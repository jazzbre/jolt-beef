// Jolt Physics Library (https://github.com/jrouwe/JoltPhysics)
// SPDX-FileCopyrightText: 2026 Jorrit Rouwe
// SPDX-License-Identifier: MIT

#include <Jolt/Jolt.h>

#include <VoxelShape.h>
#include <Jolt/Physics/Collision/Shape/BoxShape.h>
#include <Jolt/Physics/Collision/CollisionDispatch.h>
#include <Jolt/Physics/Collision/PhysicsMaterial.h>
#include <Jolt/Physics/Collision/RayCast.h>
#include <Jolt/Physics/Collision/CastResult.h>
#include <Jolt/Physics/Collision/ShapeCast.h>
#include <Jolt/Physics/Collision/TransformedShape.h>
#include <Jolt/Core/Profiler.h>
#ifdef JPH_DEBUG_RENDERER
	#include <Jolt/Renderer/DebugRenderer.h>
#endif // JPH_DEBUG_RENDERER

JPH_NAMESPACE_BEGIN

#ifdef JPH_DEBUG_RENDERER
#endif // JPH_DEBUG_RENDERER

static const Vec3 sUnitBoxTriangles[] = {
	Vec3(-1, 1, -1),	Vec3(-1, 1, 1),		Vec3(1, 1, 1),
	Vec3(-1, 1, -1),	Vec3(1, 1, 1),		Vec3(1, 1, -1),
	Vec3(-1, -1, -1),	Vec3(1, -1, -1),	Vec3(1, -1, 1),
	Vec3(-1, -1, -1),	Vec3(1, -1, 1),		Vec3(-1, -1, 1),
	Vec3(-1, 1, -1),	Vec3(-1, -1, -1),	Vec3(-1, -1, 1),
	Vec3(-1, 1, -1),	Vec3(-1, -1, 1),	Vec3(-1, 1, 1),
	Vec3(1, 1, 1),		Vec3(1, -1, 1),		Vec3(1, -1, -1),
	Vec3(1, 1, 1),		Vec3(1, -1, -1),	Vec3(1, 1, -1),
	Vec3(-1, 1, 1),		Vec3(-1, -1, 1),	Vec3(1, -1, 1),
	Vec3(-1, 1, 1),		Vec3(1, -1, 1),		Vec3(1, 1, 1),
	Vec3(-1, 1, -1),	Vec3(1, 1, -1),	Vec3(1, -1, -1),
	Vec3(-1, 1, -1),	Vec3(1, -1, -1),	Vec3(-1, -1, -1)
};

VoxelShapeSettings::VoxelShapeSettings(const VoxelShapeDataInterface *inVoxelDataInterface, uint inSizeX, uint inSizeY, uint inSizeZ, Vec3Arg inVoxelHalfExtent, float inConvexRadius) :
	mVoxelDataInterface(inVoxelDataInterface),
	mSizeX(inSizeX),
	mSizeY(inSizeY),
	mSizeZ(inSizeZ),
	mVoxelHalfExtent(inVoxelHalfExtent),
	mConvexRadius(inConvexRadius),
	mVoxelIndexBits(VoxelShape::sCalculateVoxelIndexBits(inSizeX, inSizeY, inSizeZ))
{
}

ShapeSettings::ShapeResult VoxelShapeSettings::Create() const
{
	if (mCachedResult.IsEmpty())
		Ref<Shape> shape = new VoxelShape(*this, mCachedResult);
	return mCachedResult;
}

VoxelShape::VoxelShape(const VoxelShapeDataInterface *inVoxelDataInterface, uint inSizeX, uint inSizeY, uint inSizeZ, Vec3Arg inVoxelHalfExtent, float inConvexRadius) :
	Shape(EShapeType::User1, EShapeSubType::User1),
	mVoxelDataInterface(inVoxelDataInterface),
	mSizeX(inSizeX),
	mSizeY(inSizeY),
	mSizeZ(inSizeZ),
	mVoxelHalfExtent(inVoxelHalfExtent),
	mConvexRadius(min(inConvexRadius, inVoxelHalfExtent.ReduceMin())),
	mVoxelIndexBits(sCalculateVoxelIndexBits(inSizeX, inSizeY, inSizeZ))
{
	JPH_ASSERT(inVoxelHalfExtent.ReduceMin() >= 0.0f);
	JPH_ASSERT(inConvexRadius >= 0.0f);
}

VoxelShape::VoxelShape(std::unique_ptr<const VoxelShapeDataInterface> inVoxelDataInterface, uint inSizeX, uint inSizeY, uint inSizeZ, Vec3Arg inVoxelHalfExtent, float inConvexRadius) :
	VoxelShape(inVoxelDataInterface.get(), inSizeX, inSizeY, inSizeZ, inVoxelHalfExtent, inConvexRadius)
{
	mOwnedVoxelDataInterface = std::move(inVoxelDataInterface);
}

VoxelShape::VoxelShape(const VoxelShapeSettings &inSettings, ShapeResult &outResult) :
	Shape(EShapeType::User1, EShapeSubType::User1, inSettings, outResult),
	mVoxelDataInterface(inSettings.mVoxelDataInterface),
	mSizeX(inSettings.mSizeX),
	mSizeY(inSettings.mSizeY),
	mSizeZ(inSettings.mSizeZ),
	mVoxelHalfExtent(inSettings.mVoxelHalfExtent),
	mConvexRadius(min(inSettings.mConvexRadius, inSettings.mVoxelHalfExtent.ReduceMin())),
	mVoxelIndexBits(inSettings.mVoxelIndexBits)
{
	if (inSettings.mVoxelDataInterface == nullptr)
	{
		outResult.SetError("Voxel data interface is required");
		return;
	}

	if (inSettings.mVoxelHalfExtent.ReduceMin() < 0.0f)
	{
		outResult.SetError("Invalid voxel half extent");
		return;
	}

	if (inSettings.mConvexRadius < 0.0f)
	{
		outResult.SetError("Invalid convex radius");
		return;
	}

	if (uint64(inSettings.mSizeX) * uint64(inSettings.mSizeY) * uint64(inSettings.mSizeZ) > uint64(UINT_MAX))
	{
		outResult.SetError("Too many voxels");
		return;
	}

	if (inSettings.mVoxelIndexBits < sCalculateVoxelIndexBits(inSettings.mSizeX, inSettings.mSizeY, inSettings.mSizeZ)
		|| inSettings.mVoxelIndexBits > SubShapeID::MaxBits)
	{
		outResult.SetError("Invalid voxel index bits");
		return;
	}

	outResult.Set(this);
}

class VoxelShape::VoxelShapeFilter final : public ShapeFilter
{
public:
						VoxelShapeFilter(const ShapeFilter &inFilter, const VoxelShape *inVoxelShape, const BoxShape *inBoxShape) :
		mFilter(inFilter),
		mVoxelShape(inVoxelShape),
		mBoxShape(inBoxShape)
	{
		mBodyID2 = inFilter.mBodyID2;
	}

	virtual bool		ShouldCollide(const Shape *inShape2, const SubShapeID &inSubShapeIDOfShape2) const override
	{
		return mFilter.ShouldCollide(MapShape(inShape2), inSubShapeIDOfShape2);
	}

	virtual bool		ShouldCollide(const Shape *inShape1, const SubShapeID &inSubShapeIDOfShape1, const Shape *inShape2, const SubShapeID &inSubShapeIDOfShape2) const override
	{
		return mFilter.ShouldCollide(MapShape(inShape1), inSubShapeIDOfShape1, MapShape(inShape2), inSubShapeIDOfShape2);
	}

	void				SetBoxShape(const BoxShape *inBoxShape)
	{
		mBoxShape = inBoxShape;
	}

private:
	const Shape *		MapShape(const Shape *inShape) const
	{
		return inShape == mBoxShape? mVoxelShape : inShape;
	}

	const ShapeFilter &	mFilter;
	const VoxelShape *	mVoxelShape;
	const BoxShape *	mBoxShape;
};

struct VoxelShape::VoxelRange
{
	uint				mMinX = 0;
	uint				mMinY = 0;
	uint				mMinZ = 0;
	uint				mMaxX = 0;
	uint				mMaxY = 0;
	uint				mMaxZ = 0;
};

struct VoxelShape::BrickBox
{
	uint				mMinX = 0;
	uint				mMinY = 0;
	uint				mMinZ = 0;
	uint				mMaxX = 0;
	uint				mMaxY = 0;
	uint				mMaxZ = 0;
};

static constexpr uint cBrickSize = 4;
static constexpr uint cMaxBrickBoxes = 64;

struct VoxelShape::BrickBoxContactSide
{
	const VoxelShape *	mShape = nullptr;
	Mat44				mInverseCenterOfMassTransform;
	Vec3				mInverseScale;
	SubShapeIDCreator	mSubShapeIDCreator;
	const BrickBox *	mBox = nullptr;

	SubShapeID			Resolve(Vec3Arg inContactPoint) const
	{
		Vec3 local_point = (mInverseCenterOfMassTransform * inContactPoint) * mInverseScale;
		return mShape->MakeVoxelSubShapeIDCreator(mSubShapeIDCreator, mShape->GetVoxelIndexInBrickBox(*mBox, local_point)).GetID();
	}
};

/// Box shapes stand in for several voxels at once, so each hit is given the sub shape ID of
/// the voxel in the box nearest its contact point before it reaches the real collector.
class VoxelShape::BrickBoxHitCollector final : public CollideShapeCollector
{
public:
						BrickBoxHitCollector(CollideShapeCollector &ioTarget, const BrickBoxContactSide &inSide1, const BrickBoxContactSide &inSide2) :
		CollideShapeCollector(ioTarget),
		mTarget(ioTarget),
		mSide1(inSide1),
		mSide2(inSide2)
	{
	}

	virtual void		AddHit(const CollideShapeResult &inResult) override
	{
		CollideShapeResult result = inResult;
		if (mSide1.mShape != nullptr)
			result.mSubShapeID1 = mSide1.Resolve(inResult.mContactPointOn1);
		if (mSide2.mShape != nullptr)
			result.mSubShapeID2 = mSide2.Resolve(inResult.mContactPointOn2);
		mTarget.AddHit(result);
		if (mTarget.ShouldEarlyOut())
			ForceEarlyOut();
		else if (mTarget.GetEarlyOutFraction() < GetEarlyOutFraction())
			UpdateEarlyOutFraction(mTarget.GetEarlyOutFraction());
	}

private:
	CollideShapeCollector &mTarget;
	const BrickBoxContactSide &mSide1;
	const BrickBoxContactSide &mSide2;
};

struct VoxelShape::GetTrianglesContextVoxel
{
	const VoxelShape *	mShape;
	Mat44				mLocalToWorld;
	VoxelRange			mRange;
	uint				mCurrentX = 0;
	uint				mCurrentY = 0;
	uint				mCurrentZ = 0;
	uint				mCurrentVertex = 0;
};

enum : uint
{
	cExposedFacePositiveX = 1 << 0,
	cExposedFaceNegativeX = 1 << 1,
	cExposedFacePositiveY = 1 << 2,
	cExposedFaceNegativeY = 1 << 3,
	cExposedFacePositiveZ = 1 << 4,
	cExposedFaceNegativeZ = 1 << 5
};

template <class Visitor>
class VoxelDataVisitorAdapter final : public VoxelShapeDataVisitor
{
public:
						VoxelDataVisitorAdapter(const VoxelShape *inShape, Visitor &ioVisitor) :
		mShape(inShape),
		mVisitor(ioVisitor)
	{
	}

	virtual bool		VisitVoxel(uint inX, uint inY, uint inZ, SubShapeID::Type inVoxelIndex) override
	{
		if (inX >= mShape->GetSizeX() || inY >= mShape->GetSizeY() || inZ >= mShape->GetSizeZ())
			return true;

		return mVisitor(inVoxelIndex, mShape->GetVoxelCenter(inX, inY, inZ));
	}

private:
	const VoxelShape *	mShape;
	Visitor &			mVisitor;
};

template <class Visitor>
class VoxelDataRangeVisitorAdapter final : public VoxelShapeDataRangeVisitor
{
public:
						VoxelDataRangeVisitorAdapter(Visitor &ioVisitor) :
		mVisitor(ioVisitor)
	{
	}

	virtual bool		VisitRange(uint inMinX, uint inMinY, uint inMinZ, uint inMaxX, uint inMaxY, uint inMaxZ) override
	{
		return mVisitor(VoxelShape::VoxelRange { inMinX, inMinY, inMinZ, inMaxX, inMaxY, inMaxZ });
	}

private:
	Visitor &			mVisitor;
};

template <class Visitor>
class VoxelDataBrickVisitorAdapter final : public VoxelShapeDataBrickVisitor
{
public:
						VoxelDataBrickVisitorAdapter(Visitor &ioVisitor) :
		mVisitor(ioVisitor)
	{
	}

	virtual bool		VisitBrick(uint inBrickX, uint inBrickY, uint inBrickZ, uint64 inSurfaceMask, uint64 inSolidMask) override
	{
		return mVisitor(inBrickX, inBrickY, inBrickZ, inSurfaceMask, inSolidMask);
	}

private:
	Visitor &			mVisitor;
};

static uint CountTrailingZeros64(uint64 inValue)
{
	uint32 low = uint32(inValue);
	return low != 0? CountTrailingZeros(low) : 32 + CountTrailingZeros(uint32(inValue >> 32));
}

uint VoxelShape::sDecomposeBrick(uint inBrickX, uint inBrickY, uint inBrickZ, uint64 inSurfaceMask, uint64 inSolidMask, BrickBox *outBoxes)
{
	auto block_mask = [](const uint *inMin, const uint *inMax) {
		uint64 mask = 0;
		uint64 row = uint64((1u << inMax[0]) - (1u << inMin[0]));
		for (uint z = inMin[2]; z < inMax[2]; ++z)
			for (uint y = inMin[1]; y < inMax[1]; ++y)
				mask |= row << (y * cBrickSize + z * cBrickSize * cBrickSize);
		return mask;
	};

	uint box_count = 0;
	uint64 remaining = inSurfaceMask & inSolidMask;
	uint64 unclaimed = inSolidMask;
	while (remaining != 0)
	{
		uint first_bit = CountTrailingZeros64(remaining);
		uint min[3] = { first_bit % cBrickSize, (first_bit / cBrickSize) % cBrickSize, first_bit / (cBrickSize * cBrickSize) };
		uint max[3] = { min[0] + 1, min[1] + 1, min[2] + 1 };

		// Growing through hidden solid voxels as well keeps the boxes thick, so a deep
		// penetration still resolves out of the hull rather than through a thin slab.
		// Boxes must not overlap: each contact is reported against the box voxel nearest
		// to it, and two boxes naming the same voxel give Jolt a duplicate manifold key.
		for (uint axis = 0; axis < 3; ++axis)
		{
			for (;;)
			{
				uint slice_min[3] = { min[0], min[1], min[2] };
				uint slice_max[3] = { max[0], max[1], max[2] };
				if (max[axis] < cBrickSize)
				{
					slice_min[axis] = max[axis];
					slice_max[axis] = max[axis] + 1;
					uint64 slice = block_mask(slice_min, slice_max);
					if ((unclaimed & slice) == slice)
					{
						++max[axis];
						continue;
					}
				}
				break;
			}
			for (;;)
			{
				uint slice_min[3] = { min[0], min[1], min[2] };
				uint slice_max[3] = { max[0], max[1], max[2] };
				if (min[axis] > 0)
				{
					slice_min[axis] = min[axis] - 1;
					slice_max[axis] = min[axis];
					uint64 slice = block_mask(slice_min, slice_max);
					if ((unclaimed & slice) == slice)
					{
						--min[axis];
						continue;
					}
				}
				break;
			}
		}

		uint origin_x = inBrickX * cBrickSize, origin_y = inBrickY * cBrickSize, origin_z = inBrickZ * cBrickSize;
		outBoxes[box_count++] = BrickBox { origin_x + min[0], origin_y + min[1], origin_z + min[2], origin_x + max[0], origin_y + max[1], origin_z + max[2] };
		uint64 claimed = block_mask(min, max);
		remaining &= ~claimed;
		unclaimed &= ~claimed;
	}
	return box_count;
}

uint VoxelShape::sCalculateVoxelIndexBits(uint inSizeX, uint inSizeY, uint inSizeZ)
{
	uint64 num_voxels = uint64(inSizeX) * uint64(inSizeY) * uint64(inSizeZ);
	JPH_ASSERT(num_voxels <= uint64(UINT_MAX));
	return num_voxels <= 1? 0 : 32 - CountLeadingZeros(uint32(num_voxels - 1));
}

template <class Visitor>
void VoxelShape::WalkVoxels(Visitor &ioVisitor) const
{
	WalkVoxels(VoxelRange { 0, 0, 0, mSizeX, mSizeY, mSizeZ }, ioVisitor);
}

template <class Visitor>
void VoxelShape::WalkVoxels(const VoxelRange &inRange, Visitor &ioVisitor, uint inRequiredExposedFaces, const VoxelShapeDataRangeFilter *inRangeFilter) const
{
	JPH_ASSERT(mVoxelDataInterface != nullptr);
	if (mVoxelDataInterface == nullptr)
		return;

	VoxelDataVisitorAdapter<Visitor> visitor(this, ioVisitor);
	mVoxelDataInterface->VisitActiveVoxels(inRange.mMinX, inRange.mMinY, inRange.mMinZ, inRange.mMaxX, inRange.mMaxY, inRange.mMaxZ, inRequiredExposedFaces, visitor, inRangeFilter);
}

template <class Visitor>
void VoxelShape::WalkVoxelRanges(const VoxelRange &inRange, Visitor &ioVisitor, uint inRequiredExposedFaces, const VoxelShapeDataRangeFilter *inRangeFilter) const
{
	JPH_ASSERT(mVoxelDataInterface != nullptr);
	if (mVoxelDataInterface == nullptr)
		return;

	VoxelDataRangeVisitorAdapter<Visitor> visitor(ioVisitor);
	mVoxelDataInterface->VisitActiveVoxelRanges(inRange.mMinX, inRange.mMinY, inRange.mMinZ, inRange.mMaxX, inRange.mMaxY, inRange.mMaxZ, inRequiredExposedFaces, visitor, inRangeFilter);
}

template <class Visitor>
void VoxelShape::WalkSurfaceBricks(const VoxelRange &inRange, Visitor &ioVisitor, const VoxelShapeDataRangeFilter *inRangeFilter) const
{
	JPH_ASSERT(mVoxelDataInterface != nullptr);
	if (mVoxelDataInterface == nullptr || inRange.mMinX >= inRange.mMaxX || inRange.mMinY >= inRange.mMaxY || inRange.mMinZ >= inRange.mMaxZ)
		return;

	VoxelDataBrickVisitorAdapter<Visitor> visitor(ioVisitor);
	mVoxelDataInterface->VisitSurfaceBricks(inRange.mMinX, inRange.mMinY, inRange.mMinZ, inRange.mMaxX, inRange.mMaxY, inRange.mMaxZ, visitor, inRangeFilter);
}

template <class Visitor>
void VoxelShape::WalkRayVoxels(const RayCast &inRay, float inMaxFraction, Visitor &ioVisitor) const
{
	if (mSizeX == 0 || mSizeY == 0 || mSizeZ == 0 || inMaxFraction < 0.0f)
		return;

	JPH_ASSERT(mVoxelDataInterface != nullptr);
	if (mVoxelDataInterface == nullptr)
		return;

	VoxelDataVisitorAdapter<Visitor> visitor(this, ioVisitor);
	mVoxelDataInterface->VisitRayVoxels(inRay, inMaxFraction, mVoxelHalfExtent, mSizeX, mSizeY, mSizeZ, visitor);
}

template <class Visitor>
void VoxelShape::WalkBoxCastVoxels(const AABox &inStartBounds, Vec3Arg inDirection, float inMaxFraction, Visitor &ioVisitor) const
{
	if (mSizeX == 0 || mSizeY == 0 || mSizeZ == 0 || !inStartBounds.IsValid() || inMaxFraction < 0.0f)
		return;

	JPH_ASSERT(mVoxelDataInterface != nullptr);
	if (mVoxelDataInterface == nullptr)
		return;

	VoxelDataVisitorAdapter<Visitor> visitor(this, ioVisitor);
	mVoxelDataInterface->VisitBoxCastVoxels(inStartBounds, inDirection, inMaxFraction, mVoxelHalfExtent, mSizeX, mSizeY, mSizeZ, visitor);
}

VoxelShape::VoxelRange VoxelShape::GetVoxelRangeOverlappingLocalBounds(const AABox &inLocalBounds, bool inIncludeTouching) const
{
	VoxelRange range;
	if (mSizeX == 0 || mSizeY == 0 || mSizeZ == 0)
		return range;

	auto calculate_range = [inIncludeTouching](float inMin, float inMax, float inGridMin, float inVoxelSize, uint inSize, uint &outMin, uint &outMax) {
		if (inVoxelSize <= 0.0f)
		{
			outMin = 0;
			outMax = inSize;
			return;
		}

		// The lower face is half open by default: a voxel meeting the box in a single plane
		// is dropped here but kept at the upper face. That asymmetry stays invisible while
		// every query maps boxes the same way round, and shows itself the moment one is
		// inverted, so callers that map a box back the other way ask for the closed form.
		float first = (inMin - inGridMin) / inVoxelSize;
		int min_index = inIncludeTouching? int(ceil(first)) - 1 : int(floor(first));
		outMin = uint(Clamp(min_index, 0, int(inSize)));
		outMax = uint(Clamp(int(floor((inMax - inGridMin) / inVoxelSize)) + 1, 0, int(inSize)));
		if (outMax < outMin)
			outMax = outMin;
	};

	calculate_range(inLocalBounds.mMin.GetX(), inLocalBounds.mMax.GetX(), -float(mSizeX) * mVoxelHalfExtent.GetX(), 2.0f * mVoxelHalfExtent.GetX(), mSizeX, range.mMinX, range.mMaxX);
	calculate_range(inLocalBounds.mMin.GetY(), inLocalBounds.mMax.GetY(), -float(mSizeY) * mVoxelHalfExtent.GetY(), 2.0f * mVoxelHalfExtent.GetY(), mSizeY, range.mMinY, range.mMaxY);
	calculate_range(inLocalBounds.mMin.GetZ(), inLocalBounds.mMax.GetZ(), -float(mSizeZ) * mVoxelHalfExtent.GetZ(), 2.0f * mVoxelHalfExtent.GetZ(), mSizeZ, range.mMinZ, range.mMaxZ);
	return range;
}

AABox VoxelShape::GetVoxelRangeLocalBounds(uint inMinX, uint inMinY, uint inMinZ, uint inMaxX, uint inMaxY, uint inMaxZ) const
{
	Vec3 min(
		(float(2 * inMinX) - float(mSizeX)) * mVoxelHalfExtent.GetX(),
		(float(2 * inMinY) - float(mSizeY)) * mVoxelHalfExtent.GetY(),
		(float(2 * inMinZ) - float(mSizeZ)) * mVoxelHalfExtent.GetZ());
	Vec3 max(
		(float(2 * inMaxX) - float(mSizeX)) * mVoxelHalfExtent.GetX(),
		(float(2 * inMaxY) - float(mSizeY)) * mVoxelHalfExtent.GetY(),
		(float(2 * inMaxZ) - float(mSizeZ)) * mVoxelHalfExtent.GetZ());
	return AABox(min, max);
}

bool VoxelShape::HasActiveVoxels(const VoxelRange &inRange, uint inRequiredExposedFaces, const VoxelShapeDataRangeFilter *inRangeFilter) const
{
	JPH_ASSERT(mVoxelDataInterface != nullptr);
	if (mVoxelDataInterface == nullptr)
		return false;

	return mVoxelDataInterface->HasActiveVoxels(inRange.mMinX, inRange.mMinY, inRange.mMinZ, inRange.mMaxX, inRange.mMaxY, inRange.mMaxZ, inRequiredExposedFaces, inRangeFilter);
}

/// Faces pointing from this grid's centre towards inLocalBounds.
///
/// Nothing calls this, and it must not be wired into the collide paths as it stands. It
/// measures the direction from the grid centre, which says nothing about a voxel sitting
/// inside a concavity, and its 0.5 * largest-component threshold hard-drops three of the
/// six faces. Measured against an exact oriented box test, culling on this loses 1605 of
/// 4500 real voxel contacts on plain convex hulls - a voxel on the silhouette has its
/// exposed face nearly perpendicular to the centre-to-centre direction - and inside a
/// docking bay it loses nearly all of them, including every contact holding a craft off
/// the bay floor.
///
/// A sound version would take the direction per range rather than per shape, recompute it
/// as the walk descends, cull only on axes where the other shape's region is disjoint from
/// the range along that axis, and keep both faces on any axis where the two overlap.
uint VoxelShape::GetRequiredExposedFacesForBounds(const AABox &inLocalBounds) const
{
	if (!inLocalBounds.IsValid())
		return 0;

	Vec3 direction = inLocalBounds.GetCenter();
	Vec3 abs_direction = direction.Abs();
	float max_component = abs_direction.ReduceMax();
	if (max_component <= 1.0e-5f)
		return 0;

	float threshold = 0.5f * max_component;
	uint mask = 0;
	if (abs_direction.GetX() >= threshold)
		mask |= direction.GetX() >= 0.0f? cExposedFacePositiveX : cExposedFaceNegativeX;
	if (abs_direction.GetY() >= threshold)
		mask |= direction.GetY() >= 0.0f? cExposedFacePositiveY : cExposedFaceNegativeY;
	if (abs_direction.GetZ() >= threshold)
		mask |= direction.GetZ() >= 0.0f? cExposedFacePositiveZ : cExposedFaceNegativeZ;

	return mask;
}

class WorldBoundsVoxelRangeFilter final : public VoxelShapeDataRangeFilter
{
public:
	WorldBoundsVoxelRangeFilter(const VoxelShape *inShape, Vec3Arg inScale, Mat44Arg inCenterOfMassTransform, const AABox &inWorldBounds) :
		mShape(inShape),
		mScale(inScale),
		mCenterOfMassTransform(inCenterOfMassTransform),
		mWorldBounds(inWorldBounds)
	{
	}

	virtual bool ShouldVisitRange(uint inMinX, uint inMinY, uint inMinZ, uint inMaxX, uint inMaxY, uint inMaxZ) const override
	{
		AABox range_world_bounds = mShape->GetVoxelRangeLocalBounds(inMinX, inMinY, inMinZ, inMaxX, inMaxY, inMaxZ).Scaled(mScale).Transformed(mCenterOfMassTransform);
		return range_world_bounds.Overlaps(mWorldBounds);
	}

private:
	const VoxelShape *	mShape;
	Vec3				mScale;
	Mat44				mCenterOfMassTransform;
	AABox				mWorldBounds;
};

bool VoxelShape::IsVoxelActive(SubShapeID::Type inVoxelIndex) const
{
	if (mSizeX == 0 || mSizeY == 0 || mSizeZ == 0)
		return false;

	uint xy_size = mSizeX * mSizeY;
	uint z = inVoxelIndex / xy_size;
	uint remainder = inVoxelIndex - z * xy_size;
	uint y = remainder / mSizeX;
	uint x = remainder - y * mSizeX;
	return IsVoxelActive(x, y, z, inVoxelIndex);
}

bool VoxelShape::IsVoxelActive(uint inX, uint inY, uint inZ, SubShapeID::Type inVoxelIndex) const
{
	JPH_ASSERT(mVoxelDataInterface != nullptr);
	return mVoxelDataInterface != nullptr && mVoxelDataInterface->IsVoxelActive(inX, inY, inZ, inVoxelIndex);
}

Vec3 VoxelShape::GetVoxelCenter(SubShapeID::Type inVoxelIndex) const
{
	uint xy_size = mSizeX * mSizeY;
	uint z = inVoxelIndex / xy_size;
	uint remainder = inVoxelIndex - z * xy_size;
	uint y = remainder / mSizeX;
	uint x = remainder - y * mSizeX;
	return GetVoxelCenter(x, y, z);
}

Vec3 VoxelShape::GetVoxelCenter(uint inX, uint inY, uint inZ) const
{
	return Vec3((float(2 * inX + 1) - float(mSizeX)) * mVoxelHalfExtent.GetX(), (float(2 * inY + 1) - float(mSizeY)) * mVoxelHalfExtent.GetY(), (float(2 * inZ + 1) - float(mSizeZ)) * mVoxelHalfExtent.GetZ());
}

SubShapeIDCreator VoxelShape::MakeVoxelSubShapeIDCreator(const SubShapeIDCreator &inSubShapeIDCreator, SubShapeID::Type inVoxelIndex) const
{
	JPH_ASSERT(inSubShapeIDCreator.GetNumBitsWritten() + mVoxelIndexBits <= SubShapeID::MaxBits);
	return inSubShapeIDCreator.PushID(inVoxelIndex, mVoxelIndexBits);
}

BoxShape VoxelShape::CreateBoxShape() const
{
	return BoxShape(mVoxelHalfExtent, mConvexRadius);
}

AABox VoxelShape::GetBrickLocalBounds(uint inBrickX, uint inBrickY, uint inBrickZ) const
{
	return GetVoxelRangeLocalBounds(inBrickX * cBrickSize, inBrickY * cBrickSize, inBrickZ * cBrickSize,
		min((inBrickX + 1) * cBrickSize, mSizeX), min((inBrickY + 1) * cBrickSize, mSizeY), min((inBrickZ + 1) * cBrickSize, mSizeZ));
}

AABox VoxelShape::GetBrickBoxLocalBounds(const BrickBox &inBox) const
{
	return GetVoxelRangeLocalBounds(inBox.mMinX, inBox.mMinY, inBox.mMinZ, inBox.mMaxX, inBox.mMaxY, inBox.mMaxZ);
}

BoxShape VoxelShape::CreateBrickBoxShape(const AABox &inLocalBounds) const
{
	Vec3 half_extent = inLocalBounds.GetExtent();
	return BoxShape(half_extent, min(mConvexRadius, half_extent.ReduceMin()));
}

SubShapeID::Type VoxelShape::GetVoxelIndexInBrickBox(const BrickBox &inBox, Vec3Arg inLocalPoint) const
{
	auto voxel_coordinate = [](float inPosition, float inHalfExtent, uint inSize, uint inMin, uint inMax) {
		int coordinate = int(floor((inPosition + float(inSize) * inHalfExtent) / (2.0f * inHalfExtent)));
		return uint(Clamp(coordinate, int(inMin), int(inMax) - 1));
	};
	uint x = voxel_coordinate(inLocalPoint.GetX(), mVoxelHalfExtent.GetX(), mSizeX, inBox.mMinX, inBox.mMaxX);
	uint y = voxel_coordinate(inLocalPoint.GetY(), mVoxelHalfExtent.GetY(), mSizeY, inBox.mMinY, inBox.mMaxY);
	uint z = voxel_coordinate(inLocalPoint.GetZ(), mVoxelHalfExtent.GetZ(), mSizeZ, inBox.mMinZ, inBox.mMaxZ);
	return x + y * mSizeX + z * mSizeX * mSizeY;
}

SubShapeID::Type VoxelShape::GetFirstVoxelIndex(const BrickBox &inBox) const
{
	return inBox.mMinX + inBox.mMinY * mSizeX + inBox.mMinZ * mSizeX * mSizeY;
}

AABox VoxelShape::GetLocalBounds() const
{
	// Read without a lock from every collide job, so RefreshActiveBounds is an explicit
	// call rather than something computed lazily in here.
	if (mActiveBoundsValid)
		return mActiveBounds;

	return AABox(-Vec3(float(mSizeX) * mVoxelHalfExtent.GetX(), float(mSizeY) * mVoxelHalfExtent.GetY(), float(mSizeZ) * mVoxelHalfExtent.GetZ()),
		Vec3(float(mSizeX) * mVoxelHalfExtent.GetX(), float(mSizeY) * mVoxelHalfExtent.GetY(), float(mSizeZ) * mVoxelHalfExtent.GetZ()));
}

void VoxelShape::RefreshActiveBounds()
{
	mActiveBoundsValid = false;
	if (mSizeX == 0 || mSizeY == 0 || mSizeZ == 0 || mVoxelDataInterface == nullptr)
		return;

	uint min_x = mSizeX, min_y = mSizeY, min_z = mSizeZ;
	uint max_x = 0, max_y = 0, max_z = 0;
	bool any_active = false;

	// Runs rather than voxels: a solid rock reports a handful of spans per row instead of
	// every cell, so this is closer to the surface area than to the grid volume.
	auto run_visitor = [&min_x, &min_y, &min_z, &max_x, &max_y, &max_z, &any_active](const VoxelRange &inRun) {
		any_active = true;
		min_x = min(min_x, inRun.mMinX);
		min_y = min(min_y, inRun.mMinY);
		min_z = min(min_z, inRun.mMinZ);
		max_x = max(max_x, inRun.mMaxX);
		max_y = max(max_y, inRun.mMaxY);
		max_z = max(max_z, inRun.mMaxZ);
		return true;
	};

	VoxelRange full_range;
	full_range.mMaxX = mSizeX;
	full_range.mMaxY = mSizeY;
	full_range.mMaxZ = mSizeZ;
	WalkVoxelRanges(full_range, run_visitor);

	// A grid mined away to nothing keeps the whole-grid bounds rather than an empty box,
	// which nothing downstream expects to be handed.
	if (!any_active)
		return;

	mActiveBounds = GetVoxelRangeLocalBounds(min_x, min_y, min_z, max_x, max_y, max_z);
	mActiveBoundsValid = true;
}

MassProperties VoxelShape::GetMassProperties() const
{
	if (mMassPropertiesValid)
		return mMassProperties;

	BoxShape box = CreateBoxShape();
	MassProperties total;
	auto accumulateRangeMass = [this, &box, &total](const VoxelRange &inRange) {
		AABox rangeBounds = GetVoxelRangeLocalBounds(inRange.mMinX, inRange.mMinY, inRange.mMinZ,
			inRange.mMaxX, inRange.mMaxY, inRange.mMaxZ);
		MassProperties rangeMass;
		rangeMass.SetMassAndInertiaOfSolidBox(rangeBounds.GetSize(), box.GetDensity());
		rangeMass.Translate(rangeBounds.GetCenter());
		total.mMass += rangeMass.mMass;
		total.mInertia += rangeMass.mInertia;
		return true;
	};
	WalkVoxelRanges(VoxelRange { 0, 0, 0, mSizeX, mSizeY, mSizeZ }, accumulateRangeMass);
	total.mInertia.SetColumn4(3, Vec4(0, 0, 0, 1));

	return total;
}

const Shape *VoxelShape::GetLeafShape(const SubShapeID &inSubShapeID, SubShapeID &outRemainder) const
{
	GetVoxelIndex(inSubShapeID, outRemainder);
	return this;
}

const PhysicsMaterial *VoxelShape::GetMaterial(const SubShapeID &inSubShapeID) const
{
	SubShapeID remainder;
	GetVoxelIndex(inSubShapeID, remainder);
	JPH_ASSERT(remainder.IsEmpty(), "Invalid subshape ID");
	return PhysicsMaterial::sDefault;
}

uint64 VoxelShape::GetSubShapeUserData(const SubShapeID &inSubShapeID) const
{
	SubShapeID remainder;
	return GetVoxelIndex(inSubShapeID, remainder);
}

Vec3 VoxelShape::GetSurfaceNormal(const SubShapeID &inSubShapeID, Vec3Arg inLocalSurfacePosition) const
{
	SubShapeID remainder;
	SubShapeID::Type voxel_index = GetVoxelIndex(inSubShapeID, remainder);
	JPH_ASSERT(remainder.IsEmpty(), "Invalid subshape ID");

	BoxShape box = CreateBoxShape();
	return box.GetSurfaceNormal(remainder, inLocalSurfacePosition - GetVoxelCenter(voxel_index));
}

void VoxelShape::GetSupportingFace(const SubShapeID &inSubShapeID, Vec3Arg inDirection, Vec3Arg inScale, Mat44Arg inCenterOfMassTransform, SupportingFace &outVertices) const
{
	SubShapeID remainder;
	SubShapeID::Type voxel_index = GetVoxelIndex(inSubShapeID, remainder);
	JPH_ASSERT(remainder.IsEmpty(), "Invalid subshape ID");

	BoxShape box = CreateBoxShape();
	box.GetSupportingFace(remainder, inDirection, inScale, inCenterOfMassTransform.PreTranslated(inScale * GetVoxelCenter(voxel_index)), outVertices);
}

void VoxelShape::GetSubmergedVolume(Mat44Arg inCenterOfMassTransform, Vec3Arg inScale, const Plane &inSurface, float &outTotalVolume, float &outSubmergedVolume, Vec3 &outCenterOfBuoyancy JPH_IF_DEBUG_RENDERER(, RVec3Arg inBaseOffset)) const
{
	BoxShape box = CreateBoxShape();

	outTotalVolume = 0.0f;
	outSubmergedVolume = 0.0f;
	outCenterOfBuoyancy = Vec3::sZero();

	auto visitor = [this, &box, inCenterOfMassTransform, inScale, &inSurface, &outTotalVolume, &outSubmergedVolume, &outCenterOfBuoyancy JPH_IF_DEBUG_RENDERER(, inBaseOffset)](SubShapeID::Type, Vec3Arg inVoxelCenter) {
		float total_volume, submerged_volume;
		Vec3 center_of_buoyancy;
		box.GetSubmergedVolume(inCenterOfMassTransform.PreTranslated(inScale * inVoxelCenter), inScale, inSurface, total_volume, submerged_volume, center_of_buoyancy JPH_IF_DEBUG_RENDERER(, inBaseOffset));

		outTotalVolume += total_volume;
		outSubmergedVolume += submerged_volume;
		outCenterOfBuoyancy += submerged_volume * center_of_buoyancy;
		return true;
	};
	WalkVoxels(visitor);

	if (outSubmergedVolume > 0.0f)
		outCenterOfBuoyancy /= outSubmergedVolume;
}

#ifdef JPH_DEBUG_RENDERER
void VoxelShape::Draw(DebugRenderer *inRenderer, RMat44Arg inCenterOfMassTransform, Vec3Arg inScale, ColorArg inColor, bool inUseMaterialColors, bool inDrawWireframe) const
{
	BoxShape box = CreateBoxShape();
	auto visitor = [this, &box, inRenderer, inCenterOfMassTransform, inScale, inColor, inUseMaterialColors, inDrawWireframe](SubShapeID::Type, Vec3Arg inVoxelCenter) {
		box.Draw(inRenderer, inCenterOfMassTransform.PreTranslated(inScale * inVoxelCenter), inScale, inColor, inUseMaterialColors, inDrawWireframe);
		return true;
	};
	WalkVoxels(visitor);
}
#endif // JPH_DEBUG_RENDERER

bool VoxelShape::CastRay(const RayCast &inRay, const SubShapeIDCreator &inSubShapeIDCreator, RayCastResult &ioHit) const
{
	JPH_ASSERT(mVoxelDataInterface != nullptr);
	if (mVoxelDataInterface == nullptr)
		return false;

	SubShapeID::Type voxel_index = 0;
	float fraction = ioHit.mFraction;
	if (mVoxelDataInterface->CastRayClosest(inRay, ioHit.mFraction, mVoxelHalfExtent, mSizeX, mSizeY, mSizeZ, voxel_index, fraction)
		&& fraction < ioHit.mFraction)
	{
		ioHit.mFraction = fraction;
		ioHit.mSubShapeID2 = MakeVoxelSubShapeIDCreator(inSubShapeIDCreator, voxel_index).GetID();
		return true;
	}

	return false;
}

void VoxelShape::CastRay(const RayCast &inRay, const RayCastSettings &inRayCastSettings, const SubShapeIDCreator &inSubShapeIDCreator, CastRayCollector &ioCollector, const ShapeFilter &inShapeFilter) const
{
	BoxShape box = CreateBoxShape();
	VoxelShapeFilter shape_filter(inShapeFilter, this, &box);
	auto visitor = [this, &box, &inRay, &inRayCastSettings, &inSubShapeIDCreator, &ioCollector, &shape_filter](SubShapeID::Type inVoxelIndex, Vec3Arg inVoxelCenter) {
		box.CastRay(inRay.Translated(-inVoxelCenter), inRayCastSettings, MakeVoxelSubShapeIDCreator(inSubShapeIDCreator, inVoxelIndex), ioCollector, shape_filter);
		return !ioCollector.ShouldEarlyOut();
	};
	WalkRayVoxels(inRay, ioCollector.GetEarlyOutFraction(), visitor);
}

void VoxelShape::CollidePoint(Vec3Arg inPoint, const SubShapeIDCreator &inSubShapeIDCreator, CollidePointCollector &ioCollector, const ShapeFilter &inShapeFilter) const
{
	BoxShape box = CreateBoxShape();
	VoxelShapeFilter shape_filter(inShapeFilter, this, &box);
	VoxelRange range = GetVoxelRangeOverlappingLocalBounds(AABox(inPoint, inPoint));
	auto visitor = [this, &box, inPoint, &inSubShapeIDCreator, &ioCollector, &shape_filter](SubShapeID::Type inVoxelIndex, Vec3Arg inVoxelCenter) {
		box.CollidePoint(inPoint - inVoxelCenter, MakeVoxelSubShapeIDCreator(inSubShapeIDCreator, inVoxelIndex), ioCollector, shape_filter);
		return !ioCollector.ShouldEarlyOut();
	};
	WalkVoxels(range, visitor);
}

void VoxelShape::CollideSoftBodyVertices(Mat44Arg inCenterOfMassTransform, Vec3Arg inScale, const CollideSoftBodyVertexIterator &inVertices, uint inNumVertices, int inCollidingShapeIndex) const
{
	BoxShape box = CreateBoxShape();
	auto visitor = [this, &box, inCenterOfMassTransform, inScale, &inVertices, inNumVertices, inCollidingShapeIndex](SubShapeID::Type, Vec3Arg inVoxelCenter) {
		box.CollideSoftBodyVertices(inCenterOfMassTransform.PreTranslated(inScale * inVoxelCenter), inScale, inVertices, inNumVertices, inCollidingShapeIndex);
		return true;
	};
	WalkVoxels(visitor);
}

void VoxelShape::CollectTransformedShapes(const AABox &inBox, Vec3Arg inPositionCOM, QuatArg inRotation, Vec3Arg inScale, const SubShapeIDCreator &inSubShapeIDCreator, TransformedShapeCollector &ioCollector, const ShapeFilter &inShapeFilter) const
{
	BoxShape box = CreateBoxShape();
	Mat44 transform = Mat44::sRotationTranslation(inRotation, inPositionCOM);
	AABox local_box = inBox.Transformed(transform.InversedRotationTranslation()).Scaled(Vec3::sOne() / inScale);
	VoxelRange range = GetVoxelRangeOverlappingLocalBounds(local_box);
	auto visitor = [this, &box, &inBox, inRotation, inScale, transform, &inSubShapeIDCreator, &ioCollector, &inShapeFilter](SubShapeID::Type inVoxelIndex, Vec3Arg inVoxelCenter) {
		SubShapeIDCreator voxel_sub_shape_id = MakeVoxelSubShapeIDCreator(inSubShapeIDCreator, inVoxelIndex);
		if (inShapeFilter.ShouldCollide(this, voxel_sub_shape_id.GetID()))
		{
			AABox voxel_bounds = box.GetWorldSpaceBounds(transform.PreTranslated(inScale * inVoxelCenter), inScale);
			if (voxel_bounds.Overlaps(inBox))
			{
				TransformedShape ts(RVec3(transform.GetTranslation() + transform.Multiply3x3(inScale * inVoxelCenter)), inRotation, this, TransformedShape::sGetBodyID(ioCollector.GetContext()), voxel_sub_shape_id);
				ts.SetShapeScale(inScale);
				ioCollector.AddHit(ts);
			}
		}
		return !ioCollector.ShouldEarlyOut();
	};
	WalkVoxels(range, visitor);
}

void VoxelShape::GetTrianglesStart(GetTrianglesContext &ioContext, const AABox &inBox, Vec3Arg inPositionCOM, QuatArg inRotation, Vec3Arg inScale) const
{
	static_assert(sizeof(GetTrianglesContextVoxel) <= sizeof(GetTrianglesContext), "GetTrianglesContext too small");
	JPH_ASSERT(IsAligned(&ioContext, alignof(GetTrianglesContextVoxel)));

	Mat44 transform = Mat44::sRotationTranslation(inRotation, inPositionCOM);
	AABox local_box = inBox.Transformed(transform.InversedRotationTranslation()).Scaled(Vec3::sOne() / inScale);
	VoxelRange range = GetVoxelRangeOverlappingLocalBounds(local_box);
	new (&ioContext) GetTrianglesContextVoxel { this, transform * Mat44::sScale(inScale), range, range.mMinX, range.mMinY, range.mMinZ, 0 };
}

int VoxelShape::GetTrianglesNext(GetTrianglesContext &ioContext, int inMaxTrianglesRequested, Float3 *outTriangleVertices, const PhysicsMaterial **outMaterials) const
{
	GetTrianglesContextVoxel &context = (GetTrianglesContextVoxel &)ioContext;
	int triangles_written = 0;

	while (context.mCurrentZ < context.mRange.mMaxZ && triangles_written < inMaxTrianglesRequested)
	{
		SubShapeID::Type voxel_index = context.mCurrentX + context.mCurrentY * mSizeX + context.mCurrentZ * mSizeX * mSizeY;
		if (!IsVoxelActive(voxel_index))
		{
			if (++context.mCurrentX == context.mRange.mMaxX)
			{
				context.mCurrentX = context.mRange.mMinX;
				if (++context.mCurrentY == context.mRange.mMaxY)
				{
					context.mCurrentY = context.mRange.mMinY;
					++context.mCurrentZ;
				}
			}
			context.mCurrentVertex = 0;
			continue;
		}

		Vec3 voxel_center = GetVoxelCenter(voxel_index);
		while (context.mCurrentVertex < std::size(sUnitBoxTriangles) && triangles_written < inMaxTrianglesRequested)
		{
			for (uint v = 0; v < 3; ++v)
			{
				Vec3 local_vertex = voxel_center + mVoxelHalfExtent * sUnitBoxTriangles[context.mCurrentVertex++];
				(context.mLocalToWorld * local_vertex).StoreFloat3(outTriangleVertices++);
			}

			if (outMaterials != nullptr)
				outMaterials[triangles_written] = PhysicsMaterial::sDefault;

			++triangles_written;
		}

		if (context.mCurrentVertex == std::size(sUnitBoxTriangles))
		{
			if (++context.mCurrentX == context.mRange.mMaxX)
			{
				context.mCurrentX = context.mRange.mMinX;
				if (++context.mCurrentY == context.mRange.mMaxY)
				{
					context.mCurrentY = context.mRange.mMinY;
					++context.mCurrentZ;
				}
			}
			context.mCurrentVertex = 0;
		}
	}

	return triangles_written;
}

Shape::Stats VoxelShape::GetStats() const
{
	uint num_active = 0;
	auto visitor = [&num_active](SubShapeID::Type, Vec3Arg) {
		++num_active;
		return true;
	};
	WalkVoxels(visitor);
	return Stats(sizeof(*this), 12 * num_active);
}

float VoxelShape::GetVolume() const
{
	uint num_active = 0;
	auto visitor = [&num_active](SubShapeID::Type, Vec3Arg) {
		++num_active;
		return true;
	};
	WalkVoxels(visitor);
	return num_active * 8.0f * mVoxelHalfExtent.GetX() * mVoxelHalfExtent.GetY() * mVoxelHalfExtent.GetZ();
}

void VoxelShape::sCollideVoxelVsShape(const Shape *inShape1, const Shape *inShape2, Vec3Arg inScale1, Vec3Arg inScale2, Mat44Arg inCenterOfMassTransform1, Mat44Arg inCenterOfMassTransform2, const SubShapeIDCreator &inSubShapeIDCreator1, const SubShapeIDCreator &inSubShapeIDCreator2, const CollideShapeSettings &inCollideShapeSettings, CollideShapeCollector &ioCollector, const ShapeFilter &inShapeFilter)
{
	JPH_PROFILE_FUNCTION();

	JPH_ASSERT(inShape1->GetSubType() == EShapeSubType::User1);
	const VoxelShape *shape1 = static_cast<const VoxelShape *>(inShape1);

	VoxelShapeFilter shape_filter(inShapeFilter, shape1, nullptr);
	AABox shape2_bounds = inShape2->GetLocalBounds().Scaled(inScale2).Transformed(inCenterOfMassTransform1.InversedRotationTranslation() * inCenterOfMassTransform2).Scaled(Vec3::sOne() / inScale1);
	AABox shape2_world_bounds = inShape2->GetWorldSpaceBounds(inCenterOfMassTransform2, inScale2);
	VoxelRange range = shape1->GetVoxelRangeOverlappingLocalBounds(shape2_bounds);
	WorldBoundsVoxelRangeFilter range_filter(shape1, inScale1, inCenterOfMassTransform1, shape2_world_bounds);
	BrickBoxContactSide voxel_side { shape1, inCenterOfMassTransform1.InversedRotationTranslation(), Vec3::sOne() / inScale1, inSubShapeIDCreator1 };
	BrickBoxContactSide other_side;
	BrickBox boxes[cMaxBrickBoxes];
	auto brick_visitor = [&](uint inBrickX, uint inBrickY, uint inBrickZ, uint64 inSurfaceMask, uint64 inSolidMask) {
		if (!shape1->GetBrickLocalBounds(inBrickX, inBrickY, inBrickZ).Scaled(inScale1).Transformed(inCenterOfMassTransform1).Overlaps(shape2_world_bounds))
			return true;

		uint box_count = sDecomposeBrick(inBrickX, inBrickY, inBrickZ, inSurfaceMask, inSolidMask, boxes);
		for (uint box_index = 0; box_index < box_count; ++box_index)
		{
			const BrickBox &brick_box = boxes[box_index];
			AABox local_bounds = shape1->GetBrickBoxLocalBounds(brick_box);
			if (!local_bounds.Scaled(inScale1).Transformed(inCenterOfMassTransform1).Overlaps(shape2_world_bounds))
				continue;

			BoxShape box = shape1->CreateBrickBoxShape(local_bounds);
			shape_filter.SetBoxShape(&box);
			voxel_side.mBox = &brick_box;
			BrickBoxHitCollector collector(ioCollector, voxel_side, other_side);
			Mat44 box_transform = inCenterOfMassTransform1.PreTranslated(inScale1 * local_bounds.GetCenter());
			CollisionDispatch::sCollideShapeVsShape(&box, inShape2, inScale1, inScale2, box_transform, inCenterOfMassTransform2, shape1->MakeVoxelSubShapeIDCreator(inSubShapeIDCreator1, shape1->GetFirstVoxelIndex(brick_box)), inSubShapeIDCreator2, inCollideShapeSettings, collector, shape_filter);
			if (ioCollector.ShouldEarlyOut())
				return false;
		}
		return true;
	};
	// Not filtered by exposed face. GetRequiredExposedFacesForBounds looks like the way to
	// narrow this, but the direction it derives runs between the two shapes' centres, and
	// whether a voxel can be reached depends on its own surface orientation. On a hull most
	// of the contact surface faces some other way, so the near skin gets filtered out and a
	// craft flies through it and lands on the far side's inner plating.
	shape1->WalkSurfaceBricks(range, brick_visitor, &range_filter);
}

void VoxelShape::sCollideShapeVsVoxel(const Shape *inShape1, const Shape *inShape2, Vec3Arg inScale1, Vec3Arg inScale2, Mat44Arg inCenterOfMassTransform1, Mat44Arg inCenterOfMassTransform2, const SubShapeIDCreator &inSubShapeIDCreator1, const SubShapeIDCreator &inSubShapeIDCreator2, const CollideShapeSettings &inCollideShapeSettings, CollideShapeCollector &ioCollector, const ShapeFilter &inShapeFilter)
{
	JPH_PROFILE_FUNCTION();

	JPH_ASSERT(inShape2->GetSubType() == EShapeSubType::User1);
	const VoxelShape *shape2 = static_cast<const VoxelShape *>(inShape2);

	VoxelShapeFilter shape_filter(inShapeFilter, shape2, nullptr);
	AABox shape1_bounds = inShape1->GetLocalBounds().Scaled(inScale1).Transformed(inCenterOfMassTransform2.InversedRotationTranslation() * inCenterOfMassTransform1).Scaled(Vec3::sOne() / inScale2);
	AABox shape1_world_bounds = inShape1->GetWorldSpaceBounds(inCenterOfMassTransform1, inScale1);
	VoxelRange range = shape2->GetVoxelRangeOverlappingLocalBounds(shape1_bounds);
	WorldBoundsVoxelRangeFilter range_filter(shape2, inScale2, inCenterOfMassTransform2, shape1_world_bounds);
	BrickBoxContactSide voxel_side { shape2, inCenterOfMassTransform2.InversedRotationTranslation(), Vec3::sOne() / inScale2, inSubShapeIDCreator2 };
	BrickBoxContactSide other_side;
	BrickBox boxes[cMaxBrickBoxes];
	auto brick_visitor = [&](uint inBrickX, uint inBrickY, uint inBrickZ, uint64 inSurfaceMask, uint64 inSolidMask) {
		if (!shape2->GetBrickLocalBounds(inBrickX, inBrickY, inBrickZ).Scaled(inScale2).Transformed(inCenterOfMassTransform2).Overlaps(shape1_world_bounds))
			return true;

		uint box_count = sDecomposeBrick(inBrickX, inBrickY, inBrickZ, inSurfaceMask, inSolidMask, boxes);
		for (uint box_index = 0; box_index < box_count; ++box_index)
		{
			const BrickBox &brick_box = boxes[box_index];
			AABox local_bounds = shape2->GetBrickBoxLocalBounds(brick_box);
			if (!local_bounds.Scaled(inScale2).Transformed(inCenterOfMassTransform2).Overlaps(shape1_world_bounds))
				continue;

			BoxShape box = shape2->CreateBrickBoxShape(local_bounds);
			shape_filter.SetBoxShape(&box);
			voxel_side.mBox = &brick_box;
			BrickBoxHitCollector collector(ioCollector, other_side, voxel_side);
			Mat44 box_transform = inCenterOfMassTransform2.PreTranslated(inScale2 * local_bounds.GetCenter());
			CollisionDispatch::sCollideShapeVsShape(inShape1, &box, inScale1, inScale2, inCenterOfMassTransform1, box_transform, inSubShapeIDCreator1, shape2->MakeVoxelSubShapeIDCreator(inSubShapeIDCreator2, shape2->GetFirstVoxelIndex(brick_box)), inCollideShapeSettings, collector, shape_filter);
			if (ioCollector.ShouldEarlyOut())
				return false;
		}
		return true;
	};
	shape2->WalkSurfaceBricks(range, brick_visitor, &range_filter);
}

void VoxelShape::sCollideVoxelVsVoxel(const Shape *inShape1, const Shape *inShape2, Vec3Arg inScale1, Vec3Arg inScale2, Mat44Arg inCenterOfMassTransform1, Mat44Arg inCenterOfMassTransform2, const SubShapeIDCreator &inSubShapeIDCreator1, const SubShapeIDCreator &inSubShapeIDCreator2, const CollideShapeSettings &inCollideShapeSettings, CollideShapeCollector &ioCollector, const ShapeFilter &inShapeFilter)
{
	JPH_PROFILE_FUNCTION();

	JPH_ASSERT(inShape1->GetSubType() == EShapeSubType::User1);
	JPH_ASSERT(inShape2->GetSubType() == EShapeSubType::User1);
	const VoxelShape *shape1 = static_cast<const VoxelShape *>(inShape1);
	const VoxelShape *shape2 = static_cast<const VoxelShape *>(inShape2);

	Vec3 separation_distance = Vec3::sReplicate(max(inCollideShapeSettings.mMaxSeparationDistance, 0.0f));
	AABox world_bounds1 = shape1->GetWorldSpaceBounds(inCenterOfMassTransform1, inScale1);
	AABox world_bounds2 = shape2->GetWorldSpaceBounds(inCenterOfMassTransform2, inScale2);
	world_bounds1.ExpandBy(separation_distance);
	world_bounds2.ExpandBy(separation_distance);
	AABox shared_world_bounds = world_bounds1.Intersect(world_bounds2);
	if (!shared_world_bounds.IsValid())
		return;

	VoxelShapeFilter shape_filter1(inShapeFilter, shape1, nullptr);
	VoxelShapeFilter shape_filter2(shape_filter1, shape2, nullptr);

	bool shape1_outside = shape1->mVoxelHalfExtent.ReduceMin() >= shape2->mVoxelHalfExtent.ReduceMin();
	const VoxelShape *outer_shape = shape1_outside? shape1 : shape2;
	const VoxelShape *inner_shape = shape1_outside? shape2 : shape1;
	Vec3 outer_scale = shape1_outside? inScale1 : inScale2;
	Vec3 inner_scale = shape1_outside? inScale2 : inScale1;
	Mat44 outer_transform = shape1_outside? inCenterOfMassTransform1 : inCenterOfMassTransform2;
	Mat44 inner_transform = shape1_outside? inCenterOfMassTransform2 : inCenterOfMassTransform1;

	Mat44 inverse_outer_transform = outer_transform.InversedRotationTranslation();
	Mat44 outer_to_inner = inner_transform.InversedRotationTranslation() * outer_transform;
	Mat44 inner_to_outer = inverse_outer_transform * inner_transform;
	Vec3 inv_outer_scale = Vec3::sOne() / outer_scale;
	Vec3 inv_inner_scale = Vec3::sOne() / inner_scale;
	Vec3 outer_separation = separation_distance * inv_outer_scale.Abs();
	Vec3 inner_separation = separation_distance * inv_inner_scale.Abs();

	AABox shared_bounds_in_outer = shared_world_bounds.Transformed(inverse_outer_transform).Scaled(inv_outer_scale);
	VoxelRange outer_range = outer_shape->GetVoxelRangeOverlappingLocalBounds(shared_bounds_in_outer, true);
	WorldBoundsVoxelRangeFilter outer_range_filter(outer_shape, outer_scale, outer_transform, shared_world_bounds);

	BrickBoxContactSide side1 { shape1, inCenterOfMassTransform1.InversedRotationTranslation(), Vec3::sOne() / inScale1, inSubShapeIDCreator1 };
	BrickBoxContactSide side2 { shape2, inCenterOfMassTransform2.InversedRotationTranslation(), Vec3::sOne() / inScale2, inSubShapeIDCreator2 };
	BrickBoxContactSide &outer_side = shape1_outside? side1 : side2;
	BrickBoxContactSide &inner_side = shape1_outside? side2 : side1;
	VoxelShapeFilter &outer_filter = shape1_outside? shape_filter1 : shape_filter2;
	VoxelShapeFilter &inner_filter = shape1_outside? shape_filter2 : shape_filter1;

	BrickBox outer_boxes[cMaxBrickBoxes];
	AABox outer_box_bounds[cMaxBrickBoxes];
	AABox outer_box_reach[cMaxBrickBoxes];
	uint outer_box_count = 0;
	BrickBox inner_boxes[cMaxBrickBoxes];

	auto inner_visitor = [&](uint inBrickX, uint inBrickY, uint inBrickZ, uint64 inSurfaceMask, uint64 inSolidMask) {
		uint inner_box_count = sDecomposeBrick(inBrickX, inBrickY, inBrickZ, inSurfaceMask, inSolidMask, inner_boxes);
		for (uint inner_index = 0; inner_index < inner_box_count; ++inner_index)
		{
			const BrickBox &inner_box = inner_boxes[inner_index];
			AABox inner_bounds = inner_shape->GetBrickBoxLocalBounds(inner_box);
			AABox inner_in_outer = inner_bounds.Scaled(inner_scale).Transformed(inner_to_outer).Scaled(inv_outer_scale);
			BoxShape inner_box_shape = inner_shape->CreateBrickBoxShape(inner_bounds);
			Mat44 inner_box_transform = inner_transform.PreTranslated(inner_scale * inner_bounds.GetCenter());
			SubShapeIDCreator inner_creator = inner_shape->MakeVoxelSubShapeIDCreator(inner_side.mSubShapeIDCreator, inner_shape->GetFirstVoxelIndex(inner_box));
			inner_side.mBox = &inner_box;
			inner_filter.SetBoxShape(&inner_box_shape);

			for (uint outer_index = 0; outer_index < outer_box_count; ++outer_index)
			{
				if (!outer_box_reach[outer_index].Overlaps(inner_in_outer))
					continue;

				const BrickBox &outer_box = outer_boxes[outer_index];
				BoxShape outer_box_shape = outer_shape->CreateBrickBoxShape(outer_box_bounds[outer_index]);
				Mat44 outer_box_transform = outer_transform.PreTranslated(outer_scale * outer_box_bounds[outer_index].GetCenter());
				SubShapeIDCreator outer_creator = outer_shape->MakeVoxelSubShapeIDCreator(outer_side.mSubShapeIDCreator, outer_shape->GetFirstVoxelIndex(outer_box));
				outer_side.mBox = &outer_box;
				outer_filter.SetBoxShape(&outer_box_shape);
				BrickBoxHitCollector collector(ioCollector, side1, side2);

				// Which grid drove the walk is ours to choose, but which shape the
				// collector calls the first one is not, so shape 1 stays on the left.
				if (shape1_outside)
					CollisionDispatch::sCollideShapeVsShape(&outer_box_shape, &inner_box_shape, inScale1, inScale2, outer_box_transform, inner_box_transform, outer_creator, inner_creator, inCollideShapeSettings, collector, shape_filter2);
				else
					CollisionDispatch::sCollideShapeVsShape(&inner_box_shape, &outer_box_shape, inScale1, inScale2, inner_box_transform, outer_box_transform, inner_creator, outer_creator, inCollideShapeSettings, collector, shape_filter2);

				if (ioCollector.ShouldEarlyOut())
					return false;
			}
		}
		return true;
	};

	auto outer_visitor = [&](uint inBrickX, uint inBrickY, uint inBrickZ, uint64 inSurfaceMask, uint64 inSolidMask) {
		if (!outer_shape->GetBrickLocalBounds(inBrickX, inBrickY, inBrickZ).Scaled(outer_scale).Transformed(outer_transform).Overlaps(shared_world_bounds))
			return true;

		outer_box_count = sDecomposeBrick(inBrickX, inBrickY, inBrickZ, inSurfaceMask, inSolidMask, outer_boxes);
		AABox outer_boxes_bounds;
		for (uint outer_index = 0; outer_index < outer_box_count; ++outer_index)
		{
			outer_box_bounds[outer_index] = outer_shape->GetBrickBoxLocalBounds(outer_boxes[outer_index]);
			outer_box_reach[outer_index] = outer_box_bounds[outer_index];
			outer_box_reach[outer_index].ExpandBy(outer_separation);
			outer_boxes_bounds.Encapsulate(outer_box_bounds[outer_index]);
		}

		AABox reach_in_inner = outer_boxes_bounds.Scaled(outer_scale).Transformed(outer_to_inner).Scaled(inv_inner_scale);
		reach_in_inner.ExpandBy(inner_separation);
		inner_shape->WalkSurfaceBricks(inner_shape->GetVoxelRangeOverlappingLocalBounds(reach_in_inner, true), inner_visitor);
		return !ioCollector.ShouldEarlyOut();
	};
	outer_shape->WalkSurfaceBricks(outer_range, outer_visitor, &outer_range_filter);
}

void VoxelShape::sCastVoxelVsShape(const ShapeCast &inShapeCast, const ShapeCastSettings &inShapeCastSettings, const Shape *inShape, Vec3Arg inScale, const ShapeFilter &inShapeFilter, Mat44Arg inCenterOfMassTransform2, const SubShapeIDCreator &inSubShapeIDCreator1, const SubShapeIDCreator &inSubShapeIDCreator2, CastShapeCollector &ioCollector)
{
	JPH_PROFILE_FUNCTION();

	JPH_ASSERT(inShapeCast.mShape->GetSubType() == EShapeSubType::User1);
	const VoxelShape *cast_shape = static_cast<const VoxelShape *>(inShapeCast.mShape);

	BoxShape box = cast_shape->CreateBoxShape();
	VoxelShapeFilter shape_filter(inShapeFilter, cast_shape, &box);
	Mat44 target_to_voxel = inShapeCast.mCenterOfMassStart.InversedRotationTranslation();
	AABox target_bounds = inShape->GetLocalBounds().Scaled(inScale).Transformed(target_to_voxel).Scaled(Vec3::sOne() / inShapeCast.mScale);
	Vec3 target_direction = -target_to_voxel.Multiply3x3(inShapeCast.mDirection) / inShapeCast.mScale;
	auto visitor = [cast_shape, &box, &inShapeCast, &inShapeCastSettings, inShape, inScale, &shape_filter, inCenterOfMassTransform2, &inSubShapeIDCreator1, &inSubShapeIDCreator2, &ioCollector](SubShapeID::Type inVoxelIndex, Vec3Arg inVoxelCenter) {
		ShapeCast box_cast(&box, inShapeCast.mScale, inShapeCast.mCenterOfMassStart.PreTranslated(inShapeCast.mScale * inVoxelCenter), inShapeCast.mDirection);
		CollisionDispatch::sCastShapeVsShapeLocalSpace(box_cast, inShapeCastSettings, inShape, inScale, shape_filter, inCenterOfMassTransform2, cast_shape->MakeVoxelSubShapeIDCreator(inSubShapeIDCreator1, inVoxelIndex), inSubShapeIDCreator2, ioCollector);
		return !ioCollector.ShouldEarlyOut();
	};
	cast_shape->WalkBoxCastVoxels(target_bounds, target_direction, ioCollector.GetPositiveEarlyOutFraction(), visitor);
}

void VoxelShape::sCastShapeVsVoxel(const ShapeCast &inShapeCast, const ShapeCastSettings &inShapeCastSettings, const Shape *inShape, Vec3Arg inScale, const ShapeFilter &inShapeFilter, Mat44Arg inCenterOfMassTransform2, const SubShapeIDCreator &inSubShapeIDCreator1, const SubShapeIDCreator &inSubShapeIDCreator2, CastShapeCollector &ioCollector)
{
	JPH_PROFILE_FUNCTION();

	JPH_ASSERT(inShape->GetSubType() == EShapeSubType::User1);
	const VoxelShape *shape = static_cast<const VoxelShape *>(inShape);

	BoxShape box = shape->CreateBoxShape();
	VoxelShapeFilter shape_filter(inShapeFilter, shape, &box);
	AABox cast_bounds = inShapeCast.mShapeWorldBounds.Scaled(Vec3::sOne() / inScale);
	Vec3 cast_direction = inShapeCast.mDirection / inScale;
	auto visitor = [shape, &box, &inShapeCast, &inShapeCastSettings, inScale, &shape_filter, inCenterOfMassTransform2, &inSubShapeIDCreator1, &inSubShapeIDCreator2, &ioCollector](SubShapeID::Type inVoxelIndex, Vec3Arg inVoxelCenter) {
		CollisionDispatch::sCastShapeVsShapeLocalSpace(inShapeCast, inShapeCastSettings, &box, inScale, shape_filter, inCenterOfMassTransform2.PreTranslated(inScale * inVoxelCenter), inSubShapeIDCreator1, shape->MakeVoxelSubShapeIDCreator(inSubShapeIDCreator2, inVoxelIndex), ioCollector);
		return !ioCollector.ShouldEarlyOut();
	};
	shape->WalkBoxCastVoxels(cast_bounds, cast_direction, ioCollector.GetPositiveEarlyOutFraction(), visitor);
}

void VoxelShape::sRegister()
{
	ShapeFunctions &f = ShapeFunctions::sGet(EShapeSubType::User1);
	f.mConstruct = []() -> Shape * { return new VoxelShape; };
	f.mColor = Color::sCyan;

	for (EShapeSubType s : sAllSubShapeTypes)
	{
		CollisionDispatch::sRegisterCollideShape(EShapeSubType::User1, s, sCollideVoxelVsShape);
		CollisionDispatch::sRegisterCollideShape(s, EShapeSubType::User1, sCollideShapeVsVoxel);
		CollisionDispatch::sRegisterCastShape(EShapeSubType::User1, s, sCastVoxelVsShape);
		CollisionDispatch::sRegisterCastShape(s, EShapeSubType::User1, sCastShapeVsVoxel);
	}

	CollisionDispatch::sRegisterCollideShape(EShapeSubType::User1, EShapeSubType::User1, sCollideVoxelVsVoxel);
}

JPH_NAMESPACE_END

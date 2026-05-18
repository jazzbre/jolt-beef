// Jolt Physics Library (https://github.com/jrouwe/JoltPhysics)
// SPDX-FileCopyrightText: 2026 Jorrit Rouwe
// SPDX-License-Identifier: MIT

#include <Jolt/Jolt.h>

#include "jolt_voxel_shape.h"
#include "jolt_voxel_shape_c.h"
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
bool JPHC_VoxelShape::sRecordTouchedVoxels = false;
bool JPHC_VoxelShape::sDrawTouchedVoxels = true;
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

JPHC_VoxelShapeSettings::JPHC_VoxelShapeSettings(const JPHC_VoxelShapeDataInterface *inVoxelDataInterface, uint inSizeX, uint inSizeY, uint inSizeZ, Vec3Arg inVoxelHalfExtent, float inConvexRadius) :
	mVoxelDataInterface(inVoxelDataInterface),
	mSizeX(inSizeX),
	mSizeY(inSizeY),
	mSizeZ(inSizeZ),
	mVoxelHalfExtent(inVoxelHalfExtent),
	mConvexRadius(inConvexRadius),
	mVoxelIndexBits(JPHC_VoxelShape::sCalculateVoxelIndexBits(inSizeX, inSizeY, inSizeZ))
{
}

ShapeSettings::ShapeResult JPHC_VoxelShapeSettings::Create() const
{
	if (mCachedResult.IsEmpty())
		Ref<Shape> shape = new JPHC_VoxelShape(*this, mCachedResult);
	return mCachedResult;
}

JPHC_VoxelShape::JPHC_VoxelShape(const JPHC_VoxelShapeDataInterface *inVoxelDataInterface, uint inSizeX, uint inSizeY, uint inSizeZ, Vec3Arg inVoxelHalfExtent, float inConvexRadius) :
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

JPHC_VoxelShape::JPHC_VoxelShape(std::unique_ptr<const JPHC_VoxelShapeDataInterface> inVoxelDataInterface, uint inSizeX, uint inSizeY, uint inSizeZ, Vec3Arg inVoxelHalfExtent, float inConvexRadius) :
	JPHC_VoxelShape(inVoxelDataInterface.get(), inSizeX, inSizeY, inSizeZ, inVoxelHalfExtent, inConvexRadius)
{
	mOwnedVoxelDataInterface = std::move(inVoxelDataInterface);
}

JPHC_VoxelShape::JPHC_VoxelShape(const JPHC_VoxelShapeSettings &inSettings, ShapeResult &outResult) :
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

class JPHC_VoxelShape::JPHC_VoxelShapeFilter final : public ShapeFilter
{
public:
						JPHC_VoxelShapeFilter(const ShapeFilter &inFilter, const JPHC_VoxelShape *inJPHC_VoxelShape, const BoxShape *inBoxShape) :
		mFilter(inFilter),
		mJPHC_VoxelShape(inJPHC_VoxelShape),
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

private:
	const Shape *		MapShape(const Shape *inShape) const
	{
		return inShape == mBoxShape? mJPHC_VoxelShape : inShape;
	}

	const ShapeFilter &	mFilter;
	const JPHC_VoxelShape *	mJPHC_VoxelShape;
	const BoxShape *	mBoxShape;
};

struct JPHC_VoxelShape::VoxelRange
{
	uint				mMinX = 0;
	uint				mMinY = 0;
	uint				mMinZ = 0;
	uint				mMaxX = 0;
	uint				mMaxY = 0;
	uint				mMaxZ = 0;
};

struct JPHC_VoxelShape::GetTrianglesContextVoxel
{
	const JPHC_VoxelShape *	mShape;
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
class JPHC_VoxelDataVisitorAdapter final : public JPHC_VoxelShapeDataVisitor
{
public:
						JPHC_VoxelDataVisitorAdapter(const JPHC_VoxelShape *inShape, Visitor &ioVisitor, bool inRecordTouchedVoxels) :
		mShape(inShape),
		mVisitor(ioVisitor),
		mRecordTouchedVoxels(inRecordTouchedVoxels)
	{
	}

	virtual bool		VisitVoxel(uint inX, uint inY, uint inZ, SubShapeID::Type inVoxelIndex) override
	{
		if (inX >= mShape->GetSizeX() || inY >= mShape->GetSizeY() || inZ >= mShape->GetSizeZ())
			return true;

		JPH_IF_DEBUG_RENDERER(if (mRecordTouchedVoxels) mShape->RecordTouchedVoxel(inVoxelIndex);)
		return mVisitor(inVoxelIndex, mShape->GetVoxelCenter(inX, inY, inZ));
	}

private:
	const JPHC_VoxelShape *	mShape;
	Visitor &			mVisitor;
	bool				mRecordTouchedVoxels;
};

uint JPHC_VoxelShape::sCalculateVoxelIndexBits(uint inSizeX, uint inSizeY, uint inSizeZ)
{
	uint64 num_voxels = uint64(inSizeX) * uint64(inSizeY) * uint64(inSizeZ);
	JPH_ASSERT(num_voxels <= uint64(UINT_MAX));
	return num_voxels <= 1? 0 : 32 - CountLeadingZeros(uint32(num_voxels - 1));
}

template <class Visitor>
void JPHC_VoxelShape::WalkVoxels(Visitor &ioVisitor, bool inRecordTouchedVoxels) const
{
	WalkVoxels(VoxelRange { 0, 0, 0, mSizeX, mSizeY, mSizeZ }, ioVisitor, inRecordTouchedVoxels);
}

template <class Visitor>
void JPHC_VoxelShape::WalkVoxels(const VoxelRange &inRange, Visitor &ioVisitor, [[maybe_unused]] bool inRecordTouchedVoxels, uint inRequiredExposedFaces, const JPHC_VoxelShapeDataRangeFilter *inRangeFilter) const
{
	JPH_ASSERT(mVoxelDataInterface != nullptr);
	if (mVoxelDataInterface == nullptr)
		return;

	JPHC_VoxelDataVisitorAdapter<Visitor> visitor(this, ioVisitor, inRecordTouchedVoxels);
	mVoxelDataInterface->VisitActiveVoxels(inRange.mMinX, inRange.mMinY, inRange.mMinZ, inRange.mMaxX, inRange.mMaxY, inRange.mMaxZ, inRequiredExposedFaces, visitor, inRangeFilter);
}

template <class Visitor>
void JPHC_VoxelShape::WalkRayVoxels(const RayCast &inRay, float inMaxFraction, Visitor &ioVisitor) const
{
	if (mSizeX == 0 || mSizeY == 0 || mSizeZ == 0 || inMaxFraction < 0.0f)
		return;

	JPH_ASSERT(mVoxelDataInterface != nullptr);
	if (mVoxelDataInterface == nullptr)
		return;

	JPHC_VoxelDataVisitorAdapter<Visitor> visitor(this, ioVisitor, true);
	mVoxelDataInterface->VisitRayVoxels(inRay, inMaxFraction, mVoxelHalfExtent, mSizeX, mSizeY, mSizeZ, visitor);
}

template <class Visitor>
void JPHC_VoxelShape::WalkBoxCastVoxels(const AABox &inStartBounds, Vec3Arg inDirection, float inMaxFraction, Visitor &ioVisitor) const
{
	if (mSizeX == 0 || mSizeY == 0 || mSizeZ == 0 || !inStartBounds.IsValid() || inMaxFraction < 0.0f)
		return;

	JPH_ASSERT(mVoxelDataInterface != nullptr);
	if (mVoxelDataInterface == nullptr)
		return;

	JPHC_VoxelDataVisitorAdapter<Visitor> visitor(this, ioVisitor, true);
	mVoxelDataInterface->VisitBoxCastVoxels(inStartBounds, inDirection, inMaxFraction, mVoxelHalfExtent, mSizeX, mSizeY, mSizeZ, visitor);
}

JPHC_VoxelShape::VoxelRange JPHC_VoxelShape::GetVoxelRangeOverlappingLocalBounds(const AABox &inLocalBounds) const
{
	VoxelRange range;
	if (mSizeX == 0 || mSizeY == 0 || mSizeZ == 0)
		return range;

	auto calculate_range = [](float inMin, float inMax, float inGridMin, float inVoxelSize, uint inSize, uint &outMin, uint &outMax) {
		if (inVoxelSize <= 0.0f)
		{
			outMin = 0;
			outMax = inSize;
			return;
		}

		outMin = uint(Clamp(int(floor((inMin - inGridMin) / inVoxelSize)), 0, int(inSize)));
		outMax = uint(Clamp(int(floor((inMax - inGridMin) / inVoxelSize)) + 1, 0, int(inSize)));
		if (outMax < outMin)
			outMax = outMin;
	};

	calculate_range(inLocalBounds.mMin.GetX(), inLocalBounds.mMax.GetX(), -float(mSizeX) * mVoxelHalfExtent.GetX(), 2.0f * mVoxelHalfExtent.GetX(), mSizeX, range.mMinX, range.mMaxX);
	calculate_range(inLocalBounds.mMin.GetY(), inLocalBounds.mMax.GetY(), -float(mSizeY) * mVoxelHalfExtent.GetY(), 2.0f * mVoxelHalfExtent.GetY(), mSizeY, range.mMinY, range.mMaxY);
	calculate_range(inLocalBounds.mMin.GetZ(), inLocalBounds.mMax.GetZ(), -float(mSizeZ) * mVoxelHalfExtent.GetZ(), 2.0f * mVoxelHalfExtent.GetZ(), mSizeZ, range.mMinZ, range.mMaxZ);
	return range;
}

AABox JPHC_VoxelShape::GetVoxelRangeLocalBounds(uint inMinX, uint inMinY, uint inMinZ, uint inMaxX, uint inMaxY, uint inMaxZ) const
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

bool JPHC_VoxelShape::HasActiveVoxels(const VoxelRange &inRange, uint inRequiredExposedFaces, const JPHC_VoxelShapeDataRangeFilter *inRangeFilter) const
{
	JPH_ASSERT(mVoxelDataInterface != nullptr);
	if (mVoxelDataInterface == nullptr)
		return false;

	return mVoxelDataInterface->HasActiveVoxels(inRange.mMinX, inRange.mMinY, inRange.mMinZ, inRange.mMaxX, inRange.mMaxY, inRange.mMaxZ, inRequiredExposedFaces, inRangeFilter);
}

uint JPHC_VoxelShape::GetRequiredExposedFacesForBounds(const AABox &inLocalBounds) const
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

class JPHC_WorldBoundsVoxelRangeFilter final : public JPHC_VoxelShapeDataRangeFilter
{
public:
	JPHC_WorldBoundsVoxelRangeFilter(const JPHC_VoxelShape *inShape, Vec3Arg inScale, Mat44Arg inCenterOfMassTransform, const AABox &inWorldBounds) :
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
	const JPHC_VoxelShape *	mShape;
	Vec3					mScale;
	Mat44					mCenterOfMassTransform;
	AABox					mWorldBounds;
};

class JPHC_OtherVoxelShapeRangeFilter final : public JPHC_VoxelShapeDataRangeFilter
{
public:
	JPHC_OtherVoxelShapeRangeFilter(const JPHC_VoxelShape *inSourceShape, const JPHC_VoxelShape *inTargetShape, Vec3Arg inSourceScale, Vec3Arg inTargetScale, Mat44Arg inSourceToTarget) :
		mSourceShape(inSourceShape),
		mTargetShape(inTargetShape),
		mSourceScale(inSourceScale),
		mInvTargetScale(Vec3::sOne() / inTargetScale),
		mSourceToTarget(inSourceToTarget)
	{
	}

	virtual bool ShouldVisitRange(uint inMinX, uint inMinY, uint inMinZ, uint inMaxX, uint inMaxY, uint inMaxZ) const override
	{
		AABox source_range_in_target = mSourceShape->GetVoxelRangeLocalBounds(inMinX, inMinY, inMinZ, inMaxX, inMaxY, inMaxZ).Scaled(mSourceScale).Transformed(mSourceToTarget).Scaled(mInvTargetScale);
		JPHC_VoxelShape::VoxelRange target_range = mTargetShape->GetVoxelRangeOverlappingLocalBounds(source_range_in_target);
		uint target_required_exposed_faces = mTargetShape->GetRequiredExposedFacesForBounds(source_range_in_target);
		return mTargetShape->HasActiveVoxels(target_range, target_required_exposed_faces);
	}

private:
	const JPHC_VoxelShape *	mSourceShape;
	const JPHC_VoxelShape *	mTargetShape;
	Vec3					mSourceScale;
	Vec3					mInvTargetScale;
	Mat44					mSourceToTarget;
};

bool JPHC_VoxelShape::IsVoxelActive(SubShapeID::Type inVoxelIndex) const
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

bool JPHC_VoxelShape::IsVoxelActive(uint inX, uint inY, uint inZ, SubShapeID::Type inVoxelIndex) const
{
	JPH_ASSERT(mVoxelDataInterface != nullptr);
	return mVoxelDataInterface != nullptr && mVoxelDataInterface->IsVoxelActive(inX, inY, inZ, inVoxelIndex);
}

Vec3 JPHC_VoxelShape::GetVoxelCenter(SubShapeID::Type inVoxelIndex) const
{
	uint xy_size = mSizeX * mSizeY;
	uint z = inVoxelIndex / xy_size;
	uint remainder = inVoxelIndex - z * xy_size;
	uint y = remainder / mSizeX;
	uint x = remainder - y * mSizeX;
	return GetVoxelCenter(x, y, z);
}

Vec3 JPHC_VoxelShape::GetVoxelCenter(uint inX, uint inY, uint inZ) const
{
	return Vec3((float(2 * inX + 1) - float(mSizeX)) * mVoxelHalfExtent.GetX(), (float(2 * inY + 1) - float(mSizeY)) * mVoxelHalfExtent.GetY(), (float(2 * inZ + 1) - float(mSizeZ)) * mVoxelHalfExtent.GetZ());
}

#ifdef JPH_DEBUG_RENDERER
void JPHC_VoxelShape::RecordTouchedVoxel(SubShapeID::Type inVoxelIndex) const
{
	if (!sRecordTouchedVoxels)
		return;

	for (SubShapeID::Type voxel_index : mTouchedVoxels)
		if (voxel_index == inVoxelIndex)
			return;

	mTouchedVoxels.push_back(inVoxelIndex);
}
#endif // JPH_DEBUG_RENDERER

SubShapeIDCreator JPHC_VoxelShape::MakeVoxelSubShapeIDCreator(const SubShapeIDCreator &inSubShapeIDCreator, SubShapeID::Type inVoxelIndex) const
{
	JPH_ASSERT(inSubShapeIDCreator.GetNumBitsWritten() + mVoxelIndexBits <= SubShapeID::MaxBits);
	return inSubShapeIDCreator.PushID(inVoxelIndex, mVoxelIndexBits);
}

BoxShape JPHC_VoxelShape::CreateBoxShape() const
{
	return BoxShape(mVoxelHalfExtent, mConvexRadius);
}

AABox JPHC_VoxelShape::GetLocalBounds() const
{
	return AABox(-Vec3(float(mSizeX) * mVoxelHalfExtent.GetX(), float(mSizeY) * mVoxelHalfExtent.GetY(), float(mSizeZ) * mVoxelHalfExtent.GetZ()),
		Vec3(float(mSizeX) * mVoxelHalfExtent.GetX(), float(mSizeY) * mVoxelHalfExtent.GetY(), float(mSizeZ) * mVoxelHalfExtent.GetZ()));
}

MassProperties JPHC_VoxelShape::GetMassProperties() const
{
	BoxShape box = CreateBoxShape();
	MassProperties box_mass = box.GetMassProperties();

	MassProperties total;
	auto visitor = [this, &box_mass, &total](SubShapeID::Type, Vec3Arg inVoxelCenter) {
		MassProperties voxel_mass = box_mass;
		voxel_mass.Translate(inVoxelCenter);
		total.mMass += voxel_mass.mMass;
		total.mInertia += voxel_mass.mInertia;
		return true;
	};
	WalkVoxels(visitor, false);

	return total;
}

const Shape *JPHC_VoxelShape::GetLeafShape(const SubShapeID &inSubShapeID, SubShapeID &outRemainder) const
{
	GetVoxelIndex(inSubShapeID, outRemainder);
	return this;
}

const PhysicsMaterial *JPHC_VoxelShape::GetMaterial(const SubShapeID &inSubShapeID) const
{
	SubShapeID remainder;
	GetVoxelIndex(inSubShapeID, remainder);
	JPH_ASSERT(remainder.IsEmpty(), "Invalid subshape ID");
	return PhysicsMaterial::sDefault;
}

uint64 JPHC_VoxelShape::GetSubShapeUserData(const SubShapeID &inSubShapeID) const
{
	SubShapeID remainder;
	return GetVoxelIndex(inSubShapeID, remainder);
}

Vec3 JPHC_VoxelShape::GetSurfaceNormal(const SubShapeID &inSubShapeID, Vec3Arg inLocalSurfacePosition) const
{
	SubShapeID remainder;
	SubShapeID::Type voxel_index = GetVoxelIndex(inSubShapeID, remainder);
	JPH_ASSERT(remainder.IsEmpty(), "Invalid subshape ID");

	BoxShape box = CreateBoxShape();
	return box.GetSurfaceNormal(remainder, inLocalSurfacePosition - GetVoxelCenter(voxel_index));
}

void JPHC_VoxelShape::GetSupportingFace(const SubShapeID &inSubShapeID, Vec3Arg inDirection, Vec3Arg inScale, Mat44Arg inCenterOfMassTransform, SupportingFace &outVertices) const
{
	SubShapeID remainder;
	SubShapeID::Type voxel_index = GetVoxelIndex(inSubShapeID, remainder);
	JPH_ASSERT(remainder.IsEmpty(), "Invalid subshape ID");

	BoxShape box = CreateBoxShape();
	box.GetSupportingFace(remainder, inDirection, inScale, inCenterOfMassTransform.PreTranslated(inScale * GetVoxelCenter(voxel_index)), outVertices);
}

void JPHC_VoxelShape::GetSubmergedVolume(Mat44Arg inCenterOfMassTransform, Vec3Arg inScale, const Plane &inSurface, float &outTotalVolume, float &outSubmergedVolume, Vec3 &outCenterOfBuoyancy JPH_IF_DEBUG_RENDERER(, RVec3Arg inBaseOffset)) const
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
void JPHC_VoxelShape::Draw(DebugRenderer *inRenderer, RMat44Arg inCenterOfMassTransform, Vec3Arg inScale, ColorArg inColor, bool inUseMaterialColors, bool inDrawWireframe) const
{
	BoxShape box = CreateBoxShape();
	auto visitor = [this, &box, inRenderer, inCenterOfMassTransform, inScale, inColor, inUseMaterialColors, inDrawWireframe](SubShapeID::Type, Vec3Arg inVoxelCenter) {
		box.Draw(inRenderer, inCenterOfMassTransform.PreTranslated(inScale * inVoxelCenter), inScale, inColor, inUseMaterialColors, inDrawWireframe);
		return true;
	};
	WalkVoxels(visitor, false);

	if (sDrawTouchedVoxels)
		for (SubShapeID::Type voxel_index : mTouchedVoxels)
			if (IsVoxelActive(voxel_index))
				box.Draw(inRenderer, inCenterOfMassTransform.PreTranslated(inScale * GetVoxelCenter(voxel_index)), inScale, Color::sYellow, false, true);
}
#endif // JPH_DEBUG_RENDERER

bool JPHC_VoxelShape::CastRay(const RayCast &inRay, const SubShapeIDCreator &inSubShapeIDCreator, RayCastResult &ioHit) const
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
		JPH_IF_DEBUG_RENDERER(RecordTouchedVoxel(voxel_index);)
		return true;
	}

	return false;
}

void JPHC_VoxelShape::CastRay(const RayCast &inRay, const RayCastSettings &inRayCastSettings, const SubShapeIDCreator &inSubShapeIDCreator, CastRayCollector &ioCollector, const ShapeFilter &inShapeFilter) const
{
	BoxShape box = CreateBoxShape();
	JPHC_VoxelShapeFilter shape_filter(inShapeFilter, this, &box);
	auto visitor = [this, &box, &inRay, &inRayCastSettings, &inSubShapeIDCreator, &ioCollector, &shape_filter](SubShapeID::Type inVoxelIndex, Vec3Arg inVoxelCenter) {
		box.CastRay(inRay.Translated(-inVoxelCenter), inRayCastSettings, MakeVoxelSubShapeIDCreator(inSubShapeIDCreator, inVoxelIndex), ioCollector, shape_filter);
		return !ioCollector.ShouldEarlyOut();
	};
	WalkRayVoxels(inRay, ioCollector.GetEarlyOutFraction(), visitor);
}

void JPHC_VoxelShape::CollidePoint(Vec3Arg inPoint, const SubShapeIDCreator &inSubShapeIDCreator, CollidePointCollector &ioCollector, const ShapeFilter &inShapeFilter) const
{
	BoxShape box = CreateBoxShape();
	JPHC_VoxelShapeFilter shape_filter(inShapeFilter, this, &box);
	VoxelRange range = GetVoxelRangeOverlappingLocalBounds(AABox(inPoint, inPoint));
	auto visitor = [this, &box, inPoint, &inSubShapeIDCreator, &ioCollector, &shape_filter](SubShapeID::Type inVoxelIndex, Vec3Arg inVoxelCenter) {
		box.CollidePoint(inPoint - inVoxelCenter, MakeVoxelSubShapeIDCreator(inSubShapeIDCreator, inVoxelIndex), ioCollector, shape_filter);
		return !ioCollector.ShouldEarlyOut();
	};
	WalkVoxels(range, visitor);
}

void JPHC_VoxelShape::CollideSoftBodyVertices(Mat44Arg inCenterOfMassTransform, Vec3Arg inScale, const CollideSoftBodyVertexIterator &inVertices, uint inNumVertices, int inCollidingShapeIndex) const
{
	BoxShape box = CreateBoxShape();
	auto visitor = [this, &box, inCenterOfMassTransform, inScale, &inVertices, inNumVertices, inCollidingShapeIndex](SubShapeID::Type, Vec3Arg inVoxelCenter) {
		box.CollideSoftBodyVertices(inCenterOfMassTransform.PreTranslated(inScale * inVoxelCenter), inScale, inVertices, inNumVertices, inCollidingShapeIndex);
		return true;
	};
	WalkVoxels(visitor);
}

void JPHC_VoxelShape::CollectTransformedShapes(const AABox &inBox, Vec3Arg inPositionCOM, QuatArg inRotation, Vec3Arg inScale, const SubShapeIDCreator &inSubShapeIDCreator, TransformedShapeCollector &ioCollector, const ShapeFilter &inShapeFilter) const
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

void JPHC_VoxelShape::GetTrianglesStart(GetTrianglesContext &ioContext, const AABox &inBox, Vec3Arg inPositionCOM, QuatArg inRotation, Vec3Arg inScale) const
{
	static_assert(sizeof(GetTrianglesContextVoxel) <= sizeof(GetTrianglesContext), "GetTrianglesContext too small");
	JPH_ASSERT(IsAligned(&ioContext, alignof(GetTrianglesContextVoxel)));

	Mat44 transform = Mat44::sRotationTranslation(inRotation, inPositionCOM);
	AABox local_box = inBox.Transformed(transform.InversedRotationTranslation()).Scaled(Vec3::sOne() / inScale);
	VoxelRange range = GetVoxelRangeOverlappingLocalBounds(local_box);
	new (&ioContext) GetTrianglesContextVoxel { this, transform * Mat44::sScale(inScale), range, range.mMinX, range.mMinY, range.mMinZ, 0 };
}

int JPHC_VoxelShape::GetTrianglesNext(GetTrianglesContext &ioContext, int inMaxTrianglesRequested, Float3 *outTriangleVertices, const PhysicsMaterial **outMaterials) const
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

Shape::Stats JPHC_VoxelShape::GetStats() const
{
	uint num_active = 0;
	auto visitor = [&num_active](SubShapeID::Type, Vec3Arg) {
		++num_active;
		return true;
	};
	WalkVoxels(visitor, false);
	return Stats(sizeof(*this), 12 * num_active);
}

float JPHC_VoxelShape::GetVolume() const
{
	uint num_active = 0;
	auto visitor = [&num_active](SubShapeID::Type, Vec3Arg) {
		++num_active;
		return true;
	};
	WalkVoxels(visitor, false);
	return num_active * 8.0f * mVoxelHalfExtent.GetX() * mVoxelHalfExtent.GetY() * mVoxelHalfExtent.GetZ();
}

void JPHC_VoxelShape::sCollideVoxelVsShape(const Shape *inShape1, const Shape *inShape2, Vec3Arg inScale1, Vec3Arg inScale2, Mat44Arg inCenterOfMassTransform1, Mat44Arg inCenterOfMassTransform2, const SubShapeIDCreator &inSubShapeIDCreator1, const SubShapeIDCreator &inSubShapeIDCreator2, const CollideShapeSettings &inCollideShapeSettings, CollideShapeCollector &ioCollector, const ShapeFilter &inShapeFilter)
{
	JPH_PROFILE_FUNCTION();

	JPH_ASSERT(inShape1->GetSubType() == EShapeSubType::User1);
	const JPHC_VoxelShape *shape1 = static_cast<const JPHC_VoxelShape *>(inShape1);

	BoxShape box = shape1->CreateBoxShape();
	JPHC_VoxelShapeFilter shape_filter(inShapeFilter, shape1, &box);
	AABox shape2_bounds = inShape2->GetLocalBounds().Scaled(inScale2).Transformed(inCenterOfMassTransform1.InversedRotationTranslation() * inCenterOfMassTransform2).Scaled(Vec3::sOne() / inScale1);
	AABox shape2_world_bounds = inShape2->GetWorldSpaceBounds(inCenterOfMassTransform2, inScale2);
	VoxelRange range = shape1->GetVoxelRangeOverlappingLocalBounds(shape2_bounds);
	uint required_exposed_faces = shape1->GetRequiredExposedFacesForBounds(shape2_bounds);
	JPHC_WorldBoundsVoxelRangeFilter range_filter(shape1, inScale1, inCenterOfMassTransform1, shape2_world_bounds);
	auto visitor = [shape1, &box, inShape2, inScale1, inScale2, inCenterOfMassTransform1, inCenterOfMassTransform2, &shape2_world_bounds, &inSubShapeIDCreator1, &inSubShapeIDCreator2, &inCollideShapeSettings, &ioCollector, &shape_filter](SubShapeID::Type inVoxelIndex, Vec3Arg inVoxelCenter) {
		Mat44 voxel_transform = inCenterOfMassTransform1.PreTranslated(inScale1 * inVoxelCenter);
		if (box.GetWorldSpaceBounds(voxel_transform, inScale1).Overlaps(shape2_world_bounds))
		{
			JPH_IF_DEBUG_RENDERER(shape1->RecordTouchedVoxel(inVoxelIndex);)
			CollisionDispatch::sCollideShapeVsShape(&box, inShape2, inScale1, inScale2, voxel_transform, inCenterOfMassTransform2, shape1->MakeVoxelSubShapeIDCreator(inSubShapeIDCreator1, inVoxelIndex), inSubShapeIDCreator2, inCollideShapeSettings, ioCollector, shape_filter);
		}
		return !ioCollector.ShouldEarlyOut();
	};
	shape1->WalkVoxels(range, visitor, false, required_exposed_faces, &range_filter);
}

void JPHC_VoxelShape::sCollideShapeVsVoxel(const Shape *inShape1, const Shape *inShape2, Vec3Arg inScale1, Vec3Arg inScale2, Mat44Arg inCenterOfMassTransform1, Mat44Arg inCenterOfMassTransform2, const SubShapeIDCreator &inSubShapeIDCreator1, const SubShapeIDCreator &inSubShapeIDCreator2, const CollideShapeSettings &inCollideShapeSettings, CollideShapeCollector &ioCollector, const ShapeFilter &inShapeFilter)
{
	JPH_PROFILE_FUNCTION();

	JPH_ASSERT(inShape2->GetSubType() == EShapeSubType::User1);
	const JPHC_VoxelShape *shape2 = static_cast<const JPHC_VoxelShape *>(inShape2);

	BoxShape box = shape2->CreateBoxShape();
	JPHC_VoxelShapeFilter shape_filter(inShapeFilter, shape2, &box);
	AABox shape1_bounds = inShape1->GetLocalBounds().Scaled(inScale1).Transformed(inCenterOfMassTransform2.InversedRotationTranslation() * inCenterOfMassTransform1).Scaled(Vec3::sOne() / inScale2);
	AABox shape1_world_bounds = inShape1->GetWorldSpaceBounds(inCenterOfMassTransform1, inScale1);
	VoxelRange range = shape2->GetVoxelRangeOverlappingLocalBounds(shape1_bounds);
	uint required_exposed_faces = shape2->GetRequiredExposedFacesForBounds(shape1_bounds);
	JPHC_WorldBoundsVoxelRangeFilter range_filter(shape2, inScale2, inCenterOfMassTransform2, shape1_world_bounds);
	auto visitor = [shape2, inShape1, &box, inScale1, inScale2, inCenterOfMassTransform1, inCenterOfMassTransform2, &shape1_world_bounds, &inSubShapeIDCreator1, &inSubShapeIDCreator2, &inCollideShapeSettings, &ioCollector, &shape_filter](SubShapeID::Type inVoxelIndex, Vec3Arg inVoxelCenter) {
		Mat44 voxel_transform = inCenterOfMassTransform2.PreTranslated(inScale2 * inVoxelCenter);
		if (box.GetWorldSpaceBounds(voxel_transform, inScale2).Overlaps(shape1_world_bounds))
		{
			JPH_IF_DEBUG_RENDERER(shape2->RecordTouchedVoxel(inVoxelIndex);)
			CollisionDispatch::sCollideShapeVsShape(inShape1, &box, inScale1, inScale2, inCenterOfMassTransform1, voxel_transform, inSubShapeIDCreator1, shape2->MakeVoxelSubShapeIDCreator(inSubShapeIDCreator2, inVoxelIndex), inCollideShapeSettings, ioCollector, shape_filter);
		}
		return !ioCollector.ShouldEarlyOut();
	};
	shape2->WalkVoxels(range, visitor, false, required_exposed_faces, &range_filter);
}

void JPHC_VoxelShape::sCollideVoxelVsVoxel(const Shape *inShape1, const Shape *inShape2, Vec3Arg inScale1, Vec3Arg inScale2, Mat44Arg inCenterOfMassTransform1, Mat44Arg inCenterOfMassTransform2, const SubShapeIDCreator &inSubShapeIDCreator1, const SubShapeIDCreator &inSubShapeIDCreator2, const CollideShapeSettings &inCollideShapeSettings, CollideShapeCollector &ioCollector, const ShapeFilter &inShapeFilter)
{
	JPH_PROFILE_FUNCTION();

	JPH_ASSERT(inShape1->GetSubType() == EShapeSubType::User1);
	JPH_ASSERT(inShape2->GetSubType() == EShapeSubType::User1);
	const JPHC_VoxelShape *shape1 = static_cast<const JPHC_VoxelShape *>(inShape1);
	const JPHC_VoxelShape *shape2 = static_cast<const JPHC_VoxelShape *>(inShape2);

	BoxShape box1 = shape1->CreateBoxShape();
	BoxShape box2 = shape2->CreateBoxShape();
	JPHC_VoxelShapeFilter shape_filter1(inShapeFilter, shape1, &box1);
	JPHC_VoxelShapeFilter shape_filter2(shape_filter1, shape2, &box2);

	Mat44 transform1_to_2 = inCenterOfMassTransform2.InversedRotationTranslation() * inCenterOfMassTransform1;
	AABox shape2_bounds_in_1 = shape2->GetLocalBounds().Scaled(inScale2).Transformed(inCenterOfMassTransform1.InversedRotationTranslation() * inCenterOfMassTransform2).Scaled(Vec3::sOne() / inScale1);
	VoxelRange shape1_range = shape1->GetVoxelRangeOverlappingLocalBounds(shape2_bounds_in_1);
	uint shape1_required_exposed_faces = shape1->GetRequiredExposedFacesForBounds(shape2_bounds_in_1);
	JPHC_OtherVoxelShapeRangeFilter shape1_range_filter(shape1, shape2, inScale1, inScale2, transform1_to_2);

	auto visitor1 = [shape1, shape2, &box1, &box2, inScale1, inScale2, inCenterOfMassTransform1, inCenterOfMassTransform2, transform1_to_2, &inSubShapeIDCreator1, &inSubShapeIDCreator2, &inCollideShapeSettings, &ioCollector, &shape_filter2](SubShapeID::Type inVoxelIndex1, Vec3Arg inVoxelCenter1) {
		Mat44 voxel1_transform = inCenterOfMassTransform1.PreTranslated(inScale1 * inVoxelCenter1);
		AABox voxel1_bounds_in_2 = box1.GetLocalBounds().Scaled(inScale1).Transformed(transform1_to_2.PreTranslated(inScale1 * inVoxelCenter1)).Scaled(Vec3::sOne() / inScale2);
		VoxelRange shape2_range = shape2->GetVoxelRangeOverlappingLocalBounds(voxel1_bounds_in_2);
		uint shape2_required_exposed_faces = shape2->GetRequiredExposedFacesForBounds(voxel1_bounds_in_2);

		bool touched_voxel1 = false;
		auto visitor2 = [shape1, shape2, &box1, &box2, inScale1, inScale2, voxel1_transform, inCenterOfMassTransform2, inVoxelIndex1, &touched_voxel1, &inSubShapeIDCreator1, &inSubShapeIDCreator2, &inCollideShapeSettings, &ioCollector, &shape_filter2](SubShapeID::Type inVoxelIndex2, Vec3Arg inVoxelCenter2) {
			if (!touched_voxel1)
			{
				JPH_IF_DEBUG_RENDERER(shape1->RecordTouchedVoxel(inVoxelIndex1);)
				touched_voxel1 = true;
			}
			JPH_IF_DEBUG_RENDERER(shape2->RecordTouchedVoxel(inVoxelIndex2);)

			CollisionDispatch::sCollideShapeVsShape(&box1, &box2, inScale1, inScale2, voxel1_transform, inCenterOfMassTransform2.PreTranslated(inScale2 * inVoxelCenter2), shape1->MakeVoxelSubShapeIDCreator(inSubShapeIDCreator1, inVoxelIndex1), shape2->MakeVoxelSubShapeIDCreator(inSubShapeIDCreator2, inVoxelIndex2), inCollideShapeSettings, ioCollector, shape_filter2);
			return !ioCollector.ShouldEarlyOut();
		};
		shape2->WalkVoxels(shape2_range, visitor2, false, shape2_required_exposed_faces);
		return !ioCollector.ShouldEarlyOut();
	};
	shape1->WalkVoxels(shape1_range, visitor1, false, shape1_required_exposed_faces, &shape1_range_filter);
}

void JPHC_VoxelShape::sCastVoxelVsShape(const ShapeCast &inShapeCast, const ShapeCastSettings &inShapeCastSettings, const Shape *inShape, Vec3Arg inScale, const ShapeFilter &inShapeFilter, Mat44Arg inCenterOfMassTransform2, const SubShapeIDCreator &inSubShapeIDCreator1, const SubShapeIDCreator &inSubShapeIDCreator2, CastShapeCollector &ioCollector)
{
	JPH_PROFILE_FUNCTION();

	JPH_ASSERT(inShapeCast.mShape->GetSubType() == EShapeSubType::User1);
	const JPHC_VoxelShape *cast_shape = static_cast<const JPHC_VoxelShape *>(inShapeCast.mShape);

	BoxShape box = cast_shape->CreateBoxShape();
	JPHC_VoxelShapeFilter shape_filter(inShapeFilter, cast_shape, &box);
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

void JPHC_VoxelShape::sCastShapeVsVoxel(const ShapeCast &inShapeCast, const ShapeCastSettings &inShapeCastSettings, const Shape *inShape, Vec3Arg inScale, const ShapeFilter &inShapeFilter, Mat44Arg inCenterOfMassTransform2, const SubShapeIDCreator &inSubShapeIDCreator1, const SubShapeIDCreator &inSubShapeIDCreator2, CastShapeCollector &ioCollector)
{
	JPH_PROFILE_FUNCTION();

	JPH_ASSERT(inShape->GetSubType() == EShapeSubType::User1);
	const JPHC_VoxelShape *shape = static_cast<const JPHC_VoxelShape *>(inShape);

	BoxShape box = shape->CreateBoxShape();
	JPHC_VoxelShapeFilter shape_filter(inShapeFilter, shape, &box);
	AABox cast_bounds = inShapeCast.mShapeWorldBounds.Scaled(Vec3::sOne() / inScale);
	Vec3 cast_direction = inShapeCast.mDirection / inScale;
	auto visitor = [shape, &box, &inShapeCast, &inShapeCastSettings, inScale, &shape_filter, inCenterOfMassTransform2, &inSubShapeIDCreator1, &inSubShapeIDCreator2, &ioCollector](SubShapeID::Type inVoxelIndex, Vec3Arg inVoxelCenter) {
		CollisionDispatch::sCastShapeVsShapeLocalSpace(inShapeCast, inShapeCastSettings, &box, inScale, shape_filter, inCenterOfMassTransform2.PreTranslated(inScale * inVoxelCenter), inSubShapeIDCreator1, shape->MakeVoxelSubShapeIDCreator(inSubShapeIDCreator2, inVoxelIndex), ioCollector);
		return !ioCollector.ShouldEarlyOut();
	};
	shape->WalkBoxCastVoxels(cast_bounds, cast_direction, ioCollector.GetPositiveEarlyOutFraction(), visitor);
}

void JPHC_VoxelShape::sRegister()
{
	ShapeFunctions &f = ShapeFunctions::sGet(EShapeSubType::User1);
	f.mConstruct = []() -> Shape * { return new JPHC_VoxelShape; };
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

namespace {

static JPH::Vec3 ToJolt(const JPH_Vec3 *inVector)
{
	return inVector != nullptr? JPH::Vec3(inVector->x, inVector->y, inVector->z) : JPH::Vec3::sZero();
}

static JPH_Vec3 FromJolt(JPH::Vec3Arg inVector)
{
	JPH_Vec3 result;
	result.x = inVector.GetX();
	result.y = inVector.GetY();
	result.z = inVector.GetZ();
	return result;
}

static JPH_AABox FromJolt(const JPH::AABox &inBox)
{
	JPH_AABox result;
	result.min = FromJolt(inBox.mMin);
	result.max = FromJolt(inBox.mMax);
	return result;
}

struct VoxelVisitorForwarder
{
	JPH::JPHC_VoxelShapeDataVisitor *mVisitor;
};

static bool JPH_API_CALL VisitVoxelThunk(void *inUserData, uint32_t inX, uint32_t inY, uint32_t inZ, JPH_SubShapeID inVoxelIndex)
{
	VoxelVisitorForwarder *forwarder = static_cast<VoxelVisitorForwarder *>(inUserData);
	return forwarder->mVisitor->VisitVoxel(inX, inY, inZ, inVoxelIndex);
}

static bool JPH_API_CALL ShouldVisitRangeThunk(void *inUserData, uint32_t inMinX, uint32_t inMinY, uint32_t inMinZ, uint32_t inMaxX, uint32_t inMaxY, uint32_t inMaxZ)
{
	const JPH::JPHC_VoxelShapeDataRangeFilter *range_filter = static_cast<const JPH::JPHC_VoxelShapeDataRangeFilter *>(inUserData);
	return range_filter == nullptr || range_filter->ShouldVisitRange(inMinX, inMinY, inMinZ, inMaxX, inMaxY, inMaxZ);
}

class CallbackVoxelShapeData final : public JPH::JPHC_VoxelShapeDataInterface
{
public:
	CallbackVoxelShapeData(const JPH_VoxelShape_Procs &inProcs, void *inUserData) :
		mProcs(inProcs),
		mUserData(inUserData)
	{
	}

	virtual bool IsVoxelActive(JPH::uint inX, JPH::uint inY, JPH::uint inZ, JPH::SubShapeID::Type inVoxelIndex) const override
	{
		return mProcs.IsVoxelActive(mUserData, inX, inY, inZ, inVoxelIndex);
	}

	virtual bool VisitActiveVoxels(JPH::uint inMinX, JPH::uint inMinY, JPH::uint inMinZ, JPH::uint inMaxX, JPH::uint inMaxY, JPH::uint inMaxZ, JPH::uint inRequiredExposedFaces, JPH::JPHC_VoxelShapeDataVisitor &ioVisitor, const JPH::JPHC_VoxelShapeDataRangeFilter *inRangeFilter = nullptr) const override
	{
		VoxelVisitorForwarder forwarder { &ioVisitor };
		return mProcs.VisitActiveVoxels(mUserData, inMinX, inMinY, inMinZ, inMaxX, inMaxY, inMaxZ, inRequiredExposedFaces, inRangeFilter != nullptr? ShouldVisitRangeThunk : nullptr, const_cast<JPH::JPHC_VoxelShapeDataRangeFilter *>(inRangeFilter), VisitVoxelThunk, &forwarder);
	}

	virtual bool HasActiveVoxels(JPH::uint inMinX, JPH::uint inMinY, JPH::uint inMinZ, JPH::uint inMaxX, JPH::uint inMaxY, JPH::uint inMaxZ, JPH::uint inRequiredExposedFaces, const JPH::JPHC_VoxelShapeDataRangeFilter *inRangeFilter = nullptr) const override
	{
		return mProcs.HasActiveVoxels(mUserData, inMinX, inMinY, inMinZ, inMaxX, inMaxY, inMaxZ, inRequiredExposedFaces, inRangeFilter != nullptr? ShouldVisitRangeThunk : nullptr, const_cast<JPH::JPHC_VoxelShapeDataRangeFilter *>(inRangeFilter));
	}

	virtual bool CastRayClosest(const JPH::RayCast &inRay, float inMaxFraction, JPH::Vec3Arg inVoxelHalfExtent, JPH::uint inSizeX, JPH::uint inSizeY, JPH::uint inSizeZ, JPH::SubShapeID::Type &outVoxelIndex, float &outFraction) const override
	{
		JPH_Vec3 origin = FromJolt(inRay.mOrigin);
		JPH_Vec3 direction = FromJolt(inRay.mDirection);
		JPH_Vec3 voxel_half_extent = FromJolt(inVoxelHalfExtent);
		JPH_SubShapeID voxel_index = 0;
		float fraction = outFraction;
		if (!mProcs.CastRayClosest(mUserData, &origin, &direction, inMaxFraction, &voxel_half_extent, inSizeX, inSizeY, inSizeZ, &voxel_index, &fraction))
			return false;

		outVoxelIndex = voxel_index;
		outFraction = fraction;
		return true;
	}

	virtual bool VisitRayVoxels(const JPH::RayCast &inRay, float inMaxFraction, JPH::Vec3Arg inVoxelHalfExtent, JPH::uint inSizeX, JPH::uint inSizeY, JPH::uint inSizeZ, JPH::JPHC_VoxelShapeDataVisitor &ioVisitor) const override
	{
		JPH_Vec3 origin = FromJolt(inRay.mOrigin);
		JPH_Vec3 direction = FromJolt(inRay.mDirection);
		JPH_Vec3 voxel_half_extent = FromJolt(inVoxelHalfExtent);
		VoxelVisitorForwarder forwarder { &ioVisitor };
		return mProcs.VisitRayVoxels(mUserData, &origin, &direction, inMaxFraction, &voxel_half_extent, inSizeX, inSizeY, inSizeZ, VisitVoxelThunk, &forwarder);
	}

	virtual bool VisitBoxCastVoxels(const JPH::AABox &inStartBounds, JPH::Vec3Arg inDirection, float inMaxFraction, JPH::Vec3Arg inVoxelHalfExtent, JPH::uint inSizeX, JPH::uint inSizeY, JPH::uint inSizeZ, JPH::JPHC_VoxelShapeDataVisitor &ioVisitor) const override
	{
		JPH_AABox start_bounds = FromJolt(inStartBounds);
		JPH_Vec3 direction = FromJolt(inDirection);
		JPH_Vec3 voxel_half_extent = FromJolt(inVoxelHalfExtent);
		VoxelVisitorForwarder forwarder { &ioVisitor };
		return mProcs.VisitBoxCastVoxels(mUserData, &start_bounds, &direction, inMaxFraction, &voxel_half_extent, inSizeX, inSizeY, inSizeZ, VisitVoxelThunk, &forwarder);
	}

private:
	JPH_VoxelShape_Procs mProcs;
	void *mUserData;
};

static bool AreVoxelShapeProcsValid(const JPH_VoxelShape_Procs *inProcs)
{
	return inProcs != nullptr
		&& inProcs->IsVoxelActive != nullptr
		&& inProcs->VisitActiveVoxels != nullptr
		&& inProcs->HasActiveVoxels != nullptr
		&& inProcs->CastRayClosest != nullptr
		&& inProcs->VisitRayVoxels != nullptr
		&& inProcs->VisitBoxCastVoxels != nullptr;
}

static const JPH::JPHC_VoxelShape *AsVoxelShape(const JPH_Shape *inShape)
{
	const JPH::Shape *shape = reinterpret_cast<const JPH::Shape *>(inShape);
	if (shape == nullptr || shape->GetType() != JPH::EShapeType::User1 || shape->GetSubType() != JPH::EShapeSubType::User1)
		return nullptr;

	return static_cast<const JPH::JPHC_VoxelShape *>(shape);
}

} // namespace

bool JPH_VoxelShape_Register(void)
{
	JPH::JPHC_VoxelShape::sRegister();
	return true;
}

JPH_Shape *JPH_VoxelShape_Create(const JPH_VoxelShape_Procs *inProcs, void *inUserData, uint32_t inSizeX, uint32_t inSizeY, uint32_t inSizeZ, const JPH_Vec3 *inVoxelHalfExtent, float inConvexRadius)
{
	if (!AreVoxelShapeProcsValid(inProcs))
		return nullptr;

	uint64_t num_voxels = uint64_t(inSizeX) * uint64_t(inSizeY) * uint64_t(inSizeZ);
	if (num_voxels > uint64_t(UINT32_MAX) || inConvexRadius < 0.0f)
		return nullptr;

	JPH::Vec3 voxel_half_extent = inVoxelHalfExtent != nullptr? ToJolt(inVoxelHalfExtent) : JPH::Vec3::sReplicate(0.5f);
	if (voxel_half_extent.ReduceMin() < 0.0f)
		return nullptr;

	JPH_VoxelShape_Register();

	auto data = std::make_unique<CallbackVoxelShapeData>(*inProcs, inUserData);
	JPH::JPHC_VoxelShape *shape = new JPH::JPHC_VoxelShape(std::move(data), inSizeX, inSizeY, inSizeZ, voxel_half_extent, inConvexRadius);
	shape->AddRef();
	return reinterpret_cast<JPH_Shape *>(shape);
}

uint32_t JPH_VoxelShape_GetSizeX(const JPH_Shape *inShape)
{
	const JPH::JPHC_VoxelShape *shape = AsVoxelShape(inShape);
	return shape != nullptr? shape->GetSizeX() : 0;
}

uint32_t JPH_VoxelShape_GetSizeY(const JPH_Shape *inShape)
{
	const JPH::JPHC_VoxelShape *shape = AsVoxelShape(inShape);
	return shape != nullptr? shape->GetSizeY() : 0;
}

uint32_t JPH_VoxelShape_GetSizeZ(const JPH_Shape *inShape)
{
	const JPH::JPHC_VoxelShape *shape = AsVoxelShape(inShape);
	return shape != nullptr? shape->GetSizeZ() : 0;
}

void JPH_VoxelShape_GetVoxelHalfExtent(const JPH_Shape *inShape, JPH_Vec3 *outHalfExtent)
{
	if (outHalfExtent == nullptr)
		return;

	const JPH::JPHC_VoxelShape *shape = AsVoxelShape(inShape);
	*outHalfExtent = shape != nullptr? FromJolt(shape->GetVoxelHalfExtent()) : JPH_Vec3 { 0.0f, 0.0f, 0.0f };
}

float JPH_VoxelShape_GetConvexRadius(const JPH_Shape *inShape)
{
	const JPH::JPHC_VoxelShape *shape = AsVoxelShape(inShape);
	return shape != nullptr? shape->GetConvexRadius() : 0.0f;
}

void JPH_VoxelShape_SetRecordTouchedVoxels(bool inEnabled)
{
#ifdef JPH_DEBUG_RENDERER
	JPH::JPHC_VoxelShape::sRecordTouchedVoxels = inEnabled;
#else
	JPH_UNUSED(inEnabled);
#endif
}

void JPH_VoxelShape_SetDrawTouchedVoxels(bool inEnabled)
{
#ifdef JPH_DEBUG_RENDERER
	JPH::JPHC_VoxelShape::sDrawTouchedVoxels = inEnabled;
#else
	JPH_UNUSED(inEnabled);
#endif
}

void JPH_VoxelShape_ClearTouchedVoxels(const JPH_Shape *inShape)
{
#ifdef JPH_DEBUG_RENDERER
	const JPH::JPHC_VoxelShape *shape = AsVoxelShape(inShape);
	if (shape != nullptr)
		shape->ClearTouchedVoxels();
#else
	JPH_UNUSED(inShape);
#endif
}

uint32_t JPH_VoxelShape_GetTouchedVoxelCount(const JPH_Shape *inShape)
{
#ifdef JPH_DEBUG_RENDERER
	const JPH::JPHC_VoxelShape *shape = AsVoxelShape(inShape);
	return shape != nullptr? uint32_t(shape->GetTouchedVoxels().size()) : 0;
#else
	JPH_UNUSED(inShape);
	return 0;
#endif
}

uint32_t JPH_VoxelShape_GetTouchedVoxels(const JPH_Shape *inShape, JPH_SubShapeID *outVoxelIndices, uint32_t inMaxCount)
{
#ifdef JPH_DEBUG_RENDERER
	const JPH::JPHC_VoxelShape *shape = AsVoxelShape(inShape);
	if (shape == nullptr || outVoxelIndices == nullptr || inMaxCount == 0)
		return 0;

	const JPH::Array<JPH::SubShapeID::Type> &touched_voxels = shape->GetTouchedVoxels();
	uint32_t count = JPH::min(uint32_t(touched_voxels.size()), inMaxCount);
	for (uint32_t i = 0; i < count; ++i)
		outVoxelIndices[i] = touched_voxels[i];
	return count;
#else
	JPH_UNUSED(inShape);
	JPH_UNUSED(outVoxelIndices);
	JPH_UNUSED(inMaxCount);
	return 0;
#endif
}

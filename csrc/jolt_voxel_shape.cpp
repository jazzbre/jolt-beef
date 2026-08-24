// Jolt Physics Library (https://github.com/jrouwe/JoltPhysics)
// SPDX-FileCopyrightText: 2026 Jorrit Rouwe
// SPDX-License-Identifier: MIT

// C ABI for VoxelShape. The shape itself is VoxelShape.cpp next to this file, compiled
// into the Jolt target by jolt_cmake.patch so that the samples testbed and this wrapper
// use one implementation rather than two copies that have to be kept in step by hand;
// everything here is the callback adapter that turns a set of C function pointers into
// a VoxelShapeDataInterface.

#include <Jolt/Jolt.h>

#include "jolt_voxel_shape.h"
#include "jolt_voxel_shape_c.h"

namespace {

	static JPH::Vec3 ToJolt(const JPH_Vec3* inVector)
	{
		return inVector != nullptr ? JPH::Vec3(inVector->x, inVector->y, inVector->z) : JPH::Vec3::sZero();
	}

	static JPH_Vec3 FromJolt(JPH::Vec3Arg inVector)
	{
		JPH_Vec3 result;
		result.x = inVector.GetX();
		result.y = inVector.GetY();
		result.z = inVector.GetZ();
		return result;
	}

	static JPH_AABox FromJolt(const JPH::AABox& inBox)
	{
		JPH_AABox result;
		result.min = FromJolt(inBox.mMin);
		result.max = FromJolt(inBox.mMax);
		return result;
	}

	struct VoxelVisitorForwarder
	{
		JPH::VoxelShapeDataVisitor* mVisitor;
	};

	struct VoxelRangeVisitorForwarder
	{
		JPH::VoxelShapeDataRangeVisitor* mVisitor;
	};

	static bool JPH_API_CALL VisitVoxelThunk(void* inUserData, uint32_t inX, uint32_t inY, uint32_t inZ, JPH_SubShapeID inVoxelIndex)
	{
		VoxelVisitorForwarder* forwarder = static_cast<VoxelVisitorForwarder*>(inUserData);
		return forwarder->mVisitor->VisitVoxel(inX, inY, inZ, inVoxelIndex);
	}

	static bool JPH_API_CALL VisitRangeThunk(void* inUserData, uint32_t inMinX, uint32_t inMinY, uint32_t inMinZ, uint32_t inMaxX, uint32_t inMaxY, uint32_t inMaxZ)
	{
		VoxelRangeVisitorForwarder* forwarder = static_cast<VoxelRangeVisitorForwarder*>(inUserData);
		return forwarder->mVisitor->VisitRange(inMinX, inMinY, inMinZ, inMaxX, inMaxY, inMaxZ);
	}

	static bool JPH_API_CALL ShouldVisitRangeThunk(void* inUserData, uint32_t inMinX, uint32_t inMinY, uint32_t inMinZ, uint32_t inMaxX, uint32_t inMaxY, uint32_t inMaxZ)
	{
		const JPH::VoxelShapeDataRangeFilter* range_filter = static_cast<const JPH::VoxelShapeDataRangeFilter*>(inUserData);
		return range_filter == nullptr || range_filter->ShouldVisitRange(inMinX, inMinY, inMinZ, inMaxX, inMaxY, inMaxZ);
	}

	class CallbackVoxelShapeData final : public JPH::VoxelShapeDataInterface
	{
	public:
		CallbackVoxelShapeData(const JPH_VoxelShape_Procs& inProcs, void* inUserData) :
			mProcs(inProcs),
			mUserData(inUserData)
		{
		}

		virtual bool IsVoxelActive(JPH::uint inX, JPH::uint inY, JPH::uint inZ, JPH::SubShapeID::Type inVoxelIndex) const override
		{
			return mProcs.IsVoxelActive(mUserData, inX, inY, inZ, inVoxelIndex);
		}

		virtual bool VisitActiveVoxels(JPH::uint inMinX, JPH::uint inMinY, JPH::uint inMinZ, JPH::uint inMaxX, JPH::uint inMaxY, JPH::uint inMaxZ, JPH::uint inRequiredExposedFaces, JPH::VoxelShapeDataVisitor& ioVisitor, const JPH::VoxelShapeDataRangeFilter* inRangeFilter = nullptr) const override
		{
			VoxelVisitorForwarder forwarder{ &ioVisitor };
			return mProcs.VisitActiveVoxels(mUserData, inMinX, inMinY, inMinZ, inMaxX, inMaxY, inMaxZ, inRequiredExposedFaces, inRangeFilter != nullptr ? ShouldVisitRangeThunk : nullptr, const_cast<JPH::VoxelShapeDataRangeFilter*>(inRangeFilter), VisitVoxelThunk, &forwarder);
		}

		virtual bool HasActiveVoxels(JPH::uint inMinX, JPH::uint inMinY, JPH::uint inMinZ, JPH::uint inMaxX, JPH::uint inMaxY, JPH::uint inMaxZ, JPH::uint inRequiredExposedFaces, const JPH::VoxelShapeDataRangeFilter* inRangeFilter = nullptr) const override
		{
			return mProcs.HasActiveVoxels(mUserData, inMinX, inMinY, inMinZ, inMaxX, inMaxY, inMaxZ, inRequiredExposedFaces, inRangeFilter != nullptr ? ShouldVisitRangeThunk : nullptr, const_cast<JPH::VoxelShapeDataRangeFilter*>(inRangeFilter));
		}

		virtual bool VisitActiveVoxelRanges(JPH::uint inMinX, JPH::uint inMinY, JPH::uint inMinZ, JPH::uint inMaxX, JPH::uint inMaxY, JPH::uint inMaxZ, JPH::uint inRequiredExposedFaces, JPH::VoxelShapeDataRangeVisitor& ioVisitor, const JPH::VoxelShapeDataRangeFilter* inRangeFilter = nullptr) const override
		{
			VoxelRangeVisitorForwarder forwarder{ &ioVisitor };
			return mProcs.VisitActiveVoxelRanges(mUserData, inMinX, inMinY, inMinZ, inMaxX, inMaxY, inMaxZ, inRequiredExposedFaces, inRangeFilter != nullptr ? ShouldVisitRangeThunk : nullptr, const_cast<JPH::VoxelShapeDataRangeFilter*>(inRangeFilter), VisitRangeThunk, &forwarder);
		}

		virtual bool CastRayClosest(const JPH::RayCast& inRay, float inMaxFraction, JPH::Vec3Arg inVoxelHalfExtent, JPH::uint inSizeX, JPH::uint inSizeY, JPH::uint inSizeZ, JPH::SubShapeID::Type& outVoxelIndex, float& outFraction) const override
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

		virtual bool VisitRayVoxels(const JPH::RayCast& inRay, float inMaxFraction, JPH::Vec3Arg inVoxelHalfExtent, JPH::uint inSizeX, JPH::uint inSizeY, JPH::uint inSizeZ, JPH::VoxelShapeDataVisitor& ioVisitor) const override
		{
			JPH_Vec3 origin = FromJolt(inRay.mOrigin);
			JPH_Vec3 direction = FromJolt(inRay.mDirection);
			JPH_Vec3 voxel_half_extent = FromJolt(inVoxelHalfExtent);
			VoxelVisitorForwarder forwarder{ &ioVisitor };
			return mProcs.VisitRayVoxels(mUserData, &origin, &direction, inMaxFraction, &voxel_half_extent, inSizeX, inSizeY, inSizeZ, VisitVoxelThunk, &forwarder);
		}

		virtual bool VisitBoxCastVoxels(const JPH::AABox& inStartBounds, JPH::Vec3Arg inDirection, float inMaxFraction, JPH::Vec3Arg inVoxelHalfExtent, JPH::uint inSizeX, JPH::uint inSizeY, JPH::uint inSizeZ, JPH::VoxelShapeDataVisitor& ioVisitor) const override
		{
			JPH_AABox start_bounds = FromJolt(inStartBounds);
			JPH_Vec3 direction = FromJolt(inDirection);
			JPH_Vec3 voxel_half_extent = FromJolt(inVoxelHalfExtent);
			VoxelVisitorForwarder forwarder{ &ioVisitor };
			return mProcs.VisitBoxCastVoxels(mUserData, &start_bounds, &direction, inMaxFraction, &voxel_half_extent, inSizeX, inSizeY, inSizeZ, VisitVoxelThunk, &forwarder);
		}

	private:
		JPH_VoxelShape_Procs mProcs;
		void* mUserData;
	};

	static bool AreVoxelShapeProcsValid(const JPH_VoxelShape_Procs* inProcs)
	{
		return inProcs != nullptr
			&& inProcs->IsVoxelActive != nullptr
			&& inProcs->VisitActiveVoxels != nullptr
			&& inProcs->HasActiveVoxels != nullptr
			&& inProcs->VisitActiveVoxelRanges != nullptr
			&& inProcs->CastRayClosest != nullptr
			&& inProcs->VisitRayVoxels != nullptr
			&& inProcs->VisitBoxCastVoxels != nullptr;
	}

	static const JPH::VoxelShape* AsVoxelShape(const JPH_Shape* inShape)
	{
		const JPH::Shape* shape = reinterpret_cast<const JPH::Shape*>(inShape);
		if (shape == nullptr || shape->GetType() != JPH::EShapeType::User1 || shape->GetSubType() != JPH::EShapeSubType::User1)
			return nullptr;

		return static_cast<const JPH::VoxelShape*>(shape);
	}

} // namespace

bool JPH_VoxelShape_Register(void)
{
	JPH::VoxelShape::sRegister();
	return true;
}

JPH_Shape* JPH_VoxelShape_Create(const JPH_VoxelShape_Procs* inProcs, void* inUserData, uint32_t inSizeX, uint32_t inSizeY, uint32_t inSizeZ, const JPH_Vec3* inVoxelHalfExtent, float inConvexRadius)
{
	if (!AreVoxelShapeProcsValid(inProcs))
		return nullptr;

	uint64_t num_voxels = uint64_t(inSizeX) * uint64_t(inSizeY) * uint64_t(inSizeZ);
	if (num_voxels > uint64_t(UINT32_MAX) || inConvexRadius < 0.0f)
		return nullptr;

	JPH::Vec3 voxel_half_extent = inVoxelHalfExtent != nullptr ? ToJolt(inVoxelHalfExtent) : JPH::Vec3::sReplicate(0.5f);
	if (voxel_half_extent.ReduceMin() < 0.0f)
		return nullptr;

	JPH_VoxelShape_Register();

	auto data = std::make_unique<CallbackVoxelShapeData>(*inProcs, inUserData);
	JPH::VoxelShape* shape = new JPH::VoxelShape(std::move(data), inSizeX, inSizeY, inSizeZ, voxel_half_extent, inConvexRadius);
	shape->AddRef();
	return reinterpret_cast<JPH_Shape*>(shape);
}

uint32_t JPH_VoxelShape_GetSizeX(const JPH_Shape* inShape)
{
	const JPH::VoxelShape* shape = AsVoxelShape(inShape);
	return shape != nullptr ? shape->GetSizeX() : 0;
}

uint32_t JPH_VoxelShape_GetSizeY(const JPH_Shape* inShape)
{
	const JPH::VoxelShape* shape = AsVoxelShape(inShape);
	return shape != nullptr ? shape->GetSizeY() : 0;
}

uint32_t JPH_VoxelShape_GetSizeZ(const JPH_Shape* inShape)
{
	const JPH::VoxelShape* shape = AsVoxelShape(inShape);
	return shape != nullptr ? shape->GetSizeZ() : 0;
}

void JPH_VoxelShape_GetVoxelHalfExtent(const JPH_Shape* inShape, JPH_Vec3* outHalfExtent)
{
	if (outHalfExtent == nullptr)
		return;

	const JPH::VoxelShape* shape = AsVoxelShape(inShape);
	*outHalfExtent = shape != nullptr ? FromJolt(shape->GetVoxelHalfExtent()) : JPH_Vec3{ 0.0f, 0.0f, 0.0f };
}

float JPH_VoxelShape_GetConvexRadius(const JPH_Shape* inShape)
{
	const JPH::VoxelShape* shape = AsVoxelShape(inShape);
	return shape != nullptr ? shape->GetConvexRadius() : 0.0f;
}

void JPH_VoxelShape_SetRecordTouchedVoxels(bool inEnabled)
{
#ifdef JPH_DEBUG_RENDERER
	JPH::VoxelShape::sRecordTouchedVoxels = inEnabled;
#else
	JPH_UNUSED(inEnabled);
#endif
}

void JPH_VoxelShape_SetDrawTouchedVoxels(bool inEnabled)
{
#ifdef JPH_DEBUG_RENDERER
	JPH::VoxelShape::sDrawTouchedVoxels = inEnabled;
#else
	JPH_UNUSED(inEnabled);
#endif
}

void JPH_VoxelShape_ClearTouchedVoxels(const JPH_Shape* inShape)
{
#ifdef JPH_DEBUG_RENDERER
	const JPH::VoxelShape* shape = AsVoxelShape(inShape);
	if (shape != nullptr)
		shape->ClearTouchedVoxels();
#else
	JPH_UNUSED(inShape);
#endif
}

uint32_t JPH_VoxelShape_GetTouchedVoxelCount(const JPH_Shape* inShape)
{
#ifdef JPH_DEBUG_RENDERER
	const JPH::VoxelShape* shape = AsVoxelShape(inShape);
	return shape != nullptr ? uint32_t(shape->GetTouchedVoxels().size()) : 0;
#else
	JPH_UNUSED(inShape);
	return 0;
#endif
}

uint32_t JPH_VoxelShape_GetTouchedVoxels(const JPH_Shape* inShape, JPH_SubShapeID* outVoxelIndices, uint32_t inMaxCount)
{
#ifdef JPH_DEBUG_RENDERER
	const JPH::VoxelShape* shape = AsVoxelShape(inShape);
	if (shape == nullptr || outVoxelIndices == nullptr || inMaxCount == 0)
		return 0;

	const JPH::Array<JPH::SubShapeID::Type>& touched_voxels = shape->GetTouchedVoxels();
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

uint64_t JPH_VoxelShape_GetVoxelIndexFromSubShapeID(const JPH_Shape* inShape, JPH_SubShapeID inSubShapeID) {
	const JPH::VoxelShape* shape = AsVoxelShape(inShape);
	JPH::SubShapeID subShapeId;
	subShapeId.SetValue((JPH::SubShapeID::Type)inSubShapeID);
	return shape->GetSubShapeUserData(subShapeId);
}
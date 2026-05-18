#pragma once

#include "joltc.h"

#ifdef __cplusplus
extern "C" {
#endif

typedef bool(JPH_API_CALL *JPH_VoxelShape_VisitVoxelCallback)(void *userData, uint32_t x, uint32_t y, uint32_t z, JPH_SubShapeID voxelIndex);
typedef bool(JPH_API_CALL *JPH_VoxelShape_ShouldVisitRangeCallback)(void *userData, uint32_t minX, uint32_t minY, uint32_t minZ, uint32_t maxX, uint32_t maxY, uint32_t maxZ);

typedef struct JPH_VoxelShape_Procs {
	bool(JPH_API_CALL *IsVoxelActive)(void *userData, uint32_t x, uint32_t y, uint32_t z, JPH_SubShapeID voxelIndex);
	bool(JPH_API_CALL *VisitActiveVoxels)(void *userData, uint32_t minX, uint32_t minY, uint32_t minZ, uint32_t maxX, uint32_t maxY, uint32_t maxZ, uint32_t requiredExposedFaces, JPH_VoxelShape_ShouldVisitRangeCallback rangeFilter, void *rangeFilterUserData, JPH_VoxelShape_VisitVoxelCallback visitor, void *visitorUserData);
	bool(JPH_API_CALL *HasActiveVoxels)(void *userData, uint32_t minX, uint32_t minY, uint32_t minZ, uint32_t maxX, uint32_t maxY, uint32_t maxZ, uint32_t requiredExposedFaces, JPH_VoxelShape_ShouldVisitRangeCallback rangeFilter, void *rangeFilterUserData);
	bool(JPH_API_CALL *CastRayClosest)(void *userData, const JPH_Vec3 *origin, const JPH_Vec3 *direction, float maxFraction, const JPH_Vec3 *voxelHalfExtent, uint32_t sizeX, uint32_t sizeY, uint32_t sizeZ, JPH_SubShapeID *outVoxelIndex, float *outFraction);
	bool(JPH_API_CALL *VisitRayVoxels)(void *userData, const JPH_Vec3 *origin, const JPH_Vec3 *direction, float maxFraction, const JPH_Vec3 *voxelHalfExtent, uint32_t sizeX, uint32_t sizeY, uint32_t sizeZ, JPH_VoxelShape_VisitVoxelCallback visitor, void *visitorUserData);
	bool(JPH_API_CALL *VisitBoxCastVoxels)(void *userData, const JPH_AABox *startBounds, const JPH_Vec3 *direction, float maxFraction, const JPH_Vec3 *voxelHalfExtent, uint32_t sizeX, uint32_t sizeY, uint32_t sizeZ, JPH_VoxelShape_VisitVoxelCallback visitor, void *visitorUserData);
} JPH_VoxelShape_Procs;

JPH_CAPI bool JPH_VoxelShape_Register(void);
JPH_CAPI JPH_Shape *JPH_VoxelShape_Create(const JPH_VoxelShape_Procs *procs, void *userData, uint32_t sizeX, uint32_t sizeY, uint32_t sizeZ, const JPH_Vec3 *voxelHalfExtent, float convexRadius);
JPH_CAPI uint32_t JPH_VoxelShape_GetSizeX(const JPH_Shape *shape);
JPH_CAPI uint32_t JPH_VoxelShape_GetSizeY(const JPH_Shape *shape);
JPH_CAPI uint32_t JPH_VoxelShape_GetSizeZ(const JPH_Shape *shape);
JPH_CAPI void JPH_VoxelShape_GetVoxelHalfExtent(const JPH_Shape *shape, JPH_Vec3 *halfExtent);
JPH_CAPI float JPH_VoxelShape_GetConvexRadius(const JPH_Shape *shape);
JPH_CAPI void JPH_VoxelShape_SetRecordTouchedVoxels(bool enabled);
JPH_CAPI void JPH_VoxelShape_SetDrawTouchedVoxels(bool enabled);
JPH_CAPI void JPH_VoxelShape_ClearTouchedVoxels(const JPH_Shape *shape);
JPH_CAPI uint32_t JPH_VoxelShape_GetTouchedVoxelCount(const JPH_Shape *shape);
JPH_CAPI uint32_t JPH_VoxelShape_GetTouchedVoxels(const JPH_Shape *shape, JPH_SubShapeID *outVoxelIndices, uint32_t maxCount);

#ifdef __cplusplus
}
#endif

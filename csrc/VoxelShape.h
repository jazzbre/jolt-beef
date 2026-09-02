// Jolt Physics Library (https://github.com/jrouwe/JoltPhysics)
// SPDX-FileCopyrightText: 2026 Jorrit Rouwe
// SPDX-License-Identifier: MIT

#pragma once

#include <Jolt/Physics/Collision/Shape/Shape.h>
#include <Jolt/Physics/Collision/Shape/ScaleHelpers.h>
#include <Jolt/Physics/Collision/Shape/SubShapeID.h>
#include <Jolt/Physics/Collision/RayCast.h>
#include <Jolt/Physics/PhysicsSettings.h>

#include <memory>

JPH_NAMESPACE_BEGIN

class CollideShapeSettings;
class BoxShape;
template <class Visitor> class VoxelDataVisitorAdapter;
template <class Visitor> class VoxelDataRangeVisitorAdapter;

/// Visitor interface for accelerated voxel data backends.
class JPH_EXPORT VoxelShapeDataVisitor
{
public:
	virtual					~VoxelShapeDataVisitor() = default;

	/// Return false to stop visiting.
	virtual bool			VisitVoxel(uint inX, uint inY, uint inZ, SubShapeID::Type inVoxelIndex) = 0;
};

/// Optional coarse range filter for accelerated voxel data backends.
class JPH_EXPORT VoxelShapeDataRangeFilter
{
public:
	virtual					~VoxelShapeDataRangeFilter() = default;

	/// Return false to skip all voxels in [min, max).
	virtual bool			ShouldVisitRange(uint inMinX, uint inMinY, uint inMinZ, uint inMaxX, uint inMaxY, uint inMaxZ) const = 0;
};

/// Visitor for occupied voxel ranges. Every voxel in a reported range must be an active
/// collision voxel: the voxel against voxel narrow phase collides a whole range at once
/// rather than walking it again, so a range covering anything else invents contacts.
class JPH_EXPORT VoxelShapeDataRangeVisitor
{
public:
	virtual					~VoxelShapeDataRangeVisitor() = default;

	/// Return false to stop visiting.
	virtual bool			VisitRange(uint inMinX, uint inMinY, uint inMinZ, uint inMaxX, uint inMaxY, uint inMaxZ) = 0;
};

/// Non-owned interface that lets VoxelShape query external voxel/chunk data.
class JPH_EXPORT VoxelShapeDataInterface
{
public:
	virtual					~VoxelShapeDataInterface() = default;

	/// Returns true if the voxel is solid.
	virtual bool			IsVoxelActive(uint inX, uint inY, uint inZ, SubShapeID::Type inVoxelIndex) const = 0;

	/// Visit active voxels in [min, max). Return false if traversal was aborted by the visitor.
	virtual bool			VisitActiveVoxels(uint inMinX, uint inMinY, uint inMinZ, uint inMaxX, uint inMaxY, uint inMaxZ, uint inRequiredExposedFaces, VoxelShapeDataVisitor &ioVisitor, const VoxelShapeDataRangeFilter *inRangeFilter = nullptr) const = 0;

	/// Return true if the range contains at least one active collision voxel.
	virtual bool			HasActiveVoxels(uint inMinX, uint inMinY, uint inMinZ, uint inMaxX, uint inMaxY, uint inMaxZ, uint inRequiredExposedFaces, const VoxelShapeDataRangeFilter *inRangeFilter = nullptr) const = 0;

	/// Visit occupied voxel ranges in [min, max). Return false if traversal was aborted by the visitor.
	virtual bool			VisitActiveVoxelRanges(uint inMinX, uint inMinY, uint inMinZ, uint inMaxX, uint inMaxY, uint inMaxZ, uint inRequiredExposedFaces, VoxelShapeDataRangeVisitor &ioVisitor, const VoxelShapeDataRangeFilter *inRangeFilter = nullptr) const = 0;

	/// Closest ray cast. Must return the first active voxel hit by the ray and a Jolt ray fraction.
	virtual bool			CastRayClosest(const RayCast &inRay, float inMaxFraction, Vec3Arg inVoxelHalfExtent, uint inSizeX, uint inSizeY, uint inSizeZ, SubShapeID::Type &outVoxelIndex, float &outFraction) const = 0;

	/// Visit ray voxels in front-to-back ray order. Return false if traversal was aborted by the visitor.
	virtual bool			VisitRayVoxels(const RayCast &inRay, float inMaxFraction, Vec3Arg inVoxelHalfExtent, uint inSizeX, uint inSizeY, uint inSizeZ, VoxelShapeDataVisitor &ioVisitor) const = 0;

	/// Visit swept-box voxels. Return false if traversal was aborted by the visitor.
	virtual bool			VisitBoxCastVoxels(const AABox &inStartBounds, Vec3Arg inDirection, float inMaxFraction, Vec3Arg inVoxelHalfExtent, uint inSizeX, uint inSizeY, uint inSizeZ, VoxelShapeDataVisitor &ioVisitor) const = 0;
};

/// Class that constructs a VoxelShape.
/// This is currently a placeholder shape that treats every occupied voxel as a box.
/// The voxel data interface pointer is not owned by the shape and must remain valid for the lifetime of the shape.
class JPH_EXPORT VoxelShapeSettings final : public ShapeSettings
{
public:
	/// Default constructor for deserialization
							VoxelShapeSettings() = default;

	/// Create a voxel shape backed by an external voxel data interface.
							VoxelShapeSettings(const VoxelShapeDataInterface *inVoxelDataInterface, uint inSizeX, uint inSizeY, uint inSizeZ, Vec3Arg inVoxelHalfExtent = Vec3::sReplicate(0.5f), float inConvexRadius = 0.0f);

	// See: ShapeSettings
	virtual ShapeResult		Create() const override;

	const VoxelShapeDataInterface *mVoxelDataInterface = nullptr;					///< Non-owned external voxel/chunk data interface
	uint					mSizeX = 0;
	uint					mSizeY = 0;
	uint					mSizeZ = 0;
	Vec3					mVoxelHalfExtent = Vec3::sReplicate(0.5f);				///< Half the size of each temporary voxel box
	float					mConvexRadius = 0.0f;
	uint					mVoxelIndexBits = 0;									///< Number of SubShapeID bits reserved for the voxel index
};

/// Placeholder shape for voxel collision. Each occupied voxel currently collides as a box.
class JPH_EXPORT VoxelShape final : public Shape
{
public:
	JPH_OVERRIDE_NEW_DELETE

	/// Constructor
							VoxelShape() : Shape(EShapeType::User1, EShapeSubType::User1) { }
							VoxelShape(const VoxelShapeSettings &inSettings, ShapeResult &outResult);

	/// Create a voxel shape backed by an external voxel data interface.
							VoxelShape(const VoxelShapeDataInterface *inVoxelDataInterface, uint inSizeX, uint inSizeY, uint inSizeZ, Vec3Arg inVoxelHalfExtent = Vec3::sReplicate(0.5f), float inConvexRadius = 0.0f);

	/// Create a voxel shape that owns its external voxel data interface adapter. The C API
	/// builds one adapter per shape and has nowhere else to keep it alive.
							VoxelShape(std::unique_ptr<const VoxelShapeDataInterface> inVoxelDataInterface, uint inSizeX, uint inSizeY, uint inSizeZ, Vec3Arg inVoxelHalfExtent = Vec3::sReplicate(0.5f), float inConvexRadius = 0.0f);

	/// Get half extent of each temporary voxel box
	Vec3					GetVoxelHalfExtent() const								{ return mVoxelHalfExtent; }

	/// Get the convex radius of each temporary voxel box
	float					GetConvexRadius() const									{ return mConvexRadius; }

	/// Get the size of the voxel data
	uint					GetSizeX() const										{ return mSizeX; }
	uint					GetSizeY() const										{ return mSizeY; }
	uint					GetSizeZ() const										{ return mSizeZ; }

	/// Decode a voxel index from a sub shape ID
	SubShapeID::Type		GetVoxelIndex(const SubShapeID &inSubShapeID, SubShapeID &outRemainder) const { return inSubShapeID.PopID(mVoxelIndexBits, outRemainder); }

	/// Number of SubShapeID bits used to encode the voxel index
	uint					GetVoxelIndexBits() const								{ return mVoxelIndexBits; }

	/// Calculate the number of SubShapeID bits required to encode all voxel indices
	static uint				sCalculateVoxelIndexBits(uint inSizeX, uint inSizeY, uint inSizeZ);

	/// Recomputes the bounds of the active voxels, which GetLocalBounds then reports in
	/// place of the whole grid. A rock filling a third of its grid presents a broadphase
	/// box a third the size, and the collide range walks are derived from these bounds too.
	///
	/// Safe to leave stale: voxels are only ever removed, so an old box can only be larger
	/// than the truth, never smaller, and larger costs work rather than correctness.
	void					RefreshActiveBounds();

	// See Shape
	virtual AABox			GetLocalBounds() const override;
	virtual uint			GetSubShapeIDBitsRecursive() const override				{ return mVoxelIndexBits; }
	virtual float			GetInnerRadius() const override							{ return mVoxelHalfExtent.ReduceMin(); }
	virtual MassProperties	GetMassProperties() const override;
	virtual const Shape *	GetLeafShape(const SubShapeID &inSubShapeID, SubShapeID &outRemainder) const override;
	virtual const PhysicsMaterial *GetMaterial(const SubShapeID &inSubShapeID) const override;
	virtual uint64			GetSubShapeUserData(const SubShapeID &inSubShapeID) const override;
	virtual Vec3			GetSurfaceNormal(const SubShapeID &inSubShapeID, Vec3Arg inLocalSurfacePosition) const override;
	virtual void			GetSupportingFace(const SubShapeID &inSubShapeID, Vec3Arg inDirection, Vec3Arg inScale, Mat44Arg inCenterOfMassTransform, SupportingFace &outVertices) const override;
	virtual void			GetSubmergedVolume(Mat44Arg inCenterOfMassTransform, Vec3Arg inScale, const Plane &inSurface, float &outTotalVolume, float &outSubmergedVolume, Vec3 &outCenterOfBuoyancy JPH_IF_DEBUG_RENDERER(, RVec3Arg inBaseOffset)) const override;
#ifdef JPH_DEBUG_RENDERER
	virtual void			Draw(DebugRenderer *inRenderer, RMat44Arg inCenterOfMassTransform, Vec3Arg inScale, ColorArg inColor, bool inUseMaterialColors, bool inDrawWireframe) const override;

	/// When enabled, every active voxel visited by WalkVoxels is stored in mTouchedVoxels.
	static bool				sRecordTouchedVoxels;

	/// When enabled, Draw overlays recorded touched voxels.
	static bool				sDrawTouchedVoxels;

	/// Clear the recorded touched voxel list. Call before the query/update you want to inspect.
	void					ClearTouchedVoxels() const								{ mTouchedVoxels.clear(); }

	/// Get the flat voxel indices that were touched since the last ClearTouchedVoxels call.
	const Array<SubShapeID::Type> &GetTouchedVoxels() const							{ return mTouchedVoxels; }
#endif // JPH_DEBUG_RENDERER
	virtual bool			CastRay(const RayCast &inRay, const SubShapeIDCreator &inSubShapeIDCreator, RayCastResult &ioHit) const override;
	virtual void			CastRay(const RayCast &inRay, const RayCastSettings &inRayCastSettings, const SubShapeIDCreator &inSubShapeIDCreator, CastRayCollector &ioCollector, const ShapeFilter &inShapeFilter = { }) const override;
	virtual void			CollidePoint(Vec3Arg inPoint, const SubShapeIDCreator &inSubShapeIDCreator, CollidePointCollector &ioCollector, const ShapeFilter &inShapeFilter = { }) const override;
	virtual void			CollideSoftBodyVertices(Mat44Arg inCenterOfMassTransform, Vec3Arg inScale, const CollideSoftBodyVertexIterator &inVertices, uint inNumVertices, int inCollidingShapeIndex) const override;
	virtual void			CollectTransformedShapes(const AABox &inBox, Vec3Arg inPositionCOM, QuatArg inRotation, Vec3Arg inScale, const SubShapeIDCreator &inSubShapeIDCreator, TransformedShapeCollector &ioCollector, const ShapeFilter &inShapeFilter) const override;
	virtual void			GetTrianglesStart(GetTrianglesContext &ioContext, const AABox &inBox, Vec3Arg inPositionCOM, QuatArg inRotation, Vec3Arg inScale) const override;
	virtual int				GetTrianglesNext(GetTrianglesContext &ioContext, int inMaxTrianglesRequested, Float3 *outTriangleVertices, const PhysicsMaterial **outMaterials = nullptr) const override;
	virtual Stats			GetStats() const override;
	virtual float			GetVolume() const override;
	virtual bool			IsValidScale(Vec3Arg inScale) const override			{ return !ScaleHelpers::IsZeroScale(inScale); }

	// Register shape functions with the registry
	static void				sRegister();

private:
	template <class Visitor> friend class VoxelDataVisitorAdapter;
	template <class Visitor> friend class VoxelDataRangeVisitorAdapter;
	friend class			WorldBoundsVoxelRangeFilter;

	class					VoxelShapeFilter;
	struct					GetTrianglesContextVoxel;
	struct					VoxelRange;

	template <class Visitor>
	void					WalkVoxels(Visitor &ioVisitor, bool inRecordTouchedVoxels = true) const;

	template <class Visitor>
	void					WalkVoxels(const VoxelRange &inRange, Visitor &ioVisitor, bool inRecordTouchedVoxels = true, uint inRequiredExposedFaces = 0, const VoxelShapeDataRangeFilter *inRangeFilter = nullptr) const;

	template <class Visitor>
	void					WalkVoxelRanges(const VoxelRange &inRange, Visitor &ioVisitor, uint inRequiredExposedFaces = 0, const VoxelShapeDataRangeFilter *inRangeFilter = nullptr) const;

	template <class Visitor>
	void					WalkRayVoxels(const RayCast &inRay, float inMaxFraction, Visitor &ioVisitor) const;

	template <class Visitor>
	void					WalkBoxCastVoxels(const AABox &inStartBounds, Vec3Arg inDirection, float inMaxFraction, Visitor &ioVisitor) const;

	/// Voxels overlapping inLocalBounds. Set inIncludeTouching when the box was mapped in
	/// from another grid and a voxel meeting it in a single plane still has to be named.
	VoxelRange				GetVoxelRangeOverlappingLocalBounds(const AABox &inLocalBounds, bool inIncludeTouching = false) const;
	AABox					GetVoxelRangeLocalBounds(uint inMinX, uint inMinY, uint inMinZ, uint inMaxX, uint inMaxY, uint inMaxZ) const;
	bool					HasActiveVoxels(const VoxelRange &inRange, uint inRequiredExposedFaces = 0, const VoxelShapeDataRangeFilter *inRangeFilter = nullptr) const;
	uint					GetRequiredExposedFacesForBounds(const AABox &inLocalBounds) const;
	bool					IsVoxelActive(SubShapeID::Type inVoxelIndex) const;
	bool					IsVoxelActive(uint inX, uint inY, uint inZ, SubShapeID::Type inVoxelIndex) const;
	Vec3					GetVoxelCenter(SubShapeID::Type inVoxelIndex) const;
	Vec3					GetVoxelCenter(uint inX, uint inY, uint inZ) const;
#ifdef JPH_DEBUG_RENDERER
	void					RecordTouchedVoxel(SubShapeID::Type inVoxelIndex) const;
#endif // JPH_DEBUG_RENDERER
	SubShapeIDCreator		MakeVoxelSubShapeIDCreator(const SubShapeIDCreator &inSubShapeIDCreator, SubShapeID::Type inVoxelIndex) const;
	BoxShape				CreateBoxShape() const;

	static void				sCollideVoxelVsShape(const Shape *inShape1, const Shape *inShape2, Vec3Arg inScale1, Vec3Arg inScale2, Mat44Arg inCenterOfMassTransform1, Mat44Arg inCenterOfMassTransform2, const SubShapeIDCreator &inSubShapeIDCreator1, const SubShapeIDCreator &inSubShapeIDCreator2, const CollideShapeSettings &inCollideShapeSettings, CollideShapeCollector &ioCollector, const ShapeFilter &inShapeFilter);
	static void				sCollideShapeVsVoxel(const Shape *inShape1, const Shape *inShape2, Vec3Arg inScale1, Vec3Arg inScale2, Mat44Arg inCenterOfMassTransform1, Mat44Arg inCenterOfMassTransform2, const SubShapeIDCreator &inSubShapeIDCreator1, const SubShapeIDCreator &inSubShapeIDCreator2, const CollideShapeSettings &inCollideShapeSettings, CollideShapeCollector &ioCollector, const ShapeFilter &inShapeFilter);
	static void				sCollideVoxelVsVoxel(const Shape *inShape1, const Shape *inShape2, Vec3Arg inScale1, Vec3Arg inScale2, Mat44Arg inCenterOfMassTransform1, Mat44Arg inCenterOfMassTransform2, const SubShapeIDCreator &inSubShapeIDCreator1, const SubShapeIDCreator &inSubShapeIDCreator2, const CollideShapeSettings &inCollideShapeSettings, CollideShapeCollector &ioCollector, const ShapeFilter &inShapeFilter);
	static void				sCastVoxelVsShape(const ShapeCast &inShapeCast, const ShapeCastSettings &inShapeCastSettings, const Shape *inShape, Vec3Arg inScale, const ShapeFilter &inShapeFilter, Mat44Arg inCenterOfMassTransform2, const SubShapeIDCreator &inSubShapeIDCreator1, const SubShapeIDCreator &inSubShapeIDCreator2, CastShapeCollector &ioCollector);
	static void				sCastShapeVsVoxel(const ShapeCast &inShapeCast, const ShapeCastSettings &inShapeCastSettings, const Shape *inShape, Vec3Arg inScale, const ShapeFilter &inShapeFilter, Mat44Arg inCenterOfMassTransform2, const SubShapeIDCreator &inSubShapeIDCreator1, const SubShapeIDCreator &inSubShapeIDCreator2, CastShapeCollector &ioCollector);

	const VoxelShapeDataInterface *mVoxelDataInterface = nullptr;
	std::unique_ptr<const VoxelShapeDataInterface> mOwnedVoxelDataInterface;
	uint					mSizeX = 0;
	uint					mSizeY = 0;
	uint					mSizeZ = 0;
	Vec3					mVoxelHalfExtent = Vec3::sReplicate(0.5f);
	float					mConvexRadius = 0.0f;
	uint					mVoxelIndexBits = 0;
	/// Only consulted once RefreshActiveBounds has run; until then the whole grid is
	/// reported, which is the conservative answer.
	AABox					mActiveBounds { Vec3::sZero(), Vec3::sZero() };
	bool					mActiveBoundsValid = false;
#ifdef JPH_DEBUG_RENDERER
	mutable Array<SubShapeID::Type> mTouchedVoxels;
#endif // JPH_DEBUG_RENDERER
};

JPH_NAMESPACE_END

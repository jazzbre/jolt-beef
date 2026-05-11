namespace Jolt;

using System;

public typealias Bool32 = uint32;
public typealias BodyID = uint32;
public typealias SubShapeID = uint32;
public typealias ObjectLayer = uint32;
public typealias BroadPhaseLayer = uint8;
public typealias CollisionGroupID = uint32;
public typealias CollisionSubGroupID = uint32;
public typealias CharacterID = uint32;
public typealias Color = uint32;

public typealias RVec3 = Vec3;
public typealias RMat4 = Mat4;
public typealias AssertFailureFunc = void*;
public typealias CastRayCollectorCallback = void*;
public typealias CastRayResultCallback = void*;
public typealias CastShapeCollectorCallback = void*;
public typealias CastShapeResultCallback = void*;
public typealias CollidePointCollectorCallback = void*;
public typealias CollidePointResultCallback = void*;
public typealias CollideShapeBodyCollectorCallback = void*;
public typealias CollideShapeBodyResultCallback = void*;
public typealias CollideShapeCollectorCallback = void*;
public typealias CollideShapeResultCallback = void*;
public typealias JobFunction = void*;
public typealias QueueJobCallback = void*;
public typealias QueueJobsCallback = void*;
public typealias RayCastBodyCollectorCallback = void*;
public typealias RayCastBodyResultCallback = void*;
public typealias TireMaxImpulseCallback = void*;
public typealias TraceFunc = void*;

[CRepr]
[AllowDuplicates]
public enum PhysicsUpdateError : int32
{
	None = 0,
	ManifoldCacheFull = 1,
	BodyPairCacheFull = 2,
	ContactConstraintsFull = 4,
	JPHPhysicsUpdateErrorCount = 5,
	JPHPhysicsUpdateErrorForce32 = 2147483647
}

[CRepr]
[AllowDuplicates]
public enum BodyType : int32
{
	Rigid = 0,
	Soft = 1,
	JPHBodyTypeCount = 2,
	JPHBodyTypeForce32 = 2147483647
}

[CRepr]
[AllowDuplicates]
public enum MotionType : int32
{
	Static = 0,
	Kinematic = 1,
	Dynamic = 2,
	JPHMotionTypeCount = 3,
	JPHMotionTypeForce32 = 2147483647
}

[CRepr]
[AllowDuplicates]
public enum Activation : int32
{
	Activate = 0,
	DontActivate = 1,
	JPHActivationCount = 2,
	JPHActivationForce32 = 2147483647
}

[CRepr]
[AllowDuplicates]
public enum ValidateResult : int32
{
	AcceptAllContactsForThisBodyPair = 0,
	AcceptContact = 1,
	RejectContact = 2,
	RejectAllContactsForThisBodyPair = 3,
	JPHValidateResultCount = 4,
	JPHValidateResultForce32 = 2147483647
}

[CRepr]
[AllowDuplicates]
public enum ShapeType : int32
{
	Convex = 0,
	Compound = 1,
	Decorated = 2,
	Mesh = 3,
	HeightField = 4,
	SoftBody = 5,
	User1 = 6,
	User2 = 7,
	User3 = 8,
	User4 = 9,
	JPHShapeTypeCount = 10,
	JPHShapeTypeForce32 = 2147483647
}

[CRepr]
[AllowDuplicates]
public enum ShapeSubType : int32
{
	Sphere = 0,
	Box = 1,
	Triangle = 2,
	Capsule = 3,
	TaperedCapsule = 4,
	Cylinder = 5,
	ConvexHull = 6,
	StaticCompound = 7,
	MutableCompound = 8,
	RotatedTranslated = 9,
	Scaled = 10,
	OffsetCenterOfMass = 11,
	Mesh = 12,
	HeightField = 13,
	SoftBody = 14,
	JPHShapeSubTypeCount = 15,
	JPHShapeSubTypeForce32 = 2147483647
}

[CRepr]
[AllowDuplicates]
public enum ConstraintType : int32
{
	Constraint = 0,
	TwoBodyConstraint = 1,
	JPHConstraintTypeCount = 2,
	JPHConstraintTypeForce32 = 2147483647
}

[CRepr]
[AllowDuplicates]
public enum ConstraintSubType : int32
{
	Fixed = 0,
	Point = 1,
	Hinge = 2,
	Slider = 3,
	Distance = 4,
	Cone = 5,
	SwingTwist = 6,
	SixDOF = 7,
	Path = 8,
	Vehicle = 9,
	RackAndPinion = 10,
	Gear = 11,
	Pulley = 12,
	User1 = 13,
	User2 = 14,
	User3 = 15,
	User4 = 16,
	JPHConstraintSubTypeCount = 17,
	JPHConstraintSubTypeForce32 = 2147483647
}

[CRepr]
[AllowDuplicates]
public enum ConstraintSpace : int32
{
	LocalToBodyCOM = 0,
	WorldSpace = 1,
	JPHConstraintSpaceCount = 2,
	JPHConstraintSpaceForce32 = 2147483647
}

[CRepr]
[AllowDuplicates]
public enum MotionQuality : int32
{
	Discrete = 0,
	LinearCast = 1,
	JPHMotionQualityCount = 2,
	JPHMotionQualityForce32 = 2147483647
}

[CRepr]
[AllowDuplicates]
public enum OverrideMassProperties : int32
{
	CalculateMassAndInertia = 0,
	CalculateInertia = 1,
	MassAndInertiaProvided = 2,
	JPHJPHOverrideMassPropertiesCount = 3,
	JPHJPHOverrideMassPropertiesForce32 = 2147483647
}

[CRepr]
[AllowDuplicates]
public enum AllowedDOFs : int32
{
	All = 63,
	TranslationX = 1,
	TranslationY = 2,
	TranslationZ = 4,
	RotationX = 8,
	RotationY = 16,
	RotationZ = 32,
	Plane2D = 35,
	JPHAllowedDOFsCount = 36,
	JPHAllowedDOFsForce32 = 2147483647
}

[CRepr]
[AllowDuplicates]
public enum GroundState : int32
{
	OnGround = 0,
	OnSteepGround = 1,
	NotSupported = 2,
	InAir = 3,
	JPHGroundStateCount = 4,
	JPHGroundStateForce32 = 2147483647
}

[CRepr]
[AllowDuplicates]
public enum BackFaceMode : int32
{
	IgnoreBackFaces = 0,
	CollideWithBackFaces = 1,
	JPHBackFaceModeCount = 2,
	JPHBackFaceModeForce32 = 2147483647
}

[CRepr]
[AllowDuplicates]
public enum ActiveEdgeMode : int32
{
	CollideOnlyWithActive = 0,
	CollideWithAll = 1,
	JPHActiveEdgeModeCount = 2,
	JPHActiveEdgeModeForce32 = 2147483647
}

[CRepr]
[AllowDuplicates]
public enum CollectFacesMode : int32
{
	CollectFaces = 0,
	NoFaces = 1,
	JPHCollectFacesModeCount = 2,
	JPHCollectFacesModeForce32 = 2147483647
}

[CRepr]
[AllowDuplicates]
public enum MotorState : int32
{
	Off = 0,
	Velocity = 1,
	Position = 2,
	JPHMotorStateCount = 3,
	JPHMotorStateForce32 = 2147483647
}

[CRepr]
[AllowDuplicates]
public enum CollisionCollectorType : int32
{
	AllHit = 0,
	AllHitSorted = 1,
	ClosestHit = 2,
	AnyHit = 3,
	JPHCollisionCollectorTypeCount = 4,
	JPHCollisionCollectorTypeForce32 = 2147483647
}

[CRepr]
[AllowDuplicates]
public enum SwingType : int32
{
	Cone = 0,
	Pyramid = 1,
	JPHSwingTypeCount = 2,
	JPHSwingTypeForce32 = 2147483647
}

[CRepr]
[AllowDuplicates]
public enum SixDOFConstraintAxis : int32
{
	TranslationX = 0,
	TranslationY = 1,
	TranslationZ = 2,
	RotationX = 3,
	RotationY = 4,
	RotationZ = 5,
	JPHSixDOFConstraintAxisNum = 6,
	JPHSixDOFConstraintAxisNumTranslation = 3,
	JPHSixDOFConstraintAxisForce32 = 2147483647
}

[CRepr]
[AllowDuplicates]
public enum SpringMode : int32
{
	FrequencyAndDamping = 0,
	StiffnessAndDamping = 1,
	JPHSpringModeCount = 2,
	JPHSpringModeForce32 = 2147483647
}

[CRepr]
[AllowDuplicates]
public enum SoftBodyConstraintColor : int32
{
	ConstraintType = 0,
	ConstraintGroup = 1,
	ConstraintOrder = 2,
	JPHSoftBodyConstraintColorCount = 3,
	JPHSoftBodyConstraintColorForce32 = 2147483647
}

[CRepr]
[AllowDuplicates]
public enum SoftBodyBendType : int32
{
	None = 0,
	Distance = 1,
	Dihedral = 2
}

[CRepr]
[AllowDuplicates]
public enum BodyManager_ShapeColor : int32
{
	InstanceColor = 0,
	ShapeTypeColor = 1,
	MotionTypeColor = 2,
	SleepColor = 3,
	IslandColor = 4,
	MaterialColor = 5,
	JPHBodyManagerShapeColorCount = 6,
	JPHBodyManagerShapeColorForce32 = 2147483647
}

[CRepr]
[AllowDuplicates]
public enum DebugRenderer_CastShadow : int32
{
	On = 0,
	Off = 1,
	JPHDebugRendererCastShadowCount = 2,
	JPHDebugRendererCastShadowForce32 = 2147483647
}

[CRepr]
[AllowDuplicates]
public enum DebugRenderer_DrawMode : int32
{
	Solid = 0,
	Wireframe = 1,
	JPHDebugRendererDrawModeCount = 2,
	JPHDebugRendererDrawModeForce32 = 2147483647
}

[CRepr]
[AllowDuplicates]
public enum Mesh_Shape_BuildQuality : int32
{
	FavorRuntimePerformance = 0,
	FavorBuildSpeed = 1,
	JPHMeshShapeBuildQualityCount = 2,
	JPHMeshShapeBuildQualityForce32 = 2147483647
}

[CRepr]
[AllowDuplicates]
public enum TransmissionMode : int32
{
	Auto = 0,
	Manual = 1,
	JPHTransmissionModeCount = 2,
	JPHTransmissionModeForce32 = 2147483647
}

[CRepr]
[AllowDuplicates]
public enum TrackSide : int32
{
	Left = 0,
	Right = 1
}

public struct Body { }
public struct BodyActivationListener { }
public struct BodyCreationSettings { }
public struct BodyDrawFilter { }
public struct BodyFilter { }
public struct BodyInterface { }
public struct BodyLockInterface { }
public struct BodyLockMultiRead { }
public struct BodyLockMultiWrite { }
public struct BoxShape { }
public struct BoxShapeSettings { }
public struct BroadPhaseLayerFilter { }
public struct BroadPhaseLayerInterface { }
public struct BroadPhaseQuery { }
public struct CapsuleShape { }
public struct CapsuleShapeSettings { }
public struct Character { }
public struct CharacterBase { }
public struct CharacterContactListener { }
public struct CharacterVirtual { }
public struct CharacterVsCharacterCollision { }
public struct CompoundShape { }
public struct CompoundShapeSettings { }
public struct ConeConstraint { }
public struct Constraint { }
public struct ContactListener { }
public struct ContactManifold { }
public struct ConvexHullShape { }
public struct ConvexHullShapeSettings { }
public struct ConvexShape { }
public struct ConvexShapeSettings { }
public struct CylinderShape { }
public struct CylinderShapeSettings { }
public struct DebugRenderer { }
public struct DecoratedShape { }
public struct DistanceConstraint { }
public struct EmptyShape { }
public struct EmptyShapeSettings { }
public struct FixedConstraint { }
public struct GearConstraint { }
public struct GroupFilter { }
public struct GroupFilterTable { }
public struct HeightFieldShape { }
public struct HeightFieldShapeSettings { }
public struct HingeConstraint { }
public struct JobSystem { }
public struct LinearCurve { }
public struct MeshShape { }
public struct MeshShapeSettings { }
public struct MotionProperties { }
public struct MotorcycleController { }
public struct MotorcycleControllerSettings { }
public struct MutableCompoundShape { }
public struct MutableCompoundShapeSettings { }
public struct NarrowPhaseQuery { }
public struct ObjectLayerFilter { }
public struct ObjectLayerPairFilter { }
public struct ObjectVsBroadPhaseLayerFilter { }
public struct OffsetCenterOfMassShape { }
public struct OffsetCenterOfMassShapeSettings { }
public struct PhysicsMaterial { }
public struct PhysicsStepListener { }
public struct PhysicsSystem { }
public struct PlaneShape { }
public struct PlaneShapeSettings { }
public struct PointConstraint { }
public struct Ragdoll { }
public struct RagdollSettings { }
public struct RotatedTranslatedShape { }
public struct RotatedTranslatedShapeSettings { }
public struct ScaledShape { }
public struct ScaledShapeSettings { }
public struct Shape { }
public struct ShapeFilter { }
public struct ShapeSettings { }
public struct SharedMutex { }
public struct SimShapeFilter { }
public struct SixDOFConstraint { }
public struct SkeletalAnimation { }
public struct Skeleton { }
public struct SkeletonMapper { }
public struct SkeletonPose { }
public struct SliderConstraint { }
public struct SoftBodyCreationSettings { }
public struct SoftBodySharedSettings { }
public struct SphereShape { }
public struct SphereShapeSettings { }
public struct StaticCompoundShape { }
public struct StaticCompoundShapeSettings { }
public struct SwingTwistConstraint { }
public struct TaperedCapsuleShape { }
public struct TaperedCapsuleShapeSettings { }
public struct TaperedCylinderShape { }
public struct TaperedCylinderShapeSettings { }
public struct TempAllocator { }
public struct TrackedVehicleController { }
public struct TrackedVehicleControllerSettings { }
public struct TriangleShape { }
public struct TriangleShapeSettings { }
public struct TwoBodyConstraint { }
public struct VehicleCollisionTester { }
public struct VehicleCollisionTesterCastCylinder { }
public struct VehicleCollisionTesterCastSphere { }
public struct VehicleCollisionTesterRay { }
public struct VehicleConstraint { }
public struct VehicleController { }
public struct VehicleControllerSettings { }
public struct VehicleEngine { }
public struct VehicleTrack { }
public struct VehicleTransmission { }
public struct VehicleTransmissionSettings { }
public struct Wheel { }
public struct WheelSettings { }
public struct WheelSettingsTV { }
public struct WheelSettingsWV { }
public struct WheelTV { }
public struct WheelWV { }
public struct WheeledVehicleController { }
public struct WheeledVehicleControllerSettings { }

[CRepr]
public struct Vec3
{
	public float X;
	public float Y;
	public float Z;

	public this(float x, float y, float z)
	{
		X = x;
		Y = y;
		Z = z;
	}
}

[CRepr]
public struct Vec4
{
	public float X;
	public float Y;
	public float Z;
	public float W;

	public this(float x, float y, float z, float w)
	{
		X = x;
		Y = y;
		Z = z;
		W = w;
	}
}

[CRepr]
public struct Quat
{
	public float X;
	public float Y;
	public float Z;
	public float W;

	public this(float x, float y, float z, float w)
	{
		X = x;
		Y = y;
		Z = z;
		W = w;
	}

	public static Quat Identity => .(0.0f, 0.0f, 0.0f, 1.0f);
}

[CRepr]
public struct Plane
{
	public Vec3 Normal;
	public float Distance;
}

[CRepr]
public struct Mat4
{
	public Vec4 Column0;
	public Vec4 Column1;
	public Vec4 Column2;
	public Vec4 Column3;
}

[CRepr]
public struct Point
{
	public float X;
	public float Y;
}

[CRepr]
public struct AABox
{
	public Vec3 Min;
	public Vec3 Max;
}

[CRepr]
public struct Triangle
{
	public Vec3 V1;
	public Vec3 V2;
	public Vec3 V3;
	public uint32 MaterialIndex;
}

[CRepr]
public struct IndexedTriangleNoMaterial
{
	public uint32 I1;
	public uint32 I2;
	public uint32 I3;
}

[CRepr]
public struct IndexedTriangle
{
	public uint32 I1;
	public uint32 I2;
	public uint32 I3;
	public uint32 MaterialIndex;
	public uint32 UserData;
}

[CRepr]
public struct MassProperties
{
	public float Mass;
	public Mat4 Inertia;
}

[CRepr]
public struct SoftVertex
{
	public Vec3 Position;
	public Vec3 Velocity;
	public float InvMass;
}

[CRepr]
public struct SoftFace
{
	public uint32 Vertex1;
	public uint32 Vertex2;
	public uint32 Vertex3;
	public uint32 MaterialIndex;
}

[CRepr]
public struct ContactSettings
{
	public float CombinedFriction;
	public float CombinedRestitution;
	public float InvMassScale1;
	public float InvInertiaScale1;
	public float InvMassScale2;
	public float InvInertiaScale2;
	public Bool32 IsSensor;
	public Vec3 RelativeLinearSurfaceVelocity;
	public Vec3 RelativeAngularSurfaceVelocity;
}

[CRepr]
public struct CollideSettingsBase
{
	public ActiveEdgeMode ActiveEdgeMode;
	public CollectFacesMode CollectFacesMode;
	public float CollisionTolerance;
	public float PenetrationTolerance;
	public Vec3 ActiveEdgeMovementDirection;
}

[CRepr]
public struct CollideShapeSettings
{
	public CollideSettingsBase Base;
	public float MaxSeparationDistance;
	public BackFaceMode BackFaceMode;
}

[CRepr]
public struct ShapeCastSettings
{
	public CollideSettingsBase Base;
	public BackFaceMode BackFaceModeTriangles;
	public BackFaceMode BackFaceModeConvex;
	public bool UseShrunkenShapeAndConvexRadius;
	public bool ReturnDeepestPoint;
}

[CRepr]
public struct RayCastSettings
{
	public BackFaceMode BackFaceModeTriangles;
	public BackFaceMode BackFaceModeConvex;
	public bool TreatConvexAsSolid;
}

[CRepr]
public struct SpringSettings
{
	public SpringMode Mode;
	public float FrequencyOrStiffness;
	public float Damping;
}

[CRepr]
public struct MotorSettings
{
	public SpringSettings SpringSettings;
	public float MinForceLimit;
	public float MaxForceLimit;
	public float MinTorqueLimit;
	public float MaxTorqueLimit;
}

[CRepr]
public struct SubShapeIDPair
{
	public BodyID Body1ID;
	public SubShapeID SubShapeID1;
	public BodyID Body2ID;
	public SubShapeID SubShapeID2;
}

[CRepr]
public struct BroadPhaseCastResult
{
	public BodyID BodyID;
	public float Fraction;
}

[CRepr]
public struct RayCastResult
{
	public BodyID BodyID;
	public float Fraction;
	public SubShapeID SubShapeID2;
}

[CRepr]
public struct CollidePointResult
{
	public BodyID BodyID;
	public SubShapeID SubShapeID2;
}

[CRepr]
public struct CollideShapeResult
{
	public Vec3 ContactPointOn1;
	public Vec3 ContactPointOn2;
	public Vec3 PenetrationAxis;
	public float PenetrationDepth;
	public SubShapeID SubShapeID1;
	public SubShapeID SubShapeID2;
	public BodyID BodyID2;
	public uint32 Shape1FaceCount;
	public Vec3* Shape1Faces;
	public uint32 Shape2FaceCount;
	public Vec3* Shape2Faces;
}

[CRepr]
public struct ShapeCastResult
{
	public Vec3 ContactPointOn1;
	public Vec3 ContactPointOn2;
	public Vec3 PenetrationAxis;
	public float PenetrationDepth;
	public SubShapeID SubShapeID1;
	public SubShapeID SubShapeID2;
	public BodyID BodyID2;
	public float Fraction;
	public bool IsBackFaceHit;
}

[CRepr]
public struct DrawSettings
{
	public bool DrawGetSupportFunction;
	public bool DrawSupportDirection;
	public bool DrawGetSupportingFace;
	public bool DrawShape;
	public bool DrawShapeWireframe;
	public BodyManager_ShapeColor DrawShapeColor;
	public bool DrawBoundingBox;
	public bool DrawCenterOfMassTransform;
	public bool DrawWorldTransform;
	public bool DrawVelocity;
	public bool DrawMassAndInertia;
	public bool DrawSleepStats;
	public bool DrawSoftBodyVertices;
	public bool DrawSoftBodyVertexVelocities;
	public bool DrawSoftBodyEdgeConstraints;
	public bool DrawSoftBodyBendConstraints;
	public bool DrawSoftBodyVolumeConstraints;
	public bool DrawSoftBodySkinConstraints;
	public bool DrawSoftBodyLRAConstraints;
	public bool DrawSoftBodyPredictedBounds;
	public SoftBodyConstraintColor DrawSoftBodyConstraintColor;
}

[CRepr]
public struct SupportingFace
{
	public uint32 Count;
	public Vec3 Vertices0;
	public Vec3 Vertices1;
	public Vec3 Vertices2;
	public Vec3 Vertices3;
	public Vec3 Vertices4;
	public Vec3 Vertices5;
	public Vec3 Vertices6;
	public Vec3 Vertices7;
	public Vec3 Vertices8;
	public Vec3 Vertices9;
	public Vec3 Vertices10;
	public Vec3 Vertices11;
	public Vec3 Vertices12;
	public Vec3 Vertices13;
	public Vec3 Vertices14;
	public Vec3 Vertices15;
	public Vec3 Vertices16;
	public Vec3 Vertices17;
	public Vec3 Vertices18;
	public Vec3 Vertices19;
	public Vec3 Vertices20;
	public Vec3 Vertices21;
	public Vec3 Vertices22;
	public Vec3 Vertices23;
	public Vec3 Vertices24;
	public Vec3 Vertices25;
	public Vec3 Vertices26;
	public Vec3 Vertices27;
	public Vec3 Vertices28;
	public Vec3 Vertices29;
	public Vec3 Vertices30;
	public Vec3 Vertices31;
}

[CRepr]
public struct CollisionGroup
{
	public GroupFilter* GroupFilter;
	public CollisionGroupID GroupID;
	public CollisionSubGroupID SubGroupID;
}

[CRepr]
public struct CollisionEstimationResultImpulse
{
	public float ContactImpulse;
	public float FrictionImpulse1;
	public float FrictionImpulse2;
}

[CRepr]
public struct CollisionEstimationResult
{
	public Vec3 LinearVelocity1;
	public Vec3 AngularVelocity1;
	public Vec3 LinearVelocity2;
	public Vec3 AngularVelocity2;
	public Vec3 Tangent1;
	public Vec3 Tangent2;
	public uint32 ImpulseCount;
	public CollisionEstimationResultImpulse* Impulses;
}

[CRepr]
public struct ConstraintSettings
{
	public bool Enabled;
	public uint32 ConstraintPriority;
	public uint32 NumVelocityStepsOverride;
	public uint32 NumPositionStepsOverride;
	public float DrawConstraintSize;
	public uint64 UserData;
}

[CRepr]
public struct FixedConstraintSettings
{
	public ConstraintSettings Base;
	public ConstraintSpace Space;
	public bool AutoDetectPoint;
	public RVec3 Point1;
	public Vec3 AxisX1;
	public Vec3 AxisY1;
	public RVec3 Point2;
	public Vec3 AxisX2;
	public Vec3 AxisY2;
}

[CRepr]
public struct DistanceConstraintSettings
{
	public ConstraintSettings Base;
	public ConstraintSpace Space;
	public RVec3 Point1;
	public RVec3 Point2;
	public float MinDistance;
	public float MaxDistance;
	public SpringSettings LimitsSpringSettings;
}

[CRepr]
public struct PointConstraintSettings
{
	public ConstraintSettings Base;
	public ConstraintSpace Space;
	public RVec3 Point1;
	public RVec3 Point2;
}

[CRepr]
public struct HingeConstraintSettings
{
	public ConstraintSettings Base;
	public ConstraintSpace Space;
	public RVec3 Point1;
	public Vec3 HingeAxis1;
	public Vec3 NormalAxis1;
	public RVec3 Point2;
	public Vec3 HingeAxis2;
	public Vec3 NormalAxis2;
	public float LimitsMin;
	public float LimitsMax;
	public SpringSettings LimitsSpringSettings;
	public float MaxFrictionTorque;
	public MotorSettings MotorSettings;
}

[CRepr]
public struct SliderConstraintSettings
{
	public ConstraintSettings Base;
	public ConstraintSpace Space;
	public bool AutoDetectPoint;
	public RVec3 Point1;
	public Vec3 SliderAxis1;
	public Vec3 NormalAxis1;
	public RVec3 Point2;
	public Vec3 SliderAxis2;
	public Vec3 NormalAxis2;
	public float LimitsMin;
	public float LimitsMax;
	public SpringSettings LimitsSpringSettings;
	public float MaxFrictionForce;
	public MotorSettings MotorSettings;
}

[CRepr]
public struct ConeConstraintSettings
{
	public ConstraintSettings Base;
	public ConstraintSpace Space;
	public RVec3 Point1;
	public Vec3 TwistAxis1;
	public RVec3 Point2;
	public Vec3 TwistAxis2;
	public float HalfConeAngle;
}

[CRepr]
public struct SwingTwistConstraintSettings
{
	public ConstraintSettings Base;
	public ConstraintSpace Space;
	public RVec3 Position1;
	public Vec3 TwistAxis1;
	public Vec3 PlaneAxis1;
	public RVec3 Position2;
	public Vec3 TwistAxis2;
	public Vec3 PlaneAxis2;
	public SwingType SwingType;
	public float NormalHalfConeAngle;
	public float PlaneHalfConeAngle;
	public float TwistMinAngle;
	public float TwistMaxAngle;
	public float MaxFrictionTorque;
	public MotorSettings SwingMotorSettings;
	public MotorSettings TwistMotorSettings;
}

[CRepr]
public struct SixDOFConstraintSettings
{
	public ConstraintSettings Base;
	public ConstraintSpace Space;
	public RVec3 Position1;
	public Vec3 AxisX1;
	public Vec3 AxisY1;
	public RVec3 Position2;
	public Vec3 AxisX2;
	public Vec3 AxisY2;
	public float MaxFriction0;
	public float MaxFriction1;
	public float MaxFriction2;
	public float MaxFriction3;
	public float MaxFriction4;
	public float MaxFriction5;
	public SwingType SwingType;
	public float LimitMin0;
	public float LimitMin1;
	public float LimitMin2;
	public float LimitMin3;
	public float LimitMin4;
	public float LimitMin5;
	public float LimitMax0;
	public float LimitMax1;
	public float LimitMax2;
	public float LimitMax3;
	public float LimitMax4;
	public float LimitMax5;
	public SpringSettings LimitsSpringSettings0;
	public SpringSettings LimitsSpringSettings1;
	public SpringSettings LimitsSpringSettings2;
	public MotorSettings MotorSettings0;
	public MotorSettings MotorSettings1;
	public MotorSettings MotorSettings2;
	public MotorSettings MotorSettings3;
	public MotorSettings MotorSettings4;
	public MotorSettings MotorSettings5;
}

[CRepr]
public struct GearConstraintSettings
{
	public ConstraintSettings Base;
	public ConstraintSpace Space;
	public Vec3 HingeAxis1;
	public Vec3 HingeAxis2;
	public float Ratio;
}

[CRepr]
public struct BodyLockRead
{
	public BodyLockInterface* LockInterface;
	public SharedMutex* Mutex;
	public Body* Body;
}

[CRepr]
public struct BodyLockWrite
{
	public BodyLockInterface* LockInterface;
	public SharedMutex* Mutex;
	public Body* Body;
}

[CRepr]
public struct ExtendedUpdateSettings
{
	public Vec3 StickToFloorStepDown;
	public Vec3 WalkStairsStepUp;
	public float WalkStairsMinStepForward;
	public float WalkStairsStepForwardTest;
	public float WalkStairsCosAngleForwardContact;
	public Vec3 WalkStairsStepDownExtra;
}

[CRepr]
public struct CharacterBaseSettings
{
	public Vec3 Up;
	public Plane SupportingVolume;
	public float MaxSlopeAngle;
	public bool EnhancedInternalEdgeRemoval;
	public Shape* Shape;
}

[CRepr]
public struct CharacterSettings
{
	public CharacterBaseSettings Base;
	public ObjectLayer Layer;
	public float Mass;
	public float Friction;
	public float GravityFactor;
	public AllowedDOFs AllowedDOFs;
}

[CRepr]
public struct CharacterVirtualSettings
{
	public CharacterBaseSettings Base;
	public CharacterID ID;
	public float Mass;
	public float MaxStrength;
	public Vec3 ShapeOffset;
	public BackFaceMode BackFaceMode;
	public float PredictiveContactDistance;
	public uint32 MaxCollisionIterations;
	public uint32 MaxConstraintIterations;
	public float MinTimeRemaining;
	public float CollisionTolerance;
	public float CharacterPadding;
	public uint32 MaxNumHits;
	public float HitReductionCosMaxAngle;
	public float PenetrationRecoverySpeed;
	public Shape* InnerBodyShape;
	public BodyID InnerBodyIDOverride;
	public ObjectLayer InnerBodyLayer;
}

[CRepr]
public struct CharacterContactSettings
{
	public bool CanPushCharacter;
	public bool CanReceiveImpulses;
}

[CRepr]
public struct CharacterVirtualContact
{
	public uint64 Hash;
	public BodyID BodyB;
	public CharacterID CharacterIDB;
	public SubShapeID SubShapeIDB;
	public RVec3 Position;
	public Vec3 LinearVelocity;
	public Vec3 ContactNormal;
	public Vec3 SurfaceNormal;
	public float Distance;
	public float Fraction;
	public MotionType MotionTypeB;
	public bool IsSensorB;
	public CharacterVirtual* CharacterB;
	public uint64 UserData;
	public PhysicsMaterial* Material;
	public bool HadCollision;
	public bool WasDiscarded;
	public bool CanPushCharacter;
}

[CRepr]
public struct JobSystemThreadPoolConfig
{
	public uint32 MaxJobs;
	public uint32 MaxBarriers;
	public int32 NumThreads;
}

[CRepr]
public struct JobSystemConfig
{
	public void* Context;
	public void* QueueJob;
	public void* QueueJobs;
	public uint32 MaxConcurrency;
	public uint32 MaxBarriers;
}

[CRepr]
public struct PhysicsSystemSettings
{
	public uint32 MaxBodies;
	public uint32 NumBodyMutexes;
	public uint32 MaxBodyPairs;
	public uint32 MaxContactConstraints;
	public uint32 Padding;
	public BroadPhaseLayerInterface* BroadPhaseLayerInterface;
	public ObjectLayerPairFilter* ObjectLayerPairFilter;
	public ObjectVsBroadPhaseLayerFilter* ObjectVsBroadPhaseLayerFilter;
}

[CRepr]
public struct PhysicsSettings
{
	public int32 MaxInFlightBodyPairs;
	public int32 StepListenersBatchSize;
	public int32 StepListenerBatchesPerJob;
	public float Baumgarte;
	public float SpeculativeContactDistance;
	public float PenetrationSlop;
	public float LinearCastThreshold;
	public float LinearCastMaxPenetration;
	public float ManifoldTolerance;
	public float MaxPenetrationDistance;
	public float BodyPairCacheMaxDeltaPositionSq;
	public float BodyPairCacheCosMaxDeltaRotationDiv2;
	public float ContactNormalCosMaxDeltaRotation;
	public float ContactPointPreserveLambdaMaxDistSq;
	public uint32 NumVelocitySteps;
	public uint32 NumPositionSteps;
	public float MinVelocityForRestitution;
	public float TimeBeforeSleep;
	public float PointVelocitySleepThreshold;
	public bool DeterministicSimulation;
	public bool ConstraintWarmStart;
	public bool UseBodyPairContactCache;
	public bool UseManifoldReduction;
	public bool UseLargeIslandSplitter;
	public bool AllowSleeping;
	public bool CheckActiveEdges;
}

[CRepr]
public struct PhysicsStepListenerContext
{
	public float DeltaTime;
	public Bool32 IsFirstStep;
	public Bool32 IsLastStep;
	public PhysicsSystem* PhysicsSystem;
}

[CRepr]
public struct PhysicsStepListener_Procs
{
	public typealias OnStepFunction = function void(void* userData, PhysicsStepListenerContext* context);
	public OnStepFunction OnStep = null;
}

[CRepr]
public struct BroadPhaseLayerFilter_Procs
{
	public typealias ShouldCollideFunction = function bool(void* userData, BroadPhaseLayer layer);
	public ShouldCollideFunction ShouldCollide = null;
}

[CRepr]
public struct ObjectLayerFilter_Procs
{
	public typealias ShouldCollideFunction = function bool(void* userData, ObjectLayer layer);
	public ShouldCollideFunction ShouldCollide = null;
}

[CRepr]
public struct BodyFilter_Procs
{
	public typealias ShouldCollideFunction = function bool(void* userData, BodyID bodyID);
	public ShouldCollideFunction ShouldCollide = null;

	public typealias ShouldCollideLockedFunction = function bool(void* userData, Body* bodyID);
	public ShouldCollideLockedFunction ShouldCollideLocked = null;
}

[CRepr]
public struct ShapeFilter_Procs
{
	public typealias ShouldCollideFunction = function bool(void* userData, Shape* shape2, SubShapeID* subShapeIDOfShape2);
	public ShouldCollideFunction ShouldCollide = null;

	public typealias ShouldCollide2Function = function bool(void* userData, Shape* shape1, SubShapeID* subShapeIDOfShape1, Shape* shape2, SubShapeID* subShapeIDOfShape2);
	public ShouldCollide2Function ShouldCollide2 = null;
}

[CRepr]
public struct SimShapeFilter_Procs
{
	public typealias ShouldCollideFunction = function bool(void* userData, Body* body1, Shape* shape1, SubShapeID* subShapeIDOfShape1, Body* body2, Shape* shape2, SubShapeID* subShapeIDOfShape2);
	public ShouldCollideFunction ShouldCollide = null;
}

[CRepr]
public struct ContactListener_Procs
{
	public typealias OnContactValidateFunction = function ValidateResult(void* userData, Body* body1, Body* body2, RVec3* baseOffset, CollideShapeResult* collisionResult);
	public OnContactValidateFunction OnContactValidate = null;

	public typealias OnContactAddedFunction = function void(void* userData, Body* body1, Body* body2, ContactManifold* manifold, ContactSettings* settings);
	public OnContactAddedFunction OnContactAdded = null;

	public typealias OnContactPersistedFunction = function void(void* userData, Body* body1, Body* body2, ContactManifold* manifold, ContactSettings* settings);
	public OnContactPersistedFunction OnContactPersisted = null;

	public typealias OnContactRemovedFunction = function void(void* userData, SubShapeIDPair* subShapePair);
	public OnContactRemovedFunction OnContactRemoved = null;
}

[CRepr]
public struct BodyActivationListener_Procs
{
	public typealias OnBodyActivatedFunction = function void(void* userData, BodyID bodyID, uint64 bodyUserData);
	public OnBodyActivatedFunction OnBodyActivated = null;

	public typealias OnBodyDeactivatedFunction = function void(void* userData, BodyID bodyID, uint64 bodyUserData);
	public OnBodyDeactivatedFunction OnBodyDeactivated = null;
}

[CRepr]
public struct BodyDrawFilter_Procs
{
	public typealias ShouldDrawFunction = function bool(void* userData, Body* body);
	public ShouldDrawFunction ShouldDraw = null;
}

[CRepr]
public struct CharacterContactListener_Procs
{
	public typealias OnAdjustBodyVelocityFunction = function void(void* userData, CharacterVirtual* character, Body* body2, Vec3* ioLinearVelocity, Vec3* ioAngularVelocity);
	public OnAdjustBodyVelocityFunction OnAdjustBodyVelocity = null;

	public typealias OnContactValidateFunction = function bool(void* userData, CharacterVirtual* character, BodyID bodyID2, SubShapeID subShapeID2);
	public OnContactValidateFunction OnContactValidate = null;

	public typealias OnCharacterContactValidateFunction = function bool(void* userData, CharacterVirtual* character, CharacterVirtual* otherCharacter, SubShapeID subShapeID2);
	public OnCharacterContactValidateFunction OnCharacterContactValidate = null;

	public typealias OnContactAddedFunction = function void(void* userData, CharacterVirtual* character, BodyID bodyID2, SubShapeID subShapeID2, RVec3* contactPosition, Vec3* contactNormal, CharacterContactSettings* ioSettings);
	public OnContactAddedFunction OnContactAdded = null;

	public typealias OnContactPersistedFunction = function void(void* userData, CharacterVirtual* character, BodyID bodyID2, SubShapeID subShapeID2, RVec3* contactPosition, Vec3* contactNormal, CharacterContactSettings* ioSettings);
	public OnContactPersistedFunction OnContactPersisted = null;

	public typealias OnContactRemovedFunction = function void(void* userData, CharacterVirtual* character, BodyID bodyID2, SubShapeID subShapeID2);
	public OnContactRemovedFunction OnContactRemoved = null;

	public typealias OnCharacterContactAddedFunction = function void(void* userData, CharacterVirtual* character, CharacterVirtual* otherCharacter, SubShapeID subShapeID2, RVec3* contactPosition, Vec3* contactNormal, CharacterContactSettings* ioSettings);
	public OnCharacterContactAddedFunction OnCharacterContactAdded = null;

	public typealias OnCharacterContactPersistedFunction = function void(void* userData, CharacterVirtual* character, CharacterVirtual* otherCharacter, SubShapeID subShapeID2, RVec3* contactPosition, Vec3* contactNormal, CharacterContactSettings* ioSettings);
	public OnCharacterContactPersistedFunction OnCharacterContactPersisted = null;

	public typealias OnCharacterContactRemovedFunction = function void(void* userData, CharacterVirtual* character, CharacterID otherCharacterID, SubShapeID subShapeID2);
	public OnCharacterContactRemovedFunction OnCharacterContactRemoved = null;

	public typealias OnContactSolveFunction = function void(void* userData, CharacterVirtual* character, BodyID bodyID2, SubShapeID subShapeID2, RVec3* contactPosition, Vec3* contactNormal, Vec3* contactVelocity, PhysicsMaterial* contactMaterial, Vec3* characterVelocity, Vec3* newCharacterVelocity);
	public OnContactSolveFunction OnContactSolve = null;

	public typealias OnCharacterContactSolveFunction = function void(void* userData, CharacterVirtual* character, CharacterVirtual* otherCharacter, SubShapeID subShapeID2, RVec3* contactPosition, Vec3* contactNormal, Vec3* contactVelocity, PhysicsMaterial* contactMaterial, Vec3* characterVelocity, Vec3* newCharacterVelocity);
	public OnCharacterContactSolveFunction OnCharacterContactSolve = null;
}

[CRepr]
public struct CharacterVsCharacterCollision_Procs
{
	public typealias CollideCharacterFunction = function void(void* userData, CharacterVirtual* character, RMat4* centerOfMassTransform, CollideShapeSettings* collideShapeSettings, RVec3* baseOffset);
	public CollideCharacterFunction CollideCharacter = null;

	public typealias CastCharacterFunction = function void(void* userData, CharacterVirtual* character, RMat4* centerOfMassTransform, Vec3* direction, ShapeCastSettings* shapeCastSettings, RVec3* baseOffset);
	public CastCharacterFunction CastCharacter = null;
}

[CRepr]
public struct DebugRenderer_Procs
{
	public typealias DrawLineFunction = function void(void* userData, RVec3* from, RVec3* to, Color color);
	public DrawLineFunction DrawLine = null;

	public typealias DrawTriangleFunction = function void(void* userData, RVec3* v1, RVec3* v2, RVec3* v3, Color color, DebugRenderer_CastShadow castShadow);
	public DrawTriangleFunction DrawTriangle = null;

	public typealias DrawText3DFunction = function void(void* userData, RVec3* position, char8* str, Color color, float height);
	public DrawText3DFunction DrawText3D = null;
}

[CRepr]
public struct SkeletonJoint
{
	public char8* Name;
	public char8* ParentName;
	public int32 ParentJointIndex;
}

[CRepr]
public struct VehicleAntiRollBar
{
	public int32 LeftWheel;
	public int32 RightWheel;
	public float Stiffness;
}

[CRepr]
public struct VehicleConstraintSettings
{
	public ConstraintSettings Base;
	public Vec3 Up;
	public Vec3 Forward;
	public float MaxPitchRollAngle;
	public uint32 WheelsCount;
	public WheelSettings** Wheels;
	public uint32 AntiRollBarsCount;
	public VehicleAntiRollBar* AntiRollBars;
	public VehicleControllerSettings* Controller;
}

[CRepr]
public struct VehicleEngineSettings
{
	public float MaxTorque;
	public float MinRPM;
	public float MaxRPM;
	public LinearCurve* NormalizedTorque;
	public float Inertia;
	public float AngularDamping;
}

[CRepr]
public struct VehicleDifferentialSettings
{
	public int32 LeftWheel;
	public int32 RightWheel;
	public float DifferentialRatio;
	public float LeftRightSplit;
	public float LimitedSlipRatio;
	public float EngineTorqueRatio;
}

[CRepr]
public struct VehicleTrackSettings
{
	public uint32 DrivenWheel;
	public uint32* Wheels;
	public uint32 WheelsCount;
	public float Inertia;
	public float AngularDamping;
	public float MaxBrakeTorque;
	public float DifferentialRatio;
}

public static class JPH
{
	public const float DefaultCollisionTolerance = 1.0e-4f;
	public const float DefaultPenetrationTolerance = 1.0e-4f;
	public const float DefaultConvexRadius = 0.05f;
	public const float CapsuleProjectionSlop = 0.02f;
	public const int32 MaxPhysicsJobs = 2048;
	public const int32 MaxPhysicsBarriers = 8;
	public const uint32 InvalidCollisionGroupID = 0xFFFFFFFF;
	public const uint32 InvalidCollisionSubGroupID = 0xFFFFFFFF;
	public const float Pi = 3.14159265358979323846f;

	[CLink, CallingConvention(.Cdecl)]
	public static extern JobSystem* JPH_JobSystemThreadPool_Create(JobSystemThreadPoolConfig* config);

	[CLink, CallingConvention(.Cdecl)]
	public static extern JobSystem* JPH_JobSystemCallback_Create(JobSystemConfig* config);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_JobSystem_Destroy(JobSystem* jobSystem);

	[CLink, CallingConvention(.Cdecl)]
	public static extern bool JPH_Init();

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Shutdown();

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_SetTraceHandler(void* handler);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_SetAssertFailureHandler(void* handler);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_CollideShapeResult_FreeMembers(CollideShapeResult* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_CollisionEstimationResult_FreeMembers(CollisionEstimationResult* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_BroadPhaseLayerInterface_Destroy(BroadPhaseLayerInterface* bpInterface);

	[CLink, CallingConvention(.Cdecl)]
	public static extern BroadPhaseLayerInterface* JPH_BroadPhaseLayerInterfaceMask_Create(uint32 numBroadPhaseLayers);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_BroadPhaseLayerInterfaceMask_ConfigureLayer(BroadPhaseLayerInterface* bpInterface, BroadPhaseLayer broadPhaseLayer, uint32 groupsToInclude, uint32 groupsToExclude);

	[CLink, CallingConvention(.Cdecl)]
	public static extern BroadPhaseLayerInterface* JPH_BroadPhaseLayerInterfaceTable_Create(uint32 numObjectLayers, uint32 numBroadPhaseLayers);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_BroadPhaseLayerInterfaceTable_MapObjectToBroadPhaseLayer(BroadPhaseLayerInterface* bpInterface, ObjectLayer objectLayer, BroadPhaseLayer broadPhaseLayer);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_ObjectLayerPairFilter_Destroy(ObjectLayerPairFilter* filter);

	[CLink, CallingConvention(.Cdecl)]
	public static extern ObjectLayerPairFilter* JPH_ObjectLayerPairFilterMask_Create();

	[CLink, CallingConvention(.Cdecl)]
	public static extern ObjectLayer JPH_ObjectLayerPairFilterMask_GetObjectLayer(uint32 group, uint32 mask);

	[CLink, CallingConvention(.Cdecl)]
	public static extern uint32 JPH_ObjectLayerPairFilterMask_GetGroup(ObjectLayer layer);

	[CLink, CallingConvention(.Cdecl)]
	public static extern uint32 JPH_ObjectLayerPairFilterMask_GetMask(ObjectLayer layer);

	[CLink, CallingConvention(.Cdecl)]
	public static extern ObjectLayerPairFilter* JPH_ObjectLayerPairFilterTable_Create(uint32 numObjectLayers);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_ObjectLayerPairFilterTable_DisableCollision(ObjectLayerPairFilter* objectFilter, ObjectLayer layer1, ObjectLayer layer2);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_ObjectLayerPairFilterTable_EnableCollision(ObjectLayerPairFilter* objectFilter, ObjectLayer layer1, ObjectLayer layer2);

	[CLink, CallingConvention(.Cdecl)]
	public static extern bool JPH_ObjectLayerPairFilterTable_ShouldCollide(ObjectLayerPairFilter* objectFilter, ObjectLayer layer1, ObjectLayer layer2);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_ObjectVsBroadPhaseLayerFilter_Destroy(ObjectVsBroadPhaseLayerFilter* filter);

	[CLink, CallingConvention(.Cdecl)]
	public static extern ObjectVsBroadPhaseLayerFilter* JPH_ObjectVsBroadPhaseLayerFilterMask_Create(BroadPhaseLayerInterface* broadPhaseLayerInterface);

	[CLink, CallingConvention(.Cdecl)]
	public static extern ObjectVsBroadPhaseLayerFilter* JPH_ObjectVsBroadPhaseLayerFilterTable_Create(BroadPhaseLayerInterface* broadPhaseLayerInterface, uint32 numBroadPhaseLayers, ObjectLayerPairFilter* objectLayerPairFilter, uint32 numObjectLayers);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_DrawSettings_InitDefault(DrawSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern PhysicsSystem* JPH_PhysicsSystem_Create(PhysicsSystemSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_PhysicsSystem_Destroy(PhysicsSystem* system);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_PhysicsSystem_SetPhysicsSettings(PhysicsSystem* system, PhysicsSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_PhysicsSystem_GetPhysicsSettings(PhysicsSystem* system, PhysicsSettings* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_PhysicsSystem_OptimizeBroadPhase(PhysicsSystem* system);

	[CLink, CallingConvention(.Cdecl)]
	public static extern PhysicsUpdateError JPH_PhysicsSystem_Update(PhysicsSystem* system, float deltaTime, int32 collisionSteps, JobSystem* jobSystem);

	[CLink, CallingConvention(.Cdecl)]
	public static extern BodyInterface* JPH_PhysicsSystem_GetBodyInterface(PhysicsSystem* system);

	[CLink, CallingConvention(.Cdecl)]
	public static extern BodyInterface* JPH_PhysicsSystem_GetBodyInterfaceNoLock(PhysicsSystem* system);

	[CLink, CallingConvention(.Cdecl)]
	public static extern BodyLockInterface* JPH_PhysicsSystem_GetBodyLockInterface(PhysicsSystem* system);

	[CLink, CallingConvention(.Cdecl)]
	public static extern BodyLockInterface* JPH_PhysicsSystem_GetBodyLockInterfaceNoLock(PhysicsSystem* system);

	[CLink, CallingConvention(.Cdecl)]
	public static extern BroadPhaseQuery* JPH_PhysicsSystem_GetBroadPhaseQuery(PhysicsSystem* system);

	[CLink, CallingConvention(.Cdecl)]
	public static extern NarrowPhaseQuery* JPH_PhysicsSystem_GetNarrowPhaseQuery(PhysicsSystem* system);

	[CLink, CallingConvention(.Cdecl)]
	public static extern NarrowPhaseQuery* JPH_PhysicsSystem_GetNarrowPhaseQueryNoLock(PhysicsSystem* system);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_PhysicsSystem_SetContactListener(PhysicsSystem* system, ContactListener* listener);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_PhysicsSystem_SetBodyActivationListener(PhysicsSystem* system, BodyActivationListener* listener);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_PhysicsSystem_SetSimShapeFilter(PhysicsSystem* system, SimShapeFilter* filter);

	[CLink, CallingConvention(.Cdecl)]
	public static extern bool JPH_PhysicsSystem_WereBodiesInContact(PhysicsSystem* system, BodyID body1, BodyID body2);

	[CLink, CallingConvention(.Cdecl)]
	public static extern uint32 JPH_PhysicsSystem_GetNumBodies(PhysicsSystem* system);

	[CLink, CallingConvention(.Cdecl)]
	public static extern uint32 JPH_PhysicsSystem_GetNumActiveBodies(PhysicsSystem* system, BodyType typeValue);

	[CLink, CallingConvention(.Cdecl)]
	public static extern uint32 JPH_PhysicsSystem_GetMaxBodies(PhysicsSystem* system);

	[CLink, CallingConvention(.Cdecl)]
	public static extern uint32 JPH_PhysicsSystem_GetNumConstraints(PhysicsSystem* system);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_PhysicsSystem_SetGravity(PhysicsSystem* system, Vec3* value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_PhysicsSystem_GetGravity(PhysicsSystem* system, Vec3* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_PhysicsSystem_AddConstraint(PhysicsSystem* system, Constraint* constraint);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_PhysicsSystem_RemoveConstraint(PhysicsSystem* system, Constraint* constraint);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_PhysicsSystem_AddConstraints(PhysicsSystem* system, Constraint** constraints, uint32 count);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_PhysicsSystem_RemoveConstraints(PhysicsSystem* system, Constraint** constraints, uint32 count);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_PhysicsSystem_AddStepListener(PhysicsSystem* system, PhysicsStepListener* listener);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_PhysicsSystem_RemoveStepListener(PhysicsSystem* system, PhysicsStepListener* listener);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_PhysicsSystem_GetBodies(PhysicsSystem* system, BodyID* ids, uint32 count);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_PhysicsSystem_GetActiveBodies(PhysicsSystem* system, BodyType typeValue, BodyID* ids, uint32 count);

	[CLink, CallingConvention(.Cdecl)]
	public static extern BodyID* JPH_PhysicsSystem_GetActiveBodiesUnsafe(PhysicsSystem* system, BodyType typeValue);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_PhysicsSystem_GetConstraints(PhysicsSystem* system, Constraint** constraints, uint32 count);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_PhysicsSystem_ActivateBodiesInAABox(PhysicsSystem* system, AABox* boxValue, ObjectLayer layer);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_PhysicsSystem_DrawBodies(PhysicsSystem* system, DrawSettings* settings, DebugRenderer* renderer, BodyDrawFilter* bodyFilter);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_PhysicsSystem_DrawConstraints(PhysicsSystem* system, DebugRenderer* renderer);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_PhysicsSystem_DrawConstraintLimits(PhysicsSystem* system, DebugRenderer* renderer);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_PhysicsSystem_DrawConstraintReferenceFrame(PhysicsSystem* system, DebugRenderer* renderer);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_PhysicsStepListener_SetProcs(PhysicsStepListener_Procs* procs);

	[CLink, CallingConvention(.Cdecl)]
	public static extern PhysicsStepListener* JPH_PhysicsStepListener_Create(void* userData);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_PhysicsStepListener_Destroy(PhysicsStepListener* listener);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_Math_Sin(float value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_Math_Cos(float value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Quat_FromTo(Vec3* from, Vec3* to, Quat* quat);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Quat_GetAxisAngle(Quat* quat, Vec3* outAxis, float* outAngle);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Quat_GetEulerAngles(Quat* quat, Vec3* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Quat_RotateAxisX(Quat* quat, Vec3* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Quat_RotateAxisY(Quat* quat, Vec3* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Quat_RotateAxisZ(Quat* quat, Vec3* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Quat_Inversed(Quat* quat, Quat* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Quat_GetPerpendicular(Quat* quat, Quat* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_Quat_GetRotationAngle(Quat* quat, Vec3* axis);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Quat_FromEulerAngles(Vec3* angles, Quat* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Quat_Add(Quat* q1, Quat* q2, Quat* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Quat_Subtract(Quat* q1, Quat* q2, Quat* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Quat_Multiply(Quat* q1, Quat* q2, Quat* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Quat_MultiplyScalar(Quat* q, float scalar, Quat* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Quat_DivideScalar(Quat* q, float scalar, Quat* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Quat_Dot(Quat* q1, Quat* q2, float* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Quat_Conjugated(Quat* quat, Quat* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Quat_GetTwist(Quat* quat, Vec3* axis, Quat* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Quat_GetSwingTwist(Quat* quat, Quat* outSwing, Quat* outTwist);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Quat_Lerp(Quat* from, Quat* to, float fraction, Quat* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Quat_Slerp(Quat* from, Quat* to, float fraction, Quat* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Quat_Rotate(Quat* quat, Vec3* vec, Vec3* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Quat_InverseRotate(Quat* quat, Vec3* vec, Vec3* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Vec3_AxisX(Vec3* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Vec3_AxisY(Vec3* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Vec3_AxisZ(Vec3* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern bool JPH_Vec3_IsClose(Vec3* v1, Vec3* v2, float maxDistSq);

	[CLink, CallingConvention(.Cdecl)]
	public static extern bool JPH_Vec3_IsNearZero(Vec3* v, float maxDistSq);

	[CLink, CallingConvention(.Cdecl)]
	public static extern bool JPH_Vec3_IsNormalized(Vec3* v, float tolerance);

	[CLink, CallingConvention(.Cdecl)]
	public static extern bool JPH_Vec3_IsNaN(Vec3* v);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Vec3_Negate(Vec3* v, Vec3* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Vec3_Normalized(Vec3* v, Vec3* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Vec3_Cross(Vec3* v1, Vec3* v2, Vec3* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Vec3_Abs(Vec3* v, Vec3* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_Vec3_Length(Vec3* v);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_Vec3_LengthSquared(Vec3* v);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Vec3_DotProduct(Vec3* v1, Vec3* v2, float* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Vec3_Normalize(Vec3* v, Vec3* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Vec3_Add(Vec3* v1, Vec3* v2, Vec3* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Vec3_Subtract(Vec3* v1, Vec3* v2, Vec3* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Vec3_Multiply(Vec3* v1, Vec3* v2, Vec3* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Vec3_MultiplyScalar(Vec3* v, float scalar, Vec3* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Vec3_MultiplyMatrix(Mat4* left, Vec3* right, Vec3* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Vec3_Divide(Vec3* v1, Vec3* v2, Vec3* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Vec3_DivideScalar(Vec3* v, float scalar, Vec3* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Vec3_GetNormalizedPerpendicular(Vec3* v, Vec3* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Mat4_Add(Mat4* m1, Mat4* m2, Mat4* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Mat4_Subtract(Mat4* m1, Mat4* m2, Mat4* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Mat4_Multiply(Mat4* m1, Mat4* m2, Mat4* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Mat4_MultiplyScalar(Mat4* m, float scalar, Mat4* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Mat4_Zero(Mat4* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Mat4_Identity(Mat4* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Mat4_Rotation(Mat4* result, Quat* rotation);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Mat4_Rotation2(Mat4* result, Vec3* axis, float angle);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Mat4_Translation(Mat4* result, Vec3* translation);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Mat4_RotationTranslation(Mat4* result, Quat* rotation, Vec3* translation);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Mat4_InverseRotationTranslation(Mat4* result, Quat* rotation, Vec3* translation);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Mat4_Scale(Mat4* result, Vec3* scale);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Mat4_Transposed(Mat4* m, Mat4* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Mat4_Inversed(Mat4* matrix, Mat4* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Mat4_GetAxisX(Mat4* matrix, Vec3* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Mat4_GetAxisY(Mat4* matrix, Vec3* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Mat4_GetAxisZ(Mat4* matrix, Vec3* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Mat4_GetTranslation(Mat4* matrix, Vec3* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Mat4_GetQuaternion(Mat4* matrix, Quat* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_RMat4_Zero(RMat4* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_RMat4_Identity(RMat4* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_RMat4_Rotation(RMat4* result, Quat* rotation);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_RMat4_Translation(RMat4* result, RVec3* translation);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_RMat4_RotationTranslation(RMat4* result, Quat* rotation, RVec3* translation);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_RMat4_InverseRotationTranslation(RMat4* result, Quat* rotation, RVec3* translation);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_RMat4_Scale(RMat4* result, Vec3* scale);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_RMat4_Inversed(RMat4* m, RMat4* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern PhysicsMaterial* JPH_PhysicsMaterial_Create(char8* name, uint32 color);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_PhysicsMaterial_Destroy(PhysicsMaterial* material);

	[CLink, CallingConvention(.Cdecl)]
	public static extern char8* JPH_PhysicsMaterial_GetDebugName(PhysicsMaterial* material);

	[CLink, CallingConvention(.Cdecl)]
	public static extern uint32 JPH_PhysicsMaterial_GetDebugColor(PhysicsMaterial* material);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_GroupFilter_Destroy(GroupFilter* groupFilter);

	[CLink, CallingConvention(.Cdecl)]
	public static extern bool JPH_GroupFilter_CanCollide(GroupFilter* groupFilter, CollisionGroup* group1, CollisionGroup* group2);

	[CLink, CallingConvention(.Cdecl)]
	public static extern GroupFilterTable* JPH_GroupFilterTable_Create(uint32 numSubGroups);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_GroupFilterTable_DisableCollision(GroupFilterTable* table, CollisionSubGroupID subGroup1, CollisionSubGroupID subGroup2);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_GroupFilterTable_EnableCollision(GroupFilterTable* table, CollisionSubGroupID subGroup1, CollisionSubGroupID subGroup2);

	[CLink, CallingConvention(.Cdecl)]
	public static extern bool JPH_GroupFilterTable_IsCollisionEnabled(GroupFilterTable* table, CollisionSubGroupID subGroup1, CollisionSubGroupID subGroup2);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_ShapeSettings_Destroy(ShapeSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern uint64 JPH_ShapeSettings_GetUserData(ShapeSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_ShapeSettings_SetUserData(ShapeSettings* settings, uint64 userData);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Shape_Draw(Shape* shape, DebugRenderer* renderer, RMat4* centerOfMassTransform, Vec3* scale, Color color, bool useMaterialColors, bool drawWireframe);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Shape_Destroy(Shape* shape);

	[CLink, CallingConvention(.Cdecl)]
	public static extern ShapeType JPH_Shape_GetType(Shape* shape);

	[CLink, CallingConvention(.Cdecl)]
	public static extern ShapeSubType JPH_Shape_GetSubType(Shape* shape);

	[CLink, CallingConvention(.Cdecl)]
	public static extern uint64 JPH_Shape_GetUserData(Shape* shape);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Shape_SetUserData(Shape* shape, uint64 userData);

	[CLink, CallingConvention(.Cdecl)]
	public static extern bool JPH_Shape_MustBeStatic(Shape* shape);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Shape_GetCenterOfMass(Shape* shape, Vec3* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Shape_GetLocalBounds(Shape* shape, AABox* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern uint32 JPH_Shape_GetSubShapeIDBitsRecursive(Shape* shape);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Shape_GetWorldSpaceBounds(Shape* shape, RMat4* centerOfMassTransform, Vec3* scale, AABox* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_Shape_GetInnerRadius(Shape* shape);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Shape_GetMassProperties(Shape* shape, MassProperties* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern Shape* JPH_Shape_GetLeafShape(Shape* shape, SubShapeID subShapeID, SubShapeID* remainder);

	[CLink, CallingConvention(.Cdecl)]
	public static extern PhysicsMaterial* JPH_Shape_GetMaterial(Shape* shape, SubShapeID subShapeID);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Shape_GetSurfaceNormal(Shape* shape, SubShapeID subShapeID, Vec3* localPosition, Vec3* normal);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Shape_GetSupportingFace(Shape* shape, SubShapeID subShapeID, Vec3* direction, Vec3* scale, Mat4* centerOfMassTransform, SupportingFace* outVertices);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_Shape_GetVolume(Shape* shape);

	[CLink, CallingConvention(.Cdecl)]
	public static extern bool JPH_Shape_IsValidScale(Shape* shape, Vec3* scale);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Shape_MakeScaleValid(Shape* shape, Vec3* scale, Vec3* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern Shape* JPH_Shape_ScaleShape(Shape* shape, Vec3* scale);

	[CLink, CallingConvention(.Cdecl)]
	public static extern bool JPH_Shape_CastRay(Shape* shape, Vec3* origin, Vec3* direction, RayCastResult* hit);

	[CLink, CallingConvention(.Cdecl)]
	public static extern bool JPH_Shape_CastRay2(Shape* shape, Vec3* origin, Vec3* direction, RayCastSettings* rayCastSettings, CollisionCollectorType collectorType, void* callback, void* userData, ShapeFilter* shapeFilter);

	[CLink, CallingConvention(.Cdecl)]
	public static extern bool JPH_Shape_CollidePoint(Shape* shape, Vec3* point, ShapeFilter* shapeFilter);

	[CLink, CallingConvention(.Cdecl)]
	public static extern bool JPH_Shape_CollidePoint2(Shape* shape, Vec3* point, CollisionCollectorType collectorType, void* callback, void* userData, ShapeFilter* shapeFilter);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_ConvexShapeSettings_GetDensity(ConvexShapeSettings* shape);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_ConvexShapeSettings_SetDensity(ConvexShapeSettings* shape, float value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_ConvexShape_GetDensity(ConvexShape* shape);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_ConvexShape_SetDensity(ConvexShape* shape, float inDensity);

	[CLink, CallingConvention(.Cdecl)]
	public static extern BoxShapeSettings* JPH_BoxShapeSettings_Create(Vec3* halfExtent, float convexRadius);

	[CLink, CallingConvention(.Cdecl)]
	public static extern BoxShape* JPH_BoxShapeSettings_CreateShape(BoxShapeSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern BoxShape* JPH_BoxShape_Create(Vec3* halfExtent, float convexRadius);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_BoxShape_GetHalfExtent(BoxShape* shape, Vec3* halfExtent);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_BoxShape_GetConvexRadius(BoxShape* shape);

	[CLink, CallingConvention(.Cdecl)]
	public static extern SphereShapeSettings* JPH_SphereShapeSettings_Create(float radius);

	[CLink, CallingConvention(.Cdecl)]
	public static extern SphereShape* JPH_SphereShapeSettings_CreateShape(SphereShapeSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_SphereShapeSettings_GetRadius(SphereShapeSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_SphereShapeSettings_SetRadius(SphereShapeSettings* settings, float radius);

	[CLink, CallingConvention(.Cdecl)]
	public static extern SphereShape* JPH_SphereShape_Create(float radius);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_SphereShape_GetRadius(SphereShape* shape);

	[CLink, CallingConvention(.Cdecl)]
	public static extern PlaneShapeSettings* JPH_PlaneShapeSettings_Create(Plane* plane, PhysicsMaterial* material, float halfExtent);

	[CLink, CallingConvention(.Cdecl)]
	public static extern PlaneShape* JPH_PlaneShapeSettings_CreateShape(PlaneShapeSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern PlaneShape* JPH_PlaneShape_Create(Plane* plane, PhysicsMaterial* material, float halfExtent);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_PlaneShape_GetPlane(PlaneShape* shape, Plane* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_PlaneShape_GetHalfExtent(PlaneShape* shape);

	[CLink, CallingConvention(.Cdecl)]
	public static extern TriangleShapeSettings* JPH_TriangleShapeSettings_Create(Vec3* v1, Vec3* v2, Vec3* v3, float convexRadius);

	[CLink, CallingConvention(.Cdecl)]
	public static extern TriangleShape* JPH_TriangleShapeSettings_CreateShape(TriangleShapeSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern TriangleShape* JPH_TriangleShape_Create(Vec3* v1, Vec3* v2, Vec3* v3, float convexRadius);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_TriangleShape_GetConvexRadius(TriangleShape* shape);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_TriangleShape_GetVertex1(TriangleShape* shape, Vec3* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_TriangleShape_GetVertex2(TriangleShape* shape, Vec3* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_TriangleShape_GetVertex3(TriangleShape* shape, Vec3* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern CapsuleShapeSettings* JPH_CapsuleShapeSettings_Create(float halfHeightOfCylinder, float radius);

	[CLink, CallingConvention(.Cdecl)]
	public static extern CapsuleShape* JPH_CapsuleShapeSettings_CreateShape(CapsuleShapeSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern CapsuleShape* JPH_CapsuleShape_Create(float halfHeightOfCylinder, float radius);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_CapsuleShape_GetRadius(CapsuleShape* shape);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_CapsuleShape_GetHalfHeightOfCylinder(CapsuleShape* shape);

	[CLink, CallingConvention(.Cdecl)]
	public static extern CylinderShapeSettings* JPH_CylinderShapeSettings_Create(float halfHeight, float radius, float convexRadius);

	[CLink, CallingConvention(.Cdecl)]
	public static extern CylinderShape* JPH_CylinderShapeSettings_CreateShape(CylinderShapeSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern CylinderShape* JPH_CylinderShape_Create(float halfHeight, float radius);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_CylinderShape_GetRadius(CylinderShape* shape);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_CylinderShape_GetHalfHeight(CylinderShape* shape);

	[CLink, CallingConvention(.Cdecl)]
	public static extern TaperedCylinderShapeSettings* JPH_TaperedCylinderShapeSettings_Create(float halfHeightOfTaperedCylinder, float topRadius, float bottomRadius, float convexRadius, PhysicsMaterial* material);

	[CLink, CallingConvention(.Cdecl)]
	public static extern TaperedCylinderShape* JPH_TaperedCylinderShapeSettings_CreateShape(TaperedCylinderShapeSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_TaperedCylinderShape_GetTopRadius(TaperedCylinderShape* shape);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_TaperedCylinderShape_GetBottomRadius(TaperedCylinderShape* shape);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_TaperedCylinderShape_GetConvexRadius(TaperedCylinderShape* shape);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_TaperedCylinderShape_GetHalfHeight(TaperedCylinderShape* shape);

	[CLink, CallingConvention(.Cdecl)]
	public static extern ConvexHullShapeSettings* JPH_ConvexHullShapeSettings_Create(Vec3* points, uint32 pointsCount, float maxConvexRadius);

	[CLink, CallingConvention(.Cdecl)]
	public static extern ConvexHullShape* JPH_ConvexHullShapeSettings_CreateShape(ConvexHullShapeSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern uint32 JPH_ConvexHullShape_GetNumPoints(ConvexHullShape* shape);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_ConvexHullShape_GetPoint(ConvexHullShape* shape, uint32 index, Vec3* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern uint32 JPH_ConvexHullShape_GetNumFaces(ConvexHullShape* shape);

	[CLink, CallingConvention(.Cdecl)]
	public static extern uint32 JPH_ConvexHullShape_GetNumVerticesInFace(ConvexHullShape* shape, uint32 faceIndex);

	[CLink, CallingConvention(.Cdecl)]
	public static extern uint32 JPH_ConvexHullShape_GetFaceVertices(ConvexHullShape* shape, uint32 faceIndex, uint32 maxVertices, uint32* vertices);

	[CLink, CallingConvention(.Cdecl)]
	public static extern MeshShapeSettings* JPH_MeshShapeSettings_Create(Triangle* triangles, uint32 triangleCount);

	[CLink, CallingConvention(.Cdecl)]
	public static extern MeshShapeSettings* JPH_MeshShapeSettings_Create2(Vec3* vertices, uint32 verticesCount, IndexedTriangle* triangles, uint32 triangleCount);

	[CLink, CallingConvention(.Cdecl)]
	public static extern uint32 JPH_MeshShapeSettings_GetMaxTrianglesPerLeaf(MeshShapeSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_MeshShapeSettings_SetMaxTrianglesPerLeaf(MeshShapeSettings* settings, uint32 value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_MeshShapeSettings_GetActiveEdgeCosThresholdAngle(MeshShapeSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_MeshShapeSettings_SetActiveEdgeCosThresholdAngle(MeshShapeSettings* settings, float value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern bool JPH_MeshShapeSettings_GetPerTriangleUserData(MeshShapeSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_MeshShapeSettings_SetPerTriangleUserData(MeshShapeSettings* settings, bool value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern Mesh_Shape_BuildQuality JPH_MeshShapeSettings_GetBuildQuality(MeshShapeSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_MeshShapeSettings_SetBuildQuality(MeshShapeSettings* settings, Mesh_Shape_BuildQuality value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_MeshShapeSettings_Sanitize(MeshShapeSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern MeshShape* JPH_MeshShapeSettings_CreateShape(MeshShapeSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern uint32 JPH_MeshShape_GetTriangleUserData(MeshShape* shape, SubShapeID id);

	[CLink, CallingConvention(.Cdecl)]
	public static extern HeightFieldShapeSettings* JPH_HeightFieldShapeSettings_Create(float* samples, Vec3* offset, Vec3* scale, uint32 sampleCount, uint8* materialIndices);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_HeightFieldShapeSettings_DetermineMinAndMaxSample(HeightFieldShapeSettings* settings, float* pOutMinValue, float* pOutMaxValue, float* pOutQuantizationScale);

	[CLink, CallingConvention(.Cdecl)]
	public static extern uint32 JPH_HeightFieldShapeSettings_CalculateBitsPerSampleForError(HeightFieldShapeSettings* settings, float maxError);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_HeightFieldShapeSettings_GetOffset(HeightFieldShapeSettings* shape, Vec3* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_HeightFieldShapeSettings_SetOffset(HeightFieldShapeSettings* settings, Vec3* value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_HeightFieldShapeSettings_GetScale(HeightFieldShapeSettings* shape, Vec3* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_HeightFieldShapeSettings_SetScale(HeightFieldShapeSettings* settings, Vec3* value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern uint32 JPH_HeightFieldShapeSettings_GetSampleCount(HeightFieldShapeSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_HeightFieldShapeSettings_SetSampleCount(HeightFieldShapeSettings* settings, uint32 value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_HeightFieldShapeSettings_GetMinHeightValue(HeightFieldShapeSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_HeightFieldShapeSettings_SetMinHeightValue(HeightFieldShapeSettings* settings, float value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_HeightFieldShapeSettings_GetMaxHeightValue(HeightFieldShapeSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_HeightFieldShapeSettings_SetMaxHeightValue(HeightFieldShapeSettings* settings, float value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern uint32 JPH_HeightFieldShapeSettings_GetBlockSize(HeightFieldShapeSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_HeightFieldShapeSettings_SetBlockSize(HeightFieldShapeSettings* settings, uint32 value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern uint32 JPH_HeightFieldShapeSettings_GetBitsPerSample(HeightFieldShapeSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_HeightFieldShapeSettings_SetBitsPerSample(HeightFieldShapeSettings* settings, uint32 value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_HeightFieldShapeSettings_GetActiveEdgeCosThresholdAngle(HeightFieldShapeSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_HeightFieldShapeSettings_SetActiveEdgeCosThresholdAngle(HeightFieldShapeSettings* settings, float value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern HeightFieldShape* JPH_HeightFieldShapeSettings_CreateShape(HeightFieldShapeSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern uint32 JPH_HeightFieldShape_GetSampleCount(HeightFieldShape* shape);

	[CLink, CallingConvention(.Cdecl)]
	public static extern uint32 JPH_HeightFieldShape_GetBlockSize(HeightFieldShape* shape);

	[CLink, CallingConvention(.Cdecl)]
	public static extern PhysicsMaterial* JPH_HeightFieldShape_GetMaterial(HeightFieldShape* shape, uint32 x, uint32 y);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_HeightFieldShape_GetPosition(HeightFieldShape* shape, uint32 x, uint32 y, Vec3* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern bool JPH_HeightFieldShape_IsNoCollision(HeightFieldShape* shape, uint32 x, uint32 y);

	[CLink, CallingConvention(.Cdecl)]
	public static extern bool JPH_HeightFieldShape_ProjectOntoSurface(HeightFieldShape* shape, Vec3* localPosition, Vec3* outSurfacePosition, SubShapeID* outSubShapeID);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_HeightFieldShape_GetMinHeightValue(HeightFieldShape* shape);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_HeightFieldShape_GetMaxHeightValue(HeightFieldShape* shape);

	[CLink, CallingConvention(.Cdecl)]
	public static extern TaperedCapsuleShapeSettings* JPH_TaperedCapsuleShapeSettings_Create(float halfHeightOfTaperedCylinder, float topRadius, float bottomRadius);

	[CLink, CallingConvention(.Cdecl)]
	public static extern TaperedCapsuleShape* JPH_TaperedCapsuleShapeSettings_CreateShape(TaperedCapsuleShapeSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_TaperedCapsuleShape_GetTopRadius(TaperedCapsuleShape* shape);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_TaperedCapsuleShape_GetBottomRadius(TaperedCapsuleShape* shape);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_TaperedCapsuleShape_GetHalfHeight(TaperedCapsuleShape* shape);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_CompoundShapeSettings_AddShape(CompoundShapeSettings* settings, Vec3* position, Quat* rotation, ShapeSettings* shapeSettings, uint32 userData);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_CompoundShapeSettings_AddShape2(CompoundShapeSettings* settings, Vec3* position, Quat* rotation, Shape* shape, uint32 userData);

	[CLink, CallingConvention(.Cdecl)]
	public static extern uint32 JPH_CompoundShape_GetNumSubShapes(CompoundShape* shape);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_CompoundShape_GetSubShape(CompoundShape* shape, uint32 index, Shape** subShape, Vec3* positionCOM, Quat* rotation, uint32* userData);

	[CLink, CallingConvention(.Cdecl)]
	public static extern uint32 JPH_CompoundShape_GetSubShapeIndexFromID(CompoundShape* shape, SubShapeID id, SubShapeID* remainder);

	[CLink, CallingConvention(.Cdecl)]
	public static extern StaticCompoundShapeSettings* JPH_StaticCompoundShapeSettings_Create();

	[CLink, CallingConvention(.Cdecl)]
	public static extern StaticCompoundShape* JPH_StaticCompoundShape_Create(StaticCompoundShapeSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern MutableCompoundShapeSettings* JPH_MutableCompoundShapeSettings_Create();

	[CLink, CallingConvention(.Cdecl)]
	public static extern MutableCompoundShape* JPH_MutableCompoundShape_Create(MutableCompoundShapeSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern uint32 JPH_MutableCompoundShape_AddShape(MutableCompoundShape* shape, Vec3* position, Quat* rotation, Shape* child, uint32 userData, uint32 index);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_MutableCompoundShape_RemoveShape(MutableCompoundShape* shape, uint32 index);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_MutableCompoundShape_ModifyShape(MutableCompoundShape* shape, uint32 index, Vec3* position, Quat* rotation);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_MutableCompoundShape_ModifyShape2(MutableCompoundShape* shape, uint32 index, Vec3* position, Quat* rotation, Shape* newShape);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_MutableCompoundShape_AdjustCenterOfMass(MutableCompoundShape* shape);

	[CLink, CallingConvention(.Cdecl)]
	public static extern Shape* JPH_DecoratedShape_GetInnerShape(DecoratedShape* shape);

	[CLink, CallingConvention(.Cdecl)]
	public static extern RotatedTranslatedShapeSettings* JPH_RotatedTranslatedShapeSettings_Create(Vec3* position, Quat* rotation, ShapeSettings* shapeSettings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern RotatedTranslatedShapeSettings* JPH_RotatedTranslatedShapeSettings_Create2(Vec3* position, Quat* rotation, Shape* shape);

	[CLink, CallingConvention(.Cdecl)]
	public static extern RotatedTranslatedShape* JPH_RotatedTranslatedShapeSettings_CreateShape(RotatedTranslatedShapeSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern RotatedTranslatedShape* JPH_RotatedTranslatedShape_Create(Vec3* position, Quat* rotation, Shape* shape);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_RotatedTranslatedShape_GetPosition(RotatedTranslatedShape* shape, Vec3* position);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_RotatedTranslatedShape_GetRotation(RotatedTranslatedShape* shape, Quat* rotation);

	[CLink, CallingConvention(.Cdecl)]
	public static extern ScaledShapeSettings* JPH_ScaledShapeSettings_Create(ShapeSettings* shapeSettings, Vec3* scale);

	[CLink, CallingConvention(.Cdecl)]
	public static extern ScaledShapeSettings* JPH_ScaledShapeSettings_Create2(Shape* shape, Vec3* scale);

	[CLink, CallingConvention(.Cdecl)]
	public static extern ScaledShape* JPH_ScaledShapeSettings_CreateShape(ScaledShapeSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern ScaledShape* JPH_ScaledShape_Create(Shape* shape, Vec3* scale);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_ScaledShape_GetScale(ScaledShape* shape, Vec3* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern OffsetCenterOfMassShapeSettings* JPH_OffsetCenterOfMassShapeSettings_Create(Vec3* offset, ShapeSettings* shapeSettings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern OffsetCenterOfMassShapeSettings* JPH_OffsetCenterOfMassShapeSettings_Create2(Vec3* offset, Shape* shape);

	[CLink, CallingConvention(.Cdecl)]
	public static extern OffsetCenterOfMassShape* JPH_OffsetCenterOfMassShapeSettings_CreateShape(OffsetCenterOfMassShapeSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern OffsetCenterOfMassShape* JPH_OffsetCenterOfMassShape_Create(Vec3* offset, Shape* shape);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_OffsetCenterOfMassShape_GetOffset(OffsetCenterOfMassShape* shape, Vec3* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern EmptyShapeSettings* JPH_EmptyShapeSettings_Create(Vec3* centerOfMass);

	[CLink, CallingConvention(.Cdecl)]
	public static extern EmptyShape* JPH_EmptyShapeSettings_CreateShape(EmptyShapeSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern BodyCreationSettings* JPH_BodyCreationSettings_Create();

	[CLink, CallingConvention(.Cdecl)]
	public static extern BodyCreationSettings* JPH_BodyCreationSettings_Create2(ShapeSettings* settings, RVec3* position, Quat* rotation, MotionType motionType, ObjectLayer objectLayer);

	[CLink, CallingConvention(.Cdecl)]
	public static extern BodyCreationSettings* JPH_BodyCreationSettings_Create3(Shape* shape, RVec3* position, Quat* rotation, MotionType motionType, ObjectLayer objectLayer);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_BodyCreationSettings_Destroy(BodyCreationSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_BodyCreationSettings_GetPosition(BodyCreationSettings* settings, RVec3* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_BodyCreationSettings_SetPosition(BodyCreationSettings* settings, RVec3* value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_BodyCreationSettings_GetRotation(BodyCreationSettings* settings, Quat* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_BodyCreationSettings_SetRotation(BodyCreationSettings* settings, Quat* value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_BodyCreationSettings_GetLinearVelocity(BodyCreationSettings* settings, Vec3* velocity);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_BodyCreationSettings_SetLinearVelocity(BodyCreationSettings* settings, Vec3* velocity);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_BodyCreationSettings_GetAngularVelocity(BodyCreationSettings* settings, Vec3* velocity);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_BodyCreationSettings_SetAngularVelocity(BodyCreationSettings* settings, Vec3* velocity);

	[CLink, CallingConvention(.Cdecl)]
	public static extern uint64 JPH_BodyCreationSettings_GetUserData(BodyCreationSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_BodyCreationSettings_SetUserData(BodyCreationSettings* settings, uint64 value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern ObjectLayer JPH_BodyCreationSettings_GetObjectLayer(BodyCreationSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_BodyCreationSettings_SetObjectLayer(BodyCreationSettings* settings, ObjectLayer value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_BodyCreationSettings_GetCollisionGroup(BodyCreationSettings* settings, CollisionGroup* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_BodyCreationSettings_SetCollisionGroup(BodyCreationSettings* settings, CollisionGroup* value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern MotionType JPH_BodyCreationSettings_GetMotionType(BodyCreationSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_BodyCreationSettings_SetMotionType(BodyCreationSettings* settings, MotionType value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern AllowedDOFs JPH_BodyCreationSettings_GetAllowedDOFs(BodyCreationSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_BodyCreationSettings_SetAllowedDOFs(BodyCreationSettings* settings, AllowedDOFs value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern bool JPH_BodyCreationSettings_GetAllowDynamicOrKinematic(BodyCreationSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_BodyCreationSettings_SetAllowDynamicOrKinematic(BodyCreationSettings* settings, bool value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern bool JPH_BodyCreationSettings_GetIsSensor(BodyCreationSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_BodyCreationSettings_SetIsSensor(BodyCreationSettings* settings, bool value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern bool JPH_BodyCreationSettings_GetCollideKinematicVsNonDynamic(BodyCreationSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_BodyCreationSettings_SetCollideKinematicVsNonDynamic(BodyCreationSettings* settings, bool value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern bool JPH_BodyCreationSettings_GetUseManifoldReduction(BodyCreationSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_BodyCreationSettings_SetUseManifoldReduction(BodyCreationSettings* settings, bool value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern bool JPH_BodyCreationSettings_GetApplyGyroscopicForce(BodyCreationSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_BodyCreationSettings_SetApplyGyroscopicForce(BodyCreationSettings* settings, bool value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern MotionQuality JPH_BodyCreationSettings_GetMotionQuality(BodyCreationSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_BodyCreationSettings_SetMotionQuality(BodyCreationSettings* settings, MotionQuality value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern bool JPH_BodyCreationSettings_GetEnhancedInternalEdgeRemoval(BodyCreationSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_BodyCreationSettings_SetEnhancedInternalEdgeRemoval(BodyCreationSettings* settings, bool value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern bool JPH_BodyCreationSettings_GetAllowSleeping(BodyCreationSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_BodyCreationSettings_SetAllowSleeping(BodyCreationSettings* settings, bool value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_BodyCreationSettings_GetFriction(BodyCreationSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_BodyCreationSettings_SetFriction(BodyCreationSettings* settings, float value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_BodyCreationSettings_GetRestitution(BodyCreationSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_BodyCreationSettings_SetRestitution(BodyCreationSettings* settings, float value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_BodyCreationSettings_GetLinearDamping(BodyCreationSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_BodyCreationSettings_SetLinearDamping(BodyCreationSettings* settings, float value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_BodyCreationSettings_GetAngularDamping(BodyCreationSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_BodyCreationSettings_SetAngularDamping(BodyCreationSettings* settings, float value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_BodyCreationSettings_GetMaxLinearVelocity(BodyCreationSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_BodyCreationSettings_SetMaxLinearVelocity(BodyCreationSettings* settings, float value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_BodyCreationSettings_GetMaxAngularVelocity(BodyCreationSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_BodyCreationSettings_SetMaxAngularVelocity(BodyCreationSettings* settings, float value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_BodyCreationSettings_GetGravityFactor(BodyCreationSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_BodyCreationSettings_SetGravityFactor(BodyCreationSettings* settings, float value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern uint32 JPH_BodyCreationSettings_GetNumVelocityStepsOverride(BodyCreationSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_BodyCreationSettings_SetNumVelocityStepsOverride(BodyCreationSettings* settings, uint32 value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern uint32 JPH_BodyCreationSettings_GetNumPositionStepsOverride(BodyCreationSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_BodyCreationSettings_SetNumPositionStepsOverride(BodyCreationSettings* settings, uint32 value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern OverrideMassProperties JPH_BodyCreationSettings_GetOverrideMassProperties(BodyCreationSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_BodyCreationSettings_SetOverrideMassProperties(BodyCreationSettings* settings, OverrideMassProperties value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_BodyCreationSettings_GetInertiaMultiplier(BodyCreationSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_BodyCreationSettings_SetInertiaMultiplier(BodyCreationSettings* settings, float value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_BodyCreationSettings_GetMassPropertiesOverride(BodyCreationSettings* settings, MassProperties* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_BodyCreationSettings_SetMassPropertiesOverride(BodyCreationSettings* settings, MassProperties* massProperties);

	[CLink, CallingConvention(.Cdecl)]
	public static extern SoftBodySharedSettings* JPH_SoftBodySharedSettings_Create();

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_SoftBodySharedSettings_Destroy(SoftBodySharedSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_SoftBodySharedSettings_AddVertex(SoftBodySharedSettings* settings, SoftVertex* vertex);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_SoftBodySharedSettings_AddVertices(SoftBodySharedSettings* settings, SoftVertex* vertices, uint32 count);

	[CLink, CallingConvention(.Cdecl)]
	public static extern bool JPH_SoftBodySharedSettings_RemoveVertex(SoftBodySharedSettings* settings, uint32 index);

	[CLink, CallingConvention(.Cdecl)]
	public static extern uint32 JPH_SoftBodySharedSettings_GetVertexCount(SoftBodySharedSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern bool JPH_SoftBodySharedSettings_GetVertex(SoftBodySharedSettings* settings, uint32 index, SoftVertex* outVertex);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_SoftBodySharedSettings_AddFace(SoftBodySharedSettings* settings, SoftFace* face);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_SoftBodySharedSettings_AddFaces(SoftBodySharedSettings* settings, SoftFace* faces, uint32 count);

	[CLink, CallingConvention(.Cdecl)]
	public static extern bool JPH_SoftBodySharedSettings_RemoveFace(SoftBodySharedSettings* settings, uint32 index);

	[CLink, CallingConvention(.Cdecl)]
	public static extern uint32 JPH_SoftBodySharedSettings_GetFaceCount(SoftBodySharedSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern bool JPH_SoftBodySharedSettings_GetFace(SoftBodySharedSettings* settings, uint32 index, SoftFace* outFace);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_SoftBodySharedSettings_CreateConstraints(SoftBodySharedSettings* settings, float compliance, SoftBodyBendType bendType);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_SoftBodySharedSettings_Optimize(SoftBodySharedSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern SoftBodyCreationSettings* JPH_SoftBodyCreationSettings_Create();

	[CLink, CallingConvention(.Cdecl)]
	public static extern SoftBodyCreationSettings* JPH_SoftBodyCreationSettings_Create2(SoftBodySharedSettings* settings, RVec3* position, Quat* rotation, ObjectLayer objectLayer);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_SoftBodyCreationSettings_Destroy(SoftBodyCreationSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern SoftBodySharedSettings* JPH_SoftBodyCreationSettings_GetSettings(SoftBodyCreationSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_SoftBodyCreationSettings_SetSettings(SoftBodyCreationSettings* settings, SoftBodySharedSettings* sharedSettings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_SoftBodyCreationSettings_GetPosition(SoftBodyCreationSettings* settings, RVec3* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_SoftBodyCreationSettings_SetPosition(SoftBodyCreationSettings* settings, RVec3* value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_SoftBodyCreationSettings_GetRotation(SoftBodyCreationSettings* settings, Quat* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_SoftBodyCreationSettings_SetRotation(SoftBodyCreationSettings* settings, Quat* value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern uint64 JPH_SoftBodyCreationSettings_GetUserData(SoftBodyCreationSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_SoftBodyCreationSettings_SetUserData(SoftBodyCreationSettings* settings, uint64 userData);

	[CLink, CallingConvention(.Cdecl)]
	public static extern ObjectLayer JPH_SoftBodyCreationSettings_GetObjectLayer(SoftBodyCreationSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_SoftBodyCreationSettings_SetObjectLayer(SoftBodyCreationSettings* settings, ObjectLayer value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_SoftBodyCreationSettings_GetCollisionGroup(SoftBodyCreationSettings* settings, CollisionGroup* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_SoftBodyCreationSettings_SetCollisionGroup(SoftBodyCreationSettings* settings, CollisionGroup* group);

	[CLink, CallingConvention(.Cdecl)]
	public static extern uint32 JPH_SoftBodyCreationSettings_GetNumIterations(SoftBodyCreationSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_SoftBodyCreationSettings_SetNumIterations(SoftBodyCreationSettings* settings, uint32 iterations);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_SoftBodyCreationSettings_GetLinearDamping(SoftBodyCreationSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_SoftBodyCreationSettings_SetLinearDamping(SoftBodyCreationSettings* settings, float value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_SoftBodyCreationSettings_GetMaxLinearVelocity(SoftBodyCreationSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_SoftBodyCreationSettings_SetMaxLinearVelocity(SoftBodyCreationSettings* settings, float value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_SoftBodyCreationSettings_GetRestitution(SoftBodyCreationSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_SoftBodyCreationSettings_SetRestitution(SoftBodyCreationSettings* settings, float value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_SoftBodyCreationSettings_GetFriction(SoftBodyCreationSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_SoftBodyCreationSettings_SetFriction(SoftBodyCreationSettings* settings, float value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_SoftBodyCreationSettings_GetPressure(SoftBodyCreationSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_SoftBodyCreationSettings_SetPressure(SoftBodyCreationSettings* settings, float value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_SoftBodyCreationSettings_GetGravityFactor(SoftBodyCreationSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_SoftBodyCreationSettings_SetGravityFactor(SoftBodyCreationSettings* settings, float value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_SoftBodyCreationSettings_GetVertexRadius(SoftBodyCreationSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_SoftBodyCreationSettings_SetVertexRadius(SoftBodyCreationSettings* settings, float value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern bool JPH_SoftBodyCreationSettings_GetUpdatePosition(SoftBodyCreationSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_SoftBodyCreationSettings_SetUpdatePosition(SoftBodyCreationSettings* settings, bool value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern bool JPH_SoftBodyCreationSettings_GetMakeRotationIdentity(SoftBodyCreationSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_SoftBodyCreationSettings_SetMakeRotationIdentity(SoftBodyCreationSettings* settings, bool value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern bool JPH_SoftBodyCreationSettings_GetAllowSleeping(SoftBodyCreationSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_SoftBodyCreationSettings_SetAllowSleeping(SoftBodyCreationSettings* settings, bool value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern bool JPH_SoftBodyCreationSettings_GetFacesDoubleSided(SoftBodyCreationSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_SoftBodyCreationSettings_SetFacesDoubleSided(SoftBodyCreationSettings* settings, bool value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Constraint_Destroy(Constraint* constraint);

	[CLink, CallingConvention(.Cdecl)]
	public static extern ConstraintType JPH_Constraint_GetType(Constraint* constraint);

	[CLink, CallingConvention(.Cdecl)]
	public static extern ConstraintSubType JPH_Constraint_GetSubType(Constraint* constraint);

	[CLink, CallingConvention(.Cdecl)]
	public static extern uint32 JPH_Constraint_GetConstraintPriority(Constraint* constraint);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Constraint_SetConstraintPriority(Constraint* constraint, uint32 priority);

	[CLink, CallingConvention(.Cdecl)]
	public static extern uint32 JPH_Constraint_GetNumVelocityStepsOverride(Constraint* constraint);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Constraint_SetNumVelocityStepsOverride(Constraint* constraint, uint32 value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern uint32 JPH_Constraint_GetNumPositionStepsOverride(Constraint* constraint);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Constraint_SetNumPositionStepsOverride(Constraint* constraint, uint32 value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern bool JPH_Constraint_GetEnabled(Constraint* constraint);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Constraint_SetEnabled(Constraint* constraint, bool enabled);

	[CLink, CallingConvention(.Cdecl)]
	public static extern uint64 JPH_Constraint_GetUserData(Constraint* constraint);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Constraint_SetUserData(Constraint* constraint, uint64 userData);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Constraint_NotifyShapeChanged(Constraint* constraint, BodyID bodyID, Vec3* deltaCOM);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Constraint_ResetWarmStart(Constraint* constraint);

	[CLink, CallingConvention(.Cdecl)]
	public static extern bool JPH_Constraint_IsActive(Constraint* constraint);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Constraint_SetupVelocityConstraint(Constraint* constraint, float deltaTime);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Constraint_WarmStartVelocityConstraint(Constraint* constraint, float warmStartImpulseRatio);

	[CLink, CallingConvention(.Cdecl)]
	public static extern bool JPH_Constraint_SolveVelocityConstraint(Constraint* constraint, float deltaTime);

	[CLink, CallingConvention(.Cdecl)]
	public static extern bool JPH_Constraint_SolvePositionConstraint(Constraint* constraint, float deltaTime, float baumgarte);

	[CLink, CallingConvention(.Cdecl)]
	public static extern Body* JPH_TwoBodyConstraint_GetBody1(TwoBodyConstraint* constraint);

	[CLink, CallingConvention(.Cdecl)]
	public static extern Body* JPH_TwoBodyConstraint_GetBody2(TwoBodyConstraint* constraint);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_TwoBodyConstraint_GetConstraintToBody1Matrix(TwoBodyConstraint* constraint, Mat4* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_TwoBodyConstraint_GetConstraintToBody2Matrix(TwoBodyConstraint* constraint, Mat4* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_FixedConstraintSettings_Init(FixedConstraintSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern FixedConstraint* JPH_FixedConstraint_Create(FixedConstraintSettings* settings, Body* body1, Body* body2);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_FixedConstraint_GetSettings(FixedConstraint* constraint, FixedConstraintSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_FixedConstraint_GetTotalLambdaPosition(FixedConstraint* constraint, Vec3* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_FixedConstraint_GetTotalLambdaRotation(FixedConstraint* constraint, Vec3* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_DistanceConstraintSettings_Init(DistanceConstraintSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern DistanceConstraint* JPH_DistanceConstraint_Create(DistanceConstraintSettings* settings, Body* body1, Body* body2);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_DistanceConstraint_GetSettings(DistanceConstraint* constraint, DistanceConstraintSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_DistanceConstraint_SetDistance(DistanceConstraint* constraint, float minDistance, float maxDistance);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_DistanceConstraint_GetMinDistance(DistanceConstraint* constraint);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_DistanceConstraint_GetMaxDistance(DistanceConstraint* constraint);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_DistanceConstraint_GetLimitsSpringSettings(DistanceConstraint* constraint, SpringSettings* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_DistanceConstraint_SetLimitsSpringSettings(DistanceConstraint* constraint, SpringSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_DistanceConstraint_GetTotalLambdaPosition(DistanceConstraint* constraint);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_PointConstraintSettings_Init(PointConstraintSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern PointConstraint* JPH_PointConstraint_Create(PointConstraintSettings* settings, Body* body1, Body* body2);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_PointConstraint_GetSettings(PointConstraint* constraint, PointConstraintSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_PointConstraint_SetPoint1(PointConstraint* constraint, ConstraintSpace space, RVec3* value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_PointConstraint_SetPoint2(PointConstraint* constraint, ConstraintSpace space, RVec3* value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_PointConstraint_GetLocalSpacePoint1(PointConstraint* constraint, Vec3* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_PointConstraint_GetLocalSpacePoint2(PointConstraint* constraint, Vec3* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_PointConstraint_GetTotalLambdaPosition(PointConstraint* constraint, Vec3* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_HingeConstraintSettings_Init(HingeConstraintSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern HingeConstraint* JPH_HingeConstraint_Create(HingeConstraintSettings* settings, Body* body1, Body* body2);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_HingeConstraint_GetSettings(HingeConstraint* constraint, HingeConstraintSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_HingeConstraint_GetLocalSpacePoint1(HingeConstraint* constraint, Vec3* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_HingeConstraint_GetLocalSpacePoint2(HingeConstraint* constraint, Vec3* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_HingeConstraint_GetLocalSpaceHingeAxis1(HingeConstraint* constraint, Vec3* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_HingeConstraint_GetLocalSpaceHingeAxis2(HingeConstraint* constraint, Vec3* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_HingeConstraint_GetLocalSpaceNormalAxis1(HingeConstraint* constraint, Vec3* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_HingeConstraint_GetLocalSpaceNormalAxis2(HingeConstraint* constraint, Vec3* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_HingeConstraint_GetCurrentAngle(HingeConstraint* constraint);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_HingeConstraint_SetMaxFrictionTorque(HingeConstraint* constraint, float frictionTorque);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_HingeConstraint_GetMaxFrictionTorque(HingeConstraint* constraint);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_HingeConstraint_SetMotorSettings(HingeConstraint* constraint, MotorSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_HingeConstraint_GetMotorSettings(HingeConstraint* constraint, MotorSettings* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_HingeConstraint_SetMotorState(HingeConstraint* constraint, MotorState state);

	[CLink, CallingConvention(.Cdecl)]
	public static extern MotorState JPH_HingeConstraint_GetMotorState(HingeConstraint* constraint);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_HingeConstraint_SetTargetAngularVelocity(HingeConstraint* constraint, float angularVelocity);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_HingeConstraint_GetTargetAngularVelocity(HingeConstraint* constraint);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_HingeConstraint_SetTargetAngle(HingeConstraint* constraint, float angle);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_HingeConstraint_GetTargetAngle(HingeConstraint* constraint);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_HingeConstraint_SetLimits(HingeConstraint* constraint, float inLimitsMin, float inLimitsMax);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_HingeConstraint_GetLimitsMin(HingeConstraint* constraint);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_HingeConstraint_GetLimitsMax(HingeConstraint* constraint);

	[CLink, CallingConvention(.Cdecl)]
	public static extern bool JPH_HingeConstraint_HasLimits(HingeConstraint* constraint);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_HingeConstraint_GetLimitsSpringSettings(HingeConstraint* constraint, SpringSettings* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_HingeConstraint_SetLimitsSpringSettings(HingeConstraint* constraint, SpringSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_HingeConstraint_GetTotalLambdaPosition(HingeConstraint* constraint, Vec3* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_HingeConstraint_GetTotalLambdaRotation(HingeConstraint* constraint, float* rotation);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_HingeConstraint_GetTotalLambdaRotationLimits(HingeConstraint* constraint);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_HingeConstraint_GetTotalLambdaMotor(HingeConstraint* constraint);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_SliderConstraintSettings_Init(SliderConstraintSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_SliderConstraintSettings_SetSliderAxis(SliderConstraintSettings* settings, Vec3* axis);

	[CLink, CallingConvention(.Cdecl)]
	public static extern SliderConstraint* JPH_SliderConstraint_Create(SliderConstraintSettings* settings, Body* body1, Body* body2);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_SliderConstraint_GetSettings(SliderConstraint* constraint, SliderConstraintSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_SliderConstraint_GetCurrentPosition(SliderConstraint* constraint);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_SliderConstraint_SetMaxFrictionForce(SliderConstraint* constraint, float frictionForce);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_SliderConstraint_GetMaxFrictionForce(SliderConstraint* constraint);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_SliderConstraint_SetMotorSettings(SliderConstraint* constraint, MotorSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_SliderConstraint_GetMotorSettings(SliderConstraint* constraint, MotorSettings* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_SliderConstraint_SetMotorState(SliderConstraint* constraint, MotorState state);

	[CLink, CallingConvention(.Cdecl)]
	public static extern MotorState JPH_SliderConstraint_GetMotorState(SliderConstraint* constraint);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_SliderConstraint_SetTargetVelocity(SliderConstraint* constraint, float velocity);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_SliderConstraint_GetTargetVelocity(SliderConstraint* constraint);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_SliderConstraint_SetTargetPosition(SliderConstraint* constraint, float position);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_SliderConstraint_GetTargetPosition(SliderConstraint* constraint);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_SliderConstraint_SetLimits(SliderConstraint* constraint, float inLimitsMin, float inLimitsMax);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_SliderConstraint_GetLimitsMin(SliderConstraint* constraint);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_SliderConstraint_GetLimitsMax(SliderConstraint* constraint);

	[CLink, CallingConvention(.Cdecl)]
	public static extern bool JPH_SliderConstraint_HasLimits(SliderConstraint* constraint);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_SliderConstraint_GetLimitsSpringSettings(SliderConstraint* constraint, SpringSettings* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_SliderConstraint_SetLimitsSpringSettings(SliderConstraint* constraint, SpringSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_SliderConstraint_GetTotalLambdaPosition(SliderConstraint* constraint, float* position);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_SliderConstraint_GetTotalLambdaPositionLimits(SliderConstraint* constraint);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_SliderConstraint_GetTotalLambdaRotation(SliderConstraint* constraint, Vec3* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_SliderConstraint_GetTotalLambdaMotor(SliderConstraint* constraint);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_ConeConstraintSettings_Init(ConeConstraintSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern ConeConstraint* JPH_ConeConstraint_Create(ConeConstraintSettings* settings, Body* body1, Body* body2);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_ConeConstraint_GetSettings(ConeConstraint* constraint, ConeConstraintSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_ConeConstraint_SetHalfConeAngle(ConeConstraint* constraint, float halfConeAngle);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_ConeConstraint_GetCosHalfConeAngle(ConeConstraint* constraint);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_ConeConstraint_GetTotalLambdaPosition(ConeConstraint* constraint, Vec3* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_ConeConstraint_GetTotalLambdaRotation(ConeConstraint* constraint);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_SwingTwistConstraintSettings_Init(SwingTwistConstraintSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern SwingTwistConstraint* JPH_SwingTwistConstraint_Create(SwingTwistConstraintSettings* settings, Body* body1, Body* body2);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_SwingTwistConstraint_GetSettings(SwingTwistConstraint* constraint, SwingTwistConstraintSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_SwingTwistConstraint_GetNormalHalfConeAngle(SwingTwistConstraint* constraint);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_SwingTwistConstraint_GetTotalLambdaPosition(SwingTwistConstraint* constraint, Vec3* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_SwingTwistConstraint_GetTotalLambdaTwist(SwingTwistConstraint* constraint);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_SwingTwistConstraint_GetTotalLambdaSwingY(SwingTwistConstraint* constraint);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_SwingTwistConstraint_GetTotalLambdaSwingZ(SwingTwistConstraint* constraint);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_SwingTwistConstraint_GetTotalLambdaMotor(SwingTwistConstraint* constraint, Vec3* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_SixDOFConstraintSettings_Init(SixDOFConstraintSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_SixDOFConstraintSettings_MakeFreeAxis(SixDOFConstraintSettings* settings, SixDOFConstraintAxis axis);

	[CLink, CallingConvention(.Cdecl)]
	public static extern bool JPH_SixDOFConstraintSettings_IsFreeAxis(SixDOFConstraintSettings* settings, SixDOFConstraintAxis axis);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_SixDOFConstraintSettings_MakeFixedAxis(SixDOFConstraintSettings* settings, SixDOFConstraintAxis axis);

	[CLink, CallingConvention(.Cdecl)]
	public static extern bool JPH_SixDOFConstraintSettings_IsFixedAxis(SixDOFConstraintSettings* settings, SixDOFConstraintAxis axis);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_SixDOFConstraintSettings_SetLimitedAxis(SixDOFConstraintSettings* settings, SixDOFConstraintAxis axis, float min, float max);

	[CLink, CallingConvention(.Cdecl)]
	public static extern SixDOFConstraint* JPH_SixDOFConstraint_Create(SixDOFConstraintSettings* settings, Body* body1, Body* body2);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_SixDOFConstraint_GetSettings(SixDOFConstraint* constraint, SixDOFConstraintSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_SixDOFConstraint_GetLimitsMin(SixDOFConstraint* constraint, SixDOFConstraintAxis axis);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_SixDOFConstraint_GetLimitsMax(SixDOFConstraint* constraint, SixDOFConstraintAxis axis);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_SixDOFConstraint_GetTotalLambdaPosition(SixDOFConstraint* constraint, Vec3* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_SixDOFConstraint_GetTotalLambdaRotation(SixDOFConstraint* constraint, Vec3* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_SixDOFConstraint_GetTotalLambdaMotorTranslation(SixDOFConstraint* constraint, Vec3* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_SixDOFConstraint_GetTotalLambdaMotorRotation(SixDOFConstraint* constraint, Vec3* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_SixDOFConstraint_GetTranslationLimitsMin(SixDOFConstraint* constraint, Vec3* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_SixDOFConstraint_GetTranslationLimitsMax(SixDOFConstraint* constraint, Vec3* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_SixDOFConstraint_GetRotationLimitsMin(SixDOFConstraint* constraint, Vec3* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_SixDOFConstraint_GetRotationLimitsMax(SixDOFConstraint* constraint, Vec3* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern bool JPH_SixDOFConstraint_IsFixedAxis(SixDOFConstraint* constraint, SixDOFConstraintAxis axis);

	[CLink, CallingConvention(.Cdecl)]
	public static extern bool JPH_SixDOFConstraint_IsFreeAxis(SixDOFConstraint* constraint, SixDOFConstraintAxis axis);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_SixDOFConstraint_GetLimitsSpringSettings(SixDOFConstraint* constraint, SpringSettings* result, SixDOFConstraintAxis axis);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_SixDOFConstraint_SetLimitsSpringSettings(SixDOFConstraint* constraint, SpringSettings* settings, SixDOFConstraintAxis axis);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_SixDOFConstraint_SetMaxFriction(SixDOFConstraint* constraint, SixDOFConstraintAxis axis, float inFriction);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_SixDOFConstraint_GetMaxFriction(SixDOFConstraint* constraint, SixDOFConstraintAxis axis);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_SixDOFConstraint_GetRotationInConstraintSpace(SixDOFConstraint* constraint, Quat* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_SixDOFConstraint_GetMotorSettings(SixDOFConstraint* constraint, SixDOFConstraintAxis axis, MotorSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_SixDOFConstraint_SetMotorState(SixDOFConstraint* constraint, SixDOFConstraintAxis axis, MotorState state);

	[CLink, CallingConvention(.Cdecl)]
	public static extern MotorState JPH_SixDOFConstraint_GetMotorState(SixDOFConstraint* constraint, SixDOFConstraintAxis axis);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_SixDOFConstraint_SetTargetVelocityCS(SixDOFConstraint* constraint, Vec3* inVelocity);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_SixDOFConstraint_GetTargetVelocityCS(SixDOFConstraint* constraint, Vec3* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_SixDOFConstraint_SetTargetAngularVelocityCS(SixDOFConstraint* constraint, Vec3* inAngularVelocity);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_SixDOFConstraint_GetTargetAngularVelocityCS(SixDOFConstraint* constraint, Vec3* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_SixDOFConstraint_SetTargetPositionCS(SixDOFConstraint* constraint, Vec3* inPosition);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_SixDOFConstraint_GetTargetPositionCS(SixDOFConstraint* constraint, Vec3* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_SixDOFConstraint_SetTargetOrientationCS(SixDOFConstraint* constraint, Quat* inOrientation);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_SixDOFConstraint_GetTargetOrientationCS(SixDOFConstraint* constraint, Quat* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_SixDOFConstraint_SetTargetOrientationBS(SixDOFConstraint* constraint, Quat* inOrientation);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_GearConstraintSettings_Init(GearConstraintSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern GearConstraint* JPH_GearConstraint_Create(GearConstraintSettings* settings, Body* body1, Body* body2);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_GearConstraint_GetSettings(GearConstraint* constraint, GearConstraintSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_GearConstraint_SetConstraints(GearConstraint* constraint, Constraint* gear1, Constraint* gear2);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_GearConstraint_GetTotalLambda(GearConstraint* constraint);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_BodyInterface_DestroyBody(BodyInterface* bodyInterface, BodyID bodyID);

	[CLink, CallingConvention(.Cdecl)]
	public static extern BodyID JPH_BodyInterface_CreateAndAddBody(BodyInterface* bodyInterface, BodyCreationSettings* settings, Activation activationMode);

	[CLink, CallingConvention(.Cdecl)]
	public static extern Body* JPH_BodyInterface_CreateBody(BodyInterface* bodyInterface, BodyCreationSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern Body* JPH_BodyInterface_CreateBodyWithID(BodyInterface* bodyInterface, BodyID bodyID, BodyCreationSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern Body* JPH_BodyInterface_CreateBodyWithoutID(BodyInterface* bodyInterface, BodyCreationSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_BodyInterface_DestroyBodyWithoutID(BodyInterface* bodyInterface, Body* body);

	[CLink, CallingConvention(.Cdecl)]
	public static extern bool JPH_BodyInterface_AssignBodyID(BodyInterface* bodyInterface, Body* body);

	[CLink, CallingConvention(.Cdecl)]
	public static extern bool JPH_BodyInterface_AssignBodyID2(BodyInterface* bodyInterface, Body* body, BodyID bodyID);

	[CLink, CallingConvention(.Cdecl)]
	public static extern Body* JPH_BodyInterface_UnassignBodyID(BodyInterface* bodyInterface, BodyID bodyID);

	[CLink, CallingConvention(.Cdecl)]
	public static extern Body* JPH_BodyInterface_CreateSoftBody(BodyInterface* bodyInterface, SoftBodyCreationSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern Body* JPH_BodyInterface_CreateSoftBodyWithID(BodyInterface* bodyInterface, BodyID bodyID, SoftBodyCreationSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern Body* JPH_BodyInterface_CreateSoftBodyWithoutID(BodyInterface* bodyInterface, SoftBodyCreationSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern BodyID JPH_BodyInterface_CreateAndAddSoftBody(BodyInterface* bodyInterface, SoftBodyCreationSettings* settings, Activation activationMode);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_BodyInterface_AddBody(BodyInterface* bodyInterface, BodyID bodyID, Activation activationMode);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_BodyInterface_RemoveBody(BodyInterface* bodyInterface, BodyID bodyID);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_BodyInterface_RemoveAndDestroyBody(BodyInterface* bodyInterface, BodyID bodyID);

	[CLink, CallingConvention(.Cdecl)]
	public static extern bool JPH_BodyInterface_IsAdded(BodyInterface* bodyInterface, BodyID bodyID);

	[CLink, CallingConvention(.Cdecl)]
	public static extern BodyType JPH_BodyInterface_GetBodyType(BodyInterface* bodyInterface, BodyID bodyID);

	[CLink, CallingConvention(.Cdecl)]
	public static extern Body* JPH_PhysicsSystem_GetBodyPtr(PhysicsSystem* system, BodyID bodyID);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_BodyInterface_SetLinearVelocity(BodyInterface* bodyInterface, BodyID bodyID, Vec3* velocity);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_BodyInterface_GetLinearVelocity(BodyInterface* bodyInterface, BodyID bodyID, Vec3* velocity);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_BodyInterface_GetCenterOfMassPosition(BodyInterface* bodyInterface, BodyID bodyID, RVec3* position);

	[CLink, CallingConvention(.Cdecl)]
	public static extern MotionType JPH_BodyInterface_GetMotionType(BodyInterface* bodyInterface, BodyID bodyID);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_BodyInterface_SetMotionType(BodyInterface* bodyInterface, BodyID bodyID, MotionType motionType, Activation activationMode);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_BodyInterface_GetRestitution(BodyInterface* bodyInterface, BodyID bodyID);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_BodyInterface_SetRestitution(BodyInterface* bodyInterface, BodyID bodyID, float restitution);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_BodyInterface_GetFriction(BodyInterface* bodyInterface, BodyID bodyID);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_BodyInterface_SetFriction(BodyInterface* bodyInterface, BodyID bodyID, float friction);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_BodyInterface_SetPosition(BodyInterface* bodyInterface, BodyID bodyId, RVec3* position, Activation activationMode);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_BodyInterface_GetPosition(BodyInterface* bodyInterface, BodyID bodyId, RVec3* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_BodyInterface_SetRotation(BodyInterface* bodyInterface, BodyID bodyId, Quat* rotation, Activation activationMode);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_BodyInterface_GetRotation(BodyInterface* bodyInterface, BodyID bodyId, Quat* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_BodyInterface_SetPositionAndRotation(BodyInterface* bodyInterface, BodyID bodyId, RVec3* position, Quat* rotation, Activation activationMode);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_BodyInterface_SetPositionAndRotationWhenChanged(BodyInterface* bodyInterface, BodyID bodyId, RVec3* position, Quat* rotation, Activation activationMode);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_BodyInterface_GetPositionAndRotation(BodyInterface* bodyInterface, BodyID bodyId, RVec3* position, Quat* rotation);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_BodyInterface_SetPositionRotationAndVelocity(BodyInterface* bodyInterface, BodyID bodyId, RVec3* position, Quat* rotation, Vec3* linearVelocity, Vec3* angularVelocity);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_BodyInterface_GetCollisionGroup(BodyInterface* bodyInterface, BodyID bodyId, CollisionGroup* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_BodyInterface_SetCollisionGroup(BodyInterface* bodyInterface, BodyID bodyId, CollisionGroup* group);

	[CLink, CallingConvention(.Cdecl)]
	public static extern Shape* JPH_BodyInterface_GetShape(BodyInterface* bodyInterface, BodyID bodyId);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_BodyInterface_SetShape(BodyInterface* bodyInterface, BodyID bodyId, Shape* shape, bool updateMassProperties, Activation activationMode);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_BodyInterface_NotifyShapeChanged(BodyInterface* bodyInterface, BodyID bodyId, Vec3* previousCenterOfMass, bool updateMassProperties, Activation activationMode);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_BodyInterface_ActivateBody(BodyInterface* bodyInterface, BodyID bodyId);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_BodyInterface_ActivateBodies(BodyInterface* bodyInterface, BodyID* bodyIDs, uint32 count);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_BodyInterface_ActivateBodiesInAABox(BodyInterface* bodyInterface, AABox* boxValue, BroadPhaseLayerFilter* broadPhaseLayerFilter, ObjectLayerFilter* objectLayerFilter);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_BodyInterface_DeactivateBody(BodyInterface* bodyInterface, BodyID bodyId);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_BodyInterface_DeactivateBodies(BodyInterface* bodyInterface, BodyID* bodyIDs, uint32 count);

	[CLink, CallingConvention(.Cdecl)]
	public static extern bool JPH_BodyInterface_IsActive(BodyInterface* bodyInterface, BodyID bodyID);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_BodyInterface_ResetSleepTimer(BodyInterface* bodyInterface, BodyID bodyID);

	[CLink, CallingConvention(.Cdecl)]
	public static extern ObjectLayer JPH_BodyInterface_GetObjectLayer(BodyInterface* bodyInterface, BodyID bodyId);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_BodyInterface_SetObjectLayer(BodyInterface* bodyInterface, BodyID bodyId, ObjectLayer layer);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_BodyInterface_GetWorldTransform(BodyInterface* bodyInterface, BodyID bodyId, RMat4* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_BodyInterface_GetCenterOfMassTransform(BodyInterface* bodyInterface, BodyID bodyId, RMat4* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_BodyInterface_MoveKinematic(BodyInterface* bodyInterface, BodyID bodyId, RVec3* targetPosition, Quat* targetRotation, float deltaTime);

	[CLink, CallingConvention(.Cdecl)]
	public static extern bool JPH_BodyInterface_ApplyBuoyancyImpulse(BodyInterface* bodyInterface, BodyID bodyId, RVec3* surfacePosition, Vec3* surfaceNormal, float buoyancy, float linearDrag, float angularDrag, Vec3* fluidVelocity, Vec3* gravity, float deltaTime);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_BodyInterface_SetLinearAndAngularVelocity(BodyInterface* bodyInterface, BodyID bodyId, Vec3* linearVelocity, Vec3* angularVelocity);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_BodyInterface_GetLinearAndAngularVelocity(BodyInterface* bodyInterface, BodyID bodyId, Vec3* linearVelocity, Vec3* angularVelocity);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_BodyInterface_AddLinearVelocity(BodyInterface* bodyInterface, BodyID bodyId, Vec3* linearVelocity);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_BodyInterface_AddLinearAndAngularVelocity(BodyInterface* bodyInterface, BodyID bodyId, Vec3* linearVelocity, Vec3* angularVelocity);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_BodyInterface_SetAngularVelocity(BodyInterface* bodyInterface, BodyID bodyId, Vec3* angularVelocity);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_BodyInterface_GetAngularVelocity(BodyInterface* bodyInterface, BodyID bodyId, Vec3* angularVelocity);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_BodyInterface_GetPointVelocity(BodyInterface* bodyInterface, BodyID bodyId, RVec3* point, Vec3* velocity);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_BodyInterface_AddForce(BodyInterface* bodyInterface, BodyID bodyId, Vec3* force);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_BodyInterface_AddForce2(BodyInterface* bodyInterface, BodyID bodyId, Vec3* force, RVec3* point);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_BodyInterface_AddTorque(BodyInterface* bodyInterface, BodyID bodyId, Vec3* torque);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_BodyInterface_AddForceAndTorque(BodyInterface* bodyInterface, BodyID bodyId, Vec3* force, Vec3* torque);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_BodyInterface_AddImpulse(BodyInterface* bodyInterface, BodyID bodyId, Vec3* impulse);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_BodyInterface_AddImpulse2(BodyInterface* bodyInterface, BodyID bodyId, Vec3* impulse, RVec3* point);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_BodyInterface_AddAngularImpulse(BodyInterface* bodyInterface, BodyID bodyId, Vec3* angularImpulse);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_BodyInterface_SetMotionQuality(BodyInterface* bodyInterface, BodyID bodyId, MotionQuality quality);

	[CLink, CallingConvention(.Cdecl)]
	public static extern MotionQuality JPH_BodyInterface_GetMotionQuality(BodyInterface* bodyInterface, BodyID bodyId);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_BodyInterface_GetInverseInertia(BodyInterface* bodyInterface, BodyID bodyId, Mat4* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_BodyInterface_SetGravityFactor(BodyInterface* bodyInterface, BodyID bodyId, float value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_BodyInterface_GetGravityFactor(BodyInterface* bodyInterface, BodyID bodyId);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_BodyInterface_SetUseManifoldReduction(BodyInterface* bodyInterface, BodyID bodyId, bool value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern bool JPH_BodyInterface_GetUseManifoldReduction(BodyInterface* bodyInterface, BodyID bodyId);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_BodyInterface_SetUserData(BodyInterface* bodyInterface, BodyID bodyId, uint64 inUserData);

	[CLink, CallingConvention(.Cdecl)]
	public static extern uint64 JPH_BodyInterface_GetUserData(BodyInterface* bodyInterface, BodyID bodyId);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_BodyInterface_SetIsSensor(BodyInterface* bodyInterface, BodyID bodyId, bool value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern bool JPH_BodyInterface_IsSensor(BodyInterface* bodyInterface, BodyID bodyId);

	[CLink, CallingConvention(.Cdecl)]
	public static extern PhysicsMaterial* JPH_BodyInterface_GetMaterial(BodyInterface* bodyInterface, BodyID bodyId, SubShapeID subShapeID);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_BodyInterface_InvalidateContactCache(BodyInterface* bodyInterface, BodyID bodyId);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_BodyLockInterface_LockRead(BodyLockInterface* lockInterface, BodyID bodyID, BodyLockRead* outLock);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_BodyLockInterface_UnlockRead(BodyLockInterface* lockInterface, BodyLockRead* ioLock);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_BodyLockInterface_LockWrite(BodyLockInterface* lockInterface, BodyID bodyID, BodyLockWrite* outLock);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_BodyLockInterface_UnlockWrite(BodyLockInterface* lockInterface, BodyLockWrite* ioLock);

	[CLink, CallingConvention(.Cdecl)]
	public static extern BodyLockMultiRead* JPH_BodyLockInterface_LockMultiRead(BodyLockInterface* lockInterface, BodyID* bodyIDs, uint32 count);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_BodyLockMultiRead_Destroy(BodyLockMultiRead* ioLock);

	[CLink, CallingConvention(.Cdecl)]
	public static extern Body* JPH_BodyLockMultiRead_GetBody(BodyLockMultiRead* ioLock, uint32 bodyIndex);

	[CLink, CallingConvention(.Cdecl)]
	public static extern BodyLockMultiWrite* JPH_BodyLockInterface_LockMultiWrite(BodyLockInterface* lockInterface, BodyID* bodyIDs, uint32 count);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_BodyLockMultiWrite_Destroy(BodyLockMultiWrite* ioLock);

	[CLink, CallingConvention(.Cdecl)]
	public static extern Body* JPH_BodyLockMultiWrite_GetBody(BodyLockMultiWrite* ioLock, uint32 bodyIndex);

	[CLink, CallingConvention(.Cdecl)]
	public static extern AllowedDOFs JPH_MotionProperties_GetAllowedDOFs(MotionProperties* properties);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_MotionProperties_SetLinearDamping(MotionProperties* properties, float damping);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_MotionProperties_GetLinearDamping(MotionProperties* properties);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_MotionProperties_SetAngularDamping(MotionProperties* properties, float damping);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_MotionProperties_GetAngularDamping(MotionProperties* properties);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_MotionProperties_SetMassProperties(MotionProperties* properties, AllowedDOFs allowedDOFs, MassProperties* massProperties);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_MotionProperties_GetInverseMassUnchecked(MotionProperties* properties);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_MotionProperties_SetInverseMass(MotionProperties* properties, float inverseMass);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_MotionProperties_GetInverseInertiaDiagonal(MotionProperties* properties, Vec3* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_MotionProperties_GetInertiaRotation(MotionProperties* properties, Quat* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_MotionProperties_SetInverseInertia(MotionProperties* properties, Vec3* diagonal, Quat* rot);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_MotionProperties_ScaleToMass(MotionProperties* properties, float mass);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_RayCast_GetPointOnRay(Vec3* origin, Vec3* direction, float fraction, Vec3* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_RRayCast_GetPointOnRay(RVec3* origin, Vec3* direction, float fraction, RVec3* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_MassProperties_DecomposePrincipalMomentsOfInertia(MassProperties* properties, Mat4* rotation, Vec3* diagonal);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_MassProperties_ScaleToMass(MassProperties* properties, float mass);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_MassProperties_GetEquivalentSolidBoxSize(float mass, Vec3* inertiaDiagonal, Vec3* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_CollideShapeSettings_Init(CollideShapeSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_ShapeCastSettings_Init(ShapeCastSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern bool JPH_BroadPhaseQuery_CastRay(BroadPhaseQuery* query, Vec3* origin, Vec3* direction, void* callback, void* userData, BroadPhaseLayerFilter* broadPhaseLayerFilter, ObjectLayerFilter* objectLayerFilter);

	[CLink, CallingConvention(.Cdecl)]
	public static extern bool JPH_BroadPhaseQuery_CastRay2(BroadPhaseQuery* query, Vec3* origin, Vec3* direction, CollisionCollectorType collectorType, void* callback, void* userData, BroadPhaseLayerFilter* broadPhaseLayerFilter, ObjectLayerFilter* objectLayerFilter);

	[CLink, CallingConvention(.Cdecl)]
	public static extern bool JPH_BroadPhaseQuery_CollideAABox(BroadPhaseQuery* query, AABox* boxValue, void* callback, void* userData, BroadPhaseLayerFilter* broadPhaseLayerFilter, ObjectLayerFilter* objectLayerFilter);

	[CLink, CallingConvention(.Cdecl)]
	public static extern bool JPH_BroadPhaseQuery_CollideSphere(BroadPhaseQuery* query, Vec3* center, float radius, void* callback, void* userData, BroadPhaseLayerFilter* broadPhaseLayerFilter, ObjectLayerFilter* objectLayerFilter);

	[CLink, CallingConvention(.Cdecl)]
	public static extern bool JPH_BroadPhaseQuery_CollidePoint(BroadPhaseQuery* query, Vec3* point, void* callback, void* userData, BroadPhaseLayerFilter* broadPhaseLayerFilter, ObjectLayerFilter* objectLayerFilter);

	[CLink, CallingConvention(.Cdecl)]
	public static extern bool JPH_NarrowPhaseQuery_CastRay(NarrowPhaseQuery* query, RVec3* origin, Vec3* direction, RayCastResult* hit, BroadPhaseLayerFilter* broadPhaseLayerFilter, ObjectLayerFilter* objectLayerFilter, BodyFilter* bodyFilter);

	[CLink, CallingConvention(.Cdecl)]
	public static extern bool JPH_NarrowPhaseQuery_CastRay2(NarrowPhaseQuery* query, RVec3* origin, Vec3* direction, RayCastSettings* rayCastSettings, void* callback, void* userData, BroadPhaseLayerFilter* broadPhaseLayerFilter, ObjectLayerFilter* objectLayerFilter, BodyFilter* bodyFilter, ShapeFilter* shapeFilter);

	[CLink, CallingConvention(.Cdecl)]
	public static extern bool JPH_NarrowPhaseQuery_CastRay3(NarrowPhaseQuery* query, RVec3* origin, Vec3* direction, RayCastSettings* rayCastSettings, CollisionCollectorType collectorType, void* callback, void* userData, BroadPhaseLayerFilter* broadPhaseLayerFilter, ObjectLayerFilter* objectLayerFilter, BodyFilter* bodyFilter, ShapeFilter* shapeFilter);

	[CLink, CallingConvention(.Cdecl)]
	public static extern bool JPH_NarrowPhaseQuery_CollidePoint(NarrowPhaseQuery* query, RVec3* point, void* callback, void* userData, BroadPhaseLayerFilter* broadPhaseLayerFilter, ObjectLayerFilter* objectLayerFilter, BodyFilter* bodyFilter, ShapeFilter* shapeFilter);

	[CLink, CallingConvention(.Cdecl)]
	public static extern bool JPH_NarrowPhaseQuery_CollidePoint2(NarrowPhaseQuery* query, RVec3* point, CollisionCollectorType collectorType, void* callback, void* userData, BroadPhaseLayerFilter* broadPhaseLayerFilter, ObjectLayerFilter* objectLayerFilter, BodyFilter* bodyFilter, ShapeFilter* shapeFilter);

	[CLink, CallingConvention(.Cdecl)]
	public static extern bool JPH_NarrowPhaseQuery_CollideShape(NarrowPhaseQuery* query, Shape* shape, Vec3* scale, RMat4* centerOfMassTransform, CollideShapeSettings* settings, RVec3* baseOffset, void* callback, void* userData, BroadPhaseLayerFilter* broadPhaseLayerFilter, ObjectLayerFilter* objectLayerFilter, BodyFilter* bodyFilter, ShapeFilter* shapeFilter);

	[CLink, CallingConvention(.Cdecl)]
	public static extern bool JPH_NarrowPhaseQuery_CollideShape2(NarrowPhaseQuery* query, Shape* shape, Vec3* scale, RMat4* centerOfMassTransform, CollideShapeSettings* settings, RVec3* baseOffset, CollisionCollectorType collectorType, void* callback, void* userData, BroadPhaseLayerFilter* broadPhaseLayerFilter, ObjectLayerFilter* objectLayerFilter, BodyFilter* bodyFilter, ShapeFilter* shapeFilter);

	[CLink, CallingConvention(.Cdecl)]
	public static extern bool JPH_NarrowPhaseQuery_CastShape(NarrowPhaseQuery* query, Shape* shape, RMat4* worldTransform, Vec3* direction, ShapeCastSettings* settings, RVec3* baseOffset, void* callback, void* userData, BroadPhaseLayerFilter* broadPhaseLayerFilter, ObjectLayerFilter* objectLayerFilter, BodyFilter* bodyFilter, ShapeFilter* shapeFilter);

	[CLink, CallingConvention(.Cdecl)]
	public static extern bool JPH_NarrowPhaseQuery_CastShape2(NarrowPhaseQuery* query, Shape* shape, RMat4* worldTransform, Vec3* direction, ShapeCastSettings* settings, RVec3* baseOffset, CollisionCollectorType collectorType, void* callback, void* userData, BroadPhaseLayerFilter* broadPhaseLayerFilter, ObjectLayerFilter* objectLayerFilter, BodyFilter* bodyFilter, ShapeFilter* shapeFilter);

	[CLink, CallingConvention(.Cdecl)]
	public static extern BodyID JPH_Body_GetID(Body* body);

	[CLink, CallingConvention(.Cdecl)]
	public static extern BodyType JPH_Body_GetBodyType(Body* body);

	[CLink, CallingConvention(.Cdecl)]
	public static extern bool JPH_Body_IsRigidBody(Body* body);

	[CLink, CallingConvention(.Cdecl)]
	public static extern bool JPH_Body_IsSoftBody(Body* body);

	[CLink, CallingConvention(.Cdecl)]
	public static extern bool JPH_Body_IsActive(Body* body);

	[CLink, CallingConvention(.Cdecl)]
	public static extern bool JPH_Body_IsStatic(Body* body);

	[CLink, CallingConvention(.Cdecl)]
	public static extern bool JPH_Body_IsKinematic(Body* body);

	[CLink, CallingConvention(.Cdecl)]
	public static extern bool JPH_Body_IsDynamic(Body* body);

	[CLink, CallingConvention(.Cdecl)]
	public static extern bool JPH_Body_CanBeKinematicOrDynamic(Body* body);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Body_SetIsSensor(Body* body, bool value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern bool JPH_Body_IsSensor(Body* body);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Body_SetCollideKinematicVsNonDynamic(Body* body, bool value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern bool JPH_Body_GetCollideKinematicVsNonDynamic(Body* body);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Body_SetUseManifoldReduction(Body* body, bool value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern bool JPH_Body_GetUseManifoldReduction(Body* body);

	[CLink, CallingConvention(.Cdecl)]
	public static extern bool JPH_Body_GetUseManifoldReductionWithBody(Body* body, Body* other);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Body_SetApplyGyroscopicForce(Body* body, bool value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern bool JPH_Body_GetApplyGyroscopicForce(Body* body);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Body_SetEnhancedInternalEdgeRemoval(Body* body, bool value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern bool JPH_Body_GetEnhancedInternalEdgeRemoval(Body* body);

	[CLink, CallingConvention(.Cdecl)]
	public static extern bool JPH_Body_GetEnhancedInternalEdgeRemovalWithBody(Body* body, Body* other);

	[CLink, CallingConvention(.Cdecl)]
	public static extern MotionType JPH_Body_GetMotionType(Body* body);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Body_SetMotionType(Body* body, MotionType motionType);

	[CLink, CallingConvention(.Cdecl)]
	public static extern BroadPhaseLayer JPH_Body_GetBroadPhaseLayer(Body* body);

	[CLink, CallingConvention(.Cdecl)]
	public static extern ObjectLayer JPH_Body_GetObjectLayer(Body* body);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Body_GetCollisionGroup(Body* body, CollisionGroup* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Body_SetCollisionGroup(Body* body, CollisionGroup* value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern bool JPH_Body_GetAllowSleeping(Body* body);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Body_SetAllowSleeping(Body* body, bool allowSleeping);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Body_ResetSleepTimer(Body* body);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_Body_GetFriction(Body* body);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Body_SetFriction(Body* body, float friction);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_Body_GetRestitution(Body* body);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Body_SetRestitution(Body* body, float restitution);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Body_GetLinearVelocity(Body* body, Vec3* velocity);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Body_SetLinearVelocity(Body* body, Vec3* velocity);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Body_SetLinearVelocityClamped(Body* body, Vec3* velocity);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Body_GetAngularVelocity(Body* body, Vec3* velocity);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Body_SetAngularVelocity(Body* body, Vec3* velocity);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Body_SetAngularVelocityClamped(Body* body, Vec3* velocity);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Body_GetPointVelocityCOM(Body* body, Vec3* pointRelativeToCOM, Vec3* velocity);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Body_GetPointVelocity(Body* body, RVec3* point, Vec3* velocity);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Body_AddForce(Body* body, Vec3* force);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Body_AddForceAtPosition(Body* body, Vec3* force, RVec3* position);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Body_AddTorque(Body* body, Vec3* force);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Body_GetAccumulatedForce(Body* body, Vec3* force);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Body_GetAccumulatedTorque(Body* body, Vec3* force);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Body_ResetForce(Body* body);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Body_ResetTorque(Body* body);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Body_ResetMotion(Body* body);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Body_GetInverseInertia(Body* body, Mat4* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Body_AddImpulse(Body* body, Vec3* impulse);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Body_AddImpulseAtPosition(Body* body, Vec3* impulse, RVec3* position);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Body_AddAngularImpulse(Body* body, Vec3* angularImpulse);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Body_MoveKinematic(Body* body, RVec3* targetPosition, Quat* targetRotation, float deltaTime);

	[CLink, CallingConvention(.Cdecl)]
	public static extern bool JPH_Body_ApplyBuoyancyImpulse(Body* body, RVec3* surfacePosition, Vec3* surfaceNormal, float buoyancy, float linearDrag, float angularDrag, Vec3* fluidVelocity, Vec3* gravity, float deltaTime);

	[CLink, CallingConvention(.Cdecl)]
	public static extern bool JPH_Body_IsInBroadPhase(Body* body);

	[CLink, CallingConvention(.Cdecl)]
	public static extern bool JPH_Body_IsCollisionCacheInvalid(Body* body);

	[CLink, CallingConvention(.Cdecl)]
	public static extern Shape* JPH_Body_GetShape(Body* body);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Body_GetPosition(Body* body, RVec3* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Body_GetRotation(Body* body, Quat* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Body_GetWorldTransform(Body* body, RMat4* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Body_GetCenterOfMassPosition(Body* body, RVec3* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Body_GetCenterOfMassTransform(Body* body, RMat4* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Body_GetInverseCenterOfMassTransform(Body* body, RMat4* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Body_GetWorldSpaceBounds(Body* body, AABox* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Body_GetWorldSpaceSurfaceNormal(Body* body, SubShapeID subShapeID, RVec3* position, Vec3* normal);

	[CLink, CallingConvention(.Cdecl)]
	public static extern MotionProperties* JPH_Body_GetMotionProperties(Body* body);

	[CLink, CallingConvention(.Cdecl)]
	public static extern MotionProperties* JPH_Body_GetMotionPropertiesUnchecked(Body* body);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Body_SetUserData(Body* body, uint64 userData);

	[CLink, CallingConvention(.Cdecl)]
	public static extern uint64 JPH_Body_GetUserData(Body* body);

	[CLink, CallingConvention(.Cdecl)]
	public static extern Body* JPH_Body_GetFixedToWorldBody();

	[CLink, CallingConvention(.Cdecl)]
	public static extern uint32 JPH_Body_GetSoftBodyVertexCount(Body* body);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Body_GetSoftBodyVertexPosition(Body* body, uint32 index, Vec3* outPos);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Body_GetSoftBodyVertexPositions(Body* body, Vec3* outPositions, uint32 capacity, uint32* outCount);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_BroadPhaseLayerFilter_SetProcs(BroadPhaseLayerFilter_Procs* procs);

	[CLink, CallingConvention(.Cdecl)]
	public static extern BroadPhaseLayerFilter* JPH_BroadPhaseLayerFilter_Create(void* userData);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_BroadPhaseLayerFilter_Destroy(BroadPhaseLayerFilter* filter);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_ObjectLayerFilter_SetProcs(ObjectLayerFilter_Procs* procs);

	[CLink, CallingConvention(.Cdecl)]
	public static extern ObjectLayerFilter* JPH_ObjectLayerFilter_Create(void* userData);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_ObjectLayerFilter_Destroy(ObjectLayerFilter* filter);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_BodyFilter_SetProcs(BodyFilter_Procs* procs);

	[CLink, CallingConvention(.Cdecl)]
	public static extern BodyFilter* JPH_BodyFilter_Create(void* userData);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_BodyFilter_Destroy(BodyFilter* filter);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_ShapeFilter_SetProcs(ShapeFilter_Procs* procs);

	[CLink, CallingConvention(.Cdecl)]
	public static extern ShapeFilter* JPH_ShapeFilter_Create(void* userData);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_ShapeFilter_Destroy(ShapeFilter* filter);

	[CLink, CallingConvention(.Cdecl)]
	public static extern BodyID JPH_ShapeFilter_GetBodyID2(ShapeFilter* filter);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_ShapeFilter_SetBodyID2(ShapeFilter* filter, BodyID id);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_SimShapeFilter_SetProcs(SimShapeFilter_Procs* procs);

	[CLink, CallingConvention(.Cdecl)]
	public static extern SimShapeFilter* JPH_SimShapeFilter_Create(void* userData);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_SimShapeFilter_Destroy(SimShapeFilter* filter);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_ContactListener_SetProcs(ContactListener_Procs* procs);

	[CLink, CallingConvention(.Cdecl)]
	public static extern ContactListener* JPH_ContactListener_Create(void* userData);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_ContactListener_Destroy(ContactListener* listener);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_BodyActivationListener_SetProcs(BodyActivationListener_Procs* procs);

	[CLink, CallingConvention(.Cdecl)]
	public static extern BodyActivationListener* JPH_BodyActivationListener_Create(void* userData);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_BodyActivationListener_Destroy(BodyActivationListener* listener);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_BodyDrawFilter_SetProcs(BodyDrawFilter_Procs* procs);

	[CLink, CallingConvention(.Cdecl)]
	public static extern BodyDrawFilter* JPH_BodyDrawFilter_Create(void* userData);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_BodyDrawFilter_Destroy(BodyDrawFilter* filter);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_ContactManifold_GetWorldSpaceNormal(ContactManifold* manifold, Vec3* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_ContactManifold_GetPenetrationDepth(ContactManifold* manifold);

	[CLink, CallingConvention(.Cdecl)]
	public static extern SubShapeID JPH_ContactManifold_GetSubShapeID1(ContactManifold* manifold);

	[CLink, CallingConvention(.Cdecl)]
	public static extern SubShapeID JPH_ContactManifold_GetSubShapeID2(ContactManifold* manifold);

	[CLink, CallingConvention(.Cdecl)]
	public static extern uint32 JPH_ContactManifold_GetPointCount(ContactManifold* manifold);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_ContactManifold_GetWorldSpaceContactPointOn1(ContactManifold* manifold, uint32 index, RVec3* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_ContactManifold_GetWorldSpaceContactPointOn2(ContactManifold* manifold, uint32 index, RVec3* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_CharacterBase_Destroy(CharacterBase* character);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_CharacterBase_GetCosMaxSlopeAngle(CharacterBase* character);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_CharacterBase_SetMaxSlopeAngle(CharacterBase* character, float maxSlopeAngle);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_CharacterBase_GetUp(CharacterBase* character, Vec3* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_CharacterBase_SetUp(CharacterBase* character, Vec3* value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern bool JPH_CharacterBase_IsSlopeTooSteep(CharacterBase* character, Vec3* value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern Shape* JPH_CharacterBase_GetShape(CharacterBase* character);

	[CLink, CallingConvention(.Cdecl)]
	public static extern GroundState JPH_CharacterBase_GetGroundState(CharacterBase* character);

	[CLink, CallingConvention(.Cdecl)]
	public static extern bool JPH_CharacterBase_IsSupported(CharacterBase* character);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_CharacterBase_GetGroundPosition(CharacterBase* character, RVec3* position);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_CharacterBase_GetGroundNormal(CharacterBase* character, Vec3* normal);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_CharacterBase_GetGroundVelocity(CharacterBase* character, Vec3* velocity);

	[CLink, CallingConvention(.Cdecl)]
	public static extern PhysicsMaterial* JPH_CharacterBase_GetGroundMaterial(CharacterBase* character);

	[CLink, CallingConvention(.Cdecl)]
	public static extern BodyID JPH_CharacterBase_GetGroundBodyId(CharacterBase* character);

	[CLink, CallingConvention(.Cdecl)]
	public static extern SubShapeID JPH_CharacterBase_GetGroundSubShapeId(CharacterBase* character);

	[CLink, CallingConvention(.Cdecl)]
	public static extern uint64 JPH_CharacterBase_GetGroundUserData(CharacterBase* character);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_CharacterSettings_Init(CharacterSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern Character* JPH_Character_Create(CharacterSettings* settings, RVec3* position, Quat* rotation, uint64 userData, PhysicsSystem* system);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Character_AddToPhysicsSystem(Character* character, Activation activationMode, bool lockBodies);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Character_RemoveFromPhysicsSystem(Character* character, bool lockBodies);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Character_Activate(Character* character, bool lockBodies);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Character_PostSimulation(Character* character, float maxSeparationDistance, bool lockBodies);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Character_SetLinearAndAngularVelocity(Character* character, Vec3* linearVelocity, Vec3* angularVelocity, bool lockBodies);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Character_GetLinearVelocity(Character* character, Vec3* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Character_SetLinearVelocity(Character* character, Vec3* value, bool lockBodies);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Character_AddLinearVelocity(Character* character, Vec3* value, bool lockBodies);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Character_AddImpulse(Character* character, Vec3* value, bool lockBodies);

	[CLink, CallingConvention(.Cdecl)]
	public static extern BodyID JPH_Character_GetBodyID(Character* character);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Character_GetPositionAndRotation(Character* character, RVec3* position, Quat* rotation, bool lockBodies);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Character_SetPositionAndRotation(Character* character, RVec3* position, Quat* rotation, Activation activationMode, bool lockBodies);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Character_GetPosition(Character* character, RVec3* position, bool lockBodies);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Character_SetPosition(Character* character, RVec3* position, Activation activationMode, bool lockBodies);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Character_GetRotation(Character* character, Quat* rotation, bool lockBodies);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Character_SetRotation(Character* character, Quat* rotation, Activation activationMode, bool lockBodies);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Character_GetCenterOfMassPosition(Character* character, RVec3* result, bool lockBodies);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Character_GetWorldTransform(Character* character, RMat4* result, bool lockBodies);

	[CLink, CallingConvention(.Cdecl)]
	public static extern ObjectLayer JPH_Character_GetLayer(Character* character);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Character_SetLayer(Character* character, ObjectLayer value, bool lockBodies);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Character_SetShape(Character* character, Shape* shape, float maxPenetrationDepth, bool lockBodies);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_CharacterVirtualSettings_Init(CharacterVirtualSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern CharacterVirtual* JPH_CharacterVirtual_Create(CharacterVirtualSettings* settings, RVec3* position, Quat* rotation, uint64 userData, PhysicsSystem* system);

	[CLink, CallingConvention(.Cdecl)]
	public static extern CharacterID JPH_CharacterVirtual_GetID(CharacterVirtual* character);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_CharacterVirtual_SetListener(CharacterVirtual* character, CharacterContactListener* listener);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_CharacterVirtual_SetCharacterVsCharacterCollision(CharacterVirtual* character, CharacterVsCharacterCollision* characterVsCharacterCollision);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_CharacterVirtual_GetLinearVelocity(CharacterVirtual* character, Vec3* velocity);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_CharacterVirtual_SetLinearVelocity(CharacterVirtual* character, Vec3* velocity);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_CharacterVirtual_GetPosition(CharacterVirtual* character, RVec3* position);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_CharacterVirtual_SetPosition(CharacterVirtual* character, RVec3* position);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_CharacterVirtual_GetRotation(CharacterVirtual* character, Quat* rotation);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_CharacterVirtual_SetRotation(CharacterVirtual* character, Quat* rotation);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_CharacterVirtual_GetWorldTransform(CharacterVirtual* character, RMat4* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_CharacterVirtual_GetCenterOfMassTransform(CharacterVirtual* character, RMat4* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_CharacterVirtual_GetMass(CharacterVirtual* character);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_CharacterVirtual_SetMass(CharacterVirtual* character, float value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_CharacterVirtual_GetMaxStrength(CharacterVirtual* character);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_CharacterVirtual_SetMaxStrength(CharacterVirtual* character, float value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_CharacterVirtual_GetPenetrationRecoverySpeed(CharacterVirtual* character);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_CharacterVirtual_SetPenetrationRecoverySpeed(CharacterVirtual* character, float value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern bool JPH_CharacterVirtual_GetEnhancedInternalEdgeRemoval(CharacterVirtual* character);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_CharacterVirtual_SetEnhancedInternalEdgeRemoval(CharacterVirtual* character, bool value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_CharacterVirtual_GetCharacterPadding(CharacterVirtual* character);

	[CLink, CallingConvention(.Cdecl)]
	public static extern uint32 JPH_CharacterVirtual_GetMaxNumHits(CharacterVirtual* character);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_CharacterVirtual_SetMaxNumHits(CharacterVirtual* character, uint32 value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_CharacterVirtual_GetHitReductionCosMaxAngle(CharacterVirtual* character);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_CharacterVirtual_SetHitReductionCosMaxAngle(CharacterVirtual* character, float value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern bool JPH_CharacterVirtual_GetMaxHitsExceeded(CharacterVirtual* character);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_CharacterVirtual_GetShapeOffset(CharacterVirtual* character, Vec3* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_CharacterVirtual_SetShapeOffset(CharacterVirtual* character, Vec3* value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern uint64 JPH_CharacterVirtual_GetUserData(CharacterVirtual* character);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_CharacterVirtual_SetUserData(CharacterVirtual* character, uint64 value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern BodyID JPH_CharacterVirtual_GetInnerBodyID(CharacterVirtual* character);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_CharacterVirtual_CancelVelocityTowardsSteepSlopes(CharacterVirtual* character, Vec3* desiredVelocity, Vec3* velocity);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_CharacterVirtual_StartTrackingContactChanges(CharacterVirtual* character);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_CharacterVirtual_FinishTrackingContactChanges(CharacterVirtual* character);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_CharacterVirtual_Update(CharacterVirtual* character, float deltaTime, ObjectLayer layer, PhysicsSystem* system, BodyFilter* bodyFilter, ShapeFilter* shapeFilter);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_CharacterVirtual_ExtendedUpdate(CharacterVirtual* character, float deltaTime, ExtendedUpdateSettings* settings, ObjectLayer layer, PhysicsSystem* system, BodyFilter* bodyFilter, ShapeFilter* shapeFilter);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_CharacterVirtual_RefreshContacts(CharacterVirtual* character, ObjectLayer layer, PhysicsSystem* system, BodyFilter* bodyFilter, ShapeFilter* shapeFilter);

	[CLink, CallingConvention(.Cdecl)]
	public static extern bool JPH_CharacterVirtual_CanWalkStairs(CharacterVirtual* character, Vec3* linearVelocity);

	[CLink, CallingConvention(.Cdecl)]
	public static extern bool JPH_CharacterVirtual_WalkStairs(CharacterVirtual* character, float deltaTime, Vec3* stepUp, Vec3* stepForward, Vec3* stepForwardTest, Vec3* stepDownExtra, ObjectLayer layer, PhysicsSystem* system, BodyFilter* bodyFilter, ShapeFilter* shapeFilter);

	[CLink, CallingConvention(.Cdecl)]
	public static extern bool JPH_CharacterVirtual_StickToFloor(CharacterVirtual* character, Vec3* stepDown, ObjectLayer layer, PhysicsSystem* system, BodyFilter* bodyFilter, ShapeFilter* shapeFilter);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_CharacterVirtual_UpdateGroundVelocity(CharacterVirtual* character);

	[CLink, CallingConvention(.Cdecl)]
	public static extern bool JPH_CharacterVirtual_SetShape(CharacterVirtual* character, Shape* shape, float maxPenetrationDepth, ObjectLayer layer, PhysicsSystem* system, BodyFilter* bodyFilter, ShapeFilter* shapeFilter);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_CharacterVirtual_SetInnerBodyShape(CharacterVirtual* character, Shape* shape);

	[CLink, CallingConvention(.Cdecl)]
	public static extern uint32 JPH_CharacterVirtual_GetNumActiveContacts(CharacterVirtual* character);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_CharacterVirtual_GetActiveContact(CharacterVirtual* character, uint32 index, CharacterVirtualContact* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern bool JPH_CharacterVirtual_HasCollidedWithBody(CharacterVirtual* character, BodyID body);

	[CLink, CallingConvention(.Cdecl)]
	public static extern bool JPH_CharacterVirtual_HasCollidedWith(CharacterVirtual* character, CharacterID other);

	[CLink, CallingConvention(.Cdecl)]
	public static extern bool JPH_CharacterVirtual_HasCollidedWithCharacter(CharacterVirtual* character, CharacterVirtual* other);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_CharacterContactListener_SetProcs(CharacterContactListener_Procs* procs);

	[CLink, CallingConvention(.Cdecl)]
	public static extern CharacterContactListener* JPH_CharacterContactListener_Create(void* userData);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_CharacterContactListener_Destroy(CharacterContactListener* listener);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_CharacterVsCharacterCollision_SetProcs(CharacterVsCharacterCollision_Procs* procs);

	[CLink, CallingConvention(.Cdecl)]
	public static extern CharacterVsCharacterCollision* JPH_CharacterVsCharacterCollision_Create(void* userData);

	[CLink, CallingConvention(.Cdecl)]
	public static extern CharacterVsCharacterCollision* JPH_CharacterVsCharacterCollision_CreateSimple();

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_CharacterVsCharacterCollisionSimple_AddCharacter(CharacterVsCharacterCollision* characterVsCharacter, CharacterVirtual* character);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_CharacterVsCharacterCollisionSimple_RemoveCharacter(CharacterVsCharacterCollision* characterVsCharacter, CharacterVirtual* character);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_CharacterVsCharacterCollision_Destroy(CharacterVsCharacterCollision* listener);

	[CLink, CallingConvention(.Cdecl)]
	public static extern bool JPH_CollisionDispatch_CollideShapeVsShape(Shape* shape1, Shape* shape2, Vec3* scale1, Vec3* scale2, Mat4* centerOfMassTransform1, Mat4* centerOfMassTransform2, CollideShapeSettings* collideShapeSettings, void* callback, void* userData, ShapeFilter* shapeFilter);

	[CLink, CallingConvention(.Cdecl)]
	public static extern bool JPH_CollisionDispatch_CastShapeVsShapeLocalSpace(Vec3* direction, Shape* shape1, Shape* shape2, Vec3* scale1InShape2LocalSpace, Vec3* scale2, Mat4* centerOfMassTransform1InShape2LocalSpace, Mat4* centerOfMassWorldTransform2, ShapeCastSettings* shapeCastSettings, void* callback, void* userData, ShapeFilter* shapeFilter);

	[CLink, CallingConvention(.Cdecl)]
	public static extern bool JPH_CollisionDispatch_CastShapeVsShapeWorldSpace(Vec3* direction, Shape* shape1, Shape* shape2, Vec3* scale1, Vec3* inScale2, Mat4* centerOfMassWorldTransform1, Mat4* centerOfMassWorldTransform2, ShapeCastSettings* shapeCastSettings, void* callback, void* userData, ShapeFilter* shapeFilter);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_DebugRenderer_SetProcs(DebugRenderer_Procs* procs);

	[CLink, CallingConvention(.Cdecl)]
	public static extern DebugRenderer* JPH_DebugRenderer_Create(void* userData);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_DebugRenderer_Destroy(DebugRenderer* renderer);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_DebugRenderer_NextFrame(DebugRenderer* renderer);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_DebugRenderer_SetCameraPos(DebugRenderer* renderer, RVec3* position);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_DebugRenderer_DrawLine(DebugRenderer* renderer, RVec3* from, RVec3* to, Color color);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_DebugRenderer_DrawWireBox(DebugRenderer* renderer, AABox* boxValue, Color color);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_DebugRenderer_DrawWireBox2(DebugRenderer* renderer, RMat4* matrix, AABox* boxValue, Color color);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_DebugRenderer_DrawMarker(DebugRenderer* renderer, RVec3* position, Color color, float size);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_DebugRenderer_DrawArrow(DebugRenderer* renderer, RVec3* from, RVec3* to, Color color, float size);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_DebugRenderer_DrawCoordinateSystem(DebugRenderer* renderer, RMat4* matrix, float size);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_DebugRenderer_DrawPlane(DebugRenderer* renderer, RVec3* point, Vec3* normal, Color color, float size);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_DebugRenderer_DrawWireTriangle(DebugRenderer* renderer, RVec3* v1, RVec3* v2, RVec3* v3, Color color);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_DebugRenderer_DrawWireSphere(DebugRenderer* renderer, RVec3* center, float radius, Color color, int32 level);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_DebugRenderer_DrawWireUnitSphere(DebugRenderer* renderer, RMat4* matrix, Color color, int32 level);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_DebugRenderer_DrawTriangle(DebugRenderer* renderer, RVec3* v1, RVec3* v2, RVec3* v3, Color color, DebugRenderer_CastShadow castShadow);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_DebugRenderer_DrawBox(DebugRenderer* renderer, AABox* boxValue, Color color, DebugRenderer_CastShadow castShadow, DebugRenderer_DrawMode drawMode);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_DebugRenderer_DrawBox2(DebugRenderer* renderer, RMat4* matrix, AABox* boxValue, Color color, DebugRenderer_CastShadow castShadow, DebugRenderer_DrawMode drawMode);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_DebugRenderer_DrawSphere(DebugRenderer* renderer, RVec3* center, float radius, Color color, DebugRenderer_CastShadow castShadow, DebugRenderer_DrawMode drawMode);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_DebugRenderer_DrawUnitSphere(DebugRenderer* renderer, RMat4 matrix, Color color, DebugRenderer_CastShadow castShadow, DebugRenderer_DrawMode drawMode);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_DebugRenderer_DrawCapsule(DebugRenderer* renderer, RMat4* matrix, float halfHeightOfCylinder, float radius, Color color, DebugRenderer_CastShadow castShadow, DebugRenderer_DrawMode drawMode);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_DebugRenderer_DrawCylinder(DebugRenderer* renderer, RMat4* matrix, float halfHeight, float radius, Color color, DebugRenderer_CastShadow castShadow, DebugRenderer_DrawMode drawMode);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_DebugRenderer_DrawOpenCone(DebugRenderer* renderer, RVec3* top, Vec3* axis, Vec3* perpendicular, float halfAngle, float length, Color color, DebugRenderer_CastShadow castShadow, DebugRenderer_DrawMode drawMode);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_DebugRenderer_DrawSwingConeLimits(DebugRenderer* renderer, RMat4* matrix, float swingYHalfAngle, float swingZHalfAngle, float edgeLength, Color color, DebugRenderer_CastShadow castShadow, DebugRenderer_DrawMode drawMode);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_DebugRenderer_DrawSwingPyramidLimits(DebugRenderer* renderer, RMat4* matrix, float minSwingYAngle, float maxSwingYAngle, float minSwingZAngle, float maxSwingZAngle, float edgeLength, Color color, DebugRenderer_CastShadow castShadow, DebugRenderer_DrawMode drawMode);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_DebugRenderer_DrawPie(DebugRenderer* renderer, RVec3* center, float radius, Vec3* normal, Vec3* axis, float minAngle, float maxAngle, Color color, DebugRenderer_CastShadow castShadow, DebugRenderer_DrawMode drawMode);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_DebugRenderer_DrawTaperedCylinder(DebugRenderer* renderer, RMat4* inMatrix, float top, float bottom, float topRadius, float bottomRadius, Color color, DebugRenderer_CastShadow castShadow, DebugRenderer_DrawMode drawMode);

	[CLink, CallingConvention(.Cdecl)]
	public static extern Skeleton* JPH_Skeleton_Create();

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Skeleton_Destroy(Skeleton* skeleton);

	[CLink, CallingConvention(.Cdecl)]
	public static extern uint32 JPH_Skeleton_AddJoint(Skeleton* skeleton, char8* name);

	[CLink, CallingConvention(.Cdecl)]
	public static extern uint32 JPH_Skeleton_AddJoint2(Skeleton* skeleton, char8* name, int32 parentIndex);

	[CLink, CallingConvention(.Cdecl)]
	public static extern uint32 JPH_Skeleton_AddJoint3(Skeleton* skeleton, char8* name, char8* parentName);

	[CLink, CallingConvention(.Cdecl)]
	public static extern int32 JPH_Skeleton_GetJointCount(Skeleton* skeleton);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Skeleton_GetJoint(Skeleton* skeleton, int32 index, SkeletonJoint* joint);

	[CLink, CallingConvention(.Cdecl)]
	public static extern int32 JPH_Skeleton_GetJointIndex(Skeleton* skeleton, char8* name);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Skeleton_CalculateParentJointIndices(Skeleton* skeleton);

	[CLink, CallingConvention(.Cdecl)]
	public static extern bool JPH_Skeleton_AreJointsCorrectlyOrdered(Skeleton* skeleton);

	[CLink, CallingConvention(.Cdecl)]
	public static extern SkeletonPose* JPH_SkeletonPose_Create();

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_SkeletonPose_Destroy(SkeletonPose* pose);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_SkeletonPose_SetSkeleton(SkeletonPose* pose, Skeleton* skeleton);

	[CLink, CallingConvention(.Cdecl)]
	public static extern Skeleton* JPH_SkeletonPose_GetSkeleton(SkeletonPose* pose);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_SkeletonPose_SetRootOffset(SkeletonPose* pose, RVec3* offset);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_SkeletonPose_GetRootOffset(SkeletonPose* pose, RVec3* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern int32 JPH_SkeletonPose_GetJointCount(SkeletonPose* pose);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_SkeletonPose_GetJointState(SkeletonPose* pose, int32 index, Vec3* outTranslation, Quat* outRotation);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_SkeletonPose_SetJointState(SkeletonPose* pose, int32 index, Vec3* translation, Quat* rotation);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_SkeletonPose_GetJointMatrix(SkeletonPose* pose, int32 index, Mat4* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_SkeletonPose_SetJointMatrix(SkeletonPose* pose, int32 index, Mat4* matrix);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_SkeletonPose_GetJointMatrices(SkeletonPose* pose, Mat4* outMatrices, int32 count);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_SkeletonPose_SetJointMatrices(SkeletonPose* pose, Mat4* matrices, int32 count);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_SkeletonPose_CalculateJointMatrices(SkeletonPose* pose);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_SkeletonPose_CalculateJointStates(SkeletonPose* pose);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_SkeletonPose_CalculateLocalSpaceJointMatrices(SkeletonPose* pose, Mat4* outMatrices);

	[CLink, CallingConvention(.Cdecl)]
	public static extern SkeletalAnimation* JPH_SkeletalAnimation_Create();

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_SkeletalAnimation_Destroy(SkeletalAnimation* animation);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_SkeletalAnimation_GetDuration(SkeletalAnimation* animation);

	[CLink, CallingConvention(.Cdecl)]
	public static extern bool JPH_SkeletalAnimation_IsLooping(SkeletalAnimation* animation);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_SkeletalAnimation_SetIsLooping(SkeletalAnimation* animation, bool looping);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_SkeletalAnimation_ScaleJoints(SkeletalAnimation* animation, float scale);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_SkeletalAnimation_Sample(SkeletalAnimation* animation, float time, SkeletonPose* pose);

	[CLink, CallingConvention(.Cdecl)]
	public static extern int32 JPH_SkeletalAnimation_GetAnimatedJointCount(SkeletalAnimation* animation);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_SkeletalAnimation_AddAnimatedJoint(SkeletalAnimation* animation, char8* jointName);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_SkeletalAnimation_AddKeyframe(SkeletalAnimation* animation, int32 jointIndex, float time, Vec3* translation, Quat* rotation);

	[CLink, CallingConvention(.Cdecl)]
	public static extern SkeletonMapper* JPH_SkeletonMapper_Create();

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_SkeletonMapper_Destroy(SkeletonMapper* mapper);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_SkeletonMapper_Initialize(SkeletonMapper* mapper, Skeleton* skeleton1, Mat4* neutralPose1, Skeleton* skeleton2, Mat4* neutralPose2);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_SkeletonMapper_LockAllTranslations(SkeletonMapper* mapper, Skeleton* skeleton2, Mat4* neutralPose2);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_SkeletonMapper_LockTranslations(SkeletonMapper* mapper, Skeleton* skeleton2, bool* lockedTranslations, Mat4* neutralPose2);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_SkeletonMapper_Map(SkeletonMapper* mapper, Mat4* pose1ModelSpace, Mat4* pose2LocalSpace, Mat4* outPose2ModelSpace);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_SkeletonMapper_MapReverse(SkeletonMapper* mapper, Mat4* pose2ModelSpace, Mat4* outPose1ModelSpace);

	[CLink, CallingConvention(.Cdecl)]
	public static extern int32 JPH_SkeletonMapper_GetMappedJointIndex(SkeletonMapper* mapper, int32 joint1Index);

	[CLink, CallingConvention(.Cdecl)]
	public static extern bool JPH_SkeletonMapper_IsJointTranslationLocked(SkeletonMapper* mapper, int32 joint2Index);

	[CLink, CallingConvention(.Cdecl)]
	public static extern RagdollSettings* JPH_RagdollSettings_Create();

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_RagdollSettings_Destroy(RagdollSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern Skeleton* JPH_RagdollSettings_GetSkeleton(RagdollSettings* character);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_RagdollSettings_SetSkeleton(RagdollSettings* character, Skeleton* skeleton);

	[CLink, CallingConvention(.Cdecl)]
	public static extern bool JPH_RagdollSettings_Stabilize(RagdollSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_RagdollSettings_DisableParentChildCollisions(RagdollSettings* settings, Mat4* jointMatrices, float minSeparationDistance);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_RagdollSettings_CalculateBodyIndexToConstraintIndex(RagdollSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern int32 JPH_RagdollSettings_GetConstraintIndexForBodyIndex(RagdollSettings* settings, int32 bodyIndex);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_RagdollSettings_CalculateConstraintIndexToBodyIdxPair(RagdollSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_RagdollSettings_ResizeParts(RagdollSettings* settings, int32 count);

	[CLink, CallingConvention(.Cdecl)]
	public static extern int32 JPH_RagdollSettings_GetPartCount(RagdollSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_RagdollSettings_SetPartShape(RagdollSettings* settings, int32 partIndex, Shape* shape);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_RagdollSettings_SetPartPosition(RagdollSettings* settings, int32 partIndex, RVec3* position);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_RagdollSettings_SetPartRotation(RagdollSettings* settings, int32 partIndex, Quat* rotation);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_RagdollSettings_SetPartMotionType(RagdollSettings* settings, int32 partIndex, MotionType motionType);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_RagdollSettings_SetPartObjectLayer(RagdollSettings* settings, int32 partIndex, ObjectLayer layer);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_RagdollSettings_SetPartMassProperties(RagdollSettings* settings, int32 partIndex, float mass);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_RagdollSettings_SetPartToParent(RagdollSettings* settings, int32 partIndex, SwingTwistConstraintSettings* constraintSettings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern Ragdoll* JPH_RagdollSettings_CreateRagdoll(RagdollSettings* settings, PhysicsSystem* system, CollisionGroupID collisionGroup, uint64 userData);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Ragdoll_Destroy(Ragdoll* ragdoll);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Ragdoll_AddToPhysicsSystem(Ragdoll* ragdoll, Activation activationMode, bool lockBodies);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Ragdoll_RemoveFromPhysicsSystem(Ragdoll* ragdoll, bool lockBodies);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Ragdoll_Activate(Ragdoll* ragdoll, bool lockBodies);

	[CLink, CallingConvention(.Cdecl)]
	public static extern bool JPH_Ragdoll_IsActive(Ragdoll* ragdoll, bool lockBodies);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Ragdoll_ResetWarmStart(Ragdoll* ragdoll);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Ragdoll_SetPose(Ragdoll* ragdoll, SkeletonPose* pose, bool lockBodies);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Ragdoll_SetPose2(Ragdoll* ragdoll, RVec3* rootOffset, Mat4* jointMatrices, bool lockBodies);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Ragdoll_GetPose(Ragdoll* ragdoll, SkeletonPose* outPose, bool lockBodies);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Ragdoll_GetPose2(Ragdoll* ragdoll, RVec3* outRootOffset, Mat4* outJointMatrices, bool lockBodies);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Ragdoll_DriveToPoseUsingMotors(Ragdoll* ragdoll, SkeletonPose* pose);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Ragdoll_DriveToPoseUsingKinematics(Ragdoll* ragdoll, SkeletonPose* pose, float deltaTime, bool lockBodies);

	[CLink, CallingConvention(.Cdecl)]
	public static extern int32 JPH_Ragdoll_GetBodyCount(Ragdoll* ragdoll);

	[CLink, CallingConvention(.Cdecl)]
	public static extern BodyID JPH_Ragdoll_GetBodyID(Ragdoll* ragdoll, int32 bodyIndex);

	[CLink, CallingConvention(.Cdecl)]
	public static extern int32 JPH_Ragdoll_GetConstraintCount(Ragdoll* ragdoll);

	[CLink, CallingConvention(.Cdecl)]
	public static extern TwoBodyConstraint* JPH_Ragdoll_GetConstraint(Ragdoll* ragdoll, int32 constraintIndex);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Ragdoll_GetRootTransform(Ragdoll* ragdoll, RVec3* outPosition, Quat* outRotation, bool lockBodies);

	[CLink, CallingConvention(.Cdecl)]
	public static extern RagdollSettings* JPH_Ragdoll_GetRagdollSettings(Ragdoll* ragdoll);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_EstimateCollisionResponse(Body* body1, Body* body2, ContactManifold* manifold, float combinedFriction, float combinedRestitution, float minVelocityForRestitution, uint32 numIterations, CollisionEstimationResult* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_VehicleConstraintSettings_Init(VehicleConstraintSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern VehicleConstraint* JPH_VehicleConstraint_Create(Body* body, VehicleConstraintSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern PhysicsStepListener* JPH_VehicleConstraint_AsPhysicsStepListener(VehicleConstraint* constraint);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_VehicleConstraint_SetMaxPitchRollAngle(VehicleConstraint* constraint, float maxPitchRollAngle);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_VehicleConstraint_SetVehicleCollisionTester(VehicleConstraint* constraint, VehicleCollisionTester* tester);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_VehicleConstraint_OverrideGravity(VehicleConstraint* constraint, Vec3* value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern bool JPH_VehicleConstraint_IsGravityOverridden(VehicleConstraint* constraint);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_VehicleConstraint_GetGravityOverride(VehicleConstraint* constraint, Vec3* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_VehicleConstraint_ResetGravityOverride(VehicleConstraint* constraint);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_VehicleConstraint_GetLocalForward(VehicleConstraint* constraint, Vec3* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_VehicleConstraint_GetLocalUp(VehicleConstraint* constraint, Vec3* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_VehicleConstraint_GetWorldUp(VehicleConstraint* constraint, Vec3* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern Body* JPH_VehicleConstraint_GetVehicleBody(VehicleConstraint* constraint);

	[CLink, CallingConvention(.Cdecl)]
	public static extern VehicleController* JPH_VehicleConstraint_GetController(VehicleConstraint* constraint);

	[CLink, CallingConvention(.Cdecl)]
	public static extern uint32 JPH_VehicleConstraint_GetWheelsCount(VehicleConstraint* constraint);

	[CLink, CallingConvention(.Cdecl)]
	public static extern Wheel* JPH_VehicleConstraint_GetWheel(VehicleConstraint* constraint, uint32 index);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_VehicleConstraint_GetWheelLocalBasis(VehicleConstraint* constraint, Wheel* wheel, Vec3* outForward, Vec3* outUp, Vec3* outRight);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_VehicleConstraint_GetWheelLocalTransform(VehicleConstraint* constraint, uint32 wheelIndex, Vec3* wheelRight, Vec3* wheelUp, Mat4* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_VehicleConstraint_GetWheelWorldTransform(VehicleConstraint* constraint, uint32 wheelIndex, Vec3* wheelRight, Vec3* wheelUp, RMat4* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern WheelSettings* JPH_WheelSettings_Create();

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_WheelSettings_Destroy(WheelSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_WheelSettings_GetPosition(WheelSettings* settings, Vec3* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_WheelSettings_SetPosition(WheelSettings* settings, Vec3* value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_WheelSettings_GetSuspensionForcePoint(WheelSettings* settings, Vec3* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_WheelSettings_SetSuspensionForcePoint(WheelSettings* settings, Vec3* value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_WheelSettings_GetSuspensionDirection(WheelSettings* settings, Vec3* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_WheelSettings_SetSuspensionDirection(WheelSettings* settings, Vec3* value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_WheelSettings_GetSteeringAxis(WheelSettings* settings, Vec3* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_WheelSettings_SetSteeringAxis(WheelSettings* settings, Vec3* value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_WheelSettings_GetWheelUp(WheelSettings* settings, Vec3* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_WheelSettings_SetWheelUp(WheelSettings* settings, Vec3* value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_WheelSettings_GetWheelForward(WheelSettings* settings, Vec3* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_WheelSettings_SetWheelForward(WheelSettings* settings, Vec3* value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_WheelSettings_GetSuspensionMinLength(WheelSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_WheelSettings_SetSuspensionMinLength(WheelSettings* settings, float value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_WheelSettings_GetSuspensionMaxLength(WheelSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_WheelSettings_SetSuspensionMaxLength(WheelSettings* settings, float value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_WheelSettings_GetSuspensionPreloadLength(WheelSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_WheelSettings_SetSuspensionPreloadLength(WheelSettings* settings, float value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_WheelSettings_GetSuspensionSpring(WheelSettings* settings, SpringSettings* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_WheelSettings_SetSuspensionSpring(WheelSettings* settings, SpringSettings* springSettings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_WheelSettings_GetRadius(WheelSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_WheelSettings_SetRadius(WheelSettings* settings, float value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_WheelSettings_GetWidth(WheelSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_WheelSettings_SetWidth(WheelSettings* settings, float value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern bool JPH_WheelSettings_GetEnableSuspensionForcePoint(WheelSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_WheelSettings_SetEnableSuspensionForcePoint(WheelSettings* settings, bool value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern Wheel* JPH_Wheel_Create(WheelSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Wheel_Destroy(Wheel* wheel);

	[CLink, CallingConvention(.Cdecl)]
	public static extern WheelSettings* JPH_Wheel_GetSettings(Wheel* wheel);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_Wheel_GetAngularVelocity(Wheel* wheel);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Wheel_SetAngularVelocity(Wheel* wheel, float value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_Wheel_GetRotationAngle(Wheel* wheel);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Wheel_SetRotationAngle(Wheel* wheel, float value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_Wheel_GetSteerAngle(Wheel* wheel);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Wheel_SetSteerAngle(Wheel* wheel, float value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern bool JPH_Wheel_HasContact(Wheel* wheel);

	[CLink, CallingConvention(.Cdecl)]
	public static extern BodyID JPH_Wheel_GetContactBodyID(Wheel* wheel);

	[CLink, CallingConvention(.Cdecl)]
	public static extern SubShapeID JPH_Wheel_GetContactSubShapeID(Wheel* wheel);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Wheel_GetContactPosition(Wheel* wheel, RVec3* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Wheel_GetContactPointVelocity(Wheel* wheel, Vec3* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Wheel_GetContactNormal(Wheel* wheel, Vec3* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Wheel_GetContactLongitudinal(Wheel* wheel, Vec3* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_Wheel_GetContactLateral(Wheel* wheel, Vec3* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_Wheel_GetSuspensionLength(Wheel* wheel);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_Wheel_GetSuspensionLambda(Wheel* wheel);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_Wheel_GetLongitudinalLambda(Wheel* wheel);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_Wheel_GetLateralLambda(Wheel* wheel);

	[CLink, CallingConvention(.Cdecl)]
	public static extern bool JPH_Wheel_HasHitHardPoint(Wheel* wheel);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_VehicleAntiRollBar_Init(VehicleAntiRollBar* antiRollBar);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_VehicleEngineSettings_Init(VehicleEngineSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_VehicleEngine_ClampRPM(VehicleEngine* engine);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_VehicleEngine_GetCurrentRPM(VehicleEngine* engine);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_VehicleEngine_SetCurrentRPM(VehicleEngine* engine, float rpm);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_VehicleEngine_GetAngularVelocity(VehicleEngine* engine);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_VehicleEngine_GetTorque(VehicleEngine* engine, float acceleration);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_VehicleEngine_ApplyTorque(VehicleEngine* engine, float torque, float deltaTime);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_VehicleEngine_ApplyDamping(VehicleEngine* engine, float deltaTime);

	[CLink, CallingConvention(.Cdecl)]
	public static extern bool JPH_VehicleEngine_AllowSleep(VehicleEngine* engine);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_VehicleDifferentialSettings_Init(VehicleDifferentialSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern VehicleTransmissionSettings* JPH_VehicleTransmissionSettings_Create();

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_VehicleTransmissionSettings_Destroy(VehicleTransmissionSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern TransmissionMode JPH_VehicleTransmissionSettings_GetMode(VehicleTransmissionSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_VehicleTransmissionSettings_SetMode(VehicleTransmissionSettings* settings, TransmissionMode value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern uint32 JPH_VehicleTransmissionSettings_GetGearRatioCount(VehicleTransmissionSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_VehicleTransmissionSettings_GetGearRatio(VehicleTransmissionSettings* settings, uint32 index);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_VehicleTransmissionSettings_SetGearRatio(VehicleTransmissionSettings* settings, uint32 index, float value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float* JPH_VehicleTransmissionSettings_GetGearRatios(VehicleTransmissionSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_VehicleTransmissionSettings_SetGearRatios(VehicleTransmissionSettings* settings, float* values, uint32 count);

	[CLink, CallingConvention(.Cdecl)]
	public static extern uint32 JPH_VehicleTransmissionSettings_GetReverseGearRatioCount(VehicleTransmissionSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_VehicleTransmissionSettings_GetReverseGearRatio(VehicleTransmissionSettings* settings, uint32 index);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_VehicleTransmissionSettings_SetReverseGearRatio(VehicleTransmissionSettings* settings, uint32 index, float value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float* JPH_VehicleTransmissionSettings_GetReverseGearRatios(VehicleTransmissionSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_VehicleTransmissionSettings_SetReverseGearRatios(VehicleTransmissionSettings* settings, float* values, uint32 count);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_VehicleTransmissionSettings_GetSwitchTime(VehicleTransmissionSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_VehicleTransmissionSettings_SetSwitchTime(VehicleTransmissionSettings* settings, float value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_VehicleTransmissionSettings_GetClutchReleaseTime(VehicleTransmissionSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_VehicleTransmissionSettings_SetClutchReleaseTime(VehicleTransmissionSettings* settings, float value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_VehicleTransmissionSettings_GetSwitchLatency(VehicleTransmissionSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_VehicleTransmissionSettings_SetSwitchLatency(VehicleTransmissionSettings* settings, float value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_VehicleTransmissionSettings_GetShiftUpRPM(VehicleTransmissionSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_VehicleTransmissionSettings_SetShiftUpRPM(VehicleTransmissionSettings* settings, float value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_VehicleTransmissionSettings_GetShiftDownRPM(VehicleTransmissionSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_VehicleTransmissionSettings_SetShiftDownRPM(VehicleTransmissionSettings* settings, float value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_VehicleTransmissionSettings_GetClutchStrength(VehicleTransmissionSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_VehicleTransmissionSettings_SetClutchStrength(VehicleTransmissionSettings* settings, float value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_VehicleTransmission_SetMode(VehicleTransmission* transmission, TransmissionMode mode);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_VehicleTransmission_Set(VehicleTransmission* transmission, int32 currentGear, float clutchFriction);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_VehicleTransmission_Update(VehicleTransmission* transmission, float deltaTime, float currentRPM, float forwardInput, bool canShiftUp);

	[CLink, CallingConvention(.Cdecl)]
	public static extern int32 JPH_VehicleTransmission_GetCurrentGear(VehicleTransmission* transmission);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_VehicleTransmission_GetClutchFriction(VehicleTransmission* transmission);

	[CLink, CallingConvention(.Cdecl)]
	public static extern bool JPH_VehicleTransmission_IsSwitchingGear(VehicleTransmission* transmission);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_VehicleTransmission_GetCurrentRatio(VehicleTransmission* transmission);

	[CLink, CallingConvention(.Cdecl)]
	public static extern bool JPH_VehicleTransmission_AllowSleep(VehicleTransmission* transmission);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_VehicleCollisionTester_Destroy(VehicleCollisionTester* tester);

	[CLink, CallingConvention(.Cdecl)]
	public static extern ObjectLayer JPH_VehicleCollisionTester_GetObjectLayer(VehicleCollisionTester* tester);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_VehicleCollisionTester_SetObjectLayer(VehicleCollisionTester* tester, ObjectLayer value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern VehicleCollisionTesterRay* JPH_VehicleCollisionTesterRay_Create(ObjectLayer layer, Vec3* up, float maxSlopeAngle);

	[CLink, CallingConvention(.Cdecl)]
	public static extern VehicleCollisionTesterCastSphere* JPH_VehicleCollisionTesterCastSphere_Create(ObjectLayer layer, float radius, Vec3* up, float maxSlopeAngle);

	[CLink, CallingConvention(.Cdecl)]
	public static extern VehicleCollisionTesterCastCylinder* JPH_VehicleCollisionTesterCastCylinder_Create(ObjectLayer layer, float convexRadiusFraction);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_VehicleControllerSettings_Destroy(VehicleControllerSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern VehicleConstraint* JPH_VehicleController_GetConstraint(VehicleController* controller);

	[CLink, CallingConvention(.Cdecl)]
	public static extern WheelSettingsWV* JPH_WheelSettingsWV_Create();

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_WheelSettingsWV_GetInertia(WheelSettingsWV* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_WheelSettingsWV_SetInertia(WheelSettingsWV* settings, float value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_WheelSettingsWV_GetAngularDamping(WheelSettingsWV* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_WheelSettingsWV_SetAngularDamping(WheelSettingsWV* settings, float value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_WheelSettingsWV_GetMaxSteerAngle(WheelSettingsWV* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_WheelSettingsWV_SetMaxSteerAngle(WheelSettingsWV* settings, float value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern LinearCurve* JPH_WheelSettingsWV_GetLongitudinalFriction(WheelSettingsWV* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_WheelSettingsWV_SetLongitudinalFriction(WheelSettingsWV* settings, LinearCurve* value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern LinearCurve* JPH_WheelSettingsWV_GetLateralFriction(WheelSettingsWV* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_WheelSettingsWV_SetLateralFriction(WheelSettingsWV* settings, LinearCurve* value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_WheelSettingsWV_GetMaxBrakeTorque(WheelSettingsWV* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_WheelSettingsWV_SetMaxBrakeTorque(WheelSettingsWV* settings, float value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_WheelSettingsWV_GetMaxHandBrakeTorque(WheelSettingsWV* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_WheelSettingsWV_SetMaxHandBrakeTorque(WheelSettingsWV* settings, float value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern WheelWV* JPH_WheelWV_Create(WheelSettingsWV* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern WheelSettingsWV* JPH_WheelWV_GetSettings(WheelWV* wheel);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_WheelWV_ApplyTorque(WheelWV* wheel, float torque, float deltaTime);

	[CLink, CallingConvention(.Cdecl)]
	public static extern WheeledVehicleControllerSettings* JPH_WheeledVehicleControllerSettings_Create();

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_WheeledVehicleControllerSettings_GetEngine(WheeledVehicleControllerSettings* settings, VehicleEngineSettings* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_WheeledVehicleControllerSettings_SetEngine(WheeledVehicleControllerSettings* settings, VehicleEngineSettings* value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern VehicleTransmissionSettings* JPH_WheeledVehicleControllerSettings_GetTransmission(WheeledVehicleControllerSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_WheeledVehicleControllerSettings_SetTransmission(WheeledVehicleControllerSettings* settings, VehicleTransmissionSettings* value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern uint32 JPH_WheeledVehicleControllerSettings_GetDifferentialsCount(WheeledVehicleControllerSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_WheeledVehicleControllerSettings_SetDifferentialsCount(WheeledVehicleControllerSettings* settings, uint32 count);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_WheeledVehicleControllerSettings_GetDifferential(WheeledVehicleControllerSettings* settings, uint32 index, VehicleDifferentialSettings* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_WheeledVehicleControllerSettings_SetDifferential(WheeledVehicleControllerSettings* settings, uint32 index, VehicleDifferentialSettings* value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_WheeledVehicleControllerSettings_SetDifferentials(WheeledVehicleControllerSettings* settings, VehicleDifferentialSettings* values, uint32 count);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_WheeledVehicleControllerSettings_AddDifferential(WheeledVehicleControllerSettings* settings, int32 leftWheel, int32 rightWheel);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_WheeledVehicleControllerSettings_GetDifferentialLimitedSlipRatio(WheeledVehicleControllerSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_WheeledVehicleControllerSettings_SetDifferentialLimitedSlipRatio(WheeledVehicleControllerSettings* settings, float value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_WheeledVehicleController_SetDriverInput(WheeledVehicleController* controller, float forward, float right, float brake, float handBrake);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_WheeledVehicleController_SetForwardInput(WheeledVehicleController* controller, float forward);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_WheeledVehicleController_GetForwardInput(WheeledVehicleController* controller);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_WheeledVehicleController_SetRightInput(WheeledVehicleController* controller, float rightRatio);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_WheeledVehicleController_GetRightInput(WheeledVehicleController* controller);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_WheeledVehicleController_SetBrakeInput(WheeledVehicleController* controller, float brakeInput);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_WheeledVehicleController_GetBrakeInput(WheeledVehicleController* controller);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_WheeledVehicleController_SetHandBrakeInput(WheeledVehicleController* controller, float handBrakeInput);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_WheeledVehicleController_GetHandBrakeInput(WheeledVehicleController* controller);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_WheeledVehicleController_GetWheelSpeedAtClutch(WheeledVehicleController* controller);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_WheeledVehicleController_SetTireMaxImpulseCallback(WheeledVehicleController* controller, void* tireMaxImpulseCallback, void* userData);

	[CLink, CallingConvention(.Cdecl)]
	public static extern VehicleEngine* JPH_WheeledVehicleController_GetEngine(WheeledVehicleController* controller);

	[CLink, CallingConvention(.Cdecl)]
	public static extern VehicleTransmission* JPH_WheeledVehicleController_GetTransmission(WheeledVehicleController* controller);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_VehicleTrackSettings_Init(VehicleTrackSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_VehicleTrack_GetAngularVelocity(VehicleTrack* track);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_VehicleTrack_SetAngularVelocity(VehicleTrack* track, float velocity);

	[CLink, CallingConvention(.Cdecl)]
	public static extern uint32 JPH_VehicleTrack_GetDrivenWheel(VehicleTrack* track);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_VehicleTrack_GetInertia(VehicleTrack* track);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_VehicleTrack_GetAngularDamping(VehicleTrack* track);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_VehicleTrack_GetMaxBrakeTorque(VehicleTrack* track);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_VehicleTrack_GetDifferentialRatio(VehicleTrack* track);

	[CLink, CallingConvention(.Cdecl)]
	public static extern VehicleTrack* JPH_TrackedVehicleController_GetTrack(TrackedVehicleController* controller, TrackSide side);

	[CLink, CallingConvention(.Cdecl)]
	public static extern WheelSettingsTV* JPH_WheelSettingsTV_Create();

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_WheelSettingsTV_GetLongitudinalFriction(WheelSettingsTV* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_WheelSettingsTV_SetLongitudinalFriction(WheelSettingsTV* settings, float value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_WheelSettingsTV_GetLateralFriction(WheelSettingsTV* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_WheelSettingsTV_SetLateralFriction(WheelSettingsTV* settings, float value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern WheelTV* JPH_WheelTV_Create(WheelSettingsTV* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern WheelSettingsTV* JPH_WheelTV_GetSettings(WheelTV* wheel);

	[CLink, CallingConvention(.Cdecl)]
	public static extern TrackedVehicleControllerSettings* JPH_TrackedVehicleControllerSettings_Create();

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_TrackedVehicleControllerSettings_GetEngine(TrackedVehicleControllerSettings* settings, VehicleEngineSettings* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_TrackedVehicleControllerSettings_SetEngine(TrackedVehicleControllerSettings* settings, VehicleEngineSettings* value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern VehicleTransmissionSettings* JPH_TrackedVehicleControllerSettings_GetTransmission(TrackedVehicleControllerSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_TrackedVehicleControllerSettings_SetTransmission(TrackedVehicleControllerSettings* settings, VehicleTransmissionSettings* value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_TrackedVehicleControllerSettings_SetTrack(TrackedVehicleControllerSettings* settings, uint32 index, VehicleTrackSettings* track);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_TrackedVehicleController_SetDriverInput(TrackedVehicleController* controller, float forward, float leftRatio, float rightRatio, float brake);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_TrackedVehicleController_GetForwardInput(TrackedVehicleController* controller);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_TrackedVehicleController_SetForwardInput(TrackedVehicleController* controller, float value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_TrackedVehicleController_GetLeftRatio(TrackedVehicleController* controller);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_TrackedVehicleController_SetLeftRatio(TrackedVehicleController* controller, float value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_TrackedVehicleController_GetRightRatio(TrackedVehicleController* controller);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_TrackedVehicleController_SetRightRatio(TrackedVehicleController* controller, float value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_TrackedVehicleController_GetBrakeInput(TrackedVehicleController* controller);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_TrackedVehicleController_SetBrakeInput(TrackedVehicleController* controller, float value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern VehicleEngine* JPH_TrackedVehicleController_GetEngine(TrackedVehicleController* controller);

	[CLink, CallingConvention(.Cdecl)]
	public static extern VehicleTransmission* JPH_TrackedVehicleController_GetTransmission(TrackedVehicleController* controller);

	[CLink, CallingConvention(.Cdecl)]
	public static extern MotorcycleControllerSettings* JPH_MotorcycleControllerSettings_Create();

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_MotorcycleControllerSettings_GetMaxLeanAngle(MotorcycleControllerSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_MotorcycleControllerSettings_SetMaxLeanAngle(MotorcycleControllerSettings* settings, float value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_MotorcycleControllerSettings_GetLeanSpringConstant(MotorcycleControllerSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_MotorcycleControllerSettings_SetLeanSpringConstant(MotorcycleControllerSettings* settings, float value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_MotorcycleControllerSettings_GetLeanSpringDamping(MotorcycleControllerSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_MotorcycleControllerSettings_SetLeanSpringDamping(MotorcycleControllerSettings* settings, float value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_MotorcycleControllerSettings_GetLeanSpringIntegrationCoefficient(MotorcycleControllerSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_MotorcycleControllerSettings_SetLeanSpringIntegrationCoefficient(MotorcycleControllerSettings* settings, float value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_MotorcycleControllerSettings_GetLeanSpringIntegrationCoefficientDecay(MotorcycleControllerSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_MotorcycleControllerSettings_SetLeanSpringIntegrationCoefficientDecay(MotorcycleControllerSettings* settings, float value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_MotorcycleControllerSettings_GetLeanSmoothingFactor(MotorcycleControllerSettings* settings);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_MotorcycleControllerSettings_SetLeanSmoothingFactor(MotorcycleControllerSettings* settings, float value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_MotorcycleController_GetWheelBase(MotorcycleController* controller);

	[CLink, CallingConvention(.Cdecl)]
	public static extern bool JPH_MotorcycleController_IsLeanControllerEnabled(MotorcycleController* controller);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_MotorcycleController_EnableLeanController(MotorcycleController* controller, bool value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern bool JPH_MotorcycleController_IsLeanSteeringLimitEnabled(MotorcycleController* controller);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_MotorcycleController_EnableLeanSteeringLimit(MotorcycleController* controller, bool value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_MotorcycleController_GetLeanSpringConstant(MotorcycleController* controller);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_MotorcycleController_SetLeanSpringConstant(MotorcycleController* controller, float value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_MotorcycleController_GetLeanSpringDamping(MotorcycleController* controller);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_MotorcycleController_SetLeanSpringDamping(MotorcycleController* controller, float value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_MotorcycleController_GetLeanSpringIntegrationCoefficient(MotorcycleController* controller);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_MotorcycleController_SetLeanSpringIntegrationCoefficient(MotorcycleController* controller, float value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_MotorcycleController_GetLeanSpringIntegrationCoefficientDecay(MotorcycleController* controller);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_MotorcycleController_SetLeanSpringIntegrationCoefficientDecay(MotorcycleController* controller, float value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_MotorcycleController_GetLeanSmoothingFactor(MotorcycleController* controller);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_MotorcycleController_SetLeanSmoothingFactor(MotorcycleController* controller, float value);

	[CLink, CallingConvention(.Cdecl)]
	public static extern LinearCurve* JPH_LinearCurve_Create();

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_LinearCurve_Destroy(LinearCurve* curve);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_LinearCurve_Clear(LinearCurve* curve);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_LinearCurve_Reserve(LinearCurve* curve, uint32 numPoints);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_LinearCurve_AddPoint(LinearCurve* curve, float x, float y);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_LinearCurve_Sort(LinearCurve* curve);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_LinearCurve_GetMinX(LinearCurve* curve);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_LinearCurve_GetMaxX(LinearCurve* curve);

	[CLink, CallingConvention(.Cdecl)]
	public static extern float JPH_LinearCurve_GetValue(LinearCurve* curve, float x);

	[CLink, CallingConvention(.Cdecl)]
	public static extern uint32 JPH_LinearCurve_GetPointCount(LinearCurve* curve);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_LinearCurve_GetPoint(LinearCurve* curve, uint32 index, Point* result);

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_LinearCurve_GetPoints(LinearCurve* curve, Point* points, uint32* count);

	[CLink, CallingConvention(.Cdecl)]
	public static extern TempAllocator* JPH_TempAllocator_Create(uint32 size);

	[CLink, CallingConvention(.Cdecl)]
	public static extern TempAllocator* JPH_TempAllocatorMalloc_Create();

	[CLink, CallingConvention(.Cdecl)]
	public static extern void JPH_TempAllocator_Destroy(TempAllocator* allocator);

	[CLink, CallingConvention(.Cdecl)]
	public static extern PhysicsUpdateError JPH_PhysicsSystem_Update2(PhysicsSystem* system, float deltaTime, int32 collisionSteps, TempAllocator* tempAllocator, JobSystem* jobSystem);
}

public static class Physics
{
	public static bool Init()
	{
		return JPH.JPH_Init();
	}

	public static void Shutdown()
	{
		JPH.JPH_Shutdown();
	}
}

public struct PhysicsWorld
{
	public PhysicsSystem* Handle;

	public this(PhysicsSystemSettings* settings)
	{
		Handle = JPH.JPH_PhysicsSystem_Create(settings);
	}

	public void Destroy() mut
	{
		if (Handle != null)
		{
			JPH.JPH_PhysicsSystem_Destroy(Handle);
			Handle = null;
		}
	}

	public BodyInterface* BodyInterface => JPH.JPH_PhysicsSystem_GetBodyInterface(Handle);
	public BodyInterface* BodyInterfaceNoLock => JPH.JPH_PhysicsSystem_GetBodyInterfaceNoLock(Handle);

	public Vec3 Gravity
	{
		get
		{
			Vec3 result = default;
			JPH.JPH_PhysicsSystem_GetGravity(Handle, &result);
			return result;
		}

		set
		{
			Vec3 valueCopy = value;
			JPH.JPH_PhysicsSystem_SetGravity(Handle, &valueCopy);
		}
	}

	public PhysicsUpdateError Update(float deltaTime, int32 collisionSteps, JobSystem* jobSystem)
	{
		return JPH.JPH_PhysicsSystem_Update(Handle, deltaTime, collisionSteps, jobSystem);
	}

	public void OptimizeBroadPhase()
	{
		JPH.JPH_PhysicsSystem_OptimizeBroadPhase(Handle);
	}
}

public struct BodyCreation
{
	public BodyCreationSettings* Handle;

	public this(Shape* shape, RVec3 position, Quat rotation, MotionType motionType, ObjectLayer objectLayer)
	{
		RVec3 positionCopy = position;
		Quat rotationCopy = rotation;
		Handle = JPH.JPH_BodyCreationSettings_Create3(shape, &positionCopy, &rotationCopy, motionType, objectLayer);
	}

	public void Destroy() mut
	{
		if (Handle != null)
		{
			JPH.JPH_BodyCreationSettings_Destroy(Handle);
			Handle = null;
		}
	}
}

public static class Shapes
{
	public static Shape* Sphere(float radius)
	{
		return (Shape*)JPH.JPH_SphereShape_Create(radius);
	}

	public static Shape* Box(Vec3 halfExtent, float convexRadius = JPH.DefaultConvexRadius)
	{
		Vec3 halfExtentCopy = halfExtent;
		return (Shape*)JPH.JPH_BoxShape_Create(&halfExtentCopy, convexRadius);
	}

	public static Shape* Capsule(float halfHeightOfCylinder, float radius)
	{
		return (Shape*)JPH.JPH_CapsuleShape_Create(halfHeightOfCylinder, radius);
	}

	public static Shape* Cylinder(float halfHeight, float radius)
	{
		return (Shape*)JPH.JPH_CylinderShape_Create(halfHeight, radius);
	}

	public static void Release(Shape* shape)
	{
		if (shape != null)
			JPH.JPH_Shape_Destroy(shape);
	}
}

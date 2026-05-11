using System;
using Jolt;

namespace example
{
	class Program
	{
		const ObjectLayer LayerNonMoving = 0;
		const ObjectLayer LayerMoving = 1;
		const BroadPhaseLayer BroadPhaseNonMoving = 0;
		const BroadPhaseLayer BroadPhaseMoving = 1;

		static JobSystem* jobSystem;
		static BroadPhaseLayerInterface* broadPhaseLayerInterface;
		static ObjectLayerPairFilter* objectLayerPairFilter;
		static ObjectVsBroadPhaseLayerFilter* objectVsBroadPhaseLayerFilter;
		static PhysicsSystem* physicsSystem;
		static BodyInterface* bodyInterface;
		static BodyID dynamicBody;

		static BodyID CreateBody(Shape* shape, RVec3 position, MotionType motionType, ObjectLayer objectLayer, Activation activation = .Activate)
		{
			Quat rotation = .Identity;
			RVec3 positionCopy = position;
			BodyCreationSettings* settings = JPH.JPH_BodyCreationSettings_Create3(shape, &positionCopy, &rotation, motionType, objectLayer);
			BodyID bodyID = JPH.JPH_BodyInterface_CreateAndAddBody(bodyInterface, settings, activation);
			JPH.JPH_BodyCreationSettings_Destroy(settings);
			return bodyID;
		}

		static void CreateStack(Vec3 basePosition, int size, float halfExtent)
		{
			Shape* boxShape = Shapes.Box(.(halfExtent, halfExtent, halfExtent));

			for (int i = 0; i < size; i++)
			{
				for (int j = 0; j < size - i; j++)
				{
					RVec3 position = .(
						basePosition.X + ((j * 2) - (size - i)) * halfExtent,
						basePosition.Y + (i * 2 + 1) * halfExtent,
						basePosition.Z);

					CreateBody(boxShape, position, (MotionType)2, LayerMoving);
				}
			}

			Shapes.Release(boxShape);
		}

		static BodyID CreateDynamic(RVec3 position, Shape* shape, Vec3 velocity)
		{
			BodyID bodyID = CreateBody(shape, position, (MotionType)2, LayerMoving);
			Vec3 velocityCopy = velocity;
			JPH.JPH_BodyInterface_SetLinearVelocity(bodyInterface, bodyID, &velocityCopy);
			return bodyID;
		}

		static void InitPhysics(bool interactive)
		{
			JPH.JPH_Init();

			jobSystem = JPH.JPH_JobSystemThreadPool_Create(null);

			objectLayerPairFilter = JPH.JPH_ObjectLayerPairFilterTable_Create(2);
			JPH.JPH_ObjectLayerPairFilterTable_EnableCollision(objectLayerPairFilter, LayerNonMoving, LayerMoving);
			JPH.JPH_ObjectLayerPairFilterTable_EnableCollision(objectLayerPairFilter, LayerMoving, LayerMoving);

			broadPhaseLayerInterface = JPH.JPH_BroadPhaseLayerInterfaceTable_Create(2, 2);
			JPH.JPH_BroadPhaseLayerInterfaceTable_MapObjectToBroadPhaseLayer(broadPhaseLayerInterface, LayerNonMoving, BroadPhaseNonMoving);
			JPH.JPH_BroadPhaseLayerInterfaceTable_MapObjectToBroadPhaseLayer(broadPhaseLayerInterface, LayerMoving, BroadPhaseMoving);

			objectVsBroadPhaseLayerFilter = JPH.JPH_ObjectVsBroadPhaseLayerFilterTable_Create(
				broadPhaseLayerInterface,
				2,
				objectLayerPairFilter,
				2);

			PhysicsSystemSettings settings = .();
			settings.MaxBodies = 65536;
			settings.NumBodyMutexes = 0;
			settings.MaxBodyPairs = 65536;
			settings.MaxContactConstraints = 10240;
			settings.BroadPhaseLayerInterface = broadPhaseLayerInterface;
			settings.ObjectLayerPairFilter = objectLayerPairFilter;
			settings.ObjectVsBroadPhaseLayerFilter = objectVsBroadPhaseLayerFilter;

			physicsSystem = JPH.JPH_PhysicsSystem_Create(&settings);
			bodyInterface = JPH.JPH_PhysicsSystem_GetBodyInterface(physicsSystem);

			Vec3 gravity = .(0.0f, -9.81f, 0.0f);
			JPH.JPH_PhysicsSystem_SetGravity(physicsSystem, &gravity);

			Shape* groundShape = Shapes.Box(.(100.0f, 1.0f, 100.0f));
			CreateBody(groundShape, .(0.0f, -1.0f, 0.0f), (MotionType)0, LayerNonMoving, .DontActivate);
			Shapes.Release(groundShape);

			float stackZ = 10.0f;
			for (int i = 0; i < 5; i++)
			{
				stackZ -= 10.0f;
				CreateStack(.(0.0f, 0.0f, stackZ), 10, 2.0f);
			}

			Shape* sphereShape = Shapes.Sphere(10.0f);
			dynamicBody = CreateDynamic(.(0.0f, 40.0f, 100.0f), sphereShape, .(0.0f, -50.0f, -100.0f));
			Shapes.Release(sphereShape);

			JPH.JPH_PhysicsSystem_OptimizeBroadPhase(physicsSystem);
		}

		static void StepPhysics(bool interactive)
		{
			JPH.JPH_PhysicsSystem_Update(physicsSystem, 1.0f / 60.0f, 1, jobSystem);
		}

		static void CleanupPhysics(bool interactive)
		{
			JPH.JPH_PhysicsSystem_Destroy(physicsSystem);
			JPH.JPH_JobSystem_Destroy(jobSystem);
			JPH.JPH_Shutdown();
		}

		public static int Main()
		{
			const int frameCount = 100;
			InitPhysics(false);

			for (int i = 0; i < frameCount; i++)
				StepPhysics(false);

			RVec3 position = default;
			JPH.JPH_BodyInterface_GetPosition(bodyInterface, dynamicBody, &position);

			Console.WriteLine(scope $"{position.X}, {position.Y}, {position.Z}");
			CleanupPhysics(false);
			return 0;
		}
	}
}

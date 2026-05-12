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

		static PhysicsWorld world;
		static BroadPhaseFilter broadPhaseFilter;
		static VoxelCompound voxelTerrain;
		static BodyHandle voxelBody;
		static BodyHandle dynamicBody;

		static bool BroadPhaseShouldCollide(void* userData, BroadPhaseLayer layer)
		{
			return true;
		}

		static void CreateStack(Vec3 basePosition, int size, float halfExtent)
		{
			ShapeRef boxShape = .Box(.(halfExtent, halfExtent, halfExtent));

			for (int i = 0; i < size; i++)
			{
				for (int j = 0; j < size - i; j++)
				{
					RVec3 position = .(
						basePosition.X + ((j * 2) - (size - i)) * halfExtent,
						basePosition.Y + (i * 2 + 1) * halfExtent,
						basePosition.Z);

					world.CreateBody(boxShape, position, .Dynamic, LayerMoving);
				}
			}

			boxShape.Destroy();
		}

		static BodyHandle CreateDynamic(RVec3 position, ShapeRef shape, Vec3 velocity)
		{
			BodyHandle body = world.CreateBody(shape, position, .Dynamic, LayerMoving);
			body.SetLinearAndAngularVelocity(velocity, .(0.0f, 0.25f, 0.0f));
			body.AddAngularImpulse(.(0.0f, 0.0f, 0.1f));
			return body;
		}

		static void RunBroadPhaseFilterQuery()
		{
			RayCastResult hit = default;
			world.CastRay(.(0.0f, 100.0f, 0.0f), .(0.0f, -200.0f, 0.0f), ref hit, &broadPhaseFilter);
		}

		static void InitPhysics(bool interactive)
		{
			Physics.Init();

			world = .();
			world.MapLayer(LayerNonMoving, BroadPhaseNonMoving);
			world.MapLayer(LayerMoving, BroadPhaseMoving);
			world.EnableCollision(LayerNonMoving, LayerMoving);
			world.EnableCollision(LayerMoving, LayerMoving);

			broadPhaseFilter = .(=> BroadPhaseShouldCollide);

			ShapeRef groundShape = .Box(.(100.0f, 1.0f, 100.0f));
			world.CreateBody(groundShape, .(0.0f, -1.0f, 0.0f), .Static, LayerNonMoving, .DontActivate);
			groundShape.Destroy();

			Triangle meshTriangle = .()
			{
				V1 = .(-8.0f, 0.0f, -8.0f),
				V2 = .(8.0f, 0.0f, -8.0f),
				V3 = .(0.0f, 0.0f, 8.0f),
				MaterialIndex = 0
			};
			ShapeRef meshShape = .Mesh(&meshTriangle, 1);
			world.CreateBody(meshShape, .(0.0f, 0.0f, 25.0f), .Static, LayerNonMoving, .DontActivate);
			meshShape.Destroy();

			voxelTerrain = .Create(2.0f);
			voxelBody = voxelTerrain.CreateBody(&world, .(-18.0f, 0.0f, 8.0f), .Static, LayerNonMoving, .DontActivate);
			voxelTerrain.BeginEdit();
			voxelTerrain.Add(.(0, 0, 0));
			uint32 raisedVoxel = voxelTerrain.Add(.(1, 0, 0));
			voxelTerrain.Add(.(0, 1, 0));
			voxelTerrain.Move(raisedVoxel, .(1, 1, 0));
			voxelTerrain.AdjustCenterOfMass();
			voxelTerrain.NotifyChanged(voxelBody, true, .DontActivate);

			float stackZ = 10.0f;
			for (int i = 0; i < 5; i++)
			{
				stackZ -= 10.0f;
				CreateStack(.(0.0f, 0.0f, stackZ), 10, 2.0f);
			}

			ShapeRef sphereShape = .Sphere(10.0f);
			dynamicBody = CreateDynamic(.(0.0f, 40.0f, 100.0f), sphereShape, .(0.0f, -50.0f, -100.0f));
			sphereShape.Destroy();

			world.OptimizeBroadPhase();
		}

		static void StepPhysics(bool interactive)
		{
			world.Step(1.0f / 60.0f);
		}

		static void CleanupPhysics(bool interactive)
		{
			world.Destroy();
			broadPhaseFilter.Destroy();
			voxelTerrain.Destroy();
			Physics.Shutdown();
		}

		public static int Main()
		{
			const int frameCount = 100;
			InitPhysics(false);

			for (int i = 0; i < frameCount; i++)
				StepPhysics(false);

			RunBroadPhaseFilterQuery();

			RVec3 position = dynamicBody.Position;
			Console.WriteLine(scope $"{position.X}, {position.Y}, {position.Z}");

			CleanupPhysics(false);
			return 0;
		}
	}
}

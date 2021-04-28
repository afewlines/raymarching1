#ifndef WORLD_H
#define WORLD_H
#include "../DataStructures/Distance.h"
#include "../DataStructures/vec2.h"
#include "../DataStructures/vec3.h"
#include "../Objects/Cameras.h"
#include "../Objects/Lights.h"
#include <cstdint>
#include <iostream>
#include <memory>
#include <string>
#include <vector>

typedef std::unique_ptr< WorldObjects::RenderableObject >   RenderableObjectPointer;
typedef std::vector< RenderableObjectPointer >              RenderableObjectVector;
typedef std::unique_ptr< WorldObjects::Light >              LightPointer;
typedef std::vector< LightPointer >                         LightVector;

class World {
	public:
		WorldObjects::Camera *active_camera;

		int max_steps;
		float min_distance, max_distance, threshold;

		RenderableObjectVector renderables;
		LightVector lights;

		World() { max_steps = 200;min_distance = 0.01f;max_distance = 250.0f;threshold = 0.001f; }

		// world managment functions
		void add_object( WorldObjects::RenderableObject *target );
		void add_light( WorldObjects::Light *target );
		void deets(); // deets


		void distance_func( DISTRESULT *result, VectorMath::vec3 *p );
		float distance_func_fast( VectorMath::vec3 p, float max_dist );
};

class WorldManager {
	public:
		World *active_world;
		WorldManager() {}

		// world managment functions
		void select_world( World * );
};


#endif

#ifndef WORLD_H
#define WORLD_H
#include "../DataStructures/Distance.h"
#include "../DataStructures/vec2.h"
#include "../DataStructures/vec3.h"
#include <cstdint>
#include <iostream>
#include <string>
#include <vector>

class World {
	public:
		std::vector< WorldObjects::RenderableObject > renderables;
		// COLOR diffuse;

		World() {}

		// world managment functions
		WorldObjects::RenderableObject *add_object( WorldObjects::RenderableObject * );
		void deets(); // deets
};

class WorldManager {
	public:
		World *active_world;
		WorldManager() {}

		// world managment functions
		void select_world( World * );
};


#endif

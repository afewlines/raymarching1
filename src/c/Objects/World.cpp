#include "World.h"



WorldObjects::RenderableObject *World::add_object( WorldObjects::RenderableObject *target ) {
	this->renderables.push_back( *target );
	return ( &this->renderables.back() );
}

void World::deets() {
	std::vector< WorldObjects::RenderableObject >::iterator it  = this->renderables.begin();
	std::vector< WorldObjects::RenderableObject >::iterator end = this->renderables.end();

	std::cout << "------------------" << std::endl;
	std::cout << "Tree:\n";

	for ( it, end; it != end; ++it ) {
		std::cout <<
			it->id <<
			"' @ " <<
			it->position.to_string() <<
			std::endl;
	}
} // World::deets

void WorldManager::select_world( World *w ) {
	this->active_world = w;
}

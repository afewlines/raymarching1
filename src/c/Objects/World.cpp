#include "World.h"



void World::add_object( WorldObjects::RenderableObject *target ) {
	this->renderables.emplace_back( RenderableObjectPointer( target ) );
} // World::add_object

void World::add_light( WorldObjects::Light *target ) {
	this->lights.emplace_back( LightPointer( target ) );
} // World::add_object

void World::deets() {
	std::cout << "------------------" << std::endl;
	std::cout << "Tree:\n";

	for ( const auto &ob : this->renderables ) {
		std::cout <<
			ob->id <<
			"' @ " <<
			ob->position.to_string() <<
			std::endl;
	}
} // World::deets

void World::distance_func( DISTRESULT *result, VectorMath::vec3 *p ) {
	result->d = this->max_distance;         // won't go farther than max
	size_t size = this->renderables.size(); // # of items to iterate through
	float  cur_dist;                        // dist from one item

	for ( size_t i = 0; i < size; ++i ) {
		cur_dist = this->renderables[ i ]->distance_from( p );
		if ( result->d > cur_dist ) {
			result->d             = cur_dist;                       //update
			result->closest_color = &this->renderables[ i ]->color; //update
		}
	}
} // World::distance_func

float World::distance_func_fast( VectorMath::vec3 p, float max_dist ) {
	float result = max_dist;      // won't go farther than max
	float cur_dist;               // dist from one item

	for ( int i = 0; i < this->renderables.size(); ++i ) {
		cur_dist = this->renderables[ i ]->distance_from( &p );
		if ( result > cur_dist ) {
			result = cur_dist;
		}
	}
	return ( result );
} // World::distance_func

void WorldManager::select_world( World *w ) {
	this->active_world = w;
}

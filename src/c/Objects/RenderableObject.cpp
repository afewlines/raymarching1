#include "RenderableObject.h"
#include <iostream>
#include <math.h>
#include <sstream>
#include <string>

namespace WorldObjects {
int RenderableObject::_count = 0;
// wrapping functions
void RenderableObject::get_position( float out[] ) {
	out[ 0 ] = this->position.x;
	out[ 1 ] = this->position.y;
	out[ 2 ] = this->position.z;
} // get_position

void RenderableObject::get_rotation( float out[] ) {
	out[ 0 ] = this->rotation.x;
	out[ 1 ] = this->rotation.y;
	out[ 2 ] = this->rotation.z;
} // get_rotation

void RenderableObject::set_position( float x, float y, float z ) {
	this->position.x = x;
	this->position.y = y;
	this->position.z = z;
} // set_position

void RenderableObject::set_rotation( float x, float y, float z ) {
	this->rotation.x = x;
	this->rotation.y = y;
	this->rotation.z = z;
} // set_rotation

void RenderableObject::translate_point( VectorMath::vec3 *vec ) {
	vec->rotate_by_euler( this->rotation );
}
}

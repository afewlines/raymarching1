#include "RenderablePrimitives.h"
#include <iostream>
#include <math.h>
#include <sstream>
#include <string>

namespace WorldObjects {
// wrapping functions
void PrimitivePlane::get_size( float out[] ) {
	out[ 0 ] = this->size.x;
	out[ 1 ] = this->size.y;
} // get_position

void PrimitivePlane::set_size( float w, float h ) {
	this->size.x = w;
	this->size.y = h;
} // set_position

float PrimitivePlane::distance_from( VectorMath::vec3 p ) {
	return ( p.y - this->position.y );
}

float PrimitiveSphere::distance_from( VectorMath::vec3 p ) {
	return ( p.magnitude() - this->radius );
}
}

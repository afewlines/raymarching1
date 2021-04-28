#include "RenderablePrimitives.h"
#include <iostream>
#include <math.h>
#include <sstream>
#include <string>

const VectorMath::vec3 null_height( 1.0, 0.0, 1.0 );
const VectorMath::vec3 repetition( 4.0, 0.0, 1.0 );
const float            rep_x = 4.0f;
const float            rep_y = 4.0f;
const float            rep_z = 4.0f;

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

float PrimitivePlane::distance_from( VectorMath::vec3 *p ) {
	return ( p->y - this->position.y );
} // PrimitivePlane::distance_from

float PrimitiveSphere::distance_from( VectorMath::vec3 *p ) {
	VectorMath::vec3 offset( *p );
	VectorMath::vec3 p2( this->position );
	float            hrx = rep_x / 2.0f;
	float            hry = rep_y / 2.0f;
	float            hrz = rep_z / 2.0f;

	offset  -= p2;
	offset.x = fmod( abs( offset.x ) + hrx, rep_x ) - hrx;
	offset.y = fmod( abs( offset.y ) + hry, rep_y ) - hry;
	offset.z = fmod( abs( offset.z ) + hrz, rep_z ) - hrz;

	// offset -= p2;
	return ( offset.magnitude() - this->radius );
} // PrimitiveSphere::distance_from

// float PrimitiveSphere::distance_from( VectorMath::vec3 *p ) {
// 	VectorMath::vec3 offset( *p );
//
// 	offset -= p2;
// 	return ( offset.magnitude() - this->radius );
// } // PrimitiveSphere::distance_from
}

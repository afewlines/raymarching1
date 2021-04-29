#include "RenderablePrimitives.h"
#include <iostream>
#include <math.h>
#include <sstream>
#include <string>

const VectorMath::vec3 null_height( 1.0, 0.0, 1.0 );
const float            rep_x = 8.0f;
const float            rep_y = 4.0f;
const float            rep_z = 8.0f;

void mod_xz( VectorMath::vec3 *vec, float x, float z ) {
	vec->x = fmod( abs( vec->x ) + ( x / 2.0f ), x ) - ( x / 2.0f );
	vec->z = fmod( abs( vec->z ) + ( z / 2.0f ), z ) - ( z / 2.0f );
} // mod_xz

namespace WorldObjects {
// wrapping functions
void PrimitivePlane::get_size( float out[] ) {
	// small func
	out[ 0 ] = this->size.x;
	out[ 1 ] = this->size.y;
} // PrimitivePlane::get_size

void PrimitivePlane::set_size( float w, float h ) {
	// small func
	this->size.x = w;
	this->size.y = h;
} // PrimitivePlane::set_size

void PrimitiveBox::get_size( float out[] ) {
	out[ 0 ] = this->size.x;
	out[ 1 ] = this->size.y;
	out[ 2 ] = this->size.z;
} // PrimitiveBox::get_size

void PrimitiveBox::set_size( float x, float y, float z ) {
	this->size.x = x;
	this->size.y = y;
	this->size.z = z;
} // PrimitiveBox::set_size

float PrimitivePlane::distance_from( VectorMath::vec3 *p ) {
	return ( p->y - this->position.y );
} // PrimitivePlane::distance_from

float PrimitiveSphere::distance_from( VectorMath::vec3 *p ) {
	VectorMath::vec3 offset( *p );

	offset -= this->position;
	mod_xz( &offset, rep_x, rep_z );  //UNCOMMENT FOR INFINITE REPETITION OF OBJECT

	return ( offset.magnitude() - this->radius );
} // PrimitiveSphere::distance_from

float PrimitiveBox::distance_from( VectorMath::vec3 *p ) {
	VectorMath::vec3 offset( *p );

	offset -= this->position;
	mod_xz( &offset, rep_x, rep_z ); //UNCOMMENT FOR INFINITE REPETITION OF OBJECT
	offset.set( VectorMath::vecabs( offset ) - this->size );

	return (
		VectorMath::max( offset, 0.0 ).magnitude() +
		VectorMath::min(
			0.0,
			VectorMath::max(
				offset.x,
				VectorMath::max(
					offset.y,
					offset.z ) ) )
		);
} // PrimitiveSphere::distance_from
}

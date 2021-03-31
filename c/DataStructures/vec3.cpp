#include "vec3.h"
#include <math.h>
#include <sstream>
#include <string>

namespace VectorMath {
vec3::vec3( float x, float y, float z ) {
	this->x = x;
	this->y = y;
	this->z = z;
}

vec3::vec3( float all ) : vec3( all, all, all ) {}
vec3::vec3() : vec3( 0.0 ) {}
vec3::vec3( const vec3 &that ) : vec3( that.x, that.y, that.z ) {}


vec3 vec3::operator+=( const vec3 &that ) {
	this->x += that.x;
	this->y += that.y;
	this->z += that.z;
	return ( *this );
} // +=

vec3 vec3::operator+=( const float scale ) {
	this->x += scale;
	this->y += scale;
	this->z += scale;
	return ( *this );
} // +=

vec3 vec3::operator-=( const vec3 &that ) {
	this->x -= that.x;
	this->y -= that.y;
	this->z -= that.z;
	return ( *this );
} // +=

vec3 vec3::operator-=( const float scale ) {
	this->x -= scale;
	this->y -= scale;
	this->z -= scale;
	return ( *this );
} // +=

std::string vec3::to_string() {
	std::ostringstream out;

	out << this->x << "," << this->y << "," << this->z;
	return ( out.str() );
} // vec3::to_string

float vec3::magnitude() {
	return ( sqrt( this->x + this->y + this->z ) );
}

vec3 vec3::normalize() {
	float mag = this->magnitude();

	if ( mag > 0 ) {
		this->x /= mag;
		this->y /= mag;
		this->z /= mag;
	}
	return ( *this );
} // vec3::normalize

vec3 operator+( const vec3 &lthat, const vec3 &that ) {
	vec3 out( lthat );

	out += that;
	return ( out );
} // +

vec3 operator+( const vec3 &lthat, const float scale ) {
	vec3 out( lthat );

	out += scale;
	return ( out );
} // +

vec3 operator-( const vec3 &lthat, const vec3 &that ) {
	vec3 out( lthat );

	out -= that;
	return ( out );
} // +

vec3 operator-( const vec3 &lthat, const float scale ) {
	vec3 out( lthat );

	out -= scale;
	return ( out );
} // +
}

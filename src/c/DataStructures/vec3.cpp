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
	return ( sqrt( pow( this->x, 2.0f ) + pow( this->y, 2.0f ) + pow( this->z, 2.0f ) ) );
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

vec3 operator*( const vec3 &lthat, const float scale ) {
	vec3 out( lthat );

	out.x *= scale;
	out.y *= scale;
	out.z *= scale;
	return ( out );
} // vec3::normalize

vec3 operator*( const vec3 &lthat, const vec3 &that ) {
	vec3 out( lthat );

	out.x *= that.x;
	out.y *= that.y;
	out.z *= that.z;
	return ( out );
} // *

float dot( const vec3 &v1, const vec3 &v2 ) {
	return ( ( v1.x * v2.x ) + ( v1.y * v2.y ) + ( v1.z * v2.z ) );
}

vec3 vecabs( const vec3 &vec ) {
	vec3 out( vec );

	out.x = abs( vec.x );
	out.y = abs( vec.y );
	out.z = abs( vec.z );

	return ( out );
} // abs

vec3 min( const vec3 &vec, float min_val ) {
	vec3 out( vec );

	out.x = min( vec.x, min_val );
	out.y = min( vec.y, min_val );
	out.z = min( vec.z, min_val );

	return ( out );
} // min

vec3 max( const vec3 &vec, float max_val ) {
	vec3 out( vec );

	out.x = max( vec.x, max_val );
	out.y = max( vec.y, max_val );
	out.z = max( vec.z, max_val );

	return ( out );
} // max

void vec3::rotate_by_euler( const vec3 rot ) {
	vec3  hold;

	float xc = cos( rot.x ), xs = sin( rot.x );

	hold.y = this->y * xc - this->z * xs;
	hold.z = this->z * xc + this->y * xs;

	float yc = cos( rot.y ), ys = sin( rot.y );

	hold.x  = this->x * yc - hold.z * ys;
	this->z = hold.z * yc + this->x * ys;

	float zc = cos( rot.z ), zs = sin( rot.z );

	this->x = hold.x * zc - hold.y * zs;
	this->y = hold.y * zc + hold.x * zs;
} // vec3::rotate_by_euler
}

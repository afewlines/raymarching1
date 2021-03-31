#include "vec2.h"
#include <sstream>
#include <string>

namespace VectorMath {
vec2::vec2( float x, float y ) {
	this->x = x;
	this->y = y;
}

vec2::vec2( float all ) : vec2( all, all ) {}
vec2::vec2() : vec2( 0.0 ) {}
vec2::vec2( const vec2 &that ) : vec2( that.x, that.y ) {}

vec2 vec2::operator+=( const vec2 &that ) {
	this->x += that.x;

	this->y += that.y;
	return ( *this );
} // +=

vec2 vec2::operator+=( const float scale ) {
	this->x += scale;
	this->y += scale;
	return ( *this );
} // +=

vec2 vec2::operator-=( const vec2 &that ) {
	this->x -= that.x;
	this->y -= that.y;
	return ( *this );
} // +=

vec2 vec2::operator-=( const float scale ) {
	this->x -= scale;
	this->y -= scale;
	return ( *this );
} // +=

std::string vec2::to_string() {
	std::ostringstream out;

	out << this->x << "," << this->y;
	return ( out.str() );
} // vec2::to_string

vec3 vec2::to3() {
	vec3 out( 1 );

	out.x = this->x;
	out.y = this->y;
	return ( out );
} // vec2::to3

vec2 operator+( const vec2 &lthat, const vec2 &that ) {
	vec2 out( lthat );

	out += that;
	return ( out );
} // +

vec2 operator+( const vec2 &lthat, const float scale ) {
	vec2 out( lthat );

	out += scale;
	return ( out );
} // +

vec2 operator-( const vec2 &lthat, const vec2 &that ) {
	vec2 out( lthat );

	out -= that;
	return ( out );
} // +

vec2 operator-( const vec2 &lthat, const float scale ) {
	vec2 out( lthat );

	out -= scale;
	return ( out );
} // +

vec2 operator/( const vec2 &lthat, const float scale ) {
	vec2 out( lthat );

	out.x /= scale;
	out.y /= scale;
	return ( out );
} // +
}

#ifndef VECTOR2_H
#define VECTOR2_H
#include "vec3.h"
#include <cstdint>
#include <string>

namespace VectorMath {
class vec2 {
	public:
		float x, y;
		vec2( float, float );
		vec2( float );
		vec2( const vec2 & );
		vec2();
		// ~vec2();
		vec2 operator+=( const vec2 & );
		vec2 operator+=( const float );

		vec2 operator-=( const vec2 & );
		vec2 operator-=( const float );

		std::string to_string();
		vec3 to3();
};
vec2 operator+( const vec2 &, const vec2 & );
vec2 operator+( const vec2 &, const float );
vec2 operator-( const vec2 &, const vec2 & );
vec2 operator-( const vec2 &, const float );
vec2 operator/( const vec2 &, const float );
}

#endif

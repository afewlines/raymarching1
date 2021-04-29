#ifndef VECTOR3_H
#define VECTOR3_H
#include "VectorMaths.h"
#include <cstdint>
#include <string>

namespace VectorMath {
class vec3 {
	public:
		float x, y, z;
		vec3( float, float, float );
		vec3( float );
		vec3( const vec3 & );
		vec3();
		// ~vec3();

		void set( const vec3 &o ) { this->x = o.x;this->y = o.y;this->z = o.z; }

		vec3 operator+=( const vec3 & );
		vec3 operator+=( const float );

		vec3 operator-=( const vec3 & );
		vec3 operator-=( const float );


		std::string to_string();
		float magnitude();
		vec3 normalize();

		void rotate_by_euler( const vec3 );
};
vec3 operator+( const vec3 &lthat, const vec3 &that );
vec3 operator+( const vec3 &lthat, const float scale );
vec3 operator-( const vec3 &lthat, const vec3 &that );
vec3 operator-( const vec3 &lthat, const float scale );
vec3 operator*( const vec3 &lthat, const vec3 &that );
vec3 operator*( const vec3 &lthat, const float scale );
float dot( const vec3 &v1, const vec3 &v2 );
vec3 vecabs( const vec3 &vec );
vec3 min( const vec3 &vec, float min );
vec3 max( const vec3 &vec, float min );
}

#endif

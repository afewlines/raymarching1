#ifndef VECTOR3_H
#define VECTOR3_H
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
		vec3 operator+=( const vec3 & );
		vec3 operator+=( const float );

		vec3 operator-=( const vec3 & );
		vec3 operator-=( const float );


		std::string to_string();
		float magnitude();
		vec3 normalize();
};
vec3 operator+( const vec3 &lthat, const vec3 &that );
vec3 operator+( const vec3 &lthat, const float scale );
vec3 operator-( const vec3 &lthat, const vec3 &that );
vec3 operator-( const vec3 &lthat, const float scale );
}

#endif

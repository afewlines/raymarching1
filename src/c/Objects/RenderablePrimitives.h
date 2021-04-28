#ifndef ROBJECTPRIMITIVES_H
#define ROBJECTPRIMITIVES_H
#include "RenderableObject.h"
#include <cstdint>
#include <string>

namespace WorldObjects {
class PrimitivePlane :public RenderableObject {
	public:
		VectorMath::vec2 size;

		PrimitivePlane() {}

		void get_size( float[] );
		void set_size( float, float );

		float distance_from( VectorMath::vec3 * );
};

class PrimitiveSphere :public RenderableObject {
	public:
		float radius;

		PrimitiveSphere() {}

		float get_radius() { return ( this->radius ); }
		void set_radius( float rad ) { this->radius = rad; }

		float distance_from( VectorMath::vec3 * );
};
}


#endif

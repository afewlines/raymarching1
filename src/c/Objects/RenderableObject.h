#ifndef ROBJECT_H
#define ROBJECT_H
#include "../DataStructures/Color.h"
#include "../DataStructures/vec2.h"
#include "../DataStructures/vec3.h"
#include <cstdint>
#include <iostream>
#include <string>

namespace WorldObjects {
class RenderableObject {
	public:
		static int _count;

		int id;
		VectorMath::vec3 position;
		VectorMath::vec3 rotation;
		// COLOR diffuse;

		RenderableObject() { this->id = _count++; }
		// RenderableObject( int id, ) { this->id = id; }

		// wrapping functions
		void get_position( float [] );
		void get_rotation( float [] );
		void set_position( float, float, float );
		void set_rotation( float, float, float );


		// spatial functions
		void translate_point( VectorMath::vec3 * );


		// dist function
		virtual float distance_from( VectorMath::vec3 ) { return ( 4096.0 ); }


		// float get_color_( VectorMath::vec3 );

		// std::string to_string();
};
}


#endif

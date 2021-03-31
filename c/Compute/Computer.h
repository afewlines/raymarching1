#ifndef COMPUTER_H
#define COMPUTER_H
#include "../DataStructures/Color.h"
#include "../DataStructures/vec2.h"
#include "../DataStructures/vec3.h"
#include <string>

class Computer {
	public:
		int mod;

		Computer();

		int compute_frame( double time );


		//// TODO
		// void set_world(); ?
		// void set_active_camera(); ?
		////////


		void set_vp_size( int w, int h );
		void set_buffer_image( char *buf );
		void update_mod( int n );


	private:
		// world obj
		// active camera

		VectorMath::vec2 vp;

		char *buffer_image;

		COLOR colbuf;

		void calculate_pixel_color( VectorMath::vec2 *uv );
};

#endif

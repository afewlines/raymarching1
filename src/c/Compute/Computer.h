#ifndef COMPUTER_H
#define COMPUTER_H
#include "../Compute/RayMarchLib.h"
#include "../DataStructures/Color.h"
#include "../DataStructures/Distance.h"
#include "../DataStructures/vec2.h"
#include "../DataStructures/vec3.h"
#include "../Objects/World.h"
#include <string>

class Computer {
	public:
		int mod;
		World *active_world;

		Computer();

		void compute_frame();
		void compute_frame_bounded( int lox, int hix, int lowy, int hiy );


		//// TODO
		// void set_world(); ?
		// void set_active_camera(); ?
		////////

		void set_active_world( World *world ) {}
		void set_vp_size( int w, int h );
		void set_buffer_image( char *buf );
		void update_mod( int n );


	private:
		// world obj
		// active camera

		VectorMath::vec2 vp;

		char *buffer_image;

		COLORBUF colbuf;

		void update_pixel( VectorMath::vec3 camera_pos, int x, int y );
		void calculate_pixel_color( World *world,
		    VectorMath::vec3              ray_origin,
		    COLORBUF                      *color,
		    VectorMath::vec2              *uv );
};

#endif

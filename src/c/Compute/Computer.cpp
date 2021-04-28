#include "Computer.h"
#include <cmath>
#include <cstring>
#include <iostream>


using namespace VectorMath;

Computer::Computer() {
	this->set_vp_size( 0, 0 );
}

void Computer::set_vp_size( int w, int h ) {
	this->vp.x = w;
	this->vp.y = h;
}

void Computer::set_buffer_image( char *buf ) {
	this->buffer_image = buf;
}

void Computer::update_pixel( vec3 camera_pos, int x, int y ) {
	vec2     coord( x, y );
	COLORBUF color;

	coord    = ( coord + ( vp / -2.0f ) ) / vp.y;
	coord.y *= -1.0f;
	calculate_pixel_color( active_world, camera_pos, &color, &coord );

	memcpy( &this->buffer_image[ ( x + ( y * (int)vp.x ) ) * 3 ], &color, 3 ); // copy 3
} // Computer::update_pixel

void Computer::calculate_pixel_color( World *world, vec3 ray_origin, COLORBUF *col_out, vec2 *uv ) {
	// float dist = march_ray_depth( world, uv->x, uv->y ) - world->max_distance;
	// int   col  = dist >= 0?0:255;
	DISTRESULT dist;
	float      depth = march_ray_depth( &dist, world, &ray_origin, uv->x, uv->y ) / world->max_distance;

	if ( depth > 1.0f ) {
		col_out->r = 0;
		col_out->g = 0;
		col_out->b = 0;
		return;
	} else {
		// float light = ( get_light_diffuse( world, ray_origin ) ) * 255.0f * depth;
		float light = ( get_light_diffuse( world, ray_origin ) ) * 255.0f * ( 1.0f - depth );
		col_out->r = (unsigned char)( int (dist.closest_color->r * light) );
		col_out->g = (unsigned char)( int (dist.closest_color->g * light) );
		col_out->b = (unsigned char)( int (dist.closest_color->b * light) );
	}
} // Computer::calculate_pixel_color

void Computer::compute_frame() {
	// vec2 coord;
	vec3 camera_pos( active_world->active_camera->position );

	for ( int y = 0; y < vp.y; y++ ) {
		for ( int x = 0; x < vp.x; x++ ) {
			this->update_pixel( camera_pos, x, y );
		}
	}
} // Computer::compute_frame

void Computer::compute_frame_bounded( int lox, int hix, int lowy, int hiy ) {
	// vec2 coord;
	vec3 camera_pos( active_world->active_camera->position );

	for ( int y = lowy; y < hiy; y++ ) {
		for ( int x = lox; x < hix; x++ ) {
			this->update_pixel( camera_pos, x, y );
		}
	}
} // Computer::compute_frame

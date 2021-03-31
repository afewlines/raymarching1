#include "Computer.h"

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

void Computer::calculate_pixel_color( vec2 *uv ) {
	this->colbuf.r = (unsigned char)this->mod;
	this->colbuf.g = (unsigned char)( 256 * ( std::abs( uv->x ) ) ) % 256;
	this->colbuf.b = (unsigned char)( 255 * ( std::abs( uv->y ) ) ) % 256;
} // Computer::calculate_pixel_color

int Computer::compute_frame( double time ) {
	vec2 coord;

	this->mod = (int)( ( cos( time / 2.0 ) + 1 ) * 128 ) % 256;

	for ( int y = 0; y < this->vp.y; y++ ) {
		for ( int x = 0; x < this->vp.x; x++ ) {
			coord.x = x;
			coord.y = y;
			coord	= ( coord + ( this->vp / -2.0f ) ) / this->vp.y;
			calculate_pixel_color( &coord );

			memcpy( &this->buffer_image[ ( x + ( y * (int)this->vp.x ) ) * 3 ], &this->colbuf, 3 ); // copy 3 bytes over buf
		}
	}

	return ( 1 );
} // Computer::compute_frame

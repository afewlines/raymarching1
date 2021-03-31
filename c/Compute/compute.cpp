#include "compute.h"
#include "RayMarchLib.h"
#include <chrono>
#include <cmath>
#include <cstring>
#include <iostream>
#include <string>

using namespace VectorMath;

int runtest() {
	std::cout << "hey world" << std::endl;
	return ( 0 );
}

// image buffer (where pixels write to)
// viewport buffer
// time buffer
// image buffer size ?
int calculate_frame( char *ibuf, char *tbuf, int vp_w, int vp_h ) {
	// auto start = std::chrono::steady_clock::now();
	COLOR  col;
	double t;
	int    mod;
	vec2   coord, vp( vp_w, vp_h );

	memcpy( &t, tbuf, 8 );
	mod = (int)( ( cos( t / 2.0 ) + 1 ) * 128 ) % 256;

	for ( int y = 0; y < vp_h; y++ ) {
		for ( int x = 0; x < vp_w; x++ ) {
			coord.x = x;
			coord.y = y;
			coord	= ( coord + ( vp / -2.0f ) ) / vp.y;
			col	= calculate_pixel( &coord, mod );

			memcpy( &ibuf[ ( x + ( y * vp_w ) ) * 3 ], &col, 3 ); // copy 3 bytes over buf
		}
	}

	// auto end = std::chrono::steady_clock::now();
	// std::chrono::duration< double > elapsed_seconds = end - start;
	// std::cout << "elapsed time: " << elapsed_seconds.count() * 1000 << "s\n";
	return ( 1 );
} // calculate_frame

// COLOR calculate_pixel( int x, int y, int mod ) {
COLOR calculate_pixel( vec2 *uv, int mod ) {
	COLOR a;

	// float depth = march_ray_depth( uv.to3().normalize() );
	a.r = (unsigned char)mod;
	a.g = (unsigned char)( 256 * ( std::abs( uv->x ) ) ) % 256;
	a.b = (unsigned char)( 255 * ( std::abs( uv->y ) ) ) % 256;
	return ( a );
} // calculate

char *test_uv( int x, int y, int sx, int sy ) {
	vec2 coord, vp( sx, sy );

	coord.x = x;
	coord.y = y;
	vec2 res = ( coord + ( vp / -2.0f ) ) / vp.y;

	// vec2 res = vp / -2.0f;

	std::cout << res.to_string() << '\n';

	return ( 0 );
} // test_uv

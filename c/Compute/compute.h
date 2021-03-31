#ifndef COMPUTELIB_H
#define COMPUTELIB_H
#include "../DataStructures/Color.h"
#include "../DataStructures/vec2.h"
#include "../DataStructures/vec3.h"

int runtest();
int calculate_frame( char *, char *, int, int );
COLOR calculate_pixel( VectorMath::vec2*, int );
char * test_uv(int, int, int, int );


#endif

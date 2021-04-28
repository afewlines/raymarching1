#ifndef STRUCT_DIST
#define STRUCT_DIST
#include "../Objects/RenderableObject.h"

typedef struct dresult {
  float d;
  WorldObjects::RenderableObject *closest_obj;
  COLOR *closest_color;
} DISTRESULT;

#endif

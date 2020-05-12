
#ifndef __APP_H__
#define __APP_H__

typedef int ChromType;
typedef int ChromTypeB;

typedef int Appstruct;

typedef struct {
	float x;
	float y;
} Coords;

typedef struct {
	int start;
	int end;
} Edges;

#define NUMBER_POINTS 50
#define NUMBER_EDGES 823

#define MAX_ROUTE_LENGTH (4 * NUMBER_EDGES)

#endif

#ifndef __REPORT__CUH__
#define __REPORT__CUH__

#include <cstdio>
#include <cstdlib>

#include "type.cuh"

void Report(int gen, IPTR pop, Population *p, double time);
void RawStat(FILE *fp, IPTR pj, Population *p, double time);
#endif
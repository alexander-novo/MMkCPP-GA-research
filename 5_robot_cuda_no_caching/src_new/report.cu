#include <stdio.h>

#include <cstdlib>

#include "case.cuh"
#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include "type.cuh"

void ObjFuncStat(FILE *fp, IPTR pj, Population *p);
void RawStat(FILE *fp, IPTR pj, Population *p);
__host__ void PhenoPrint(FILE *fp, IPTR pj, Population *p);

void GooguStat(FILE *fp, IPTR pop, Population *p);

void Report(int gen, IPTR pop, Population *p) { /* report generations stats */
	FILE *fp;

	/* print Progress Statistics to file */
	if ((fp = fopen(p->oFile, "a")) == NULL) {
		printf("error in opening file ofile: %s \n", p->oFile);
		exit(1);
	} else {
		RawStat(fp, pop, p);
		fclose(fp);
	}
	/* print Progress Statistics for Googu */
	if ((fp = fopen(p->fitFile, "a")) == NULL) {
		printf("error in opening file fitFile in report: %s \n", p->fitFile);
		exit(1);
	} else {
		GooguStat(fp, pop, p);
		fclose(fp);
	}

	/* print Phenotype information for Googu*/
	if (p->bigGen == p->generation) {
		if ((fp = fopen(p->phenoFile, "a")) == NULL) {
			printf("error in opening file phenoFile %s \n", p->phenoFile);
			exit(1);
		} else {
			PhenoPrint(fp, pop, p);
			// Wait for GPU to finish before accessing on host
			// cudaDeviceSynchronize();

			fclose(fp);
		}
	}

	/*  If improvement on current best,
	    save new best individual to case-base */
	if (p->saveCases) {
		if (p->bigGen == p->generation) {
			if ((fp = fopen(p->caseFileName, "a")) == NULL) {
				printf("error in opening file casefile: %s \n", p->caseFileName);
				exit(1);
			} else {
				SaveCase(fp, &pop[p->maxi], p->generation, p);
				fflush(fp);
				fclose(fp);
			}
		}
	}

	/* Progress stats on stdout */
	RawStat(stdout, pop, p);
}

void ObjFuncStat(FILE *fp, IPTR pj, Population *p) {
	fprintf(fp, "%d %f\n", p->generation, pj->objfunc);
}

void RawStat(FILE *fp, IPTR pop, Population *p) {
	fprintf(fp, " %3d %9.3f %9.3f %9.3f %9.3f %9.3f", p->generation, p->max, p->avg, p->min,
	        p->smax, p->smin);
	fprintf(fp, " %3d %9.3f %3d", p->bigGen, p->bigMax, p->bigInd);
	fprintf(fp, " %9.3f\n", pop[p->maxi].objfunc);
}

void GooguStat(FILE *fp, IPTR pop, Population *p) {
	fprintf(fp, " %3d %.3f %.3f %.3f\n", p->generation, p->max, p->avg, p->min);
}

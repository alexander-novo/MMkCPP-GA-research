#include <errno.h>
#include <sys/stat.h>
#include <unistd.h>

#include <chrono>
#include <cmath>
#include <cstdio>
#include <cstdlib>
#include <vector>

#include "case.cuh"
#include "report.cuh"
// #include "init.cuh"
// #include "type.cuh"

// extern int errno;

void Statistics(IPTR, Population *p);

void Initialize(int argc, char *argv[], Population *p, Functions *f);

void WritePid(char *pidFile);
void RmPidFile(char *pidFile);

void PhenoPrint(FILE *fp, IPTR pop, Population *p);  // modified

int main(int argc, char *argv[]) {
	IPTR tmp;            // used for swapping two IPTRs
	int foo;             /* just a placeholder for a value that is not used */
	Population pop, *p;  // The current population under inspection
	Functions funcs,
	    *f;  // A set of function pointers which are swapped out depending on the parameters.

	p = &pop;
	f = &funcs;

	p->generation = 0;

	Initialize(argc, argv, p, f);

	std::vector<double> genTimes;
	genTimes.reserve(p->maxgen);
	double timeAverage = 0;

	// WritePid(p->pidFile);
	while (p->generation < p->maxgen) {
		p->generation++;

		auto start = std::chrono::system_clock::now();
		foo        = f->CurrentGA(p->oldpop, p->newpop, p->generation, p, f);
		auto end   = std::chrono::system_clock::now();
		genTimes.push_back(
		    std::chrono::duration_cast<std::chrono::milliseconds>(end - start).count() / 1000.0);
		timeAverage += genTimes.back() / p->maxgen;

		if (p->injectFraction > 0.0) {
			if ((p->generation % p->injectPeriod == 0) && (p->generation <= p->injectStop)) {
				LoadCases(p->newpop, p->generation, p->injectFraction, p, f);
				/* printf("Loaded cases %d\n", (int) (loadPerc/100.0 * popsize));*/
			}
		}
		Statistics(p->newpop, p);
		Report(p->generation, p->newpop, p, genTimes.back());

		// Record data (best individual at each gen)
		FILE *dataFile;

		dataFile = fopen("myData.txt", "a");

		fprintf(dataFile, "%f\n", p->newpop[p->maxi].objfunc);

		fclose(dataFile);

		// Record best route
		FILE *routeFile;
		routeFile = fopen("myRoutes.txt", "a");

		// PhenoPrint<<<1,1>>>(routeFile, p->newpop, p);
		PhenoPrint(routeFile, p->newpop, p);
		// Wait for GPU to finish before accessing on host
		// cudaDeviceSynchronize();

		fprintf(routeFile, "\n");
		for (int i = 0; i < p->newpop->chromLen; i++)
			fprintf(routeFile, "%d, ", p->newpop->chrom[i]);
		fprintf(routeFile, "\n");
		fclose(routeFile);

		tmp       = p->oldpop;
		p->oldpop = p->newpop;
		p->newpop = tmp;
	}
	if (p->nCurrentCases > 0) {
		p->nCases = FindNCases(p->nCFile);
		StoreNcases(p->nCFile, p->nCases, p->nCurrentCases);
	}

	printf("Average time taken between generations: %f\n", timeAverage);
	printf("Adjusted for population: %f\n", timeAverage / p->popsize);
	// RmPidFile(p->pidFile);

	return 0;
}

void WritePid(char *fname) {
	struct stat buf;
	int er;
	FILE *fp;

	er = stat(fname, &buf);
	if (!(er == -1 || errno == ENOENT)) {
		fprintf(stderr, "Lock file (%s) exists, Process running\n", fname);
		fprintf(stderr, "This process is exiting....\n");
		exit(1);
	}

	if ((fp = fopen(fname, "w")) == NULL) {
		fprintf(stderr, "Error in opening file %s for writing\n", fname);
		exit(2);
	}

	// fprintf(fp, "%lu", getpid());
}

void RmPidFile(char *fname) {
	unlink(fname);
}

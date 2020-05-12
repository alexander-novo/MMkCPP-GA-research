CC = g++
NVCC = nvcc

HDRS =  type.h defaults.h case.h random.h utils.h select.h finders.h \
	dist.h ox.h 

SRCS =  xover.c gen.c cigar.c report.c \
	statistics.c  random.c  select.c utils.c halve.c scale.c \
	finders.c hms.c case.c dist.c\
	pmx.c evalpop.c ox.c lcs.c

OBJDIR		= objs

CUDAOBJS =  $(OBJDIR)/xover.obj $(OBJDIR)/gen.obj $(OBJDIR)/report.obj \
	$(OBJDIR)/statistics.obj  $(OBJDIR)/random.obj  $(OBJDIR)/select.obj $(OBJDIR)/utils.obj $(OBJDIR)/halve.obj $(OBJDIR)/scale.obj \
	$(OBJDIR)/finders.obj $(OBJDIR)/hms.obj $(OBJDIR)/case.obj  $(OBJDIR)/dist.obj\
	$(OBJDIR)/pmx.obj $(OBJDIR)/evalpop.obj $(OBJDIR)/ox.obj $(OBJDIR)/lcs.obj

COBJS = $(OBJDIR)/cigar.o

APPHDRS = app.h init.h greedy.h

APPSRCS = app.c greedy.c init.c 
# greedy must be listed here since it uses app specific information
# greedy xover calculates distances between cities
APPOBJS = $(OBJDIR)/app.obj $(OBJDIR)/greedy.obj $(OBJDIR)/init.obj

TESTHDRS = testapp.h testinit.h

TESTSRCS = testapp.c testinit.c

TESTOBJS = $(OBJDIR)/testapp.o $(OBJDIR)/testinit.o

TESTINFILE = testinfile

INFILE  = infile eil76.tsp berlin52.tsp eil51.tsp lin105.tsp lin318.tsp run.sh

BASENAME	= cigartsp-1.1.tgz

CFLAGS =  -O3 -std=c++11
NVCCFLAGS = -O3 -dc -DCACHING

cigar	: $(CUDAOBJS) $(COBJS) $(APPOBJS)
	$(NVCC) -o cigar $(CUDAOBJS) $(COBJS) $(APPOBJS) $(CLIBS)

cigartest	: $(OBJS) $(TESTOBJS)
	$(NVCC) -o cigartest $(OBJS) $(TESTOBJS) $(CLIBS)

clean	: 
ifeq ($(OS),Windows_NT)
	del $(OBJS) $(APPOBJS)
else
	rm $(OBJS) $(APPOBJS)
	touch $(HDRS) $(APPHDRS)
endif

dist	:
	tar -cvzf $(BASENAME) $(HDRS) $(APPHDRS) $(SRCS) $(APPSRCS) $(INFILE) Makefile $(TESTHDRS) $(TESTSRCS) $(TESTINFILE)
	cp $(BASENAME) /staff/sushil/classes/gas/code/cigar/

#$(OBJS)	: $(HDRS) $(APPHDRS)
$(OBJDIR)/%.obj: %.cu Makefile
	$(NVCC) -c -o $@ $< $(NVCCFLAGS)

$(OBJDIR)/%.o: %.cpp Makefile
	$(CC) -c -o $@ $< $(CFLAGS)

#$(APPOBJS)	:	$(APPHRDS)

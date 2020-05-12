#! /bin/sh

# -i input file name
# -a application data file name
# -M minimization problem
# -s random seed between 0 and 1, needed to seed the random number generator
#
# Run the 50 vertice options

../../src_new/cigar -i ../infiles/infile_200 -a ../../../graphs/graph_50_200.csv -M -s 0.47657
../../src_new/cigar -i ../infiles/infile_400 -a ../../../graphs/graph_50_200.csv -M -s 0.47657
../../src_new/cigar -i ../infiles/infile_800 -a ../../../graphs/graph_50_200.csv -M -s 0.47657
../../src_new/cigar -i ../infiles/infile_1600 -a ../../../graphs/graph_50_200.csv -M -s 0.47657
../../src_new/cigar -i ../infiles/infile_3200 -a ../../../graphs/graph_50_200.csv -M -s 0.47657
../../src_new/cigar -i ../infiles/infile_6400 -a ../../../graphs/graph_50_200.csv -M -s 0.47657



#
# ./cigar -i infile -a eil76.tsp -M -s 0.47657 > /dev/null 
# will redirect most output to /dev/null


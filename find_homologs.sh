#!/bin/bash
# Usage: find_homologs.sh <query file> <subject file> <output file>

query=$1
subject=$2
output=$3

# Build a nucleotide BLAST database from the subject file
makeblastdb -in "$subject" -dbtype nucl -out subject_db

# Run tblastn: protein query against translated nucleotide subject
# outfmt 6 with qlen included so we can compute 90% of query length for filtering
tblastn -query "$query" -db subject_db \
  -outfmt "6 qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore qlen" \
  > raw_results.tmp

# Filter: keep hits with >30% identity AND alignment length >90% of query length
awk '$3 > 30 && $4 > 0.9 * $13' raw_results.tmp > "$output"

# Report number of matches
num_matches=$(wc -l < "$output")
echo "$num_matches"

# Clean up intermediate files
rm -f raw_results.tmp subject_db.*

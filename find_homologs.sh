#!/bin/bash
# Usage: find_homologs.sh <query file> <subject file> <output file>

query=$1
subject=$2
output=$3

makeblastdb -in "$subject" -dbtype nucl -out subject_db > /dev/null 2>&1

tblastn -query "$query" -db subject_db \
  -outfmt "6 qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore qlen" \
  > raw_results.tmp 2> /dev/null

awk '$3 > 30 && $4 > 0.9 * $13' raw_results.tmp > "$output"

num_matches=$(wc -l < "$output")
echo "$num_matches"

rm -f raw_results.tmp subject_db.*

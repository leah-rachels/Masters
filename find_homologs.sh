#!/bin/bash
# Usage: find_homologs.sh <query file> <subject file> <output file>

query=$1
subject=$2
output=$3

makeblastdb -in "$subject" -dbtype nucl -out subject_db

tblastn -query "$query" -db subject_db \
  -outfmt "6 qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore qlen" \
  > raw_results.tmp

awk '$3 > 30 && $4 > 0.9 * $13' raw_results.tmp > "$output"
wc -l < "$output"

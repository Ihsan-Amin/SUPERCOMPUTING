#!/bin/bash
set -ueo pipefail

FASTA=$1

SEQS=$(grep -c "^>" ${FASTA})
NUC=$(grep -v "^>" ${FASTA} | tr -d '\n' | wc -c)
TABLE=$(seqtk comp ${FASTA} | cut -f 1,2)

echo "sequences: ${SEQS}"
echo "nucleotides: ${NUC}"
echo "Sequence Name and Length:"
echo "${TABLE}"

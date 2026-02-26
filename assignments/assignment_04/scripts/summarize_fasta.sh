#!/bin/bash
set -ueo pipefail
FASTA=$1
NUM_SEQS=$(grep -c "^>" ${FASTA})
TOTAL_NUC=$(seqtk comp ${FASTA} | cut -f 2 | paste -sd+ | bc)
SEQ_TABLE=$(seqtk comp ${FASTA} | cut -f 1,2)

echo "sequences: ${NUM_SEQS}"
echo "nucleotides: ${TOTAL_NUC}"
echo "Sequence Name and Length:"
echo "${SEQ_TABLE}"

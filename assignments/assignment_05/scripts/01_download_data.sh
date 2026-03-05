#!/bin/bash
set -ueo pipefail

DIR="${HOME}/SUPERCOMPUTING/assignments/assignment_05"
RAW_DIR="${DIR}/data/raw"
mkdir -p "${RAW_DIR}"
cd "${RAW_DIR}"
wget https://gzahn.github.io/data/fastq_examples.tar
tar -xf fastq_examples.tar

rm -f fastq_examples.tar
echo "Downloaded:"
ls -1 "${RAW_DIR}"


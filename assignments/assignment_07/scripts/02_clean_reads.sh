#!/bin/bash
set -ueo pipefail

MAIN_DIR="${HOME}/SUPERCOMPUTING/assignments/assignment_07"
RAW_DIR="${MAIN_DIR}/data/raw"
CLEAN_DIR="${MAIN_DIR}/data/clean"

export PATH=$PATH:${HOME}/programs

mkdir -p "${CLEAN_DIR}"

for fwd in ${RAW_DIR}/*_1.fastq.gz; do
    rev=${fwd/_1.fastq.gz/_2.fastq.gz}

    filename=$(basename "$fwd")
    samplename=${filename%%_*}

    out1="${CLEAN_DIR}/${samplename}_1.fastq.gz"
    out2="${CLEAN_DIR}/${samplename}_2.fastq.gz"
    fastp -i "$fwd" -I "$rev" -o "$out1" -O "$out2" --detect_adapter_for_pe -j /dev/null -h /dev/null
done

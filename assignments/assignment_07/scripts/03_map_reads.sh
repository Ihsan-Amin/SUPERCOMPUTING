#!/bin/bash
set -ueo pipefail

MAIN_DIR="${HOME}/SUPERCOMPUTING/assignments/assignment_07"
CLEAN_DIR="${MAIN_DIR}/data/clean"
REF="${MAIN_DIR}/data/dog_reference/dog_reference_genome.fna"
OUTPUT_DIR="${MAIN_DIR}/output"

mkdir -p "${OUTPUT_DIR}"

module load miniforge3
source "$(dirname $(dirname $(which conda)))/etc/profile.d/conda.sh"
conda activate bbmap-env

for fwd in ${CLEAN_DIR}/*_1.fastq.gz; do

    rev=${fwd/_1.fastq.gz/_2.fastq.gz}
    filename=$(basename "$fwd")
    samplename=${filename%%_*}

    OUT="${OUTPUT_DIR}/${samplename}.sam"
    MATCHES="${OUTPUT_DIR}/${samplename}_dog-matches.sam"

    bbmap.sh ref="${REF}" in1="${fwd}" in2="${rev}" out="${OUT}" minid=0.95 -Xmx16g
    samtools view -F 4 "${OUT}" > "${MATCHES}"

done

conda deactivate

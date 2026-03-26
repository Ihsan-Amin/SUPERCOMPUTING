#!/bin/bash
set -ueo pipefail

MAIN_DIR="${HOME}/SUPERCOMPUTING/assignments/assignment_07"
DATA_DIR="${MAIN_DIR}/data"
RAW_DIR="${DATA_DIR}/raw"
REF_DIR="${DATA_DIR}/dog_reference"
METADATA="${DATA_DIR}/SraRunTable.csv"

export PATH=$PATH:${HOME}/programs
export PATH=$PATH:${HOME}/programs/sratoolkit.3.4.1-ubuntu64/bin

mkdir -p "${RAW_DIR}" "${REF_DIR}"

for ACC in $(tail -n +2 "${METADATA}" | cut -d ',' -f 1); do
    if [[ -s "${RAW_DIR}/${ACC}_1.fastq" || -s "${RAW_DIR}/${ACC}_1.fastq.gz" ]]; then
        echo "Skipping ${ACC} - already downloaded"
    else
        echo "Downloading ${ACC}..."
        fasterq-dump "${ACC}" --split-files --outdir "${RAW_DIR}"
    fi
done

if ls ${RAW_DIR}/*.fastq >/dev/null 2>&1; then
    gzip ${RAW_DIR}/*.fastq
fi

datasets download genome taxon "Canis familiaris" --reference --filename "${REF_DIR}/dog_genome.zip"
unzip "${REF_DIR}/dog_genome.zip" -d "${REF_DIR}"

cp ${REF_DIR}/ncbi_dataset/data/GCF_*/GCF_*.fna "${REF_DIR}/dog_reference_genome.fna"
rm -rf "${REF_DIR}/ncbi_dataset" "${REF_DIR}/dog_genome.zip" "${REF_DIR}/README.md"



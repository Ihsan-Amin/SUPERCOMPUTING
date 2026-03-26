#!/bin/bash

set -euo pipefail

echo "| Sample | QC reads | Dog-mapped reads |"
echo "|---|---:|---:|"

for fwd in data/clean/*_1*.fastq.gz; do
    filename=$(basename "${fwd}")
    sample=${filename%%_*}

    qc_reads=$(gunzip -c "${fwd}" | awk 'END {print NR/4}')
    mapped_reads=$(wc -l < "output/${sample}_dog-matches.sam")

    echo "| ${sample} | ${qc_reads} | ${mapped_reads} |"
done

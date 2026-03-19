#!/bin/bash
set -ueo pipefail

mkdir -p ./data

wget -O ./data/SRR33939694.fastq.gz  "https://zenodo.org/records/15730819/files/SRR33939694.fastq.gz?download=1"

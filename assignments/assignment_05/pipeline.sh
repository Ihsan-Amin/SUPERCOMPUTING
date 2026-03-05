#!/bin/bash
set -euo pipefail

DIR="${HOME}/SUPERCOMPUTING/assignments/assignment_05"
SCRIPTS_DIR="${DIR}/scripts"
RAW_DIR="${DIR}/data/raw"

#Download and extract data using first script
${SCRIPTS_DIR}/01_download_data.sh

# for  every forward read file run fastp  , use script 2 
for FWD in ${RAW_DIR}/*_R1_*.fastq.gz
do
    ${SCRIPTS_DIR}/02_run_fastp.sh "$FWD"
done

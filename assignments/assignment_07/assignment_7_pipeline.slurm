#!/bin/bash

#SBATCH --job-name=assignment_7
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --time=1-00:00:00
#SBATCH --mem=24G
#SBATCH --mail-type=FAIL,BEGIN,END
#SBATCH --mail-user=iamin01@wm.edu
#SBATCH -o /sciclone/home/iamin01/SUPERCOMPUTING/assignments/assignment_07/output/assignment_7_%j.out
#SBATCH -e /sciclone/home/iamin01/SUPERCOMPUTING/assignments/assignment_07/output/assignment_7_%j.err

set -euo pipefail

export PATH=$PATH:${HOME}/programs
export PATH=$PATH:${HOME}/programs/sratoolkit.3.4.1-ubuntu64/bin

MAIN_DIR="${HOME}/SUPERCOMPUTING/assignments/assignment_07"

cd "${MAIN_DIR}"

bash scripts/01_download_data.sh
bash scripts/02_clean_reads.sh
bash scripts/03_map_reads.sh


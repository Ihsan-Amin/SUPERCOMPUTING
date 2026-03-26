# Assignment 7
# Ihsan Amin

# The goal of this assignment was to download 10  metagenomic dataset to identify dog DNA matches in shotgun sequencing reads. 
# pipeline (sbatch assignment_7_pipeline.slurm) runs scripts 1-3, downloading sequence data, cleaning reads, mapping reads to the Canis familiaris reference genome. Scripts are located in the script directory. Data is organized in the data directory and seperated into cleaned, reference dog genome, and raw genome data. An sraruntable.csv is in the base data folder and used as a reference for script 1 to download data from SRA
# run pipeline via SLURM, sbatch assignment_7_pipeline.slurm in a7 directory


## SRR_Acc_List.txt

```text
SRR37374480
SRR37374490
SRR37374505
SRR37374508
SRR37374512
SRR37374517
SRR37767435
SRR37767436
SRR37767437
SRR37767438
```

## Task 1

**Bora**

```bash
cd ~/SUPERCOMPUTING/assignments/assignment_07
mkdir -p data/raw data/clean data/dog_reference mkdir -p scripts mkdir -p output
```

## Task 2: Sequence data download + Script

```bash
# Navigate to https://www.ncbi.nlm.nih.gov/datasets/docs/v2/command-line-tools/download-and-install/ 
# Shotgun metagenome data (random library selection, not amplicon) Illumina sequences, not PacBio or ONT
# used "soil metagenome"[Organism] AND illumina[Platform] AND wgs[Strategy] AND random[Selection] and selected paired under library layout 
# Downloaded SRARunTable.csv to local and used FileZilla to place in assignment_07/data directory 
# use the NCBI `datasets command-line program to download the reference genome for Canis familiaris
```

**Nano `scripts/01_download_data.sh`**

**Script:**

```bash
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
```

```bash
chmod +x scripts/01_download_data.sh
```

## Task 3: Clean up raw Reads using fastp

**Nano `scripts/02_clean_reads.sh`**

**Script:**

```bash
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
```

```bash
chmod +x scripts/02_clean_reads.sh
```

## Task 4 and 5: Map reads and extract matches w/ dog

**Nano `scripts/03_map_reads.sh`**

**Script:**

```bash
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
```

```bash
chmod +x scripts/03_map_reads.sh
```

## Task 6: Slurm Job for running all scripts

**Nano `assignment_7_pipeline.slurm`**

```bash
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
```

```bash
sbatch assignment_7_pipeline.slurm
sacct
```

## Task 7: monitoring slurm

```bash
tail -f output/assignment_7_*.out
cat output/assignment_7_*.err
sacct
```

## Task 8: finding dog DNA matches in metagenomic files

**Nano `scripts/04_count_reads.sh`**

**Script:**

```bash
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
```

```bash
chmod +x scripts/04_count_reads.sh
bash scripts/04_count_reads.sh > task8_table.md
```

```text
# pipeline took too long could not run this in time
```

## Task 9 Reflection

This task was interesting to bring together but i ultimately got stuck on downloading and unzipping the data. I likely selected genome data that was too large or came accross a bottleneck with the slurm process. I'll spend time reviewing what i did wrong over the week. I do feel more confident accessing SLURM and checking in on tasks. 


# Assignment 05 — fastp QC Pipeline

Pipeline downloads FASTQ data, trims using `fastp`, and outputs the data into a trimmed folder under the data folder.

**fastp version:** v1.1.0

## Directory Structure - used an llm to generate the pasteable outline

```
assignment_05/
├── data/
│   ├── raw/
│   └── trimmed/
├── log/
├── scripts/
│   ├── 01_download_data.sh
│   └── 02_run_fastp.sh
├── pipeline.sh
├── .gitignore
└── README.md
```

## Pipeline instructionsn

```bash
cd ~/SUPERCOMPUTING/assignments/assignment_05
./pipeline.sh
```
Runs `01_download_data.sh` which downoads and extracts fastq files from https://gzahn.github.io/data/fastq_examples.tar
then loops through all files with `02_run_fastp.sh`

### Task 1: 

```bash
cd SUPERCOMPUTING
cd assignments
cd assignment_05
mkdir scripts
mkdir log
mkdir data
cd data
mkdir raw
mkdir trimmed
```

### Task 2:

```bash
cd ~/SUPERCOMPUTING/assignments/assignment_05/scripts
nano 01_download_data.sh
```

Script:

```bash
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
```

```bash
chmod +x 01_download_data.sh
./01_download_data.sh
```

### Task 3:

```bash
cd ~/programs
wget http://opengene.org/fastp/fastp
chmod +x fastp
which fastp # returned no fastp in $PATH 
export PATH=$HOME/programs:$PATH
echo 'export PATH=$HOME/programs:$PATH' >> ~/.bashrc
exec bash  # restarted  bash to apply .bashrc
fastp --version # v1.1.0
fastp --help
```

### Task 4:

```bash
cd ~/SUPERCOMPUTING/assignments/assignment_05
nano ./scripts/02_run_fastp.sh
```

Script:

```bash
#!/bin/bash
set -ueo pipefail
FWD_IN=$1
REV_IN=${FWD_IN/_R1_/_R2_}
FWD_OUT=${FWD_IN/.fastq.gz/.trimmed.fastq.gz}
REV_OUT=${REV_IN/.fastq.gz/.trimmed.fastq.gz}
FWD_OUT=${FWD_OUT/raw/trimmed}
REV_OUT=${REV_OUT/raw/trimmed}
BASENAME=$(basename "$FWD_IN")
SAMPLENAME=${BASENAME%%_R1*}
DIR="${HOME}/SUPERCOMPUTING/assignments/assignment_05"
LOG_DIR="${DIR}/log"

fastp \
  --in1 "$FWD_IN" \
  --in2 "$REV_IN" \
  --out1 "$FWD_OUT" \
  --out2 "$REV_OUT" \
  --json /dev/null \
  --html "${LOG_DIR}/${SAMPLENAME}_fastp.html" \
  --trim_front1 8 \
  --trim_front2 8 \
  --trim_tail1 20 \
  --trim_tail2 20 \
  --n_base_limit 0 \
  --length_required 100 \
  --average_qual 20
```

```bash
chmod +x ./scripts/02_run_fastp.sh
./scripts/02_run_fastp.sh ./data/raw/6083_001_S1_R1_001.subset.fastq.gz
ls ./data/trimmed/ #processed files
```

### Task 5:

```bash
nano pipeline.sh
```

Script:

```bash
#!/bin/bash

set -euo pipefail
#pipefail exits scrpt if it fails

#set vars for proj directory, change if directory differs
DIR="${HOME}/SUPERCOMPUTING/assignments/assignment_05"
SCRIPTS_DIR="${DIR}/scripts"
RAW_DIR="${DIR}/data/raw"

# Download and extract data using first script
${SCRIPTS_DIR}/01_download_data.sh

#For every forward file, run fastp using script 2
for FWD in ${RAW_DIR}/*_R1_*.fastq.gz
do
    ${SCRIPTS_DIR}/02_run_fastp.sh "$FWD"
done
```

```bash
chmod +x pipeline.sh
```

### Task 6:

```bash
rm -f ./data/raw/*.fastq.gz
rm -f ./data/raw/*.fastq
rm -f ./data/trimmed/*.fastq.gz
rm -f ./data/trimmed/*.fastq
ls ./data/raw/
./pipeline.sh
```

### Task 7: Reflection

These tasks were mostly straight foreward but I had to search why ./ was required before running scripts.
I was in scripts when i ran script 1 and had to google why it was necessary (tells the shell to look for the script in the current dir).
I also found the fastp install process tedious, had to confirm it wasn't in path then add it to path and restart bash. 
The big thing i learned was param expansion. In script 2 I take the file name i'm assessing and assign it to fwd-in, then I get the reverse read filename by replacing r1 with r2 in REV_IN=${FWD_IN/_R1_/_R2_}
its also easy to adjust output names the same way, when i change fastq.gz to trimmed.fastq.gz. 
its also easier to change output dir the same way  because its included in the call.
I ended up googling how to use basename to strip out the dir when im making the file name, and used %%-R1* to cut off everything _R1 onwards inclusively.  
Splitting the script into parts makes sense from a debugging perspective if one script isnt working, also lets me test each one as I make them as i go. The pipeline can also be iterated on with additional scripts.
The immediate issue i can see is if the directories change, i would need to change them in each script manually. (though i guess theres a script out there to automate that) 

### Task 8: Git push w/ ignores for data files

```bash
echo "data/raw/" > .gitignore
echo "data/trimmed/" >> .gitignore
echo "*.fastq.gz" >> .gitignore
echo "*.fastq" >> .gitignore
echo "*.tar" >> .gitignore
cat .gitignore
cd ..
git add assignment_05
git status
git commit -m "added assignment 5 without readme.md"
git push
```

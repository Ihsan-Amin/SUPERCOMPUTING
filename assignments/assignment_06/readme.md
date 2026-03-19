# Ihsan Amin — Assignment 06

## 3 folders, data, assemblies, and scripts. Data contains the zipped FASTQ file (SRR33939694.fastq.gz) with small data set of sequences from Oxford Nanopore Technologies (ONT, AKA: Nanopore) of E. coli phages. Assemblies contains three subdirectories (assembly_conda, assembly_local, assembly_module) containing the assembly FASTA and Flye log from running the same assembly through their respective software environments. Scripts contains scripts that download the data, set up / install environments for flye, process the data in their respective environments, and delete redundant files. 

## The pipeline (pipeline.sh) stitches the scripts together, allowing all 3 environemnts to run from scratch by downloading the data, setting up flye locally and via conda, and running flye with conda local and module on the data. It also deletes redundant files, and prints out each environments respective logs.
## pipeline run

```bash
bash pipeline.sh
```
Runs all scripts, all 3 Flye methods

### Task 1 — directories

```bash
bora
cd SUPERCOMPUTING/assignments/assignment_06
mkdir -p data scripts assemblies/assembly_conda assemblies/assembly_local assemblies/assembly_module
touch README.md pipeline.sh
```

### Task 2 — Downloads data into data folder

```bash
nano ./scripts/01_download_data.sh
```

```bash
#!/bin/bash
set -ueo pipefail

mkdir -p ./data

wget -O ./data/SRR33939694.fastq.gz "https://zenodo.org/records/15730819/files/SRR33939694.fastq.gz?download=1"
```

```bash
bash scripts/01_download_data.sh
```

### Task 3 — dowloading Flye 2.9.6 locally copied from instal guide at https://github.com/mikolmogorov/Flye/blob/flye/docs/INSTALL.md#local-building-without-installation

```bash
nano ./scripts/02_flye_2.9.6_manual_build.sh
```

```bash
#!/bin/bash
set -ueo pipefail

cd ~/programs/
rm -rf Flye #removes flye for fresh re-runs 
git clone --branch 2.9.6 https://github.com/fenderglass/Flye
cd Flye
make
```

```bash
bash scripts/02_flye_2.9.6_manual_build.sh
export PATH=$PATH:~/programs/Flye/bin # compiles to programs
flye -v
```

### Task 4 — Flye 2.9.6 conda

- miniforge 3 loaded
- `mamba` for install, `conda` for activating
- Exports environment and creates `flye-env.yml`

```bash
nano ./scripts/02_flye_2.9.6_conda_install.sh
```

```bash
#!/bin/bash
set -ueo pipefail

module load miniforge3/
source "$(conda info --base)/etc/profile.d/conda.sh"
conda env remove -y -n flye-env # added -y to auto accept changes for re-runs
mamba create -y -n flye-env -c bioconda -c conda-forge flye=2.9.6
conda activate flye-env
flye -v
conda env export --no-builds > ./flye-env.yml #Document the environment by exporting a yml file of all the dependencies and versions

conda deactivate
```

```bash
bash scripts/02_flye_2.9.6_conda_install.sh
```

### Task 5 — Design the Flye command 

```bash
Flye -h 
flye --nano-hq ./data/SRR33939694.fastq.gz --genome-size 50k --out-dir ./assemblies/assembly_local --threads 6 --meta # using nano high quality data, googled 50kb expected size, 6 threads, out dir placeholder w/ local, meta for uneven coverage from >1 type of phage 

```

### Task 6A — Run Flye via conda: Activates conda runs assembly, renames outputs, removes unwanted files, deactivates

```bash
nano ./scripts/03_run_flye_conda.sh
```

```bash
#!/bin/bash
set -ueo pipefail

module load miniforge3/
source "$(conda info --base)/etc/profile.d/conda.sh"
conda activate flye-env

mkdir -p ./assemblies/assembly_conda

flye --nano-hq ./data/SRR33939694.fastq.gz --genome-size 50k --out-dir ./assemblies/assembly_conda --threads 6 --meta

mv ./assemblies/assembly_conda/assembly.fasta ./assemblies/assembly_conda/conda_assembly.fasta
mv ./assemblies/assembly_conda/flye.log ./assemblies/assembly_conda/conda_flye.log

cd ./assemblies/assembly_conda
rm -f assembly_graph.gfa assembly_graph.gv assembly_info.txt params.json
rm -rf 00-assembly 10-consensus 20-repeat 30-contigger 40-polishing
cd -

conda deactivate
```

```bash
bash scripts/03_run_flye_conda.sh
```

### Task 6B — Run Flye w/ HPC module

```bash
nano ./scripts/03_run_flye_module.sh
```

```bash
#!/bin/bash
set -ueo pipefail

module load Flye/gcc-11.4.1/2.9.6

mkdir -p ./assemblies/assembly_module

flye --nano-hq ./data/SRR33939694.fastq.gz --genome-size 50k --out-dir ./assemblies/assembly_module --threads 6 --meta

mv ./assemblies/assembly_module/assembly.fasta ./assemblies/assembly_module/module_assembly.fasta
mv ./assemblies/assembly_module/flye.log ./assemblies/assembly_module/module_flye.log

cd ./assemblies/assembly_module
rm -f assembly_graph.gfa assembly_graph.gv assembly_info.txt params.json
rm -rf 00-assembly 10-consensus 20-repeat 30-contigger 40-polishing
cd -
```

```bash
bash scripts/03_run_flye_module.sh
```

### Task 6C — Flye local

```bash
nano ./scripts/03_run_flye_local.sh
```
p
```bash
#!/bin/bash
set -ueo pipefail

export PATH=$PATH:~/programs/Flye/bin

mkdir -p ./assemblies/assembly_local

flye --nano-hq ./data/SRR33939694.fastq.gz --genome-size 50k --out-dir ./assemblies/assembly_local --threads 6 --meta

mv ./assemblies/assembly_local/assembly.fasta ./assemblies/assembly_local/local_assembly.fasta
mv ./assemblies/assembly_local/flye.log ./assemblies/assembly_local/local_flye.log

cd ./assemblies/assembly_local
rm -f assembly_graph.gfa assembly_graph.gv assembly_info.txt params.json
rm -rf 00-assembly 10-consensus 20-repeat 30-contigger 40-polishing
cd -
```

```bash
bash scripts/03_run_flye_local.sh
```

### Task 7 — Compare log files

- everything was identical

```bash
tail -n 10 ./assemblies/assembly_conda/conda_flye.log
tail -n 10 ./assemblies/assembly_module/module_flye.log
tail -n 10 ./assemblies/assembly_local/local_flye.log
```

### Task 8 — Pipeline

- Runs all scripts in order and prints the last 10 lines of logs

```bash
nano pipeline.sh
```

```bash
#!/bin/bash
set -ueo pipefail

SCRIPTS_DIR=./scripts

bash ${SCRIPTS_DIR}/01_download_data.sh
bash ${SCRIPTS_DIR}/02_flye_2.9.6_manual_build.sh
bash ${SCRIPTS_DIR}/02_flye_2.9.6_conda_install.sh
bash ${SCRIPTS_DIR}/03_run_flye_conda.sh
bash ${SCRIPTS_DIR}/03_run_flye_local.sh
bash ${SCRIPTS_DIR}/03_run_flye_module.sh

echo "conda"
tail -n 10 ./assemblies/assembly_conda/conda_flye.log
echo "module"
tail -n 10 ./assemblies/assembly_module/module_flye.log
echo "local"
tail -n 10 ./assemblies/assembly_local/local_flye.log
```

```bash
bash pipeline.sh
```

### Task 9 — Clean slate re-run

- cleared all output directories and env and reran pipeline

```bash
rm -rf ./data/*
rm -rf ./assemblies/assembly_conda/*
rm -rf ./assemblies/assembly_local/*
rm -rf ./assemblies/assembly_module/*
rm flye-env.yml
bash pipeline.sh
```

### Task 10 — Reflection

- The issues I  came accross on this assignment were fairly easy to debug, mainly writing scripts that had to have changes for re-runs. git clone and mamba create both created duplicates so i had to add remove statements before for the pipeline. It was annoying going back and fixing them, but it made me more concious of how I write scripts, i've started using -rf to avoid errors on the off chance files may/may not exist when running a pipeline. 
- Vs the lesson, we used mamba here. I learned that mamba resolves dependencies faster than conda, but fundementally does the same things (installing packages). I googled some differences and it looks like mamba uses c++ vs conda's python. 
- I also learned that conda is still required when using mamba, because (googled) mamba cant do shell level commands like activate and deactivating the environment.  
- All 3 of the approaches in this assignment returned the correct results. While I liked the simplicity of the hpc module, I think the conda approach that generated the YML would be easier to replicate on other devices.


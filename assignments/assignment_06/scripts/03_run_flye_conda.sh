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

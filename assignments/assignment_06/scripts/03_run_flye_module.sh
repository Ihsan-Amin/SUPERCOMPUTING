#!/bin/bash
set -ueo pipefail

module load Flye/gcc-11.4.1/2.9.6

mkdir -p ./assemblies/assembly_module

flye --nano-hq ./data/SRR33939694.fastq.gz --genome-size 50k --out-dir ./assemblies/assembly_module  --threads 6 --meta

mv ./assemblies/assembly_module/assembly.fasta ./assemblies/assembly_module/module_assembly.fasta
mv ./assemblies/assembly_module/flye.log ./assemblies/assembly_module/module_flye.log

cd ./assemblies/assembly_module
rm -f assembly_graph.gfa assembly_graph.gv assembly_info.txt params.json
rm -rf 00-assembly 10-consensus 20-repeat 30-contigger 40-polishing
cd -


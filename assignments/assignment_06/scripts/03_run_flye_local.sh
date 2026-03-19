#!/bin/bash
set -ueo pipefail

export PATH=$PATH:~/programs/Flye/bin

flye --nano-hq ./data/SRR33939694.fastq.gz --genome-size 50k --out-dir ./assemblies/assembly_local --threads 6 --meta

mv ./assemblies/assembly_local/assembly.fasta ./assemblies/assembly_local/local_assembly.fasta
mv ./assemblies/assembly_local/flye.log ./assemblies/assembly_local/local_flye.log

cd ./assemblies/assembly_local
rm -f assembly_graph.gfa assembly_graph.gv assembly_info.txt params.json
rm -rf 00-assembly 10-consensus 20-repeat 30-contigger 40-polishing
cd -

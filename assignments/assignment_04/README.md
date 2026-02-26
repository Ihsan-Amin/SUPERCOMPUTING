Ihsan Amin 2.25.26 Assignment #04

bora
password
ls

# Task 1 - made programs folder in home directory on bora, notably this is outside SUPERCOMPUTING in /sciclone/home/iamin01
mkdir programs

# Task 2 - downloaded and unpacked gh in programs folder
cd programs
wget https://github.com/cli/cli/releases/download/v2.74.2/gh_2.74.2_linux_amd64.tar.gz
tar -xzvf gh_2.74.2_linux_amd64.tar.gz
rm gh_2.74.2_linux_amd64.tar.gz

# Task 3 - put task 2 into a bash script, for ref: chmod makes file executable, export adds to $PATH, exec resets shell so .bashrc is updated and things added to path are registered, which tells me the full path of programs
cd programs
nano install_gh.sh

# Bash Script:
##!/bin/bash
#set -ueo pipefail
#INSTALL_DIR="${HOME}/programs"
#cd ${INSTALL_DIR}
#wget https://github.com/cli/cli/releases/download/v2.74.2/gh_2.74.2_linux_amd64.tar.gz
#tar -xzvf gh_2.74.2_linux_amd64.tar.gz
#rm gh_2.74.2_linux_amd64.tar.gz
#chmod +x ${INSTALL_DIR}/gh_2.74.2_linux_amd64/bin/gh
#echo "installed"

chmod +x ~/programs/install_gh.sh

# Task 4 - added gh binary to path 
export PATH=$PATH:$HOME/programs/gh_2.74.2_linux_amd64/bin
echo 'export PATH=$PATH:$HOME/programs/gh_2.74.2_linux_amd64/bin' >> ~/.bashrc
exec bash
which gh

# Task 5 - Github
gh auth login
followed steps + passkey 

# Task 6 - seqtk
ls 
cd programs
nano install_seqtk.sh

# Bash script
##!/bin/bash
#set -ueo pipefail
#INSTALL_DIR="${HOME}/programs"
#cd ${INSTALL_DIR}
#git clone https://github.com/lh3/seqtk.git
#cd seqtk
#make
#ls -l ${INSTALL_DIR}/seqtk/seqtk
#chmod +x ${INSTALL_DIR}/seqtk/seqtk
#echo "export PATH=$PATH:${INSTALL_DIR}/seqtk" >> ~/.bashrc
#echo "Run 'exec bash'"

chmod +x ~/programs/install_seqtk.sh
bash ~/programs/install_seqtk.sh
exec bash
which seqtk

# Task 7 - Move from /sciclone/home/iamin01/programs to assignment_03

cd
ls
cd SUPERCOMPUTING
git status
git pull
cd assignments
cd assignment_03
cd data
seqtk
seqtk comp GCF_000001735.4_TAIR10.1_genomic.fna | head
seqtk comp GCF_000001735.4_TAIR10.1_genomic.fna | cut -f 1,2

# Task 8 - move to assignment_04, make new dirs, add fasta summarizing script
cd ~/SUPERCOMPUTING/assignments/assignment_04
mkdir -p data scripts
cd scripts
nano summarize_fasta.sh

# Bash Script
##!/bin/bash
#set -ueo pipefail
#FASTA=$1
#SEQS=$(grep -c "^>" ${FASTA})
#NUC=$(grep -v "^>" ${FASTA} | tr -d '\n' | wc -c)
#TABLE=$(seqtk comp ${FASTA} | cut -f 1,2)
#echo "sequences: ${SEQS}"
#echo "nucleotides: ${NUC}"
#echo "Sequence Name and Length:"
#echo "${TABLE}"

chmod +x summarize_fasta.sh
bash summarize_fasta.sh ~/SUPERCOMPUTING/assignments/assignment_03/data/GCF_000001735.4_TAIR10.1_genomic.fna

# Task 9 - Went to NIH NCBI website, searched up yeast flu ecoli genomes, copied links to download with wget, ran for loop using summarize_fasta.sh to analyze new files
cd ~/SUPERCOMPUTING/assignments/assignment_04/data
wget "https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/001/343/785/GCF_001343785.1_ViralMultiSegProj274766/GCF_001343785.1_ViralMultiSegProj274766_genomic.fna.gz"
wget "https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/005/845/GCF_000005845.2_ASM584v2/GCF_000005845.2_ASM584v2_genomic.fna.gz"
wget "https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/146/045/GCF_000146045.2_R64/GCF_000146045.2_R64_genomic.fna.gz"
gunzip GCF_001343785.1_ViralMultiSegProj274766_genomic.fna.gz
gunzip GCF_000005845.2_ASM584v2_genomic.fna.gz
gunzip GCF_000146045.2_R64_genomic.fna.gz
cd ..
ls
for file in data/*.fna; do bash scripts/summarize_fasta.sh $file; done

# Task 10 - Reflection: 
Most of the new content was relatively easy after referencing the lessons, though I need to practice a lot more to remember the syntax for the bash scripts (ie. Stuff like setting INSTALL_DIR="${HOME}/programs" ). My main challenge was remembering how to sum the nucleotide counts from the fasta files. For counting sequences and total nucleotides I couldn’t recall my grep/piped commands perfectly from memory so I copied over my work from assignment 3. e.g. grep -v "^>" | tr -d '\n' | wc -c which takes headers, removes new lines, and counts remaining chars for total nucleotides. I did learn how to use seqtk (which is a “tool for processing sequences in the FASTA or FASTQ format.”) for the sequence name and length table. I used seqtk comp outputs a table where column 1 is the sequence name and column 2 is the length. I used cut -f 1,2 to get just the relevant columns. Something that was easy but interesting for reproducibility was learning how to write the installation scripts, it was relatively useless for this assignment but I can definitely see this being useful (like python requirements.txt’s you can call to download all required packages for a project).

$PATH is an “environmental variable” that stores a list of directories the shell searches through whenever a command is sent. When I type seqtk, the shell looks through directories in $PATH to find an executable with that name. After installing gh and seqtk into my root programs folder, I had to add their locations to $PATH with export so the shell could get them. Adding the export line to ~/.bashrc makes it persistent, because ~/.bashrc runs each time a new shell starts (which I tested with which gh and exec bash). 

I had to use .gitignore again in this lesson because of the large genome files being too big for GitHub. The README has the exact wget URLs I used so this approach should still be reproducible. 


# task 11 - git push, ignore data files
cd ~/SUPERCOMPUTING
echo "assignments/assignment_04/data/GCF_000005845.2_ASM584v2_genomic.fna" >> ~/SUPERCOMPUTING/.gitignore
echo "assignments/assignment_04/data/GCF_000146045.2_R64_genomic.fna" >> ~/SUPERCOMPUTING/.gitignore
echo "assignments/assignment_04/data/GCF_001343785.1_ViralMultiSegProj274766_genomic.fna" >> ~/SUPERCOMPUTING/.gitignore
git add .gitignore
git commit -m "Added gitignore for data files"
git push
git add assignments/assignment_04/
git commit -m "e.g"
git push



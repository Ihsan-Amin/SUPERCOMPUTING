Ihsan Amin 2.11.25 Assignment_02

# Task 1: visit assignment 2 directory
bora 
#Password 
cd ~/SUPERCOMPUTING/assignments/assignment_02/data/ 
# Task 2 NCBI FTP command downloads 
ftp ftp.ncbi.nlm.nih.gov 
#anonymous 
#ihsan.s.amin@gmail.com 
passive 
binary 
cd genomes/all/GCF/000/005/845/GCF_000005845.2_ASM584v2/ 
get GCF_000005845.2_ASM584v2_genomic.fna.gz 
get GCF_000005845.2_ASM584v2_genomic.gff.gz 
bye 
# Task 3 FileZilla transfer + chmod readability check 
#Connect using SFTP: 
#- Host: bora.sciclone.wm.edu 
#- Username: your W&M username 
#- Password: your W&M password 
#- Port: 22 
#- Protocol: SFTP 
#Navigate to: ~/SUPERCOMPUTING/assignments/assignment_2/data/ and upload both .gz files you just #downloaded.
bora 
#Password 
cd ~/SUPERCOMPUTING/assignments/assignment_02/data/ 
chmod 644 GCF_000005845.2_ASM584v2_genomic.fna.gz GCF_000005845.2_ASM584v2_genomic.gff.gz 
ls -l GCF_000005845.2_ASM584v2_genomic.fna.gz GCF_000005845.2_ASM584v2_genomic.gff.gz 
Exit 
# Task 4 - verifying file integrity with md5sum 
cd ncbi_downloads 
md5sum GCF_000005845.2_ASM584v2_genomic.gff.gz 
# 2238238dd39e11329547d26ab138be41  GCF_000005845.2_ASM584v2_genomic.gff.gz
md5sum GCF_000005845.2_ASM584v2_genomic.fna.gz 
# c13d459b5caa702ff7e1f26fe44b8ad7  GCF_000005845.2_ASM584v2_genomic.fna.gz
cd ..
bora
#Password
cd ~/SUPERCOMPUTING/assignments/assignment_02/data/
md5sum GCF_000005845.2_ASM584v2_genomic.fna.gz
# c13d459b5caa702ff7e1f26fe44b8ad7  GCF_000005845.2_ASM584v2_genomic.fna.gz 
$md5sum GCF_000005845.2_ASM584v2_genomic.gff.gz
# 2238238dd39e11329547d26ab138be41  GCF_000005845.2_ASM584v2_genomic.gff.gz

# both checksums match on local and bora copies

# Task 5: Create Useful Bash Aliases

Nano ~/.bashrc
# add: 
# alias u='cd ..;clear;pwd;ls -alFh --group-directories-first' 
# goes back 1 directory clears screen, prints working directory, then runs ls, but with alfh so it shows hidden files, long listed files, file types, and human readable sizes also and it lists directories first.
# alias d='cd -;clear;pwd;ls -alFh --group-directories-first'
# goes up 1 directory clears screen, prints working directory, then runs ls, but with alfh so it shows hidden files, long listed files, file types, and human readable sizes also and it lists directories first.
# alias ll='ls -alFh --group-directories-first’
# runs ls, but with alfh so it shows hidden files, long listed files, file types, and human readable sizes also and it lists directories first.
source ~/.bashrc

# Task 6: Reflection
#  Overall I felt the use of aliases worked well to save time, especially when i was going in 
# between local and bora for some of the tasks. The hardest part was the FTP download from the NTBI database. I had 
# to google the right commands to avoid a port/LPRT failure. the chmod 644 command to edit file readability and 
# md5sum both worked as expected if i could change 1 thing it would be findin terminal based solutions to filezilla 
# transfers as documenting gui steps is more difficult

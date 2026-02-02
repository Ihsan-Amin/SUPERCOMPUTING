git clone https://github.com/Ihsan-Amin/SUPERCOMPUTING.git 
cd SUPERCOMPUTING 
git pull #pulling latest version before writing 
pwd #finds directory 
mkdir -p assignments/assignment_1 
cd assignments/assignment_1  
touch assignment_1_essay.md #touch makes files 
touch README.md 
git add README.md assignment_1_essay.md  
git commit -m Add assignment 1 essay file placeholder  
git push 
mkdir -p data/raw 
mkdir -p data/clean 
mkdir docs 
mkdir logs 
touch data/raw/example.txt 
touch data/clean/example.txt 
touch docs/example.txt 
touch logs/logfile.log 
git add . 
git commit -m "Add placeholders" 
git push 

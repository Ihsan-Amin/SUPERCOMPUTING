Ihsan Amin Assignment 3 2.18.26
bora
password
cd SUPERCOMPUTING
git pull
cd assignments
cd assignment_03
mkdir -p data
cd data
wget https://gzahn.github.io/data/GCF_000001735.4_TAIR10.1_genomic.fna.gz
gunzip GCF_000001735.4_TAIR10.1_genomic.fna.gz
DATA="GCF_000001735.4_TAIR10.1_genomic.fna"
grep -c ">" $DATA
grep -v "^>" $DATA|tr -d '\n' | wc -c
wc -l $DATA
grep "mitochondrion" $DATA | grep "^>" | wc -l
grep "chromosome" "$DATA" | grep "^>" | wc -l
grep -n "^>.*chromosome 1" "$DATA" | head -n 1
grep -n "^>.*chromosome 2" "$DATA" | head -n 1
grep -n "^>.*chromosome 3" "$DATA" | head -n 1
grep -n "^>.*chromosome 4" "$DATA" | head -n 1
head -n 2 "$DATA" | tail -n 1 | wc -c
head -n 4 "$DATA" | tail -n 1 | wc -c
head -n 6 "$DATA" | tail -n 1 | wc -c
head -n 10 "$DATA" | tail -n 1 | wc -c
paste <(grep "^>" "$DATA") <(grep -v "^>" "$DATA") | grep "AAAAAAAAAAAAAAA" | wc -l
grep "^>" $DATA | sort | head -n 1
paste <(grep "^>" "$DATA") <(grep -v "^>" "$DATA") > GCF_000001735.4_TAIR10.1_genomic.fna.tsv

REFLECTION:

Coming into this assignment I had somewhat limited experience using stuff like grep and connecting commands together with |. I would
say my main takeaway was that stringing commands together is pretty powerful and when that becomes muscle memory it can effectively
replace the need for some scripts or dedicated programs on the fly. I definitely tried to optimize my approach more, especially for
final submission, using pipes.  Using grep "^>" to select header lines and wc -l to count them or finding the number of nucleotides by
taking grep -v "^>" into tr -d '\n' and then into wc -c are good examples of this. The most frusterating part was finding the
nucleotide counts for the chromosomes. I used grep -n (i had to google a little on this to see how it worked) to identify header line
positions and then used head and tail to find the start and end of each section. Small details like ^> instead of just > affected
results. exclusion commands like tr -d '\n' weren't an issue here but i can see how messing them up or applying them improperly might
cause some headache in the future. I can definitely see why a lot of these commands and the use of servers are critical for applied
data work. To start, i initially forgot to go into bora when I downloaded the files, which took significantly longer over wifi than on
the server. Starting my work also meant i had to git pull when i logged into the server, which emphasized how useful it was. For the
actual assignment, being able to stay in the terminal to filter, count, transform, and repackage data into different file formats
instead of using a gui made it very straightforward to catalog my steps(+ transmisibility and reproducibility). Additionally, it would
likely be much faster than a gui if i had more experience.

Note: could not push large files to github

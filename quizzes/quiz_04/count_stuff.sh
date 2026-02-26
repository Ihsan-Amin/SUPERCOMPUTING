
#!/bin/bash
set -ueo pipefail

DIR=$1

FILES=$(ls -p ${DIR} | grep -v "/" | wc -l)
DIRS=$(ls -p ${DIR} | grep "/" | wc -l)

echo "Files: ${FILES}"
echo "Directories: ${DIRS}"

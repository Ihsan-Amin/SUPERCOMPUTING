#!/bin/bash
set -ueo pipefail

cd ~/programs/
rm -rf Flye
git clone --branch 2.9.6 https://github.com/fenderglass/Flye
cd Flye
make

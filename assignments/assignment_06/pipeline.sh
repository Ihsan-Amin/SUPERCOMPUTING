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


#!/bin/bash

# To run this script do the folowing: docker_run_abyss_test.sh ABYSS_DOCKER_TAG

# ABYSS_DOCKER_TAG is optional.
# Possible values are found here https://hub.docker.com/r/pegi3s/abyss/tags. 
# For example, use '2.0.2-3' to run Abyss version 2.0.2.

set -euox pipefail

VER=${1-latest}
wget http://www.bcgsc.ca/platform/bioinfo/software/abyss/releases/1.3.4/test-data.tar.gz
tar -xvzf test-data.tar.gz 
mkdir -p results
docker run --rm -v$(pwd):/data pegi3s/abyss:"$VER" abyss-pe k=25 name=test in='/data/test-data/reads1.fastq /data/test-data/reads2.fastq' --directory=/data/results
echo
echo ------------------------------------------
echo Final contigs file is here...
ls -l results/test-contigs.fa

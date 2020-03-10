#!/bin/bash

# To run this script do the folowing: docker_run_cutadapt_test.sh DOCKER_TAG

# DOCKER_TAG is optional.
# Possible values are found here https://hub.docker.com/r/pegi3s/cutadapt/tags. 
# For example, use '1.16' to run version 1.16

set -euox pipefail

VER=${1-latest}
if [[ ! -f test-data.tar.gz ]]; then
    wget http://www.bcgsc.ca/platform/bioinfo/software/abyss/releases/1.3.4/test-data.tar.gz
fi
tar -xvzf test-data.tar.gz 
docker run --rm -v$(pwd)/test-data:/data pegi3s/cutadapt:"$VER" \
       -m 25 -q 15 \
       -a AGATCGGAAGAGCACACGTCTGAACTCCAGTCA \
       -A AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT \
       -o /data/reads1_cutadapt.fastq -p /data/reads2_cutadapt.fastq \
       /data/reads1.fastq /data/reads2.fastq

       

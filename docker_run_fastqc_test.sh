#!/bin/bash

# To run this script do the folowing: docker_run_fastqc_test.sh DOCKER_TAG

# DOCKER_TAG is optional.
# Possible values are found here https://hub.docker.com/r/pegi3s/fastqc/tags. 
# For example, use '0.11.7' to run version 0.11.7

set -euox pipefail

VER=${1-latest}
if [[ ! -f test-data.tar.gz ]]; then
    wget http://www.bcgsc.ca/platform/bioinfo/software/abyss/releases/1.3.4/test-data.tar.gz
fi
tar -xvzf test-data.tar.gz 
docker run --rm -v$(pwd)/test-data:/data pegi3s/fastqc:"$VER" /data/reads1.fastq /data/reads2.fastq
ls -l test-data/*fastqc*

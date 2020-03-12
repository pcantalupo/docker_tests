#!/bin/bash

set -euox pipefail

#VER=${1-latest}
MINLEN=${1-25}
MINQUAL=${2-15}
OUTDIR=${3-abyss_assembly}  # OUTDIR=abyss_assembly
#NUMREADS=${4-20000}   # matches number of reads in test-data

READSDIR=test-data
# get paired fastq reads from Abyss website
if [[ ! -f test-data.tar.gz ]]; then
    wget http://www.bcgsc.ca/platform/bioinfo/software/abyss/releases/1.3.4/test-data.tar.gz
fi
tar -xvzf test-data.tar.gz

# Run Cutadapt on raw paired reads
echo "Running cutadapt"
cutadapt -m "$MINLEN" -q "$MINQUAL" \
         -a AGATCGGAAGAGCACACGTCTGAACTCCAGTCA \
         -A AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT \
         -o "$READSDIR"/reads1_cutadapt.fastq -p "$READSDIR"/reads2_cutadapt.fastq \
         "$READSDIR"/reads1.fastq "$READSDIR"/reads2.fastq

# Run Fastqc on Cutadapt paired reads
echo "Running fastqc"
fastqc "$READSDIR"/reads1_cutadapt.fastq "$READSDIR"/reads2_cutadapt.fastq  

# Run Abyss assembly on Cutadapt paired reads
echo "Running abyss-pe"
mkdir -p $OUTDIR
abyss-pe k=25 name=test in="/"$READSDIR"/reads1_cutadapt.fastq "/$READSDIR"/reads2_cutadapt.fastq" \
         --directory=$OUTDIR

echo "Output files in the Docker Container"
ls -lR /$OUTDIR /test-data

echo "Copying output files to Host"
cp -r /$OUTDIR /test-data /results    # use -v$(pwd)/results:/results on docker run command line to connect the /results directory to the Host OS



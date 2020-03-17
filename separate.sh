#!/bin/bash

set -euox pipefail

MINLEN=${1-25}
MINQUAL=${2-15}
OUTDIR=${3-abyss_assembly}  # OUTDIR=abyss_assembly

READSDIR=test-data
# get paired fastq reads from Abyss website
if [[ ! -f test-data.tar.gz ]]; then
    wget http://www.bcgsc.ca/platform/bioinfo/software/abyss/releases/1.3.4/test-data.tar.gz
fi
tar -xvzf test-data.tar.gz


# cutadapt step
CMD=cutadapt
if hash "$CMD" 2>/dev/null; then
    echo "$CMD was found in PATH...running installed version of $CMD"
    $CMD
else
    echo "$CMD was NOT found in PATH...running docker version of $CMD"
    docker run --rm -v$(pwd)/"$READSDIR":/"$READSDIR" onion2 \
         $CMD -m "$MINLEN" -q "$MINQUAL" \
         -a AGATCGGAAGAGCACACGTCTGAACTCCAGTCA \
         -A AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT \
         -o /"$READSDIR"/reads1_cutadapt.fastq -p /"$READSDIR"/reads2_cutadapt.fastq \
         /"$READSDIR"/reads1.fastq /"$READSDIR"/reads2.fastq
fi

# fastqc step
CMD=fastqc
if hash "$CMD" 2>/dev/null; then
    echo "$CMD was found in PATH...running installed version of $CMD"
    $CMD
else
    echo "$CMD was NOT found in PATH...running docker version of $CMD"    
    docker run --rm -v$(pwd)/"$READSDIR":/"$READSDIR" onion2 \
         $CMD /"$READSDIR"/reads1_cutadapt.fastq /"$READSDIR"/reads2_cutadapt.fastq
fi


# abyss-pe step
CMD="abyss-pe"
if hash "$CMD" 2>/dev/null; then
    echo "$CMD was found in PATH...running installed version of $CMD"
    $CMD
else
    echo "$CMD was NOT found in PATH...running docker version of $CMD"
    mkdir -p $OUTDIR
    docker run --rm -v$(pwd):/hostdir onion2 \
         $CMD k=25 name=test in="/hostdir/$READSDIR/reads1_cutadapt.fastq /hostdir/$READSDIR/reads2_cutadapt.fastq" \
         --directory=/hostdir/"$OUTDIR"
fi


mkdir -p results
mv $OUTDIR results
mkdir -p results/$READSDIR
mv $READSDIR/*cutadapt* results/$READSDIR


#!/usr/bin/env bash

#SBATCH --time=02:00:00
#SBATCH --mem=10G
#SBATCH --cpus-per-task=4
#SBATCH --job-name=BUSCO
#SBATCH --mail-user=james.groffmizoguchi@students.unibe.ch
#SBATCH --mail-type=begin,end
#SBATCH --output=/data/users/jgroff/assembly_annotation_course/annotation_evaluation/BUSCO/BUSCO_%j.o
#SBATCH --error=/data/users/jgroff/assembly_annotation_course/annotation_evaluation/BUSCO/BUSCO_%j.e
#SBATCH --partition=pall

MAKERDIR=/data/users/jgroff/assembly_annotation_course/MAKER/run_mpi.maker.output
WORKDIR=/data/users/jgroff/assembly_annotation_course/annotation_evaluation/BUSCO
cd $WORKDIR

# Module to run BUSCO assessment
module add UHTS/Analysis/busco/4.1.4;

#Make a copy of the augustus config directory to have written permission
cp -r /software/SequenceAnalysis/GenePrediction/augustus/3.3.3.1/config augustus_config
export AUGUSTUS_CONFIG_PATH=./augustus_config

# Run BUSCO for annotation results
busco -i ${MAKERDIR}/flye_polished.all.maker.proteins.fasta.renamed.fasta -o flye_polished_annotation -l brassicales_odb10 -m proteins -c 4

#!/usr/bin/env bash

#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --time=1-00:00:00
#SBATCH --job-name=flye
#SBATCH --mail-user=james.groffmizoguchi@students.unibe.ch
#SBATCH --mail-type=begin,end
#SBATCH --output=/data/users/jgroff/assembly_annotation_course/assemblies/flye/output_flye_%j.o
#SBATCH --error=/data/users/jgroff/assembly_annotation_course/assemblies/flye/error_flye_%j.e
#SBATCH --partition=pall

# Add modules for the flye assembly
module add UHTS/Assembler/flye/2.8.3;

#Variables for directory pathways
READS_DIR=/data/users/jgroff/assembly_annotation_course/participant_1/pacbio
OUTPUT_DIR=/data/users/jgroff/assembly_annotation_course/assemblies/flye

# Go to the output pathway
cd $OUTPUT_DIR

# Run flye
flye --pacbio-raw $READS_DIR/*.fastq.gz -o $OUTPUT_DIR -t 16 -g 127m

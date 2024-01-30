#!/usr/bin/env bash

#SBATCH --cpus-per-task=12
#SBATCH --mem=48G
#SBATCH --time=1-00:00:00
#SBATCH --job-name=trinity
#SBATCH --mail-user=james.groffmizoguchi@students.unibe.ch
#SBATCH --mail-type=begin,end
#SBATCH --output=/data/users/jgroff/assembly_annotation_course/assemblies/Trinity/output_trinity_%j.o
#SBATCH --error=/data/users/jgroff/assembly_annotation_course/assemblies/Trinity/error_trinity_%j.e
#SBATCH --partition=pall

#Add modules for the Trinity assembly
module add UHTS/Assembler/trinityrnaseq/2.5.1;

#Variables for directory pathways
READS_DIR=/data/users/jgroff/assembly_annotation_course/participant_1/RNAseq
OUTPUT_DIR=/data/users/jgroff/assembly_annotation_course/assemblies/Trinity

# Go to the output pathway
cd $OUTPUT_DIR

# Run Trinity
Trinity --seqType fq --left $READS_DIR/*_1.fastq.gz --right $READS_DIR/*_2.fastq.gz \
 --CPU 12 --max_memory 48G 

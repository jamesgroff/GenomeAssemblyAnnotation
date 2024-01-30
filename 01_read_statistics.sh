#!/usr/bin/env bash

#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=4000M
#SBATCH --time=06:00:00
#SBATCH --job-name=fastqc
#SBATCH --mail-user=james.groffmizoguchi@students.unibe.ch
#SBATCH --mail-type=begin,end
#SBATCH --output=/data/users/jgroff/assembly_annotation_course/read_QC/output_fastqc_%j.o
#SBATCH --error=/data/users/jgroff/assembly_annotation_course/read_QC/error_fastqc_%j.e
#SBATCH --partition=pall

#First, load or add the required modules
module add UHTS/Quality_control/fastqc/0.11.9

# Variables for directory pathways
READS_DIR=/data/users/jgroff/assembly_annotation_course/participant_1
OUTPUT_DIR=/data/users/jgroff/assembly_annotation_course/read_QC/fastqc

# Go to the output pathway and create directories
cd $OUTPUT_DIR
mkdir Illumina pacbio RNAseq

#Run fastqc to assess quality data from the reads directory to the output directory
fastqc -o $OUTPUT_DIR/Illumina/ $READS_DIR/Illumina/*.fastq.gz
fastqc -o $OUTPUT_DIR/pacbio/ $READS_DIR/pacbio/*.fastq.gz
fastqc -o $OUTPUT_DIR/RNAseq/ $READS_DIR/RNAseq/*.fastq.gz



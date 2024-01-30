#!/usr/bin/env bash

#SBATCH --cpus-per-task=4
#SBATCH --mem=64G
#SBATCH --time=10:00:00
#SBATCH --job-name=bowtie
#SBATCH --mail-user=james.groffmizoguchi@students.unibe.ch
#SBATCH --mail-type=begin,end
#SBATCH --output=/data/users/jgroff/assembly_annotation_course/polish/output_bowtie_%j.o
#SBATCH --error=/data/users/jgroff/assembly_annotation_course/polish/error_bowtie_%j.e
#SBATCH --partition=pall

# Add modules for aligning with bowtie2 and for converting with samtools
module add UHTS/Aligner/bowtie2/2.3.4.1;
module add UHTS/Analysis/samtools/1.10;

# Variables for directory pathways
READS_DIR=/data/users/jgroff/assembly_annotation_course/participant_1/Illumina
FLYE_DIR=/data/users/jgroff/assembly_annotation_course/assemblies/flye
CANU_DIR=/data/users/jgroff/assembly_annotation_course/assemblies/canu/arabidopsis-pacbio
OUTPUT_DIR=/data/users/jgroff/assembly_annotation_course/polish

# Go to the output pathway and create directories
cd $OUTPUT_DIR
mkdir flye canu
cd $OUTPUT_DIR/flye

# Index the assemblies for flye with bowtie2
bowtie2-build $FLYE_DIR/assembly.fasta flye_assembly.bt2

# Run bowtie2
bowtie2 --sensitive-local --threads 4 -x flye_assembly.bt2 -1 ${READS_DIR}/*_1.fastq.gz -2 ${READS_DIR}/*_2.fastq.gz -S flye_aligned.sam

# Convert the SAM file into a BAM file
samtools view --threads 4 -bo flye_aligned.bam flye_aligned.sam

# Do the same but with the canu assembly
cd $OUTPUT_DIR/canu

bowtie2-build $CANU_DIR/arabidopsis.contigs.fasta canu_assembly.bt2

bowtie2 --sensitive-local --threads 4 -x canu_assembly.bt2 -1 ${READS_DIR}/*_1.fastq.gz -2 ${READS_DIR}/*_2.fastq.gz -S canu_aligned.sam

samtools view --threads 4 -bo canu_aligned.bam canu_aligned.sam

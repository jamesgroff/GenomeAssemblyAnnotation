#!/usr/bin/env bash

#SBATCH --cpus-per-task=4
#SBATCH --mem-per-cpu=10G
#SBATCH --time=24:00:00
#SBATCH --job-name=kmer_count
#SBATCH --mail-user=james.groffmizoguchi@students.unibe.ch
#SBATCH --mail-type=begin,end
#SBATCH --output=/data/users/jgroff/assembly_annotation_course/read_QC/output_kmer_count_%j.o
#SBATCH --error=/data/users/jgroff/assembly_annotation_course/read_QC/error_kmer_count_%j.e
#SBATCH --partition=pall

# Add modules for the kmer counting being jellyfish
module add UHTS/Analysis/jellyfish/2.3.0

#Variables for directory pathways
READS_DIR=/data/users/jgroff/assembly_annotation_course/participant_1
OUTPUT_DIR=/data/users/jgroff/assembly_annotation_course/read_QC/kmer_counting

# Go to the output pathway and create directories
cd $OUTPUT_DIR
mkdir Illumina pacbio RNAseq

# Count k-mers on each fastq database
jellyfish count \
-C -m 21 -s 5G -t 4 -o $OUTPUT_DIR/Illumina/Illumina_reads.jf \
<(zcat $READS_DIR/Illumina/*_1.fastq.gz) \
<(zcat $READS_DIR/Illumina/*_2.fastq.gz)

jellyfish count \
-C -m 21 -s 5G -t 4 -o $OUTPUT_DIR/pacbio/pacbio_reads.jf \
<(zcat $READS_DIR/pacbio/*1.fastq.gz) \
<(zcat $READS_DIR/pacbio/*2.fastq.gz)

jellyfish count \
-C -m 21 -s 5G -t 4 -o $OUTPUT_DIR/RNAseq/RNAseq_reads.jf \
<(zcat $READS_DIR/RNAseq/*_1.fastq.gz) \
<(zcat $READS_DIR/RNAseq/*_2.fastq.gz)


# Export the kmer count histogram for each file
jellyfish histo -t 4 $OUTPUT_DIR/Illumina/Illumina_reads.jf \
> $OUTPUT_DIR/Illumina/Illumina_reads.histo
jellyfish histo -t 4 $OUTPUT_DIR/pacbio/pacbio_reads.jf \
> $OUTPUT_DIR/pacbio/pacbio_reads.histo
jellyfish histo -t 4 $OUTPUT_DIR/RNAseq/RNAseq_reads.jf \
> $OUTPUT_DIR/RNAseq/RNAseq_reads.histo

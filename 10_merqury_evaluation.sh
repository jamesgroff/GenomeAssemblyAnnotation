#!/usr/bin/env bash

#SBATCH --cpus-per-task=4
#SBATCH --mem=64G
#SBATCH --time=1-00:00:00
#SBATCH --job-name=merqury
#SBATCH --mail-user=james.groffmizoguchi@students.unibe.ch
#SBATCH --mail-type=begin,end
#SBATCH --output=/data/users/jgroff/assembly_annotation_course/evaluation/output_merqury_%j.o
#SBATCH --error=/data/users/jgroff/assembly_annotation_course/evaluation/error_merqury_%j.e
#SBATCH --partition=pall

# Add module for the meryl count
module add UHTS/Assembler/canu/2.1.1;

#Variables for directory pathways
READS_DIR=/data/users/jgroff/assembly_annotation_course/participant_1/Illumina
FLYE_DIR=/data/users/jgroff/assembly_annotation_course/assemblies/flye
CANU_DIR=/data/users/jgroff/assembly_annotation_course/assemblies/canu/arabidopsis-pacbio
OUTPUT_DIR=/data/users/jgroff/assembly_annotation_course/evaluation/merqury

cd $OUTPUT_DIR
mkdir meryl

genome=/data/users/jgroff/assembly_annotation_course/evaluation/merqury/meryl

# Prepare kmer dbs with meryl
meryl k=19 count compress ${READS_DIR}/*_1.fastq.gz output ${genome}/illumina_1.meryl
meryl k=19 count compress ${READS_DIR}/*_2.fastq.gz output ${genome}/illumina_2.meryl

meryl union-sum output ${genome}/illumina_all.meryl ${genome}/illumina_*.meryl

# Run merqury on both flye and canu assemblies

mkdir $OUTPUT_DIR/flye
cd $OUTPUT_DIR/flye

apptainer exec \
 --bind ${OUTPUT_DIR} \
 /software/singularity/containers/Merqury-1.3-1.ubuntu20.sif \
 merqury.sh ${genome}/illumina_all.meryl ${FLYE_DIR}/assembly.fasta flye_test

mkdir $OUTPUT_DIR/canu
cd $OUTPUT_DIR/canu

apptainer exec \
 --bind ${OUTPUT_DIR} \
 /software/singularity/containers/Merqury-1.3-1.ubuntu20.sif \
 merqury.sh ${genome}/illumina_all.meryl ${CANU_DIR}/arabidopsis.contigs.fasta canu_test

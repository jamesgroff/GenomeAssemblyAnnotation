#!/usr/bin/env bash

#SBATCH --cpus-per-task=4
#SBATCH --mem=64G
#SBATCH --time=02:00:00
#SBATCH --job-name=compare
#SBATCH --mail-user=james.groffmizoguchi@students.unibe.ch
#SBATCH --mail-type=begin,end
#SBATCH --output=/data/users/jgroff/assembly_annotation_course/compare/output_compare_%j.o
#SBATCH --error=/data/users/jgroff/assembly_annotation_course/compare/error_compare_%j.e
#SBATCH --partition=pall

# Add mummer module for the nucmer and mummerplot programs for comparing genomes
module add UHTS/Analysis/mummer/4.0.0beta1

# Directory pathways as variables
FLYE_DIR=/data/users/jgroff/assembly_annotation_course/polish/flye
CANU_DIR=/data/users/jgroff/assembly_annotation_course/polish/canu
REFERENCE_DIR=/data/courses/assembly-annotation-course/references
OUTPUT_DIR=/data/users/jgroff/assembly_annotation_course/compare

cd $OUTPUT_DIR

# Run nucmer on flye and canu polished fasta files with reference, then between each other

nucmer --prefix flye_reference --breaklen 1000 --mincluster 1000 \
 ${REFERENCE_DIR}/Arabidopsis_thaliana.TAIR10.dna.toplevel.fa \
 ${FLYE_DIR}/flye_polished.fasta

nucmer --prefix canu_reference --breaklen 1000 --mincluster 1000 \
 ${REFERENCE_DIR}/Arabidopsis_thaliana.TAIR10.dna.toplevel.fa \
 ${CANU_DIR}/canu_polished.fasta

nucmer --prefix flye_canu --breaklen 1000 --mincluster 1000 \
 ${FLYE_DIR}/flye_polished.fasta \
 ${CANU_DIR}/canu_polished.fasta

# GNUplot needs to be available to the working path
export PATH=/software/bin:$PATH

# Run mummer on the produced delta files

mummerplot -R ${REFERENCE_DIR}/Arabidopsis_thaliana.TAIR10.dna.toplevel.fa \
 -Q ${FLYE_DIR}/flye_polished.fasta \
 --prefix flye_reference --filter -t png --large --layout flye_reference.delta

mummerplot -R ${REFERENCE_DIR}/Arabidopsis_thaliana.TAIR10.dna.toplevel.fa \
 -Q ${CANU_DIR}/canu_polished.fasta \
 --prefix canu_reference --filter -t png --large --layout canu_reference.delta

mummerplot -R ${FLYE_DIR}/flye_polished.fasta \
 -Q ${CANU_DIR}/canu_polished.fasta \
 --prefix flye_canu --filter -t png --large --layout flye_canu.delta

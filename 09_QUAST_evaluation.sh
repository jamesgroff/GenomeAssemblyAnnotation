#!/usr/bin/env bash

#SBATCH --cpus-per-task=4
#SBATCH --mem=64G
#SBATCH --time=1-00:00:00
#SBATCH --job-name=QUAST
#SBATCH --mail-user=james.groffmizoguchi@students.unibe.ch
#SBATCH --mail-type=begin,end
#SBATCH --output=/data/users/jgroff/assembly_annotation_course/evaluation/output_QUAST_%j.o
#SBATCH --error=/data/users/jgroff/assembly_annotation_course/evaluation/error_QUAST_%j.e
#SBATCH --partition=pall

#Variables for directory pathways
FLYE_DIR=/data/users/jgroff/assembly_annotation_course/assemblies/flye
CANU_DIR=/data/users/jgroff/assembly_annotation_course/assemblies/canu/arabidopsis-pacbio
FLYE_POLISH_DIR=/data/users/jgroff/assembly_annotation_course/polish/flye
CANU_POLISH_DIR=/data/users/jgroff/assembly_annotation_course/polish/canu
REFERENCE_DIR=/data/courses/assembly-annotation-course/references
OUTPUT_DIR=/data/users/jgroff/assembly_annotation_course/evaluation/QUAST

# Module to run QUAST assessment
module add UHTS/Quality_control/quast/4.6.0;

# Run quast for flye and canu (polished or not) with reference
cd $OUTPUT_DIR
quast.py ${FLYE_DIR}/assembly.fasta \
           -R ${REFERENCE_DIR}/Arabidopsis_thaliana.TAIR10.dna.toplevel.fa.gz \
           -G ${REFERENCE_DIR}/TAIR10_GFF3_genes.gff -l flye_assembly \
           -o flye_unpolished --threads 4 --eukaryote --no-sv

quast.py ${CANU_DIR}/arabidopsis.contigs.fasta \
           -R ${REFERENCE_DIR}/Arabidopsis_thaliana.TAIR10.dna.toplevel.fa.gz \
           -G ${REFERENCE_DIR}/TAIR10_GFF3_genes.gff -l canu_assembly \
           -o canu_unpolished --threads 4 --eukaryote --no-sv

quast.py ${FLYE_POLISH_DIR}/flye_polished.fasta \
           -R ${REFERENCE_DIR}/Arabidopsis_thaliana.TAIR10.dna.toplevel.fa.gz \
           -G ${REFERENCE_DIR}/TAIR10_GFF3_genes.gff -l flye_polished \
           -o flye_polished --threads 4 --eukaryote --no-sv

quast.py ${CANU_POLISH_DIR}/canu_polished.fasta \
           -R ${REFERENCE_DIR}/Arabidopsis_thaliana.TAIR10.dna.toplevel.fa.gz \
           -G ${REFERENCE_DIR}/TAIR10_GFF3_genes.gff -l canu_polished \
           -o canu_polished --threads 4 --eukaryote --no-sv


# Run quast for flye and canu (polished or not) without reference
quast.py ${FLYE_DIR}/assembly.fasta \
           -l flye_assembly_no_ref -o flye_unpolished_no_ref \
           --threads 4 --eukaryote --no-sv --est-ref-size 133725193

quast.py ${CANU_DIR}/arabidopsis.contigs.fasta \
           -l canu_assembly_no_ref -o canu_unpolished_no_ref \
           --threads 4 --eukaryote --no-sv --est-ref-size 133725193

quast.py ${FLYE_POLISH_DIR}/flye_polished.fasta \
           -l flye_polished_no_ref -o flye_polished_no_ref \
           --threads 4 --eukaryote --no-sv --est-ref-size 133725193

quast.py ${CANU_POLISH_DIR}/canu_polished.fasta \
           -l canu_polished_no_ref -o canu_polished_no_ref \
           --threads 4 --eukaryote --no-sv --est-ref-size 133725193


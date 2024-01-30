#!/usr/bin/env bash

#SBATCH --time=10:00:00
#SBATCH --mem=10G
#SBATCH --cpus-per-task=50
#SBATCH --job-name=edta
#SBATCH --mail-user=james.groffmizoguchi@students.unibe.ch
#SBATCH --mail-type=begin,end
#SBATCH --output=/data/users/jgroff/assembly_annotation_course/EDTA/edta_%j.o
#SBATCH --error=/data/users/jgroff/assembly_annotation_course/EDTA/edta_%j.e
#SBATCH --partition=pall

COURSEDIR=/data/courses/assembly-annotation-course
WORKDIR=/data/users/jgroff/assembly_annotation_course/EDTA
genome=/data/users/jgroff/assembly_annotation_course/polish/flye/flye_polished.fasta
cds_gene=/data/courses/assembly-annotation-course/CDS_annotation/TAIR10_cds_20110103_representative_gene_model_updated

cd $WORKDIR

singularity exec \
--bind $COURSEDIR \
--bind $WORKDIR \
$COURSEDIR/containers2/EDTA_v1.9.6.sif \
EDTA.pl \
--genome $genome --species others --step all --cds $cds_gene --anno 1 --threads 50

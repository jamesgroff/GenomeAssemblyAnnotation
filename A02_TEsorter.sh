#!/usr/bin/env bash

#SBATCH --time=04:00:00
#SBATCH --mem=10G
#SBATCH --cpus-per-task=4
#SBATCH --job-name=TEsorter
#SBATCH --mail-user=james.groffmizoguchi@students.unibe.ch
#SBATCH --mail-type=begin,end
#SBATCH --output=/data/users/jgroff/assembly_annotation_course/TEsorter/TEsorter_%j.o
#SBATCH --error=/data/users/jgroff/assembly_annotation_course/TEsorter/TEsorter_%j.e
#SBATCH --partition=pall

COURSEDIR=/data/courses/assembly-annotation-course
WORKDIR=/data/users/jgroff/assembly_annotation_course/TEsorter
genome=/data/users/jgroff/assembly_annotation_course/EDTA/polished_flye.fasta.mod.EDTA.TElib.fa
database=/data/courses/assembly-annotation-course/CDS_annotation/Brassicaceae_repbase_all_march2019.fasta

# Add module for seqkit
module add UHTS/Analysis/SeqKit/0.13.2;

cd $WORKDIR

# Search for Copia and Gypsy in the assembly genome and seperate them in two fasta files
cat $genome | seqkit grep -r -p ^*Copia > output_copia.fasta
cat $genome | seqkit grep -r -p ^*Gypsy > output_gypsy.fasta

# Run TEsorter one input at a time
singularity exec \
 --bind $COURSEDIR \
 --bind $WORKDIR \
$COURSEDIR/containers2/TEsorter_1.3.0.sif \
TEsorter output_copia.fasta -db rexdb-plant

singularity exec \
 --bind $COURSEDIR \
 --bind $WORKDIR \
$COURSEDIR/containers2/TEsorter_1.3.0.sif \
TEsorter output_gypsy.fasta -db rexdb-plant

# Search for Copia and Gypsy in the brassicaceae databate and seperate them in two fasta files
cat $database | seqkit grep -r -p ^*Copia > brassicaceae_copia.fasta
cat $database | seqkit grep -r -p ^*Gypsy > brassicaceae_gypsy.fasta

# Run TEsorter again with the fasta files from Brassicaceae TE database
singularity exec \
 --bind $COURSEDIR \
 --bind $WORKDIR \
$COURSEDIR/containers2/TEsorter_1.3.0.sif \
TEsorter brassicaceae_copia.fasta -db rexdb-plant

singularity exec \
 --bind $COURSEDIR \
 --bind $WORKDIR \
$COURSEDIR/containers2/TEsorter_1.3.0.sif \
TEsorter brassicaceae_gypsy.fasta -db rexdb-plant

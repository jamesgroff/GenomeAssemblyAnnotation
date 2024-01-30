#!/usr/bin/env bash

#SBATCH --cpus-per-task=1
#SBATCH --mem=4G
#SBATCH --time=01:00:00
#SBATCH --job-name=canu
#SBATCH --mail-user=james.groffmizoguchi@students.unibe.ch
#SBATCH --mail-type=begin,end
#SBATCH --output=/data/users/jgroff/assembly_annotation_course/assemblies/canu/output_canu_%j.o
#SBATCH --error=/data/users/jgroff/assembly_annotation_course/assemblies/canu/error_canu_%j.e
#SBATCH --partition=pall

#Add modules for the canu assembly
module add UHTS/Assembler/canu/2.1.1;

#Variables for directory pathways
READS_DIR=/data/users/jgroff/assembly_annotation_course/participant_1/pacbio
OUTPUT_DIR=/data/users/jgroff/assembly_annotation_course/assemblies/canu

# Go to the output pathway
cd $OUTPUT_DIR

# Run canu
canu \
 -p arabidopsis -d arabidopsis-pacbio \
 genomeSize=126m \
 -pacbio $READS_DIR/*.fastq.gz \
 maxThreads=16 \
 maxMemory=64 \
 gridEngineResourceOption="--cpus-per-task=THREADS --mem-per-cpu=MEMORY" \
 gridOptions="--partition=pall --mail-user=james.groffmizoguchi@students.unibe.ch"

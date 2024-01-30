#!/usr/bin/env bash

#SBATCH --cpus-per-task=4
#SBATCH --mem=48G
#SBATCH --time=1-00:00:00
#SBATCH --job-name=polish
#SBATCH --mail-user=james.groffmizoguchi@students.unibe.ch
#SBATCH --mail-type=begin,end
#SBATCH --output=/data/users/jgroff/assembly_annotation_course/polish/output_polish_%j.o
#SBATCH --error=/data/users/jgroff/assembly_annotation_course/polish/error_polish_%j.e
#SBATCH --partition=pall

# Get the module for java and samtools for sorting and indexing (try one of the two)
#module add Development/java/17.0.6;
module add Development/java/1.8.0_242;
module add UHTS/Analysis/samtools/1.10;

#Variables for directory pathways
FLYE_DIR=/data/users/jgroff/assembly_annotation_course/assemblies/flye
CANU_DIR=/data/users/jgroff/assembly_annotation_course/assemblies/canu/arabidopsis-pacbio
OUTPUT_DIR=/data/users/jgroff/assembly_annotation_course/polish

# Run pilon for flye assembly
cd $OUTPUT_DIR/flye
samtools sort -o flye_aligned.sorted.bam --threads 4 flye_aligned.bam
samtools index flye_aligned.sorted.bam
java -Xmx45g -jar /mnt/software/UHTS/Analysis/pilon/1.22/bin/pilon-1.22.jar \
 --genome $FLYE_DIR/assembly.fasta --bam flye_aligned.sorted.bam --output flye_polished --threads 4

# Do the same for canu assembly
cd $OUTPUT_DIR/canu
samtools sort -o canu_aligned.sorted.bam --threads 4 canu_aligned.bam
samtools index canu_aligned.sorted.bam
java -Xmx45g -jar /mnt/software/UHTS/Analysis/pilon/1.22/bin/pilon-1.22.jar \
 --genome $CANU_DIR/arabidopsis.contigs.fasta --bam canu_aligned.sorted.bam --output canu_polished --threads 4


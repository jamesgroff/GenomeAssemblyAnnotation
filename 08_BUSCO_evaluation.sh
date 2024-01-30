#!/usr/bin/env bash

#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --time=1-00:00:00
#SBATCH --job-name=BUSCO
#SBATCH --mail-user=james.groffmizoguchi@students.unibe.ch
#SBATCH --mail-type=begin,end
#SBATCH --output=/data/users/jgroff/assembly_annotation_course/evaluation/output_BUSCO_%j.o
#SBATCH --error=/data/users/jgroff/assembly_annotation_course/evaluation/error_BUSCO_%j.e
#SBATCH --partition=pall

#Variables for directory pathways
FLYE_DIR=/data/users/jgroff/assembly_annotation_course/assemblies/flye
CANU_DIR=/data/users/jgroff/assembly_annotation_course/assemblies/canu/arabidopsis-pacbio
TRIN_DIR=/data/users/jgroff/assembly_annotation_course/assemblies/Trinity/trinity_out_dir
FLYE_POLISH_DIR=/data/users/jgroff/assembly_annotation_course/polish/flye
CANU_POLISH_DIR=/data/users/jgroff/assembly_annotation_course/polish/canu
OUTPUT_DIR=/data/users/jgroff/assembly_annotation_course/evaluation/BUSCO

# Module to run BUSCO assessment
module add UHTS/Analysis/busco/4.1.4;

cd $OUTPUT_DIR

#Make a copy of the augustus config directory to have written permission
cp -r /software/SequenceAnalysis/GenePrediction/augustus/3.3.3.1/config augustus_config
export AUGUSTUS_CONFIG_PATH=./augustus_config

# Run BUSCO for flye, canu and trinity assemblies (not polished)
busco -i ${FLYE_DIR}/assembly.fasta -o flye_unpolished --lineage brassicales_odb10 -m genome --cpu 16
busco -i ${CANU_DIR}/arabidopsis.contigs.fasta -o canu_unpolished --lineage brassicales_odb10 -m genome --cpu 16
#busco -i ${TRIN_DIR}/Trinity.fasta -o trinity_RNAseq --lineage brassicales_odb10 -m transcriptome --cpu 16

# Run BUSCO for flye and canu (polished)
busco -i ${FLYE_POLISH_DIR}/flye_polished.fasta -o flye_polished --lineage brassicales_odb10 -m genome --cpu 16
busco -i ${CANU_POLISH_DIR}/canu_polished.fasta -o canu_polished --lineage brassicales_odb10 -m genome --cpu 16

# Remove the augustus config
rm -r ./augustus_config

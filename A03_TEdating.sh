#!/usr/bin/env bash

#SBATCH --time=04:00:00
#SBATCH --mem=10G
#SBATCH --cpus-per-task=4
#SBATCH --job-name=TEdating
#SBATCH --mail-user=james.groffmizoguchi@students.unibe.ch
#SBATCH --mail-type=begin,end
#SBATCH --output=/data/users/jgroff/assembly_annotation_course/TEdating/TEdating_%j.o
#SBATCH --error=/data/users/jgroff/assembly_annotation_course/TEdating/TEdating_%j.e
#SBATCH --partition=pall

COURSEDIR=/data/courses/assembly-annotation-course/CDS_annotation/scripts
WORKDIR=/data/users/jgroff/assembly_annotation_course/TEdating
genome=/data/users/jgroff/assembly_annotation_course/EDTA/polished_flye.fasta.mod.EDTA.anno/polished_flye.fasta.mod.out

cd $WORKDIR

# Use perl to parse raw alignments for the whole output with conda environment,
# You could do it on the cluster withouth the script by yourself which is recommended
module add Development/conda/4.6.14
conda create -n env
conda activate env
conda install -c bioconda perl-bioperl
perl parseRM.pl -i $genome -l 50,1 -v
conda deactivate

# Modify the output file by removing 1st and 3rd line
sed -i '1d;3d' polished_flye.fasta.mod.out.landscape.Div.Rname.tab

# Date the divergence of annotated TEs
module load R/3.6.1;
R $COURSEDIR/plot_div.R polished_flye.fasta.mod.out.landscape.Div.Rname.tab

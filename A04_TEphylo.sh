#!/usr/bin/env bash

#SBATCH --time=01:00:00
#SBATCH --mem=10G
#SBATCH --cpus-per-task=4
#SBATCH --job-name=TEphylo
#SBATCH --mail-user=james.groffmizoguchi@students.unibe.ch
#SBATCH --mail-type=begin,end
#SBATCH --output=/data/users/jgroff/assembly_annotation_course/TEphylo/TEphylo_%j.o
#SBATCH --error=/data/users/jgroff/assembly_annotation_course/TEphylo/TEphylo_%j.e
#SBATCH --partition=pall

WORKDIR=/data/users/jgroff/assembly_annotation_course/TEphylo
copia=/data/users/jgroff/assembly_annotation_course/TEsorter/output_copia.fasta.rexdb-plant.dom.faa
gypsy=/data/users/jgroff/assembly_annotation_course/TEsorter/output_gypsy.fasta.rexdb-plant.dom.faa

cd $WORKDIR

# Add module for seqkit
module add UHTS/Analysis/SeqKit/0.13.2;

# Extract RT proteins of gypsy elements
grep Ty3-RT $gypsy > gypsy_list.txt #make a list of RT proteins to extract
sed -i 's/>//' gypsy_list.txt #remove ">" from the header
sed -i 's/ .\+//' gypsy_list.txt #remove all characters following "empty space" from the header
seqkit grep -f gypsy_list.txt $gypsy -o Gypsy_RT.fasta

# Shorten the identifiers of RT sequences
sed -i 's/|.\+//' Gypsy_RT.fasta #remove all characters following "|"

# Align the sequences of clustal omega
module load SequenceAnalysis/MultipleSequenceAlignment/clustal-omega/1.2.4
clustalo -i Gypsy_RT.fasta -o Gypsy_protein_alignment.fasta

# Create a phylogenic tree with FastTree
module load Phylogeny/FastTree/2.1.10
FastTree -out Gypsy_protein_alignment.tree Gypsy_protein_alignment.fasta

# Repeat the same steps for copia elements

# Extract RT proteins of copia elements
grep Ty1-RT $copia > copia_list.txt #make a list of RT proteins to extract
sed -i 's/>//' copia_list.txt #remove ">" from the header
sed -i 's/ .\+//' copia_list.txt #remove all characters following "empty space" from the header
seqkit grep -f copia_list.txt $copia -o Copia_RT.fasta

# Shorten the identifiers of RT sequences
sed -i 's/|.\+//' Copia_RT.fasta #remove all characters following "|"

# Align the sequences of clustal omega
clustalo -i Copia_RT.fasta -o Copia_protein_alignment.fasta

# Create a phylogenic tree with FastTree
FastTree -out Copia_protein_alignment.tree Copia_protein_alignment.fasta


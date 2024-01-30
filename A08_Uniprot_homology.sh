#!/usr/bin/env bash

#SBATCH --time=02:00:00
#SBATCH --mem=20G
#SBATCH --cpus-per-task=10
#SBATCH --job-name=UniProt
#SBATCH --mail-user=james.groffmizoguchi@students.unibe.ch
#SBATCH --mail-type=begin,end
#SBATCH --output=/data/users/jgroff/assembly_annotation_course/annotation_evaluation/UniProt/UniProt_%j.o
#SBATCH --error=/data/users/jgroff/assembly_annotation_course/annotation_evaluation/UniProt/UniProt_%j.e
#SBATCH --partition=pall

COURSEFILE=/data/courses/assembly-annotation-course/CDS_annotation/uniprot-plant_reviewed.fasta
MAKERDIR=/data/users/jgroff/assembly_annotation_course/MAKER/run_mpi.maker.output
WORKDIR=/data/users/jgroff/assembly_annotation_course/annotation_evaluation/UniProt
cd $WORKDIR

# Load module for Blast and maker
module load Blast/ncbi-blast/2.10.1+;
module load SequenceAnalysis/GenePrediction/maker/2.31.9;

# Align proteins against validated proteins from UniProt database
makeblastdb -in $COURSEFILE -dbtype prot -out uniprot-plant_reviewed_db
blastp -query ${MAKERDIR}/flye_polished.all.maker.proteins.fasta.renamed.fasta -db uniprot-plant_reviewed_db -num_threads 10 -outfmt 6 -evalue 1e-10 -out blastp_uniprot.out

# Map protein putative functions to MAKER produced GFF3 and FASTA files

cp ${MAKERDIR}/flye_polished.all.maker.proteins.fasta.renamed.fasta flye_polished.all.maker.proteins.fasta.renamed.fasta.Uniprot
cp ${MAKERDIR}/flye_polished.all.maker.noseq.gff.renamed.gff flye_polished.all.maker.noseq.gff.renamed.gff.Uniprot

maker_functional_fasta $COURSEFILE blastp_uniprot.out flye_polished.all.maker.proteins.fasta.renamed.fasta.Uniprot
maker_functional_gff $COURSEFILE blastp_uniprot.out flye_polished.all.maker.noseq.gff.renamed.gff.Uniprot

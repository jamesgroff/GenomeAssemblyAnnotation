#!/usr/bin/env bash

#SBATCH --time=02:00:00
#SBATCH --mem=10G
#SBATCH --cpus-per-task=4
#SBATCH --job-name=annotation
#SBATCH --mail-user=james.groffmizoguchi@students.unibe.ch
#SBATCH --mail-type=begin,end
#SBATCH --output=/data/users/jgroff/assembly_annotation_course/MAKER/annotation_%j.o
#SBATCH --error=/data/users/jgroff/assembly_annotation_course/MAKER/annotation_%j.e
#SBATCH --partition=pall

WORKDIR=/data/users/jgroff/assembly_annotation_course/MAKER/run_mpi.maker.output
cd $WORKDIR

module load SequenceAnalysis/GenePrediction/maker/2.31.9;
export TMPDIR=$SCRATCH
base="flye_polished"

# Generate gff and fasta files

gff3_merge -d run_mpi_master_datastore_index.log -o ${base}.all.maker.gff
gff3_merge -d run_mpi_master_datastore_index.log -n -o ${base}.all.maker.noseq.gff
fasta_merge -d run_mpi_master_datastore_index.log -o ${base}

# Finalize annotation by renaming MAKER genes

protein=${base}.all.maker.proteins.fasta
transcript=${base}.all.maker.transcripts.fasta
gff=${base}.all.maker.noseq.gff
prefix=${base}_

cp $gff ${gff}.renamed.gff
cp $protein ${protein}.renamed.fasta
cp $transcript ${transcript}.renamed.fasta

maker_map_ids --prefix $prefix --justify 7 ${gff}.renamed.gff > ${base}.id.map
map_gff_ids ${base}.id.map ${gff}.renamed.gff
map_fasta_ids ${base}.id.map ${protein}.renamed.fasta
map_fasta_ids ${base}.id.map ${transcript}.renamed.fasta

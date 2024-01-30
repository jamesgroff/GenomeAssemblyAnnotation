#!/usr/bin/env bash

#SBATCH --time=01:00:00
#SBATCH --mem=10G
#SBATCH --cpus-per-task=4
#SBATCH --job-name=prepMAKER
#SBATCH --mail-user=james.groffmizoguchi@students.unibe.ch
#SBATCH --mail-type=begin,end
#SBATCH --output=/data/users/jgroff/assembly_annotation_course/MAKER/prepMAKER_%j.o
#SBATCH --error=/data/users/jgroff/assembly_annotation_course/MAKER/prepMAKER_%j.e
#SBATCH --partition=pall

COURSEDIR=/data/courses/assembly-annotation-course
WORKDIR=/data/users/jgroff/assembly_annotation_course/MAKER
cd $WORKDIR

module load SequenceAnalysis/GenePrediction/maker/2.31.9;

singularity exec --bind $SCRATCH --bind $WORKDIR --bind $COURSEDIR \
$COURSEDIR/containers2/MAKER_3.01.03.sif \
maker -CTL

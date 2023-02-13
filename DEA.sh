#!/bin/bash

#-----------------------------------------------------
#DIFFERENTIAL EXPRESSION ANALYSIS
#-----------------------------------------------------

cd ~/results_final_project

mkdir -p DEA

#Copy gff genome file
cp ~/final_project/genome.gff ~/results_final_project/DEA/genome.gff

#Convert BAM files to Raw counts

source activate base
conda activate rnaseq

for file in ~/results_final_project/GenomeAnalysis/VariantCalling/*.sorted.bam ; do
	filename=$(basename -- "$file") #filename without path
	name=${filename%.*.*} #filename without extension
	htseq-count -i locus_tag -s no -r pos -f bam $file ./DEA/genome.gff -m union -t CDS > ./DEA/${name}.count
done
conda deactivate

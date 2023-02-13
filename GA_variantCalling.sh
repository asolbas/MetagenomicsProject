#!/bin/bash

#-----------------------------------------------------
#GENOME ANALYSIS (Variant Calling)
#-----------------------------------------------------

cd ~/results_final_project/GenomeAnalysis

#Create results folder
mkdir -p VariantCalling

#Activate conda environment
source activate base
conda activate samtools

echo -e "Sorting BAM files..."

#Sort BAM files
for file in ./ReadMapping/*.bam ; do
    filename=$(basename -- "$file") #filename without path
    name=${filename%.*} #filename without extension
    samtools sort $file > ./VariantCalling/$name.sorted.bam
done

echo -e "Merging BAM sample files..."

#Merge all mappings into a single file
samtools merge -h ./VariantCalling/normal01.sorted.bam ./VariantCalling/merged.bam  ./VariantCalling/normal01.sorted.bam ./VariantCalling/normal02.sorted.bam ./VariantCalling/hightemp01.sorted.bam ./VariantCalling/hightemp02.sorted.bam
#Index reference genome
samtools faidx ./genome.fasta

#deactivate samtools environment
conda deactivate

#Activate bcftools
source activate base
conda activate bcftools

#Variant Calling with merged file
echo -e "Running Variant Calling with merged samples..."

#Transform BAM file into VCF format
bcftools mpileup --threads 1 -f genome.fasta ./VariantCalling/merged.bam > ./VariantCalling/mpileup_merged.vcf

#Run Variant Calling
bcftools call --threads 1 -mv -Ob -o ./VariantCalling/calls_merged.bcf ./VariantCalling/mpileup_merged.vcf

#Repeat the analysis with the 4 sample files separately
echo -e "Running Variant Calling with 4 samples separately..."
bcftools mpileup --threads 1 -f genome.fasta ./VariantCalling/hightemp01.sorted.bam ./VariantCalling/hightemp02.sorted.bam ./VariantCalling/normal01.sorted.bam ./VariantCalling/normal02.sorted.bam > ./VariantCalling/mpileup_sep.vcf

bcftools call --threads 1 -mv -Ob -o ./VariantCalling/calls_sep.bcf ./VariantCalling/mpileup_sep.vcf

#Deactivate environment
conda deactivate

#Check results

#bcftools stats ./VariantCalling/calls_merged.bcf | more 
#bcftools stats ./VariantCalling/calls_sep.bcf | more

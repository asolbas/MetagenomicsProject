#!/bin/bash

#-----------------------------------------------------
#GENOME ANALYSIS (Basic checks)
#-----------------------------------------------------

cd ~/results_final_project/GenomeAnalysis

#Create an index of the reference genome
bwa index ./genome.fasta

#Create folder to store results
mkdir -p ReadMapping

#Map the samples to the reference genome
echo -e "Start mapping..."
#hightemp 01
bwa mem -t 1 genome.fasta ./RNAseq/hightemp01.r1.fq ./RNAseq/hightemp01.r2.fq > ./ReadMapping/hightemp01.sam 2> ./ReadMapping/hightemp01.sam.err
#hightemp 02
bwa mem -t 1 genome.fasta ./RNAseq/hightemp02.r1.fq ./RNAseq/hightemp02.r2.fq > ./ReadMapping/hightemp02.sam 2> ./ReadMapping/hightemp02.sam.err
#normal 01
bwa mem -t 1 genome.fasta ./RNAseq/normal01.r1.fq ./RNAseq/normal01.r2.fq > ./ReadMapping/normal01.sam 2> ./ReadMapping/normal01.sam.err
#normal 02
bwa mem -t 1 genome.fasta ./RNAseq/normal02.r1.fq ./RNAseq/normal02.r2.fq > ./ReadMapping/normal02.sam 2> ./ReadMapping/normal02.sam.err

#Create BAM files for the mappings
echo -e "Generating BAM files..."
source activate base
conda activate samtools #activate environment

for file in ./ReadMapping/*.sam ; do
	filename=$(basename -- "$file") #filename without path
	name=${filename%.*} #filename without extension
	echo -e "Mapping $name \n"
	#Create BAM file
	samtools view -b -h $file > ./ReadMapping/$name.bam 
	#Remove SAM files
	rm $file
done

#Generate flagstat report
echo -e "Generating flagstat report..."
for file in ./ReadMapping/*.bam ; do
        filename=$(basename -- "$file") #filename without path
        name=${filename%.*} #filename without extension
	echo -e "-----------------------------"
	echo -e "$name FLAGSTAT REPORT \n"
	echo -e "-----------------------------"
	samtools flagstat $file
	echo -e "\n"
done > ./ReadMapping/flagstat.txt

conda deactivate
	

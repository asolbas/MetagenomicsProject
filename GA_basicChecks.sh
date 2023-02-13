#!/bin/bash

#-----------------------------------------------------
#GENOME ANALYSIS (Basic checks)
#-----------------------------------------------------
cd ~/results_final_project

#Create results folder
mkdir -p GenomeAnalysis

#Quality check: FastQC -------------------------------
if [ ! -d "./GenomeAnalysis/fastqc" ]; then

	echo -e "Running FastQC analysis..."
	mkdir -p ./GenomeAnalysis/fastqc

	#Activate rnaseq conda environment
	source activate base
	conda activate rnaseq

	# Run FastQC
	for file in /home/a.solbas/final_project/RNAseq/*.fq.gz ; do
		fastqc -o /home/a.solbas/results_final_project/GenomeAnalysis/fastqc/ $file
	done

	#Merge files
	cd GenomeAnalysis/fastqc
	multiqc .

	conda deactivate

else
	echo -e "Quality check already done"
fi

#Copy files into results folder --------------------

#Copy reference genome file
cp ~/final_project/genome.fasta ./GenomeAnalysis/

if [ ! -d "./GenomeAnalysis/RNAseq" ]; then
	#Copy sample files
	cp -ar ~/final_project/RNAseq/ ~/results_final_project/GenomeAnalysis/
	#decompress files
	gunzip -r ~/results_final_project/GenomeAnalysis/RNAseq
fi		

#Basic checks -----------------------------------
echo -e "Running basic check analysis..."

#Count the number of samples
echo -e "------------------------" > ./GenomeAnalysis/BasicChecks_Report.txt
echo -e "BASIC CHECKS REPORT" >> ./GenomeAnalysis/BasicChecks_Report.txt
echo -e "------------------------\n" >> ./GenomeAnalysis/BasicChecks_Report.txt

echo -e "List RNAseq sample files:\n" >> ./GenomeAnalysis/BasicChecks_Report.txt
count=0
for file in /home/a.solbas/final_project/RNAseq/*.fq.gz ; do
	count=$((count+1))
	filename=$(basename -- "$file") #filename without path
	name=${filename%.*} #filename without extension
	echo -e "$name" >> ./GenomeAnalysis/BasicChecks_Report.txt
done
echo -e "Total number of files: $count" >> ./GenomeAnalysis/BasicChecks_Report.txt

#Count the number of reads of each sample
echo -e "\n------------------------\n" >> ./GenomeAnalysis/BasicChecks_Report.txt
echo -e "Number of reads of each sample\n" >> ./GenomeAnalysis/BasicChecks_Report.txt
for file in ./GenomeAnalysis/RNAseq/*.fq ; do
	filename=$(basename -- "$file") #filename without path
	name=${filename%.*} #filename without extension
	count=$(cat $file | grep -cP "^@")
	echo -e "-$name: $count" >> ./GenomeAnalysis/BasicChecks_Report.txt
done

#Check if all reads have the same length
#Calculate the number of reads with each different length value
echo -e "\n------------------------\n" >> ./GenomeAnalysis/BasicChecks_Report.txt
echo -e "Distribution of read lengths for each sample" >> ./GenomeAnalysis/BasicChecks_Report.txt
for file in ./GenomeAnalysis/RNAseq/*.fq ; do
	filename=$(basename -- "$file") #filename without path
        name=${filename%.*} #filename without extension
	echo -e "\n-$name:" >> ./GenomeAnalysis/BasicChecks_Report.txt
	cat $file | awk 'NR%4 == 2 {lengths[length($0)]++ ; counter++} END {for (l in lengths) {print l, lengths[l]}; print "total reads: " counter}' >> ./GenomeAnalysis/BasicChecks_Report.txt
done

#Distribution of quality values 
echo -e "\n------------------------\n" >> ./GenomeAnalysis/BasicChecks_Report.txt
echo -e "Distribution of quality scores for each sample" >> ./GenomeAnalysis/BasicChecks_Report.txt
for file in ./GenomeAnalysis/RNAseq/*.fq ; do
        filename=$(basename -- "$file") #filename without path
        name=${filename%.*} #filename without extension
        echo -e "\n-$name:" >> ./GenomeAnalysis/BasicChecks_Report.txt
	cat $file | awk 'NR%4 == 0' | sort | uniq -c >> ./GenomeAnalysis/BasicChecks_Report.txt
done

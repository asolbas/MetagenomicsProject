#!/bin/bash

#-----------------------------------------------------
#PHYLOGENETIC ANALYSIS
#-----------------------------------------------------

#Create results folder
mkdir ~/results_final_project/PA

cd ~/results_final_project/PA

echo -e "Creating BLAST database..."

#Create a BLAST database
makeblastdb -dbtype prot -in ~/final_project/all_reference_proteomes.faa -out all_reference_proteomes.blastdb

#Run BLAST and Phylogenetic reconstruction
for file in ~/results_final_project/FA/*.faa ; do
	filename=$(basename -- "$file") #filename without path
	name=${filename%.*} #filename without extension
	echo -e "\nRunning BLAST for $name"
	#Run a blast with a 0.001 e-value threshold and tabular output format 6
	#Format 6: qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore
	blastp -task blastp -query $file -db all_reference_proteomes.blastdb -outfmt 6 -evalue 0.001 > $name.blastout

	#Extract all the homologs sequences
	python /home/compgenomics/4proteomes/scripts/extract_seqs_from_blast_result.py $name.blastout ~/final_project/all_reference_proteomes.faa > ${name}_homologs.faa

	#Add query protein
	cat $file >> ${name}_homologs.faa

	#Multiple secuence alignment (MSA)
	echo -e "Running MSA"
	mafft ${name}_homologs.faa > ${name}_homologs.alg
	
	#Phylogenetic reconstruction
	echo -e "Running iqtree"
	iqtree -s ${name}_homologs.alg -m LG

	#Root tree
	echo -e "Generating tree txt file"
	python /home/compgenomics/4proteomes/scripts/midpoint_rooting.py ${name}_homologs.alg.treefile > ${name}_homologs_rooted.alg.treefile
	
	#Visualize tree
	cat ${name}_homologs_rooted.alg.treefile | ete3 view --text >> ${name}_rootedTree.txt 

done

#!/bin/bash

#-----------------------------------------------------
#METAGENOMICS
#-----------------------------------------------------

#Create results folder
mkdir -p Metagenomics

#Obtain the most abundant organism in high-temperature
motus  profile -f /home/a.solbas/final_project/metagenomics-hotspring-hightemp.1.fq.gz -r /home/a.solbas/final_project/metagenomics-hotspring-hightemp.2.fq.gz -o ~/results_final_project/Metagenomics/hightemp.motus -t 20

echo -e "-----------------------------" > ~/results_final_project/Metagenomics/Metagenomics_results.txt
echo -e "METAGENOMICS RESULTS" >> ~/results_final_project/Metagenomics/Metagenomics_results.txt
echo -e "-----------------------------" >> ~/results_final_project/Metagenomics/Metagenomics_results.txt

echo -e "The most abundant organism in the high-temperature sample is: \n" >> ~/results_final_project/Metagenomics/Metagenomics_results.txt
perl -F"\t" -lane 'print if $F[1]>0' ~/results_final_project/Metagenomics/hightemp.motus | sort -nk2,2 | head -n1 >> ~/results_final_project/Metagenomics/Metagenomics_results.txt

#Repeat the analysis with a more stringent threshold: 5 marker-genes
motus  profile -g 5 -f /home/a.solbas/final_project/metagenomics-hotspring-hightemp.1.fq.gz -r /home/a.solbas/final_project/metagenomics-hotspring-hightemp.2.fq.gz -o ~/results_final_project/Metagenomics/hightemp_5genes.motus -t 20

echo -e "The most abundant organism in the high-temperature sample with a more stringent threshold is: \n" >> ~/results_final_project/Metagenomics/Metagenomics_results.txt

perl -F"\t" -lane 'print if $F[1]>0' ~/results_final_project/Metagenomics/hightemp_5genes.motus | sort -nk2,2 | head -n1 >> ~/results_final_project/Metagenomics/Metagenomics_results.txt

#Most abundant organisms in normal temperature (rel ab >0.01)
motus  profile -f /home/a.solbas/final_project/metagenomics-hotspring-normaltemp.1.fq.gz -r /home/a.solbas/final_project/metagenomics-hotspring-normaltemp.2.fq.gz -o ~/results_final_project/Metagenomics/normaltemp.motus -t 20

echo -e "The most abundant organism in the normal-temperature sample is: \n" >> ~/results_final_project/Metagenomics/Metagenomics_results.txt

perl -F"\t" -lane 'print if $F[1]>0.01' ./Metagenomics/normaltemp.motus >> ~/results_final_project/Metagenomics/Metagenomics_results.txt

#alpha diversity
#Calculate the number of different organisms found in each condition 
echo -e "High-temperature sample alpha diversity: " >> ~/results_final_project/Metagenomics/Metagenomics_results.txt
perl -F"\t" -lane 'print if $F[1]>0' ./Metagenomics/hightemp.motus | wc -l >> ~/results_final_project/Metagenomics/Metagenomics_results.txt #high temperature
echo -e "Normal-temperature sample alpha diversity: " >> ~/results_final_project/Metagenomics/Metagenomics_results.txt
perl -F"\t" -lane 'print if $F[1]>0' ./Metagenomics/normaltemp.motus | wc -l >> ./Metagenomics/Metagenomics_results.txt #normal temperature

#Check if there any algae organisms in the normal temp sample
motus  profile -f /home/a.solbas/final_project/metagenomics-hotspring-normaltemp.1.fq.gz -r /home/a.solbas/final_project/metagenomics-hotspring-normaltemp.2.fq.gz -o ~/results_final_project/Metagenomics/normaltemp_phylum.motus -k phylum -t 20
echo -e "Relative abundance of the different phyla in the normal temperature sample:\n"  >> ~/results_final_project/Metagenomics/Metagenomics_results.txt
perl -F"\t" -lane 'print if $F[1]>0' ~/results_final_project/Metagenomics/normaltemp_phylum.motus >> ~/results_final_project/Metagenomics/Metagenomics_results.txt

#Check if there are any eukaryotic organisms
motus  profile -f /home/a.solbas/final_project/metagenomics-hotspring-normaltemp.1.fq.gz -r /home/a.solbas/final_project/metagenomics-hotspring-normaltemp.2.fq.gz -o ~/results_final_project/Metagenomics/normaltemp_kingdom.motus -k kingdom -t 20
echo -e "Relative abundance of the different kingdoms in the normal temperature sample:\n"  >> ~/results_final_project/Metagenomics/Metagenomics_results.txt
perl -F"\t" -lane 'print if $F[1]>0' ~/results_final_project/Metagenomics/normaltemp_kingdom.motus  >> ~/results_final_project/Metagenomics/Metagenomics_results.txt

#Repeat the analysis for the high-temperature sample to compare it with the normal-temp one
motus  profile -f /home/a.solbas/final_project/metagenomics-hotspring-hightemp.1.fq.gz -r /home/a.solbas/final_project/metagenomics-hotspring-hightemp.2.fq.gz -o ~/results_final_project/Metagenomics/hightemp_kingdom.motus -k kingdom -t 20
echo -e "Relative abundance of the different kingdoms in the high temperature sample:\n"  >> ~/results_final_project/Metagenomics/Metagenomics_results.txt
perl -F"\t" -lane 'print if $F[1]>0' ~/results_final_project/Metagenomics/hightemp_kingdom.motus >> ~/results_final_project/Metagenomics/Metagenomics_results.txt

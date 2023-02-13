# MetagenomicsProject

Code for the final project of the Genomics Data Analysis and Visualization course of the MSc in Computational Biology at the Technical University of Madrid (UPM). 

## Overview

The aim of the project was to analyze a microbial community retrieved from an Icelandic hot spring using bioinformatics tools. The microbial community sample was isolated in two different temperature conditions: normal temperature and high-temperature, and subsequently sequenced using Illumina 1.5 technology. The resulting `fastQ` files were provided to the students to carry out the bioinformatics analysis. 

The workflow consists on the following steps: 

1. Taxonomic profile of the microbial community in both temperature conditions. 
2. Analysis of the genome of the most abundant organism. 
3. RNAseq analysis
4. Functional Analysis
5. Phylogenetic Analysis

Note that the data used in this work has not been included in the repository as it was generated specifically for the Master's course by the professors. Thus, the scripts will point to files that have not been included in this repository.

## Scripts

## Dependencies

- [mOTUs](https://motu-tool.org/)
- [Burrows-Wheeler Aligner](https://bio-bwa.sourceforge.net/)
- [BEDtools](https://bedtools.readthedocs.io/en/latest/)
- [DESeq2](https://bioconductor.org/packages/release/bioc/html/DESeq2.html)
- [IQ-TREE](http://www.iqtree.org/)
- [Blast+](https://blast.ncbi.nlm.nih.gov/Blast.cgi?CMD=Web&PAGE_TYPE=BlastDocs&DOC_TYPE=Download)

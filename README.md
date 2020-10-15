# Sat-BSA

## Table of contents
 - [Installation](#Installation)
 - [Dependencies](#Dependencies)
   + [Installation using bioconda](#Installation-using-bioconda)
   + [Manual Installation](#Manual-Installation)
 - [Usage](#Usage)
   + [command : Local_reads_selection](#command-:-Local_reads_selection)
   + [command : Local_de_novo_assembly](#command-:-Local_de_novo_assembly)
   + [command : Long_reads_alignment](#command-:-Long_reads_alignment)
   + [command : SVs_detection](#command-:-SVs_detection)
   + [command : Graph](#command-:-Graph)
 - [The input file format](#The-input-file-format)
 - [The output file format in the result of each command](#The-output-file-format-in-the-result-of-each-command)
 - [The example of execution of each command and the construction of their out files](#The-example-of-execution-of-each-command-and-the-construction-of-their-out-files)


## Installation
### Dependencies
####  Softwares
   - [perl](#perl)
   - [R](#R)
   - [minimap2](https://github.com/lh3/minimap2)
   - [samtools](https://github.com/samtools/samtools)
   - [canu](https://github.com/marbl/canu)

### Installation using bioconda
  You can install Sat-BSA using bioconda.
  $conda install -c bioconda sat-bsa
  Alternatively, if you want to execute Sat-BSA in a specific environment, below conda command is applied for installing.
  $ conda create -n Sat-BSA -c bioconda sat-bsa
  $ conda activate Sat-BSA
  However, Canu is not installed by above command. You need to download Canu from GitHub by yourself (https://github.com/marbl/canu/releases).
  
  You need to download the input files which used as the argument.
  $ wget https://github.com/SegawaTenta/Sat-BSA_input_file/releases/download/v1.0/Sat-BSA_input_file-1.0.tar
  $ tar -xvf Sat-BSA_input_file-1.0.tar
  or 
  $ git clone https://github.com/SegawaTenta/Sat-BSA_input_file.git 

### Manuel Installation
  If you got an error during installation, you can install Sat-BSA, manually.
  $ git clone https://github.com/SegawaTenta/Sat-BSA.git
  Please create path a path to Sat-BSA/script. The following is an example of a command to create a path.
  $ export PATH="$PATH:/Sat-BSA/script"
  Then, you have to install other dependencies and softwares by yourself.  Creating path to samtools and minimap2 should be confirmed by below commands.
  $samtools
  $minimap2

  You need to download the input files which used as the argument.
  You need to download the input files which used as the argument.
  $ wget https://github.com/SegawaTenta/Sat-BSA_input_file/releases/download/v1.0/Sat-BSA_input_file-1.0.tar
  $ tar -xvf Sat-BSA_input_file-1.0.tar
  or 
  $ git clone https://github.com/SegawaTenta/Sat-BSA_input_file.git  

## Usage
$ Sat-BSA -h
  This command is used for confirming the version and the detailed Usage. 
Description:
  This is Sat-BSA version 1.9.
  Sat-BSA is a package used for applying local de novo assembly and identifying the structural variants in the assembled contigs.  

Usage:
  Sat-BSA -w command [Required arguments] [Additional options]

command : Local_reads_selection
  This command is applied for selecting long reads alined at target region.
  Required arguments:
    -c String     : Chromosome name for selecting the aligned reads.
    -s Int        : Start position for selecting the aligned reads.
    -e Int        : End position for selecting the aligned reads.
    -b Path       : Full path of bam_list.txt listing bam files (Input format 1).
    -f Path       : Full path of fa_list.txt listing fasta.gz files (Input format 2).
  Additional options:
    -t Int        : Thread number. Default=[1]

command : Local_de_novo_assembly
  This command is applied for selecting long reads alined at target region and assembling the selected long reads with Canu (https://github.com/marbl/canu). 
  Required arguments:
    -c String     : Chromosome name for selecting the aligned reads.
    -s Int        : Start position for selecting the aligned reads.
    -e Int        : End position for selecting the aligned reads.
    -b Path       : Full path of bam_list.txt listing bam files (Input format 1).
    -f Path       : Full path of fa_list.txt listing fasta.gz files (Input format 2).
    -d Path       : Full path of Canu.
  Additional options:
    -g Int        : Genome size in Mb set in Canu. 
    -r String     : Read status set in Canu. Default=[-nanopore-raw]. 

command : Long_reads_alignment
  This command is applied for aligning long reads with Minimap2.
  Required arguments:
    -f Path       : Full path of aligned_read_list.txt listing sequence reads applied to Minimap2 (Input format 3).
    -r Path       : Full path of fasta file used as reference.
  Additional options:
    -q Int        : The mapping quality value excluded from analysis. Default=[0]
    -t Int        : Thread number. Default=[1]
    -i ont or pb  : The used sequence reads type (Oxford Nanopore Technologies[ont] or PacBio[pb]).

command : SVs_detection
   This command is applied for identifying structural variants between samples by comparing the alignment depth of long reads in the contigs constructed by local de novo assembly.
  Required arguments:
    -g Path       : Full path of gtf file (Input format 4).
    -c Path       : Full path of samples.txt listing the compared samples (Input format 5).
    -r Path       : Full path of fasta files used as refarence genome.
  Additional options:
    -p Int        : Defining promoter size applied for identifying SVs. Default=[0]
    -t Int        : Thread number Default=[1]
    -v Int        : Threshold for P-value from Fishers exact test. Default=[0.05]
    -f Int        : The minimum length of insertion or deletion applied for analysis. Default=[5]

command : Graph
  This command is applied for drawing graph with the result from SVs_detections.
  Required arguments:
    -r Path       : Full path of result.txt which is an output from SVs_detection command.
    -c Path       : Full path of graph_data.txt listing the path to directory constructed by SVs_detection command and color used for the line of graph (Input format 6).
  Additional options:
    -t Int        : Thread number. Default=[1]
    

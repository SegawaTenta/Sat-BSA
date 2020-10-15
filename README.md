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


Installation
 Dependencies
  Softwares
   ・perl
   ・R
   ・minimap2 (https://github.com/lh3/minimap2)
   ・samtools (https://github.com/samtools/samtools)
   ・canu (https://github.com/marbl/canu)

 Installation using bioconda
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

 Manuel Installation
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

Usage
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
    -t Int        : Thread number. Default=[1]The input file format

1: bam_list.txt 
(applied in “Local_reads_selection”, “Local_de_novo_assembly”)
This file is containing (1)sample name and (2)full path of bam files for each sample in Tab delaminated format.

Ex)
#(1)sample	(2)full_path_of_bam
Sample_P1	/…/…/…/P1.sort.bam
Sample_P2	/…/…/…/P2.sort.bam
Sample_P3	/…/…/…/P3.sort.bam


2: fa_list.txt 
(applied in “Local_reads_selection”, “Local_de_novo_assembly”)
This file is containing (1)sample name and (2)full path of gz compressed fasta formatted sequence reads for each sample in Tab delaminated format. More than two fasta files used for a same sample is listed in different lines as described in Sample_P3

Ex)
#(1)sample	(2)full_path_of_fasta.gz
Sample_P1	/…/…/…/P1.fa.gz
Sample_P2	/…/…/…/P2.fa.gz
Sample_P3	/…/…/…/P3_1.fa.gz
Sample_P3	/…/…/…/P3_2.fa.gz
Sample_P3	/…/…/…/P3_3.fa.gz


3: aligned_read_list.txt 
(applied in “Local_reads_selection”, “Local_de_novo_assembly”)
This file is containing (1)sample name and (2)full path of sequence read files for each sample in Tab delaminated format.  fasta, fastq and their gz compressed files can be applied.  More than two sequence files used for a same sample is listed in different lines as described in Sample_P3

Ex)
#(1)sample	(2)full_path_of_fasta/fastq/fast.gz/fastq.gz
Sample_P1	/…/…/…/P1.fa.gz
Sample_P2	/…/…/…/P2.fa.gz
Sample_P3	/…/…/…/P3_1.fa.gz
Sample_P3	/…/…/…/P3_2.fastq.gz
Sample_P3	/…/…/…/P3_3.fa


4: gene.gtf
(applied in “SVs_detection”)
This file is gtf format file developed by Stringtie (https://ccb.jhu.edu/software/stringtie/index.shtml?t=manual#output) or any tool. The only "transcript" feature is analyzed in this program.


5: compare_list.txt
(applied in “SVs_detection”)
This file is used for comparing SVs between two samples by comparing the aligned depth of each long reads to the assembled contig. This file is contained (1)the name of Sample 1 name, (2)full path of bam for Sample 1, (3)full path of fasta format sequence reads for Sample 1, (4)the name of Sample 2 name, (5)full path of bam for Sample 2 and  (6)full path of sequence reads for Sample 2 in Tab delaminated format.
If you denote the some of the compared samples in different lines, you can identify the gene which have SVs detected commonly in all of the compared samples. In the below example, you can identify the gene having SVs which is commonly detected in analysis between Sample 1 vs Sample 2 and Sample 2 vs Sample 3.

Ex)
#(1)sample1	(2)bam1	 		(3)full path of equence read1	(4)sample2	(5)bam2	 		(6)full path of equence read2
Sample_P1	/…/…/…/P1.sort.bam	/…/…/…/P1_alined.fa.gz	Sample_P2	/…/…/…/P2.sort.bam	/XXX/P2_alined.fa.gz
Sample_P3	/…/…/…/P3.sort.bam	/…/…/…/P3_alined.fa.gz	Sample_P2	/…/…/…/P2.sort.bam	/XXX/P2_alined.fa.gz


6: graph_data.txt
(applied in “Graph”)
This file is used for drawing graph plotting P-value from statistical analysis of aligned depth and showing the region having SVs. This file is contained (1)the full path of the directory of comparing the alignment result between samples and (2) hex triplet color code without # (https://en.wikipedia.org/wiki/Web_colors) in Tab delaminated format.

Ex)
(1)the directory path	(2) Hexadecimal color code without #
/…/…/…/P1_vs_P2	ff0000
/…/…/…/P3_vs_P2	008000The output file format in the result of each command

Local_reads_selection

1: aligned_[chr]_[start_posi]_[end_posi]_[sample_name].fa
  This file is multi fasta file.  
  This multi fasta file contains the long reads aligned at the given genomic region.

2: aligned_[chr]_[start_posi]_[end_posi]_[sample_name].stat.txt
  This file is a text file showing summary of the selected long reads in 1.
 

Local_de_novo_assembly

1: aligned_[chr]_[start_posi]_[end_posi]_[sample_name].fa
  This file is multi fasta file.  
  This multi fasta file contains the long reads aligned at the given genomic region.

2: aligned_[chr]_[start_posi]_[end_posi]_[sample_name].stat.txt
  This file is a text file showing summary of the selected long reads in 1.

3: Local_de_novo_assembly_[sample_name]_[chr]_[start_posi]_[end_posi]
  This is the directly containing the result from Canu assembly with the selected long reads in 1.


Long_reads_alignment

1: [sample_name].sort.bam
  This file is the sorted bam file.
  This bam is developed by aligning the sequence reads of [sample_name] to the given reference.

2: [sample_name].sort.bam.bai
  This is index file of 1.


SVs_detection

1: filter_InDel_size_DNA_result.txt
  This file is a text showing the detected SVs between given samples.
  The file format is written in below.
  column	description
  1		gene id from the given gtf file 
  2		chr name for the gene of 1 column.
  3		start position of genomic region for the gene of 1 column.* 
  4		end position of genomic region for the gene of 1 column.*
  5		strand of the  gene in 1 column.
  6		detecting common mutation. [mut] indicates the gene containing common mutation among compared samples.  
  7~		the combination detected the mutation in the gene of 1 column.
  * The genomic region contains not only transcript feature defined by gtf file but also promoter length indicated by option -p.

  ex)
   [gene_id] [chr] [start] [end]   [strand] [common] [pompare1] [compare2]
   gene.1	tig00000001	1	10000	+	-	-
   gene.2	tig00000001	10000	20000	-	mut	P1_vs_P2	P3_vs_P2
   gene.3	tig00000001	20000	30000	-	mut	P1_vs_P2	P3_vs_P2


2: [Sample1]_vs_[Sample2]/filter_InDel_size_Fishered_[Sample1]_vs_[Sample2].pileup
  This file is a text showing the alined depth of each sample at the position detecting the edge of the alined reads or covering no sequence reads.
  The file format is written in below.
  column	description
  1		chr name of reference fasta. 
  2		position of reference fasta.
  3		alignment depth of [Sample1].
  4		alignment depth of [Sample2].
  5		number of edge of the alined reads of [Sample1].
  6		number of edge of the alined reads of [Sample2].
  7		P-value calculated from Fisher’s exact test.

 ex)
  [chr]	[position] [Sample1_depth] [Sample2_depth] [edge_Sample1] [edge_Sample2] [P-value]
  tig00000001 1020 2 2 1 1 1
  tig00000001 3223 3 1 1 0 1
  tig00000001 5154 4 1 1 0 1
  tig00000001 134561 4 0 2 1 0.428
  tig00000001 151564 5 1 2 0 0.999


Graph

1: [gene_id].png
  This file is a graph plotting P-value calculated by SVs_detection in each genomic region. 

 
The example of execution of each command and the construction of their out files.

Local_reads_selection

$ Sat-BSA -w Local_reads_selection \
	-c chr1 \
	-s 5000 \
	-e 10000 \
	-b /…/…/…/bam_list.txt \
	-f /…/…/…/fa_list.txt \

OUTPUT

|--aligned_chr1_5000_10000_P1.fa
|--aligned_chr1_5000_10000_P1.stat.txt
|--aligned_chr1_5000_10000_P2.fa
|--aligned_chr1_5000_10000_P2.stat.txt
|--aligned_chr1_5000_10000_P3.fa
|--aligned_chr1_5000_10000_P3.stat.txt
|--s1_1_select_reads_name.txt
|--s1_2_pick_up.txt
|--s1_3_merge.txt
|--s1_4_info.txt
|--s2_1_Local_de_novo_assembly.txt

Local_de_novo_assembly

$ Sat-BSA -w Local_de_novo_assembly \
	-c chr1 \
	-s 10000 \
	-e 20000 \
	-b /…/…/…/bam_list.txt \
	-f /…/…/…/fa_list.txt \
	-g 10 \
	-d /…/…/…/Darwin-amd64/bin/canu


OUTPUT

|--aligned_chr1_10000_20000_P1.fa
|--aligned_chr1_10000_20000_P1.stat.txt
|--aligned_chr1_10000_20000_P2.fa
|--aligned_chr1_10000_20000_P2.stat.txt
|--aligned_chr1_10000_20000_P3.fa
|--aligned_chr1_10000_20000_P3.stat.txt
|--Local_de_novo_assembly_P1_chr1_10000_20000
|--Local_de_novo_assembly_P2_chr1_10000_20000
|--Local_de_novo_assembly_P3_chr1_10000_20000
|--s1_1_select_reads_name.txt
|--s1_2_pick_up.txt
|--s1_3_merge.txt
|--s1_4_info.txt
|--s2_1_Local_de_novo_assembly.txt

 Long_reads_alignment

$ Sat-BSA	-w Long_reads_alignment \
	-f /…/…/…/Sat-BSA/fa_list.txt \
	-r /…/…/…/reference.fasta \
	-q 60


OUTPUT


|--P1.sort.bam
|--P1.sort.bam.bai
|--P2.sort.bam
|--P2.sort.bam.bai
|--P3.sort.bam
|--P3.sort.bam.bai
|--s3_1_minimap2_alignment.txt
|--s3_2_filter_MQ.txt
|--s3_3_sam_to_bam.txt
|--s3_4_merge.txt
|--s3_5_sort.txt
|--s3_6_index.txtSVs_detection

$ Sat-BSA	-w SVs_detection \
	-c /…/…/…/compare_list.txt \
	-g /…/…/…/gene_prediction.gtf \
	-r /…/…/…/reference.fasta


OUTPUT
.
|--P1_vs_P2
|  |--Fishered_P1_vs_P2.pileup
|  |--filter_InDel_size_Fishered_P1_vs_P2.pileup
|--P3_vs_P2
|  |--filter_InDel_size_Fishered_P3_vs_P2.pileup
|--filter_InDel_size_DNA_result.txt
|--s4_1_compare.txtGraph

$ Sat-BAS	-w Graph \
		-r filter_InDel_size_DNA_result.txt \
		-c compare_list.txt

OUTPUT
.
|--gene.1 .png
|--gene.2 .png
|--gene.3 .png

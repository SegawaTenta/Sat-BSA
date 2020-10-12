# Sat-BSA

  Description:
    This is Sat-BAS version 1.0.
    
  Usage:
  
    Sat-BSA -w Local_reads_selection [Required options] ..
    Sat-BSA -w Local_de_novo_assembly [Required options] ..
    Sat-BSA -w Long_reads_alignment [Required options] ..
    Sat-BSA -w SVs_detection [Required options] ..
    Sat-BSA -w Graph [Required options] ..
    
  Options of Local_reads_selection:
  
    Required options:
      -c String     : Chromosome to select.
      -s Int        : Start position to select.
      -e Int        : End position to select.
      -b Path       : Full path to text file listing bam files.
      -f Path       : Full path to text file listing fa.gz files.
    Any option:
      -t Int        : CPU. [1]
      
  Options of Local_de_novo_assembly:
  
    In addition to the Local_reads_selection options, you can set the following options!
    Required options:
      -d Path       : Full path to Canu.
    Any options:
      -g String     : Genome size set in Canu.[2m]
      -r String     : Read status set in Canu.[-nanopore-raw]
      
  Options of Long_reads_alignment:
  
    Required options:
      -f Path       : Full path to text file listing reads files.
      -r Path       : Full path to refarence genome fasta.
    Any options:
      -q Int        : Removed less than Int mapping quality alignment.[0]
      -t Int        : CPU. [1]
      -i ont or pb  : Reads type. [ont]
      
  Options of SVs_detection:
  
    Required options:
      -c Path       : Full path to text file listing samples to compare.
      -g Path       : Full path to gtf file.
      -r Path       : Full path to refarence genome fasta.
    Any option:
      -p Int        : Promoter size.[0]
      -t Int        : CPU. [1]
      -v Int        : P-value threshold.[0.05]
      -f Int        : InDels Int or less bp are not detected.[5]
      
  Options of Graph:
  
    Required options:
      -r Path       : Full path to result file output in SVs_detection.
      -c Path       : Full path to text file listing pilup and hexagonal color.
    Any options:
      -t Int        : CPU. [1]

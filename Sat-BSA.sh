#! /bin/sh
#$ -S /bin/sh
#$ -cwd

SCRIPT_DIR=$(cd $(dirname $0); pwd)
# echo $SCRIPT_DIR

function usage() {
  echo $1
  cat <<_EOT_

    oooo                        ooooooo      oooo      oo    
   o   oo                       oo    oo    o   oo     oo    
  oo                 o          oo    oo   oo          ooo   
  oo                 o          oo    oo   oo         oo o   
  ooo       oooo   ooooo        oo    oo   ooo        o  o   
   oooo    oo   o    o          ooooooo     oooo     oo  oo  
     oooo       o    o    oooo  oo    oo      oooo   o    o  
       oo    ooooo   o          oo     o        oo   ooooooo 
        oo oo   oo   o          oo     oo        oo oo    oo 
        oo o    oo   o          oo     o         oo o      o 
  oo   oo  oo  ooo   o          oo    oo   oo   oo oo      oo
   ooooo    oooooo   ooo        ooooooo     ooooo  oo      oo

  Description:
    This is Sat-BAS version 1.0.

  Usage:
    `basename $0` -w Local_reads_selection [Required options] ..
    `basename $0` -w Local_de_novo_assembly [Required options] ..
    `basename $0` -w Long_reads_alignment [Required options] ..
    `basename $0` -w SVs_detection [Required options] ..
    `basename $0` -w Graph [Required options] ..

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
      -g String     : Genome size set in Canu.[2m]
      -r String     : Read status set in Canu.[-nanopore-raw]
      -o OS         : Mac or Linux.[Mac]

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

_EOT_
  exit 1
}

work=0;

while getopts ":hw:" optKey
do
  case $optKey in
    w)
      if [ $OPTARG = "Local_reads_selection" ]
      then
        echo "i will do Local_reads_selection."
        work=1
      elif [ $OPTARG = "Local_de_novo_assembly" ]
      then
        echo "i will do Local_de_novo_assembly."
        work=2
      elif [ $OPTARG = "Long_reads_alignment" ]
      then
        echo "i will do Long_reads_alignment."
        work=3
      elif [ $OPTARG = "SVs_detection" ]
      then
        echo "i will do SVs_detection."
        work=4
      elif [ $OPTARG = "Graph" ]
      then
        echo "i will do Graph."
        work=5
      fi
      break;;
    h)
      usage
      exit;;
  esac
done

if [ $work == 1 ] || [ $work == 2 ]
then
  chr=""
  s_posi=""
  e_posi=""
  bam_list=""
  fa_list=""
  cpu=1
  genome_size="2m"
  reads_info="-nanopore-raw"
  os="Mac"

  while getopts ":c:s:e:b:f:t:g:r:o:" optKey
  do
    # echo $optKey
    # echo ${OPTARG}
    case $optKey in
      c)
        chr=$OPTARG;;
      s)
        s_posi=$OPTARG;;
      e)
        e_posi=$OPTARG;;
      b)
        bam_list=$OPTARG;;
      f)
        fa_list=$OPTARG;;
      t)
        cpu=$OPTARG;;
      g)
        genome_size=$OPTARG;;
      r)
        reads_info=$OPTARG;;
      o)
        os=$OPTARG;;
    esac
  done

  if [ -z "$chr" ]
  then
    echo "Please use -c option!"
    exit
  elif [ -z "$s_posi" ]
  then
    echo "Please use -s option!"
    exit
  elif [ -z "$e_posi" ]
  then
    echo "Please use -e option!"
    exit
  elif [ -z "$bam_list" ]
  then
    echo "Please use -b option!"
    exit
  elif [ -z "$fa_list" ]
  then
    echo "Please use -f option!"
    exit
  fi

  make_Local_reads_selection.pl $bam_list $chr $s_posi $e_posi $fa_list
  chmod +x Local_reads_selection_link.sh
  ./Local_reads_selection_link.sh
  cat s1_1_select_reads_name.txt|xargs -P ${cpu} -I % sh -c %
  cat s1_2_pick_up.txt|xargs -P ${cpu} -I % sh -c %
  cat s1_3_merge.txt|xargs -P ${cpu} -I % sh -c %
  # rm *[0-9].fa
  # rm *_selected_reads_list.txt
  cat s1_4_info.txt|xargs -P ${cpu} -I % sh -c %

  if [ $work == 2 ]
  then
    make_Local_de_novo_assembly.pl $bam_list $genome_size $reads_info $chr $s_posi $e_posi $SCRIPT_DIR $os
    cat s2_1_Local_de_novo_assembly.txt|xargs -P ${cpu} -I % sh -c %
  fi

elif [ $work == 3 ]
then
  fa_list=""
  ref=""
  filtMQ=0
  cpu=1
  info="ont"

  while getopts ":f:r:q:t:i:" optKey
  do
    # echo $optKey
    # echo ${OPTARG}
    case $optKey in
      f)
        fa_list=$OPTARG;;
      r)
        ref=$OPTARG;;
      q)
        filtMQ=$OPTARG;;
      t)
        cpu=$OPTARG;;
      i)
        info=$OPTARG;;
    esac
  done

  if [ -z "$fa_list" ]
  then
    echo "Please use -f option!"
    exit
  elif [ -z "$ref" ]
  then
    echo "Please use -r option!"
    exit
  fi

  make_Long_reads_alignment.pl $fa_list $cpu $filtMQ $ref $info
  chmod +x Long_reads_alignment_link.sh
  ./Long_reads_alignment_link.sh
  cat s3_1_minimap2_alignment.txt|xargs -P $cpu -I % sh -c %
  cat s3_2_filter_MQ.txt|xargs -P $cpu -I % sh -c %
  cat s3_3_sam_to_bam.txt|xargs -P $cpu -I % sh -c %
  cat s3_4_merge.txt|xargs -P $cpu -I % sh -c %
  cat s3_5_sort.txt|xargs -P $cpu -I % sh -c %
  cat s3_6_index.txt|xargs -P $cpu -I % sh -c %

  # rm *.sam
  # rm *.pre.bam
elif [ $work == 4 ]
then
  compare_list=""
  gtf_file=""
  ref=""
  promoter_size=0
  cpu=1
  p_value=0.05
  filt_InDel_size=5

  while getopts ":c:g:r:p:t:v:f:" optKey
  do
    # echo $optKey
    # echo ${OPTARG}
    case $optKey in
      c)
        compare_list=$OPTARG;;
      g)
        gtf_file=$OPTARG;;
      r)
        ref=$OPTARG;;
      p)
        promoter_size=$OPTARG;;
      t)
        cpu=$OPTARG;;
      v)
        p_value=$OPTARG;;
      f)
        filt_InDel_size=$OPTARG;;
    esac
  done

  if [ -z "$compare_list" ]
  then
    echo "Please use -c option!"
    exit
  elif [ -z "$gtf_file" ]
  then
    echo "Please use -g option!"
    exit
  elif [ -z "$ref" ]
  then
    echo "Please use -r option!"
    exit
  fi

  make_SVs_detection.pl $compare_list $gtf_file $ref $promoter_size $cpu $p_value $filt_InDel_size $SCRIPT_DIR
  chmod +x *
  4_1_promoter_transcription_region.pl $gtf_file $promoter_size
  cat s4_1_compare.txt|xargs -P ${cpu} -I % sh -c %
  ls *_vs_*/m_filter_InDel_size_Fishered_*_vs_*.pileup > filter_InDel_size_compare_list.txt
  4_6_match_pileup.pl filter_InDel_size_compare_list.txt
  4_7_result.pl filter_InDel_size_match_mutation.pileup filter_InDel_size_compare_list.txt gene_region.txt


elif [ $work == 5 ]
then
  result_file=""
  compare_list=""
  cpu=1

  while getopts ":r:c:t:" optKey
  do
    # echo $optKey
    # echo ${OPTARG}
    case $optKey in
      r)
        result_file=$OPTARG;;
      c)
        compare_list=$OPTARG;;
      t)
        cpu=$OPTARG;;
    esac
  done

  if [ -z "$result_file" ]
  then
    echo "Please use -r option!"
    exit
  elif [ -z "$compare_list" ]
  then
    echo "Please use -c option!"
    exit
  fi

  mkdir Graph
  cd Graph
  mkdir Graph_script
  5_1_make_script.pl $result_file $SCRIPT_DIR/5_make_graph.R
  ls -1 Graph_script/* > script.txt
  5_2_make_format.pl script.txt $compare_list
  cat make_script.txt|xargs -P ${cpu} -I % sh -c %

fi

#!/usr/bin/perl -w
use strict;

my $reads_PATH=$ARGV[0];
my $CPU =$ARGV[1];
my $filter_Q=$ARGV[2];
my $ref=$ARGV[3];
my $info=$ARGV[4];

my $ref_name=$ref;
$ref_name=~s/\S+\///;

open(FILE,$reads_PATH) or die "$!";
open(OUTPUT, ">Long_reads_alignment_link.sh\n") or die "cannot open file";
open(OUTPUT1, ">s3_1_minimap2_alignment.txt\n") or die "cannot open file";
open(OUTPUT2, ">s3_2_filter_MQ.txt\n") or die "cannot open file";
open(OUTPUT3, ">s3_3_sam_to_bam.txt\n") or die "cannot open file";
open(OUTPUT4, ">s3_4_merge.txt\n") or die "cannot open file";
open(OUTPUT5, ">s3_5_sort.txt\n") or die "cannot open file";
open(OUTPUT6, ">s3_6_index.txt\n") or die "cannot open file";

print OUTPUT "#! /bin/sh\n";
print OUTPUT "#$ -S /bin/sh\n";
print OUTPUT "#$ -cwd\n\n";
print OUTPUT "mkdir link3\n";
print OUTPUT "cd link3\n";

print OUTPUT "mkdir Ref\n";
print OUTPUT "cd Ref\n";
print OUTPUT "ln -s $ref\n";
print OUTPUT "cd ../\n";

my $count=0;
my $keep_name="";

while (my $file = <FILE>){
    chomp $file;
    $count++;
    my @colom = split (/\s+/, $file);
    my $name=$colom[0];
    my $path=$colom[1];

    my $reads_name=$path;
    $reads_name=~s/\S+\///;

    print OUTPUT1 "minimap2 -t 8 -ax map-${info} link3/Ref/${ref_name} link3/$name/$reads_name > ${name}_${count}.sam\n";
    print OUTPUT2 "3_1_filter_mapQ_for_sam.pl ${name}_${count}.sam ${filter_Q}\n";
    print OUTPUT3 "samtools view -bS ${name}_${count}.filtered_Q${filter_Q}.sam > ${name}_${count}.pre.bam\n";

    if($keep_name ne $name){
      if($keep_name ne ""){
        print OUTPUT "cd ../\n";
      }

      $keep_name=$name;

      print OUTPUT "mkdir $name\n";
      print OUTPUT "cd $name\n";

      print OUTPUT4 "samtools merge -f ${name}_merged.bam ${name}_*.pre.bam\n";
      print OUTPUT5 "samtools sort -T ${name}.sort -@ 2 ${name}_merged.bam -o ${name}.sort.bam\n";
      print OUTPUT6 "samtools index ${name}.sort.bam\n";
    }

    print OUTPUT "ln -s $path\n";
}
print OUTPUT "cd ../../\n";

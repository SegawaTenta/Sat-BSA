#!/usr/bin/perl -w
use strict;

my $bam_file =$ARGV[0];
my $chr =$ARGV[1];
my $from_posi =$ARGV[2];
my $to_posi =$ARGV[3];
my $ONT_reads =$ARGV[4];


open(FILE,$bam_file) or die "$!";
open(FILE2,$ONT_reads) or die "$!";
open(OUTPUT, "> Local_reads_selection_link.sh\n") or die "cannot open file";
open(OUTPUT1, "> s1_1_select_reads_name.txt\n") or die "cannot open file";
open(OUTPUT2, "> s1_2_pick_up.txt\n") or die "cannot open file";
open(OUTPUT3, "> s1_3_merge.txt\n") or die "cannot open file";
open(OUTPUT4, "> s1_4_info.txt\n") or die "cannot open file";

print OUTPUT "#! /bin/sh\n";
print OUTPUT "#$ -S /bin/sh\n";
print OUTPUT "#$ -cwd\n\n";
print OUTPUT "mkdir link1\n";
print OUTPUT "cd link1\n";
print OUTPUT "mkdir bam\n";
print OUTPUT "cd bam\n";

my @item=();
while (my $file = <FILE>){
    chomp $file;
    my @colom = split (/\s+/, $file);
    my $name=$colom[0];
    my $bam=$colom[1];

    my $bam_name=$bam;
    $bam_name=~s/\S+\///;

    print OUTPUT "ln -s $bam\n";

    print OUTPUT1 "1_1_select_reads_name_from_bam.pl link1/bam/${bam_name} ${chr} ${from_posi} ${to_posi} samtools ${name}\n";
    print OUTPUT3 "cat ${name}_*[0-9].fa > aligned_${chr}_${from_posi}_${to_posi}_${name}.fa\n";
    print OUTPUT4 "1_3_fa_size.pl aligned_${chr}_${from_posi}_${to_posi}_${name}.fa\n";
    push(@item,$name);
}

print OUTPUT "cd ../\n";
print OUTPUT "mkdir fa\n";
print OUTPUT "cd fa\n";

my $count=0;
my $keep_name="";
while (my $file = <FILE2>){
    chomp $file;
    $count++;
    my @colom = split (/\s+/, $file);
    my $name=$colom[0];
    my $reads=$colom[1];

    my $reads_name=$reads;
    $reads_name=~s/\S+\///;

    if($keep_name ne $name){

      if($keep_name ne ""){
        print OUTPUT "cd ../\n";
      }
      print OUTPUT "mkdir $name\n";
      print OUTPUT "cd $name\n";
      $keep_name=$name;
    }

    print OUTPUT "ln -s $reads\n";

    print OUTPUT2 "1_2_pick_up_reads.pl link1/fa/${name}/${reads_name} ${name}_selected_reads_list.txt ${name}_${count}\n";
}
print OUTPUT "cd ../../../\n";

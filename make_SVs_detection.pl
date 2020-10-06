#!/usr/bin/perl -w
use strict;

my $compare_list =$ARGV[0];
my $gtf_file =$ARGV[1];
my $ref =$ARGV[2];
my $promoter_size =$ARGV[3];
my $cpu =$ARGV[4];
my $p_value =$ARGV[5];
my $filt_InDel_size =$ARGV[6];
my $script_dir =$ARGV[7];

my $ref_name=$ref;
$ref_name=~s/\S+\///;

open(FILE,$compare_list) or die "$!";
open(OUTPUT1, ">s4_1_compare.txt\n") or die "cannot open file";

my $count=0;
my %hash;
my $keep_name="";

while (my $file = <FILE>){
    chomp $file;
    $count++;

    my @colom = split (/\s+/, $file);
    my $name1=$colom[0];
    my $bam1=$colom[1];
    my $fa1=$colom[2];
    my $name2=$colom[3];
    my $bam2=$colom[4];
    my $fa2=$colom[5];

    my $bam1_name=$bam1;
    $bam1_name=~s/\S+\///;
    my $fa1_name=$fa1;
    $fa1_name=~s/\S+\///;

    my $bam2_name=$bam2;
    $bam2_name=~s/\S+\///;
    my $fa2_name=$fa2;
    $fa2_name=~s/\S+\///;

    print OUTPUT1 "sh ./${name1}_vs_${name2}.sh\n";
    open(OUTPUTs, ">${name1}_vs_${name2}.sh\n") or die "cannot open file";
    print OUTPUTs "#! /bin/sh\n";
    print OUTPUTs "#\$ -S /bin/sh\n";
    print OUTPUTs "#\$ -cwd\n\n";
    print OUTPUTs "mkdir ${name1}_vs_${name2}\n";
    print OUTPUTs "cd ${name1}_vs_${name2}\n\n";
    print OUTPUTs "dir=\$(pwd)\n\n";

    print OUTPUTs "mkdir link_Ref\n";
    print OUTPUTs "cd link_Ref\n";
    print OUTPUTs "ln -s $ref\n";
    print OUTPUTs "cd ../\n";

    print OUTPUTs "mkdir link_${name1}\n";
    print OUTPUTs "cd link_${name1}\n";
    print OUTPUTs "ln -s $bam1\n";
    print OUTPUTs "ln -s $fa1\n";
    print OUTPUTs "cd ../\n";

    print OUTPUTs "mkdir link_${name2}\n";
    print OUTPUTs "cd link_${name2}\n";
    print OUTPUTs "ln -s $bam2\n";
    print OUTPUTs "ln -s $fa2\n";
    print OUTPUTs "cd ../\n\n";

    print OUTPUTs "4_1_fa_size.pl $name1 link_${name1}/${fa1_name}\n";
    print OUTPUTs "4_1_fa_size.pl $name2 link_${name2}/${fa2_name}\n";
    print OUTPUTs "4_2_select_pileup.pl ../gene_region.txt samtools link_${name1}/${bam1_name} link_${name2}/${bam2_name} link_Ref/${ref_name} ${name1}_vs_${name2} $filt_InDel_size\n";
    print OUTPUTs "4_3_mut_count_pileup.pl ${name1}_vs_${name2}.pileup\n";
    print OUTPUTs "Rscript ${script_dir}/4_4_Fisher.R \${dir} m_${name1}_vs_${name2}.pileup ${name1}_size.txt ${name2}_size.txt Fishered_${name1}_vs_${name2}.pileup\n";
    print OUTPUTs "4_5_select_mut_pileup.pl Fishered_${name1}_vs_${name2}.pileup $p_value InDel_position.txt\n";

}

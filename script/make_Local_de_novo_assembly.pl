#!/usr/bin/perl -w
use strict;

my $bam_list =$ARGV[0];
my $genome_size =$ARGV[1];
my $reads_info =$ARGV[2];
my $chr =$ARGV[3];
my $s_posi =$ARGV[4];
my $e_posi =$ARGV[5];
my $dir =$ARGV[6];
my $os =$ARGV[7];

open(FILE,$bam_list) or die "$!";
open(OUTPUT, "> s2_1_Local_de_novo_assembly.txt\n") or die "cannot open file";

my @item=();
while (my $file = <FILE>){
    chomp $file;
    my @colom = split (/\s+/, $file);
    my $name=$colom[0];
    my $bam=$colom[1];

    print OUTPUT "${dir}/canu-1.9_${os}/*/bin/canu -p Local_de_novo_assembly_${name}_${chr}_${s_posi}_${e_posi} -d Local_de_novo_assembly_${name}_${chr}_${s_posi}_${e_posi} genomeSize=${genome_size} ${reads_info} aligned_${chr}_${s_posi}_${e_posi}_${name}.fa\n";
}

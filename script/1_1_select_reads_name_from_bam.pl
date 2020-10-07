#!/usr/bin/perl -w
use strict;

my $bam_file = $ARGV[0];
my $chromosome = $ARGV[1];
my $first_position = $ARGV[2];
my $last_position = $ARGV[3];
my $samtools= $ARGV[4];
my $name= $ARGV[5];

open (FILE, "$samtools view $bam_file | ") or die "cannot open file";
open OUTPUT, ">${name}_selected_reads_list.txt\n" or die "cannot open file";
while (my $genome = <FILE>) {
    chomp $genome;
    
    my @colom = split (/\s+/, $genome);
    my $reads_name=$colom[0];
    my $mapped_posi_s=$colom[3];
    my $mapped_posi_e=length($colom[9])+$mapped_posi_s;
    if ($colom[2] =~ /$chromosome/ and $mapped_posi_e >= $first_position and  $mapped_posi_s <= $last_position){
        print OUTPUT "$reads_name\n"; 
    }       
}

close(OUTPUT);
close(FILE);

#!/usr/bin/perl -w
use strict;

my $sam_file = $ARGV[0];
my $q= $ARGV[1];

my $output_file=$sam_file;
$output_file=~s/\S+\///;
$output_file=~s/\.sam/\.filtered_Q${q}\.sam/;

# print "$output_file";

open (FILE, $sam_file) or die "cannot open file";
open OUTPUT, ">$output_file\n" or die "cannot open file";

while (my $sam = <FILE>) {
    chomp $sam;
    if($sam=~/^@/){
        print OUTPUT "$sam\n"; 
    }else{
        my @colom = split (/\t/, $sam);
        my $map_q=$colom[4];

        if ($map_q>=$q){ 
            print OUTPUT "$sam\n";
        }    
    }
       
}

#!/usr/bin/perl -w
use strict;

my $script  = $ARGV[0];
my $compare_txt = $ARGV[1];

open (FILE,$script) or die "cannot open file";
open OUTPUT, ">make_script.txt\n" or die "cannot open file";

my $count1=0;
while (my $file = <FILE>) {
    chomp $file;
    
    print OUTPUT "Rscript ./$file $compare_txt\n";
}

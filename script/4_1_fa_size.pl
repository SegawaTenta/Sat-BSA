#!/usr/bin/perl -w
use strict;

my $name = $ARGV[0];
my $path = $ARGV[1];

open (FILE1,$path) or die "cannot open file";

open OUTPUT, ">${name}_size.txt\n" or die "cannot open file";

my $count1=0;
while (my $file = <FILE1>) {
    chomp $file;
    
    if($file=~/^>/){
    }else{
        $count1=$count1+length($file);
    }
    
}

print OUTPUT "$count1\n";

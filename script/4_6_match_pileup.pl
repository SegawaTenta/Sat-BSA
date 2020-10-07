#!/usr/bin/perl -w
use strict;

my $list=$ARGV[0];


open (FILE1, $list) or die "cannot open file";
open OUTPUT, ">filter_InDel_size_match_mutation.pileup\n" or die "cannot open file";
my %hash=();
my %hash2=();
my $count=0;
while (my $file = <FILE1>) {
    chomp $file;
    $count++;

    # print "Open $file\n";
    open (FILE2, $file) or die "cannot open file";

    if($count==1){
        while(my $pileup = <FILE2>){
            chomp $pileup;

            my @colom = split (/\s+/, $pileup);
            my $chr=$colom[0];
            my $position=$colom[1];
            my $chr_position="${chr}:${position}";

            $hash{$chr_position}=1;

        }

    }elsif($count>1){
        while(my $pileup = <FILE2>){
            chomp $pileup;

            my @colom = split (/\s+/, $pileup);
            my $chr=$colom[0];
            my $position=$colom[1];
            my $chr_position="${chr}:${position}";

            if(exists($hash2{$chr_position})){
                $hash{$chr_position}=1;
            }
        }
    }

    %hash2=();
    my $keys_length= my @keys = keys %hash;
    %hash=();
    # print "$keys_length\n";
    for my $i(@keys){
        $hash2{$i}=1;
    }

}

my $keys1 = keys %hash;
# print "$keys1\n";
my @keys2 = keys %hash2;

for my $i (@keys2){
    print OUTPUT "$i\n";
}

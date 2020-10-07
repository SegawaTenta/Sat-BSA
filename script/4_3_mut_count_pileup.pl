#!/usr/bin/perl -w
use strict;

my $pileup=$ARGV[0];
# my $InDel_size=$ARGV[1];


open (FILE1, $pileup) or die "cannot open file";
open OUTPUT, ">m_${pileup}\n" or die "cannot open file";

while (my $file = <FILE1>) {
    chomp $file;
    
    my @colom = split (/\t/, $file);
    my $chr=$colom[0];
    my $position=$colom[1];
    my $P1_depth=$colom[3];
    my $P1_detail=$colom[4];
    my $P2_depth=$colom[5];
    my $P2_detail=$colom[6];
    
    my $P1clip=$P1_detail;
    $P1clip=~s/[\,\.\]\*\+\-]//ig;
    $P1clip=~s/[0-9]//ig;
    $P1clip=~s/[a-z]//ig;
    my $P1clip_num=length($P1clip);
    
    my $P2clip=$P2_detail;
    $P2clip=~s/[\,\.\]\*\+\-]//ig;
    $P2clip=~s/[0-9]//ig;
    $P2clip=~s/[a-z]//ig;
    my $P2clip_num=length($P2clip);
    
    
    
    my $P1_total_mut=$P1clip_num;
    my $P2_total_mut=$P2clip_num;
    
    if($P1_depth==0 and $P2_depth==0){
        
    }elsif($P1_total_mut>0 or $P2_total_mut>0 or $P1_depth==0 or $P2_depth==0){
        print OUTPUT "$chr\t$position\t$P1_depth\t$P1_total_mut\t$P2_depth\t$P2_total_mut\n";
    }
}

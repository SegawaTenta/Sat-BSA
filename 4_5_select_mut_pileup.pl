#!/usr/bin/perl -w
use strict;

my $pileup = $ARGV[0];
my $filter_p_value= $ARGV[1];
my $InDel_file= $ARGV[2];


# print "$output_file";

open (FILE, $pileup) or die "cannot open file";
open OUTPUT, ">m_$pileup\n" or die "cannot open file";
open OUTPUT2, ">filter_InDel_size_$pileup\n" or die "cannot open file";
open OUTPUT3, ">m_filter_InDel_size_$pileup\n" or die "cannot open file";

while (my $file = <FILE>) {
    chomp $file;

    my @colom = split (/\s+/, $file);
    my $tig=$colom[0];
    my $posi=$colom[1];
    my $P1_depth=$colom[2];
    my $P2_depth=$colom[4];
    my $p_value=$colom[6];

    if($p_value<$filter_p_value){
        print OUTPUT "$file\n";
    }

    my $mut=0;
    if($P1_depth==0 or $P2_depth==0){

        open (FILE2, $InDel_file) or die "cannot open file";
        while (my $file2 = <FILE2>) {
            chomp $file2;
            my @colom2 = split (/\s+/, $file2);
            my $tigINDEL=$colom2[0];
            my $s_posi=$colom2[1];
            my $e_posi=$colom2[2];

            if($tig eq $tigINDEL){
                # print "$file2\n";
                if($posi>=$s_posi and $posi<=$e_posi){
                    $mut=1;
                }
            }
        }
        close(FILE2);
    }else{
        $mut=1;
    }

    if($mut==1){
        print OUTPUT2 "$file\n";

        if($p_value<$filter_p_value){
            print OUTPUT3 "$file\n";
        }
    }
}

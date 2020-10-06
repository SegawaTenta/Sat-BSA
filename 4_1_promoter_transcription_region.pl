#!/usr/bin/perl -w
use strict;

my $gtf = $ARGV[0];
my $p_size = $ARGV[1];

open (FILE1,$gtf) or die "cannot open file";
open OUTPUT, ">gene_region.txt\n" or die "cannot open file";

my %hash1=();

my $line_count=0;

while (my $file = <FILE1>) {
    chomp $file;
    $line_count++;
    if($file=~/^#/){
    }else{
        my @colom = split (/\t/, $file);
        my $tig=$colom[0];
        my $fueture=$colom[2];
        my $s_posi=$colom[3];
        my $e_posi=$colom[4];
        my $gtf_strand=$colom[6];
        my $id_info=$colom[8];
        # print "$id_info\n";
        my @colom2 = split (/\s+/, $id_info);
        my $id=$colom2[3];
        $id=~s/"//ig;
        $id=~s/\;//ig;

        if($fueture eq "transcript"){
            if($gtf_strand eq "+"){
                if($s_posi>$p_size){
                    my $ps_posi=$s_posi-$p_size;
                    print OUTPUT "$id\t$tig\t$ps_posi\t$e_posi\t$gtf_strand\n";
                }else{
                    print OUTPUT "$id\t$tig\t1\t$e_posi\t$gtf_strand\n";
                }
            }elsif($gtf_strand eq "-"){
                my $pe_posi=$e_posi+$p_size;
                print OUTPUT "$id\t$tig\t$s_posi\t$pe_posi\t$gtf_strand\n";
            }else{
                print OUTPUT "$id\t$tig\t$s_posi\t$e_posi\t$gtf_strand\n";
            }
        }
    }
}

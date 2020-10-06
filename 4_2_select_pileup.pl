#!/usr/bin/perl -w
use strict;

my $gene_region= $ARGV[0];
my $samtools_dir= $ARGV[1];
my $bam_file_1= $ARGV[2];
my $bam_file_2 = $ARGV[3];
my $reference_fasta=$ARGV[4];
my $name=$ARGV[5];
my $InDel_size=$ARGV[6];

open (FILE1, $gene_region) or die "cannot open file";
open (FILE2, "$samtools_dir depth -a $bam_file_1 $bam_file_2 |") or die "cannot open file";
open (FILE3, "$samtools_dir mpileup -f $reference_fasta $bam_file_1 $bam_file_2 |") or die "cannot open file";

open OUTPUT, "> ${name}.pileup\n" or die "cannot open file";
open OUTPUT2, "> InDel_position.txt\n" or die "cannot open file";

my %hash=();
while (my $file = <FILE1>) {
    chomp $file;
    my @colom = split (/\t/, $file);
    my $chr=$colom[1];
    my $sposi=$colom[2];
    my $eposi=$colom[3];

    for(my $i=$sposi;$i<$eposi+1;$i++){
        my $posi="${chr}:${i}";
        $hash{$posi}=1;
    }
}


my $stock_tig="";
my $stock_s_posi=0;
my $stock_e_posi=0;
my $stock_count=0;

while (my $file = <FILE2>) {
    chomp $file;

    my @colom = split (/\t/, $file);
    my $tig=$colom[0];
    my $posi=$colom[1];
    my $P1_depth=$colom[2];
    my $P2_depth=$colom[3];

    my $chr_posi="$tig:$posi";
    my $depth="$P1_depth:$P2_depth";

    if(exists($hash{$chr_posi})){
        $hash{$chr_posi}=$depth;
    }

    if($stock_tig ne $tig and $stock_count >= $InDel_size){
        print OUTPUT2 "$stock_tig $stock_s_posi $stock_e_posi $stock_count\n";
        $stock_tig="";
        $stock_s_posi=0;
        $stock_e_posi=0;
        $stock_count=0;
    }elsif($P1_depth>0 and $P2_depth>0 and $stock_count>=$InDel_size){
        print OUTPUT2 "$stock_tig $stock_s_posi $stock_e_posi $stock_count\n";
        $stock_tig="";
        $stock_s_posi=0;
        $stock_e_posi=0;
        $stock_count=0;
    }elsif($P1_depth==0 and $P2_depth==0 and $stock_count>=$InDel_size){
        print OUTPUT2 "$stock_tig $stock_s_posi $stock_e_posi $stock_count\n";
        $stock_tig="";
        $stock_s_posi=0;
        $stock_e_posi=0;
        $stock_count=0;
    }

    if($P1_depth==0 and $P2_depth==0){
        $stock_tig="";
        $stock_s_posi=0;
        $stock_e_posi=0;
        $stock_count=0;
    }elsif($P1_depth==0 or $P2_depth==0){
        if($stock_count==0){
            $stock_tig=$tig;
            $stock_s_posi=$posi;
            $stock_count++;
        }else{
            $stock_count++;
            $stock_e_posi=$posi;
            # print "$tig\t$posi\t$stock_count\n";
        }
    }elsif($P1_depth>0 or $P2_depth>0){
        $stock_tig="";
        $stock_s_posi=0;
        $stock_e_posi=0;
        $stock_count=0;
    }
}

if($stock_count>=$InDel_size){
    print OUTPUT2 "$stock_tig $stock_s_posi $stock_e_posi $stock_count\n";
}

while (my $file = <FILE3>) {
    chomp $file;

    my @colom = split (/\t/, $file);
    my $tig=$colom[0];
    my $posi=$colom[1];
    my $ref_base=$colom[2];
    # my $P1_depth=$colom[3];
    my $P1_detail=$colom[4];
    # my $P2_depth=$colom[6];
    my $P2_detail=$colom[7];

    my $chr_posi="$tig:$posi";

    if(exists($hash{$chr_posi})){
        # print "$hash{$chr_posi}\n";
        my @colom2 = split (/:/, $hash{$chr_posi});
        # print "$colom2[1]\n";
        my $P1_depth=$colom2[0];
        my $P2_depth=$colom2[1];

        print OUTPUT "$tig\t$posi\t$ref_base\t$P1_depth\t$P1_detail\t$P2_depth\t$P2_detail\n";
    }
}

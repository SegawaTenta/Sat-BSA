#!/usr/bin/perl -w
use strict;

my $match_list=$ARGV[0];
my $compare_list=$ARGV[1];
my $gene_list=$ARGV[2];


open (FILE1, $match_list) or die "cannot open file";
open (FILE2, $compare_list) or die "cannot open file";
open (FILE3, $gene_list) or die "cannot open file";
open OUTPUT, ">filter_InDel_size_DNA_result.txt\n" or die "cannot open file";
my %hash=();
my %hash2=();
my $count=0;

while (my $file = <FILE1>) {
    chomp $file;
    $hash{$file}=1;
}

while (my $file = <FILE2>) {
    chomp $file;
    my $compare=$file;
    $compare=~s/\S+\/m_filter_InDel_size_Fishered_//;
    $compare=~s/\.pileup//g;


    open (FILEs, $file) or die "cannot open file";
    while (my $files = <FILEs>) {
        my @colom = split (/\s+/, $files);
        my $chr=$colom[0];
        my $position=$colom[1];
        my $chr_position="${chr}:${position}";

        if(exists($hash2{$chr_position})){
            my $new_compare="$hash2{$chr_position},$compare";
            # print "$new_compare\n";
            $hash2{$chr_position}=$new_compare;
        }else{
            $hash2{$chr_position}=$compare;
        }
    }
}

while (my $file = <FILE3>) {
    chomp $file;

    my $match="-";
    my $mut="-";
    my %hash3;

    my @colom = split (/\s+/, $file);
    my $id=$colom[0];
    my $chr=$colom[1];
    my $s_posi=$colom[2];
    my $e_posi=$colom[3];
    my $strand=$colom[4];

    for(my $i=$s_posi;$i<$e_posi+1;$i++){
        my $chr_position="${chr}:${i}";

        if(exists($hash{$chr_position})){
            $match="mut";
        }

        if(exists($hash2{$chr_position})){
            my @colom2 = split (/\,/, $hash2{$chr_position});
            for my $aaa(@colom2){
                $hash3{$aaa}=1;
            }
        }
    }

    my $hash3_item_num=my @hash3_item =keys %hash3;
    if($hash3_item_num>0){
        $mut= join("\t", @hash3_item);
    }

    print OUTPUT "$file\t$match\t$mut\n";

}

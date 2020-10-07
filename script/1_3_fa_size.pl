#!/usr/bin/perl

use strict;
use List::Util qw(sum max);

my $name = $ARGV[0];
my $output_name = $name;
$output_name=~s/\.fa/.stat.txt/;

open (FILE,$name) or die "cannot open file";
open OUTPUT, ">${output_name}\n" or die "cannot open file";


my $loopflg = 1;

my (@length, $count,$line_length);

while(my $genome = <FILE>) {
    chomp $genome;

    if ($genome=~/^>/) {
        if($loopflg == 1){$loopflg = 0;}
        else{push (@length, $count);}
        # print "$count\n";
        # print "$genome\n";
        $count = 0;
    }else{
        $line_length=length($genome);
        $count=$count+$line_length;
        # $count += tr/A|a|G|g|C|c|T|t|N|n|U|u//;
    }
}
# print "$count\n";
push (@length, $count);

# ステータス
my $num_contig = scalar(@length);
my $max_length = max(@length);
my $sum_base = List::Util::sum(@length);
my $ave_length = int($sum_base/$num_contig);
# N50
my @length_sorted = sort { $b <=> $a } @length;
my $N50_sum = 0;
my $result = 0;

for (my $i = 0; $i <= $#length_sorted; $i++){
    $N50_sum +=$length_sorted[$i];
    if($N50_sum >= $sum_base/2){
        $result = $i;
        last;
    }
}

# 結果を出力
print OUTPUT "Number of reads\t$num_contig\n";
print OUTPUT "Total sequence (bp)\t$sum_base\n";
print OUTPUT "Max read length (bp)\t$max_length\n";
print OUTPUT "Average  (bp)\t$ave_length\n";
print OUTPUT "N50 (bp)\t$length_sorted[$result]\n";

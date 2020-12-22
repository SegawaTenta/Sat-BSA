#!/usr/bin/perl -w
use strict;

my $fa = $ARGV[0];
my $read_name = $ARGV[1];
my $name = $ARGV[2];

open (FILE, "gzip -dc $fa |") or die "cannot open file";
open (FILE2, $read_name) or die "cannot open file";

open(OUTPUT, ">$name.fa\n") or die "cannot open file";

my %QNAME_hash=();
while (my $genome = <FILE2>) {
    chomp $genome;
    # $genome=~s/^/\@/;
    # print "$genome\n";
    $QNAME_hash{$genome}=1;
}


my $count=0;
my $botan=0;

while (my $genome = <FILE>) {
    chomp $genome;
    $count++;

    if($genome=~/^>/){
      my @colom = split (/\s+/, $genome);
      $colom[0]=~s/^>//;
      if(exists($QNAME_hash{$colom[0]})){
          $botan=1;
      }else{
          $botan=0;
      }
    }

    if($botan==1){
      print OUTPUT "$genome\n";
    }

}

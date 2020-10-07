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
    # print "$genome\n";
    # print "$genome\n";
    if($count%2==1){
        my @colom = split (/\s+/, $genome);
        # my @colom2 = split (/\s+/, $colom[0]);
        $colom[0]=~s/^>//;
        # print "$colom[0]\n";
        if(exists($QNAME_hash{$colom[0]})){
            # print "$colom[0]\n";
            $botan=1;
        }
    }
    
    if(1 <= $botan and $botan <= 2){
        print OUTPUT "$genome\n";
        $botan++;
        # print "$botan\n";
    }else{
        $botan=0;
    }
    
}

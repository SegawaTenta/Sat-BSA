#!/usr/bin/perl -w
use strict;

my $gene  = $ARGV[0];
my $script = $ARGV[1];

open (FILE,$gene) or die "cannot open file";

my $count1=0;
while (my $file = <FILE>) {
    chomp $file;

    my @colom = split (/\t/, $file);
    my $id=$colom[0];
    my $tig=$colom[1];
    my $s_posi=$colom[2];
    my $e_posi=$colom[3];
    my $mut=$colom[5];



        my $script_name=$script;
        $script_name=~s/\S+\///;
        $script_name=~s/^5//;
        $script_name=$id.$script_name;

        open (FILE1,$script) or die "cannot open file";
        open OUTPUT, ">Graph_script/$script_name\n" or die "cannot open file";

        while (my $file1 = <FILE1>) {
            chomp $file1;
            $file1=~s/s_posi/$s_posi/g;
            $file1=~s/e_posi/$e_posi/g;
            $file1=~s/gene_id/$id/g;
            $file1=~s/tig/$tig/g;

            print OUTPUT "$file1\n";

        }

        close(OUTPUT);
        close(FILE1);


}

#!/usr/bin/perl -w
use strict;
use Smart::Comments;

my $input = $ARGV[0];
my $output = $ARGV[1];

open IN,'<',$input ||die "can't open file $input\n";

my %index = ();
while(<IN>){
    chomp;
    my @line = split /\t/,$_;
    my $key = join "\t", $line[0],$line[1],$line[2],$line[5];
    if(!exists $index{$key}{'all'}){
        $index{$key}{'all'} = join "\t",@line[6..11];
        $index{$key}{'max'} = $line[10];
    }else{
        if($index{$key}{'max'} >= $line[10]){
            next;
        }else{
            $index{$key}{'all'} = join "\t",@line[6..11];
            $index{$key}{'max'} = $line[10];
        }
    }
}

open OUT,'>',$output ||die "can't open file $output\n";

for my $keys (sort keys %index){
    print OUT "$index{$keys}{'all'}\n";
}



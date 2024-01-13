#!/usr/bin/perl -w
use strict;
use Smart::Comments;

my $input = $ARGV[0];
my $output = $ARGV[1];

open IN,$input;
open OUT,'>',$output ||die "can't open file $output\n";
while(<IN>){
    chomp;
    my ($chr,$start,$end,$strand,$ID,$sRNA_seq,$pri_seq,$structure) = split /\t/,$_;
    $sRNA_seq =~ tr/tT/uU/;
    $pri_seq =~ /(.*?)$sRNA_seq(.*?)/;
    my $len1 = length($1);
    my $len2 = length ($sRNA_seq);
    my $s2 = $start - $len1;
    my $e2 = $end +(100-$len1-$len2);
    print OUT "$chr\t$start\t$end\t$strand\t$ID\t$sRNA_seq\t$chr\t$s2\t$e2\t$pri_seq\t$structure\n";
}










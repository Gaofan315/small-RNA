#!/usr/bin/perl -w
use strict;
use Smart::Comments;

my $list = $ARGV[0];
my $rnafold = $ARGV[1];
my $fasta = $ARGV[2];

open IN,$list;
my %srna = ();
while(<IN>){
    chomp;
    my ($chr,$start,$end,$id,$point,$strand) = split /\t/,$_;
    #my $value = join "\t",$chr,$start,$end,$strand;
    #my $key = $id;
    $srna{$id} = join "\t",$chr,$start,$end,$strand;
    #print "$chr\t$start\t$end\t$strand\t$id\n";
}

open OUT,'>',"$list.RNAfold" || die "can't open $list.RNAfold";
print OUT "Chr\tStart\tEnd\tStrand\tType\tsRNA.seq\tpre-miRNA.seq\tStructure\n";

my %RNAfold = get_fold($rnafold);
my %fa = get_fa($fasta);

for my $keys(sort keys %srna){
    if(exists $RNAfold{$keys} && exists $fa{$keys}){
        print OUT "$srna{$keys}\t$keys\t$fa{$keys}\t$RNAfold{$keys}{'seq'}\t$RNAfold{$keys}{'fold'}\n";
    }else{next;}
}

sub get_fold{
    my $file = shift;
    my %fold = ();
    my $num = 0;
    my $key = '';
    open IN,$file;
    while(<IN>){
        chomp;
        $num +=1;
        if($num%3 ==1){
            my $id = $_;
            $id =~ s/>//g;
            ($key) = $id; 
        }elsif($num%3 == 2){
            $fold{$key}{'seq'} = $_;
        }elsif($num%3 == 0){
            my ($struc,$value) = split /\s/,$_;
            #$value =~ s/\(\-\d+.\d+\)$//;
            $fold{$key}{'fold'} = $struc;
        }
    }
    return %fold;
}

sub get_fa{
    my $file = shift;
    my %fasta = ();
    my $num = 0;
    my $key = '';
    open IN,$file;
    while(<IN>){
        chomp;
        $num +=1;
        if($num%2 == 1){
            my $id = $_;
            $id =~ s/>//g;
            ($key) = $id;
        }elsif($num%2 == 0){
            $fasta{$key} = $_;
        }
    }
    return %fasta;
}


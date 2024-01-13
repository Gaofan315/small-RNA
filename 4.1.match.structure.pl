#!/usr/bin/perl -w
use strict;
use Smart::Comments;





    my $siRNA_file = $ARGV[0];
    open IN1,$siRNA_file;
    my %hash = ();
    while (<IN1>) {
        chomp;
        my ($chr,$s1,$e1,$strand1,$score,undef,$s2,$e2,undef,$seq,$structure) = split /\s+/,$_;
        my $new_str = $structure;
        if ($strand1 eq "-") {
            $new_str = get_complementary($structure);
        }
        my $ind0 = $s1 - $s2;
        my $ind1 = $e1 - $s2;
        my $len = $e2 - $s2 +1;
        ### $chr
        ### $s1
        ### $e1
        ### $strand1
        ### $s2
        ### $e2
        ### $structure
        ### $new_str
        ### $ind0
        ### $ind1
        ### $len
        my @lines = split //, $new_str;
        my $tmp = @lines;
        ### $tmp
        
        #extact the ind0 and ind1 and try to find the opposite one;
        my $seq0 = $lines[$ind0];
        my $seq1 = $lines[$ind1];
        ### $seq0
        ### $seq1
        
        my ($news1,$newe1) = ("NA","NA");
        if ( ($s1+$e1) < ($s2+$e2)) {
            my $sub0 = substr($new_str,0,$ind0+1);
            my $sub1 = substr($new_str,0,$ind1+1);
            #count number of "("
            ### $sub0
            ### $sub1
            my $num0 = 0;
            my $num1 = 0;
            if ($sub0 =~ /\(/) {
                $num0 = ($sub0 =~ s/\(/#/g);
            }
            if ($sub1 =~ /\(/) {
                $num1 = ($sub1 =~ s/\(/#/g);
            }
            ### $sub0
            ### $sub1
            ### $num0
            ### $num1
            my $counti = 0;
            my $k = $#lines;
            while ($k > 0) {
                my $tmpi = pop @lines;
                if ($tmpi eq ")") {$counti ++; }
                if ($counti eq $num0) {
                    $newe1 = $k;
                }
                elsif ($counti eq $num1) {
                    $news1 = $k;
                    last;
                }
                $k--;
            }
            ### type1
            ### $news1
            ### $newe1
        }
        elsif ( ($s1+$e1) > ($s2+$e2) ) {
            my $sub0 = substr($new_str,$ind1,$len-$ind1);
            my $sub1 = substr($new_str,$ind0,$len-$ind0);
            #count number of ")"
            ### $sub0
            ### $sub1
            my $num0 = 0; my $num1 = 0;
            if ($sub0 =~ /\)/) {$num0 = ($sub0 =~ s/\)/#/g);}
            if ($sub1 =~ /\)/) {$num1 = ($sub1 =~ s/\)/#/g);}
            ### $sub0
            ### $sub1
            ### $num0
            ### $num1
            my $counti = 0;
            my $k = 0;
            while ($k <= 100) {
            #while ($k <= $#lines) {
                my $tmpi = shift @lines;
                if ($tmpi eq "(") {$counti ++; }
                if ($counti eq $num0) {
                    $newe1 = $k;
                }elsif ( $counti eq $num1 ) {
                    $news1 = $k;
                    last;
                }
                $k++;
            }
            ### type2
            ### $news1
            ### $newe1

        }

        if ($news1 ne "NA" and $newe1 ne "NA") {
            my $cs = $s2 + $news1;
            my $ce = $s2 + $newe1;
            if ($cs > $ce) {my $tmpi = $cs; $cs = $ce; $ce = $tmpi;}
            print "$_\t$cs\t$ce\n";
        }else {
            print "$_\tNA\tNA\n";
        }



    } 
    close IN1;

        


sub get_complementary {
    my $str = shift;
    $str =~ tr/\)/A/;
    $str =~ tr/\(/\)/;
    $str =~ tr/A/\(/;
    my $rev_str = reverse $str;
    return $rev_str;

}

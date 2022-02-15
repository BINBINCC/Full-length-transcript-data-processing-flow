#!/usr/bin/perl
use warnings;
#2021.03.29

($#ARGV==2) or die "Usage: perl $0 overlap.0.9.result overlap.0.9.result.isoname stat_list_basedBED5_isoform_cov_gene_num\n";

#Based on bed5 file
##overlap.0.9.result
#A01    445524  447994  ID=BraA01g000950.3C     A01     445272  453750  PB.1494.1
#A01    451636  452160  ID=BraA01g000960.3C     A01     445272  453750  PB.1494.1
#A01    451636  452160  ID=BraA01g000960.3C     A01     448167  453750  PB.1494.2
#A01    451636  452160  ID=BraA01g000960.3C     A01     448545  453750  PB.1494.3
#A01    451636  452160  ID=BraA01g000960.3C     A01     448768  453744  PB.1494.4

my %allisoform;
my @isoform;

open IN1, "$ARGV[1]" or die  "cannot open $ARGV[1] the file";
while(<IN1>){
        chomp;
        my $id = $_;
        push (@isoform,$id);
#       $allisoform{$id}="";
}

#my %temp_hash;
#@isoform = grep { ++$temp_hash{$_} < 2} @isoform;

open IN, "$ARGV[0]" or die  "cannot open $ARGV[0] the file";
while(<IN>){
        chomp;
        my @temp = split(/\s+/,$_);
        if($temp[4] eq $temp[9]){
        if (grep /$temp[8]/ ,@isoform){
                push (@{$allisoform{$temp[8]}} , $temp[3]);
        }
}
open OUT,">$ARGV[2]" or die "cannot write $ARGV[2] the file";

#for my $id (keys %allisoform){
#       print OUT "$id: @{ $allisoform{$id} }\n";
#}

#按照覆盖基因的个数进行排序
for my $id (sort { @{ $allisoform{$a} } <=> @{ $allisoform{$b} } } keys %allisoform){
        print OUT "$id:", join(","=> sort @{ $allisoform{$id} }),"\n";
}

close OUT;
close IN;

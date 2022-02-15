#!/user/bin/bash
###Statistics information
#isoform VS loci
#Usage:
#<sh 03.Align_FLisoformToGene.sh flnc.correct.collapsed.group.txt Brapa_genome_v3.0_genes.bed5 flnc.correct.collapsed.gff overlap.0.9.result>

collapsed_group_txt=$1   #"File from the Collapse redundant isoforms step"
genome_bed=$2            #"Reference genome BED file"
collapsed_gff=$3         #"File from the Collapse redundant isoforms step"
collapsed_bed=${collapsed_gff%.gff}.bed5
overlap_90_result=$4

#collapsed isoform number
coll_iso_num=`wc -l $collapsed_group_txt`
echo "isoform number: $coll_iso_num"

#PB.x isoform number
coll_iso_uniq_num=`cat $collapsed_group_txt | cut -f1 | grep "\.1$" | wc -l`
echo "uniq isoform number: $coll_iso_uniq_num"

#build bed file
cat $collapsed_gff | grep -v exon | cut -f 1,4,5,7,9 | awk  '{print $1"\t"$2"\t"$3"\t"$8"\t"$4}'  | sed -e 's/\"//g' | sed -e 's/\;//g' > $collapsed_bed

bedtools intersect -a $genome_bed -b $collapsed_bed -wa -wb -f 0.9 > $overlap_90_result

#isoform coverage the number of gene
iso_cov_gene_num=`cat $overlap_90_result | cut -f 4 | uniq | wc -l`

#isoform coverage the number of isoform
iso_cov_iso_num=`cat $overlap_90_result | cut -f 8 |sort | uniq | wc -l`

#single isoform coverage multipe gene file
cat $overlap_90_result | cut -f 4|sort| uniq > overlap.0.9.result.genename
cat $overlap_90_result | cut -f 9|sort| uniq > overlap.0.9.result.isoname

#statistics list : single isoform cov multipe gene
perl summary_list_isoform_cov_gene.bed5.pl $overlap_90_result overlap.0.9.result.isoname stat_list_basedBED5_isoform_cov_gene_num

cat stat_list_basedBED5_isoform_cov_gene_num | awk -F "," '{print NF"  "$0}' > stat_list_basedBED5_isoform_cov_gene_num.covgenenum

##
cat stat_list_basedBED5_isoform_cov_gene_num |awk -F "," '{if(NF == 1) print $0}' > stat_list_basedBED5_isoform_cov_gene_num.1cover
cat stat_list_basedBED5_isoform_cov_gene_num |awk -F "," '{if(NF == 2) print $0}' > stat_list_basedBED5_isoform_cov_gene_num.2cover
cat stat_list_basedBED5_isoform_cov_gene_num |awk -F "," '{if(NF == 3) print $0}' > stat_list_basedBED5_isoform_cov_gene_num.3cover
cat stat_list_basedBED5_isoform_cov_gene_num |awk -F "," '{if(NF == 4) print $0}' > stat_list_basedBED5_isoform_cov_gene_num.4cover
cat stat_list_basedBED5_isoform_cov_gene_num |awk -F "," '{if(NF >= 5) print $0}' > stat_list_basedBED5_isoform_cov_gene_num.5cover

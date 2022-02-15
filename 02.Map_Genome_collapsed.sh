##Alignment of PacBio reads to genome
minimap2 -ax splice -uf -C5 -O6,24 -B4 -t 10 Brapa_sequence_v3.0.fasta flnc.correct.fasta > flnc.correct.sam
##Unique alignment
cat flnc.correct.sam |grep -v @ | grep -v -w -E '256|272|2048|2064' | awk '{if($2 != 4) print $0}' > flnc.correct.uniq.sam
##Collapse redundant isoforms
collapse_isoforms_by_sam.py --input flnc.correct.fasta -s flnc.correct.sam --dun-merge-5-shorter --max_3_diff 500 --min-coverage 0.90 --min-identity 0.90 -o flnc.correct.collapsed
##GFF to GFF3
gffread flnc.correct.collapsed.gff -o- > flnc.correct.collapsed.gff3

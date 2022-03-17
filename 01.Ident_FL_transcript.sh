##Get the Circular Consensus Calling reads
ccs subreads.bam ccs.bam  --noPolish --min-passes 3
##Rmove the primer and barcode
lima ccs.bam barcoded_primers.fasta demux.ccs.bam --isoseq --no-pbi --peek-guess
##Rapid concatemer identificaton and removal
isoseq3 refine demux.ccs.bam barcoded_primers.fasta flnc.bam --require-polya
##Bam file to Fasta file
samtools view flnc.bam -O SAM | awk -F"\t" '{print ">"$1"\n"$10}' > flnc.fa
##Data correction
lordec-correct -T 20 -2 allreads_1.fastq,allreads_2.fastq -k 19 -s 3 -i flnc.fasta -o flnc.correct.fasta

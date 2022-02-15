# Basic process for processing full-length transcript data
This includes the identification of full-length transcripts and the comparison of reference genome.
## PacBio sequencing data processing and error correction
`sh 01.Ident_FL_transcript.sh`

The PacBio-seq raw reads were filtered into circular consensus sequence (CCS) subreads using SMRTLink (https://github.com/PacificBiosciences/IsoSeq/). After quality evaluation, CCS subreads were processed to generate the ROIs with a minimum full pass of 1. The pipeline then classified the ROIs in terms of full-length non-chimeric (FLNC) and non-full-length reads. This was done by identifying the 5′ and 3′ adapters used in the library preparation as well as the poly(A) tail. Only reads that contained all three in the expected arrangement and did not contain any additional copies of the adapter sequence within the DNA fragment were classified as FLNC reads. Then, the FLNC reads were corrected using LoRDEC (version 0.9).
## Map of PacBio reads to the reference genome and collapse
`sh 02.Map_Genome_collapsed.sh`

All FLNC reads were mapped to the reference genome using minimap2 (version 2.15) software. Only the best alignments (the largest alignment with the lowest number of mismatches against the reference genome) were kept. Then the retained FLNC reads were collapsed into full-length non-redundant consensus isoforms using a Python script (collapse_isoforms_by_sam.py) in the Cupcake program (version 19.0.0) (https://github.com/Magdoll/cDNA_Cupcake/wiki/Cupcake:-supporting-scripts-for-Iso-Seq-after-clustering-step#collapse) with parameters of coverage > 0.90 and identity > 0.90.
## Alignment of FL isoform to the annotated genes and Statistics information
`sh 03.Align_FLisoformToGene.sh`

All collapsed Full-lenght isoform were aligned to annotated genes using SHELL script and statistics information.

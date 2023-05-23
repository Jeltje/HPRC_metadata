#! /bin/bash

# download latest table as tsv:
#https://docs.google.com/spreadsheets/d/1y0LujKGvaNNn1YINX6cnUIjxefjkcZbHjYJzaCRhMWE/edit#gid=1219603661

#crlf_replace.sh HPRC_sheet.tsv
# remove header
#tail -n +2 HPRC_sheet.tsv > this; mv this HPRC_sheet.tsv
#grep -w UW HPRC_sheet.tsv | grep -w YR3 > expected.samples
# this gives 24 expected samples but there are only 21 at
# https://s3-us-west-2.amazonaws.com/human-pangenomics/index.html?prefix=submissions/5c68b972-8534-402f-9861-11c93558765f--UW_HPRC_HiFi_Y3/
# the list is in UWY3.samples
# Julian says (2/7/2023) that UW will upload the last three samples by this evening

# this is what's on the google cloud side (empty before copied)
# gsutil -u hpp-ucsc ls gs://fc-4310e737-a388-4a10-8c9e-babe06aaf0cf/submissions/5c68b972-8534-402f-9861-11c93558765f--UW_HPRC_HiFi_Y3/

# and this is the s3 source
#aws s3 ls s3://human-pangenomics/submissions/5c68b972-8534-402f-9861-11c93558765f--UW_HPRC_HiFi_Y3/

# the copying happens using instructions at 
# https://ucsc-cgl.atlassian.net/wiki/spaces/~63c888081d7734b550c2052b/pages/2327183361/Uploading+Syncing+HPRC+Submissions#Sync-Data-From-S3-to-GCP
# this takes a while (next time make sure not to copy subread data)

# this is the workspace bucket for this project: fc-c2424fa0-8b70-4a0a-bd92-598d9fa71260
#cut -f2 expected.samples | cut -f1 -d' ' > UW_HPRC_HiFi_Y3.csv
#gsutil cp UW_HPRC_HiFi_Y3.csv gs://fc-c2424fa0-8b70-4a0a-bd92-598d9fa71260
#gsutil ls gs://fc-c2424fa0-8b70-4a0a-bd92-598d9fa71260
# gs://fc-c2424fa0-8b70-4a0a-bd92-598d9fa71260/UW_HPRC_HiFi_Y3.csv

# check that we have the subread files in the correct location (some are in the regular submissions space where they don't belong)
#aws s3 ls human-pangenomics/backup/submissions/5c68b972-8534-402f-9861-11c93558765f--UW_HPRC_HiFi_Y3/ --recursive --profile pgdev > backup.files
#aws s3 ls human-pangenomics/submissions/5c68b972-8534-402f-9861-11c93558765f--UW_HPRC_HiFi_Y3/ --recursive --profile pgdev | grep subreads.bam > subm.subreads
# there are 8 subreads files in the submissions
# it also looks like one of the subreads files occurs in multiple samples
#sed 's/.*\///' backup.files | grep -c subreads
#sed 's/.*\///' backup.files | sort -u | grep -c subreads
#sed 's/.*\///' backup.files | grep subreads | uniq -c | grep -v ' 1 '
#sed 's/.*\///' backup.files | grep subreads | sort | uniq -c | grep m64076_220216_013707
#sed 's/.*\///' backup.files | grep subreads | sort -u > have
#sed 's/.*\///' subm.subreads | grep subreads | sort -u > want
#comm -12 have want # all subreads files in the submissions are in the backup

# other duplicates in the backups:
#aws s3 ls human-pangenomics/backup/submissions  --recursive --profile pgdev > allbk
#grep "subreads.bam$" allbk | sed 's/.*\///' | sort | uniq -c | sort -n | grep -v ' 1 ' | awk '{print $2}' > subread.dups
#for i in $(cat subread.dups); do grep "$i$" allbk; echo; done #| awk '{print $4}'

# following along with https://ucsc-cgl.atlassian.net/wiki/spaces/~63c888081d7734b550c2052b/pages/2333147137/Upload+Reads+To+SRA
# Copied the list of filenames (first column of UW metadata.xlsx)

#gsutil -u hpp-ucsc ls -r gs://fc-4310e737-a388-4a10-8c9e-babe06aaf0cf/submissions/5c68b972-8534-402f-9861-11c93558765f--UW_HPRC_HiFi_Y3/ > this
#grep hifi_reads.bam$ this | sed 's/.*UW_HPRC_HiFi_Y3\///' | sort > have
#head have want
#sort metadata.ids > want
#head have want
#wc -l have want
#comm -3 have want
# HG03017/m64076_221001_041132-bc1012.hifi_reads.bam does not appear to be on gs
# is it on s3?
#aws s3 ls human-pangenomics/submissions/5c68b972-8534-402f-9861-11c93558765f--UW_HPRC_HiFi_Y3/HG03017/ --profile pgdev
# nope

# sex info from pedigree file
#wget ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/technical/working/20130606_sample_info/20130606_g1k.ped

# create biosample and metadata files for upload to SRA
#./sra_metadata.py UW_HPRC_HiFi_Y3_metadata.txt 
# note: later renamed to match original: HPRC_PacBio_HiFi_Metadata_Submission_UW_Yr3.tsv
#mv sra_biosample_UW_HPRC_HiFi_Y3_metadata.txt  sra_metadata_UW_HPRC_HiFi_Y3_metadata.txt ~/Documents/Miga

# sra upload (SUB12950574) gets two errors

#File "submissions/5c68b972-8534-402f-9861-11c93558765f--UW_HPRC_HiFi_Y3/NA18522/m54329U_220607_194753-bc2021.hifi_reads.bam" is corrupted. Please reupload the file and resubmit submission.
#File "submissions/5c68b972-8534-402f-9861-11c93558765f--UW_HPRC_HiFi_Y3/NA20905/m64076_220916_183810-bc2060.hifi_reads.bam" is corrupted. Please reupload the file and resubmit submission.

# this is where I realize I made a big mistake. I should have uploaded the 5mc files, not the hifi.
# the Biosample part went through
# Solution: Make a new submission but upload the samples with their biosaple_accession instead of their sample_name
#sed -i 's/hifi_reads.bam/5mc.hifi_reads.bam/g'  ~/Documents/Miga/sra_metadata_UW_HPRC_HiFi_Y3_metadata.txt
# now we need to add a biosample_accession column
#echo 'biosample_accession' > this
#for i in $(cut -f1 ~/Documents/Miga/sra_metadata_UW_HPRC_HiFi_Y3_metadata.txt | tail -n +2 ); do 
#    grep $i UW_HPRC_HiFi_Y3_biosamples.tsv | cut -f1 >> this
#done
#wc -l this ~/Documents/Miga/sra_metadata_UW_HPRC_HiFi_Y3_metadata.txt
#paste this ~/Documents/Miga/sra_metadata_UW_HPRC_HiFi_Y3_metadata.txt | cut -f1,3- > ~/Documents/Miga/sra_metadata_UW_HPRC_HiFi_Y3_withBiosample.txt
# Made a new accession SUB12971042 using this last file instead of the metadata
# This went through quickly.
# Emailed help desk to ask for withdrawal of SRA section of first submission
#gsutil cp metadata-12971042-processed-ok.tsv gs://fc-c2424fa0-8b70-4a0a-bd92-598d9fa71260
#gsutil cp UW_HPRC_HiFi_Y3_metadata.txt gs://fc-c2424fa0-8b70-4a0a-bd92-598d9fa71260
# Run the mergeSRAMetaReadstats.ipynb analysis and download the final file
#gsutil cp gs://fc-c2424fa0-8b70-4a0a-bd92-598d9fa71260/UW_HPRC_HiFi_Y3_post_sra_metadata.tsv .
# and clean up
#mkdir UW_HPRC_HiFi_Y3
#mv metadata-12971042-processed-ok.tsv UW_HPRC_HiFi_Y3_SRA.tsv  UW_HPRC_HiFi_Y3_biosamples.tsv  UW_HPRC_HiFi_Y3_post_sra_metadata.tsv UW_HPRC_HiFi_Y3

# get the notebooks
gsutil cp gs://fc-c2424fa0-8b70-4a0a-bd92-598d9fa71260/notebooks/*ipynb UW_HPRC_HiFi_Y3

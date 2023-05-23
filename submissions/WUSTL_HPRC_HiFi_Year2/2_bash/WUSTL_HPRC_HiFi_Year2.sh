#! /bin/bash


##### ignore this for now, this is fora  different project ###
#https://s3-us-west-2.amazonaws.com/human-pangenomics/index.html?prefix=backup/submissions/b544dcc2-9e98-4cfb-b19e-0cda52a97541--WUSTL_HPRC_HiFi_Year2/HG00423/PacBio_HiFi/
##############################################################
#HPRC_WRANGLING_WUSTL_HPRC_HiFi_Year2

#https://s3-us-west-2.amazonaws.com/human-pangenomics/index.html?prefix=submissions/b544dcc2-9e98-4cfb-b19e-0cda52a97541--WUSTL_HPRC_HiFi_Year2/


#HPRC_WRANGLING_UW_HPRC_HiFi_Y2
## submitted to SRA as SRR18189665 (submission SUB11121843)

workspace_bucket='gs://fc-089d894b-6682-450d-8031-f17732e5ece5'
uuid='b544dcc2-9e98-4cfb-b19e-0cda52a97541--WUSTL_HPRC_HiFi_Year2'
gsBase='gs://fc-4310e737-a388-4a10-8c9e-babe06aaf0cf/submissions'
awsBase='s3://human-pangenomics/submissions'
# aws html:https://s3-us-west-2.amazonaws.com/human-pangenomics/index.html?prefix=submissions

#aws s3 ls $awsBase/$uuid/ --profile pgdev | awk '{print $2}' | sed 's/\///' | grep HG | sort > s3.samples
#aws s3 ls $awsBase/$uuid/ --recursive --profile pgdev > s3.allfiles
#gsutil -u hpp-ucsc ls $gsBase/$uuid | sed 's/\/$//' | sed 's/.*\///' | grep HG | sort > gs.samples 
#wc -l s3.samples gs.samples # 25

# 82 entries
metadata='HPRC_PacBio_HiFi_Metadata_Submission_WUSTL_Year2_v0.2.tsv'
#cut -f3 $metadata | sort -u | grep HG| wc -l # 25

sra_meta='metadata-11121843-processed-ok.tsv'
#cut -f6 $sra_meta | grep HG | sort -u | wc -l # 25

#grep hifi_reads.bam$ s3.allfiles | sed 's/.*\///' | sort > want # 89
#for i in $(cat $sra_meta); do echo $i; done | grep hifi_reads.bam | sort > have # 89

#wc -l want have
#comm -3 want have # empty

#gsutil cp gs.samples $workspace_bucket/WUSTL_HPRC_HiFi_Year2_samples.tsv
#gsutil cp $sra_meta $workspace_bucket 
#gsutil cp $metadata $workspace_bucket

# Run the mergeSRAMetaReadstats.ipynb analysis and download the final file
#gsutil cp gs://fc-089d894b-6682-450d-8031-f17732e5ece5/WUSTL_HPRC_HiFi_Year2_post_sra_metadata.tsv .

# and clean up
#mkdir WUSTL_HPRC_HiFi_Year2
#mv HPRC_PacBio_HiFi_Metadata_Submission_WUSTL_Year2_v0.2.tsv WUSTL_HPRC_HiFi_Year2_post_sra_metadata.tsv metadata-11121843-processed-ok.tsv WUSTL_HPRC_HiFi_Year2

# get the notebooks
gsutil cp $workspace_bucket/notebooks/*ipynb WUSTL_HPRC_HiFi_Year2

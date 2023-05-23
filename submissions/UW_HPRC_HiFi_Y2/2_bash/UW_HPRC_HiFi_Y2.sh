#! /bin/bash

#HPRC_WRANGLING_UW_HPRC_HiFi_Y2
# submitted to SRA as SRR18158610 (submission SUB11130351)

workspace_bucket='gs://fc-21b07b99-b484-46a3-91e0-9f4bf83ab3aa'
uuid='57361110-d079-4bb0-ac49-b4f6e0407fc0--UW_HPRC_HiFi_Y2/'
gsBase='gs://fc-4310e737-a388-4a10-8c9e-babe06aaf0cf/submissions'
awsBase='s3://human-pangenomics/submissions'
# aws html:https://s3-us-west-2.amazonaws.com/human-pangenomics/index.html?prefix=submissions

#aws s3 ls $awsBase/$uuid --profile pgdev | awk '{print $2}' | sed 's/\///' | grep HG | sort > s3.samples
#aws s3 ls $awsBase/$uuid --recursive --profile pgdev > s3.allfiles
#gsutil -u hpp-ucsc ls $gsBase/$uuid | sed 's/\/$//' | sed 's/.*\///' | grep HG | sort > gs.samples 
#wc -l s3.samples gs.samples # 21

# 82 entries
metadata='220118_HPRC_PacBio_HiFi_Metadata_Submission_v0.2_UW_wh_km.tsv'
#cut -f3 $metadata | sort -u | grep HG| wc -l # 21

sra_meta='metadata-11130351-processed-ok.tsv'
#cut -f6 $sra_meta | grep HG | sort -u | wc -l # 20 - missing HG02572

#grep hifi_reads.bam s3.allfiles | sed 's/.*\///' | sort > want # 82
#for i in $(cat $sra_meta); do echo $i; done | grep hifi_reads.bam | sort > have # 80

#comm -3 want have
#m54329U_210527_060352.hifi_reads.bam
#m64076_210502_044702.hifi_reads.bam

#gsutil cp gs.samples $workspace_bucket/UW_HPRC_HiFi_Y2_samples.tsv

#gsutil cp $sra_meta $workspace_bucket 
#gsutil cp $metadata $workspace_bucket

# Run the mergeSRAMetaReadstats.ipynb analysis and download the final file
#gsutil cp gs://fc-21b07b99-b484-46a3-91e0-9f4bf83ab3aa/UW_HPRC_HiFi_Y2_post_sra_metadata.tsv .

# and clean up
#mkdir UW_HPRC_HiFi_Y2
#mv 220118_HPRC_PacBio_HiFi_Metadata_Submission_v0.2_UW_wh_km.tsv UW_HPRC_HiFi_Y2_post_sra_metadata.tsv metadata-11130351-processed-ok.tsv UW_HPRC_HiFi_Y2

# get the notebooks
gsutil cp $workspace_bucket/notebooks/*ipynb UW_HPRC_HiFi_Y2

HPRC_PacBio_HiFi_Metadata_Submission_v0.5_WUSTL.txC_PacBio_HiFi_Metadata_Submission_v0.5_WUSTL.tsv

#HPRC_WRANGLING_WUSTL_HPRC_HiFi_Year1
# Submitted to SRA as SUB9061008 (to which I do not have access)

workspace_bucket='gs://fc-888bd569-6e57-439d-b69d-943f184cf8cb'
uuid='4d711a5a-8a5c-4ca9-9251-91d6c0998ad9--WUSTL_HPRC_HiFi'
gsBase='gs://fc-4310e737-a388-4a10-8c9e-babe06aaf0cf/submissions'
awsBase='s3://human-pangenomics/submissions'
# aws html:https://s3-us-west-2.amazonaws.com/human-pangenomics/index.html?prefix=submissions

sra_meta='metadata-9061008-processed-ok.tsv'
#cut -f6 $sra_meta | grep HG | sort -u | grep -v sample | wc -l # 20 

metadata='HPRC_PacBio_HiFi_Metadata_Submission_v0.5_WUSTL.tsv'
#cut -f3 $metadata | sort -u | grep -v sample | wc -l # 37
# the extra 17 are HPRC plus samples

#aws s3 ls $awsBase/$uuid/ --profile pgdev | awk '{print $2}' | sed 's/\///' | grep HG | sort > s3.samples
#aws s3 ls $awsBase/$uuid/ --recursive --profile pgdev > s3.allfiles
#gsutil -u hpp-ucsc ls $gsBase/$uuid | sed 's/\/$//' | sed 's/.*\///' | grep HG | sort > gs.samples 
#wc -l s3.samples gs.samples # 20

#grep ccs.bam$ s3.allfiles | sed 's/.*\///' | sort > want # 80
#for i in $(cat $sra_meta); do echo $i; done | grep ccs.bam | sort > have # 80
#head want have

#wc -l want have
#comm -3 want have # empty

# So we have 17 extra samples in the submitter metadata that aren't anywhere else. Ignore for now.
#gsutil cp gs.samples $workspace_bucket/WUSTL_HPRC_HiFi_Year1_samples.tsv
#gsutil cp $sra_meta $workspace_bucket 
#gsutil cp $metadata $workspace_bucket

# Run the mergeSRAMetaReadstats.ipynb analysis and download the final file
#gsutil cp $workspace_bucket/WUSTL_HPRC_HiFi_Year1_post_sra_metadata.tsv .

# and clean up
#mkdir WUSTL_HPRC_HiFi_Year1
#mv $sra_meta $metadata WUSTL_HPRC_HiFi_Year1_post_sra_metadata.tsv WUSTL_HPRC_HiFi_Year1

# get the notebooks
gsutil cp $workspace_bucket/notebooks/*ipynb WUSTL_HPRC_HiFi_Year1

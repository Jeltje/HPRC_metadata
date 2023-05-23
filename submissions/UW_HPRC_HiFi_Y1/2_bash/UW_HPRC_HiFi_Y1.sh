#! /bin/bash

#48f9717b-23c6-4045-a33f-10a3df8fc924--UW_HPRC_HiFi/
# submitted to SRA as SRR13684290 (submission ??); I don't have access to it.
# Julian copied the sra_metadata for me

workspace_bucket='gs://fc-ed02327c-c4c0-4a7a-8339-50e7ebe38ce5'
uuid='48f9717b-23c6-4045-a33f-10a3df8fc924--UW_HPRC_HiFi/'
gsBase='gs://fc-4310e737-a388-4a10-8c9e-babe06aaf0cf/submissions'
awsBase='s3://human-pangenomics/submissions'
# aws html:https://s3-us-west-2.amazonaws.com/human-pangenomics/index.html?prefix=submissions

#aws s3 ls $awsBase/$uuid --profile pgdev | awk '{print $2}' | sed 's/\///' | sort > s3.samples
#aws s3 ls $awsBase/$uuid --recursive --profile pgdev > s3.allfiles
#gsutil -u hpp-ucsc ls $gsBase/$uuid | sed 's/\/$//' | sed 's/.*\///' | sort > gs.samples 
#wc -l s3.samples gs.samples # 11 and 'release-transfer-manifests'
#diff s3.samples gs.samples # same
#grep -v release-transfer-manifests gs.samples > this; mv this gs.samples

metadata='201112_UW_HPRC_PacBio_HiFi_Metadata_Submission_v0.2_kmmod.tsv'
sra_meta='metadata-8323615-processed-ok.tsv'
#cut -f3 $metadata | sort -u | grep -v sample | wc -l # 11 samples
#grep ccs.bam$ s3.allfiles | sed 's/.*\///' | sort > want # 47 files
# m54329U_201103_231616.ccs.bam is on s3 but not in the submitter metadata
# it's a HG002 sample. Another HG002 sample, m64076_201016_191536.ccs.bam, IS present in the submitter metadata

#gsutil cp gs.samples $workspace_bucket/UW_HPRC_HiFi_samples.tsv
#gsutil cp $metadata $workspace_bucket
#gsutil cp $sra_meta $workspace_bucket 

# problem with creating NTSM table: Whether we're using cram or fastq files, we're missing
#'HG002', 'HG01123', 'HG02486', 'HG02559'
# replaced with hic/child_ilm from AnVIL_HPRC (see Generate_Terra_Tables_HiFi_QC.ipynb), then 
# cut off (the 36) HG002 files to the first 16 to avoid duplicate filenames
# then run NTSM


# Run the mergeSRAMetaReadstats.ipynb analysis and download the final file
#gsutil cp $workspace_bucket/UW_HPRC_HiFi_Y1_post_sra_metadata.tsv .

# and clean up
#mkdir UW_HPRC_HiFi_Y1
#mv $sra_meta $metadata UW_HPRC_HiFi_Y1_post_sra_metadata.tsv UW_HPRC_HiFi_Y1

# get the notebooks
#gsutil cp $workspace_bucket/notebooks/*ipynb UW_HPRC_HiFi_Y1

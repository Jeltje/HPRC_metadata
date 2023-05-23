#! /bin/bash

#HPRC_WRANGLING_WUSTL_HPRC_HiFi_Year3/data

#https://s3-us-west-2.amazonaws.com/human-pangenomics/index.html?prefix=submissions/c0de0f97-f422-4057-90bd-12b40869d30a--WUSTL_HPRC_HiFi_Year3

# Julian, slack, 2/16/2023:
#Notice that there is one sample with a crazy name: MGISTL_PAN027_HG06807/
#This sample is alternatively called PAN027 and HG06807
# I don't believe it is actually part of the Y3 efforts. That being said, we should wrangle it anyway.

# 79 lines in file
#cut -f1 WUSTL_HPRC_HiFi_Year3_metadata.tsv | sort -u | wc -l # all 79 are unique hifi bam files
#cut -f3 WUSTL_HPRC_HiFi_Year3_metadata.tsv | sort -u | wc -l # 22 unique samples (yes I'm subtracting the header)
# note: later renamed this file to HPRC_Y3_WUSTL_PacBio_HiFi_Metadata_Submission_WUSTL_v0.1.tsv, matching the original
#aws s3 ls s3://human-pangenomics/submissions/c0de0f97-f422-4057-90bd-12b40869d30a--WUSTL_HPRC_HiFi_Year3/ --profile pgdev > s3.samples
#aws s3 ls s3://human-pangenomics/submissions/c0de0f97-f422-4057-90bd-12b40869d30a--WUSTL_HPRC_HiFi_Year3/ --recursive --profile pgdev> s3.allfiles
# 22 samples, 158 files
#grep -c hifi_reads.bam$ s3.allfiles # 79 files (promising)
#cut -f1 WUSTL_HPRC_HiFi_Year3_metadata.tsv | sort -u > want
#sed 's/.*\///' s3.allfiles | grep bam$ | sort > have
#comm -3 have want # perfect, everything is there.

# they haven't been copied to gs yet, but check:
#gsutil -u hpp-ucsc ls gs://fc-4310e737-a388-4a10-8c9e-babe06aaf0cf/submissions/c0de0f97-f422-4057-90bd-12b40869d30a--WUSTL_HPRC_HiFi_Year3 > gs.samples # nothing

# started aws instance jeltje-test
# ssds staging sync --submission-id c0de0f97-f422-4057-90bd-12b40869d30a --deployment default --dst-deployment gcp &> sync_WUSTL_HPRC_HiFi_Year3.txt
#gsutil -u hpp-ucsc ls -r gs://fc-4310e737-a388-4a10-8c9e-babe06aaf0cf/submissions/c0de0f97-f422-4057-90bd-12b40869d30a--WUSTL_HPRC_HiFi_Year3 > gs.samples
#grep -c hifi_reads.bam$ gs.samples # 79, perfect
#awk '{print $2}' s3.samples | sed 's/\///' > WUSTL_HPRC_HiFi_Year3.csv
#gsutil cp WUSTL_HPRC_HiFi_Year3.csv gs://fc-a7e6ae6b-860b-4519-80a5-277aeb967124/

# when running Readstats, one job died because of a truncated bam file:
# gs
#PRC_HiFi_Year3/HG02015/PacBio_HiFi/m64043_210905_032603-bc1022.5mc.hifi_reads.bam
#TOTAL: 1 objects, 77510737920 bytes (72.19 GiB)
# s3
#2022-07-25 21:09:02 144419844103 m64043_210905_032603-bc1022.5mc.hifi_reads.bam
# This is due to a timeout error during the copying
# redid the sync

#gsutil -u hpp-ucsc ls -l gs://fc-4310e737-a388-4a10-8c9e-babe06aaf0cf/submissions/c0de0f97-f422-4057-90bd-12b40869d30a--WUSTL_HPRC_HiFi_Year3/HG02015/PacBio_HiFi/m64043_210905_032603-bc1022.5mc.hifi_reads.bam
#144419844103  2023-03-03T19:07:22Z  gs://fc-4310e737-a388-4a10-8c9e-babe06aaf0cf/submissions/c0de0f97-f422-4057-90bd-12b40869d30a--WUSTL_HPRC_HiFi_Year3/HG02015/PacBio_HiFi/m64043_210905_032603-bc1022.5mc.hifi_reads.bam # perfect

# GRCh38_full_analysis_set_plus_decoy_hla.fa was used instead of the default ref because that's how the bam files were created
# comes from the AnVIL-HPRC workspace
# after some ... interesting... developments the NTSM and Readstats finished, and all  files are OK'd
# Time to upload to SRA


# create biosample and metadata files for upload to SRA
#./sra_metadata.py WUSTL_HPRC_HiFi_Year3_metadata.tsv
#mv sra_biosample_WUSTL_HPRC_HiFi_Year3_metadata.tsv sra_metadata_WUSTL_HPRC_HiFi_Year3_metadata.tsv ~/Documents/Miga

# upload this to SRA via https://submit.ncbi.nlm.nih.gov/subs/
# then download the resulting metadata table an upload it to the workspace
#gsutil cp metadata-12876517-processed-ok.tsv gs://fc-a7e6ae6b-860b-4519-80a5-277aeb967124/

# Run the mergeSRAMetaReadstats.ipynb analysis and download the final file
#gsutil cp gs://fc-a7e6ae6b-860b-4519-80a5-277aeb967124/WUSTL_HPRC_HiFi_Year3_post_sra_metadata.tsv .

# and clean up
#mkdir WUSTL_HPRC_HiFi_Year3
#mv WUSTL_HPRC_HiFi_Year3.csv  WUSTL_HPRC_HiFi_Year3_metadata.tsv  WUSTL_HPRC_HiFi_Year3_post_sra_metadata.tsv WUSTL_HPRC_HiFi_Year3

# get the notebooks
gsutil cp gs://fc-a7e6ae6b-860b-4519-80a5-277aeb967124/notebooks/*ipynb WUSTL_HPRC_HiFi_Year3

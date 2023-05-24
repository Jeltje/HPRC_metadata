# Terra

For more details on the below, see [Setup A PacBio HiFi Wrangling Workspace In AnVIL](https://ucsc-cgl.atlassian.net/wiki/spaces/~63c888081d7734b550c2052b/pages/2333245441/Setup+A+PacBio+HiFi+Wrangling+Workspace+In+AnVIL)

We run two QC workflows on the input HiFi bam files,
[Readstats](https://dockstore.org/workflows/github.com/human-pangenomics/hpp_production_workflows/ReadStats:master?tab=info)
and
[NTSM](https://dockstore.org/workflows/github.com/human-pangenomics/hpp_production_workflows/NTSM:master?tab=info).  
Note that these pages have an Export to AnVIL option on the right hand side.  

To create input tables for these workflows upload
[Generate_Terra_Tables_HiFi_QC.ipynb](https://github.com/human-pangenomics/hpp_data_pipeline/blob/main/data_processing/AnVIL/Generate_Terra_Tables_HiFi_QC.ipynb) to the Analysis section

After running both workflows, check the results using
[Extract_HiFi_QC_Results.ipynb](https://github.com/human-pangenomics/hpp_data_pipeline/blob/main/data_processing/AnVIL/Extract_HiFi_QC_Results.ipynb)  
Note that this is meant for manual validation and does not output any files.

It is possible to merge Readstats, SRA (see step 5), and submitter info using
[mergeSRAMetaReadstats.ipynb](https://github.com/human-pangenomics/hpp_data_pipeline/blob/main/data_processing/AnVIL/mergeSRAMetaReadstats.ipynb) but it might be easier to just output the Readstats info in a table and merge using a commandline script.

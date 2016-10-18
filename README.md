## Summary

Scripts for analysing one-to-one Crithidia orthologs in codeml.

Use these scripts at your own risk! They may need some tweaks or fixes for different gene sets or organisms. No documentation is available for these scripts and I don't plan on writing any. They are effectively unsupported, but if you have questions please get in touch with me and I may still be able to help.  


## Example workflows 


## Python scripts

Pre-processing was already done by the GDC. Assume we start with coding sequence alignments of 4 taxa (tbrucei, lmajor, cbombi, cexpoeki). 


- GetNewAlignments.py:
	Produce alignments that can be used with PAML and PhyML

    - Trim the alignment:
            * Using Gblocks, if parameters are given.
    - Skip groups where the trimmed alignment is shorter than the minimum length (default = 300bp)
    - Save trimmed cDNA and AA alignments in Phylip format so it can be used with PAML and PhyML

	Need to have Gblocks installled.  Check that programs are in your path.  
	
	Output:

    - Alignments.csv:  Processed alignments
    - Skipped.csv:     Groups which have been skipped for whatever reason
    

    For each group that wasn't skipped:

    - \<group\>.dna.fas-gb         Trimmed alignment from Gblocks
    - \<group\>.dna.fas-gb.txt     Gblocks statistics
    - \<group\>.dna.phylip         Trimmed cDNA alignment in Phylip, ready for Paml
    - \<group\>.aa.phylip             Trimmed AA alignment in phylip
   

- RunPhyml.py: 
	Run PhyML to get branch length estimates (topology not optimized, uses JTT model)

- SetupPAML.py:
	Setup control files for different PAML models (for all alignments and trees in the specified directory). Requires template control files. Outputs bash scripts for running the analyses in PAML (both locally or on the Brutus cluster). Where applicable make multiple control files for different random initializations of omega.

	- Sites: M0, M1, M2, M3, M7, M8, M8A
	- Branch-Site
	- Clade models C and D (not used)

	Trees for branch-site and clade models are hardcoded for 4- and 5-taxa trees in the paper (but can be easily changed).

- ExtractParameter.py:
	Extract parameters from the PAML output files into easily readable csv files.

- ExtractBest.py:
	Looks at output files from ExtractParameters.py to extract the replicate with the maximum-likelihood for each model.

- ExtractBEB.py:
	Extract BEB posterior values from PAML branch-site and M8 models.

- FormatBEB.py:
	Format BEB into BEB values for each of the sequences in the alignment. (So that the posterior estimate for the rate of evolution at each site in each full sequence (outside of the alignment) is known).

- GetInterPro.py:
	Download domains returned by InterPro Scan for AA sequences. A lot of functions based on http://www.ebi.ac.uk/Tools/webservices/download_lients/python/suds/iprscan5_suds.py

- MergeBEBInterPro.py:
	Merge the output from the BEB and Interpro scan into one file that can be plotted to see where sites under selection fall within domains.



## Data
Files needed as input for some scripts

- PAML templates
- Files containing sets of taxa for various analyses 
- Files containing topologies for various analyses  


## R scripts
Likelihood-ratio tests, figures, tables, Venn diagrams etc.
These need to be checked.

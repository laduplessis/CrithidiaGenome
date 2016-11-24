#!/bin/bash


#####################################################################################################################################################
# 3) Extract new trimmed alignments
#		Can choose to only extract alignments with certain numbers of each species
#		Alignments trimmed here
#		Rename sequences and save alignments in Phylip format

# No trimming
python GetNewAlignments.py -i ../Data/prank/ -l 100

# Gblocks strict
python2.7 GetNewAlignments.py -i ../Data/prank/ -l 100 -g strict

# Gblocks relaxed
python2.7 GetNewAlignments.py -i ../Data/prank-relaxed/ -l 100 -g relaxed


#####################################################################################################################################################
# 4) Get trees (based on AA sequences)

# No trimming
python RunPhyml.py -i ../Data/prank/ -p ~/Documents/Packages/PhyML-3.1/PhyML-3.1_macOS-MountainLion -t ../Data/InputTree4.txt 

# Gblocks strict
python2.7 RunPhyml.py -i ../Data/prank-strict/ -p ~/Documents/Packages/PhyML-3.1/PhyML-3.1_macOS-MountainLion -t ../Data/InputTree4.txt 

# Gblocks relaxed
python2.7 RunPhyml.py -i ../Data/prank-relaxed/ -p ~/Documents/Packages/PhyML-3.1/PhyML-3.1_macOS-MountainLion -t ../Data/InputTree4.txt 


#####################################################################################################################################################
# 5) Make PAML control files

# No trimming
python SetupPAML.py -i ../Data/prank/ -o ../Data/PAML_prank/ -c ../Data/PAML_Templates/ -s 4 -R 3 -r 25

# Gblocks strict
python SetupPAML.py -i ../Data/prank-strict/ -o ../Data/PAML_prank-strict/ -c ../Data/PAML_Templates/ -s 4 -R 3 -r 25

# Gblocks relaxed
python SetupPAML.py -i ../Data/prank-relaxed/ -o ../Data/PAML_prank-relaxed/ -c ../Data/PAML_Templates/ -s 4 -R 3 -r 25


#####################################################################################################################################################
# 6) Run PAML

#### Done on Euler



#####################################################################################################################################################
# 7) Extract the parameters found by PAML for each of the models

# No trimming
python ExtractParameters.py -i ../Data/PAML_prank/ -o ../Data/PAML_prank_Results/

# Gblocks strict
python ExtractParameters.py -i ../Data/PAML_prank-strict/ -o ../Data/PAML_prank-strict_Results/

# Gblocks relaxed
python ExtractParameters.py -i ../Data/PAML_prank-relaxed/ -o ../Data/PAML_prank-relaxed_Results/


#####################################################################################################################################################
# 8) Extract the best run

# No trimming
python ExtractBest.py -i ../Data/PAML_prank_Results/

# Gblocks strict
python ExtractBest.py -i ../Data/PAML_prank-strict_Results/

# Gblocks relaxed
python ExtractBest.py -i ../Data/PAML_prank-relaxed_Results/


# #####################################################################################################################################################
# # 9) Extract BEB results for M8 and Branch-site models for the best runs

# # ProGraphMSA Strict
# python ExtractBEB.py -i ../DivergenceData/4Species/PAML_ProGraphMSA_Strict -b ../DivergenceData/4Species/PAML_ProGraphMSA_Strict_Results/ -m prographmsa

# # ProGraphMSA Relaxed
# python ExtractBEB.py -i ../DivergenceData/4Species/PAML_ProGraphMSA_Relaxed -b ../DivergenceData/4Species/PAML_ProGraphMSA_Relaxed_Results/ -m prographmsa

# # ProGraphMSA None
# python ExtractBEB.py -i ../DivergenceData/4Species/PAML_ProGraphMSA_None -b ../DivergenceData/4Species/PAML_ProGraphMSA_None_Results/ -m prographmsa


# #####################################################################################################################################################
# # 10) Copy alignments summary file to results file (all results files in one directory for easy analysis)

# # ProGraphMSA Strict
# cp ../DivergenceData/4Species/MSA_ProGraphMSA_Strict/Alignments.csv ../DivergenceData/4Species/PAML_ProGraphMSA_Strict_Results/

# # ProGraphMSA Relaxed
# cp ../DivergenceData/4Species/MSA_ProGraphMSA_Relaxed/Alignments.csv ../DivergenceData/4Species/PAML_ProGraphMSA_Relaxed_Results/

# # ProGraphMSA None
# cp ../DivergenceData/4Species/MSA_ProGraphMSA_None/Alignments.csv ../DivergenceData/4Species/PAML_ProGraphMSA_None_Results/








# python FormatBEB.py -i ../DivergenceData/4Species/MSA_ProGraphMSA_Strict/ -b ../DivergenceData/4Species/PAML_ProGraphMSA_Strict_Results/BEB/ -m prographmsa -o ../DivergenceData/4Species/PAML_ProGraphMSA_Strict_Results/InterPro/

# python MergeBEBInterPro.py -i ../DivergenceData/4Species/PAML_ProGraphMSA_Strict_Results/InterPro/ -d smart,pfam,phobius



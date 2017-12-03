#!/bin/bash

# Steps 1 and 2 not performed for Crithidia (alignments already exist and checked)

#####################################################################################################################################################
# 2.5) Rename sequence ids
#
#	TbruceiTREU927      -> tbrucei
#	crithidia_expoeki   -> cexpoeki
#	crithidia_bombi     -> cbombi
#	LseymouriATCC30220  -> lseymouri
#	LpyrrhocorisH10     -> lpyrrhoco
#	CfasciculataCfCl    -> cfascicul
#	EmonterogeiiLV88    -> emonterog
#	LmajorFriedlin      -> lmajor
#	BayalaiB08_376      -> bayalai
# 

cp -r ../Data9Species/prank.align.9sp prank/

sed -i .bak s/TbruceiTREU927/tbrucei/g *.fasta
sed -i .bak s/crithidia_expoeki/cexpoeki/g *.fasta
sed -i .bak s/crithidia_bombi/cbombi/g *.fasta
sed -i .bak s/LseymouriATCC30220/lseymouri/g *.fasta
sed -i .bak s/LpyrrhocorisH10/lpyrrhoco/g *.fasta
sed -i .bak s/CfasciculataCfCl/cfascicul/g *.fasta
sed -i .bak s/EmonterogeiiLV88/emonterog/g *.fasta
sed -i .bak s/LmajorFriedlin/lmajor/g *.fasta
sed -i .bak s/BayalaiB08_376/bayalai/g *.fasta
rm *.bak
cd ..
cp prank/*.fasta prank-strict/
cp prank/*.fasta prank-relaxed/


#####################################################################################################################################################
# 3) Extract new trimmed alignments
#		Can choose to only extract alignments with certain numbers of each species
#		Alignments trimmed here
#		Rename sequences and save alignments in Phylip format

# No trimming
python2.7 GetNewAlignments.py -i ../Results9Species/prank/ -l 100

# Gblocks strict
python2.7 GetNewAlignments.py -i ../Results9Species/prank-strict/ -l 100 -g strict

# Gblocks relaxed
python2.7 GetNewAlignments.py -i ../Results9Species/prank-relaxed/ -l 100 -g relaxed


#####################################################################################################################################################
# 4) Get trees (based on AA sequences, using fixed topology)

# No trimming
python2.7 RunPhyml.py -i ../Results9Species/prank/ -p ~/Documents/Packages/PhyML-3.1/PhyML-3.1_macOS-MountainLion -t ../Data9Species/InputTree9.txt

# Gblocks strict
python2.7 RunPhyml.py -i ../Results9Species/prank-strict/ -p ~/Documents/Packages/PhyML-3.1/PhyML-3.1_macOS-MountainLion -t ../Data9Species/InputTree9.txt

# Gblocks relaxed
python2.7 RunPhyml.py -i ../Results9Species/prank-relaxed/ -p ~/Documents/Packages/PhyML-3.1/PhyML-3.1_macOS-MountainLion -t ../Data9Species/InputTree9.txt


#####################################################################################################################################################
# 5) Make PAML control files

# No trimming
python2.7 SetupPAML.py -i ../Results9Species/prank/ -o ../Results9Species/PAML_prank/ -c ../Data/PAML_Templates/ -s 9 -R 3 -r 25

# Gblocks strict
python2.7 SetupPAML.py -i ../Results9Species/prank-strict/ -o ../Results9Species/PAML_prank-strict/ -c ../Data/PAML_Templates/ -s 9 -R 3 -r 25

# Gblocks relaxed
python2.7 SetupPAML.py -i ../Results9Species/prank-relaxed/ -o ../Results9Species/PAML_prank-relaxed/ -c ../Data/PAML_Templates/ -s 9 -R 3 -r 25


#####################################################################################################################################################
# 6) Run PAML

#### Done on Euler



#####################################################################################################################################################
# 7) Extract the parameters found by PAML for each of the models

# No trimming
python ExtractParameters.py -i ../Results9Species/PAML_prank/ -o ../Results9Species/PAML_prank_Results/
rm *1.120* *2.330* *3.480*

1764, 1768

cut -f 1 Sites-2.000.M3.w | sort -g > Sites-2.000.M3.completed.csv
cut -f 1 Sites-2.000.M7.w | sort -g > Sites-2.000.M7.completed.csv
cut -f 1 Sites-2.000.M8.w | sort -g > Sites-2.000.M8.completed.csv
diff Sites-2.000.M3.completed.csv Sites-2.000.M7.completed.csv | grep "<" | cut -f 2 -d " " > Sites-2.000.M7.missing.csv
diff Sites-2.000.M3.completed.csv Sites-2.000.M8.completed.csv | grep "<" | cut -f 2 -d " " > Sites-2.000.M8.missing.csv
for i in `cat Sites-2.000.M7.missing.csv`;  do grep -A 1 $i ../PAML_prank-strict/Sites-2.000.leonhard.sh; done > Sites-2.000.leonhard.reruns.sh
sed s/W8/W28/g Sites-2.000.leonhard.reruns.sh > Sites-2.000.leonhard.reruns24.sh


# Gblocks strict
python ExtractParameters.py -i ../Results9Species/PAML_prank-strict/ -o ../Results9Species/PAML_prank-strict_Results/

# Gblocks relaxed
python ExtractParameters.py -i ../Results9Species/PAML_prank-relaxed/ -o ../Results9Species/PAML_prank-relaxed_Results/


#####################################################################################################################################################
# 8) Extract the best run

# No trimming
python ExtractBest.py -i ../Results9Species/PAML_prank_Results/

# Gblocks strict
python ExtractBest.py -i ../Results9Species/PAML_prank-strict_Results/

# Gblocks relaxed
python ExtractBest.py -i ../Results9Species/PAML_prank-relaxed_Results/

f

cp ../Results9Species/prank-strict/Alignments.csv ../Results9Species/PAML_prank-strict_Results/Alignments.csv



# Steps past here were used for Bumblebees but are not done for Crithidia

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

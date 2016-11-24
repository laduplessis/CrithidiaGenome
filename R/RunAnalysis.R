# Initialization and parameters
rm(list = ls())

scriptpath <- "~/Documents/Projects/Crithidia/R/"
source(paste(scriptpath,'LRT.R',sep='/'))
source(paste(scriptpath,'ReadData.R',sep='/'))
#source(paste(scriptpath,'Table.R',sep='/'))
#library(gridExtra)
#library(xtable)
library(RColorBrewer)
#library(VennDiagram)
#library(plotrix)

alpha   <- 0.05
path4   <- "~/Documents/Projects/Crithidia/Data/"

pal.light <- brewer.pal(12,"Paired")[seq(1,12,2)]
pal.dark  <- brewer.pal(12,"Paired")[seq(2,12,2)]
pal.trans <- pal.light
for (i in 1:6) {
  pal.trans[i] <- paste(pal.trans[i],"88",sep='')
}

run     <- "prank-relaxed"
outpath <- paste0("~/Documents/Projects/Crithidia/Data/",run,"Analysis")
source(paste(scriptpath,'GetOutput.R',sep='/'))





#run     <- "ProGraphMSA_Relaxed"
#outpath <- "Documents/Projects/Bumblebees/DivergenceData/RelaxedAnalysis/"
#source(paste(scriptpath,'GetOutput.R',sep='/'))

#run     <- "ProGraphMSA_None"
#outpath <- "Documents/Projects/Bumblebees/DivergenceData/NoneAnalysis/"
#source(paste(scriptpath,'GetOutput.R',sep='/'))


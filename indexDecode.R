### indexDecode.R
### v 1.0
### 
### This R script extracts index sorting data from MoFlo-Astrios FCS files. 
### It uses the flowCore package from Bioconductor to read the raw FCS files. 
### 
### Mandy Tam <mandycm26@gmail.com>

# set up working directory and file names
setwd("~/Desktop/index_sorting")       #edit this to your working directory
fcsFileName <- "Plate2_384w.fcs"        #input FCS file
outputCSV <- "Plate2_384w_index.csv"    #output index file 
descriptorCSV <- "Plate2_384w_descriptors.csv"  #output descriptor file

# load flowCore package 
library("flowCore")

# run flowCore command to read FCS file 
myFile <- read.FCS(fcsFileName)

# extract sort classifier data
sortClassifier <- exprs(myFile)[, c("Sort Classifier")]

# set up matrix to store sort index X and Y data in columns 1 and 2
indexData = matrix(nrow=length(sortClassifier), ncol=2)
wellCount = 0
for (i in 1:length(sortClassifier)){
  if (sortClassifier[i] > 2^20){
    bits = as.numeric(intToBits(sortClassifier[i]))
    indexData[i,1] = bits[21] + bits[22]*2 + bits[23]*4 + bits[24]*8 + bits[25]*16 + bits[26]*32
    indexData[i,2] = bits[27] + bits[28]*2 + bits[29]*4 + bits[30]*8 + bits[31]*16 + bits[32]*32
    wellCount = wellCount+1
  }
}

# export index data in csv with each row containing well position and the corresponding signal in all the parameters
sink(outputCSV)
cat("Position,")
cat(colnames(myFile), sep=",")
cat("\n")
for (i in 1:nrow(myFile)){
  if (!is.na(indexData[i,1])){
    if (indexData[i,2] <= 26){  #rows A-Z
      cat( paste0(c(intToUtf8(indexData[i,2]+64), indexData[i, 1])))
    } else {  #rows AA-EE for 1536-well plate
      cat( paste0(c(intToUtf8(indexData[i,2]-26+64), intToUtf8(indexData[i,2]-26+64), indexData[i, 1])))
    } 
    cat(",")
    for (j in colnames(myFile)){
      cat(exprs(myFile)[,c(j)][i])
      cat(",")
    }
    cat("\n")
  }
}
sink()

#post-run console messages
cat(outputCSV, "generated \n")
cat("Number of cells sorted:", wellCount, "\n")

#save descriptors file
sink(descriptorCSV)
myFile
sink()
cat(descriptorCSV, "generated \n")

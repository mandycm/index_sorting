Extracting Astrios Index Sorting Data
======
indexDecode.R a script written in R to extract the index-sorting data from the MoFlo-Astrios FCS files. When a plate sort is performed on the Astrios, the well position of a sorted event is recorded. The information is packaged in the Sort Classifier parameter inside the FCS file. The Sort Classifier is a 32-bit parameter, with sort-media X postion stored in bits 21-26 and sort-media Y position stored in bits 27-32. This script is written to extract those bits of information from an Astrios FCS file.

Here are some examples of sort classifier values. Bits 21-32 are highlighted.
* An event that is outside of the desired sort gate
 * 65536 (Binary = **000000 000000** 0 1 0 0 00000000 00000000)
- An aborted event
 * 196863 (Binary = **000000 000000** 0 0 1 1 00000000 11111111)
- An event sorted into well A5
 * 72482815 (Binary = **000001 000101** 0 0 0 1 11111111 11111111)

## Data Input and Output
**Data Input**: FCS file from the MoFlo-Astrios

**Data Output**:
1. CSV file containing well position of a sorted event and its signal in all the recorded parameters
2. CSV file containing the header information

I have included some sample files I used for testing this script:  
- FCS file from a 96-well plate sort (Plate1_96w.fcs). H10-12 are empty in this sort. All other wells have a single cell sorted.
- Index data output from the 96w plate example (Plate1_96w_index.csv)
- Header descriptor output from the 96w plate example (Plate1_96w_descriptors.csv)
- FCS file from a 384-well plate sort (Plate2_384w.fcs). Wells A1, A24, P1, P24 have 10 cells each. All other wells have a single cell sorted.
- Index data output from the 96w plate example (Plate2_384w_index.csv)
- Header descriptor output from the 96w plate example (Plate2_384w_descriptors.csv)

## Using the Script
You need to have the [R](http://www.r-project.org/) and the [Bioconductor-flowCore](http://www.bioconductor.org/packages/release/bioc/html/flowCore.html) package installed.

To install flowCore:
`source("http://bioconductor.org/biocLite.R")`
`biocLite("flowCore")`

Edit the working directory, input file name and desired output file names

Run the script. I didn't set up error checking so I would suggest running the script block by block on the R console and monitor each step.


## Known Issues
1. **File Size Limit**
  -  I have trouble running the readFCS() command of the FlowCore pacakage on big FCS files. My laptop froze when I tried this on a 1GB file. For Harvard people, you may want to try running this on the Odyssey cluster for big files.
2. **Speed**  
   - Just a disclaimer that the script is rather slow, especially the   block that writes data out as the csv files. It took my aging laptop ~20 seconds to write the outputs in the 384-well plate example.
3. **Issue with 1536-well plates**
 - I forgot to set up the script to decode for rows AA-EE. I will fix that when I get a chance.

Collaborators are welcome to improve the script and make it more robust. Feel free to contact me for issues.

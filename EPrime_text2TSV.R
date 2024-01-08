"This code can be used to convert EPrime text outputs (.txt files) to TSV files"

# rprime library contains all necessary funtions to read and convert EPrime data
library(rprime)

# Path to directory containing all EPrime text data
dataPath <- '/Set/this/variable/to/path/for/EPrime/text/data/'

# Path to directory where output files will be created
outputLoc <- '/Set/this/variable/to/path/for/output/directory/'



# Get list of files in the root directory containing all Prime files
fileList <- list.files(path=dataPath, pattern="*.txt", full.names=TRUE, recursive=FALSE)


# Function to convert EPrime data to R DataFrame
processEPrimeData <- function(flPath) {
  ## Load file
  eprime_log <- read_eprime(flPath, remove_clock = TRUE)
  ## Separate frame chunks from file
  rawDataChunks <- extract_chunks(eprime_log)
  ## Convert character-vector chunks to ePrime framelist
  ePrimeFramelist <- FrameList(rawDataChunks)
  return(to_data_frame(ePrimeFramelist))
}


# Loop through files
for (flPath in fileList) {
  currDF <- processEPrimeData(flPath)
  flName <- paste(tools::file_path_sans_ext(basename(flPath)), ".tsv", sep = "")
  write.table(currDF, paste(outputLoc,flName,sep=""), sep="\t", quote=FALSE, row.names=FALSE, col.names=TRUE)
}

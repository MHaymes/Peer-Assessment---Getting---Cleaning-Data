Peer-Assessment---Getting---Cleaning-Data
=========================================

Peer Assessment - Getting &amp; Cleaning Data

Instructions for use: 

Download zipped data from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

The entire UCI - HAR folder should be unzipped to your local R working directory (not the individual files).  The R script contains several functions; however, these are all called internally by the main run_analysis() function.  Calling this function will create the two output datafiles within the working directory.   

The function requires the stringi and reshape2 packages, which will need to be installed if not already installed on your machine. 

These can be installed by calling: 

install.packages("stringi")
install.packages("reshape2")

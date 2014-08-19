# README
## Course Project
### Coursera Getting And Cleaning Data - JHSPH
This repository contains five files comprising the work for the 
course project.

1.  This README.md file
2.  CodeBook.md which describes the data, variables, and transformations performed by the project R code
3.  run_analysis.R which contains the R code for processing the  [smartphone dataset](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip). Note the R code is dependent on the data.table package. This function takes two arguments: 
* directory (default = ".") The directory that contains the root of the dataset as well as the featuresDescriptive.txt file
* summaryFilename (default = "summary.txt") The filename to place the output of the analysis in relative to the directory argument
4.  featuresDescriptive.txt which contains mapping data to allow the user to specify/change column names and add/remove columns from the analysis. **Note** this file must be placed in the working/target directory in order for the analysis to succeed
5.  summary.txt which is sample output from running the analysis
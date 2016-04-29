#Getting and Cleaning Data Assignment

This file explains how the run_analysis.R script is used.
Information on the output data and transformation steps can be found under CodeBook.md

## Requirements
* This R file requires the dplyr package. If you do not already have it installed run `install.packages("dplyr")`

## Instructions
* Download the run_analysis.R script
* Load R or R Studio and set the working directory to the location of the run_analysis.R script
* In R type `source("./run_analysis.R")
* `run_analysis()` will start the data download and create 2 files
        * SubjectActivityData.txt (): containing the subject and activity recorded means and standard deviations for both test and train data
        * SubjectActivityMeanData.txt (): containing the mean data for each recorded activity type for each subject
* To use the SubjectActivityMeanData in R, you can load by calling `resultMeans()` 
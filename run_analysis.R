#run_analysis.R file contains 
library(dplyr)

zipsource <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
zipfile <- "./data/dataset.zip"

## Function will execute download of project data zip file and create a new file
run_analysis <- function() {
        downloadData() ## Download and save project data
        loadData() ## Load datasets for manipulation
        
        ## Merge training and test datasets into single sets
        mergeData()
        
        meanStdIndices <- grep("mean|std", features[,2])
        ## Preserve only mean and standard deviation data
        mergedData <- mergedData[, meanStdIndices]
        ## Add column names
        names(mergedData) <- gsub("-|(\\(\\))", "", features[meanStdIndices, 2])
        names(mergedData) <- gsub("mean", "Mean", names(mergedData))
        names(mergedData) <- gsub("std", "Std", names(mergedData))
        ## Create descriptive activity names
        activities <- activityLabels[, 2]
        activities <- strsplit(tolower(activities), "_")
        activities <- sapply(activities, function(x){
                paste(sapply(x, function(y) paste0(toupper(substr(y, 1, 1)), tolower(substring(y, 2)))),
                        collapse=" ")
                })
        actLabels <- activities[mergedLabel[,1]]
        mergedLabel[, 1] <- actLabels
        ## Descriptive variable names
        names(mergedLabel) <- "activity"
        names(mergedSubject) <- "subject"
        ## Combine Subjects, Activity Labels and Data
        completeData <- cbind(mergedSubject, mergedLabel, mergedData)
        write.table(completeData, "./SubjectActivityData.txt")
        
        ## Create an independent data set with averages for each activity for each subject
        ## Use dplyr to group by subject and activity and then summarise the other columns
        tidyData <- completeData %>% group_by(subject, activity) %>% summarise_each(funs(mean))

        ## Save the dataset
        write.table(tidyData, "./SubjectActivityMeanData.txt", row.name=FALSE)
}

## Function reads the saved mean data back into R
resultMeans <- function() {
        ## Read back the dataset
        read.table("./SubjectActivityMeanData.txt")
}


## Function downloads project zip file and saves it to the ./data folder
downloadData <- function() {
        if (!file.exists("./data")) {dir.create("./data")}
        if (!file.exists(zipfile)) {download.file(zipsource, destfile=zipfile)}
}

## Function loads datasets from zip file into R and assigns global variables
loadData <- function() {
        trainSubject <<- read.table(unz(zipfile, "UCI HAR Dataset/train/subject_train.txt"))
        trainData <<- read.table(unz(zipfile, "UCI HAR Dataset/train/X_train.txt"))
        trainLabel <<- read.table(unz(zipfile, "UCI HAR Dataset/train/y_train.txt"))
        testSubject <<- read.table(unz(zipfile, "UCI HAR Dataset/test/subject_test.txt"))
        testData <<- read.table(unz(zipfile, "UCI HAR Dataset/test/X_test.txt"))
        testLabel <<- read.table(unz(zipfile, "UCI HAR Dataset/test/y_test.txt"))
        features <<- read.table(unz(zipfile, "UCI HAR Dataset/features.txt"))
        activityLabels <<- read.table(unz(zipfile, "UCI HAR Dataset/activity_labels.txt"))
}

## Function merges the test and train datasets from the loadData() created glabal variables into
## a set of merged global variables; mergedSubject, mergedData and mergedLabel
mergeData <- function() {
        mergedSubject <<- rbind(trainSubject, testSubject)
        mergedData <<- rbind(trainData, testData)
        mergedLabel <<- rbind(trainLabel, testLabel)
}
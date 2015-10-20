## INITIALIZING FOLDERS AND FILES
URL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
dest <- "C:/Users/atyshchenko/Documents/data"
datapath <- "C:/Users/atyshchenko/Documents/data/UCI HAR Dataset"
file <- "data.zip"

##DOWNLOADING AND UN-ZIPING
if (!file.exists(dest)) {
  dir.create(dest)
  download.file(URL, paste(dest, file, sep="/"), mode="wb")
}
if (!file.exists(datapath)) {
  unzip( paste(dest, file, sep="/"), exdir = dest )  
}

##READING THE FILES
labels <- read.table( paste(datapath, "activity_labels.txt", sep="/"), sep=" ")
names(labels)<- c("activity", "activityName")
features <- read.table( paste(datapath, "features.txt", sep="/"), sep=" ")

x.train <- read.table( paste(datapath, "train/X_train.txt", sep="/"), header = FALSE)
y.train <- read.table( paste(datapath, "train/y_train.txt", sep="/"), header = FALSE)
x.test <- read.table( paste(datapath,"test/X_test.txt", sep="/"), header = FALSE)
y.test <- read.table( paste(datapath,"test/y_test.txt", sep="/"), header = FALSE)
subject.test <- read.table( paste(datapath,"test/subject_test.txt", sep="/"), header = FALSE)
subject.train <- read.table( paste(datapath,"train/subject_train.txt", sep="/"), header = FALSE)

## merge THE TRAIN AND TEST DATA
x.data    <- rbind(x.test, x.train)
y.data    <- rbind(y.test, y.train)
subject.data <- rbind(subject.train, subject.test)

## merge data, labels, subjects
tmp <- cbind(x.data, y.data, subject.data)

## apply column names
names(tmp) <- c(as.vector(features[,2]), "activity","subject")

## filter out necessary columns
colNames <- grep("std\\(\\)|mean\\(\\)", features[,2], ignore.case = TRUE, value = TRUE )

## filter data based on the column names
subData <- subset(data, select = c(colNames, "activity","subject"))

## Merge activityName based on activity ID
finalData <- merge(subData, labels, by="activity", all.x=TRUE)

## create new data set with averages
library(plyr)
tidyData <-

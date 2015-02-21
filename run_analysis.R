#The following lines are used to download the zip file into the working directory
#fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
#library(downloader)
#download(fileURL, dest="dataset.zip", mode="wb")

#first unzip the dataset.zip into the same working directory
unzip ("dataset.zip", exdir = ".")

#open the train data set and add the activity and subject variables
trainset <- read.table("./UCI HAR Dataset/train/X_train.txt")
tra <- read.table("./UCI HAR Dataset/train/y_train.txt")
trs <- read.table("./UCI HAR Dataset/train/subject_train.txt")
trainset <- cbind(trainset, tra, trs)

#open the test data set and add the activity and subject variables
testset <- read.table("./UCI HAR Dataset/test/X_test.txt")
tta <- read.table("./UCI HAR Dataset/test/y_test.txt")
tts <- read.table("./UCI HAR Dataset/test/subject_test.txt")
testset <- cbind(testset, tta, tts)

mergedset <- rbind(testset, trainset)

#Read the features variable names
fdf <- read.table("./UCI HAR Dataset/features.txt", stringsAsFactors = FALSE)
#include only mean and std variables
fdf <- fdf[grepl("mean()",fdf[,2]) | grepl("std()",fdf[,2]),]
#exclude meanFreq variables
fdf <- fdf[!grepl("meanFreq()",fdf[,2]),]
fdf <- rbind(fdf, c("562","activity"))
fdf <- rbind(fdf, c("563","subject"))
fdf[,1] <- as.integer(fdf[,1])

#include only columns for required variables
fdv <- fdf[,1]
mergedset <- mergedset[fdv]

#set proper variable names
fdv <- fdf[,2]
colnames(mergedset) <- fdv

#generate and save finalset
finalset <- aggregate( . ~ activity + subject, data=mergedset, FUN=mean)
write.table(finalset, file="finalset.txt",row.name=FALSE)

setwd("/Users/peggyfan/Downloads/R_data/Getting_cleaning_data")

#Merges the training and the test sets to create one data set.
test <- read.table("./UCI HAR Dataset/test/X_test.txt")
features <- read.table("./UCI HAR Dataset/features.txt")
colnames(test) <- features$V2
test_labels <- read.table("./UCI HAR Dataset/test/y_test.txt")
test_subjects <- read.table("./UCI HAR Dataset/test/subject_test.txt")
test_data = cbind(test_subjects, test_labels, test)

train <- read.table("./UCI HAR Dataset/train/X_train.txt")
colnames(train) <- features$V2
train_labels <- read.table("./UCI HAR Dataset/train/y_train.txt")
train_subjects <- read.table("./UCI HAR Dataset/train/subject_train.txt")
train_data = cbind(train_subjects,train_labels, train)

merged_data <- rbind(test_data, train_data)
colnames(merged_data)[1] <- "ID"
colnames(merged_data)[2] <- "Labels"

#Extracts only the measurements on the mean and standard deviation for each measurement. 
subj_labels <- merged_data[,1:2]
dat <- merged_data[,grep("std|mean", colnames(merged_data))]
data <- cbind(subj_labels, dat)

#Uses descriptive activity names to name the activities in the data set

data$Labels[data$Label == 1] <- "WALKING"
data$Labels[data$Label == 2] <- "WALKING_UPSTAIRS"
data$Labels[data$Label == 3] <- "WALKING_DOWNSTAIRS"
data$Labels[data$Label == 4] <- "SITTING"
data$Labels[data$Label == 5] <- "STANDING"
data$Labels[data$Label == 6] <- "LAYING"

#Appropriately labels the data set with descriptive variable names.
vars <- names(data)
vars <- gsub("t", "T_", vars)
vars <- gsub("f", "F_", vars)
vars <- gsub("-", "_", vars)
vars <- gsub("-|\\()", "", vars)
vars <- gsub("sT_d", "std", vars)
vars <- gsub("meanFreq", "freq_mean", vars)
names(data) <- vars
colnames(data)[1] <- "Subjects"
colnames(data)[2] <- "Activity"

#Creates a second, independent tidy data set with the average of each variable for 
#each activity and each subject.
library(plyr)
tidy <- ddply(data, .(Subjects, Activity), numcolwise(mean))

write.table(tidy, file = "tidy_data.txt", row.names=F, quote=T, sep=" ") 


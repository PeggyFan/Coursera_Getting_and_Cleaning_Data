Getting_Cleaning_Data_Course_Project
====================================
Set working directory
```r
setwd("/Users/peggyfan/Downloads/R_data/Getting_cleaning_data")

```

Step 1: Merges the training and the test sets to create one data set.
Read data files from the working directories and combine datasets for "test" files 
```r
test <- read.table("./UCI HAR Dataset/test/X_test.txt")
features <- read.table("./UCI HAR Dataset/features.txt")
colnames(test) <- features$V2
test_labels <- read.table("./UCI HAR Dataset/test/y_test.txt")
test_subjects <- read.table("./UCI HAR Dataset/test/subject_test.txt")
test_data = cbind(test_subjects, test_labels, test)
```

Read data files from the working directories and combine datasets for "training" files 
```r
train <- read.table("./UCI HAR Dataset/train/X_train.txt")
colnames(train) <- features$V2
train_labels <- read.table("./UCI HAR Dataset/train/y_train.txt")
train_subjects <- read.table("./UCI HAR Dataset/train/subject_train.txt")
train_data = cbind(train_subjects,train_labels, train)

```
Merging the "test" and "training" datasets:
```r
merged_data <- rbind(test_data, train_data)
colnames(merged_data)[1] <- "ID"
colnames(merged_data)[2] <- "Labels"
```
Step 2: Extracts only the measurements on the mean and standard deviation for each measurement. 
First creating a separate data file for the columns "ID" and "Labels" prior to the extraction of columns, then creating a data frame by extracting the columns names with "std" or "mean" in them (meanFreq is also included). Then adding the file with "ID" and "Labels" to the file of extracted columns.
```r
subj_labels <- merged_data[,1:2]
dat <- merged_data[,grep("std|mean", colnames(merged_data))]
data <- cbind(subj_labels, dat)
```

Step 3: Uses descriptive activity names to name the activities in the data set
```r
data$Labels[data$Label == 1] <- "WALKING"
data$Labels[data$Label == 2] <- "WALKING_UPSTAIRS"
data$Labels[data$Label == 3] <- "WALKING_DOWNSTAIRS"
data$Labels[data$Label == 4] <- "SITTING"
data$Labels[data$Label == 5] <- "STANDING"
data$Labels[data$Label == 6] <- "LAYING"
```

Step 4: Appropriately labels the data set with descriptive variable names.
Changing the variable names in the following ways:
Use capital letter of t and f with underscore to signify Jerk and FFT measurements. Then replace dashes with underscores, remove "()", reword "sT_d" into "std" for standard deviation, and reword the phrase for frequency mean.
```r
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
```

Step 5: Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
```r
library(plyr)
tidy <- ddply(data, .(Subjects, Activity), numcolwise(mean))
```

Exporting the file to space-delimited text file.
```r
write.table(tidy, file = "tidy_data.txt", row.names=F, quote=T, sep=" ") 
```

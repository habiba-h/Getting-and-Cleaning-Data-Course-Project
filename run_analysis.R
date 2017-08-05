library(dplyr)

##incase the data has not been saved in the right directory at the current location
if(!file.exists("./UCI HAR Dataset")){
    fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(fileUrl, destfile = "./getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", method = "curl")
    unzip("./getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip")
}

## extracting all the relevant data

## training data
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", header = FALSE)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", header = FALSE)
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", header = FALSE)

## put all the training data together
train <- cbind(subject_train, x_train, y_train)

## test data
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", header = FALSE)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", header = FALSE)
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", header = FALSE)

## put all the training data together
test <- cbind(subject_test, x_test, y_test)

## read the 6 activity labels
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt", header = FALSE)

## name the columns for activity labels
colnames(activityLabels) <- c("ActivityID", "Activity")

## reading all the feature labels
features = read.table("UCI HAR Dataset/features.txt", header = FALSE, stringsAsFactors = TRUE)
features <- features[,2]

## Step 1: Merges the training and the test sets to create one data set.
data <- rbind(train, test)

##add column names to the data
colnames(data)<-c("UserID", as.character(features), "ActivityID")

## Step 2: Extracts only the measurements on the mean and standard deviation for each measurement.
data <- data[,c(1,grep("mean\\(\\)|std\\(\\)", colnames(data)),length(data))]

## Step 3: Uses descriptive activity names to name the activities in the data set
data<- merge(data, activityLabels, by = intersect(names(data), names(activityLabels)), sort = FALSE)
## remove the redundant "Activity ID" column as it is repleaced by descriptive activity name.
data <- data[,-1]

## Step 4: Appropriately labels the data set with descriptive variable names.
colnames(data) <- gsub("\\(\\)","", colnames(data))
colnames(data) <- gsub("-","", colnames(data))
colnames(data) <- gsub("mean","Mean", colnames(data))
colnames(data) <- gsub("std","Std", colnames(data))
colnames(data) <- gsub("MeanX","XMean", colnames(data))
colnames(data) <- gsub("MeanY","YMean", colnames(data))
colnames(data) <- gsub("MeanZ","ZMean", colnames(data))
colnames(data) <- gsub("StdX","XStd", colnames(data))
colnames(data) <- gsub("StdY","YStd", colnames(data))
colnames(data) <- gsub("StdZ","ZStd", colnames(data))
colnames(data) <- gsub("tBody","TimeBody", colnames(data))
colnames(data) <- gsub("tGravity","TimeGravity", colnames(data))
colnames(data) <- gsub("fBody","FrequencyBody", colnames(data))
colnames(data) <- gsub("BodyBody","Body", colnames(data))

## Step 5: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
Grouped_data <- group_by(data, Activity, UserID)
Averaged_data <- summarize_all(Grouped_data,mean)

## save the averaged results
write.table(Averaged_data,"UCI_HAR_Averages.txt")

## read back the saved data
summary_data <- read.table("UCI_HAR_Averages.txt")
View(summary_data)
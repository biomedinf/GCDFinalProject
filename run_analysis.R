# Course project for "Getting and Cleaning Data"

# First download the project zip file and unzip in the current working directory
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile="dataset.zip", method="curl")
unzip("dataset.zip")

# Step 1)  Merge training and test dataset from UCI repository
# to create one dataset.

# Read in values from training dataset
dataset1 <- read.table("UCI HAR Dataset/train/X_train.txt")
# Read in training labels
train_labels <- read.table("UCI HAR Dataset/train/y_train.txt")
# Read in subject's training set number
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
# Read in values from test dataset
dataset2 <- read.table("UCI HAR Dataset/test/X_test.txt")
# Read in test labels
test_labels <- read.table("UCI HAR Dataset/test/y_test.txt")
# Read in subject's test set number
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")

# Assess the dimensions (row by column) of each dataset
dim(dataset1)
# [1] 7352  561
dim(train_labels)
# [1] 7352    1
dim(subject_train)
# [1] 7352    1
dim(dataset2)
# [1] 2947  561
dim(test_labels)
# [1] 2947    1
dim(subject_test)
# [1] 2947    1

# Append the training_labels to the end of the training dataset
dataset1 <- cbind(dataset1, train_labels)
# Append the subject's number to the end of the training dataset
dataset1 <- cbind(dataset1, subject_train)
dim(dataset1)
# [1] 7352  563

# Append the test_labels to the end of the test dataset
dataset2 <- cbind(dataset2, test_labels)
# Append the subject's number to the end of the test dataset
dataset2 <- cbind(dataset2, subject_test)
dim(dataset2)
# [1] 2947  563

# "Merge" the datasets together by appending dataset2 to the end of dataset1
# The resulting dataset should have 10,299 rows and 563 columns
concat_datasets <- rbind(dataset1, dataset2)
dim(concat_datasets)
# [1] 10299   563

# Steps 2 and 4) Extract only the measurements on the mean and standard deviation for 
# each feature/measurement and label the dataset with descriptive variable names

# read in the number and names of each feature/measurement
featureNames <- read.table("UCI HAR Dataset/features.txt", stringsAsFactors=FALSE)
# append the values "562, Activities" to featureNames to represent the
# number and name of the activity label
featureNames <- rbind(featureNames, c(562, "Activities"))
# append the values "563, SubjectNumber" to featureNames to represent the
# number and name of the subject
featureNames <- rbind(featureNames, c(563, "SubjectNumber"))
# Set the column names for the concatenated dataset to be the values 
# in column 2 of featureNames
colnames(concat_datasets) <- featureNames[,2]

# Extract columns whose names/headings contain the strings "mean()", "std()", 
# "Activities", and "SubjectNumber" into new dataset called feature_subset
feature_subset <- concat_datasets[grep("mean[()]|std[()]|Activities|SubjectNumber", 
                                       names(concat_datasets), value=TRUE)]

# Step 3) Use descriptive activity names to name the activities in the data set

# From the "activity_labels.txt" file, we know that the activties are coded 
# numerically as follows:
#   1 WALKING
#   2 WALKING_UPSTAIRS
#   3 WALKING_DOWNSTAIRS
#   4 SITTING
#   5 STANDING
#   6 LAYING

# Replace the numerical values in feature_subset with the text labels 
# accordingly

feature_subset$Activities[feature_subset$Activities == 1] <- "WALKING"
feature_subset$Activities[feature_subset$Activities == 2] <- "WALKING_UPSTAIRS"
feature_subset$Activities[feature_subset$Activities == 3] <- "WALKING_DOWNSTAIRS"
feature_subset$Activities[feature_subset$Activities == 4] <- "SITTING"
feature_subset$Activities[feature_subset$Activities == 5] <- "STANDING"
feature_subset$Activities[feature_subset$Activities == 6] <- "LAYING"

# Step 5) From the data set in step 4, create a second, independent tidy data 
# set with the average of each variable for each activity and each subject.

library(plyr)
# Use the plyr package's ddply function to average feature/measurement values 
# by Activity and SubjectNumber
tidy_dataset <- ddply(feature_subset, .variables = .(Activities, SubjectNumber), numcolwise(mean))

# Write out resulting dataset to a text file
write.table(tidy_dataset, "variable_averages.txt")
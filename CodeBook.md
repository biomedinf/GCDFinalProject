##  This is the code book for the Getting and Cleaning Data final project.
# It describes the steps taken to produce a tidy data set from the 
# "Human activity using smartphones" dataset contained in the UC Irvine 
# Machine learning repository.  Steps described correspond to code in the 
# R script, run_analysis.R

First I downloaded the project zip file and unzipped it in the current working 
directory per lines 4-6 of run_analysis.R

## Step 1: Merge the training and test sets to create one dataset

Next, I read in all the training and test datasets obtained from the UCI 
repository: X_train.txt, y_train.txt, subject_train.txt, X_test.txt, 
y_test.txt, and subject_test.txt

After reading in each dataset, I checked its dimensions and discovered
that the training dataset had 7,352 rows and 561 columns, the training 
labels and subject's training numbers each had 7,352 rows and 1 column, 
the test dataset had 2,947 rows and 561 columns and the test labels 
and subject's test numbers each had 2,947 rows and 1 column.  
This means that "merging" the datasets involved:
1) appending the column of training labels to the training dataset, dataset1,
to produce a dataset that has 7,352 rows and 562 columns
2) appending the column of subject training numbers to the training dataset, 
dataset1, to produce a dataset that has 7,352 rows and 563 columns
3) appending the column of test labels to the test dataset, dataset2, to produce
a dataset that has 2,947 rows 562 columns,
4) appending the column of subject test numbers to the test dataset, dataset2,
to produce a dataset that has 2,947 rows and 563 columns
5) concatenating the resulting two datasets (dataset 1 and dataset2) to produce 
a new dataset called concat_datasets that has 10,299 rows and 563 columns.

## Steps 2 and 4) Extract only the measurements on the mean and standard deviation 
## for each feature/measurement and label the dataset with descriptive 
## variable names

I interpreted this to mean that data on the mean and standard deviation were to 
be extracted only for the following variables described in "features_info.txt": 
tBodyAcc-XYZ
tGravityAcc-XYZ
tBodyAccJerk-XYZ
tBodyGyro-XYZ
tBodyGyroJerk-XYZ
tBodyAccMag
tGravityAccMag
tBodyAccJerkMag
tBodyGyroMag
tBodyGyroJerkMag
fBodyAcc-XYZ
fBodyAccJerk-XYZ
fBodyGyro-XYZ
fBodyAccMag
fBodyAccJerkMag
fBodyGyroMag
fBodyGyroJerkMag

"features_info.txt" is a text file describing the features or measurements 
selected for the raw dataset, and it is one of the files downloaded and unzipped.

Based on my interpretation of the instructions for step 2, I did not include 
variables such as 
fBodyAcc-meanFreq()-X
fBodyAcc-meanFreq()-Y
fBodyAcc-meanFreq()-Z

To do this, I read in the number and names of all features/measurements from 
"features.txt" as shown in "run_analysis.R".  I also appended the values 
"562, Activities" to the end of featureNames to represent the number and name 
of the activity label. I then set the column names for the concatenated dataset 
to be the values in column 2 of featureNames.

I extracted columns whose names/headings contain the strings "mean()", "std()", 
"Activities" and "SubjectNumber" into a new dataset called feature_subset

## Step 3: Use descriptive activity names to name the activities in the data set

From the "activity_labels.txt" file, we know that the activties are coded 
numerically as follows:
1 WALKING
2 WALKING_UPSTAIRS
3 WALKING_DOWNSTAIRS
4 SITTING
5 STANDING
6 LAYING

I replaced the numerical values in the column labeled "Activities" with their 
text description.

# Step 5) From the data set in step 4, create a second, independent tidy data 
# set with the average of each variable for each activity and each subject.

I did this using the plyr package's ddply function to average feature/
measurement values by Activity and SubjectNumber
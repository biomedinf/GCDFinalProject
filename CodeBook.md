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
"562, Activities" and "563, SubjectNumber" to the end of featureNames to 
represent the number and name of the activity label and the number and coded name 
of the person/subject whose activity data was measured. I then set the column 
names for the concatenated dataset to be the values in column 2 of featureNames.
I believe that the variable names contained in "features.txt" plus Activities and
SubjectNumber for the two columns reresenting activity labels and the person/subject 
who performed an activity are descriptive variable names for our feature extract.

I extracted columns whose names/headings contain the strings "mean()", "std()", 
"Activities" and "SubjectNumber" into a new dataset called feature_subset

## Step 3: Use descriptive activity names to name the activities in the data set

From the "activity_labels.txt" file, we know that the activities are coded 
numerically as follows:
1 WALKING
2 WALKING_UPSTAIRS
3 WALKING_DOWNSTAIRS
4 SITTING
5 STANDING
6 LAYING

I replaced the numerical values in the feature_subset column labeled "Activities" 
with the corresponding text description, based on the activity coding described above.

# Step 5) From the data set in step 4, create a second, independent tidy data 
# set with the average of each variable for each activity and each subject.

I did this using the plyr package's ddply function to average feature/
measurement values by Activity and SubjectNumber

Variable names for the final tidy data set are:
[1] "Activities"                  "SubjectNumber"               "tBodyAcc-mean()-X"          
 [4] "tBodyAcc-mean()-Y"           "tBodyAcc-mean()-Z"           "tBodyAcc-std()-X"           
 [7] "tBodyAcc-std()-Y"            "tBodyAcc-std()-Z"            "tGravityAcc-mean()-X"       
[10] "tGravityAcc-mean()-Y"        "tGravityAcc-mean()-Z"        "tGravityAcc-std()-X"        
[13] "tGravityAcc-std()-Y"         "tGravityAcc-std()-Z"         "tBodyAccJerk-mean()-X"      
[16] "tBodyAccJerk-mean()-Y"       "tBodyAccJerk-mean()-Z"       "tBodyAccJerk-std()-X"       
[19] "tBodyAccJerk-std()-Y"        "tBodyAccJerk-std()-Z"        "tBodyGyro-mean()-X"         
[22] "tBodyGyro-mean()-Y"          "tBodyGyro-mean()-Z"          "tBodyGyro-std()-X"          
[25] "tBodyGyro-std()-Y"           "tBodyGyro-std()-Z"           "tBodyGyroJerk-mean()-X"     
[28] "tBodyGyroJerk-mean()-Y"      "tBodyGyroJerk-mean()-Z"      "tBodyGyroJerk-std()-X"      
[31] "tBodyGyroJerk-std()-Y"       "tBodyGyroJerk-std()-Z"       "tBodyAccMag-mean()"         
[34] "tBodyAccMag-std()"           "tGravityAccMag-mean()"       "tGravityAccMag-std()"       
[37] "tBodyAccJerkMag-mean()"      "tBodyAccJerkMag-std()"       "tBodyGyroMag-mean()"        
[40] "tBodyGyroMag-std()"          "tBodyGyroJerkMag-mean()"     "tBodyGyroJerkMag-std()"     
[43] "fBodyAcc-mean()-X"           "fBodyAcc-mean()-Y"           "fBodyAcc-mean()-Z"          
[46] "fBodyAcc-std()-X"            "fBodyAcc-std()-Y"            "fBodyAcc-std()-Z"           
[49] "fBodyAccJerk-mean()-X"       "fBodyAccJerk-mean()-Y"       "fBodyAccJerk-mean()-Z"      
[52] "fBodyAccJerk-std()-X"        "fBodyAccJerk-std()-Y"        "fBodyAccJerk-std()-Z"       
[55] "fBodyGyro-mean()-X"          "fBodyGyro-mean()-Y"          "fBodyGyro-mean()-Z"         
[58] "fBodyGyro-std()-X"           "fBodyGyro-std()-Y"           "fBodyGyro-std()-Z"          
[61] "fBodyAccMag-mean()"          "fBodyAccMag-std()"           "fBodyBodyAccJerkMag-mean()" 
[64] "fBodyBodyAccJerkMag-std()"   "fBodyBodyGyroMag-mean()"     "fBodyBodyGyroMag-std()"     
[67] "fBodyBodyGyroJerkMag-mean()" "fBodyBodyGyroJerkMag-std()" 
# GettingCleaningDataCourseProject

The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.  

One of the most exciting areas in all of data science right now is wearable computing - see for example  this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the [data was obtained](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).

Here are the [data for the project](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip).

You should create one R script called run_analysis.R that does the following. 

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names. 
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# run_analysis.R

This R script completes all of the tasks above.  It depends on the library "dplyr" which is available using the normal `install.packages("dplyr")` command.

# Datasets within the code

These datasets are raw data read in from the data supplied at the link above.

* `testsubject` <- test/subject_test.txt
* `testactivity` <- test/y_test.txt
* `testdata` <- test/X_test.txt
* `trainsubject` <- train/subject_train.txt
* `trainactivity` <- train/y_train.txt
* `traindata` <- train/X_train.txt
* `features` <- features.txt
* `activitynames` <- activity_labels.txt

In order to process the required fields, a logical vector listing TRUE for column names with "mean" or "std" in the column name was created and stored in `meanstdcols` from `features` using:

*`meanstdcols <- grepl("(std|mean[^F])", features$V2)`

The `features` data set was cleaned of bad characters using:

*`features$V2 <- gsub("[^[:alnum:]///' ]", "", features$V2)`

The updated `features$V2` and `meanstdcols` vector to create the `testdataext` and `traindataext` data sets which only contain the data that is needed according to the second requirement above.

Next, a complete `test` and `train` data set is created combining a type designation for "test" or "train", the subject, activity, and the extracted data using:

*`test <- cbind(type="test",testsubject,testactivity,testdataext)`
*`train <- cbind(type="train",trainsubject,trainactivity,traindataext)`

`dplyr` is used to `filter` and `mutate` the `test` and `train` data sets so that a readable activity name replaces the activity indices.  Interim data sets `testact1:testact6` and `trainact1:trainact6` are used to accomplish this task.  For example:

*`test <- tbl_df(test)`
*`testact1 <- filter(test,activity==1)`
*`testact1 <- mutate(testact1,activity=activitynames$V2[[1]])`

Then the `test` and `train` data sets are combined to create a single `tidydata` data set with dimensions 10299 by 69.  

In order to adress the fifth requirement above, `tidydataave` was created using `summarise_each` from `dplyr` with dimensions 180 by 69.  This datasets is organized by subject, activity, and type using:

*`avedataset <- tbl_df(tidydata)`
*`avedataset <- group_by(avedataset, subject, activity, type)`

`tidydataave<- summarise_each(avedataset,funs(mean))`

`tidydata` and `tidydataave` are written to disk:

*`write.table(tidydata, "tidyData.txt", row.name=FALSE)`
*`write.table(tidydataave, "tidyData2.txt", row.name=FALSE)`
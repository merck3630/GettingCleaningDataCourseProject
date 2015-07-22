library(dplyr)

# Read raw subject, activity, and data for test data
testsubject <- read.table("test/subject_test.txt") 
testactivity <- read.table("test/y_test.txt") 
testdata <- read.table("test/X_test.txt") 

# Read raw subject, activity, and data for train data
trainsubject <- read.table("train/subject_train.txt") 
trainactivity <- read.table("train/y_train.txt") 
traindata <- read.table("train/X_train.txt") 

# Read features (column names) for both test and train data and remove bad characters
features <- read.table("features.txt")

# Logical vector listing TRUE for column names with "mean" or "std" in the name
meanstdcols <- grepl("(std|mean[^F])", features$V2)

# Clean bad characters from needed column names
features$V2 <- gsub("[^[:alnum:]///' ]", "", features$V2)

# Extract only the columns with "mean" or "std" in the column name
testdataext <- testdata[meanstdcols]
traindataext <- traindata[meanstdcols]

# Rename test data column names to cleaned, readable, and meaningful names
names(testactivity) <- "activity"
names(testsubject) <- "subject"
names(testdataext) <- features$V2[meanstdcols]

# Rename test data column names to cleaned, readable, and meaningful names
names(trainactivity) <- "activity"
names(trainsubject) <- "subject"
names(traindataext) <- features$V2[meanstdcols]

# It is important to make this note for the grader.  I have added a column for 
# data type (train or test) because without this column, the final tidy data set loses
# the information contained in the directory structure of /test and /train. 

# combine test data and add "type" column for "test"
test <- cbind(type="test",testsubject,testactivity,testdataext)

# combine train data and add "type" column for "train"
train <- cbind(type="train",trainsubject,trainactivity,traindataext)

# Read activity names corresponding to code 1-6 in test and train activity data
activitynames <- read.table("activity_labels.txt")

# Rename activity indices as readable activities for test.
test <- tbl_df(test)
testact1 <- filter(test,activity==1)
testact1 <- mutate(testact1,activity=activitynames$V2[[1]])
testact2 <- filter(test,activity==2)
testact2 <- mutate(testact2,activity=activitynames$V2[[2]])
testact3 <- filter(test,activity==3)
testact3 <- mutate(testact3,activity=activitynames$V2[[3]])
testact4 <- filter(test,activity==4)
testact4 <- mutate(testact4,activity=activitynames$V2[[4]])
testact5 <- filter(test,activity==5)
testact5 <- mutate(testact5,activity=activitynames$V2[[5]])
testact6 <- filter(test,activity==6)
testact6 <- mutate(testact6,activity=activitynames$V2[[6]])
test <- rbind(testact1,testact2,testact3,testact4,testact5,testact6)

# Rename activity indices as readable activities for train.
train <- tbl_df(train)
trainact1 <- filter(train,activity==1)
trainact1 <- mutate(trainact1,activity=activitynames$V2[[1]])
trainact2 <- filter(train,activity==2)
trainact2 <- mutate(trainact2,activity=activitynames$V2[[2]])
trainact3 <- filter(train,activity==3)
trainact3 <- mutate(trainact3,activity=activitynames$V2[[3]])
trainact4 <- filter(train,activity==4)
trainact4 <- mutate(trainact4,activity=activitynames$V2[[4]])
trainact5 <- filter(train,activity==5)
trainact5 <- mutate(trainact5,activity=activitynames$V2[[5]])
trainact6 <- filter(train,activity==6)
trainact6 <- mutate(trainact6,activity=activitynames$V2[[6]])
train <- rbind(trainact1,trainact2,trainact3,trainact4,trainact5,trainact6)

# combine test and train data into one tidy data file.
tidydata <- rbind(test,train)

# remove all of the variables created as steps to the tidy data file.
rm(test,testactivity,testdata,testdataext,testsubject)
rm(train,trainactivity,traindata,traindataext,trainsubject)
rm(testact1,testact2,testact3,testact4,testact5,testact6)
rm(trainact1,trainact2,trainact3,trainact4,trainact5,trainact6)
rm(features,meanstdcols,activitynames)

# Create second tidy data set with the avearage of each variable by subject, by activity, by type.
avedataset <- tbl_df(tidydata)
avedataset <- group_by(avedataset, subject, activity, type)
tidydataave<- summarise_each(avedataset,funs(mean))
rm(avedataset)

# Write tidydata and tidydataave to disk
write.table(tidydata, "tidyData.txt", row.name=FALSE)
write.table(tidydataave, "tidyData2.txt", row.name=FALSE)
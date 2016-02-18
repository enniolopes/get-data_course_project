#Getting and Cleaning Data Course Project
#The purpose of this project is to demonstrate ability to collect, work with, and clean a data set.
#The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:
#   http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

#So on, the code here is to perform the steps for the assignment for the course project.
#It does the following:
#   1. Merges the training and the test sets to create one data set.
#   2. Extracts only the measurements on the mean and standard deviation for each measurement.
#   3. Uses descriptive activity names to name the activities in the data set
#   4. Appropriately labels the data set with descriptive variable names.
#   5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


#1. Get, read and merge the data____________________
temp <- tempfile()
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",temp)
features      <- read.table(unz(temp,"UCI HAR Dataset/features.txt"),header=FALSE)
activityType  <- read.table(unz(temp,"UCI HAR Dataset/activity_labels.txt"),header=FALSE, col.names=c('activityId','activityType'))
# the training data
subjectTrain  <- read.table(unz(temp,"UCI HAR Dataset/train/subject_train.txt"),header=FALSE, col.names="subjectId")
xTrain        <- read.table(unz(temp,"UCI HAR Dataset/train/X_train.txt"),header=FALSE,col.names=features[,2])
yTrain        <- read.table(unz(temp,"UCI HAR Dataset/train/y_train.txt"),header=FALSE,col.names="activityId")
trainingData = cbind(yTrain,subjectTrain,xTrain) ; #Merging all the training data set
# the test data
subjectTest   <- read.table(unz(temp,"UCI HAR Dataset/test/subject_test.txt"),header=FALSE,col.names="subjectId")
xTest         <- read.table(unz(temp,"UCI HAR Dataset/test/X_test.txt"),header=FALSE,col.names=features[,2])
yTest         <- read.table(unz(temp,"UCI HAR Dataset/test/y_test.txt"),header=FALSE,col.names="activityId")
testData = cbind(yTest,subjectTest,xTest) ; #Merging all the test data set
# combining all data (trainig and test):
data = rbind(trainingData,testData)
names = colnames(data)
# unlink the temp connection and keeping only the necessary data
unlink(temp)
rm(temp, features, subjectTrain, xTrain, yTrain, subjectTest, xTest, yTest, testData, trainingData)


#2. The mean and the standard deviation_____________
mean_col  <- names(data)[grep("mean",names(data),ignore.case=TRUE)]
std_col   <- names(data)[grep("std",names(data),ignore.case=TRUE)]
meanstd <- data[,c("subjectId","activityId",mean_col,std_col)]


#3. Descriptive names_______________________________
descrnames <- merge(activityType,meanstd,by.x="activityId",by.y="activityId",all=TRUE)

#4. Labels the data set_____________________________
datamelt <- melt(descrnames,id=c("activityId","activityType","subjectId"))

#5. Tidy data set with the average__________________
meandata <- dcast(datamelt,activityId + activityType + subjectId ~ variable,mean)
write.table(meandata,"./tidy_data.txt")

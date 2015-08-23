
library (dplyr)

# Downdload the dataset using the link and unzip in the working directory "data"
# --------------------------------------------------------------------------------

setwd("./data")
destfilename <- "project.zip"

if (!files.exists(destfilename)){

dlink <-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
download.file(dlink,destfilename, method="auto",mode="wb")

}
if (!file.exists("UCI HAR Dataset")) { 
  unzip(destfilename) 
}
setwd("./UCI HAR Dataset")

# Read the activity_labels and features ".txt" files
# --------------------------------------------------

features <- read.table("features.txt", header = FALSE)
activitylabels <- read.table("activity_labels.txt" , header = FALSE)


# Read the  subject, X and Y ".txt" files from test and train folders
# -------------------------------------------------------------------

subjectTest <- read.table("./test/subject_test.txt", header=FALSE)
xTest <- read.table("./test/X_test.txt", header= FALSE)
yTest <- read.table("./test/Y_test.txt", header= FALSE)

subjectTrain <- read.table("./train/subject_train.txt", header=FALSE)
xTrain <- read.table("./train/X_train.txt", header= FALSE)
yTrain <- read.table("./train/y_train.txt", header= FALSE)

# Change column names to aid merging
# ----------------------------------

colnames(activitylables)  = c('activityId','activityType')
colnames (subjectTrain) = "subID"
colnames (subjectTest) = "subID"

colnames(xTest) = features[,2]
colnames(xTrain) = features[,2]

colnames(yTest) = "activityId"
colnames(yTrain) = "activityId"

# Create complete Train dataset

trainData <- cbind(yTrain,subjectTrain,xTrain)

# Create complete Test dataset

testData <- cbind(yTest, subjectTest,xTest)

#1> Merge Train and Test datasets to create final dataset
#   -----------------------------------------------------

finalData <- rbind(trainData,testData)

#2> Extract only the measurements on the mean and standard deviation for each measurement.
#   --------------------------------------------------------------------------------------

meanStdcolind <- grep(".*mean.*|.*std.*", colnames(finalData))

exdf <- finalData[,c(1:2,meanStdcolind)]

#3> Use descriptive activity names to name the activities in the data set (replace activity Id by activity Names)
#   ------------------------------------------------------------------------------------------------------------

len1 = nrow(finalData)
len2 = nrow(activitylabels)

for (i in 1:len1){
  for ( j in 1:len2){
    if (finalData[i,1]== j) 
      finalData[i,1] <- as.character(activitylabels[j,2])
  }
}


#4> Appropriately label the data set with descriptive variable names. 
#   -----------------------------------------------------------------

colNames  = colnames(finalData)

# Cleaning up the variable names
for (i in 1:length(colNames)) 
{
  colNames[i] = gsub("\\()","",colNames[i])
  colNames[i] = gsub("-std$","StdDev",colNames[i])
  colNames[i] = gsub("-mean","Mean",colNames[i])
  colNames[i] = gsub("^(t)","time",colNames[i])
  colNames[i] = gsub("^(f)","freq",colNames[i])
  colNames[i] = gsub("([Gg]ravity)","Gravity",colNames[i])
  colNames[i] = gsub("([Bb]ody[Bb]ody|[Bb]ody)","Body",colNames[i])
  colNames[i] = gsub("[Gg]yro","Gyro",colNames[i])
  colNames[i] = gsub("AccMag","AccMagnitude",colNames[i])
  colNames[i] = gsub("([Bb]odyaccjerkmag)","BodyAccJerkMagnitude",colNames[i])
  colNames[i] = gsub("JerkMag","JerkMagnitude",colNames[i])
  colNames[i] = gsub("GyroMag","GyroMagnitude",colNames[i])
}



validColNames <- make.names(names = names(finalData) , unique = TRUE , allow_ = TRUE)
names(finalData) <- validColNames

finalData <- rename (finalData, ActivityName = activityId )

tempdf<-finalData


#5> From the data set in step 4, create a second, 
#   independent tidy data set with the average of each variable for each activity and each subject.
#  ------------------------------------------------------------------------------------------------

 tidy <- finalData %>% group_by ( ActivityName,subID) %>% summarise_each (funs(mean))

write.table(tidy, "tidyData.txt", row.names = FALSE )

























Summary
-------

The script run_analysis.R performs the 5 steps described in the course project's definition.

We start by reading the raw data given in .txt file and merge the train and test cases using the rbind() function. By similar, we address those files having the same number of columns and referring to the same entities.

Then, only those columns with the mean and standard deviation measures are taken from the whole dataset. 

After extracting these columns, they are given the correct names, taken from features.txt.
As activity data is addressed with values 1:6, we take the activity names and IDs from activity_labels.txt and they are substituted in the dataset.

On the whole dataset, those columns with vague column names are corrected using make.names function in R.

Finally, we generate a new dataset with all the average measures for each subject and activity type (30 subjects * 6 activities = 180 rows). The output file is called tidyData.txt, and uploaded to this repository.


Variables
---------


xTrain, yTrain, xTest, yTest, subjectTrain and subjectTest contain the data from the downloaded files.

we use cbind to column bind yTrain , subjectTrain and xTrain to get complete trainData. 
Similar approach with Test set give us complete testData

Then we rbind to row bind together to merge Train and test datasets to get the complete dataset stored in finalData.

x_data, y_data and subject_data merge the previous datasets to further analysis.

Finally, tidyData contains the relevant averages grouped by ActivityName and SubId which will be later stored in a .txt file. 

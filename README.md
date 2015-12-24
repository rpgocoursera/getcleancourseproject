
# Readme

This Readme file describes the repository as part of getting and cleaning observationd data captured with Samsung S2.  The repository contains the following:
* Cookbook.md - This markdown file describes the experiment undertaken (ie source data), the description of data used for cleaning, the observed data set and the transformed subset of data (ie.tidy data)
* run_analysis.R - This is the R program use to combine the data (test and train data set) and clean the data into a data set. Please see below for further information
* tidydata.txt - This is the final output of the data.


## run_analysis.R
R script called run_analysis.R as been created that does the following. 
* Merges the training and the test sets to create one data set.
* Extracts only the measurements on the mean and standard deviation for each measurement. 
* Uses descriptive activity names to name the activities in the data set
* Appropriately labels the data set with descriptive variable names. 
* From the data set in step above, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
* Output the tidy data set into tidydata.txt

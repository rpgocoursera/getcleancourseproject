#############################################################################################
## Name       : run_analysis.R
## Description: The code reads data from the experiment "Human Activity Recognition Using 
##              Smartphones Data Set" using Samsung S2. The code does the following
##              1. Merges the training and the test sets to create one data set.
##              2. Extracts only the measurements on the mean and standard deviation for each 
##                 measurement. 
##              3. Uses descriptive activity names to name the activities in the data set
##              4. Appropriately labels the data set with descriptive variable names. 
##              5. From the data set in step 4, creates a second, independent tidy data set 
##                 with the average of each variable for each activity and each subject.
##
#############################################################################################

#############################################################################################
## Load library
#############################################################################################
library( dplyr )
library( data.table )


#############################################################################################
## Data files for cleanup
#############################################################################################
fileActivityLabel = "./UCI HAR Dataset/activity_labels.txt"
fileFeatures      = "./UCI HAR Dataset/features.txt"
fileTrainSubject  = "./UCI HAR Dataset/train/subject_train.txt"
fileTrainX        = "./UCI HAR Dataset/train/X_train.txt"
fileTrainY        = "./UCI HAR Dataset/train/Y_train.txt"
fileTestSubject   = "./UCI HAR Dataset/test/subject_test.txt"
fileTestX         = "./UCI HAR Dataset/test/X_test.txt"
fileTestY         = "./UCI HAR Dataset/test/Y_test.txt"


#############################################################################################
## Read data files
#############################################################################################
setwd( "C:/Coursera/03 Getting Cleaning Data/Week 3/Project" )

dtActivityLabel = read.table( fileActivityLabel, sep = "" , header = FALSE, na.strings ="", stringsAsFactors= FALSE )
dtFeatures      = read.table( fileFeatures, sep = "" , header = FALSE, na.strings ="", stringsAsFactors= FALSE )
dtTrainSubject  = read.table( fileTrainSubject, sep = "" , header = FALSE, na.strings ="", stringsAsFactors= FALSE )
dtTrainX        = read.table( fileTrainX, sep = "" , header = FALSE, na.strings ="", stringsAsFactors= FALSE )
dtTrainY        = read.table( fileTrainY, sep = "" , header = FALSE, na.strings ="", stringsAsFactors= FALSE )
dtTestSubject   = read.table( fileTestSubject, sep = "" , header = FALSE, na.strings ="", stringsAsFactors= FALSE )
dtTestX         = read.table( fileTestX, sep = "" , header = FALSE, na.strings ="", stringsAsFactors= FALSE )
dtTestY         = read.table( fileTestY, sep = "" , header = FALSE, na.strings ="", stringsAsFactors= FALSE )


#############################################################################################
## 3. Uses descriptive activity names to name the activities in the data set
#############################################################################################
dtTestY$Act  = ifelse( dtTestY$V1 == c(dtActivityLabel[1,1]), c(dtActivityLabel[1,2]), ifelse( dtTestY$V1 == c(dtActivityLabel[2,1]), c(dtActivityLabel[2,2]), ifelse( dtTestY$V1 == c(dtActivityLabel[3,1]), c(dtActivityLabel[3,2]), ifelse( dtTestY$V1 == c(dtActivityLabel[4,1]), c(dtActivityLabel[4,2]), ifelse( dtTestY$V1 == c(dtActivityLabel[5,1]), c(dtActivityLabel[5,2]), ifelse( dtTestY$V1 == c(dtActivityLabel[6,1]), c(dtActivityLabel[6,2]), "NA" ) ) ) ) ) )

dtTrainY$Act = ifelse( dtTrainY$V1 == c(dtActivityLabel[1,1]), c(dtActivityLabel[1,2]), ifelse( dtTrainY$V1 == c(dtActivityLabel[2,1]), c(dtActivityLabel[2,2]), ifelse( dtTrainY$V1 == c(dtActivityLabel[3,1]), c(dtActivityLabel[3,2]), ifelse( dtTrainY$V1 == c(dtActivityLabel[4,1]), c(dtActivityLabel[4,2]), ifelse( dtTrainY$V1 == c(dtActivityLabel[5,1]), c(dtActivityLabel[5,2]), ifelse( dtTrainY$V1 == c(dtActivityLabel[6,1]), c(dtActivityLabel[6,2]), "NA" ) ) ) ) ) )

#############################################################################################
## 1. Merges the training and the test sets to create one data set.
##    Add subjects and activities Test and Train merged data:
##     - Copy the Train and Test Subjects
##     - Rename header to Subject
##     - Add the activity from above
#############################################################################################
dtTestMerged = copy( dtTestSubject )
dtTrainMerged = copy( dtTrainSubject )

dtTestMerged = rename( dtTestMerged, Subject=V1 )
dtTrainMerged = rename( dtTrainMerged, Subject=V1 )

dtTestMerged = mutate( dtTestMerged, Activity=dtTestY$Act )
dtTrainMerged = mutate( dtTrainMerged, Activity=dtTrainY$Act )


#############################################################################################
## 2. Extracts only the measurements on the mean and standard deviation for each measurement 
##
##    Merges the training and the test sets to create one data set:
##    - Rename the columns to label from Features
##    - Combine Train and Test observation as a merged data
##    - Subset columns of means and standard deviation
##    - Add Subject and activities to the final merged data set
#############################################################################################
colnames( dtTestX ) = c( dtFeatures$V2 )
colnames( dtTrainX ) = c( dtFeatures$V2 )

dtFinalMerged =  rbind( cbind( dtTestMerged, dtTestX ), cbind( dtTrainMerged, dtTrainX ) )
dtFinalMerged =  cbind( dtFinalMerged[ , grepl( "std()" , names( dtFinalMerged ), fixed=TRUE ) ] , dtFinalMerged[ , grepl( "mean()" , names( dtFinalMerged ), fixed=TRUE ) ] )
dtFinalMerged =  cbind( rbind( dtTestMerged, dtTrainMerged ), dtFinalMerged )


#############################################################################################
## 4. Appropriately labels the data set with descriptive variable names. 
##
##   Appropriately labels the data set with new descriptive variable names by:
##   - Replacing tBody with TimeBody
##   - Replacing fBody with FrequencyBody
##   - Replacing tGravity with TimeGravity
##   - Replacing Acc with Accelerate
##   - Replacing std() with StandardDeviation
##   - Replacing mean() with Mean
##   - Replacing Mag with Magnitude
##   - Replacing Gyro- with Gyro
##   - Replacing "-" with blank
##   - Replacing "()" with blank
#############################################################################################
names( dtFinalMerged ) = gsub( "tBody", "TimeBody", names( dtFinalMerged ) )
names( dtFinalMerged ) = gsub( "fBody", "FrequencyBody", names( dtFinalMerged ) )
names( dtFinalMerged ) = gsub( "tGravity", "TimeGravity", names( dtFinalMerged ) )
names( dtFinalMerged ) = gsub( "Acc", "Accelerometer", names( dtFinalMerged ) )
names( dtFinalMerged ) = gsub( "Gyro", "Gyroscope", names( dtFinalMerged ) )
names( dtFinalMerged ) = gsub( "std", "StandardDeviation", names( dtFinalMerged ) )
names( dtFinalMerged ) = gsub( "mean", "Mean", names( dtFinalMerged ) )
names( dtFinalMerged ) = gsub( "Mag", "Magnitude", names( dtFinalMerged ) )
names( dtFinalMerged ) = gsub( "-", "", names( dtFinalMerged ) )
names( dtFinalMerged ) = gsub( "\\(\\)", "", names( dtFinalMerged ) )


#############################################################################################
## 5. From the data set in step 4, creates a second, independent tidy data set 
##    with the average of each variable for each activity and each subject.
## 
##     Output data set as a txt file created with write.table() using row.name=FALSE
#############################################################################################
dtTidyData = aggregate(. ~Subject + Activity, dtFinalMerged, mean )
dtTidyData = dtTidyData[ order( dtTidyData$Subject, dtTidyData$Activity ), ]

write.table( dtTidyData, file = "tidydata.txt", col.names = TRUE, row.name=FALSE, quote=FALSE )

##run_analysis.R
## DIRECTIONS:
##You should create one R script called run_analysis.R that does the following. 
##Merges the training and the test sets to create one data set.
##Extracts only the measurements on the mean and standard deviation for each measurement. 
##Uses descriptive activity names to name the activities in the data set
##Appropriately labels the data set with descriptive variable names. 
##From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
##SOURCE:
## DATA: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20Har%20Dataset.zip
##DESCRIPTION OF DATA: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20Har%20Dataset.zip


## load activity_labels and features
actlabel <- read.table("UCI HAR Dataset/activity_labels.txt")
actlabel[,2] <- as.character(actlabel[,2])
feat <- read.table("UCI HAR Dataset/features.txt")
feat[,2] <- as.character(feat[,2])

## extracts only measurements on mean and standard deviation
usefeat <- grep(".*mean.*|.*std.*", feat[,2])
usefeat.names <- feat[usefeat,2]
usefeat.names = gsub('-mean', 'Mean', usefeat.names)
usefeat.names = gsub('-std', 'Std', usefeat.names)
usefeat.names <- gsub('[-()]', '', usefeat.names)


## loads datasets
train <- read.table("UCI HAR Dataset/train/X_train.txt")[usefeat]
trainacts <- read.table("UCI HAR Dataset/train/Y_train.txt")
trainsubj <- read.table("UCI HAR Dataset/train/subject_train.txt")
train <- cbind(trainsubj, trainacts, train)

test <- read.table("UCI HAR Dataset/test/X_test.txt")[usefeat]
testacts <- read.table("UCI HAR Dataset/test/Y_test.txt")
testsubj <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(testsubj, testacts, test)

# merge datasets and add labels
data <- rbind(train, test)
colnames(data) <- c("subject", "activity", usefeat.names)

# turn activities & subjects into factors
data$activity <- factor(data$activity, levels = actlabel[,1], labels = actlabel[,2])
data$subject <- as.factor(data$subject)

##melts data
data.melted <- melt(data, id = c("subject", "activity"))
data.mean <- dcast(data.melted, subject + activity ~ variable, mean)

##writes data to a file called "tidy_data.txt" in the UCI Har Dataset folder
write.table(data.mean, "UCI Har Dataset/tidy_data.txt", row.names = FALSE, quote= FALSE)
tidy_data_ <- read.table("UCI Har Dataset/tidy_data.txt")
head(tidy_data)



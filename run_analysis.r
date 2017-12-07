#Set working Directory
setwd("/User/cherry/Data")
#Download files in working directory
download.file("http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones", destfile = "./", method = "libcurl")
#Change working directory to UCI HAR Daraset
setwd("./UCI HAR Dataset")
#load library "dplyr"
library("dplyr")

#Read features and activities data in dataframe form
features <- read.table("features.txt")
activity <- read.table("activity_labels.txt")

#Add column name for dataframe named "activity"
colnames(activity) <- c("number", "lables")

#Read test data, subjects and activities in dataframe form
test_x <- read.table("./test/X_test.txt")
test_y <- read.table("./test/y_test.txt")
test_subject <- read.table("./test/subject_test.txt")

#Add column name for test data, subjects and activities
colnames(test_x) <- features[,2]
colnames(test_y) <- c("activity")
colnames(test_subject) <- c("subject")

#Read train data, subjects and activities in dataframe form
train_x <- read.table("./train/X_train.txt")
train_y <- read.table("./train/y_train.txt")
train_subject <- read.table("./train/subject_train.txt")

#Add column name for train data, subjects and activities
colnames(train_x) <- features[,2]
colnames(train_y) <- c("activity")
colnames(train_subject) <- c("subject")

#combine test data, subjects and activities together
test_data <- cbind(test_x, test_y, test_subject)

#combine train data, subjects and activities together
train_data <- cbind(train_x, train_y, train_subject)

#combine train and test data together
data <- rbind(test_data, train_data)

#Extracts only the measurements on the mean and standard deviation for each measurement
x <- grep(".*mean.*|.*std.*", colnames(data), value = TRUE)
data_want <- data[, x]

#Uses descriptive activity names to name the activities in the data set
data$activity <- factor(data$activity, levels = activity[, 1], labels = activity[, 2])

#calculate mean data of each variable by subjects and activities
tidy <- aggregate(data, by = list(data$activity, data$subject), FUN = "mean")
write.table(tidy, "tidy.txt", sep = "\t", row.name = FALSE)
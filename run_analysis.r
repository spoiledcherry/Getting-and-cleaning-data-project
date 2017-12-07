#Set working directory
setwd("/User/cherry/Data")
#Download files
download.file("http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones", destfile = "./", method = "libcurl")
#change working directory
setwd("./UCI HAR Dataset")

#Read features and activities in data frame form
features <- read.table("features.txt")
activity <- read.table("activity_labels.txt")
#Add column name for activities
colnames(activity) <- c("number", "lables")

#read test data, subjects and activities in data frame form
test_x <- read.table("./test/X_test.txt")
test_y <- read.table("./test/y_test.txt")
test_subject <- read.table("./test/subject_test.txt")

#Add column name for all test data, subjects and activities
colnames(test_x) <- features[,2]
colnames(test_y) <- c("activity")
colnames(test_subject) <- c("subject")

#read train data, subjects and activities in data frame form
train_x <- read.table("./train/X_train.txt")
train_y <- read.table("./train/y_train.txt")
train_subject <- read.table("./train/subject_train.txt")

#Add column name for all train data, subjects and activities
colnames(train_x) <- features[,2]
colnames(train_y) <- c("activity")
colnames(train_subject) <- c("subject")

#Combine test and train data with subjexts and activities
test_data <- cbind(test_x, test_y, test_subject)
train_data <- cbind(train_x, train_y, train_subject)

#Combine test data with train data
data <- rbind(test_data, train_data)

#Extracts only the measurements on the mean and standard deviation for each measurement
x <- grep(".*mean.*|.*std.*", colnames(data), value = TRUE)
data_want <- data[, x]

#creates a second, independent tidy data set with the average of each variable for each activity and each subject
data$activity <- factor(data$activity, levels = activity[, 1], labels = activity[, 2])
tidy <- aggregate(data, by = list(data$activity, data$subject), FUN = "mean")
write.table(tidy, "tidy.txt", sep = "\t", row.name = FALSE)

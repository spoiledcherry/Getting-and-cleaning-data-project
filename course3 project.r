features <- read.table("features.txt")
activity <- read.table("activity_labels.txt")
colnames(activity) <- c("number", "lables")
test_x <- read.table("./test/X_test.txt")
colnames(test_x) <- features[,2]
test_y <- read.table("./test/y_test.txt")
colnames(test_y) <- c("activity")
train_x <- read.table("./train/X_train.txt")
colnames(train_x) <- features[,2]
train_y <- read.table("./train/y_train.txt")
colnames(train_y) <- c("activity")
test_subject <- read.table("./test/subject_test.txt")
colnames(test_subject) <- c("subject")
train_subject <- read.table("./train/subject_train.txt")
colnames(train_subject) <- c("subject")
test_data <- cbind(test_x, test_y, test_subject)
train_data <- cbind(train_x, train_y, train_subject)
data <- rbind(test_data, train_data)
x <- grep(".*mean.*|.*std.*", colnames(data), value = TRUE)
data_want <- data[, x]
data$activity <- factor(data$activity, levels = activity[, 1], labels = activity[, 2])
tidy <- aggregate(data, by = list(data$activity, data$subject), FUN = "mean")
write.table(tidy, "tidy.txt", sep = "\t", row.name = FALSE)
setwd("/Users/moderato/Desktop/r_wd/UCI HAR Dataset")
library(data.table)

# Read the original data
subject_test <- read.table("./test/subject_test.txt")
X_test <- read.table("./test/X_test.txt")
y_test <- read.table("./test/y_test.txt")
subject_train <- read.table("./train/subject_train.txt")
X_train <- read.table("./train/X_train.txt")
y_train <- read.table("./train/y_train.txt")
labels <- read.table("activity_labels.txt")
features <- read.table("features.txt")

# Merge testing and training data
data_set_temp <- rbind(X_test, X_train)
subject <- rbind(subject_test, subject_train)

# Change activity name from numbers to corresponding strings
for (i in 1:length(y_test[,1])){
  y_test[i,1] <- as.character(labels[which(labels[,1] %in% y_test[i,1]),2])
}
for (i in 1:length(y_train[,1])){
  y_train[i,1] <- as.character(labels[which(labels[,1] %in% y_train[i,1]),2])
}
activity <- rbind(y_test, y_train)

# Garbage collection
rm(subject_test,subject_train,X_test,X_train,y_test,y_train,labels)
gc()

# Give names to columns in this intermediate data set
colnames(data_set_temp) <- as.character(features[,2])

# Extract columns for mean and standard deviation from the intermediate data set. Add activity and subject number
data_set<- cbind(data_set_temp[,sort(c(grep("-mean()", names(data_set_temp)), grep("-std()", names(data_set_temp))))],activity)
data_set <- cbind(data_set, subject)
colnames(data_set)[dim(data_set)[2]-1] <- "activity"
colnames(data_set)[dim(data_set)[2]] <- "subject"

# Split the data set according to activities and subjects and create a new tidy data set. Name the columns and rows in the new data set
temp <- split(data_set, list(data_set$"activity", data_set$"subject"))
new_set <- data.frame()
activity_subject <- data.frame()
for (i in 1:length(names(temp))){
  new_set <- rbind(new_set, apply(temp[[i]][,1:(dim(data_set)[2]-2)], 2, mean))
  activity_subject <- rbind(activity_subject, temp[[i]][1,(dim(data_set)[2]-1):(dim(data_set)[2])])
}
new_set <- cbind(new_set, activity_subject)
colnames(new_set) <- colnames(data_set[,1:dim(data_set)[2]])
rownames(new_set) <- names(temp)

# Garbage collection
rm(activity, activity_subject, data_set, data_set_temp, features, subject, i, name, temp)
gc()

# Output the tidy data set
write.table(new_set, file = "new.txt", row.names = FALSE, col.names = TRUE)

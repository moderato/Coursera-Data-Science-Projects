setwd("/Users/moderato/Desktop/r_wd/UCI HAR Dataset")
library(data.table)
library(plyr)
# Read all the detail data tables
body_acc_x_test <- read.table("./test/Inertial Signals/body_acc_x_test.txt")
body_acc_y_test <- read.table("./test/Inertial Signals/body_acc_y_test.txt")
body_acc_z_test <- read.table("./test/Inertial Signals/body_acc_z_test.txt")
body_gyro_x_test <- read.table("./test/Inertial Signals/body_gyro_x_test.txt")
body_gyro_y_test <- read.table("./test/Inertial Signals/body_gyro_y_test.txt")
body_gyro_z_test <- read.table("./test/Inertial Signals/body_gyro_z_test.txt")
total_acc_x_test <- read.table("./test/Inertial Signals/total_acc_x_test.txt")
total_acc_y_test <- read.table("./test/Inertial Signals/total_acc_y_test.txt")
total_acc_z_test <- read.table("./test/Inertial Signals/total_acc_z_test.txt")
body_acc_x_train <- read.table("./train/Inertial Signals/body_acc_x_train.txt")
body_acc_y_train <- read.table("./train/Inertial Signals/body_acc_y_train.txt")
body_acc_z_train <- read.table("./train/Inertial Signals/body_acc_z_train.txt")
body_gyro_x_train <- read.table("./train/Inertial Signals/body_gyro_x_train.txt")
body_gyro_y_train <- read.table("./train/Inertial Signals/body_gyro_y_train.txt")
body_gyro_z_train <- read.table("./train/Inertial Signals/body_gyro_z_train.txt")
total_acc_x_train <- read.table("./train/Inertial Signals/total_acc_x_train.txt")
total_acc_y_train <- read.table("./train/Inertial Signals/total_acc_y_train.txt")
total_acc_z_train <- read.table("./train/Inertial Signals/total_acc_z_train.txt")

subject_test <- read.table("./test/subject_test.txt")
X_test <- read.table("./test/X_test.txt")
y_test <- read.table("./test/y_test.txt")
subject_train <- read.table("./train/subject_train.txt")
X_train <- read.table("./train/X_train.txt")
y_train <- read.table("./train/y_train.txt")
labels <- read.table("activity_labels.txt")

##### Step 1. Merge the test and train data
body_acc_x <- rbind(body_acc_x_test, body_acc_x_train)
body_acc_y <- rbind(body_acc_y_test, body_acc_y_train)
body_acc_z <- rbind(body_acc_z_test, body_acc_z_train)
body_gyro_x <- rbind(body_gyro_x_test, body_gyro_x_train)
body_gyro_y <- rbind(body_gyro_y_test, body_gyro_y_train)
body_gyro_z <- rbind(body_gyro_z_test, body_gyro_z_train)
total_acc_x <- rbind(total_acc_x_test, total_acc_x_train)
total_acc_y <- rbind(total_acc_y_test, total_acc_y_train)
total_acc_z <- rbind(total_acc_z_test, total_acc_z_train)
# Remove garbage variable to save space 
rm(body_acc_x_test,body_acc_y_test,body_acc_z_test)
rm(body_acc_x_train,body_acc_y_train,body_acc_z_train)
rm(body_gyro_x_test,body_gyro_y_test,body_gyro_z_test)
rm(body_gyro_x_train,body_gyro_y_train,body_gyro_z_train)
rm(total_acc_x_test,total_acc_y_test,total_acc_z_test)
rm(total_acc_x_train,total_acc_y_train,total_acc_z_train)
gc()

colnames(body_acc_x) <- paste(rep("body_acc_x.", 128), 1:128, sep = "")
colnames(body_acc_y) <- paste(rep("body_acc_y.", 128), 1:128, sep = "")
colnames(body_acc_z) <- paste(rep("body_acc_z.", 128), 1:128, sep = "")
colnames(body_gyro_x) <- paste(rep("body_gyro_x.", 128), 1:128, sep = "")
colnames(body_gyro_y) <- paste(rep("body_gyro_y.", 128), 1:128, sep = "")
colnames(body_gyro_z) <- paste(rep("body_gyro_z.", 128), 1:128, sep = "")
colnames(total_acc_x) <- paste(rep("body_acc_x.", 128), 1:128, sep = "")
colnames(total_acc_x) <- paste(rep("body_acc_x.", 128), 1:128, sep = "")
colnames(total_acc_x) <- paste(rep("body_acc_x.", 128), 1:128, sep = "")


l <- list(body_acc_x, body_acc_y, body_acc_z, body_gyro_x, body_gyro_y, body_gyro_z, total_acc_x, total_acc_y, total_acc_z)
data_set <- l[[1]]
for (i in 2:9){
  data_set <- cbind(data_set, l[[i]])
}

rm(l, body_acc_x, body_acc_y, body_acc_z, body_gyro_x, body_gyro_y, body_gyro_z, total_acc_x, total_acc_y, total_acc_z)
gc()

##### Step 2. Extrac the mean and standard deviation of each measurements
mean_stdDev_test <- X_test[,1:2]
mean_stdDev_train <- X_train[,1:2]
mean_stdDev <- rbind(mean_stdDev_test, mean_stdDev_train)
rm(mean_stdDev_test, mean_stdDev_train, X_test, X_train)

##### Step 3. Name the activities in the data set
for (i in 1:length(y_test[,1])){
  y_test[i,1] <- as.character(labels[which(labels[,1] %in% y_test[i,1]),2])
}
for (i in 1:length(y_train[,1])){
  y_train[i,1] <- as.character(labels[which(labels[,1] %in% y_train[i,1]),2])
}
activity <- rbind(y_test, y_train)
rm(y_test,y_train)
gc()


# body_acc_x[,129] <- c(rep("Test", 2947),rep("Train", 7352))
# body_acc_y[,129] <- c(rep("Test", 2947),rep("Train", 7352))
# body_acc_z[,129] <- c(rep("Test", 2947),rep("Train", 7352))
# body_gyro_x[,129] <- c(rep("Test", 2947),rep("Train", 7352))
# body_gyro_y[,129] <- c(rep("Test", 2947),rep("Train", 7352))
# body_gyro_z[,129] <- c(rep("Test", 2947),rep("Train", 7352))
# total_acc_x[,129] <- c(rep("Test", 2947),rep("Train", 7352))
# total_acc_y[,129] <- c(rep("Test", 2947),rep("Train", 7352))
# total_acc_z[,129] <- c(rep("Test", 2947),rep("Train", 7352))


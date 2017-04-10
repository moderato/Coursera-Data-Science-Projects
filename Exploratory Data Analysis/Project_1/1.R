## Set working directory and read data
#if (getwd() != "C:\\Users\\hp\\Desktop\\r_workspace\\exploratory course\\Project_1"){
#setwd("C:\\Users\\hp\\Desktop\\r_workspace\\exploratory course")}
if (getwd() != "/Users/moderato/Desktop/r_wd"){
  setwd("/Users/moderato/Desktop/r_wd")}
library(data.table)
data_temp <- na.omit(fread("household_power_consumption.txt"))
data <- data_temp[Date=="1/2/2007"|Date=="2/2/2007",]

## Plot image 1
active <- as.numeric(data$Global_active_power)
png("plot1.png",width=480, height=480)
hist(active, breaks = 16,  col = "red", xlim = range(0,6), ylim = range(0,1200), main = "Global Active Power", xlab = "Gloabl Active Power (kilowatts)", cex.axis = 0.85)
dev.off()

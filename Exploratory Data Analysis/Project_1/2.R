## Set working directory and read data
#if (getwd() != "C:\\Users\\hp\\Desktop\\r_workspace\\exploratory course\\Project_1"){
#setwd("C:\\Users\\hp\\Desktop\\r_workspace\\exploratory course")}
if (getwd() != "/Users/moderato/Desktop/r_wd"){
  setwd("/Users/moderato/Desktop/r_wd")}
library(data.table)
data_temp <- na.omit(fread("household_power_consumption.txt"))
data <- data_temp[Date=="1/2/2007"|Date=="2/2/2007",]

## Plot image 2
Sys.setlocale("LC_TIME", "en_US.UTF-8")
active <- as.numeric(data$Global_active_power)
time <- data$Time
date <- data$Date
date_time <- as.POSIXct(strptime(paste(date, time), "%d/%m/%Y %H:%M:%S", tz="GMT"))
png("plot2.png",width=480, height=480)
plot(date_time, active, type = "l", xlab = "", ylab = "Gloabl Active Power (kilowatts)")
dev.off()

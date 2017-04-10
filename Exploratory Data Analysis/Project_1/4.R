## Set working directory and read data
#if (getwd() != "C:\\Users\\hp\\Desktop\\r_workspace\\exploratory course\\Project_1"){
#setwd("C:\\Users\\hp\\Desktop\\r_workspace\\exploratory course")}
if (getwd() != "/Users/moderato/Desktop/r_wd"){
  setwd("/Users/moderato/Desktop/r_wd")}
library(data.table)
data_temp <- na.omit(fread("household_power_consumption.txt"))
data <- data_temp[Date=="1/2/2007"|Date=="2/2/2007",]

active <- as.numeric(data$Global_active_power)
voltage <- data$Voltage
reactive <- data$Global_reactive_power
Sys.setlocale("LC_TIME", "en_US.UTF-8")
time <- data$Time
date <- data$Date
date_time <- as.POSIXct(strptime(paste(date, time), "%d/%m/%Y %H:%M:%S", tz="GMT"))
png("plot4.png",width=480, height=480)
par(mfrow=c(2,2))
## Subplot 1
plot(date_time, active, type = "l", xlab = "", ylab = "Gloabl Active Power")
## Subplot 2
plot(date_time, voltage, type = "l", xlab = "datetime", ylab = "Voltage")
## Subplot 3
plot(date_time, data$Sub_metering_1, type = "l", xlab = "", ylab = "Energy sub metering")
lines(date_time, data$Sub_metering_2, col = "Red")
lines(date_time, data$Sub_metering_3, col = "Blue")
legend("topright", c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lty = c(1,1,1), col = c("Black", "Red", "Blue"), cex = 0.7)
## Subplot 4
plot(date_time, reactive, type = "l", xlab = "datetime", ylab = "Gloabl_reactive_power")
dev.off()

setwd("/Users/moderato/Desktop/r_wd")
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
VehicleIndex <- levels(SCC[,4])[grep("Vehicles",levels(SCC[,4]))]
VehicleSCC <- SCC$SCC[which(SCC[,4] %in% VehicleIndex)]
baltimore <- NEI[NEI$fips==24510,]
Vehicle <- baltimore[which(baltimore$SCC %in% VehicleSCC),]
splitted <- split(Vehicle, Vehicle$year)
summation <- sapply(splitted, function(x){sum(x[,4],na.rm=TRUE)})
df <- data.frame(as.numeric(names(summation)),summation)

png("plot5.png", width=640, height=640)
plot(df[,1],df[,2],type='b',lwd=3, xaxt='n', xlab="Year", ylab="PM2.5 Emission Amount")
axis(1, at = seq(1998, 2009, by = 1), las=2)
title("Pic.5 PM2.5 Emission from Motor Vehicles Sources in Baltimore City from 1999 to 2008")
dev.off()
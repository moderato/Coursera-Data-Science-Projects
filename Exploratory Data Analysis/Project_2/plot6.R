library(reshape2)
library(ggplot2)
setwd("/Users/moderato/Desktop/r_wd")
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
VehicleIndex <- levels(SCC[,4])[grep("Vehicles",levels(SCC[,4]))]
VehicleSCC <- SCC$SCC[which(SCC[,4] %in% VehicleIndex)]
baltimore <- NEI[NEI$fips=="24510",]
losangeles <- NEI[NEI$fips=="06037",]
VehicleB <- baltimore[which(baltimore$SCC %in% VehicleSCC),]
VehicleLA <- losangeles[which(losangeles$SCC %in% VehicleSCC),]
splittedB <- split(VehicleB, VehicleB$year)
summationB <- sapply(splittedB, function(x){sum(x[,4],na.rm=TRUE)})
df <- data.frame(as.numeric(names(summationB)),summationB)
splittedLA <- split(VehicleLA, VehicleLA$year)
summationLA <- sapply(splittedLA, function(x){sum(x[,4],na.rm=TRUE)})
df <- data.frame(df, summationLA)
names(df) <- c("Years", "Baltimore", "Los Angeles")

png("plot6.png", width=640, height=640)
mdf <- melt(df, id.vars="Years", value.name="EmissionAmount",variable.name="City")
fig <- ggplot(data=mdf,aes(x=Years, y=EmissionAmount, colour=City, shape=City))
fig + geom_line() + geom_point() + labs(title="Pic.6 PM2.5 Emission from motor vehicles versus Years in Baltimore and LA", TRUE)
dev.off()

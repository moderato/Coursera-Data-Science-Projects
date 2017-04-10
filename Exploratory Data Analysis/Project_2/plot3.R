library(ggplot2)
library(reshape2)
setwd("/Users/moderato/Desktop/r_wd")
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
baltimore <- NEI[NEI$fips==24510,]
splitByType <- split(baltimore, baltimore$type)
df <- data.frame(c(1999,2002,2005,2008))
for(i in 1:4){
  splitted <- split(splitByType[[i]], splitByType[[i]]$year)
  summation <- sapply(splitted, function(x){sum(x[,4],na.rm=TRUE)})
  df <- data.frame(df, summation)
}
colnames(df) <- c("Years",names(splitByType))

png("plot3.png", width=640, height=640)
mdf <- melt(df, id.vars="Years", value.name="EmissionAmount",variable.name="Types")
fig <- ggplot(data=mdf,aes(x=Years, y=EmissionAmount, colour=Types, shape=Types))
fig + geom_line() + geom_point() + labs(title="Pic.3 PM2.5 Emission of Different Sources versus Years in Baltimore City", TRUE)
dev.off()

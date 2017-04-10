setwd("/Users/moderato/Desktop/r_wd")
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
Comb <- grep("Comb",levels(SCC[,4]))
Coal <- grep("Coal",levels(SCC[,4]))
CoalCombIndex <- levels(SCC[,4])[Comb[which(Comb %in% Coal)]]
CoalCombSCC <- SCC$SCC[which(SCC[,4] %in% CoalCombIndex)]
CoalComb <- NEI[which(NEI$SCC %in% CoalCombSCC),]
splitted <- split(CoalComb, CoalComb$year)
summation <- sapply(splitted, function(x){sum(x[,4],na.rm=TRUE)})
df <- data.frame(as.numeric(names(summation)),summation)

png("plot4.png", width=640, height=640)
plot(df[,1],df[,2],type='b',lwd=3, xaxt='n', xlab="Year", ylab="PM2.5 Emission Amount")
axis(1, at = seq(1998, 2009, by = 1), las=2)
title("Pic.4 Coal Combustion-related PM2.5 Emission Amount from 1999 to 2008")
dev.off()
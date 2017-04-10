setwd("C:\\Users\\hp\\Desktop\\r_workspace\\getting and cleaning data course\\Quizzes")

library(data.table)
data <- fread("getdata-data-ss06hid.csv")
data_new <- split(data)
length(data_new$24)

library(xlsx)
colIndex <- 7:15
rowIndex <- 18:23
dat <- read.xlsx("./getdata-data-DATA.gov_NGAP.xlsx", sheetIndex = 1, colIndex = colIndex, rowIndex = rowIndex)
sum(dat$Zip*dat$Ext,na.rm=T)

library(XML)
doc <- xmlTreeParse("getdata-data-restaurants.xml", useInternal = TRUE)
rootNode <- xmlRoot(doc)
names(rootNode)
zipcode <- xpathSApply(doc, "//zipcode", xmlValue)
zipcode_21231 <- zipcode[zipcode == "21231"]
length(zipcode_21231)

library(data.table)
DT <- fread("getdata-data-ss06pid.csv")
DT[,mean(pwgtp15),by=SEX]

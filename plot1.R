# Make sure these libraries are imported
#library(plyr) 
#library(reshape2)
#library(ggplot2)
#Download Source file and unzip it
# Load the NEI and SCC data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Aggregate the total PM2.5 emission from all sources for each of the Years 1999, 2002,2005, and 2008.
emissionTotals <- aggregate(Emissions ~ year,NEI, sum)

png("plot1.png",width=480,height=480,units="px",bg="transparent")

barplot(
  (emissionTotals$Emissions),
  names.arg=emissionTotals$year,
  xlab="Year",
  ylab="PM2.5 Emissions",
  main="Total PM2.5 Emissions From All US Sources"
)

dev.off()

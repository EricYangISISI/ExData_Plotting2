# Load the NEI and SCC data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#Comparing emissions from motor vehicle sources in Baltimore City (fips == "24510") 
#with emissions from motor vehicle sources in Los Angeles County, California (fips == "06037")
# Get Baltimore emissions from motor vehicle sources
# Get Los Angeles emissions from motor vehicle sources

baltimoreEmissions <- NEI[(NEI$fips=="24510") & (NEI$type=="ON-ROAD"),]
baltimoreTotal <- aggregate(Emissions ~ year, data=baltimoreEmissions, FUN=sum)

laEmissions <- NEI[(NEI$fips=="06037") & (NEI$type=="ON-ROAD"),]
laTotal <- aggregate(Emissions ~ year, data=laEmissions, FUN=sum)

normalize <- function(x) {(x-min(x)) / (max(x)-min(x))}

baltimoreTotal$County <- "Baltimore City, MD"
laTotal$County <- "Los Angeles County, CA"
allEmissions <- rbind(baltimoreTotal, laTotal)

# plot
library(ggplot2)
png("plot6.png",width=480,height=480,units="px",bg="transparent")

ggp <- ggplot(allEmissions, aes(x=factor(year), y=Emissions, fill=County)) +
  geom_bar(stat="identity") + 
  facet_grid(County  ~ ., scales="free") +
  ylab("total emissions (tons)") + 
  xlab("year") +
  ggtitle(expression("Motor Vehicle Source Emissions in Baltimore & LA"))

print(ggp)

dev.off()
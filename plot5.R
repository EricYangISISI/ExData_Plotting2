# Load the NEI and SCC data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Get Baltimore emissions from motor vehicle sources
emissions <- NEI[(NEI$fips=="24510") & (NEI$type=="ON-ROAD"),]
total <- aggregate(Emissions ~ year, data=emissions, FUN=sum)

# plot
library(ggplot2)

png("plot5.png",width=480,height=480,units="px",bg="transparent")

ggp <- ggplot(total, aes(x=factor(year), y=Emissions)) +
  geom_bar(stat="identity", fill="grey") +
  theme_bw()+
  xlab("year") +
  ylab(expression("total PM"[2.5]*" emissions")) +
  ggtitle("Emissions from motor vehicle sources in Baltimore City")

print(ggp)

dev.off()
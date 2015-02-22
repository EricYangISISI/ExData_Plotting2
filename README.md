Exploratory Data Analysis  

Course Project-2 README


============================================

**NOTE: It contains project introduction and my work**

## Introduction

Fine particulate matter (PM2.5) is an ambient air pollutant for which there is strong evidence that it is harmful to human health. In the United States, the Environmental Protection Agency (EPA) is tasked with setting national ambient air quality standards for fine PM and for tracking the emissions of this pollutant into the atmosphere. Approximatly every 3 years, the EPA releases its database on emissions of PM2.5. This database is known as the National Emissions Inventory (NEI). You can read more information about the NEI at the EPA National [Emissions Inventory web site](http://www.epa.gov/ttn/chief/eiinformation.html).

For each year and for each type of PM source, the NEI records how many tons of PM2.5 were emitted from that source over the course of the entire year. The data that you will use for this assignment are for 1999, 2002, 2005, and 2008.

## Data

The data for this assignment are available from the course web site as a single zip file:

* [Data for Peer Assessment [29Mb]](https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip)

The zip file contains two files:

PM2.5 Emissions Data (`summarySCC_PM25.rds`): This file contains a data frame with all of the PM2.5 emissions data for 1999, 2002, 2005, and 2008. For each year, the table contains number of tons of PM2.5 emitted from a specific type of source for the entire year. Here are the first few rows.

    ##     fips      SCC Pollutant Emissions  type year
    ## 4  09001 10100401  PM25-PRI    15.714 POINT 1999
    ## 8  09001 10100404  PM25-PRI   234.178 POINT 1999
    ## 12 09001 10100501  PM25-PRI     0.128 POINT 1999
    ## 16 09001 10200401  PM25-PRI     2.036 POINT 1999
    ## 20 09001 10200504  PM25-PRI     0.388 POINT 1999
    ## 24 09001 10200602  PM25-PRI     1.490 POINT 1999

* `fips`: A five-digit number (represented as a string) indicating the U.S. county
* `SCC`: The name of the source as indicated by a digit string (see source code classification table)
* `Pollutant`: A string indicating the pollutant
* `Emissions`: Amount of PM2.5 emitted, in tons
* `type`: The type of source (point, non-point, on-road, or non-road)
* `year`: The year of emissions recorded

Source Classification Code Table (`Source_Classification_Code.rds`): This table provides a mapping from the SCC digit strings int he Emissions table to the actual name of the PM2.5 source. The sources are categorized in a few different ways from more general to more specific and you may choose to explore whatever categories you think are most useful. For example, source “10100101” is known as “Ext Comb /Electric Gen /Anthracite Coal /Pulverized Coal”.

You can read each of the two files using the `readRDS()` function in R. For example, reading in each file can be done with the following code:

    ## This first line will likely take a few seconds. Be patient!
    NEI <- readRDS("summarySCC_PM25.rds")
    SCC <- readRDS("Source_Classification_Code.rds")


as long as each of those files is in your current working directory (check by calling `dir()` and see if those files are in the listing).

## Assignment

The overall goal of this assignment is to explore the National Emissions Inventory database and see what it say about fine particulate matter pollution in the United states over the 10-year period 1999–2008. You may use any R package you want to support your analysis.

###Questions & Answers

You must address the following questions and tasks in your exploratory analysis. For each question/task you will need to make a single plot. Unless specified, you can use any plotting system in R to make your plot.

Prepare Work: 

 - Download Data and unzip it
 - Set working directory

Question 1

Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? Using the base plotting system, make a plot showing the total PM2.5 emission from all sources for each of the years 1999, 2002, 2005, and 2008.

> First, load Data and aggregate the total PM2.5 emission from all
> sources for each of the Years 1999, 2002,2005, and 2008.

    NEI <- readRDS("summarySCC_PM25.rds")
    SCC <- readRDS("Source_Classification_Code.rds")

> We plot the total PM2.5 Emission from all sources by using barplot.

    barplot(
      (emissionTotals$Emissions),
      names.arg=emissionTotals$year,
      xlab="Year",
      ylab="PM2.5 Emissions",
      main="Total PM2.5 Emissions From All US Sources"
    )
![Plot 1](https://github.com/EricYangISISI/ExData_Plotting2/blob/master/plot1.png)

Question 2

Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == "24510") from 1999 to 2008? Use the base plotting system to make a plot answering this question.

   

>  1.Get subset of NEI Data by Baltimore's fips == "24510"

    baltimoreNEI <- NEI[NEI$fips=="24510",]

>  2.Aggregate using sum the Baltimore emissions data by year

    total <- aggregate(Emissions ~ year, baltimoreNEI,sum)

> 3.We use the base plotting system to generate a plot of result

    png("plot2.png",width=480,height=480,units="px",bg="transparent")
    
    barplot(
      total$Emissions,
      names.arg=total$year,
      xlab="Year",
      ylab="PM2.5 Emissions (Tons)",
      main="Total PM2.5 Emissions From Baltimore City Sources"
    )

![Plot 2](https://github.com/EricYangISISI/ExData_Plotting2/blob/master/plot2.png)

Question 3

Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, which of these four sources have seen decreases in emissions from 1999–2008 for Baltimore City? Which have seen increases in emissions from 1999–2008? Use the ggplot2 plotting system to make a plot answer this question.

> Load Data
> Get subdata by Baltimore's fips == "24510"
> Aggregate using sum the Baltimore emissions data by year
>Use the library(ggplot2) plotting system

    ggplot(baltimoreNEI,aes(factor(year),Emissions,fill=type)) +
      geom_bar(stat="identity") +
      theme_bw() + guides(fill=FALSE)+
      facet_grid(.~type,scales = "free",space="free") + 
      labs(x="year", y=expression("Total PM"[2.5]*" Emission (Tons)")) + 
      labs(title=expression("PM"[2.5]*" Emissions, Baltimore City 1999-2008 by Source Type"))

![Plot 3](https://github.com/EricYangISISI/ExData_Plotting2/blob/master/plot3.png)

Question 4

Across the United States, how have emissions from coal combustion-related sources changed from 1999–2008?

> Get subdata of coal combustion-related sources

    combustionRelated <- grepl("comb", SCC$SCC.Level.One, ignore.case=TRUE)
    coalRelated <- grepl("coal", SCC$SCC.Level.Four, ignore.case=TRUE) 
    coalCombustion <- (combustionRelated & coalRelated)
    combustionSCC <- SCC[coalCombustion,]$SCC
    combustionNEI <- NEI[NEI$SCC %in% combustionSCC,]

> Use ggplot2 library to represent result

    ggplot(combustionNEI,aes(factor(year),Emissions/10^5)) +
      geom_bar(stat="identity",fill="grey",width=0.75) +
      theme_bw() +  guides(fill=FALSE) +
      labs(x="year", y=expression("Total PM"[2.5]*" Emission (10^5 Tons)")) + 
      labs(title=expression("PM"[2.5]*" Coal Combustion-related Source Emissions"))

![Plot 4](https://github.com/EricYangISISI/ExData_Plotting2/blob/master/plot4.png)

Question 5

How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?

> Load the NEI and SCC data

    NEI <- readRDS("summarySCC_PM25.rds")
    SCC <- readRDS("Source_Classification_Code.rds")

> Get Baltimore emissions from motor vehicle sources

    emissions <- NEI[(NEI$fips=="24510") & (NEI$type=="ON-ROAD"),]
    total <- aggregate(Emissions ~ year, data=emissions, FUN=sum)


> last step, we plot result using ggplot2

    ggplot(total, aes(x=factor(year), y=Emissions)) +
      geom_bar(stat="identity", fill="grey") +
      theme_bw()+
      xlab("year") +
      ylab(expression("total PM"[2.5]*" emissions")) +
      ggtitle("Emissions from motor vehicle sources in Baltimore City")

![Plot 5](https://github.com/EricYangISISI/ExData_Plotting2/blob/master/plot5.png)

Question 6

Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle sources in Los Angeles County, California (fips == "06037"). Which city has seen greater changes over time in motor vehicle emissions?

> Comparing emissions from motor vehicle sources in Baltimore City (fips
> == "24510")  with emissions from motor vehicle sources in Los Angeles County, California (fips == "06037") Get Baltimore emissions from
> motor vehicle sources Get Los Angeles emissions from motor vehicle
> sources

    baltimoreEmissions <- NEI[(NEI$fips=="24510") & (NEI$type=="ON-ROAD"),]
    baltimoreTotal <- aggregate(Emissions ~ year, data=baltimoreEmissions, FUN=sum)
    
    laEmissions <- NEI[(NEI$fips=="06037") & (NEI$type=="ON-ROAD"),]
    laTotal <- aggregate(Emissions ~ year, data=laEmissions, FUN=sum)
    
    normalize <- function(x) {(x-min(x)) / (max(x)-min(x))}
    
    baltimoreTotal$County <- "Baltimore City, MD"
    laTotal$County <- "Los Angeles County, CA"
    allEmissions <- rbind(baltimoreTotal, laTotal)

> Use ggplot represent result

    ggplot(allEmissions, aes(x=factor(year), y=Emissions, fill=County)) +
      geom_bar(stat="identity") + 
      facet_grid(County  ~ ., scales="free") +
      ylab("total emissions (tons)") + 
      xlab("year") +
      ggtitle(expression("Motor Vehicle Source Emissions in Baltimore & LA"))

![Plot 6](https://github.com/EricYangISISI/ExData_Plotting2/blob/master/plot6.png)
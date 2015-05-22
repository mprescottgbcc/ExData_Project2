# Project 2 for "Exploratory Data Analysis" Course
# Offered by Johns Hopkins University, Bloomberg School of Public Health
# Student Name: Margaret Prescott
# Course Start Date: 2015-May-04
# Project Due Date: Sun 2015-May-24
#
# REQUIRED PACKAGES: dplyr
library(dplyr)

# REQUIRED DATASET: Download and unZIP the following file and move its contents (2 RDS files) 
# into this script's directory location (which must then be set as the working directory):
# https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip
#
# This script addresses question 1 of the project requirements:
#
# Have total emissions from PM2.5 decreased in the United States from 1999 to 2008?
# Using the base plotting system, make a plot showing the total PM2.5 emission from all 
# sources for each of the years 1999, 2002, 2005, and 2008.


# Create data frames from each of the two data files required for the project. Additionally, stip
# out any extraneous columns and make data conversions as appropriate.
NEI <- readRDS("summarySCC_PM25.rds")
NEI <- NEI %>% select(fips,SCC,Emissions,type,year)
SCC <- readRDS("Source_Classification_Code.rds")
SCC <- SCC %>% select(SCC,Data.Category,EI.Sector)
SCC$SCC <- as.character(SCC$SCC)


# I decided to create multiple graphs to explore the nature of the emissions over time by source.
# This is where the dplyr package is VERY helpful because of its speed in working with very large
# datasets.
#
# The top graph shows the emissions from all sources summarized by year. If one were to go solely
# on this graph, it would seem pretty clear that particulate matter emissions have decreased
# significantly from 1999 to 2008. The following creates the data frame needed for this plot:

emissionsYear  <- NEI %>% 
                      group_by(year) %>%
                      summarize(total = sum(Emissions))

# To better understand what's going on, it would be important to see how the sources of these
# emissions factor in to the analysis. The next graph further breaks the total emissions down by
# source (SCC - Source Code Classification). We can now see that there are a small number of 
# specific PM emission sources that have a major impact on the yearly totals. Some questions: are
# these sources ones that will have a consistent presence over time or were there specific rare events
# producing extraordinary amounts of these PM emissions? The following data frame is used to produce
# the second graph:

emissionsYearSCC <- NEI %>% 
                      group_by(year,SCC) %>%
                      summarize(total = sum(Emissions))

# The third graph is used to study the outliers in the data set which appear to be those emissions
# measuring higher than 400,000 tons based on visual inspection of the second graph. Let's see what
# they are and which years they are present.

outliers <- inner_join(emissionsYearSCC %>% filter(total>400000),SCC, by='SCC')
outlierSCC <- outliers %>% group_by(SCC) %>% count(SCC) %>% select(SCC)
outlierSCC <- outlierSCC$SCC    #easier to use this as a vector instead of a data frame or table

# Now, on with the plotting! The following will generate the three graphs described above in one
# column in a single plot. The bottom graph has a legend with the SCC for each outlier represented
# in the graph. The resulting plot will be stored in a PNG file named "q1plot.png" in the working 
# directory.

png(file="q1Plot.png",width=840,height=1200)
par(mfrow=c(3,1))

# Graph 1: Total emissions in the US per year
with(
  emissionsYear,
  {
    plot(
      year,total,
      xlab="Year", ylab="Total Emissions",
      main="Total PM2.5 Emissions\nFrom All Sources by Year",
      pch=20
    )
    lines(year,total)
  }
)

# Graph 2: Scatterplot of total emissions for each SCC in the US per year. Here's where you can
# see where there may be outliers in the data.
with(
  emissionsYearSCC,
  plot(
    year,total,
    xlab="Year", ylab="Total Emissions by SCC",
    main="Total PM2.5 Emissions\nBy Source Per Year"
  )
)

# Graph 3: Only total emissions for those sources that result in more than 400,000 tons per year
# are represented in this graph. Each SCC is assigned a different color and symbol to better
# visualize any potential pattern. A legend is produced to match the color and symbol to the SCC
with(
  outliers, {
    plot(
      year,total,
      xlab="Year", ylab="Total Emissions by SCC",
      main="Total PM2.5 Emissions > 400,000 tons\nBy Source Per Year",
      type='n'
    )

    # These next vectors are used for applying color and building the legend for the third plot
    cols <- character()
    symbols <- vector()
    allColors <- colors()
  
    for(i in 1:length(outlierSCC)) {
      cols <- c(cols,allColors[i*27])
      symbols <- c(symbols,(i*2+6))
      with(
        subset(outliers, SCC == outlierSCC[i]),
        points(year, total, col = cols[i],pch=symbols[i])
      )
    }
    legend("topright",col=cols,legend=outlierSCC,pch=symbols)
  }
)
dev.off()

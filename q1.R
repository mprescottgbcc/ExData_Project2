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


# Create data frames from each of the two data files required for the project
#NEI <- readRDS("summarySCC_PM25.rds")
#NEI <- NEI[,c('fips','SCC','Emissions','type','year')]
#SCC <- readRDS("Source_Classification_Code.rds")
#coalSrc <- SCC[grep('coal',SCC$Short.Name,ignore.case=TRUE),]
#onroadSrc <- SCC[SCC$Data.Category=='Onroad',]

# I decided to create multiple plots to explore the nature of the emissions over time by source.
# This is where the dplyr package is VERY helpful because of its speed in working with very large
# datasets.
#
# The top plot graphs the emissions from all sources summarized by year. If one were to go solely
# on this graph, it would seem pretty clear that particulate matter emissions have decreased
# significantly from 1999 to 2008. The following creates the data frame needed for this plot:

emissionsYear  <- NEI %>% 
                      group_by(year) %>%
                      summarize(total = sum(Emissions))

# To better understand what's going on, it would be important to see how the sources of these
# emissions factor in to the analysis. The next graph further breaks the total emissions down by
# source (SCC - Source Code Classification). We can now see that there are a small number of 
# specific PM emission sources that have a major impact on the yearly totals. Some questions: are
# these sources that will have a consistent presence over time or were there specific rare events that
# produced extraordinary amounts of these PM emissions? The following data frame is used to produce
# the second graph:

emissionsYearSCC  <- NEI %>% 
  group_by(year,SCC) %>%
  summarize(total = sum(Emissions))

# The third graph is used to identify the apparent outliers in the data set (determined visually
# from the second graph). Totals by SCC that are more than 400,000 tons appear to be unusual, so
# let's see what they are and which years they are present.
outlierSCC <- emissionsYearSCC %>%
  filter(total>400000) %>%
  ungroup() %>%
  count(SCC)
  

# Now, on with the plotting!
par(mfrow=c(1,2))
with(
  subset(emissionsYearSCC,total>400000),
  {
    plot(
      year,total,
      xlab="Year", ylab="Total Emissions by SCC",
      main="Total PM2.5 Emissions > 400,000 tons\nBy Source Per Year"
    )
  }
)

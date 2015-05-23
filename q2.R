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
# This script addresses question 2 of the project requirements:
#
# Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == "24510") from
# 1999 to 2008? Use the base plotting system to make a plot answering this question.
#
# Create data frames from each of the two data files required for the project. Additionally, strip
# out any extraneous columns and make data conversions as appropriate.

#NEI <- readRDS("summarySCC_PM25.rds")
#NEI <- NEI %>% select(fips,SCC,Emissions,type,year)
#SCC <- readRDS("Source_Classification_Code.rds")
#SCC <- SCC %>% select(SCC,Data.Category,EI.Sector)
#SCC$SCC <- as.character(SCC$SCC)

# Find all the total emissions by source (SCC) for Baltimore City based on the fips "24510"
emissionsYearSCC <- NEI %>%
                      group_by(year,SCC) %>%
                      filter(fips=="24510") %>%
                      summarize(total = sum(Emissions))

emissionsYearSCC <- inner_join(emissionsYearSCC,SCC,by='SCC')

# Now, on with the plotting!
png(file="q2Plot.png", bg="white")

with(
  emissionsYearSCC,
  plot(
    year,total,
    xlab="Year", ylab="Total Emissions by SCC (tons)",
    main="Total PM2.5 Emissions in Baltimore City, Maryland\nBy Source Per Year",
    type="n"
    )
)

# After looking at the initial run of this plot, one of the sources is
# much higher in volume than the rest. I re-plot this to subset the
# extreme value in order to make it stand out on the plot. A legend
# will be generated to show the EI.Sector for this source.
with(
  subset(emissionsYearSCC, total>500),
  points(year,total,col="red",pch=8)
)

with(
  subset(emissionsYearSCC, total<=500),
  points(year,total,col="black",pch=1)
)

# Determine the outlier and get the EI.Sector value to show in the legend
outlier <- emissionsYearSCC[emissionsYearSCC$total>500,'EI.Sector']
sector <- as.character(outlier$EI.Sector)

# Finally, create the legend
legend("topright", pch=c(8,1), col=c("red","black"), legend=c(sector,"All Other Sources"))

dev.off()


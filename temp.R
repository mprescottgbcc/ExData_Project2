par(mfrow = c(2,2))
with(
  NEI,
  plot(
    year, Emissions,
    xlab="Year",
    ylab="Emissions",
    main = "Emissions by Year from All Sources",
    pch=20
  )
)
with(
  NEI,
  plot(
    year, Emissions,
    xlab = "Year",
    ylab = "Emissions",
    ylim = c(0,outerFence),
    main = "Emissions by Year from All Sources\nOutliers Removed",
    pch=20
  )
)
with(
  NEI,
  plot(
    year, Emissions,
    xlab="Year",
    ylab="Emissions",
    ylim=c(outerFence,maxEmissions),
    main = "Emissions by Year from All Sources\nOutliers Only"
  )
)
with(
  NEI,
  plot(
    SCC, Emissions,
    xlab="Source Classification Code (SCC)",
    ylab="Emissions",
    ylim=c(outerFence,maxEmissions),
    main = "Emissions by Source Classification Code\nOutliers Only"
  )
)

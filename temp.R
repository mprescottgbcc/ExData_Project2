par(mfrow=c(1,2))
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

with(
  emissionsYearSCC,
  plot(
    year,total,
    xlab="Year", ylab="Total Emissions by SCC",
    main="Total PM2.5 Emissions\nBy Source Per Year"
  )
)

##CREATE PLOT 2 TREND

#read flat file
household <- read.table("household_power_consumption.txt", sep=";", header = TRUE, strip.white=TRUE)
#make sure Date field behaves as a Date
household <- transform(household, Date = as.Date(Date,'%d/%m/%Y'))
# subset data to given dates
household <- subset(household, Date>=as.Date("2007-02-01") & Date<=as.Date("2007-02-02"))

# concatenate Date & Time columns and parse date properly
household <- transform(household, Date = paste(household$Date, household$Time))
household <- transform(household, Date = strptime(household$Date, format = '%Y-%m-%d %H:%M'))

# replace ? and fill with empty
household[household$Global_active_power=="?"]<-NA
# secure variable as numeric type
household <- transform(household, Global_active_power = as.numeric(Global_active_power))

#generate plot for variable
plot(household$Date, household$Global_active_power/1000, type="l", ylab = "Global Active Power (KiloWatts)")

# copy plot to required png file
dev.copy(png, file = "plot2.png", width = 480, height = 480)
# close graphing system and commit png
dev.off()
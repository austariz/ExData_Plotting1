##CREATE PLOT 3 MULTI-PLOTS

#read flat file
household <- read.table("household_power_consumption.txt", sep=";", header = TRUE, strip.white=TRUE)
#make sure Date field behaves as a Date
household <- transform(household, Date = as.Date(Date,'%d/%m/%Y'))
# subset data to given dates
household <- subset(household, Date>=as.Date("2007-02-01") & Date<=as.Date("2007-02-02"))

# concatenate Date & Time columns and parse date properly
household <- transform(household, Date = paste(household$Date, household$Time))
household <- transform(household, Date = strptime(household$Date, format = '%Y-%m-%d %H:%M'))

# replace ? and fill with zero
household[household$Global_active_power=="?"]<-0
household[household$Global_reactive_power=="?"]<-0
household[household$Voltage=="?"]<-0
household[household$Sub_metering_1=="?"]<-0
household[household$Sub_metering_2=="?"]<-0
household[household$Sub_metering_3=="?"]<-0
# secure variable as numeric type
household <- transform(household, Global_active_power = as.numeric(Global_active_power))
household <- transform(household, Global_reactive_power = as.numeric(Global_reactive_power))
household <- transform(household, Voltage = as.numeric(Voltage))
household <- transform(household, Sub_metering_1 = as.numeric(Sub_metering_1))
household <- transform(household, Sub_metering_2 = as.numeric(Sub_metering_2))


par(mfrow = c(2,2), mar = c(4,4,2,1), oma = c(0,0,2,0), cex=0.7)
with(household, {
       plot(household$Date, household$Global_active_power/1000, type="l", ylab = "Global Active Power", , xlab = "")
       plot(household$Date, household$Voltage, type="l", xlab = "DateTime", ylab = "Voltage")
       plot(household$Date, household$Sub_metering_1, type="l", yaxt = "n", ylab = "Energy sub metering", xlab = "")
         lines(household$Date, household$Sub_metering_2/10, type="l", col = "red", lwd = 1)
         lines(household$Date, household$Sub_metering_3, type="l", col = "blue")
         axis(lwd=1, side=2, line=0, at=c(seq(from=0,to=30,by=10)))
         legend("topright", lty = 1, col = c("black","blue","red"), legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"))
	   plot(household$Date, household$Global_reactive_power/500, type="l", ylab = "Global_reactive_power", , xlab = "DateTime")
})


# copy plot to required png file
dev.copy(png, file = "plot4.png", width = 480, height = 480)
# close graphing system and commit png
dev.off()
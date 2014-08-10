# Clean up workspace
rm(list=ls())

# load.extract the zip
zipfile<-'exdata-data-household_power_consumption.zip'
if (!file.exists(zipfile)) {
  url <- 'https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip'
  download.file(url, destfile=zipfile, method='curl')
  unzip(zipfile)
}
# read data file
destfile<-'household_power_consumption.txt'
dataset<-read.csv(destfile, header=TRUE, stringsAsFactors=FALSE, sep=";")

# filter the data we are interested in (dates are one char only for m and d)
data<-subset(dataset,Date =="1/2/2007" | Date=="2/2/2007")

#clean data
cleandata<-subset(data,Sub_metering_1 !="?" | Sub_metering_2 !="?" | Sub_metering_3 !="?" | Date != "?")

#format as date -with time (POSIX)
dates<-as.POSIXct(strptime(paste(cleandata$Date,cleandata$Time), "%d/%m/%Y %H:%M:%S"))

#create plot file device
plotfile="plot3.png"
png(filename = plotfile,
    width = 480, 
    height = 480, 
    units = "px",
    bg="grey60") #tryed to match the example color

#create plot

plot(dates,as.numeric(cleandata$Sub_metering_1), 
     ylab="Energy sub metering", 
     xlab="",
     type='l',
     col="black")

points(dates,as.numeric(cleandata$Sub_metering_2), 
       type='l',
       col="red")

points(dates,as.numeric(cleandata$Sub_metering_3),
       type='l',
       col="blue")

legend("topright",
       lty=1,
       col = c("black","red","blue"), 
       legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3")
       )

#close device
dev.off()
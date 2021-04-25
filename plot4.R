library(dplyr)
library(lubridate)
library(stringi)
#Import dataset
df <- read.table(file = "./household_power_consumption.txt", header = T, sep = ";",
                 na.strings = "?", colClasses = c("character","character","numeric","numeric","numeric"
                                                  ,"numeric","numeric","numeric","numeric"))

#Remove underscore and convert all letter into lower cases
names(df) <- gsub("_","",tolower(names(df)))


#Becase my local machine is set with CHT time zone, therefore I've to speficy to use the same
# time zone. (Asia Taipei). Lubridate function will use UTC as the default time zone
# while R base function by default use local machine setting as Time zone.
df.cleaned <- df %>%
    mutate(datetime = dmy_hms(paste(date,time),tz = "Asia/Taipei") )%>%
    select(-c(date,time)) %>%
    filter ((datetime >= as.POSIXct("2007-02-01 00:00:00",format = "%Y-%m-%d %H:%M:%S"))&
                (datetime < as.POSIXct("2007-02-03 00:00:00",format = "%Y-%m-%d %H:%M:%S")))

#plotting multiple item
png(file = "plot4.png",width = 480, height = 480)
par(mfrow = c(2,2),mar = c(4,4,2,2))

with(df.cleaned, plot(datetime, globalactivepower,type = "l"
                      ,xlab = "",ylab = "Global Active Power"))
with(df.cleaned, plot(datetime, voltage,type = "l"
                      ,xlab = "datetime",ylab = "Voltage"))
with(df.cleaned, plot(datetime,submetering1,type = "l",xlab = "",ylab = "Energy sub metering"))
with(df.cleaned, lines(datetime, submetering2,col = "red"))
with(df.cleaned, lines(datetime, submetering3,col = "blue"))
legend("topright",col = c("black","red","blue"),
                        legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),lty = c(1,1,1),cex = 0.8)
with(df.cleaned,plot(globalreactivepower,ylab = "Global_reactive_power",xlab = "datetime",type = "l"))
dev.off()

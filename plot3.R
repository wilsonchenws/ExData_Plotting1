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
png(file = "plot3.png",width = 480, height = 480)
with(df.cleaned, plot(datetime,submetering1,type = "l"))
with(df.cleaned, lines(datetime, submetering2,col = "red"))
with(df.cleaned, lines(datetime, submetering3,col = "blue"))
legend("topright",legend = c("Sub_metering1","Sub_metering2","Sub_metering3"),
       col = c("black","red","blue"),lty = c(1,1,1), cex = 0.7,box.lty = 0)
dev.off()

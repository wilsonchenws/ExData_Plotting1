library(dplyr)
library(lubridate)

#Loading dataset with variable speficied (system time shows seconds faster)
df <- read.table(file = "./household_power_consumption.txt",sep = ";",header = T, na.strings = "?",
                 colClasses = c("character","character","numeric","numeric","numeric"
                                ,"numeric","numeric","numeric","numeric"))

#Make all column names lower case, a more consistent naming.
names(df) <- tolower(names(df))

#Combine date and time columns and convert into POSIXT type, remove date and time string column
#and at last filter date required by JHU assignement (2007/2/1-2007/2/2)

df.cleaned <- df %>%
                mutate( datetime = dmy_hms( paste( date, time))) %>%
                select( -c( date, time)) %>%
                 filter( (datetime >= ymd("20070201"))& (datetime < ymd("20070203")))
#Remove unecessary dataframe to save memory space
rm(df)

png(filename = "plot2.png",width = 480,height = 480)
with(df.cleaned, plot(datetime, global_active_power,type = "l"
                      ,ylab = "Global Active Power(kilowatts)"))
dev.off()
#Personal interest: What time does household use most electricity
#with(df.cleaned, plot(datetime, global_active_power,type = "l"
#,ylab = "Global Active Power(kilowatts)"),xaxt = "n")
#axis.POSIXct(1,at = df.cleaned$datetime, labels = format(df.cleaned$datetime, "%H%M"))


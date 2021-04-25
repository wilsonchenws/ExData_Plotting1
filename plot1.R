library(dplyr)
library(lubridate)
df <- read.table("./household_power_consumption.txt",sep = ";",header = T)
# change all case to lower cases.
names(df) <- tolower(names(df))

# Add one column combining date and time, select to exclude date and time
# Use filter to select only Feb 1 and Feb 2 of year 2007.
df.cleaned <- df %>%
                mutate(datetime = dmy_hms(paste(date,time))) %>%
                select(-c(date,time)) %>%
                filter((datetime < ymd("20070203"))&(datetime >= ymd("20070201")))

#convert measurement from string to numeric
df.cleaned[,1:7] <- lapply(df.cleaned[1:7],function(x){as.numeric(x)})

#Start ploting with base plotting system
png(filename = "plot1.png",width = 480, height = 480)
with(df.cleaned,hist(global_active_power,breaks = 25,col = "red",
                     main = "Global Active Power",
                     ylab = "Frequency",
                     xlab = "Global Active Power (kilowatts)"))
dev.off()


# Download the data if its not already here
if(! file.exists('Dataset.zip')) {
        url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
        download.file(url, 'household_power_consumption.zip', method='curl')
}

# Unzip the data if its not already here
if(! file.exists('household_power_consumption.zip')) {
        unzip('household_power_consumption.zip')
}

library(data.table)

tab5rows <- read.csv('household_power_consumption.txt', sep = ';', quote = "", nrows = 5)
classes <- sapply(tab5rows, class)

df_pc <- read.csv('household_power_consumption.txt', sep = ';', quote = "", 
                  colClasses = classes, na.strings="?", stringsAsFactors = FALSE , check.names = FALSE)

df_pc$Date <- as.Date(df_pc$Date, "%d/%m/%Y")

df_pc$DateTime <- as.POSIXct(paste(df_pc$Date, df_pc$Time), format="%Y-%m-%d %H:%M:%S")

df_pc$Time <- strptime(df_pc$Time, "%H:%M:%S")
df_pc$Time <- strftime(df_pc$Time, "%H:%M:%S")

DF <- df_pc[df_pc$Date == '2007-02-01' | df_pc$Date == '2007-02-02', ]
DF <- DF[complete.cases(DF), ]

# Plot 1
par(bg="transparent")
par(mfrow = c(1,1))
par(ps = 12)
par(family = "sans")
hist(DF$Global_active_power, col='red', xlab = 'Global Active Power (kilowatts)', 
     main = '')
mtext("Global Active Power", cex = 1.2, side = 3, family='Hershey', font=2)

dev.copy(png, file = "plot1.png", height = 480, width = 480) ; dev.off()

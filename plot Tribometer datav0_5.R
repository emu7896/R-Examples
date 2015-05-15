# Use direct data from tribometer
# Manual cleaning of files:
# Delete all lines till header data. Change Friction Force to FrictionForce and delete [m] and [N] Change data name to start with a letter not a number.
# Put all files into Work directory
library(zoo)
setwd("D:/Work") # change working directory. Don't forget to put your own working directory here
#MovAv <_ function(data){
#  flt1 <- rep(1/100,100)
#  ylag <- filter(data1a$FrictionForce, flt1, sides=1) #sides=1 for average of current sample and 99 previous samples sides=2 for average of 50 future and 50 past samples
#  xlag <- filter(data1a$Distance,flt1, sides=1)
# }

temp = list.files(pattern="*.csv")  # Get a list of all CSV files into temp 
#tmep2 <- rep(NA,length(temp))
#for (i in 1:length(temp)) tmep2[i]<-c(substr(temp[[i]],start=1,stop=6))
for (i in 1:length(temp)) assign(substr(temp[[i]],start=1,stop=6), read.csv(temp[i],header = TRUE, sep = "",quote = "\"", dec = ",", fill = TRUE, comment.char = "")) # Import all CSV files into R. I didn't want *.csv in my files so truncated that part. Also please be aware of correct R file naming conventions.

# All files are in your Global Environment now. Now it's time to plot them. I couldn't find a way to automate these, so manually change lines below for correct file names and columns

plot(1,xlab='Distance',ylab = 'Friction Force',xlim=c(0,85),ylim=c(0,2.5))   # Plot an empty graph with correct axis names
fltN <- 100
flt1 <- rep(1/fltN,fltN)        # Generate filter for Moving average 100 
flt2 <- rep(1/(fltN+1),fltN+1)  # Generate filter for Moving average with 2 sides, ie past and future


ylag <- filter(data1a$FrictionForce, flt1, sides=1) #sides=1 for average of current sample and 99 previous samples sides=2 for average of 50 future and 50 past samples
xlag <- filter(data1a$Distance,flt1, sides=1)

# Use below for future and past
# ylag <- filter(data1a$FrictionForce, flt2, sides=2)
# xlag <- filter(data1a$Distance,flt2, sides=2)

points(xlag,ylag, col='blue',pch='.')  # Plot first data

# Get second data points
ylag <- filter(data2a$FrictionForce, flt1, sides=1) 
xlag <- filter(data2a$Distance,flt1, sides=1)
points(xlag,ylag, col='red',pch='.') # Plot second data

# Copy paste lines 36-38  and change variable names as needed

legend(80,1,legend = c("A1","B1"), col = c("blue", "red"),pch = 16)   # Put legend add necessary variable names and colors Check http://research.stowers-institute.org/efg/R/Color/Chart/ for colors

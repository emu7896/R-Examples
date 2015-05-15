library(zoo)
setwd("D:/") # change working directory
#import
# All files should be csv
# Header should be Distance and Profile
# Seperation is , and text is ""
# Sample File 
# "Distance","Profile"
# "0,00050","-0,08"
# "0,00100","-0,09"
filenames <- list.files(pattern="*.csv")  
All <- lapply(filenames,function(i){
  read.csv(i, sep = ",",quote = "\"", dec = ",", fill = TRUE, comment.char = "")

}) #Get all data into a List named All. If your csv file is different changing read.csv options you can change import options

# Main Loop for multiple Files

for (i in 1: length(filenames)){
EndV<-length(All[[i]]$Profile)-1        # Set End point
plot(All[[i]]$Distance, All[[i]]$Profile,pch='.',xlab='Distance mm',ylab='Profile') # Plot Full Data
legend("topright", legend=filenames[i],cex=.5)    # Add filename legend

#Apply filter to data in order to eliminate noise Filter is moving average with 100 elements
fltN <- 100 #lag
flt1 <- rep(1/fltN,fltN)   # Filter
ProfileFiltered<- filter(All[[i]]$Profile,flt1,sides=1) #filter profile
points(filter(All[[i]]$Distance,flt1,sides=1),filter(All[[i]]$Profile,flt1,sides=1),col='blue',pch='.')
MinF <- min(ProfileFiltered,na.rm=TRUE)   #Find filtered min
PMinF <- match(MinF,ProfileFiltered)      # Get position of filtered min


# Get left maximum from minimum
MaxF1 <-max(ProfileFiltered[0:PMinF],na.rm=TRUE)  # Find max value on filtered
PMaxF1 <- match(MaxF1,ProfileFiltered)  #Find position of maximum value in filtered vector


Max1<-max(All[[i]]$Profile[0:PMinF],na.rm=TRUE)      #Find maximum value on actual
PMax1<- match(Max1,All[[i]]$Profile)                # Get positon of maximum value on actual


# Getting maximum value near filterd maximum value 
# Check for PMaxF1-PMax1 if it's 50 points near use that value for Maximum
while (PMaxF1-PMax1>50) {
  PMax1<-PMax1+1;
  Max1 <-max(All[[i]]$Profile[PMax1:PMinF],na.rm=TRUE);
  PMax1<- match(Max1,All[[i]]$Profile[PMax1:PMinF])+PMax1}
points(All[[i]]$Distance[PMax1],All[[i]]$Profile[PMax1],col='red')

# Get right maximum from minimum
MaxF2 <-max(ProfileFiltered[PMinF:EndV],na.rm=TRUE)  # Find max value on filtered
PMaxF2 <- match(MaxF2,ProfileFiltered[PMinF:EndV])+PMinF  #Find position of maximum value in filtered vector


Max2<-max(All[[i]]$Profile[PMinF:EndV],na.rm=TRUE)      #Find maximum value on actual
PMax2<- match(Max2,All[[i]]$Profile[PMinF:EndV])+PMinF                # Get positon of maximum value on actual


# Getting maximum value near filterd maximum value 
# Check for PMaxF1-PMax1 if it's 50 points near use that value for Maximum
while (All[[i]]$Distance[PMax2]-All[[i]]$Distance[PMaxF2]>0.03) {
  PMax2<-PMax2+1;
  Max2 <-max(All[[i]]$Profile[PMinF:PMax2],na.rm=TRUE);
  PMax2<- match(Max2,All[[i]]$Profile[PMinF:PMax2])+PMinF

}
points(All[[i]]$Distance[PMax2],All[[i]]$Profile[PMax2],col='red')


plot(All[[i]]$Distance[PMax1:PMax2], All[[i]]$Profile[PMax1:PMax2],pch='.', xlab='Distance (mm)',ylab='Height (um)')
polygon(All[[i]]$Distance[PMax1:PMax2],All[[i]]$Profile[PMax1:PMax2],col="green")

Min<-min(All[[i]]$Profile[PMax1:PMax2])      #Find minimum value of curve
AUCc <- sum(diff(All[[i]]$Distance[PMax1:PMax2])*rollmean(All[[i]]$Profile[PMax1:PMax2]-Min,2))     #Calculate area under curve to 0 use min to have all values greater than zero

xL <- c(All[[i]]$Distance[PMax1],All[[i]]$Distance[PMax2])   # A vector with start and end values for x
yL <- c(All[[i]]$Profile[PMax1],All[[i]]$Profile[PMax2])     # A vector with start and end values for y
AUCl <- sum(diff(xL)*rollmean(yL-Min,2))                  #Calculate area under line
AUC <- AUCl-AUCc                                         #Calculate area between
legend(All[[i]]$Distance[(PMax2-PMax1)/2+PMax1],All[[i]]$Profile[PMax1/2],legend=AUC)    #Write value
legend("bottomright", legend=filenames[i],cex=.5)
}

# Use direct data from tribometer
# Delete all lines till header data. Change Friction Force to FrictionForce and delete [m] and [N]
setwd("D:/Dropbox/Dosyalar/Doktora/EN MAkale") # change working directory
#MovAv <_ function(data){
#  flt1 <- rep(1/100,100)
#  ylag <- filter(data1a$FrictionForce, flt1, sides=1) #sides=1 for average of current sample and 99 previous samples sides=2 for average of 50 future and 50 past samples
#  xlag <- filter(data1a$Distance,flt1, sides=1)
# }

temp = list.files(pattern="*.csv")
#tmep2 <- rep(NA,length(temp))
#for (i in 1:length(temp)) tmep2[i]<-c(substr(temp[[i]],start=1,stop=6))
for (i in 1:length(temp)) assign(substr(temp[[i]],start=1,stop=6), read.csv(temp[i],header = TRUE, sep = "",quote = "\"", dec = ",", fill = TRUE, comment.char = ""))
plot(1,xlab='Distance',ylab = 'Friction Force',xlim=c(0,85),ylim=c(0,2.5))
#for (i in 1:length(temp)) points(temp[i][,"Distance"],temp[i][,"FrictionForce"],col=rainbow(x)[i],pch='.')
flt1 <- rep(1/100,100)
ylag <- filter(data1a$FrictionForce, flt1, sides=1) #sides=1 for average of current sample and 99 previous samples sides=2 for average of 50 future and 50 past samples
xlag <- filter(data1a$Distance,flt1, sides=1)
points(xlag,ylag, col='red',pch='.')
ylag <- filter(data2a$FrictionForce, flt1, sides=1) #sides=1 for average of current sample and 99 previous samples sides=2 for average of 50 future and 50 past samples
xlag <- filter(data2a$Distance,flt1, sides=1)
points(xlag,ylag, col='green',pch='.')
legend(80,1,legend = c("A1","B1"), col = c("blue", "red"),pch = 16)

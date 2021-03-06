library(stringr)
library(plyr)
library(dplyr)
library(lubridate)

# Macrozooplankton data ----
#read in  data
z <- read.csv(file = "195101-201404_Zoop.csv", header = T, stringsAsFactors = F)
z <- z[,which(unlist(lapply(z, function(x)!all(is.na(x)))))] #using the "lapply" function from the "dplyr" package, remove fields which contain all "NA" values

#create new fields with decimal degree latitude and longitude values
z$Lat_DecDeg <- z$Lat_Deg + (z$Lat_Min / 60)
z$Lon_DecDeg <- (z$Lon_Deg + (z$Lon_Min / 60)) *-1

# create a date-time field
z$dateTime <- str_c(z$Tow_Date," ",z$Tow_Time,":00")
z$dateTime <- as.POSIXct(strptime(z$dateTime, "%m/%d/%Y %H:%M:%S", tz = "America/Los_Angeles")) #Hint: look up input time formats for the 'strptime' function
z$Tow_Date <- NULL
z$Tow_Time <- NULL

#export data as tab delimited file
#write.csv(z, file = "zoopla.csv")
write.table(z, file = "zoop.txt", row.names = FALSE, sep = "\t")

z1 = z%>% select(c("ID", "Cruise", "Sta_ID", "Tow_DpthM", "Ttl_PVolC3", 
                   "Sml_PVolC3", "Lat_DecDeg", "Lon_DecDeg", "dateTime"))
write.table(z1, file = "zoop_cut.txt", row.names = F, sep = "\t")

#Egg data Set-----

#read in data set
e <- read.csv(file = "erdCalCOFIcufes_bb4a_5c83_ad3a.csv", header = T)

#turn these character fields into date-time field
e$stop_time_UTC <- gsub(x = e$stop_time_UTC, pattern = "T", replacement = " ")
e$stop_time_UTC <- gsub(x = e$stop_time_UTC, pattern = "Z", replacement = "")
e$time_UTC <- gsub(x = e$time_UTC, pattern = "T", replacement = " ")
e$time_UTC <- gsub(x = e$time_UTC, pattern = "Z", replacement = "")
  

#export data
write.table(e, file = "cufes_clean.txt", row.names = F)


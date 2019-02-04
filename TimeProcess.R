#Transform $CountryName$ to $TimeZoneName$
#Default: America/Los_Angeles
#For US: America/New_York
#For Other Big Countries: Russia->Europe/Russia; Others: See country2TimeZone.csv...
TimeZone <- function(c0){
  if (c0=="not set"){return("America/Los_Angeles")}
  if (length(which(Country$V2==c0))==0){return("America/Los_Angeles")}
  return(Country$V3[which(Country$V2==c0)])
}

#Extract POSIX time into local time (string)
PackedPOSIXct <- function(Item){
  TZ <- TimeZone(as.character(Item["country"]))
  Tim <- as.character(as.POSIXct(as.integer(Item["visitStartTime"]),origin="1970-01-01",tz=TZ))
  #print(Tim)
  return(Tim)
}

#Using apply to transform all time tags.
Data$Time <- apply(Data,1,PackedPOSIXct)

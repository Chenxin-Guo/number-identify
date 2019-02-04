google <- read.csv("~/Desktop/4740project/google.csv")
install.packages("lubridate")
google <- google[, !colnames(google) %in% c('index', 'sessionId', 'visitId', 'adwordsClickInfo', 'adContent')]
#google=na.omit(google$)
google$visitStartTime = as.POSIXct(google$visitStartTime, origin="1970-01-01", tz='UTC')
# or "Pacific/Auckland", "US/New York",.....
google$transactionRevenue[is.na(google$transactionRevenue)] <- 0
google$isTrueDirect[is.na(google$isTrueDirect)]= FALSE
#Check for factor variables and convert them into dummy variables.
sapply(google, class)
google$browser <- model.matrix( ~ browser -1, data=google )
google$operatingSystem <- model.matrix( ~ operatingSystem, data=google )

remove(google)
google <- google[, !colnames(google) %in% c('index','date','fullVisitorId', 'sessionId', 
                                            'visitId', 'adwordsClickInfo', 'adContent', 
                                            'visitStartTime', 'region', 'metro', 
                                            'city', 'networkDomain', 'referralPath', 'keyword', 
                                            'visitStartTime', 'Time', 'NewDate','visits')]
google$NewTime <- as.numeric(lapply(strsplit(as.character(google$NewTime),":"),  function(x) x[1]))
google$NewTime <-cut(google$NewTime, breaks = 6*(0:4), labels=c('night', 'morning', 'afternoon', 'evening'), 
                     include.lowest=TRUE, ordered=TRUE)
Revenue=ifelse(google$transactionRevenue<=0,"False","True")
google=data.frame(google,Revenue)
countryNumber=c(summary(google$country))
#google$country <- cut(google$country, breaks = (372795, ), labels=c('United States', 'India', 'United Kingdom', ''), include.lowest=TRUE, ordered=TRUE)


# training and testing data
train_ind <- sample(1:nrow(google), 1/10000000*nrow(google))
google_train <- google[train_ind, ]
google_test <- google[-train_ind, ]
#logistic regression
google_logit <- glm(transactionRevenue~.-transactionRevenue, data = google_train, family = binomial)


#?????????
tree.google=tree(transactionRevenue ~.-transactionRevenue, google_train)



library(forcats)
google$NewDate <- fct_collapse(google$NewDate,
                         first = c("8/1/16",'8/2/16', "8/3/16", '8/4/16','8/5/16', '8/6/16', '8/7/16', '8/8/16', '8/9/16', '8/10/16' ),
                         second = c("8/11/16",'8/12/16', "8/13/16", '8/14/16','8/15/16', '8/16/16', '8/17/16', '8/18/16', '8/19/16', '8/20/16' ),
                         third = c("8/21/16",'8/22/16', "8/23/16", '8/24/16','8/25/16', '8/26/16' ))
fct_count(google$NewDate)



library(forcats)
google$NewDate <- fct_collapse(google$NewDate,
                               first = c(8/1/16,8/2/16, 8/3/16, '8/4/16','8/5/16', '8/6/16', '8/7/16', '8/8/16', '8/9/16', '8/10/16' ),
                               second = c("8/11/16",'8/12/16', "8/13/16", '8/14/16','8/15/16', '8/16/16', '8/17/16', '8/18/16', '8/19/16', '8/20/16' ),
                               third = c("8/21/16",'8/22/16', "8/23/16", '8/24/16','8/25/16', '8/26/16' ))
fct_count(google$NewDate)



google$country <- fct_collapse(google$country,
                               United_States = 'United States', India = 'India', United_Kingdom = 'United Kingdom', 
                               first_country=c('Canada', 'Vietnam', 'Turkey', 'Germany', 'Thailand', 'Japan', 'Brazil'),
                               second_country=c('France', 'Mexico', 'Taiwan', 'Australia', 'Spain', 'Rassia', 'Netherlands', 'Italy'),
                               third_country=c('Poland ', 'Philippines', 'Indonesia ', 'Singapore', 'Ireland','Malaysia ','Romania', 'Ukraine','Israel','Peru','Sweden', 'South Korea', 'Argentina'),
                               Fourth_country=c('Colombia', 'Hong Kong','Belgium','Switzerland','Czechia ','Pakistan','China','Greece ','Denmark','United Arab Emirates','Saudi Arabia', 'Austria '),
                               fifth_country=c('Hungary','Portugal ','Egypt','Bangladesh ','Norway','New Zealand','Venezuela','South Africa','Algeria', 'Bulgaria','Chile','Morocco','Serbia','Slovakia'),
                               Sixth_country=c('(not set)', 'Sri Lanka','Nigeria ','Croatia','Ecuador','Tunisia '),
                               seventh_country=c('Belarus', 'Kazakhstan','Finland','Dominican Republic','Bosnia & Herzegovina','Georgia','Jordan','Macedonia (FYROM)','Lithuania','Kenya ','Puerto Rico',' Slovenia ', 'Iraq','Latvia '),
                               other=google$country %in% c('United States','India','United Kingdom','Canada', 'Vietnam', 'Turkey', 'Germany', 'Thailand', 'Japan', 'Brazil', 'France', 'Mexico', 'Taiwan', 'Australia', 'Spain', 'Rassia', 'Netherlands', 'Italy','Poland ', 'Philippines', 'Indonesia ', 'Singapore', 'Ireland','Malaysia ','Romania', 'Ukraine','Israel','Peru','Sweden', 'South Korea', 'Argentina', 
                                                           'Colombia', 'Hong Kong','Belgium','Switzerland','Czechia ','Pakistan','China','Greece ','Denmark','United Arab Emirates','Saudi Arabia', 'Austria ','Hungary','Portugal ','Egypt','Bangladesh ','Norway','New Zealand','Venezuela','South Africa','Algeria', 'Bulgaria','Chile','Morocco','Serbia','Slovakia',
                                                           '(not set)', 'Sri Lanka','Nigeria ','Croatia','Ecuador','Tunisia'))





library(forcats)
google$country <- fct_collapse(google$country[train_ind],
                               United_States = 'United States', India = 'India', United_Kingdom = 'United Kingdom', 
                               first_country=c('Canada', 'Vietnam', 'Turkey', 'Germany', 'Thailand', 'Japan', 'Brazil'),
                               second_country=c('France', 'Mexico', 'Taiwan', 'Australia', 'Spain', 'Rassia', 'Netherlands', 'Italy'),
                               third_country=c('Poland ', 'Philippines', 'Indonesia ', 'Singapore', 'Ireland','Malaysia ','Romania', 'Ukraine','Israel','Peru','Sweden', 'South Korea', 'Argentina',
                                               'Colombia', 'Hong Kong','Belgium','Switzerland','Czechia ','Pakistan','China','Greece ','Denmark','United Arab Emirates','Saudi Arabia', 'Austria ',
                                               'Hungary','Portugal ','Egypt','Bangladesh ','Norway','New Zealand','Venezuela','South Africa','Algeria', 'Bulgaria','Chile','Morocco','Serbia','Slovakia'),
                               Sixth_country=c('(not set)', 'Sri Lanka','Nigeria ','Croatia','Ecuador','Tunisia ',
                                               'Belarus', 'Kazakhstan','Finland','Dominican Republic','Bosnia & Herzegovina','Georgia','Jordan','Macedonia (FYROM)','Lithuania','Kenya ','Puerto Rico',' Slovenia ', 'Iraq','Latvia '),
                               other=google$country %in% c('United States','India','United Kingdom','Canada', 'Vietnam', 'Turkey', 'Germany', 'Thailand', 'Japan', 'Brazil', 'France', 'Mexico', 'Taiwan', 'Australia', 'Spain', 'Rassia', 'Netherlands', 'Italy','Poland ', 'Philippines', 'Indonesia ', 'Singapore', 'Ireland','Malaysia ','Romania', 'Ukraine','Israel','Peru','Sweden', 'South Korea', 'Argentina', 
                                                           'Colombia', 'Hong Kong','Belgium','Switzerland','Czechia ','Pakistan','China','Greece ','Denmark','United Arab Emirates','Saudi Arabia', 'Austria ','Hungary','Portugal ','Egypt','Bangladesh ','Norway','New Zealand','Venezuela','South Africa','Algeria', 'Bulgaria','Chile','Morocco','Serbia','Slovakia',
                                                           '(not set)', 'Sri Lanka','Nigeria ','Croatia','Ecuador','Tunisia', 'Belarus', 'Kazakhstan','Finland','Dominican Republic','Bosnia & Herzegovina','Georgia','Jordan','Macedonia (FYROM)','Lithuania','Kenya ','Puerto Rico',' Slovenia ', 'Iraq','Latvia '))







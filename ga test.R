# http://code.markedmondson.me/googleAnalyticsR/setup.html
# http://code.markedmondson.me/googleAnalyticsR/v4.html

## setup
library(googleAnalyticsR)

## This should send you to your browser to authenticate your email.
## Authenticate with an email that has access to the Google Analytics View you want to use.
ga_auth()

## get your accounts
account_list <- google_analytics_account_list()
#ga_id <- account_list[GA_ID,'viewId']


ga_id <- 43015466


## create filters on dimensions
df <- dim_filter("eventAction","REGEXP","risp|tel")      ## this is a costant
df2 <- dim_filter("eventLabel","REGEXP","lavorodacasa8014")  ##this is the parameter to ask to user



## construct filter objects
fc2 <- filter_clause_ga4(list(df, df2), operator = "AND")

my_filter_clause <- filter_clause_ga4(list(df2))

data_fetch <- NULL

data_fetch <- google_analytics_4(ga_id,date_range = c("2016-11-28","2017-05-03"),
                                 metrics = c("totalEvents"),                       # costant
                                 dimensions = c("eventLabel","eventAction"),       # costant
                                 dim_filters = fc2,
                                 anti_sample = TRUE,
                                 anti_sample_batches = 10)
#slow_fetch = TRUE)

## test forecast

library(highcharter)
library(googleAnalyticsR)
library(forecast)

gadata <- google_analytics_4(ga_id, 
                             date_range = c("2015-01-01", "2016-12-31"),
                             metrics = "sessions", 
                             dimensions = c("yearMonth"),
                             max = -1)

# Convert the data to be officially "time-series" data
ga_ts <- ts(gadata$sessions, start = c(2015,01), end = c(2016,12), frequency = 12)

# Compute the Holt-Winters filtering for the data
forecast1 <- HoltWinters(ga_ts)

# Generate a forecast for next 12 months of the blog sessions
hchart(forecast(forecast1, h = 12))
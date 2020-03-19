library(rjson)
library(purrr)
library(magrittr) #for extract verb
library(dplyr)
library(bizdays) 

# From web to create data -------------------------------------------------
# Used the API as bank holidays can be added and changed and other packages do not necessarily check this as they
# are often built on holiday patterns. 2020 will have a change of holiday in May from Monday to Friday 

url <- 'https://t.co/H5wIDJG67R'
document <- fromJSON(file = url, method='C')

# Extract events
events <- map(document, function(x) x[["events"]])

# Extract just England/Wales
eventsEW <- events$`england-and-wales`

# Extract dates
dates <- map(eventsEW, extract, c("date"))

# dataframe to vector 
calendar <- as.vector(unlist(dates))


# create calendar ---------------------------------------------------------

# Create a calendar that excludes Saturdays and Sundays 
# Takes holidays from the package timeDate

create.calendar("Workdays", holidays = calendar, weekdays = c("saturday", "sunday"))

#myDates <- seq(from = startDate, to = endDate, by = "days")


# Calculate differences ---------------------------------------------------

# create sequence over the Easter bank holidays in 2019 starting on the Thursday and ending Wednesday
# so would expect 3 working days.

dfDates <- tibble(startDate = as.Date('2019/04/18'), endDate = as.Date('2019/04/24'))
dfDates$wDays <- bizdays(dfDates$startDate,dfDates$endDate,"Workdays") + 1 

# Calculate days difference for bank holiday week in 2020 where bank holiday moved from Monday to Friday, from
# Thursday until Saturday so would expect 1 day

dfMayDates <- tibble(startDate = as.Date('2020/05/07'), endDate = as.Date('2020/05/09'))
dfMayDates$wDays <- bizdays(dfMayDates$startDate,dfMayDates$endDate,"Workdays") + 1 

# Double check the Monday is not longer counted so from the Sunday to the Monday would expect 1 working day

dfMovedMay <- tibble(startDate = as.Date('2020/05/03'), endDate = as.Date('2020/05/04'))
dfMovedMay$wDays <- bizdays(dfMovedMay$startDate,dfMovedMay$endDate,"Workdays") + 1 

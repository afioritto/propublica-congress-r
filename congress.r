# A simple script for connecting to the ProPublica Congress API, a very fine source of tons of interesting data about the U.S. Congress, and returning a dataframe of current U.S. Senators. 
# Building off of the work of NorfolkDataSci https://github.com/NorfolkDataSci/propublica-congress-api 
# For more info on ProPublica Congress API, read the docs https://projects.propublica.org/api-docs/congress-api/
# Note: you'll need to get a free API key from ProPublica for this to work: https://www.propublica.org/datastore/api/propublica-congress-api

# Load Tidyverse, for all our data wrangling needs. Also load plyr, because I couldn't get the last function that coerces object into data frame without it.  Hopefully someone can write something better so we don't have to use plyr anymore.  
# If you don't have it, install it first with install.packages('tidyverse') and install.packages('plyr'). 

library('plyr')
library('tidyverse')

# Load HTTR, so we can connect to the API
# If you don't have it, install it first with install.packages('httr').
library(httr)

# Connect to the appropriate endpoint and return current list of senators in the 115th congress, store it as an object called senators.  Note: you'll need to stick it your API key where it says "CONGRESS_API_KEY".   

senators <- GET("https://api.propublica.org/congress/v1/115/senate/members.json", 
              add_headers(`X-API-Key` = "CONGRESS_API_KEY"))

# Parse the senators object.  Not sure what this does exactly, but seems to be important for the next step. 
senators <- content(senators, 'parsed')

# Convert the senators object into a nice little data frame. 
senators <- ldply(senators$results[[1]]$members, 
                 .fun=function(x){
                   as.data.frame(x[!sapply(x, is.null)])
                 }
)

# View the senators data frame.
View(senators)
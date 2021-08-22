## libs
library(tidyverse)
library(lubridate)
library(vroom)
library(countrycode)
library(cowplot)

## Function to get case data from OWID
getDataOWID <- function(countries = NULL, tempFileName = NULL, tReload = 300) {
  urlfile <- "https://covid.ourworldindata.org/data/owid-covid-data.csv"
  
  if (is.null(tempFileName)) {
    csvPath <- urlfile
  } else {
    fileMod <- file.mtime(tempFileName)
    fileReload <- if_else(file.exists(tempFileName), now() > fileMod + minutes(tReload), TRUE)
    if (fileReload) {
      downloadOK <- try(download.file(urlfile, destfile = tempFileName))
      if ("try-error" %in% class(downloadOK)) {
        if (file.exists(tempFileName)) {
          warning("Couldn't fetch new OWID data. Using data from ", fileMod)
        } else {
          warning("Couldn't fetch new OWID data.")
          return(NULL)
        }
      }
    }
    csvPath <- tempFileName
  }
  
  world_data <- try(read_csv(csvPath,
                             col_types = cols_only(
                               iso_code = col_character(),
                               date = col_date(format = ""),
                               new_cases = col_double(),
                               new_deaths = col_double())
  ))
  
  
  if ("try-error" %in% class(world_data)) {
    warning(str_c("couldn't get OWID data from ", url, "."))
    return(NULL)
  }
  
   longData <- world_data %>%
    dplyr::select(
      date = "date",
      countryIso3 = "iso_code",
      region = "iso_code",
      confirmed = "new_cases", deaths = "new_deaths") %>%
    pivot_longer(cols = c(confirmed, deaths), names_to = "data_type") %>%
    mutate(
      date_type = "report",
      local_infection = TRUE,
      source = "OWID") %>%
    filter(!is.na(value))
  
  if (!is.null(countries)) {
    longData <- longData %>%
      filter(countryIso3 %in% countries)
  }
  
  longData[longData$value < 0, "value"] <- 0
  return(longData)
}

## Get data to object
cases = getDataOWID()

## Refine new case data
country = "Switerland"

cases %>% 
  filter(data_type == "confirmed",
         countryIso3 == "CHE",
         date >= as.Date("2020-11-15"),
         date <= as.Date("2021-01-17")) %>% 
  group_by(countryIso3) %>% 
  summarise(new_cases = sum(value)) 
  
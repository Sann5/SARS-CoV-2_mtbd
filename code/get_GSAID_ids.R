library(vroom)
library(tidyverse)

# Read data from individual folders
nov = vroom(file = "../data/gisaid_auspice_input_hcov-19_from_nov6_to_nov30/1624635717282.metadata.tsv",
            delim = "\t")
dic_1 = vroom(file = "../data/gisaid_auspice_input_hcov-19_from_dic1_to_dic21/1624636659036.metadata.tsv",
              delim = "\t")
dic_2 = vroom(file = "../data/gisaid_auspice_input_hcov-19_from_dic22_to_dic31/1624637018593.metadata.tsv",
              delim = "\t")
jan = vroom(file = "../data/gisaid_auspice_input_hcov-19_from_jan1_to_jan17/1624637297277.metadata.tsv",
            delim = "\t")

# Bind data and correct
data = bind_rows(nov,
                 dic_1,
                 dic_2,
                 jan) %>% 
  filter(date > as.Date("2020-11-14")) %>% 
  filter(age != "unknown",
         age != "unkown") %>% 
  mutate(age = as.integer(age),
         age_group = case_when(age < 30 ~ "young",
                               (age >= 30 & age < 60) ~ "adult",
                               age >= 60 ~ "old"))

## Write ids to file
vroom_write(data %>% select(gisaid_epi_isl), 
            path = "../data/anotated_ids.txt", 
            delim = " ", 
            col_names = FALSE)
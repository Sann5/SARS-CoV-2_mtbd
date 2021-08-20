# Import libs
library(vroom)
library(tidyverse)
library(muscle)

# Get metadata
m_path = "./1626786136794.metadata.tsv"
m_data = vroom(file = m_path, delim = "\t")

# Get sequences
d_path = "./1626786136794.sequences.fasta"
data = readDNAStringSet(filepath = d_path, format = "fasta")

## Name every sequence with id, date and age group
m_data = m_data %>% 
  mutate(age = as.integer(age),
         age_group = case_when(age < 30 ~ "young",
                               (age >= 30 & age < 60) ~ "adult",
                               age >= 60 ~ "old"))

names(data) = names(data) %>% 
  as_tibble() %>% 
  left_join(y = m_data %>% select(strain,
                                  gisaid_epi_isl,
                                  date,
                                  age_group),
            by = c("value" = "strain")) %>% 
  mutate(new_id = paste(gisaid_epi_isl, date, age_group, sep = "/")) %>% 
  pull(new_id)

## Align
alig = muscle(data)

## Cast to StringsSet object type
alig = as(alig, "DNAStringSet")

new_path = "./sequences_anotated_aligned.fasta"
writeXStringSet(alig, filepath = new_path)
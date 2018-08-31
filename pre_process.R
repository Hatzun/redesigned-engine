library(feather)
library(dplyr)
library(data.table)

# read in the table via fread, which is faster
log.df <- fread('data/log20170516.csv', data.table = FALSE)

# function to read the index files from EDGAR
read_index <- function(filename){
  con <- file('data/company.20170516.idx', open='r')
  idx <- readLines(con) 
  close(con)
  rm(con)
  
  idx <- idx[11:length(idx)]
  
  index <- idx %>%
    str_sub(1,62) %>% 
    str_trim() %>% 
    as.tibble()
  
  index$form <- idx %>% str_sub(63,74) %>% str_trim()
  index$cik <- idx %>% str_sub(75,86) %>% str_trim()
  index$date <- idx %>% str_sub(87, 98) %>% str_trim()
  index$link <- idx %>% str_sub(99, 145) %>% str_trim()
  rm(idx)
  colnames(index)[1] <- "name"
  return(index)
}



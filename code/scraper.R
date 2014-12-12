# Script to download and clean
# OCHA Syria's topline figures. 
# Directly from their website.

onSw <- function(d = T) {
  if (d == T) return('tool/')
  else return('')
}

# dependencies
library(RCurl)
library(reshape2)

# helper functions
source(paste0(onSw(), 'code/write_tables.R'))
source(paste0(onSw(), 'code/sw_status.R'))

# Downlaod and load function
downloadAndLoad <- function() {
  # downloading
  # google doc link is on page source of: http://www.unocha.org/syria
  cat('-----------------------------------------\n')
  cat('Downloading and saving data locally ..\n')
  url = 'https://docs.google.com/spreadsheet/pub?key=0AgVVZWe9NC8wdDNfOHUyQlB6VWlFWWZhRGFNQW9zV3c&output=csv'
  path = paste0(onSw(), 'data/temp/data.csv')
  download.file(url, destfile = path, method = 'curl', quiet = TRUE)
  
  # loading
  out <- suppressWarnings(read.csv(path))
  return(out)
}

# Reorganizing data
reshapeData <- function() {
  cat('Reshaping and cleaning data ..\n')
  data <- downloadAndLoad()
  data <- melt(data)
  path = paste0(onSw(), 'data/ocha-syria-topline-figures.csv')
  
  # Cleaning
  data$id <- NULL
  data$type <- NULL
  data$variable <- sub('X', '', data$variable)
  data$variable <- gsub('\\.', '-', data$variable)
  data$title <- gsub('<br/>', '', x$title)
  names(data) <- c('indicator', 'dates', 'value')
  
  write.csv(data, path, row.names = F)
  writeTable(data, 'ocha_syria_topline_figures', 'scraperwiki')
  
  cat('Done. \n')
  cat('-----------------------------------------\n')
}

# Scraper wrapper
runScraper <- function() {
  reshapeData()
}

# Changing the status of SW.
tryCatch(runScraper(),
         error = function(e) {
           cat('Error detected ... sending notification.')
           system('mail -s "OCHA Syria Topline figures failed" luiscape@gmail.com')
           changeSwStatus(type = "error", message = "Scraper failed.")
           { stop("!!") }
         }
)

# If success:
changeSwStatus(type = 'ok')

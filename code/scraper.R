# Script to download and clean
# OCHA Syria's topline figures. 
# Directly from their website.

onSw <- function(p = NULL, f = 'tool/', d = T) {
  if (d == T) return(paste0(f, p))
  else return(p)
}

###################
## Configuration ##
###################
FILE_PATH = onSw('data/ocha-syria-topline-figures.csv')

# dependencies
library(RCurl)
library(reshape2)

# helper functions
source(onSw('code/write_tables.R'))
source(onSw('code/sw_status.R'))

# Downlaod and load function
downloadAndLoad <- function() {
  # downloading
  # google doc link is on page source of: http://www.unocha.org/syria
  cat('Downloading and saving data locally ... ')
  url = 'https://docs.google.com/spreadsheet/pub?key=0AgVVZWe9NC8wdDNfOHUyQlB6VWlFWWZhRGFNQW9zV3c&output=csv'
  path = onSw('data/temp/data.csv')
  download.file(url, destfile = path, method = 'curl', quiet = TRUE)
  cat('done.\n')
  
  # loading
  out <- suppressWarnings(read.csv(path))
  return(out)
}

# Reorganizing data
reshapeData <- function(p = NULL) {
  cat('-----------------------------------------\n')
  data <- downloadAndLoad()
  
  cat('Reshaping and cleaning data ... ')
  data$labels <- NULL
  data$image <- NULL
  data$type <- NULL
  data$title <- NULL
  data$id <- NULL
  colnames(data)[1] <- "title"
  data <- suppressWarnings(melt(data, "title"))
  cat('done.\n')
  
  # Cleaning
  data$variable <- sub('X', '', data$variable)
  data$variable <- gsub('\\.', '-', data$variable)
  data$title <- gsub('<br/>', '', data$title)
  names(data) <- c('indicator', 'dates', 'value')
  
  cat('-----------------------------------------\n')
  
  return(data)
}

# Scraper wrapper
runScraper <- function(csv = FALSE, db = TRUE, csv_p = NULL) {
  data <- reshapeData(csv_p)
  # Writing output
  if (csv) write.csv(data, csv_p, row.names = F)
  if (db) writeTable(data, 'ocha_syria_topline_figures', 'scraperwiki')
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

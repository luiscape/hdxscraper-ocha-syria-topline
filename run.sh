#!/bin/sh

# running the R scraper from the
# virtual environment
~/R/bin/Rscript tool/code/scraper.R

# activating the python venv
source venv/bin/activate
python tool/code/create-datastore.py

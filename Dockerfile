FROM rocker/shiny-verse:latest
# Make the Shiny app accessible on port 3838
EXPOSE 3838

COPY ./app.R /srv/shiny-server/app.R
# Start the Shiny server
CMD ["R", "-e", "shiny::runApp('/srv/shiny-server/app.R', host = '0.0.0.0', port = 3838)"]
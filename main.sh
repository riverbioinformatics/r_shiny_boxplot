singularity exec R.sif R -e "shiny::runApp('/srv/shiny-server/app.R', host='0.0.0.0', port=$PORT)"
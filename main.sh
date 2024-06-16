if [ -d $NXF_SINGULARITY_CACHEDIR ]; then
    echo "R.sif already exists"
else
    echo "Not found NXF_SINGULARITY_CACHEDIR global variable"
    exit 1
fi
if [ -f $NXF_SINGULARITY_CACHEDIR/R.sif ]; then
    echo "R.sif already exists"
else
    singularity build --fakeroot $NXF_SINGULARITY_CACHEDIR/R.sif $TOOLS/river_r_shiny/singularity.def
fi
singularity exec $NXF_SINGULARITY_CACHEDIR/R.sif R -e "shiny::runApp('/srv/shiny-server/app.R', host='0.0.0.0', port=$PORT)"

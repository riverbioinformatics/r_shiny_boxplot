all: build
.PHONY: run all build

build:
	docker build -t river_r_shiny . --platform linux/amd64
	docker tag river_rshiny:latest river_r_shiny:0.1
	docker save river_r_shiny:0.1|gzip -c  > river_r_shiny.tar.gz

run: build
	docker run -p 3838:3838 river_r_shiny

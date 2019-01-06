CWD=$$PWD
NEW_CWD=/$${PWD\#\#*/}
VOL=${CWD}:${NEW_CWD}

# Build and run. Entrypoint into bash terminal
.PHONY: all
all: d-build d-run

# Builds image from Dockerfile found in current folder
.PHONY: d-build
d-build:
	docker build . -t dev_img

# Runs Docker image tagged "dev_img" with the command "bash" and current working directory mounted to the root folder of the image.
.PHONY: d-run
d-run:
	docker run -it --rm -v $(VOL) dev_img

.PHONY: cmd
cmd: all #_____cmd here



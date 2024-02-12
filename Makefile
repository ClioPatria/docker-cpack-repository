RESTART=--restart unless-stopped
VOLUME=$(shell pwd)/data
PORT=3020

PUBLISH=--publish=${PORT}:3020
DOPTS=${PUBLISH} -v ${VOLUME}:/srv/cliopatria/data
IMG=cliopatria
SRV=cliopatria

all:
	@echo "Targets"
	@echo
	@echo "image            Build the plweb image"
	@echo "run              Run the image (detached)"
	@echo "restart          Stop and restart the image"

image::
	docker build -t $(IMG) .

run:
	docker run --name=$(SRV) -d ${RESTART} ${DOPTS} $(IMG)

stop:
	docker stop $(SRV)

restart:
	-docker stop $(SRV)
	-docker rm $(SRV)
	make run

bash:
	docker run -it ${DOPTS} $(IMG) --bash


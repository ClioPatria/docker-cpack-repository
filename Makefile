RESTART=--restart unless-stopped
VOLUME=$(shell cd .. && pwd)/data
PORT=3400

PUBLISH=--publish=${PORT}:3400 --publish=3420:2022
DOPTS=${PUBLISH} -v ${VOLUME}:/srv/plweb/data
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

restart:
	docker stop $(SRV)
	docker rm $(SRV)
	make run

bash:
	docker run -it ${DOPTS} $(IMG) --bash


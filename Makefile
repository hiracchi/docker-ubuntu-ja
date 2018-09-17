PACKAGE="hiracchi/ubuntu-ja"
TAG=latest
CONTAINER_NAME="ubuntu-ja"

.PHONY: build start stop restart term logs

build:
	docker build -t "${PACKAGE}:${TAG}" .


start:
	\$(eval USER_ID := $(shell id -u))
	\$(eval GROUP_ID := $(shell id -g))
	docker run -d \
		--rm \
		--name ${CONTAINER_NAME} \
		-u $(USER_ID):$(GROUP_ID) \
		"${PACKAGE}:${TAG}"
	#sleep 4
	docker ps -a

stop:
	docker rm -f ${CONTAINER_NAME}


restart: stop start


term:
	docker exec -it ${CONTAINER_NAME} /bin/bash


logs:
	docker logs ${CONTAINER_NAME}

PACKAGE=hiracchi/ubuntu-ja
TAG=latest
CONTAINER_NAME=ubuntu-ja
ARG=

.PHONY: build start stop restart term logs

build:
	docker build -t "${PACKAGE}:${TAG}" . 2>&1 | tee docker-build.log


start:
	@\$(eval USER_ID := $(shell id -u))
	@\$(eval GROUP_ID := $(shell id -g))
	@echo "start docker as ${USER_ID}:${GROUP_ID}"
	docker run -d \
		--rm \
		--name ${CONTAINER_NAME} \
		-u $(USER_ID):$(GROUP_ID) \
		"${PACKAGE}:${TAG}" ${ARG}


start_as_root:
	@echo "start docker as root"
	docker run -t \
		--rm \
		--name ${CONTAINER_NAME} \
		"${PACKAGE}:${TAG}" ${ARG}


stop:
	docker rm -f ${CONTAINER_NAME}


restart: stop start


term:
	docker exec -it ${CONTAINER_NAME} /bin/bash


logs:
	docker logs ${CONTAINER_NAME}

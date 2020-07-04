MACHINE := $(shell uname -m)

PACKAGE=hiracchi/ubuntu-ja
TAG=$(MACHINE)-latest
CONTAINER_NAME=ubuntu-ja
ARG=


.PHONY: build start stop restart term logs

build:
	docker build \
		-f Dockerfile.$(MACHINE) \
		-t "${PACKAGE}:${TAG}" . 2>&1 | tee docker-build.log


start:
	@\$(eval USER_ID := $(shell id -u))
	@\$(eval GROUP_ID := $(shell id -g))
	@echo "start docker as ${USER_ID}:${GROUP_ID}"
	docker run -d \
		--rm \
		--name ${CONTAINER_NAME} \
		-u $(USER_ID):$(GROUP_ID) \
		--volume ${PWD}:/work \
		"${PACKAGE}:${TAG}" ${ARG}


start_as_root:
	@echo "start docker as root"
	docker run -d \
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

PACKAGE=ubuntu-ja
TAG=latest
BRANCH=master

.PHONY: build run exec

build:
	docker build -t "hiracchi/${PACKAGE}:${TAG}" .


start:
	docker run -d --rm \
		--name ${PACKAGE} \
		"hiracchi/${PACKAGE}:${TAG}"

stop:
	docker rm -f ${PACKAGE}

term:
	docker exec -it ${PACKAGE} /bin/bash

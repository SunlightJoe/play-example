.PHONY: all docker run
all: docker

docker:
	sbt docker:publishLocal

run: docker
	docker run -p 80:9000  play-example:1.0-SNAPSHOT

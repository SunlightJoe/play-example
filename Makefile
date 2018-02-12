.PHONY: build run release

AWS_ACCOUNT_ID ?= $(shell aws sts get-caller-identity | sed -n '/Account/s/.*"\([0-9]\+\)".*/\1/p')
IMAGE := play-example:1.0-SNAPSHOT
REPO := $(AWS_ACCOUNT_ID).dkr.ecr.us-east-1.amazonaws.com/play-example:latest

build:
	mkdir -p .cache/ivy2 .cache/m2 .cache/sbt
	docker run --privileged \
		-v /var/run/docker.sock:/var/run/docker.sock \
		-v /var/lib/docker:/var/lib/docker \
		-v `pwd`:/root/play-example \
		-v `pwd`/.cache/ivy2:/root/.ivy2 \
		-v `pwd`/.cache/m2:/root/.m2 \
		-v `pwd`/.cache/sbt:/root/.sbt \
		-w /root/play-example \
		codebuild-sbt-docker \
		sbt docker:publishLocal

run:
	docker run -p 9000:9000 play-example:1.0-SNAPSHOT

release:
	eval `aws ecr get-login --no-include-email --region us-east-1`
	docker inspect ${REPO} > /dev/null
	docker tag ${IMAGE} ${REPO}
	docker push ${REPO}

.PHONY: all deploy

YAMLS := $(wildcard *.yaml **/*.yaml)
LINTS := $(patsubst %.yaml, %.lint, $(YAMLS))
BUCKET ?= play-example-cfn
PARAMS := play-example-cfn.json
PARAMSZIP := $(PARAMS).zip

all: $(LINTS)

$(LINTS): %.lint: %.yaml
	aws cloudformation validate-template --template-body file://./$<


push: $(LINTS) $(PARAMSZIP)
#	./deploy $(BUCKET)
	aws s3 cp $(PARAMSZIP) s3://$(BUCKET)

$(PARAMSZIP): $(PARAMS)
	jq . $<
	zip $@ $<

create: push
	aws cloudformation create-stack \
		--stack-name play-via-cfn \
		--template-url https://s3.amazonaws.com/$(BUCKET)/play-example.yaml \
		--parameters file://params.json \
		--capabilities CAPABILITY_IAM \
		--region us-east-1

update: push
	aws cloudformation update-stack \
		--stack-name play-via-cfn \
		--template-url https://s3.amazonaws.com/$(BUCKET)/play-example.yaml \
		--parameters file://params.json \
		--capabilities CAPABILITY_IAM \
		--region us-east-1

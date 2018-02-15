.PHONY: all deploy

YAMLS := $(wildcard *.yaml **/*.yaml)
LINTS := $(patsubst %.yaml, %.lint, $(YAMLS))
BUCKET ?= play-example-cfn

all: $(LINTS)

$(LINTS): %.lint: %.yaml
	aws cloudformation validate-template --template-body file://./$<


push: $(LINTS)
	aws s3api head-bucket --bucket "$(BUCKET)" || aws s3 mb "s3://$(BUCKET)"

# aws s3api put-bucket-policy --bucket "$(BUCKET)" \
# 	--policy "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Principal\":\"*\",\"Action\":[\"s3:GetObject\",\"s3:GetObjectVersion\"],\"Resource\":\"arn:aws:s3:::${1}/*\"},{\"Effect\":\"Allow\",\"Principal\":\"*\",\"Action\":[\"s3:ListBucket\",\"s3:GetBucketVersioning\"],\"Resource\":\"arn:aws:s3:::$(BUCKET)\"}]}"

	aws s3api put-bucket-versioning --bucket "$(BUCKET)"  --versioning-configuration Status=Enabled

	aws s3 cp play-example.yaml "s3://$(BUCKET)"

	aws s3 cp --recursive templates/ "s3://$(BUCKET)/templates"

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

PROJECT_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
LAMBDAS := "input-processor"

init:
	echo Project dir is $(PROJECT_DIR) && \
	mkdir -p ${PROJECT_DIR}/target

deploy:	init build
	# use https://github.com/cbuschka/tfvm/releases/latest
	cd ${PROJECT_DIR}/terraform/local && \
	terraform init && \
	terraform apply -auto-approve -var-file=vars.tfvars

build:	init
	cd ${PROJECT_DIR}/lambda/input-processor && \
	TEMP_BUILD_DIR=$(shell mktemp -d) && \
	source venv/bin/activate && \
	pip install -r requirements.txt && \
	zip -r ${PROJECT_DIR}/target/input-processor.zip --exclude='venv/*' --exclude=requirements.txt . && \
	deactivate

upload_file:
	touch /tmp/test.txt
	AWS_ACCESS_KEY=dummy AWS_SECRET_ACCESS_KEY=dummy AWS_DEFAULT_REGION=eu-central-1 aws --endpoint-url=http://localhost:4566 s3 cp /tmp/test.txt s3://input/

tail_logs:
	# use https://github.com/lucagrulla/cw/releases/latest/
	cw --endpoint-url=http://localhost:4566 tail -f /aws/lambda/input-processor-lambda:

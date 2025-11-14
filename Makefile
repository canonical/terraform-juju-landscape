.PHONY: check fix fmt-check test

MODULE_PATHS := modules/landscape-scalable
ROOT_DIR := $(shell pwd)
TFLINT := tflint --config=$(ROOT_DIR)/.tflint.hcl

fix:
	$(TFLINT) --init
	for m in $(MODULE_PATHS); do \
		cd $$m && terraform fmt -recursive && \
		$(TFLINT) --recursive --fix; \
	done

fmt-check:
	$(TFLINT) --init
	for m in $(MODULE_PATHS); do \
		cd $$m && terraform fmt -check -recursive && \
		$(TFLINT) --recursive; \
	done

check: fmt-check

test:
	for m in $(MODULE_PATHS); do \
		cd $$m && terraform init && terraform test; \
	done

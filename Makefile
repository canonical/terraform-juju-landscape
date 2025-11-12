.PHONY: check fmt-fix fmt-check test

MODULE_PATHS := modules/landscape-scalable

fmt-fix:
	for m in $(MODULE_PATHS); do \
		cd $$m && terraform fmt -recursive; \
	done

fmt-check:
	for m in $(MODULE_PATHS); do \
		cd $$m && terraform fmt -check -recursive && \
		tflint --init && \
		tflint --recursive --disable-rule=terraform_module_pinned_source; \
	done

test:
	for m in $(MODULE_PATHS); do \
		cd $$m && terraform init && terraform test; \
	done

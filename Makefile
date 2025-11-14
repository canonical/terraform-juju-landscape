MODULE_PATHS := modules/landscape-scalable

.PHONY: check fix test

check:
	tflint --init
	for m in $(MODULE_PATHS); do \
		cd $$m && \
		terraform init -backend=false && \
		terraform fmt -check -recursive && \
		tflint --recursive; \
	done

fix:
	tflint --init
	for m in $(MODULE_PATHS); do \
		cd $$m && \
		terraform init -backend=false && \
		terraform fmt -recursive && \
		tflint --recursive --fix; \
	done

test:
	for m in $(MODULE_PATHS); do \
		cd $$m && \
		terraform init -backend=false && \
		terraform test; \
	done

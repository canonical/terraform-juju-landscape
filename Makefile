.PHONY: lint

MODULE_PATHS := modules/landscape-scalable

lint:
	for m in $(MODULE_PATHS); do \
		cd $$m && tox -e tflint; \
	done

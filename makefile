MODULE ?= test

.PHONY: create-module

create-module:
	cd modules && flutter create --org com.module.$(MODULE) --platforms=android,ios -a kotlin -i swift $(MODULE)
	cd modules/$(MODULE)/lib && echo "\n" > module.dart
	cd modules/$(MODULE)/lib && echo "\n" > export.dart
	cd modules/$(MODULE) && flutter build apk --config-only
	cd modules/$(MODULE) && flutter build ios --no-codesign --config-only

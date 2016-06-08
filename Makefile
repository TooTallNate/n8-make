.PHONY: clean distclean build

export PATH := $(PATH):$(shell npm bin):$(shell cd "$(DIR)" && npm bin):$(DIR)
export NODE_PATH := $(NODE_PATH):$(DIR)/node_modules
export NODE_ENV ?= development

# Source file extensions to process into .js files.
# .json files are implicitly supported.
EXTENSIONS ?= js jsx pug

SOURCE_FILES := $(subst ./,,$(foreach ext,$(EXTENSIONS),$(shell find . -name "*.$(ext)" -not -path "./build/*" -not -path "./node_modules/*" -not -path "./webpack.config.js" -not -path "./public/*" -print)))
JSON_SOURCE_FILES := $(subst ./,,$(shell find . -name "*.json" -not -path "./build/*" -not -path "./node_modules/*" -not -path "./public/*" -print))

COMPILED_FILES := $(addprefix build/, $(addsuffix .js,$(basename $(SOURCE_FILES))) $(JSON_SOURCE_FILES))

build: $(COMPILED_FILES)

# Source files that need to be compiled into regular .js files.
#
# Optionally, a `build/%.js.map` file may be created with
# Source Map information mapping back to the source file, which may
# be used by `source-map-loader` (for Webpack)
# or `source-map-support` (for Node.js).
#
# We have to check the file extension here before executing the compiler
# in case of duplicate basenames with multiple file extensions. i.e.
# if there's a `main.js` and a `main.css` file, then we want to process
# the .js rule, but skip the .css rule.
build/%.js build/%.json: %.*
	@$(eval EXT=$(subst .,,$(suffix $<)))
	@[[ "$(EXTENSIONS) json" =~ "$(EXT)" ]] && \
		mkdir -p $(dir $@) && \
		echo "$<": $(shell echo $(EXT) | tr "[a-z]" "[A-Z]") source file && \
		n8-make-$(EXT) "$<" "$@" \
		|| true

clean:
	@rm -rfv build

distclean:
	@rm -rfv node_modules

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
define buildrule
build/%.js build/%.json: %.$(1)
	$$(eval EXT=$$(subst .,,$$(suffix $$<)))
	@mkdir -p $$(dir $$@)
	@echo "$$<": $$(shell echo $$(EXT) | tr "[a-z]" "[A-Z]") source file
	@n8-make-$$(EXT) "$$<" "$$@"
endef
$(foreach ext,json js,$(eval $(call buildrule,$(ext))))

clean:
	@rm -rfv build

distclean:
	@rm -rfv node_modules

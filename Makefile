.PHONY: clean distclean build

# The directory to place the compiled .js and .json files.
BUILDDIR ?= build

# Source file extensions to process into .js files.
# .json files are implicitly supported.
EXTENSIONS ?= js jsx pug

# Paths to ignore for the build
IGNORE ?= $(BUILDDIR) node_modules webpack.config.js public

# get Makefile directory name: http://stackoverflow.com/a/5982798/376773
THIS_MAKEFILE_PATH := $(word $(words $(MAKEFILE_LIST)),$(MAKEFILE_LIST))
DIR := $(shell cd $(dir $(THIS_MAKEFILE_PATH));pwd)

export PATH := $(PATH):$(shell npm bin):$(shell cd "$(DIR)" && npm bin):$(DIR)
export NODE_PATH := $(NODE_PATH):$(DIR)/node_modules
export NODE_ENV ?= development

FIND_EXT_ := $(foreach EXT,$(EXTENSIONS),-o -name "*.$(EXT)")
FIND_EXT := $(wordlist 2,$(words $(FIND_EXT_)),$(FIND_EXT_))
FIND_IGNORE := $(foreach IG,$(IGNORE),! -path "./$(IG)*")

SOURCE_FILES := $(subst ./,,$(shell find . \( $(FIND_EXT) \) $(FIND_IGNORE)))

JSON_SOURCE_FILES := $(subst ./,,$(shell find . -name "*.json" $(FIND_IGNORE)))

COMPILED_FILES := $(addprefix $(BUILDDIR)/, $(addsuffix .js,$(basename $(SOURCE_FILES))) $(JSON_SOURCE_FILES))

build: $(COMPILED_FILES)

# Source files that need to be compiled into regular .js files.
#
# Optionally, a `$(BUILDDIR)/%.js.map` file may be created with
# Source Map information mapping back to the source file, which may
# be used by `source-map-loader` (for Webpack)
# or `source-map-support` (for Node.js).
define buildrule
$$(BUILDDIR)/%.$(2): %.$(1)
	@mkdir -p $$(dir $$@)
	@echo $$(shell echo $(1) | tr "[a-z]" "[A-Z]") source file: "$$<" → "$$@"
	@n8-make-$(1) "$$<" "$$@"
endef
$(foreach EXT,$(EXTENSIONS),$(eval $(call buildrule,$(EXT),js)))
$(eval $(call buildrule,json,json))

clean:
	@rm -rfv $(BUILDDIR)

distclean:
	@rm -rfv node_modules

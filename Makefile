.PHONY: clean distclean build

# to enable debugging, add `DEBUG=n8-make` to the env
ifneq (,$(findstring n8-make,$(DEBUG)))
define debug
$(info n8-make: $1)
endef
else
define debug
endef
endif

# get Makefile directory name: http://stackoverflow.com/a/5982798/376773
THIS_MAKEFILE_PATH := $(word $(words $(MAKEFILE_LIST)),$(MAKEFILE_LIST))
DIR := $(shell cd $(dir $(THIS_MAKEFILE_PATH));pwd)

export PATH := $(shell npm bin):$(shell cd "$(DIR)" && npm bin):$(DIR):$(PATH)
export NODE_PATH := $(DIR)/node_modules:$(NODE_PATH)
export NODE_ENV ?= development

# The directory to place the compiled .js and .json files.
BUILDDIR ?= build

# Source file extensions to process into .js files.
# .json files are implicitly supported.
EXTENSIONS ?= js jsx pug
$(call debug,will compile extensions = $(EXTENSIONS))

# Paths to ignore for the build
IGNORE ?= $(BUILDDIR) node_modules webpack.config.js public
$(call debug,ignoring paths = $(IGNORE))

FIND_EXT_ := $(foreach EXT,$(EXTENSIONS),-o -name "*.$(EXT)")
FIND_EXT := $(wordlist 2,$(words $(FIND_EXT_)),$(FIND_EXT_))
FIND_IGNORE := $(foreach IG,$(IGNORE),! -path "./$(IG)*")

SOURCE_FILES := $(subst ./,,$(shell find . \( $(FIND_EXT) \) $(FIND_IGNORE) -exec test -e {} \; -print))
JSON_SOURCE_FILES := $(subst ./,,$(shell find . -name "*.json" $(FIND_IGNORE) -exec test -e {} \; -print))
$(call debug,source files = $(SOURCE_FILES) $(JSON_SOURCE_FILES))

COMPILED_FILES := $(addprefix $(BUILDDIR)/, $(addsuffix .js,$(basename $(SOURCE_FILES))) $(JSON_SOURCE_FILES))
$(call debug,output files = $(COMPILED_FILES))

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

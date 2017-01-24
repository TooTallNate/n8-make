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

# Source files root directory
ROOT ?= .

# The directory to place the compiled .js and .json files.
BUILDDIR ?= build

# The client-side entry point file pattern (if a file exists
# matching this pattern then the webpack client-side file is built)
WEBPACK_ENTRY ?= client/index.*

# The output filename for the Webpack client-side build to use.
WEBPACK_BUILD ?= public/build.js

# Source file extensions to process into .js files.
# .json files are implicitly supported.
EXTENSIONS ?= js jsx pug
$(call debug,compiling extensions = $(EXTENSIONS))

# Paths to ignore for the build
IGNORE_PATHS ?= $(IGNORE) $(BUILDDIR) node_modules webpack.config.js public
$(call debug,ignoring paths = $(IGNORE_PATHS))

FIND_EXT_ := $(foreach EXT,$(EXTENSIONS),-o -name "*.$(EXT)")
FIND_EXT := $(wordlist 2,$(words $(FIND_EXT_)),$(FIND_EXT_))
FIND_IGNORE_FILES := $(foreach IG,$(IGNORE_PATHS),! \( -path "./$(IG)" \))
FIND_IGNORE_DIRS := $(foreach IG,$(IGNORE_PATHS),! \( -path "./$(IG)" -prune \))

FIND_COMMAND := find $(ROOT) \( $(FIND_EXT) \) $(FIND_IGNORE_FILES) -exec test -e {} \; -print -o $(FIND_IGNORE_DIRS)
$(call debug,$(FIND_COMMAND))
SOURCE_FILES := $(subst ./,,$(shell $(FIND_COMMAND)))

JSON_SOURCE_FILES := $(subst ./,,$(shell find $(ROOT) -name "*.json" $(FIND_IGNORE_FILES) -exec test -e {} \; -print -o $(FIND_IGNORE_DIRS)))
$(call debug,source files = $(SOURCE_FILES) $(JSON_SOURCE_FILES))

COMPILED_FILES := $(addprefix $(BUILDDIR)/, $(addsuffix .js,$(basename $(SOURCE_FILES))) $(JSON_SOURCE_FILES))
$(call debug,output files = $(COMPILED_FILES))

WEBPACK_ENTRY_FILE := $(wildcard client/index.*)
ifneq ("$(WEBPACK_ENTRY_FILE)","")
DO_WEBPACK_BUILD = $(WEBPACK_BUILD)
$(call debug,webpack build = $(DO_WEBPACK_BUILD))
endif

build: $(COMPILED_FILES) $(DO_WEBPACK_BUILD)

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
	@chmod $$(shell stat -f '%p' "$$<") "$$@"
endef
$(foreach EXT,$(EXTENSIONS),$(eval $(call buildrule,$(EXT),js)))
$(eval $(call buildrule,json,json))

# Webpack client-side build, placed at `public/build.js` by default.
$(WEBPACK_BUILD): $(COMPILED_FILES)
	@mkdir -p $(dir $@)
	@echo Webpack client-side build: "$(WEBPACK_ENTRY_FILE)" → "$@"
	@webpack \
		--config "$(DIR)/webpack.config.js" \
		--entry "./$(addprefix $(BUILDDIR)/,$(addsuffix .js,$(basename $(WEBPACK_ENTRY_FILE))))" \
		--output-path "$(dir $@)" \
		--output-filename "$(notdir $@)"

clean:
	@rm -rfv $(BUILDDIR) $(WEBPACK_BUILD)

distclean:
	@rm -rfv node_modules

# Build variables
BINARY_NAME=sera
GIT_VERSION=$(shell git describe --tags --always --dirty)
BUILD_DIR=.build

# Reduce binary size and strip local directory paths (from logging etc)
FLAGS=-ldflags "-s -w" -trimpath

LINUX_ARCHS=386 amd64 arm64
DARWIN_ARCHS=amd64 arm64

define build
	GOOS=$(1) GOARCH=$(2) go build $(FLAGS) -o $(BUILD_DIR)/$(BINARY_NAME)_$(GIT_VERSION)_$(1)_$(2) .


endef

.PHONY: all linux darwin clean compress

all: clean linux darwin compress

linux:
	$(foreach arch,$(LINUX_ARCHS), \
		$(call build,linux,$(arch)) \
	)

darwin:
	$(foreach arch,$(DARWIN_ARCHS), \
		$(call build,darwin,$(arch)) \
	)

clean:
	rm -rf $(BUILD_DIR)

# Use consistent filename since it will be extracted to /usr/local/bin during bake.
compress:
	cd $(BUILD_DIR) && \
	for binary in $(BINARY_NAME)_*; do \
		tar --transform='s|.*|sera|' --remove-files -czf $$binary.tar.gz $$binary; \
	done && cd ..
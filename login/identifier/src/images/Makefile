# Tools

SCOUR     ?= scour

define do-scour =
$(SCOUR) --enable-viewboxing --create-groups --shorten-ids --enable-id-stripping \
	--enable-comment-stripping --disable-embed-rasters --remove-metadata --strip-xml-prolog -p 9 \
	-i $< -o $@
endef

# Variables

UCS_LOGO_SRC        ?= ucs-logo-raw.svg
UNIVENTION_LOGO_SRC ?= univention-logo-raw.svg

# Build

.PHONY: all
all: ucs-logo.svg univention-logo.svg

ucs-logo.svg: $(UCS_LOGO_SRC)
	$(do-scour)

univention-logo.svg: $(UNIVENTION_LOGO_SRC)
	$(do-scour)

.PHONY: clean
clean:
	$(RM) ucs-logo.svg
	$(RM) univention-logo.svg

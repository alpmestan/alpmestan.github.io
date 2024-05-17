# ===== Usage ================================================================
#
# make                  Prepare _out/ folder (all pages & assets)
# make _out/index.html  Recompile just docs/index.html
#
# make watch            Start a local HTTP server and rebuild on changes
# PORT=4242 make watch  Like above, but use port 4242
#
# make clean            Delete all generated files
#
# ============================================================================

SOURCES := $(shell find src -type f -name '*.md')
TARGETS := $(patsubst src/%.md,_out/%.html,$(SOURCES))
POSTS   := $(shell find src/posts -type f -name '*.md')

.PHONY: all
all: $(TARGETS) _out/posts.html
	cp -R ./plots _out/

.PHONY: clean
clean:
	rm -rf _out ./plots/ src/posts.md

.PHONY: watch
watch:
	./tools/serve.sh --watch

_out/css/theme.css:
	mkdir -p _out _out/posts
	cp -R public/* _out/

_out/%.html: src/%.md template.html5 Makefile _out/css/theme.css
	pandoc \
		--katex \
		--from markdown+tex_math_single_backslash \
		--filter pandoc-sidenote \
		--filter pandoc-plot \
		-M plot-configuration=./pandoc-plot.yml \
		--to html5+smart \
		--template=template \
		--css="/css/theme.css" \
		--css="/css/skylighting-solarized-theme.css" \
		--toc \
		--wrap=auto \
		--output="$@" \
		"$<"

src/posts.md: $(POSTS)
	./tools/genlinks.sh src/posts src/posts.md

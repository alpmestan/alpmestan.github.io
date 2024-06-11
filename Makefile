# ===== Usage ================================================================
#
# make                  Prepare docs/ folder (all pages & assets)
# make docs/index.html  Recompile just docs/index.html
#
# make watch            Start a local HTTP server and rebuild on changes
# PORT=4242 make watch  Like above, but use port 4242
#
# make clean            Delete all generated files
#
# ============================================================================

SOURCES := $(shell find src -type f -name '*.md')
TARGETS := $(patsubst src/%.md,docs/%.html,$(SOURCES))
POSTS   := $(shell find src/posts -type f -name '*.md')

.PHONY: all
all: $(TARGETS) docs/posts.html
	cp -R ./plots docs/

.PHONY: clean
clean:
	rm -rf docs ./plots/ src/posts.md

.PHONY: watch
watch:
	./tools/serve.sh --watch

docs/css/theme.css:
	mkdir -p docs/posts
	cp -R public/* docs/

docs/%.html: src/%.md template.html5 Makefile docs/css/theme.css
	pandoc \
		--katex \
		--standalone \
		--embed-resources \
		--from markdown+tex_math_single_backslash \
		--filter pandoc-sidenote \
		--filter pandoc-plot \
		-M plot-configuration=./pandoc-plot.yml \
		--to html5+smart \
		--template=template \
		--css="public/css/skylighting-solarized-theme.css" \
        --css="public/css/theme.css" \
        --css="public/css/tufte.css" \
		--toc \
		--wrap=auto \
		--output="$@" \
		"$<"

src/posts.md: $(POSTS)
	./tools/genlinks.sh src/posts src/posts.md

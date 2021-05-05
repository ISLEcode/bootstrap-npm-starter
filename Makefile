SHELL = /bin/ksh
export PATH := $(PATH):$(PWD)/node_modules/.bin

OUT_CSSDIR  = docs/zip/starter/css
OUT_CSSFILE = $(OUT_CSSDIR)/starter.css
SRC_SCSS    = src/scss

POSTCSS     = postcss --replace $(OUT_CSSFILE) --use autoprefixer --map
PURGECSS    = purgecss --keyframes --output $(OUT_CSSDIR)
SASSC       = node-sass --include-path node_modules --output-style compressed --source-map true \
              --source-map-contents true --precision 6
STYLELINT   = stylelint

build: css

configure:
	@npm install
	@npm update

css:	css-compile css-prefix

css-compile:
	@$(SASSC) $(SRC_SCSS) -o $(OUT_CSSDIR)

css-lint:
	@$(STYLELINT) $(SRC_SCSS)

css-prefix:
	@$(POSTCSS)

css-purge:
	@$(PURGECSS) --css $(OUT_CSSFILE) --content index.html "node_modules/bootstrap/js/dist/{util,modal}.js"

server:
	serve --listen 3000

start: watch server

watch:
	@nodemon -e html,$(SRC_SCSS) -x 'make css'

test: css-lint css

# vim: fdm=marker fmr=@{,@} noet ts=4

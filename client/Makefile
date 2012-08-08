DATE=$(shell date +%I:%M%p)
CHECK=\033[32m✔\033[39m
HR= ==================================================
LESS_FILES = static/less/less-variables.less \
			 static/less/third-party-bootstrap.less \
			 static/less/third-party-font-awesome.less \
			 static/less/base-elements.less \
			 static/less/buttons.less \
			 static/less/layout.less

JS_TARGETS = static/js/namespace.js \
			 static/js/logger.js \
			 static/js/util.js \
			 static/js/game.js \
			 static/js/cell.js \
			 static/js/creature.js \
			 static/js/user-interface.js \
			 static/js/map.js \
			 static/js/player.js \
			 static/js/renderer.js \
			 static/js/spells.js \
			 static/js/init.js 

THIRD_PARTY = static/js/libs/underscore.js \
			  static/js/libs/json2.js \
			  static/js/libs/jquery.js \
			  static/js/libs/backbone.js \
			  static/js/libs/d3.js

JS_COMPILER = ./node_modules/uglify-js/bin/uglifyjs

# Build all coffeejs templates by default

all: coffee js less

less: 
	@echo "\n${HR}"
	@echo "Combining Less Files"
	@cat $(LESS_FILES) > static/css/all.less
	@echo "${CHECK} Done"
	@echo "\n${HR}"
	@echo "Compiling CSS"
	@./node_modules/less/bin/lessc static/css/all.less static/css/style-all.css
	@rm static/css/all.less
	@echo "Running Less compiler... ${CHECK} Done"
	@echo "\n${HR}"

coffee:
	@echo "\n${HR}"
	@echo "Compiling Coffeejs"
	@echo "${HR}"
	@coffee --compile --output static/coffee static/js
	@coffee --compile --output static/coffee/tests static/js/tests
	@echo "Compiled coffeejs...	${CHECK} Done\n"
	@echo "${HR}"
	@echo "\n${HR}"

js:
	@echo "\n${HR}"
	@echo "${HR}\nRunning uglify\n${HR}"

	@cat $(JS_TARGETS) > static/js/build/vasirtactics.js
	@uglifyjs -nc static/js/build/vasirtactics.js > static/js/build/vasirtactics.min.tmp.js
	@cat static/coffee/copyright.txt static/js/build/vasirtactics.min.tmp.js > static/js/build/vasirtactics.min.js
	@echo "Compiling Our Scripts ${CHECK} Done"
	@rm static/js/build/vasirtactics.min.tmp.js
	@rm static/js/build/vasirtactics.js
	@echo "Cleaned up files...	${CHECK} Done"
	@echo "\n${HR}"
	@echo "Files successfully built at ${DATE}."
	@echo "${HR}\n"

third:
	@echo "${HR}\n"
	@echo "Compiling Third Party JS"
	@cat  $(THIRD_PARTY) > static/js/libs/all3rdjs.js
	@uglifyjs -nc static/js/libs/all3rdjs.js > static/js/libs/all3rdjs.min.js
	@rm static/js/libs/all3rdjs.js
	@echo "Third party files successfully built at ${DATE}."

watch:
	echo "Watching Less and Coffee files..."; \
	watchr -e "watch('static/js/.*\.coffee') { system 'make' }"

mongo:
	@mongoimport -d mtg -c models server/data.json

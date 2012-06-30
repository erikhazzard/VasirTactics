DATE=$(shell date +%I:%M%p)
CHECK=\033[32m✔\033[39m
HR= ==================================================

# @echo "Combining Third Party CSS"
# @cat static/css/bootstrap.css static/css/bootstrap-responsive.css > static/css/bootstrap.all.css
# No more jshint since coffeescript doesn't output valid JS
# @echo "Running JSHint"
# @echo "${HR}\n"
# @jshint static/script/*[^min].js --config static/script/.jshintrc
# @echo "Running JSHint on javascript...	${CHECK} Done"


#LESS_FILES = static/less/less-variables.less \
#			 static/less/third-party-bootstrap.less \
#			 static/less/third-party-font-awesome.less \
#			 static/less/third-party-jqueryui.less \
#			 static/less/base-elements.less \
#			 static/less/buttons.less \
#			 static/less/layout.less \
#			 static/less/facets.less \
#			 static/less/responsive-800.less \
#			 static/less/responsive-600.less

#less: 
#	@echo "\n${HR}"
#	@echo "Combining Less Files"
#	cat $(LESS_FILES) > static/less/all.less
#	@echo "${CHECK} Done"
#	@echo "\n${HR}"
#	@echo "Compiling CSS"
#	@./node_modules/less/bin/lessc static/less/all.less static/css/style-all.css
#	@rm static/less/all.less
#	@echo "Running Less compiler... ${CHECK} Done"

# Build all coffeescript templates by default
all: js 

js:
	@echo "\n${HR}"
	@echo "Compiling CSS"
	@echo "${HR}\n"
	@./node_modules/less/bin/lessc static/css/*.less static/css/style.css
	@echo "Running Less compiler... ${CHECK} Done"
	@echo "\n${HR}"
	@echo "Compiling Coffeescript"
	@echo "${HR}"
	@coffee --compile --output static/script static/script
	@echo "Compiled coffeescript...	${CHECK} Done\n"
	@echo "${HR}\nRunning uglify\n${HR}"
	@cat static/script/namespace.js static/script/logger.js static/script/util.js static/script/game.js static/script/cell.js static/script/creature.js static/script/user-interface.js static/script/map.js static/script/player.js static/script/renderer.js static/script/spells.js static/script/init.js > static/script/vasirtactics.js
	@echo "Compiling Our Scripts ${CHECK} Done"
	@uglifyjs -nc static/script/vasirtactics.js > static/script/vasirtactics.min.tmp.js
	@cat static/script/copyright.txt static/script/vasirtactics.min.tmp.js > static/script/vasirtactics.min.js
	@rm static/script/vasirtactics.min.tmp.js
	@rm static/script/vasirtactics.js
	@echo "Compiling and minifying javascript...	${CHECK} Done"
	@echo "\n${HR}"
	@echo "Files successfully built at ${DATE}."
	@echo "Files: static/css/bootstrap.all.css, static/script/lucid.min.js, static/script/all.min.js, static/script/libs/all3rd.min.js"
	@echo "${HR}\n"

third:
	@echo "Compiling Third Party JS"
	@cat static/script/libs/underscore.js static/script/libs/json2.js static/script/libs/jquery.js static/script/libs/backbone.js static/script/libs/d3.js > static/script/libs/all3rdjs.js
	@uglifyjs -nc static/script/libs/all3rdjs.js > static/script/libs/all3rdjs.min.js
	@rm static/script/libs/all3rdjs.js

watch:
	echo "Watching Less and Coffee files..."; \
	watchr -e "watch('static/script/.*\.coffee') { system 'make' }"

sass = require 'node-sass';

module.exports = (grunt) ->

	require('load-grunt-tasks')(grunt);

	# Project configuration.
	grunt.initConfig

		# Metadata.
		pkg: grunt.file.readJSON("package.json")

		# Task configuration.

		# Builds the demos
		assemble:
			options:
				prettify:
					indent: 2
				marked:
					sanitize: false
				production: false
				data: "src/data/**/*.{yml,json}"
				assets: "dist"
				helpers: "src/helpers/helper-*.js"
				partials: ["src/includes/**/*.hbs"]

			site:
				cwd: "src"
				src: ["*.hbs"]
				dest: "dist/"
				expand: true

		sass:
			options:
				implementation: sass
			dist:
				expand: true
				cwd: "src/scss"
				src: ["**/*.scss", "!**/_*.scss"]
				dest: "dist/css/"
				ext: ".css"

		cssmin:
			dist:
				expand: true
				cwd: "dist/css"
				src: ["**/*.css", "!**/*.min.css"]
				dest: 'dist/css'
				ext: ".min.css"

		copy:
			revealjs:
				cwd: "node_modules/reveal.js"
				src: [
					"css/reveal.css"
					"js/*.js",
					"lib/**/*.js"
				]
				dest: "dist/reveal.js"
				expand: true

			assets:
				cwd: "src"
				src: "assets/**/*"
				dest: "dist"
				expand: true

		clean:
			dist: "dist"
			cssUncompressed: ["dist/css/**/*.css", "!dist/css/**/*.min.css"]

		"gh-pages":
			options:
				message: "Travis build " + process.env.TRAVIS_BUILD_NUMBER
				base: "dist"
			src: [
				"**",
			]

		connect:
			server:
				options:
					port: 8000
					base: "dist"
					keepalive: true


	# Load custom grunt tasks form the tasks directory
	@loadTasks "tasks"

	# Default task.
	@registerTask "default", ["dist"]
	@registerTask "css", ["sass", "cssmin", "clean:cssUncompressed"]

	@registerTask "dist", ["clean:dist", "css", "copy", "html"]
	@registerTask "html", ["assemble"]
	@registerTask "deploy", ["gh-pages"]

	@

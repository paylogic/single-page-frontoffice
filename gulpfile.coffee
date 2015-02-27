# Load requirements
gulp = require "gulp"
$ = do require "gulp-load-plugins"
es = require "event-stream"
runSequence = require "run-sequence"
bowerFiles = require "main-bower-files"
del = require "del"

# Global variables
production = no
prefix = "app"
source = "src"
paths =
  index: "#{source}/index.html"
  images: "#{source}/images/**/*"
  styles: "#{source}/styles/*.less"
  stylesToWatch: "#{source}/styles/**/*.less"
  compiledStyles: "#{prefix}/styles/**/*.css"
  scripts: "#{source}/scripts/**/*.coffee"
  compiledScripts: "#{prefix}/scripts/**/*.js"
  partials: "#{source}/partials/**/*.html"
  translations: "#{source}/translations/**/*.po"

# Detect any issues in script files
gulp.task "jshint", ["scripts"], ->
  gulp.src "#{prefix}/scripts"
    .pipe $.plumber()
    .pipe $.jshint()
    .pipe $.jshint.reporter "jshint-stylish"
    .pipe $.jshint.reporter "fail"

# Validate coffeescript files
gulp.task "coffeelint", ->
  gulp.src paths.scripts
    .pipe $.plumber()
    .pipe $.coffeelint()
    .pipe $.coffeelint.reporter()
    .pipe $.coffeelint.reporter "fail"

# Compile coffeescript files
gulp.task "scripts", ->
  gulp.src paths.scripts
    .pipe $.plumber()
    .pipe $.sourcemaps.init()
    .pipe gulp.dest "#{prefix}/scripts"
    .pipe $.coffee()
    .pipe $.if production, $.ngAnnotate()
    .pipe $.if production, $.uglify()
    .pipe $.if production, $.concat "app.js"
    .pipe $.sourcemaps.write()
    .pipe gulp.dest "#{prefix}/scripts"
    .pipe $.if !production, $.connect.reload()

# Compile less files
gulp.task "styles", ->
  gulp.src paths.styles
    .pipe $.plumber()
    .pipe gulp.dest "#{prefix}/styles"
    .pipe $.sourcemaps.init()
    .pipe $.less compress: production
    .pipe $.sourcemaps.write "."
    .pipe gulp.dest "#{prefix}/styles"
    .pipe $.if !production, $.connect.reload()

# Copy images to build folder
gulp.task "images", ->
  gulp.src paths.images
    .pipe $.plumber()
    .pipe $.if production, $.imagemin()
    .pipe gulp.dest "#{prefix}/images"
    .pipe $.if !production, $.connect.reload()

# Copy partials to build folder
gulp.task "partials", ->
  gulp.src paths.partials
    .pipe $.plumber()
    .pipe gulp.dest "#{prefix}/partials"
    .pipe $.if !production, $.connect.reload()

# Compile translation files
gulp.task "translations", ->
  gulp.src paths.translations
    .pipe $.plumber()
    .pipe $.angularGettext.compile()
    .pipe gulp.dest "#{prefix}/scripts/translations"
    .pipe $.if !production, $.connect.reload()

# Inject compiled stylesheets, compiled scripts, translations and bower packages
gulp.task "index", ["scripts", "styles", "translations"], ->
  gulp.src paths.index
    .pipe $.plumber()
    .pipe $.inject(
      gulp.src bowerFiles(), read: no
    , {ignorePath: "#{prefix}", name: "bower"})
    .pipe $.inject es.merge(
      gulp.src paths.compiledStyles, read: no
    ,
      gulp.src paths.compiledScripts, read: no
    ), ignorePath: prefix
    .pipe gulp.dest prefix
    .pipe $.if !production, $.connect.reload()

# Clean build folder
gulp.task "clean", (cb) ->
  del [
    "#{prefix}/index.html",
    "#{prefix}/styles",
    "#{prefix}/scripts",
    "#{prefix}/images",
    "#{prefix}/partials",
    "!#{prefix}/bower_components/**"
  ], cb

# Build for production
gulp.task "build", (cb) ->
  production = yes
  runSequence "clean", "coffeelint", ["scripts", "styles", "images", "partials", "translations", "jshint"], "index", cb

# Watch for any changes in source files
gulp.task "watch", ->
  gulp.watch paths.partials, ["partials"]
  gulp.watch paths.scripts, ["scripts"]
  gulp.watch paths.stylesToWatch, ["styles"]
  gulp.watch paths.images, ["images"]
  gulp.watch paths.index, ["index"]
  gulp.watch paths.translations, ["translations"]

# Compiles all parts
gulp.task "compile", [], (cb) ->
  runSequence ["scripts", "styles", "images", "partials", "translations"], "index", cb

# Launch server
gulp.task "serve", ["compile"], (cb) ->
  $.connect.server
    root: prefix
    livereload: yes
  runSequence "watch", cb

# Create the pot file to use it for translations
gulp.task "extract-trans", ["scripts"], ->
  gulp.src [paths.index, paths.partials, paths.compiledScripts]
    .pipe $.angularGettext.extract "template.pot"
    .pipe gulp.dest "#{source}/translations/"

# Default task
gulp.task "default", ["serve"]

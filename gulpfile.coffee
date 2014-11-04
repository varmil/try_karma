gulp = require('gulp')
pl = require('gulp-load-plugins')()

localPort = 9999

src =
  dirRoot:     'src'
  coffee:      'src/coffee/**/*.coffee'
  js:          'src/js/**/*.js' # javascriptを書くならこっち
  tests:       'src/tests/**/*.coffee'
  images:      'src/img/**/*'
  dirJs:       'src/js/'

dest = 
  dirMin:   'dest/min/'
  dirImg:   'dest/img/'
  dirMap:   '../map/'


# coffeelint
gulp.task 'lint', ->
  gulp.src src.coffee 
    .pipe pl.coffeelint() 
    .pipe pl.coffeelint.reporter('default')

# (option) javascriptを書くならこっち
gulp.task 'jshint', ->
  gulp.src src.js 
    .pipe pl.jshint() 
    .pipe pl.jshint.reporter('default')


# compile coffee-script (for development because this generates .map file)
gulp.task 'coffee', ->
  gulp.src src.coffee
    .pipe pl.sourcemaps.init()
    .pipe pl.coffee map:true
    .pipe pl.sourcemaps.write dest.dirMap
    .pipe gulp.dest src.dirJs


# uglify javascript （for production）
gulp.task 'uglify', ->
  gulp.src src.js
    .pipe pl.uglify()
    .pipe gulp.dest dest.dirMin


# image optimization
gulp.task 'imagemin', ->
  gulp.src src.images
    .pipe pl.imagemin {
      progressive: true # jpg
      interlaced: true # gif
      optimizationLevel: 3 # the higher the level, the more trials.
    }
    .pipe gulp.dest dest.dirImg


# web server
gulp.task 'webserver', ->
  gulp.src src.dirRoot
    .pipe pl.webserver {
      livereload: true
      directoryListing: true
      port: localPort
      fallback: 'index.html'
    }


# TODO karma


# watch
gulp.task 'watch', ->
  gulp.watch src.coffee, ['convert']
 
# default
gulp.task 'default', ['webserver', 'watch']

# specific combination
gulp.task 'convert', ['coffee', 'uglify']
gulp = require 'gulp'
pl = require('gulp-load-plugins')()
browserSync = require 'browser-sync'

localPort = 9999
projectName = 'try_karma'

src =
  dirRoot:     'src'
  all:         'src/**/*'
  coffee:      'src/coffee/**/*.coffee'
  js:          'src/js/**/*.js' # javascriptを書くならこっち
  tests:       'src/tests/**/*.coffee'
  images:      'src/img/**/*'
  dirJs:       'src/js/'

dist =
  all:         'dist/**/*'
  dirMin:      'dist/min/'
  minJs:       'dist/min/**/*.js'
  dirConcat:   'dist/concat/'
  dirImg:      'dist/img/'
  dirMap:      '../map/'


# coffeelint : コレと併用も gulp-coffeelint-threshold
gulp.task 'lint', ->
  gulp.src src.coffee
    .pipe pl.coffeelint()
    .pipe pl.coffeelint.reporter 'default'

# (option) javascriptを書くならこっち
gulp.task 'jshint', ->
  gulp.src src.js
    .pipe pl.jshint()
    .pipe pl.jshint.reporter 'default'


# compile coffee-script (for development because this generates .map file)
gulp.task 'coffee', ->
  gulp.src src.coffee
    .pipe pl.changed src.dirJs
    .pipe pl.sourcemaps.init()
    .pipe pl.coffee()
    .pipe pl.sourcemaps.write dist.dirMap
    .pipe gulp.dest src.dirJs


# uglify（for production）
gulp.task 'uglify', ->
  gulp.src src.js
    .pipe pl.changed dist.dirMin
    .pipe pl.uglify {
      preserveComments: 'some'
    }
    .pipe gulp.dest dist.dirMin


# concat javascript
gulp.task 'concat', ->
  gulp.src dist.minJs
    .pipe pl.concat projectName + '.js'
    .pipe gulp.dest dist.dirConcat


# image optimization
gulp.task 'imagemin', ->
  gulp.src src.images
    .pipe pl.changed dist.dirImg
    .pipe pl.imagemin {
      progressive: true # jpg
      interlaced: true # gif
      optimizationLevel: 3 # the higher the level, the more trials.
    }
    .pipe gulp.dest dist.dirImg


# browserSync : http://www.browsersync.io/docs/
gulp.task 'bs-init', ->
  browserSync.init {
    port: localPort
    server: {
      baseDir: [src.dirRoot]
    }
    notify: false
    open: false
  }
gulp.task 'bs-reload', ->
  browserSync.reload()


# FIX ME 色がつかない。。。gulpとは別タブでやった方がいいかも
gulp.task 'karma', pl.shell.task [
  'npm test'
]

# inputファイルをkarma.conf.coffeeにも書いてここにも書くの？
# gulp.task 'test', ->
#   gulp.src ['src/**/*.coffee']
#     .pipe pl.karma {
#       configFile: 'karma.conf.coffee'
#       action: 'run'
#     }


# watch
gulp.task 'watch', ['bs-init'], ->
  gulp.watch src.coffee, ['convert']
  gulp.watch src.images, ['imagemin']
  gulp.watch [src.all, dist.all], ['bs-reload'] # 雑

# default
gulp.task 'default', ['watch']

# specific combination
gulp.task 'convert', ['lint', 'coffee', 'uglify', 'concat']
# gulp.task 'convert', ['jshint', 'uglify', 'concat'] # javascriptを書くならこっち
gulp = require('gulp')
pl = require('gulp-load-plugins')()
browserSync = require('browser-sync')

localPort = 9999

src =
  dirRoot:     'src'
  all:         'src/**/*'
  coffee:      'src/coffee/**/*.coffee'
  js:          'src/js/**/*.js' # javascriptを書くならこっち
  tests:       'src/tests/**/*.coffee'
  images:      'src/img/**/*'
  dirJs:       'src/js/'

dest =
  dirMin:   'dest/min/'
  dirImg:   'dest/img/'
  dirMap:   '../map/'


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


# browserSync : http://www.browsersync.io/docs/
gulp.task 'bs-init', ->
  browserSync.init {
    port: localPort
    server: {
      baseDir: ['src']
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
  gulp.watch src.coffee, ['lint', 'convert']
  gulp.watch src.all, ['bs-reload']

# default
gulp.task 'default', ['watch']

# specific combination
gulp.task 'convert', ['coffee', 'uglify']
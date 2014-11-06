gulp = require 'gulp'
pl = require('gulp-load-plugins')()
browserSync = require 'browser-sync'
runSequence = require 'run-sequence'

localPort = 9999
projectName = 'try_karma'

src =
  dirRoot:     'src'
  all:         'src/**/*'
  coffee:      'src/coffee/**/*.coffee'
  dirJs:       'src/js/'
  js:          'src/js/**/*.js' # javascriptを書くならこっち
  test:        'src/test/**/*.coffee'
  images:      'src/img/**/*'
  dirMap:      '../map/'

dist =
  all:         'dist/**/*'
  dirImg:      'dist/img/'
  dirJs:       'dist/js/' # uglifyされたJSファイルを置く
  js:          'dist/js/**/*.js'
  dirJsLib:    'dist/js/lib/' # uglifyされたJSファイル(ライブラリ類)を置く
  jsLib:       'dist/js/lib/**/*.js'
  dirConcat:   'dist/concat/' # uglify + concatされたJSファイルを置く


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
    .pipe pl.sourcemaps.write src.dirMap
    .pipe gulp.dest src.dirJs


# uglify（for production）
gulp.task 'uglify', ->
  gulp.src src.js
    .pipe pl.changed dist.dirJs
    .pipe pl.uglify {
      preserveComments: 'some'
    }
    .pipe gulp.dest dist.dirJs


# ライブラリ類と、それ以外とで別々にconcatする
gulp.task 'concat', ->
  # lib以下以外のJSをまとめる
  gulp.src [dist.js, '!' + dist.jsLib]
    .pipe pl.concat projectName + '.js'
    .pipe gulp.dest dist.dirConcat
  # lib以下をまとめる
  gulp.src dist.jsLib
    .pipe pl.concat 'lib.js'
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
gulp.task 'convert', (callback) ->
  runSequence 'lint', 'coffee', 'uglify', 'concat', callback
# javascriptを書くならこっち
# gulp.task 'convert', (callback) ->
#   runSequence 'jshint', 'uglify', 'concat', callback
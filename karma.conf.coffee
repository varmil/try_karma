# Karma configuration
# Generated on Tue Nov 04 2014 15:31:18 GMT+0900 (JST)

module.exports = (config) ->
  config.set

    # base path that will be used to resolve all patterns (eg. files, exclude)
    basePath: ''


    # frameworks to use
    # available frameworks: https://npmjs.org/browse/keyword/karma-adapter
    frameworks: ['jasmine']


    # list of files / patterns to load in the browser
    files: [
      'src/coffee/**/*.coffee'
      'src/test/**/*.coffee'
    ]


    # list of files to exclude
    exclude: [
    ]


    # preprocess matching files before serving them to the browser
    # available preprocessors: https://npmjs.org/browse/keyword/karma-preprocessor
    preprocessors: {
      # 参考：http://qiita.com/mokemokechicken/items/4c1bd14ef1a701d88608
      # ※文法によってはエラーが出る ex) Logic = -> などでクラスを作るとError
      'src/coffee/**/*.coffee': ['coverage']
      'src/test/**/*.coffee': ['coffee']
    }

    # FIX ME doesnt work well..... => Chromeだといけた。PhantomJSだとnull
    coffeePreprocessor: {
      options: {
        sourceMap: true
      }
    }

    # test results reporter to use
    # possible values: 'dots', 'progress'
    # available reporters: https://npmjs.org/browse/keyword/karma-reporter
    reporters: ['mocha', 'coverage', 'html']

    coverageReporter: {
      type: 'html'
      dir : 'coverage/'
    }

    # web server port
    port: 9876


    # enable / disable colors in the output (reporters and logs)
    colors: true


    # level of logging
    # possible values:
    # - config.LOG_DISABLE
    # - config.LOG_ERROR
    # - config.LOG_WARN
    # - config.LOG_INFO
    # - config.LOG_DEBUG
    logLevel: config.LOG_INFO


    # enable / disable watching file and executing tests whenever any file changes
    autoWatch: true


    # start these browsers
    # available browser launchers: https://npmjs.org/browse/keyword/karma-launcher
    # other example: 'Chrome', 'PhantomJS'
    browsers: ['Chrome']


    # Continuous Integration mode
    # if true, Karma captures browsers, runs the tests and exits
    singleRun: false

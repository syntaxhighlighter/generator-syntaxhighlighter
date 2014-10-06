require 'coffee-errors'

module.exports = (config) ->
  config.set
    colors: yes
    frameworks: ['mocha', 'chai', 'browserify']
    browsers: ['PhantomJS']

    files: ['test/**/*.coffee']

    preprocessors:
      '**/*.coffee': ['coffee', 'browserify']

    browserify:
      extensions: ['.coffee']
      watch: true
      debug: true

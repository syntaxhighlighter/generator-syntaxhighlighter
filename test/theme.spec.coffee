path = require 'path'
rimraf = require 'rimraf'
helpers = require('yeoman-generator').test

describe 'theme', ->
  beforeEach (done) ->
    helpers.testDirectory path.join(__dirname, 'theme-test'), (err) =>
      return done(err) if err
      @target = helpers.createGenerator 'syntaxhighlighter:theme', ['../../theme']
      done()

  afterEach (done) ->
    rimraf "#{__dirname}/theme-test", done

  it 'creates expected files', (done) ->
    helpers.mockPrompt @target,
      appname: 'Eclipse'

    @target.options['skip-install'] = true

    @target.run {}, ->
      helpers.assertFile """
        package.json
        Gruntfile.coffee
        README.md
        .gitignore
        .travis.yml
        test/theme-eclipse.spec.coffee
        scss/theme-eclipse.scss
      """.split /\s+/g

      done()

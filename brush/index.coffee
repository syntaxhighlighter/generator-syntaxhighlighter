require 'coffee-errors'

util = require 'util'
path = require 'path'
yeoman = require 'yeoman-generator'

module.exports = class Generator extends yeoman.generators.Base
  constructor: (args, options, config) ->
    super
    @currentYear = (new Date()).getFullYear()
    @on 'end', => @installDependencies skipInstall: options['skip-install']
    @pkg = JSON.parse @readFileAsString path.join __dirname, '../package.json'

  askFor: ->
    done = @async()

    # have Yeoman greet the user.
    console.log @yeoman

    prompts = [
      name: 'moduleName'
      message: 'What\'s the name of your brush (e.g. JavaScript)?'
      default: @_.slugify @appname
    ]

    @prompt prompts, (props) =>
      @moduleName = props.moduleName
      @appname = @moduleName
      @slug = @_.slugify @appname
      done()

  projectfiles: ->
    @template '_package.json', 'package.json'
    @template 'README.md'
    @template 'Gruntfile.coffee'

  gitfiles: ->
    @copy '_gitignore', '.gitignore'

  app: ->
    @template 'lib/brush.js', "lib/brush-#{@slug}.js"

  tests: ->
    @mkdir 'test'
    @copy '_travis.yml', '.travis.yml'
    @template 'test/spec.coffee', "test/brush-#{@slug}.spec.coffee"
    @template 'test/shcore-stub.js'
    @template 'karma.conf.coffee'

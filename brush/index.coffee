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
    console.log @yeoman

    setProps = ({@appname}) =>
      @slug = @_.slugify @appname
      done()

    {appname} = @options

    if appname?
      setProps {appname}
    else
      prompts = [
        name: 'appname'
        message: 'What\'s the name of your brush (eg JavaScript)?'
        default: @_.slugify @appname
      ]

      @prompt prompts, setProps

  projectfiles: ->
    @template '_package.json', 'package.json'
    @template 'README.md'
    @template 'SAMPLE'
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

  end: ->
    done = @async()
    opts = env: cwd: @env.cwd
    origin = "git@github.com:syntaxhighlighter/brush-#{@slug}.git"

    console.log '$ git init .'
    @spawnCommand('git', ['init', '.'], opts).on 'exit', =>
      console.log "$ git remote add origin #{origin}"
      @spawnCommand('git', ['remote', 'add', 'origin', origin], opts).on 'exit', =>
        done()

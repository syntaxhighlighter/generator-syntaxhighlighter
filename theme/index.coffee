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
        message: 'What\'s the name of your theme (eg Monokai)?'
        default: @_.slugify @appname
      ]

      @prompt prompts, setProps

  projectfiles: ->
    @template '_package.json', 'package.json'
    @template '_travis.yml', '.travis.yml'
    @template 'README.md'
    @template 'Gruntfile.coffee'

  gitfiles: ->
    @copy '_gitignore', '.gitignore'

  app: ->
    @template 'scss/theme.scss', "scss/theme-#{@slug}.scss"

  tests: ->
    @template 'test/spec.coffee', "test/theme-#{@slug}.spec.coffee"
    @template 'test/mocha.opts'

  end: ->
    done = @async()
    opts = env: cwd: @env.cwd
    origin = "git@github.com:syntaxhighlighter/theme-#{@slug}.git"

    console.log '$ git init .'
    @spawnCommand('git', ['init', '.'], opts).on 'exit', =>
      console.log "$ git remote add origin #{origin}"
      @spawnCommand('git', ['remote', 'add', 'origin', origin], opts).on 'exit', =>
        done()

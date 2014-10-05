require 'coffee-errors'

chai = require 'chai'
expect = chai.expect
parser = require 'parser'

(typeof window isnt 'undefined' and window or global)
  .SyntaxHighlighter =
    Highlighter: require 'brush-base'
    regexLib: require 'regex-lib'
    brushes: {}

{Brush} = require '..'

SAMPLE = """
  /* hello */
  function foo() {

  }
"""

describe 'brush-<%= slug %>', ->
  instance = null

  before ->
    instance = new Brush()

  describe 'instance', ->
    it 'has `regexList`', ->
      expect(instance).to.have.property 'regexList'

  describe 'parsing', ->
    matches = null

    before ->
      matches = parser.parse SAMPLE, instance.regexList

    it 'can parse', ->
      expect(matches).to.have.length.above 0

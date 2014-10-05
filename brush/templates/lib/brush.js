;(function()
{
  // CommonJS
  SyntaxHighlighter = SyntaxHighlighter || (typeof require !== 'undefined'? require('shCore').SyntaxHighlighter : null);

  function Brush()
  {
    var keywords = 'break case catch class continue';

    var r = SyntaxHighlighter.regexLib;

    this.regexList = [
      { regex: r.multiLineDoubleQuotedString, css: 'string' },
      { regex: r.multiLineSingleQuotedString, css: 'string' },
      { regex: r.singleLineCComments, css: 'comments' },
      { regex: r.multiLineCComments, css: 'comments' },
      { regex: /\s*#.*/gm, css: 'preprocessor' },
      { regex: new RegExp(this.getKeywords(keywords), 'gm'), css: 'keyword' }
      ];

    this.forHtmlScript(r.scriptScriptTags);
  }

  Brush.prototype = new SyntaxHighlighter.Highlighter();
  Brush.aliases = ['<%= slug %>', 'another...?'];

  SyntaxHighlighter.brushes.<%= appname %> = Brush;

  // CommonJS
  typeof(exports) != 'undefined' ? exports.Brush = Brush : null;
})();

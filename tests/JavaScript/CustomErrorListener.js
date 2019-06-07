const antlr4 = require('antlr4');

class CustomErrorListener extends antlr4.error.ErrorListener {
  constructor() {
    super(...arguments);
  }

  syntaxError(recognizer, offendingSymbol, line, column, msg, e) {
    console.error(`Syntax Error: ${msg}\n${line}:${column}: symbol '${offendingSymbol}'`);
  }
}

exports.CustomErrorListener = CustomErrorListener;

const path = require('path');
const antlr4 = require('antlr4');
const { ClosureLexer } = require('./ClosureLexer.js');
const { ClosureParser } = require('./ClosureParser.js');
const { ClosureParserListener } = require('./ClosureParserListener.js');

class CustomListener extends ClosureParserListener {
  constructor() {
    super(...arguments);

    // TODO
  }
}

function parseClosure(filename, errorListener = () => {}, buildParseTrees = true) {
  const chars = new antlr4.FileStream(filename);
  const lexer = new ClosureLexer(chars);
  const tokens  = new antlr4.CommonTokenStream(lexer);
  const parser = new ClosureParser(tokens);

  parser.addErrorListener(errorListener);
  parser.buildParseTrees = buildParseTrees;

  return parser.soyFile();
}

const targets = [
  'empty-template'
];

const listener = new CustomListener();

for (const target of targets) {
  const tree = parseClosure(path.resolve(`../targets/${target}.soy`));

  antlr4.tree.ParseTreeWalker.DEFAULT.walk(listener, tree);
}

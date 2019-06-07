const path = require('path');
const antlr4 = require('antlr4');
const { ClosureLexer } = require('./ClosureLexer.js');
const { ClosureParser } = require('./ClosureParser.js');

const { CustomListener } = require('./CustomListener.js');
const { CustomErrorListener } = require('./CustomErrorListener.js');

function parseClosure(filename, errorListener = () => {}, buildParseTrees = true) {
  const chars = new antlr4.FileStream(filename);
  const lexer = new ClosureLexer(chars);
  const tokens  = new antlr4.CommonTokenStream(lexer);
  const parser = new ClosureParser(tokens);

  global.tokens = tokens;

  parser.addErrorListener(errorListener);
  parser.buildParseTrees = buildParseTrees;

  return parser.soyFile();
}

const targets = [
  'empty-template',
  'namespace-file'
];

const listener = new CustomListener();
const errorListener = new CustomErrorListener();

console.log('Starting JavaScript tests...');

for (const target of targets) {
  console.log('Test Target ' + target);

  const tree = parseClosure(path.resolve(`../targets/${target}.soy`), errorListener);

  antlr4.tree.ParseTreeWalker.DEFAULT.walk(listener, tree);
}

console.log('JavaScript tests complete.');

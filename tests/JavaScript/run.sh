source ../pre-run.sh

cp ../../generated/JavaScript/ClosureLexer.js .
cp ../../generated/JavaScript/ClosureParser.js .
cp ../../generated/JavaScript/ClosureParserListener.js .

yarn install

node index.js

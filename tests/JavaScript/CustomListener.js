const { ClosureParserListener } = require('./ClosureParserListener.js');

class CustomListener extends ClosureParserListener {
  constructor() {
    super(...arguments);
  }
}

CustomListener.prototype.enterEveryRule = ctx => {
  console.log('Enter ' + ctx.constructor.name);
}

CustomListener.prototype.exitEveryRule = ctx => {
  console.log('Exit ' + ctx.constructor.name);
}

exports.CustomListener = CustomListener;

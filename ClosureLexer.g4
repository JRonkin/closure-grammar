/*
 * The MIT License (MIT)
 *
 * Copyright (c) 2019 by Jason Ronkin
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following
 * conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 */

lexer grammar ClosureLexer;

channels { ERROR }

options {
  superClass=ClosureBaseLexer;
}

/// Command delimiters
LeftDelim:           '{';
RightDelim:          '}';
RightDelimEnd:       '/}';

/// Text
Text:                ~[{}]+;

/// Command attributes
Equals:              '=';
DoubleQuote:         '"';

/// Expression values
NullLiteral:         'null';
BoolLiteral:         'true' | 'false';
IntegerLiteral:      ([0-9]+ | '0x' [0-9A-F]+);
FloatLiteral:        [0-9]+ (('.' [0-9]+)? 'e' '-'? | '.') [0-9]+;
StringLiteral:       '\'' ('\\\'' | .)*? '\'';

Comma:               ',';
Colon:               ':';
Pipe:                '|';

/// Data ref access tokens
Identifier:          [0-9A-Za-z_]+;
Dollar:              '$';
Dot:                 '.';
Question:            '?';
LeftBracket:         '[';
RightBracket:        ']';

/// Expression operations
Mul:                 '*';
Div:                 '/';
Mod:                 '%';
Add:                 '+';
Sub:                 '-';
Eq:                  '==';
NotEq:               '!=';
Lt:                  '<';
Gt:                  '>';
Lte:                 '<=';
Gte:                 '>=';
Not:                 'not';
Or:                  'or';
And:                 'and';
Elvis:               '?:';

LeftParen:           '(';
RightParen:          ')';

/// Soy doc
SoyDocStart:         '/**';
SoyDocParam:         '@param';
SoyDocOptionalParam: '@param?';
SoyDocEnd:           '*/';
Comment:             '//' ~'\n'* | '/*' .*? '*/';

/// Commands
Alias:               'alias';
Call:                'call';
Case:                'case';
Css:                 'css';
Default:             'default';
Delcall:             'delcall';
Delpackage:          'delpackage';
Deltemplate :        'deltamplate';
Else:                'else';
Elseif:              'elseif';
Fallbackmsg:         'fallbackmsg';
For:                 'for';
Foreach:             'foreach';
If:                  'if';
Ifempty:             'ifempty';
Let:                 'let';
Literal:             'literal';
Msg:                 'msg';
Namespace:           'namespace';
Param:               'param';
Plural:              'plural';
Print:               'print';
Switch:              'switch';
Template:            'template';
Xid:                 'xid';
Log:                 'log';
Debugger:            'debugger';

/// Character commands
Space:               '{sp}';
Nil:                 '{nil}';
Tab:                 '{\\t}';
CarriageReturn:      '{\\r}';
Newline:             '{\\n}';
LeftBrace:           '{lb}';
RightBrace:          '{rb}';

/// Close commands.
CallEnd:             '{/call}';
DelcallEnd:          '{/delcall}';
DeltemplateEnd:      '{/deltemplate}';
ForEnd:              '{/for}';
ForeachEnd:          '{/foreach}';
IfEnd:               '{/if}';
LetEnd:              '{/let}';
LiteralEnd:          '{/literal}';
MsgEnd:              '{/msg}';
ParamEnd:            '{/param}';
PluralEnd:           '{/plural}';
SwitchEnd:           '{/switch}';
TemplateEnd:         '{/template}';
LogEnd:              '{/log}';

/// Built-in identifiers
As:                  'as';
In:                  'in';

/// Whitespace
Whitespace:          [ \t\r\n]+ -> channel(HIDDEN);

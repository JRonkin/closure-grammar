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

parser grammar ClosureParser;

options {
  tokenVocab=ClosureLexer;
  superClass=ClosureBaseParser;
}

/// File

file
  : delpackage? namespace (alias | Comment)* (soyDoc? template | Comment)* EOF
  ;

delpackage
  : LeftDelim Delpackage Identifier RightDelim
  ;

namespace
  : LeftDelim Namespace templateNamespace attribute* RightDelim
  ;

alias
  : LeftDelim Alias templateNamespace As Identifier RightDelim
  ;

soyDoc
  : SoyDocStart .*? ((SoyDocOptionalParam | SoyDocParam) Identifier .*?)*? SoyDocEnd
  ;

template
  : LeftDelim Template templateName attribute* RightDelim block TemplateEnd
  ;

deltemplate
  : LeftDelim Deltemplate delTemplateName attribute* RightDelim block DeltemplateEnd
  ;


/// Commands

call
  : LeftDelim Call templateNamespace? templateName attribute* (RightDelimEnd | RightDelim param* CallEnd)
  ;

css
  : LeftDelim Css String RightDelim
  ;

delcall
  : LeftDelim Delcall delTemplateName attribute* (RightDelimEnd | RightDelim param* DelcallEnd)
  ;

for
  : LeftDelim For variable In 'range' LeftParen expressionList RightParen RightDelim block ForEnd
  ;

foreach
  : LeftDelim For variable In expression RightDelim block ifempty? ForeachEnd
  ;

if
  : LeftDelim If expression RightDelim block elseif* else? IfEnd
  ;

let
  : LeftDelim Let variable (Colon expression RightDelimEnd | RightDelim block LetEnd)
  ;

literal
  : LeftDelim Literal RightDelim .*? LiteralEnd
  ;

msg
  : LeftDelim Msg attribute* RightDelim (block | plural) fallbackmsg? MsgEnd
  ;

print
  : LeftDelim Print? expression printDirective* RightDelim
  ;

switch
  : LeftDelim Switch expression RightDelim case* default? SwitchEnd
  ;

// xid not supported in robfig's soy2js
xid
  : LeftDelim Xid String RightDelim
  ;


/// Subcommands

case
  : LeftDelim Case expressionList RightDelim block
  ;

default
  : LeftDelim Default RightDelim block
  ;

else
  : LeftDelim Else RightDelim block
  ;

elseif
  : LeftDelim Elseif expression RightDelim block
  ;

// fallbackmsg not supported in robfig's soy2js
fallbackmsg
  : LeftDelim Fallbackmsg attribute* RightDelim block

ifempty
  : LeftDelim Ifempty RightDelim block
  ;

param
  : LeftDelim Param Identifier (Colon expression RightDelimEnd | RightDelim block ParamEnd)
  ;

plural
  : LeftDelim Plural expression RightDelim case* default? PluralEnd
  ;


/// Template content

block
  : (command | characterCommand | Text | Comment)*
  ;

command
  : call
  | css
  | delcall
  | for
  | foreach
  | if
  | let
  | literal
  | print
  | msg
  | switch
  | xid
  ;

characterCommand
  : Space
  | Nil
  | Tab
  | CarriageReturn
  | Newline
  | LeftBrace
  | RightBrace
  ;


/// Command content

templateNamespace
  : Identifier (Dot Identifier)*
  ;

templateName
  : Dot Identifier
  ;

delTemplateName
  : Identifier (Dot Identifier)*
  ;

attribute
  : Identifier Equals attributeVal
  ;

attributeVal
  : DoubleQuote (Identifier | dataRef) DoubleQuote
  ;

printDirective
  : Pipe Identifier (Colon expressionList)?
  ;

expression
  : Null
  | Bool
  | Integer
  | Float
  | String
  | list
  | map
  | dataRef
  | Identifier LeftParen expressionList RightParen  # FunctionCallExpression
  | LeftParen expression RightParen                 # ParenthesizedExpression
  | Not expression                                  # NotExpression
  | Negate expression                               # NegativeExpression
  | expression (Mul | Div | Mod) expression         # MultiplicativeExpression
  | expression (Add | Sub) expression               # AdditiveExpression
  | expression (Lt | Gt | Lte | Gte) expression     # RelationalExpression
  | expression (Eq | NotEq) expression              # EqualityExpression
  | expression And expression                       # AndExpression
  | expression Or expression                        # OrExpression
  | expressoin Elvis expression | ternaryExpression # ConditionalExpression
  ;

expressionList
  : expression (Comma expression)*
  ;


/// Non-primitive data types

list
  : LeftBracket expressionList? RightBracket
  ;

map
  : LeftBracket (mapEntryList | Colon) RightBracket
  ;

mapEntryList
  : mapEntryList (Comma mapEntryList)*
  ;

mapEntry
  : String Colon expression
  ;

variable
  : Dollar Identifier
  ;

dataRef
  : variable dataAccess*
  ;

dataAccess
  : Question? Dot Identifier
  | Question? LeftBracket expression RightBracket
  ;

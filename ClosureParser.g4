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
  tokenVocab = ClosureLexer;
  superClass = ClosureBaseParser;
}

/// File

soyFile
  : delpackageCmd? namespaceCmd (aliasCmd | Comment)* (soyDoc? templateCmd | Comment)* EOF
  ;

delpackageCmd
  : LeftDelim Delpackage Identifier RightDelim
  ;

namespaceCmd
  : LeftDelim Namespace templateNamespace attribute* RightDelim
  ;

aliasCmd
  : LeftDelim Alias templateNamespace As Identifier RightDelim
  ;

soyDoc
  : SoyDocStart .*? ((SoyDocOptionalParam | SoyDocParam) Identifier .*?)*? SoyDocEnd
  ;

templateCmd
  : LeftDelim Template templateName attribute* RightDelim block TemplateEnd
  ;

deltemplateCmd
  : LeftDelim Deltemplate delTemplateName attribute* RightDelim block DeltemplateEnd
  ;


/// Commands

callCmd
  : LeftDelim Call templateNamespace? templateName attribute* (RightDelimEnd | RightDelim paramCmd* CallEnd)
  ;

cssCmd
  : LeftDelim Css StringLiteral RightDelim
  ;

delcallCmd
  : LeftDelim Delcall delTemplateName attribute* (RightDelimEnd | RightDelim paramCmd* DelcallEnd)
  ;

forCmd
  : LeftDelim For variable In Range LeftParen expressionList RightParen RightDelim block ifemptyCmd? ForEnd
  ;

foreachCmd
  : LeftDelim Foreach variable In expression RightDelim block ifemptyCmd? ForeachEnd
  ;

ifCmd
  : LeftDelim If expression RightDelim block elseifCmd* elseCmd? IfEnd
  ;

letCmd
  : LeftDelim Let variable (Colon expression RightDelimEnd | RightDelim block LetEnd)
  ;

literalCmd
  : LeftDelim Literal RightDelim .*? LiteralEnd
  ;

msgCmd
  : LeftDelim Msg attribute* RightDelim (block | pluralCmd) fallbackmsgCmd? MsgEnd
  ;

printCmd
  : LeftDelim Print? expression printDirective* RightDelim
  ;

switchCmd
  : LeftDelim Switch expression RightDelim caseCmd* defaultCmd? SwitchEnd
  ;

// xid not supported in robfig's soy2js
xidCmd
  : LeftDelim Xid StringLiteral RightDelim
  ;


/// Subcommands

caseCmd
  : LeftDelim Case expressionList RightDelim block
  ;

defaultCmd
  : LeftDelim Default RightDelim block
  ;

elseCmd
  : LeftDelim Else RightDelim block
  ;

elseifCmd
  : LeftDelim Elseif expression RightDelim block
  ;

// fallbackmsg not supported in robfig's soy2js
fallbackmsgCmd
  : LeftDelim Fallbackmsg attribute* RightDelim block
  ;

ifemptyCmd
  : LeftDelim Ifempty RightDelim block
  ;

paramCmd
  : LeftDelim Param Identifier (Colon expression RightDelimEnd | RightDelim block ParamEnd)
  ;

pluralCmd
  : LeftDelim Plural expression RightDelim caseCmd* defaultCmd? PluralEnd
  ;


/// Template content

block
  : (command | characterCommand | Text | Comment)*
  ;

command
  : callCmd
  | cssCmd
  | delcallCmd
  | forCmd
  | ifCmd
  | letCmd
  | literalCmd
  | printCmd
  | msgCmd
  | switchCmd
  | xidCmd
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

expressionList
  : expression (Comma expression)*
  ;

expression
  : NullLiteral                                               # NullExpression
  | BoolLiteral                                               # BoolExpression
  | IntegerLiteral                                            # IntegerExpression
  | FloatLiteral                                              # FloatExpression
  | StringLiteral                                             # StringExpression
  | listLiteral                                               # ListExpression
  | mapLiteral                                                # MapExpression
  | dataRef                                                   # DataRefExpression
  | Identifier LeftParen expressionList RightParen            # FunctionCallExpression
  | LeftParen expression RightParen                           # ParenthesizedExpression
  | Not expression                                            # NotExpression
  | Sub expression                                            # NegativeExpression
  | expression (Mul | Div | Mod) expression                   # MultiplicativeExpression
  | expression (Add | Sub) expression                         # AdditiveExpression
  | expression (Lt | Gt | Lte | Gte) expression               # RelationalExpression
  | expression (Eq | NotEq) expression                        # EqualityExpression
  | expression And expression                                 # AndExpression
  | expression Or expression                                  # OrExpression
  | expression (Elvis | Question expression Colon) expression # ConditionalExpression
  ;


/// Non-primitive data types

listLiteral
  : LeftBracket expressionList? RightBracket
  ;

mapLiteral
  : LeftBracket (mapEntryList | Colon) RightBracket
  ;

mapEntryList
  : mapEntry (Comma mapEntry)*
  ;

mapEntry
  : StringLiteral Colon expression
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

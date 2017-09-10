grammar Config;

// [done] STRING lexer rule定义过于简单，不满足需求, 包括其中包含Quote(',")的String
// [done] nested bool expression中的字段引用
// [done] nested bool expression
// [done] Filter, Output 允许if else, 包含nested if..else
// [done] 允许key不包含双引号
// [done] 允许多行配置没有"，"分割
// [done] 允许plugin中不包含任何配置

// notes: lexer rule vs parser rule
// notes: don't let two lexer rule match the same token

import BoolExpr;

config
    : COMMENT* 'input' input_block COMMENT* 'filter' filter_block COMMENT* 'output' output_block COMMENT* EOF
    ;

input_block
    : '{' plugin_list '}'
    ;

filter_block
    : '{' statement '}'
    ;

output_block
    : '{' statement '}'
    ;

statement
    : (plugin | if_statement | COMMENT)*
    ;

if_statement
    : IF expression '{' statement '}' (ELSE IF expression '{' statement '}')* (ELSE '{' statement '}')?
    ;

plugin_list
    : (plugin | COMMENT)*
    ;

plugin
    : IDENTIFIER entries
//    : plugin_name entries
    ;

entries
    : '{' (pair | COMMENT)* '}'
    ;

// entries
//    : '{' pair (','? pair)* '}'
//    | '{' '}'
//    ;

pair
    : IDENTIFIER '=' value
    ;

array
    : '[' value (',' value)* ']'
    | '[' ']'
    ;

value
    : DECIMAL
    | QUOTED_STRING
//   | entries
    | array
    | 'true'
    | 'false'
    | 'null'
    ;

COMMENT
    : '#' ~( '\r' | '\n' )*
    ;

// double and single quoted string support
fragment BSLASH : '\\';
fragment DQUOTE : '"';
fragment SQUOTE : '\'';
fragment DQ_STRING_ESC : BSLASH ["\\/bfnrt] ;
fragment SQ_STRING_ESC : BSLASH ['\\/bfnrt] ;
fragment DQ_STRING : DQUOTE (DQ_STRING_ESC | ~["\\])* DQUOTE ;
fragment SQ_STRING : SQUOTE (SQ_STRING_ESC | ~['\\])* SQUOTE ;
QUOTED_STRING : DQ_STRING | SQ_STRING ;

WS
    : [ \t\n\r]+ -> skip
    ;

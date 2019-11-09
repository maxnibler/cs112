%{
// $Id: parser.y,v 1.22 2019-04-23 14:07:52-07 - - $
// Dummy parser for scanner project.

#include <cassert>
using namespace std;
#include "lyutils.h"
#include "astree.h"

%}

%debug
%defines
%error-verbose
%token-table
%verbose

%initial-action {
   parser::root = new astree (TOK_ROOT, {0, 0, 0}, "<<ROOT>>");
 }

%token TOK_VOID TOK_INT TOK_STRING
%token TOK_IF TOK_ELSE TOK_WHILE TOK_RETURN TOK_STRUCT
%token TOK_NULLPTR TOK_ARRAY TOK_ARROW TOK_ALLOC TOK_PTR
%token TOK_EQ TOK_NE TOK_LT TOK_LE TOK_GT TOK_GE TOK_NOT
%token TOK_IDENT TOK_INTCON TOK_CHARCON TOK_STRINGCON
%token TOK_ROOT TOK_BLOCK TOK_CALL

%start program

%%

start     : program              { $$ = parser::root;       }
          ;
program   : program structdef    { $$ = $1->adopt ($2);     }
          | program error '}'    { $$ = $1;                 }
          | program error ';'    { $$ = $1;                 }
          | program token
	  |                      { $$ = parser::root;       }
	  ;
structdef : TOK_STRUCT TOK_IDENT '{' type TOK_IDENT '}' ';'
{ destroy($2); destroy($5, $6); $$ = $1->adopt ($3, $4); }
          ;
type      : plaintype
          | TOK_ARRAY '[' plaintype ']'
          ;
plaintype : TOK_INT
          | TOK_STRING
          | TOK_PTR 
          ;
token     : '(' | ')' | '[' | ']' | ','
          | '=' | '+' | '-' | '*' | '/' | '%' | TOK_NOT | TOK_PTR
          | TOK_ROOT TOK_VOID | TOK_INT | TOK_STRING
          | TOK_IF | TOK_ELSE | TOK_WHILE | TOK_RETURN 
          | TOK_NULLPTR | TOK_ARRAY | TOK_ARROW | TOK_ALLOC
          | TOK_EQ | TOK_NE | TOK_LT | TOK_LE | TOK_GT | TOK_GE
          | TOK_IDENT | TOK_INTCON | TOK_CHARCON | TOK_STRINGCON
          ;

%%


const char *parser::get_tname (int symbol) {
   return yytname [YYTRANSLATE (symbol)];
}


bool is_defined_token (int symbol) {
   return YYTRANSLATE (symbol) > YYUNDEFTOK;
}   

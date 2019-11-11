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
%token TOK_ROOT TOK_BLOCK TOK_CALL TOK_FUNC TOK_TYPE_ID TOK_PARAM

%right  '='
%left   TOK_EQ TOK_NE TOK_LT TOK_LE TOK_GT TOK_GE
%left   '+' '-'
%left   '*' '/' '%'
%right  '^'
%right  TOK_NOT
%left   TOK_ARROW

%start program

%%

program   : program structdef    { $$ = $1->adopt ($2);     }
          | program function     { $$ = $1->adopt ($2);     }
          | program vardecl      { $$ = $1->adopt ($2);     }
          | program error '}'    { $$ = $1;                 }
          | program error ';'    { $$ = $1;                 }
	  | %empty               { $$ = parser::root;       }
	  ;
structdef : structdec '}' ';'
           { destroy($2, $3); }
          ;
structdec : TOK_STRUCT TOK_IDENT '{'
           { $$ = $1->adopt($2); destroy($3); }
          | structdec type TOK_IDENT ';'
           { $$ = $1->adopt($2, $3); destroy($4); }
type      : TOK_INT
          | TOK_STRING 
          | TOK_PTR TOK_LT TOK_STRUCT TOK_IDENT TOK_GT
           { $$ = $1->adopt($3, $4); destroy($2, $5); }
          | TOK_VOID
          | TOK_ARRAY TOK_LT type TOK_GT
	   { $$ = $1->adopt($3); destroy($2, $4); }
          ;
function  : funbod ';' {$$ = $1; destroy($2); }
          | funbod block
           { $$ = $1->adopt($2); }
          ;
funbod    : type TOK_IDENT parameters
           { $$ = new astree(TOK_FUNC, $1->loc, "");
             astree* temp = new astree(TOK_TYPE_ID, $1->loc, "");
             temp->adopt($1, $2); $$->adopt(temp, $3);}
          ;
parameters: parambod ')' { destroy($2); }
	  ;
parambod  : '(' {$$ = new astree(TOK_PARAM, $1->loc, "("); }
          | parambod type TOK_IDENT
            { $$ = $1->adopt($2, $3);}
          | parambod ',' type TOK_IDENT
	   { $$ = $1->adopt($3, $4); destroy($2);                }
          ;
block     : body '}'
          ;
body      : '{'  
          { $$ = new astree(TOK_BLOCK, $1->loc, "{");}
          | body statement { $$ = $1->adopt($2); }
statement : vardecl    { $$ = $1; }
	  | expr ';'   { $$ = $1; destroy($2);}
          | block
	  | while
	  | ifelse
          | return              { $$ = $1; }
          | ';'
          ;
vardecl   : varbod ';'   { destroy($2); $$ = $1;}
          ;
varbod    : type TOK_IDENT {$$ = $1->adopt($2); }
          | varbod '=' expr {destroy($2), $$ = $1->adopt($3); }
          ;
while     : TOK_WHILE '(' expr ')' statement
           { $$ = $1->adopt($3, $5); destroy($2, $4); }
          ;
ifelse    : TOK_IF '(' expr ')' statement
           { $$ = $1->adopt($3, $5); destroy($2, $4); }
          | ifelse TOK_ELSE statement
	  { $$ = $1->adopt($2); $2->adopt($3); }
          ;
return    : TOK_RETURN expr ';' {destroy($3); $$ = $1->adopt($2); }
          | TOK_RETURN ';' {destroy($2); $$ = $1; }
          ;
expr      : expr binop expr { $$ = $2->adopt($1, $3);}
          | unop expr { $$ = $1->adopt($2); }
          | variable
	  | call
	  | constant
	  | allocator
	  | '(' expr ')' { $$ = $2; destroy($1, $3);}
          ;
binop     : '+' | '-' | '*' | '/' | '%' | '=' | '^'
          | TOK_GT | TOK_GE | TOK_LT | TOK_LE | TOK_NE
          | TOK_EQ
          ;
unop      : '+' | '-' | TOK_NOT
          ;
allocator : TOK_ALLOC TOK_LT TOK_STRING TOK_GT '(' expr ')'
           { $$ = $1->adopt($6);}
          | TOK_ALLOC TOK_LT TOK_STRUCT TOK_IDENT TOK_GT '(' ')'
	  { $$ = $1->adopt($3, $4);}
          | TOK_ALLOC TOK_LT TOK_ARRAY TOK_LT type
	    TOK_GT TOK_GT '(' expr ')'
           { $$ = $1->adopt($9); }
          ;
call      : callbod ')' {$$ = $1; destroy($2);}
          ;
callbod   : TOK_IDENT '(' 
           { $$ = new astree(TOK_CALL, $1->loc, "(");
             $$->adopt($1); destroy($2);} 
          | callbod expr { $$ = $1->adopt($2); }
          | callbod ',' expr { $$ = $1->adopt($3); destroy($2); }
variable  : TOK_IDENT
          | expr TOK_ARROW TOK_IDENT { $$ = $2->adopt($1, $3);}
          | expr '[' expr ']' { $$ = $1->adopt($3); }
          ;
constant  : TOK_INTCON
          | TOK_STRINGCON
          | TOK_CHARCON
          | TOK_NULLPTR
          ;
%%


const char *parser::get_tname (int symbol) {
   return yytname [YYTRANSLATE (symbol)];
}


bool is_defined_token (int symbol) {
   return YYTRANSLATE (symbol) > YYUNDEFTOK;
}   

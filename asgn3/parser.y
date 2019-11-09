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

%right  '='
%left   TOK_EQ TOK_NE TOK_LT TOK_LE TOK_GT TOK_GE
%left   '+' '-'
%left   '*' '/' '%'
%right  '^'
%right  TOK_NOT

%start program

%%

start     : program              { $$ = parser::root;       }
          ;
program   : program structdef    { $$ = $1->adopt ($2);     }
          | program vardecl      { $$ = $1->adopt ($2);     }
| program function     { cout << "Function" << endl;
   $$ = $1->adopt ($2);     }
          | program error '}'    { $$ = $1;                 }
          | program error ';'    { $$ = $1;                 }
          | program token        { $$ = $1->adopt ($2);     }
	  |                      { $$ = parser::root;       }
	  ;
vardecl   : type TOK_IDENT
          | type TOK_IDENT '=' expr ';'
           { destroy($3, $5); $$ = $1->adopt ($2); $$ = $1->adopt($4);}
          ;
expr      : expr '+' expr { $$ = $2->adopt($1, $3);}
          | expr '-' expr { $$ = $2->adopt($1, $3);}
          | expr '*' expr { $$ = $2->adopt($1, $3);}
          | expr '/' expr { $$ = $2->adopt($1, $3);}
          | expr '%' expr { $$ = $2->adopt($1, $3);}
          | TOK_INTCON
          | variable
          ;
function  : returntype TOK_IDENT '(' ')' block
{ $$ = $1->adopt($2); destroy($3, $4); $$ = $1->adopt($5); }
          | returntype TOK_IDENT '(' parameters ')' block
	   { destroy($5); $$ = $2->adopt($4, $6); }
| returntype '(' ')' '{' vardecl {$$ = $1->adopt($5);}
          ;
parameters: type TOK_IDENT ',' type TOK_IDENT
           { destroy($3); $$ = $1->adopt($4, $5); }
| type TOK_IDENT    { $$ = $1; }
          ;
block     : '{' statement '}' { destroy($1, $3); $$ = $2;}
| '{' '}' {destroy($1, $2); }
          | ';'               { destroy($1); }
          ;
statement : vardecl  
          | block    
	  | expr ';' { destroy($2); }
          ;
variable  : TOK_IDENT
          | expr ',' expr { $$ = $1->adopt($3); destroy($2);}
          | expr TOK_ARROW TOK_IDENT { $$ = $1->adopt($3); destroy($2);}
          ;
structdef : TOK_STRUCT TOK_IDENT '{' type TOK_IDENT '}' ';'
{ destroy($2); destroy($5, $6); $3 = $4; $$ = $1; }
          ;
type      : plaintype 
          | TOK_ARRAY '[' plaintype ']' {$$ = $1->adopt($3);}
          ;
plaintype : TOK_INT
          | TOK_STRING
          | TOK_PTR 
          ;
returntype: plaintype
          | TOK_VOID
          ;
token     : '(' | ')' | '[' | ']' | ',' | '}' | '{' | ';'
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

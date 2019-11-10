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
%token TOK_ROOT TOK_BLOCK TOK_CALL TOK_FUNC TOK_TYPE_ID

%right  '='
%left   TOK_EQ TOK_NE TOK_LT TOK_LE TOK_GT TOK_GE
%left   '+' '-'
%left   '*' '/' '%'
%right  '^'
%right  TOK_NOT

%start program

%%

start     : program              { $$ = $1 = nullptr;       }
          ;
program   : program structdef    { $$ = $1->adopt ($2);     }
          | program function     { $$ = $1->adopt($2);     }
          | program vardecl      { $$ = $1->adopt ($2);     }
          | program error '}'    { $$ = $1;                 }
          | program error ';'    { $$ = $1;                 }
	  | %empty               { $$ = parser::root;       }
	  ;
structdef : TOK_STRUCT TOK_IDENT '{' type TOK_IDENT '}' ';'
           { destroy($2); destroy($5, $6); $3 = $4; $$ = $1; }
          ;
type      : plaintype
          | TOK_ARRAY
          ;
plaintype : TOK_INT
          | TOK_STRING
          | TOK_PTR
          | TOK_VOID
          ;
function  : plaintype TOK_IDENT '(' ')' block
{ $$ = new astree(TOK_FUNC, $1->loc, ""); destroy($3, $4);
             astree* temp = new astree(TOK_TYPE_ID, $1->loc, "");
             $$->adopt(temp, $5); temp->adopt($1, $2); }
          | plaintype TOK_IDENT '(' parameters ')' block
{ $$ = new astree(TOK_FUNC, $1->loc, ""); destroy($3, $5);
             astree* temp = new astree(TOK_TYPE_ID, $1->loc, "");
             $$->adopt(temp, $4); $$->adopt($6); temp->adopt($1, $2); }
          ;
parameters: type TOK_IDENT {$$ = $1->adopt($2); }
	  ;
block     : '{' { $$ = new astree(TOK_BLOCK, $1->loc, "{");}
          | block statement { $$ = $1->adopt($2); }
          | '}' 
          | ';' { destroy($1); }
          ;
statement : vardecl    { $$ = $1; }
	  | expr ';'   { $$ = $1; destroy($2);}
          | block
          | return              { $$ = $1; }
          ;
vardecl   : type TOK_IDENT ';'   { destroy($3); $$ = $1;}
          | type TOK_IDENT '=' expr ';'
	  { destroy($3, $5); $$ = $1->adopt ($2); $$ = $1->adopt($4);}
          ;
expr      : expr '+' expr { $$ = $2->adopt($1, $3);}
          | expr '-' expr { $$ = $2->adopt($1, $3);}
          | expr '*' expr { $$ = $2->adopt($1, $3);}
          | expr '/' expr { $$ = $2->adopt($1, $3);}
          | expr '%' expr { $$ = $2->adopt($1, $3);}
          | expr '=' expr { $$ = $2->adopt($1, $3);}
          | variable
	  | call
	  | constant
          ;
constant  : TOK_INTCON
          | TOK_STRINGCON
          | TOK_CHARCON
          ;
call      : TOK_IDENT '(' expr ')' { $$ = $1->adopt($3); }
          ;
return    : TOK_RETURN expr ';' {destroy($3); $$ = $1->adopt($2); }
          | TOK_RETURN ';' {destroy($2); $$ = $1; }
          ;
variable  : TOK_IDENT
          | expr ',' expr { $$ = $1->adopt($3); destroy($2);}
          | expr TOK_ARROW TOK_IDENT { $$ = $1->adopt($3); destroy($2);}
          ;
%%


const char *parser::get_tname (int symbol) {
   return yytname [YYTRANSLATE (symbol)];
}


bool is_defined_token (int symbol) {
   return YYTRANSLATE (symbol) > YYUNDEFTOK;
}   

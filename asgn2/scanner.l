%{
#include <cassert>

#include "lyutils.h"
#include "astree.h"
%}

%option 8bit
%option debug
%option nobackup
%option nodefault
%option noinput
%option nounput
%option noyywrap
%option warn

digit                [0-9]
letter               [a-zA-Z]

%%
"+"                  { return '+';        }
"-"                  { return '-';        }
"*"                  { return '*';        }
"/"                  { return '/';        }
"%"                  { return '%';        }
"("                  { return '(';        }
")"                  { return ')';        }
"["                  { return '[';        }
"]"                  { return ']';        }
"{"                  { return '{';        }
"}"                  { return '}';        }
";"                  { return ';';        }
","                  { return ',';        }
"="                  { return '=';        }
"=="                 { return TOK_EQ;     }
"<>"                 { return TOK_NE;     }
"<"                  { return TOK_LT;     }
">"                  { return TOK_GT;     }
"<="                 { return TOK_LE;     }
">="                 { return TOK_GE;     }
"->"                 { return TOK_ARROW;  }
"if"                 { return TOK_IF;     }
"else"               { return TOK_ELSE;   }
"while"              { return TOK_WHILE;  }
"return"             { return TOK_RETURN; }
"alloc"              { return TOK_ALLOC;  }
"nullptr"            { return TOK_NULLPTR;}
"not"                { return TOK_NOT;    }
"int"                { return TOK_INT;    }
"string"             { return TOK_STRING; }
"struct"             { return TOK_STRUCT; }
"array"              { return TOK_ARRAY;  }
"ptr"                { return TOK_PTR;    }
"void"               { return TOK_VOID;   }

{letter}({letter}|{digit})* {
                yylval.id = strdup(yytext);
                return TOK_IDENT;         }

{digit}+                    {
                yylval.num = atoi(yytext);
                return TOK_INTCON;        }



%%
{return 1;}

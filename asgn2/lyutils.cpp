// $Id: lyutils.cpp,v 1.13 2019-09-20 16:23:59-07 - - $

#include <cstdio>
#include <cassert>
#include <cctype>
#include <cstring>
#include <iomanip>
#include <iostream>
#include <memory>
#include <sstream>
using namespace std;

//#include "yyparse.h"
#include "auxlib.h"
#include "lyutils.h"

FILE* tokfile;
bool lexer::interactive = true;
location lexer::loc = {.filenr=0, .linenr=1, .offset=0};
size_t lexer::last_yyleng = 0;
vector<string> lexer::filenames;

astree* parser::root = nullptr;

const string* lexer::filename (int filenr) {
   return &lexer::filenames.at(filenr);
}

void lexer::newfilename (const string& filename) {
   lexer::loc.filenr = lexer::filenames.size();
   lexer::filenames.push_back (filename);
}

void lexer::advance() {
   if (not interactive) {
      if (lexer::loc.offset == 0) {
         cout << ";" << setw(3) << lexer::loc.filenr << ","
              << setw(3) << lexer::loc.linenr << ": ";
      }
      cout << yytext;
   }
   lexer::loc.offset += last_yyleng;
   last_yyleng = yyleng;
}

void lexer::newline() {
   ++lexer::loc.linenr;
   lexer::loc.offset = 0;
}

void lexer::badchar (unsigned char bad) {
   ostringstream buffer;
   if (isgraph (bad)) buffer << bad;
                 else buffer << "\\" << setfill('0') << setw(3)
                             << static_cast<unsigned> (bad);
   lexer::error() << "invalid source character ("
                  << buffer.str() << ")" << endl;
}


void lexer::include() {
   size_t linenr;
   size_t filename_size = strlen (yytext) + 1;
   unique_ptr<char[]> filename = make_unique<char[]> (filename_size);
   int scan_rc = sscanf (yytext, "# %zu \"%[^\"]\"",
                         &linenr, filename.get());
   if (scan_rc != 2) {
      error() << "invalid directive, ignored: " << yytext << endl;
   }else {
      if (yy_flex_debug) {
         cerr << "--included # " << linenr << " \"" << filename.get()
              << "\"" << endl;
      }
      lexer::loc.linenr = linenr - 1;
      lexer::newfilename (filename.get());
   }
}

int lexer::token (int symbol) {
   yylval = new astree (symbol, lexer::loc, yytext);
   const char* tokitem = parser::get_tname(symbol);
   printf("%-2ld %2ld.%03ld %4d  %-10s %-s\n",
	  loc.filenr, loc.linenr, loc.offset, symbol, tokitem, yytext);
   return symbol;
}

int lexer::badtoken (int symbol) {
   lexer::error() << "invalid token (" << yytext << ")" << endl;
   return lexer::token (symbol);
}

void lexer::fatal_error (const char* msg) {
   error() << msg << endl;
   throw exit_error (EXIT_FAILURE);
}

ostream& lexer::error() {
   assert (not lexer::filenames.empty());
   return error() << lexer::filename (loc.filenr) << ":"
          << loc.linenr << "." << loc.offset << ": ";
}

void lexer::dump_filenames (ostream& out) {
   for (size_t index = 0; index < filenames.size(); ++index) {
      out << "filenames[" << setw(2) << index << "] = \""
          << filenames[index] << "\"" << endl;
   }
}

void yyerror (const char* message) {
   lexer::error() << message << endl;
}


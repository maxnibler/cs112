#include <cerrno>
#include <cstring>
#include <libgen.h>
#include <iomanip>
#include <iostream>
#include <fstream>
#include <string>
#include <string.h>

#include "string_set.h"
#include "lyutils.h"
#include "auxlib.h"
#include "astree.h"
using namespace std;

const string CPP = "/usr/bin/cpp -nostdinc";
constexpr size_t buffSize = 1024;

void removeChar(char* line, char target){
  size_t slen = strlen(line);
  if (slen == 0)return;
  char* pos = line + slen - 1;
  if (*pos == target)*pos = '\0';
}
void strProc(FILE* pipe, string filename){
  string_set strSet;
  char Buff[buffSize];
  int lineNum = 1;
  while(true){
    const char* readLine = fgets(Buff, buffSize, pipe);
    if (readLine == nullptr)break;
    removeChar(Buff, '\n');
    char* saveLine = nullptr;
    char* linePtr = Buff;
    for(int tokCount = 1;; ++tokCount){
      const char* token = strtok_r(linePtr, " \t\n", &saveLine);
      linePtr = nullptr;
      if (token == nullptr) break;
      strSet.intern(token);
    }
    ++lineNum;
  }
  //cout << filename << endl;
  //string noname = "test.str";
  filebuf outBuff;
  outBuff.open(filename, ios::out);
  ostream outStream(&outBuff);
  strSet.dump(outStream);
  outBuff.close();
}

void flags(int argc, char* argv[]){
  yy_flex_debug = 0;
  yydebug = 0;
  string opt;
  for (int i = 1; i < argc - 1; i++){
    opt = argv[i];
    if (opt[0] == '-'){
      if (opt[1] == 'y'){
        //yy_debug = 1;
        break;
      }
      if (opt[1] == 'l'){
        yy_flex_debug = 1;
        break;
      }
      cerr << "Flag " << opt << " invalid" << endl;
    }
  }
}

string addSuff(char* file, const char* suff){
  string temp = file;
  int len = temp.length();
  bool check = false;
  for (int i = 0; i < len ; i++){
    if (check) file[i] = '\0';
    if (file[i] == '.')check = true;
  }
  strcat(file, suff);
  return file;
}

int main(int argc, char* argv[]){
  string com;
  char* baseName;
  string filestr, filetok, fileast, filesym;
  filebuf buffer;
  string inFile = argv[argc-1];
  if ( inFile[inFile.length()-1] != 'c' ||
       inFile[inFile.length()-2] != 'o' ||
       inFile[inFile.length()-3] != '.'){
    cerr << "error: " << inFile << " is not an .oc file\n";
    exit(-1);
  }else{
    com = CPP + " " + inFile;
    baseName = basename(argv[argc-1]);
    filestr = addSuff(baseName, "str");
    filesym = addSuff(baseName, "sym");
    filetok = addSuff(baseName, "tok");
    fileast = addSuff(baseName, "ast");
    tokfile = fopen(filetok.c_str(), "wb");
    //cout << filetok << endl;
  }
  flags (argc, argv);
  yyin = popen (com.c_str(), "r");
  //int lexint;
  string lexstr;
  yyparse();
  buffer.open(fileast, std::ios::out);
  ostream os(&buffer);
  astree::print(os, parser::root, 0);
  buffer.close();
  buffer.open(filesym, std::ios::out);
  ostream sstrm(&buffer);
  astree::postorder(sstrm, parser::root, 0);
  buffer.close();
  /*  while (true){
    lexint = yylex();
    if (lexint == YYEOF)break;
    else {
      //lexstr = lexer::get_yytname(lexint);
      //cout << lexint << endl;
    }
  }*/
  strProc(yyin, filestr);
  pclose(yyin);
  return 0;
}

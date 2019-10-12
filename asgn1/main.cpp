#include <cerrno>
#include <cstring>
#include <libgen.h>
#include <iomanip>
#include <iostream>
#include <fstream>
#include <string>
#include <string.h>
#include "string_set.h"
using namespace std;

const string CPP = "/usr/bin/cpp -nostdinc";
constexpr size_t buffSize = 1024;
void removeChar(char* line, char target){
  size_t slen = strlen(line);
  if (slen == 0)return;
  char* pos = line + slen - 1;
  if (*pos == target)*pos = '\0';
}
void preProc(FILE* pipe, string filename){
  string_set strSet;
  char Buff[buffSize];
  int lineNum = 1;
  while(true){
    const char* readLine = fgets(Buff, buffSize, pipe);
    if (readLine == nullptr)break;
    removeChar(Buff, '\n');
    //cout << "Line  " << lineNum << " of " << filename << " : " << Buff << endl;
    char* saveLine = nullptr;
    char* linePtr = Buff;
    for(int tokCount = 1;; ++tokCount){
      const char* token = strtok_r(linePtr, " \t\n", &saveLine);
      linePtr = nullptr;
      if (token == nullptr) break;
      //cout << lineNum << "; " << tokCount << ": " <<
      //token << endl;
      //const string* returnStr =
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

int main(int argc, char* argv[]){
  string com;
  const char* suff = "str";
  char* filename;
  string inFile = argv[argc-1];
  if ( inFile[inFile.length()-1] != 'c' ||
       inFile[inFile.length()-2] != 'o' ||
       inFile[inFile.length()-3] != '.'){
    cerr << "error: " << inFile << " is not an .oc file\n";
    exit(-1);
  }else{
    com = CPP + " " + inFile;
    filename = basename(argv[argc-1]);
    string filestr = filename;
    int len = filestr.length();
    filename[len - 1] = '\0';
    filename[len - 2] = '\0';
    strcat(filename, suff);
  }
  //cout << "command=\"" << filename << "\"" << endl;
  //string filename = inFile+"r";
  FILE* pipe = popen (com.c_str(), "r");
  preProc(pipe, filename);
  pclose(pipe);
  return 0;
}

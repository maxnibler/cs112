#include <cerrno>
#include <cstring>
#include <iomanip>
#include <iostream>
#include <string>
#include <string.h>
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
  char Buff[buffSize];
  while(true){
    const char* readLine = fgets(Buff, buffSize, pipe);
    if (readLine == nullptr)break;
    removeChar(Buff, '\n');
    //cout << "FirstLine: " << Buff << endl;
  }
}

int main(int argc, char* argv[]){
  string inFile = argv[argc-1];
  if ( inFile[inFile.length()-1] != 'c' ||
       inFile[inFile.length()-2] != 'o' ||
       inFile[inFile.length()-3] != '.'){
    cerr << "error: " << inFile << " is not an .oc file\n";
    exit(-1);
  }
  string com = CPP + " " + inFile;
  cout << "command=\"" << com << "\"" << endl;
  FILE* pipe = popen (com.c_str(), "r");
  preProc(pipe, inFile);
  int fileCloseStat = pclose(pipe);
  return 0;
}

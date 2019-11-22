#include <cassert>
#include <iomanip>
#include <iostream>

using namespace std;

#include "symbol.h"
#include "astree.h"
#include "string_set.h"
#include "lyutils.h"

void putSym(ostream& o, int symbol, location loc){
  o << symbol << ": " << parser::get_tname(symbol) << endl;
}

enum class attr {
  VOID, INT, NULLPTR_T, STRING, STRUCT, ARRAY,
  FUNCTION, VARIABLE, FIELD, TYPEID, PARAM, LOCAL,
  LVAL, CONST, VREG, VADDR, BITSET_SIZE,
};
using attr_bitset = bitset<attr::BITSET_SIZE>;

struct symbol{
  attr_bitset attributes;
  size_t sequence;
  symbol_table* fields;
  location lloc;
  size_t block_nr;
  vector<symbol*>* parameters;
};

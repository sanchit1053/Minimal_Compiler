

#include "type.hh"
#include <string>
#include <map>
#include <utility>
#include <tuple>
#include <algorithm>

enum EntityType{
    Function,
    Variable,
    Struct,
};


enum Scope{
    Global,
    Local,
    Parameter,
};



class entity;

class symtab{
    public:
    std::map<std::string, entity*> table;
    int offset;
    int parameterOffset;
    symtab();

    void addEntity(entity* e);
    entity* getEntity(std::string s);
    void printSymTab(int specialOffset = 0, int isFunction = 1);
    void addSymtab(symtab* s);
};

class entity{
    public:
    std::string identifier;
    enum EntityType entityType;
    enum Scope scope;
    int size;
    int offset;
    TypeClass type;
    symtab* st;

    entity(std::string identifier, enum EntityType entityType, enum Scope scope, TypeClass type, symtab* st = NULL);

    void addArray(int n);
    void addDeref();
    int getSize();

    void printEntity(int paramOffset, int specialOffset, int isFunction);
    int getParamNumber();
    bool structContains(std::string val);
    std::vector<TypeClass> getParamTypes();

};


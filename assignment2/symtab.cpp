#include "symtab.hh"

extern symtab *glbsymtab;

struct sort_types{
    bool operator()(const std::pair<int, TypeClass> &a, const std::pair<int, TypeClass> &b){
        return a.first > b.first;
    }
};


std::string printEntityType(enum EntityType e){
    switch(e)
    {
        case Function: return "fun";
        case Variable: return "var";
        case Struct : return "struct";
        default: return "-";

    }
}

std::string printScope(enum Scope s){
    switch(s)
    {
        case Global: return "global";
        case Local: return "local";
        case Parameter: return "param";
        default: return "INVALID";
    }
}


entity::entity(std::string identifier, enum EntityType entityType, enum Scope scope, TypeClass type, symtab* st){
    this->identifier = identifier;
    this->entityType = entityType;
    this->scope = scope;
    this->type = type;
    this->st = st;

    if(st != NULL){
        this->size = this->getSize();
    }
}

void entity::addArray(int n){
    this->type.addArray(n);
}

void entity::addDeref(){
    this->type.addDeref();
}

int entity::getSize(){
    int size = 0;
    for(std::map<std::string, entity*>::iterator i = this->st->table.begin(); i != this->st->table.end(); i++){
        size += i->second->size;
    }
    return size;
}

void entity::printEntity(int paramOffset, int specialOffset, int isFunction){
    std::cout << "[\n";
    std::cout << "\"" << this->identifier << "\",\n";
    std::cout << "\"" << printEntityType(this->entityType) << "\"";
    std::cout << ",\n";
    std::cout << "\"" << printScope(this->scope) << "\"";
    std::cout << ",\n";
    if(this->entityType == Function){
        std::cout << 0 << ",\n";
        std::cout << 0 << ",\n";
    }
    else if(this->entityType == Struct){
        std::cout << this->getSize() << ",\n";
        std::cout << "\"-\"" << ",\n";
    }
    else{
        std::cout << this->size << ",\n";
        if(this->scope == Parameter){
            int change = 12 - paramOffset;
            std::cout << this->offset + change<< ",\n";
        }
        else{
            // cout << ""
            int o = 0;
            if(isFunction == -1){
                o = this->size;
            }
            std::cout << isFunction * (this->offset + o ) << ",\n";
        }
    }
    std::cout << "\"";
    this->type.print();
    std::cout << "\"";
    std::cout << "\n]";

}

int entity::getParamNumber(){
    int ans = 0;
    for(std::map<std::string, entity*>::iterator i = this->st->table.begin(); i != this->st->table.end(); i++){
        ans += i->second->scope == Parameter;
    }
    return ans;
}

bool entity::structContains(std::string val){
    for(std::map<std::string, entity*>::iterator i = this->st->table.begin(); i != this->st->table.end(); i++){
        if( i->second->identifier == val ){
            return true;
        }
    }
    return false;
}

std::vector<TypeClass> entity::getParamTypes(){
    std::vector<std::pair<int, TypeClass>> tempAns;
    for(std::map<std::string, entity*>::iterator i = this->st->table.begin(); i != this->st->table.end(); i++){
        if(i->second->scope == Parameter){
            tempAns.emplace_back(i->second->offset, i->second->type);
        }
    }
    std::vector<TypeClass> ans;
    sort(tempAns.begin(), tempAns.end(), sort_types());
    for(int i = 0; i < tempAns.size(); i++){
        ans.push_back(tempAns[i].second);
    }
    return ans;
}

symtab::symtab(){
    this->offset = 0;
    this->parameterOffset = 0;
}

void symtab::addEntity(entity* e){

    if(e->scope == Parameter){
        // std::cout << "STARTING " << e->size << " " << this->parameterOffset << " " << e->offset << std::endl;
        e->size = e->type.getSize();
        this->parameterOffset -= e->size;
        e->offset = this->parameterOffset;
        // std::cout << "ENDING " << e->size << " " << this->parameterOffset << " " << e->offset << std::endl;
    }
    else{
        e->size = e->type.getSize();
        // std::cout << "{debug} " << e->size  << " " << this->offset << std::endl;
        e->offset = this->offset;
        this->offset += e->size;
    }
    this->table[e->identifier] = e;
}

entity* symtab::getEntity(std::string s){
    if(this->table.find(s) == this->table.end()){
        return NULL;
    } 
    entity* e = this->table[s];
    return e;
}

void symtab::addSymtab(symtab* s){
    for(std::map<std::string, entity*>::iterator i = s->table.begin(); i != s->table.end(); i++){
        i->second->offset += this->offset;
        this->table[i->first] = i->second;
    }
    this->offset += s->offset;
}

void symtab::printSymTab(int specialOffset, int isFunction){
    std::cout << "[\n";
    for(std::map<std::string, entity*>::iterator i = this->table.begin(); i != this->table.end(); i++){
        i->second->printEntity(this->parameterOffset, specialOffset, isFunction);
        if(next(i) != this->table.end())
            std::cout << ",\n";
    }
    std::cout << "\n]";
}
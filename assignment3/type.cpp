#include "type.hh"
#include "symtab.hh"

extern symtab * glbsymtab;

bool arrayPointer(TypeClass a, TypeClass b){
    return (a == b) || (decay(a) == b) || (a == decay(b)) || (decay(a) == decay(b));

}

TypeClass decay(TypeClass a){
    if(a.arr.size() > 0 && !a.addr){
        a.arr.erase(a.arr.begin());
        a.addr = true;
    }
    return a;
}



std::string getType(enum Type type){
    switch(type){
        case IntType: return "int";
        case FloatType: return "float";
        case StringType: return "string";
        case VoidType: return "void";
        case StructType: return "struct";
        default: return "-";
    }
}

int getTypeSize(std::string type){
    if(type == "int") return 4;
    if(type == "float") return 4;
    if(type == "string") return 0;
    if(type.substr(0,6) == "struct") return glbsymtab->getEntity(type)->getSize();
    return 0;
}

TypeClass::TypeClass(std::string type, int deref){
    this->type = type;
    this->deref = deref;
    this->arr = std::vector<int>(0);
    addr = false;
}


void TypeClass::addDeref(){
    this->deref++;
}

void TypeClass::addArray(int n){
    this->arr.push_back(n);
}

std::string TypeClass::getPrintString(){
    std::string ans = this->type;
    for(int i = 0; i < this->deref; i++){
        ans += "*";
    }
    if(this->addr){
        ans += "(*)";
    }
    // if(this->addr && this->arr.size() == 0){
    //     ans += "*";
    // }
    for(int i = 0; i < this->arr.size(); i++){
        ans += "[" + std::to_string(this->arr[i]) + "]";
    }
    return ans;
}

void TypeClass::print(){
    std::cout << (this->type == "NullType" ? "-" : this->type);
    for(int i = 0; i < this->deref; i++){
        std::cout << "*";
    }
    for(int i = 0; i < this->arr.size(); i++){
        std::cout << "[" << this->arr[i] << "]";
    }
}

int TypeClass::getSize(){
    int base = 0;
    if(this->deref > 0) base =  4;
    else{
        base = getTypeSize(this->type);
    }
    for(int i = 0; i < this->arr.size(); i++){
        base *= this->arr[i];
    }
    return base;
}

bool TypeClass::operator==(TypeClass t){
    if(this->type != t.type) return false;

    if(this->addr == false && t.addr == false){
        if(this->deref != t.deref) return false;
        if(this->arr.size() != t.arr.size()) return false;
        for(int i = 0; i < this->arr.size(); i++){
            if(this->arr[i] != t.arr[i]) return false;
        }
        return true;
    }
    else{
        int t1 = this->deref;
        int t2 = t.deref;
        if(this->arr.size() ==  0 && this->addr){
            t1++;
        }
        if(t.arr.size() ==  0 && t.addr){
            t2++;
        }
        if(this->arr.size() != t.arr.size()) return false;
        for(int i = 0; i < this->arr.size(); i++){
            if(this->arr[i] != t.arr[i]) return false;
        }
        if(this->arr.size() > 0 && this->addr != t.addr){
            return false;
        }
        if(t1 != t2) return false;

        return true;
    }
}

bool TypeClass::operator!=(TypeClass t){
    return !(*this == t);
}

bool TypeClass::isSubscriptable(){
    if(this->deref > 0) return true;
    if(this->arr.size() > 0) return true;
    return false;
}

bool TypeClass::isDereferencable(){
    if(this->deref > 0) return true;
    if(this->arr.size() > 0) return true;
    if(this->addr) return true;
    return false;
}


bool TypeClass::isPointer(){
    if(this->deref > 0) return true;
    return false;
}

TypeClass TypeClass::index(){
    TypeClass n = *this;
    if(n.arr.size() > 0){
        n.arr.pop_back();
        return n;
    }
    else{
        n.deref--;
        return n;
    }
}

TypeClass TypeClass::address(){
    TypeClass ans = TypeClass(this->type);
    ans.deref = this->deref;
    ans.arr = this->arr;
    ans.addr = true;
    return ans;
}

TypeClass TypeClass::derefType(){
    TypeClass n = *this;
    if(n.addr){
        n.addr = false;
        return n;
    }
    else{
        if(n.arr.size() > 0){
            n.arr.pop_back();
            return n;
        }
        else{
            n.deref--;
            return n;
        }
    }
}

bool TypeClass::isStruct(){
    if(this->type.length() > 6 && this->type.substr(0,6) == "struct" && this->deref == 0 && this->arr.size() == 0){
        return true;
    }
    return false;
}

bool TypeClass::isPointerStruct(){
    if(this->type.length() > 6 && this->type.substr(0,6) == "struct" ){
        if(this->deref == 1 && this->arr.size() == 0 && !this->addr){
            return true;
        }
        if(this->arr.size() == 1 && this->deref == 0 && !this->addr){
            return true;
        }
        if(this->arr.size() == 0 && this->deref == 0 && this->addr){
            return true;
        }
    }
    return false;
}

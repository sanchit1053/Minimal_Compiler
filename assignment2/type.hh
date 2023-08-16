#ifndef TYPES
#define TYPES

#include <vector>
#include <string>
#include <iostream>



enum Type {IntType, FloatType, StringType, VoidType, StructType, NullType};

struct TypeClass{
    public:
    std::string type;
    int deref;
    std::vector<int> arr;

    bool addr;
    TypeClass(std::string type = "NullType", int deref = 0);

    void addDeref();
    void addArray(int n);
    void print();
    std::string getPrintString();

    int getSize();
    bool operator==(TypeClass t);
    bool operator!=(TypeClass t);
    bool isSubscriptable();
    bool isDereferencable();
    bool isPointer();
    TypeClass index();
    TypeClass address();
    TypeClass derefType();
    bool isStruct();
    bool isPointerStruct();

};

bool arrayPointer(TypeClass a, TypeClass b);

TypeClass decay(TypeClass a);

#endif
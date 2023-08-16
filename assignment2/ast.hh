#include <iostream>
#include <vector>
#include <string>
#include "type.hh"



using namespace std;

enum typeExp
{
    emptystmt,
    seqstmt,
    assignmentstmt,
    returnstmt,
    ifstmt,
    whilestmt,
    forstmt,


    binaryoptype,
    unaryoptype,
    assignmenttype,
    funcalltype,
    intconsttype,
    floatconsttype,
    stringconsttype,
    identifiertype,
    arrayreftype,
    membertype,
    arrowtype,
};

class op_binary_astnode;
class op_unary_astnode;
class assignE_astnode;
class funcallexp_astnode;
class funcallstmt_astnode;
class intconst_astnode;
class floatconst_astnode;
class stringconst_astnode;
class identifier_astnode;
class arrayref_astnode;
class member_astnode;
class arrow_astnode;
class empty_astnode;
class seq_astnode;
class assignS_astnode;
class return_astnode;
class if_astnode;
class for_astnode;
class while_astnode;



class abstract_astnode
{
public:
    virtual void print() = 0;
    enum typeExp astnode_type;
};

class statement_astnode : public abstract_astnode
{
    public :
};

class exp_astnode : public abstract_astnode
{
    public :
    TypeClass type;
    bool lval;
};

class ref_astnode : public exp_astnode
{
    public :
};


class op_binary_astnode : public exp_astnode
{
    public:
    string op;
    exp_astnode* first;
    exp_astnode* second;
    op_binary_astnode(string op, exp_astnode* first, exp_astnode* second);

    void print();

};

class op_unary_astnode : public exp_astnode
{
    public:
    string op;
    exp_astnode* exp;
    op_unary_astnode(string op, exp_astnode* exp);

    void print();
};

class assignE_astnode : public exp_astnode
{
    public:
    exp_astnode* first;
    exp_astnode* second;
    assignE_astnode(exp_astnode* first, exp_astnode* second);

    void print();
};

class funcallexp_astnode : public exp_astnode
{
    public:
    identifier_astnode* identifier;
    vector<exp_astnode*> parameters;
    funcallexp_astnode(identifier_astnode* identifier, vector<exp_astnode*> parameters );

    void print();
};


class funcallstmt_astnode : public statement_astnode
{
    public:
    identifier_astnode* identifier;
    vector<exp_astnode*> parameters;
    funcallstmt_astnode(identifier_astnode* identifier, vector<exp_astnode*> parameters );

    void print();
};

class intconst_astnode : public ref_astnode
{

public:
    std::string value;
    intconst_astnode(std::string temp);
  
    void print();
};

class floatconst_astnode : public  ref_astnode
{

public:
    std::string value;
    floatconst_astnode(std::string temp);

    void print();
};

class stringconst_astnode : public ref_astnode
{

public:
    std::string value;
    stringconst_astnode(std::string temp);
   

    void print();
};

class identifier_astnode : public ref_astnode
{

public:
    std::string value;
    identifier_astnode(std::string temp);

    void print();
};

class arrayref_astnode : public exp_astnode
{
    public:
    exp_astnode* first;
    exp_astnode* second;
    arrayref_astnode(exp_astnode* first, exp_astnode* second);

    void print();
};

class member_astnode : public exp_astnode
{
    public:
    exp_astnode* exp;
    identifier_astnode* identifier;
    member_astnode(exp_astnode* exp, identifier_astnode* identifier);

    void print();

};

class arrow_astnode : public exp_astnode
{
    public:
    exp_astnode* exp;
    identifier_astnode* identifier;
    arrow_astnode(exp_astnode* exp, identifier_astnode* identifier);

    void print();
};


class empty_astnode: public statement_astnode
{
    public:
    empty_astnode();

    void print();
};

class seq_astnode: public statement_astnode
{
    public:
    vector<statement_astnode*> statements;
    seq_astnode(vector<statement_astnode*> statements);

    void print();
};

class assignS_astnode : public statement_astnode
{
    public:
    exp_astnode* first;
    exp_astnode* second;
    assignS_astnode(exp_astnode* first, exp_astnode* second);

    void print();
};

class return_astnode : public statement_astnode
{
    public:
    exp_astnode* exp;
    return_astnode(exp_astnode* exp);

    void print();
};

class if_astnode : public statement_astnode
{
    public:
    exp_astnode* exp;
    statement_astnode* first;
    statement_astnode* second;
    if_astnode(exp_astnode* exp, statement_astnode* first, statement_astnode* second);

    void print();
};

class while_astnode : public statement_astnode
{
    public:
    exp_astnode* exp;
    statement_astnode* statement;
    while_astnode(exp_astnode* exp, statement_astnode* statement);

    void print();
};

class for_astnode : public statement_astnode
{
    public:
    exp_astnode* first;
    exp_astnode* second;
    exp_astnode* third;
    statement_astnode* statement;
    for_astnode(exp_astnode* first, exp_astnode* second, exp_astnode* third, statement_astnode* statement);

    void print();
};
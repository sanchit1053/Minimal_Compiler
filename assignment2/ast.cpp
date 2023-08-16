#include "ast.hh"


op_binary_astnode::op_binary_astnode(string op, exp_astnode* first, exp_astnode* second){
    this->op = op;
    this->first = first;
    this->second = second;
    astnode_type = binaryoptype;
}

op_unary_astnode::op_unary_astnode(string op, exp_astnode* exp){
    this->op = op;
    this->exp = exp;
    astnode_type = unaryoptype;
}

assignE_astnode::assignE_astnode(exp_astnode* first, exp_astnode* second){
    this->first = first;
    this->second = second;
    astnode_type = assignmenttype;
}

funcallexp_astnode::funcallexp_astnode(identifier_astnode* identifier, vector<exp_astnode*> parameters){
    this->identifier = identifier;
    this->parameters = parameters;
    astnode_type = funcalltype;
}


funcallstmt_astnode::funcallstmt_astnode(identifier_astnode* identifier, vector<exp_astnode*> parameters){
    this->identifier = identifier;
    this->parameters = parameters;
    astnode_type = funcalltype;
}

intconst_astnode::intconst_astnode(std::string temp)
{
    value = temp;
    astnode_type = intconsttype;
}

floatconst_astnode::floatconst_astnode(std::string temp)
{
    value = temp;
    astnode_type = floatconsttype;
}

stringconst_astnode::stringconst_astnode(std::string temp)
{
    value = temp;
    astnode_type = stringconsttype;
}

identifier_astnode::identifier_astnode(std::string temp)
{
    value = temp;
    astnode_type = identifiertype;
}

arrayref_astnode::arrayref_astnode(exp_astnode* first, exp_astnode* second){
    this->first = first;
    this->second = second;
    astnode_type = arrayreftype;
    this->type = first->type.index();
}

member_astnode::member_astnode(exp_astnode* exp, identifier_astnode* identifier){
    this->exp = exp;
    this->identifier = identifier;
    astnode_type = membertype;
}

arrow_astnode::arrow_astnode(exp_astnode* exp, identifier_astnode* identifier){
    this->exp = exp;
    this->identifier = identifier;
    astnode_type = arrowtype;
}

empty_astnode::empty_astnode(){
    astnode_type = emptystmt;
}

seq_astnode::seq_astnode(vector<statement_astnode*> statements){
    this->statements = statements;
    astnode_type = seqstmt;
}

assignS_astnode::assignS_astnode(exp_astnode* first, exp_astnode* second){
    this->first = first;
    this->second = second;
    astnode_type = assignmentstmt;
}

return_astnode::return_astnode(exp_astnode* exp){
    this->exp = exp;
    astnode_type = returnstmt;
}

if_astnode::if_astnode(exp_astnode* exp, statement_astnode* first, statement_astnode* second){
    this->exp = exp;
    this->first = first;
    this->second = second;
    astnode_type = ifstmt;
}

while_astnode::while_astnode(exp_astnode* exp, statement_astnode* statement){
    this->exp = exp;
    this->statement = statement;
    astnode_type = whilestmt;
}

for_astnode::for_astnode(exp_astnode* first, exp_astnode* second, exp_astnode* third, statement_astnode* statement){
    this->first = first;
    this->second = second;
    this->third = third;
    this->statement = statement;
    astnode_type = forstmt;
}
///////////////////////////////////////////////////////////////////

void op_binary_astnode::print(){
    std::cout << "{\n \"op_binary\": {\n";
    std::cout << "\"op\": \"" << op << "\"," << std::endl;
    cout << "\"left\": ";
    first->print();
    cout << ","<< std::endl;
    cout << "\"right\": ";
    second->print();
    cout <<std::endl << "}" << std::endl << "}";
}


void op_unary_astnode::print(){
    cout << "{"<< std::endl;
    std::cout << "\"op_unary\": {"<< std::endl;
    std::cout << "\"op\": \"" << op << "\","<< std::endl;
    cout << "\"child\": ";
    exp->print();
    cout<< std::endl << "}" << std::endl << "}";
}

void assignE_astnode::print(){
    cout << "{\n\"assignE\": {"<< std::endl;
    cout << "\"left\": ";
    first->print(); cout << ","<< std::endl;
    cout << "\"right\": ";
    second->print(); cout << ""<< std::endl;
    cout << "}"<< std::endl<<"}";

}

void funcallexp_astnode::print(){
     cout << "{\n\"funcall\": {"<< std::endl;
    cout << "\"fname\": ";
    identifier->print(); cout << ","<< std::endl;
    cout << "\"params\": [" << std::endl ;
    for(int i = 0; i < parameters.size(); i++){
        parameters[i]->print();
        if(i < parameters.size() - 1)
            cout << ","<< std::endl;
    }
    cout << "\n]\n}\n}";
}


void funcallstmt_astnode::print(){
    cout << "{\n\"proccall\": {"<< std::endl;
    cout << "\"fname\": ";
    identifier->print(); cout << ","<< std::endl;
    cout << "\"params\": [\n";
    for(int i = 0; i < parameters.size(); i++){
        parameters[i]->print();
        if(i < parameters.size() -1)
            cout << ","<< std::endl;
    }
    cout << "\n]\n}\n}";
}

void intconst_astnode::print(){
    std::cout << "{\n\"intconst\": "  <<  value << "\n}";
}

void floatconst_astnode::print(){
    std::cout << "{\n\"floatconst\": "  <<  value << "\n}";
}

void stringconst_astnode::print(){
    std::cout << "{\n\"stringconst\": "  <<  value << "\n}";
}

void identifier_astnode::print(){
    std::cout << "{\n\"identifier\": \""  <<  value << "\"\n}";
}

void arrayref_astnode::print(){
    cout << "{\n\"arrayref\": {"<< std::endl;
    cout << "\"array\": ";
    first->print();
    cout << ",\n\"index\": ";
    second->print();
    cout << "\n}\n}";
}

void member_astnode::print(){
    cout << "{\n\"member\": {"<< std::endl;
    cout << "\"struct\": ";
    exp->print();
    cout << ",\n";
    cout << "\"field\": ";
    identifier->print();
    cout << "\n}\n}";
}

void arrow_astnode::print(){
    cout << "{\n\"arrow\": {"<< std::endl;
    cout << "\"pointer\": ";
    exp->print();
    cout << ",\n";
    cout << "\"field\": ";
    identifier->print();
    cout << "\n}\n}";
}


void  empty_astnode::print(){
    cout << "\"empty\"";
}

void seq_astnode::print(){
    cout << "{\n\"seq\": ["<< std::endl;

    for(int i = 0; i < statements.size(); i++){
        statements[i]->print();
        if(i < statements.size() - 1)
            cout << ","<< std::endl;
    }

    cout << "\n]\n}";
    
}

void assignS_astnode::print(){
    cout << "{\n\"assignS\": {"<< std::endl;
    cout << "\"left\": ";
    first->print(); cout << ","<< std::endl;
    cout << "\"right\": ";
    second->print(); cout << ""<< std::endl;
    cout << "}\n}";
}

void return_astnode::print(){
    cout << "{\n\"return\":";
    exp->print();
    cout << "\n}";
}

void if_astnode::print(){
    cout << "{\n\"if\": {"<< std::endl;
    cout << "\"cond\": "<< std::endl;
    exp->print();
    cout << ",\n";
    cout << "\"then\": "<< std::endl;
    first->print();
    cout << ","<< std::endl;
    cout << "\"else\": "<< std::endl;
    second->print();
    cout << "\n}\n}";
}

void while_astnode::print(){
    cout<< "{\n\"while\": {"<< std::endl;
    cout << "\"cond\": ";
    exp->print();
    cout << ","<< std::endl;
    cout << "\"stmt\": ";
    statement->print();
    cout << "\n}\n}";
}

void for_astnode::print(){
    cout << "{\n\"for\": {"<< std::endl;
    cout << "\"init\": ";
    first->print();
    cout << ","<< std::endl;
    cout << "\"guard\": ";
    second->print();
    cout << ","<< std::endl;
    cout << "\"step\": ";
    third->print();
    cout << ","<< std::endl;
    cout << "\"body\": ";
    statement->print();
    cout << "\n}\n}";
}
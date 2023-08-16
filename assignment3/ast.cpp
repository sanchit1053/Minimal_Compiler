#include "ast.hh"



op_binary_astnode::op_binary_astnode(string op, exp_astnode* first, exp_astnode* second){
    this->op = op;
    this->first = first;
    this->second = second;
    astnode_type = binaryoptype;

    this->code = "";
}

op_unary_astnode::op_unary_astnode(string op, exp_astnode* exp){
    this->op = op;
    this->exp = exp;
    astnode_type = unaryoptype;
    this->code = "";
}

assignE_astnode::assignE_astnode(exp_astnode* first, exp_astnode* second){
    this->first = first;
    this->second = second;
    astnode_type = assignmenttype;
    this->code = "";

}

funcallexp_astnode::funcallexp_astnode(identifier_astnode* identifier, vector<exp_astnode*> parameters){
    this->identifier = identifier;
    this->parameters = parameters;
    astnode_type = funcalltype;
    this->code = "";

}


funcallstmt_astnode::funcallstmt_astnode(identifier_astnode* identifier, vector<exp_astnode*> parameters){
    this->identifier = identifier;
    this->parameters = parameters;
    astnode_type = funcalltype;
    this->code = "";

}

intconst_astnode::intconst_astnode(std::string temp)
{
    value = temp;
    astnode_type = intconsttype;
    this->code = "";

}

floatconst_astnode::floatconst_astnode(std::string temp)
{
    value = temp;
    astnode_type = floatconsttype;
    this->code = "";

}

stringconst_astnode::stringconst_astnode(std::string temp)
{
    value = temp;
    astnode_type = stringconsttype;
    this->code = "";

}

identifier_astnode::identifier_astnode(std::string temp)
{
    value = temp;
    astnode_type = identifiertype;
    this->code = "";

}

arrayref_astnode::arrayref_astnode(exp_astnode* first, exp_astnode* second){
    this->first = first;
    this->second = second;
    astnode_type = arrayreftype;
    this->code = "";

    this->type = first->type.index();
}

member_astnode::member_astnode(exp_astnode* exp, identifier_astnode* identifier){
    this->exp = exp;
    this->identifier = identifier;
    astnode_type = membertype;
    this->code = "";

}

arrow_astnode::arrow_astnode(exp_astnode* exp, identifier_astnode* identifier){
    this->exp = exp;
    this->identifier = identifier;
    astnode_type = arrowtype;
    this->code = "";

}

empty_astnode::empty_astnode(){
    astnode_type = emptystmt;
    this->code = "";

}

seq_astnode::seq_astnode(vector<statement_astnode*> statements){
    this->statements = statements;
    astnode_type = seqstmt;
    this->code = "";

}

assignS_astnode::assignS_astnode(exp_astnode* first, exp_astnode* second){
    this->first = first;
    this->second = second;
    astnode_type = assignmentstmt;
    this->code = "";

}

return_astnode::return_astnode(exp_astnode* exp){
    this->exp = exp;
    astnode_type = returnstmt;
    this->code = "";

}

if_astnode::if_astnode(exp_astnode* exp, statement_astnode* first, statement_astnode* second){
    this->exp = exp;
    this->first = first;
    this->second = second;
    astnode_type = ifstmt;
    this->code = "";

}

while_astnode::while_astnode(exp_astnode* exp, statement_astnode* statement){
    this->exp = exp;
    this->statement = statement;
    astnode_type = whilestmt;
    this->code = "";

}

for_astnode::for_astnode(exp_astnode* first, exp_astnode* second, exp_astnode* third, statement_astnode* statement){
    this->first = first;
    this->second = second;
    this->third = third;
    this->statement = statement;
    astnode_type = forstmt;
    this->code = "";

}

printf_call::printf_call(string s, vector<exp_astnode*> parameters){
    this->s = s;
    this->parameters = parameters;
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

void printf_call::print(){
    cout << "{\n\"proccall\": {"<< std::endl;
    cout << "\"fname\": ";
    cout << "\"printf\""; cout << ","<< std::endl;
    cout << "\"params\": [\n";
    for(int i = 0; i < parameters.size(); i++){
        parameters[i]->print();
        if(i < parameters.size() -1)
            cout << ","<< std::endl;
    }
    cout << "\n]\n}\n}";
}


///////////////////////////////////////////////////////////////////////////////

void op_binary_astnode::printcode(){
   
    first->printcode();
    if(this->op == "OP_AND"){
        cout << "\tcmpl $0, " << this->first->offset << "(%ebp)\n";
        cout << "\tje .L" << this->label << endl;;
    }
    else if(this->op == "OP_OR"){
        cout << "\tcmpl $0, " << this->first->offset << "(%ebp)\n";
        cout << "\tjne .L" << this->label << endl;;
    }

    second->printcode();

    if(this->op == "OP_AND"){
        cout << "\tmovl " << this->second->offset << "(%ebp), %eax\n";
        cout << "\taddl $4, %esp\n";
        cout << "\tcmpl $0, %eax\n";
        cout << "\tje .L" << this->label << endl;
    }
    else if(this->op == "OP_OR"){
        cout << "\tmovl " << this->second->offset << "(%ebp), %eax\n";
        cout << "\taddl $4, %esp\n";
        cout << "\tcmpl $0, %eax\n";
        cout << "\tjne .L" << this->label << endl;
    }
    cout << this->code;

    if(this->op == "OP_AND"){
        cout << "\tmovl $1, " << this->first->offset << "(%ebp)" << endl;
        cout << "\tjmp .L" << this->label + 1 << endl;
        cout << ".L" << this->label << ":\n";
        cout << "\tmovl $0, " << this->first->offset << "(%ebp)" << endl;
        cout << ".L" << this->label+1 << ":\n";

    }
    else if(this->op == "OP_OR"){
        cout << "\tmovl $0, " << this->first->offset << "(%ebp)" << endl;
        cout << "\tjmp .L" << this->label + 1 << endl;
        cout << ".L" << this->label << ":\n";
        cout << "\tmovl $1, " << this->first->offset << "(%ebp)" << endl;
        cout << ".L" << this->label+1 << ":\n";
    }

}


void op_unary_astnode::printcode(){
    exp->printcode();
    cout << this->code;
}

void assignE_astnode::printcode(){
    second->printcode();

    cout << this->code;
}

void funcallexp_astnode::printcode(){
    identifier->printcode();
    for(int i = 0; i < parameters.size(); i++){
        parameters[i]->printcode();
    }
    cout << this->code;
}


void funcallstmt_astnode::printcode(){
    identifier->printcode();
    for(int i = 0; i < parameters.size(); i++){
        parameters[i]->printcode();
    }
    cout << this->code;
}

void intconst_astnode::printcode(){
    cout << this->code;
}

void floatconst_astnode::printcode(){
    cout << this->code;
}

void stringconst_astnode::printcode(){
    cout << this->code;
}

void identifier_astnode::printcode(){
    cout << this->code;
}

void arrayref_astnode::printcode(){
    first->printcode();
    second->printcode();
    cout << this->code;
}

void member_astnode::printcode(){
    exp->printcode();
    identifier->printcode();
    cout << this->code;
}

void arrow_astnode::printcode(){
    exp->printcode();
    identifier->printcode();
    cout << this->code;
}


void  empty_astnode::printcode(){
    cout << this->code;
}

void seq_astnode::printcode(){

    cout << this->codefirst;
    for(int i = 0; i < statements.size(); i++){
        statements[i]->printcode();
    }

    cout << this->code;
    
}

void assignS_astnode::printcode(){
    first->printcode();
    second->printcode();
    cout << this->code;
}

void return_astnode::printcode(){
    exp->printcode();
    cout << this->code;
}

void if_astnode::printcode(){
    exp->printcode();
    cout << "\t#IF STATEMENT" << endl;
    cout << "\tmovl " << exp->offset << "(%ebp), %eax" << endl;
    cout << "\taddl $4, %esp" << endl;
    cout << "\tcmpl $0, %eax" << endl;
    cout << "\tje .L" << this->label << endl;

    first->printcode();
    cout << "\tjmp .L" << this->label+1 << endl;
    cout << "\t.L" << this->label << ":" << endl;

    second->printcode();
    cout << "\t.L" << this->label+1 << ": \n";

    cout << this->code;
}

void while_astnode::printcode(){

    cout << "\t# WHILE STATEMENT" << endl;
    cout << ".L" << this->label << ":\n";
    exp->printcode();

    cout << "\tmovl " << exp->offset << "(%ebp), %eax" << endl;
    cout << "\taddl $4, %esp" << endl;
    cout << "\tcmpl $0, %eax" << endl;
    cout << "\tje .L" << this->label+1 << endl;

    statement->printcode();
    cout << "\tjmp .L" << this->label <<endl;
    cout << ".L" << this->label+1 << ":\n";
    cout << this->code;
}

void for_astnode::printcode(){
    first->printcode();

    cout << "\t# FOR STATEMENT" << endl;
    cout << ".L" << this->label << ":\n";
    second->printcode();
    cout << "\tmovl " << second->offset << "(%ebp), %eax" << endl;
    cout << "\taddl $4, %esp" << endl;
    cout << "\tcmpl $0, %eax" << endl;
    cout << "\tje .L" << this->label+1 << endl;
    cout << "\tjmp .L" << this->label+2 << endl;
    cout << ".L" << this->label+3 << ":\n";
    third->printcode();
    cout << "\tjmp .L" << this->label << endl;
    cout << ".L" << this->label+2 << ":\n";
    statement->printcode();
    cout << "\tjmp .L" << this->label+3 << endl;
    cout << ".L" << this->label+1 << ":\n";
    cout << this->code;
}

void printf_call::printcode(){

    // cout << "\tsubl $4 %esp"<<endl;

    for(int i = 0; i < parameters.size(); i++){
        parameters[i]->printcode();
    }
    for(int i = parameters.size() - 1; i >= 0; i--){
        cout << "\tpushl " << parameters[i]->offset << "(%ebp)\n";
    }
    cout << "\tpushl $" << this->s << endl;
    cout << this->code;
}
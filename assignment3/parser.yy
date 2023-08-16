%skeleton "lalr1.cc"
%require  "3.0.1"

%defines 
%define api.namespace {IPL}
%define api.parser.class {Parser}

%define parse.trace
/* %define api.location.type{IPL::location} */

%code requires{
	#include "ast.hh"
	#include "symtab.hh"
	#include "type.hh"
	#include "location.hh"
	 namespace IPL {
			class Scanner;
	 }

	// # ifndef YY_NULLPTR
	// #  if defined __cplusplus && 201103L <= __cplusplus
	// #   define YY_NULLPTR nullptr
	// #  else
	// #   define YY_NULLPTR 0
	// #  endif
	// # endif

}

%printer { std::cerr << $$; } VOID 			
%printer { std::cerr << $$; } INT 			
%printer { std::cerr << $$; } FLOAT 			
%printer { std::cerr << $$; } STRING 		 	
%printer { std::cerr << $$; } STRUCT 			
%printer { std::cerr << $$; } IF 				
%printer { std::cerr << $$; } ELSE 			
%printer { std::cerr << $$; } FOR 			     
%printer { std::cerr << $$; } WHILE 			
%printer { std::cerr << $$; } RETURN 
%printer { std::cerr << $$; } MAIN
%printer { std::cerr << $$; } PRINTF
%printer { std::cerr << $$; } IDENTIFIER 		
%printer { std::cerr << $$; } CONSTANT_INT	
%printer { std::cerr << $$; } FLOAT_CONSTANT	
%printer { std::cerr << $$; } CONSTANT_STR
%printer { std::cerr << $$; } EOS
%printer { std::cerr << $$; } LCB
%printer { std::cerr << $$; } RCB
%printer { std::cerr << $$; } LRB
%printer { std::cerr << $$; } RRB
%printer { std::cerr << $$; } LSB
%printer { std::cerr << $$; } RSB
%printer { std::cerr << $$; } OP_ADD
%printer { std::cerr << $$; } OP_SUB
%printer { std::cerr << $$; } OP_MUL
%printer { std::cerr << $$; } OP_DIV
%printer { std::cerr << $$; } OP_MEM
%printer { std::cerr << $$; } COMMA
%printer { std::cerr << $$; } OP_INC 		 	
%printer { std::cerr << $$; } OP_AND 		 	
%printer { std::cerr << $$; } OP_OR 		 	
%printer { std::cerr << $$; } OP_EQ 		 	
%printer { std::cerr << $$; } OP_NEQ 		 	
%printer { std::cerr << $$; } OP_LT 			
%printer { std::cerr << $$; } OP_GT 			
%printer { std::cerr << $$; } OP_LTE 			
%printer { std::cerr << $$; } OP_GTE 			
%printer { std::cerr << $$; } OP_PTR 			
%printer { std::cerr << $$; } OP_NOT 			
%printer { std::cerr << $$; } OP_ADDR 			
%printer { std::cerr << $$; } OP_ASSIGN 			
%printer { std::cerr << $$; } OTHER


%parse-param { Scanner  &scanner  }
%locations
%code{
	 #include <iostream>
	 #include <cstdlib>
	 #include <fstream>
	 #include <string>
	 #include <stack>
	 
	 #include "scanner.hh"

	#define tab string("\t")
	#define ln "\n"

	//  extern int glbsymbtab, localsymtab;
	extern symtab* glbsymtab ;
	extern std::map<std::string, abstract_astnode*> ast;
	extern symtab* currentsymtab;
	extern std::map<std::string, TypeClass> predefined;
	extern std::map<std::string, std::string> strings;
	std::string currentFunction;
	TypeClass basetype, funBaseType;

	int stackPointer;
	bool leftVal = false;
	stack<int> functionStack;
	stack<int> sp;

	int numStrings = 0;
	int labelNum = 0;

#undef yylex
#define yylex IPL::Parser::scanner.yylex

}





%define api.value.type variant
%define parse.assert

%start program

%token <std::string> VOID 			
%token <std::string> INT 			
%token <std::string> FLOAT 			
%token <std::string> STRING 		 	
%token <std::string> STRUCT 			
%token <std::string> IF 				
%token <std::string> ELSE 			
%token <std::string> FOR 			     
%token <std::string> WHILE 			
%token <std::string> RETURN 			
%token <std::string> MAIN 			
%token <std::string> PRINTF			
%token <std::string> IDENTIFIER 		
%token <std::string> CONSTANT_INT	
%token <std::string> FLOAT_CONSTANT	
%token <std::string> CONSTANT_STR
%token <std::string> EOS
%token <std::string> LCB
%token <std::string> RCB
%token <std::string> LRB
%token <std::string> RRB
%token <std::string> LSB
%token <std::string> RSB
%token <std::string> OP_ADD
%token <std::string> OP_SUB
%token <std::string> OP_MUL
%token <std::string> OP_DIV
%token <std::string> OP_MEM
%token <std::string> COMMA
%token <std::string> OP_INC 		 	
%token <std::string> OP_AND 		 	
%token <std::string> OP_OR 		 	
%token <std::string> OP_EQ 		 	
%token <std::string> OP_NEQ 		 	
%token <std::string> OP_LT 			
%token <std::string> OP_GT 			
%token <std::string> OP_LTE 			
%token <std::string> OP_GTE 			
%token <std::string> OP_PTR 			
%token <std::string> OP_NOT 			
%token <std::string> OP_ADDR 			
%token <std::string> OP_ASSIGN 			
%token <std::string> OTHER


%nterm <abstract_astnode*> program
%nterm <abstract_astnode*> translation_unit
%nterm <symtab*> struct_specifier
%nterm <seq_astnode*> main_definition
%nterm <seq_astnode*> function_definition
%nterm <TypeClass> type_specifier
%nterm <symtab*> parameter_list
%nterm <entity*> parameter_declaration
%nterm <seq_astnode*> compound_statement
%nterm <seq_astnode*> statement_list
%nterm <statement_astnode*> statement
%nterm <assignE_astnode*> assignment_expression
%nterm <funcallstmt_astnode*> procedure_call
%nterm <exp_astnode*> expression
%nterm <exp_astnode*> logical_and_expression
%nterm <exp_astnode*> equality_expression
%nterm <exp_astnode*> relational_expression
%nterm <exp_astnode*> additive_expression
%nterm <exp_astnode*> unary_expression
%nterm <exp_astnode*> multiplicative_expression
%nterm <if_astnode*> selection_statement
%nterm <exp_astnode*> postfix_expression
%nterm <exp_astnode*> primary_expression
%nterm <std::vector<exp_astnode*>> expression_list
%nterm <std::string> unary_operator
%nterm <statement_astnode*> iteration_statement
%nterm <symtab*> declaration_list
%nterm <symtab*> declaration
%nterm <symtab*> declarator_list 
%nterm <entity*> declarator_arr
%nterm <entity*> declarator
%nterm <printf_call*> printf_call

%%
program:
		main_definition
		{
			
		}
		| translation_unit main_definition
		{

		}


translation_unit:
		 struct_specifier 
		 {

			currentsymtab = new symtab();
		 } 
		 | function_definition 
		 {
			currentsymtab = new symtab();

			//  $1->print();
		 } 
		 | translation_unit struct_specifier 
		 {
			
			currentsymtab = new symtab();
		 }
		 | translation_unit function_definition 
		 {
			currentsymtab = new symtab();


			//  $2->print();
		 };

struct_specifier:
		 STRUCT IDENTIFIER LCB declaration_list RCB EOS   
		 {
			//  cout << "REACHED" << endl;
				entity* temp = new entity("struct "+$2, Struct, Global, TypeClass("NullType"), currentsymtab);
			//  cout << "REACHED1" << endl;
				temp->size = temp->getSize();
				glbsymtab->addEntity(temp);
			//  cout << "REACHED2" << endl;
		 };    

function_definition:  
		type_specifier IDENTIFIER LRB {currentFunction = $2; funBaseType = basetype;} RRB {
			entity* temp = new entity(currentFunction, Function, Global, $1, currentsymtab);
			glbsymtab->addEntity(temp);}
			compound_statement 
		{
			$$ = $7;
			ast[currentFunction] = $$;
			// std::cout << "REACHED" << std::endl;
			
		};
		| type_specifier IDENTIFIER LRB  {currentFunction = $2; funBaseType = basetype;} parameter_list RRB {
			entity* temp = new entity(currentFunction, Function, Global, $1, currentsymtab);
			glbsymtab->addEntity(temp);}compound_statement
		{
			$$ = $8;
			ast[currentFunction] = $$;

		}

main_definition:
		INT {
			stackPointer = 0;
		} MAIN {currentFunction = "main"; funBaseType = TypeClass("int"); } LRB RRB compound_statement
		{	
			$$ = $7;
			entity* temp = new entity(currentFunction, Function, Global, $1, currentsymtab);
			ast[currentFunction] = $$;
			glbsymtab->addEntity(temp);															
		};
		
type_specifier:
		VOID {
			$$ = TypeClass("void");
			basetype = $$;
		}
		| INT {
			$$ = TypeClass("int");
			basetype = $$;
		}
		| STRUCT IDENTIFIER {
			$$ = TypeClass("struct " + $2 );
			basetype = $$;
		};


declaration_list: 
		declaration {
			$$ = new symtab();
			currentsymtab->addSymtab($1);	
		}
		| declaration_list declaration {
			$$ = $1;
			currentsymtab->addSymtab($2);
		};

declaration:
		type_specifier declarator_list EOS {
			
			// $2->printSymTab();
			for(std::map<std::string, entity*>::iterator i = $2->table.begin(); i != $2->table.end(); i++){
				if(i->second->type == TypeClass("void")){
					error(@$, "Cannot declare variable of type \"" + i->second->type.getPrintString() + "\"");
					exit(1);
				}
			}
			$$ = $2;
		};

declarator_list:
		declarator {
			$$ = new symtab();
			$$->addEntity($1);
		}
		| declarator_list COMMA declarator {
				$1->addEntity($3);
				$$ = $1;
		}; 

declarator:
		declarator_arr {
			$$ = $1;
		}
		| OP_MUL declarator {
			$$ = $2;
			$$->addDeref();
		};

declarator_arr:
		IDENTIFIER {
			$$ = new entity($1, Variable, Local, basetype);
		}
		| declarator_arr LSB CONSTANT_INT RSB {
			$$ = $1;
			$$->addArray(stoi($3));
		};
		

parameter_list:
		parameter_declaration {
			currentsymtab->addEntity($1);
		}
		| parameter_list COMMA parameter_declaration {
			currentsymtab->addEntity($3);
	};      

parameter_declaration:
		type_specifier declarator {
				basetype = $1;
				$$ = $2;
				$$->scope = Parameter;
		};

compound_statement: 
		LCB RCB {
				statement_astnode* temp = new empty_astnode();
				std::vector<statement_astnode*> n;
				// n.push_back(temp);
				$$ = new seq_astnode(n);	
		}
	| LCB {stackPointer = -1 * currentsymtab->offset - 4;} statement_list RCB {
				$$ = $3;
		}

	/* | LCB declaration_list RCB {
				statement_astnode* temp = new empty_astnode();
				std::vector<statement_astnode*> n;
				$$ = new seq_astnode(n);
	} */
	| LCB declaration_list {stackPointer = -1 * currentsymtab->offset - 4; sp.push( currentsymtab->offset); } statement_list RCB {
				$$ = $4;
				$$->codefirst = tab + "# local variable "  + ln;
				$$->codefirst += tab + "subl $" +  to_string(sp.top()) + ", %esp" + ln + $$->code;
				sp.pop();
		};

statement_list:
		statement {
				vector<statement_astnode*> v;
				v.push_back($1);
				$$ = new seq_astnode(v);
		}
	| statement_list statement {
				seq_astnode* v = $1;
				v->statements.push_back($2);
				$$ = v;	
	}; 

statement:
		EOS  {
			$$ = new empty_astnode();
		}
		| LCB statement_list RCB {
				$$ = $2;
		}
		| assignment_expression EOS {
				$$ = new assignS_astnode($1->first, $1->second);
				$$->code = $1->code;
		}
		| selection_statement {
				$$ = $1;
		}
		| iteration_statement  {
				$$ = $1;
		}
		| procedure_call {
				$$ = $1;
		}   
		|printf_call {
				$$ = $1;
		}    
		| RETURN expression EOS  {
				if($2->type == funBaseType){
					 $$ = new return_astnode($2);
				}
				else if($2->type == TypeClass("int") && funBaseType==TypeClass("float")){
					$2 = new op_unary_astnode("TO_FLOAT", $2);
					$$ = new return_astnode($2);
				}
				else if($2->type == TypeClass("float") && funBaseType==TypeClass("int")){
					$2 = new op_unary_astnode("TO_INT", $2);
					$$ = new return_astnode($2);
				}
				else{
					error(@$, "Incompatible type \"" + $2->type.getPrintString() + "\" returned, expected \""  + funBaseType.getPrintString() +"\"");
					exit(1);
				}

				if(funBaseType.isStruct()){
					$$->code = tab + "leal " + to_string($2->offset) + "(%ebp), %eax" + ln;
					$$->code += tab + "addl $" + to_string($2->size) + ", %esp" + ln;
					stackPointer += $2->size;
				}
				else{
					$$->code = tab + "movl " + to_string($2->offset) + "(%ebp), %eax" + ln;
					$$->code += tab + "addl $" + "4, %esp" + ln;
					stackPointer += 4;
				}
				$$->code += tab + "leave" + ln;
				$$->code += tab + "ret" + ln;
		};

assignment_expression:
		  unary_expression OP_ASSIGN expression { 

			 	intconst_astnode *temp = dynamic_cast<intconst_astnode*>($3);

			 	if($1->type == $3->type){
					 $$ = new assignE_astnode($1, $3);
					 $$->type = TypeClass("NullType");
				}
				else if($1->type == TypeClass("int") && $3->type==TypeClass("float")){
					$3 = new op_unary_astnode("TO_INT", $3);
					 $$ = new assignE_astnode($1, $3);
					$$->type = TypeClass("NullType");
				}
				else if($1->type == TypeClass("float") && $3->type==TypeClass("int")){
					$3 = new op_unary_astnode("TO_FLOAT", $3);
					$$ = new assignE_astnode($1, $3);
					$$->type = TypeClass("NullType");
				}
				else if($1->type.isPointer() && $3->type == TypeClass("int") && $3->astnode_type == intconsttype && temp->value == "0"){
					$$ = new assignE_astnode($1, $3);
					$$->type = TypeClass("NullType");
				}
				else if(arrayPointer($1->type, $3->type)){
					$$ = new assignE_astnode($1, $3);
					$$->type = TypeClass("NullType");
				}
				else if($1->type.type == "void" && $1->type.isPointer() && $3->type.isSubscriptable()){
					$$ = new assignE_astnode($1, $3);
					$$->type = $1->type;
				}
				else if($3->type.type == "void" && $1->type.isPointer() && $3->type.isSubscriptable()){
					$$ = new assignE_astnode($1, $3);
					$$->type = $1->type;
				}
				else{
					error(@$, "Incompatible assignment when assigning to type \"" + $1->type.getPrintString() + "\" from type \"" + $3->type.getPrintString() + "\"");
					exit(1);
				}


				if($1->constant == true){
					$$->code = tab + "# assigning array" + ln;
					$$->code += tab + "movl " + to_string($1->offset) + "(%ebp), %eax"+ln;
					$$->code += tab + "movl " + to_string($3->offset) + "(%ebp), %edx"+ln;
					$$->code += tab + "movl %edx, (%eax)" + ln;
					$$->code += tab + "addl $" + to_string($3->size) + ", %esp" + ln;
					$$->code += tab + "addl $" + "4, %esp" + ln;
					stackPointer += 4;
					stackPointer += $3->size;

				}
				else if($1->isAddress){
					$$->code = tab + "movl " + to_string($1->offset) + "(%ebp), %eax" + ln;
					for(int i = 0; i < $1->addressOffset.size() - 1; i++){
						$$->code += tab + "movl " + to_string($1->addressOffset[i]) + "(%eax), %eax" + ln;
					}
					$$->code += tab + "leal " + to_string($1->addressOffset[$1->addressOffset.size() - 1]) + "(%eax), %eax" + ln;
					$$->code +=tab +"movl " + to_string($3->offset) + "(%ebp), %edx" + ln;
					$$->code += tab + "movl %edx, (%eax)" + ln;
					$$->code += tab + "addl $" + "4, %esp" + ln;;
					stackPointer += $3->size;
				}
				else{
					$$->code +=tab +"movl " + to_string($3->offset) + "(%ebp), %eax" + ln;
					$$->code += tab + "movl %eax, " + to_string($1->offset) + "(%ebp)" + ln;
					$$->code += tab + "addl $" + "4, %esp" + ln;;
					stackPointer += 4;

				}

		};

expression:
		logical_and_expression {
				$$ = $1;
		}
	| expression OP_OR logical_and_expression {
				if($1->type.isStruct() || $3->type.isStruct()){
					error(@$, "Invalid operand of ||,  not scalar or pointer");
					exit(1);
				}
				$$ = new op_binary_astnode("OP_OR", $1, $3);
				$$->type = TypeClass("int");

				$$->size = $1->size;
				$$->offset = $1->offset;
				$$->label = labelNum;
				labelNum += 2;
				stackPointer += 4;
	};

logical_and_expression:
		equality_expression {
				$$ = $1;
		}
	| logical_and_expression OP_AND equality_expression {
				if($1->type.isStruct() || $3->type.isStruct()){
					error(@$, "Invalid operand of &&,  not scalar or pointer");
					exit(1);
				}
				$$ = new op_binary_astnode("OP_AND", $1, $3);
				$$->type = TypeClass("int");

				$$->size = $1->size;
				$$->offset = $1->offset;
				$$->label = labelNum;
				labelNum += 2;
				stackPointer += 4;
		};
		
equality_expression :
		relational_expression {
				$$ = $1;
		}
	| equality_expression OP_EQ relational_expression {
				if($1->type == TypeClass("int") && $3->type==TypeClass("int")){
					$$ = new op_binary_astnode("EQ_OP_INT", $1, $3);
					$$->type = TypeClass("int");
				}
				else if($1->type == TypeClass("float") && $3->type==TypeClass("float")){
					$$ = new op_binary_astnode("EQ_OP_FLOAT", $1, $3);
					$$->type = TypeClass("int");
				}
				else if($1->type == TypeClass("int") && $3->type==TypeClass("float")){
					$1 = new op_unary_astnode("TO_FLOAT", $1);
					$$ = new op_binary_astnode("EQ_OP_FLOAT", $1, $3);
					$$->type = TypeClass("int");
				}
				else if($1->type == TypeClass("float") && $3->type==TypeClass("int")){
					$3 = new op_unary_astnode("TO_FLOAT", $1);
					$$ = new op_binary_astnode("EQ_OP_FLOAT", $1, $3);
					$$->type = TypeClass("int");
				}
				else if($1->type == $3->type){
					$$ = new op_binary_astnode("EQ_OP_INT", $1, $3);
					$$->type = TypeClass("int");
				}
				else if(arrayPointer($1->type, $3->type)){
					$$ = new op_binary_astnode("EQ_OP_INT", $1, $3);
					$$->type = TypeClass("int");
				}
				else{
					error(@$, "Invalid operand types for binary == ,\"" +  $1->type.getPrintString() + "\" and \"" + $3->type.getPrintString() + "\"");
					exit(1);
				}
				$$->offset = $1->offset;
				$$->size = $1->size;
				$$->code += tab + "movl " + to_string($1->offset) + "(%ebp), %eax" + ln;
				$$->code += tab + "cmpl " + to_string($3->offset) + "(%ebp), %eax" + ln;
				$$->code += tab + "sete %al" + ln;
				$$->code += tab + "movzbl %al, %eax" + ln;
				$$->code += tab + "movl %eax, " + to_string($1->offset) + "(%ebp)" + ln;
				$$->code += tab + "addl $" + "4, %esp" + ln;
				stackPointer+= 4;; 
				
	}
	| equality_expression OP_NEQ relational_expression {
				if($1->type == TypeClass("int") && $3->type==TypeClass("int")){
					$$ = new op_binary_astnode("NE_OP_INT", $1, $3);
					$$->type = TypeClass("int");
				}
				else if($1->type == TypeClass("float") && $3->type==TypeClass("float")){
					$$ = new op_binary_astnode("NE_OP_FLOAT", $1, $3);
					$$->type = TypeClass("int");
				}
				else if($1->type == TypeClass("int") && $3->type==TypeClass("float")){
					$1 = new op_unary_astnode("TO_FLOAT", $1);
					$$ = new op_binary_astnode("NE_OP_FLOAT", $1, $3);
					$$->type = TypeClass("int");
				}
				else if($1->type == TypeClass("float") && $3->type==TypeClass("int")){
					$3 = new op_unary_astnode("TO_FLOAT", $3);
					$$ = new op_binary_astnode("NE_OP_FLOAT", $1, $3);
					$$->type = TypeClass("int");
				}
				else if($1->type == $3->type){
					$$ = new op_binary_astnode("NE_OP_INT", $1, $3);
					$$->type = TypeClass("int");
				}
				else if($1->type.isSubscriptable() && $3->type == TypeClass("int")){
					$$ = new op_binary_astnode("NE_OP_INT", $1, $3);
					$$->type = TypeClass("int");
				}
				else if($3->type.isSubscriptable() && $1->type == TypeClass("int")){
					$$ = new op_binary_astnode("NE_OP_INT", $1, $3);
					$$->type = TypeClass("int");
				}
				else if(arrayPointer($1->type, $3->type)){
					$$ = new op_binary_astnode("NE_OP_INT", $1, $3);
					$$->type = TypeClass("int");
				}
				else{
					error(@$, "Invalid operand types for binary != ,\"" +  $1->type.getPrintString() + "\" and \"" + $3->type.getPrintString() + "\"");
					exit(1);
				}	

				$$->offset = $1->offset;
				$$->size = $1->size;
				$$->code += tab + "movl " + to_string($1->offset) + "(%ebp), %eax" + ln;
				$$->code += tab + "cmpl " + to_string($3->offset) + "(%ebp), %eax" + ln;
				$$->code += tab + "setne %al" + ln;
				$$->code += tab + "movzbl %al, %eax" + ln;
				$$->code += tab + "movl %eax, " + to_string($1->offset) + "(%ebp)" + ln;
				$$->code += tab + "addl $" + "4, %esp" + ln;
				stackPointer+= 4;; 
	};

relational_expression:
		additive_expression {
				$$ = $1;
		}
	| relational_expression OP_LT additive_expression {
				if($1->type == TypeClass("int") && $3->type==TypeClass("int")){
					$$ = new op_binary_astnode("LT_OP_INT", $1, $3);
					$$->type = TypeClass("int");
				}
				else if($1->type == TypeClass("float") && $3->type==TypeClass("float")){
					$$ = new op_binary_astnode("LT_OP_FLOAT", $1, $3);
					$$->type = TypeClass("int");
				}
				else if($1->type == TypeClass("int") && $3->type==TypeClass("float")){
					$1 = new op_unary_astnode("TO_FLOAT", $1);
					$$ = new op_binary_astnode("LT_OP_FLOAT", $1, $3);
					$$->type = TypeClass("int");
				}
				else if($1->type == TypeClass("float") && $3->type==TypeClass("int")){
					$3 = new op_unary_astnode("TO_FLOAT", $3);
					$$ = new op_binary_astnode("LT_OP_FLOAT", $1, $3);
					$$->type = TypeClass("int");
				}
				else if($1->type == $3->type){
					$$ = new op_binary_astnode("LT_OP_INT", $1, $3);
					$$->type = TypeClass("int");
				}
				else if(arrayPointer($1->type, $3->type)){
					$$ = new op_binary_astnode("LT_OP_INT", $1, $3);
					$$->type = TypeClass("int");
				}
				else{
					error(@$, "Invalid operand types for binary < ,\"" +  $1->type.getPrintString() + "\" and \"" + $3->type.getPrintString() + "\"");
					exit(1);
				}

				$$->offset = $1->offset;
				$$->size = $1->size;
				$$->code += tab + "movl " + to_string($1->offset) + "(%ebp), %eax" + ln;
				$$->code += tab + "cmpl " + to_string($3->offset) + "(%ebp), %eax" + ln;
				$$->code += tab + "setl %al" + ln;
				$$->code += tab + "movzbl %al, %eax" + ln;
				$$->code += tab + "movl %eax, " + to_string($1->offset) + "(%ebp)" + ln;
				$$->code += tab + "addl $" + "4, %esp" + ln;
				stackPointer+= 4;; 	
					
	}
	| relational_expression OP_GT additive_expression  {
				if($1->type == TypeClass("int") && $3->type==TypeClass("int")){
					$$ = new op_binary_astnode("GT_OP_INT", $1, $3);
					$$->type = TypeClass("int");
				}
				else if($1->type == TypeClass("float") && $3->type==TypeClass("float")){
					$$ = new op_binary_astnode("GT_OP_FLOAT", $1, $3);
					$$->type = TypeClass("int");
				}
				else if($1->type == TypeClass("int") && $3->type==TypeClass("float")){
					$1 = new op_unary_astnode("TO_FLOAT", $1);
					$$ = new op_binary_astnode("GT_OP_FLOAT", $1, $3);
					$$->type = TypeClass("int");
				}
				else if($1->type == TypeClass("float") && $3->type==TypeClass("int")){
					$3 = new op_unary_astnode("TO_FLOAT", $3);
					$$ = new op_binary_astnode("GT_OP_FLOAT", $1, $3);
					$$->type = TypeClass("int");
				}
				else if($1->type == $3->type){
					$$ = new op_binary_astnode("GT_OP_INT", $1, $3);
					$$->type = TypeClass("int");
				}
				else if(arrayPointer($1->type, $3->type)){
					$$ = new op_binary_astnode("GT_OP_INT", $1, $3);
					$$->type = TypeClass("int");
				}
				else{
					error(@$, "Invalid operand types for binary > ,\"" +  $1->type.getPrintString() + "\" and \"" + $3->type.getPrintString() + "\"");
					exit(1);
				}
				$$->offset = $1->offset;
				$$->size = $1->size;
				$$->code += tab + "movl " + to_string($1->offset) + "(%ebp), %eax" + ln;
				$$->code += tab + "cmpl " + to_string($3->offset) + "(%ebp), %eax" + ln;
				$$->code += tab + "setg %al" + ln;
				$$->code += tab + "movzbl %al, %eax" + ln;
				$$->code += tab + "movl %eax, " + to_string($1->offset) + "(%ebp)" + ln;
				$$->code += tab + "addl $" + "4, %esp" + ln;
				stackPointer+= 4;; 
					
	}
	| relational_expression OP_LTE additive_expression {
				if($1->type == TypeClass("int") && $3->type==TypeClass("int")){
					$$ = new op_binary_astnode("LE_OP_INT", $1, $3);
					$$->type = TypeClass("int");
				}
				else if($1->type == TypeClass("float") && $3->type==TypeClass("float")){
					$$ = new op_binary_astnode("LE_OP_FLOAT", $1, $3);
					$$->type = TypeClass("int");
				}
				else if($1->type == TypeClass("int") && $3->type==TypeClass("float")){
					$1 = new op_unary_astnode("TO_FLOAT", $1);
					$$ = new op_binary_astnode("LE_OP_FLOAT", $1, $3);
					$$->type = TypeClass("int");
				}
				else if($1->type == TypeClass("float") && $3->type==TypeClass("int")){
					$3 = new op_unary_astnode("TO_FLOAT", $3);
					$$ = new op_binary_astnode("LE_OP_FLOAT", $1, $3);
					$$->type = TypeClass("int");
				}
				else if($1->type == $3->type){
					$$ = new op_binary_astnode("LE_OP_INT", $1, $3);
					$$->type = TypeClass("int");
				}
				else if(arrayPointer($1->type, $3->type)){
					$$ = new op_binary_astnode("LE_OP_INT", $1, $3);
					$$->type = TypeClass("int");
				}
				else{
					error(@$, "Invalid operand types for binary <= ,\"" +  $1->type.getPrintString() + "\" and \"" + $3->type.getPrintString() + "\"");
					exit(1);
				}

				$$->offset = $1->offset;
				$$->size = $1->size;
				$$->code += tab + "movl " + to_string($1->offset) + "(%ebp), %eax" + ln;
				$$->code += tab + "cmpl " + to_string($3->offset) + "(%ebp), %eax" + ln;
				$$->code += tab + "setle %al" + ln;
				$$->code += tab + "movzbl %al, %eax" + ln;
				$$->code += tab + "movl %eax, " + to_string($1->offset) + "(%ebp)" + ln;
				$$->code += tab + "addl $" + "4, %esp" + ln;
				stackPointer+= 4;; 
				
	} 
	| relational_expression OP_GTE additive_expression {
				if($1->type == TypeClass("int") && $3->type==TypeClass("int")){
					$$ = new op_binary_astnode("GE_OP_INT", $1, $3);
					$$->type = TypeClass("int");
				}
				else if($1->type == TypeClass("float") && $3->type==TypeClass("float")){
					$$ = new op_binary_astnode("GE_OP_FLOAT", $1, $3);
					$$->type = TypeClass("int");
				}
				else if($1->type == TypeClass("int") && $3->type==TypeClass("float")){
					$1 = new op_unary_astnode("TO_FLOAT", $1);
					$$ = new op_binary_astnode("GE_OP_FLOAT", $1, $3);
					$$->type = TypeClass("int");
				}
				else if($1->type == TypeClass("float") && $3->type==TypeClass("int")){
					$3 = new op_unary_astnode("TO_FLOAT", $3);
					$$ = new op_binary_astnode("GE_OP_FLOAT", $1, $3);
					$$->type = TypeClass("int");
				}
				else if($1->type == $3->type){
					$$ = new op_binary_astnode("GE_OP_INT", $1, $3);
					$$->type = TypeClass("int");
				}
				else if(arrayPointer($1->type, $3->type)){
					$$ = new op_binary_astnode("GE_OP_INT", $1, $3);
					$$->type = TypeClass("int");
				}
				else{
					error(@$, "Invalid operand types for binary >= ,\"" +  $1->type.getPrintString() + "\" and \"" + $3->type.getPrintString() + "\"");
					exit(1);
				}

				$$->offset = $1->offset;
				$$->size = $1->size;
				$$->code += tab + "movl " + to_string($1->offset) + "(%ebp), %eax" + ln;
				$$->code += tab + "cmpl " + to_string($3->offset) + "(%ebp), %eax" + ln;
				$$->code += tab + "setge %al" + ln;
				$$->code += tab + "movzbl %al, %eax" + ln;
				$$->code += tab + "movl %eax, " + to_string($1->offset) + "(%ebp)" + ln;
				$$->code += tab + "addl $" + "4, %esp" + ln;
				stackPointer+= 4;; 
	};

additive_expression:
		multiplicative_expression {
					$$ = $1;
		}
	| additive_expression OP_ADD multiplicative_expression {


				if($1->type == TypeClass("int") && $3->type==TypeClass("int")){
					$$ = new op_binary_astnode("PLUS_INT", $1, $3);
					$$->type = TypeClass("int");
				}
				else if($1->type == TypeClass("float") && $3->type==TypeClass("float")){
					$$ = new op_binary_astnode("PLUS_FLOAT", $1, $3);
					$$->type = TypeClass("float");
				}
				else if($1->type == TypeClass("int") && $3->type==TypeClass("float")){
					$1 = new op_unary_astnode("TO_FLOAT", $1);
					$$ = new op_binary_astnode("PLUS_FLOAT", $1, $3);
					$$->type = TypeClass("float");
				}
				else if($1->type == TypeClass("float") && $3->type==TypeClass("int")){
					$3 = new op_unary_astnode("TO_FLOAT", $3);
					$$ = new op_binary_astnode("PLUS_FLOAT", $1, $3);
					$$->type = TypeClass("float");
				}
				else if($1->type.isSubscriptable() && $3->type == TypeClass("int")){
					$$ = new op_binary_astnode("PLUS_INT", $1, $3);
					$$->type = $1->type;
				}
				else if($3->type.isSubscriptable() && $1->type == TypeClass("int")){
					$$ = new op_binary_astnode("PLUS_INT", $1, $3);
					$$->type = $3->type;
				}
				else if(! $1->type.isStruct() && $1->type == $3->type){
					$$ = new op_binary_astnode("PLUS_INT", $1, $3);
					$$->type = TypeClass("int");
				}
				else if(arrayPointer($1->type, $3->type)){
					$$ = new op_binary_astnode("PLUS_INT", $1, $3);
					$$->type = TypeClass("int");
				}
				else{
					error(@$, "Invalid operand types for binary + ,\"" +  $1->type.getPrintString() + "\" and \"" + $3->type.getPrintString() + "\"");
					exit(1);
				}

				if($$->type.isSubscriptable()){

					if($1->type.isSubscriptable()){
					$$->offset = $1->offset;
					$$->size = $1->size;
					$$->code += tab + "movl " + to_string($3->offset) + "(%ebp), %eax" + ln;
					$$->code += tab + "imull $" + "4, %eax" + ln; 
					$$->code += tab + "addl %eax, " + to_string($1->offset) + "(%ebp)" + ln;
					$$->code += tab + "addl $" + to_string($3->size) + ", %esp" + ln; 
					stackPointer += 4; 
					}
					else{
						$$->offset = $1->offset;
						$$->size = $1->size;
						$$->code += tab + "movl " + to_string($1->offset) + "(%ebp), %eax" + ln;
						$$->code += tab + "imull $" + "4, %eax" + ln; 
						$$->code += tab + "addl %eax, " + to_string($3->offset) + "(%ebp)" + ln;
						$$->code += tab + "movl " + to_string($3->offset) + "(%ebp), %eax" +ln;
						$$->code += tab + "movl %eax, " + to_string($1->offset) + "(%ebp)" + ln;
						$$->code += tab + "addl $" + to_string($3->size) + ", %esp" + ln; 
						stackPointer += 4; 
					}
				}
				else{
					$$->offset = $1->offset;
					$$->size = $1->size;
					$$->code += tab + "movl " + to_string($3->offset) + "(%ebp), %eax" + ln;
					$$->code += tab + "addl %eax, " + to_string($1->offset) + "(%ebp)" + ln;
					$$->code += tab + "addl $" + to_string($3->size) + ", %esp" + ln; 
					stackPointer += 4; 
				}
				
	}
	| additive_expression OP_SUB multiplicative_expression {


				if($1->type == TypeClass("int") && $3->type==TypeClass("int")){
					$$ = new op_binary_astnode("MINUS_INT", $1, $3);
					$$->type = TypeClass("int");
				}
				else if($1->type == TypeClass("float") && $3->type==TypeClass("float")){
					$$ = new op_binary_astnode("MINUS_FLOAT", $1, $3);
					$$->type = TypeClass("float");
				}
				else if($1->type == TypeClass("int") && $3->type==TypeClass("float")){
					$1 = new op_unary_astnode("TO_FLOAT", $1);
					$$ = new op_binary_astnode("MINUS_FLOAT", $1, $3);
					$$->type = TypeClass("float");
				}
				else if($1->type == TypeClass("float") && $3->type==TypeClass("int")){
					$3 = new op_unary_astnode("TO_FLOAT", $3);
					$$ = new op_binary_astnode("MINUS_FLOAT", $1, $3);
					$$->type = TypeClass("float");
				}
				else if($1->type.isSubscriptable() && $3->type == TypeClass("int")){
					$$ = new op_binary_astnode("MINUS_INT", $1, $3);
					$$->type = $1->type;
				}
				else if(! $1->type.isStruct() && $1->type == $3->type){
					$$ = new op_binary_astnode("MINUS_INT", $1, $3);
					$$->type = TypeClass("int");
				}
				else if(arrayPointer($1->type, $3->type)){
					$$ = new op_binary_astnode("MINUS_INT", $1, $3);
					$$->type = TypeClass("int");
				}
				else{
					error(@$, "Invalid operand types for binary -,\"" + $1->type.getPrintString() + "\" and \"" + $3->type.getPrintString() + "\"");
					exit(1);
				}
				if($$->type.isSubscriptable()){
						$$->offset = $1->offset;
						$$->size = $1->size;
						$$->code += tab + "movl " + to_string($3->offset) + "(%ebp), %eax" + ln;
						$$->code += tab + "imull $" + "4, %eax" + ln; 
						$$->code += tab + "subl %eax, " + to_string($1->offset) + "(%ebp)" + ln;
						$$->code += tab + "addl $" + to_string($3->size) + ", %esp" + ln; 
						stackPointer += 4; 
				}
				else{
					$$->offset = $1->offset;
					$$->size = $1->size;
					$$->code += tab + "movl " + to_string($3->offset) + "(%ebp), %eax" + ln;
					$$->code += tab + "subl %eax, " + to_string($1->offset) + "(%ebp)" + ln;
					$$->code += tab + "addl $" + to_string($3->size) + ", %esp" + ln; 
					stackPointer += 4; 
				}

	};

multiplicative_expression:
unary_expression  {
				$$ = $1;

				if($$->type.arr.size() > 0){
					$$->code += tab + "# STORE ADDRESS" + ln;
					$$->code += tab + "leal " + to_string($1->offset) + "(%ebp), %eax" + ln;
					if($1->needDeref){
						$$->code += tab + "movl (%eax), %eax" + ln;
					}
					$$->code += tab + "subl $" + "4, %esp" + ln;
					$$->code += tab + "movl %eax, " + to_string(stackPointer) + "(%ebp)" + ln;
					$$->offset = stackPointer;
					$$->size = 4;
					stackPointer += -4;
				}
				else if($1->constant == false){
					$$->size = $1->size;
					$$->constant = true;
					if($1->isAddress){
						$$->code += tab + "# Getting the address [NOT MULTIPLYING]" + ln;
						$$->code += tab +"subl $" + to_string($$->size) + ", %esp" + ln;
						$$->code += tab +"movl " + to_string($$->offset) + "(%ebp), %eax" + ln;
						for(int i = 0; i < $1->addressOffset.size() - 1; i++){
							$$->code += tab +"movl " + to_string($1->addressOffset[i]) + "(%eax), %eax" + ln;
						}
						$$->code += tab + "leal " +  to_string($1->addressOffset[$$->addressOffset.size() - 1]) + "(%eax), %eax" + ln;
						for(int i = 0; i < $1->size / 4; i ++){
							$$->code += tab +"movl " + to_string(4*i) + "(%eax), %edx" + ln;
							$$->code += tab +"movl %edx, " + to_string(stackPointer - $1->size + 4 + 4*i) + "(%ebp)" + ln;
						}
						$$->offset = stackPointer;
						stackPointer -= $$->size;
					}
					
					else{
						$$->code += tab + "# new place here " + to_string(stackPointer) + ln;
						$$->code += tab +"subl $" + to_string($$->size) + ", %esp" + ln;
						for(int i = 0; i < $1->size / 4; i ++){
							$$->code += tab +"movl " + to_string($$->offset +4*i) + "(%ebp), %eax" + ln;
							$$->code += tab +"movl %eax, " + to_string(stackPointer - $1->size + 4 + 4*i) + "(%ebp)" + ln;
						}
						$$->offset = stackPointer;
						stackPointer -= $$->size;
					}
				}
				else if($1->needDeref){
						$$->code += tab + "#DEREFERENCING" + ln;
						$$->code += tab + "movl " + to_string($1->offset) + "(%ebp), %eax" + ln;
						$$->code += tab + "movl (%eax), %eax" + ln;
						$$->code += tab + "movl %eax, " + to_string($1->offset) + "(%ebp)" + ln;
						$$->offset = $1->offset;
				}
	}
	| multiplicative_expression OP_MUL unary_expression {
 

				if($1->type == TypeClass("int") && $3->type==TypeClass("int")){
					$$ = new op_binary_astnode("MULT_INT", $1, $3);
					$$->type = TypeClass("int");
				}
				else if($1->type == TypeClass("float") && $3->type==TypeClass("float")){
					$$ = new op_binary_astnode("MULT_FLOAT", $1, $3);
					$$->type = TypeClass("float");
				}
				else if($1->type == TypeClass("int") && $3->type==TypeClass("float")){
					$1 = new op_unary_astnode("TO_FLOAT", $1);
					$$ = new op_binary_astnode("MULT_FLOAT", $1, $3);
					$$->type = TypeClass("float");
				}
				else if($1->type == TypeClass("float") && $3->type==TypeClass("int")){
					$3 = new op_unary_astnode("TO_FLOAT", $3);
					$$ = new op_binary_astnode("MULT_FLOAT", $1, $3);
					$$->type = TypeClass("float");
				}
				else{
					error(@$, "Invalid operand types for binary *,\"" + $1->type.getPrintString() + "\" and \"" + $3->type.getPrintString() + "\"");
					exit(1);
				}
				$$->offset = $1->offset;
				$$->size = $1->size;

				if($3->constant == false){
					if($3->isAddress){
						$$->code += tab + "# Getting the address" + ln;
						$$->code += tab +"subl $" + to_string($$->size) + ", %esp" + ln;
						$$->code += tab +"movl " + to_string($3->offset) + "(%ebp), %eax" + ln;
						for(int i = 0; i < $3->addressOffset.size() - 1; i++){
							$$->code += tab +"movl " + to_string($3->addressOffset[i]) + "(%eax), %eax" + ln;
						}
						$$->code += tab + "leal " +  to_string($3->addressOffset[$3->addressOffset.size() - 1]) + "(%eax), %eax" + ln;
						for(int i = 0; i < $3->size / 4; i ++){
							$$->code += tab +"movl " + to_string(4*i) + "(%eax), %edx" + ln;
							$$->code += tab +"movl %edx, " + to_string(stackPointer - $1->size + 4 + 4*i) + "(%ebp)" + ln;
						}
						$3->offset = stackPointer;
						stackPointer -= $$->size;
					}
					else{
						$$->code += tab + "# new place here" + ln;
						$$->code += tab +"subl $" + to_string($3->size) + ", %esp" + ln;
						$$->code += tab +"movl " + to_string($3->offset) + "(%ebp), %eax" + ln;
						$$->code += tab +"movl %eax, " + to_string(stackPointer) + "(%ebp)" + ln;
						$3->offset = stackPointer;
						stackPointer -= $$->size;
				}
				}else if($3->needDeref){
						$$->code += tab + "#DEREFERENCING" + ln;
						$$->code += tab + "movl " + to_string($3->offset) + "(%ebp), %eax" + ln;
						$$->code += tab + "movl (%eax), %eax" + ln;
						$$->code += tab + "movl %eax, " + to_string($3->offset) + "(%ebp)" + ln;
						$$->offset = $1->offset;
				}
					$$->code += tab + "movl " + to_string($1->offset) + "(%ebp), %eax" + ln;
					$$->code += tab + "imull " + to_string($3->offset) + "(%ebp), %eax" + ln;
					$$->code += tab + "movl %eax, " +to_string($1->offset) + "(%ebp)" + ln;
					$$->code += tab + "addl $" + to_string($3->size) + ", %esp" +ln; 
					stackPointer += 4;

		}
	| multiplicative_expression OP_DIV unary_expression  {



				if($1->type == TypeClass("int") && $3->type==TypeClass("int")){
					$$ = new op_binary_astnode("DIV_INT", $1, $3);
					$$->type = TypeClass("int");
				}
				else if($1->type == TypeClass("float") && $3->type==TypeClass("float")){
					$$ = new op_binary_astnode("DIV_FLOAT", $1, $3);
					$$->type = TypeClass("float");
				}
				else if($1->type == TypeClass("int") && $3->type==TypeClass("float")){
					$1 = new op_unary_astnode("TO_FLOAT", $1);
					$$ = new op_binary_astnode("DIV_FLOAT", $1, $3);
					$$->type = TypeClass("float");
				}
				else if($1->type == TypeClass("float") && $3->type==TypeClass("int")){
					$3 = new op_unary_astnode("TO_FLOAT", $3);
					$$ = new op_binary_astnode("DIV_FLOAT", $1, $3);
					$$->type = TypeClass("float");
				}
				else{
					error(@$, "Invalid operand types for binary / ,\""+  $1->type.getPrintString() + "\" and \"" + $3->type.getPrintString() + "\"");
					exit(1);
				}
				$$->offset = $1->offset;
				$$->size = $1->size;	

				if($3->constant == false){
					if($3->isAddress){
						$$->code += tab + "# Getting the address" + ln;
						$$->code += tab +"subl $" + to_string($$->size) + ", %esp" + ln;
						$$->code += tab +"leal " + to_string($3->offset) + "(%ebp), %eax" + ln;
						for(int i = 0; i < $3->addressOffset.size() - 1; i++){
							$$->code += tab +"movl " + to_string($3->addressOffset[i]) + "(%eax), %eax" + ln;
						}
						$$->code += tab + "movl " +  to_string($3->addressOffset[$3->addressOffset.size() - 1]) + "(%eax), %eax" + ln;
						for(int i = 0; i < $3->size / 4; i ++){
							$$->code += tab +"movl " + to_string(4*i) + "(%eax), %edx" + ln;
							$$->code += tab +"movl %edx, " + to_string(stackPointer - $1->size + 4 + 4*i) + "(%ebp)" + ln;
						}
						$3->offset = stackPointer;
						stackPointer -= $$->size;
					}
					else{
						$$->code += tab + "# new place here" + ln;
						$$->code += tab +"subl $" + to_string($3->size) + ", %esp" + ln;
						$$->code += tab +"movl " + to_string($3->offset) + "(%ebp), %eax" + ln;
						$$->code += tab +"movl %eax, " + to_string(stackPointer) + "(%ebp)" + ln;
						$3->offset = stackPointer;
						stackPointer -= $$->size;
				}
				}else if($3->needDeref){
						$$->code += tab + "#DEREFERENCING" + ln;
						$$->code += tab + "movl " + to_string($3->offset) + "(%ebp), %eax" + ln;
						$$->code += tab + "movl (%eax), %eax" + ln;
						$$->code += tab + "movl %eax, " + to_string($3->offset) + "(%ebp)" + ln;
						$$->offset = $1->offset;
				}

				$$->code += tab+ "movl " + to_string($1->offset) + "(%ebp), " + "%eax" + ln;
				$$->code += tab +"cltd"  ln;
				$$->code += tab +"idivl " + to_string($3->offset) + "(%ebp)" + ln;
				$$->code += tab +"movl %eax, " + to_string($1->offset) + "(%ebp)" + ln;
				$$->code += tab + "addl $" + to_string($3->size) + ", %esp" +ln; 
				stackPointer += 4; 

	};

unary_expression:
		postfix_expression {
				$$ = $1;
		}
	| unary_operator unary_expression {
				$$ = new op_unary_astnode($1, $2);
				if($1 == "UMINUS"){
					if($2->type != TypeClass("int") && $2->type != TypeClass("float")){
						error(@$, "Operand of unary - should be an int or float");
						exit(1);
					}
					$$->type = $2->type;
					$$->size = $2->size;
					$$->offset = $2->offset;

					if($2->constant == false){
						$$->code += tab + "# new place here" + ln;
						$$->code += tab +"subl $" + to_string($2->size) + ", %esp" + ln;
						$$->code += tab +"movl " + to_string($2->offset) + "(%ebp), %eax" + ln;
						$$->code += tab +"movl %eax, " + to_string(stackPointer) + "(%ebp)" + ln;
						$$->offset = stackPointer;
						$$->size = $2->size;
						$$->constant = true;
						stackPointer -= $$->size;
					}

					$$->code += tab + "# negative unary operator" + ln;
					$$->code += tab + "movl " + to_string($$->offset) + "(%ebp), %eax" + ln;
					$$->code += tab + "negl %eax"+ln;
					$$->code += tab + "movl %eax, " + to_string($$->offset) + "(%ebp)" + ln;
					$$->constant = true;

				}
				else if($1 == "NOT"){
					$$->type = TypeClass("int");

					$$->size = $2->size;
					$$->offset = $2->offset;

					if($2->constant == false){
						$$->code += tab + "# new place here" + ln;
						$$->code += tab +"subl $" + to_string($2->size) + ", %esp" + ln;
						$$->code += tab +"movl " + to_string($2->offset) + "(%ebp), %eax" + ln;
						$$->code += tab +"movl %eax, " + to_string(stackPointer) + "(%ebp)" + ln;
						$$->offset = stackPointer;
						$$->size = $2->size;
						$$->constant = true;
						stackPointer -= $$->size;
					}

					$$->code += tab + "# NOT INSTRUCTION " + ln;
					$$->code += tab + "cmpl $" + "0, " + to_string($$->offset) + "(%ebp)" + ln;
					$$->code += tab + "sete %al" + ln;
					$$->code += tab + "movzbl %al, %eax" + ln;
					$$->code += tab + "movl %eax, " + to_string($$->offset) + "(%ebp)" + ln;



				}
				else if($1 == "ADDRESS"){
					$$->type =	$2->type.address();

					$$->offset = stackPointer;
					$$->size = 4;
					$$->code = tab + "subl $" + "4, %esp" + ln;
					$$->code += tab + "leal " + to_string($2->offset) + "(%ebp), %eax" + ln;
					if($2->needDeref){
						$$->code += tab + "movl (%eax), %eax" + ln;
					}

					if($2->constant){
						$$->code += tab + "addl $" + "4, %esp" + ln;
						stackPointer += 4;
					}
					$$->code += tab + "movl %eax, " + to_string($$->offset) + "(%ebp)" + ln;
					stackPointer += -4;
					$$->constant = true;
				}
				else if($1 == "DEREF"){
					if(! $2->type.isDereferencable()){
						error(@$, "Invalid operand type \"" + $2->type.getPrintString() + "\" of unary *");
						exit(1);
					}
					$$->type = $2->type.derefType();

					$$->offset = $2->offset;
					$$->size = $2->size;

					$$->isAddress = true;
					$$->addressOffset = $2->addressOffset;
					$$->addressOffset.push_back(0);
				}

	}; 
	



postfix_expression: 
		primary_expression {
				$$ = $1;
		}
		| postfix_expression OP_INC {

					$$ = new op_unary_astnode("PP", $1);
					$$->type = $1->type;
					$$->lval = false;
					if($1->type == TypeClass("NullType")){
						error(@$, "Operand of \"++\" should have lvalue");
						exit(1);
					}

					$$->size = $1->size;
					$$->offset = $1->offset;

					$$->code += tab + "subl $" + "4, %esp" + ln;
					$$->code += tab + "movl " + to_string($1->offset) + "(%ebp), %eax" + ln;
					if($1->needDeref){
						$$->code += tab + "movl (%eax), %eax" + ln;
					}
					$$->code += tab + "movl %eax, " + to_string(stackPointer) + "(%ebp)" + ln; 
					$$->code += tab + "addl $"+ "1, " + to_string($$->offset) + "(%ebp)" + ln;
					$$->offset = stackPointer;
					stackPointer += -4;

		}
		|IDENTIFIER LRB RRB {
				vector<exp_astnode*> v;
				identifier_astnode* t = new identifier_astnode($1);
				$$ = new funcallexp_astnode(t, v);
				if(glbsymtab->getEntity($1) != NULL){
					$$->type = glbsymtab->getEntity($1)->type;
				}
				else{
					error(@$, "Function \"" +$1 +"\" not declared");
					exit(1);
				}

				if(glbsymtab->getEntity($1)->getParamNumber() > 0){
					error(@$, "Function \"" + $1 + "\"  called with too few arguments");
					exit(1);
				}
				$$->lval = false;

				

				
				$$->code = tab + "call " + $1 + ln;
				$$->offset = stackPointer;
				$$->size = $$->type.getSize();
				if($$->type.isStruct()){
					$$->code += tab + "subl $" + to_string($$->type.getSize()) + ", %esp" + ln;

					for(int i = 0; i < $$->size / 4; i++){
							$$->code += tab + "movl " + to_string(-4*i) +  "(%eax), %edx"  + ln;
							$$->code += tab + "movl %edx, " + to_string(stackPointer - i*4)+ "(%ebp)" + ln;
					}
				}
				else{
					$$->code += tab + "subl $" + "4, %esp" + ln;
					$$->code += tab + "movl %eax, " + to_string(stackPointer) + "(%ebp)" + ln;
				}
				


				stackPointer -= $$->type.getSize();
				$$->constant = true;				
	}
		
	| IDENTIFIER LRB expression_list RRB {
				identifier_astnode* t = new identifier_astnode($1);

				if(glbsymtab->getEntity($1) != NULL){

					if(glbsymtab->getEntity($1)->getParamNumber() > $3.size()){
						error(@$, "Function \"" + $1 + "\"  called with too few arguments");
						exit(1);
					}
					if(glbsymtab->getEntity($1)->getParamNumber() < $3.size()){
						error(@$, "Function \"" + $1 + "\"  called with too many arguments");
						exit(1);
					}
					std::vector<TypeClass> parameters = glbsymtab->getEntity($1)->getParamTypes();
					for(int i = 0; i < $3.size(); i++){
						// std::cout << $3[i]->type.getPrintString() << " " << parameters[i].getPrintString() << std::endl;
						if($3[i]->type == TypeClass("int") && parameters[i] == TypeClass("float")){
							$3[i] = new op_unary_astnode("TO_FLOAT", $3[i]);
						}
						else if($3[i]->type == TypeClass("float") && parameters[i] == TypeClass("int")){
							$3[i] = new op_unary_astnode("TO_INT", $3[i]);
						}
						else if(arrayPointer($3[i]->type, parameters[i])){

						}
						else if($3[i]->type.type == "void" && $3[i]->type.isPointer() && parameters[i].isSubscriptable()){

								}
								else if(parameters[i].type == "void" && parameters[i].isPointer() && $3[i]->type.isSubscriptable()){
									
								}
						else{
							error(@$, "Expected \"" + parameters[i].getPrintString() +  "\" but argument is of type \"" + $3[i]->type.getPrintString() + "\"");
							exit(1);
						}
					}
					$$ = new funcallexp_astnode(t, $3);
					$$->type = glbsymtab->getEntity($1)->type;


					$$->size = $$->type.getSize();
					$$->code = tab + "call " + $1 + ln;

					int totalSize = 0;
					for (int i = 0; i < $3.size(); i++){
						totalSize += $3[i]->size;
					}	
					$$->code += tab + "addl $" + to_string( totalSize ) + ", %esp" + ln; 
					for(int i = 0; i < $3.size();i ++){
						stackPointer += $3[i]->size;
					}	

					
					if($$->type.isStruct()){
						$$->code += tab + "subl $" + to_string($$->type.getSize()) + ", %esp" + ln;

						for(int i = 0; i < $$->type.getSize() / 4; i++){
							$$->code += tab + "movl " + to_string(-4*i) +  "(%eax), %edx"  + ln;
							$$->code += tab + "movl %edx, " + to_string(stackPointer - i*4)+ "(%ebp)" + ln;
						}
					}
					else{
						$$->code += tab + "subl $" + "4, %esp" + ln;
						$$->code += tab + "movl %eax, " + to_string(stackPointer) + "(%ebp)" + ln;
					}
					$$->offset = stackPointer;
					stackPointer -= $$->type.getSize();
					$$->constant = true;

				}
				else{
					
					if(predefined.find($1) == predefined.end()){
						error(@$, "Function \"" +$1 +"\" not declared");
						exit(1);
					}

					$$ = new funcallexp_astnode(t, $3);
					$$->type = predefined[$1];
				}
				

				$$->lval = false;


	} 
	| postfix_expression OP_MEM IDENTIFIER {
					identifier_astnode* t = new identifier_astnode($3);
					$$ = new member_astnode($1, t);
					if(! $1->type.isStruct()){
						error(@$, "Left operand of \".\"  is not a structure");
						exit(1);
					}
					if(! glbsymtab->getEntity($1->type.type)->structContains($3)){
						error(@$, "Struct \"" + $1->type.type + "\" has no member named \"" + $3 + "\"");
						exit(1);
					}
					$$->type =  glbsymtab->getEntity($1->type.type)->st->getEntity($3)->type;
					$$->lval = true;

					int off = glbsymtab->getEntity($1->type.type)->st->getOffsetStruct($3);
					$$->code = tab + "leal " + to_string($1->offset) + "(%ebp), %eax" + ln;
					if($1->needDeref){
						$$->code += tab + "movl (%eax), %eax" + ln;
					}
					$$->code += tab + "addl $" + to_string(off) + ", %eax" + ln;
					$$->code += tab + "subl $" + "4, %esp" + ln;
					$$->code += tab + "movl %eax, " + to_string(stackPointer) + "(%ebp)" + ln;

					$$->offset = stackPointer;
					// $$->code = tab + "#" + $3 + " " + to_string($1->offset) + " " + to_string(off) + ln;
					$$->needDeref = true;
					$$->constant = true;
					stackPointer += -4;
					$$->size = glbsymtab->getEntity($1->type.type)->st->getEntity($3)->size;
	}
	| postfix_expression OP_PTR IDENTIFIER {
					identifier_astnode* t = new identifier_astnode($3);
					$$ = new arrow_astnode($1, t);
					if(! $1->type.isPointerStruct()){
						error(@$, "Left operand of \"->\"  is not a pointer to structure");
						exit(1);
					}
					if(! glbsymtab->getEntity($1->type.type)->structContains($3)){
						error(@$, "Struct \"" + $1->type.type + "\" has no member named \"" + $3 + "\"");
						exit(1);
					}
					$$->type =  glbsymtab->getEntity($1->type.type)->st->getEntity($3)->type;
					$$->lval = true;
					$$->offset = stackPointer;
					int off = glbsymtab->getEntity($1->type.index().type)->st->getOffsetStruct($3);

					$$->code += tab + "movl " + to_string($1->offset) + "(%ebp), %eax" +ln;
					// if($1->needDeref){
					// 	$$->code += tab + "movl (%eax), %eax" + ln;
					// }
					if($1->constant){
						$$->code += tab + "addl $" + "4, %esp" + ln;
						stackPointer += 4;
					}
					$$->code += tab + "addl $" + to_string(off )+ ", %eax" + ln;
					$$->code += tab + "subl $" + "4, %esp" + ln;
					$$->code += tab + "movl %eax, " + to_string(stackPointer) + "(%ebp)" + ln;
					stackPointer += -4;
					$$->size = glbsymtab->getEntity($1->type.index().type)->st->getEntity($3)->size;
					$$->needDeref = true;
					$$->constant = true;
					// $$->isAddress = true;
					// $$->addressOffset = $1->addressOffset;
					// $$->addressOffset.push_back(off);
	}
	|postfix_expression LSB expression RSB {
				$$ = new arrayref_astnode($1, $3);
				if($3->type != TypeClass("int")){
					error(@$, "Array subscript is not an integer");
					exit(1);
				}
				if(! $1->type.isSubscriptable()){
					error(@$, "Subscripted value is neither array nor pointer");
					exit(1);
				}
				$$->type = $1->type.index();
				$$->lval = true;



				$$->size =  $1->type.index().getSize();
				$$->code += tab + "leal " + to_string($1->offset) + "(%ebp), %eax" +ln;
				if($1->needDeref){
					$$->code += tab + "movl (%eax), %eax" + ln;
				}
				if($1->constant){
					$$->code += tab + "addl $" + "4, %esp" + ln;
					stackPointer += 4;
				}
				$$->code += tab + "movl " + to_string($3->offset) + "(%ebp), %edx" + ln;
				$$->code += tab + "imull $" + to_string($$->size) + ", %edx" + ln;
				$$->code += tab + "addl %edx, %eax" + ln;
				// $$->code += tab + "subl $" + "4, %esp" + ln;
				$$->code += tab + "movl %eax, " + to_string(stackPointer + 4) + "(%ebp)" + ln;

				$$->offset = stackPointer + 4;
				$$->constant = true;
				$$->needDeref = true;
		};


primary_expression:
		IDENTIFIER  {
			$$ = new identifier_astnode($1);


			if(currentsymtab->getEntity($1) != NULL){
				$$->type = TypeClass(currentsymtab->getEntity($1)->type);
				$$->offset =  currentsymtab->getOffset($1);
				$$->size = currentsymtab->getEntity($1)->size;
				$$->constant = false;
				// cout << $1 << " " << $$->offset << endl;
				if(currentsymtab->getEntity($1)->scope == Parameter && $$->type.isSubscriptable()) $$->needDeref = true;
			}
			else{
				error(@$, "Variable \"" + $1 + "\" not declared");
				exit(1);
			}
			$$->lval = true;
		}
	| CONSTANT_INT {
			$$ = new intconst_astnode($1);
			$$->type = TypeClass("int");
			$$->lval = false;

			$$->code += tab + "subl $" + to_string(4) + ", %esp" + ln;
			$$->code += tab + "movl $" + $1 + ", " +  to_string(stackPointer) + "(%ebp)" + ln;
			$$->offset = stackPointer;
			$$->size = 4;
			$$->constant = true;
			$$->needDeref = false;
			stackPointer -= 4;

	}
	| LRB expression RRB  {
			$$ = $2;	
			$$->lval = false;
			$$->constant = true;
	};

unary_operator:
		OP_SUB {
				$$ = "UMINUS";
		}
		| OP_NOT {
					$$ = "NOT";
		}
		| OP_ADDR {
					$$ = "ADDRESS";
		}
		| OP_MUL {
					$$ = "DEREF";
		}
		;


selection_statement: 
		IF LRB expression {stackPointer += 4;} RRB statement ELSE statement {
				$$ = new if_astnode($3, $6, $8);

				$$->label = labelNum;
				labelNum += 2;
		};

iteration_statement: 
		WHILE LRB expression {stackPointer += 4;} RRB statement {
				$$ = new while_astnode($3, $6);

				$$->label = labelNum;
				labelNum += 2;

	}
	| FOR LRB assignment_expression EOS expression { stackPointer += 4; }EOS assignment_expression RRB statement {
			$$ = new for_astnode($3, $5, $8, $10);

				$$->label = labelNum;
				labelNum += 4;
	};

expression_list: 
	expression {
				vector<exp_astnode*> v = {$1};
				$$ = v;
		}
	| expression_list COMMA expression {
				vector<exp_astnode*> v = $1;
				v.push_back($3);
				$$ = v;
	};



procedure_call:
		IDENTIFIER LRB RRB EOS {
					vector<exp_astnode*> v;
					identifier_astnode* t = new identifier_astnode($1);
					$$ = new funcallstmt_astnode(t, v);
					if(glbsymtab->getEntity($1)){
						TypeClass t = glbsymtab->getEntity($1)->type;
					}
					else{
						error(@$, "Function \"" +$1 +"\" not declared");
						exit(1);
					}
					if(glbsymtab->getEntity($1)->getParamNumber() > 0){
						error(@$, "Function \"" + $1 + "\"  called with too few arguments");
						exit(1);
					}

					$$->code = tab + "call " + $1 + ln;

		}
		| IDENTIFIER LRB expression_list RRB EOS {
					identifier_astnode* t = new identifier_astnode($1);

					if(glbsymtab->getEntity($1) != NULL){
						TypeClass t = glbsymtab->getEntity($1)->type;

						if(glbsymtab->getEntity($1)->getParamNumber() > $3.size()){
							error(@$, "Function \"" + $1 + "\"  called with too few arguments");
							exit(1);
							}

						if(glbsymtab->getEntity($1)->getParamNumber() < $3.size()){
							error(@$, "Function \"" + $1 + "\"  called with too many arguments");
							exit(1);
						}
						
						std::vector<TypeClass> parameters = glbsymtab->getEntity($1)->getParamTypes();
						for(int i = 0; i < $3.size(); i++){
							if($3[i]->type != parameters[i]){
								if($3[i]->type == TypeClass("int") && parameters[i] == TypeClass("float")){
									$3[i] = new op_unary_astnode("TO_FLOAT", $3[i]);
								}
								else if($3[i]->type == TypeClass("float") && parameters[i] == TypeClass("int")){
									$3[i] = new op_unary_astnode("TO_INT", $3[i]);
								}
								else if(arrayPointer($3[i]->type, parameters[i])){

								}
								else if($3[i]->type.type == "void" && $3[i]->type.isPointer() && parameters[i].isSubscriptable()){

								}
								else if(parameters[i].type == "void" && parameters[i].isPointer() && $3[i]->type.isSubscriptable()){

								}
								else{
									error(@$, "Expected \"" + parameters[i].getPrintString() +  "\" but argument is of type \"" + $3[i]->type.getPrintString() + "\"");
									exit(1);
								}
							}
						}
						
					}
					else{
						// cout << "HELLO" << endl;
						if(predefined.find($1) == predefined.end()){
							error(@$, "Function \"" + $1 +"\" not declared");
							exit(1);
						}
						// cout << "BYE" << endl;
					}
					$$ = new funcallstmt_astnode(t, $3);

					$$->code = tab + "call " + $1 + ln;
					$$->code += tab + "addl $" + to_string( 4 * $3.size() ) + ", %esp" + ln; 
					stackPointer += 4 * ($3.size());		
	};

printf_call:
	PRINTF LRB CONSTANT_STR RRB EOS {
			strings[".LC" + to_string(numStrings)] = $3;
			identifier_astnode* name = new identifier_astnode($1);
			$$ = new printf_call(".LC" + to_string(numStrings), vector<exp_astnode*>());
			$$->code = tab + "call printf" + ln;
			$$->code += tab + "addl $" + "4, %esp" + ln;
			numStrings++;
	}

	| PRINTF LRB CONSTANT_STR COMMA expression_list RRB EOS {

			strings[".LC" + to_string(numStrings)] = $3;
			identifier_astnode* name = new identifier_astnode($1);
			$$ = new printf_call(".LC" + to_string(numStrings),$5);
			$$->code = tab + "call printf" + ln;
			$$->code += tab + "addl $" + to_string( 4 * ( 2 * ($5.size() + 1)  - 1 ) ) + ", %esp" + ln; 
			numStrings++;
			stackPointer += 4 * ($5.size());
	};





%%
void IPL::Parser::error( const location_type &l, const std::string &err_message )
{
	 std::cout << "Error at line " << l.begin.line << ": " << err_message << "\n";
}



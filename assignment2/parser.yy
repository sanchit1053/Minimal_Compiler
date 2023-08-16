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
%printer { std::cerr << $$; } IDENTIFIER 		
%printer { std::cerr << $$; } INT_CONSTANT	
%printer { std::cerr << $$; } FLOAT_CONSTANT	
%printer { std::cerr << $$; } STRING_LITERAL
%printer { std::cerr << $$; } INC_OP 		 	
%printer { std::cerr << $$; } AND_OP 		 	
%printer { std::cerr << $$; } OR_OP 		 	
%printer { std::cerr << $$; } EQ_OP 		 	
%printer { std::cerr << $$; } NE_OP 		 	
%printer { std::cerr << $$; } LE_OP 			
%printer { std::cerr << $$; } GE_OP 			
%printer { std::cerr << $$; } PTR_OP 			
%printer { std::cerr << $$; } OTHER


%parse-param { Scanner  &scanner  }
%locations
%code{
	 #include <iostream>
	 #include <cstdlib>
	 #include <fstream>
	 #include <string>
	 
	 
	 #include "scanner.hh"

	//  extern int glbsymbtab, localsymtab;
	extern symtab* glbsymtab ;
	extern std::map<std::string, abstract_astnode*> ast;
	extern symtab* currentsymtab;
	extern std::map<std::string, TypeClass> predefined;
	std::string currentFunction;
	TypeClass basetype, funBaseType;

#undef yylex
#define yylex IPL::Parser::scanner.yylex

}





%define api.value.type variant
%define parse.assert

%start translation_unit

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
%token <std::string> IDENTIFIER 		
%token <std::string> INT_CONSTANT	
%token <std::string> FLOAT_CONSTANT	
%token <std::string> STRING_LITERAL
%token <std::string> AND_OP 		 	
%token <std::string> INC_OP 		 	
%token <std::string> OR_OP 		 	
%token <std::string> EQ_OP 		 	
%token <std::string> NE_OP 		 	
%token <std::string> LE_OP 			
%token <std::string> GE_OP 			
%token <std::string> PTR_OP 			
%token <std::string> OTHER

%token ';' '{' '}' '(' ')' '[' ']' '+' '-' '*' '/' ',' '<' '>' '.' '!' '&' '='


%nterm <abstract_astnode*> translation_unit
%nterm <symtab*> struct_specifier
%nterm <seq_astnode*> function_definition
%nterm <TypeClass> type_specifier
%nterm <seq_astnode*> fun_declarator
%nterm <symtab*> parameter_list
%nterm <entity*> parameter_declaration
%nterm <seq_astnode*> compound_statement
%nterm <seq_astnode*> statement_list
%nterm <statement_astnode*> statement
%nterm <assignE_astnode*> assignment_expression
%nterm <assignS_astnode*> assignment_statement
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

%%
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
		 STRUCT IDENTIFIER '{' declaration_list '}' ';'  
		 {
			//  cout << "REACHED" << endl;
				entity* temp = new entity("struct "+$2, Struct, Global, TypeClass("NullType"), currentsymtab);
			//  cout << "REACHED1" << endl;
				temp->size = temp->getSize();
				glbsymtab->addEntity(temp);
			//  cout << "REACHED2" << endl;
		 };    

function_definition:  
		type_specifier {funBaseType = basetype;} fun_declarator compound_statement 
		{
			$$ = $4;
			// std::cout << "REACHED" << std::endl;
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
		| FLOAT {
			$$ = TypeClass("float");
			basetype = $$;
		}
		| STRUCT IDENTIFIER {
			$$ = TypeClass("struct " + $2 );
			basetype = $$;
		};

fun_declarator: 
		IDENTIFIER '(' parameter_list ')' {
				
				currentFunction = $1;
				// currentsymtab = new symtab();
		}
	| IDENTIFIER '(' ')' {
				currentFunction = $1;
				// currentsymtab = new symtab();
	};

parameter_list:
		parameter_declaration {
			currentsymtab->addEntity($1);
		}
		| parameter_list ',' parameter_declaration {
			currentsymtab->addEntity($3);
	};      

parameter_declaration:
		type_specifier declarator {
				basetype = $1;
				$$ = $2;
				$$->scope = Parameter;
		};

declarator_arr:
		IDENTIFIER {
			$$ = new entity($1, Variable, Local, basetype);
		}
		| declarator_arr '[' INT_CONSTANT ']' {
			$$ = $1;
			$$->addArray(stoi($3));
		};
		
declarator:
		declarator_arr {
			$$ = $1;
		}
	| '*' declarator {
		$$ = $2;
		$$->addDeref();
	};


compound_statement: 
		'{' '}' {
				statement_astnode* temp = new empty_astnode();
				std::vector<statement_astnode*> n;
				// n.push_back(temp);
				$$ = new seq_astnode(n);	
		}
	| '{' statement_list '}' {
				$$ = $2;
		}

	| '{' declaration_list '}' {
				statement_astnode* temp = new empty_astnode();
				std::vector<statement_astnode*> n;
				$$ = new seq_astnode(n);
	}
	| '{' declaration_list statement_list '}' {
				$$ = $3;
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
		';'  {
			$$ = new empty_astnode();
		}
		| '{' statement_list '}' {
				$$ = $2;
		}
		| selection_statement {
				$$ = $1;
		}
		| iteration_statement  {
				$$ = $1;
		}
		| assignment_statement  {
				$$ = $1;
		}
		| procedure_call {
				$$ = $1;
		}       
		| RETURN expression ';'  {
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
					error(@$, "Incompatible type \"" + $2->type.getPrintString() + "\" returned, expected \""  + basetype.getPrintString() +"\"");
					exit(1);
				}
		};

assignment_expression:
		 unary_expression '=' expression { 

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
		};
					

assignment_statement: 
		assignment_expression ';' {
					$$ = new assignS_astnode($1->first, $1->second);
		};

procedure_call:
		IDENTIFIER '(' ')' ';' {
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
		}
		| IDENTIFIER '(' expression_list ')' ';' {
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
	}

expression:
		logical_and_expression {
				$$ = $1;
		}
	| expression OR_OP logical_and_expression {
				if($1->type.isStruct() || $3->type.isStruct()){
					error(@$, "Invalid operand of ||,  not scalar or pointer");
					exit(1);
				}
				$$ = new op_binary_astnode("OR_OP", $1, $3);
				$$->type = TypeClass("int");
	};

logical_and_expression:
		equality_expression {
				$$ = $1;
		}
	| logical_and_expression AND_OP equality_expression {
				if($1->type.isStruct() || $3->type.isStruct()){
					error(@$, "Invalid operand of &&,  not scalar or pointer");
					exit(1);
				}
				$$ = new op_binary_astnode("AND_OP", $1, $3);
				$$->type = TypeClass("int");
		};

equality_expression :
		relational_expression {
				$$ = $1;
		}
	| equality_expression EQ_OP relational_expression {
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
				
	}
	| equality_expression NE_OP relational_expression {
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
				else if(arrayPointer($1->type, $3->type)){
					$$ = new op_binary_astnode("NE_OP_INT", $1, $3);
					$$->type = TypeClass("int");
				}
				else{
					error(@$, "Invalid operand types for binary != ,\"" +  $1->type.getPrintString() + "\" and \"" + $3->type.getPrintString() + "\"");
					exit(1);
				}
				
	};

relational_expression:
		additive_expression {
				$$ = $1;
		}
	| relational_expression '<' additive_expression {
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
					
	}
	| relational_expression '>' additive_expression  {
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
					
	}
	| relational_expression LE_OP additive_expression {
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
				
	} 
	| relational_expression GE_OP additive_expression {
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
	};

additive_expression:
		multiplicative_expression {
					$$ = $1;
		}
	| additive_expression '+' multiplicative_expression {
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
				
	}
	| additive_expression '-' multiplicative_expression {
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
				}
				else if($1 == "NOT"){
					$$->type = TypeClass("int");
				}
				else if($1 == "ADDRESS"){
					$$->type =	$2->type.address();
				}
				else if($1 == "DEREF"){
					if(! $2->type.isDereferencable()){
						error(@$, "Invalid operand type \"" + $2->type.getPrintString() + "\" of unary *");
						exit(1);
					}
					$$->type = $2->type.derefType();
				}

	}; 

multiplicative_expression:
unary_expression  {
				$$ = $1;
	}
	| multiplicative_expression '*' unary_expression {
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

		}
	| multiplicative_expression '/' unary_expression  {
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

	};
	


postfix_expression: 
		primary_expression {
				$$ = $1;
		}
		|postfix_expression '[' expression ']' {
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
		}
	| IDENTIFIER '(' ')' {
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
	}
	| IDENTIFIER '(' expression_list ')' {
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
	| postfix_expression '.' IDENTIFIER {
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

	}
	| postfix_expression PTR_OP IDENTIFIER {
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
	}
	| postfix_expression INC_OP {

					$$ = new op_unary_astnode("PP", $1);
					$$->type = $1->type;
					$$->lval = false;
					if($1->type == TypeClass("NullType")){
						error(@$, "Operand of \"++\" should have lvalue");
						exit(1);
					}
	};


primary_expression:
		IDENTIFIER  {
			$$ = new identifier_astnode($1);
			if(currentsymtab->getEntity($1) != NULL){
				$$->type = TypeClass(currentsymtab->getEntity($1)->type);
			}
			else{
				error(@$, "Variable \"" + $1 + "\" not declared");
				exit(1);
			}
			$$->lval = true;
		}
	| INT_CONSTANT {
			$$ = new intconst_astnode($1);
			$$->type = TypeClass("int");
			$$->lval = false;


	}
	| FLOAT_CONSTANT {
			$$ = new floatconst_astnode($1);	
			$$->type = TypeClass("float");
			$$->lval = false;
					
	} 
	| STRING_LITERAL {
			$$ = new stringconst_astnode($1);
			$$->type = TypeClass("string");
			$$->lval = false;
	}
	| '(' expression ')'  {
			$$ = $2;	
			$$->lval = false;
	};

expression_list: 
	expression {
				vector<exp_astnode*> v = {$1};
				$$ = v;
		}
	| expression_list ',' expression {
				vector<exp_astnode*> v = $1;
				v.push_back($3);
				$$ = v;
	};

unary_operator:
		'-' {
				$$ = "UMINUS";
		}
		| '!'  {
					$$ = "NOT";
		}
		| '&' {
					$$ = "ADDRESS";
		}
		| '*' {
					$$ = "DEREF";
		}
		;

selection_statement: 
		IF '(' expression ')' statement ELSE statement {
				$$ = new if_astnode($3, $5, $7);
		};

iteration_statement: 
		WHILE '(' expression ')' statement {
				$$ = new while_astnode($3, $5);

	}
	| FOR '(' assignment_expression ';' expression ';' assignment_expression ')' statement {
			$$ = new for_astnode($3, $5, $7, $9);
	};

declaration_list: 
		declaration {
			$$ = new symtab();
			// $$->addSymtab($1);
			currentsymtab->addSymtab($1);
					
		}
	| declaration_list declaration {
			// $1->addSymtab($2);
			$$ = $1;
			// $$->printSymTab();
			currentsymtab->addSymtab($2);
			// currentsymtab->printSymTab();
	};

declaration:
		type_specifier declarator_list';' {
			
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
	| declarator_list ',' declarator {
			$1->addEntity($3);
			$$ = $1;
	}; 

%%
void IPL::Parser::error( const location_type &l, const std::string &err_message )
{
	 std::cout << "Error at line " << l.begin.line << ": " << err_message << "\n";
}



%{
	#include "scanner.hh"
	#include "parser.tab.hh"

	#undef YY_DECL
	#define YY_DECL int IPL::Scanner::yylex(IPL::Parser::semantic_type* const lval, IPL::Parser::location_type *loc)

	#define YY_USER_ACTION loc->step(); loc->columns(yyleng);
	
	using token_type = IPL::Parser::token;
%}


%option nodefault
%option noyywrap
%option yyclass="Scanner"
%option c++

%%

%{
	yylval = lval;
%}


[ \r\t]|(\/\*(\*[^/]|[^*])*\*\/)																//skip;
[\n]																		{loc->lines();}
"void" 																		{ yylval->emplace<std::string>(YYText()); return token_type::VOID; }
"int" 																		{ yylval->emplace<std::string>(YYText()); return token_type::INT; }
"float" 																	{ yylval->emplace<std::string>(YYText()); return token_type::FLOAT; }
"string"																	{ yylval->emplace<std::string>(YYText()); return token_type::STRING; }
"struct" 																	{ yylval->emplace<std::string>(YYText()); return token_type::STRUCT; }
"if" 																		{ yylval->emplace<std::string>(YYText()); return token_type::IF; }
"else"																		{ yylval->emplace<std::string>(YYText()); return token_type::ELSE; }
"for"																		{ yylval->emplace<std::string>(YYText()); return token_type::FOR; }
"while"																		{ yylval->emplace<std::string>(YYText()); return token_type::WHILE; }
"return" 																	{ yylval->emplace<std::string>(YYText()); return token_type::RETURN; }
"main"																		{ yylval->emplace<std::string>(YYText()); return token_type::MAIN; }
"printf"																	{ yylval->emplace<std::string>(YYText()); return token_type::PRINTF; }
[a-zA-Z_][a-zA-Z_0-9]*														{ yylval->emplace<std::string>(YYText()); return token_type::IDENTIFIER; }
([1-9][0-9]*)|(0[bB][01]*)|(0[0-7]*)|([0][xX][0-9a-fA-F]*)				{ yylval->emplace<std::string>(YYText()); return token_type::CONSTANT_INT; }
([0-9]+[.][0-9]*)|([0-9]*[.][0-9]+)([eE][+-]?[0-9]*)?										{ yylval->emplace<std::string>(YYText()); return token_type::FLOAT_CONSTANT; }
["]([^"\\]|(\\.))*["]														{ yylval->emplace<std::string>(YYText()); return token_type::CONSTANT_STR; } 
";"																			{ yylval->emplace<std::string>(YYText()); return token_type::EOS; }
"{"																			{ yylval->emplace<std::string>(YYText()); return token_type::LCB; }
"}"																			{ yylval->emplace<std::string>(YYText()); return token_type::RCB; }
"("																			{ yylval->emplace<std::string>(YYText()); return token_type::LRB; }
")"																			{ yylval->emplace<std::string>(YYText()); return token_type::RRB; }
"["																			{ yylval->emplace<std::string>(YYText()); return token_type::LSB; }
"]"																			{ yylval->emplace<std::string>(YYText()); return token_type::RSB; }
"+"																			{ yylval->emplace<std::string>(YYText()); return token_type::OP_ADD; }
"-"																			{ yylval->emplace<std::string>(YYText()); return token_type::OP_SUB; }
"*"																			{ yylval->emplace<std::string>(YYText()); return token_type::OP_MUL; }
"/"																			{ yylval->emplace<std::string>(YYText()); return token_type::OP_DIV; }
"."																			{ yylval->emplace<std::string>(YYText()); return token_type::OP_MEM; }
","																			{ yylval->emplace<std::string>(YYText()); return token_type::COMMA; }
"++"																		{ yylval->emplace<std::string>(YYText()); return token_type::OP_INC; }
"&&"																		{ yylval->emplace<std::string>(YYText()); return token_type::OP_AND; }
"||"																		{ yylval->emplace<std::string>(YYText()); return token_type::OP_OR; }
"=="																		{ yylval->emplace<std::string>(YYText()); return token_type::OP_EQ; }
"!="																		{ yylval->emplace<std::string>(YYText()); return token_type::OP_NEQ; }
"<"																			{ yylval->emplace<std::string>(YYText()); return token_type::OP_LT; }
">"																			{ yylval->emplace<std::string>(YYText()); return token_type::OP_GT; }
"<="																		{ yylval->emplace<std::string>(YYText()); return token_type::OP_LTE; }
">="																		{ yylval->emplace<std::string>(YYText()); return token_type::OP_GTE; }
"->" 																		{ yylval->emplace<std::string>(YYText()); return token_type::OP_PTR; }
"!"																			{ yylval->emplace<std::string>(YYText()); return token_type::OP_NOT; }
"&"																			{ yylval->emplace<std::string>(YYText()); return token_type::OP_ADDR; }
"="																			{ yylval->emplace<std::string>(YYText()); return token_type::OP_ASSIGN; }
<<EOF>>																		yyterminate();
.																			{ yylval->emplace<std::string>(YYText()); return token_type::OTHER; }

%%

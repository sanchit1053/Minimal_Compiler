%{
	#include "scanner.hh"
	#include "parser.tab.hh"

	#undef YY_DECL
	#define YY_DECL int IPL::Scanner::yylex(IPL::Parser::semantic_type* const lval, IPL::Parser::location_type *location)

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


[ \r\n\t]|(\/\*(\*[^/]|[^*])*\*\/)																//skip;
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
[a-zA-Z_][a-zA-Z_0-9]*														{ yylval->emplace<std::string>(YYText()); return token_type::IDENTIFIER; }
([1-9][0-9]*)|(0[bB][01]*)|(0[0-7]*)|([0][xX][0-9a-fA-F]*)				{ yylval->emplace<std::string>(YYText()); return token_type::INT_CONSTANT; }
([0-9]+[.][0-9]*)|([0-9]*[.][0-9]+)([eE][+-]?[0-9]*)?										{ yylval->emplace<std::string>(YYText()); return token_type::FLOAT_CONSTANT; }
["]([^"\\]|(\\.))*["]														{ yylval->emplace<std::string>(YYText()); return token_type::STRING_LITERAL; } 
";"																			return ';';
"{"																			return '{';
"}"																			return '}';
"("																			return '(';
")"																			return ')';
"["																			return '[';
"]"																			return ']';
"+"																			return '+';
"-"																			return '-';
"*"																			return '*';
"/"																			return '/';
"."																			return '.';
","																			return ',';
"++"																		{ yylval->emplace<std::string>(YYText()); return token_type::INC_OP; }
"&&"																		{ yylval->emplace<std::string>(YYText()); return token_type::AND_OP; }
"||"																		{ yylval->emplace<std::string>(YYText()); return token_type::OR_OP; }
"=="																		{ yylval->emplace<std::string>(YYText()); return token_type::EQ_OP; }
"!="																		{ yylval->emplace<std::string>(YYText()); return token_type::NE_OP; }
"<"																			return '<';
">"																			return '>';
"<="																		{ yylval->emplace<std::string>(YYText()); return token_type::LE_OP; }
">="																		{ yylval->emplace<std::string>(YYText()); return token_type::GE_OP; }
"->" 																		{ yylval->emplace<std::string>(YYText()); return token_type::PTR_OP; }
"!"																			return '!';
"&"																			return '&';
"="																			return '=';
<<EOF>>																		yyterminate();
.																			{ yylval->emplace<std::string>(YYText()); return token_type::OTHER; }

%%

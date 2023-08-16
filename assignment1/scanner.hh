#if !defined(yyFlexLexerOnce)
	#include <FlexLexer.h>
#endif

#include "parser.tab.hh"
#include "location.hh"

namespace IPL
{
	class Scanner : public yyFlexLexer
	{
	public:
		Scanner(std::istream& in) : yyFlexLexer(in, std::cout){
			loc = new IPL::Parser::location_type();
		};

		virtual int yylex(IPL::Parser::semantic_type *const lval,
							IPL::Parser::location_type *location); 
	private:
		IPL::Parser::semantic_type *yylval = nullptr;
		IPL::Parser::location_type *loc    = nullptr;
	};


}
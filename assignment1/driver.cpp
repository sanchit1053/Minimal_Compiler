#include <cstring>
#include <cstddef>
#include <istream>
#include <iostream>
#include <fstream>

#include "scanner.hh"
#include "parser.tab.hh"

int main(const int argc, const char **argv)
{

  using namespace std;
  fstream in_file, out_file;

  if(argc <= 1){
    printf("USAGE \n ./iplC <input_file>\n");
    return 1;
  }

  in_file.open(argv[1], ios::in);
  // Generate a scanner
  IPL::Scanner scanner(in_file);
  // Generate a Parser, passing the scanner as an argument.
  // Remember %parse-param { Scanner  &scanner  }
  IPL::Parser parser(scanner);
  
  #ifdef YYDEBUG
   parser.set_debug_level(1);
  #endif 

  std::cout << "digraph D { node [ordering=out]" << std::endl;
  parser.parse();
  std::cout << "}" << std::endl;
}


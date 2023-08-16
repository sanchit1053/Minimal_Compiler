#include <cstring>
#include <cstddef>
#include <istream>
#include <iostream>
#include <iterator>
#include <fstream>

#include "scanner.hh"
#include "parser.tab.hh"

symtab *glbsymtab;
symtab *currentsymtab;
symtab *structsymtab, *funsymtab;
std::map<std::string, abstract_astnode *> ast;
std::map<std::string, std::string> strings;

std::map<std::string, TypeClass> predefined {
	{"printf", TypeClass("void")},
	{"scanf", TypeClass("void")},
	{"mod", TypeClass("int")}
};

int main(const int argc, const char **argv)
{
	glbsymtab = new symtab();
	currentsymtab = new symtab();
	structsymtab = new symtab();
	funsymtab = new symtab();

	using namespace std;
	fstream in_file, out_file;

	if (argc <= 1)
	{
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

	// std::cout << "[\n";
	parser.parse();
	// std::cout << "DONE " << glbsymtab->table.size() << std::endl;
	for (std::map<std::string, entity *>::iterator entry = glbsymtab->table.begin(); entry != glbsymtab->table.end(); entry++)
	{
		// std::cout << "DONE THIS TOO " << entry->first << std::endl;
		if (entry->second->entityType == Function){
			funsymtab->table[entry->first] = entry->second;
		}
	}

	for (std::map<std::string, entity *>::iterator entry = glbsymtab->table.begin(); entry != glbsymtab->table.end(); entry++)
	{
		if (entry->second->entityType == Struct)
			structsymtab->table[entry->first] = entry->second;
	}
	// std::cout << "\n]";
	// cout << "{\"globalST\": " << endl;
	// glbsymtab->printSymTab();
	// cout << "," << endl;
	// cout << "  \"structs\": [" << endl;
	// for (std::map<std::string, entity *>::iterator it = structsymtab->table.begin(); it != structsymtab->table.end(); ++it)
	// {
	// 	cout << "{" << endl;
	// 	cout << "\"name\": "
	// 		 << "\"" << it->first << "\"," << endl;
	// 	cout << "\"localST\": " << endl;
	// 	it->second->st->printSymTab(-4);
	// 	cout << "}" << endl;
	// 	if (next(it) != structsymtab->table.end())
	// 		cout << "," << endl;
	// }
	// cout << "]," << endl;
	// cout << "  \"functions\": [" << endl;

	for(std::map<std::string, std::string>::iterator it = strings.begin(); it != strings.end(); it++){
		cout << it->first << ":\n";
		cout << "\t.string " << it->second << "\n";
	}

	cout << "\t.globl main\n";


	for (std::map<std::string, entity *>::iterator it = funsymtab->table.begin(); it != funsymtab->table.end(); ++it)
	{
		// cout << "{" << endl;
		// cout << "\"name\": "
		// 	 << "\"" << it->first << "\"," << endl;
		// cout << "\"localST\": " << endl;
		// it->second->st->printSymTab(0, -1);
		// cout << "," << endl;
		// cout << "\"ast\": " << endl;
		// ast[it->first]->print();
		string t = "";
			t += it->first + ":\n";
			t += "\tpushl %ebp\n";
			t += "\tmovl %esp, %ebp\n" ;
		cout << t ;

		ast[it->first]->printcode();

		if( glbsymtab->getEntity(it->first)->type.getPrintString() == "void"){
		cout << "\tleave\n";
		cout << "\tret\n";
		}
		// cout << "}" << endl;
		// if (next(it) != funsymtab->table.end())
		// 	cout << "," << endl;
	}

}

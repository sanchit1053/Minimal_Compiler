CXX = g++-8
EXE = ipl_scanner
CXXDEBUG = -g
CXXSTD = -std=c++11
BIN = bin
DEBUG = debtrug
SOURCE = .
TEMP = temp
SCANNER=scanner_only

.PHONY: all parser lexer only_lexer

all: type symtab ast parser lexer
	$(CXX) $(CXXDEBUG) $(CXXSTD) -o iplC $(SOURCE)/driver.cpp parser.o scanner.o ast.o type.o symtab.o

ast : ./ast.cpp ./ast.hh
	$(CXX) $(CXXDEBUG) $(CXXSTD) -c -o ast.o $(SOURCE)/ast.cpp


type : ./type.cpp ./type.hh
	$(CXX) $(CXXDEBUG) $(CXXSTD) -c -o type.o $(SOURCE)/type.cpp


symtab : ./symtab.cpp ./ast.hh
	$(CXX) $(CXXDEBUG) $(CXXSTD) -c -o symtab.o $(SOURCE)/symtab.cpp

parser: $(SOURCE)/parser.yy $(SOURCE)/scanner.hh
	bison -d -v --report=all --file-prefix=$(SOURCE)/parser $<
	$(CXX) $(CXXDEBUG) $(CXXSTD) -c $(SOURCE)/parser.tab.cc -o parser.o 


lexer: $(SOURCE)/scanner.l $(SOURCE)/scanner.hh $(SOURCE)/parser.tab.hh $(SOURCE)/parser.tab.cc	
	flex++ --outfile=$(SOURCE)/scanner.yy.cc  $<
	$(CXX)  $(CXXDEBUG) $(CXXSTD) -c $(SOURCE)/scanner.yy.cc -o scanner.o

only_lexer: $(SCANNER)/scanner.l $(SCANNER)/scanner.hh
	flex++ --outfile=$(SCANNER)/scanner.yy.cc  $<
	$(CXX)  $(CXXDEBUG) $(SCANNER)/scanner.yy.cc -o scanner


.PHONY: clean

clean: 
	rm -f *.o
	rm -f iplC
	rm -f $(SOURCE)/ast.o
	rm -f $(SOURCE)/location.hh
	rm -f $(SOURCE)/parser.output
	rm -f $(SOURCE)/parser.tab.cc
	rm -f $(SOURCE)/parser.tab.hh
	rm -f $(SOURCE)/position.hh
	rm -f $(SOURCE)/scanner.yy.cc
	rm -f $(SOURCE)/stack.hh

DEPS = ${CDEPS} ${YYDEPS}
YYDEPS = yylex yyparse
CDEPS = string_set astree lyutils auxlib symbol
CPP = ${CDEPS:=.cpp} main.cpp 
HEAD = ${CDEPS:=.h} oclib.h
OBJ = ${DEPS:=.o} main.o
GPP = g++ -std=gnu++2a -g -O0
EXEC = oc
YY = -Wno-sign-compare -Wno-register
WARN =  -Wall -Wextra -Wpedantic -Wshadow -Wold-style-cast
LSOURCES = scanner.l
YSOURCES = parser.y
CLGEN = yylex.cpp
HYGEN = yyparse.h
CYGEN = yyparse.cpp
LREPORT = yylex.output
YREPORT = yyparse.output
GEN = ${CLGEN} ${CYGEN} ${HYGEN} ${LREPORT} ${YREPORT} 
SOURCE = ${LSOURCES} ${YSOURCES} oclib.h oclib.c

all : $(HYGEN) $(CLGEN) $(OBJ)
	$(GPP) $(WARN) -o $(EXEC) $(OBJ)

%.o : %.cpp
	$(GPP) $(WARN) -o $@ -c $<

yylex.o : yylex.cpp
	$(GPP) -c $<

yyparse.o : yyparse.cpp
	$(GPP) -c $<

$(CLGEN) : $(LSOURCES)
	flex --outfile=$(CLGEN) $(LSOURCES)

$(CYGEN) $(HYGEN) : $(YSOURCES)
	bison --defines=$(HYGEN) --output=$(CYGEN) $(YSOURCES)

clean :
	rm $(EXEC)

open :
	emacs main.cpp&
	emacs astree.cpp&
	emacs scanner.l&
	emacs astree.cpp&
	emacs lyutils.cpp&

spotless :
	rm $(EXEC) $(OBJ) $(GEN)

ci :
	git commit -am "Generic commit"

deps : $(CDEPS)
	g++ -c $(WARN) $(CDEPS)

ssh :
	ssh mnibler@unix.ucsc.edu

test :
	./oc 01-test.oc
	cat 01-test.ast
	cat 01-test.oc

submit :
	submit cse110a-wm.f19 asg4 Makefile README
	submit cse110a-wm.f19 asg4 $(CPP) $(HEAD) $(SOURCE)


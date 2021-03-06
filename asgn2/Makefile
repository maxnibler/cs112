DEPS = ${CDEPS} ${YYDEPS}
YYDEPS = yylex yyparse
CDEPS = string_set astree lyutils auxlib
CPP = ${CDEPS:=.cpp} main.cpp
HEAD = ${CDEPS:=.h}
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

all : $(HYGEN) $(OBJ)
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
	rm $(OBJ)

open :
	emacs main.cpp&
	emacs astree.cpp&
	emacs scanner.l&
	emacs astree.cpp&
	emacs lyutils.cpp&

spotless :
	rm $(EXEC) $(OBJ)

ci :
	git commit -am "Generic commit"

deps : $(CDEPS)
	g++ -c $(WARN) $(CDEPS)

ssh :
	ssh mnibler@unix.ucsc.edu

test :
	./oc test.oc

submit :
	submit cse110a-wm.f19 asg2 Makefile README $(LSOURCES)
	submit cse110a-wm.f19 asg2 $(CPP) $(HEAD) $(YSOURCES) $(HYGEN)


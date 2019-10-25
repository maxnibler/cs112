DEPS = main string_set astree lyutils auxlib
CDEPS = ${DEPS:=.cpp}
OBJ = ${DEPS:=.o}
GPP = g++
EXEC = oc
WARN = -std=gnu++17 -g -O0 -Wall -Wextra -Wold-style-cast

all : $(OBJ)
	$(GPP) $(WARN) -o $(EXEC) $(OBJ) 	

%.o : %.cpp
	$(GPP) $(WARN) -o $@ -c $<

clean :
	rm $(OBJ)

spotless :
	rm $(EXEC) $(OBJ)

ci :
	git commit -am "Generic commit"

deps : $(CDEPS)
	g++ -c $(WARN) $(CDEPS)

test :
	./oc test.oc


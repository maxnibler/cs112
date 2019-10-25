DEPS = main string_set astree lyutils auxlib
CDEPS = ${DEPS:=.cpp}
OBJ = ${DEPS:=.o}
GPP = g++ -o
WARN = -std=gnu++17 -g -O0 -Wall -Wextra -Wold-style-cast

all : $(OBJ)
	$(GPP) oc $(OBJ) 	

clean :
	rm $(OBJ)

spotless :
	rm oc $(OBJ)

ci :
	git commit -am "Generic commit"

deps : $(CDEPS)
	g++ -c $(WARN) $(CDEPS)

test :
	./oc test.oc


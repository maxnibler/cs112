DEPS = main string_set astree lyutils auxlib
CDEPS = ${DEPS:=.cpp}
OBJ = ${DEPS:=.o}
GPP = g++ -std=gnu++2a -g -O0
EXEC = oc
YY = -Wno-sign-compare -Wno-register
WARN =  -Wall -Wextra -Wpedantic -Wshadow -Wold-style-cast

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


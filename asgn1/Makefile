CDEPS = main.cpp string_set.cpp
OBJ = main.o string_set.o
GPP = g++ -o
WARN = -std=gnu++17 -g -O0 -Wall -Wextra -Wold-style-cast

all : $(OBJ)
	$(GPP) oc $(OBJ) 	

clean :
	rm $(OBJ)

spotless :
	rm oc $(OBJ)

ci :
	git commit -am "$<<"

deps : $(CDEPS)
	g++ -c $(WARN) $(CDEPS)

test :
	./oc test.oc


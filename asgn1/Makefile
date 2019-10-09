CDEPS = main.cpp
OBJ = main.o
GPP = g++ -o
WARN = -Wall -Wextra -Wpedantic -Wshadow -Wold-style-cast

all : $(OBJ)
	$(GPP) oc $(OBJ) 	

clean :
	rm $(OBJ)

spotless :
	rm oc $(OBJ)

ci :

deps : $(CDEPS)
	g++ -c $(CDEPS)

test :
	./oc test.oc


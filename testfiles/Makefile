# $Id: Makefile,v 1.21 2019-10-11 14:21:09-07 - - $

UTILDIR = /afs/cats.ucsc.edu/courses/cse110a-wm/bin

NOWARN  = -Wno-write-strings -Wno-main
OCGPP   = g++ ${NOWARN} -x c++ -include octypes.h

OCSRC   = ${sort ${wildcard [0-8]*.oc}}
LIBSRC  = oclib.c
LIBOBJ  = ${LIBSRC:.c=.o}
HEADERS = oclib.h octypes.h
OCOBJ   = ${OCSRC:.oc=.o}
EXECS   = ${OCSRC:.oc=}
ALLSRC  = ${OCSRC} 9*.oc Makefile ${HEADERS} ${LIBSRC}
LISTING = Listing.oc-programs

all : ${EXECS}

% : %.o ${LIBOBJ}
	g++ $< ${LIBOBJ} -o $@

%.o : %.oc ${HEADERS}
	- cid + $<
	- checksource $<
	${OCGPP} -c $<

${LIBOBJ} : ${LIBSRC}
	- cid + $<
	- checksource $<
	gcc -c $<

spotless : clean
	- rm ${LISTING}.{ps,pdf} ${EXECS}

clean :
	-rm ${OCOBJ} ${LIBOBJ} oclib.nm Listing.asm.{ps,pdf}

ci :
	${UTILDIR}/cid + ${ALLSRC}

lis :
	${UTILDIR}/checksource ${ALLSRC}
	${UTILDIR}/mkpspdf ${LISTING}.ps ${ALLSRC}

asm : ${LIBOBJ}
	nm -a ${LIBOBJ} >oclib.nm
	${UTILDIR}/mkpspdf Listing.asm.ps \
	      oclib.h oclib.c oclib.nm oclib.s

again :
	make --no-print-directory clean ci all lis

DEPSFILE  = Makefile.deps
NOINCLUDE = ci clean spotless
NEEDINCL  = ${filter ${NOINCLUDE}, ${MAKECMDGOALS}}
WARNING   = -Wall -Wextra -Wpedantic -Wshadow -Wold-style-cast
GPP       = g++ -std=gnu++2a -g -O0
GPPWARN   = ${GPP} ${WARNING} -fdiagnostics-color=never
GPPYY     = ${GPP} -Wno-sign-compare -Wno-register
MKDEPS    = g++ -std=gnu++2a -MM
GRIND     = valgrind --leak-check=full --show-reachable=yes
UTILBIN   = /afs/cats.ucsc.edu/courses/cse110a-wm/bin

MODULES   = astree lyutils string_set emitter auxlib
HDRSRC    = ${MODULES:=.h}
CPPSRC    = ${MODULES:=.cpp} main.cpp
FLEXSRC   = lexer.l
BISONSRC  = parser.y
PARSEHDR  = yyparse.h
LEXCPP    = yylex.cpp
PARSECPP  = yyparse.cpp
CGENS     = ${LEXCPP} ${PARSECPP}
ALLGENS   = ${PARSEHDR} ${CGENS}
EXECBIN   = zexprsm
ALLCSRC   = ${CPPSRC} ${CGENS}
OBJECTS   = ${ALLCSRC:.cpp=.o}
LEXOUT    = yylex.output
PARSEOUT  = yyparse.output
REPORTS   = ${LEXOUT} ${PARSEOUT}
MODSRC    = ${foreach MOD, ${MODULES}, ${MOD}.h ${MOD}.cpp}
MISCSRC   = ${filter-out ${MODSRC}, ${HDRSRC} ${CPPSRC}}
ALLSRC    = README ${FLEXSRC} ${BISONSRC} ${MODSRC} ${MISCSRC} Makefile
TESTINS   = ${wildcard test*.in}
EXECTEST  = ${EXECBIN} -ly
LISTSRC   = ${ALLSRC} ${DEPSFILE} ${PARSEHDR}


all : ${EXECBIN}

${EXECBIN} : ${OBJECTS}
        ${GPPWARN} -o${EXECBIN} ${OBJECTS}


clean :
        - rm ${OBJECTS} ${ALLGENS} ${REPORTS} ${DEPSFILE} core
        - rm ${foreach test, ${TESTINS:.in=}, \
              ${patsubst %, ${test}.%, out err log}}

spotless : clean
        - rm ${EXECBIN} List.*.ps List.*.pdf


ci : ${ALLSRC} ${TESTINS}
        - ${UTILBIN}/checksource ${ALLSRC}
        ${UTILBIN}/cid + ${ALLSRC} ${TESTINS} test?.inh


deps: ${ALLCSRC}
        @ echo "# ${DEPSFILE} created `date` by ${MAKE}" >${DEPSFILE}
        ${MKDEPS} ${ALLCSRC} >>${DEPSFILE}


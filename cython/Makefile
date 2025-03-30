
FLIB = binio
TARGET = forbit

FC = gfortran
FFLAG = -O3 -Wall

export CC = gcc
PC = compiler.py

LIB_INSTALL = ${HOME}/PythonLib/lib/

#%.o : %.f90
#	${FC} -c $< ${FFLAG} -fPIC
#
#%.so : %.o
#	${FC} -shared -fPIC -o lib$@ $^
%.so : %.f90
	${FC} -shared -fPIC -Wl,-rpath,. -o lib$@ $^

all : ${TARGET}

${TARGET} : ${FLIB}.so
	python compiler.py ${TARGET} ${TARGET}.pyx


.PHONY : clean re

clean :
	rm -fv *.mod ${TARGET}.c *.so
	rm -rfv build

re : clean all

install :
	cp *.so ${LIB_INSTALL}


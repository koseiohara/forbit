PYMOD = binio
FMOD = binio.f90

F2PY = f2py
FC = gfortran
FFLAG = -O3

all : ${PYMOD}

${PYMOD} : ${FMOD}
	${F2PY} --fcompiler=${FC} -m $@ -c --f90flags='${FLAG}' $<

.PHONY : clean re

clean :
	rm -fv *.so

re : clean all


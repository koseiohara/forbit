PYMOD = binio
FMOD = binio.f90

F2PY = f2py

all : ${PYMOD}

${PYMOD} : ${FMOD}
	${F2PY} -m $@ -c $<

.PHONY : clean re

clean :
	rm -fv *.so

re : clean all


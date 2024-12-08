PYMOD = dabin
FMOD = dabin.f90

F2PY = f2py

all : ${PYMOD}

${PYMOD} : ${FMOD}
	${F2PY} -m $@ -c $<

.PHONY : clean re

clean :
	rm -fv *.so

re : clean all


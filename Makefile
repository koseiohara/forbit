PYMOD = dabin
FMOD = ${PYMOD}.f90
OBJS = ${FMOD:.f90=.o}

F2PY = f2py

FC = ifort
FLAG = -warn all -O1 -traceback

all : ${PYMOD}

${PYMOD} : ${FMOD}
	${F2PY} -m ${PYMOD} -c ${FMOD}

 ${OBJS} : ${FMOD}
	${FC} -c $< ${FLAG}


.PHONY : cp clean

cp : ${OBJS}

clean :
	rm -fv *.o *.mod

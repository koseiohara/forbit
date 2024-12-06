PYMOD = BinIO
FMOD = BinIO.f90
OBJS = ${FMOD:.f90=.o}

F2PY = f2py

FC = ifort
FLAG = -warn all -O1 -traceback

all : ${PYMOD}

${PYMOD} : ${FMOD}
	${F2PY} -c -m ${PYMOD} ${FMOD}

 ${OBJS} : ${FMOD}
	${FC} -c $< ${FLAG}


.PHONY : cp clean

cp : ${OBJS}

clean :
	rm -fv *.o *.mod

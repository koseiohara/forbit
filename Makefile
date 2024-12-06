PYMOD = BinIO
FMOD = BinIO.f90

F2PY = f2py

all : ${PYMOD}

${PYMOD} : ${FMOD}
	${F2PY} -c -m ${PYMOD} ${FMOD}


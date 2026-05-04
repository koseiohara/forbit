
PYTHON = python3
FC     = gfortran
CC     = gcc
CYTHON = cython

TARGET_NAME = forbit

EXT_SUFFIX := $(shell $(PYTHON) -c "import sysconfig; print(sysconfig.get_config_var('EXT_SUFFIX'))")
NUMPY_INC  := $(shell $(PYTHON) -c "import numpy; print(numpy.get_include())")
PY_INC     := $(shell $(PYTHON) -c "import sysconfig; print(sysconfig.get_paths()['include'])")

TARGET = $(TARGET_NAME)$(EXT_SUFFIX)

F90_SRC = binio.f90
PYX_SRC = forbit.pyx
C_SRC   = $(PYX_SRC:%.pyx=%.c)

F90_OBJ = $(F90_SRC:%.f90=%.o)
C_OBJ   = $(C_SRC:%.c=%.o)

OBJS = $(F90_OBJ) $(C_OBJ)

FFLAGS  ?= -O3 -fPIC
CFLAGS  ?= -O3 -fPIC
LDFLAGS ?= -shared

%.c : %.pyx
	$(CYTHON) -3 --embed-positions -o $@ $<

%.o : %.f90
	$(FC) -c $< $(FFLAGS) -o $@

%.o : %.c
	$(CC) -c $< $(CFLAGS) -I$(PY_INC) -I$(NUMPY_INC) -o $@

all: $(TARGET)

$(TARGET) : $(OBJS)
	$(FC) -o $@ $^ $(LDFLAGS)

.PHONY: all clean distclean show

show:
	@echo "PYTHON     = $(PYTHON)"
	@echo "FC         = $(FC)"
	@echo "CC         = $(CC)"
	@echo "CYTHON     = $(CYTHON)"
	@echo "EXT_SUFFIX = $(EXT_SUFFIX)"
	@echo "NUMPY_INC  = $(NUMPY_INC)"
	@echo "PY_INC     = $(PY_INC)"
	@echo "TARGET     = $(TARGET)"

clean:
	rm -f *.o *.mod *.so forbit.c

distclean: clean
	rm -rf build dist *.egg-info




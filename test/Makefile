
FEXE = bingen
FOBJ = gen_fort_bin.o

FC = gfortran
FFLAG = -O3 -Wall

%.o : %.f90
	$(FC) -c $< $(FFLAG)

all : $(FEXE)

$(FEXE) : $(FOBJ)
	$(FC) -o $@ $^

.PHONY: clean re run

clean :
	rm -fv *.o *.mod $(FEXE)

re : clean all

run :
	./$(FEXE)



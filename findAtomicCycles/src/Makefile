
# set MODE=DEBUG to build with debugging and verbose printing on host,
# default is to build with optimizations on and no debug or profile
#
# location of the Waffles toolkit source
WAFFLES = $(HOME)/waffles

CXX = g++
CPPFLAGS += -I$(WAFFLES)/src
LDFLAGS += -L$(WAFFLES)/lib
CXXDEBUG = -g

# Waffles toolkit library
LDLIBS = -lGClasses

ifeq ($(MODE),DEBUG)
  CXXFLAGS += $(CXXDEBUG)
  LDLIBS = -lGClassesDbg
endif

all: findAtomicCycles

findAtomicCycles.o: findAtomicCycles.cpp
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -o findAtomicCycles.o -c findAtomicCycles.cpp

findAtomicCycles: findAtomicCycles.o
	$(CXX) $(LDFLAGS) -o findAtomicCycles findAtomicCycles.o $(LDLIBS)

clean:
	$(RM) findAtomicCycles
	$(RM) findAtomicCycles.o


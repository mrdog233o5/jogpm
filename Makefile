CFILE=main
CSOURCE=$(wildcard *.cpp)
MANFILE=jogpm.1
MANSOURCE=$(wildcard *.md)
CC=g++
CCARG=$(CSOURCE) -o $(CFILE)
PANDOC=pandoc
PANDOCARG=-s $(MANSOURCE) -t man -o $(MANFILE)

all: build buildman

build:
	$(CC) $(CCARG)

	echo build done | lolcat

buildman:
	$(PANDOC) $(PANDOCARG)

	echo build man from md | lolcat

run: build
	. $(CFILE)
	echo $(CFILE) ran | lolcat

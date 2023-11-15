CFILE=main
CFILE2=jogpmExec
CSOURCE=./src/main.cpp
CSOURCE2=./src/jogpm.cpp
MANFILE=jogpm.1
MANSOURCE=$(wildcard *.md)
CC=g++
CCARG=$(CSOURCE) -o $(CFILE) -lcurl
CCARG2=$(CSOURCE2) -o $(CFILE2) -lcurl
PANDOC=pandoc
PANDOCARG=-s $(MANSOURCE) -t man -o $(MANFILE)

all: build buildman

build:
	$(CC) $(CCARG)
	$(CC) $(CCARG2)
	cp -f ./jogpmExec ./jogpm/jogpm/jogpmExec
	echo "build done" | lolcat

buildman:
	$(PANDOC) $(PANDOCARG)
	echo "build man from md" | lolcat

run: build
	. $(CFILE)
	echo $(CFILE) ran | lolcat

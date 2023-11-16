CFILE=main
CSOURCE=./src/main.cpp
MANFILE=jogpm.1
MANSOURCE=$(wildcard *.md)
CC=g++
CCARG=$(CSOURCE) -o $(CFILE) -lcurl
PANDOC=pandoc
PANDOCARG=-s $(MANSOURCE) -t man -o $(MANFILE)

all: build buildman

build:
	$(CC) $(CCARG)
	cp -f ./src/jogpm.c ./jogpm/jogpm/jogpm.c
	echo "build done" | lolcat

buildman:
	$(PANDOC) $(PANDOCARG)
	echo "build man from md" | lolcat

run: build
	. $(CFILE)
	echo $(CFILE) ran | lolcat

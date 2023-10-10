CC=clang++
CFILE=main

run: build

build:
	$(CC) $(CFILE).cpp -o $(CFILE)
	echo built done | lolcat

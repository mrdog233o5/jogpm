CC=g++
CFILE=main

run:
	$(CC) -o $(CFILE) $(CFILE).cpp

	echo built done | lolcat

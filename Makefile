CC=pyinstaller
CFILE=main
CFLAGS = --clean --noconsole --noconfirm --uac-admin --hidden-import pygame -F

run:
	$(CC) $(CFLAGS) $(CFILE).py
	echo built done | lolcat

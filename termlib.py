import time
import sys
import os

class ansiConverter:
    def __init__(self):
        self.RESET = "\33[0m]"
        self.RESET = self.RESET.rstrip(self.RESET[-1])

    def ansiText(self, text, rgb=(255,255,255)):
        r,g,b = rgb
        ret = f"\033[38;2;{r};{g};{b}m{str(text)}]"
        return ret.rstrip(ret[-1])+self.RESET

    def ansiBlock(self, rgb=(255,255,255)):
        r,g,b = rgb
        ret = f"\033[48;2;{r};{g};{b}m ]"
        return ret.rstrip(ret[-1])+self.RESET

class printer:
    def __init__(self, color=[-1,-1,-1]):
        self.color = color

    def cprint(self, msg, color):
        tempClass = ansiConverter()
        print(tempClass.ansiText(msg, rgb=color), end="")

    def bprint(self, color):
        tempClass = ansiConverter()
        print(tempClass.ansiBlock(rgb=color), end="")
        print(tempClass.ansiBlock(rgb=color), end="")

    def aprint(self, message, WaitTime=0.015, end="\n"):
        for i in message:
            self.cprint(i, color=self.color)
            time.sleep(WaitTime)
        print(end, end="")

    def cprintgrid(self, grid, space=10, revert=False):
        if revert:
            grid = list(zip(*grid[::-1]))
            for i in range(len(grid)):
                grid[i] = list(reversed(grid[i]))
        for row in grid:
            for element in row:
                self.cprint(element, color=self.color)
                for i in range(space - len(str(element))):
                    self.cprint(" ", color=self.color)
            print("")

    def printgrid(self, grid, space=10, revert=False):
        if revert:
            grid = list(zip(*grid[::-1]))
            for i in range(len(grid)):
                grid[i] = list(reversed(grid[i]))
        for row in grid:
            for element in row:
                print(element, end="")
                for i in range(space - len(str(element))):
                    print(" ", end="")
            print("")

    def cleanln(self):
        temp = '\r\33[K]'
        sys.stdout.write(temp.strip(temp[-1]))
        sys.stdout.flush()

    def clean(self):
        os.system('cls' if os.name == 'nt' else 'clear')

    def bList(self, grid, keys, revert=False):
        if revert:
            grid = list(zip(*grid[::-1]))
            for i in range(len(grid)):
                grid[i] = list(reversed(grid[i]))
        for row in grid:
            for element in row:
                self.bprint(keys[element])
            print("")

    def bText(self, text:str, keys, revert = False):
        rows = text.split(sep="\n")
        del rows[0]
        del rows[-1]
        grid = []
        for i in rows:
            grid.append(list(i))
        if revert:
            grid = list(zip(*grid[::-1]))
            for i in range(len(grid)):
                grid[i] = list(reversed(grid[i]))
        for row in grid:
            for element in row:
                self.bprint(keys[element])
            print("")


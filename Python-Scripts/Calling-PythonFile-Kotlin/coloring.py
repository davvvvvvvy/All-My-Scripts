#
#
#               COLORING IN PYTHON
#
#


class COLORING:
    PURPLE    = '\033[95m' # Purple
    BLUE      = '\033[94m' # Blue
    GREEN     = '\033[92m' # Green
    YELLOW    = '\033[93m' # Yellow
    RED       = '\033[91m' # Red
    DEFAULT   = '\033[0m'  # Default
    BOLD      = '\033[1m'  # Bold
    UNDERLINE = '\033[4m'  # Underline

print(COLORING.YELLOW    + "This is yellow"    + COLORING.DEFAULT + " by Ivan")
print(COLORING.PURPLE    + "This is purple"    + COLORING.DEFAULT + " by Ivan")
print(COLORING.BLUE      + "This is blue"      + COLORING.DEFAULT + " by Ivan")
print(COLORING.RED       + "This is red"       + COLORING.DEFAULT + " by Ivan")
print(COLORING.GREEN     + "This is green"     + COLORING.DEFAULT + " by Ivan")
print(COLORING.BOLD      + "This is bold"      + COLORING.DEFAULT + " by Ivan")
print(COLORING.UNDERLINE + "This is underline" + COLORING.DEFAULT + " by Ivan")


print( f"{COLORING.RED}{COLORING.BOLD}{COLORING.UNDERLINE}Ivan says:{COLORING.DEFAULT} Hey, whats up GitHubbers?" )


print("\n\n\n\n\n\n")

person = "I am red is here"

print(f"{COLORING.BLUE if 'blue' in person in person else COLORING.RED}{person}")

print(f"Zivot je nekad siv nekad {COLORING.YELLOW}zut {COLORING.DEFAULT}")

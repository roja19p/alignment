import sys

for line in open(sys.argv[1]):
    lst = line.strip().split()
    if len(lst) > 2:
        print(line.strip())

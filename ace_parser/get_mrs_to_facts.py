import sys, re

fr = open(sys.argv[1], 'r').readlines()

for i in range(len(fr)):
    if fr[i].startswith('ICONS'):
        a = re.findall(r'\<([^>]+)\>', fr[i].strip())
        print(a)
        if a != []:
            print(a)




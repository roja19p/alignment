import sys

f = open(sys.argv[1], 'r').readlines()

flag = 0
for i in range(0, len(f)-1):
    if f[i].startswith('(ROOT'):
        print(f[i-2].strip())
        print(f[i-1].strip())
        flag = 1
    if flag == 1:    
        print(f[i].strip())
    if f[i].startswith('\n') and flag == 1:
        print(f[i].strip())
        print(';~~~~~~~~~~')
        flag = 0

         







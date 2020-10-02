import sys, re

f = open(sys.argv[1], 'r').readlines()

cons = f[0]
eng_index = 0
stack = []


while eng_index < len(cons):
    if cons[eng_index] == '(':
        b = cons
        a = re.findall(r'\("[^() ]+"', b)
        print(a)
        stack.append(a[0])
        length = len(a[0])
        eng_index = eng_index + length + 1
        print(eng_index, stack)
        del[a[0]]
        print(a)
        b = b[
        



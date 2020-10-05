import sys, re 

fw = open('clause_log', 'a')

hnd = ''
for line in open(sys.argv[1]):
    if 'Output 1 from NMT' in line:
        hnd = line[20:-1]


#print(hnd)        


for line in open(sys.argv[2]):
    if 'Output 1 from NMT' in line:
        h_clause = line[20:-1]
        if h_clause in hnd:
            a = re.sub(h_clause, '', hnd)
            #print(h_clause)
            #print(a)
            hnd = a
        else:
            fw.write('Check h_clause in hnd ' +  h_clause +  '\n')

print(hnd)

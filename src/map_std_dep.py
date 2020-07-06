import sys, re


f = open(sys.argv[1], 'r').readlines()

for i in range(0, len(f)-1):
    if i >2 and i != len(f)-2:
        #To get rel info
        rel = re.findall(r'.*\(', f[i])
        rel = rel[0][:-1]
#        print(rel)

        #To get head id and child id info
        hid = re.findall(r'-[^-]+,', f[i])
        hid = hid[0][1:-1]
#        print(hid)

        cid = re.findall(r'-[^-]+\)', f[i])
        cid = cid[0][1:-1]
#        print(cid)

        print('(eng_relation_name-head-chiid', rel, hid, cid, ')')





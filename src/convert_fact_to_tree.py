import sys

for line in open(sys.argv[1]):
    new_lst = []
    lst = line[:-2].split()
    new_lst.append(lst[1])
    new_lst.append(lst[2])
    new_lst.append(lst[2])
    new_lst.append(lst[3])
    new_lst.append("_")
    new_lst.append("_")
    new_lst.append(lst[4])
    new_lst.append("_")
    #new_lst.append(lst[3]+':'+lst[4])
    new_lst.append("_")
    new_lst.append("_")
    print('\t'.join(new_lst))

print('\n')    

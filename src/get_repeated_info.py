from all_indices import return_index

#To get Repeated english words index
with open('word.dat', 'r') as wd:
    new_lst = []
    w_lst = []
    for line in wd:
        if 'id-word' in line:
            lst = line[:-2].split()
            w_lst.append(lst[2])
    for each in w_lst:
        out = return_index(w_lst, each)
        if len(out) > 1:
            for each in out:
                if each+1 not in new_lst:
                   new_lst.append(each+1)

    for each in new_lst:
        print('(Repeated_id ' , each, ')')
                                                 

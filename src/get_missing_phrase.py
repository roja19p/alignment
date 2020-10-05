#Programme to get missing clauses/phrases in a sentence
import sys


e_sent = open(sys.argv[1], 'r').read().split()
clause_info_f = open("clauses_info_with_ids.dat", "w")

start_index = 0
clause_len = 0
missing_clause = []
count = 0
f_count = 0
w_count = 0
w_c_lst = []


def print_wrd_count_in_seq(clause, wc):
    lst = []
    for i in range(len(clause)):
            lst.append(str(int(wc+i)))
    return lst        
            

for line in open(sys.argv[2]):
    lst = line.strip().split()
    #clause_info = lst[1:]
    clause_info = lst
    index = e_sent[start_index:].index(clause_info[0])
    start_index = start_index + len(missing_clause)+clause_len
    missing_clause = e_sent[start_index:index]
    clause_len = len(clause_info)
    if missing_clause != []:
        count += 1
        print('M' + str(count) + '\t' + ' '.join(missing_clause))
        w_count += 1
        w_c_lst = print_wrd_count_in_seq(missing_clause, w_count)
        clause_info_f.write('(eng_clause_ids ' + ' '.join(w_c_lst) + ')\n')
        clause_info_f.write('(missing_clause ' + w_c_lst[0] + ')\n')
        w_count = int(w_c_lst[-1])
 
  #This 0000 wors only for 9 clauses. Need to automate here    
    print('000' + str(f_count) + '\t' + ' '.join(clause_info))
    f_count += 1
    count += 1
    w_count += 1
    w_c_lst = print_wrd_count_in_seq(clause_info, w_count)
    clause_info_f.write('(eng_clause_ids ' + ' '.join(w_c_lst) + ')\n')
    w_count = int(w_c_lst[-1])



    
  

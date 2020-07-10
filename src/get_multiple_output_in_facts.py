import sys

count = 0

h_wrd_dic = {}
h_rt_dic = {}
final_dic = {}

#manual_id_mapped.dat
for line in open(sys.argv[2]):
    lst = line[:-2].split()
    if lst[2] not in h_wrd_dic.keys():
        h_wrd_dic[lst[2]] = lst[1]
    else:
        h_wrd_dic[lst[2]] = h_wrd_dic[lst[2]] + '/' + lst[1]

#manual_mapped_id_root_info.dat
for line in open(sys.argv[3]):
    lst = line.strip().split()
    if lst[2] not in h_rt_dic.keys():
        h_rt_dic[lst[2]] = lst[1]
    else:
        h_rt_dic[lst[2]] = h_rt_dic[lst[2]] + '/' + lst[1]


for line in open(sys.argv[1]):
    lst = line.strip().split('\t')
    for i in range(1, len(lst)):
        if '/' not in lst[i]:
            if lst[i] in h_wrd_dic.keys():
                ids = h_wrd_dic[lst[i]].split('/')
                if i not in final_dic.keys():
                    final_dic[i] = ' '.join(ids)
                else:
                    final_dic[i] = final_dic[i] + ' ' + ' '.join(ids)
            elif lst[i] in h_rt_dic.keys():
                ids = h_rt_dic[lst[i]].split('/')
                if i not in final_dic.keys():
                    final_dic[i] = ' '.join(ids)
                else:
                    final_dic[i] = final_dic[i] + ' ' + ' '.join(ids)
            else:
                if i not in final_dic.keys():
                    final_dic[i] = lst[i]
                else:
                    final_dic[i] = final_dic[i] + ' ' + lst[i]
        else:
            m = lst[i].split('/')
            for each in m :
                if each in h_wrd_dic.keys():
                    ids = h_wrd_dic[each].split('/')
                    if i not in final_dic.keys():
                         final_dic[i] = ' '.join(ids)
                    else:
                         final_dic[i] = final_dic[i] + ' ' + ' '.join(ids)
                elif each in h_rt_dic.keys():
                    ids = h_rt_dic[each].split('/')
                    if i not in final_dic.keys():
                         final_dic[i] = ' '.join(ids)
                    else:
                         final_dic[i] = final_dic[i] + ' ' + ' '.join(ids)
                else:
                    if i not in final_dic.keys():
                         final_dic[i] = each
                    else:
                         final_dic[i] = final_dic[i] + ' ' + each

for key in sorted(final_dic):
    print('(eng_id-hindi_id ' + str(key) + ' ' + final_dic[key] + ')')





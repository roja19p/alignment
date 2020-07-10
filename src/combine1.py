import sys
import pandas as pd
import re


from nltk import skipgrams
from nltk import ngrams
from nltk import everygrams


file = open(sys.argv[1], 'r', encoding='utf-8', errors='ignore')
file1 = open(sys.argv[2], 'w', encoding='utf-8', errors='ignore')
#file = open('sens/0009', 'r', encoding='utf-8', errors='ignore')
Lines1 = file.readlines()

i = 0
for l in Lines1:
    if('NMT:' in l):
        print(i,l)
        file1.write((str(i)+":"+l))
        i += 1
    else:
        print(l)
        file1.write((l))

Lines = []
for l in Lines1:
    if('NMT:' in l):
        l1 = l.split('NMT: ')[1].strip()
        Lines.append(l1)
    if('ENG: ' in l):
        eng_sen = l



my_list = []
for line in Lines:
   l=line.strip()
   my_list.append(l.split(sep=' ',maxsplit=-1))
   #print(l.split(sep='\t',maxsplit=-1))

no_nmt_op = len(Lines)


i = 0
for l in Lines:
    if(i == 0):
        sen_df = pd.DataFrame([l.split()])
    else:
        tmp_df = pd.DataFrame([l.split()])
        sen_df = sen_df.append(tmp_df)
    i += 1

total_egram = []
for i, sen in sen_df.fillna('NOWORD').iterrows():
    lsen = list(sen)
    l_egram = list(everygrams(lsen))
    for gm in everygrams(lsen):
        total_egram.append(list(gm))
        #print(list(gm))

#print(sen_df)

total_egram_dic = {}
for l in total_egram:
    if(len(l) == 1):
        k = l[0]
    else:
        k = '_'.join(l)
    if k in total_egram_dic:
        total_egram_dic[k] = total_egram_dic[k] + 1
    else:
        total_egram_dic[k] = 1



total_egram_dic_sorted = {k: v for k, v in sorted(total_egram_dic.items(), key=lambda item: item[1])}

i = 0
for k in total_egram_dic_sorted:
    freq = total_egram_dic_sorted[k]
    size = len(k.split('_'))
    data = [k,size,freq]
    if(i == 0):
        tmp_df = pd.DataFrame([data])
        egram_df = pd.DataFrame([0,1,2])
        egram_df = egram_df.append(tmp_df)
    else:
        tmp_df = pd.DataFrame([data])
        egram_df = egram_df.append(tmp_df)
    i += 1


egram_df_soted = egram_df.sort_values(2,1)

total_wds = []
total_grp_wds = []
for i in range(egram_df_soted.shape[0],0,-1):
    row_info = egram_df_soted.iloc[i-1].to_list()
    wds = str(row_info[0]).split('_')
    flag_not_pres = 0
    if('NOWORD' not in wds):
        for wd in wds:
            if (wd not in total_wds):
                total_wds.append(wd)
                flag_not_pres = 1
                wd_flg = wd
        if flag_not_pres:
            total_grp_wds.append(row_info)



for i, sen in sen_df.fillna('NOWORD').iterrows():
    lsen = list(sen)
    break
filled_sen = [0] * len(lsen)

for wds in total_grp_wds:
    if(type(wds[0]) == str):
        wds_split = wds[0].split('_')
        freq = wds[2]
        for wd in lsen:
            if wd in wds_split:
                for w in wds_split:
                    k = 0
                    for i, sen in sen_df.fillna('NOWORD').iterrows():
                        lsen = list(sen)
                        for j in range(0,len(lsen)):
                            if(w == lsen[j]):
                                if(filled_sen[j] == 0):
                                    filled_sen[j] = w+'_'+str(k)
                                else:
                                    tmp_wd = []
                                    full_wd = filled_sen[j].split('/')
                                    for w1 in full_wd:
                                        tmp_wd.append(w1.split('_')[0])
                                    if(w in tmp_wd):
                                        for w1 in full_wd:
                                            if w == w1.split('_')[0]:
                                                nmt_ns = w1.split('_')[1].split('+')
                                                if str(k) not in nmt_ns:
                                                    tmp_new_wd = w1+'+'+str(k)
                                                    tmp_id = full_wd.index(w1)
                                                    full_wd[tmp_id] = tmp_new_wd
                                                    filled_sen[j] = '/'.join(full_wd)
                                    else:
                                        filled_sen[j] = filled_sen[j]+'/'+w+'_'+str(k)
                        k += 1
                break



file1.write('\n-----------\n')
print(' '.join(filled_sen))
file1.write((' '.join(filled_sen)))
file1.write('\n-----------\n')


total_uniq_wd = []
for i, sen in sen_df.fillna('NOWORD').iterrows():
    lsen = list(sen)
    for w in lsen:
        total_uniq_wd.append(w)

total_uniq_wd1 = list(set(total_uniq_wd))
if('NOWORD' in total_uniq_wd1):
    total_uniq_wd1.remove('NOWORD')

count_table = pd.DataFrame([total_uniq_wd1])
for i, wd in count_table.fillna('NOWORD').iterrows():
    lwd = list(wd)
    l = 0
    for w in lwd:
        m = 1
        for j, sen in sen_df.fillna('NOWORD').iterrows():
            lsen = list(sen)
            if w in lsen:
                count = len([k for k, x in enumerate(lsen) if x == w])
                count_table.loc[m,l] = count
            m += 1
        l += 1

#print(count_table.fillna('0'))
#count_table.to_csv(sys.argv[2], sep='\t', header=False, index=False)
count_table.to_csv(file1, sep='\t', header=False, index=False)


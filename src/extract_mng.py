import sys, os, re, string

eng_sent = ''
hnd_mul = ''

for line in open(sys.argv[1]):
    if 'ENG:' in line:
        eng_sent = line[5:-2]
    if '_' in line:
        hnd_mul = line.strip()

rest_dic = {}
def_dic = {}
eng_rt_dic = {}

for line in open(sys.argv[2]):
    lst = line.strip().split('\t')
    rest_dic[lst[0]] = lst[1]


for line in open(sys.argv[3]):
    if line[0] != '\t':
        lst = line.strip().split('\t')
        def_dic[lst[0]] = lst[1]

for line in open(sys.argv[4]):
    lst = line.strip().split()
    eng_rt_dic[lst[1]] = lst[2]


cop_lst_id = []
for line in open(sys.argv[5]):
    lst = line.strip().split()
    if lst[1] == 'cop':
        cop_lst_id.append(lst[3])


eng_lst = eng_sent.split()
hnd_lst = hnd_mul.split()

#print(hnd_lst)

pure_hnd_lst = []
#extract pure words
for h in hnd_lst:
    hnd = h.split('/')
    for each in hnd:
        h_wrd = each.strip(string.punctuation).split('_')
        hin = h_wrd[0].strip(';').split('<;')
        if hin[0] not in pure_hnd_lst:
            pure_hnd_lst.append(hin[0])

rt_lst = []
for each in pure_hnd_lst:
#    print(each)
    path = os.getenv('HOME_anu_test')
    morph_command = 'echo ' + each + ' | lt-proc -ca ' + path + '/bin/hi.morf.bin'
    #print(morph_command)
    out=os.popen(morph_command).readlines()
    for mo in out:
        if '*' not in mo:
            analysis = mo.split('/')
    #        print(analysis)
            for item in analysis:
                if '<' in item:
                    rt = re.findall(r'[^<]+<cat', item)
    #                print(rt)
                    if rt[0][:-4] not in rt_lst:
                        rt_lst.append(rt[0][:-4])
   # print(rt_lst)

#print(eng_rt_dic.keys())
#print(eng_rt_dic.values())
mng_dic = {}
for i in range(0, len(eng_lst)):
    val = []
#    print(def_dic.keys())
  #  print(i)
    if eng_lst[i] not in rest_dic.keys() and eng_lst[i] in def_dic.keys()  or (str(i+1) in eng_rt_dic.keys() and eng_rt_dic[str(i+1)] in def_dic.keys()):
        if eng_lst[i] in def_dic.keys():
            m = def_dic[eng_lst[i]].split('/')
            for each in m :
              if each not in val:
                val.append(each)
        if str(i+1) in eng_rt_dic.keys() and eng_rt_dic[str(i+1)] in def_dic.keys():
            m1 = def_dic[eng_rt_dic[str(i+1)]].split('/')
            for each in m1:
              if each not in val:
                val.append(each)
    elif str(i+1) in cop_lst_id:
        if eng_lst[i+1] in def_dic.keys() and i != len(eng_lst):
            m = def_dic[eng_lst[i+1]].split('/')
            for each in m :
                if each not in val:
                   val.append(each)
 #           print('**', i, val)        
        if eng_rt_dic[str(i+1)] in def_dic.keys():
            m = def_dic[eng_rt_dic[str(i+1)]].split('/')
            for each in m :
                if each not in val:
                   val.append(each)
#            print('&&', i, val)        
    elif eng_lst[i] in rest_dic.keys():
        m = rest_dic[eng_lst[i]].split('/')
        for each in m :
            if each not in val:
                val.append(each)
    for h in hnd_lst:
        hnd = h.split('/')
        for j in hnd:
            k = j.split('_')
            if k[0] in val:
                #if i-1 not in mng_dic.keys():
                if i not in mng_dic.keys():
                    mng_dic[i] = k[0]
                else:
                    if k[0] not in mng_dic[i].split('/'):
                        mng_dic[i] = mng_dic[i] + '/' + k[0] 

 #              print(i, eng_lst[i] , k[0])
    for rt in rt_lst:
        if rt in val:
            if i not in mng_dic.keys():
                    mng_dic[i] = rt
            else:
                if rt not in mng_dic[i].split('/'):
                    mng_dic[i] = mng_dic[i] + '/' + rt


 
mng_lst = []
#print(mng_dic.values())
for i in range(0, len(eng_lst)): 
    if i in mng_dic.keys():
        mng_lst.append(mng_dic[i])
    else:
        mng_lst.append('0')


print('Multiple_NMT\t' + '\t'.join(mng_lst))


        


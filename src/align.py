import sys, re, os, string
import dbm.gnu
#import pandas as pd
#import numpy as np

f = open(sys.argv[1], 'r').readlines()
fw = open('word.dat', 'r').readlines()
fr = open('root.dat', 'r').readlines()
dbm = dbm.gnu.open(sys.argv[2], 'r')

#pd.set_option('display.max_rows', 1000)
#pd.set_option('display.max_columns', 1000)
fm = open("sampark_morph.dat", "a")


eng_sent = ''
hnd_sent = ''
rt_dic = {}
w_dic = {}
w_rt_dic = {}
r_dic = {}

#word data
for i in range(len(fw)):
    w_lst = fw[i][:-2].split()
    w_dic[int(w_lst[1])] = w_lst[2]

#root data
for i in range(len(fr)):
    r_lst = fr[i][:-2].split()
    rt_dic[int(r_lst[1])] = r_lst[2]

#r_dic = sorted(rt_dic).copy()
#print(r_dic)
#print(w_dic.keys())
#data = {'Key': list(w_dic.keys()), 'Word': list(w_dic.values()), 'Root': r_dic.values()}
#df = pd.DataFrame(data)

##store root and word in a dic
for key in sorted(rt_dic):
    if w_dic[key] not in w_rt_dic.keys():
        w_rt_dic[w_dic[key]] = str(key) + ':' + rt_dic[key]
    else:
        a = w_rt_dic[w_dic[key]].split(':')
        if a[1] == rt_dic[key]:
            w_rt_dic[w_dic[key]] = str(key)+'/'+ a[0] + ':' + rt_dic[key]
        #else: case need to be written   

# Print `df`
#print(df)



#print(w_rt_dic)
#extracting eng and hindi sent
for i in range(len(f)):
    if i == 0:
        eng_sent = f[i][12:-1].strip(string.punctuation)
    if i == len(f)-1:
        hnd_sent = f[i][20:-1].strip(string.punctuation)

eng = eng_sent.split()
hnd = hnd_sent.split()
#print(hnd)
h_rt_lst = []
h_w_rt_dic = {}
#extract morph info
for each in hnd:
    path = os.getenv('HOME_anu_test')
    morph_command = 'echo ' + each.strip(string.punctuation) + ' |  apertium-destxt | lt-proc -ca ' + path + '/bin/hi.morf.bin | apertium-retxt'
#    print(morph_command)
    out=os.popen(morph_command).readlines()
   # print(out)
    for mo in out:
        if '*' not in mo:
            analysis = mo.split('/')
            for item in analysis:
                if '<' in item:
                    rt = re.findall(r'[^<]+<cat', item)
                    if rt[0][:-4] not in h_rt_lst:
                        h_rt_lst.append(rt[0][:-4])
                        h_w_rt_dic[rt[0][:-4]] = each
        else:
#            print(mo, each)
            path = os.getenv('setu')

            #o = 'echo 1	' + each.strip(string.punctuation) + ' | sh ' + path + '/bin/sl/morph/hin/morph_run.sh'
            f = open(path + '/bin/sl/morph/hin/t' , 'w')
            f.write('1\t' + each.strip(string.punctuation)+'\n')
            #o = 'echo '+ '1' + '	' + each.strip(string.punctuation) +  ' > ' + path + '/bin/sl/morph/hin/t'
            #os.popen(o).readlines()
            sam_m_comm = 'sh ' + path + '/bin/sl/morph/hin/morph_run.sh ' + path + '/bin/sl/morph/hin/t'
            #print(sam_m_comm)
            f.close()
            m_out=os.popen(sam_m_comm).readlines()
            r = m_out[0].split('\t')
            #(man_word-root-cat      sUcanA  sUcanA  n)
            #print(r)
            mo = r[3].split('|')
            for anal in mo:
                r_lst = anal.split(',')
                rt = r_lst[0][8:]
                cat = r_lst[1]
             #   print('(man_word-root-cat\t' + each.strip(string.punctuation) + ' ' + rt + ' ' + cat + ')')
                fm.write('(man_word-root-cat\t' + each.strip(string.punctuation) + ' ' + rt + ' ' + cat + ')\n')
                h_w_rt_dic[rt] = each
                h_rt_lst.append(rt)

            
            #print(m_out)
#




#print(h_rt_lst)
kA_lst = ['kA', 'ke', 'kI']
#Check mng present or not
def check_mng(lst):
    #print(lst, hnd, h_rt_lst)
    for each in lst:
        a = each.split('_')
        if each in hnd:
            return each
        elif each in h_rt_lst:
            return each
        elif a[0] in hnd and a[0] not in kA_lst:
            return each
        elif a[0] in h_rt_lst and a[0] not in kA_lst:
            return each
        elif a[0] in kA_lst and a[1] in hnd:
            return each
        elif a[0] in kA_lst and a[1] in h_rt_lst:
            return each


for each in eng:
    #rt = w_rt_dic[each.lower()]
    #print('RTTT', rt)
  if each.lower().strip(string.punctuation) in w_rt_dic.keys():  
    wrd = w_rt_dic[each.lower().strip(string.punctuation)].split(':')
#    print(wrd)
    if each.lower() in dbm:
        val = dbm.get(wrd[1] , b'not present')
        value = val.decode("utf-8")

        #print(each.lower(), value)
        item = value.split('/')
        out = check_mng(item)
        #print('OUTTT', out)
        if out != None:
            if '/' not in wrd[0] and out in h_w_rt_dic.keys():
                print('(id-wrd-h_mng', wrd[0], each, h_w_rt_dic[out],')') #available
            elif '/' not in wrd[0]:
                print('(id-wrd-h_mng', wrd[0], each, out,')')
            else:
                a = wrd[0].split('/')
                for ids in a:
                    if out in h_w_rt_dic.keys():
                        print('(id-wrd-h_mng', ids, each, h_w_rt_dic[out],')') #available
                    else: #e1, 2.2 more -> aXika
                        print('(id-wrd-h_mng', ids, each, out,')')


    elif w_rt_dic[each.lower().strip(string.punctuation)] in dbm:
        val = dbm.get(wrd[1], b'not present')
        value = val.decode("utf-8")

        item = value.split('/')
        out = check_mng(item)
        if out != None:
            #print('&&', wrd[0], each, out)
            print('(id-wrd-h_mng', wrd[0], each, h_w_rt_dic[out],')')



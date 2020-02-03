import sys, string, subprocess

few = open("e", "w")
fhw = open("h", "w")

exc_dic = {}

#Calling Exception dic:
for line in open(sys.argv[3]):
    if line[0] != '#':
        lst = line.strip().split('\t')
        exc_dic[lst[0]] = lst[1]

#Func to separate punctuations and extract pure words which are not in above exception dic
def extract_pure_wrds(lst):
    new_lst = []
    for each in lst:
        wrd = each.strip(string.punctuation)
        if wrd not in exc_dic.keys():
            new_lst.append(wrd)
        else:
            print('(eng_wrd-transliterate_wrd', wrd, exc_dic[wrd], ')')
    return new_lst    
            
#English Corpus
for line in open(sys.argv[1]):
    lst = line.strip().split()
    o = extract_pure_wrds(lst)
    few.write(' '.join(o)+'\n')

#Hindi Corpus
for line in open(sys.argv[2]):
    lst = line.strip().split()
    o = extract_pure_wrds(lst)
    fhw.write(' '.join(o)+'\n')

few.close()
fhw.close()

fer = open("e", "r").readlines()
fhr = open("h", "r").readlines()


for i in range(0, len(fer)):
    e_lst = fer[i].split()
    h_lst = fhr[i].split()
    for e_wrd in e_lst:
        for h_wrd in h_lst:
            cmd = 'python2.7  check_transliteration.py ' + e_wrd + ' ' + h_wrd + ' Sound-dic.txt'
#            print(cmd)
            out = subprocess.getoutput(cmd)
#            print(out)
            if out == 'Given word is transliterate word':
                print('(eng_wrd-transliterate_wrd', e_wrd, h_wrd, ')')

few.close()
fhw.close()
 

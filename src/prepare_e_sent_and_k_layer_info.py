import sys, re, os

e_sent = []
Eng_sent = []
Hnd_sent = []

f = open(sys.argv[3], 'w')

for line in open(sys.argv[1]):
    lst = line[:-2].split()
    e_sent.append(lst[1]+'_'+lst[2])
    Eng_sent.append(lst[2])

f.write('ENG:'+'\t'+' '.join(Eng_sent)+ '\n')

with open('manual_id_mapped.dat', 'r') as nmt:
    for line in nmt:
       lst = line[:-2].split()
       Hnd_sent.append(lst[2])

f.write('NMT:'+'\t'+' '.join(Hnd_sent)+ '\n')

print('English_Sentence'+'\t'+'\t'.join(e_sent))
length = len(e_sent)

K_layer_info_dic = {}

K_layer_info = []
for line in open(sys.argv[2]):
    lst = line[:-2].strip().split()
    mng = lst[2:]
    if '@PUNCT-OpenParen' in mng:
        mng = re.sub('@PUNCT-OpenParen@PUNCT-OpenParen', '((', mng)
    if '@PUNCT-ClosedParen' in mng:
        mng = re.sub('@PUNCT-ClosedParen@PUNCT-ClosedParen', '))', mng)
    if len(lst) <= 2:    
        mng = '-'
    K_layer_info_dic[int(lst[1])] =  ' '.join(mng)



for i in range(0, length):
    if i+1 in K_layer_info_dic.keys():
        K_layer_info.append(str(i+1)+'_'+ K_layer_info_dic[i+1])
    else:
        K_layer_info.append('-')

command = 'echo  " ' + '\t'.join(K_layer_info) + '" | wx_utf8' 
#print(command)
out=os.popen(command).readlines()
#print(out)

#print('Anusaaraka Translation' +'\t' + '\t'.join(K_layer_info)), 
print('Anusaaraka Translation' +'\t' + '\t'.join(out).strip()), 
           








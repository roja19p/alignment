import sys, string, re

count = 0
eng_clau = open("eng_clause_word.dat", "w")
hnd_clau = open("hnd_clause_word.dat", "w")

for line in open(sys.argv[1]):
    if 'English' in line:
        lst = line[12:-1].split()
        for each in lst:
            count += 1
            wrd = each.strip(string.punctuation)
            eng_clau.write('(id-clause_wrd '+ str(count) + ' ' + wrd.lower() + ')\n')
    if 'Output 1 from NMT' in line:
         h_count = 0
         lst = line[20:-1].split()
         for each in lst:
            h_count += 1
            wrd = each.strip(string.punctuation)
            wrd = re.sub('Z','',wrd)
            hnd_clau.write('(id-hnd_clause_wrd '+ str(h_count) + ' ' + wrd + ')\n')
            print('(hindi_head_id-grp_ids '+ str(h_count) + ' ' + str(h_count) + ')')

r_lst = []
for i in range(count):
    r_lst.append('0')

print('(iter-h_g_id  0', ' '.join(r_lst), ')')

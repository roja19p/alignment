#Written by Roja(25-07-17)
#RUN:: python get_sound_dic.py <sound_dic_with_ex> > <sound-dic>
#Ex::  python get_sound_dic.py sounds.txt > Sound_dic.txt
#################################################################### 
import sys

dic = {}

for line in open(sys.argv[1]):
	if line[0] != '\n' and line[0] != '#':
#		print line.strip()
		lst = line.strip().split('\t')
		if len(lst) == 2:
			sound = lst[1].split('-')
			key = lst[0]
			dic[key] = sound[0]
		else:
			sound = lst[0].split('-')
			dic[key] = dic[key] + '/' + sound[0]

for key in sorted(dic):
	print(key + '\t' + dic[key])

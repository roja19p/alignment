#Create facst from Soumya grouping
#Written by Roja(02-12-19)
#For Eng:::
#python3 $HOME_alignment/src/create_facts_from_grouping.py E_Word_Group_Sanity.dat Eng E_grouping_wrd.dat > E_grouping.dat
#For Hnd:::
#python3 $HOME_alignment/src/create_facts_from_grouping.py H_Word_Group.dat Hnd H_grouping_wrd.dat  >  H_grouping.dat 
#################################################################
import sys,re
count = 0
fact_name = str(sys.argv[2])
wrd_f = open(sys.argv[3], 'w')

for line in open(sys.argv[1]):
    ids = re.findall(r'grp_elements_ids [^)]+', line)
    wrds = re.findall(r'grp_element_words [^)]+', line)

    count += 1
    print('('+ fact_name + '_label-group_elements', count, ' '.join(ids[0].split()[1:]), ')')
    wrd_f.write('('+ fact_name + '_label-group_words ' +  str(count) + ' '+ ' '.join(wrds[0].split()[1:]) + ')\n')


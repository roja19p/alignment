import re, sys
import config
from hari_common_file_fumctions import read_a_file_line_by_line
from hari_common_file_fumctions import return_list_of_lines
from hari_common_string_fumctions import return_inserted_string
from hari_transform import list_to_string
from hari_transform import string_to_words
from hari_lst_strng_common_fns import safe_index
from hari_lst_strng_common_fns import id_symbol_to_wrds_indx_x
from hari_lst_strng_common_fns import id_symbol_to_wrds_indx_h
from hari_lst_strng_common_fns import id_symbol_to_wrds_indx
from hari_lst_strng_common_fns import id_symbol_to_wrds
from hari_common_list_functions import print_one_element_per_line

Lines=read_a_file_line_by_line(sys.argv[1])
#Lines=read_a_file_line_by_line("../output_fat_boy_ripe_banana")
#Lines=read_a_file_line_by_line("../output_every_dog_chases_some_white_cat")
#Lines=read_a_file_line_by_line("../output_fat_boy_ripe_banana")
#Lines=read_a_file_line_by_line("../output_killing_by_process_id_is")
#Lines=read_a_file_line_by_line("../output_The_dream_of_making_a_computer_imitate_humans_also_has_a_very_early_history")
#Lines=read_a_file_line_by_line("../better_compound_parse")
#Lines=read_a_file_line_by_line("../output_roja1")
#Lines=read_a_file_line_by_line("../output_roja2")
#Lines=read_a_file_line_by_line("../output_roja3")
#Lines=read_a_file_line_by_line("../output_roja10")
#Lines=read_a_file_line_by_line("../output_roja11")
#Lines=read_a_file_line_by_line("../output_roja12")
#Lines=read_a_file_line_by_line("../output_roja13")
#Lines=read_a_file_line_by_line("../output_ever_find")
#Lines=read_a_file_line_by_line("../output_agent_action_goal")
#Lines=read_a_file_line_by_line("../output_books_are_selling")
#Lines=read_a_file_line_by_line("../output_has_been_killed")
#Lines=read_a_file_line_by_line("../output_derivation")
#Lines=read_a_file_line_by_line("../output_ace00108")
#Lines=read_a_file_line_by_line("../output_ace00114")
#Lines=read_a_file_line_by_line("../output_give_up_smoking")
#Lines=read_a_file_line_by_line("../output_roja_f_a")
#Lines=read_a_file_line_by_line("../output_roja_s_a")
#Lines=read_a_file_line_by_line("../output_roja_bug_1")
#Lines=read_a_file_line_by_line("../output_intransitive_verb")
#Lines=read_a_file_line_by_line("../output_police1")
#Lines=read_a_file_line_by_line("../output_delphin1")
#sentence=Lines[0]
#print("hari")
list_of_lines=return_list_of_lines(Lines)
old_list_of_lines=return_list_of_lines(Lines)
str_LTOP=list_of_lines[1]
print(str_LTOP[2:])
str_INDEX=list_of_lines[2]
print(str_INDEX[0:9])
str_HCONS = list_of_lines[-4]
print(str_HCONS)
str_ICONS = list_of_lines[-3]
#print(str_HCONS[0:-1])
print(str_ICONS[0:-1])

intermediate_list=[]
str_SENTENCE=list_of_lines[0][6:]
lst_SENTENCE=string_to_words(str_SENTENCE)
print(str_SENTENCE)
intermediate_list.append(str_SENTENCE)
str_LTOP=list_of_lines[1]
#print(str_LTOP[2:])
intermediate_list.append(str_LTOP[2:])
#print(list_of_lines[-4])
intermediate_list.append(list_of_lines[-4])
str_HCONS = list_of_lines[-4]
str_ICONS = list_of_lines[-3]
#print(str_ICONS[0:-1])
intermediate_list.append(str_ICONS[0:-1])
str_INDEX=list_of_lines[2]
#print(str_INDEX[0:9])
intermediate_list.append(str_INDEX[0:9])
string_to_be_inserted = str_INDEX[10:]
total_lines=len(list_of_lines)
first_tmp_str=list_of_lines[3]
first_RELS_string=first_tmp_str[8:]
#print("my_RELS_list_follows:")
intermediate_list.append("my_RELS_list_follows:")
#print('<')
intermediate_list.append('<')
#print(first_RELS_string)
intermediate_list.append(first_RELS_string)
list_of_RELS2_lines = list_of_lines[4:-5]
#print(list_of_RELS_lines[0].replace('<','',1))
#print(list_of_RELS_lines[-1].replace(' >',''))
RELS1_list = []
for x in list_of_RELS2_lines:
   if x.count('ARG0: e2 ') != 0:
      p=x.index('ARG0: e2 ')
      RELS1_list.append(return_inserted_string(x,string_to_be_inserted,p+8)) 
   else:
      RELS1_list.append(x)
for x in RELS1_list:
   #print(x)
   intermediate_list.append(x)
last_tmp_str=list_of_lines[-5]
last_RELS_string=last_tmp_str[:-2]
#print(last_RELS_string)
intermediate_list.append(last_RELS_string)
#print('>')
intermediate_list.append('>')
#print(intermediate_list)
#mAXava.py follows

list_of_lines=intermediate_list
# anu_ids-char_ids-mapping:
#print(sentence)

#S1.py has following line:
#print("anu_ids-char_ids_mapping:char_ids")
anu_ids=[]
char_ids=[]
i=0
while i < len(lst_SENTENCE)-1:
   #char_ids.append(str_SENTENCE.index(lst_SENTENCE[i]))+":"+len(lsr_SENTENCE[i])
   tmp_s_id = str_SENTENCE.index(lst_SENTENCE[i])
   tmp_e_id = len(lst_SENTENCE[i])+tmp_s_id
   char_ids.append(str(tmp_s_id)+":"+str(tmp_e_id))
   #anu_ids.appendi(str(i+1))
   i += 1


previous_first_number=-1
count=0
i=7
ids=[]
c_ids=[]
word=[]
LBL_val=[]
ARG0_val=[]
while i < len(intermediate_list)-1:
   start_num=intermediate_list[i].find('<')
   colon_position=intermediate_list[i].find(':')
   first_number=int(intermediate_list[i][(start_num+1):colon_position])
   end_num=intermediate_list[i].find('>')
   tmp_str='str_SENTENCE'+'['+intermediate_list[i][start_num+1:end_num]+']'
   tmp_lst=string_to_words(intermediate_list[i])
   tmp_word = eval(tmp_str)
   if first_number > previous_first_number:
      count += 1
      previous_first_number = first_number
   #S1.py has following line:
   #print("\t"+str(i-6) + "\t" + str(count) + "\t" + tmp_word + "\t" + tmp_lst[tmp_lst.index('LBL')+1] + "\t" + tmp_lst[tmp_lst.index('ARG0')+1] + "\t"+ intermediate_list[i])
   ids.append(str(i-6))
   c_ids.append(str(count))
   word.append(tmp_word)
   LBL_val.append(tmp_lst[tmp_lst.index('LBL')+1])
   ARG0_val.append(tmp_lst[tmp_lst.index('ARG0')+1]) 
#   print(i)
   i += 1


#print("IMPORTANT REMARKS:")
#print("  Takes ARGs:")

j=7
vc_pred_ids = []
ARGs_counts = []
while j < len(intermediate_list)-1:
   tmp_str=intermediate_list[j]
   tmp_lst=string_to_words(intermediate_list[j])
   #print(tmp_str.count(' ARG'),"\t",tmp_str)
   arg_count=tmp_str.count(' ARG')
   if arg_count > 1:
      #print("\t",j-6,"\t",arg_count,"\t","\t","\t","\t",tmp_lst)
      vc_pred_ids.append(j-6)
      ARGs_counts.append(arg_count)
   j += 1

#print("  Compounds:")
k=7
compound_ids=[]
compound_counts=[]
while k < len(intermediate_list)-1:
   tmp_str=intermediate_list[k]
   tmp_lst=string_to_words(intermediate_list[k])
   #print(tmp_str.count(' ARG'),"\t",tmp_str)
   compound_count = tmp_lst.count('compound')
   if compound_count > 0:
      #print("\t",k-6,"\t",compound_count,"\t","\t","\t","\t",tmp_lst)
      compound_ids.append(k-6)
      compound_counts.append(compound_count)
   k += 1

#print("  Quantifier_RSTR:")

k=7
quantifier_id=[]
quantifier_ARG0=[]
quantifier_LBL=[]
quantifier_RSTR=[]
while k < len(intermediate_list)-1:
   tmp_str=intermediate_list[k]
   tmp_lst=string_to_words(intermediate_list[k])
   #print(tmp_str.count(' ARG'),"\t",tmp_str)
   RSTR_count = tmp_lst.count('RSTR')
   if RSTR_count > 0:
      #print("\t",k-6,"\t","\t",tmp_lst[tmp_lst.index('RSTR')+1],"\t","\t","\t","\t",tmp_lst)
      quantifier_id.append(k-6)
      quantifier_ARG0.append(tmp_lst[tmp_lst.index('ARG0')+1])
      quantifier_LBL.append(tmp_lst[tmp_lst.index('LBL')+1])
      quantifier_RSTR.append(tmp_lst[tmp_lst.index('RSTR')+1])
   k += 1

#print("hara hara mahAxev",quantifier_id,quantifier_ARG0,quantifier_LBL,quantifier_RSTR)
lst_HCONS = string_to_words(str_HCONS)
tmp_str_HCONS = str_HCONS[8:-1]
modulo_quantifier_equalities = tmp_str_HCONS.replace(" qeq ","=")
print(modulo_quantifier_equalities)
lst_modulo_equalities = string_to_words(modulo_quantifier_equalities)
'''
Hint using "lst_modulo_equalities":
Because counting starts from zero so:
if index is even add 1 to it to get equal item.
if index is odd subtract 1 to it to get equal item.
'''
print("---------------------------------------------------------------------------------------------")
print("Information, in this section, is for programmers only")
print("Main_Table: ids,c_ids,word,LBL_val,ARG0_val")
print(ids,c_ids,word,LBL_val,ARG0_val) 
print("VC_PREDS:vc_pred_ids,ARGs_counts")
print(vc_pred_ids,ARGs_counts) 
print("---------------------------------------------------------------------------------------------")

#print("janArxana")
print("RELS_LIST_IDS")
clean_RELS_list=[]
clean_RELS_list.append(first_RELS_string)
for lst_item in RELS1_list:
   clean_RELS_list.append(lst_item)
clean_RELS_list.append(last_RELS_string)
enumerated_RELS_list = list(enumerate(clean_RELS_list, start=1))
#print_one_element_per_line(clean_RELS_list)
list_of_identifiers=[]
list_of_identifier_string=[]
lst_of_ids = range(1,len(ids)+1)
for i in lst_of_ids:
   word_val = word[i-1]
   root_sense_etc=clean_RELS_list[i-1][2:clean_RELS_list[i-1].find('<')]
   tmp_lbl_val = LBL_val[i-1]
   tmp_ARG0_val=ARG0_val[i-1]
 #  tmp_ARGs_count = ARGs_counts[iter_quant_round]
   #list_of_args_etc = string_to_words(clean_RELS_list[i-1])
   #print("gaNeSa",list_of_args_etc)
   char_ids_range = clean_RELS_list[i-1][clean_RELS_list[i-1].find('<'):clean_RELS_list[i-1].find('>')+1]
   list_of_args_etc = [word_val,root_sense_etc,char_ids_range,tmp_lbl_val,tmp_ARG0_val]
   my_i = 0
   my_iter = 0
   arg_val_string = ""   
   word_val_string = word_val
   list_of_identifiers.append(list_of_args_etc)

print_one_element_per_line(list_of_identifiers)
#print("sIwArAma")
RELS_identifier = {}
iter_id = 1
#for rel in clean_RELS_list:
for rel in enumerated_RELS_list:
  RELS_identifier[iter_id] = rel
  iter_id += 1 

ARG0_identifier = {}
for x in list_of_identifiers:
   match = re.search(r'_q$',x[1])
   if match == None:
      ARG0_identifier[x[-1]] = x

LBL_identifier = {}
for x in list_of_identifiers:
   LBL_identifier[x[-2]] = x

modulo_equalities = {}
i=0
while i < len(lst_modulo_equalities):
   modulo_equalities[lst_modulo_equalities[i]] = lst_modulo_equalities[i+1]
   i += 2


#WORKING
print("COMPOUNDS:compound_ids,compound_counts")
print(compound_ids,compound_counts)
for x in compound_ids:
   print(RELS_identifier[x][1][1])
   curr_s=RELS_identifier[x][1]
   n1 = curr_s.index('<')
   n2 = curr_s.index(':')
   n3 = curr_s.index('>')
   #print("curr_s=",curr_s)
   #print("n1,n2,n3",n1,n2,n3)
   print("compound=",str_SENTENCE[int(curr_s[n1+1:n2]):int(curr_s[n2+1:n3])])
print("QUANTIFIERS:quantifier_id,quantifier_ARG0,quantifier_LBL,quantifier_RSTR")
print(quantifier_id,quantifier_ARG0,quantifier_LBL,quantifier_RSTR)
#print("hari hari hari hari hari")
iter_quant_round = 0
for i in quantifier_id:
   #print(intermediate_list[i+6])
   word_val = word[i-1]
   bgn_root_sense_etc = 2
   end_root_sense_etc = intermediate_list[i+6][2:].index(" ")+2
   root_sense_etc=intermediate_list[i+6][bgn_root_sense_etc:end_root_sense_etc]
   tmp_lbl_val = LBL_val[i-1]
   tmp_ARG0_val=ARG0_val[i-1]
   list_of_args_etc = string_to_words(intermediate_list[i+6])
   my_i = 0
   my_iter = 0
   arg_val_string = ""
   #tmp_prefinal_str = word_val+"~"+root_sense_etc+"~"+tmp_lbl_val+"~"+tmp_ARG0_val+"("+ quantifier_RSTR[iter_quant_round] + ")"
   #print(tmp_prefinal_str.replace(",)",")"))
   lbl_val_tmp = quantifier_RSTR[iter_quant_round]
   #print("lbl_val_tmp=",lbl_val_tmp)
   lbl_val_arg = LBL_identifier[modulo_equalities[lbl_val_tmp]]
   tmp_prefinal_str = word_val+"~"+root_sense_etc+"~"+tmp_lbl_val+"~"+tmp_ARG0_val+"("+ str(lbl_val_arg) + ")"
   print(tmp_prefinal_str)
   iter_quant_round += 1

'''
Note:
 modulo_quantifier_lst = string_to_words(modulo_quantifier_equalities)
 modulo_quantifier_lst[modulo_quantifier_lst.index('h5')+1]
-----
tmp_s = "humans~udef_q<39:45>~h26~x25"
string_to_words(tmp_s.replace('~',' ',-1))

['humans', 'udef_q', '39', '45', 'h26', 'x25']
-----
[ _the_q<0:3> LBL: h4 ARG0: x3 [ x PERS: 3 NUM: sg IND: + ] RSTR: h5 BODY: h6 ]
['[ _dream_n_1<4:9> LBL: h7 ARG0: x3 ]', '[ _of_p<10:12> LBL: h7 ARG0: e8 [ e SF: prop TENSE: untensed MOOD: indicative PROG: - PERF: - ] ARG1: x3 ARG2: x9 ]', '[ udef_q<13:45> LBL: h10 ARG0: x9 RSTR: h11 BODY: h12 ]', '[ nominalization<13:45> LBL: h13 ARG0: x9 ARG1: h14 ]', '[ _make_v_cause<13:19> LBL: h14 ARG0: e15 [ e SF: prop TENSE: untensed MOOD: indicative PROG: + PERF: - ] ARG1: i16 ARG2: h17 ]', '[ _a_q<20:21> LBL: h18 ARG0: x19 [ x PERS: 3 NUM: sg IND: + ] RSTR: h20 BODY: h21 ]', '[ _computer_n_1<22:30> LBL: h22 ARG0: x19 ]', '[ _imitate_v_1<31:38> LBL: h23 ARG0: e24 [ e SF: prop TENSE: untensed MOOD: indicative PROG: - PERF: - ] ARG1: x19 ARG2: x25 [ x PERS: 3 NUM: pl IND: + ] ]', '[ udef_q<39:45> LBL: h26 ARG0: x25 RSTR: h27 BODY: h28 ]', '[ _human_n_1<39:45> LBL: h29 ARG0: x25 ]', '[ _also_a_1<46:50> LBL: h1 ARG0: i30 ARG1: h31 ]', '[ _have_v_1<51:54> LBL: h32 ARG0: e2 [ e SF: prop TENSE: pres MOOD: indicative PROG: - PERF: - ] ARG1: x3 ARG2: x33 [ x PERS: 3 NUM: sg IND: + ] ]', '[ _a_q<55:56> LBL: h34 ARG0: x33 RSTR: h35 BODY: h36 ]', '[ _very_x_deg<57:61> LBL: h37 ARG0: e38 [ e SF: prop TENSE: untensed MOOD: indicative PROG: - PERF: - ] ARG1: e39 [ e SF: prop TENSE: untensed MOOD: indicative PROG: bool PERF: - ] ]', '[ _early_a_1<62:67> LBL: h37 ARG0: e39 ARG1: x33 ]']

'''
print('###################################################################################################')
iter_round = 0
#print("rAma")
print("RELS with ARGUMENTS")
for i in vc_pred_ids:
   #print(intermediate_list[i+6])
   word_val = word[i-1]
   bgn_root_sense_etc = 2
   end_root_sense_etc = intermediate_list[i+6][2:].index(" ")+2
   root_sense_etc=intermediate_list[i+6][bgn_root_sense_etc:end_root_sense_etc]
   tmp_lbl_val = LBL_val[i-1]
   tmp_ARG0_val=ARG0_val[i-1]
   #print("hari",tmp_ARG0_val)
   tmp_ARGs_count = ARGs_counts[iter_round]
   list_of_args_etc = string_to_words(intermediate_list[i+6])
   my_i = 0
   my_iter = 0
   arg_val_string = ""
   while my_i < tmp_ARGs_count-1:
      arg_string = "ARG"+str(my_i+1)
      tmp_arg_val=list_of_args_etc[list_of_args_etc.index(arg_string)+1]
      arg_val_str=str(tmp_arg_val)
      #print("arg_val_str=", arg_val_str)
      if arg_val_str[0] != 'h' and arg_val_str[0] != 'i' and arg_val_str[0] != 'u':
         arg_val=ARG0_identifier[arg_val_str]
      if arg_val_str[0] != 'h' and arg_val_str[0] == 'i' or arg_val_str[0] == 'u':
         arg_val="'"+arg_val_str+"_?" + "'"
      if arg_val_str[0] == 'h':
         if arg_val_str in LBL_identifier: arg_val = LBL_identifier[arg_val_str]; #print("gaNapawi1",arg_val)
         else: arg_val=LBL_identifier[modulo_equalities[arg_val_str]]; #print("gaNapawi2",arg_val)
      arg_val_string = arg_val_string + str(arg_val) + ","
      my_i += 1
   tmp_prefinal_str = word_val+"~"+root_sense_etc+"~"+tmp_lbl_val+"~"+tmp_ARG0_val+"("+ arg_val_string + ")"
   print(tmp_prefinal_str.replace(",)",")"))
   iter_round += 1

print()
print("Note:")
print("For TAM or GNP Information use tam_gnp dictionary e.g. tam_gnp['x3']")
print('###################################################################################################')
#print(ARG0_val)
#print(LBL_val)
#print(word)
RELS_list = intermediate_list[7:len(intermediate_list)-1]
'''
'h77' in LBL_identifier
'h41' in LBL_identifier
'''
lst = ['[ _a_q<0:1> LBL: h4 ARG0: x3 [ x PERS: 3 NUM: sg IND: + ] RSTR: h5 BODY: h6 ]', '[ _fat_a_1<2:5> LBL: h7 ARG0: e8 [ e SF: prop TENSE: untensed MOOD: indicative PROG: bool PERF: - ] ARG1: x3 ]', '[ _boy_n_1<6:9> LBL: h7 ARG0: x3 ]', '[ _have_v_qmodal-2<10:13> LBL: h1 ARG0: e2 [ e SF: prop TENSE: past MOOD: indicative PROG: - PERF: - ] ARG1: h9 ]', '[ _eat_v_1<17:20> LBL: h10 ARG0: e11 [ e SF: prop-or-ques TENSE: untensed MOOD: indicative PROG: - PERF: - ] ARG1: x3 ARG2: x12 [ x PERS: 3 NUM: pl IND: + ] ]', '[ udef_q<21:28> LBL: h13 ARG0: x12 RSTR: h14 BODY: h15 ]', '[ _fruit_n_1<21:28> LBL: h16 ARG0: x12 ]']
#clean_RELS_list = lst

#list_of_identifiers = [['A', '_a_q', '<0:1>', 'h4', 'x3'], ['fat', '_fat_a_1', '<2:5>', 'h7', 'e8'], ['boy', '_boy_n_1', '<6:9>', 'h7', 'x3'], ['had', '_have_v_qmodal-2', '<10:13>', 'h1', 'e2'], ['eat', '_eat_v_1', '<17:20>', 'h10', 'e11'], ['fruits.', 'udef_q', '<21:28>', 'h13', 'x12'], ['fruits.', '_fruit_n_1', '<21:28>', 'h16', 'x12']]
list_of_ARG0_vals = []
for x in list_of_identifiers:
   #print(x[4])
   list_of_ARG0_vals.append(x[4])

#print(list_of_ARG0_vals)

s1 = set(list_of_ARG0_vals)
l1 = list(s1) # list_of_ARG0_vals_without_repeatitions

#print(l1)

def dict_of_arg0(list_of_ARG0_vals):

   tam_gnp_part = {}
   count=0
   for x in clean_RELS_list:
      tmp_str = "ARG0: " + list_of_ARG0_vals[count] + " [ "
      if x.find(tmp_str) != -1:
         #strt_num = 20
         strt_num = x.find('<')
         end_num = x[strt_num:].find(']')
         tam_gnp_part[list_of_ARG0_vals[count]] = x[strt_num:strt_num+end_num+1]
      count += 1
   return(tam_gnp_part)

tam_gnp_part = dict_of_arg0(list_of_ARG0_vals)

lp=eval(str(tam_gnp_part.keys())[10:-1])
#print(lp)
sp = set(lp)
remaining_ARG0_vals = list(s1 - sp)
#print(remaining_ARG0_vals)
long_string = ""
for x in clean_RELS_list:
   long_string = long_string + x

tam_gnp = {}
for x in remaining_ARG0_vals:
   strt_num = long_string.find(': ' +x+ " [")
   end_num = long_string[strt_num:].find(']')
   tam_gnp[x] = long_string[strt_num+2:strt_num+end_num+1] 

print("initial tam_gnp before update:", tam_gnp)
tam_gnp.update(tam_gnp_part)
print("tam_gnp_dump=",tam_gnp)
print("string_to_be_inserted=", string_to_be_inserted)

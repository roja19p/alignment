MYPATH=$HOME_alignment
#To generate P2 layer
echo "Generating P2 layer ..."
#map manual_word.dat
python3 $MYPATH/map_par_id_to_wrdid.py manual_word.dat  manual_id_mapped.dat manual_id_wrdid.dat

echo "Extracting root info for manual..."
python3 $MYPATH/get_manual_root.py  manual_id_wrdid.dat manual_lwg_new.dat > manual_mapped_id_root_info.dat

#Create Eng and Hindi Soumya grouping facts
python3 $MYPATH/create_facts_from_grouping.py E_Word_Group_Sanity.dat Eng > E_grouping.dat
python3 $MYPATH/create_facts_from_grouping.py H_Word_Group.dat Hnd > H_grouping.dat

#Get each word with count of occurences
python3 $MYPATH/check_each_word_occurences.py eng_wrd_occurence.dat hnd_wrd_occurence.dat

python3 $MYPATH/map_punctuations_in_conll.py E_conll_parse_enhanced > E_conll_enhanced_without_punc.tsv
python3 $MYPATH/map_punctuations_in_conll.py hindi_dep_parser_original.dat > hindi_dep_parser_original_without_punc.tsv

#Get parent sanwawi info 
#bash $MYPATH/get_parent_sanwawi.sh Eng Hnd   

#Get kriyA_mUla info from Hindi sentence:
python3 $MYPATH/check_for_kriyA_mUla.py manual_mapped_id_root_info.dat $MYPATH/dics/kriyA_mUla_default_dic.txt > kriyA_mUla_info.dat

#Get anchors:
python3 $MYPATH/map_slot_debug_info.py manual_id_wrdid.dat slot_debug_input.txt  > slot_debug_input_mapped.txt
python3 $MYPATH/get_anch_and_pot_info.py slot_debug_input_mapped.txt word.dat  manual_id_mapped.dat  > anchor.dat

#Create conll facts 
python3 $MYPATH/create_facts_from_conll.py E_conll_enhanced_without_punc.tsv eng > eng_conll_facts.dat
python3 $MYPATH/create_facts_from_conll.py hindi_dep_parser_original_without_punc.tsv hnd > hnd_conll_facts.dat

python3 $MYPATH/get_root_frm_conll.py E_conll_enhanced_without_punc.tsv > eng_conll_root.dat

#Generating P1 layer
echo "(defglobal ?*path* = $MYPATH)" > alignment_path.clp
timeout 100 myclips -f $MYPATH/run.bat > new_layer.error

sed -i 's/dummy //g' new_layer_p2.dat
#Converting P2 layer fact to csv 
python3 $MYPATH/convert_new_layer_fact_to_csv.py new_layer_p2.dat P2 > p2_layer.csv

python3 $MYPATH/get_left_over_wrds.py p2_layer.csv  P2 > p2_left_over_wrds.dat

#Replacing new layer id with id_wrd format
python3 $MYPATH/replace_id_with_wrd.py   manual_id_mapped.dat p2_layer.csv P2 > p2_layer_with_wrd.csv


#For debugging purpose 
python3 $MYPATH/get_hindi_sentence_with_id_wrd.py  manual_id_mapped.dat > H_sentence_with_ids.dat
wx_utf8 < H_sentence_with_ids.dat > H_sentence_with_ids_utf8.dat

python3 $MYPATH/group.py E_grouping.dat English_grouping > E_grouping.tsv
python3 $MYPATH/group.py H_grouping.dat Hindi_grouping > H_grouping.tsv

sed 's/(//g' p2_left_over_wrds.dat | sed 's/)//g' | sed 's/ /,/g'> p2_left_over_wrds.txt
sed 's/,/\t/g' p2_layer_with_wrd.csv > p2_layer_with_wrd.tsv
wx_utf8 < p2_layer_with_wrd.tsv > p2_layer_with_wrd_utf8.tsv

python3 $MYPATH/prepare_e_sent_and_k_layer_info.py original_word.dat  id_Apertium_output.dat > info.tsv

cat H_sentence_with_ids.dat  H_grouping.tsv E_grouping.tsv info.tsv p2_layer_with_wrd.tsv p2_left_over_wrds.txt > Complete_alignment.csv
cat H_sentence_with_ids_utf8.dat  H_grouping.tsv E_grouping.tsv info.tsv p2_layer_with_wrd_utf8.tsv p2_left_over_wrds.txt > Complete_alignment_utf8.csv

####################

#To generate P2 layer
echo "Generating P2 layer ..."
#map manual_word.dat
python3 $HOME_alignment/src/map_par_id_to_wrdid.py manual_word.dat  manual_id_mapped.dat manual_id_wrdid.dat

echo "Extracting root info for manual..."
python3 $HOME_alignment/src/get_manual_root.py  manual_id_wrdid.dat manual_lwg_new.dat > manual_mapped_id_root_info.dat

#Create Eng and Hindi Soumya grouping facts
python3 $HOME_alignment/src/create_facts_from_grouping.py E_Word_Group_Sanity.dat Eng E_grouping_wrd.dat > E_grouping.dat
python3 $HOME_alignment/src/create_facts_from_grouping.py H_Word_Group.dat Hnd H_grouping_wrd.dat > H_grouping.dat

#Get each word with count of occurences
python3 $HOME_alignment/src/check_each_word_occurences.py eng_wrd_occurence.dat hnd_wrd_occurence.dat

python3 $HOME_alignment/src/map_punctuations_in_conll.py E_conll_parse_enhanced > E_conll_enhanced_without_punc.tsv
python3 $HOME_alignment/src/map_punctuations_in_conll.py hindi_dep_parser_original.dat > hindi_dep_parser_original_without_punc.tsv

#Get parent sanwawi info 
bash $HOME_alignment/shell_scripts/get_parent_sanwawi.sh Eng Hnd   

#Repeated info :
python3  $HOME_alignment/src/get_repeated_info.py > repeated_ids.dat

#Get kriyA_mUla info from Hindi sentence:
python3 $HOME_alignment/src/check_for_kriyA_mUla.py manual_mapped_id_root_info.dat $HOME_alignment/dics/kriyA_mUla_default_dic.txt > kriyA_mUla_info.dat

#Get tam info 
bash $HOME_alignment/extract_rt_and_tam/run.sh

#Get anchors:
python3 $HOME_alignment/src/map_slot_debug_info.py manual_id_wrdid.dat slot_debug_input.txt  > slot_debug_input_mapped.txt
python3 $HOME_alignment/src/get_anch_and_pot_info.py slot_debug_input_mapped.txt word.dat  manual_id_mapped.dat  > anchor_tmp.dat

#Create conll facts 
python3 $HOME_alignment/src/create_facts_from_conll.py E_conll_enhanced_without_punc.tsv eng > eng_conll_facts.dat
python3 $HOME_alignment/src/create_facts_from_conll.py hindi_dep_parser_original_without_punc.tsv hnd > hnd_conll_facts.dat

python3 $HOME_alignment/src/get_root_frm_conll.py E_conll_enhanced_without_punc.tsv > eng_conll_root.dat

python3  $HOME_alignment/src/map_std_dep.py new_version_std.dat > eng_std_facts.dat

#Generating P1 layer
echo "(defglobal ?*path* = $HOME_alignment)" > alignment_path.clp
timeout 500 myclips -f $HOME_alignment/clp_files/run.bat > new_layer.error

sed -i 's/dummy //g' new_layer_p2.dat
#Converting P2 layer fact to csv 
python3 $HOME_alignment/src/convert_new_layer_fact_to_csv.py new_layer_p2.dat P2 > p2_layer.csv

python3 $HOME_alignment/src/get_left_over_wrds.py p2_layer.csv  P2 manual_id_mapped.dat > p2_left_over_wrds.dat
python3 $HOME_alignment/src/convert_new_layer_fact_to_csv.py p2_left_over_wrds.dat P2_left_over_ids > p2_left_over_wrds.csv

#P layer info:
python3 $HOME_alignment/src/P_layer_info.py
python3 $HOME_alignment/src/replace_id_with_wrd.py   manual_word.dat p_layer.csv P > p_layer_with_wrd.csv


#Replacing new layer id with id_wrd format
python3 $HOME_alignment/src/replace_id_with_wrd.py   manual_id_mapped.dat p2_layer.csv P2 > p2_layer_with_wrd.csv
python3 $HOME_alignment/src/replace_id_with_wrd.py   manual_id_mapped.dat p2_left_over_wrds.csv P2_left_over_ids > p2_left_over_wrds_with_ids.dat


#For debugging purpose 
python3 $HOME_alignment/src/get_hindi_sentence_with_id_wrd.py  manual_id_mapped.dat > H_sentence_with_ids.dat
wx_utf8 < H_sentence_with_ids.dat > H_sentence_with_ids_utf8.dat

python3 $HOME_alignment/src/group.py E_grouping.dat English_grouping > E_grouping.tsv
python3 $HOME_alignment/src/group.py H_grouping.dat Hindi_grouping > H_grouping.tsv

sed 's/(//g' p2_left_over_wrds_with_ids.dat | sed 's/)//g' | sed 's/ /,/g'> p2_left_over_wrds.txt
sed 's/,/\t/g' p_layer_with_wrd.csv > p_layer_with_wrd.tsv
sed 's/,/\t/g' p2_layer_with_wrd.csv > p2_layer_with_wrd.tsv
sed 's/,/\t/g' p2_left_over_wrds.txt > p2_left_over_wrds.tsv


python3 $HOME_alignment/src/prepare_e_sent_and_k_layer_info.py original_word.dat  id_Apertium_output.dat  sentence_info.txt anu_trn.txt > info.tsv

#cat H_sentence_with_ids.dat  H_grouping.tsv E_grouping.tsv info.tsv p_layer_with_wrd.tsv p2_layer_with_wrd.tsv p2_left_over_wrds.txt > Complete_alignment.csv
cat info.tsv p2_layer_with_wrd.tsv p_layer_with_wrd.tsv p2_left_over_wrds.tsv H_sentence_with_ids.dat H_grouping.tsv E_grouping.tsv > Complete_alignment.csv
#cat H_sentence_with_ids_utf8.dat  H_grouping.tsv E_grouping.tsv info.tsv p_layer_with_wrd_utf8.tsv p2_layer_with_wrd_utf8.tsv p2_left_over_wrds.txt > Complete_alignment_utf8.csv

sed -i 's/P\t/@P\t/'  p_layer_with_wrd.tsv
sed -i 's/P2\t/@P2\t/'  p2_layer_with_wrd.tsv
sed -i 's/P2_left_over_ids/@P2_@left_@over_@ids/'  p2_left_over_wrds.tsv

wx_utf8 < p_layer_with_wrd.tsv > p_layer_with_wrd_utf8.tsv
wx_utf8 < p2_layer_with_wrd.tsv > p2_layer_with_wrd_utf8.tsv
wx_utf8 < p2_left_over_wrds.tsv > p2_left_over_wrds_utf8.tsv

#cat info.tsv p2_layer_with_wrd_utf8.tsv p_layer_with_wrd_utf8.tsv p2_left_over_wrds_utf8.tsv H_sentence_with_ids_utf8.dat  H_grouping.tsv E_grouping.tsv > Complete_alignment_utf8.csv

cat info.tsv H_sentence_with_ids_utf8.dat anu_trn.txt p2_layer_with_wrd_utf8.tsv p_layer_with_wrd_utf8.tsv p2_left_over_wrds_utf8.tsv H_grouping.tsv E_grouping.tsv  > p2_alignment_utf8.csv
####################

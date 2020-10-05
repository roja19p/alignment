
MYPATH=$2

#cd $MYPATH
#utf8_wx  $HOME/vandan/m/output/$1  > $1.wx1

#grep -v "NMT:$" $HOME/Examples/$1.wx > $1.wx2

#python3 $HOME/vandan/pick_nmt.py  $1.wx2 > $1.wx1

python3 $HOME_alignment/src/combine1.py $MYPATH/mul_nmt_files/$1.wx $1.table > $1 

sed -i 's/English --> /ENG: /' $1

sh $HOME_alignment/shell_scripts/generate_P2_layer.sh

#cd $HOME/sens
mkdir -p canonical
grep -v "ENG" $1 > canonical/$1_h
grep  "ENG" $1 > canonical/$1_e

sed -i 's/NMT/@NMT/g' canonical/$1_h
$HOME_anu_test/Anu_data/canonical_form_dictionary/canonical_form.out   < canonical/$1_h  >  canonical/tmp
$HOME_anu_test/Anu_data/canonical_form_dictionary/canonical_form_correction.out  < canonical/tmp  > canonical/tmp1
$HOME_anu_test/Anu_data/canonical_form_dictionary/canonical_to_conventional.out  < canonical/tmp1  > canonical/$1_h_can

sed -i 's/@NMT/NMT/g' canonical/$1_h_can

cat canonical/$1_e canonical/$1_h_can   >  canonical/$1_canonical

python3 $HOME_alignment/src/extract_mng.py  canonical/$1_canonical $HOME_anu_test/Anu_data/canonical_form_dictionary/dictionaries/restricted_eng_words_in_canonical_form.txt  $HOME_anu_test/Anu_data/canonical_form_dictionary/dictionaries/default-iit-bombay-shabdanjali-dic_smt.txt revised_root.dat eng_conll_facts.dat  > new_mul_out.csv


#echo "NMT"
python3  $HOME_alignment/src/get_multiple_output_in_facts.py new_mul_out.csv  manual_id_mapped.dat manual_mapped_id_root_info.dat  > mul_nmt_facts.dat

timeout 500 myclips -f $HOME_alignment/clp_files/run1.bat >> new_layer.error 

sed -i 's/dummy //g' new_layer_p3.dat

#Converting P3 layer fact to csv 
python3 $HOME_alignment/src/convert_new_layer_fact_to_csv.py new_layer_p3.dat P3 > p3_layer.csv

python3 $HOME_alignment/src/get_left_over_wrds.py p3_layer.csv  P3 manual_id_mapped.dat> p3_left_over_wrds.dat

#Replacing new layer id with id_wrd format
python3 $HOME_alignment/src/replace_id_with_wrd.py   manual_id_mapped.dat p3_layer.csv P3 > p3_layer_with_wrd.csv

sed 's/(//g' p3_left_over_wrds.dat | sed 's/)//g' | sed 's/ /,/g'> p3_left_over_wrds.txt
sed 's/,/\t/g' p3_layer_with_wrd.csv > p3_layer_with_wrd.tsv
sed -i 's/Multiple_NMT/@Multiple_@NMT/' new_mul_out.csv
sed -i 's/P3\t/@P3\t/'  p3_layer_with_wrd.tsv

wx_utf8 < p3_layer_with_wrd.tsv > p3_layer_with_wrd_utf8.tsv
wx_utf8 < new_mul_out.csv > new_mul_out_utf8.csv
#cat new_mul_out.csv >> Complete_alignment.csv

#cat p3_layer_with_wrd.tsv >> Complete_alignment.csv

cat info.tsv H_sentence_with_ids_utf8.dat anu_trn.txt p3_layer_with_wrd_utf8.tsv p2_layer_with_wrd_utf8.tsv p_layer_with_wrd_utf8.tsv p2_left_over_wrds_utf8.tsv H_grouping.tsv E_grouping.tsv new_mul_out_utf8.csv > p3_alignment_utf8.csv





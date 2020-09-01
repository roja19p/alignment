#To get irshaad parser in canonical form

cd $HOME_anu_tmp/tmp/$1_tmp
cut -f1 hindi_dep_parser_original.txt > h_p_id
cut -f2 hindi_dep_parser_original.txt > h_p_word
cut -f3-10 hindi_dep_parser_original.txt > h_p_rest

$HOME_anu_test/Anu_data/canonical_form_dictionary/canonical_form.out   < h_p_word  >  tmp
$HOME_anu_test/Anu_data/canonical_form_dictionary/canonical_form_correction.out  < tmp  > tmp1
$HOME_anu_test/Anu_data/canonical_form_dictionary/canonical_to_conventional.out  < tmp1  > h_p_word_canonical

paste h_p_id  h_p_word_canonical  h_p_rest >  hindi_parser_out_canonical.txt

#sed -i 's/;~~~~~~~~~~\t;~~~~~~~~~~\t;~~~~~~~~~~//g' $tmp/$file_dir/tmp1_canonical_tmp2 > $tmp/$file_dir/hindi_parser_out_canonical.txt
sed -i 's/\t;~~~~~~~~~~\t;~~~~~~~~~~//g' hindi_parser_out_canonical.txt

rm tmp tmp1 h_p_word_canonical

$HOME_anu_test/Anu_src/split_file.out hindi_parser_out_canonical.txt dir_names.txt hindi_parser_canonial.dat


rm -f eng_parent_sanwawi.dat hnd_parent_sanwawi.dat
count=`wc -l original_word.dat| awk '{print $1}'`
for ((i = 1 ; i <= $count ; i++)); do
	python3 $HOME_alignment/src/print_ancester.py E_conll_enhanced_without_punc.tsv $i $1  >> eng_parent_sanwawi.dat 
done;

count=`wc -l manual_id_mapped.dat | awk '{print $1}'`
for ((i = 1 ; i <= $count ; i++)); do
	python3 $HOME_alignment/src/print_ancester.py hindi_dep_parser_original_without_punc.tsv $i $2 >> hnd_parent_sanwawi.dat
done;


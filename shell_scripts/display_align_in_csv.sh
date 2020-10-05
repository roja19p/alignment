	sed  's/dummy //g' new_layer_clause.dat > new_layer_clause_$1.dat
	python3 $HOME_alignment/src/convert_new_layer_fact_to_csv.py new_layer_clause_$1.dat P2-clause > new_layer_clause_$1.csv
	sed -i 's/P2_clause//g' new_layer_clause_$1.csv
	sed -i 's/Output 1 from NMT - //g' H_clause
	wx_utf8 < H_clause > H_clause_utf8

	python3 $HOME_alignment/src/get_hindi_sentence_with_id_wrd.py eng_clause_word.dat  > E_clause_with_wrd.dat
	sed -i 's/@Hindi_@sentence/English_Clause/g' E_clause_with_wrd.dat
	python3 $HOME_alignment/src/get_hindi_sentence_with_id_wrd.py hnd_clause_word.dat  > H_clause_with_wrd.dat
	wx_utf8 < H_clause_with_wrd.dat > H_clause_with_wrd_utf8.dat
	python3 $HOME_alignment/src/replace_id_with_wrd.py  hnd_clause_word.dat new_layer_clause_$1.csv P2-clause > new_layer_clause_$1_with_wrd.csv
	#left over wrds 
	python3 $HOME_alignment/src/get_left_over_wrds.py new_layer_clause_$1.csv  P2-clause hnd_clause_word.dat > new_layer_clause_$1_left_over_wrds.dat
	python3 $HOME_alignment/src/convert_new_layer_fact_to_csv.py new_layer_clause_$1_left_over_wrds.dat P2_clause_left_over_ids > new_layer_clause_$1_left_over_wrds.csv

	python3 $HOME_alignment/src/replace_id_with_wrd.py  hnd_clause_word.dat new_layer_clause_$1_left_over_wrds.csv P2_clause_left_over_ids > new_layer_clause_$1_left_over_wrds_with_ids.dat

	sed -i 's/P2-clause/@P2_@clause/g' new_layer_clause_$1_with_wrd.csv
	sed -i 's/P2_clause_left_over_ids/@P2_@clause_@left_@over_@ids/g' new_layer_clause_$1_left_over_wrds_with_ids.dat
	wx_utf8 < new_layer_clause_$1_with_wrd.csv > new_layer_clause_$1_with_wrd_utf8.csv
	wx_utf8 < new_layer_clause_$1_left_over_wrds_with_ids.dat > new_layer_clause_$1_left_over_wrds_with_ids_utf8.dat

	cat E_clause_with_wrd.dat new_layer_clause_$1_with_wrd_utf8.csv new_layer_clause_$1_left_over_wrds_with_ids_utf8.dat H_clause_with_wrd_utf8.dat > p2_$1_clause.csv
	sed -i 's/,/\t/g' p2_$1_clause.csv

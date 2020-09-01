MYPATH=`pwd`
source activate irshad_parser
echo "Running Anusaaraka .."
time Anusaaraka_stanford.sh $1 0 True $3 onesent > $1_out 2>&1
echo "Running Alignment upto P layer ..."
time Anusaaraka_alignment.sh $1 $2 $3 nsdp >> $1_out  2>&1
conda deactivate
##exit
cd $HOME_alignment/shell_scripts
sh  get_conll.sh $HOME_anu_tmp/tmp/$1_tmp/one_sentence_per_line.txt $HOME_anu_tmp/tmp/$1_tmp/

sh $HOME_anu_test/Parsers/stanford-parser/src/run_stanford.sh  $HOME_anu_tmp/tmp/$1_tmp/one_sentence_per_line.txt  > $HOME_anu_tmp/tmp/$1_tmp/new_version_std_tmp.txt

cd $HOME_anu_tmp/tmp/$1_tmp
sed -n '1h;2,$H;${g;s/\n\n/\n;~~~~~~~~~~\n/g;p}' E_conll_parse  > $HOME_anu_tmp/tmp/$1_tmp/E_conll_parse1
sed -n '1h;2,$H;${g;s/\n\n/\n;~~~~~~~~~~\n/g;p}' E_conll_parse_basic >  $HOME_anu_tmp/tmp/$1_tmp/E_conll_parse_basic1
sed -n '1h;2,$H;${g;s/\n\n/\n;~~~~~~~~~~\n/g;p}' E_conll_parse_enhanced >  $HOME_anu_tmp/tmp/$1_tmp/E_conll_parse_enhanced1
sed -n '1h;2,$H;${g;s/\n\n/\n;~~~~~~~~~~\n/g;p}' E_conll_parse_enhanced_plus_plus >  $HOME_anu_tmp/tmp/$1_tmp/E_conll_parse_enhanced_plus_plus1

cd $HOME_anu_tmp/tmp/$1_tmp
$HOME_anu_test/Anu_src/split_file.out  E_conll_parse1 dir_names.txt E_conll_parse
python3 $HOME_alignment/src/get_sent_split.py new_version_std_tmp.txt > new_version_std.txt
$HOME_anu_test/Anu_src/split_file.out  new_version_std.txt dir_names.txt new_version_std.dat

echo "Word Grouping ..."
python3 $HOME_alignment/Word_Grouping/E_Sanity_Check.py $1
python3 $HOME_alignment/Word_Grouping/E_Grouping_Word_Dependency_Sanity.py $1

cd $HOME_alignment/shell_scripts
sh get_canonical.sh $1

python3 $HOME_alignment/Word_Grouping/H_Grouping_Word.py $1

#sh get_const_nd_dep_for_single_sent.sh $HOME_anu_tmp/tmp/$1_tmp/one_sentence_per_line.txt.std.penn $MYPATH


echo "Calling Transliteration.."
cd $HOME_alignment/transliteration
time python3 check_transliteration_on_corpus.py $MYPATH/$1 $MYPATH/$2 Exception-dic.txt > $HOME_anu_tmp/tmp/$1_tmp/transliterate_wrds.txt

cd $HOME_anu_tmp/tmp/$1_tmp/

$HOME_anu_test/Anu_src/split_file.out E_conll_parse_basic1 dir_names.txt E_conll_parse_basic
$HOME_anu_test/Anu_src/split_file.out E_conll_parse_enhanced1 dir_names.txt E_conll_parse_enhanced
$HOME_anu_test/Anu_src/split_file.out E_conll_parse_enhanced_plus_plus1 dir_names.txt E_conll_parse_enhanced_plus_plus

while read line 
do 
	cp transliterate_wrds.txt $line/transliterate_wrds.dat
	cd $line
	echo $line
	if [ "$line" != "1.1" ] ; then
		echo "(defglobal ?*path* = $HOME_alignment)" > alignment_path.clp
		bash $HOME_alignment/shell_scripts/generate_P2_layer.sh  
	fi	
	cd ..
done < dir_names.txt	


##### clause data info 
MYPATH=`pwd`
var=''

#############################################################################
#To get clauses info in a sentence:
python3 $HOME_alignment/src/constituency-to-conll.py penn_tree.dat  > penn_in_conll.dat
python3 $HOME_alignment/src/largest-np-pp.py  penn_in_conll.dat > clauses_info.txt

rm tmp
while read line 
do
        echo $line | sed 's/^[^ ]\+ //g' >> tmp
#        cat tmp
done < clauses_info.txt
python3 $HOME_alignment/src/check_word_count.py tmp > clauses_info.txt1
cp clauses_info.txt1 $HOME/dockers/all-export/input.txt

#############################################################################
#Generate NMT output for each clause
cd  $HOME/dockers/all-export
source activate onmt
sh run.sh > out 2>&1
conda deactivate
grep "Please check OUTPUT" out | sed 's/Please check//' > f_name
var=`cat f_name`
echo $var
cd $var/output-lm-score/
rm list
ls * > list
cp list $MYPATH/
while read line 
do
	echo $line
	sed -i 's/।/\./g' $line	
	utf8_wx $line > $MYPATH/$line.wx
done <	list
rm $MYPATH/clause_align_data.dat
cd $MYPATH
var=`cat $HOME/dockers/all-export/f_name`
echo $var
#var=$1

rm -f P2_clause_info.csv sampark_morph.dat H_clauses
#cat E_sentence > P2_clause_info.csv
python3 $HOME_alignment/src/get_missing_phrase.py E_sentence  clauses_info.txt1 > all_clauses.txt
#############################################################################
#Align each Clause
while read line 
do

	sh $HOME_alignment/shell_scripts/run_clause.sh  $line
	sh $HOME_alignment/shell_scripts/display_align_in_csv.sh  $line

	cat p2_"$line"_clause.csv >> P2_clause_info.csv	
	echo "" >> P2_clause_info.csv
	echo "" >> P2_clause_info.csv

done < list
#############################################################################
#To get clauses info in a csv 

cut -f1 all_clauses.txt > f1
cut -f2 all_clauses.txt > f2

count=0
exec 3<f1
exec 4<f2

rm missing_clause_info.dat  

while read line <&3 && read line1 <&4 
do
        count=`expr $count + 1`
        w=M$count
        if [ "$line" == "$w" ] ; then
                echo $line $line1
		echo $line1 > t.$line
		sed -i 's/^/English --> /g' t.$line
	        sed 's/^_/Output 1 from NMT: /g' hnd | sed 's/_/ /g' > H_sentence 	
		cat H_sentence  >> t.$line
		#### Testing below prog 
		python3 $HOME_alignment/src/remove_matching_phrase.py h_sentence H_clauses > rem_wrds.txt
		echo "=================="
		cat rem_wrds.txt
		echo "=================="
		###################
		cp rem_wrds.txt h_sentence
	        python3 $HOME_alignment/src/get_wrd_clause_info.py rem_wrds.txt > clause_anchor_tmp.dat
	        python3 $HOME_alignment/src/align.py t.$line  $HOME_anu_test/Anu_databases/default-iit-bombay-shabdanjali-dic_smt.gdbm >> missing_clause_info.dat
		myclips -f $HOME_alignment/clp_files/run_clause_across.bat 
		sh $HOME_alignment/shell_scripts/display_align_in_csv.sh  $line
        fi

done #< f1


#Final output : P2_clause_info.csv
#############################################################################


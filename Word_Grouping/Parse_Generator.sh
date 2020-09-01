#RUN ALL THE COMMANDS IN PYTHON2.7 ENVIRONMENT EXCEPT FOR THE LAST ONE 
# $1 IS PROPER PATH O INPUT FILE $2 IS LOCATION OF OUTPUT FILE DIRECTORY

#$1=/home/rajrajeshwari/tmp_anu_dir/tmp/test_tmp/2.1/E_sentence
#$2=/home/rajrajeshwari/tmp_anu_dir/tmp/test_tmp/2.1

#touch $2/E_constituency_parse
cd $HOME/anusaaraka/Parsers/stanford-parser/stanford-parser-full-2018-10-17
java -mx1g -cp "*" edu.stanford.nlp.parser.lexparser.LexicalizedParser  edu/stanford/nlp/models/lexparser/englishPCFG.ser.gz $1 > $2/E_constituency_parse

#touch $2/E_conll_parse_(representation)
java -mx1g  -cp "*" edu.stanford.nlp.trees.ud.UniversalDependenciesConverter  -treeFile $2/E_constituency_parse  -conllx > $2/E_conll_parse -outputRepresentation basic

#cd $HOME/Internship/Saumya_Single_line_grouping

sh $hindi_parser/run_hindi_parser.sh /home/rajrajeshwari/tmp_anu_dir/tmp/test_tmp/2.1/H_sentence /home/rajrajeshwari/tmp_anu_dir/tmp/test_tmp/2.1/hindi_parser_canonial.dat

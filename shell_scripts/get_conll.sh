cd $HOME_anu_test/Parsers/stanford-parser/stanford-parser-4.0.0

java -mx1g -cp "*" edu.stanford.nlp.parser.lexparser.LexicalizedParser  -sentences "newline"  edu/stanford/nlp/models/lexparser/englishPCFG.ser.gz $1 > $2/E_constituency_parse 2>/dev/null

java -mx1g  -cp "*" edu.stanford.nlp.trees.ud.UniversalDependenciesConverter  -treeFile $2/E_constituency_parse   -conllx > $2/E_conll_parse -outputRepresentation basic #2>/dev/null

java -mx1g  -cp "*" edu.stanford.nlp.trees.ud.UniversalDependenciesConverter  -treeFile  $2/E_constituency_parse  -conllx  -outputRepresentation basic   > $2/E_conll_parse_basic
java -mx1g  -cp "*" edu.stanford.nlp.trees.ud.UniversalDependenciesConverter  -treeFile  $2/E_constituency_parse  -conllx  -outputRepresentation enhanced  > $2/E_conll_parse_enhanced
java -mx1g  -cp "*" edu.stanford.nlp.trees.ud.UniversalDependenciesConverter  -treeFile  $2/E_constituency_parse  -conllx  -outputRepresentation enhanced++   > $2/E_conll_parse_enhanced_plus_plus



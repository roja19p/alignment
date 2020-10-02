$HOME/ace-0.9.31/ace -g $HOME/ace-0.9.31/erg-2018-x86-64-0.9.31.dat -1f --report-labels < $1 > tmp_file_for_tree
fmt tmp_file_for_tree > $2
grep -A100 "(\"S\" (\"S\"" $2 > $2.tmp
sed 's/.*("S" ("S"/("S ("S /g' $2.tmp | sed 's/"//g'  > $2_tree

#cat $2_tree

###########  Using option --tsdb-stdout , comment above lines and uncomment below lines
#$HOME/ace-0.9.31/ace -g $HOME/ace-0.9.31/erg-2018-x86-64-0.9.31.dat -1f --report-labels --tsdb-stdout < $1 > tmp_file_for_tree
#grep -A100 "tree" $2 > $2.tmp
#sed 's/.*tree \." //g' $2.tmp | sed 's/\\"//g' | sed 's/") (:flags.*//g' > $2_tree

java -jar $HOME_anu_test/miscellaneous/TREES/tree_viewer/ConstTreeViewer_13_05_10.jar 



# OUTPUT:
# Rama returned to Ayodhya after fourteen years' exile.                                                                            
# SENT: Rama returned to Ayodhya after fourteen years' exile.
# [ LTOP: h0
# INDEX: e2 [ e SF: prop TENSE: past MOOD: indicative PROG: - PERF: - ]
# RELS: < [ proper_q<0:4> LBL: h4 ARG0: x3 [ x PERS: 3 NUM: sg IND: + ] RSTR: h5 BODY: h6 ]
#  [ named<0:4> LBL: h7 CARG: "Rama" ARG0: x3 ]
#  [ _return_v_1<5:13> LBL: h1 ARG0: e2 ARG1: x3 ]
#  [ _to_p_dir<14:16> LBL: h1 ARG0: e9 [ e SF: prop TENSE: untensed MOOD: indicative PROG: - PERF: - ] ARG1: e2 ARG2: x10 [ x PERS: 3 NUM: sg IND: + ] ]
#  [ proper_q<17:24> LBL: h11 ARG0: x10 RSTR: h12 BODY: h13 ]
#  [ named<17:24> LBL: h14 CARG: "Ayodhya" ARG0: x10 ]
#  [ _after_p<25:30> LBL: h1 ARG0: e16 [ e SF: prop TENSE: untensed MOOD: indicative PROG: - PERF: - ] ARG1: e2 ARG2: x17 [ x PERS: 3 NUM: sg ] ]
#  [ udef_q<31:45> LBL: h18 ARG0: x19 [ x PERS: 3 NUM: pl IND: + ] RSTR: h20 BODY: h21 ]
#  [ card<31:39> LBL: h22 CARG: "14" ARG0: e24 [ e SF: prop TENSE: untensed MOOD: indicative PROG: - PERF: - ] ARG1: x19 ]
#  [ _year_n_1<40:45> LBL: h22 ARG0: x19 ]
#  [ def_explicit_q<45:46> LBL: h25 ARG0: x17 RSTR: h26 BODY: h27 ]
#  [ poss<45:46> LBL: h28 ARG0: e29 [ e SF: prop TENSE: untensed MOOD: indicative PROG: - PERF: - ] ARG1: x17 ARG2: x19 ]
#  [ _exile_n_1<47:53> LBL: h28 ARG0: x17 ] >
# HCONS: < h0 qeq h1 h5 qeq h7 h12 qeq h14 h20 qeq h22 h26 qeq h28 >
# ICONS: < > ]
# NOTE: 1 readings, added 6162 / 4043 edges to chart (1147 fully instantiated, 458 actives used, 1167 passives used)      RAM: 30574k

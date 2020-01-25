echo "(defglobal ?*path* = $HOME_alignment)" > alignment_path.clp

python3 $HOME_alignment/src/convert_conll_tree_to_facts.py $1 > conll-facts.dat
myclips -f $HOME_alignment/clp_files/tree_transform.bat > $1.error
python3 $HOME_alignment/src/convert_fact_to_tree.py tree-mod1.dat > new_tree.csv
cp new_tree.csv ~/
dep_tree_view.sh &

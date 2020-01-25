
(load "alignment_path.clp")
(bind ?*path* (str-cat ?*path* "/clp_files/conll_tree_mod.clp"))
(load ?*path*)
(load-facts "conll-facts.dat")
(assert (index 1))
(open "tree-mod1.dat" open-conll "w")
(watch rules)
(watch facts)
(agenda)
(run)
(save-facts "tree-mod.dat" local id-word-cat-head_id-rel)

(clear)
(exit)


(load "alignment_path.clp")
(bind ?path (str-cat ?*path* "/clp_files/group_vib.clp"))
(load ?path)
(load-facts "hnd_clause_word.dat")
(load-facts "clause_anchor_tmp.dat")
(watch rules)
(watch facts)
(agenda)
(run)
(save-facts "clause_anchor.dat" local hindi_head_id-grp_ids iter-h_g_id)
(clear)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(load "alignment_path.clp")
(bind ?path (str-cat ?*path* "/clp_files/align_across_clause.clp"))
(load ?path)
(load-facts "clauses_info_with_ids.dat")
(load-facts "clause_anchor.dat")
(load-facts "manual_id_mapped.dat")
(load-facts "manual_mapped_id_root_info.dat")
(load-facts "missing_clause_info.dat")
;(assert (label P2_clause))
(watch rules)
(watch facts)
(agenda)
(matches align_across_clause) 
(run)
(save-facts "anchor_miss_clause.dat" local hindi_head_id-grp_ids iter-type-eng_g_id-h_g_id iter-h_g_id)
;(save-facts "new_layer_clause.dat" local dummy)
(clear)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(load "alignment_path.clp")
(bind ?*path* (str-cat ?*path* "/clp_files/generate_new_layer.clp"))
(load ?*path*)
(load-facts "anchor_miss_clause.dat")
;(load-facts "mng_suggested.dat")
(assert (label P2_clause))
(watch rules)
(watch facts)
(agenda)
(matches replace_head_with_childs)
(facts) 
(run)

(save-facts "new_layer_clause.dat" local dummy)
(clear)
(exit)



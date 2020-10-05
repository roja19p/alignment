(defrule align_across_clause
(eng_clause_ids $?ids)
(missing_clause ?id)
(test (member$ ?id $?ids))
(id-wrd-h_mng ?id1 ?wrd ?mng)
(test (member$ ?id1 $?ids))
;(or (manual_mapped_id-word ?hid ?mng) (manual_mapped_id-root ?hid ?mng))
(manual_mapped_id-word ?hid ?mng)
;(test (member$  ?hid $?hids))
=>
	(assert (iter-type-eng_g_id-h_g_id 1  anchor ?id1 ?hid))	
)


(defrule modify_fact
(declare (salience -100))
?f<-(iter-h_g_id ?iter $?hids)
(label ?lab)
=>
        (retract ?f)
        (assert (dummy ?lab $?hids))
)
 

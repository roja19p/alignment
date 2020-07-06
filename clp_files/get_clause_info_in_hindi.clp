
; when no clause is present
(defrule get_initial_clause
?f<-(verb_root-id ?v_rt ?id)
(test (neq (numberp ?id)  FALSE))
(not (hnd_clause_hid-childs $?))
=>
	(retract ?f)
	(bind $?gids (create$ ))
	(loop-for-count (?i 1 ?id)
		(bind $?gids (create$ $?gids ?i))
	)
	(assert (hnd_clause_hid-childs ?id  $?gids))
)

(defrule get_clause_info
?f<-(verb_root-id ?v_rt ?id)
(hnd_clause_hid-childs ?id1 $?cids)
(test (neq (numberp ?id)  FALSE))
(test (> ?id ?id1))
=>
	(retract ?f)
        (bind $?gids (create$ ))
	(bind ?last_id (nth$ (length $?cids) $?cids))
        (loop-for-count (?i (+ ?last_id 1) ?id)
                (bind $?gids (create$ $?gids ?i))
        )
        (assert (hnd_clause_hid-childs ?id  $?gids))
)


(defrule get_clause_info1
?f<-(verb_root-id ?v_rt ?id)
?f1<-(hnd_clause_hid-childs ?id1 ?f_id $?cids)
(test (neq (numberp ?id)  FALSE))
(test (< ?id ?id1))
(hindi_head_id-grp_ids ?id $?hids)
=>
        (bind $?gids (create$ ))
        (bind $?gids1 (create$ ))
	(bind ?last_id (nth$ (length $?hids) $?hids))
	;clause info
        (loop-for-count (?i ?f_id ?last_id)
                (bind $?gids (create$ $?gids ?i))
        )
        (assert (hnd_clause_hid-childs ?id  $?gids))

	(bind ?l_id (nth$ (length $?cids) $?cids))
	;clause info
	(loop-for-count (?i (+ ?last_id 1) ?l_id)
                (bind $?gids1 (create$ $?gids1 ?i))
        )

	(retract ?f ?f1)
        (assert (hnd_clause_hid-childs ?id  $?gids))
        (assert (hnd_clause_hid-childs ?id1  $?gids1))
)

;ex: soca sakawe hEM laser_eng , 2.3
(defrule replace_head_with_grp_ids
(declare (salience 2))
(hindi_head_id-grp_ids ?h $?hids)
?f<-(hnd_clause_hid-childs ?h $?gids)
(test (member$ ?h $?gids))
(test (eq (subsetp $?hids $?gids) FALSE))
(not (head_replaced ?h))
=>
	(loop-for-count (?i 1 (length $?gids))
		(if (eq (nth$ ?i $?gids) ?h) then
			(bind $?new_ids (replace$ $?gids ?i ?i $?hids))
			(retract ?f)
			(assert (hnd_clause_hid-childs ?h $?new_ids))
			(assert (head_replaced ?h))
		)
	)
)
			


;aba eka progrAma ko maSIna xvArA niRpAxiwa karane kI AvaSyakawA nahIM hE @PUNCT-Comma hAlAzki vaha kampyUtara progrAmiMga kA viSiRta sanxarBa hogA hama ummIxa kara rahe We ki eka kampyUtara apane caraNoM ko niRpAxiwa karegA  .
(defrule get_initial_clause_info_for_kriyA_mUla
?f<-(verb_root-id ?v_rt ?id)
(test (neq (str-index "+" ?id) FALSE))
(verb_root_hid-gids ?h  $?hids)
(not (hnd_clause_hid-childs $?))
(test (eq ?h (string-to-field (sub-string 1 (- (str-index "+" ?id) 1) ?id))))
=>
	(retract ?f)
        (bind $?gids (create$ ))
	(bind ?last_id (nth$ (length $?hids) $?hids)) 
        (loop-for-count (?i 1 ?last_id)
                (bind $?gids (create$ $?gids ?i))
        )
        (assert (hnd_clause_hid-childs ?h  $?gids))
)


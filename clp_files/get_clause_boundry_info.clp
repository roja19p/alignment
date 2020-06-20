
(deffunction remove_character(?char ?str ?replace_char)
                        (bind ?new_str "")
                        (bind ?index (str-index ?char ?str))
                        (if (neq ?index FALSE) then
                        (while (neq ?index FALSE)
                        (bind ?new_str (str-cat ?new_str (sub-string 1 (- ?index 1) ?str) ?replace_char))
                        (bind ?str (sub-string (+ ?index 1) (length ?str) ?str))
                        (bind ?index (str-index ?char ?str))
                        )
                        )
                (bind ?new_str (explode$ (str-cat ?new_str (sub-string 1 (length ?str) ?str))))
 )


(defrule check_for_yaxi_clause
(Hnd_parent-sanwawi ?hid $?hids)
(manual_mapped_id-word	?id yaxi)
(test (member$ ?id $?hids))
=>
	(printout t "yaxi clause " $?hids crlf)
	(assert (yaxi_clause_head_id-gids ?hid $?hids))
)

;In hindi 'yaxi' might be absent ..so using Eng 'if' identifying the clause
(defrule check_for_if_clause
(Eng_parent-sanwawi ?eid $?ids)
(id-word ?id ?wrd&if)
(test (member$ ?id $?ids))
=>
	(printout t "if clause "  $?ids crlf)
	(assert (if_clause_head_id-gids ?eid  $?ids))
)

(defrule check_for_then_in_if_clause
?f<-(Eng_parent-sanwawi ?eid $?ids)
?f1<-(if_clause_head_id-gids ?if  $?ids)
(id-word ?id ?wrd&then)
(test (member$ ?id $?ids))
=>
	(retract ?f ?f1)
	(bind $?ids (delete-member$ $?ids ?id))
	(printout t "modifying_if_clause_by_removing_then " $?ids)
	(assert (if_clause_head_id-gids ?eid  $?ids))
	(assert (Eng_parent-sanwawi ?eid $?ids))
)

;check for then
(defrule check_for_then_clause
?f<-(Eng_parent-sanwawi ?eid $?ids)
(id-word ?id ?wrd&then)
(test (member$ ?id $?ids))
(if_clause_head_id-gids ?if  $?gids)
(test (subsetp $?gids $?ids))
=>
	(retract ?f)
	(bind $?then_ids $?ids)
	(loop-for-count (?i 1 (length $?then_ids))
		(bind ?var (nth$ ?i $?then_ids))
		(if (or (member$ ?var $?gids) (eq ?var ?if)) then
			(bind $?ids (delete-member$ $?ids ?var))
		)
	)
	(printout t "then_clause" ?eid " " $?ids)
	(assert (then_clause_head_id-gids ?eid  $?ids))
	(assert (Eng_parent-sanwawi ?eid $?ids))
)

(defrule check_for_wo_clause
(declare (salience 10))
?f<-(Hnd_parent-sanwawi ?hid $?hids)
(manual_mapped_id-word  ?id wo)
(test (member$ ?id $?hids))
(yaxi_clause_head_id-gids ?yaxi_h_id $?gids)
(test (subsetp $?gids $?hids))
=>
	(retract ?f)
	(bind $?wo_ids $?hids)
	(loop-for-count (?i 1 (length $?wo_ids))
		(bind ?var (nth$ ?i $?wo_ids))
		(if (or (member$ ?var $?gids) (eq ?var ?yaxi_h_id)) then
			(bind $?hids (delete-member$ $?hids ?var))
		)
	)
	(printout t "wo_clause" ?hid "  " $?hids crlf)
	(assert (wo_clause_head_id-gids ?hid  $?hids))
	(assert (Hnd_parent-sanwawi ?hid $?hids))
)


(defrule get_main_clause_frm_rel_clause
?f<-(Eng_parent-sanwawi ?e_p $?eids)
(Eng_parent-sanwawi ?e_p1 $?eids1)
(test (neq ?e_p ?e_p1))
(id-word ?id ?wrd&which|that)
(test (eq (nth$ 1 $?eids1) ?id))
(test (member$ ?id  $?eids))
;(test (subsetp (create$ ?e_p1 $?eids) $?eids1))
(not (clause_decided ?e_p))
=>
	(retract ?f)
	(bind $?n (sort > (create$ ?e_p1 $?eids1)))
	(printout t (type $?eids) crlf)
	(printout t (type $?n) crlf)
	(bind ?new_ids (delete-member$ $?eids $?n))
	(printout t ?new_ids crlf)
	(assert (Eng_parent-sanwawi ?e_p ?new_ids))
	(assert (clause_decided ?e_p))
)	

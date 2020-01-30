
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

;[If an element of interference or uncertainty occurs] then the environment is stochastic.
(defrule align_if_clause
(if_clause_head_id-gids ?if_head  $?gids)
?f<-(iter-type-eng_g_id-h_g_id ?iter potential ?eid $?ids)
(test (or (member$ ?eid $?gids) (eq ?if_head ?eid)))
(yaxi_clause_head_id-gids ?yaxi_head $?hids)
(iter-type-eng_g_id-h_g_id ? anchor ?id ?hid)
(test (or (member$ ?id $?gids) (eq ?id ?if_head)))
(test (member$ ?hid $?hids))
=>
	(loop-for-count (?i 1 (length $?ids))
		(bind ?n (nth$ ?i $?ids))
		(bind ?yaxi_clause_ids (create$ ?yaxi_head $?hids))
		(if (eq (member$  ?n ?yaxi_clause_ids) FALSE) then
			(if (> (length $?ids) 1) then
				(printout t ?n crlf)
				(bind ?new_ids (delete-member$ $?ids ?n))
				(assert (iter-type-eng_g_id-h_g_id (+ ?iter 1) potential ?eid ?new_ids))
				(retract ?f)
			)
		)
	)
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






;lakRya rAjyoM aksara eka lakRya parIkRaNa xvArA nirxiRta kara rahe hEM [jo kisI BI lakRya rAjya ko sanwuRta karanA cAhie].
(defrule  align_jo_clause
(Eng_parent-sanwawi ?e_p ?which $?eids)
(id-word ?which which|that)
?f<-(iter-type-eng_g_id-h_g_id ?iter potential ?eid $?hids)
(test (member$ ?eid $?eids))
(Hnd_parent-sanwawi ?par ?jo $?ids)
(manual_mapped_id-word ?id1 ?hwrd)
(test (member$ ?id1 $?hids))
(test (member$ ?id1 $?ids)) 
(not (anchor_decided ?eid))
=>
	(assert (iter-type-eng_g_id-h_g_id (+ ?iter 1) potential ?eid ?id1))
	(assert (anchor_decided ?eid))
        (retract ?f)
)

;Goal states are often specified by a [goal test] which any goal state must satisfy.
;lakRya rAjyoM aksara eka [lakRya parIkRaNa] xvArA nirxiRta kara rahe hEM jo kisI BI lakRya rAjya ko sanwuRta karanA cAhie. 
(defrule comp_rule_in_hin1
?f<-(iter-type-eng_g_id-h_g_id ?iter potential ?e2 $?hids)
(eng_relation_name-head-chiid compound ?e1 ?e2 )
(iter-type-eng_g_id-h_g_id ?iter1 anchor ?e1 $?ids)
(hnd_relation_name-head-chiid compound ?h1 ?h2)
(test (member$ ?h1 $?ids))
(test (member$ ?h2 $?hids))
(not (anchor_decided ?e2))
=>
	(retract ?f)
        (assert (iter-type-eng_g_id-h_g_id (+ ?iter 1) potential ?e2 ?h2))
	(assert (anchor_decided ?e2))
)

;[Rational Action] is the action that maximizes the expected value of the performance measure given the percept sequence to date.
;[yukwisafgawa kriyA], vaha kriyA howI hE, jo wiWi karane ke lie boXa anukrama meM xie gae niRpAxana mApa ke apekRiwa mUlya ko aXikawama karawI hE.
(defrule align_thru_unlabeled_info
(eng_relation_name-head-chiid ?rel ?e1 ?e2)
(iter-type-eng_g_id-h_g_id ?iter  anchor ?e1 $?hids)
(hnd_relation_name-head-chiid ?rel1 ?h1 ?h2)
(test (member$ ?h1 $?hids))
(hindi_head_id-grp_ids ?h2 $?h2_ids)
(not (iter-type-eng_g_id-h_g_id ?  ? ?e2 $?))
(not (iter-type-eng_g_id-h_g_id ?  ? ? $? ?h2 $?)) ;added this condition to stop firing in Ex: One of [the] rooms contains a computer.
(test (neq ?rel case))
(test (neq ?rel1 case))
=>
	(assert (iter-type-eng_g_id-h_g_id 1 anchor ?e2 ?h2))
)


;One of the rooms contains [a] computer.
(defrule align_thru_unlabelled_info_whn_fact_avl
(eng_relation_name-head-chiid ?rel ?e1 ?e2)
(iter-type-eng_g_id-h_g_id ?iter  anchor ?e1 $?hids1)
?f1<-(iter-type-eng_g_id-h_g_id ?iter1  potential ?e2 $?hids2)
(hnd_relation_name-head-chiid ?rel1 ?h1 ?h2)
(test (member$ ?h1 $?hids1))
(test (member$ ?h2 $?hids2))
=>
	(retract ?f1)
	(assert (iter-type-eng_g_id-h_g_id (+ ?iter1 1) anchor ?e2 ?h2))
)


;Goal states are often [specified] by a goal test which any goal state must satisfy.
;lakRya rAjyoM aksara eka lakRya parIkRaNa xvArA [nirxiRta kara rahe hEM] jo kisI BI lakRya rAjya ko sanwuRta karanA cAhie.
(defrule align_thru_unlabeled_info_for_root
(eng_relation_name-head-chiid root ?e1 ?e2)
(hnd_relation_name-head-chiid root ?h1 ?h2)
(not (iter-type-eng_g_id-h_g_id ?  ? ?e2 $?))
(not (eng_relation_name-head-chiid cop ?e2 ?)) ;If an element of interference or uncertainty occurs then the environment [is stochastic].
(hindi_head_id-grp_ids ?h $?hids)
(test (member$ ?h2 $?hids))
=>
        (assert (iter-type-eng_g_id-h_g_id 1 anchor ?e2 ?h))
)




;These rules are not in use..if neccessary modify accordingly
;(defrule pick_p_layer_if_clause
;(if_clause_head_id-gids ?id  $?gids)
;(Eng_parent-sanwawi ?id $?gids)
;(P1 $?ids)
;=>
;	(bind ?pids (create$ ))
;	(loop-for-count (?i 1 (length $?gids)) 
;               (bind ?pids (create$ ?pids (nth$ ?i $?ids)))
;
;       )
;	(bind ?pids (create$ ?pids (nth$ ?id $?ids)))
;       (assert (head_id-hindi_ids ?id ?pids))
;       (printout t ?pids crlf)
;)
;
;(defrule pick_p_layer_then_clause
;(then_clause_head_id-gids ?id  $?gids)
;(Eng_parent-sanwawi ?id $?gids)
;(P1 $?ids)
;=>
;	(bind ?pids (create$ ))
;	(loop-for-count (?i 1 (length $?gids))
;               (bind ?pids (create$ ?pids (nth$ ?i $?ids)))
;
;	)
;	(bind ?pids (create$ ?pids (nth$ ?id $?ids)))
;       (assert (head_id-hindi_ids ?id ?pids))
;       (printout t ?pids crlf)
;)
;
;
;(defrule check_p_layer_if_clause
;(head_id-hindi_ids ?id $?hids)
;?f<-(P1 $?ids)
;(yaxi_clause_head_id-gids ?yaxi $?gids)
;(Hnd_parent-sanwawi ?yaxi $?san)
;=>
;	(loop-for-count (?i 1 (length $?hids))
;		(bind ?var (nth$ ?i $?hids))
;		(if (eq (member$ ?var $?gids) FALSE) then
;			(if (neq ?var 0) then 
;			(if (and (neq (type ?var) INTEGER) (neq (str-index "," ?var) FALSE ))  then
;			;(if  (neq (str-index "," ?var) FALSE )  then
;				(bind $?items (explode$ (implode$ (remove_character "," ?var " "))))
;				(if (eq (member$ (nth$ 1 $?items) $?gids) FALSE) then
;					(assert (wrong_eng_h_id-wrong_eng_id-hnd_h_id-hids ?id ?i ?yaxi ?var))
;					(printout t "eng_id-hnd_h_id-wrong_hids " ?i  " " ?var crlf)
;				else
;		                        (bind $?san (delete-member$ $?san $?items))
;					(printout t $?san crlf)
;				)
;			))
;		else
;			(bind $?san (delete-member$ $?san ?var))
;		)
;	)
;	(assert (wrong_eng_h_id-exp_id ?id $?san))
;) 
;
;(defrule correct_wrong_ids
;(declare (salience 10))
;?f<-(wrong_eng_h_id-wrong_eng_id-hnd_h_id-hids ?id ?eng ?hnd ?hids)
;(wrong_eng_h_id-exp_id ?id ?ex_id)
;(Hnd_parent-sanwawi ?hnd $?san)
;(Hnd_label-group_elements ?hlab $?gids)
;(test (member$ ?ex_id $?gids))
;?f1<-(P1 $?ids)
;(not (fact_corrected_id ?id))
;=>
;        (bind ?var (explode$ (implode$ (remove_character " " (implode$ $?gids) ","))))
;	(bind $?new_ids (replace$ $?ids ?eng ?eng ?var))
;	(retract ?f ?f1)
;	(assert (P1 $?new_ids))
;	(assert (fact_corrected_id ?id))
;	(assert (grouping_corrected_id-prev_val ?id ?hids))
;
;)
;
;(defrule interchange_grp_val_aft_correction
;(declare (salience 10))
;(grouping_corrected_id-prev_val  ?id $?val)
;?f<-(P1 $?ids)
;(not (fact_value_asserted $?val))
;
;=>
;	(bind ?var (nth$ ?id $?ids))
;	(loop-for-count (?i 1 (length $?ids))
;		(bind ?var1 (nth$ ?i $?ids))
;		(if (and (eq ?var ?var1) (neq ?i ?id)) then 
;                	(bind ?new_ids (replace$ $?ids ?i ?i $?val))
;	                (assert (P1 ?new_ids))
;			(assert (fact_corrected_id ?i))
;			(assert (fact_value_asserted $?val))
;                	(retract ?f)
;        	)
;	)
;)
;
;
;

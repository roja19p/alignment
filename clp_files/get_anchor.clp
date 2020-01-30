;ex: ai2E, 2.10, An autonomous agent decides [autonomously] which action to take in the current situation to maximize progress towards its goals.
;eka svAyawwa ejeMta [svAyawwa rUpa se] waya karawA hE ki mOjUxA sWiwi meM apane lakRyoM kI xiSA meM pragawi ko aXikawama karane ke lie kOna sI kArravAI karanI hE.
;If P1 anchor is fixed then removing potential info if present in anchor.dat (ie. from slot_debug_input.txt)
(defrule del_potential_anchor_if_P1_is_fixed
(declare (salience 10))
?f<-(iter-type-eng_g_id-h_g_id ?iter potential ?id $?)
(hindi_head_id-grp_ids ?h $?hids)
(P1_tmp ?id  $?pids)
(test (eq $?pids $?hids))
(not (iter-type-eng_g_id-h_g_id ?iter1 potential ? ?h))
=>
	(retract ?f)
)

;ex: ai2E, 2.10, An autonomous agent decides [autonomously] which action to take in the current situation to maximize progress towards its goals.
;eka svAyawwa ejeMta [svAyawwa rUpa se] waya karawA hE ki mOjUxA sWiwi meM apane lakRyoM kI xiSA meM pragawi ko aXikawama karane ke lie kOna sI kArravAI karanI hE.
;If potential ids are subset of P1 fixed slot then remove the potential fact
(defrule check_hin_ids_in_p
(declare (salience 9))
(P1_tmp ?id  $?pids)
?f<-(iter-type-eng_g_id-h_g_id ?iter potential ?id1 $?ids)
(hindi_head_id-grp_ids ?hid $?h_ids )
(test (member$ ?hid $?ids))
(test (member$ $?h_ids $?pids))
(test (neq $?h_ids $?pids))
=>
	(retract ?f)
	(bind ?new_ids (delete-member$ $?ids ?hid))
	(printout t ?new_ids  crlf)
	(if (>= (length ?new_ids) 1) then 
		(assert (iter-type-eng_g_id-h_g_id (+ ?iter 1) potential ?id1 ?new_ids))
	else
		(assert (iter-type-eng_g_id-h_g_id (+ ?iter 1) potential ?id1 0))
	)

)

(defrule merge_group_ids_if_p1_fixed
(declare (salience 9))
?f<-(hindi_head_id-grp_ids ?hid  $?ids)
?f1<-(hindi_head_id-grp_ids ?hid1 $?ids1)
(P1_tmp ?id  $?pids)
(test (member$ ?hid $?pids))
(test (member$ ?hid1 $?pids))
(test (neq ?hid ?hid1))
=>
	(bind $?new_ids (sort > (create$ $?ids $?ids1)))
	(retract ?f ?f1)
	(assert (hindi_head_id-grp_ids (first$ $?new_ids) $?new_ids))
)


;Deciding P layer anchor 
(defrule decide_anchor_if_p1_decided
(declare (salience 8))
(P1_tmp ?id  $?pids)
(hindi_head_id-grp_ids ?hid $?gids)
(test (member$ ?hid  $?pids))
(not (iter-type-eng_g_id-h_g_id ?iter ?type ? $? ?hid $?))
=>
	(assert (iter-type-eng_g_id-h_g_id 2 anchor ?id ?hid))
;	(assert (iter-type-eng_g_id-h_g_id ?iter anchor ?id $?pids))
)


;(defrule decide_anchor_using_grouping
;(declare (salience 7))
;(Eng_label-group_elements ?lab $?eids)
;(iter-type-eng_g_id-h_g_id ?iter anchor  ?id  $?ids)
;(test (member$ ?id $?eids))
;(iter-type-eng_g_id-h_g_id ?iter1 potential  ?id1  $?h_id1)
;(test (member$ ?id1 $?eids))
;(Hnd_label-group_elements ?hlab $?hids)
;(test (member$ $?ids $?hids))
;=>
;	(loop-for-count (?i (length $?h_id1))
;		(bind ?tmp (nth$ ?i $?h_id1))
;		(if (neq (member$ ?tmp $?hids)  FALSE) then 
;			(assert (eng_id-possible_suggestion ?id1 ?tmp))
;		)
;	)
;)
;
;;
;(defrule remove_potential_if_sugg_avl1
;(eng_id-possible_suggestion ?id ?sug_id)
;?f<-(iter-type-eng_g_id-h_g_id ?iter potential  ?id  $?h_id1)
;=>
;	(retract ?f)
;	(assert (iter-type-eng_g_id-h_g_id (+ ?iter 1) anchor ?id ?sug_id))
;)
;

;(defrule remove_potential_if_sugg_avl2
;(eng_id-possible_suggestion ?id ?sug_id)
;(iter-type-eng_g_id-h_g_id ?iter1 anchor ?id ?sug_id)
;?f<-(iter-type-eng_g_id-h_g_id ?iter potential  ?id1  $?h_id1)
;(test (member$ ?sug_id $?h_id1))
;=>
;        (retract ?f)
;	(bind ?new_id (delete-member$ $?h_id1 ?sug_id))
;	(assert (iter-type-eng_g_id-h_g_id (+ ?iter 1) potential ?id1 ?new_id))
;        (if (>= (length ?new_id) 1) then
;                (assert (iter-type-eng_g_id-h_g_id (+ ?iter 1) potential ?id1 ?new_id))
;        else
;                (assert (iter-type-eng_g_id-h_g_id (+ ?iter 1) potential ?id1 0))
;        )
;
;)

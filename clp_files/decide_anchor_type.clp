(defrule remove_pot_id_if_anc_decided
?f<-(iter-type-eng_g_id-h_g_id ?iter potential ?id $?hids)
(iter-type-eng_g_id-h_g_id ?iter1 anchor ? ?hid)
;(anchor_decided_e_id-h_id ?id1 ?hid)
(test (member$ ?hid $?hids))
=>
	(retract ?f)
	(bind ?new_id (delete-member$ $?hids ?hid))
	(if (>= (length ?new_id) 1) then 
		(assert (iter-type-eng_g_id-h_g_id (+ ?iter 1) potential ?id ?new_id))
	else
		(assert (iter-type-eng_g_id-h_g_id (+ ?iter 1) potential ?id  0))
	)
)

(defrule create_fact
(declare (salience -100))
?f<-(iter-h_g_id  ?iter  $?hids)
(iter-type-eng_g_id-h_g_id ?iter1 ? ?id ?hid)
(test (neq (nth$ ?id $?hids) ?hid))
(not (anchor_replaced ?id))
=>
        (retract ?f)
        (bind $?hids (replace$ $?hids ?id ?id ?hid))
        (if (>= ?iter1 ?iter) then
                (assert (iter-h_g_id  ?iter1  $?hids))
        else
                (assert (iter-h_g_id  ?iter  $?hids))
        )
        (assert (anchor_replaced ?id))
)


(defrule check_potential_anchor
(declare (salience -200))
?f<-(iter-h_g_id  ?iter  $?hids)
?f1<-(iter-type-eng_g_id-h_g_id ?iter1 potential ?id ?hid)
=>
        (bind ?type "")
;        (printout t ?type crlf)
	(bind ?count 0)
        (loop-for-count (?i (length $?hids))
                (bind ?val (nth$ ?i $?hids))
                (if (eq ?val ?hid) then
			(bind ?count (+ ?count 1))
                )
        )
	(if (eq ?count 1) then (bind ?type "anchor")
	else	(bind ?type "potential"))
        (if (eq ?type "anchor") then
                (retract ?f1)
                (assert (iter-type-eng_g_id-h_g_id (+ ?iter1 1) anchor ?id ?hid))
        )
)



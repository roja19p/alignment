
;To align compound mng when one is fixed
;In this meeting the term "[Artificial Intelligence]" was adopted.
;isa bETaka meM '[aXyayanAwmaka prajFA]' Sabxa ko apanAyA gayA  .
(defrule align_comp_rule1
(id-HM-source-grp_ids  ?id ?mng  ?src $?ids)
(test (neq (str-index "compound" ?src) FALSE))
(iter-type-eng_g_id-h_g_id ? anchor ?eid  ?hid)
(test (member$ ?eid $?ids))
(test (member$ (- ?eid 1) $?ids))
(not (iter-type-eng_g_id-h_g_id ? ? =(- ?eid 1) ?))
(hindi_head_id-grp_ids ?h $?hids)
(test (member$ (- ?hid 1) $?hids))
(not (iter-type-eng_g_id-h_g_id ? anchor ? ?h)) ; ai1E , 2.2 Artificial Intelligence is concerned with the design of intelligence in an artificial device.
=>
	(assert (iter-type-eng_g_id-h_g_id 1 anchor (- ?eid 1) ?h))
)

;Writing similar rule for RHS wrd
(defrule align_comp_rule2
(id-HM-source-grp_ids  ?id ?mng  ?src $?ids)
(test (neq (str-index "compound" ?src) FALSE))
(iter-type-eng_g_id-h_g_id ? anchor ?eid  ?hid)
(test (member$ ?eid $?ids))
(test (member$ (+ ?eid 1) $?ids))
(not (iter-type-eng_g_id-h_g_id ? ? =(+ ?eid 1) ?))
(hindi_head_id-grp_ids ?h $?hids)
(test (member$ (+ ?hid 1) $?hids))
(not (iter-type-eng_g_id-h_g_id ? anchor ? ?h))
=>
        (assert (iter-type-eng_g_id-h_g_id 1 anchor (+ ?eid 1) ?h))
)

;If already potential fact is available and other one is anchor
(defrule align_comp_rule3
(id-HM-source-grp_ids  ?id ?mng  ?src $?ids)
(test (neq (str-index "compound" ?src) FALSE))
(iter-type-eng_g_id-h_g_id ? anchor ?eid  ?hid)
(test (member$ ?eid $?ids))
(test (member$ (- ?eid 1) $?ids))
?f<-(iter-type-eng_g_id-h_g_id ?iter potential =(- ?eid 1) $?)
(hindi_head_id-grp_ids ?h $?hids)
(test (member$ (- ?hid 1) $?hids))
(not (iter-type-eng_g_id-h_g_id ? anchor ? ?h))
=>
	(retract ?f)
        (assert (iter-type-eng_g_id-h_g_id (+ ?iter 1) anchor (- ?eid 1) ?h))
)



;Writing similar rule for RHS wrd when potential anchor is available
(defrule align_comp_rule4
(id-HM-source-grp_ids  ?id ?mng  ?src $?ids)
(test (neq (str-index "compound" ?src) FALSE))
(iter-type-eng_g_id-h_g_id ? anchor ?eid  ?hid)
(test (member$ ?eid $?ids))
(test (member$ (+ ?eid 1) $?ids))
?f<-(iter-type-eng_g_id-h_g_id ?iter potential =(+ ?eid 1) $?)
(hindi_head_id-grp_ids ?h $?hids)
(test (member$ (+ ?hid 1) $?hids))
(not (iter-type-eng_g_id-h_g_id ? anchor ? ?h))
=>
        (assert (iter-type-eng_g_id-h_g_id (+ ?iter 1) anchor (+ ?eid 1) ?h))
)


;Rule from Manju's alignment1.clp. Rewrote again to get align in P2 using facts available here.
;[Do] you see the fish on the revolving disc on the pole? [kyA] wumane swamBa para Gumawe hue pahie para lagI maCalI ko xeKA ?
;[Are] we looking at the thought process or reasoning ability of the system?
;[kyA] hama sistama kI soca prakriyA yA reasoning kRamawA ko xeKa rahe hEM ?
(defrule align_kyA_in_aux
(declare (salience 550))
?f0<-(hindi_id_order kyA $?a)
(not (iter-type-eng_g_id-h_g_id ? ? ?eid  $? 1 $?))
(manual_mapped_id-word 1 kyA)
=>
        (assert (iter-type-eng_g_id-h_g_id 1 anchor 1 1))
)

;Aligning ke saMxarBa meM
(defrule align_ke+h_wrd+meM
(manual_mapped_id-word ?id ke)
(manual_mapped_id-word =(+ ?id 1) ?hwrd)
(manual_mapped_id-word =(+ ?id 2) meM)
?f<-(hindi_head_id-grp_ids ?h $?hids ?id)
?f1<-(hindi_head_id-grp_ids ?h1 =(+ ?id 1) =(+ ?id 2)) 
?f2<-(Hnd_label-group_elements ?lab $?gids ?id)
?f3<-(Hnd_label-group_elements ?lab1 =(+ ?id 1) $?gids1)
=>
	(retract ?f ?f1 ?f2 ?f3)
	(assert (hindi_head_id-grp_ids ?h $?hids ?id (+ ?id 1) (+ ?id 2) ))
	(bind ?new_lab (string-to-field (str-cat ?lab "_" ?lab1)))
	(assert (Hnd_label-group_elements ?new_lab $?gids ?id (+ ?id 1)  $?gids1))
) 	
	

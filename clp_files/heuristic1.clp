
(deftemplate manual_word_info (slot head_id (default 0))(multislot word (default 0))(multislot word_components (default 0))(multislot root (default 0))(multislot root_components (default 0))(multislot vibakthi (default 0))(multislot vibakthi_components (default 0))(slot tam (default 0))(multislot tam_components (default 0))(multislot group_ids (default 0)))


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
(test (member$ ?hid $?hids));#Counter ex: So, this will consists of different steps such as a cleaning the room, preparing the stage, [making sure] the decoration are up, arranging the chairs and so on.
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
(test (member$ ?hid $?hids));#Counter ex: So, this will consists of different steps such as a cleaning the room, preparing the stage, [making sure] the decoration are up, arranging the chairs and so on. 
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


;Decide using default dic:
(defrule decide_anchor_using_dic
?f<-(iter-type-eng_g_id-h_g_id ?iter potential ?id $? ?hid $?)
;?f<-(iter-type-eng_g_id-h_g_id ?iter potential ?id ?hid)
(or (manual_mapped_id-word  ?hid ?hwrd) (manual_mapped_id-root ?hid ?hwrd))
(id-org_wrd-root-dbase_name-mng ? ? ?rt  default-iit-bombay-shabdanjali-dic_smt.gdbm ?hwrd)
(or (id-root ?id ?rt) (id-conll_root ?id ?rt))
(hindi_head_id-grp_ids ?head_id $?ids)
(test (member$ ?hid $?ids))
(not (anchor_decided_e_id-h_id ?id  ?head_id))
=>
       (retract ?f)
       (assert (iter-type-eng_g_id-h_g_id (+ ?iter 1) potential ?id ?head_id))
       (assert (anchor_decided_e_id-h_id ?id  ?head_id))
;      (assert (anchor_decided ?head_id))
)


;Decide using default dic:
(defrule decide_anchor_using_dic1
?f<-(iter-type-eng_g_id-h_g_id ?iter potential ?id 0)
(or (manual_mapped_id-word  ?hid ?hwrd) (manual_mapped_id-root ?hid ?hwrd))
(id-org_wrd-root-dbase_name-mng ? ? ?rt  default-iit-bombay-shabdanjali-dic_smt.gdbm ?hwrd)
(or (id-root ?id ?rt) (id-conll_root ?id ?rt))
(hindi_head_id-grp_ids ?head_id $?ids)
(test (member$ ?hid $?ids))
(not (anchor_decided_e_id-h_id ?id  ?head_id))
(not (iter-type-eng_g_id-h_g_id ? anchor ? ?head_id)) ;[Goal] states are often specified by a goal test which any goal state must satisfy.`
=>
       (retract ?f)
       (assert (iter-type-eng_g_id-h_g_id (+ ?iter 1) potential ?id ?head_id))
       (assert (anchor_decided_e_id-h_id ?id  ?head_id))
;      (assert (anchor_decided ?head_id))
)


;Align using 'P' layer
;2.52
;when eng id potential/anchor fact not available
(defrule using_P_layer
(declare (salience -1))
(manual_word_info (head_id ?phead_id) (word ?wrd $?) (group_ids $?gids1))
(manual_parserid-wordid ?phead_id ?head_id)
(hindi_head_id-grp_ids ?head_id $?gids)
(not (iter-type-eng_g_id-h_g_id ? ? ?  $? ?head_id $?))
(anu_id-anu_mng-sep-man_id-man_mng_tmp ?eid $? - ?phead_id $?mng)
(not (iter-type-eng_g_id-h_g_id ? ? ?eid  $? ))
(not (anchor_decided_e_id-h_id ?eid  ?head_id))
(test (member$ ?wrd $?mng))
=>
	(assert (iter-type-eng_g_id-h_g_id 1 anchor  ?eid  ?head_id))
	(assert (anchor_decided_e_id-h_id ?eid  ?head_id))
)

;when eng id potential fact available
(defrule using_P_layer1
(declare (salience -1))
(manual_word_info (head_id ?phead_id) (word ?wrd $?) (group_ids $?gids1))
(manual_parserid-wordid ?phead_id ?head_id)
(hindi_head_id-grp_ids ?head_id $?gids)
;(not (iter-type-eng_g_id-h_g_id ? ? ?  $? ?head_id $?))
(anu_id-anu_mng-sep-man_id-man_mng_tmp ?eid $? - ?phead_id $?mng)
?f<-(iter-type-eng_g_id-h_g_id ?iter potential ?eid  $?ids )
(not (anchor_decided_e_id-h_id ?eid  ?head_id))
(test (member$ ?wrd $?mng))
(not (iter-type-eng_g_id-h_g_id ? anchor ?  ?head_id))
=>
	(retract ?f)
        (assert (iter-type-eng_g_id-h_g_id (+ ?iter 1) anchor  ?eid  ?head_id))
        (assert (anchor_decided_e_id-h_id ?eid  ?head_id))
)

;E, 2.3
;So, those things require a lot of [careful] calculation and all that.
;wo, una cIjoM ke lie bahuwa [sAvaXAnI se] gaNanA Ora saba kuCa kI AvaSyakawA hE  . 
(defrule using_P_layer2
(declare (salience -2))
(manual_word_info (head_id ?phead_id) (word ?wrd $?) (group_ids $?gids1))
(manual_parserid-wordid ?phead_id ?head_id)
(hindi_head_id-grp_ids ?head_id $?gids)
(anu_id-anu_mng-sep-man_id-man_mng_tmp ?eid $? - ?phead_id $?mng)
?f<-(iter-type-eng_g_id-h_g_id ?iter potential ?eid  $? ?head_id $?)
(not (anchor_decided_e_id-h_id ?eid  ?head_id))
(test (member$ ?wrd $?mng))
(id-org_wrd-root-dbase_name-mng ? ? ?rt default-iit-bombay-shabdanjali-dic_smt.gdbm ?wrd $?)
(id-root ?eid ?rt)
=>
	(retract ?f)
        (assert (iter-type-eng_g_id-h_g_id (+ ?iter 1) anchor  ?eid  ?head_id))
        (assert (anchor_decided_e_id-h_id ?eid  ?head_id))
)

;;E , 2.3
;So, those things require a [lot] of careful calculation and all that.
;wo, una cIjoM ke lie [bahuwa] sAvaXAnI se gaNanA Ora saba kuCa kI AvaSyakawA hE  . 
(defrule using_anusaaraka_K_layer
(declare (salience -3))
(id-Apertium_output ?eid  ?mng $?mngs)
?f<-(iter-type-eng_g_id-h_g_id ?iter potential ?eid  $?ids )
(manual_mapped_id-word ?hid ?mng)
(hindi_head_id-grp_ids ?head_id $?gids)
(test (member$ ?hid $?gids))
(id-org_wrd-root-dbase_name-mng ? ? ?rt default-iit-bombay-shabdanjali-dic_smt.gdbm ?mng $?)
(id-root ?id ?rt)
(not (iter-type-eng_g_id-h_g_id ? anchor ? ?head_id)) ;[Goal] states are often specified by a goal test which any goal state must satisfy.`
=>
	(retract ?f)
	(assert (iter-type-eng_g_id-h_g_id (+ ?iter 1) anchor  ?eid  ?head_id))
        (assert (anchor_decided_e_id-h_id ?eid  ?head_id))
)

;align using mwe 
;A [prime number] is one which is divisible by no other number other rather than 1 and itself.
;[aBAjya safKyA] vaha hE, jo 1 Ora svayaM se Binna kisI anya safKyA se viBAjya nahIM hE  .
(defrule using_mwe
(ids-cmp_mng-head-cat-mng_typ-priority $?ids ?mng ?h ?oun ? ?)
?f<-(iter-type-eng_g_id-h_g_id ?iter potential  ?eid $? ?hid $?)
(test (eq (nth$ ?h $?ids) ?eid))
(hindi_head_id-grp_ids ?head_id $?gids)
(test (member$ ?hid $?gids))
(or (manual_mapped_id-root ?j  ?rt)
(manual_mapped_id-word ?j ?rt))
(test (member$ ?j $?gids))
=>
	(retract ?f)
	(assert (iter-type-eng_g_id-h_g_id (+ ?iter 1) anchor  ?eid  ?head_id))
)
	

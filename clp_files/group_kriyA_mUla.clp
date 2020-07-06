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

;Added by Roja(19-11-19)
 ;[Image analysis] [systems] are examples of this kind of situation.
 (defrule assert_dummy_fact
 (declare (salience 3))
 (id-HM-source-grp_ids ?id ?mng ?s $?pre ?id1 $?post)
 (not (fact_created ?id))
 =>
        (assert (id-HM-source-grp_rts ?id ?mng ?s $?pre ?id1 $?post))
        (assert (fact_created ?id))
 )

 ;Added by Roja (19-11-19)
 ;To replace ids with word in hindi meaning group fact (for printing suggestion in below rules wrd info needed)
 (defrule create_eng_wrds_info
 (declare (salience 2))
 (id-root ?id1 ?r)
 ?f<-(id-HM-source-grp_rts ?id ?mng ?s $?pre ?id1 $?post)
 (test (neq (numberp ?r) TRUE))
 =>
        (retract ?f)
        (assert (id-HM-source-grp_rts ?id ?mng ?s $?pre ?r $?post))
 )

;Group apekRA_kara/raKa
(defrule group_apekRA_kara/raKa
(declare (salience 2))
?f<-(Hnd_label-group_elements ?lab ?hid)
?f1<-(Hnd_label-group_elements ?lab1 =(+ ?hid 1) $?hids)
(manual_mapped_id-word ?hid apekRA)
(manual_mapped_id-root  =(+ ?hid 1) kara|raKa)
?f2<-(hindi_head_id-grp_ids ? $? ?hid)
?f3<-(hindi_head_id-grp_ids =(+ ?hid 1) =(+ ?hid 1) $?hids)
;(not (iter-type-eng_g_id-h_g_id ? ? ? $?pre ?hid $?post))
=>
        (retract ?f ?f1 ?f2 ?f3 )
	(bind ?new_lab (string-to-field (str-cat ?lab "_" ?lab1)))
	(assert (Hnd_label-group_elements ?new_lab ?hid (+ ?hid 1) $?hids))
        (assert (hindi_head_id-grp_ids ?hid ?hid (+ ?hid 1) $?hids))
)


;As parser splits for kriyA mUla correct the grouping
(defrule correct_eng_grouping_kriyA_mUla
(id-HM-source-grp_ids ?id ?mng ?source $?gids)
(id-HM-source-grp_rts ?id ?mng ?source $?rts)
(id-cat_coarse ?id1 verb)
(test (and (member$ ?id1 $?gids) (> (length $?gids) 1)))
?f<-(Eng_label-group_elements ?lab  $?ids)
?f1<-(Eng_label-group_elements ?lab1  $?ids1)
(test (member$ ?id1 $?ids))
(test (member$ (+ ?id1 1) $?ids1))
(not (grouping_decided ?id1))
?f2<-(Eng_label-group_words ?lab  $?wrds)
?f3<-(Eng_label-group_words ?lab1  $?wrds1)

=>
	(retract ?f ?f1 ?f2 ?f3)
	(bind ?new_lab (string-to-field (str-cat ?lab "_" ?lab1)))
	(assert (Eng_label-group_elements ?new_lab $?ids $?ids1))
	(assert (Eng_label-group_words ?new_lab $?wrds $?wrds1))
	(assert (grouping_decided ?id1))
)

;ai3E, 2.50 pawA_lagA
(defrule correct_hnd_grouping_kriyA_mUla
(kriyA_mUla_wrd-ids ?wrd $?ids)
?f<-(Hnd_label-group_elements ?lab $?gids)
?f1<-(Hnd_label-group_elements ?lab1 $?gids1 )
(test (neq ?lab ?lab1))
(test (member$ (first$ $?ids) $?gids))
(test (member$ (nth$ 2 $?ids) $?gids1))
?f2<-(Hnd_label-group_words ?lab $?wrds)
?f3<-(Hnd_label-group_words ?lab1 $?wrds1)
=>
;	(loop-for-count (?i 1 (length $?ids))
;		(if (and (member$ (nth$ ?i $?ids) $?gids) (member$ (nth$ (+ ?i 1) $?ids) $?gids1)) then 
			(retract ?f ?f1 ?f2 ?f3)
			(bind ?new_lab (string-to-field (str-cat ?lab "_" ?lab1)))
			(assert (Hnd_label-group_elements ?new_lab $?gids $?gids1))
			(assert (Hnd_label-group_words ?new_lab $?wrds $?wrds1))
			
;		)
;	)
)

(defrule align_kriyA_mUla_group
(declare (salience -1))
(id-root ?id ?rt)
(Eng_label-group_elements ?lab $?eids)
(test (or (member$ ?id $?eids) (eq ?id $?eids)))
(kriyA_mUla_wrd-ids ?k_wrd ?kid $?ids)
(Hnd_label-group_elements ?hlab $?hids)
(test (member$ ?kid $?hids))
(test (neq (gdbm_lookup "default-iit-bombay-shabdanjali-dic.gdbm" (str-cat ?rt "_verb")) FALSE))
;(not (eng_id_decided ?id))
;(not (and (hid_id_decided ?j) (test (member$ ?j $?hids))))
=>
	(bind ?mng (gdbm_lookup "default-iit-bombay-shabdanjali-dic.gdbm" (str-cat ?rt "_verb")))
        (bind $?mngs  (explode$ (implode$ (remove_character "/"  ?mng " "))))
        (if (member$ ?k_wrd $?mngs) then
		(assert (hid_id_decided ?kid))
		(bind ?new_id ?kid)
		(loop-for-count (?i 2 (length $?hids)) 
			(bind ?new_id (string-to-field (str-cat ?new_id "," (nth$ ?i $?hids))))
	;		(assert (hid_id_decided (nth$ ?i $?hids)))
		)
		(printout t ?new_id $?hids crlf)
		(bind ?new_id  (explode$ (implode$ (remove_character ","  ?new_id " "))))
		(assert (P1_tmp ?id ?new_id))
	;	(assert (eng_id_decided ?id))
	)
)		

;The [emphasis] in this case is on the inferencing mechanism, and its properties.            
;isa mAmale meM anumAna wanwra, Ora isake guNoM para [jora xiyA gayA hE]  .
(defrule kriyA_mula1
(verb_root_hid-gids ?vid $?gids)
?f<-(Hnd_label-group_elements ?lab  ?vid )
?f1<-(Hnd_label-group_elements ?lab1 $?ids)
(test (subsetp $?ids $?gids))
?f2<-(hindi_head_id-grp_ids ?vid ?vid)
?f3<-(hindi_head_id-grp_ids ?hid $?ids)
?f4<-(iter-type-eng_g_id-h_g_id ?iter ?type ?eid $?pre ?hid $?post)
(test (neq ?lab ?lab1))
=>
	(retract ?f ?f1 ?f2 ?f3 ?f4)
	(bind ?new_lab (string-to-field (str-cat ?lab "_" ?lab1)))
	(assert (Hnd_label-group_elements ?new_lab ?vid  $?ids))
	(assert (hindi_head_id-grp_ids ?vid ?vid $?ids))
	(assert (iter-type-eng_g_id-h_g_id (+ ?iter 1) ?type ?eid ?vid $?pre $?post))
)	
	

(defrule kriyA_mula2
(verb_root_hid-gids ?vid $?gids)
?f<-(Hnd_label-group_elements ?lab  ?vid )
?f1<-(Hnd_label-group_elements ?lab1 $?ids)
(test (subsetp $?ids $?gids))
?f2<-(hindi_head_id-grp_ids ?vid ?vid)
?f3<-(hindi_head_id-grp_ids ?hid $?ids)
(not (iter-type-eng_g_id-h_g_id ? ? ? $?pre ?hid $?post))
=>
        (retract ?f ?f1 ?f2 ?f3 )
        (bind ?new_lab (string-to-field (str-cat ?lab "_" ?lab1)))
        (assert (Hnd_label-group_elements ?new_lab ?vid  $?ids))
        (assert (hindi_head_id-grp_ids ?vid ?vid $?ids))
)

;Check if any repeation id in group
(defrule check_rpt_id
(hindi_head_id-grp_ids ?hid $?gids)
(hindi_head_id-grp_ids ?hid1 $?gids1)
(test (neq ?hid ?hid1))
=>
       (loop-for-count (?i 1 (length $?gids))
               (bind ?id (nth$ ?i $?gids)) 
               (if (member$ ?id $?gids1) then
                       (assert (repeated_ids ?id))
               )
       )
)



;
;(defrule correct_p_layer1
;(kriyA_mUla_wrd-ids ?wrd ?id $?ids)
;(Hnd_label-group_elements ?lab $?gids)
;(test (member$ ?id $?gids))
;?f<-(P1 $?pids)
;=>
;	(loop-for-count (?i 1 (length $?pids))
;		(bind ?pid (nth$ ?i $?pids))
;		(bind ?pid (create$ ?pid))
;        	(bind $?var (explode$ (implode$ (remove_character "," (implode$ ?pid) " "))))
;		(if (member$ (first$ $?ids) $?var) then
;			(assert (replace_e_id-hid-val ?i ?pid 0))
;		)
;	)
;)
;
;(defrule correct_p_layer
;(kriyA_mUla_wrd-ids ?wrd ?id $?ids)
;(Hnd_label-group_elements ?lab $?gids)
;(test (member$ ?id $?gids))
;?f<-(P1 $?pids)
;(replace_e_id-hid-val ?w_eid ?hids ?val)
;(not (fact_corrected_eng_id-hids ?id ?hids))
;=>
;	(bind ?hids (create$ ?hids))
;	(bind $?var (explode$ (implode$ (remove_character "," (implode$ ?hids) " "))))
;	(if (member$ (first$ $?ids)  $?var) then
;	(loop-for-count (?i 1 (length $?pids)) 
;		(bind ?pid (nth$ ?i $?pids))
;		(if (eq ?pid ?id) then
;			(bind ?newids (create$ ?id ?hids))
;		        (bind ?var1 (explode$ (implode$ (remove_character " " (implode$ ?newids) ","))))
;		        	(bind $?new_pids (replace$ $?pids ?i ?i ?var1))
;				(printout t ?i "  " (nth$  ?i $?pids) crlf)
;				(assert (P1 $?new_pids))
;				(assert (fact_corrected_eng_id-hids ?id ?hids))
;				(retract ?f)
;		)
;	))
;)
;
;
;(defrule replace_id
;(fact_corrected_eng_id-hids ?engid ?hids)
;?f<-(replace_e_id-hid-val ?w_eid ?hids ?val)
;?f1<-(P1 $?pids)
;=>
;        (bind $?new_pids (replace$ $?pids ?w_eid ?w_eid ?val))
;	(retract ?f ?f1)
;	(assert (P1 $?new_pids))
;)
;
;
;;ai3E, 2.48
;(defrule default_kriyA_mUla_rule
;(kriyA_mUla_wrd-ids ?wrd ?id $?ids)
;(Hnd_label-group_elements ?lab $?gids)
;(test (member$ ?id $?gids))
;(test (> (length $?gids) 1))
;?f<-(P1 $?pids)
;(not (fact_corrected_eng_id-hids ?id ?))
;(test (neq (integerp ?lab) TRUE))
;(test (neq (str-index "_" ?lab) FALSE))
;=>
;	(loop-for-count (?i 1 (length $?pids)) 
;		(bind ?pid (nth$ ?i $?pids))
;		(if (member$ ?pid $?gids) then
;	        	(bind ?var1 (explode$ (implode$ (remove_character " " (implode$ $?gids) ","))))
;		        (bind $?new_pids (replace$ $?pids ?i ?i ?var1))
;			(retract ?f)
;			(assert (P1 $?new_pids))
;		)
;	)
;)

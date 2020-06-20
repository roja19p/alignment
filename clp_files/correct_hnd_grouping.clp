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

;correct repeated eng wrd mng using eng grouping and hindi grouping
;ai2E, 2.106 [multiple goals]
(defrule correct_p2_lay_with_wrng_grp_id
(declare (salience 10))
?f0<-(Repeated_id  ?id)
(Eng_label-group_elements ?lab  $?e_gids)
(test (member$ ?id $?e_gids))
(test (member$ (- ?id 1) $?e_gids))
(eng_wrd-occurrences ?wrd 1)
(id-word =(- ?id 1) ?wrd)
;?f1<-(P1 $?ids)
?f<-(iter-type-eng_g_id-h_g_id ?iter potential ?id $?ids)
(test (neq $?ids 0))
(iter-type-eng_g_id-h_g_id ? anchor =(- ?id 1) ?hid)
(manual_mapped_id-word ?hid ?hwrd)
(hin_wrd-occurrences ?hwrd 1)
(Hnd_label-group_elements ?hlabel  $?h_gids)
(hindi_head_id-grp_ids ?h_id $?hgids)
(test (member$ ?hid $?hgids))
(test (member$ ?h_id $?h_gids))
(manual_mapped_id-word ?hid1 ?hwrd1)
(test (member$ ?hid1 $?h_gids))
(test (member$ ?hid1 $?ids))
(hindi_head_id-grp_ids ?h_id1 $?hgids1)
(test (member$ ?hid1 $?hgids1))
;(test (neq ?hid ?h_id))
=>
	(retract ?f)
	(assert (iter-type-eng_g_id-h_g_id (+ ?iter 1) anchor ?id ?hid1))
;	(bind ?new_hids (explode$ (implode$ (remove_character " " (implode$ $?hgids) ","))))
;	(assert (grouping_corrected_id-prev_val ?id (nth$ ?id $?ids)))
;	(bind ?new_ids (replace$ $?ids ?id ?id ?new_hids))
)

;So [those things] require a lot of careful calculation and all that
;wo [una cIjoM ke lie] bahuwa sAvaXAnI se gaNanA Ora saba kuCa kI AvaSyakawA hE
(defrule align_thru_grouping1
?f<-(iter-type-eng_g_id-h_g_id ?iter potential ?eid $?ids)
(test (neq $?ids 0))
(Eng_label-group_elements ?lab $? ?eid ?eid1 $?)
(test (eq (+ ?eid 1) ?eid1))
(iter-type-eng_g_id-h_g_id ? anchor ?eid1 ?hid)
(Hnd_label-group_elements ?  $?h_gids)
(test (member$ ?hid $?h_gids))
(hindi_head_id-grp_ids ?h_hid $?hids)
(test (member$ ?hid $?hids))
(hindi_head_id-grp_ids =(- ?h_hid 1) $?)
=>
	(retract ?f)
	(assert (iter-type-eng_g_id-h_g_id (+ ?iter 1) anchor ?eid (- ?h_hid 1)))
)	

;Need to test
(defrule align_thru_grouping2
?f<-(iter-type-eng_g_id-h_g_id ?iter potential ?eid1 $?ids)
(test (neq $?ids 0))
(Eng_label-group_elements ?lab $? ?eid ?eid1 $?)
(test (eq (- ?eid1 1) ?eid))
(iter-type-eng_g_id-h_g_id ? anchor ?eid ?hid)
(Hnd_label-group_elements ?  $?h_gids)
(test (member$ ?hid $?h_gids))
(hindi_head_id-grp_ids ?h_hid $?hids)
(test (member$ ?hid $?hids))
(hindi_head_id-grp_ids =(+ ?h_hid 1) $?)
=>
        (retract ?f)
        (assert (iter-type-eng_g_id-h_g_id (+ ?iter 1) anchor ?eid1 (+ ?h_hid 1)))
)







;
;(defrule interchange_grp_val_aft_correction
;(grouping_corrected_id-prev_val	 ?id $?val)
;(id-word ?id  ?wrd)
;(id-word ?id1  ?wrd)
;?f1<-(eng_wrd-occurrences ?wrd ?count&~1)
;(test (neq ?id ?id1))
;?f<-(P1 $?ids)
;=>
;	(if (eq (nth$ ?id1 $?ids) (nth$ ?id $?ids)) then 
;		(retract ?f ?f1)
;		(bind ?new_ids (replace$ $?ids ?id1 ?id1 $?val))
;		(assert (P1 ?new_ids))
;		(assert (eng_wrd-occurrences ?wrd (- ?count 1)))
;	)
;)
;
;
;(defrule correct_p_lay_with_repeated_wrd1
;?f0<-(Repeated_id  ?id)
;(Eng_label-group_elements ?lab  $?e_gids)
;(test (member$ ?id $?e_gids))
;(test (member$ (- ?id 1) $?e_gids))
;(id-word =(- ?id 1) ?wrd)
;?f1<-(P1 $?ids)
;(P-head_id-grp_ids ?h_id $?hgids)
;(H_wordid-word  ?hid&=(nth$ (- ?id 1) $?ids) ?hwrd)
;(Hnd_label-group_elements ?hlabel  $?h_gids)
;(test (member$ ?hid $?h_gids))
;(test (member$ ?h_id $?h_gids))
;(test (neq ?hid ?h_id))
;=>
;	(printout t (nth$ (- ?id 1) $?ids) " " ?hid " " (+ ?hid 1) " " crlf)
;	(bind ?new_hids (explode$ (implode$ (remove_character " " (implode$ $?hgids) ","))))
;        (assert (grouping_corrected_id-prev_val ?id ?new_hids))
;        (retract ?f0 ?f1)
;        (bind ?new_ids (replace$ $?ids ?id ?id ?new_hids))
;        (assert (P1 ?new_ids))
;)
;
;
;;(defrule modify_fact
;;(declare (salience -10))
;;?f<- (P $?ids)
;;=>
;;	(retract ?f)
;;	(assert (P1 $?ids))
;;)
;

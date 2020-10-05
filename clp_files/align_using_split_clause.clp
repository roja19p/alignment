;Align using splitted clause data

(defrule align_transliterate_data
(eng_wrd-transliterate_wrd ?wrd ?hwrd)
(manual_mapped_id-word ?hid ?hwrd)
(id-word ?id ?wrd)
?f<-(iter-type-eng_g_id-h_g_id ?iter potential ?id $?)
(hindi_head_id-grp_ids ?h_gids $?hids)
(test (member$ ?hid $?hids))
=>
	(retract ?f)
	(assert (iter-type-eng_g_id-h_g_id (+ ?iter 1)  anchor ?id ?h_gids))
)



(defrule align_data
(id-wrd-h_mng ?id ?wrd ?mng)
(manual_mapped_id-word ?hid ?mng)
?f<-(iter-type-eng_g_id-h_g_id ?iter potential ?id $? ?h_gids $?)
(hindi_head_id-grp_ids ?h_gids $?hids)
(test (member$ ?hid $?hids))
=>
	(retract ?f)
	(assert (iter-type-eng_g_id-h_g_id (+ ?iter 1)  anchor ?id ?h_gids))
)


;check anchor correct or not 
(defrule check_align_data
(declare (salience -1))
(id-wrd-h_mng ?id ?wrd ?mng)
(manual_mapped_id-word ?hid ?mng)
?f<-(iter-type-eng_g_id-h_g_id ?iter anchor ?id ?h $?)
(hindi_head_id-grp_ids ?h_gids $?hids)
(test (member$ ?h $?hids))
(manual_mapped_id-word ?h ?mng1)
=>
	(if (eq (member$ ?hid $?hids) FALSE) then 
		(printout t "Check anchor " ?id "  " ?wrd   "   "?mng  " " ?h " " ?mng1 crlf)
	)
)




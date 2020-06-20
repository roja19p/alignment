(defrule align_nmt
(eng_id-hindi_idi ?eng_id  $? ?mul_nmt_id $?)
(manual_mapped_id-word ?mul_nmt_id ?h_wrd)
(hindi_head_id-grp_ids ?h_id $?hids)
(test (member$ ?mul_nmt_id $?hids))
(iter-type-eng_g_id-h_g_id ?iter potential $?ids)
(test (member$ ?mul_nmt_id $?ids))
=>
	(assert (iter-type-eng_g_id-h_g_id (+ ?iter 1) anchor ?mul_nmt_id))
)





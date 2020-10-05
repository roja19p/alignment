(defrule suggest_mng
(iter-type-eng_g_id-h_g_id ? anchor ?eid ?hid)
(hindi_head_id-grp_ids ?h_gid   $?hids)
(test (member$ ?hid $?hids))
(hindi_head_id-grp_ids ?h_gid1  $?hids1)
(test (eq (+ (nth$ (length $?hids) $?hids) 1) (nth$ 1 $?hids1)))
(not (iter-type-eng_g_id-h_g_id ?  ? ? ?h_gid1))
(not (iter-type-eng_g_id-h_g_id ?  ? =(+ ?eid 1) ?))
=>
	(assert (iter-type-eng_g_id-h_g_id 1 anchor (+ ?eid 1) ?h_gid1))
	(assert (meaning_suggested (+ ?eid 1) ?h_gid1))
)


(defrule suggest_mng1
(declare (salience 1 ))
(iter-type-eng_g_id-h_g_id ? anchor ?eid ?hid)
(hindi_head_id-grp_ids ?h_gid   $?hids)
(test (member$ ?hid $?hids))
(hindi_head_id-grp_ids ?h_gid1  $?hids1)
(test (eq (- (nth$ 1 $?hids) 1) (nth$ (length $?hids1) $?hids1)))
(not (iter-type-eng_g_id-h_g_id ?  ? ? ?h_gid1))
(not (iter-type-eng_g_id-h_g_id ?  ? =(- ?eid 1) ?))
(test (neq ?eid 1))
=>
        (assert (iter-type-eng_g_id-h_g_id 1 anchor (- ?eid 1) ?h_gid1))
	(assert (meaning_suggested (- ?eid 1) ?h_gid1))
)


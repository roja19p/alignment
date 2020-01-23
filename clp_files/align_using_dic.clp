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

(defrule decide_anchor_using_dic
?f<-(iter-type-eng_g_id-h_g_id ?iter potential ?id ?hid)
(manual_mapped_id-word	?hid ?hwrd)
(id-org_wrd-root-dbase_name-mng ? ? ?rt  default-iit-bombay-shabdanjali-dic_smt.gdbm ?hwrd)
(or (id-root ?id ?rt) (id-conll_root ?id ?rt))
(not (anchor_decided ?hid))
=>
	(retract ?f)
	(assert (iter-type-eng_g_id-h_g_id (+ ?iter 1) anchor ?id ?hid))
	(assert (anchor_decided_e_id-h_id ?id  ?hid))
)

;Rational Action is the action that [maximizes] the expected value of the performance measure given the percept sequence to date.
; yukwisafgawa kriyA , vaha kriyA howI hE , jo wiWi karane ke lie boXa anukrama meM xie gae niRpAxana mApa ke apekRiwa mUlya ko [aXikawama karawI hE] . 
(defrule decide_anchor_for_no_match
(manual_mapped_id-root ?hid ?hwrd)
(or (id-root ?id ?rt) (id-conll_root ?id ?rt))
(test (neq (gdbm_lookup "default-iit-bombay-shabdanjali-dic_smt.gdbm" ?rt) FALSE))
(not (iter-type-eng_g_id-h_g_id ? ? ?id $?))
(not (anchor_decided ?hid))
=>
	(bind ?mng (gdbm_lookup "default-iit-bombay-shabdanjali-dic_smt.gdbm" ?rt))
        (bind $?mngs  (explode$ (implode$ (remove_character "/"  ?mng " "))))
	(if (member$ ?hwrd $?mngs) then
		(assert (iter-type-eng_g_id-h_g_id  1 anchor ?id ?hid))
		(assert (anchor_decided_e_id-h_id ?id  ?hid))
	)
)

(defrule remove_pot_if_anc_decided
?f<-(iter-type-eng_g_id-h_g_id ?iter potential ?id $?hids)
(anchor_decided_e_id-h_id ?id1 ?hid)
(test (neq ?id ?id1))
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


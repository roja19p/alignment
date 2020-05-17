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



(defrule remove_pot_id_if_anc_decided
?f<-(iter-type-eng_g_id-h_g_id ?iter potential ?id $?hids)
(iter-type-eng_g_id-h_g_id ?iter1 anchor ?id1 ?hid)
(test (neq ?id ?id1))
;(anchor_decided_e_id-h_id ?id1 ?hid)
(test (member$ ?hid $?hids))
(test (neq ?hid 0))
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
(declare (salience -300))
?f<-(iter-h_g_id  ?iter  $?hids)
(iter-type-eng_g_id-h_g_id ?iter1 ? ?id $?hid)
(test (neq (nth$ ?id $?hids) ?hid))
(not (anchor_replaced ?id $?hid))
=>
        (retract ?f)
	(if (eq (length $?hid) 1) then 
	        (bind $?hids (replace$ $?hids ?id ?id ?hid))
	else
		(bind ?m (explode$ (implode$ (remove_character " " (implode$ $?hid) ","))))
	        (bind $?hids (replace$ $?hids ?id ?id ?m))
	)
        (if (>= ?iter1 ?iter) then
                (assert (iter-h_g_id  ?iter1  $?hids))
        else
                (assert (iter-h_g_id  ?iter  $?hids))
        )
        (assert (anchor_replaced ?id $?hid))
)


(defrule check_potential_anchor
(declare (salience -200))
?f<-(iter-h_g_id  ?iter  $?hids)
?f1<-(iter-type-eng_g_id-h_g_id ?iter1 potential ?id ?hid)
=>
        (bind ?type "")
	(bind ?count 0)
        (loop-for-count (?i (length $?hids))
                (bind ?val (nth$ ?i $?hids))
		(if (eq ?val ?hid) then 
				(bind ?count (+ ?count 1))
		else
		(if (neq (integerp  ?val) TRUE) then 
		;	(if (neq (str-index "," ?val) FALSE) then 
         ;       		(printout t (type ?val) " " ?val crlf)
				(bind $?m  (remove_character "," ?val " "))
	;			(printout t $?m crlf)
                		(if (member$ ?hid $?m) then
					(bind ?count (+ ?count 1))
                	)		
		))
        )
	;(printout t ?count crlf)
	(if (eq ?count 1) then (bind ?type "anchor")
	else	(bind ?type "potential"))
        (if (eq ?type "anchor") then
                (retract ?f1)
                (assert (iter-type-eng_g_id-h_g_id (+ ?iter1 1) anchor ?id ?hid))
        )
)



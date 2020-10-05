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



;good reason to believe that [smart] data analysis will become even more pervasive as a necessary ingredient for technological progress.
;yaha viSvAsa karane kA acCA kAraNa hE ki [smArta] detA viSleRaNa wakanIkI pragawi ke lie eka AvaSyaka Gataka ke rUpa meM Ora BI vyApaka ho jAegA .
(defrule align_using_transliterate
(eng_wrd-transliterate_wrd ?wrd ?t_wrd)
(id-clause_wrd ?id ?c_wrd)
(test (or (eq ?wrd ?c_wrd) (eq (lowcase ?wrd) ?c_wrd)))
(id-hnd_clause_wrd ?hid ?hwrd)
(test (eq ?hwrd ?t_wrd))
=>
	(assert	(iter-type-eng_g_id-h_g_id 1 anchor ?id ?hid))
)


;of the mainstays of information technology and with that a rather central albeit usually hidden part of our life
;sUcanA prOxyogikI ke muKya AXAroM kA Ora usa ke sAWa eka balki keMxrIya hAlAMki AmawOra para hamAre jIvana kA hissA CipA huA hE
(defrule align_using_domain_mwe
(declare (salience 3))
?f<-(ids-domain_cmp_mng-head-cat-mng_typ-priority $?ids ?mng ?h ?c ?t ?p)
(id-clause_wrd ?id ?wrd)
(test (eq (nth$ ?h $?ids) ?id))
(id-hnd_clause_wrd ?hid ?hwrd)
(test (neq (str-index ?hwrd ?mng) FALSE))
(not (anchor_decided ?id))
=>
	(retract ?f)
	(assert (iter-type-eng_g_id-h_g_id 1 anchor ?id ?hid)) 
	(assert (anchor_decided ?id))
)


(defrule align_using_mwe
(declare (salience 2))
?f<-(ids-cmp_mng-head-cat-mng_typ-priority $?ids ?mng ?h ?c ?t ?p)
(id-clause_wrd ?id ?wrd)
(test (eq (nth$ ?h $?ids) ?id))
(id-hnd_clause_wrd ?hid ?hwrd)
(test (neq (str-index ?hwrd ?mng) FALSE))
(not (anchor_decided ?id))
=>
        (retract ?f)
        (assert (iter-type-eng_g_id-h_g_id 1 anchor ?id ?hid))
	(assert (anchor_decided ?id))
)



(defrule align_using_domain_dic
(declare (salience 1))
(id-clause_wrd ?id ?wrd)
(id-hnd_clause_wrd ?hid ?hwrd)
(test (neq (gdbm_lookup "computer_science.gdbm" (str-cat ?wrd "_noun")) FALSE))
(not (anchor_decided ?hid))
=>
        (bind ?mng (gdbm_lookup "computer_science.gdbm" (str-cat ?wrd "_noun")))
        (bind $?mngs  (explode$ (implode$ (remove_character "/"  ?mng " "))))
        (if (member$ ?hwrd $?mngs) then
                (assert (iter-type-eng_g_id-h_g_id 1 anchor ?id ?hid))
        )
)


(defrule default_dic
(id-clause_wrd ?id ?wrd)
(id-hnd_clause_wrd ?hid ?hwrd)
(id-wrd-h_mng ? ?wrd ?hwrd)
(hindi_head_id-grp_ids ?hid $?hids)
=>
	(assert (iter-type-eng_g_id-h_g_id 1 anchor ?id ?hid))
)


(defrule default_dic1
(id-clause_wrd ?id ?wrd)
(id-hnd_clause_wrd ?hid ?hwrd1)
(id-wrd-h_mng ? ?wrd ?hwrd)
(test (eq (sub-string 1 (length ?hwrd1) ?hwrd) ?hwrd1))
=>
        (assert (iter-type-eng_g_id-h_g_id 1 anchor ?id ?hid))
)



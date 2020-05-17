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

;ai1E, 2.113
;While [some translation systems] have been developed, there is a lot of scope for improvement in translation quality.
;Here 'some' we have an anchor fact. So using this fact to decide translation mng using E grouping and H grouping
(defrule decide_anchor_using_technical_dic
?f<-(iter-type-eng_g_id-h_g_id ?iter potential ?id $?hids)
(manual_mapped_id-word  ?hid ?hwrd)
(test (member$ ?hid $?hids))
(Eng_label-group_elements ? $?egids)
(test (member$ ?id $?egids))
(Hnd_label-group_elements ? $?hgids)
(test (member$ ?hid $?hgids))
(iter-type-eng_g_id-h_g_id ?iter1 anchor ?id1 ?hid1)
(test (member$ ?id1 $?egids))
(test (member$ ?hid1 $?hgids))
(or (id-root ?id ?rt) (id-conll_root ?id ?rt))
(test (neq (gdbm_lookup "computer_science.gdbm" (str-cat ?rt "_noun")) FALSE))
(not (anchor_decided ?hid))
=>
	(bind ?mng (gdbm_lookup "computer_science.gdbm" (str-cat ?rt "_noun")))
        (bind $?mngs  (explode$ (implode$ (remove_character "/"  ?mng " "))))
        (if (member$ ?hwrd $?mngs) then
		(retract ?f)
		(assert (iter-type-eng_g_id-h_g_id ?iter anchor ?id ?hid))
	)
)


;Decide using default dic:
(defrule decide_anchor_using_dic
?f<-(iter-type-eng_g_id-h_g_id ?iter potential ?id ?hid)
(manual_mapped_id-word	?hid ?hwrd)
(id-org_wrd-root-dbase_name-mng ? ? ?rt  default-iit-bombay-shabdanjali-dic_smt.gdbm ?hwrd)
(or (id-root ?id ?rt) (id-conll_root ?id ?rt))
(hindi_head_id-grp_ids ?head_id $?ids)
(test (member$ ?hid $?ids))
(not (anchor_decided ?head_id))
=>
	(retract ?f)
	(assert (iter-type-eng_g_id-h_g_id (+ ?iter 1) anchor ?id ?head_id))
	(assert (anchor_decided_e_id-h_id ?id  ?head_id))
	(assert (anchor_decided ?head_id))
)

;A system with intelligence is expected to behave in the [best] possible manner.
;buxXi se yukwa praNAlI se apekRA kI jAwI hE ki vaha [uwwama se uwwama] Dafga se vyavahAra kare  .
;Decide using default dic if anchor/potential fact not available
(defrule decide_anchor_using_dic_whn_no_anchor_fact
(manual_mapped_id-word  ?hid ?hwrd)
(id-org_wrd-root-dbase_name-mng ? ? ?rt  default-iit-bombay-shabdanjali-dic_smt.gdbm ?hwrd)
(or (id-root ?id ?rt) (id-conll_root ?id ?rt))
(hindi_head_id-grp_ids ?head_id $?ids)
(test (member$ ?hid $?ids))
(not (anchor_decided ?head_id))
(not (iter-type-eng_g_id-h_g_id ?iter ? ?id ?));Checking there is no potential/anchor fact for 'best'
(not (iter-type-eng_g_id-h_g_id ?iter ? ? $? ?head_id $?)) ;Checking 'uwwama' is not aligned in any other fact.
(id-cat_coarse ?id ?cat&~preposition)
=>
        (assert (iter-type-eng_g_id-h_g_id 1 anchor ?id ?head_id))
        (assert (anchor_decided_e_id-h_id ?id  ?head_id))
	(assert (anchor_decided ?head_id))
)


;Rational Action is the action that [maximizes] the expected value of the performance measure given the percept sequence to date.
; yukwisafgawa kriyA , vaha kriyA howI hE , jo wiWi karane ke lie boXa anukrama meM xie gae niRpAxana mApa ke apekRiwa mUlya ko [aXikawama karawI hE] . 
(defrule decide_anchor_for_no_match
(no_match_found ?hid ?)
(manual_mapped_id-root ?hid ?hwrd)
(or (id-root ?id ?rt) (id-conll_root ?id ?rt))
(test (neq (gdbm_lookup "default-iit-bombay-shabdanjali-dic_smt.gdbm" ?rt) FALSE))
(not (iter-type-eng_g_id-h_g_id ? ? ?id $?))
(not (iter-type-eng_g_id-h_g_id ? ? ? $? ?hid $?))
(not (anchor_decided ?hid))
=>
	(bind ?mng (gdbm_lookup "default-iit-bombay-shabdanjali-dic_smt.gdbm" ?rt))
        (bind $?mngs  (explode$ (implode$ (remove_character "/"  ?mng " "))))
	(if (member$ ?hwrd $?mngs) then
		(assert (iter-type-eng_g_id-h_g_id  1 potential ?id ?hid))
	;	(assert (anchor_decided_e_id-h_id ?id  ?hid))
	)
)



(defrule align_prep_using_dic
(or (id-root ?id ?rt) (id-conll_root ?id ?rt))
(not (iter-type-eng_g_id-h_g_id  ? ? ?id $?))
(Eng_label-group_elements ?elab $?eids)
(test (member$ ?id $?eids))
(iter-type-eng_g_id-h_g_id  ?iter anchor ?id1 $?ids)
(test (member$ ?id1 $?eids))
(id-org_wrd-root-dbase_name-mng ? ? ?rt default-iit-bombay-shabdanjali-dic_smt.gdbm $?mngs)
?f<-(Hnd_label-group_elements ?hlab $?hids1 ?h)
(test (subsetp $?ids $?hids1))
?f1<-(Hnd_label-group_elements ?hlab2 $?hids2)
(test (member$ (+ ?h 1) $?hids2))
?f2<-(Hnd_label-group_words ?hlab $?h_wrds ?hw)
?f3<-(Hnd_label-group_words ?hlab2 $?h_wrds1)
=>
        (bind $?new_mng (create$ ?hw $?h_wrds1))
        (if (eq $?mngs $?new_mng) then
                (retract ?f ?f1 ?f2 ?f3)
                (bind ?new_lab (string-to-field (str-cat ?hlab "_" ?hlab2)))
                (assert (Hnd_label-group_elements ?new_lab $?hids1 ?h $?hids2))
                (assert (Hnd_label-group_words ?new_lab  $?h_wrds ?hw $?h_wrds1))
;               (assert (iter-type-eng_g_id-h_g_id ?
                (printout t ?rt " " $?mngs crlf)
        )
)


(defrule remove_pot_if_anc_decided
(declare (salience -2))
?f<-(iter-type-eng_g_id-h_g_id ?iter potential ?id $?hids)
;(not (iter-type-eng_g_id-h_g_id ? anchor ?id ?))
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


;Align using hindi_wordnet 
;In manju rule's hindi_wordnet_match is brought from older version hindi_wordnet dics (where hindi_wordnet_dic1.txt and  hindi_wordnet_dic2.txt are inputs)
;'hindi_wordnet_match_using_dic' source is from latest dics given by Sriram ji category wise but default dic is also used to get the match
;So to get purely hindi_wordnet_match on latest dics below rule is written on Suggestion of Chaitanya Sir.
;The dream of making a computer imitate [humans] also has a very early history. 
;[iMsAnoM] kI nakala karane vAle kampyUtara banAne kA sapanA BI bahuwa jalxI iwihAsa bana jAwA hE .
(defrule match_hindi_wrdnet_noun
(id-anu_root ?id ?rt )
(id-cat_coarse ?id noun)
(manual_mapped_id-root ?hid ?hwrd)
(test (neq (gdbm_lookup "hnd-wrdnet-noun.gdbm" ?rt) FALSE))
;(not (iter-type-eng_g_id-h_g_id  ? ? ?id ?))
=>
	(bind ?mng (gdbm_lookup "hnd-wrdnet-noun.gdbm" ?rt))
        (bind $?mngs  (explode$ (implode$ (remove_character "/"  ?mng " "))))
        (if (member$ ?hwrd $?mngs) then
              ;  (assert (iter-type-eng_g_id-h_g_id  1 anchor ?id ?hid))
                (assert (anchor_decided_e_id-h_id ?id  ?hid))
        )
)
  

(defrule match_hindi_wrdnet_verb
(id-anu_root ?id ?rt )
(id-cat_coarse ?id verb)
(manual_mapped_id-root ?hid ?hwrd)
(test (neq (gdbm_lookup "hnd-wrdnet-verb.gdbm" ?rt) FALSE))
(not (iter-type-eng_g_id-h_g_id  ? ? ?id ?)) 
=>
        (bind ?mng (gdbm_lookup "hnd-wrdnet-verb.gdbm" ?rt))
        (bind $?mngs  (explode$ (implode$ (remove_character "/"  ?mng " "))))
        (if (member$ ?hwrd $?mngs) then
               ; (assert (iter-type-eng_g_id-h_g_id  1 anchor ?id ?hid))
                (assert (anchor_decided_e_id-h_id ?id  ?hid))
        )
)


(defrule match_hindi_wrdnet_adj
(id-anu_root ?id ?rt )
(id-cat_coarse ?id adjective)
(manual_mapped_id-root ?hid ?hwrd)
(test (neq (gdbm_lookup "hnd-wrdnet-adj.gdbm" ?rt) FALSE))
(not (iter-type-eng_g_id-h_g_id  ? ? ?id ?)) 
=>
        (bind ?mng (gdbm_lookup "hnd-wrdnet-adj.gdbm" ?rt))
        (bind $?mngs  (explode$ (implode$ (remove_character "/"  ?mng " "))))
        (if (member$ ?hwrd $?mngs) then
               ; (assert (iter-type-eng_g_id-h_g_id  1 anchor ?id ?hid))
                (assert (anchor_decided_e_id-h_id ?id  ?hid))
        )
)


(defrule match_hindi_wrdnet_adv
(id-anu_root ?id ?rt )
(id-cat_coarse ?id adverb)
(manual_mapped_id-root ?hid ?hwrd)
(test (neq (gdbm_lookup "hnd-wrdnet-adv.gdbm" ?rt) FALSE))
(not (iter-type-eng_g_id-h_g_id  ? ? ?id ?))
=>
        (bind ?mng (gdbm_lookup "hnd-wrdnet-adv.gdbm" ?rt))
        (bind $?mngs  (explode$ (implode$ (remove_character "/"  ?mng " "))))
        (if (member$ ?hwrd $?mngs) then
               ; (assert (iter-type-eng_g_id-h_g_id  1 anchor ?id ?hid))
                (assert (anchor_decided_e_id-h_id ?id  ?hid))
        )
)

;ai1E 2.10
(defrule decide_hin_ids_based_on_wrdnet
(declare (salience -1))
?f<- (anchor_decided_e_id-h_id ?id $?hids)
?f1<-(anchor_decided_e_id-h_id ?id ?hid)
(test (eq (member$ ?hid $?hids) FALSE))
=>
	(retract ?f ?f1)
	(assert (anchor_decided_e_id-h_id ?id (sort > (create$  $?hids ?hid))))
)


;(defrule decide_anchor_based_on_wordnet
;(anchor_decided_e_id-h_id ?id $?hids)
;(iter-type-eng_g_id-h_g_id  ?iter ?type ?id $?h)
;=>
;	(assert (iter-type-eng_g_id-h_g_id  1 potential  ?id $?hids))
;)

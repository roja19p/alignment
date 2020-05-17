
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


;(defrule check_for_yaxi_clause
;(Hnd_parent-sanwawi ?hid $?hids)
;(manual_mapped_id-word	?id yaxi)
;(test (member$ ?id $?hids))
;=>
;	(printout t "yaxi clause " $?hids crlf)
;	(assert (yaxi_clause_head_id-gids ?hid $?hids))
;)
;
;;In hindi 'yaxi' might be absent ..so using Eng 'if' identifying the clause
;(defrule check_for_if_clause
;(Eng_parent-sanwawi ?eid $?ids)
;(id-word ?id ?wrd&if)
;(test (member$ ?id $?ids))
;=>
;	(printout t "if clause "  $?ids crlf)
;	(assert (if_clause_head_id-gids ?eid  $?ids))
;)
;
;(defrule check_for_then_in_if_clause
;?f<-(Eng_parent-sanwawi ?eid $?ids)
;?f1<-(if_clause_head_id-gids ?if  $?ids)
;(id-word ?id ?wrd&then)
;(test (member$ ?id $?ids))
;=>
;	(retract ?f ?f1)
;	(bind $?ids (delete-member$ $?ids ?id))
;	(printout t "modifying_if_clause_by_removing_then " $?ids)
;	(assert (if_clause_head_id-gids ?eid  $?ids))
;	(assert (Eng_parent-sanwawi ?eid $?ids))
;)
;
;;check for then
;(defrule check_for_then_clause
;?f<-(Eng_parent-sanwawi ?eid $?ids)
;(id-word ?id ?wrd&then)
;(test (member$ ?id $?ids))
;(if_clause_head_id-gids ?if  $?gids)
;(test (subsetp $?gids $?ids))
;=>
;	(retract ?f)
;	(bind $?then_ids $?ids)
;	(loop-for-count (?i 1 (length $?then_ids))
;		(bind ?var (nth$ ?i $?then_ids))
;		(if (or (member$ ?var $?gids) (eq ?var ?if)) then
;			(bind $?ids (delete-member$ $?ids ?var))
;		)
;	)
;	(printout t "then_clause" ?eid " " $?ids)
;	(assert (then_clause_head_id-gids ?eid  $?ids))
;	(assert (Eng_parent-sanwawi ?eid $?ids))
;)
;
;(defrule check_for_wo_clause
;(declare (salience 10))
;?f<-(Hnd_parent-sanwawi ?hid $?hids)
;(manual_mapped_id-word  ?id wo)
;(test (member$ ?id $?hids))
;(yaxi_clause_head_id-gids ?yaxi_h_id $?gids)
;(test (subsetp $?gids $?hids))
;=>
;	(retract ?f)
;	(bind $?wo_ids $?hids)
;	(loop-for-count (?i 1 (length $?wo_ids))
;		(bind ?var (nth$ ?i $?wo_ids))
;		(if (or (member$ ?var $?gids) (eq ?var ?yaxi_h_id)) then
;			(bind $?hids (delete-member$ $?hids ?var))
;		)
;	)
;	(printout t "wo_clause" ?hid "  " $?hids crlf)
;	(assert (wo_clause_head_id-gids ?hid  $?hids))
;	(assert (Hnd_parent-sanwawi ?hid $?hids))
;)
;
;[If an element of interference or uncertainty occurs] then the environment is stochastic.
(defrule align_if_clause
(if_clause_head_id-gids ?if_head  $?gids)
?f<-(iter-type-eng_g_id-h_g_id ?iter potential ?eid $?ids)
(test (or (member$ ?eid $?gids) (eq ?if_head ?eid)))
(yaxi_clause_head_id-gids ?yaxi_head $?hids)
(iter-type-eng_g_id-h_g_id ? anchor ?id ?hid)
(test (or (member$ ?id $?gids) (eq ?id ?if_head)))
(test (member$ ?hid $?hids))
=>
	(loop-for-count (?i 1 (length $?ids))
		(bind ?n (nth$ ?i $?ids))
		(bind ?yaxi_clause_ids (create$ ?yaxi_head $?hids))
		(if (eq (member$  ?n ?yaxi_clause_ids) FALSE) then
			(if (> (length $?ids) 1) then
				(printout t ?n crlf)
				(bind ?new_ids (delete-member$ $?ids ?n))
				(assert (iter-type-eng_g_id-h_g_id (+ ?iter 1) potential ?eid ?new_ids))
				(retract ?f)
			)
		)
	)
)


;(defrule get_main_clause_frm_rel_clause
;?f<-(Eng_parent-sanwawi ?e_p $?eids)
;(Eng_parent-sanwawi ?e_p1 $?eids1)
;(test (neq ?e_p ?e_p1))
;(id-word ?id ?wrd&which|that)
;(test (eq (nth$ 1 $?eids1) ?id))
;(test (member$ ?id  $?eids))
;;(test (subsetp (create$ ?e_p1 $?eids) $?eids1))
;(not (clause_decided ?e_p))
;=>
;	(retract ?f)
;	(bind $?n (sort > (create$ ?e_p1 $?eids1)))
;	(printout t (type $?eids) crlf)
;	(printout t (type $?n) crlf)
;	(bind ?new_ids (delete-member$ $?eids $?n))
;	(printout t ?new_ids crlf)
;	(assert (Eng_parent-sanwawi ?e_p ?new_ids))
;	(assert (clause_decided ?e_p))
;)	
;

;lakRya rAjyoM aksara eka lakRya parIkRaNa xvArA nirxiRta kara rahe hEM [jo kisI BI lakRya rAjya ko sanwuRta karanA cAhie].
(defrule  align_jo_clause
(Eng_parent-sanwawi ?e_p ?which $?eids)
(id-word ?which which|that)
?f<-(iter-type-eng_g_id-h_g_id ?iter potential ?eid $?hids)
(test (member$ ?eid $?eids))
(Hnd_parent-sanwawi ?par ?jo $?ids)
(manual_mapped_id-word ?id1 ?hwrd)
(test (member$ ?id1 $?hids))
(test (member$ ?id1 $?ids)) 
(not (anchor_decided ?eid))
=>
	(assert (iter-type-eng_g_id-h_g_id (+ ?iter 1) potential ?eid ?id1))
	(assert (anchor_decided ?eid))
        (retract ?f)
)

;He even propounded the possibility of letting the machine alter its own instructions so [that] machines can learn from experience.
;unhoMne [isa] bAwa kI samBAvanA BI prawipAxiwa kI ki maSIna ko apane nirxeSoM meM parivarwana karane xiyA jAe wAki maSInoM ko anuBava se sIKA jA sake
(defrule cross_check_jo_clause
(Eng_parent-sanwawi ?e_p ?which $?eids)
(id-word ?which which|that)
?f<-(iter-type-eng_g_id-h_g_id ?iter anchor ?which ?hid)
(Hnd_parent-sanwawi ?par ?jo $?ids)
(manual_mapped_id-word ?jo ?hwrd&wAki|jo)
(test (eq (member$ ?hid $?ids) FALSE))
=>
	(retract ?f)
)

;Goal states are often specified by a [goal test] which any goal state must satisfy.
;lakRya rAjyoM aksara eka [lakRya parIkRaNa] xvArA nirxiRta kara rahe hEM jo kisI BI lakRya rAjya ko sanwuRta karanA cAhie. 
(defrule comp_rule_in_hin1
?f<-(iter-type-eng_g_id-h_g_id ?iter potential ?e2 $?hids)
(eng_relation_name-head-chiid compound ?e1 ?e2 )
(iter-type-eng_g_id-h_g_id ?iter1 anchor ?e1 $?ids)
(hnd_relation_name-head-chiid compound ?h1 ?h2)
(test (member$ ?h1 $?ids))
(test (member$ ?h2 $?hids))
(not (anchor_decided ?e2))
=>
	(retract ?f)
        (assert (iter-type-eng_g_id-h_g_id (+ ?iter 1) potential ?e2 ?h2))
	(assert (anchor_decided_e_id-h_id ?e2 ?h2))
	(assert (anchor_decided ?e2))
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


;[Rational Action] is the action that maximizes the expected value of the performance measure given the percept sequence to date.
;[yukwisafgawa kriyA], vaha kriyA howI hE, jo wiWi karane ke lie boXa anukrama meM xie gae niRpAxana mApa ke apekRiwa mUlya ko aXikawama karawI hE.
(defrule align_thru_unlabeled_info
(eng_relation_name-head-chiid ?rel ?e1 ?e2)
(iter-type-eng_g_id-h_g_id ?iter  anchor ?e1 $?hids)
(hnd_relation_name-head-chiid ?rel1 ?h1 ?h2)
(test (member$ ?h1 $?hids))
(hindi_head_id-grp_ids ?h2 $?h2_ids)
(not (iter-type-eng_g_id-h_g_id ?  ? ?e2 $?))
(not (iter-type-eng_g_id-h_g_id ?  ? ? $? ?h2 $?)) ;added this condition to stop firing in Ex: One of [the] rooms contains a computer.
(test (and (neq ?rel case) (neq ?rel aux))) ;Ex: He [can] ask questions through a teletype and receives answers from both A and B.
(test (neq ?rel1 case))
(not (hnd_relation_name-head-chiid case ?h2 ?)) ;Ex: He can ask questions [through] a teletype and receives answers from both A and B.
(not (anchor_decided ?e2))
=>
	(assert (iter-type-eng_g_id-h_g_id 1 anchor ?e2 ?h2))
	(assert (anchor_decided ?e2))
)


(defrule align_thru_unlabeled_info1
(eng_relation_name-head-chiid ?rel ?e1 ?e2)
(iter-type-eng_g_id-h_g_id ?iter  anchor ?e2 $?hids)
(hnd_relation_name-head-chiid ?rel1 ?h1 ?h2)
(test (member$ ?h2 $?hids))
(hindi_head_id-grp_ids ?h1 $?h2_ids)
(not (iter-type-eng_g_id-h_g_id ? ? ?e1 $?))
(test (neq ?e1 0)) ;Is it that which characterize humans?
(not (iter-type-eng_g_id-h_g_id ? anchor ? ?h1))  ;Turing's 'imitation game' is now usually called 'the Turing test' for intelligence.
=>
        (assert (iter-type-eng_g_id-h_g_id 1 anchor ?e1 ?h1))
)


;This [view] is the cognitive science [approach] to AI.
;yaha [xqRtikoNa] eAI ke lie saFjFAnAwmaka vijFAna [xqRtikoNa] hE  .
(defrule align_thru_unlabeled_info_whn_fact_avl1
(eng_relation_name-head-chiid ?rel ?e1 ?e2)
(iter-type-eng_g_id-h_g_id ?iter  anchor ?e2 $?hids)
(hnd_relation_name-head-chiid ?rel1 ?h1 ?h2)
(test (member$ ?h2 $?hids))
(hindi_head_id-grp_ids ?h1 $?h2_ids)
(iter-type-eng_g_id-h_g_id ?iter1 potential ?e1 $?)
(not (iter-type-eng_g_id-h_g_id ? anchor  ? ?h1))  ; One room has one computer.
=>
        (assert (iter-type-eng_g_id-h_g_id (+ ?iter 1) anchor ?e1 ?h1))
)


;One of the rooms contains [a] computer.
(defrule align_thru_unlabelled_info_whn_fact_avl
(eng_relation_name-head-chiid ?rel ?e1 ?e2)
(iter-type-eng_g_id-h_g_id ?iter  anchor ?e1 $?hids1)
?f1<-(iter-type-eng_g_id-h_g_id ?iter1  potential ?e2 $?hids2)
(hnd_relation_name-head-chiid ?rel1 ?h1 ?h2)
(test (member$ ?h1 $?hids1))
(test (member$ ?h2 $?hids2))
(not (anchor_decided ?e2))
=>
	(retract ?f1)
	(assert (iter-type-eng_g_id-h_g_id (+ ?iter1 1) anchor ?e2 ?h2))
	(assert (anchor_decided ?e2))
)


;Goal states are often [specified] by a goal test which any goal state must satisfy.
;lakRya rAjyoM aksara eka lakRya parIkRaNa xvArA [nirxiRta kara rahe hEM] jo kisI BI lakRya rAjya ko sanwuRta karanA cAhie.
(defrule align_thru_unlabeled_info_for_root
(eng_relation_name-head-chiid root ?e1 ?e2)
(hnd_relation_name-head-chiid root ?h1 ?h2)
(not (iter-type-eng_g_id-h_g_id ?  ? ?e2 $?))
(not (eng_relation_name-head-chiid cop ?e2 ?)) ;If an element of interference or uncertainty occurs then the environment [is stochastic].
(hindi_head_id-grp_ids ?h $?hids)
(test (member$ ?h2 $?hids))
(not (iter-type-eng_g_id-h_g_id ?  ? ? $? ?h $?))
=>
        (assert (iter-type-eng_g_id-h_g_id 1 anchor ?e2 ?h))
)

;The advent of electronic computers provided a revolutionary advance in the ability to study intelligence.
;ilektraoYnika kampyUtaroM ke Agamana se buxXi kA [aXyayana karane kI] kRamawA meM krAnwikArI pragawi huI.
(defrule align_kI
(Hnd_label-group_elements ?lab $?gids)
(manual_mapped_id-word ?id kI)
?f<-(hindi_head_id-grp_ids ?h $?ids)
(test (member$ ?id $?gids))
(test (member$ (- ?id 1) $?ids))
(test (eq (member$ ?id $?ids) FALSE))
=>
	(retract ?f)
	(assert (hindi_head_id-grp_ids ?h $?ids ?id))
	(printout t "Warning:: Aligned kI ... " ?id crlf)
)
	
 
(defrule align_transliterate_wrd
(eng_wrd-transliterate_wrd ?wrd ?hwrd)
(id-original_word ?id  ?wrd)
(manual_mapped_id-word ?hid ?hwrd)
(not (iter-type-eng_g_id-h_g_id ?  ? ?id $?))
=>
	(assert (iter-type-eng_g_id-h_g_id  1 anchor ?id ?hid))
)


(defrule align_transliterate_wrd_in_pot
(eng_wrd-transliterate_wrd ?wrd ?hwrd)
(id-original_word ?id  ?wrd)
(manual_mapped_id-word ?hid ?hwrd)
?f<-(iter-type-eng_g_id-h_g_id ?iter potential  ?id $?)
=>
	(retract ?f)
        (assert (iter-type-eng_g_id-h_g_id  (+ ?iter 1) anchor ?id ?hid))
)


;Aligning through tam info
(defrule align_thru_tam_info
(id-tam_info_ids  ?eid ?hid $?hids)
?f<-(iter-type-eng_g_id-h_g_id ?iter ?potential ?eid $?)
(hindi_head_id-grp_ids ?hid $?hgids)
(not (anchor_decided ?eid ?hid))
=>
	(retract ?f)
	(bind $?ids (create$ ?hid $?hids))
	(assert (iter-type-eng_g_id-h_g_id (+ ?iter 1) anchor ?eid ?hid))	
	(assert (anchor_decided ?eid ?hid))
)


(defrule align_thru_tam_info1
(id-tam_info_ids  ?eid ?hid $?hids)
(hindi_head_id-grp_ids ?hid $?hgids)
(not (iter-type-eng_g_id-h_g_id ?iter ?potential ?eid $?))
(not (anchor_decided ?eid ?hid))
=>
	(bind $?ids (create$ ?hid $?hids))
	(assert (anchor_decided ?eid ?hid))
)

;A system with intelligence is [expected] to [behave] as intelligently as a human. 
;buxXi se yukwa praNAlI se mAnava kI waraha buxXimAnI se [vyavahAra karane kI]	[apekRA kI jAwI hE]  . 
;(defrule correcting_hindi_head_id_gids_fact_using_kriyA_mUla_info
;(verb_root_hid-gids ?hid $?gids)
;?f<-(hindi_head_id-grp_ids ?hid1 $?hgids1)
;?f1<-(hindi_head_id-grp_ids ?hid2 $?hgids2)
;(test (member$ ?hid $?hgids1))
;(test (subsetp $?hgids2 $?gids))
;(not (group_corrected ?hid))
;=>
;	(retract ?f ?f1)
;	(bind ?new_ids (delete-member$ $?hgids1 ?hid))
;	(assert (hindi_head_id-grp_ids ?hid1 ?new_ids))
;	(assert (hindi_head_id-grp_ids ?hid $?gids))
;	(assert (group_corrected ?hid))
;)
;
;

;Combining two different hindi groups based on dic and anchor fact
;He can ask questions [[through] [a teletype]] and receives answers from both A and B.
;vaha [eka telItAipa ke] [mAXyama se] savAla pUCa sakawe hEM Ora xonoM e Ora bI se javAba prApwa kara sakawe hEM  .  )
(defrule align_prep_using_dic
(or (id-root ?id ?rt) (id-conll_root ?id ?rt))
(not (iter-type-eng_g_id-h_g_id  ? ? ?id $?))
(Eng_label-group_elements ?elab $?eids)
(test (member$ ?id $?eids))
(iter-type-eng_g_id-h_g_id  ?iter anchor ?id1 $?ids ?i)
(test (member$ ?id1 $?eids))
(id-org_wrd-root-dbase_name-mng ? ? ?rt default-iit-bombay-shabdanjali-dic_smt.gdbm $?mngs)
?f<-(Hnd_label-group_elements ?hlab $?hids1 ?h)
(test (subsetp $?ids $?hids1))
?f1<-(Hnd_label-group_elements ?hlab2 $?hids2)
(test (member$ (+ ?h 1) $?hids2))
?f2<-(Hnd_label-group_words ?hlab $?h_wrds ?hw)
?f3<-(Hnd_label-group_words ?hlab2 $?h_wrds1)
?f4<-(hindi_head_id-grp_ids ?i $?hids)
?f5<-(hindi_head_id-grp_ids ?h1 $?h_ids)
(test (member$ ?h $?hids))
(test (member$ (+ ?h 1) $?h_ids))
(test (neq ?i ?h1))
=>
	(bind $?new_mng (create$ ?hw $?h_wrds1))
	(if (eq $?mngs $?new_mng) then
		(retract ?f ?f1 ?f2 ?f3)
		(bind ?new_lab (string-to-field (str-cat ?hlab "_" ?hlab2)))
		(assert (Hnd_label-group_elements ?new_lab $?hids1 ?h $?hids2))
		(assert (Hnd_label-group_words ?new_lab  $?h_wrds ?hw $?h_wrds1))
		(assert (hindi_head_id-grp_ids ?i $?hids $?h_ids))
		(printout t ?rt " " $?mngs crlf)
	)
)



;These rules are not in use..if neccessary modify accordingly
;(defrule pick_p_layer_if_clause
;(if_clause_head_id-gids ?id  $?gids)
;(Eng_parent-sanwawi ?id $?gids)
;(P1 $?ids)
;=>
;	(bind ?pids (create$ ))
;	(loop-for-count (?i 1 (length $?gids)) 
;               (bind ?pids (create$ ?pids (nth$ ?i $?ids)))
;
;       )
;	(bind ?pids (create$ ?pids (nth$ ?id $?ids)))
;       (assert (head_id-hindi_ids ?id ?pids))
;       (printout t ?pids crlf)
;)
;
;(defrule pick_p_layer_then_clause
;(then_clause_head_id-gids ?id  $?gids)
;(Eng_parent-sanwawi ?id $?gids)
;(P1 $?ids)
;=>
;	(bind ?pids (create$ ))
;	(loop-for-count (?i 1 (length $?gids))
;               (bind ?pids (create$ ?pids (nth$ ?i $?ids)))
;
;	)
;	(bind ?pids (create$ ?pids (nth$ ?id $?ids)))
;       (assert (head_id-hindi_ids ?id ?pids))
;       (printout t ?pids crlf)
;)
;
;
;(defrule check_p_layer_if_clause
;(head_id-hindi_ids ?id $?hids)
;?f<-(P1 $?ids)
;(yaxi_clause_head_id-gids ?yaxi $?gids)
;(Hnd_parent-sanwawi ?yaxi $?san)
;=>
;	(loop-for-count (?i 1 (length $?hids))
;		(bind ?var (nth$ ?i $?hids))
;		(if (eq (member$ ?var $?gids) FALSE) then
;			(if (neq ?var 0) then 
;			(if (and (neq (type ?var) INTEGER) (neq (str-index "," ?var) FALSE ))  then
;			;(if  (neq (str-index "," ?var) FALSE )  then
;				(bind $?items (explode$ (implode$ (remove_character "," ?var " "))))
;				(if (eq (member$ (nth$ 1 $?items) $?gids) FALSE) then
;					(assert (wrong_eng_h_id-wrong_eng_id-hnd_h_id-hids ?id ?i ?yaxi ?var))
;					(printout t "eng_id-hnd_h_id-wrong_hids " ?i  " " ?var crlf)
;				else
;		                        (bind $?san (delete-member$ $?san $?items))
;					(printout t $?san crlf)
;				)
;			))
;		else
;			(bind $?san (delete-member$ $?san ?var))
;		)
;	)
;	(assert (wrong_eng_h_id-exp_id ?id $?san))
;) 
;
;(defrule correct_wrong_ids
;(declare (salience 10))
;?f<-(wrong_eng_h_id-wrong_eng_id-hnd_h_id-hids ?id ?eng ?hnd ?hids)
;(wrong_eng_h_id-exp_id ?id ?ex_id)
;(Hnd_parent-sanwawi ?hnd $?san)
;(Hnd_label-group_elements ?hlab $?gids)
;(test (member$ ?ex_id $?gids))
;?f1<-(P1 $?ids)
;(not (fact_corrected_id ?id))
;=>
;        (bind ?var (explode$ (implode$ (remove_character " " (implode$ $?gids) ","))))
;	(bind $?new_ids (replace$ $?ids ?eng ?eng ?var))
;	(retract ?f ?f1)
;	(assert (P1 $?new_ids))
;	(assert (fact_corrected_id ?id))
;	(assert (grouping_corrected_id-prev_val ?id ?hids))
;
;)
;
;(defrule interchange_grp_val_aft_correction
;(declare (salience 10))
;(grouping_corrected_id-prev_val  ?id $?val)
;?f<-(P1 $?ids)
;(not (fact_value_asserted $?val))
;
;=>
;	(bind ?var (nth$ ?id $?ids))
;	(loop-for-count (?i 1 (length $?ids))
;		(bind ?var1 (nth$ ?i $?ids))
;		(if (and (eq ?var ?var1) (neq ?i ?id)) then 
;                	(bind ?new_ids (replace$ $?ids ?i ?i $?val))
;	                (assert (P1 ?new_ids))
;			(assert (fact_corrected_id ?i))
;			(assert (fact_value_asserted $?val))
;                	(retract ?f)
;        	)
;	)
;)
;
;
;

;ai2E 2.3, [Human beings] do not satisfy this definition of rationality.
; [manuRya] buxXi kI isa pariBARA se sanwuRta nahIM howA.
(defrule eng_comp_rule_with_same_mng
?f<-(iter-type-eng_g_id-h_g_id ?iter potential ?head  $?ids)
?f1<-(iter-type-eng_g_id-h_g_id ?iter1 potential ?child  $?ids)
(eng_relation_name-head-chiid compound ?head  ?child )
=>
	(retract ?f ?f1)
	(assert (iter-type-eng_g_id-h_g_id (+ ?iter 1) anchor  ?head $?ids))
	(assert (iter-type-eng_g_id-h_g_id (+ ?iter1 1) anchor  ?child 0))
)


;ai2E, 2.38 Rational Action is the [action] that maximizes the expected value of the performance measure given the percept sequence to date.
;yukwisafgawa kriyA, vaha [kriyA howI] hE, jo wiWi karane ke lie boXa anukrama meM xie gae niRpAxana mApa ke apekRiwa mUlya ko aXikawama karawI hE.
(defrule comp_rule_in_hin
?f<-(iter-type-eng_g_id-h_g_id ?iter potential ?h $?hids)
(hnd_relation_name-head-chiid compound ?h ?hid )
(test (member$ ?hid $?hids))
=>
	(retract ?f)
	(assert (iter-type-eng_g_id-h_g_id  (+ ?iter 1) anchor ?h ?hid))
	(assert (anchor_decided ?hid))
)


(defrule del_if_anch_decided
?f<-(iter-type-eng_g_id-h_g_id ?iter potential ?h $?hids)
(anchor_decided ?hid)
(test (member$ ?hid $?hids))
(not (iter-type-eng_g_id-h_g_id ?iter1 anchor ?h $?))
=>
	(retract ?f)
	(bind ?new_ids (delete-member$ $?hids ?hid))
	(assert (iter-type-eng_g_id-h_g_id  (+ ?iter 1) potential ?h ?new_ids))
)

(defrule del_if_anch_decided1
(declare (salience 10))
?f<-(iter-type-eng_g_id-h_g_id ?iter potential ?h $?hids)
(anchor_decided ?hid)
(test (member$ ?hid $?hids))
(iter-type-eng_g_id-h_g_id ?iter1 anchor ?h $?)
=>
        (retract ?f)
)


;ai2E, 2.38 [Rational Action] is the action that maximizes the expected value of the performance measure given the percept sequence to date.
;[yukwisafgawa kriyA], vaha kriyA howI hE, jo wiWi karane ke lie boXa anukrama meM xie gae niRpAxana mApa ke apekRiwa mUlya ko aXikawama karawI hE.
(defrule align_comp_using_grouping
(iter-type-eng_g_id-h_g_id ?iter anchor ?id $?hids)
(eng_relation_name-head-chiid compound ?id ?c )
(Eng_label-group_elements ?lab $?eids)
(test (and (member$ ?id $?eids) (member$ ?c $?eids)))
(Hnd_label-group_elements ? $?h_ids)
(hindi_head_id-grp_ids ?h $?h_gids)
(test (member$ $?hids $?h_ids))
(test (member$ ?h $?h_ids))
(not (eng_anchor_decided ?c))
(not (anchor_decided $?hids))
=>
	(printout t $?h_ids crlf)
	(printout t $?h_gids crlf)

	(bind ?new_id (delete-member$ $?h_ids $?h_gids))
	(assert (iter-type-eng_g_id-h_g_id (+ ?iter 1) anchor ?c ?new_id))
	(assert (anchor_decided ?new_id))
	(assert (eng_anchor_decided ?c))
)

;;ai2E, 2.38 [Rational Action] is the action that maximizes the expected value of the performance measure given the percept sequence to date.
;;yukwisafgawa kriyA, vaha [kriyA howI] hE, jo wiWi karane ke lie boXa anukrama meM xie gae niRpAxana mApa ke apekRiwa mUlya ko aXikawama karawI hE.
;(defrule align_using_eng_and_hindi_parse
;(eng_relation_name-head-chiid ?rel  ?h ?c )
;(iter-type-eng_g_id-h_g_id ?iter anchor ?h $?hids)
;(hnd_relation_name-head-chiid ?rel ?h1 ?c1 )
;(test (or (member$ ?h1 $?hids)
	  

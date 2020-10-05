(defrule group_three_wrds_vib1
(declare (salience 1))
?f<-(hindi_head_id-grp_ids ?id ?id)
?f1<-(hindi_head_id-grp_ids =(+ ?id 1) =(+ ?id 1))
?f2<-(hindi_head_id-grp_ids =(+ ?id 2) =(+ ?id 2))
?f3<-(hindi_head_id-grp_ids =(+ ?id 3) =(+ ?id 3))
(id-hnd_clause_wrd =(+ ?id 1) ?vib&ke)
(id-hnd_clause_wrd =(+ ?id 2) ?vib1&bAre|rUpa)
(id-hnd_clause_wrd =(+ ?id 3) ?vib2&meM)
=>
        (retract ?f ?f1 ?f2 ?f3)
        (assert (hindi_head_id-grp_ids ?id ?id (+ ?id 1) (+ ?id 2) (+ ?id 3)))
)

(defrule group_three_wrds_vib2
(declare (salience 1))
?f<-(hindi_head_id-grp_ids ?id ?id)
?f1<-(hindi_head_id-grp_ids =(+ ?id 1) =(+ ?id 1))
?f2<-(hindi_head_id-grp_ids =(+ ?id 2) =(+ ?id 2))
?f3<-(hindi_head_id-grp_ids =(+ ?id 3) =(+ ?id 3))
(id-hnd_clause_wrd =(+ ?id 1) ?vib&ke)
(id-hnd_clause_wrd =(+ ?id 2) ?vib1&mAXyama)
(id-hnd_clause_wrd =(+ ?id 3) ?vib2&se)
=>
        (retract ?f ?f1 ?f2 ?f3)
        (assert (hindi_head_id-grp_ids ?id ?id (+ ?id 1) (+ ?id 2) (+ ?id 3)))
)

;ke_xUra_waka
(defrule group_three_wrds_vib3
(declare (salience 1))
?f<-(hindi_head_id-grp_ids ?id ?id)
?f1<-(hindi_head_id-grp_ids =(+ ?id 1) =(+ ?id 1))
?f2<-(hindi_head_id-grp_ids =(+ ?id 2) =(+ ?id 2))
?f3<-(hindi_head_id-grp_ids =(+ ?id 3) =(+ ?id 3))
(id-hnd_clause_wrd =(+ ?id 1) ?vib&ke)
(id-hnd_clause_wrd =(+ ?id 2) ?vib1&xUra)
(id-hnd_clause_wrd =(+ ?id 3) ?vib2&waka)
=>
        (retract ?f ?f1 ?f2 ?f3)
        (assert (hindi_head_id-grp_ids ?id ?id (+ ?id 1) (+ ?id 2) (+ ?id 3)))
)

;waka_ke_liye
(defrule group_three_wrds_vib4
(declare (salience 1))
?f<-(hindi_head_id-grp_ids ?id ?id)
?f1<-(hindi_head_id-grp_ids =(+ ?id 1) =(+ ?id 1))
?f2<-(hindi_head_id-grp_ids =(+ ?id 2) =(+ ?id 2))
?f3<-(hindi_head_id-grp_ids =(+ ?id 3) =(+ ?id 3))
(id-hnd_clause_wrd =(+ ?id 1) ?vib&waka)
(id-hnd_clause_wrd =(+ ?id 2) ?vib1&ke)
(id-hnd_clause_wrd =(+ ?id 3) ?vib2&liye|lie)
=>
        (retract ?f ?f1 ?f2 ?f3)
        (assert (hindi_head_id-grp_ids ?id ?id (+ ?id 1) (+ ?id 2) (+ ?id 3)))
)


(defrule group_two_wrd_vib1
?f<-(hindi_head_id-grp_ids ?id ?id)
?f1<-(hindi_head_id-grp_ids =(+ ?id 1) =(+ ?id 1))
?f2<-(hindi_head_id-grp_ids =(+ ?id 2) =(+ ?id 2))
(id-hnd_clause_wrd =(+ ?id 1) ?vib&ke)
(id-hnd_clause_wrd =(+ ?id 2) ?vib2&liye|lie|bIca|xOrAna|kAraNa|awirikwa|xvArA|karIba|nIce|Upara|sAWa|aMxara|bAxa|pariNAmasvarUpa|sAWa-sAWa|anusAra|bAhara|prakAra)
(not (id-hnd_clause_wrd =(+ ?id 3) ?vib&ke))
=>
        (retract ?f ?f1 ?f2)
        (assert (hindi_head_id-grp_ids ?id ?id (+ ?id 1) (+ ?id 2)))
)

;meM_se
(defrule group_two_wrd_vib2
?f<-(hindi_head_id-grp_ids ?id ?id)
?f1<-(hindi_head_id-grp_ids =(+ ?id 1) =(+ ?id 1))
?f2<-(hindi_head_id-grp_ids =(+ ?id 2) =(+ ?id 2))
(id-hnd_clause_wrd =(+ ?id 1) ?vib&meM)
(id-hnd_clause_wrd =(+ ?id 2) ?vib1&se)
=>
        (retract ?f ?f1 ?f2)
        (assert (hindi_head_id-grp_ids ?id ?id (+ ?id 1) (+ ?id 2)))
)

;waka
(defrule group_two_wrd_vib3
?f<-(hindi_head_id-grp_ids ?id ?id)
?f1<-(hindi_head_id-grp_ids =(+ ?id 1) =(+ ?id 1))
?f2<-(hindi_head_id-grp_ids =(+ ?id 2) =(+ ?id 2))
(id-hnd_clause_wrd =(+ ?id 1) ?vib&waka)
(id-hnd_clause_wrd =(+ ?id 2) ?vib1&ke|kA|kI)
=>
        (retract ?f ?f1 ?f2)
        (assert (hindi_head_id-grp_ids ?id ?id (+ ?id 1) (+ ?id 2)))
)

;kI_ora
(defrule group_two_wrd_vib4
?f<-(hindi_head_id-grp_ids ?id ?id)
?f1<-(hindi_head_id-grp_ids =(+ ?id 1) =(+ ?id 1))
?f2<-(hindi_head_id-grp_ids =(+ ?id 2) =(+ ?id 2))
(id-hnd_clause_wrd =(+ ?id 1) ?vib&kI)
(id-hnd_clause_wrd =(+ ?id 2) ?vib1&ora)
=>
        (retract ?f ?f1 ?f2)
        (assert (hindi_head_id-grp_ids ?id ?id (+ ?id 1) (+ ?id 2)))
)


(defrule group_single_vib
(declare (salience -1))
?f<-(hindi_head_id-grp_ids ?id ?id)
?f1<-(hindi_head_id-grp_ids =(+ ?id 1) =(+ ?id 1))
(id-hnd_clause_wrd =(+ ?id 1) ?vib&meM|kA|ke|kI|se|ne|para|ko|vAlA|vAlI|vAle|waka|xvArA)
=>
	(retract ?f ?f1)
	(assert (hindi_head_id-grp_ids ?id ?id (+ ?id 1)))
)


(defrule replace_const
?f<-(Head-Level-Mother-Daughters  ?head  ?level  ?Moth  $?pre ?daugh $?post)
(Node-Category ?Moth S|SBAR)
?f1<-(Head-Level-Mother-Daughters  ?  ?  ?daugh  $?childs)
=>
	;(retract ?f ?f1)
	(retract ?f)
	(assert (Head-Level-Mother-Daughters  ?head  ?level  ?Moth  $?pre $?childs $?post))
)  


(defrule replace_fact
(declare (salience -1))
?f<-(Head-Level-Mother-Daughters ?h ?l ?M $?daughters)
(Node-Category ?M S|SBAR)
=>
	(retract ?f)
	(assert (clause_boundry_head-childs ?M $?daughters))
)


(defrule remove_S_in_SBAR
(declare (salience -2))
(clause_boundry_head-childs ?M $?daughters)
(Node-Category ?M SBAR)
?f<-(clause_boundry_head-childs ?M1 $?daughters1)
(Node-Category ?M1 S)
(test (subsetp $?daughters1 $?daughters))
=>
	(retract ?f)
)


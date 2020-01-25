(defglobal ?*dbug* = open-conll)
(defglobal ?*index* = 1)

;One [boy] [and] two girls are coming.
(defrule modify_and_head_child_in_noun_case
?f<-(id-word-cat-head_id-rel ?id ?conj&and|Ora ?cat ?hid cc )
?f1<-(id-word-cat-head_id-rel ?hid ?wrd NOUN ?id1 ?rel )
(not (modified_and_fact ?conj ?id))
=>
	(retract ?f ?f1)
	(assert (id-word-cat-head_id-rel ?id ?conj ?cat ?id1 cc))
	(assert (id-word-cat-head_id-rel ?hid ?wrd NOUN ?id ?rel))
	(assert (modified_and_fact ?conj ?id))
	(assert (id-transformed_id ?hid ?id))
)


(defrule modify_Ora
?f<-(id-word-cat-head_id-rel ?id ?conj&Ora ?cat ?hid cc )
?f1<-(id-word-cat-head_id-rel ?hid ?wrd NOUN ?id1 ?rel )
(modified_and_fact ?conj ?id)
=>
	(retract ?f ?f1)
        (assert (id-word-cat-head_id-rel ?id ?conj ?cat ?id1 cc))
        (assert (id-word-cat-head_id-rel ?hid ?wrd NOUN ?id ?rel))
;        (assert (modified_and_fact ?conj ?id))
        (assert (id-transformed_id ?hid ?id))
)


;One boy [and] [two] girls are coming.
(defrule modify_all_and_components
?f<-(id-word-cat-head_id-rel ?id ?wrd NOUN ?hid ?rel)
(id-transformed_id ?hid ?tid)
=>
	(retract ?f)
	(assert (id-word-cat-head_id-rel ?id ?wrd NOUN ?tid ?rel))
)


;;Learning allows an agent to operate in initially unknown environments.
;(defrule modify_in
;?f<-(id-word-cat-head_id-rel ?id in ?hid ? case )
;?f1<-(id-word-cat-head_id-rel ?hid ?wrd ?cat ?hid1 ?rel)
;







;Print facts in order to display tree
(defrule print_facts_in_order
(declare (salience -20))
(id-word-cat-head_id-rel ?id ?wrd ?cat ?head ?rel)
?f<-(index ?id)
=>
	(retract ?f)
	(printout ?*dbug* "(id-word-cat-head_id-rel " ?id " "?wrd " " ?cat " " ?head " "?rel ")" crlf)
	(assert (index (+  ?id 1)))
)
 
(defrule end
(declare (salience -100))
=>
       (close  ?*dbug*)
)

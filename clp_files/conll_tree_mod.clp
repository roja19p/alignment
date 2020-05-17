(defglobal ?*dbug* = open-conll)
;(defglobal ?*index* = 1)
(defglobal ?*count* = 0)

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


;Modifying case (prep)
;Rama gave a book to Mohan.
;Learning allows an agent to operate in initially unknown environments.
(defrule modify_case
?f<-(id-word-cat-head_id-rel ?id ?wrd ?cat ?hid ?rel&nmod|obl)
?f1<-(id-word-cat-head_id-rel ?prep_id ?prep ? ?id case )
=>
	(retract ?f ?f1)
	(assert (id-word-cat-head_id-rel ?id ?wrd ?cat ?hid ?prep))
	(bind ?*count* (+ ?*count* 1))
	(assert (modify_index ?prep_id)) 
)


;modify id with new count
(defrule modify_hid_with_tid
(declare (salience -2))
(id-transformed_id ?id ?tid)
?f<-(id-word-cat-head_id-rel ?id1 ?wrd ?cat ?id ?rel)
(test (neq ?*count* 0))
(not (hid_modified ?id ?tid))
=>
	(retract ?f)
	(assert (id-word-cat-head_id-rel ?id1 ?wrd ?cat ?tid ?rel))
	(assert (hid_modified ?id ?tid))
)


;decrease id when count is greater than 0
(defrule modify_id_with_count
(declare (salience 10))
?f<-(id-word-cat-head_id-rel ?id ?wrd ?cat ?hid ?rel)
?f1<-(modify_index ?prep_id)
(test (eq (+ ?prep_id 1) ?id))
=>
	(if (neq ?*count* 0) then
		(retract ?f ?f1)
	        (assert (id-word-cat-head_id-rel (- ?id ?*count*) ?wrd ?cat ?hid ?rel))
        	(assert (id-transformed_id ?id (- ?id ?*count*)))
		(assert (modify_index ?id))
	)
)



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

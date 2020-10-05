(defrule map_mwe_ids_with_wrd_ids
(multifast_id-wordid ?mid ?id)
(id-clause_wrd ?id ?wrd)
?f<-(ids-cmp_mng-head-cat-mng_typ-priority $?pre ?mid $?post ?mng ?h ?cat ?type ?pri)
=>
	(retract ?f)
	(assert (ids-cmp_mng-head-cat-mng_typ-priority $?pre ?id $?post ?mng ?h ?cat ?type ?pri))
)


(defrule map_domain_mwe_ids_with_wrd_ids
(multifast_id-wordid ?mid ?id)
(id-clause_wrd ?id ?wrd)
?f<-(ids-domain_cmp_mng-head-cat-mng_typ-priority $?pre ?mid $?post ?mng ?h ?cat ?type ?pri)
=>
        (retract ?f)
        (assert (ids-domain_cmp_mng-head-cat-mng_typ-priority $?pre ?id $?post ?mng ?h ?cat ?type ?pri))
)



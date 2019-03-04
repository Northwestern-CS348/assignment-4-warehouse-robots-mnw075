(define (domain warehouse)
	(:requirements :typing)
	(:types robot pallette - bigobject
        	location shipment order saleitem)

  	(:predicates
    	(ships ?s - shipment ?o - order)
    	(orders ?o - order ?si - saleitem)
    	(unstarted ?s - shipment)
    	(started ?s - shipment)
    	(complete ?s - shipment)
    	(includes ?s - shipment ?si - saleitem)

    	(free ?r - robot)
    	(has ?r - robot ?p - pallette)

    	(packing-location ?l - location)
    	(packing-at ?s - shipment ?l - location)
    	(available ?l - location)
    	(connected ?l - location ?l - location)
    	(at ?bo - bigobject ?l - location)
    	(no-robot ?l - location)
    	(no-pallette ?l - location)

    	(contains ?p - pallette ?si - saleitem)
  )

   (:action startShipment
      :parameters (?s - shipment ?o - order ?l - location)
      :precondition (and (unstarted ?s) (not (complete ?s)) (ships ?s ?o) (available ?l) (packing-location ?l))
      :effect (and (started ?s) (packing-at ?s ?l) (not (unstarted ?s)) (not (available ?l)))
   )
   
   (:action robotMove
        :parameters (?r - robot ?lo - location ?ld - location)
        :precondition (and (at ?r ?lo) (no-robot ?ld) (free ?r) (connected ?lo ?ld))
        :effect (and (at ?r ?ld) (not (at ?r ?lo)) (no-robot ?lo) (not (no-robot ?ld)) )
   )
   
   (:action robotMoveWithPallette
        :parameters (?r - robot ?lo - location ?ld - location ?p - pallette)
	    :precondition (and (at ?r ?lo) (at ?p ?lo) (connected ?lo ?ld) (no-robot ?ld)  (no-pallette ?ld))
	    :effect (and (at ?r ?ld) (at ?p ?ld) (no-robot ?lo) (no-pallette ?lo) (has ?r ?p) (not (at ?r ?lo)) (not (at ?p ?lo)) (not (no-robot ?ld)) (not (no-pallette ?ld)))   
    )

    (:action moveItemFromPallette
        :parameters (?l - location ?s - shipment ?si - saleitem  ?p - pallette ?o - order)
	    :precondition (and (at ?p ?l) (packing-at ?s ?l) (packing-location ?l) (contains ?p ?si) (ships ?s ?o) (orders ?o ?si) (started ?s))
	    :effect (and (includes ?s ?si) (not (contains ?p ?si)))
   	)

    (:action completeShipment
	    :parameters (?s - shipment ?o - order ?l - location)
	    :precondition (and (started ?s) (ships ?s ?o) (not (complete ?s)) (not (available ?l)) (packing-location ?l))
	    :effect (and (complete ?s) (available ?l) (not (started ?s))  (not (packing-at ?s ?l)))
   	)

)

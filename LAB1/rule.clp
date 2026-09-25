(defrule print-today
   (Today is ?day)
   =>
   (printout t "Today is " ?day crlf)
)
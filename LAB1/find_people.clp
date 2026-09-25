;; Пошук чоловіка 
(defrule find-men
   (person (name ?name) (gender male))
   =>
   (printout t "Знайдено чоловіка: " ?name crlf)
)

;; Пошук жінки
(defrule find-women
   (person (name ?name) (gender female))
   =>
   (printout t "Знайдено жінку: " ?name crlf)
)

;; Пошук людини за ім'ям 
(defrule find-by-name-pavlo
   (person (name "Pavlo") (age ?age) (gender ?gender))
   =>
   (printout t "Знайдено за ім'ям (Pavlo): вік " ?age ", стать " ?gender crlf)
)

;; Пошук за віком
(defrule find-by-age-20
   (person (name ?name) (age 20) (gender ?gender))
   =>
   (printout t "Знайдено за віком (20 років): " ?name crlf)
)


;; Пошук за умовою: старше 20 років
(defrule find-older-than-20
   (person (name ?name) (age ?age&:(> ?age 20)))
   =>
   (printout t "Старше 20 років: " ?name " (" ?age " років)" crlf)
)
;; 1. Визначення шаблону для опису людини
(deftemplate person
   (slot name)
   (slot age)
   (slot gender)
)

;; 2. Список фактів із трьома екземплярами людей
(deffacts people
   (person (name "Pavlo") (age 20) (gender male))
   (person (name "Ivanna") (age 21) (gender female))
   (person (name "Serhiy") (age 18) (gender male))
)
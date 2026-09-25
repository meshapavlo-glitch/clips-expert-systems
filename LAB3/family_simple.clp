;; БАЗОВІ ФАКТИ (deffacts)

(deffacts base-facts
   ;; Базові факти про стать осіб
   (male Tom)
   (female Susan)
   (male John)

   ;; Базові факти про відношення батько/мати -> дитина
   (father-of Tom John)
   (mother-of Susan John)
)


;; ПРАВИЛА ВИВОДУ (defrule)

;; Правило 1: Виведення "The father of <child> is <father>."
(defrule print-father-of
   (father-of ?f ?c)
   =>
   (printout t "The father of " ?c " is " ?f "." crlf))

;; Правило 2: Виведення "The mother of <child> is <mother>."
(defrule print-mother-of
   (mother-of ?m ?c)
   =>
   (printout t "The mother of " ?c " is " ?m "." crlf))

;; Правило 3: Виведення "The parents of <child> are <father> and <mother>."
(defrule infer-parents
   (father-of ?f ?c)
   (mother-of ?m ?c)
   =>
   (assert (parents-of ?f ?m ?c))
   (printout t "The parents of " ?c " are " ?f " and " ?m "." crlf))

;; Правило 4: Виведення "<person> is a father."
(defrule infer-father-role
   (father-of ?f ?)
   =>
   (assert (is-father ?f))
   (printout t ?f " is a father." crlf))

;; Правило 5: Виведення "<person> is a mother."
(defrule infer-mother-role
   (mother-of ?m ?)
   =>
   (assert (is-mother ?m))
   (printout t ?m " is a mother." crlf))

;; Правило 6: Виведення "<person> is a son." (якщо це дитина і чоловік)
(defrule infer-son-role
   (or (father-of ? ?c) (mother-of ? ?c))
   (male ?c)
   =>
   (assert (is-son ?c))
   (printout t ?c " is a son." crlf))

;; Правило 7: Виведення стати для кожного чоловіка ("<person> is a male.")
(defrule print-male
   (male ?m)
   =>
   (printout t ?m " is a male." crlf))

;; Правило 8: Виведення стати для кожної жінки ("<person> is a female.")
(defrule print-female
   (female ?f)
   =>
   (printout t ?f " is a female." crlf))
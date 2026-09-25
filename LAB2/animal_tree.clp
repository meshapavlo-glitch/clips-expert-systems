;; 1. ШАБЛОНИ ДАНИХ (deftemplate)
;; Шаблон для представлення вузла дерева рішень
(deftemplate node
   (slot id (type SYMBOL))                          ; Унікальний ID вузла (n1, n2, leaf-hippo...)
   (slot type (allowed-values decision answer))     ; Тип: decision (питання) або answer (листок/результат)
   (slot text (type STRING))                        ; Текст питання або назва тварини
   (slot yes-node (type SYMBOL))                    ; ID вузла при відповіді "так"
   (slot no-node (type SYMBOL))                     ; ID вузла при відповіді "ні"
)

;; Шаблон для збереження поточного стану проходження дерева
(deftemplate current-node
   (slot id (type SYMBOL))                          ; ID вузла, на якому ми зараз перебуваємо
)

;; 2. БАЗА ФАКТІВ (deffacts)
(deffacts animal-decision-tree
   ;; Початковий стан: починаємо з кореневого вузла n1
   (current-node (id n1))

   ;; --- ВНУТРІШНІ ВУЗЛИ (ПИТАННЯ) ---
   (node (id n1) (type decision) 
         (text "Действительно ли является очень большим?") 
         (yes-node n3) (no-node n2))

   (node (id n2) (type decision) 
         (text "Издает писк?") 
         (yes-node leaf-mouse) (no-node leaf-squirrel))

   (node (id n3) (type decision) 
         (text "Имеет длинную шею?") 
         (yes-node leaf-giraffe) (no-node n4))

   (node (id n4) (type decision) 
         (text "Имеет хобот?") 
         (yes-node leaf-elephant) (no-node n5))

   (node (id n5) (type decision) 
         (text "Любит находиться в воде?") 
         (yes-node leaf-hippo) (no-node leaf-rhino))

   ;; --- ЛИСТОВІ ВУЗЛИ (РЕЗУЛЬТАТИ) ---
   (node (id leaf-squirrel) (type answer) (text "белка"))
   (node (id leaf-mouse)    (type answer) (text "мышь"))
   (node (id leaf-giraffe)  (type answer) (text "жираф"))
   (node (id leaf-elephant) (type answer) (text "слон"))
   (node (id leaf-hippo)    (type answer) (text "гиппопотам"))
   (node (id leaf-rhino)    (type answer) (text "носорог"))
)

;; 3. ПРАВИЛА (defrule) ДЛЯ ОБХОДУ ДЕРЕВА
;; Правило 1: Ставить питання та обробляє відповідь "да"
(defrule ask-question-yes
   ?curr <- (current-node (id ?id))
   (node (id ?id) (type decision) (text ?question) (yes-node ?yes))
   =>
   (printout t ?question " (yes/no): ")
   (bind ?answer (read))
   (if (eq ?answer yes) then
      (retract ?curr)
      (assert (current-node (id ?yes)))
   )
)

;; Правило 2: Обробляє відповідь "no"
(defrule ask-question-no
   ?curr <- (current-node (id ?id))
   (node (id ?id) (type decision) (text ?question) (no-node ?no))
   =>
   ;; Перевіряємо відповідь ще раз, якщо введена не "yes"
   ;; (якщо введено "no", переходимо по гілці no-node)
   (bind ?answer (read))
   (if (eq ?answer no) then
      (retract ?curr)
      (assert (current-node (id ?no)))
   )
)

;; Правило 3: Спрацьовує, коли ми дійшли до листового вузла
(defrule print-answer
   (current-node (id ?id))
   (node (id ?id) (type answer) (text ?animal))
   =>
   (printout t "Предположить, что это: " ?animal crlf)
)
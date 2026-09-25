
;; 1. ШАБЛОН ДЛЯ ОПИСУ ЧАГАРНИКА (deftemplate)
(deftemplate shrub
   (slot name (type STRING))             ; Назва чагарника
   (multislot traits (type SYMBOL))      ; Список його характеристик
)


;; 2. БАЗА ФАКТІВ ПРО ЧАГАРНИКИ (deffacts)
(deffacts shrub-database
   (shrub (name "Деревоподібна гортензія") 
          (traits urban container growth))

   (shrub (name "Олеандр") 
          (traits container))

   (shrub (name "Повстяна восковиця") 
          (traits cold shade drought wet))

   (shrub (name "Жимолость") 
          (traits urban easy growth))

   (shrub (name "Гарденія") 
          (traits drought urban container easy growth))

   (shrub (name "Звичайний ялівець") 
          (traits cold drought acid urban))

   (shrub (name "Вільхолиста квітка") 
          (traits cold shade wet acid))

   (shrub (name "Татарський кизил") 
          (traits cold shade wet easy growth))

   (shrub (name "Японська аукуба") 
          (traits shade container))

   (shrub (name "Канадський рододендрон") 
          (traits cold drought))
          
   ;; Початковий прапорець для запуску діалогу введення
   (start-input)
)

;; 3. ПРАВИЛО ДІАЛОГОВОГО ВВЕДЕННЯ (defrule)
(defrule get-user-preferences
   ?f <- (start-input)
   =>
   (retract ?f)
   (printout t "=== ДОБІР ЧАГАРНИКА ===" crlf)
   (printout t "Доступні характеристики:" crlf)
   (printout t "  cold      - Стійкість до холоду" crlf)
   (printout t "  shade     - Стійкість до затінення" crlf)
   (printout t "  drought   - Стійкість до посухи" crlf)
   (printout t "  wet       - Стійкість до вологого ґрунту" crlf)
   (printout t "  acid      - Стійкість до кислого ґрунту" crlf)
   (printout t "  urban     - Стійкість до міських умов" crlf)
   (printout t "  container - Контейнерне вирощування" crlf)
   (printout t "  easy      - Простота культивування" crlf)
   (printout t "  growth    - Швидкість росту" crlf crlf)
   
   (printout t "Вводьте необхідні характеристики по одній (наприклад, cold)." crlf)
   (printout t "Для завершення введення введіть done:" crlf crlf)
   
   ;; Цикл введення з клавіатури
   (bind ?ans (read))
   (while (neq ?ans done) do
      (assert (desire ?ans))
      (printout t "Додано характеристику: " ?ans ". Введіть наступну або done: ")
      (bind ?ans (read))
   )
   (printout t crlf "=== РЕЗУЛЬТАТИ ПОШУКУ ===" crlf)
)


;; 4. ПРАВИЛА ФІЛЬТРАЦІЇ ТА ВИВОДУ (defrule)
;; Відмічаємо рослини, яким бракує хоча б однієї обраної характеристики
(defrule filter-non-matching-shrubs
   (desire ?trait)
   (shrub (name ?name) (traits $?traits))
   (test (not (member$ ?trait $?traits)))
   =>
   (assert (missing-trait ?name))
)

;; Виводим ті, що відповідають УСІМ характеристикам
(defrule print-suitable-shrubs
   (shrub (name ?name))
   (not (missing-trait ?name))
   =>
   (assert (suitable ?name))
   (printout t "-> Підходить для посадки: " ?name crlf)
)

;; Якщо жодна рослина не підійшла
(defrule print-no-matches
   (not (suitable ?))
   =>
   (printout t "На жаль, за вашим запитом жодного чагарника не знайдено." crlf)
)
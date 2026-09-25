;; 1. ШАБЛОНИ ТА ДАНІ (deftemplate / deffacts)

;; Шаблон для структурованого опису чагарника
(deftemplate shrub
   (slot name (type STRING))             ; Назва чагарника
   (multislot traits (type SYMBOL))      ; Список характеристик
)

;; Початкова база фактів про рослини
(deffacts shrub-database
   (shrub (name "Деревоподібна гортензія") (traits urban container growth))
   (shrub (name "Олеандр") (traits container))
   (shrub (name "Повстяна восковиця") (traits cold shade drought wet))
   (shrub (name "Жимолость") (traits urban easy growth))
   (shrub (name "Гарденія") (traits drought urban container easy growth))
   (shrub (name "Ззвичайний ялівець") (traits cold drought acid urban))
   (shrub (name "Вільхолиста квітка") (traits cold shade wet acid))
   (shrub (name "Татарський кизил") (traits cold shade wet easy growth))
   (shrub (name "Японська аукуба") (traits shade container))
   (shrub (name "Канадський рододендрон") (traits cold drought))
   
   ;; Прапорець для запуску діалогу
   (start-input)
)

;; 2. КОРИСТУВАЦЬКІ ФУНКЦІЇ (deffunction)

;; Функція 1: Перевірка наявності потрібної риси у куща (викликається з LHS правила)
(deffunction trait-missing (?trait $?shrub-traits)
   ;; Повертає TRUE, якщо риси НЕМАЄ в списку характеристик куща
   (return (not (member$ ?trait $?shrub-traits)))
)

;; Функція 2: Вивід інформації про знайдений чагарник (викликається з RHS правила)
(deffunction print-shrub-info (?name $?traits)
   (printout t " -> [ЗНАЙДЕНО]: " ?name crlf)
   (printout t "    Властивості (" (length$ ?traits) " шт.): " ?traits crlf)
   (return TRUE)
)

;; 3. ПРАВИЛА ВИВОДУ ТА ФІЛЬТРАЦІЇ (defrule)

;; Правило діалогового введення побажань користувача
(defrule get-user-preferences
   ?f <- (start-input)
   =>
   (retract ?f)
   (printout t "   ЕКСПЕРТНА СИСТЕМА: ДОБІР ЧАГАРНИКІВ   " crlf)
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
   
   (printout t "Введіть характеристики (по одній). Введіть 'done' для завершення:" crlf)
   
   (bind ?ans (read))
   (while (neq ?ans done) do
      (assert (desire ?ans))
      (printout t "  [+] Додано: " ?ans ". Далі (або 'done'): ")
      (bind ?ans (read))
   )
   (printout t crlf " РЕЗУЛЬТАТИ РОБОТИ ЕКСПЕРТНОЇ СИСТЕМИ " crlf)
)

;; Пошук невідповідностей із використанням ВАШОЇ ФУНКЦІЇ trait-missing
(defrule filter-non-matching
   (desire ?trait)
   (shrub (name ?name) (traits $?traits))
   ;; Виклики функції з лівої частини правила (LHS)
   (test (trait-missing ?trait $?traits))
   =>
   (assert (missing-trait ?name))
)

;; Фінальний вивід відповідних чагарників із викликом print-shrub-info
(defrule print-suitable
   (shrub (name ?name) (traits $?traits))
   (not (missing-trait ?name))
   =>
   (assert (suitable ?name))
   ;; Виклик функції з правої частини правила (RHS)
   (print-shrub-info ?name $?traits)
)

;; Правило на випадок відсутності результатів
(defrule print-no-matches
   (not (suitable ?))
   =>
   (printout t "На жаль, за вашими критеріями жодної рослини не знайдено." crlf)
)
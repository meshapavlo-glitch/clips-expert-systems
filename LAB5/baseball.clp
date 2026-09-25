;; 1. Шаблони фактів для гравців
(deftemplate player (slot name))

;; 2. Початкові факти
(deffacts initial-data
   (player (name Andy))
   (player (name Ed))
   (player (name Harry))
   (player (name Paul))
   (player (name Allen))
   (player (name Sam))
   (player (name Bill))
   (player (name Jerry))
   (player (name Mike))
)

;; 3. Продукційне правило з перевіркою унікальності та обмежень
(defrule solve-baseball-team
  
   (player (name ?pitcher))
   
   (player (name ?catcher&:(neq ?catcher ?pitcher)))
   
   (player (name ?first&:(and (neq ?first ?pitcher) 
                             (neq ?first ?catcher))))
   
   (player (name ?second&:(and (neq ?second ?pitcher) 
                              (neq ?second ?catcher) 
                              (neq ?second ?first))))
   
   (player (name ?third&:(and (neq ?third ?pitcher) 
                             (neq ?third ?catcher) 
                             (neq ?third ?first) 
                             (neq ?third ?second))))
   
   (player (name ?short&:(and (neq ?short ?pitcher) 
                             (neq ?short ?catcher) 
                             (neq ?short ?first) 
                             (neq ?short ?second) 
                             (neq ?short ?third))))
   
   (player (name ?left&:(and (neq ?left ?pitcher) 
                            (neq ?left ?catcher) 
                            (neq ?left ?first) 
                            (neq ?left ?second) 
                            (neq ?left ?third) 
                            (neq ?left ?short))))
   
   (player (name ?center&:(and (neq ?center ?pitcher) 
                              (neq ?center ?catcher) 
                              (neq ?center ?first) 
                              (neq ?center ?second) 
                              (neq ?center ?third) 
                              (neq ?center ?short) 
                              (neq ?center ?left))))
   
   (player (name ?right&:(and (neq ?right ?pitcher) 
                             (neq ?right ?catcher) 
                             (neq ?right ?first) 
                             (neq ?right ?second) 
                             (neq ?right ?third) 
                             (neq ?right ?short) 
                             (neq ?right ?left) 
                             (neq ?right ?center))))

   ;; -------------------------------------------------------------
   ;; Логічні обмеження умови задачи:
   ;; -------------------------------------------------------------
   
   ;; Енді не любить кетчера
   (test (neq ?catcher Andy))

   ;; Сестра Еда одружена з другим бейсменом
   (test (neq ?second Ed))

   ;; Гаррі і третій бейсмен живуть в одному будинку
   (test (neq ?third Harry))

   ;; Пол і Аллен виграли у пітчера
   (test (neq ?pitcher Paul))
   (test (neq ?pitcher Allen))

   ;; Шорт-стоп, Пол і Енді програли на скачках
   (test (neq ?short Paul))
   (test (neq ?short Andy))

   ;; Другий бейсмен обіграв Пола, Гаррі, Білла і кетчера
   (test (neq ?second Paul))
   (test (neq ?second Harry))
   (test (neq ?second Bill))
   (test (neq ?catcher Paul))
   (test (neq ?catcher Harry))
   (test (neq ?catcher Bill))

   ;; Ед, Пол, Джеррі - холостяки. Дружина пітчера -> пітчер одружений
   (test (neq ?pitcher Ed))
   (test (neq ?pitcher Paul))
   (test (neq ?pitcher Jerry))

   ;; Сестра 3-го бейсмена одружена -> 3-й бейсмен має сестру/одружений
   (test (neq ?third Ed))
   (test (neq ?third Paul))
   (test (neq ?third Jerry))

   ;; Шорт-стоп, 3-й бейсмен і Білл - різні
   (test (neq ?short Bill))
   (test (neq ?third Bill))

   ;; Сем, кетчер і 3-й бейсмен - різні
   (test (neq ?catcher Sam))
   (test (neq ?third Sam))

   ;; Ед, Сем і шорт-стоп - різні
   (test (neq ?short Ed))
   (test (neq ?short Sam))

   ;; Правий і центральний фільдери - холостяки (Ed, Paul або Jerry)
   (test (or (eq ?right Ed) (eq ?right Paul) (eq ?right Jerry)))
   (test (or (eq ?center Ed) (eq ?center Paul) (eq ?center Jerry)))

   =>
   ;; Виведення результату
   (printout t "==================================" crlf)
   (printout t "   СКЛАД БЕЙСБОЛЬНОЇ КОМАНДИ      " crlf)
   (printout t "==================================" crlf)
   (printout t "Pitcher (Пітчер): " ?pitcher crlf)
   (printout t "Catcher (Кетчер): " ?catcher crlf)
   (printout t "First Baseman (Перший бейсмен): " ?first crlf)
   (printout t "Second Baseman (Другий бейсмен): " ?second crlf)
   (printout t "Third Baseman (Третій бейсмен): " ?third crlf)
   (printout t "Shortstop (Шорт-стоп): " ?short crlf)
   (printout t "Left Fielder (Лівий фільдер): " ?left crlf)
   (printout t "Center Fielder (Центральний фільдер): " ?center crlf)
   (printout t "Right Fielder (Правий фільдер): " ?right crlf)
   (printout t "==================================" crlf)
)
;; Шаблон для опису людини (ім'я, стать, роль)
(deftemplate person
   (slot name)
   (slot gender (allowed-values male female))
   (slot role (allowed-values father mother son daughter)))

;; Шаблон для опису відношення "батько/мати -> дитина"
(deftemplate parent-child
   (slot parent)
   (slot child)
   (slot relation (allowed-values father mother)))

;; Шаблон для опису відношення "обоє батьків -> дитина"
(deftemplate parent-pair
   (slot child)
   (multislot parents))

(deffacts family-facts
   ;; 1. Інформація про людей (стать та роль):
     (person (name Tom) (gender male) (role father))
   
   ;; "Susan is a mother", "Susan is a female"
   (person (name Susan) (gender female) (role mother))
   
   ;; "John is a son", "John is a male"
   (person (name John) (gender male) (role son))

   ;; 2. Індивідуальні відношення батьківства:
   ;; "The father of John is Tom"
   (parent-child (parent Tom) (child John) (relation father))
   
   ;; "The mother of John is Susan"
   (parent-child (parent Susan) (child John) (relation mother))

   ;; 3. Парне відношення батьків:
   ;; "The parents of John are Tom and Susan"
   (parent-pair (child John) (parents Tom Susan))
)
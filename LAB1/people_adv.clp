(deftemplate person
   (multislot name)
   (slot age (type INTEGER))
   (slot gender (allowed-values male female))
)

(deffacts people-advanced
   (person (name John Doe) (age 25) (gender male))
   (person (name Berta) (age 30) (gender female))
   (person (name Alex Smith) (age 18) (gender male))
)
;;; ************************************************************
;;; *                                                          *
;;; *                   FlowerAdvisor 2.                      *
;;; *                                                          *
;;; ************************************************************





;;; ***************************
;;; * DEFTEMPLATES & DEFFACTS *
;;; ***************************

(deftemplate UI-state
   (slot display)
   (slot relation-asserted (default none))
   (slot response (default none))
   (multislot valid-answers)
   (slot state (default middle)))
   



;;;****************
;;;* STARTUP RULE *
;;;****************

(defrule system-banner ""
  =>
  (assert (UI-state (display WelcomeMessage)
                    (relation-asserted start)
                    (state initial)
                    (valid-answers))))




;;;***************
;;;* QUERY RULES *
;;;***************

(defrule determine-user-gender ""
	?state<-(UI-state)
    (not(user-gender))
    =>
	(retract ?state) 
	(assert (user-gender))	
    (assert (UI-state (display UserQuestion)
                     (relation-asserted user-gender)
                     (response Male)
                     (valid-answers Male Female))))

(defrule determine-receiver-gender ""
	(not(receiver-gender))
	?state<-(UI-state)
    =>
	(retract ?state)
	(assert(receiver-gender))
    (assert (UI-state (display ReceiverQuestion)
                     (relation-asserted receiver-gender)
                     (response Female)
                     (valid-answers Female Male))))

(defrule determine-relation ""
	(not(affinity))
	?state<-(UI-state)
	=>
	(retract ?state)
	(assert(affinity))
	(assert (UI-state (display FamilyQuestion)
                     (relation-asserted affinity)
                     (response CloseFamily)
                     (valid-answers CloseFamily FurtherFamily None))))

(defrule determine-relation-m-f-close ""
	(not(relation))
    (user-gender Male) 
    (receiver-gender Female)
    (affinity CloseFamily)
   	?state<-(UI-state)
   =>
	(retract ?state)
	(assert(relation))
    (assert (UI-state (display RelationQuestion)
                     (relation-asserted relation)
                     (response Mother)
                     (valid-answers Mother Sister Grandmother Daughter Wife))))

(defrule determine-relation-m-f-further ""
	(not(relation))
    (user-gender Male) 
    (receiver-gender Female)
    (affinity FurtherFamily)
   	?state<-(UI-state)
    =>
	(retract ?state)
	(assert(relation))
    (assert (UI-state (display RelationQuestion)
                     (relation-asserted relation)
                     (response Aunt)
                     (valid-answers Aunt Cousin_f ))))

(defrule determine-relation-m-f-none ""
	(not(relation))
    (user-gender Male) 
    (receiver-gender Female)
    (affinity None)
   	?state<-(UI-state)
    =>
	(retract ?state)
	(assert(relation))
    (assert (UI-state (display RelationQuestion)
                     (relation-asserted relation)
                     (response Friend_f)
                     (valid-answers Friend_f Girlfriend Fiancee Boss_f))))

(defrule determine-relation-m-m-close ""
	(not(relation))
    (user-gender Male)
    (receiver-gender Male)
	(affinity CloseFamily)
   	?state<-(UI-state)
    =>
	(retract ?state)
	(assert(relation))
    (assert (UI-state (display RelationQuestion)
                     (relation-asserted relation)
                     (response Father)
                     (valid-answers Father Son Grandfather Brother))))
                     
(defrule determine-relation-m-m-further ""
	(not(relation))
    (user-gender Male)
    (receiver-gender Male)
	(affinity FurtherFamily)
   	?state<-(UI-state)
     =>
	(retract ?state)
	(assert(relation))
    (assert (UI-state (display RelationQuestion)
                     (relation-asserted relation)
                     (response Uncle)
                     (valid-answers Uncle Cousin_m))))

(defrule determine-relation-m-m-none ""
	(not(relation))
    (user-gender Male)
	(receiver-gender Male)
	(affinity None)
   	?state<-(UI-state)
    =>
	(retract ?state)
	(assert(relation))
    (assert (UI-state (display RelationQuestion)
                     (relation-asserted relation)
                     (response Friend_m)
                     (valid-answers Friend_m Boss_m))))                     

(defrule determine-relation-f-f-close ""
	(not(relation))
    (user-gender Female) 
	(receiver-gender Female)
	(affinity CloseFamily)
   	?state<-(UI-state)
     =>
	(retract ?state)
	(assert(relation))
    (assert (UI-state (display RelationQuestion)
                     (relation-asserted relation)
                     (response Mother)
                     (valid-answers Mother Sister Grandmother Daughter))))
                     
(defrule determine-relation-f-f-further ""
	(not(relation))
    (user-gender Female) 
	(receiver-gender Female)
	(affinity FurtherFamily)
   	?state<-(UI-state)
    =>
	(retract ?state)
	(assert(relation))
    (assert (UI-state (display RelationQuestion)
                     (relation-asserted relation)
                     (response Aunt)
                     (valid-answers Aunt Cousin_f))))                     
                     
(defrule determine-relation-f-f-none "" 
	(not(relation))
    (user-gender Female) 
	(receiver-gender Female)
	(affinity None)
   	?state<-(UI-state)
     =>
	(retract ?state)
	(assert(relation))
    (assert (UI-state (display RelationQuestion)
                     (relation-asserted relation)
                     (response Friend_f)
                     (valid-answers Friend_f Boss_m))))                     
                     
(defrule determine-relation-f-m-close ""
	(not(relation))
    (user-gender Female) 
	(receiver-gender Male)
	(affinity CloseFamily)
   	?state<-(UI-state)
     =>
	(retract ?state)
	(assert(relation))
    (assert (UI-state (display RelationQuestion)
                     (relation-asserted relation)
                     (response Father)
                     (valid-answers Father Son Grandfather Brother Husband))))

(defrule determine-relation-f-m-further ""
	(not(relation))
    (user-gender Female) 
	(receiver-gender Male)
	(affinity FurtherFamily)
   	?state<-(UI-state)
    =>
	(retract ?state)
	(assert(relation))
    (assert (UI-state (display RelationQuestion)
                     (relation-asserted relation)
                     (response Uncle)
                     (valid-answers  Uncle Cousin_m))))
                     
(defrule determine-relation-f-m-none ""
	(not(relation))
    (user-gender Female) 
	(receiver-gender Male)
	(affinity None)
   	?state<-(UI-state)
   =>
	(retract ?state)
	(assert(relation))
    (assert (UI-state (display RelationQuestion)
                     (relation-asserted relation)
                     (response Friend_m)
                     (valid-answers Friend_m Boss_m Boyfriend Fiance ))))

(defrule determine-occasion-type-family ""
	(not(occasion-type))
	(or(affinity CloseFamily)(affinity FurtherFamily))
	?state<-(UI-state)
	=>
	(assert(occasion-type))
	(retract ?state)
	(assert (UI-state (display OccasionTypeQuestion)
                     (relation-asserted occasion-type)
                     (response Anniversary) 
                     (valid-answers Anniversary FamilyCelebrations SpecDay Apology Thanks Funeral)))
			;SpecDay - czyli te dnie matki
			)

(defrule determine-occasion-type-rest ""
	(not(occasion-type))
	(affinity None)
	?state<-(UI-state)
	=>
	(assert(occasion-type))
	(retract ?state)
	(assert (UI-state (display OccasionTypeQuestion)
                     (relation-asserted occasion-type)
                     (response Anniversary) 
                     (valid-answers Anniversary SpecDay Apology Thanks Funeral)))
			;SpecDay - czyli te imieniny
			)

;da sie wydzielic tez sposob swietowania np. Congrats -> Banquet or sth less formal 

(defrule determine-anniversary ""
	(not(anniversary))
	(not(or (relation Husband)(relation Wife)(relation Boyfriend)(relation Girlfriend)(relation Fiancee)(relation Fiance)))
	(occasion-type Anniversary)
	?state<-(UI-state)
	=>
	(assert(anniversary))
	(retract ?state)
	(assert (UI-state (display AnniversaryQuestion)
					(relation-asserted anniversary)
					(response Wedding);i jakies inne
					(valid-answers Wedding Birthday))))

(defrule determine-anniversary-couple ""
	(not(anniversary))
	(occasion-type Anniversary)
	(or (relation Husband)(relation Wife)(relation Boyfriend)(relation Girlfriend)(relation Fiancee)(relation Fiance))
	?state<-(UI-state)
	=>
	(assert(anniversary))
	(retract ?state)
	(assert (UI-state (display AnniversaryQuestion)
					(relation-asserted anniversary)
					(response Wedding);i jakies inne
					(valid-answers Wedding Birthday FirstMeeting))))

(defrule determine-family-celebration ""
	(not(family-celebration))
	(occasion-type FamilyCelebrations)
	(or (affinity CloseFamily)(affinity FurtherFamily))
	?state<-(UI-state)
	=>
	(assert(family-celebration))
	(retract ?state)
	(assert (UI-state (display FamilyCelebQuestion)
					(relation-asserted family-celebration)
					(response Wedding);i jakies inne
					(valid-answers Wedding Baptism Communion))))

(defrule determine-special-day-mother ""
	(not(special-day))
	(occasion-type SpecDay)
	(relation Mother)
	?state<-(UI-state)
	=>
	(assert(special-day))
	(retract ?state)
	(assert (UI-state (display SpecDayQuestion)
					(relation-asserted special-day)
					(response MotherDay);i jakies inne
					(valid-answers MotherDay WomanDay Namesday))))

(defrule determine-special-couple-m ""
	(not(special-day))
	(occasion-type SpecDay)
	(or (relation Husband)(relation Boyfriend)(relation Fiance))
	?state<-(UI-state)
	=>
	(assert(special-day))
	(retract ?state)
	(assert (UI-state (display SpecDayQuestion)
					(relation-asserted special-day)
					(response Valentine)
					(valid-answers Valentine ManDay Namesday))))

(defrule determine-special-couple-f ""
	(not(special-day))
	(occasion-type SpecDay)
	(or (relation Wife)(relation Girlfriend)(relation Fiancee))
	?state<-(UI-state)
	=>
	(assert(special-day))
	(retract ?state)
	(assert (UI-state (display SpecDayQuestion)
					(relation-asserted special-day)
					(response Valentine)
					(valid-answers Valentine WomanDay Namesday))))
					
(defrule determine-special-father ""
	(not(special-day))
	(occasion-type SpecDay)
	(relation Father)
	?state<-(UI-state)
	=>
	(assert(special-day))
	(retract ?state)
	(assert (UI-state (display SpecDayQuestion)
					(relation-asserted special-day)
					(response FatherDay)
					(valid-answers FatherDay ManDay Namesday))))

(defrule determine-special-grandparent ""
	(not(special-day))
	(occasion-type SpecDay)
	(or(relation Grandmother)(relation Grandfather))
	?state<-(UI-state)
	=>
	(assert(special-day))
	(retract ?state)
	(assert (UI-state (display SpecDayQuestion)
					(relation-asserted special-day)
					(response GrandparentDay)
					(valid-answers GrandparentDay Namesday))))

(defrule determine-special-child ""
	(not(special-day))
	(occasion-type SpecDay)
	(or(relation Daughter)(relation Son))
	?state<-(UI-state)
	=>
	(assert(special-day))
	(retract ?state)
	(assert (UI-state (display SpecDayQuestion)
					(relation-asserted special-day)
					(response ChildDay)
					(valid-answers ChildDay Namesday))))

(defrule determine-special-f ""
	(not(special-day))
	(occasion-type SpecDay)
	(or (relation Friend_f)(relation Sister)(relation Aunt)(relation Cousin_f)(relation Boss_f))
	?state<-(UI-state)
	=>
	(assert(special-day))
	(retract ?state)
	(assert (UI-state (display SpecDayQuestion)
					(relation-asserted special-day)
					(response WomanDay)
					(valid-answers WomanDay Namesday))))

(defrule determine-special-m ""
	(not(special-day))
	(occasion-type SpecDay)
	(or (relation Friend_m)(relation Brother)(relation Uncle)(relation Cousin_m)(relation Boss_m))
	?state<-(UI-state)
	=>
	(assert(special-day))
	(retract ?state)
	(assert (UI-state (display SpecDayQuestion)
					(relation-asserted special-day)
					(response ManDay)
					(valid-answers ManDay Namesday))))

(defrule determine-relation-length ""
	(not(occasion-type Funeral))
	(not(relation-length))
	(affinity None)
   	?state<-(UI-state)
    =>
	(retract ?state)
	(assert(relation-length))
    (assert (UI-state (display RelationLenghtQuestion)
                     (relation-asserted relation-length)
                     (response Year)
                     (valid-answers Year Two-years Three-five-years Five-years))))

(defrule determine-personality ""
	(not(occasion-type Funeral))
	(not(personality))
   	?state<-(UI-state)
    =>
	(retract ?state)
	(assert(personality))
    (assert (UI-state (display PersonalityQuestion)
                     (relation-asserted personality)
                     (response Traditional)
                     (valid-answers Traditional Creative Sentimental))))

(defrule determine-place ""
	(not(occasion-type Funeral))
	(not(place))
	?state<-(UI-state)
	=>
	(assert(place))
	(retract ?state)
	(assert (UI-state (display PlaceQuestion)
					(relation-asserted place)
					(response House)
					(valid-answers House Restaurant Banquet Vernissage Other))))

(defrule determine-pot-flower ""
	(not(pot-flower))
   	?state<-(UI-state)
    =>
	(retract ?state)
	(assert(pot-flower))
    (assert (UI-state (display PotQuestion)
                     (relation-asserted pot-flower)
                     (response No)
                     (valid-answers No Yes))))

(defrule determine-season ""
	(not(occasion-type Funeral))
	(not(season))
    (pot-flower No)
   	?state<-(UI-state)
    =>
	(retract ?state)
	(assert(season))
    (assert (UI-state (display SeasonQuestion)
                     (relation-asserted season)
                     (response Spring)
                     (valid-answers Spring Summer Autumn Winter ))))

(defrule determine-flower-picking ""
	(not(flower-picking))
    (or(personality Creative)(personality Sentimental))
    (not (or(place Banquet)(relation Boss_m)(occasion-type Apology)(relation Boss_f)(place Vernissage)))
    (or (season Spring) (season Summer) (season Autumn))
    (or (price Cheap) (not (price ?)))
   	?state<-(UI-state)
    =>
	(retract ?state)
	(assert(flower-picking))
    (assert (UI-state (display FlowerPickingQuestion)
                     (relation-asserted flower-picking)
                     (response Yes)
                     (valid-answers Yes No))))

(defrule determine-allergy ""
	(not(occasion-type Funeral))
	(not(allergic))
   	?state<-(UI-state)
     =>
	(retract ?state)
	(assert(allergic))
    (assert (UI-state (display AllergyQuestion)
                     (relation-asserted allergic)
                     (response No)
                     (valid-answers No Yes))))

(defrule determine-price ""
	(not(price))
    (or (flower-picking No)(not (flower-picking ?)))
   	?state<-(UI-state)
    =>
	(retract ?state)
	(assert(price))
    (assert (UI-state (display PriceQuestion)
                     (relation-asserted price)
                     (response Medium)
                     (valid-answers Cheap Medium High))))
            
            
            
                     
  ;******************************;
  ;     ADDITIONAL               ;
  ;                   RULES      ;
  ;******************************;                   



(defrule change-officiality-official ""
    (not(officiality ?))
	(or(place Banquet)
		(occasion-type Apology)
	   (place Vernissage)
	   (or
	      (and(place Other)(family-celebration)) 
	      (or(relation Boss_f)(relation Boss_m))
	    )
	 )
	 =>
    (assert(officiality official)))


(defrule change-officiality-semi-official ""
	(not(officiality ?))
	(not(occasion-type Apology))
	(or(place Restaurant)
	   (and
	       (or(relation-length Two-years)
	          (relation-length Year)
	          (affinity FurtherFamily)
	   		  (affinity CloseFamily)
	   		  (relation Boyfriend)
	   		  (relation Girlfriend)
	   		  (relation Fiancee)
	   		  (relation Fiance)
	   	    )
	   	    (place Other)
	   	)
	 )
	 =>
	(assert(officiality semi-official)))


(defrule change-officiality-unofficial ""
	(not(occasion-type Apology))
	(not(officiality ?))
	(not(relation Boss_f))
	(not(relation Boss_m))
	(or
	   (place House)
	   (and
	       (or
	          (relation-length Five-years)
	          (relation-length Three-five-years)
	          (affinity CloseFamily)
	          (affinity FurtherFamily)
	          (relation Boyfriend)
	          (relation Girlfriend)
	          (relation Fiancee)
	          (relation Fiance)
	        )
	        (place Other)
	    )
	 )
	 =>
	(assert(officiality unofficial)))


(defrule change-price-none "" ;ewentualnie dodac usuwanie (price Cheap)
	(flower-picking Yes)
	 =>
	(assert (price None)))


(defrule change-color-red ""
	(or(special-day Valentine)
	(anniversary FirstMeeting)
	(and(anniversary Wedding)(relation Wife))
	(and (special-day WomanDay)(or (relation Wife)(relation Girlfriend)(relation Fiancee))))
	(not (family-celebration Wedding))
	 =>
	 (assert (color red)))


(defrule change-color-tea ""
	(or(relation Friend_f)(relation Friend_m))
	(occasion-type Thanks)
	 =>
	(assert (color tea)))


(defrule change-color-white ""
	(relation Wife)   ;new wife ;) 
	(family-celebration Wedding)
	 =>
	(assert (color white)))


(defrule change-color-black "" ;kwiatki na pogrzeb
	(occasion-type Funeral)
	 =>
	(assert (color black)))




;;; ***************************
;;; *  FINAL  *  CONCLUSIONS  *
;;; *************************** 



(defrule red-rose ""
	(color red)
	(price Cheap|Medium|High)
	(pot-flower No)
	?state<-(UI-state)
     =>
	(retract ?state)
	(assert (UI-state (display RedRoseChoice)
                      (state final)
                     ))
)

(defrule white-rose ""
	(color white)
	(price Medium|Cheap)
	(pot-flower No)
	?state<-(UI-state)
     =>
	(retract ?state)
	(assert (UI-state (display WhiteRoseChoice)
                      (state final)
                     ))
)

(defrule white-bouquet "";Biale roze + Lilie + Eustomy
	(color white)
	(allergic No)
	(price High)
	(pot-flower No)
	?state<-(UI-state)
     =>
	(retract ?state)
	(assert (UI-state (display WhiteBouquetChoice)
                      (state final)
                     ))
)

(defrule white-bouquet-of-roses "";Biale roze 
	(color white)
	(price High)
	(pot-flower No)
	?state<-(UI-state)
     =>
	(retract ?state)
	(assert (UI-state (display WhiteRosesChoice)
                      (state final)
                     ))
)

(defrule chrysanthemum ""
	(color black)
	(price Cheap|Medium)
	?state<-(UI-state)
    =>
	(retract ?state)
	(assert (UI-state (display ChrysanthemumChoice)
                      (state final)
                     ))
)

(defrule white-lilies ""
	(color black)
	(price High)
	?state<-(UI-state)
     =>
	(retract ?state)
	(assert (UI-state (display WhiteLiliesChoice)
                      (state final)
                     ))
)

(defrule tea-rose ""
	(color tea)
	(price Cheap|Medium|High)
	(pot-flower No)
	?state<-(UI-state)
     =>
	(retract ?state)
	(assert (UI-state (display TeaRoseChoice)
    				  (state final)
                     ))
)

(defrule antirrhinum-majus "" ;Lwia paszcza
	(not (color ?))
	(allergic No)              ;dla niealergikow
	(personality Creative)
	(officiality official)
	(price High)
	(pot-flower No)
	?state<-(UI-state)
   =>
	(retract ?state)
	(assert (UI-state (display AntirrhinumMajusChoice)
                     (state final)
                     ))
)

(defrule asian-lilies "" 
	(not (color ?))
	(allergic No);dla niealergikow
	(personality Sentimental|Traditional)
	(price High)
	(season Summer)
	(pot-flower No)
	?state<-(UI-state)
     =>
	(retract ?state)
	(assert (UI-state (display AsianLiliesChoice)
                      (state final)
                     ))
)

(defrule iris "" 
	(not (color ?))
	(personality Traditional)
	(price Cheap)
	(officiality official|semi-official)
	(season Summer)
	(pot-flower No)
	?state<-(UI-state)
     =>
	(retract ?state)
	(assert (UI-state (display IrisChoice)
                      (state final)
                     ))
)

(defrule dalia "" 
	(not (color ?))
	(personality Sentimental|Traditional)
	(price Medium)
	(officiality official|semi-official)
	(season Summer|Autumn)
	(pot-flower No)
	?state<-(UI-state)
     =>
	(retract ?state)
	(assert (UI-state (display DaliaChoice)
                      (state final)
                     ))
)

(defrule anturium "" 
	(not (color ?))
	(personality Creative)
	(price Medium)
	(officiality official)
	(pot-flower No)
	?state<-(UI-state)
     =>
	(retract ?state)
	(assert (UI-state (display AnturiumChoice)
                      (state final)
                     ))
)

(defrule fikus "" 
	(officiality semi-official|unofficial)
	(personality Creative)
	(pot-flower Yes)
	(allergic No)
	(price Medium)
	?state<-(UI-state)
     =>
	(retract ?state)
	(assert (UI-state (display FikusChoice)
                      (state final)
                     ))
)

(defrule paprotka "" 
	(officiality semi-official|unofficial)
	(personality Creative)
	(pot-flower Yes)
	(price Cheap)
	?state<-(UI-state)
    =>
	(retract ?state)
	(assert (UI-state (display PaprotkaChoice)
                      (state final)
                     ))
)

(defrule azalia "" 
	(officiality semi-official|official)
	(personality Traditional|Sentimental)
	(price Medium|High)
	(pot-flower Yes)
	?state<-(UI-state)
     =>
	(retract ?state)
	(assert (UI-state (display AzaliaChoice)
                      (state final)
                     ))
)

(defrule cyklamen-perski "" 
	(officiality official|semi-official)
	(price Cheap)
	(pot-flower Yes)
	?state<-(UI-state)
    =>
	(retract ?state)
	(assert (UI-state (display CyklamenPerskiChoice)
                      (state final)
                     ))
)

(defrule fake-rose "" 
	(not (color ?))
	(officiality unofficial)
	(pot-flower No)
	(price Cheap)
	(season Winter|Autumn)
	(personality Creative)
	?state<-(UI-state)
     =>
	(retract ?state)
	(assert (UI-state (display FakeRoseChoice)
                      (state final)
                     ))
)

(defrule krokus "" 
	(not (color ?))
	(officiality  semi-official|unofficial)
	(pot-flower No)
	(allergic Yes) ; bo zaslanial narcyza
	(personality Creative|Sentimental)
	(price None)
	(season Spring)
	?state<-(UI-state)
    =>
	(retract ?state)
	(assert (UI-state (display KrokusChoice)
                      (state final)
                     ))
)

(defrule bez-lilak "" 
	(color red)
	(allergic No)
	(price None)
	(season Spring)
	(pot-flower No)
	?state<-(UI-state)
     =>
	(retract ?state)
	(assert (UI-state (display BezLilakChoice)
                      (state final)
                     ))
)

(defrule tulip "" 
	(not (color ?))
	(officiality semi-official|unofficial)
	(price Cheap)
	(season Spring)
	(pot-flower No)
	?state<-(UI-state)
     =>
	(retract ?state)
	(assert (UI-state (display TulipChoice)
                      (state final)
                     ))
)

(defrule gozdzik "" 
	(not (color ?))
	(price High)
	(personality Traditional)
	(officiality semi-official)
	(season Spring|Summer)
	(pot-flower No)
	?state<-(UI-state)
     =>
	(retract ?state)
	(assert (UI-state (display GozdzikChoice)
                      (state final)
                     ))
)

(defrule piwonia "" 
	(not (color ?))
	(price Cheap)
	(personality Creative)
	(officiality official)
	(pot-flower No)
	?state<-(UI-state)
    =>
	(retract ?state)
	(assert (UI-state (display PiwoniaChoice)
                      (state final)
                     ))
)

(defrule storczyk "" 
	(allergic No)
	(price High)
	(officiality official)
	(pot-flower Yes)
	(personality Traditional|Sentimental)
	?state<-(UI-state)
     =>
	(retract ?state)
	(assert (UI-state (display StorczykChoice)
                      (state final)
                     ))
)

(defrule aster "" 
	(not (color ?))
	(price Cheap)
	(personality Creative|Sentimental)
	(season Summer)
	(pot-flower No)
	?state<-(UI-state)
    =>
	(retract ?state)
	(assert (UI-state (display AsterChoice)
                      (state final)
                     ))
)


(defrule fiolek "" 
	(price Medium)
	(officiality unofficial)
	(personality Sentimental)
	(pot-flower Yes)
	?state<-(UI-state)
     =>
	(retract ?state)
	(assert (UI-state (display FiolekChoice)
                      (state final)
                     ))
)

(defrule lesna-konwalia "" 
	(color tea|white)
	(allergic No)
	(price None)
	(season Spring|Summer)
	(pot-flower No)
	?state<-(UI-state)
     =>
	(retract ?state)
	(assert (UI-state (display LesnaKonwaliaChoice)
                      (state final)
                     ))
)

(defrule uprawna-konwalia "" 
	(not (color ?))
	(allergic No)
	(price High)
	(officiality official)
	(season Spring|Summer)
	(personality Sentimental)
	(pot-flower No)
	?state<-(UI-state)
     =>
	(retract ?state)
	(assert (UI-state (display UprawnaKonwaliaChoice)
                      (state final)
                     ))
)

(defrule mak "" 
	(not (color ?))
	(price None)
	(officiality unofficial)
	(season Summer)
	(personality Creative)
	(pot-flower No)
	?state<-(UI-state)
     =>
	(retract ?state)
	(assert (UI-state (display MakChaberChoice)
                      (state final)
                     ))
)

(defrule slonecznik "" 
	(not (color ?))
	(price Medium)
	(officiality semi-official|unofficial)
	(season Summer)
	(pot-flower No)
	(personality Creative|Sentimental)
	?state<-(UI-state)
     =>
	(retract ?state)
	(assert (UI-state (display SlonecznikChoice)
                      (state final)
                     ))
)

(defrule slonecznik-ogrodowy "" 
	(not (color ?))
	(price None)
	(pot-flower No)
	(officiality semi-official)
	(season Summer)
	(personality Sentimental)
	?state<-(UI-state)
    =>
	(retract ?state)
	(assert (UI-state (display SlonecznikOgrodowyChoice)
                      (state final)
                     ))
)

(defrule narcyz "" 
	(not (color ?))
	(price Medium)
	(season Spring)
	(pot-flower No)
	(officiality semi-official|unofficial )
	(personality Creative)
	?state<-(UI-state)
     =>
	(retract ?state)
	(assert (UI-state (display NarcyzChoice)
                     (state final)
                     ))
)

(defrule zonkil "" 
	(not (color ?))
	(price Medium)
	(season Spring)
	(pot-flower No)
	(officiality semi-official|unofficial )
	(personality Sentimental)
	?state<-(UI-state)
     =>
	(retract ?state)
	(assert (UI-state (display ZonkilChoice)
                      (state final)
                     ))
)

(defrule narcyz-ogrodowy "" 
	(not (color ?))
	(price None)
	(season Spring)
	(allergic No)
	(pot-flower No)
	(officiality semi-official|unofficial)
	(personality Creative)
	?state<-(UI-state)
     =>
	(retract ?state)
	(assert (UI-state (display NarcyzOgrodowyChoice)
                      (state final)
                     ))
)

(defrule zonkil-ogrodowy "" 
	(not (color ?))
	(price None)
	(season Spring)
	(allergic No)
	(pot-flower No)
	(officiality semi-official|unofficial )
	(personality Sentimental)
	?state<-(UI-state)
     =>
	(retract ?state)
	(assert (UI-state (display ZonkilOgrodowyChoice)
                      (state final)
                     ))
)

(defrule margaretka "" 
	(not (color ?))
	;(allergic No)    bo brakowalo sciezki a margaretka chyba mocno nie pachnie??
	(price Medium)
	(pot-flower No)
	(season Spring|Summer|Winter)
	(officiality semi-official|unofficial )
	?state<-(UI-state)
     =>
	(retract ?state)
	(assert (UI-state (display MargaretkaChoice)
                      (state final)
                     ))
)

(defrule gerbera "" 
	(not (color ?))
	(price Medium)
	(pot-flower No)
	(officiality official)
	(personality Traditional|Sentimental)
	?state<-(UI-state)
     =>
	(retract ?state)
	(assert (UI-state (display GerberaChoice)
                      (state final)
                     ))
)

(defrule stokrotka "" 
	(not (color ?))
	(price None)
	(pot-flower No)
	(officiality unofficial)
	(personality Sentimental)
	(season Summer)
	?state<-(UI-state)
     =>
	(retract ?state)
	(assert (UI-state (display StokrotkaChoice)
                      (state final)
                     ))
)

(defrule bambus "" 
	(price Medium)
	(officiality semi-official|official)
	(pot-flower Yes)
	(personality Creative)
	?state<-(UI-state)
     =>
	(retract ?state)
	(assert (UI-state (display BambusChoice)
                      (state final)
                      ))
)

(defrule jukka "" 
	(price Medium)
	(officiality unofficial)
	(pot-flower Yes)
	(personality Traditional)
	?state<-(UI-state)
     =>
	(retract ?state)
	(assert (UI-state (display JukkaChoice)
                      (state final)
                     ))
)

(defrule hoja-piekna "" 
	(price High)
	(officiality unofficial)
	(pot-flower Yes)
	(personality Traditional|Sentimental)
	?state<-(UI-state)
     =>
	(retract ?state)
	(assert (UI-state (display HojaPieknaChoice)
                      (state final)
                     ))
)

(defrule bonsai "" 
	(price High)
	(officiality semi-official|unofficial)
	(pot-flower Yes)
	(personality Creative)
	?state<-(UI-state)
     =>
	(retract ?state)
	(assert (UI-state (display BonsaiChoice)
                      (state final)
                     ))
)

(defrule hedera "" 
	(price Cheap)
	(officiality unofficial)
	(pot-flower Yes)
	(personality Traditional)
	?state<-(UI-state)
     =>
	(retract ?state)
	(assert (UI-state (display HederaChoice)
                      (state final)
                     ))
)

(defrule hortensja-ogrodowa "" 
	(allergic No)
	(price Medium)
	(officiality semi-official)
	(pot-flower Yes)
	(personality Creative|Sentimental)
	?state<-(UI-state)
     =>
	(retract ?state)
	(assert (UI-state (display HortnesjaOgrodowaChoice)
                      (state final)
                     ))
)

(defrule bratki "" 
	(not (color ?))
	(price None)
	(season Summer)
	(officiality semi-official)
	(personality Creative)
	?state<-(UI-state)
     =>
	(retract ?state)
	(assert (UI-state (display BratkiChoice)
                      (state final)
                     ))
)

(defrule niezapominajki "" 
	(price None)
	(season Summer)
	(color red)
	(pot-flower No)
	?state<-(UI-state)
     =>
	(retract ?state)
	(assert (UI-state (display NiezapominajkiChoice)
                      (state final)
                     ))
)

(defrule alokazja "" 
	(officiality official)
	(pot-flower Yes)
	(price High)
	(personality Traditional|Sentimental)
	?state<-(UI-state)
     =>
	(retract ?state)
	(assert (UI-state (display AlokazjaChoice)
                      (state final)
                     ))
)

(defrule dracena "" 
	(officiality official)
	(pot-flower Yes)
	(price High)
	(personality Creative)
	?state<-(UI-state)
     =>
	(retract ?state)
	(assert (UI-state (display DracenaChoice)
                      (state final)
                     ))
)

(defrule frezja "" 
	(not (color ?))
	(allergic No)
	(pot-flower No)
	(price Medium|High)
	(officiality semi-official|unofficial)
	(personality Creative)
	?state<-(UI-state)
     =>
	(retract ?state)
	(assert (UI-state (display FrezjaChoice)
                      (state final)
                     ))
)

(defrule cactus ""
	(price Cheap)
	(personality Creative)
	(officiality unofficial)
	(pot-flower Yes)
	?state<-(UI-state)
     =>
	(retract ?state)
	(assert (UI-state (display CactusChoice)
                      (state final)
                     ))
)

(defrule wrzos ""
	(season Autumn) 
	(price None) 
	(pot-flower No)
	?state<-(UI-state)
     =>
	(retract ?state)
	(assert (UI-state (display WrzosChoice)
                      (state final)
                     ))
)

(defrule strelitzia ""
	(not (color ?))
	(officiality official)
	(price High) 
	(pot-flower No)
	?state<-(UI-state)
     =>
	(retract ?state)
	(assert (UI-state (display StrelitziaChoice)
                      (state final)
                     ))
)

(defrule gladiolus ""
	(not (color ?))
	(officiality official)
	(price Cheap) 
	(pot-flower No)
	(personality Traditional|Sentimental)
	?state<-(UI-state)
     =>
	(retract ?state)
	(assert (UI-state (display GladiolusChoice)
                      (state final)
                     ))
)

(defrule amaryllis ""
	(not (color ?))
	(officiality unofficial)
	(personality Sentimental|Creative)
	(price High) 
	(pot-flower No)
	?state<-(UI-state)
     =>
	(retract ?state)
	(assert (UI-state (display AmaryllisChoice)
                      (state final)
                     ))
)

(defrule Bromelia ""
	(price Medium)
	(personality Creative)
	(officiality unofficial)
	(pot-flower Yes)
	?state<-(UI-state)
     =>
	(retract ?state)
	(assert (UI-state (display BromeliaceaeChoice)
                      (state final)
                     ))
)

(defrule brak ""
	(declare (salience -10))
	?state<-(UI-state)
	 =>
	(retract ?state)
	(assert (UI-state (display BrakChoice)
                      (state final)
                     ))
)
; 102 razy defrule :)
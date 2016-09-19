;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Command-line version of PC Diagnostic Assistant from part 4 of
;; "Jess in Action"
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Question and answer templates

(deftemplate question
    "A question the application may ask"
    (slot text)       ;; The question itself
    (slot type)       ;; Can be multi, text, or numeric
    (multislot valid) ;; The allowed answers for type multi
    (slot ident))     ;; The "name" of the question

(deftemplate answer
  (slot ident)
  (slot text))

(do-backward-chaining answer)

(defrule MAIN::right-architecture
    (declare (auto-focus TRUE))
    (explicit (answer (ident hardware) (text ~x86)))
    =>
    (recommend-action "consult a human expert")
    (halt))

(defrule MAIN::not-plugged-in
    (declare (auto-focus TRUE))
    (answer (ident sound) (text no))
    (answer (ident plugged-in) (text no))
    =>
    (recommend-action "plug in the computer")
    (halt))

(defrule MAIN::power-supply-broken
    (declare (auto-focus TRUE))
    (answer (ident sound) (text no))
    (answer (ident plugged-in) (text yes))
    =>
    (recommend-action "repair or replace power supply")
    (halt))


(defrule MAIN::check-ram
    (declare (auto-focus TRUE))
    (answer (ident sound) (text yes))
    (answer (ident seek) (text no))
    (answer (ident does-beep) (text yes))
    (answer (ident how-many-beeps) (text ?t))
    (test (< (integer ?t) 3))
    =>
    (assert (check loose-ram))
    (recommend-action "check for loose RAM, then continue"))

(defrule MAIN::unknown-sound
    (declare (auto-focus TRUE))
    (answer (ident sound) (text yes))
    (answer (ident seek) (text no))
    (answer (ident does-beep) (text no))
    =>
    (recommend-action "consult a human expert")
    (halt))

(defrule MAIN::motherboard-or-keyboard
    (declare (auto-focus TRUE))
    (answer (ident sound) (text yes))
    (answer (ident seek) (text no))
    (answer (ident does-beep) (text yes))
    (answer (ident how-many-beeps) (text ?t))
    (test (>= (integer ?t) 3))
    =>
    (recommend-action "check keyboard and motherboard")
    (halt))

(defrule MAIN::no-boot-start
    (declare (auto-focus TRUE))
    (answer (ident sound) (text yes))
    (answer (ident seek) (text yes))
    (answer (ident boot-begins) (text no))
    =>
    (recommend-action
    "check keyboard, RAM, motherboard, and power supply")
    (halt))

(defrule MAIN::boot-start
    (declare (auto-focus TRUE))
    (answer (ident sound) (text yes))
    (answer (ident seek) (text yes))
    (answer (ident boot-begins) (text yes))
    =>
    (recommend-action "consult a software expert")
    (halt))

(defrule MAIN::loose-ram
    (declare (auto-focus TRUE))
    (check loose-ram)
    (answer (ident loose-ram) (text yes))
    =>
    (recommend-action "remove and reseat memory modules")
    (halt))

(defrule MAIN::faulty-ram
    (declare (auto-focus TRUE))
    (check loose-ram)
    (answer (ident loose-ram) (text no))
    =>
    (recommend-action
    "replace memory modules one by one and retest")
    (halt))

 (deffacts MAIN::question-data
    (question (ident hardware)
      (type multi) (valid x86 Macintosh other)
      (text "What kind of hardware is it?"))
    (question
      (ident sound) (type multi) (valid yes no)
      (text "Does the computer make any sound?"))
    (question
      (ident plugged-in) (type multi) (valid yes no)
      (text "Is the computer plugged in?"))
    (question
      (ident seek) (type multi) (valid yes no)
      (text "Does the disk make \"seeking\" sounds?"))
    (question
      (ident does-beep) (type multi) (valid yes no)
      (text "Does the computer beep?"))
    (question
      (ident how-many-beeps) (type number) (valid)
      (text "How many times does it beep?"))
    (question
      (ident loose-ram) (type multi) (valid yes no)
      (text "Are any of the memory modules loose?"))
    (question
      (ident boot-begins) (type multi) (valid yes no)
      (text "Does the computer begin to boot?"))
    (MAIN::ask hardware) )

(deffunction recommend-action (?action)
    "Give final instructions to the user"
    (printout t "I recommend that you " ?action crlf))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defmodule trigger)

(defrule trigger::supply-answers
    (declare (auto-focus TRUE))
    (MAIN::need-answer (ident ?id))
    (not (MAIN::answer (ident ?id)))
    (not (MAIN::ask ?))
    =>
    (assert (MAIN::ask ?id))
    (return))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defmodule ask)

(defrule ask::ask-question-by-id
    "Ask a question and assert the answer"
    (declare (auto-focus TRUE))
    (MAIN::question (ident ?id) (text ?text)
                    (valid $?valid) (type ?type))
    (not (MAIN::answer (ident ?id)))
    ?ask <- (MAIN::ask ?id)
    =>
    (retract ?ask)
    (bind ?answer (ask-user ?text ?type ?valid))
    (assert (answer (ident ?id) (text ?answer)))
    (return))

(deffunction ask-user (?question ?type ?valid)
    "Ask a question, and return the answer"
    (bind ?answer "")
    (while (not (is-of-type ?answer ?type ?valid)) do
      (printout t ?question " ")
      (if (eq ?type multi) then
        (printout t crlf "Valid answers are ")
        (foreach ?item ?valid
          (printout t ?item " "))
        (printout t ":"))
      (bind ?answer (read)))
    (return ?answer))

(deffunction is-of-type (?answer ?type ?valid)
    "Check that the answer has the right form"
    (if (eq ?type multi) then
      (foreach ?item ?valid
        (if (eq (sym-cat ?answer) (sym-cat ?item)) then
          (return TRUE)))
      (return FALSE))

    (if (eq ?type number) then
      (return (is-a-number ?answer)))

    ;; plain text
    (return (> (str-length ?answer) 0)))

(deffunction is-a-number (?value)
    "Return TRUE if ?value is a number"
    (try
      (integer ?value)
      (return TRUE)
    catch
      (return FALSE)))

(reset)
(run)

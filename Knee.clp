(clear)
(reset)

(defglobal ?*N* = " 
") ;global variable used similarly to the newline character in java "\n"

/*
*  The (doc) method displays the top level documentation required
*  by the style guide. This documentation can also be seen in-game
*  at the beginning, when the system will prompt the user if
*  they would like to see the documentation for the game.
*/
(deffunction doc()
   (printout t
             
"
****************************************************************************
*                                                                         *
*                          Knee Injury Expert System                      *
*                             Name: Oisin Coveney                         *
*                     Date Created: November 30, 2015                     *
*               Date Last Modified: January 4, 2016                       *
*                        Submitted: January 2016                          *
*                                                                         *
*    The Knee Injury Expert System attempts to replicate the expertise    *
*    of a physician who is diagnosing somebody's knee injury.             *             
*                                                                         *                            
*    Knowledge was collected through four interviews with two physicans,  *                      
*    Jaron Olson and Jenna Allen, who work at the Harker School and       *                 
*    have experience that, combined, spans more than 20 years.            *         
*                                                                         *
*    Of course, while the two physicians have a lot of experience,        *                                
*    they could only impart so much information within these interviews.  *                  
*    Therefore, injury information will not be completely comprehensive.  *  
*    For example, only a few chronic injuries are included, since we ran  *   
*    out of interview time. However, there are many different acute       *   
*    injuries.                                                            *
*                                                                         *
*    The system uses the methods (loadSubRules) and (loadEndRules) to     *
*    create rules from the files subRules.txt and endRules.txt,           *
*    respectively.                                                        *
*                                                                         *
*                                                                         *
*    The two types of rules have fundamental differences.                 *
*    Rules created from subRules.txt contain backward chaining elements,  *
*    and use the (multipleChoice) method by manipulating information      *
*    formatted in the text file. Meanwhile, rules created from            *
*    endRules.txt contain the terminal rules, whose left hand side        *
*    contains the symptoms of the injury, while the right hand side       *
*    contains a (printout) of the injury diagnosis and treatment.         *
*                                                                         *
*                                                                         *
*    The format of the rules in subRules.txt is:                          *
*                                                                         *
*    rule_name                                                            *
*    r: \"root_assertion\"                                                  *
*    q: \"question\"                                                        *
*    LHS:                                                                 *
*    (rules properly formatted in JESS language)                          *
*    RHS:                                                                 *
*    \"English sentence 1\"    \"corresponding pattern to assert 1\"          *
*    \"English sentence 2\"    \"corresponding pattern to assert 2\"          *
*                                                                         *
*    This format allows for quicker creation of rules that utilize        *
*    the (multipleChoice) function, which requires a root assertion,      *
*    a question, and two lists, the answer and pattern lists.             *
*                                                                         *
*    The answer list, stylized as ?ansList, contains English sentences    *
*    that have possible answers to the question. When presented to the    *
*    user, these answers are numbered to allow for easier input.          *
*                                                                         *
*    The pattern list, stylized as ?pattList, contains the corresponding  *
*    pattern for each answer in the answer list. Thus, this pattern list  *
*    is the same length as the answer list.                               *
*                                                                         *
*    This correspondance allows this program to 'translate' between       *
*    English sentences and patterns that are useful for the program.      *
*                                                                         *
*                                                                         *
*    The format of the rules in endRules.txt is:                          *
*                                                                         *
*    injury_name_in_one_UpperCamelCase_word                               *
*                                                                         *
*    Symptoms                                                             *
*    root_pattern 1      \"sub pattern 1\"                                  *
*    root_pattern 2      \"sub pattern 2\"                                  *
*    root_pattern 3      \"sub pattern 3\"                                  *
*                                                                         *
*    Diagnosis                                                            *
*    \"injury name\"                                                        *
*    \"general explanation about the injury\"                               *
*                                                                         *    
*    Treatment                                                            *
*    \"magnitude_of_injury (mild, moderate, severe, etc.),                 *
*            treatment recommendations\"                                   *
*                                                                         *
*    *optional depending on injury*                                       *
*    \"PRICE\"                                                              *
*    \"Strength\"                                                           *
*    \"Cardio\"                                                             *
*                                                                         *
*    With this format, terminal rules are created in which the symptoms   *
*    correspond to left hand rules, while the right hand side contains    *
*    the (printout) for diagnosis and treatment.                          *
*                                                                         *
*                                                                         *
*    These rules are then compiled with the (loadAllRules) function,      *
*    which uses the (loadSubRule) and (loadEndRule) functions to          *
*    compile the rules into a single string. This string is then          *
*    compiled with (build), then run.                                     *
*                                                                         *
*                                                                         *
*    Please remember that while this system attempts to replicate         *
*    the expertise of a physician, this system cannot perform             *
*    special tests and X-rays that will make diagnosis more effective     *
*    and accurate. If you think that the system has not accurately        *
*    diagnosed and treated your injury, you should see a physician.       *
*                                                                         *
*                             Have fun!                                   *
*                                                                         *
***************************************************************************"
      
             
   crlf
   )
   (return)
)



/*
* (ask) prompts the user with a question and a list of answers, using 
* (printout) to display the prompt, then returns the user's answer.
*
*/
(deffunction ask (?q ?a)
   (printout t crlf ?q crlf ?a crlf
    "Your answer: ")
                                    ;prompts the user for a word 
                                    ;and presents possible answers
   (bind ?x (read))                 ;put user input into variable ?x
   (return ?x)                      ;returns the user input
) ;deffunction ask()


/*
*  (assertTrait ?token) takes ?token for a rule that
*  should be asserted using the (assert-string) function.
*  
*  For example, if the rule "assignment late" must be
*  asserted, (assertTrait "assignment late") will assert
*  the rule (assignment late).
*  
*  The function is used in the (multipleChoice) function, to assert
*  any rules that define the traits of an animal.
* 
*/
(deffunction assertTrait(?token)
   (bind ?x (str-cat "
                     (" ?token ")"))  ;creates the rule in a string of (?token)
   (assert-string ?x)                  ;asserts the string using (assert-string)
   (return)
) ;deffunction assertTrait(?token)





/*
*  
*  (multipleChoice ?q ?root ?ansList ?patternList) takes in
*  four parameters:
*  
*  ?q - a string that contains a question
*  ?root - a string that contains the root of an assertion pattern
*  ?ansList - a list of strings containing possible answers to the question
*  ?patternList - a list with the same number of elements as ?ansList, with each entry
*                 corresponding to the entry in ?ansList with the same index
*  
*  The (multipleChoice) function drives the input and output with the user, and makes
*  assertions based on user input.
*  
*  The function first asks the user a question, and uses the (numerate) method to deliver
*  a numbered list, so the user can answer with a number rather than a whole sentence.
*  
*  It then takes the user's input and checks it using the (validate) method, making sure
*  that the input is a number that corresponds with a ?ansList element.
*  
*  Then, if the user's input does not match an element, the method will run again with a
*  warning for the user.
*
*  Otherwise, the user's input number will be taken, and the list element in ?patternList
*  with the same index number will be taken. The ?patternList element should correspond with
*  an ?ansList element.
*
*  Finally, the function will use the (assertTrait) method to assert the pattern
*  (?root ?pattern), unless the ?patternList element is "no assertion", in which nothing
*  will be asserted.
*  
*
*
*  In this project, the use of the ?ansList and ?patternList can work as a 'translator'
*  between normal English sentences and shorter, more complicated words used in kinesiology.
*  
*  For example, an element in ?ansList could say "My injury happened suddenly.", while
*  the corresponding element in ?patternList could say "acute". The user is able to understand
*  and answer using words they can understand, while this sentence is 'translated' into
*  a word more useful for a symptom for an injury.
*  
*  In the text file subRules.txt, you can see these translations. Here is a table of
*  ?ansList and ?patternList elements side-by-side for the "location" root:
*              "Outer (lateral) side of the knee"    "lateral"
*              "Inner (medial) side of the knee"     "medial"
*              "On, below or under the kneecap"      "anterior"
*              "The back side of the knee"           "posterior"
*  
*  With this function, we can turn normal English into something more useful for the program.
*
*/
(deffunction multipleChoice (?q ?root ?ansList ?patternList)
   
   (bind ?input (ask ?q (numerate ?ansList)))                                          ;creates a numbered list and asks the user for input
   (bind ?boolean (validate ?input (length$ ?ansList)))                                ;validates the user's input with the (validate) method

   (if (eq ?boolean FALSE) then                                                        ;if the user's answer does not correspond with the list
       (printout t crlf
            "Please type the number that most closely represents your answer." crlf)   ;warns the user if they have not inputted a correct answer
       (multipleChoice ?q ?root ?ansList ?patternList)

    else                                                                               ;if input is valid
      (bind ?pattern (nth$ ?input ?patternList))                                       ;gets the corresponding element from ?patternList
      (if (not (eq ?input "no assertion")) then                                        ;if the pattern is "no assertion", nothing gets asserted
         (assertTrait (str-cat ?root " " ?pattern))                                    ;asserts a pattern of (?root ?pattern)
      )
   )
      
   (return)                                                                            ;end of the function
) ;(deffunction multipleChoice (?q ?root ?ansList ?patternList))




/*
*  
*  (numerate ?list) takes in one parameter ?list
*  that contains elements to be put together into
*  a string containing a formatted number list.
*  
*  For example, if a list of
*  ("Bill" "Nye" "The" "Science" "Guy")
*  was inputted into the function,
*  a list containing:
*  "
*  1. Bill
*  2. Nye
*  3. The
*  4. Science
*  5. Guy
*  "
*  would be returned.
*  
*  In this project, this method is used with the (multipleChoice)
*  function. That function passes its ?ansList, which contains
*  the English sentence answers that a user can select. This method
*  numbers each sentence, so the user can choose a number instead of
*  typing a whole sentence into the (ask) prompt.
*  
*  
*/
(deffunction numerate (?list)
   (bind ?length (length$ ?list))                   ;gets the length of the list for the loop
   (bind ?string ?*N*)                              ;begins the string with a new line
   
   (for (bind ?i 1) (<= ?i ?length) (++ ?i)         ;iterates through the list
        (bind ?x (str-cat ?i ". " (nth$ ?i ?list))) ;adding a number to the beginning of the element
        (bind ?string (str-cat ?string ?x ?*N*))    ;and a new line after each entry
   )
   
   (return ?string)
) ;(deffunction numerate (?list))
   
/*
*
* (validate ?input ?length) takes in two parameters:
* 
* ?input - a number that reflects the user's input in the (ask) prompt
* ?length - the number of entries given by the numerated ?ansList
* 
* The method checks if the ?input is a number, greater than zero,
* and less than or equal to the ?length number.
*
*/
(deffunction validate (?input ?length)
   (return (and               ;one-line method
         (numberp ?input)     ;checks if ?input is a number
         (<= ?input ?length)  ;then if it is less than or equal to the ?length
         (> ?input 0)         ;then if it is greater than 0
           )
   )
) ;(deffunction validate (?input ?length))



/*
*  
*  (loadAllRules) opens the two files subRules.txt and endRules.txt, and uses
*  the (loadSubRule) and (loadEndRule) functions to build the initial and terminal
*  rules from the text files.
*  
*  The method returns a string containing all the rules delineated in the text files.
*  With this function, new material could easily be added in a readable txt file, rather
*  than mixed in with code.
*  
*  The files are opened in the "d" and "f" routers respectively so user input in router "t"
*  will not be disrupted.
*
*/
(deffunction loadAllRules ()
   
   (open subRules.txt d)                                                   ;opens the subRules text in the "d" router
   
   (bind ?rules "")                                                        ;creates the string to be returned
   
   (for (bind ?r (loadSubRule)) (not (eq ?r FALSE)) (bind ?r (loadSubRule));iterates through the subRules text using the (loadSubRule) function
        
        (bind ?rules (str-cat ?rules ?*N* ?r))                             ;binds the newly-created rule to the ?rules string
        
   )
   
   (open endRules.txt f)                                                   ;opens the endRules text in the "f" router
   
   (for (bind ?s (loadEndRule)) (not (eq ?s FALSE)) (bind ?s (loadEndRule));iterates through the endRules text using the (loadEndRule) function
   
        (bind ?rules (str-cat ?rules ?*N* ?s))                             ;binds the new end rules to the ?rules string
        
   )
   
   
   (return ?rules)                                                         ;returns all the rules contained the two files

)




/*
*  
*  (loadSubRule) takes in no parameters, and returns a string containing
*  a single rule, and sometimes a (do-backward-chaining) function, depending
*  on the content found in the subRules text file.
*  
*  This method will create a rule if the first string from (read d) is not
*  "end". Otherwise, the function will return FALSE.
*  
*  If the read string is not "end", then the method will create a (defrule)
*  header, and get the assertion root and question using the (readline)
*  method and a constant ?END_OF_IDENTIFIER, which delinates the index of where
*  the root and question when a new line is read with (newline d).
*  
*  Then, the left hand side of the rule is created, first iterating through
*  organizational headers in the text file, until arriving at rules
*  that have been properly formatted in the text file. If one of these rules
*  is a (need- ?) rule, then the corresponding (do-backward-chaining) function
*  will also be created.
*  
*  The function then iterates to the RHS rules using the (readline) method.
*  Then, two strings are created that correspond to the lists that will be
*  used in the (multipleChoice) function. Fittingly, the ?ansString string
*  corresponds to ?ansList in the (multipleChoice) function, and
*  ?pattString to ?patternList. The elements are added using a binary switch
*  that will switch between the two strings as elements are added, so the
*  corresponding elements in the text file are placed to correctly
*  correspond to a user's answer.
*  
*  Finally, the rule is created by binding the header, left, and right hand
*  sides together, and is returned.
*  
*  
*/
(deffunction loadSubRule ()
   
   (bind ?END_OF_IDENTIFIER 5)                                                   ;index where ?root and ?question begin in the text file
   (bind ?r (read d))                                                            ;uses (read) to get the name of the rule
   (bind ?rule FALSE)                                                            ;sets rule to false in case (read) equalled "end"
   ;name
   
   (if (not (eq ?r end)) then                                                    ;a rule name was found, so the function can continue
   
      (bind ?rule (str-cat "(defrule " ?r ?*N*))                                 ;rule header is created with the name

      (readline d)                                                               ;iterates past organizational header
      (bind ?r (readline d))                                                     ;gets the first line
      (bind ?root (sub-string ?END_OF_IDENTIFIER (- (str-length ?r) 1) ?r))      ;and extracts the assertion root

      (bind ?r (readline d))                                                     ;then moves to the next line
      (bind ?question (sub-string ?END_OF_IDENTIFIER (- (str-length ?r) 1) ?r))  ;and gets the question

      
       ;LHS - adding properly formatted JESS rules to the left hand side of the rule
       
      (readline d)                                                               ;iterates through LHS header on file
      (bind ?left "")                                                            ;creates ?left for all LHS rules

      (for (bind ?r (readline d)) (not (eq ?r "RHS:")) (bind ?r (readline d))    ;gets all rules, which are properly formatted in the file
         
           (bind ?left (str-cat ?left " " ?r))                                   ;adds the new rules to the left hand side
           
      )

      (if (not (eq (str-index "need-" ?left) FALSE)) then                        ;if one of the rules was a (need-) rule
          
          (bind ?rule (str-cat "(do-backward-chaining " ?root ")" ?*N* ?rule))   ;(do-backward-chaining) is added outside the rule
          
      )

      ;RHS - building the multipleChoice method
      ;multipleChoice - question, root, answerlist, patternlist

      (bind ?right (str-cat "(multipleChoice \"" ?question "\" \"" ?root "\" ")) ;all non-end rules will have a (multipleChoice) element

      (bind ?ansString "")                                                       ;corresponding strings for ?ansList and ?patternList
      (bind ?pattString "")                                                      ;for the (multipleChoice) function

      (bind ?b TRUE)                                                             ;binary switch for switching between inserting to
                                                                                 ;?ansString or ?pattString
      (for (bind ?r (read d)) (not (eq ?r *)) (bind ?r (read d))                 ;iterates through every element regardless of line and space
           
           (if (eq ?b TRUE) then                                                 
                                                                                 ;Starts with ?ansString, then every other token
               (bind ?ansString (str-cat ?ansString "\"" ?r "\" " ?*N*))         ;is inserted into ?ansString while the others
               
            else
               
               (bind ?pattString (str-cat ?pattString "\"" ?r "\" " ?*N*))       ;are entered into ?pattString.
               
           )
           
           (bind ?b (not ?b))                                                    ;the switch for changing string output
      )

      (bind ?ansString (str-cat "(list " ?ansString ") "))                       ;creates a list than will be build later using (list) function
      (bind ?pattString (str-cat "(list " ?pattString ")"))

      (bind ?right (str-cat ?right ?ansString ?pattString ")"))                  ;puts the whole right side together, with mostly a 
                                                                                 ;(multipleChoice) declaration

      (bind ?rule (str-cat ?rule ?left " => " ?*N* ?right ")"))                  ;connects the header, left, and right sides
   )
   
   (return ?rule)
)






/*
*  
*  (loadEndRule) takes in no parameters, but reads the file endRules.txt
*  and returns a terminal rule that will present a diagnosis and treatment for an injury.
*  These rules contain all the symptoms of the injury on the left hand side, while the right
*  hand side will contain a diagnosis, an explanation, treatment, and,
*  depending on the injury, instructions for exercise and ice.
*  
*  The function will only create a rule if the first element is not "end".
*  Otherwise, it will return FALSE.
*  
*  If the function retrieves a name, then the function will continue by
*  creating a (defrule) header, and iterating through organizational headers
*  until it reaches the symptoms, which it will pass off to the (loadLeftEnd)
*  function to organize and return as a string.
*  
*  Then, the function extracts the injury and explanation information as strings
*  from the endRules.txt file for the right hand side of the rule.
*  Then, the function will use this information to create a heart-felt message
*  templated as "Unfortunately, you have a *INJURY*. This diagnosis means that *EXPLANATION*."
*  
*  The function will then iterate to the explanation, using another string template to explain
*  treatments to the injury. After, relevant instructions on icing the injury, rehabilitation,
*  and cardio exercises will be added depending on the injury.
*  
*  The function then combines the header, left, and right sides, and inserts an (assertTrait "end")
*  to assert that the system should halt and not ask any more questions.
*  
*  
*/
(deffunction loadEndRule ()
   
   (bind ?r (read f))                                    ;Reads the first word
   (bind ?rule FALSE)                                    ;Gets ready to return as FALSE in case the first word is "end"
   
   (if (not (eq ?r end)) then                            ;if the first word is not "end", the function continues and creates the rule
       
       
       (bind ?rule (str-cat "(defrule " ?r ?*N*))        ;creates the (defrule) header
       (readline f)                                      ;iteration through organization headers/fluff for readability in the text file
       (readline f)
       (readline f)
       
       ;LHS:Symptoms
       
       (bind ?left (loadLeftEnd))                        ;passes on the left hand side to the (loadLeftEnd) function for readability
      
       ;RHS: Diagnosis and Treatment
       
       (bind ?injury (read f))                           ;extracts the injury and explanation from the file
       (bind ?explanation (read f))
       
       (bind ?right (str-cat ?*N* ?*N* 
            "Unfortunately, you have a " ?injury ". This diagnosis means that " ?explanation)) ;creates heart-felt message with two previous elements
                                                                                       
      
       (read f)                                                                                ;iteration
       (bind ?treatment (str-cat ?*N* "Because a " ?injury " is " (read f) ?*N* ?*N*))         ;Treatment and assessment of damage
       (bind ?treatment (addPSC ?treatment))                                                   ;gets ice, rehab, and cardio exercises based on injury
       
       (bind ?right (str-cat ?right ?*N* ?treatment))                                          ;puts the whole right side together
       
       (bind ?rule (str-cat ?rule ?left ?*N* "=>" ?*N* "(printout t \"" ?right "\"" ?*N* ")" ?*N* "(assertTrait \"end\"))")) ;puts the whole rule together
                                                                                                                             ;with (assert end) to stop
   )
   
   (return ?rule)                                        ;returns the rule

)


/*
*  
*  (loadLeftEnd) constructs the left hand side of the end rules 
*  from the "Symptoms" section of the text file endRules.txt
*  This function is called upon by the (loadEndRule) function to
*  organize the symptoms of each injury into rules usable for JESS.
*  
*  The system uses three local variables:
*  ?OR_INDEX and ?AND_INDEX both delineate the index where rule content
*                           can be found after a "or" or "and" in the symptom index
*                           in the endRules.txt file
*  
*  ?EXTRANEOUS_CHAR delineates that there is an extra character at the end of (readline)
*  that must be removed so the token inside can be used.
*  
*  
*  The function uses the (read) and (readline) functions to iterate through the
*  symptoms given in endRules.txt. As the iteration continues, rules formatted as
*  
*              onset                  "acute"
*              location               "lateral"
*              mechanism              "plant and twist" or "varus force"
*  
*  are formatted into: 
*              (onset acute)
*              (location lateral)
*              (or (mechanism plant and twist) (mechanism varus force))
*  
*  These rules are then returned to the (loadEndRule) function to act
*  as the left hand side of the end rules.
*  
*/
(deffunction loadLeftEnd ()
   
   (bind ?OR_INDEX 6)                                                                              ;index after "or" that contains useful rule content
   (bind ?AND_INDEX 7)                                                                             ;index after "and" that contains useful rule content
   (bind ?EXTRANEOUS_CHAR 1)                                                                       ;number needed to get rid of extra symbols after the useful content
   
   
   (bind ?left "")                                                                                 ;Creates string to be returned containing all the rules
   
   (for (bind ?r (read f)) (not (eq ?r Diagnosis)) (bind ?r (read f))                              ;While the function is still in "Symptoms" section of txt
        
        (bind ?pattern (str-cat "(" ?r " " (read f) ")"))                                          ;The rule pattern that will be added to the assertion
        
        (bind ?line (readline f))                                                                  ;(readline) is used to check for "or" or "and" content
        
        (if (not (eq ?line "")) then                                                               ;if there is any content
            
            (if (numberp (str-index or ?line)) then                                                ;if there is an "or"
                
                
                (bind ?p2 (sub-string ?OR_INDEX (- (str-length ?line) ?EXTRANEOUS_CHAR) ?line))    ;the token that can be used for the pattern of the assertion
                
                (bind ?pattern (str-cat "(or " ?pattern "(" ?r " " ?p2 "))"))                      ;a new pattern containing the original + the new pattern
                                                                                                   ;with the "or" symbol
            else
                
                (if (numberp (str-index and ?line)) then                                           ;if there is an "and"
                    
                  (bind ?p2 (sub-string ?AND_INDEX (- (str-length ?line) ?EXTRANEOUS_CHAR) ?line)) ;the token that can be used for the pattern of the assertion
                
                  (bind ?pattern (str-cat "(and " ?pattern "(" ?r " " ?p2 "))"))                   ;a new pattern containing the original + the new pattern
                                                                                                   ;with the "and" symbol
                    
                )   
            )
        )
        
        (bind ?left (str-cat ?left ?*N* ?pattern))                                                 ;Adds the new fact to the left hand string
   )
   (return ?left)                                                                                  ;returns the string to the loadEndRule function
)






/*
*  (addPSC) takes in a string that contains the key words "PRICE", "Strength", and "Cardio"
*  that will cause the function to add relevant information about:
*  
*     PRICE: icing and compression instructions
*     Strength: knee muscle strength rehabilitation exercises
*     Cardio: cardio exercises that are not strenuous on the knee
*  
*  The function uses three "if" statements to determine whether each section
*  should be added to the ?treatment, but uses the (read) function to iterate through
*  the endRules.txt file to find the keywords. If the function gets to "*" before it finds
*  any key words, then the function will return the ?treatment with no new information.
*/
(deffunction addPSC (?treatment)
   
  (for (bind ?r (read f)) (not (eq * ?r)) (bind ?r (read f))   ;iterates through the file until it reaches "*" and returns
            
            (if (eq ?r "PRICE") then                           ;PRICE: methods for icing and compression
                (bind ?treatment (str-cat ?treatment ?*N* 
"The PRICE treatment consists of five parameters:
      1: Prevention - Stop participating in the activity to prevent further injuries.
      2: Rest - Take a break from the activity, so your injury can heal.
      3: Ice - Place a bag of ice on the affected area.
      4: Compression - Use plastic wrap or a towel to compress the ice into the 
         injured area.
      5: Elevation - Elevate the injured area. This is usually done by lying down,
                     and placing the knee on a pillow or other soft surface.
      ")))
            (if (eq ?r "Strength") then                        ;strength rehabilitation exercises to strengthen knee muscles
                
                (bind ?treatment (str-cat ?treatment ?*N* ?*N* 
                                          
"Strength rehabilitation exercises are very important for recovering from most injuries,
 but be sure to keep slow and steady movements.
 Do not fully exert yourself! You can potentially injure yourself more.
      
   1: Step-Ups: Using a hard elevated surface, step up with one leg onto the
                platform,then slowly bring your other knee up into the air in front    
                of you for 3 seconds.
                Slowly return and do the same thing on the other side. Do five
                repetitions for each leg.
   
   2: Ski Hops: This exercise should only be used in the event of a mild injury
                because of the jumping motion.
                Stand on one leg slightly bent, and hop laterally about 2 feet,
                landing softly with the knee slightly bent.
                Do eight hops per leg.
   
   3: Body-weight Squats: Spread your feet shoulder-width apart. Slowly bend your 
                          knees, making sure to keep them level with your toes.
                          Lower until your knee forms a 90 degree angle. Do three 
                          reps of 5-10 times depending on your comfort level.
                          Do not lean forward, as this could move your knees forward 
                          and cause unneeded stress.
   
   4: Resisted Knee Exercises: Place your foot inside a resistance band and push
                               slowly against the resistance until almost fully        
                               extended. Then, slowly bring the foot back.
                               Do three reps of 8 times each leg."
                                          
                                          
                                 )
                   )
                
            )
            
            (if (eq ?r "Cardio") then                          ;cardiovascular exercises to stay fit while recovering from injury
               
                (bind ?treatment (str-cat ?treatment ?*N* ?*N*
"These cardio exercises can be helpful when treating your knee injury, and
you want to stay in shape for the season. Be careful to not over-exert your legs,
since this could cause more injuries.
   
   1: Biking - Biking on a smooth surface, such as a road or a well-maintained trail,
               can allow you to relieve stress from your knees
               Be sure to move at a somewhat leisurely pace.
  
   2: Swimming - Swimming can allow you to move freely without the worries of putting
                 pressure on your knee. Just be sure to not jump straight into the 
                 shallow end; this action could rupture another part of your knee if
                 you are not careful.

   3: Rowing - Using rowing machines at gyms (or at your home, if you have one) will
               give you a good upper-body workout. Make sure to stabilize
               the knee with a brace.
       
These three exercises can help you stay relatively fit while you recover from your
injury. Refrain from sports that involve rotating or the use of cleats, such as
soccer or football, since you can potentially twist your leg and injure your 
knee."
                                 )
               )
            )
            
            
       )
   (return ?treatment)                                      ;returns once the iterator finds "*"
)




/*
*  
*  The (noMatch) rule will fire when no injuries have been found (the (end) rule has not fired)
*  and every possible rule and combination has fired based on the user's input.
*  
*  To get the desired output of being the very last rule fired, (declare (salience -100))
*  will force the priority of the (noMatch) rule to be the lowest possible, firing every
*  rule until nothing else fires. If an end match is found, this rule will not fire. Otherwise,
*  if the system cannot find anymore matches, then the message 
*  "Unfortunately, no injury was found. Because of the scope of this project, not all injuries and treatments may be included" will display.
*  
*/
(defrule noMatch
   (declare (salience -100))                                                                  ;forces the noMatch rule to be
                                                                                              ;the lowest priority rule, only
                                                                                              ;activating if all the other rules
                                                                                              ;have fired
   
   (not (end))                                                                                ;only fires if an injury/diagnosis hasn't been found
   =>
   (printout t crlf crlf "Unfortunately, no injury was found. Because of the scope of this project," crlf
                     "not all injuries and treatments may be included. Please see a licensed" crlf
                     "physician who will be able to determine your injury." crlf crlf crlf)   ;the system cannot find an injury
                                                                                              ;and must display an unsuccessful message
   
) ;defrule noMatch 


(defrule end
   (end)
   =>
   (printout t crlf crlf 
"Please remember that this system can be used for basic diagnoses for knee injuries and does not replace a real physician 
 (although it attempts to). If the advice given does not heal your injury, please see a licensed physician who can perform
 physical tests, palpations, and X-rays that a computer system cannot make.
             
 Thanks for using the Knee Injury Expert System!" crlf)
   (halt)
)





/*
*  
*  User Interface and Start of Game
*  
*  When the user runs this file, they will see a small user interface that
*  will allow them to see the documentation before they use the system.
*  
*  Otherwise, they can continue onto the game by typing anything else and
*  pressing ENTER.
*  
*/


(bind ?x (ask
"
***************************************************************************
*                Welcome to the Knee Injury Expert System!                *
*           Do you want to see the documentation for the system?          *
*                                                                         *"
"*   Type 1 for YES, otherwise press any other key and ENTER to begin!     *"))        ;first part of the user interface, welcoming user and
                                                                                       ;asking if they want to see the documentation


(if (eq ?x 1) then                                                           ;will display documenation using (doc) if user says YES
    (doc)
)


(printout t                                                                  ;if 1, doc is displayed then the game starts. Otherwise,
                                                                             ;the game starts anyway.
"

Please answer with the number that most closely corresponds to your situation.

")                                                                           ;tells user how to answer each question


(bind ?x (loadAllRules)) ;loads all rules
(build ?x)               ;then builds them into runnable code
(run)                    ;then runs it
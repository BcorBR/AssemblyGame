call levelMain

call render
call renderPlayer
jmp inGame


inGame:
  call DelayMove
  call mobMain
  jmp inGame

; selects level to be loaded
levelMain:
  push R0
  push R1

  load R0, curLevel ; takes curLevel number
  loadn R1, #1
  cmp R0, R1
  jne testLevel2
  call loadLevel1
  
  jmp levelMainFinish

  testLevel2:

  levelMainFinish:
    pop R1
    pop R0
    rts


loadLevel1:
  push R0
  push R1
  push R2

  ; player things
  loadn R0, #playerCoordRender
  loadn R1, #750
  storei R0, R1 ; stores coord 750 in player render

  inc R0
  storei R0, R1 ; stores coord 750 in player map

  ; render things
  loadn R0, #renderVar
  loadn R1, #0   ;#480
  storei R0, R1 ; stores render min cord as 480

  inc R0
  loadn R1, #1200   ;#1680
  storei R0, R1 ; stores max coord as 1680

  ; restars slideCounter
  loadn R0, #slideCounter
  loadn R1, #20000
  storei R0, R1
  inc R0
  loadn R1, #65000
  storei R0, R1

  ; mob things
  loadn R0, #mob1
  loadn R1, #1
  storei R0, R1 ; activates mob1

  loadn R1, #6
  add R1, R1, R0 ; addr to mapCoord of mob
  loadn R2, #841
  storei R1, R2 ; coord now 841

  inc R1 ; addr to chase bool
  loadn R2, #0
  storei R1, R2 ; restarts chase bool
  inc R1
  storei R1, R2 ; restarts alert bool

  inc R1   ; addr to side mob is facing
  loadn R2, #1
  storei R1, R2 ; stores 1 (facing right)

  loadn R1, #12
  add R1, R1, R0 ; addr to script number
  loadn R2, #1
  storei R1, R2 ; stores script 1

  ; slides map from bottom to top
  ;call levelSlide

; ADDD POP PUSH
  pop R2
  pop R1
  pop R0
  rts


; will slide map from bottom to top
levelSlide:
  push R0
  push R1
  push R2
  push R3
  push R4
  push R5

  ; checks delay
  loadn R0, #slideCounter ; addr to first counter
  mov R1, R0
  inc R1 ; addr to second counter

  loadi R2, R1 ; R2 = second counter value
  loadn R5, #0
  cmp R2, R5 ; if 0, test first counter, else, dec second counter
  jeq levelSlideTestFirstCounter

  dec R2
  storei R1, R2
  jmp levelSlideFinish

  levelSlideTestFirstCounter:
    loadi R3, R0 ; R3 = first counter value
    cmp R3, R5 ; if 0, var = true, restore both counters
               ; else, dec counter 1 and restore counter 2
    jne levelSlideTestFirstNot0

    ; if 0
    loadn R4, #65000 ; stores to 2nd counter
    storei R1, R4
    loadn R4, #2000 ; stores to 1st counter
    storei R0, R4
    
    jmp levelSlideStartLoop

    levelSlideTestFirstNot0:
      dec R3
      storei R0, R3 ; decs first counter

      loadn R4, #65000 ; stores to 2nd counter
      storei R1, R4
      jmp levelSlideFinish


  levelSlideStartLoop:  
    loadn R0, #renderVar
    mov R1, R0
    inc R1 ; addr to max coord to be rendered
    loadi R2, R0 ; min coord rendered
    loadi R3, R1 ; max coord rendered
    loadn R4, #40 ; 40 will be subed from coords
    loadn R5, #0 ; to be used as case base

    levelSlideLoop:
      call render
      call mobMain

      sub R2, R2, R4
      storei R0, R2 ; subs 40 to min coord to be rendered

      sub R3, R3, R4 ; subs 40 to max coord to be rendered
      storei R1, R3

      cmp R2, R5
      jne levelSlideLoop

  levelSlideFinish:
    pop R5
    pop R4
    pop R3
    pop R2
    pop R1
    pop R0
    rts

; loads configs for testing
testLevel:
  push R0
  push R1
  push R2
  
  loadn R0, #mob1
  loadn R1, #1
  storei R0, R1
  loadn R1, #6
  add R0, R0, R1
  loadn R2, #746
  storei R0, R2

  pop R2
  pop R1
  pop R0
  rts

mobMain:
  push R0
  push R1
  push R2

  ; checks which mobs are active and does calculates their behaviour if active
  checkActiveMob1:
    loadn R2, #1
    load R1, mob1
    cmp R1, R2 ; checks if mob is active
    jne checkActiveMob2

    loadn R0, #mob1 ; will be used for various instructions, 
                    ; should not be changed inside of them
    call mobMovement
    call behaveMob
    call renderExclaInter

  checkActiveMob2:

  pop R2
  pop R1
  pop R0
  rts

behaveMob:
  push R1
  push R2
  push R3
  push R4
  push R5
  push R6
  push R7

  ; checks chaseCondition not chaseBool
  checkChaseBool:
    load R1, playerCoordInMap
    call chaseCondition ; tests condition for chase state
                        ; returns true or false in register 2
    
    loadn R3, #1
    cmp R2, R3
    jne conditionChaseFalse ; if condition false, jmp

    conditionChaseTrue:
      loadn R2, #7
      add R2, R2, R0 ; addr to chase bool
      loadi R4, R2
      cmp R4, R3 ; chase bool == 1?
      jeq behaveMobFinish ; if chaseBool == 1 finish

      ; if == 0
      storei R2, R3 ; store 1 in chase bool
      
      ; store script chase

      jmp behaveMobFinish ; finish

    conditionChaseFalse:
      loadn R2, #7
      add R2, R2, R0 ; addr to chase bool
      loadi R4, R2
      cmp R4, R3 ; chase bool == 1?
      jne testAlertBool ; if chaseBool == 0 test alertBool

      loadn R4, #0
      storei R2, R4 ;
      inc R2 ; addr to alert bool
      storei R2, R3 ; stores 0 to chaseBool and 1 to alertBool

      ; STORE SCRIPT ALERT!!!!!!!!!!!!

      jmp behaveMobFinish
    
    testAlertBool:
      loadn R3, #8
      add R2, R3, R0 ; addr to alert bool
      loadi R2, R2
      loadn R3, #1
      cmp R2, R3
      jne behaveMobFinish ; if alertBool == 0, finish

      call delayMobAlert

  ; script movement
  scriptMovement:

  behaveMobFinish:
    pop R7
    pop R6
    pop R5
    pop R4
    pop R3
    pop R2
    pop R1
    rts

; will use R0 as addr of mob
mobMovement:
  push R1
  push R2
  push R3

  loadn R1, #1
  loadn R3, #7
  add R3, R3, R0 ; addr of chase bool
  loadi R2, R3
  cmp R2, R1 ; if chase bool = 1, script chase
             ; else, test alert
  jne mobMovementAlertTest

  ; CHASE SCRIPT HERE
  call scriptChase
  jmp mobMovementFinish

  mobMovementAlertTest:
    inc R3 ; addr of alert bool
    loadi R2, R3
    cmp R2, R1 ; if alert bool = 1, script alert
               ;else, scriptMain
    jne mobMovementScriptMain

    ; ALERT SCRIPT HERE

  mobMovementScriptMain:
    call scriptMain

  mobMovementFinish:
    pop R3
    pop R2
    pop R1
    rts


scriptChase:
  push R1
  push R2
  push R3
  push R4
  push R5
  push R6
  push R7

  ; DEKLAYYYYYYYYYYYYYYYYYYYYYYYYYYY
  call delayMoveMob ; will return bool in R2
  loadn R1, #0
  cmp R2, R1 ; if == 0, finish
             ; else, go on
  jeq scriptChaseFinish

  loadn R3, #6
  add R7, R3, R0 ; addr  to mob coord
  loadi R6, R7 ; mob coord
  
  loadn R4, #40
  mod R1, R6, R4 ; mob.x
  div R2, R6, R4 ; mob.y

  load R5, playerCoordInMap
  mod R3, R5, R4 ; player.x
  div R4, R5, R4 ; player.y

  loadn R5, #15
  add R5, R5, R0 ; addr to last move
  loadi R5, R5 ; last move

  cmp R3, R1 ; player.x > mob.x
             ; else if lesser, player.x lesser
             ; else if equal, test player.y
  jle scriptChasePlXLesMobX
  jeq scriptChasePlYGrMobY

  loadn R6, #'v' ; to compare with last move
  cmp R5, R6 ; last move vertical
  jeq scriptChaseWalkRight

  cmp R4, R2 ; if player.y > mob.y
  jgr scriptChaseWalkDown
  jle scriptChaseWalkUp

  jmp scriptChaseWalkRight

  scriptChasePlXLesMobX:
    loadn R6, #'v' ; to compare with last move
    cmp R5, R6 ; last move vertical
    jeq scriptChaseWalkLeft

    cmp R4, R2 ; if player.y > mob.y
    jgr scriptChaseWalkDown
    jle scriptChaseWalkUp

    jmp scriptChaseWalkLeft

  scriptChasePlYGrMobY:
    cmp R4, R2 ; player.y > mob.y
               ; else, player.y < mob.y
    jel scriptChasePlYLesMobY

  scriptChasePlYLesMobY:
    loadn R6, #'h' ; to compare with last move
    cmp R5, R6 ; last move horizontal
    jeq scriptChaseWalkUp

    cmp R3, R1 ; if player.x > mob.x
    jgr scriptChaseWalkRight
    jle scriptChaseWalkLeft

    jmp scriptChaseWalkUp

  scriptChaseWalkRight:
    inc R6 ; coord to the right
    storei R7, R6 ; stores new coord

    inc R7
    inc R7
    inc R7 ; addr to side looking
    loadn R6, #1
    storei R7, R6 ; stores looking at right
    
    loadn R6, #15
    add R6, R6, R0 ; addr to last movement
    loadn R7, #'h'
    storei R6, R7

    jmp scriptChaseFinish

  scriptChaseWalkLeft:
    dec R6 ; coord to the left
    storei R7, R6 ; stores new coord

    inc R7
    inc R7
    inc R7 ; addr to side looking
    loadn R6, #0
    storei R7, R6 ; stores looking at right
    
    loadn R6, #15
    add R6, R6, R0 ; addr to last movement
    loadn R7, #'h'
    storei R6, R7

    jmp scriptChaseFinish

  scriptChaseWalkUp:
    loadn R1, #40
    sub R6, R6, R1 ; coord up
    storei R7, R6 ; stores new coord
    
    loadn R6, #15
    add R6, R6, R0 ; addr to last movement
    loadn R7, #'v'
    storei R6, R7

    jmp scriptChaseFinish

  scriptChaseWalkDown:
    loadn R1, #40
    add R6, R6, R1 ; coord down
    storei R7, R6 ; stores new coord
    
    loadn R6, #15
    add R6, R6, R0 ; addr to last movement
    loadn R7, #'v'
    storei R6, R7

  scriptChaseFinish:
    pop R7
    pop R6
    pop R5
    pop R4
    pop R3
    pop R2
    pop R1
    rts



; will use R0 as addr of mob
scriptMain:
  push R1
  push R2
  push R3
  push R4
  push R5
  push R6

  loadn R2, #6
  add R2, R2, R0 ; addr of mob coord
  
  ; reads script number of mob
  loadn R1, #12
  add R1, R1, R0
  loadi R1, R1

  loadn R3, #0
  cmp R1, R3
  jne scriptMainTest1
  ; 0 does nothing
  jmp checkRenderUpperMob1

  ;scriptMainTest
  scriptMainTest1:
    loadn R3, #1
    cmp R1, R3
    jne scriptMainTest2

    loadn R3, #script1 ; R3 will hold addr of script!!! 
    jmp scriptMainAction

  scriptMainTest2:
    ; to be updated


  ; R3 must be addr of script
  scriptMainAction:
    loadi R4, R3 ; reads phase number

    ; check if we reached the end (script[1 + 2*phaseNum] == 0)
    loadn R5, #2
    mul R4, R4, R5
    inc R4
    add R6, R3, R4 ; R6 = addr script[1+2*phaseNum]
    loadi R4, R6 ; R4 = script[1+2*phaseNum]

    loadn R5, #0
    cmp R4, R5 ; if == 0, phaseNFum = 0
    jeq scriptMainLastPhase

    ; R3 = script1 addr
    ; R2 = addr of mob coord
    ; R4 = script[1+2*phaseNum]
    call mobMoveChoice
    loadi R2, R2 ; new value of mobCoord
    cmp R2, R4
    jne checkRenderUpperMob1 ; if mob coord == script[1 + 2*phasenum] 
                         ; we've reached our destintion, inc 1 to sscript[0]
    loadi R4, R3
    inc R4 ; loads script[0] inc and stores it
    storei R3, R4

    jmp checkRenderUpperMob1
  
  ; R3 must be addr of script
  scriptMainLastPhase:
    loadn R4, #0
    storei R3, R4 ; restarts num phase

    jmp checkRenderUpperMob1
  
  ; check if coord right to render 
  ; checks first y
  checkRenderUpperMob1:
    loadn R5, #renderVar
    
    loadn R7, #6
    add R1, R0, R7 ; addr of mapCoord
    loadi R1, R1 ; mapCoord of mob

    loadi R2, R5 ; min render coord
    cmp R1, R2 ; check if upper part coord is greater  or equal than min renderCoord
    jle checkRenderLowerMob1

    ; now checking max renderCoord
    inc R5
    loadi R2, R5
    cmp R1, R2 ; check if mapCoord lesser than maxCoord (exclusive)
    jeg checkRenderLowerMob1

      ; renders upper part of mob
      ; checks mob side
      loadn R3, #9
      add R3, R3, R0 ; addr to mob side
      loadi R3, R3
      loadn R4, #0 ; if equal, render left
      cmp R3, R4
      jeq checkRenderUpperMob1Left

      mov R3, R0
      inc R3 ; addr to first skin
      loadi R4, R3 ; R4 has skin

      ; using R0, R1, R2, R3, R5
      ; R1 has coordinMap, R2 has max render coord, R4 has skin
      ; renders left face
      load R2, renderVar ; R2 now has min coord render
      sub R6, R1, R2 ; has to render in coord (mapCoord - minRenderVar)
      outchar R4, R6

      ; renders right face
      inc R3
      loadi R4, R3 ; right face skin
      inc R6 ; increments render coord
      outchar R4, R6
      
      ; renders wings
      inc R3
      inc R3
      inc R3 ; addr to wings skin
      loadi R4, R3 ; has wing skin
      dec R6
      dec R6 ; wing render coord
      outchar R4, R6

      jmp checkRenderLowerMob1

      checkRenderUpperMob1Left:
        loadn R4, #2827

        ; R1 has coordinMap, R2 has max render coord, R4 has skin
        ; renders right face
        load R2, renderVar ; R2 now has min coord render
        sub R6, R1, R2 ; has to render in coord (mapCoord - minRenderVar)
        outchar R4, R6

        ; renders right face
        dec R4 ; left face skin
        dec R6 ; decrements render coord
        outchar R4, R6
        
        ; renders wings
        loadn R4, #2062
        inc R6
        inc R6 ; wing render coord
        outchar R4, R6

        jmp checkRenderLowerMob1

  checkRenderLowerMob1:
    ; R0 = addr of mob1, R1 = mapCoord, R3 = addr first skin
    loadn R5, #renderVar
    loadn R7, #40
    add R1, R1, R7 ; getting coord of lower part


    loadi R2, R5 ; min render coord
    cmp R1, R2 ; check if lower part coord is greater or equal than min renderCoord
    jle scriptMainFinish ; CHANGE THIS LATER!!!!!!!!!!!!!!!!!!

    ; now checking max renderCoord
    inc R5
    loadi R2, R5
    cmp R1, R2 ; check if mapCoord lesser than maxCoord (exclusive)
    jeg scriptMainFinish  ; CHANGE THIS LATER!!!!!!!!!!!!!!!!!!

      ; renders lower part of mob
        ; checks mob side
        loadn R3, #9
        add R3, R3, R0 ; addr to mob side
        loadi R3, R3
        loadn R4, #0 ; if equal, render left
        cmp R3, R4
        jeq checkRenderLowerMob1Left

        mov R3, R0
        inc R3
        inc R3
        inc R3 ; addr to left leg skin
        loadi R4, R3 ; R4 has skin

        ; using R0, R1, R2, R3, R5
        ; R1 has coordinMap of left leg, R2 has max render coord, R4 has skin
        ; renders left leg
        load R2, renderVar ; R2 now has min coord render
        sub R6, R1, R2 ; has to render in coord (mapCoord - minRenderVar)
        outchar R4, R6

        ; renders right leg
        inc R3
        loadi R4, R3 ; right face skin
        inc R6 ; increments render coord
        outchar R4, R6

        jmp scriptMainFinish

        checkRenderLowerMob1Left:
          loadn R4, #2828 ; right leg skin

          ; using R0, R1, R2, R3, R5
          ; R1 has coordinMap of left leg, R2 has max render coord, R4 has skin
          ; renders right leg
          load R2, renderVar ; R2 now has min coord render
          sub R6, R1, R2 ; has to render in coord (mapCoord - minRenderVar)
          outchar R4, R6

          ; renders left leg
          inc R4 ; left leg skin
          dec R6 ; increments render coord
          outchar R4, R6      

  scriptMainFinish:
    pop R6
    pop R5
    pop R4
    pop R3
    pop R2
    pop R1
    rts

; will use R3 as script addr and
; R0 as mob addr
; R6 = addr script[1+2*phaseNum]
mobMoveChoice:
  push R1
  push R2
  push R3
  push R4
  push R5
  push R6
  push R7
  
  ; checks delay
  call delayMoveMob ; will return bool in R2
  loadn R1, #0
  cmp R2, R1 ; if == 0, finish
             ; else, continue
  jeq mobMoveChoiceFinish
  
  inc R6 ; addr to side to move
  loadi R1, R6

  loadn R2, #'r'
  cmp R1, R2 ; if true, move right
  jeq mobMoveRight

  loadn R2, #'l'
  cmp R1, R2 ; if true, move left
  jeq mobMoveLeft

  loadn R2, #'d'
  cmp R1, R2 ; if true, move down
  jeq mobMoveDown

  loadn R2, #'u'
  cmp R1, R2 ; if true, move up
  jeq mobMoveUp

  jmp mobMoveChoiceFinish

  mobMoveRight:
  ; stores right side
    loadn R1, #9
    add R1, R1, R0 ; addr to side mob
    loadn R2, #1
    storei R1, R2 ; stores 1 to side val (right)

    loadn R2, #6
    add R2, R2, R0 ; addr to mapcoord
    loadi R1, R2
    inc R1 ; 1 pix to the right, mob's head

    ; if (mob's head + 1) mod 40 == 0, do nothing
    mov R3, R1
    inc R3
    loadn R4, #40
    mod R3, R3, R4 ; (mob's head + 1) mod 40

    loadn R4, #0
    cmp R3, R4 ; if == 0, finish
    jeq mobMoveChoiceFinish

    ; update map coord
    call renderSymbolBackground ; unrender symbol chase/alert
    loadi R3, R2
    inc R3 ; +1 mapcoord
    storei R2, R3

    mobMoveRightTestUpper:
      ; restore background
      loadn R5, #renderVar
      loadi R4, R5 ; map coord must greater than min var render

      loadi R3, R2 ; mob coord
      dec R3
      dec R3 ; coord of where wings were
      cmp R3, R4 ; if equal or greater, test maxCoord
                ; else, test lower part
      jle mobMoveRightTestLower

      inc R5 ; addr to max coord
      loadi R4, R5
      cmp R3, R4 ; if lesser, render background
                ; else, test lower part
      jeg mobMoveRightTestLower

      ; restores upper background 
      loadn R6, #mapTotal
      add R6, R3, R6
      loadi R6, R6 ; pix info

      dec R5 ; addr min renderVar
      loadi R4, R5 ; min rendervar
      sub R4, R3, R4 ; coordRender

      outchar R6, R4

    mobMoveRightTestLower:
    ; tests lower part
    ; R5 = addr to min coord render
    ; R3 = past mapcoords of wings
    loadn R5, #renderVar

    loadn R2, #6
    add R2, R2, R0 ; addr to mobcoord
    loadi R3, R2

    loadn R6, #38
    add R3, R3, R6 ; left of left leg
    loadi R4, R5
    cmp R3, R4 ; if equal or greater, test maxCoord
               ; else, do nothing
    jle mobMoveChoiceFinish

    inc R5 ; addr to max rendervar
    loadi R4, R5
    cmp R3, R4 ; if lesser, render background
               ; else, do nothing
    jeg mobMoveChoiceFinish

    ; renders lower part
    dec R5 ; addr to min rendervar
    loadi R4, R5
    loadn R6, #mapTotal
    add R6, R3, R6 ; addr to pix info
    loadi R7, R6 ; pix info

    sub R5, R3, R4 ; coord in render
    outchar R7, R5

    ; next pix to the right
    inc R6
    loadi R7, R6 ; pix info
    inc R5 ; next coord in render
    outchar R7, R5

    jmp mobMoveChoiceFinish
  
  mobMoveLeft:
  ; stores left side
    loadn R1, #9
    add R1, R1, R0 ; addr to side mob
    loadn R2, #0
    storei R1, R2 ; stores 0 to side val (right)

    loadn R2, #6
    add R2, R2, R0 ; addr to mapcoord
    loadi R1, R2
    dec R1 ; 1 pix to the left, mob's head

    ; if (mob's head) mod 40 == 0, do nothing
    loadn R4, #40
    mod R1, R1, R4 ; (mob's head) mod 40

    loadn R4, #0
    cmp R1, R4 ; if == 0, finish
    jeq mobMoveChoiceFinish

    ; update map coord
    call renderSymbolBackground ; unrender symbol chase/alert
    loadi R3, R2
    dec R3 ; -1 mapcoord
    storei R2, R3

    ; restore background
    loadn R5, #renderVar
    loadi R4, R5 ; map coord must equal or  greater than min var render
    
    loadn R2, #6
    add R2, R2, R0 ; addr to mapcoord
    loadi R3, R2
    inc R3
    inc R3 ; coord of where wings were
    
    cmp R3, R4 ; if equal or greater, test maxCoord
               ; else, test lower part
    jle mobMoveLeftTestLower

    inc R5 ; addr to max coord
    loadi R4, R5
    cmp R3, R4 ; if lesser, render background
               ; else, test lower part
    jeg mobMoveLeftTestLower

    ; restores upper background 
    loadn R6, #mapTotal
    add R6, R3, R6
    loadi R6, R6 ; pix info

    dec R5 ; addr min renderVar
    loadi R4, R5 ; min rendervar
    sub R4, R3, R4 ; coordRender

    outchar R6, R4

    mobMoveLeftTestLower:
      ; tests lower part
      loadn R5, #renderVar
      
      loadn R2, #6
      add R2, R2, R0 ; addr to mobcoord
      loadi R3, R2      
      
      loadn R6, #42
      add R3, R3, R6 ; right of right leg
      loadi R4, R5
      cmp R3, R4 ; if equal or greater, test maxCoord
                ; else, do nothing
      jle mobMoveChoiceFinish

      inc R5 ; addr to max rendervar
      loadi R4, R5
      cmp R3, R4 ; if lesser, render background
                ; else, do nothing
      jeg mobMoveChoiceFinish

      ; renders lower part
      loadn R6, #mapTotal
      add R6, R3, R6
      loadi R7, R6 ; pix info
      
      dec R5 ; addr to minrendervar
      loadi R4, R5
      sub R3, R3, R4 ; coordrender
      outchar R7, R3

      ; pix to the left
      dec R6 ; mapTotal index
      loadi R7, R6
      dec R3 ; renderCoord
      outchar R7, R3

      jmp mobMoveChoiceFinish

  mobMoveDown:
    loadn R2, #6
    add R2, R2, R0 ; addr to mapcoord
    loadi R1, R2

    ; if coord > 1639, do nothing
    loadn R4, #1639
    cmp R1, R4
    jgr mobMoveChoiceFinish

    ; update map coord
    call renderSymbolBackground ; unrender symbol chase/alert
    loadi R3, R2
    loadn R4, #40
    add R3, R3, R4; +40 mapcoord
    storei R2, R3

    ; restore background
    loadn R5, #renderVar
    loadi R4, R5 ; map coord must equal or  greater than min var render
    
    loadn R4, #40
    sub R3, R3, R4 ; past mob coord
    
    cmp R3, R4 ; if equal or greater, test maxCoord
               ; else, finish
    jle mobMoveChoiceFinish

    inc R5 ; addr to max coord
    loadi R4, R5
    cmp R3, R4 ; if lesser, render background
               ; else, finish
    jeg mobMoveChoiceFinish

    ; restores upper background 
    loadn R6, #mapTotal
    add R6, R3, R6 ; addr of pix info
    loadi R7, R6 ; pix info

    dec R5 ; addr min renderVar
    loadi R4, R5 ; min rendervar
    sub R4, R3, R4 ; coordRender
    outchar R7, R4

    ; 1 pix left
    dec R6
    loadi R7, R6 ; pix info
    dec R3 ; 1 pix left
    loadi R4, R5 ; min rendervar
    sub R4, R3, R4 ; coord to render
    outchar R7, R4

    ; 1 pix to the right of first
    inc R6
    inc R6 ; addr to pix info
    loadi R7, R6
    inc R3
    inc R3 ; coord in map
    loadi R4, R5 ; min rendervar
    sub R4, R3, R4
    outchar R7, R4

    jmp mobMoveChoiceFinish    

  mobMoveUp:
    loadn R2, #6
    add R2, R2, R0 ; addr to mapcoord
    loadi R1, R2

    ; if coord < 40, do nothing
    loadn R4, #40
    cmp R1, R4
    jle mobMoveChoiceFinish

    ; update map coord
    call renderSymbolBackground ; unrender symbol chase/alert
    loadi R3, R2
    sub R3, R3, R4; -40 mapcoord
    storei R2, R3

    ; test side to restore background
    loadn R4, #3
    add R1, R2, R4 ; addr to side
    loadi R1, R1

    loadn R4, #0
    cmp R1, R4 ; if not equal, restore right
    jne mobMoveUpRestoreRight

    ; test render coords
    loadn R1, #renderVar
    loadi R4, R1 ; min renderVar
    cmp R3, R4 ; must be equal or greater
               ; else, test lower part
    jle mobMoveUpRestoreLeftTestLower

    inc R1
    loadi R4, R1 ; max renderVar
    cmp R3, R4 ; must be lesser
               ; else, test lower part
    jeg mobMoveUpRestoreLeftTestLower

    ; restores upper part side left
    dec R1
    loadi R4, R1 ; min rendervar

    inc R3 ; past coords of wings
    loadn R5, #mapTotal
    add R5, R3, R5 ; addr to pix info
    loadi R6, R5 ; pix info
    sub R7, R3, R4 ; mapcoord - minRenderVar
    outchar R6, R7

    mobMoveUpRestoreLeftTestLower:
      loadn R2, #renderVar
      loadi R1, R2

      loadn R3, #6
      add R3, R3, R0
      loadi R3, R3 ; mob coord
      loadn R4, #80
      add R3, R3, R4 ; past coord of right foot
      cmp R3, R1 ; must be equal pr greater than min coord
                 ; else finish
      jle mobMoveChoiceFinish

      inc R2
      loadi R1, R2 ; max rendervar
      cmp R3, R1 ; must be lesser than max coord
                 ; else, finish
      jeg mobMoveChoiceFinish

      ; renders lower part
      loadn R4, #mapTotal
      add R4, R3, R4 ; addr to pix info
      loadi R5, R4 ; pix info
      dec R2
      loadi R1, R2 ; min rendervar
      sub R3, R3, R1 ; coord to be rendered
      outchar R5, R3

      ; next pix
      dec R3 ; coord to be rendered
      dec R4
      loadi R5, R4 ; pix info
      outchar R5, R3

      jmp mobMoveChoiceFinish

    mobMoveUpRestoreRight:
      ; test render coords
      loadn R1, #renderVar
      loadi R4, R1 ; min renderVar

      loadn R2, #6
      add R2, R2, R0 ; addr to mobcoord
      loadi R3, R2 ; mob coord
      loadn R5, #39
      add R3, R3, R5 ; past coord of wings

      cmp R3, R4 ; must be equal or greater
                 ; else, testlower
      jle mobMoveUpRestoreRightTestLower

      inc R1
      loadi R4, R1 ; max renderVar
      cmp R3, R4 ; must be lesser
                 ; else, testlower
      jeg mobMoveUpRestoreRightTestLower

      ; restores upper part side left
      dec R1
      loadi R4, R1 ; min rendervar

      loadn R5, #mapTotal
      add R5, R3, R5 ; addr to pix info
      loadi R6, R5 ; pix info
      sub R7, R3, R4 ; mapcoord - minRenderVar
      outchar R6, R7

      mobMoveUpRestoreRightTestLower:
        loadn R2, #renderVar
        loadi R1, R2

        loadn R3, #6
        add R3, R3, R0
        loadi R3, R3 ; mob coord
        loadn R4, #80
        add R3, R3, R4 ; past coord of left foot
        cmp R3, R1 ; must be equal or greater than min coord
                   ; else finish
        jle mobMoveChoiceFinish

        inc R2
        loadi R1, R2 ; max rendervar
        cmp R3, R1 ; must be lesser than max coord
                   ; else, finish
        jeg mobMoveChoiceFinish

        ; renders lower part
        loadn R4, #mapTotal
        add R4, R3, R4 ; addr to pix info
        loadi R5, R4 ; pix info
        dec R2
        loadi R1, R2 ; min rendervar
        sub R3, R3, R1 ; coord to be rendered
        outchar R5, R3

        ; next pix
        inc R3 ; coord to be rendered
        inc R4
        loadi R5, R4 ; pix info
        outchar R5, R3

        jmp mobMoveChoiceFinish

  mobMoveChoiceFinish:
    pop R7
    pop R6
    pop R5
    pop R4
    pop R3
    pop R2
    pop R1
    rts

; will use R0 as mob addr
delayMoveMob:
  push R1
  push R4

  loadn R1, #11
  add R1, R1, R0 ; addr to delay mobMove2
  loadi R2, R1 ; delay mobMove2
  loadn R4, #0
  cmp R2, R4 ; check if timer2 = 0
  jne delayMoveMobTimer2Not0

  ; check if timer 1 = 0
  dec R1
  loadi R2, R1 ; delay mobMove1
  cmp R2, R4
  jne delayMoveMobTimer1Not0

  loadn R4, #1 
  storei R1, R4 ; stores 1 in timer 1
  inc R1 ; addr to timer 2
  loadn R4, #65000
  storei R1, R4 ; stores 65000  in timer 2
  loadn R2, #1 ; bool = true

  jmp delayMoveMobFinish

  delayMoveMobTimer1Not0:
    dec R2
    storei R1, R2 ; decrements and stores timer 1

    inc R1 ; addr to timer 2
    loadn R2, #65000
    storei R1, R2 ; restores timer 2
    loadn R2, #0 ; bool = false

    jmp delayMoveMobFinish

  delayMoveMobTimer2Not0:
    dec R2
    storei R1, R2
    loadn R2, #0 ; bool = false

    jmp delayMoveMobFinish

  delayMoveMobFinish:
    pop R4
    pop R1
    rts



; R0 will be used as addr to chosen mob
delayMobAlert:
  push R1
  push R2
  push R3  
  push R4
  
  loadn R1, #14
  add R2, R1, R0 ; addr to timer 2
  loadi R1, R2 ; checks timer 2
  loadn R3, #0
  cmp R1, R3
  jeq delayMobAlertTimer1 ; if equal to 0, check the other timer
                          ; else, decrease timer2 and finish
  dec R1
  storei R2, R1
  jmp delayMobAlertFinish

  delayMobAlertTimer1:
    dec R2 ; addr to timer 1

    loadi R1, R2
    cmp R1, R3 ; if equal to 0, alertBool = 0 and restore timer
               ; else, dec timer1 and restore timer2
    jne delayMobAlertTimer1Dec

    ; if equal to 0
    loadn R4, #50
    storei R2, R4 ; stores 50 to timer1
    inc R2
    loadn R4, #65000
    storei R2, R4 ; stores 65000 to timer2
    loadn R4, #6
    sub R2, R2, R4 ; addr of alertBool
    storei R2, R3 ; stores 0 to alertBool

    ; unrenders inter
    loadn R1, #6
    add R1, R1, R0 ; addr to mobCoord
    loadi R1, R1
    loadn R2, #80
    sub R1, R1, R2 ; coord inMap of inter

    ; getting pixel info on mapTotal
    loadn R2, #mapTotal
    add R2, R1, R2 ; addr of mapTotal pix
    loadi R2, R2 ; pix info
    ; gets coordinRender
    load R3, renderVar
    sub R1, R1, R3 ; coord in Render
    outchar R2, R1

    jmp delayMobAlertFinish

    delayMobAlertTimer1Dec:
      dec R1 ; dec number in timer1
      storei R2, R1
      inc R2 ; addr to timer2
      loadn R1, #65000
      storei R2, R1 ; restore timer 2

  delayMobAlertFinish:
    pop R4
    pop R3
    pop R2
    pop R1
    rts



; R0 will come from another function as address to mob of choice
renderExclaInter:
  push R1
  push R2
  push R3
  push R4
  push R5

  ; check if chase bool active to render excla
  loadn R1, #7
  add R1, R1, R0 ; R1 has addr to chase bool
  loadi R2, R1 ; chase bool
  loadn R3, #1
  cmp R2, R3
  jne renderExclaInterAlertBool ; if not, check alert bool

  ; renders excla
  dec R1 ; addr to coordInMap
  loadi R1, R1
  ; checks if mob not above 3rd line of render so excla/inter can be rendered
  load R2, renderVar ; min var of render
  sub R2, R1, R2 ; coord of mob in render
  loadn R3, #79 ; last coord in 2nd line (1-indexed)
                ; mob coord has to be greater than this
  cmp R2, R3
  jel renderExclaInterFinish

  ; actual rendering
  inc R3 ; subs 2 in y axis (80)
  sub R2, R2, R3 ; coord of excla/inter
  loadn R3, #3134 ; exclamation
  outchar R3, R2
  jmp renderExclaInterFinish

  renderExclaInterAlertBool:
    ; test alert bool
    inc R1 ; addr to alert bool
    loadi R2, R1 ; alert bool
    cmp R2, R3
    jne renderSymbolBackgroundCall ; if == 0, render pixel behid inter/exla

    dec R1
    dec R1 ; addr to coordInMap
    loadi R1, R1
    ; checks if mob not above 3rd line (1-indexed) of render so excla/inter can be rendered
    load R2, renderVar ; min var of render
    sub R2, R1, R2 ; coord of mob in render
    loadn R3, #79 ; last coord in 2nd line (1-indexed)
                  ; mob coord has to be greater than this
    cmp R2, R3
    jel renderExclaInterFinish

    ; actual rendering
    inc R3 ; subs 2 in y axis (80)
    sub R2, R2, R3 ; coord of excla/inter in render
    loadn R3, #3135 ; interogation
    outchar R3, R2

    jmp renderExclaInterFinish
    
    renderSymbolBackgroundCall:
      call renderSymbolBackground
    
  renderExclaInterFinish:
    pop R5
    pop R4
    pop R3
    pop R2
    pop R1
    rts

renderSymbolBackground:
  push R1
  push R2
  push R3
  push R4
  push R5
  push R6

    loadn R1, #6
    add R1, R1, R0 ; addr of map coord
    loadi R2, R1
    
    ; checks if mob not above 3rd line of render so excla/inter can be rendered
    loadn R3, #renderVar
    loadi R4, R3
    sub R4, R2, R4 ; coord of mob in render
    loadn R5, #79 ; last coord in 2nd line (1-indexed)
                  ; mob coord has to be greater than this
    cmp R4, R5
    jel renderSymbolBackgroundFinish

    ; mob map coord must be eq or lower to maxRenderVar + 79
    loadi R2, R1 ; mob map coord
    inc R3 ; addr to max rendervar
    loadi R4, R3 ; max rendervar
    add R4, R4, R5 ; max rendervar + 79
    cmp R2, R4 ; if greater, finish
    jgr renderSymbolBackgroundFinish

    ; actual rendering
    loadn R3, #80 ; subs 2 in y axis (80)
    loadi R1, R1 ; map coord
    sub R5, R1, R3 ; coord of excla/inter in map
    
    ; check map prop
    loadn R4, #mapProp
    add R4, R4, R5 ; addr to coord in mapprop of symbol
    loadi R4, R4 ; mapProp val
    loadn R6, #1

    cmp R4, R6 ; if mapProp = 1, render background
    jeq renderExclaInterBackgroundBackground
    inc R6
    cmp R4, R6 ; if mapProp = 2, render background
    jeq renderExclaInterBackgroundBackground
    loadn R6, #0
    cmp R4, R6 ; if mapProp = 0 
                ; if player in there, render player , else, render back
                ; else, test mapProp 3
    jne renderExclaInterBackgroundTestMapProp3

  ; R1 = mobCoord in map,
  ; R5 = excla/inter coord inMap
    load R3, playerCoordInMap
    cmp R5, R3 ; if symbol in same coord as player, render player
                ; else, test new coord
    jne renderExclaInterBackgroundTestRightFace

    ; if symbol is being tested, then it's already in a valid screen coord
    load R3, playerCoordRender
    loadn R4, #2305
    outchar R4, R3 ; renders player left face
    
    jmp renderSymbolBackgroundFinish

    renderExclaInterBackgroundTestRightFace:
      inc R3
      cmp R5, R3 ; if symbol in same coord as player, render player
                  ; else, test new coord
      jne renderExclaInterBackgroundTestRightLeg

      ; if symbol is being tested, then it's already in a valid screen coord
      load R3, playerCoordRender
      inc R3
      loadn R4, #2306
      outchar R4, R3 ; renders player right face

      jmp renderSymbolBackgroundFinish
    
    renderExclaInterBackgroundTestRightLeg:
      loadn R4, #40
      add R3, R3, R4 ; one down in y axis
      cmp R5, R3 ; if symbol in same coord as player, render player
                  ; else, test new coord
      jne renderExclaInterBackgroundTestLeftLeg

      ; if symbol is being tested, then it's already in a valid screen coord
      load R3, playerCoordRender
      inc R3
      add R3, R3, R4 ; coord to render player
      loadn R4, #771
      outchar R4, R3 ; renders player right leg

      jmp renderSymbolBackgroundFinish

    renderExclaInterBackgroundTestLeftLeg:
      dec R3 ; player left leg in map
      cmp R5, R3 ; if symbol in same coord as player, render player
                  ; else, test new coord
      jne renderExclaInterBackgroundBackground

      ; if symbol is being tested, then it's already in a valid screen coord
      load R3, playerCoordRender
      add R3, R3, R4 ; left leg player in render
      loadn R4, #772
      outchar R4, R3 ; renders player left leg

      jmp renderSymbolBackgroundFinish

    ; R1 = mobCoord in map,
    ; R5 = excla/inter coord inMap
    ; if mapProp in symbol coord = 3 (flower stealth)
    renderExclaInterBackgroundTestMapProp3:
      load R3, playerCoordInMap
      cmp R3, R5 ; if symbol in same coord as player, render player
                  ; else if symbol in same coord as player +1, render player
                  ; else, render background
      jne renderExclaInterBackgroundTestMapProp3RightFace

      ; renders left face
      load R3, playerCoordRender
      loadn R4, #2822
      outchar R4, R3

      jmp renderSymbolBackgroundFinish

    renderExclaInterBackgroundTestMapProp3RightFace:
      inc R3 ; player's right face coord in map
      cmp R3, R5 ; if symbol in same coord as player, render player
                  ; else if symbol in same coord as player +1, render player
                  ; else, render background
      jne renderExclaInterBackgroundBackground

      ; renders right face
      load R3, playerCoordRender
      inc R3 ; coord of right face in render
      loadn R4, #2306
      outchar R4, R3

      jmp renderSymbolBackgroundFinish
    
    ; R1 = mobCoord in map, R2 = mobCoord in render
    ; R5 = excla/inter coord inMap
    renderExclaInterBackgroundBackground:
      loadn R3, #mapTotal
      add R3, R3, R5 ; addr pixel info in map for background
      loadi R3, R3 ; info for pixel
      load R4, renderVar
      sub R4, R5, R4 ; symbol coord in map - min render pixel = symbol coord in render
                      ; R4 = symbol coord in render
      outchar R3, R5
    
  renderSymbolBackgroundFinish:
    pop R6
    pop R5
    pop R4
    pop R3
    pop R2
    pop R1
    rts      


; R0 = addr to mob
; R1 = playerCoordInMap
; measures distance between mob and player,
; if player is at front side of mob and if stealth true or false
; returns chase state
chaseCondition:
  ; checks which side mob is facing  
  loadn R5, #9
  add R5, R5, R0 ; addr to side mob is facing
  loadi R5, R5
  loadn R3, #0
  cmp R5, R3
  jne rightSideChase ; if side == 1 (right side)

  ; sees if player is at right side of mob
  loadn R2, #6
  add R3, R2, R0 ; addr to mobCoord
  loadi R3, R3 ; mob Coord
  loadn R2, #40

  ; finds x axis coord
  mod R3, R3, R2 ; mobCoord mod 40
  mod R4, R1, R2 ; playerCoordMap mod 40

  ; playerCoord mod 40 (x axis) has to be equal or lesser than mobCoord mod 40
  ; leftSideChase
  cmp R4, R3 
  jgr chaseFalse
  jel calculateDistance

  rightSideChase:
    ; sees if player is at right side of mob
    loadn R2, #6
    add R3, R2, R0 ; addr to mobCoord
    loadi R3, R3 ; mob Coord
    loadn R2, #40

    ; finds x axis coord
    mod R3, R3, R2 ; mobCoord mod 40
    mod R4, R1, R2 ; playerCoordMap mod 40
    inc R4

    ; playerCoord mod 40 (x axis) has to be equal or greater than mobCoord mod 40
    cmp R4, R3 
    jle chaseFalse

  calculateDistance:
    ; calculates distance
    loadn R2, #40
    div R3, R1, R2 ; R3 = player.y
    mod R4, R1, R2 ; R4 = player.x
    loadn R5, #6
    add R5, R0, R5 ; addr to mobCoord
    loadi R5, R5
    mod R6, R5, R2 ; R6 = mob.x
    div R5, R5, R2 ; R5 = mob.y

    ; d = max(|x2-x1|, |y2-y1|) + 0.5*min(|x2-x2, |y2-y1|)
    ; test which x is bigger and do subtraction
    cmp R4, R6
    jle mobXgreater

    sub R4, R4, R6
    jmp testYcoord

    mobXgreater:
      sub R4, R6, R4

    ; test which y is bigger and do subtraction
    testYcoord:
      cmp R3, R5
      jle mobYgreater

      sub R3, R3, R5
      jmp testXorYgreater

    mobYgreater:
      sub R3, R5, R3

    ; test which sub ended in a greater result, x or y
    testXorYgreater:
      cmp R4, R3
      loadn R5, #2 ; used for division
      jle distYgreater

      ; divides the smaller by two and adds to the bigger
      div R3, R3, R5
      add R3, R4, R3 ; this is our approximated distance
      jmp checkPlayerStealth
    
    ; divides the smller by two and adds to the bigger
    distYgreater:
      div R4, R4, R5
      add R3, R4, R3 ; this is our approximated distance

    checkPlayerStealth:
    ; if not, distance <= 15
    ; if yes, distance <= 4
    ; R3 has distance
    load R2, playerProp ; stealth prop
    loadn R5, #1
    cmp R2, R5
    jne chaseNotStealth ; if 0, jmp, not stealth

    loadn R2, #4
    cmp R3, R2 ; compares distance to 4
    jgr chaseFalse
    jel chaseTrue

    chaseNotStealth:
      loadn R2, #15
      cmp R3, R2 ; compares distance to 15
      jgr chaseFalse
      jel chaseTrue
  

  chaseFalse:
    loadn R2, #0 ; this is chase bool false
    rts

  chaseTrue:
    call algorithmLineMain ; will check for walls and return bool
    rts

; R0 = addr to mob
; R2 = bool
algorithmLineMain:
  push R1
  push R3
  push R4
  push R5
  push R6
  push R7

  loadn R3, #6
  add R5, R3, R0 ; addr to mobcoord
  loadi R3, R5 ; mob coord
  
  inc R5
  inc R5
  inc R5 ; addr to side
  loadi R4, R5
  loadn R5, #1
  cmp R4, R5
  jeq algorithmLineMainRightSide

  dec R3 ; coord to mob's left head
  jmp algorithmLineMainDecision

  algorithmLineMainRightSide:
    inc R3 ; coord to mob's right head
  
  algorithmLineMainDecision:
    loadn R7, #40
    mod R4, R3, R7 ; mob.x
    div R5, R3, R7 ; mob.y

    load R1, playerCoordInMap
    mod  R6, R1, R7 ; player.x
    div R7, R1, R7 ; player.y

    ; stores values
    store lineAlgorithmMobX, R4 ; stores mob.x
    store lineAlgorithmMobY, R5 ; stores mob.y
    store lineAlgorithmPlayerX, R6 ; stores player.x
    store lineAlgorithmPlayerY, R7 ; stores player.y

    cmp R4, R6 ; if mob.x > player.x
    jel algorithmLineMainDecisionMobLesserX

    cmp R5, R7 ; if mob.y > p.y
    jel algorithmLineMainDecisionMobGreaterXLesserY

    ; first test
    loadn R3, #1 ; to compare with bool
    load R1, playerCoordInMap
    inc R1 ; aiming at player's right face
    call algorithmLine ; will return bool
    cmp R2, R3 ; if equal, finish, else, next call
    jeq algorithmLineMainFinish

    loadn R2, #40
    add R1, R1, R2 ; aiming at player's right leg
    call algorithmLine ; will return bool
    cmp R2, R3 ; if equal, finish, else, next call
    jeq algorithmLineMainFinish

    dec R1 ; aiming at player's left leg
    call algorithmLine ; will return bool
    jmp algorithmLineMainFinish ; last call is done, finish

    algorithmLineMainDecisionMobGreaterXLesserY:
      ; moby has to be lesser than pl.y
      cmp R5, R7 ; if mob.y < p.y
      jeg algorithmLineMainDecisionMobGreaterXEqualY
      
      ; first test
      loadn R3, #1 ; to compare with bool
      load R1, playerCoordInMap ; aiming at player's left face
      call algorithmLine ; will return bool
      cmp R2, R3 ; if equal, finish, else, next call
      jeq algorithmLineMainFinish

      inc R1 ; aiming at player's right face
      call algorithmLine ; will return bool
      cmp R2, R3 ; if equal, finish, else, next call
      jeq algorithmLineMainFinish

      loadn R2, #40
      add R1, R1, R2 ; aiming at player's right leg
      call algorithmLine ; will return bool
      jmp algorithmLineMainFinish ; last call is done, finish

    algorithmLineMainDecisionMobGreaterXEqualY:
      ; first test
      loadn R3, #1 ; to compare with bool
      load R1, playerCoordInMap 
      inc R1 ; aiming at player's right face
      call algorithmLine ; will return bool
      cmp R2, R3 ; if equal, finish, else, next call
      jeq algorithmLineMainFinish

      loadn R2, #40
      add R1, R1, R2 ; aiming at player's right leg
      call algorithmLine ; will return bool
      jmp algorithmLineMainFinish ; last call is done, finish


    algorithmLineMainDecisionMobLesserX:
      ; mob.x has to be lesser than play.x
      cmp R4, R6 ; it has to be lesser, else jmp to next condition
      jeg algorithmLineMainDecisionMobEqualX

      ; test mob.y > play.y
      cmp R5, R7 ; if mob.y > p.y
      jel algorithmLineMainDecisionMobLesserXLesserY

      ; first test
      loadn R3, #1 ; to compare with bool
      load R1, playerCoordInMap ; aiming at player's left face
      call algorithmLine ; will return bool
      cmp R2, R3 ; if equal, finish, else, next call
      jeq algorithmLineMainFinish

      loadn R2, #40
      add R1, R1, R2 ; aiming at player's left leg
      call algorithmLine ; will return bool
      cmp R2, R3 ; if equal, finish, else, next call
      jeq algorithmLineMainFinish

      inc R1 ; aiming at player's right leg
      call algorithmLine ; will return bool
      jmp algorithmLineMainFinish ; last call is done, finish

      algorithmLineMainDecisionMobLesserXLesserY:
        ; moby has to be lesser than pl.y
        cmp R5, R7 ; if mob.y < p.y
        jeg algorithmLineMainDecisionMobLesserXEqualY
        
        ; first test
        loadn R3, #1 ; to compare with bool
        load R1, playerCoordInMap ; aiming at player's left face
        call algorithmLine ; will return bool
        cmp R2, R3 ; if equal, finish, else, next call
        jeq algorithmLineMainFinish

        inc R1 ; aiming at player's right face
        call algorithmLine ; will return bool
        cmp R2, R3 ; if equal, finish, else, next call
        jeq algorithmLineMainFinish

        loadn R2, #39
        add R1, R1, R2 ; aiming at player's left leg
        call algorithmLine ; will return bool
        jmp algorithmLineMainFinish ; last call is done, finish

      algorithmLineMainDecisionMobLesserXEqualY:
        ; first test
        loadn R3, #1 ; to compare with bool
        load R1, playerCoordInMap 
        inc R1 ; aiming at player's right face
        call algorithmLine ; will return bool
        cmp R2, R3 ; if equal, finish, else, next call
        jeq algorithmLineMainFinish

        loadn R2, #40
        add R1, R1, R2 ; aiming at player's right leg
        call algorithmLine ; will return bool
        jmp algorithmLineMainFinish ; last call is done, finish

    
    algorithmLineMainDecisionMobEqualX:
      ; test mob.y > play.y
      cmp R5, R7 ; if mob.y > p.y
      jel algorithmLineMainDecisionMobEqualXLesserY

      ; first test
      loadn R3, #1 ; to compare with bool
      load R1, playerCoordInMap 
      loadn R2, #40
      add R1, R1, R2 ; aiming at player's left leg
      call algorithmLine ; will return bool

      cmp R2, R3 ; if equal, finish, else, next call
      jeq algorithmLineMainFinish

      ; second test
      inc R1 ; player's right leg
      call algorithmLine ; will return bool
      jmp algorithmLineMainFinish ; last call is done, finish

      algorithmLineMainDecisionMobEqualXLesserY:
        ; first test
        loadn R3, #1 ; to compare with bool
        load R1, playerCoordInMap ; aims at player's right face
        call algorithmLine ; will return bool
        cmp R2, R3 ; if equal, finish, else, next call
        jeq algorithmLineMainFinish

        ; second test
        inc R1 ; face leg
        call algorithmLine ; will return bool
        jmp algorithmLineMainFinish ; last call is done, finish

  algorithmLineMainFinish:
    pop R7
    pop R6
    pop R5
    pop R4
    pop R3
    pop R1
    rts


algorithmLine:
  push R1
  push R3
  push R4
  push R5
  push R6
  push R7

  ; we need to find abs(player.x - mob.x) and abs(player.y - mob.y)
  cmp R6, R4 ; R6 = player.x, R4 = mob.x
  jle algorithmLineMobGreaterX

  sub R4, R6, R4 ; abs(player.x - mob.x)
  jmp algorithmLineTestAbsY

  algorithmLineMobGreaterX:
    sub R4, R4, R6 ; abs(player.x - mob.x)

  algorithmLineTestAbsY:
    cmp R7, R5 ; R7 = player.y, R5 = mob.y
    jle algorithmLineMobGreaterY

    sub R5, R7, R5 ; abs(player.y - mob.y)
    cmp R4, R5 ; if difX > difY, horizontal line,
               ; else. vertical
    jgr algorithmLineH
    jel algorithmLineV


  algorithmLineMobGreaterY:
    sub R5, R5, R7 ; abs(player.y - mob.y)
    cmp R4, R5 ; if difX > difY, horizontal line,
               ; else. vertical
    jgr algorithmLineH
    jel algorithmLineV

  algorithmLineH:
    load R4, lineAlgorithmMobX
    load R5, lineAlgorithmMobY
    load R6, lineAlgorithmPlayerX
    load R7, lineAlgorithmPlayerY

    cmp R4, R6 ; if mob.x > player.x, exchange values
    jel algorithmLineHSetup

    ; exchange values
    mov R4, R6 ; mob.x = player.x
    load R6, lineAlgorithmMobX ; player.x = mob.x
    mov R5, R7 ; mob.y = player.y
    load R7, lineAlgorithmMobY ; player.y = mob.y

    algorithmLineHSetup:
      sub R1, R6, R4 ; this is dx
      sub R2, R7, R5 ; this is dy, might be negative

      ; R5 (mob.y), R4 mob.x will still be used, the rest wont
      ; choosing dir
      mov R3, R2
      shiftr0 R3, #15
      loadn R6, #1
      cmp R3, R6 ; if equal dir = -1, else 1
      jne algorithmLineHSetupDirPos

      loadn R3, #65535 ; dir = -1
      jmp algorithmLineHSetupDyMult

      algorithmLineHSetupDirPos:
        loadn R3, #1 ; dir = 1

      algorithmLineHSetupDyMult:
        store lineAlgorithmDir, R3

        mul R2, R2, R3 ; dy *= dir

        loadn R6, #0
        cmp R1, R6 ; if dx not 0, go on 
                   ; else, finish
        jeq algorithmLineHStraight
        
        ; R5 (mob.y will now be y)
        ; p = 2*dy - dx
        mov R6, R2 ; R2 = dy
        loadn R7, #2
        mul R6, R6, R7
        sub R6, R6, R1 ; R6 = p
        store lineAlgorithmP, R6 ; store p
        store lineAlgorithmY, R5 ; store y as mob.y

        ; will use 
        ; R0 = mob addr, R1 = dx, R2 = dy, R4 = mob.x R5 = counter
        loadn R5, #0 ; while < dx+1
        algorithmLineHLoop:
          cmp R5, R1 ; must be eq or le
          jgr algorithmLineBoolTrue

          ; find coord to outchar
          add R6, R4, R5 ; (mob.x + counter)
          load R7, lineAlgorithmY
          loadn R3, #40
          mul R3, R3, R7
          add R3, R3, R6 ; mob.x + counter + 40*y

          ; check mapProp
          loadn R6, #mapProp
          add R3, R3, R6 ; idx to coord in map
          loadi R3, R3
          loadn R6, #1
          cmp R3, R6 ; check if wall
          jeq algorithmLineBoolFalse ; if equal, bool false and finish

          ; will now use
          ; p, R7 = y, dir, R1 = dx, R2 = dy
          ; can be used R3, R6, R7
          load R3, lineAlgorithmP
          shiftr0 R3, #15 ; gets sign bit
          loadn R6, #0
          cmp R6, R3 ; if R5 is 0 (positive num)
          jne algorithmLineHLoopPAdd
          
          ; p = p - 2*dx
          load R6, lineAlgorithmP
          add R7, R1, R1 ; 2*dx
          sub R6, R6, R7 ; p = p -2*dx
          store lineAlgorithmP, R6

          ; y += dir
          ; need to hold R0, R1, R2, R4, R5, R6, R7
          ; R7 restored at the end, we used the R for another thing
          load R3, lineAlgorithmDir
          loadn R7, #1
          cmp R3, R7 ; if not equal it's negative
          jne algorithmLineHLoopDirNeg

          load R3, lineAlgorithmY
          add R7, R3, R7
          store lineAlgorithmY, R7
          jmp algorithmLineHLoopPAdd

          algorithmLineHLoopDirNeg:
            load R3, lineAlgorithmY
            sub R7, R3, R7
            store lineAlgorithmY, R7

          algorithmLineHLoopPAdd:
            load R6, lineAlgorithmP
            add R7, R2, R2 ; R7 = 2*dy dy can be neg
            add R6, R6, R7 ; p = p + 2*dy
            store lineAlgorithmP, R6

            inc R5 ; increments counter
            jmp algorithmLineHLoop

        algorithmLineHStraight:
            ; R5 (mob.y will now be y)
            store lineAlgorithmY, R5 ; store y as mob.y

          ; will use 
          ; R0 = mob addr, R1 = dx, R2 = dy, R4 = mob.x R5 = counter
          loadn R5, #0 ; while < dx+1
          algorithmLineHStraightLoop:
            cmp R5, R1 ; must be eq or le
            jgr algorithmLineBoolTrue

            ; find coord to outchar
            add R6, R4, R5 ; (mob.x + counter)
            load R7, lineAlgorithmY
            loadn R3, #40
            mul R3, R3, R7
            add R3, R3, R6 ; mob.x + counter + 40*y

            ; check mapProp
            loadn R6, #mapProp
            add R3, R3, R6 ; idx to coord in map
            loadi R3, R3
            loadn R6, #1
            cmp R3, R6 ; check if wall
            jeq algorithmLineBoolFalse ; if equal, bool false and finish

            inc R5 ; increments counter
            jmp algorithmLineHStraightLoop


    algorithmLineBoolFalse:
      loadn R2, #0
      jmp algorithmLineFinish

    algorithmLineBoolTrue:
      loadn R2, #1
      jmp algorithmLineFinish

    algorithmLineV:
      load R4, lineAlgorithmMobX
      load R5, lineAlgorithmMobY
      load R6, lineAlgorithmPlayerX
      load R7, lineAlgorithmPlayerY

      cmp R5, R7 ; if mob.y > player.y, exchange values
      jel algorithmLineVSetup

      ; exchange values
      mov R4, R6 ; mob.x = player.x
      load R6, lineAlgorithmMobX ; player.x = mob.x
      mov R5, R7 ; mob.y = player.y
      load R7, lineAlgorithmMobY ; player.y = mob.y
      store lineAlgorithmMobX, R4
      store lineAlgorithmMobY, R5
      store lineAlgorithmPlayerX, R6
      store lineAlgorithmPlayerY, R7

      algorithmLineVSetup:
        sub R1, R6, R4 ; this is dx
        sub R2, R7, R5 ; this is dy, might be negative

        ; R5 (mob.y), R4 mob.x will still be used, the rest wont
        ; choosing dir
        mov R3, R1
        shiftr0 R3, #15
        loadn R6, #1
        cmp R3, R6 ; if equal dir = -1, else 1
        jne algorithmLineVSetupDirPos

        loadn R3, #65535 ; dir = -1
        jmp algorithmLineVSetupDyMult

        algorithmLineVSetupDirPos:
          loadn R3, #1 ; dir = 1

        algorithmLineVSetupDyMult:
          store lineAlgorithmDir, R3

          mul R1, R1, R3 ; dx *= dir

          loadn R6, #0
          cmp R1, R6 ; if dy not 0, go on 
                    ; else, finish
          jeq algorithmLineVStraight
          
          ; R4 (mob.x will now be x)
          ; p = 2*dx - dy
          mov R6, R1 ; R1 = dx
          loadn R7, #2
          mul R6, R6, R7
          sub R6, R6, R2 ; R6 = p
          store lineAlgorithmP, R6 ; store p
          store lineAlgorithmX, R4 ; store x as mob.x

          ; will use 
          ; R0 = mob addr, R1 = dx, R2 = dy, R4 = mob.y R5 = counter
          load R4, lineAlgorithmMobY
          loadn R5, #0 ; while < dy+1
          algorithmLineVLoop:
            cmp R5, R2 ; must be eq or le
            jgr algorithmLineBoolTrue

            ; find coord 
            add R6, R4, R5 ; (mob.y + counter)
            loadn R3, #40
            mul R3, R3, R6 ; (mob.y + counter)*40
            load R7, lineAlgorithmX
            add R3, R7, R3 ; (mob.y + counter)*40 + x

            ; check mapProp
            loadn R6, #mapProp
            add R3, R3, R6 ; idx to coord in map
            loadi R3, R3
            loadn R6, #1
            cmp R3, R6 ; check if wall
            jeq algorithmLineBoolFalse ; if equal, bool false and finish

            ; will now use
            ; p, R7 = x, dir, R1 = dx, R2 = dy
            ; can be used R3, R6, R7
            load R3, lineAlgorithmP
            shiftr0 R3, #15 ; gets sign bit
            loadn R6, #0
            cmp R6, R3 ; if R5 is 0 (positive num)
            jne algorithmLineVLoopPAdd

            ; p = p - 2*dy
            load R6, lineAlgorithmP
            add R7, R2, R2 ; 2*dy
            sub R6, R6, R7 ; p = p -2*dy
            store lineAlgorithmP, R6

            ; x += dir
            ; need to hold R0, R1, R2, R4, R5, R6, R7
            ; R7 restored at the end, we used the R for another thing
            load R3, lineAlgorithmDir
            loadn R7, #1
            cmp R3, R7 ; if not equal it's negative
            jne algorithmLineVLoopDirNeg

            load R3, lineAlgorithmX
            add R7, R3, R7
            store lineAlgorithmX, R7
            jmp algorithmLineVLoopPAdd

            algorithmLineVLoopDirNeg:
              load R3, lineAlgorithmX
              sub R7, R3, R7
              store lineAlgorithmX, R7

            algorithmLineVLoopPAdd:
              load R6, lineAlgorithmP
              add R7, R1, R1 ; R7 = 2*dx, dx can be neg
              add R6, R6, R7 ; p = p + 2*dx
              store lineAlgorithmP, R6

              inc R5 ; increments counter
              jmp algorithmLineVLoop

          algorithmLineVStraight:
          ; R4 (mob.x will now be x)
          store lineAlgorithmX, R4 ; store x as mob.x

          ; will use 
          ; R0 = mob addr, R1 = dx, R2 = dy, R4 = mob.y R5 = counter
          load R4, lineAlgorithmMobY
          loadn R5, #0 ; while < dy+1
          algorithmLineVStraightLoop:
            cmp R5, R2 ; must be eq or le
            jgr algorithmLineBoolTrue

            ; find coord 
            add R6, R4, R5 ; (mob.y + counter)
            loadn R3, #40
            mul R3, R3, R6 ; (mob.y + counter)*40
            load R7, lineAlgorithmX
            add R3, R7, R3 ; (mob.y + counter)*40 + x
      
            ; check mapProp
            loadn R6, #mapProp
            add R3, R3, R6 ; idx to coord in map
            loadi R3, R3
            loadn R6, #1
            cmp R3, R6 ; check if wall
            jeq algorithmLineBoolFalse ; if equal, bool false and finish

            inc R5 ; increments counter
            jmp algorithmLineVStraightLoop



    algorithmLineFinish:
      pop R7
      pop R6
      pop R5
      pop R4
      pop R3
      pop R1
      rts



DelayMove:
  push R0
  push R1

  ; dec R0, if R0 is 0 -> dec R1 and restore R0 -> counter ends when R1 is 0, then restarts
  load R0, delayPlayerMove2 
  loadn R1, #0
  cmp R0, R1
  jne decDelay2
  
  load R0, delayPlayerMove1
  cmp R0, R1
  jne decDelay1
  
  call playerMove ; if both are 0, call playerMove and restore counter
                  ; if playerMove succeds, delay will be restored
  jmp finishDelayMove
  
  decDelay1:
    dec R0
    store delayPlayerMove1, R0
    
    loadn R0, #65000
    store delayPlayerMove2, R0
    
    jmp finishDelayMove

  decDelay2:
    dec R0
    store delayPlayerMove2, R0

  
  finishDelayMove:
    pop R1
    pop R0
    rts

restoreDelay:
  push R0
  push R1

  ; must be stored only if playerMove succeded
  loadn R1, #1
  loadn R0, #65000
  store delayPlayerMove2,  R0
  store delayPlayerMove1, R1

  pop R1
  pop R0
  rts

playerMove:
  push R0
  push R1
  push R2
  push R3
  push R4

  ; check if stealth is active
  call checkStealth

  inchar R0
  loadn R1, #'w'
  cmp R0, R1
  jeq playerMoveUp

  loadn R1, #'s'
  cmp R0, R1
  jeq playerMoveDown

  loadn R1, #'a'
  cmp R0, R1
  jeq playerMoveLeft

  loadn R1, #'d'
  cmp R0, R1
  jeq playerMoveRight

  jmp playerMoveFinish

  playerMoveRight:
    load R0, playerCoordInMap
    inc R0
    inc R0
    loadn R3, #40; if (playerCoord + 2) mod 40 != 0, do nothing
    mod R2, R0, R3
    jz playerMoveFinish

    ; check if there is wall
    mov R1, R0 ; R0 to the right of right face
    add R1, R1, R3 ; 1 pixel to the right of right leg
    loadn R2, #mapProp
    add R0, R0, R2
    add R1, R1, R2
    loadi R0, R0 ; takes info from mapProp
    loadi R1, R1
    loadn R3, #1
    cmp R0, R3
    jeq playerMoveFinish
    cmp R1, R3
    jeq playerMoveFinish

    ; render pixels under player's left side
    load R0, playerCoordInMap ; index of pixel in mapTotal upper left of character
    loadn R4, #40
    add R1, R0, R4 ; index of pixel in mapTotal lower right of character

    loadn R4, #mapTotal
    add R0, R0, R4 ; first pixel info addr
    add R1, R1, R4 ; second pixel info addr
    loadi R0, R0
    loadi R1, R1

    load R2, playerCoordRender ; first screen coord
    loadn R4, #40
    add R3, R2, R4 ; second screen coord

    outchar R0, R2
    outchar R1, R3

    ; increment plyaerCoordInMap and InRender
    load R0, playerCoordInMap
    load R1, playerCoordRender
    inc R0
    inc R1
    store playerCoordInMap, R0
    store playerCoordRender, R1

    call renderPlayer
    call restoreDelay

    jmp playerMoveFinish


  playerMoveLeft:
    load R0, playerCoordInMap
    loadn R3, #40; if playerCoord mod 40 != 0, do nothing
    mod R2, R0, R3
    jz playerMoveFinish

    ; check if there is wall
    dec R0 ; 1 pix to the left of left face
    mov R1, R0
    add R1, R1, R3 ; 1 pixel to the left of left leg
    loadn R2, #mapProp
    add R0, R0, R2
    add R1, R1, R2
    loadi R0, R0 ; takes info from mapProp
    loadi R1, R1
    loadn R3, #1
    cmp R0, R3
    jeq playerMoveFinish
    cmp R1, R3
    jeq playerMoveFinish

    ; render pixels under player's right side
    load R0, playerCoordInMap
    inc R0   ; index of pixel in mapTotal upper right of character
    loadn R4, #40
    add R1, R0, R4 ; index of pixel in mapTotal lower right of character

    loadn R4, #mapTotal
    add R0, R0, R4 ; first pixel info addr
    add R1, R1, R4 ; second pixel info addr
    loadi R0, R0
    loadi R1, R1

    load R2, playerCoordRender
    inc R2         ; first screen coord
    loadn R4, #40
    add R3, R2, R4 ; second screen coord

    outchar R0, R2
    outchar R1, R3

    ; decrement plyaerCoordInMap and InRender
    load R0, playerCoordInMap
    load R1, playerCoordRender
    dec R0
    dec R1
    store playerCoordInMap, R0
    store playerCoordRender, R1

    call renderPlayer
    call restoreDelay

    jmp playerMoveFinish


  playerMoveDown:
    load R0, playerCoordInMap
    ; if playerCoordInMap greater than 1600 (first pixel of penultimate line), can't go down, limit of map reached
    loadn R1, #1600
    cmp R0, R1
    ; if greater or equal, it's above the last line of the map,
    jeg playerMoveFinish ; if lesser, finish routine

    ; check if there is wall
    loadn R2, #80
    add R0, R0, R2 ; under left foot (index)
    mov R1, R0 ; 
    inc R1 ; under right foot (index)
    loadn R2, #mapProp
    add R0, R0, R2
    add R1, R1, R2
    loadi R0, R0 ; takes info from mapProp
    loadi R1, R1
    loadn R3, #1
    cmp R0, R3
    jeq playerMoveFinish
    cmp R1, R3
    jeq playerMoveFinish

    ; condition here to ask if it should go to map slide
    load R2, playerCoordRender
    loadn R3, #959    ; will slide down if player in screen coord greater than 920 (greater than 6th line bottom to top) AND mapCoord NOT greater than 1439
    cmp R2, R3                                                               ; (1199) - 240                                              (1679) - 240
    jel slideDownFalse
    load R2, playerCoordInMap ; check if playerCoordInMap NOT greater than 1439
    loadn R3, #1439
    cmp R2, R3
    cel slideDown
    jel slideDownTrue

    slideDownFalse:
      ; if slide has not happened, pixels behind player's face must be saved to be rendered after it moves
      load R0, playerCoordRender ; player left face, first index of screen
      loadn R4, #1
      add R1, R0, R4 ; player right face, second index of screen

      load R2, playerCoordInMap ; player left face, first index of mapTotal
      add R3, R2, R4 ; player right face, seonc index of mapTotal

      ; renders map pixels on player's face
      loadn R4, #mapTotal
      add R2, R2, R4 ; addr of first pixel type/color on mapTotal
      loadi R2, R2
      add R3, R3, R4
      loadi R3, R3 ; addr of first pixel type/color on mapTotal

      outchar R2, R0
      outchar R3, R1
      
      ; increments player coords in render by 40
      load R0, playerCoordRender
      loadn R1, #40
      add R0, R0, R1
      store playerCoordRender, R0

      ; increments player coords in map by 40
      load R0, playerCoordInMap
      add R0, R0, R1
      store playerCoordInMap, R0

      call renderPlayer
      call restoreDelay
      jmp playerMoveFinish
    
    slideDownTrue:
      ; increments player coords in map by 40
      load R0, playerCoordInMap
      loadn R1, #40
      add R0, R0, R1
      store playerCoordInMap, R0
      
      call renderPlayer
      call restoreDelay
      jmp playerMoveFinish


  playerMoveUp:  
    load R0, playerCoordInMap
    ; if playerCoordInMap below 40 (1st line 0 indexed), can't go upper, limit of map reached
    loadn R1, #40
    cmp R0, R1
    ; if greater or equal, it's below the first line of the map,
    jle playerMoveFinish ; if lesser, finish routine

    ; check if there is wall
    sub R0, R0, R1 ; above right face 
    mov R1, R0 
    inc R1 ; above left face
    loadn R2, #mapProp
    add R0, R0, R2
    add R1, R1, R2
    loadi R0, R0 ; takes info from mapProp
    loadi R1, R1
    loadn R3, #1
    cmp R0, R3
    jeq playerMoveFinish
    cmp R1, R3
    jeq playerMoveFinish

    ; condition here to ask if it should go to map slide
    load R2, playerCoordRender
    loadn R3, #240    ; will slide up if player in screen coord below 240 (above 6th line) AND NOT below mapCoord 240
    cmp R2, R3
    jeg slideUpFalse
    load R2, playerCoordInMap ; check if playerCoordInMap below 240
    cmp R2, R3
    ceg slideUp
    jeg slideUpTrue

    slideUpFalse:
      ; if slide has not happened, pixels behind player's feet must be saved to be rendered after it moves
      load R0, playerCoordRender
      loadn R4, #40
      add R0, R0, R4 ; player left feet, first index of screen
      mov R1, R0
      inc R1 ; player right feet, second index of screen

      load R2, playerCoordInMap
      add R2, R2, R4 ; player left feet, first index of mapTotal
      mov R3, R2
      inc R3 ; player right feet, second index of mapTotal

      ; renders map pixels under player's feet
      loadn R4, #mapTotal
      add R2, R2, R4 ; addr of first pixel type/color on mapTotal
      loadi R2, R2
      add R3, R3, R4
      loadi R3, R3 ; addr of second pixel type/color on mapTotal

      outchar R2, R0
      outchar R3, R1
      
      ; decrements player coords in render by 40
      load R0, playerCoordRender
      loadn R1, #40
      sub R0, R0, R1
      store playerCoordRender, R0

      ; decrements player coords in map by 40
      load R0, playerCoordInMap
      sub R0, R0, R1
      store playerCoordInMap, R0

      call renderPlayer
      call restoreDelay
      jmp playerMoveFinish
    
    slideUpTrue:
      ; decrements player coords in map by 40
      load R0, playerCoordInMap
      loadn R1, #40
      sub R0, R0, R1
      store playerCoordInMap, R0
      
      call renderPlayer
      call restoreDelay
      jmp playerMoveFinish



playerMoveFinish:
  pop R4
  pop R3
  pop R2
  pop R1
  pop R0
  rts

renderPlayer:
  push R0
  push R1
  push R2
  push R3
  push R4
  push R5
  push R6
  push R7
  
  loadn R7, #0 ; will be used to check stealth squares
  store playerProp, R7 ; restarts stealth

  ; skins are 2305 - 2306
  ;           771  - 772
  ; fixing values for rendering
  load R0, playerCoordRender ; R0 = mem(playerCoordRender)
  loadn R1, #2305

  ; check if it's in stealth coord left face
  load R4, playerCoordInMap
  loadn R5, #mapProp
  add R4, R4, R5 ; R4 has mem addr of cur mapProp
  loadi R5, R4 ; puts coord prop num in R5
  loadn R6, #2
  cmp R5, R6
  jne renderLeftFace
  
  inc R7  ; holds amount of stealth squares excluding flower stealth, 
          ; if it reaches 2, plant is in stealth mode
  jmp checkRightFaceStealth ; left face should not render

    renderLeftFace:
      outchar R1, R0

  checkRightFaceStealth:
    ; fixing values for rendering
    loadn R2, #1
    add R0, R0, R2 ; next coord to the right
    add R1, R1, R2 ; next skin

    ; checks if right face is in stealth coord
    add R4, R4, R2 ; R4 has mem addr of cur mapProp
    loadi R5, R4
    cmp R5, R6
    jne renderRightFace
    
    inc R7 ; holds amount of stealth squares excluding flower stealth, 
          ; if it reaches 2, plant is in stealth mode
    jmp checkRightLegStealth ; should not render right face

    renderRightFace:
      outchar R1, R0
  
  checkRightLegStealth:
    ; fixing values for rendering
    loadn R3, #40
    add R0, R0, R3 ; one coord down
    loadn R1, #772 ; lower right skin

    ; checks if right leg is in stealth coord
    add R4, R4, R3 ; R4 has mem addr of cur mapProp
    loadi R5, R4

    loadn R6, #3 ; check if it's flower stealth
    cmp R5, R6
    jne checkRightLegStealth_2 ; if not, checks if it's normal stealth

    store playerProp, R2 ; stores 1
    call renderBackRightLeg ; renders scenario at cord

    jmp checkLeftLegStealth

    checkRightLegStealth_2:
      loadn R6, #2
      cmp R5, R6 ; checks if it's 2
      jne renderRightLeg
      
      inc R7 ; holds amount of stealth squares excluding flower stealth, 
            ; if it reaches 2, plant is in stealth mode
      jmp checkLeftLegStealth ; should not render right leg

      renderRightLeg:
        outchar R1, R0

  checkLeftLegStealth:
    ; checks if left leg is in stealth coord
    sub R4, R4, R2 ; R4 has mem addr of cur mapProp
    loadi R5, R4

    ; checks flower stealth
    loadn R6, #3
    cmp R5, R6 ; checks if it's 3
    jne checkLeftLegStealth_2 ; if not, checks if it's normal stealth

    store playerProp, R2 ; stores 1
    call renderBackLeftLeg ; renders scenario at cord

    jmp finishRenderPlayer

    checkLeftLegStealth_2:
      loadn R6, #2
      cmp R5, R6 ; checks if it's 2
      jne renderLeftLeg
      
      inc R7 ; holds amount of stealth squares excluding flower stealth, 
            ; if it reaches 2, plant is in stealth mode
      jmp activateStealth ; should not render right leg

      renderLeftLeg:
        sub R0, R0, R2 ; one coord left
        sub R1, R1, R2 ; next skin
        outchar R1, R0

  activateStealth:
    cmp R7, R6 ; if stealthCounter >= 2 : activate stealth
    jle finishRenderPlayer
    store playerProp, R2 ; stores 1

  finishRenderPlayer:
    pop R7
    pop R6
    pop R5
    pop R4
    pop R3
    pop R2
    pop R1
    pop R0
    rts


; renders pix in the backround of left leg
renderBackLeftLeg:
  push R0
  push R1
  push R2

  loadn R0, #mapTotal
  load R1, playerCoordInMap
  loadn R2, #40
  add R0, R0, R1
  add R0, R0, R2
  loadi R0, R0
  
  load R1, playerCoordRender
  add R1, R1, R2

  outchar R0, R1

  pop R2
  pop R1
  pop R0
  rts


; renders pix in the backround of right leg
renderBackRightLeg:
  push R0
  push R1
  push R2

  loadn R0, #mapTotal
  load R1, playerCoordInMap
  loadn R2, #41
  add R0, R0, R1
  add R0, R0, R2
  loadi R0, R0
  
  load R1, playerCoordRender
  add R1, R1, R2

  outchar R0, R1

  pop R2
  pop R1
  pop R0
  rts

render:
  push R0
  push R1
  push R2
  push R3
  push R4

  loadn R0, #mapTotal ; R0 = base addr map
  load R1, renderVar   ; R1 = min coord to be rendered, is incremented until max coord
  loadn R2, #renderVar ; R2 = addr to max coord number to be rendered
  inc R2
  loadi R2, R2         ; R2 = mem(R2)
  loadn R4, #0         ; R4 = pix position on screen

  renderLoop:

    add R3,R0,R1
    loadi R3, R3
    outchar R3, R4 
    inc R4 ; pixel position on screen
    inc R1 ; map coordinate to be rendered
    cmp R1, R2 ; R2 = map coordinate limit

    jne renderLoop

  pop R4
  pop R3
  pop R2
  pop R1
  pop R0
  rts


slideUp:
  push R1
  push R2
  push R3
  push FR

  loadn R1, #renderVar  ; R0 = key; R1 = end: (renderdvar); R2 = mem(rendervar)
  loadi R2, R1          ; there is a filter if it reaches limit
  loadn R3, #0
  cmp R3, R2
  jne renderAbove    ; if not in pixel limit jump next step, else return
  jmp slideFinish

  renderAbove:
    loadn R3, #40
    sub R2, R2, R3       ; adds to max pixel rendering
    storei R1, R2
    
    inc R1                ; subs to min pixel rendering
    loadi R2, R1
    sub R2, R2, R3
    storei R1, R2

    call render
    jmp slideFinish
  
    
slideDown:
  push R1
  push R2
  push R3
  push FR

  loadn R1, #renderVar  
  inc R1 ; addr of max coord limit for screen rendering
  loadi R2, R1 ; finds current max coord limit for screen rendering

  loadn R3, #1680 ; if it doesn't work, sub to 1679
  cmp R2, R3
  jne renderBelow    ; if not in pixel limit jump next step, else return
  jmp slideFinish

  renderBelow:
    loadn R3, #40
    add R2, R2, R3  ; adds 40 to max pixel rendering
    storei R1, R2
    
    dec R1  ; addr to min pixel rendering
    loadi R2, R1 ; puts into R2 min coord to be rendered
    add R2, R2, R3 ; adds 40 to it and store
    storei R1, R2

    call render
    jmp slideFinish
  
  slideFinish:
    pop FR
    pop R3
    pop R2
    pop R1
    rts
  
; to test if it activates, delete later
checkStealth:
  push R0
  push R1
  
  load R0, playerProp
  loadn R1, #1
  cmp R0, R1
  jne restoreStealthPixel

  loadn R1, #3391
  loadn R0, #0
  outchar R1, R0
  jmp checkStealthFinish

  restoreStealthPixel:
    load R1, renderVar
    loadn R2, #mapTotal
    add R1, R1, R2
    loadi R1, R1
    outchar R1, R0

  checkStealthFinish:
    pop R1
    pop R0
    rts


playerProp: var #1
  static playerProp, #0 ; stealth

playerCoordRender: var #1
  static playerCoordRender, #750

playerCoordInMap: var #1
  static playerCoordInMap, #750

delayPlayerMove1: var #1
  static delayPlayerMove1, #0
  
delayPlayerMove2: var #1
  static delayPlayerMove2, #0


; player skins
skinPlayerFrontStop: var #4
  static skinPlayerFrontStop + #0, #2305 ; left face
  static skinPlayerFrontStop + #1, #2306 ; right face
  static skinPlayerFrontStop + #2, #771 ; right leg
  static skinPlayerFrontStop + #3, #772 ; left leg

; mob inverted 
; left face : 2826
; right face: 2827
; right leg: 2828
; left leg: 2829
; wings: 2062


mob1: var #16
  static mob1 + #0, #0 ; if it's active or not
  static mob1 + #1, #2822 ; left face skin
  static mob1 + #2, #2823 ; right face skin
  static mob1 + #3, #2825 ; left leg skin
  static mob1 + #4, #2824 ; right leg skin
  static mob1 + #5, #2053 ; wings
  static mob1 + #6, #0 ; mobCoordInMap; coord in render will be calculated
  static mob1 + #7, #0 ; chase bool
  static mob1 + #8, #0 ; alert bool
  static mob1 + #9, #1 ; side that mob is looking at, 0 for left, 1 for right
  static mob1 + #10, #1 ; delay mobMove1 
  static mob1 + #11, #65000 ; delay mobMove2
  static mob1 + #12, #0 ; number of script
  static mob1 + #13, #50 ; alertTimer 1
  static mob1 + #14, #65000 ; alertTimer 2
  static mob1 + #15, #0 ; last movememt, vertical or horizontal


; starts at 841
script1: var #6
  static script1 + #0, #0 ; phase number
  static script1 + #1, #877
  static script1 + #2, #'r' ; right
  static script1 + #3, #841
  static script1 + #4, #'l' ; left
  static script1 + #5, #0


curLevel: var #1
  static curLevel, #1

; for slide of begginning of level
slideCounter: var #2
  static slideCounter + #0, #20000
  static slideCounter + #1, #65000


lineAlgorithmMobX: var #1
  static lineAlgorithmMobX, #0 ; mob.x

lineAlgorithmMobY: var #1
  static lineAlgorithmMobY, #0 ; mob.y
  
lineAlgorithmPlayerX: var #1
  static lineAlgorithmPlayerX, #0 ; player.x
  
lineAlgorithmPlayerY: var #1
  static lineAlgorithmPlayerY, #0 ; player.y

lineAlgorithmDx: var #1
  static lineAlgorithmDx, #0 ; dx
  
lineAlgorithmDy: var #1
  static lineAlgorithmDy, #0 ; dy

lineAlgorithmDir: var #1
  static lineAlgorithmDir, #0 ; dir
  
lineAlgorithmX: var #1
  static lineAlgorithmX, #0 ; x

lineAlgorithmY: var #1
  static lineAlgorithmY, #0 ; y

lineAlgorithmP: var #1
  static lineAlgorithmP, #0 ; p


; stores min and max coord to be rendered
renderVar: var #2
  static renderVar + #0, #0     ; first coord rendered
  static renderVar + #1, #1200  ; can't reach this number


; determines properties of each coord of map
; 0 = no prop; 1 = wall; 2 = hide; 3 = flower hide
mapProp : var #1680

  ;Linha 0
  static mapProp + #0, #1
  static mapProp + #1, #0
  static mapProp + #2, #0
  static mapProp + #3, #0
  static mapProp + #4, #0
  static mapProp + #5, #0
  static mapProp + #6, #0
  static mapProp + #7, #0
  static mapProp + #8, #0
  static mapProp + #9, #0
  static mapProp + #10, #0
  static mapProp + #11, #2
  static mapProp + #12, #2
  static mapProp + #13, #2
  static mapProp + #14, #2
  static mapProp + #15, #2
  static mapProp + #16, #0
  static mapProp + #17, #3
  static mapProp + #18, #3
  static mapProp + #19, #3
  static mapProp + #20, #0
  static mapProp + #21, #3
  static mapProp + #22, #3
  static mapProp + #23, #3
  static mapProp + #24, #3
  static mapProp + #25, #3
  static mapProp + #26, #0
  static mapProp + #27, #0
  static mapProp + #28, #0
  static mapProp + #29, #0
  static mapProp + #30, #0
  static mapProp + #31, #0
  static mapProp + #32, #0
  static mapProp + #33, #0
  static mapProp + #34, #0
  static mapProp + #35, #0
  static mapProp + #36, #1
  static mapProp + #37, #1
  static mapProp + #38, #1
  static mapProp + #39, #1

  ;Linha 1
  static mapProp + #40, #0
  static mapProp + #41, #0
  static mapProp + #42, #0
  static mapProp + #43, #0
  static mapProp + #44, #0
  static mapProp + #45, #0
  static mapProp + #46, #0
  static mapProp + #47, #0
  static mapProp + #48, #0
  static mapProp + #49, #0
  static mapProp + #50, #2
  static mapProp + #51, #2
  static mapProp + #52, #2
  static mapProp + #53, #2
  static mapProp + #54, #2
  static mapProp + #55, #2
  static mapProp + #56, #2
  static mapProp + #57, #0
  static mapProp + #58, #3
  static mapProp + #59, #3
  static mapProp + #60, #3
  static mapProp + #61, #3
  static mapProp + #62, #3
  static mapProp + #63, #3
  static mapProp + #64, #3
  static mapProp + #65, #3
  static mapProp + #66, #3
  static mapProp + #67, #0
  static mapProp + #68, #0
  static mapProp + #69, #0
  static mapProp + #70, #2
  static mapProp + #71, #2
  static mapProp + #72, #0
  static mapProp + #73, #0
  static mapProp + #74, #0
  static mapProp + #75, #0
  static mapProp + #76, #0
  static mapProp + #77, #1
  static mapProp + #78, #1
  static mapProp + #79, #1

  ;Linha 2
  static mapProp + #80, #0
  static mapProp + #81, #0
  static mapProp + #82, #0
  static mapProp + #83, #0
  static mapProp + #84, #0
  static mapProp + #85, #0
  static mapProp + #86, #0
  static mapProp + #87, #0
  static mapProp + #88, #0
  static mapProp + #89, #2
  static mapProp + #90, #2
  static mapProp + #91, #2
  static mapProp + #92, #2
  static mapProp + #93, #2
  static mapProp + #94, #2
  static mapProp + #95, #2
  static mapProp + #96, #2
  static mapProp + #97, #2
  static mapProp + #98, #0
  static mapProp + #99, #3
  static mapProp + #100, #3
  static mapProp + #101, #3
  static mapProp + #102, #3
  static mapProp + #103, #3
  static mapProp + #104, #3
  static mapProp + #105, #3
  static mapProp + #106, #0
  static mapProp + #107, #0
  static mapProp + #108, #0
  static mapProp + #109, #2
  static mapProp + #110, #2
  static mapProp + #111, #2
  static mapProp + #112, #2
  static mapProp + #113, #0
  static mapProp + #114, #0
  static mapProp + #115, #0
  static mapProp + #116, #0
  static mapProp + #117, #0
  static mapProp + #118, #1
  static mapProp + #119, #1

  ;Linha 3
  static mapProp + #120, #0
  static mapProp + #121, #0
  static mapProp + #122, #0
  static mapProp + #123, #0
  static mapProp + #124, #0
  static mapProp + #125, #0
  static mapProp + #126, #0
  static mapProp + #127, #0
  static mapProp + #128, #0
  static mapProp + #129, #0
  static mapProp + #130, #2
  static mapProp + #131, #2
  static mapProp + #132, #2
  static mapProp + #133, #2
  static mapProp + #134, #2
  static mapProp + #135, #2
  static mapProp + #136, #2
  static mapProp + #137, #0
  static mapProp + #138, #3
  static mapProp + #139, #3
  static mapProp + #140, #3
  static mapProp + #141, #3
  static mapProp + #142, #3
  static mapProp + #143, #3
  static mapProp + #144, #3
  static mapProp + #145, #0
  static mapProp + #146, #0
  static mapProp + #147, #0
  static mapProp + #148, #2
  static mapProp + #149, #2
  static mapProp + #150, #2
  static mapProp + #151, #2
  static mapProp + #152, #2
  static mapProp + #153, #2
  static mapProp + #154, #0
  static mapProp + #155, #0
  static mapProp + #156, #0
  static mapProp + #157, #0
  static mapProp + #158, #0
  static mapProp + #159, #0

  ;Linha 4
  static mapProp + #160, #0
  static mapProp + #161, #0
  static mapProp + #162, #0
  static mapProp + #163, #0
  static mapProp + #164, #0
  static mapProp + #165, #0
  static mapProp + #166, #0
  static mapProp + #167, #0
  static mapProp + #168, #0
  static mapProp + #169, #0
  static mapProp + #170, #0
  static mapProp + #171, #2
  static mapProp + #172, #2
  static mapProp + #173, #2
  static mapProp + #174, #2
  static mapProp + #175, #2
  static mapProp + #176, #0
  static mapProp + #177, #0
  static mapProp + #178, #0
  static mapProp + #179, #3
  static mapProp + #180, #3
  static mapProp + #181, #0
  static mapProp + #182, #0
  static mapProp + #183, #0
  static mapProp + #184, #0
  static mapProp + #185, #0
  static mapProp + #186, #0
  static mapProp + #187, #0
  static mapProp + #188, #2
  static mapProp + #189, #2
  static mapProp + #190, #2
  static mapProp + #191, #2
  static mapProp + #192, #2
  static mapProp + #193, #2
  static mapProp + #194, #0
  static mapProp + #195, #0
  static mapProp + #196, #0
  static mapProp + #197, #0
  static mapProp + #198, #0
  static mapProp + #199, #0

  ;Linha 5
  static mapProp + #200, #0
  static mapProp + #201, #0
  static mapProp + #202, #0
  static mapProp + #203, #0
  static mapProp + #204, #0
  static mapProp + #205, #0
  static mapProp + #206, #0
  static mapProp + #207, #0
  static mapProp + #208, #0
  static mapProp + #209, #0
  static mapProp + #210, #0
  static mapProp + #211, #0
  static mapProp + #212, #2
  static mapProp + #213, #2
  static mapProp + #214, #2
  static mapProp + #215, #0
  static mapProp + #216, #0
  static mapProp + #217, #0
  static mapProp + #218, #0
  static mapProp + #219, #0
  static mapProp + #220, #0
  static mapProp + #221, #2
  static mapProp + #222, #2
  static mapProp + #223, #2
  static mapProp + #224, #2
  static mapProp + #225, #0
  static mapProp + #226, #0
  static mapProp + #227, #0
  static mapProp + #228, #0
  static mapProp + #229, #2
  static mapProp + #230, #2
  static mapProp + #231, #2
  static mapProp + #232, #2
  static mapProp + #233, #0
  static mapProp + #234, #0
  static mapProp + #235, #0
  static mapProp + #236, #0
  static mapProp + #237, #0
  static mapProp + #238, #0
  static mapProp + #239, #0

  ;Linha 6
  static mapProp + #240, #0
  static mapProp + #241, #0
  static mapProp + #242, #2
  static mapProp + #243, #2
  static mapProp + #244, #2
  static mapProp + #245, #2
  static mapProp + #246, #0
  static mapProp + #247, #0
  static mapProp + #248, #0
  static mapProp + #249, #0
  static mapProp + #250, #2
  static mapProp + #251, #2
  static mapProp + #252, #2
  static mapProp + #253, #2
  static mapProp + #254, #2
  static mapProp + #255, #2
  static mapProp + #256, #2
  static mapProp + #257, #2
  static mapProp + #258, #2
  static mapProp + #259, #2
  static mapProp + #260, #2
  static mapProp + #261, #2
  static mapProp + #262, #2
  static mapProp + #263, #2
  static mapProp + #264, #2
  static mapProp + #265, #2
  static mapProp + #266, #2
  static mapProp + #267, #0
  static mapProp + #268, #0
  static mapProp + #269, #0
  static mapProp + #270, #2
  static mapProp + #271, #2
  static mapProp + #272, #0
  static mapProp + #273, #0
  static mapProp + #274, #0
  static mapProp + #275, #0
  static mapProp + #276, #0
  static mapProp + #277, #0
  static mapProp + #278, #0
  static mapProp + #279, #0

  ;Linha 7
  static mapProp + #280, #0
  static mapProp + #281, #2
  static mapProp + #282, #2
  static mapProp + #283, #2
  static mapProp + #284, #2
  static mapProp + #285, #2
  static mapProp + #286, #2
  static mapProp + #287, #0
  static mapProp + #288, #0
  static mapProp + #289, #2
  static mapProp + #290, #2
  static mapProp + #291, #2
  static mapProp + #292, #2
  static mapProp + #293, #2
  static mapProp + #294, #2
  static mapProp + #295, #2
  static mapProp + #296, #2
  static mapProp + #297, #2
  static mapProp + #298, #2
  static mapProp + #299, #2
  static mapProp + #300, #2
  static mapProp + #301, #2
  static mapProp + #302, #2
  static mapProp + #303, #2
  static mapProp + #304, #2
  static mapProp + #305, #2
  static mapProp + #306, #2
  static mapProp + #307, #2
  static mapProp + #308, #0
  static mapProp + #309, #0
  static mapProp + #310, #2
  static mapProp + #311, #2
  static mapProp + #312, #0
  static mapProp + #313, #0
  static mapProp + #314, #0
  static mapProp + #315, #0
  static mapProp + #316, #0
  static mapProp + #317, #0
  static mapProp + #318, #0
  static mapProp + #319, #0

  ;Linha 8
  static mapProp + #320, #2
  static mapProp + #321, #2
  static mapProp + #322, #2
  static mapProp + #323, #2
  static mapProp + #324, #2
  static mapProp + #325, #2
  static mapProp + #326, #2
  static mapProp + #327, #2
  static mapProp + #328, #0
  static mapProp + #329, #2
  static mapProp + #330, #2
  static mapProp + #331, #2
  static mapProp + #332, #2
  static mapProp + #333, #2
  static mapProp + #334, #2
  static mapProp + #335, #2
  static mapProp + #336, #2
  static mapProp + #337, #2
  static mapProp + #338, #2
  static mapProp + #339, #2
  static mapProp + #340, #2
  static mapProp + #341, #2
  static mapProp + #342, #2
  static mapProp + #343, #2
  static mapProp + #344, #2
  static mapProp + #345, #2
  static mapProp + #346, #2
  static mapProp + #347, #2
  static mapProp + #348, #0
  static mapProp + #349, #0
  static mapProp + #350, #2
  static mapProp + #351, #2
  static mapProp + #352, #0
  static mapProp + #353, #0
  static mapProp + #354, #0
  static mapProp + #355, #0
  static mapProp + #356, #0
  static mapProp + #357, #0
  static mapProp + #358, #0
  static mapProp + #359, #0

  ;Linha 9
  static mapProp + #360, #2
  static mapProp + #361, #2
  static mapProp + #362, #2
  static mapProp + #363, #2
  static mapProp + #364, #2
  static mapProp + #365, #2
  static mapProp + #366, #2
  static mapProp + #367, #2
  static mapProp + #368, #0
  static mapProp + #369, #2
  static mapProp + #370, #2
  static mapProp + #371, #2
  static mapProp + #372, #2
  static mapProp + #373, #3
  static mapProp + #374, #2
  static mapProp + #375, #2
  static mapProp + #376, #2
  static mapProp + #377, #2
  static mapProp + #378, #2
  static mapProp + #379, #2
  static mapProp + #380, #2
  static mapProp + #381, #2
  static mapProp + #382, #2
  static mapProp + #383, #2
  static mapProp + #384, #2
  static mapProp + #385, #2
  static mapProp + #386, #2
  static mapProp + #387, #2
  static mapProp + #388, #0
  static mapProp + #389, #0
  static mapProp + #390, #2
  static mapProp + #391, #2
  static mapProp + #392, #0
  static mapProp + #393, #0
  static mapProp + #394, #0
  static mapProp + #395, #0
  static mapProp + #396, #0
  static mapProp + #397, #0
  static mapProp + #398, #0
  static mapProp + #399, #0

  ;Linha 10
  static mapProp + #400, #0
  static mapProp + #401, #2
  static mapProp + #402, #2
  static mapProp + #403, #2
  static mapProp + #404, #2
  static mapProp + #405, #2
  static mapProp + #406, #2
  static mapProp + #407, #0
  static mapProp + #408, #0
  static mapProp + #409, #0
  static mapProp + #410, #2
  static mapProp + #411, #2
  static mapProp + #412, #3
  static mapProp + #413, #3
  static mapProp + #414, #3
  static mapProp + #415, #2
  static mapProp + #416, #2
  static mapProp + #417, #2
  static mapProp + #418, #2
  static mapProp + #419, #2
  static mapProp + #420, #2
  static mapProp + #421, #2
  static mapProp + #422, #2
  static mapProp + #423, #2
  static mapProp + #424, #2
  static mapProp + #425, #2
  static mapProp + #426, #2
  static mapProp + #427, #0
  static mapProp + #428, #0
  static mapProp + #429, #0
  static mapProp + #430, #2
  static mapProp + #431, #2
  static mapProp + #432, #0
  static mapProp + #433, #0
  static mapProp + #434, #2
  static mapProp + #435, #0
  static mapProp + #436, #0
  static mapProp + #437, #0
  static mapProp + #438, #0
  static mapProp + #439, #0

  ;Linha 11
  static mapProp + #440, #0
  static mapProp + #441, #0
  static mapProp + #442, #2
  static mapProp + #443, #2
  static mapProp + #444, #2
  static mapProp + #445, #2
  static mapProp + #446, #0
  static mapProp + #447, #0
  static mapProp + #448, #0
  static mapProp + #449, #0
  static mapProp + #450, #3
  static mapProp + #451, #2
  static mapProp + #452, #0
  static mapProp + #453, #3
  static mapProp + #454, #3
  static mapProp + #455, #3
  static mapProp + #456, #2
  static mapProp + #457, #2
  static mapProp + #458, #3
  static mapProp + #459, #3
  static mapProp + #460, #2
  static mapProp + #461, #2
  static mapProp + #462, #2
  static mapProp + #463, #2
  static mapProp + #464, #2
  static mapProp + #465, #2
  static mapProp + #466, #0
  static mapProp + #467, #0
  static mapProp + #468, #0
  static mapProp + #469, #0
  static mapProp + #470, #2
  static mapProp + #471, #2
  static mapProp + #472, #0
  static mapProp + #473, #2
  static mapProp + #474, #2
  static mapProp + #475, #2
  static mapProp + #476, #0
  static mapProp + #477, #0
  static mapProp + #478, #0
  static mapProp + #479, #0

  ;Linha 12
  static mapProp + #480, #0
  static mapProp + #481, #0
  static mapProp + #482, #0
  static mapProp + #483, #2
  static mapProp + #484, #2
  static mapProp + #485, #0
  static mapProp + #486, #0
  static mapProp + #487, #3
  static mapProp + #488, #3
  static mapProp + #489, #3
  static mapProp + #490, #3
  static mapProp + #491, #3
  static mapProp + #492, #3
  static mapProp + #493, #3
  static mapProp + #494, #0
  static mapProp + #495, #1
  static mapProp + #496, #1
  static mapProp + #497, #0
  static mapProp + #498, #0
  static mapProp + #499, #3
  static mapProp + #500, #2
  static mapProp + #501, #2
  static mapProp + #502, #0
  static mapProp + #503, #0
  static mapProp + #504, #1
  static mapProp + #505, #1
  static mapProp + #506, #0
  static mapProp + #507, #0
  static mapProp + #508, #0
  static mapProp + #509, #0
  static mapProp + #510, #1
  static mapProp + #511, #1
  static mapProp + #512, #0
  static mapProp + #513, #2
  static mapProp + #514, #2
  static mapProp + #515, #2
  static mapProp + #516, #0
  static mapProp + #517, #0
  static mapProp + #518, #0
  static mapProp + #519, #0

  ;Linha 13
  static mapProp + #520, #0
  static mapProp + #521, #0
  static mapProp + #522, #0
  static mapProp + #523, #2
  static mapProp + #524, #2
  static mapProp + #525, #0
  static mapProp + #526, #3
  static mapProp + #527, #3
  static mapProp + #528, #3
  static mapProp + #529, #3
  static mapProp + #530, #3
  static mapProp + #531, #3
  static mapProp + #532, #3
  static mapProp + #533, #3
  static mapProp + #534, #3
  static mapProp + #535, #0
  static mapProp + #536, #0
  static mapProp + #537, #0
  static mapProp + #538, #0
  static mapProp + #539, #0
  static mapProp + #540, #2
  static mapProp + #541, #2
  static mapProp + #542, #0
  static mapProp + #543, #0
  static mapProp + #544, #1
  static mapProp + #545, #1
  static mapProp + #546, #0
  static mapProp + #547, #0
  static mapProp + #548, #0
  static mapProp + #549, #0
  static mapProp + #550, #1
  static mapProp + #551, #1
  static mapProp + #552, #0
  static mapProp + #553, #2
  static mapProp + #554, #2
  static mapProp + #555, #0
  static mapProp + #556, #0
  static mapProp + #557, #0
  static mapProp + #558, #0
  static mapProp + #559, #0

  ;Linha 14
  static mapProp + #560, #0
  static mapProp + #561, #0
  static mapProp + #562, #0
  static mapProp + #563, #1
  static mapProp + #564, #1
  static mapProp + #565, #0
  static mapProp + #566, #3
  static mapProp + #567, #3
  static mapProp + #568, #3
  static mapProp + #569, #3
  static mapProp + #570, #3
  static mapProp + #571, #3
  static mapProp + #572, #3
  static mapProp + #573, #3
  static mapProp + #574, #0
  static mapProp + #575, #0
  static mapProp + #576, #0
  static mapProp + #577, #0
  static mapProp + #578, #0
  static mapProp + #579, #0
  static mapProp + #580, #1
  static mapProp + #581, #1
  static mapProp + #582, #0
  static mapProp + #583, #0
  static mapProp + #584, #0
  static mapProp + #585, #0
  static mapProp + #586, #0
  static mapProp + #587, #0
  static mapProp + #588, #0
  static mapProp + #589, #0
  static mapProp + #590, #0
  static mapProp + #591, #0
  static mapProp + #592, #0
  static mapProp + #593, #1
  static mapProp + #594, #1
  static mapProp + #595, #0
  static mapProp + #596, #0
  static mapProp + #597, #0
  static mapProp + #598, #0
  static mapProp + #599, #0

  ;Linha 15
  static mapProp + #600, #0
  static mapProp + #601, #0
  static mapProp + #602, #0
  static mapProp + #603, #1
  static mapProp + #604, #1
  static mapProp + #605, #0
  static mapProp + #606, #0
  static mapProp + #607, #3
  static mapProp + #608, #3
  static mapProp + #609, #3
  static mapProp + #610, #3
  static mapProp + #611, #0
  static mapProp + #612, #0
  static mapProp + #613, #0
  static mapProp + #614, #0
  static mapProp + #615, #0
  static mapProp + #616, #0
  static mapProp + #617, #0
  static mapProp + #618, #0
  static mapProp + #619, #0
  static mapProp + #620, #1
  static mapProp + #621, #1
  static mapProp + #622, #0
  static mapProp + #623, #0
  static mapProp + #624, #0
  static mapProp + #625, #0
  static mapProp + #626, #0
  static mapProp + #627, #0
  static mapProp + #628, #0
  static mapProp + #629, #0
  static mapProp + #630, #0
  static mapProp + #631, #0
  static mapProp + #632, #0
  static mapProp + #633, #1
  static mapProp + #634, #1
  static mapProp + #635, #0
  static mapProp + #636, #0
  static mapProp + #637, #0
  static mapProp + #638, #0
  static mapProp + #639, #0

  ;Linha 16
  static mapProp + #640, #0
  static mapProp + #641, #0
  static mapProp + #642, #0
  static mapProp + #643, #0
  static mapProp + #644, #0
  static mapProp + #645, #0
  static mapProp + #646, #0
  static mapProp + #647, #0
  static mapProp + #648, #0
  static mapProp + #649, #0
  static mapProp + #650, #0
  static mapProp + #651, #0
  static mapProp + #652, #0
  static mapProp + #653, #0
  static mapProp + #654, #0
  static mapProp + #655, #0
  static mapProp + #656, #0
  static mapProp + #657, #0
  static mapProp + #658, #0
  static mapProp + #659, #0
  static mapProp + #660, #0
  static mapProp + #661, #0
  static mapProp + #662, #0
  static mapProp + #663, #0
  static mapProp + #664, #0
  static mapProp + #665, #0
  static mapProp + #666, #0
  static mapProp + #667, #0
  static mapProp + #668, #0
  static mapProp + #669, #0
  static mapProp + #670, #0
  static mapProp + #671, #0
  static mapProp + #672, #0
  static mapProp + #673, #0
  static mapProp + #674, #0
  static mapProp + #675, #0
  static mapProp + #676, #0
  static mapProp + #677, #0
  static mapProp + #678, #0
  static mapProp + #679, #0

  ;Linha 17
  static mapProp + #680, #0
  static mapProp + #681, #0
  static mapProp + #682, #0
  static mapProp + #683, #0
  static mapProp + #684, #0
  static mapProp + #685, #0
  static mapProp + #686, #0
  static mapProp + #687, #0
  static mapProp + #688, #0
  static mapProp + #689, #0
  static mapProp + #690, #0
  static mapProp + #691, #0
  static mapProp + #692, #0
  static mapProp + #693, #0
  static mapProp + #694, #0
  static mapProp + #695, #0
  static mapProp + #696, #0
  static mapProp + #697, #0
  static mapProp + #698, #0
  static mapProp + #699, #0
  static mapProp + #700, #0
  static mapProp + #701, #0
  static mapProp + #702, #0
  static mapProp + #703, #0
  static mapProp + #704, #0
  static mapProp + #705, #0
  static mapProp + #706, #0
  static mapProp + #707, #0
  static mapProp + #708, #0
  static mapProp + #709, #0
  static mapProp + #710, #0
  static mapProp + #711, #0
  static mapProp + #712, #0
  static mapProp + #713, #0
  static mapProp + #714, #0
  static mapProp + #715, #0
  static mapProp + #716, #0
  static mapProp + #717, #0
  static mapProp + #718, #0
  static mapProp + #719, #0

  ;Linha 18
  static mapProp + #720, #0
  static mapProp + #721, #0
  static mapProp + #722, #0
  static mapProp + #723, #0
  static mapProp + #724, #0
  static mapProp + #725, #0
  static mapProp + #726, #0
  static mapProp + #727, #0
  static mapProp + #728, #0
  static mapProp + #729, #0
  static mapProp + #730, #0
  static mapProp + #731, #0
  static mapProp + #732, #0
  static mapProp + #733, #0
  static mapProp + #734, #0
  static mapProp + #735, #0
  static mapProp + #736, #0
  static mapProp + #737, #0
  static mapProp + #738, #0
  static mapProp + #739, #0
  static mapProp + #740, #0
  static mapProp + #741, #0
  static mapProp + #742, #0
  static mapProp + #743, #0
  static mapProp + #744, #0
  static mapProp + #745, #0
  static mapProp + #746, #0
  static mapProp + #747, #0
  static mapProp + #748, #0
  static mapProp + #749, #0
  static mapProp + #750, #0
  static mapProp + #751, #0
  static mapProp + #752, #0
  static mapProp + #753, #0
  static mapProp + #754, #0
  static mapProp + #755, #0
  static mapProp + #756, #0
  static mapProp + #757, #0
  static mapProp + #758, #0
  static mapProp + #759, #0

  ;Linha 19
  static mapProp + #760, #0
  static mapProp + #761, #0
  static mapProp + #762, #0
  static mapProp + #763, #0
  static mapProp + #764, #0
  static mapProp + #765, #0
  static mapProp + #766, #0
  static mapProp + #767, #0
  static mapProp + #768, #0
  static mapProp + #769, #0
  static mapProp + #770, #0
  static mapProp + #771, #0
  static mapProp + #772, #0
  static mapProp + #773, #0
  static mapProp + #774, #0
  static mapProp + #775, #0
  static mapProp + #776, #0
  static mapProp + #777, #0
  static mapProp + #778, #0
  static mapProp + #779, #0
  static mapProp + #780, #0
  static mapProp + #781, #0
  static mapProp + #782, #0
  static mapProp + #783, #0
  static mapProp + #784, #0
  static mapProp + #785, #0
  static mapProp + #786, #0
  static mapProp + #787, #0
  static mapProp + #788, #0
  static mapProp + #789, #0
  static mapProp + #790, #0
  static mapProp + #791, #0
  static mapProp + #792, #0
  static mapProp + #793, #0
  static mapProp + #794, #0
  static mapProp + #795, #0
  static mapProp + #796, #0
  static mapProp + #797, #0
  static mapProp + #798, #0
  static mapProp + #799, #0

  ;Linha 20
  static mapProp + #800, #1
  static mapProp + #801, #0
  static mapProp + #802, #0
  static mapProp + #803, #1
  static mapProp + #804, #1
  static mapProp + #805, #1
  static mapProp + #806, #1
  static mapProp + #807, #1
  static mapProp + #808, #1
  static mapProp + #809, #1
  static mapProp + #810, #1
  static mapProp + #811, #1
  static mapProp + #812, #1
  static mapProp + #813, #0
  static mapProp + #814, #0
  static mapProp + #815, #1
  static mapProp + #816, #1
  static mapProp + #817, #1
  static mapProp + #818, #1
  static mapProp + #819, #1
  static mapProp + #820, #1
  static mapProp + #821, #1
  static mapProp + #822, #1
  static mapProp + #823, #1
  static mapProp + #824, #1
  static mapProp + #825, #0
  static mapProp + #826, #0
  static mapProp + #827, #1
  static mapProp + #828, #1
  static mapProp + #829, #1
  static mapProp + #830, #1
  static mapProp + #831, #1
  static mapProp + #832, #1
  static mapProp + #833, #1
  static mapProp + #834, #1
  static mapProp + #835, #1
  static mapProp + #836, #1
  static mapProp + #837, #1
  static mapProp + #838, #0
  static mapProp + #839, #0

  ;Linha 21
  static mapProp + #840, #0
  static mapProp + #841, #0
  static mapProp + #842, #0
  static mapProp + #843, #0
  static mapProp + #844, #0
  static mapProp + #845, #0
  static mapProp + #846, #0
  static mapProp + #847, #0
  static mapProp + #848, #0
  static mapProp + #849, #0
  static mapProp + #850, #0
  static mapProp + #851, #0
  static mapProp + #852, #0
  static mapProp + #853, #0
  static mapProp + #854, #0
  static mapProp + #855, #0
  static mapProp + #856, #0
  static mapProp + #857, #0
  static mapProp + #858, #0
  static mapProp + #859, #0
  static mapProp + #860, #0
  static mapProp + #861, #0
  static mapProp + #862, #0
  static mapProp + #863, #0
  static mapProp + #864, #0
  static mapProp + #865, #0
  static mapProp + #866, #0
  static mapProp + #867, #0
  static mapProp + #868, #0
  static mapProp + #869, #0
  static mapProp + #870, #0
  static mapProp + #871, #0
  static mapProp + #872, #0
  static mapProp + #873, #0
  static mapProp + #874, #0
  static mapProp + #875, #0
  static mapProp + #876, #0
  static mapProp + #877, #0
  static mapProp + #878, #0
  static mapProp + #879, #0

  ;Linha 22
  static mapProp + #880, #0
  static mapProp + #881, #0
  static mapProp + #882, #0
  static mapProp + #883, #0
  static mapProp + #884, #0
  static mapProp + #885, #0
  static mapProp + #886, #0
  static mapProp + #887, #0
  static mapProp + #888, #0
  static mapProp + #889, #0
  static mapProp + #890, #0
  static mapProp + #891, #0
  static mapProp + #892, #0
  static mapProp + #893, #0
  static mapProp + #894, #0
  static mapProp + #895, #0
  static mapProp + #896, #0
  static mapProp + #897, #0
  static mapProp + #898, #0
  static mapProp + #899, #0
  static mapProp + #900, #0
  static mapProp + #901, #0
  static mapProp + #902, #0
  static mapProp + #903, #0
  static mapProp + #904, #0
  static mapProp + #905, #0
  static mapProp + #906, #0
  static mapProp + #907, #0
  static mapProp + #908, #0
  static mapProp + #909, #0
  static mapProp + #910, #0
  static mapProp + #911, #0
  static mapProp + #912, #0
  static mapProp + #913, #0
  static mapProp + #914, #0
  static mapProp + #915, #0
  static mapProp + #916, #0
  static mapProp + #917, #0
  static mapProp + #918, #0
  static mapProp + #919, #0

  ;Linha 23
  static mapProp + #920, #0
  static mapProp + #921, #0
  static mapProp + #922, #0
  static mapProp + #923, #1
  static mapProp + #924, #1
  static mapProp + #925, #1
  static mapProp + #926, #1
  static mapProp + #927, #1
  static mapProp + #928, #0
  static mapProp + #929, #0
  static mapProp + #930, #1
  static mapProp + #931, #1
  static mapProp + #932, #1
  static mapProp + #933, #0
  static mapProp + #934, #0
  static mapProp + #935, #1
  static mapProp + #936, #1
  static mapProp + #937, #1
  static mapProp + #938, #1
  static mapProp + #939, #1
  static mapProp + #940, #1
  static mapProp + #941, #1
  static mapProp + #942, #1
  static mapProp + #943, #1
  static mapProp + #944, #1
  static mapProp + #945, #1
  static mapProp + #946, #1
  static mapProp + #947, #1
  static mapProp + #948, #1
  static mapProp + #949, #1
  static mapProp + #950, #1
  static mapProp + #951, #1
  static mapProp + #952, #1
  static mapProp + #953, #1
  static mapProp + #954, #1
  static mapProp + #955, #0
  static mapProp + #956, #0
  static mapProp + #957, #1
  static mapProp + #958, #0
  static mapProp + #959, #0

  ;Linha 24
  static mapProp + #960, #0
  static mapProp + #961, #0
  static mapProp + #962, #0
  static mapProp + #963, #1
  static mapProp + #964, #0
  static mapProp + #965, #0
  static mapProp + #966, #0
  static mapProp + #967, #0
  static mapProp + #968, #0
  static mapProp + #969, #0
  static mapProp + #970, #0
  static mapProp + #971, #0
  static mapProp + #972, #0
  static mapProp + #973, #0
  static mapProp + #974, #0
  static mapProp + #975, #0
  static mapProp + #976, #0
  static mapProp + #977, #0
  static mapProp + #978, #0
  static mapProp + #979, #0
  static mapProp + #980, #0
  static mapProp + #981, #0
  static mapProp + #982, #0
  static mapProp + #983, #0
  static mapProp + #984, #0
  static mapProp + #985, #0
  static mapProp + #986, #0
  static mapProp + #987, #0
  static mapProp + #988, #0
  static mapProp + #989, #0
  static mapProp + #990, #0
  static mapProp + #991, #0
  static mapProp + #992, #0
  static mapProp + #993, #0
  static mapProp + #994, #0
  static mapProp + #995, #0
  static mapProp + #996, #0
  static mapProp + #997, #1
  static mapProp + #998, #0
  static mapProp + #999, #0

  ;Linha 25
  static mapProp + #1000, #0
  static mapProp + #1001, #0
  static mapProp + #1002, #0
  static mapProp + #1003, #1
  static mapProp + #1004, #0
  static mapProp + #1005, #0
  static mapProp + #1006, #0
  static mapProp + #1007, #0
  static mapProp + #1008, #0
  static mapProp + #1009, #0
  static mapProp + #1010, #0
  static mapProp + #1011, #0
  static mapProp + #1012, #0
  static mapProp + #1013, #0
  static mapProp + #1014, #0
  static mapProp + #1015, #0
  static mapProp + #1016, #0
  static mapProp + #1017, #0
  static mapProp + #1018, #0
  static mapProp + #1019, #0
  static mapProp + #1020, #0
  static mapProp + #1021, #0
  static mapProp + #1022, #0
  static mapProp + #1023, #0
  static mapProp + #1024, #0
  static mapProp + #1025, #0
  static mapProp + #1026, #0
  static mapProp + #1027, #0
  static mapProp + #1028, #0
  static mapProp + #1029, #0
  static mapProp + #1030, #0
  static mapProp + #1031, #0
  static mapProp + #1032, #0
  static mapProp + #1033, #0
  static mapProp + #1034, #0
  static mapProp + #1035, #0
  static mapProp + #1036, #0
  static mapProp + #1037, #1
  static mapProp + #1038, #0
  static mapProp + #1039, #0

  ;Linha 26
  static mapProp + #1040, #0
  static mapProp + #1041, #0
  static mapProp + #1042, #0
  static mapProp + #1043, #1
  static mapProp + #1044, #0
  static mapProp + #1045, #0
  static mapProp + #1046, #0
  static mapProp + #1047, #1
  static mapProp + #1048, #1
  static mapProp + #1049, #1
  static mapProp + #1050, #1
  static mapProp + #1051, #1
  static mapProp + #1052, #1
  static mapProp + #1053, #1
  static mapProp + #1054, #1
  static mapProp + #1055, #1
  static mapProp + #1056, #0
  static mapProp + #1057, #0
  static mapProp + #1058, #0
  static mapProp + #1059, #1
  static mapProp + #1060, #1
  static mapProp + #1061, #1
  static mapProp + #1062, #1
  static mapProp + #1063, #0
  static mapProp + #1064, #0
  static mapProp + #1065, #1
  static mapProp + #1066, #1
  static mapProp + #1067, #1
  static mapProp + #1068, #1
  static mapProp + #1069, #1
  static mapProp + #1070, #0
  static mapProp + #1071, #0
  static mapProp + #1072, #1
  static mapProp + #1073, #1
  static mapProp + #1074, #1
  static mapProp + #1075, #1
  static mapProp + #1076, #1
  static mapProp + #1077, #1
  static mapProp + #1078, #0
  static mapProp + #1079, #0

  ;Linha 27
  static mapProp + #1080, #0
  static mapProp + #1081, #0
  static mapProp + #1082, #0
  static mapProp + #1083, #1
  static mapProp + #1084, #0
  static mapProp + #1085, #0
  static mapProp + #1086, #0
  static mapProp + #1087, #0
  static mapProp + #1088, #0
  static mapProp + #1089, #0
  static mapProp + #1090, #0
  static mapProp + #1091, #0
  static mapProp + #1092, #0
  static mapProp + #1093, #0
  static mapProp + #1094, #0
  static mapProp + #1095, #0
  static mapProp + #1096, #0
  static mapProp + #1097, #0
  static mapProp + #1098, #0
  static mapProp + #1099, #0
  static mapProp + #1100, #0
  static mapProp + #1101, #0
  static mapProp + #1102, #1
  static mapProp + #1103, #0
  static mapProp + #1104, #0
  static mapProp + #1105, #1
  static mapProp + #1106, #1
  static mapProp + #1107, #1
  static mapProp + #1108, #1
  static mapProp + #1109, #1
  static mapProp + #1110, #0
  static mapProp + #1111, #0
  static mapProp + #1112, #0
  static mapProp + #1113, #0
  static mapProp + #1114, #0
  static mapProp + #1115, #0
  static mapProp + #1116, #0
  static mapProp + #1117, #0
  static mapProp + #1118, #0
  static mapProp + #1119, #0

  ;Linha 28
  static mapProp + #1120, #0
  static mapProp + #1121, #0
  static mapProp + #1122, #0
  static mapProp + #1123, #1
  static mapProp + #1124, #0
  static mapProp + #1125, #0
  static mapProp + #1126, #0
  static mapProp + #1127, #0
  static mapProp + #1128, #0
  static mapProp + #1129, #0
  static mapProp + #1130, #0
  static mapProp + #1131, #0
  static mapProp + #1132, #0
  static mapProp + #1133, #0
  static mapProp + #1134, #0
  static mapProp + #1135, #0
  static mapProp + #1136, #0
  static mapProp + #1137, #0
  static mapProp + #1138, #0
  static mapProp + #1139, #0
  static mapProp + #1140, #0
  static mapProp + #1141, #0
  static mapProp + #1142, #1
  static mapProp + #1143, #0
  static mapProp + #1144, #0
  static mapProp + #1145, #0
  static mapProp + #1146, #0
  static mapProp + #1147, #0
  static mapProp + #1148, #0
  static mapProp + #1149, #1
  static mapProp + #1150, #0
  static mapProp + #1151, #0
  static mapProp + #1152, #0
  static mapProp + #1153, #0
  static mapProp + #1154, #0
  static mapProp + #1155, #0
  static mapProp + #1156, #0
  static mapProp + #1157, #0
  static mapProp + #1158, #0
  static mapProp + #1159, #0

  ;Linha 29
  static mapProp + #1160, #0
  static mapProp + #1161, #0
  static mapProp + #1162, #0
  static mapProp + #1163, #1
  static mapProp + #1164, #0
  static mapProp + #1165, #0
  static mapProp + #1166, #0
  static mapProp + #1167, #1
  static mapProp + #1168, #1
  static mapProp + #1169, #1
  static mapProp + #1170, #1
  static mapProp + #1171, #1
  static mapProp + #1172, #1
  static mapProp + #1173, #0
  static mapProp + #1174, #0
  static mapProp + #1175, #0
  static mapProp + #1176, #1
  static mapProp + #1177, #0
  static mapProp + #1178, #0
  static mapProp + #1179, #1
  static mapProp + #1180, #0
  static mapProp + #1181, #0
  static mapProp + #1182, #1
  static mapProp + #1183, #0
  static mapProp + #1184, #0
  static mapProp + #1185, #0
  static mapProp + #1186, #0
  static mapProp + #1187, #0
  static mapProp + #1188, #0
  static mapProp + #1189, #1
  static mapProp + #1190, #0
  static mapProp + #1191, #0
  static mapProp + #1192, #0
  static mapProp + #1193, #0
  static mapProp + #1194, #0
  static mapProp + #1195, #0
  static mapProp + #1196, #0
  static mapProp + #1197, #0
  static mapProp + #1198, #0
  static mapProp + #1199, #0

  ;Linha 30
  static mapProp + #1200, #0
  static mapProp + #1201, #0
  static mapProp + #1202, #0
  static mapProp + #1203, #1
  static mapProp + #1204, #0
  static mapProp + #1205, #0
  static mapProp + #1206, #1
  static mapProp + #1207, #1
  static mapProp + #1208, #1
  static mapProp + #1209, #1
  static mapProp + #1210, #1
  static mapProp + #1211, #1
  static mapProp + #1212, #1
  static mapProp + #1213, #1
  static mapProp + #1214, #0
  static mapProp + #1215, #0
  static mapProp + #1216, #1
  static mapProp + #1217, #0
  static mapProp + #1218, #0
  static mapProp + #1219, #1
  static mapProp + #1220, #0
  static mapProp + #1221, #0
  static mapProp + #1222, #1
  static mapProp + #1223, #1
  static mapProp + #1224, #1
  static mapProp + #1225, #1
  static mapProp + #1226, #1
  static mapProp + #1227, #0
  static mapProp + #1228, #0
  static mapProp + #1229, #1
  static mapProp + #1230, #1
  static mapProp + #1231, #1
  static mapProp + #1232, #1
  static mapProp + #1233, #1
  static mapProp + #1234, #1
  static mapProp + #1235, #0
  static mapProp + #1236, #0
  static mapProp + #1237, #1
  static mapProp + #1238, #0
  static mapProp + #1239, #0

  ;Linha 31
  static mapProp + #1240, #0
  static mapProp + #1241, #0
  static mapProp + #1242, #0
  static mapProp + #1243, #1
  static mapProp + #1244, #0
  static mapProp + #1245, #0
  static mapProp + #1246, #1
  static mapProp + #1247, #1
  static mapProp + #1248, #1
  static mapProp + #1249, #1
  static mapProp + #1250, #1
  static mapProp + #1251, #1
  static mapProp + #1252, #1
  static mapProp + #1253, #1
  static mapProp + #1254, #0
  static mapProp + #1255, #0
  static mapProp + #1256, #1
  static mapProp + #1257, #0
  static mapProp + #1258, #0
  static mapProp + #1259, #1
  static mapProp + #1260, #0
  static mapProp + #1261, #0
  static mapProp + #1262, #0
  static mapProp + #1263, #0
  static mapProp + #1264, #0
  static mapProp + #1265, #0
  static mapProp + #1266, #1
  static mapProp + #1267, #0
  static mapProp + #1268, #0
  static mapProp + #1269, #1
  static mapProp + #1270, #0
  static mapProp + #1271, #0
  static mapProp + #1272, #0
  static mapProp + #1273, #0
  static mapProp + #1274, #0
  static mapProp + #1275, #0
  static mapProp + #1276, #0
  static mapProp + #1277, #1
  static mapProp + #1278, #0
  static mapProp + #1279, #0

  ;Linha 32
  static mapProp + #1280, #0
  static mapProp + #1281, #0
  static mapProp + #1282, #0
  static mapProp + #1283, #1
  static mapProp + #1284, #0
  static mapProp + #1285, #0
  static mapProp + #1286, #1
  static mapProp + #1287, #1
  static mapProp + #1288, #1
  static mapProp + #1289, #1
  static mapProp + #1290, #1
  static mapProp + #1291, #1
  static mapProp + #1292, #1
  static mapProp + #1293, #1
  static mapProp + #1294, #0
  static mapProp + #1295, #0
  static mapProp + #1296, #1
  static mapProp + #1297, #0
  static mapProp + #1298, #0
  static mapProp + #1299, #1
  static mapProp + #1300, #0
  static mapProp + #1301, #0
  static mapProp + #1302, #0
  static mapProp + #1303, #0
  static mapProp + #1304, #0
  static mapProp + #1305, #0
  static mapProp + #1306, #1
  static mapProp + #1307, #0
  static mapProp + #1308, #0
  static mapProp + #1309, #1
  static mapProp + #1310, #0
  static mapProp + #1311, #0
  static mapProp + #1312, #0
  static mapProp + #1313, #0
  static mapProp + #1314, #0
  static mapProp + #1315, #0
  static mapProp + #1316, #0
  static mapProp + #1317, #1
  static mapProp + #1318, #0
  static mapProp + #1319, #0

  ;Linha 33
  static mapProp + #1320, #0
  static mapProp + #1321, #0
  static mapProp + #1322, #0
  static mapProp + #1323, #1
  static mapProp + #1324, #0
  static mapProp + #1325, #0
  static mapProp + #1326, #0
  static mapProp + #1327, #1
  static mapProp + #1328, #1
  static mapProp + #1329, #1
  static mapProp + #1330, #1
  static mapProp + #1331, #1
  static mapProp + #1332, #1
  static mapProp + #1333, #0
  static mapProp + #1334, #0
  static mapProp + #1335, #0
  static mapProp + #1336, #1
  static mapProp + #1337, #0
  static mapProp + #1338, #0
  static mapProp + #1339, #1
  static mapProp + #1340, #1
  static mapProp + #1341, #1
  static mapProp + #1342, #1
  static mapProp + #1343, #1
  static mapProp + #1344, #0
  static mapProp + #1345, #0
  static mapProp + #1346, #1
  static mapProp + #1347, #0
  static mapProp + #1348, #0
  static mapProp + #1349, #1
  static mapProp + #1350, #0
  static mapProp + #1351, #0
  static mapProp + #1352, #0
  static mapProp + #1353, #0
  static mapProp + #1354, #1
  static mapProp + #1355, #1
  static mapProp + #1356, #1
  static mapProp + #1357, #1
  static mapProp + #1358, #0
  static mapProp + #1359, #0

  ;Linha 34
  static mapProp + #1360, #0
  static mapProp + #1361, #0
  static mapProp + #1362, #0
  static mapProp + #1363, #0
  static mapProp + #1364, #0
  static mapProp + #1365, #0
  static mapProp + #1366, #0
  static mapProp + #1367, #0
  static mapProp + #1368, #0
  static mapProp + #1369, #0
  static mapProp + #1370, #0
  static mapProp + #1371, #0
  static mapProp + #1372, #0
  static mapProp + #1373, #0
  static mapProp + #1374, #0
  static mapProp + #1375, #0
  static mapProp + #1376, #0
  static mapProp + #1377, #0
  static mapProp + #1378, #0
  static mapProp + #1379, #1
  static mapProp + #1380, #1
  static mapProp + #1381, #0
  static mapProp + #1382, #0
  static mapProp + #1383, #0
  static mapProp + #1384, #0
  static mapProp + #1385, #0
  static mapProp + #1386, #0
  static mapProp + #1387, #0
  static mapProp + #1388, #0
  static mapProp + #1389, #0
  static mapProp + #1390, #0
  static mapProp + #1391, #0
  static mapProp + #1392, #0
  static mapProp + #1393, #1
  static mapProp + #1394, #1
  static mapProp + #1395, #1
  static mapProp + #1396, #1
  static mapProp + #1397, #1
  static mapProp + #1398, #0
  static mapProp + #1399, #0

  ;Linha 35
  static mapProp + #1400, #0
  static mapProp + #1401, #0
  static mapProp + #1402, #0
  static mapProp + #1403, #0
  static mapProp + #1404, #0
  static mapProp + #1405, #0
  static mapProp + #1406, #0
  static mapProp + #1407, #0
  static mapProp + #1408, #0
  static mapProp + #1409, #0
  static mapProp + #1410, #0
  static mapProp + #1411, #0
  static mapProp + #1412, #0
  static mapProp + #1413, #0
  static mapProp + #1414, #0
  static mapProp + #1415, #0
  static mapProp + #1416, #0
  static mapProp + #1417, #0
  static mapProp + #1418, #0
  static mapProp + #1419, #1
  static mapProp + #1420, #1
  static mapProp + #1421, #0
  static mapProp + #1422, #0
  static mapProp + #1423, #0
  static mapProp + #1424, #0
  static mapProp + #1425, #0
  static mapProp + #1426, #0
  static mapProp + #1427, #0
  static mapProp + #1428, #0
  static mapProp + #1429, #0
  static mapProp + #1430, #0
  static mapProp + #1431, #0
  static mapProp + #1432, #0
  static mapProp + #1433, #1
  static mapProp + #1434, #1
  static mapProp + #1435, #1
  static mapProp + #1436, #1
  static mapProp + #1437, #1
  static mapProp + #1438, #0
  static mapProp + #1439, #0

  ;Linha 36
  static mapProp + #1440, #0
  static mapProp + #1441, #0
  static mapProp + #1442, #0
  static mapProp + #1443, #1
  static mapProp + #1444, #0
  static mapProp + #1445, #0
  static mapProp + #1446, #0
  static mapProp + #1447, #1
  static mapProp + #1448, #1
  static mapProp + #1449, #1
  static mapProp + #1450, #1
  static mapProp + #1451, #1
  static mapProp + #1452, #1
  static mapProp + #1453, #1
  static mapProp + #1454, #1
  static mapProp + #1455, #1
  static mapProp + #1456, #1
  static mapProp + #1457, #1
  static mapProp + #1458, #1
  static mapProp + #1459, #1
  static mapProp + #1460, #1
  static mapProp + #1461, #0
  static mapProp + #1462, #0
  static mapProp + #1463, #1
  static mapProp + #1464, #1
  static mapProp + #1465, #0
  static mapProp + #1466, #0
  static mapProp + #1467, #0
  static mapProp + #1468, #0
  static mapProp + #1469, #0
  static mapProp + #1470, #0
  static mapProp + #1471, #1
  static mapProp + #1472, #1
  static mapProp + #1473, #1
  static mapProp + #1474, #1
  static mapProp + #1475, #1
  static mapProp + #1476, #1
  static mapProp + #1477, #1
  static mapProp + #1478, #0
  static mapProp + #1479, #0

  ;Linha 37
  static mapProp + #1480, #0
  static mapProp + #1481, #0
  static mapProp + #1482, #0
  static mapProp + #1483, #1
  static mapProp + #1484, #0
  static mapProp + #1485, #0
  static mapProp + #1486, #0
  static mapProp + #1487, #0
  static mapProp + #1488, #0
  static mapProp + #1489, #0
  static mapProp + #1490, #0
  static mapProp + #1491, #0
  static mapProp + #1492, #0
  static mapProp + #1493, #0
  static mapProp + #1494, #0
  static mapProp + #1495, #0
  static mapProp + #1496, #0
  static mapProp + #1497, #0
  static mapProp + #1498, #0
  static mapProp + #1499, #0
  static mapProp + #1500, #0
  static mapProp + #1501, #0
  static mapProp + #1502, #0
  static mapProp + #1503, #0
  static mapProp + #1504, #0
  static mapProp + #1505, #0
  static mapProp + #1506, #0
  static mapProp + #1507, #0
  static mapProp + #1508, #0
  static mapProp + #1509, #0
  static mapProp + #1510, #0
  static mapProp + #1511, #0
  static mapProp + #1512, #0
  static mapProp + #1513, #0
  static mapProp + #1514, #0
  static mapProp + #1515, #0
  static mapProp + #1516, #0
  static mapProp + #1517, #1
  static mapProp + #1518, #0
  static mapProp + #1519, #0

  ;Linha 38
  static mapProp + #1520, #0
  static mapProp + #1521, #0
  static mapProp + #1522, #0
  static mapProp + #1523, #1
  static mapProp + #1524, #0
  static mapProp + #1525, #0
  static mapProp + #1526, #0
  static mapProp + #1527, #0
  static mapProp + #1528, #0
  static mapProp + #1529, #0
  static mapProp + #1530, #0
  static mapProp + #1531, #0
  static mapProp + #1532, #0
  static mapProp + #1533, #0
  static mapProp + #1534, #0
  static mapProp + #1535, #0
  static mapProp + #1536, #0
  static mapProp + #1537, #0
  static mapProp + #1538, #0
  static mapProp + #1539, #0
  static mapProp + #1540, #0
  static mapProp + #1541, #0
  static mapProp + #1542, #0
  static mapProp + #1543, #1
  static mapProp + #1544, #1
  static mapProp + #1545, #1
  static mapProp + #1546, #1
  static mapProp + #1547, #1
  static mapProp + #1548, #0
  static mapProp + #1549, #0
  static mapProp + #1550, #0
  static mapProp + #1551, #0
  static mapProp + #1552, #0
  static mapProp + #1553, #0
  static mapProp + #1554, #0
  static mapProp + #1555, #0
  static mapProp + #1556, #0
  static mapProp + #1557, #1
  static mapProp + #1558, #0
  static mapProp + #1559, #0

  ;Linha 39
  static mapProp + #1560, #0
  static mapProp + #1561, #0
  static mapProp + #1562, #0
  static mapProp + #1563, #1
  static mapProp + #1564, #0
  static mapProp + #1565, #0
  static mapProp + #1566, #1
  static mapProp + #1567, #1
  static mapProp + #1568, #1
  static mapProp + #1569, #1
  static mapProp + #1570, #1
  static mapProp + #1571, #1
  static mapProp + #1572, #1
  static mapProp + #1573, #1
  static mapProp + #1574, #1
  static mapProp + #1575, #1
  static mapProp + #1576, #1
  static mapProp + #1577, #1
  static mapProp + #1578, #1
  static mapProp + #1579, #1
  static mapProp + #1580, #0
  static mapProp + #1581, #0
  static mapProp + #1582, #0
  static mapProp + #1583, #1
  static mapProp + #1584, #1
  static mapProp + #1585, #0
  static mapProp + #1586, #0
  static mapProp + #1587, #0
  static mapProp + #1588, #0
  static mapProp + #1589, #0
  static mapProp + #1590, #0
  static mapProp + #1591, #0
  static mapProp + #1592, #0
  static mapProp + #1593, #1
  static mapProp + #1594, #1
  static mapProp + #1595, #1
  static mapProp + #1596, #1
  static mapProp + #1597, #1
  static mapProp + #1598, #0
  static mapProp + #1599, #0

  ;Linha 40
  static mapProp + #1600, #0
  static mapProp + #1601, #0
  static mapProp + #1602, #0
  static mapProp + #1603, #0
  static mapProp + #1604, #0
  static mapProp + #1605, #0
  static mapProp + #1606, #0
  static mapProp + #1607, #0
  static mapProp + #1608, #0
  static mapProp + #1609, #0
  static mapProp + #1610, #0
  static mapProp + #1611, #0
  static mapProp + #1612, #0
  static mapProp + #1613, #0
  static mapProp + #1614, #0
  static mapProp + #1615, #0
  static mapProp + #1616, #0
  static mapProp + #1617, #0
  static mapProp + #1618, #0
  static mapProp + #1619, #0
  static mapProp + #1620, #0
  static mapProp + #1621, #0
  static mapProp + #1622, #0
  static mapProp + #1623, #0
  static mapProp + #1624, #0
  static mapProp + #1625, #0
  static mapProp + #1626, #0
  static mapProp + #1627, #0
  static mapProp + #1628, #0
  static mapProp + #1629, #0
  static mapProp + #1630, #0
  static mapProp + #1631, #0
  static mapProp + #1632, #0
  static mapProp + #1633, #0
  static mapProp + #1634, #0
  static mapProp + #1635, #0
  static mapProp + #1636, #0
  static mapProp + #1637, #0
  static mapProp + #1638, #0
  static mapProp + #1639, #0

  ;Linha 41
  static mapProp + #1640, #0
  static mapProp + #1641, #0
  static mapProp + #1642, #0
  static mapProp + #1643, #0
  static mapProp + #1644, #0
  static mapProp + #1645, #0
  static mapProp + #1646, #0
  static mapProp + #1647, #0
  static mapProp + #1648, #0
  static mapProp + #1649, #0
  static mapProp + #1650, #0
  static mapProp + #1651, #0
  static mapProp + #1652, #0
  static mapProp + #1653, #0
  static mapProp + #1654, #0
  static mapProp + #1655, #0
  static mapProp + #1656, #0
  static mapProp + #1657, #0
  static mapProp + #1658, #0
  static mapProp + #1659, #0
  static mapProp + #1660, #0
  static mapProp + #1661, #0
  static mapProp + #1662, #0
  static mapProp + #1663, #0
  static mapProp + #1664, #0
  static mapProp + #1665, #0
  static mapProp + #1666, #0
  static mapProp + #1667, #0
  static mapProp + #1668, #0
  static mapProp + #1669, #0
  static mapProp + #1670, #0
  static mapProp + #1671, #0
  static mapProp + #1672, #0
  static mapProp + #1673, #0
  static mapProp + #1674, #0
  static mapProp + #1675, #0
  static mapProp + #1676, #0
  static mapProp + #1677, #0
  static mapProp + #1678, #0
  static mapProp + #1679, #0

mapTotal : var #1680

  ;Linha 0
  static mapTotal + #0, #2560
  static mapTotal + #1, #2560
  static mapTotal + #2, #2560
  static mapTotal + #3, #2560
  static mapTotal + #4, #2560
  static mapTotal + #5, #2560
  static mapTotal + #6, #2560
  static mapTotal + #7, #2560
  static mapTotal + #8, #2560
  static mapTotal + #9, #2560
  static mapTotal + #10, #2560
  static mapTotal + #11, #768
  static mapTotal + #12, #768
  static mapTotal + #13, #768
  static mapTotal + #14, #768
  static mapTotal + #15, #768
  static mapTotal + #16, #2560
  static mapTotal + #17, #768
  static mapTotal + #18, #768
  static mapTotal + #19, #768
  static mapTotal + #20, #2560
  static mapTotal + #21, #1280
  static mapTotal + #22, #2816
  static mapTotal + #23, #1280
  static mapTotal + #24, #768
  static mapTotal + #25, #768
  static mapTotal + #26, #2560
  static mapTotal + #27, #2560
  static mapTotal + #28, #2560
  static mapTotal + #29, #2560
  static mapTotal + #30, #2560
  static mapTotal + #31, #2560
  static mapTotal + #32, #2560
  static mapTotal + #33, #2560
  static mapTotal + #34, #2560
  static mapTotal + #35, #2560
  static mapTotal + #36, #2816
  static mapTotal + #37, #2816
  static mapTotal + #38, #256
  static mapTotal + #39, #2816

  ;Linha 1
  static mapTotal + #40, #2560
  static mapTotal + #41, #2560
  static mapTotal + #42, #2560
  static mapTotal + #43, #2560
  static mapTotal + #44, #2560
  static mapTotal + #45, #2560
  static mapTotal + #46, #2560
  static mapTotal + #47, #2560
  static mapTotal + #48, #2560
  static mapTotal + #49, #2560
  static mapTotal + #50, #768
  static mapTotal + #51, #768
  static mapTotal + #52, #768
  static mapTotal + #53, #768
  static mapTotal + #54, #768
  static mapTotal + #55, #768
  static mapTotal + #56, #768
  static mapTotal + #57, #2560
  static mapTotal + #58, #768
  static mapTotal + #59, #768
  static mapTotal + #60, #768
  static mapTotal + #61, #2304
  static mapTotal + #62, #1280
  static mapTotal + #63, #768
  static mapTotal + #64, #1536
  static mapTotal + #65, #768
  static mapTotal + #66, #768
  static mapTotal + #67, #2560
  static mapTotal + #68, #2560
  static mapTotal + #69, #2560
  static mapTotal + #70, #768
  static mapTotal + #71, #768
  static mapTotal + #72, #2560
  static mapTotal + #73, #2560
  static mapTotal + #74, #2560
  static mapTotal + #75, #2560
  static mapTotal + #76, #2560
  static mapTotal + #77, #2816
  static mapTotal + #78, #2816
  static mapTotal + #79, #256

  ;Linha 2
  static mapTotal + #80, #2560
  static mapTotal + #81, #2560
  static mapTotal + #82, #2560
  static mapTotal + #83, #2560
  static mapTotal + #84, #2560
  static mapTotal + #85, #2560
  static mapTotal + #86, #2560
  static mapTotal + #87, #2560
  static mapTotal + #88, #2560
  static mapTotal + #89, #768
  static mapTotal + #90, #768
  static mapTotal + #91, #768
  static mapTotal + #92, #768
  static mapTotal + #93, #768
  static mapTotal + #94, #768
  static mapTotal + #95, #768
  static mapTotal + #96, #768
  static mapTotal + #97, #768
  static mapTotal + #98, #2560
  static mapTotal + #99, #1792
  static mapTotal + #100, #2304
  static mapTotal + #101, #2816
  static mapTotal + #102, #2304
  static mapTotal + #103, #1536
  static mapTotal + #104, #2816
  static mapTotal + #105, #1536
  static mapTotal + #106, #2560
  static mapTotal + #107, #2560
  static mapTotal + #108, #2560
  static mapTotal + #109, #768
  static mapTotal + #110, #768
  static mapTotal + #111, #768
  static mapTotal + #112, #768
  static mapTotal + #113, #2560
  static mapTotal + #114, #2560
  static mapTotal + #115, #2560
  static mapTotal + #116, #2560
  static mapTotal + #117, #2560
  static mapTotal + #118, #2816
  static mapTotal + #119, #2816

  ;Linha 3
  static mapTotal + #120, #2560
  static mapTotal + #121, #2560
  static mapTotal + #122, #2560
  static mapTotal + #123, #2560
  static mapTotal + #124, #2560
  static mapTotal + #125, #2560
  static mapTotal + #126, #2560
  static mapTotal + #127, #2560
  static mapTotal + #128, #2560
  static mapTotal + #129, #2560
  static mapTotal + #130, #768
  static mapTotal + #131, #768
  static mapTotal + #132, #768
  static mapTotal + #133, #768
  static mapTotal + #134, #768
  static mapTotal + #135, #768
  static mapTotal + #136, #768
  static mapTotal + #137, #2560
  static mapTotal + #138, #1792
  static mapTotal + #139, #2816
  static mapTotal + #140, #1792
  static mapTotal + #141, #2304
  static mapTotal + #142, #768
  static mapTotal + #143, #768
  static mapTotal + #144, #1536
  static mapTotal + #145, #2560
  static mapTotal + #146, #2560
  static mapTotal + #147, #2560
  static mapTotal + #148, #768
  static mapTotal + #149, #768
  static mapTotal + #150, #768
  static mapTotal + #151, #768
  static mapTotal + #152, #768
  static mapTotal + #153, #768
  static mapTotal + #154, #2560
  static mapTotal + #155, #2560
  static mapTotal + #156, #2560
  static mapTotal + #157, #2560
  static mapTotal + #158, #2560
  static mapTotal + #159, #2560

  ;Linha 4
  static mapTotal + #160, #2560
  static mapTotal + #161, #2560
  static mapTotal + #162, #2560
  static mapTotal + #163, #2560
  static mapTotal + #164, #2560
  static mapTotal + #165, #2560
  static mapTotal + #166, #2560
  static mapTotal + #167, #2560
  static mapTotal + #168, #2560
  static mapTotal + #169, #2560
  static mapTotal + #170, #2560
  static mapTotal + #171, #768
  static mapTotal + #172, #768
  static mapTotal + #173, #768
  static mapTotal + #174, #768
  static mapTotal + #175, #768
  static mapTotal + #176, #2560
  static mapTotal + #177, #2560
  static mapTotal + #178, #2560
  static mapTotal + #179, #1792
  static mapTotal + #180, #768
  static mapTotal + #181, #2560
  static mapTotal + #182, #2560
  static mapTotal + #183, #2560
  static mapTotal + #184, #2560
  static mapTotal + #185, #2560
  static mapTotal + #186, #2560
  static mapTotal + #187, #2560
  static mapTotal + #188, #768
  static mapTotal + #189, #768
  static mapTotal + #190, #768
  static mapTotal + #191, #768
  static mapTotal + #192, #768
  static mapTotal + #193, #768
  static mapTotal + #194, #2560
  static mapTotal + #195, #2560
  static mapTotal + #196, #2560
  static mapTotal + #197, #2560
  static mapTotal + #198, #2560
  static mapTotal + #199, #2560

  ;Linha 5
  static mapTotal + #200, #2560
  static mapTotal + #201, #2560
  static mapTotal + #202, #2560
  static mapTotal + #203, #2560
  static mapTotal + #204, #2560
  static mapTotal + #205, #2560
  static mapTotal + #206, #2560
  static mapTotal + #207, #2560
  static mapTotal + #208, #2560
  static mapTotal + #209, #2560
  static mapTotal + #210, #2560
  static mapTotal + #211, #2560
  static mapTotal + #212, #256
  static mapTotal + #213, #256
  static mapTotal + #214, #256
  static mapTotal + #215, #2560
  static mapTotal + #216, #2560
  static mapTotal + #217, #2560
  static mapTotal + #218, #2560
  static mapTotal + #219, #2560
  static mapTotal + #220, #2560
  static mapTotal + #221, #768
  static mapTotal + #222, #768
  static mapTotal + #223, #768
  static mapTotal + #224, #768
  static mapTotal + #225, #2560
  static mapTotal + #226, #2560
  static mapTotal + #227, #2560
  static mapTotal + #228, #2560
  static mapTotal + #229, #768
  static mapTotal + #230, #768
  static mapTotal + #231, #768
  static mapTotal + #232, #768
  static mapTotal + #233, #2560
  static mapTotal + #234, #2560
  static mapTotal + #235, #2560
  static mapTotal + #236, #2560
  static mapTotal + #237, #2560
  static mapTotal + #238, #2560
  static mapTotal + #239, #2560

  ;Linha 6
  static mapTotal + #240, #2560
  static mapTotal + #241, #2560
  static mapTotal + #242, #768
  static mapTotal + #243, #768
  static mapTotal + #244, #768
  static mapTotal + #245, #768
  static mapTotal + #246, #2560
  static mapTotal + #247, #2560
  static mapTotal + #248, #2560
  static mapTotal + #249, #2560
  static mapTotal + #250, #768
  static mapTotal + #251, #768
  static mapTotal + #252, #256
  static mapTotal + #253, #256
  static mapTotal + #254, #256
  static mapTotal + #255, #768
  static mapTotal + #256, #768
  static mapTotal + #257, #768
  static mapTotal + #258, #768
  static mapTotal + #259, #768
  static mapTotal + #260, #768
  static mapTotal + #261, #768
  static mapTotal + #262, #768
  static mapTotal + #263, #768
  static mapTotal + #264, #768
  static mapTotal + #265, #768
  static mapTotal + #266, #768
  static mapTotal + #267, #2560
  static mapTotal + #268, #2560
  static mapTotal + #269, #2560
  static mapTotal + #270, #256
  static mapTotal + #271, #256
  static mapTotal + #272, #2560
  static mapTotal + #273, #2560
  static mapTotal + #274, #2560
  static mapTotal + #275, #2560
  static mapTotal + #276, #2560
  static mapTotal + #277, #2560
  static mapTotal + #278, #2560
  static mapTotal + #279, #2560

  ;Linha 7
  static mapTotal + #280, #2560
  static mapTotal + #281, #768
  static mapTotal + #282, #768
  static mapTotal + #283, #768
  static mapTotal + #284, #768
  static mapTotal + #285, #768
  static mapTotal + #286, #768
  static mapTotal + #287, #2560
  static mapTotal + #288, #2560
  static mapTotal + #289, #768
  static mapTotal + #290, #768
  static mapTotal + #291, #768
  static mapTotal + #292, #768
  static mapTotal + #293, #256
  static mapTotal + #294, #768
  static mapTotal + #295, #768
  static mapTotal + #296, #768
  static mapTotal + #297, #768
  static mapTotal + #298, #768
  static mapTotal + #299, #768
  static mapTotal + #300, #768
  static mapTotal + #301, #768
  static mapTotal + #302, #768
  static mapTotal + #303, #768
  static mapTotal + #304, #768
  static mapTotal + #305, #768
  static mapTotal + #306, #768
  static mapTotal + #307, #768
  static mapTotal + #308, #2560
  static mapTotal + #309, #2560
  static mapTotal + #310, #256
  static mapTotal + #311, #256
  static mapTotal + #312, #2560
  static mapTotal + #313, #2560
  static mapTotal + #314, #2560
  static mapTotal + #315, #2560
  static mapTotal + #316, #2560
  static mapTotal + #317, #2560
  static mapTotal + #318, #2560
  static mapTotal + #319, #2560

  ;Linha 8
  static mapTotal + #320, #768
  static mapTotal + #321, #768
  static mapTotal + #322, #768
  static mapTotal + #323, #768
  static mapTotal + #324, #768
  static mapTotal + #325, #768
  static mapTotal + #326, #768
  static mapTotal + #327, #768
  static mapTotal + #328, #2560
  static mapTotal + #329, #768
  static mapTotal + #330, #768
  static mapTotal + #331, #768
  static mapTotal + #332, #768
  static mapTotal + #333, #768
  static mapTotal + #334, #768
  static mapTotal + #335, #768
  static mapTotal + #336, #768
  static mapTotal + #337, #768
  static mapTotal + #338, #768
  static mapTotal + #339, #768
  static mapTotal + #340, #768
  static mapTotal + #341, #768
  static mapTotal + #342, #768
  static mapTotal + #343, #768
  static mapTotal + #344, #768
  static mapTotal + #345, #768
  static mapTotal + #346, #768
  static mapTotal + #347, #768
  static mapTotal + #348, #2560
  static mapTotal + #349, #2560
  static mapTotal + #350, #256
  static mapTotal + #351, #256
  static mapTotal + #352, #2560
  static mapTotal + #353, #2560
  static mapTotal + #354, #2560
  static mapTotal + #355, #2560
  static mapTotal + #356, #2560
  static mapTotal + #357, #2560
  static mapTotal + #358, #2560
  static mapTotal + #359, #2560

  ;Linha 9
  static mapTotal + #360, #768
  static mapTotal + #361, #768
  static mapTotal + #362, #768
  static mapTotal + #363, #768
  static mapTotal + #364, #768
  static mapTotal + #365, #768
  static mapTotal + #366, #768
  static mapTotal + #367, #768
  static mapTotal + #368, #2560
  static mapTotal + #369, #768
  static mapTotal + #370, #768
  static mapTotal + #371, #768
  static mapTotal + #372, #768
  static mapTotal + #373, #2304
  static mapTotal + #374, #768
  static mapTotal + #375, #768
  static mapTotal + #376, #768
  static mapTotal + #377, #768
  static mapTotal + #378, #768
  static mapTotal + #379, #768
  static mapTotal + #380, #768
  static mapTotal + #381, #768
  static mapTotal + #382, #768
  static mapTotal + #383, #768
  static mapTotal + #384, #768
  static mapTotal + #385, #768
  static mapTotal + #386, #768
  static mapTotal + #387, #768
  static mapTotal + #388, #2560
  static mapTotal + #389, #2560
  static mapTotal + #390, #256
  static mapTotal + #391, #256
  static mapTotal + #392, #2560
  static mapTotal + #393, #2560
  static mapTotal + #394, #2560
  static mapTotal + #395, #2560
  static mapTotal + #396, #2560
  static mapTotal + #397, #2560
  static mapTotal + #398, #2560
  static mapTotal + #399, #2560

  ;Linha 10
  static mapTotal + #400, #2560
  static mapTotal + #401, #768
  static mapTotal + #402, #768
  static mapTotal + #403, #768
  static mapTotal + #404, #768
  static mapTotal + #405, #768
  static mapTotal + #406, #768
  static mapTotal + #407, #2560
  static mapTotal + #408, #2560
  static mapTotal + #409, #2560
  static mapTotal + #410, #768
  static mapTotal + #411, #768
  static mapTotal + #412, #2304
  static mapTotal + #413, #2816
  static mapTotal + #414, #2304
  static mapTotal + #415, #768
  static mapTotal + #416, #768
  static mapTotal + #417, #768
  static mapTotal + #418, #768
  static mapTotal + #419, #768
  static mapTotal + #420, #768
  static mapTotal + #421, #768
  static mapTotal + #422, #768
  static mapTotal + #423, #768
  static mapTotal + #424, #768
  static mapTotal + #425, #768
  static mapTotal + #426, #768
  static mapTotal + #427, #2560
  static mapTotal + #428, #2560
  static mapTotal + #429, #2560
  static mapTotal + #430, #256
  static mapTotal + #431, #256
  static mapTotal + #432, #2560
  static mapTotal + #433, #2560
  static mapTotal + #434, #768
  static mapTotal + #435, #2560
  static mapTotal + #436, #2560
  static mapTotal + #437, #2560
  static mapTotal + #438, #2560
  static mapTotal + #439, #2560

  ;Linha 11
  static mapTotal + #440, #2560
  static mapTotal + #441, #2560
  static mapTotal + #442, #768
  static mapTotal + #443, #768
  static mapTotal + #444, #768
  static mapTotal + #445, #768
  static mapTotal + #446, #2560
  static mapTotal + #447, #2560
  static mapTotal + #448, #2560
  static mapTotal + #449, #2560
  static mapTotal + #450, #1024
  static mapTotal + #451, #256
  static mapTotal + #452, #768
  static mapTotal + #453, #2304
  static mapTotal + #454, #1280
  static mapTotal + #455, #2816
  static mapTotal + #456, #256
  static mapTotal + #457, #256
  static mapTotal + #458, #1280
  static mapTotal + #459, #2816
  static mapTotal + #460, #768
  static mapTotal + #461, #768
  static mapTotal + #462, #768
  static mapTotal + #463, #768
  static mapTotal + #464, #768
  static mapTotal + #465, #768
  static mapTotal + #466, #2560
  static mapTotal + #467, #2560
  static mapTotal + #468, #2560
  static mapTotal + #469, #2560
  static mapTotal + #470, #256
  static mapTotal + #471, #256
  static mapTotal + #472, #2560
  static mapTotal + #473, #768
  static mapTotal + #474, #768
  static mapTotal + #475, #768
  static mapTotal + #476, #2560
  static mapTotal + #477, #2560
  static mapTotal + #478, #2560
  static mapTotal + #479, #2560

  ;Linha 12
  static mapTotal + #480, #2560
  static mapTotal + #481, #2560
  static mapTotal + #482, #2560
  static mapTotal + #483, #256
  static mapTotal + #484, #256
  static mapTotal + #485, #2560
  static mapTotal + #486, #2560
  static mapTotal + #487, #1792
  static mapTotal + #488, #768
  static mapTotal + #489, #1024
  static mapTotal + #490, #2816
  static mapTotal + #491, #1024
  static mapTotal + #492, #1536
  static mapTotal + #493, #768
  static mapTotal + #494, #2560
  static mapTotal + #495, #256
  static mapTotal + #496, #256
  static mapTotal + #497, #2560
  static mapTotal + #498, #2560
  static mapTotal + #499, #1280
  static mapTotal + #500, #256
  static mapTotal + #501, #256
  static mapTotal + #502, #1792
  static mapTotal + #503, #2560
  static mapTotal + #504, #256
  static mapTotal + #505, #256
  static mapTotal + #506, #2560
  static mapTotal + #507, #2560
  static mapTotal + #508, #2560
  static mapTotal + #509, #2560
  static mapTotal + #510, #256
  static mapTotal + #511, #256
  static mapTotal + #512, #2560
  static mapTotal + #513, #256
  static mapTotal + #514, #256
  static mapTotal + #515, #768
  static mapTotal + #516, #2560
  static mapTotal + #517, #2560
  static mapTotal + #518, #2560
  static mapTotal + #519, #2560

  ;Linha 13
  static mapTotal + #520, #2560
  static mapTotal + #521, #2560
  static mapTotal + #522, #2560
  static mapTotal + #523, #256
  static mapTotal + #524, #256
  static mapTotal + #525, #2560
  static mapTotal + #526, #1792
  static mapTotal + #527, #2816
  static mapTotal + #528, #1792
  static mapTotal + #529, #1280
  static mapTotal + #530, #1024
  static mapTotal + #531, #1536
  static mapTotal + #532, #2816
  static mapTotal + #533, #1536
  static mapTotal + #534, #768
  static mapTotal + #535, #2560
  static mapTotal + #536, #2560
  static mapTotal + #537, #2560
  static mapTotal + #538, #2560
  static mapTotal + #539, #2560
  static mapTotal + #540, #256
  static mapTotal + #541, #256
  static mapTotal + #542, #2560
  static mapTotal + #543, #2560
  static mapTotal + #544, #256
  static mapTotal + #545, #256
  static mapTotal + #546, #2560
  static mapTotal + #547, #2560
  static mapTotal + #548, #2560
  static mapTotal + #549, #2560
  static mapTotal + #550, #256
  static mapTotal + #551, #256
  static mapTotal + #552, #2560
  static mapTotal + #553, #256
  static mapTotal + #554, #256
  static mapTotal + #555, #2560
  static mapTotal + #556, #2560
  static mapTotal + #557, #2560
  static mapTotal + #558, #2560
  static mapTotal + #559, #2560

  ;Linha 14
  static mapTotal + #560, #2560
  static mapTotal + #561, #2560
  static mapTotal + #562, #2560
  static mapTotal + #563, #256
  static mapTotal + #564, #256
  static mapTotal + #565, #2560
  static mapTotal + #566, #768
  static mapTotal + #567, #1792
  static mapTotal + #568, #1280
  static mapTotal + #569, #2816
  static mapTotal + #570, #1280
  static mapTotal + #571, #768
  static mapTotal + #572, #1536
  static mapTotal + #573, #768
  static mapTotal + #574, #2560
  static mapTotal + #575, #2560
  static mapTotal + #576, #2560
  static mapTotal + #577, #2560
  static mapTotal + #578, #2560
  static mapTotal + #579, #2560
  static mapTotal + #580, #256
  static mapTotal + #581, #256
  static mapTotal + #582, #2560
  static mapTotal + #583, #2560
  static mapTotal + #584, #2560
  static mapTotal + #585, #2560
  static mapTotal + #586, #2560
  static mapTotal + #587, #2560
  static mapTotal + #588, #2560
  static mapTotal + #589, #2560
  static mapTotal + #590, #2560
  static mapTotal + #591, #2560
  static mapTotal + #592, #2560
  static mapTotal + #593, #256
  static mapTotal + #594, #256
  static mapTotal + #595, #2560
  static mapTotal + #596, #2560
  static mapTotal + #597, #2560
  static mapTotal + #598, #2560
  static mapTotal + #599, #2560

  ;Linha 15
  static mapTotal + #600, #2560
  static mapTotal + #601, #2560
  static mapTotal + #602, #2560
  static mapTotal + #603, #256
  static mapTotal + #604, #256
  static mapTotal + #605, #2560
  static mapTotal + #606, #2560
  static mapTotal + #607, #768
  static mapTotal + #608, #768
  static mapTotal + #609, #1280
  static mapTotal + #610, #768
  static mapTotal + #611, #2560
  static mapTotal + #612, #2560
  static mapTotal + #613, #2560
  static mapTotal + #614, #2560
  static mapTotal + #615, #2560
  static mapTotal + #616, #2560
  static mapTotal + #617, #2560
  static mapTotal + #618, #2560
  static mapTotal + #619, #2560
  static mapTotal + #620, #256
  static mapTotal + #621, #256
  static mapTotal + #622, #2560
  static mapTotal + #623, #2560
  static mapTotal + #624, #2560
  static mapTotal + #625, #2560
  static mapTotal + #626, #2560
  static mapTotal + #627, #2560
  static mapTotal + #628, #2560
  static mapTotal + #629, #2560
  static mapTotal + #630, #2560
  static mapTotal + #631, #2560
  static mapTotal + #632, #2560
  static mapTotal + #633, #256
  static mapTotal + #634, #256
  static mapTotal + #635, #2560
  static mapTotal + #636, #2560
  static mapTotal + #637, #2560
  static mapTotal + #638, #2560
  static mapTotal + #639, #2560

  ;Linha 16
  static mapTotal + #640, #2560
  static mapTotal + #641, #2560
  static mapTotal + #642, #2560
  static mapTotal + #643, #2560
  static mapTotal + #644, #2560
  static mapTotal + #645, #2560
  static mapTotal + #646, #2560
  static mapTotal + #647, #2560
  static mapTotal + #648, #2560
  static mapTotal + #649, #2560
  static mapTotal + #650, #2560
  static mapTotal + #651, #2560
  static mapTotal + #652, #2560
  static mapTotal + #653, #2560
  static mapTotal + #654, #2560
  static mapTotal + #655, #2560
  static mapTotal + #656, #2560
  static mapTotal + #657, #2560
  static mapTotal + #658, #2560
  static mapTotal + #659, #2560
  static mapTotal + #660, #2560
  static mapTotal + #661, #2560
  static mapTotal + #662, #2560
  static mapTotal + #663, #2560
  static mapTotal + #664, #2560
  static mapTotal + #665, #2560
  static mapTotal + #666, #2560
  static mapTotal + #667, #2560
  static mapTotal + #668, #2560
  static mapTotal + #669, #2560
  static mapTotal + #670, #2560
  static mapTotal + #671, #2560
  static mapTotal + #672, #2560
  static mapTotal + #673, #2560
  static mapTotal + #674, #2560
  static mapTotal + #675, #2560
  static mapTotal + #676, #2560
  static mapTotal + #677, #2560
  static mapTotal + #678, #2560
  static mapTotal + #679, #2560

  ;Linha 17
  static mapTotal + #680, #2560
  static mapTotal + #681, #2560
  static mapTotal + #682, #2560
  static mapTotal + #683, #2560
  static mapTotal + #684, #2560
  static mapTotal + #685, #2560
  static mapTotal + #686, #2560
  static mapTotal + #687, #2560
  static mapTotal + #688, #2560
  static mapTotal + #689, #2560
  static mapTotal + #690, #2560
  static mapTotal + #691, #2560
  static mapTotal + #692, #2560
  static mapTotal + #693, #2560
  static mapTotal + #694, #2560
  static mapTotal + #695, #2560
  static mapTotal + #696, #2560
  static mapTotal + #697, #2560
  static mapTotal + #698, #2560
  static mapTotal + #699, #2560
  static mapTotal + #700, #2560
  static mapTotal + #701, #2560
  static mapTotal + #702, #2560
  static mapTotal + #703, #2560
  static mapTotal + #704, #2560
  static mapTotal + #705, #2560
  static mapTotal + #706, #2560
  static mapTotal + #707, #2560
  static mapTotal + #708, #2560
  static mapTotal + #709, #2560
  static mapTotal + #710, #2560
  static mapTotal + #711, #2560
  static mapTotal + #712, #2560
  static mapTotal + #713, #2560
  static mapTotal + #714, #2560
  static mapTotal + #715, #2560
  static mapTotal + #716, #2560
  static mapTotal + #717, #2560
  static mapTotal + #718, #2560
  static mapTotal + #719, #2560

  ;Linha 18
  static mapTotal + #720, #2560
  static mapTotal + #721, #2560
  static mapTotal + #722, #2560
  static mapTotal + #723, #2560
  static mapTotal + #724, #2560
  static mapTotal + #725, #2560
  static mapTotal + #726, #2560
  static mapTotal + #727, #2560
  static mapTotal + #728, #2560
  static mapTotal + #729, #2560
  static mapTotal + #730, #2560
  static mapTotal + #731, #2560
  static mapTotal + #732, #2560
  static mapTotal + #733, #2560
  static mapTotal + #734, #2560
  static mapTotal + #735, #2560
  static mapTotal + #736, #2560
  static mapTotal + #737, #2560
  static mapTotal + #738, #2560
  static mapTotal + #739, #2560
  static mapTotal + #740, #2560
  static mapTotal + #741, #2560
  static mapTotal + #742, #2560
  static mapTotal + #743, #2560
  static mapTotal + #744, #2560
  static mapTotal + #745, #2560
  static mapTotal + #746, #2560
  static mapTotal + #747, #2560
  static mapTotal + #748, #2560
  static mapTotal + #749, #2560
  static mapTotal + #750, #2560
  static mapTotal + #751, #2560
  static mapTotal + #752, #2560
  static mapTotal + #753, #2560
  static mapTotal + #754, #2560
  static mapTotal + #755, #2560
  static mapTotal + #756, #2560
  static mapTotal + #757, #2560
  static mapTotal + #758, #2560
  static mapTotal + #759, #2560

  ;Linha 19
  static mapTotal + #760, #2560
  static mapTotal + #761, #2560
  static mapTotal + #762, #2560
  static mapTotal + #763, #2560
  static mapTotal + #764, #2560
  static mapTotal + #765, #2560
  static mapTotal + #766, #2560
  static mapTotal + #767, #2560
  static mapTotal + #768, #2560
  static mapTotal + #769, #2560
  static mapTotal + #770, #2560
  static mapTotal + #771, #2560
  static mapTotal + #772, #2560
  static mapTotal + #773, #2560
  static mapTotal + #774, #2560
  static mapTotal + #775, #2560
  static mapTotal + #776, #2560
  static mapTotal + #777, #2560
  static mapTotal + #778, #2560
  static mapTotal + #779, #2560
  static mapTotal + #780, #2560
  static mapTotal + #781, #2560
  static mapTotal + #782, #2560
  static mapTotal + #783, #2560
  static mapTotal + #784, #2560
  static mapTotal + #785, #2560
  static mapTotal + #786, #2560
  static mapTotal + #787, #2560
  static mapTotal + #788, #2560
  static mapTotal + #789, #2560
  static mapTotal + #790, #2560
  static mapTotal + #791, #2560
  static mapTotal + #792, #2560
  static mapTotal + #793, #2560
  static mapTotal + #794, #2560
  static mapTotal + #795, #2560
  static mapTotal + #796, #2560
  static mapTotal + #797, #2560
  static mapTotal + #798, #2560
  static mapTotal + #799, #2560

  ;Linha 20
  static mapTotal + #800, #256
  static mapTotal + #801, #2560
  static mapTotal + #802, #2560
  static mapTotal + #803, #256
  static mapTotal + #804, #256
  static mapTotal + #805, #256
  static mapTotal + #806, #256
  static mapTotal + #807, #256
  static mapTotal + #808, #256
  static mapTotal + #809, #256
  static mapTotal + #810, #256
  static mapTotal + #811, #256
  static mapTotal + #812, #256
  static mapTotal + #813, #2560
  static mapTotal + #814, #2560
  static mapTotal + #815, #256
  static mapTotal + #816, #256
  static mapTotal + #817, #256
  static mapTotal + #818, #256
  static mapTotal + #819, #256
  static mapTotal + #820, #256
  static mapTotal + #821, #256
  static mapTotal + #822, #256
  static mapTotal + #823, #256
  static mapTotal + #824, #256
  static mapTotal + #825, #2560
  static mapTotal + #826, #2560
  static mapTotal + #827, #256
  static mapTotal + #828, #256
  static mapTotal + #829, #256
  static mapTotal + #830, #256
  static mapTotal + #831, #256
  static mapTotal + #832, #256
  static mapTotal + #833, #256
  static mapTotal + #834, #256
  static mapTotal + #835, #256
  static mapTotal + #836, #256
  static mapTotal + #837, #256
  static mapTotal + #838, #2560
  static mapTotal + #839, #2560

  ;Linha 21
  static mapTotal + #840, #2560
  static mapTotal + #841, #2560
  static mapTotal + #842, #2560
  static mapTotal + #843, #2560
  static mapTotal + #844, #2560
  static mapTotal + #845, #2560
  static mapTotal + #846, #2560
  static mapTotal + #847, #2560
  static mapTotal + #848, #2560
  static mapTotal + #849, #2560
  static mapTotal + #850, #2560
  static mapTotal + #851, #2560
  static mapTotal + #852, #2560
  static mapTotal + #853, #2560
  static mapTotal + #854, #2560
  static mapTotal + #855, #2560
  static mapTotal + #856, #2560
  static mapTotal + #857, #2560
  static mapTotal + #858, #2560
  static mapTotal + #859, #2560
  static mapTotal + #860, #2560
  static mapTotal + #861, #2560
  static mapTotal + #862, #2560
  static mapTotal + #863, #2560
  static mapTotal + #864, #2560
  static mapTotal + #865, #2560
  static mapTotal + #866, #2560
  static mapTotal + #867, #2560
  static mapTotal + #868, #2560
  static mapTotal + #869, #2560
  static mapTotal + #870, #2560
  static mapTotal + #871, #2560
  static mapTotal + #872, #2560
  static mapTotal + #873, #2560
  static mapTotal + #874, #2560
  static mapTotal + #875, #2560
  static mapTotal + #876, #2560
  static mapTotal + #877, #2560
  static mapTotal + #878, #2560
  static mapTotal + #879, #2560

  ;Linha 22
  static mapTotal + #880, #2560
  static mapTotal + #881, #2560
  static mapTotal + #882, #2560
  static mapTotal + #883, #2560
  static mapTotal + #884, #2560
  static mapTotal + #885, #2560
  static mapTotal + #886, #2560
  static mapTotal + #887, #2560
  static mapTotal + #888, #2560
  static mapTotal + #889, #2560
  static mapTotal + #890, #2560
  static mapTotal + #891, #2560
  static mapTotal + #892, #2560
  static mapTotal + #893, #2560
  static mapTotal + #894, #2560
  static mapTotal + #895, #2560
  static mapTotal + #896, #2560
  static mapTotal + #897, #2560
  static mapTotal + #898, #2560
  static mapTotal + #899, #2560
  static mapTotal + #900, #2560
  static mapTotal + #901, #2560
  static mapTotal + #902, #2560
  static mapTotal + #903, #2560
  static mapTotal + #904, #2560
  static mapTotal + #905, #2560
  static mapTotal + #906, #2560
  static mapTotal + #907, #2560
  static mapTotal + #908, #2560
  static mapTotal + #909, #2560
  static mapTotal + #910, #2560
  static mapTotal + #911, #2560
  static mapTotal + #912, #2560
  static mapTotal + #913, #2560
  static mapTotal + #914, #2560
  static mapTotal + #915, #2560
  static mapTotal + #916, #2560
  static mapTotal + #917, #2560
  static mapTotal + #918, #2560
  static mapTotal + #919, #2560

  ;Linha 23
  static mapTotal + #920, #2560
  static mapTotal + #921, #2560
  static mapTotal + #922, #2560
  static mapTotal + #923, #2048
  static mapTotal + #924, #2048
  static mapTotal + #925, #256
  static mapTotal + #926, #256
  static mapTotal + #927, #2048
  static mapTotal + #928, #2560
  static mapTotal + #929, #2560
  static mapTotal + #930, #2048
  static mapTotal + #931, #2048
  static mapTotal + #932, #2048
  static mapTotal + #933, #2560
  static mapTotal + #934, #2560
  static mapTotal + #935, #256
  static mapTotal + #936, #256
  static mapTotal + #937, #256
  static mapTotal + #938, #256
  static mapTotal + #939, #256
  static mapTotal + #940, #256
  static mapTotal + #941, #256
  static mapTotal + #942, #256
  static mapTotal + #943, #256
  static mapTotal + #944, #256
  static mapTotal + #945, #256
  static mapTotal + #946, #256
  static mapTotal + #947, #256
  static mapTotal + #948, #256
  static mapTotal + #949, #256
  static mapTotal + #950, #256
  static mapTotal + #951, #2048
  static mapTotal + #952, #2048
  static mapTotal + #953, #2048
  static mapTotal + #954, #2048
  static mapTotal + #955, #2560
  static mapTotal + #956, #2560
  static mapTotal + #957, #2048
  static mapTotal + #958, #2560
  static mapTotal + #959, #2560

  ;Linha 24
  static mapTotal + #960, #2560
  static mapTotal + #961, #2560
  static mapTotal + #962, #2560
  static mapTotal + #963, #2048
  static mapTotal + #964, #2560
  static mapTotal + #965, #2560
  static mapTotal + #966, #2560
  static mapTotal + #967, #2560
  static mapTotal + #968, #2560
  static mapTotal + #969, #2560
  static mapTotal + #970, #2560
  static mapTotal + #971, #2560
  static mapTotal + #972, #2560
  static mapTotal + #973, #2560
  static mapTotal + #974, #2560
  static mapTotal + #975, #2560
  static mapTotal + #976, #2560
  static mapTotal + #977, #2560
  static mapTotal + #978, #2560
  static mapTotal + #979, #2560
  static mapTotal + #980, #2560
  static mapTotal + #981, #2560
  static mapTotal + #982, #2560
  static mapTotal + #983, #2560
  static mapTotal + #984, #2560
  static mapTotal + #985, #2560
  static mapTotal + #986, #2560
  static mapTotal + #987, #2560
  static mapTotal + #988, #2560
  static mapTotal + #989, #2560
  static mapTotal + #990, #2560
  static mapTotal + #991, #2560
  static mapTotal + #992, #2560
  static mapTotal + #993, #2560
  static mapTotal + #994, #2560
  static mapTotal + #995, #2560
  static mapTotal + #996, #2560
  static mapTotal + #997, #2048
  static mapTotal + #998, #2560
  static mapTotal + #999, #2560

  ;Linha 25
  static mapTotal + #1000, #2560
  static mapTotal + #1001, #2560
  static mapTotal + #1002, #2560
  static mapTotal + #1003, #2048
  static mapTotal + #1004, #2560
  static mapTotal + #1005, #2560
  static mapTotal + #1006, #2560
  static mapTotal + #1007, #2560
  static mapTotal + #1008, #2560
  static mapTotal + #1009, #2560
  static mapTotal + #1010, #2560
  static mapTotal + #1011, #2560
  static mapTotal + #1012, #2560
  static mapTotal + #1013, #2560
  static mapTotal + #1014, #2560
  static mapTotal + #1015, #2560
  static mapTotal + #1016, #2560
  static mapTotal + #1017, #2560
  static mapTotal + #1018, #2560
  static mapTotal + #1019, #2560
  static mapTotal + #1020, #2560
  static mapTotal + #1021, #2560
  static mapTotal + #1022, #2560
  static mapTotal + #1023, #2560
  static mapTotal + #1024, #2560
  static mapTotal + #1025, #2560
  static mapTotal + #1026, #2560
  static mapTotal + #1027, #2560
  static mapTotal + #1028, #2560
  static mapTotal + #1029, #2560
  static mapTotal + #1030, #2560
  static mapTotal + #1031, #2560
  static mapTotal + #1032, #2560
  static mapTotal + #1033, #2560
  static mapTotal + #1034, #2560
  static mapTotal + #1035, #2560
  static mapTotal + #1036, #2560
  static mapTotal + #1037, #256
  static mapTotal + #1038, #2560
  static mapTotal + #1039, #2560

  ;Linha 26
  static mapTotal + #1040, #2560
  static mapTotal + #1041, #2560
  static mapTotal + #1042, #2560
  static mapTotal + #1043, #2048
  static mapTotal + #1044, #2560
  static mapTotal + #1045, #2560
  static mapTotal + #1046, #2560
  static mapTotal + #1047, #2048
  static mapTotal + #1048, #2048
  static mapTotal + #1049, #256
  static mapTotal + #1050, #2048
  static mapTotal + #1051, #2048
  static mapTotal + #1052, #2048
  static mapTotal + #1053, #2048
  static mapTotal + #1054, #2048
  static mapTotal + #1055, #2048
  static mapTotal + #1056, #2560
  static mapTotal + #1057, #2560
  static mapTotal + #1058, #2560
  static mapTotal + #1059, #2048
  static mapTotal + #1060, #2048
  static mapTotal + #1061, #2048
  static mapTotal + #1062, #2048
  static mapTotal + #1063, #2560
  static mapTotal + #1064, #2560
  static mapTotal + #1065, #2048
  static mapTotal + #1066, #2048
  static mapTotal + #1067, #2048
  static mapTotal + #1068, #2048
  static mapTotal + #1069, #2048
  static mapTotal + #1070, #2560
  static mapTotal + #1071, #2560
  static mapTotal + #1072, #2048
  static mapTotal + #1073, #768
  static mapTotal + #1074, #2048
  static mapTotal + #1075, #2048
  static mapTotal + #1076, #2048
  static mapTotal + #1077, #256
  static mapTotal + #1078, #2560
  static mapTotal + #1079, #2560

  ;Linha 27
  static mapTotal + #1080, #2560
  static mapTotal + #1081, #2560
  static mapTotal + #1082, #2560
  static mapTotal + #1083, #2048
  static mapTotal + #1084, #2560
  static mapTotal + #1085, #2560
  static mapTotal + #1086, #2560
  static mapTotal + #1087, #2560
  static mapTotal + #1088, #2560
  static mapTotal + #1089, #2560
  static mapTotal + #1090, #2560
  static mapTotal + #1091, #2560
  static mapTotal + #1092, #2560
  static mapTotal + #1093, #2560
  static mapTotal + #1094, #2560
  static mapTotal + #1095, #2560
  static mapTotal + #1096, #2560
  static mapTotal + #1097, #2560
  static mapTotal + #1098, #2560
  static mapTotal + #1099, #2560
  static mapTotal + #1100, #2560
  static mapTotal + #1101, #2560
  static mapTotal + #1102, #2048
  static mapTotal + #1103, #2560
  static mapTotal + #1104, #2560
  static mapTotal + #1105, #256
  static mapTotal + #1106, #768
  static mapTotal + #1107, #256
  static mapTotal + #1108, #768
  static mapTotal + #1109, #2048
  static mapTotal + #1110, #2560
  static mapTotal + #1111, #2560
  static mapTotal + #1112, #2560
  static mapTotal + #1113, #2560
  static mapTotal + #1114, #2560
  static mapTotal + #1115, #2560
  static mapTotal + #1116, #2560
  static mapTotal + #1117, #2560
  static mapTotal + #1118, #2560
  static mapTotal + #1119, #2560

  ;Linha 28
  static mapTotal + #1120, #2560
  static mapTotal + #1121, #2560
  static mapTotal + #1122, #2560
  static mapTotal + #1123, #2048
  static mapTotal + #1124, #2560
  static mapTotal + #1125, #2560
  static mapTotal + #1126, #2560
  static mapTotal + #1127, #2560
  static mapTotal + #1128, #2560
  static mapTotal + #1129, #2560
  static mapTotal + #1130, #2560
  static mapTotal + #1131, #2560
  static mapTotal + #1132, #2560
  static mapTotal + #1133, #2560
  static mapTotal + #1134, #2560
  static mapTotal + #1135, #2560
  static mapTotal + #1136, #2560
  static mapTotal + #1137, #2560
  static mapTotal + #1138, #2560
  static mapTotal + #1139, #2560
  static mapTotal + #1140, #2560
  static mapTotal + #1141, #2560
  static mapTotal + #1142, #2048
  static mapTotal + #1143, #2560
  static mapTotal + #1144, #2560
  static mapTotal + #1145, #2560
  static mapTotal + #1146, #2560
  static mapTotal + #1147, #2560
  static mapTotal + #1148, #2560
  static mapTotal + #1149, #2048
  static mapTotal + #1150, #2560
  static mapTotal + #1151, #2560
  static mapTotal + #1152, #2560
  static mapTotal + #1153, #2560
  static mapTotal + #1154, #2560
  static mapTotal + #1155, #2560
  static mapTotal + #1156, #2560
  static mapTotal + #1157, #2560
  static mapTotal + #1158, #2560
  static mapTotal + #1159, #2560

  ;Linha 29
  static mapTotal + #1160, #2560
  static mapTotal + #1161, #2560
  static mapTotal + #1162, #2560
  static mapTotal + #1163, #2048
  static mapTotal + #1164, #2560
  static mapTotal + #1165, #2560
  static mapTotal + #1166, #2560
  static mapTotal + #1167, #2816
  static mapTotal + #1168, #2816
  static mapTotal + #1169, #2816
  static mapTotal + #1170, #2816
  static mapTotal + #1171, #2816
  static mapTotal + #1172, #2816
  static mapTotal + #1173, #2560
  static mapTotal + #1174, #2560
  static mapTotal + #1175, #2560
  static mapTotal + #1176, #256
  static mapTotal + #1177, #2560
  static mapTotal + #1178, #2560
  static mapTotal + #1179, #2048
  static mapTotal + #1180, #2560
  static mapTotal + #1181, #2560
  static mapTotal + #1182, #2048
  static mapTotal + #1183, #2560
  static mapTotal + #1184, #2560
  static mapTotal + #1185, #2560
  static mapTotal + #1186, #2560
  static mapTotal + #1187, #2560
  static mapTotal + #1188, #2560
  static mapTotal + #1189, #2048
  static mapTotal + #1190, #2560
  static mapTotal + #1191, #2560
  static mapTotal + #1192, #2560
  static mapTotal + #1193, #2560
  static mapTotal + #1194, #2560
  static mapTotal + #1195, #2560
  static mapTotal + #1196, #2560
  static mapTotal + #1197, #2560
  static mapTotal + #1198, #2560
  static mapTotal + #1199, #2560

  ;Linha 30
  static mapTotal + #1200, #2560
  static mapTotal + #1201, #2560
  static mapTotal + #1202, #2560
  static mapTotal + #1203, #2048
  static mapTotal + #1204, #2560
  static mapTotal + #1205, #2560
  static mapTotal + #1206, #2816
  static mapTotal + #1207, #256
  static mapTotal + #1208, #2816
  static mapTotal + #1209, #2816
  static mapTotal + #1210, #2816
  static mapTotal + #1211, #2816
  static mapTotal + #1212, #2816
  static mapTotal + #1213, #2816
  static mapTotal + #1214, #2560
  static mapTotal + #1215, #2560
  static mapTotal + #1216, #256
  static mapTotal + #1217, #2560
  static mapTotal + #1218, #2560
  static mapTotal + #1219, #2048
  static mapTotal + #1220, #2560
  static mapTotal + #1221, #2560
  static mapTotal + #1222, #2048
  static mapTotal + #1223, #2048
  static mapTotal + #1224, #2048
  static mapTotal + #1225, #2048
  static mapTotal + #1226, #2048
  static mapTotal + #1227, #2560
  static mapTotal + #1228, #2560
  static mapTotal + #1229, #2048
  static mapTotal + #1230, #2048
  static mapTotal + #1231, #2048
  static mapTotal + #1232, #2048
  static mapTotal + #1233, #2048
  static mapTotal + #1234, #2048
  static mapTotal + #1235, #2560
  static mapTotal + #1236, #2560
  static mapTotal + #1237, #2048
  static mapTotal + #1238, #2560
  static mapTotal + #1239, #2560

  ;Linha 31
  static mapTotal + #1240, #2560
  static mapTotal + #1241, #2560
  static mapTotal + #1242, #2560
  static mapTotal + #1243, #2048
  static mapTotal + #1244, #2560
  static mapTotal + #1245, #2560
  static mapTotal + #1246, #2816
  static mapTotal + #1247, #256
  static mapTotal + #1248, #2816
  static mapTotal + #1249, #256
  static mapTotal + #1250, #2816
  static mapTotal + #1251, #2816
  static mapTotal + #1252, #256
  static mapTotal + #1253, #2816
  static mapTotal + #1254, #2560
  static mapTotal + #1255, #2560
  static mapTotal + #1256, #256
  static mapTotal + #1257, #2560
  static mapTotal + #1258, #2560
  static mapTotal + #1259, #2048
  static mapTotal + #1260, #2560
  static mapTotal + #1261, #2560
  static mapTotal + #1262, #2560
  static mapTotal + #1263, #2560
  static mapTotal + #1264, #2560
  static mapTotal + #1265, #2560
  static mapTotal + #1266, #768
  static mapTotal + #1267, #2560
  static mapTotal + #1268, #2560
  static mapTotal + #1269, #2048
  static mapTotal + #1270, #2560
  static mapTotal + #1271, #2560
  static mapTotal + #1272, #2560
  static mapTotal + #1273, #2560
  static mapTotal + #1274, #2560
  static mapTotal + #1275, #2560
  static mapTotal + #1276, #2560
  static mapTotal + #1277, #2048
  static mapTotal + #1278, #2560
  static mapTotal + #1279, #2560

  ;Linha 32
  static mapTotal + #1280, #2560
  static mapTotal + #1281, #2560
  static mapTotal + #1282, #2560
  static mapTotal + #1283, #2048
  static mapTotal + #1284, #2560
  static mapTotal + #1285, #2560
  static mapTotal + #1286, #2816
  static mapTotal + #1287, #2816
  static mapTotal + #1288, #256
  static mapTotal + #1289, #2816
  static mapTotal + #1290, #2816
  static mapTotal + #1291, #256
  static mapTotal + #1292, #2816
  static mapTotal + #1293, #2816
  static mapTotal + #1294, #2560
  static mapTotal + #1295, #2560
  static mapTotal + #1296, #256
  static mapTotal + #1297, #2560
  static mapTotal + #1298, #2560
  static mapTotal + #1299, #2048
  static mapTotal + #1300, #2560
  static mapTotal + #1301, #2560
  static mapTotal + #1302, #2560
  static mapTotal + #1303, #2560
  static mapTotal + #1304, #2560
  static mapTotal + #1305, #2560
  static mapTotal + #1306, #2048
  static mapTotal + #1307, #2560
  static mapTotal + #1308, #2560
  static mapTotal + #1309, #2048
  static mapTotal + #1310, #2560
  static mapTotal + #1311, #2560
  static mapTotal + #1312, #2560
  static mapTotal + #1313, #2560
  static mapTotal + #1314, #2560
  static mapTotal + #1315, #2560
  static mapTotal + #1316, #2560
  static mapTotal + #1317, #2048
  static mapTotal + #1318, #2560
  static mapTotal + #1319, #2560

  ;Linha 33
  static mapTotal + #1320, #2560
  static mapTotal + #1321, #2560
  static mapTotal + #1322, #2560
  static mapTotal + #1323, #256
  static mapTotal + #1324, #2560
  static mapTotal + #1325, #2560
  static mapTotal + #1326, #2560
  static mapTotal + #1327, #2816
  static mapTotal + #1328, #2816
  static mapTotal + #1329, #2816
  static mapTotal + #1330, #2816
  static mapTotal + #1331, #2816
  static mapTotal + #1332, #2816
  static mapTotal + #1333, #2560
  static mapTotal + #1334, #2560
  static mapTotal + #1335, #2560
  static mapTotal + #1336, #256
  static mapTotal + #1337, #2560
  static mapTotal + #1338, #2560
  static mapTotal + #1339, #2048
  static mapTotal + #1340, #2048
  static mapTotal + #1341, #2048
  static mapTotal + #1342, #2048
  static mapTotal + #1343, #2048
  static mapTotal + #1344, #2560
  static mapTotal + #1345, #2560
  static mapTotal + #1346, #2048
  static mapTotal + #1347, #2560
  static mapTotal + #1348, #2560
  static mapTotal + #1349, #2048
  static mapTotal + #1350, #2560
  static mapTotal + #1351, #2560
  static mapTotal + #1352, #2560
  static mapTotal + #1353, #2560
  static mapTotal + #1354, #2816
  static mapTotal + #1355, #2816
  static mapTotal + #1356, #2816
  static mapTotal + #1357, #2048
  static mapTotal + #1358, #2560
  static mapTotal + #1359, #2560

  ;Linha 34
  static mapTotal + #1360, #2560
  static mapTotal + #1361, #2560
  static mapTotal + #1362, #2560
  static mapTotal + #1363, #2560
  static mapTotal + #1364, #2560
  static mapTotal + #1365, #2560
  static mapTotal + #1366, #2560
  static mapTotal + #1367, #2560
  static mapTotal + #1368, #2560
  static mapTotal + #1369, #2560
  static mapTotal + #1370, #2560
  static mapTotal + #1371, #2560
  static mapTotal + #1372, #2560
  static mapTotal + #1373, #2560
  static mapTotal + #1374, #2560
  static mapTotal + #1375, #2560
  static mapTotal + #1376, #2560
  static mapTotal + #1377, #2560
  static mapTotal + #1378, #2560
  static mapTotal + #1379, #2048
  static mapTotal + #1380, #256
  static mapTotal + #1381, #2560
  static mapTotal + #1382, #2560
  static mapTotal + #1383, #2560
  static mapTotal + #1384, #2560
  static mapTotal + #1385, #2560
  static mapTotal + #1386, #2560
  static mapTotal + #1387, #2560
  static mapTotal + #1388, #2560
  static mapTotal + #1389, #2560
  static mapTotal + #1390, #2560
  static mapTotal + #1391, #2560
  static mapTotal + #1392, #2560
  static mapTotal + #1393, #2816
  static mapTotal + #1394, #2816
  static mapTotal + #1395, #256
  static mapTotal + #1396, #256
  static mapTotal + #1397, #2048
  static mapTotal + #1398, #2560
  static mapTotal + #1399, #2560

  ;Linha 35
  static mapTotal + #1400, #2560
  static mapTotal + #1401, #2560
  static mapTotal + #1402, #2560
  static mapTotal + #1403, #2560
  static mapTotal + #1404, #2560
  static mapTotal + #1405, #2560
  static mapTotal + #1406, #2560
  static mapTotal + #1407, #2560
  static mapTotal + #1408, #2560
  static mapTotal + #1409, #2560
  static mapTotal + #1410, #2560
  static mapTotal + #1411, #2560
  static mapTotal + #1412, #2560
  static mapTotal + #1413, #2560
  static mapTotal + #1414, #2560
  static mapTotal + #1415, #2560
  static mapTotal + #1416, #2560
  static mapTotal + #1417, #2560
  static mapTotal + #1418, #2560
  static mapTotal + #1419, #2048
  static mapTotal + #1420, #256
  static mapTotal + #1421, #2560
  static mapTotal + #1422, #2560
  static mapTotal + #1423, #2560
  static mapTotal + #1424, #2560
  static mapTotal + #1425, #2560
  static mapTotal + #1426, #2560
  static mapTotal + #1427, #2560
  static mapTotal + #1428, #2560
  static mapTotal + #1429, #2560
  static mapTotal + #1430, #2560
  static mapTotal + #1431, #2560
  static mapTotal + #1432, #2560
  static mapTotal + #1433, #2816
  static mapTotal + #1434, #256
  static mapTotal + #1435, #2816
  static mapTotal + #1436, #2816
  static mapTotal + #1437, #2048
  static mapTotal + #1438, #2560
  static mapTotal + #1439, #2560

  ;Linha 36
  static mapTotal + #1440, #2560
  static mapTotal + #1441, #2560
  static mapTotal + #1442, #2560
  static mapTotal + #1443, #2048
  static mapTotal + #1444, #2560
  static mapTotal + #1445, #2560
  static mapTotal + #1446, #2560
  static mapTotal + #1447, #2048
  static mapTotal + #1448, #2048
  static mapTotal + #1449, #2048
  static mapTotal + #1450, #2048
  static mapTotal + #1451, #2048
  static mapTotal + #1452, #2048
  static mapTotal + #1453, #2048
  static mapTotal + #1454, #2048
  static mapTotal + #1455, #2048
  static mapTotal + #1456, #2048
  static mapTotal + #1457, #2048
  static mapTotal + #1458, #2048
  static mapTotal + #1459, #256
  static mapTotal + #1460, #256
  static mapTotal + #1461, #2560
  static mapTotal + #1462, #2560
  static mapTotal + #1463, #256
  static mapTotal + #1464, #2048
  static mapTotal + #1465, #2560
  static mapTotal + #1466, #2560
  static mapTotal + #1467, #2560
  static mapTotal + #1468, #2560
  static mapTotal + #1469, #2560
  static mapTotal + #1470, #2560
  static mapTotal + #1471, #2048
  static mapTotal + #1472, #2048
  static mapTotal + #1473, #2048
  static mapTotal + #1474, #2048
  static mapTotal + #1475, #2048
  static mapTotal + #1476, #2048
  static mapTotal + #1477, #2048
  static mapTotal + #1478, #2560
  static mapTotal + #1479, #2560

  ;Linha 37
  static mapTotal + #1480, #2560
  static mapTotal + #1481, #2560
  static mapTotal + #1482, #2560
  static mapTotal + #1483, #2048
  static mapTotal + #1484, #2560
  static mapTotal + #1485, #2560
  static mapTotal + #1486, #2560
  static mapTotal + #1487, #2560
  static mapTotal + #1488, #2560
  static mapTotal + #1489, #2560
  static mapTotal + #1490, #2560
  static mapTotal + #1491, #2560
  static mapTotal + #1492, #2560
  static mapTotal + #1493, #2560
  static mapTotal + #1494, #2560
  static mapTotal + #1495, #2560
  static mapTotal + #1496, #2560
  static mapTotal + #1497, #2560
  static mapTotal + #1498, #2560
  static mapTotal + #1499, #2560
  static mapTotal + #1500, #2560
  static mapTotal + #1501, #2560
  static mapTotal + #1502, #2560
  static mapTotal + #1503, #768
  static mapTotal + #1504, #2048
  static mapTotal + #1505, #2560
  static mapTotal + #1506, #2560
  static mapTotal + #1507, #2560
  static mapTotal + #1508, #2560
  static mapTotal + #1509, #2560
  static mapTotal + #1510, #2560
  static mapTotal + #1511, #2560
  static mapTotal + #1512, #2560
  static mapTotal + #1513, #2560
  static mapTotal + #1514, #2560
  static mapTotal + #1515, #2560
  static mapTotal + #1516, #2560
  static mapTotal + #1517, #2048
  static mapTotal + #1518, #2560
  static mapTotal + #1519, #2560

  ;Linha 38
  static mapTotal + #1520, #2560
  static mapTotal + #1521, #2560
  static mapTotal + #1522, #2560
  static mapTotal + #1523, #2048
  static mapTotal + #1524, #2560
  static mapTotal + #1525, #2560
  static mapTotal + #1526, #2560
  static mapTotal + #1527, #2560
  static mapTotal + #1528, #2560
  static mapTotal + #1529, #2560
  static mapTotal + #1530, #2560
  static mapTotal + #1531, #2560
  static mapTotal + #1532, #2560
  static mapTotal + #1533, #2560
  static mapTotal + #1534, #2560
  static mapTotal + #1535, #2560
  static mapTotal + #1536, #2560
  static mapTotal + #1537, #2560
  static mapTotal + #1538, #2560
  static mapTotal + #1539, #2560
  static mapTotal + #1540, #2560
  static mapTotal + #1541, #2560
  static mapTotal + #1542, #2560
  static mapTotal + #1543, #256
  static mapTotal + #1544, #2048
  static mapTotal + #1545, #2048
  static mapTotal + #1546, #2048
  static mapTotal + #1547, #2048
  static mapTotal + #1548, #2560
  static mapTotal + #1549, #2560
  static mapTotal + #1550, #2560
  static mapTotal + #1551, #2560
  static mapTotal + #1552, #2560
  static mapTotal + #1553, #2560
  static mapTotal + #1554, #2560
  static mapTotal + #1555, #2560
  static mapTotal + #1556, #2560
  static mapTotal + #1557, #2048
  static mapTotal + #1558, #2560
  static mapTotal + #1559, #2560

  ;Linha 39
  static mapTotal + #1560, #2560
  static mapTotal + #1561, #2560
  static mapTotal + #1562, #2560
  static mapTotal + #1563, #2048
  static mapTotal + #1564, #2560
  static mapTotal + #1565, #2560
  static mapTotal + #1566, #256
  static mapTotal + #1567, #256
  static mapTotal + #1568, #256
  static mapTotal + #1569, #256
  static mapTotal + #1570, #256
  static mapTotal + #1571, #256
  static mapTotal + #1572, #256
  static mapTotal + #1573, #256
  static mapTotal + #1574, #256
  static mapTotal + #1575, #256
  static mapTotal + #1576, #256
  static mapTotal + #1577, #256
  static mapTotal + #1578, #256
  static mapTotal + #1579, #256
  static mapTotal + #1580, #2560
  static mapTotal + #1581, #2560
  static mapTotal + #1582, #2560
  static mapTotal + #1583, #768
  static mapTotal + #1584, #2048
  static mapTotal + #1585, #2560
  static mapTotal + #1586, #2560
  static mapTotal + #1587, #2560
  static mapTotal + #1588, #2560
  static mapTotal + #1589, #2560
  static mapTotal + #1590, #2560
  static mapTotal + #1591, #2560
  static mapTotal + #1592, #2560
  static mapTotal + #1593, #2048
  static mapTotal + #1594, #2048
  static mapTotal + #1595, #2048
  static mapTotal + #1596, #2048
  static mapTotal + #1597, #2048
  static mapTotal + #1598, #2560
  static mapTotal + #1599, #2560

  ;Linha 40
  static mapTotal + #1600, #2560
  static mapTotal + #1601, #2560
  static mapTotal + #1602, #2560
  static mapTotal + #1603, #2560
  static mapTotal + #1604, #2560
  static mapTotal + #1605, #2560
  static mapTotal + #1606, #2560
  static mapTotal + #1607, #2560
  static mapTotal + #1608, #2560
  static mapTotal + #1609, #2560
  static mapTotal + #1610, #2560
  static mapTotal + #1611, #2560
  static mapTotal + #1612, #2560
  static mapTotal + #1613, #2560
  static mapTotal + #1614, #2560
  static mapTotal + #1615, #2560
  static mapTotal + #1616, #2560
  static mapTotal + #1617, #2560
  static mapTotal + #1618, #2560
  static mapTotal + #1619, #2560
  static mapTotal + #1620, #2560
  static mapTotal + #1621, #2560
  static mapTotal + #1622, #2560
  static mapTotal + #1623, #2560
  static mapTotal + #1624, #2560
  static mapTotal + #1625, #2560
  static mapTotal + #1626, #2560
  static mapTotal + #1627, #2560
  static mapTotal + #1628, #2560
  static mapTotal + #1629, #2560
  static mapTotal + #1630, #2560
  static mapTotal + #1631, #2560
  static mapTotal + #1632, #2560
  static mapTotal + #1633, #2560
  static mapTotal + #1634, #2560
  static mapTotal + #1635, #2560
  static mapTotal + #1636, #2560
  static mapTotal + #1637, #2560
  static mapTotal + #1638, #2560
  static mapTotal + #1639, #2560

  ;Linha 41
  static mapTotal + #1640, #2560
  static mapTotal + #1641, #2560
  static mapTotal + #1642, #2560
  static mapTotal + #1643, #2560
  static mapTotal + #1644, #2560
  static mapTotal + #1645, #2560
  static mapTotal + #1646, #2560
  static mapTotal + #1647, #2560
  static mapTotal + #1648, #2560
  static mapTotal + #1649, #2560
  static mapTotal + #1650, #2560
  static mapTotal + #1651, #2560
  static mapTotal + #1652, #2560
  static mapTotal + #1653, #2560
  static mapTotal + #1654, #2560
  static mapTotal + #1655, #2560
  static mapTotal + #1656, #2560
  static mapTotal + #1657, #2560
  static mapTotal + #1658, #2560
  static mapTotal + #1659, #2560
  static mapTotal + #1660, #2560
  static mapTotal + #1661, #2560
  static mapTotal + #1662, #2560
  static mapTotal + #1663, #2560
  static mapTotal + #1664, #2560
  static mapTotal + #1665, #2560
  static mapTotal + #1666, #2560
  static mapTotal + #1667, #2560
  static mapTotal + #1668, #2560
  static mapTotal + #1669, #2560
  static mapTotal + #1670, #2560
  static mapTotal + #1671, #2560
  static mapTotal + #1672, #2560
  static mapTotal + #1673, #2560
  static mapTotal + #1674, #2560
  static mapTotal + #1675, #2560
  static mapTotal + #1676, #2560
  static mapTotal + #1677, #2560
  static mapTotal + #1678, #2560
  static mapTotal + #1679, #2560
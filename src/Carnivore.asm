startGame:
  call printMenu
  call menuSpaceLoop

startLevel:
  call levelMain ; loads current level

  call render
  call renderPlayer

inGame:
  call DelayMove
  call checkCollision
  call mobMain
  call checkCollision
  
  ; renders baby bee
  call renderBaby

  ; has the level finished?
  call finishLevel

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
    loadn R1, #2
    cmp R0, R1
    jne testLevel3
    call loadLevel2

    jmp levelMainFinish

  testLevel3:
    loadn R1, #3
    cmp R0, R1
    jne levelMainFinish
    call loadLevel3

  levelMainFinish:
    pop R1
    pop R0
    rts

spaceLoop:
  inchar R0
  loadn R1, #32 ; space 
  cmp R0, R1
  jne spaceLoop
  rts

menuSpaceLoop:
  inchar R0
  loadn R1, #32 ; space 
  cmp R0, R1
  jeq menuSpaceLoopReturn ; starts game

  loadn R1, #'i'
  cmp R0, R1
  ceq printinstructionScreen ; prints instruction screen
  ceq instructionScreenCommandLoop ; will wait for space key to print menu again 
                                   ; (goes back to addr 0)

  jmp menuSpaceLoop

  menuSpaceLoopReturn:
    rts

instructionScreenCommandLoop:
  call spaceLoop
  jmp startGame


loadLevel1:
  push R0
  push R1
  push R2

  ; player things
  loadn R0, #playerCoordRender
  loadn R1, #43
  storei R0, R1 ; stores coord 43 in player render

  inc R0
  storei R0, R1 ; stores coord 43 in player map

  ; render things
  loadn R0, #renderVar
  loadn R1, #480 ; #480
  storei R0, R1 ; stores render min cord as 480

  inc R0
  loadn R1, #1680 ; #1680
  storei R0, R1 ; stores max coord as 1680

  ; restars slideCounter
  loadn R0, #slideCounter
  loadn R1, #0
  storei R0, R1
  inc R0
  loadn R1, #65000
  storei R0, R1

  ; baby bee spawn
  loadn R1, #0
  store babyBee, R1

  ; mob things
  loadn R0, #mob1
  call loadMobRoutine

  loadn R1, #6
  add R1, R1, R0 ; addr to mapCoord of mob
  loadn R2, #841
  storei R1, R2 ; coord now 841

  loadn R1, #9
  add R1, R1, R0 ; addr to side mob is facing
  loadn R2, #1
  storei R1, R2 ; stores 1 (facing right)

  loadn R1, #12
  add R1, R1, R0 ; addr to script number
  loadn R2, #script1
  storei R1, R2 ; stores script 1

  ; second mob
  loadn R0, #mob2
  call loadMobRoutine

  loadn R1, #6
  add R1, R1, R0 ; addr to mapCoord of mob
  loadn R2, #1152
  storei R1, R2 ; coord now 1152

  loadn R1, #9
  add R1, R1, R0 ; addr to side mob is facing
  loadn R2, #1
  storei R1, R2 ; stores 1 (facing right)

  loadn R1, #12
  add R1, R1, R0 ; addr to script number
  loadn R2, #script2
  storei R1, R2 ; stores script 2

  ; third mob
  loadn R0, #mob3
  call loadMobRoutine

  loadn R1, #6
  add R1, R1, R0 ; addr to mapCoord of mob
  loadn R2, #1143
  storei R1, R2 ; coord now 1143

  loadn R1, #9
  add R1, R1, R0 ; addr to side mob is facing
  loadn R2, #1
  storei R1, R2 ; stores 1 (facing right)

  loadn R1, #12
  add R1, R1, R0 ; addr to script number
  loadn R2, #script3
  storei R1, R2 ; stores script 3

  ; slides map from bottom to top
  call levelSlide

  pop R2
  pop R1
  pop R0
  rts


loadLevel2:
  push R0
  push R1
  push R2

  ; player things
  loadn R0, #playerCoordRender
  loadn R1, #43
  storei R0, R1 ; stores coord 43 in player render

  inc R0
  storei R0, R1 ; stores coord 43 in player map

  ; render things
  loadn R0, #renderVar
  loadn R1, #480   ;#480
  storei R0, R1 ; stores render min cord as 480

  inc R0
  loadn R1, #1680   ;#1680
  storei R0, R1 ; stores max coord as 1680

  ; restars slideCounter
  loadn R0, #slideCounter
  loadn R1, #0
  storei R0, R1
  inc R0
  loadn R1, #65000
  storei R0, R1

  ; baby bee spawn
  loadn R1, #0
  store babyBee, R1

  ; mob things
  loadn R0, #mob1
  call loadMobRoutine

  loadn R1, #6
  add R1, R1, R0 ; addr to mapCoord of mob
  loadn R2, #1085
  storei R1, R2 ; coord now 1085

  loadn R1, #9
  add R1, R1, R0 ; addr to side mob is facing
  loadn R2, #1
  storei R1, R2 ; stores 1 (facing right)

  loadn R1, #12
  add R1, R1, R0 ; addr to script number
  loadn R2, #script4
  storei R1, R2 ; stores script 1

  ; second mob
  loadn R0, #mob2
  call loadMobRoutine

  loadn R1, #6
  add R1, R1, R0 ; addr to mapCoord of mob
  loadn R2, #1629
  storei R1, R2 ; coord now 1629

  loadn R1, #9
  add R1, R1, R0 ; addr to side mob is facing
  loadn R2, #1
  storei R1, R2 ; stores 1 (facing right)

  loadn R1, #12
  add R1, R1, R0 ; addr to script number
  loadn R2, #script5
  storei R1, R2 ; stores script 2

  ; third mob
  loadn R0, #mob3
  call loadMobRoutine

  loadn R1, #6
  add R1, R1, R0 ; addr to mapCoord of mob
  loadn R2, #875
  storei R1, R2 ; coord now 875

  loadn R1, #9
  add R1, R1, R0 ; addr to side mob is facing
  loadn R2, #1
  storei R1, R2 ; stores 1 (facing right)

  loadn R1, #12
  add R1, R1, R0 ; addr to script number
  loadn R2, #script6
  storei R1, R2 ; stores script 3

  ; slides map from bottom to top
  call levelSlide

  pop R2
  pop R1
  pop R0
  rts

loadLevel3:
  push R0
  push R1
  push R2

  ; player things
  loadn R0, #playerCoordRender
  loadn R1, #43
  storei R0, R1 ; stores coord 43 in player render

  inc R0
  storei R0, R1 ; stores coord 43 in player map

  ; render things
  loadn R0, #renderVar
  loadn R1, #480   ;#480
  storei R0, R1 ; stores render min cord as 480

  inc R0
  loadn R1, #1680   ;#1680
  storei R0, R1 ; stores max coord as 1680

  ; restars slideCounter
  loadn R0, #slideCounter
  loadn R1, #0
  storei R0, R1
  inc R0
  loadn R1, #65000
  storei R0, R1

  ; baby bee spawn
  loadn R1, #0
  store babyBee, R1

  ; first mob
  loadn R0, #mob1
  call loadMobRoutine

  loadn R1, #6
  add R1, R1, R0 ; addr to mapCoord of mob
  loadn R2, #1624
  storei R1, R2 ; coord now 875

  loadn R1, #9
  add R1, R1, R0 ; addr to side mob is facing
  loadn R2, #1
  storei R1, R2 ; stores 1 (facing right)

  loadn R1, #12
  add R1, R1, R0 ; addr to script number
  loadn R2, #script8
  storei R1, R2 ; stores script 3

  ; second mob
  loadn R0, #mob2
  call loadMobRoutine

  loadn R1, #6
  add R1, R1, R0 ; addr to mapCoord of mob
  loadn R2, #875
  storei R1, R2 ; coord now 1629

  loadn R1, #9
  add R1, R1, R0 ; addr to side mob is facing
  loadn R2, #1
  storei R1, R2 ; stores 1 (facing right)

  loadn R1, #12
  add R1, R1, R0 ; addr to script number
  loadn R2, #script6
  storei R1, R2 ; stores script 2

  ; third mob
  loadn R0, #mob3
  call loadMobRoutine

  loadn R1, #6
  add R1, R1, R0 ; addr to mapCoord of mob
  loadn R2, #1155
  storei R1, R2 ; coord now 875

  loadn R1, #9
  add R1, R1, R0 ; addr to side mob is facing
  loadn R2, #1
  storei R1, R2 ; stores 1 (facing right)

  loadn R1, #12
  add R1, R1, R0 ; addr to script number
  loadn R2, #script7
  storei R1, R2 ; stores script 3


  ; slides map from bottom to top
  call levelSlide

  pop R2
  pop R1
  pop R0
  rts


; R0 must have mob addr
loadMobRoutine:
  push R1
  push R2

  loadn R1, #1
  storei R0, R1 ; activates mob

  loadn R1, #7 
  add R1, R1, R0 ; addr to chase bool
  loadn R2, #0
  storei R1, R2 ; restarts chase bool
  inc R1
  storei R1, R2 ; restarts alert bool
  loadn R1, #17
  add R1, R1, R0 ; addr to return bool
  storei R1, R2 ; restarts return bool

  pop R2
  pop R1
  rts

printMenu:
  push R0
  push R1
  push R2
  push R3

  loadn R0, #menu
  loadn R1, #0
  loadn R2, #1200

  printmenuScreenLoop:

    add R3,R0,R1
    loadi R3, R3
    outchar R3, R1
    inc R1
    cmp R1, R2

    jne printmenuScreenLoop

  pop R3
  pop R2
  pop R1
  pop R0
  rts

finishLevel:
  push R0
  push R1
  push R2

  ; check if babyBee has been eaten
  load R0, babyBee
  loadn R1, #1
  cmp R0, R1 ; if equal, check coords
             ; else, finish
  jne finishLevelFinish

  ; check if player has returned home
  load R0, playerCoordInMap
  loadn R2, #40

  div R1, R0, R2 ; player.y
  mod R0, R0, R2 ; player.x

  ; player.x <= 7 AND 
  ; player.y <= 6
  loadn R2, #7
  cmp R0, R2 ; eq or le
  jgr finishLevelFinish

  loadn R2, #6
  cmp R1, R2 ; eq or le
  jgr finishLevelFinish

  ; increments level
  load R1, curLevel
  inc R1
  store curLevel, R1 ; increases level

  ; checks if new level is 4 (end game)
  loadn R2, #4
  cmp R1, R2
  ceq endGameLevel ; everything will restart

  ; prints next level screen
  call printnextlevelScreen

  ; will loop until player presses space
  ; then jmps to startLevel and loads new level
  finishLevelSpaceLoop:
    inchar R0
    loadn R1, #32 ; space
    cmp R0, R1
    jeq startLevel  

    jmp finishLevelSpaceLoop

finishLevelFinish:
  pop R2
  pop R1
  pop R0
  rts

endGameLevel:
  loadn R0, #endGame
  loadn R1, #0
  loadn R2, #1200

  printendGameScreenLoop:
    add R3,R0,R1
    loadi R3, R3
    outchar R3, R1
    inc R1
    cmp R1, R2

    jne printendGameScreenLoop
  
  endGameLoop:
    inchar R0
    loadn R1, #32 ; space
    cmp R1, R0

    jne endGameLoop

    loadn R1, #1
    store curLevel, R1

    loadn R0, #0
    jmp startGame


renderBaby:
  push R0
  push R1
  push R2
  push R3

  loadn R0, #1
  load R1, babyBee
  cmp R0, R1 ; has baby bee been eaten
             ; if 1, yes it has, finish
             ; else, continue
  jeq renderBabyFinish

  ; checks if in distance
  loadn R0, #1396
  loadn R3, #renderVar
  loadi R1, R3 ; min render var

  cmp R0, R1 ; has to be eq or greater
             ; else, finish
  jle renderBabyFinish

  inc R3
  loadi R2, R3 ; max render var
  cmp R0, R2 ; has to be lesser
             ; else, finish
  jeg renderBabyFinish

  sub R0, R0, R1 ; finds render coord
  loadn R1, #2850 ; baby head value
  outchar R1, R0 ; renders babyhead

  dec R0
  loadn R1, #1827 ; baby diaper skin
  outchar R1, R0 ; renders baby diaper

  renderBabyFinish:
    pop R3
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
  push R6
  push R7

  call render
  call renderBaby
  
  levelSlideDelayLoop:
    call mobMain

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
    jmp levelSlideDelayLoop

    levelSlideTestFirstCounter:
      loadi R3, R0 ; R3 = first counter value
      cmp R3, R5 ; if 0, var = true, restore both counters
                ; else, dec counter 1 and restore counter 2
      jne levelSlideTestFirstNot0

      ; if 0
      loadn R4, #17500 ; stores to 2nd counter
      storei R1, R4
      loadn R4, #0 ; stores to 1st counter
      storei R0, R4
      
      jmp levelSlideStartLoopFirst

      levelSlideTestFirstNot0:
        dec R3
        storei R0, R3 ; decs first counter

        loadn R4, #65000 ; stores to 2nd counter
        storei R1, R4
        jmp levelSlideStartLoopFirst


    levelSlideStartLoopFirst:  
      loadn R0, #renderVar
      mov R1, R0
      inc R1 ; addr to max coord to be rendered
      loadn R5, #0 ; to be used as case base

      ; delays
      levelSlideStartLoop:
        call mobMain

        loadn R6, #slideCounter ; addr to first counter
        inc R6 ; addr to second counter
        loadi R7, R6

        dec R7
        storei R6, R7 

        cmp R5, R7 ; if equal, test first counter and restore second
        jne levelSlideStartLoop

        ; if second counter == 0, restore it
        loadn R7, #17500
        storei R6, R7 ; restores second counter
        
        loadn R6, #slideCounter
        loadi R7, R6
        cmp R5, R7
        jeq levelSlideLoop ; if timer 1 == 0, restore all timers and execute slide loop once

        ; decrements timer 1
        dec R7
        storei R6, R7

        ; timer 2 is already restored

        jmp levelSlideStartLoop

      levelSlideLoop:
        loadn R6, #slideCounter
        loadn R7, #0
        storei R6, R7

        inc R6
        loadn R7, #17500
        storei R6, R7

        loadi R2, R0 ; min coord rendered
        loadi R3, R1 ; max coord rendered
        loadn R4, #40 ; 40 will be subed from coords

        sub R2, R2, R4
        storei R0, R2 ; subs 40 to min coord to be rendered

        sub R3, R3, R4 ; subs 40 to max coord to be rendered
        storei R1, R3
        
        call render
        call renderBaby
        call renderPlayer

        cmp R2, R5 ; case base, if min coord is 0, we stop
        jne levelSlideStartLoop

  levelSlideFinish:
    pop R7
    pop R6
    pop R5
    pop R4
    pop R3
    pop R2
    pop R1
    pop R0
    rts

printnextlevelScreen:
  push R0
  push R1
  push R2
  push R3

  loadn R0, #nextlevel
  loadn R1, #0
  loadn R2, #1200

  printnextlevelScreenLoop:

    add R3,R0,R1
    loadi R3, R3
    outchar R3, R1
    inc R1
    cmp R1, R2

    jne printnextlevelScreenLoop

  pop R3
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
    load R1, mob2
    cmp R1, R2 ; checks if mob is active
    jne checkActiveMob3

    loadn R0, #mob2 ; will be used for various instructions, 
                    ; should not be changed inside of them
    call mobMovement
    call behaveMob
    call renderExclaInter

  checkActiveMob3:
    load R1, mob3
    cmp R1, R2 ; checks if mob is active
    jne mobMainFinish

    loadn R0, #mob3 ; will be used for various instructions, 
                    ; should not be changed inside of them
    call mobMovement
    call behaveMob
    call renderExclaInter
  
  checkActiveMob4:
    load R1, mob4
    cmp R1, R2 ; checks if mob is active
    jne mobMainFinish

    loadn R0, #mob4 ; will be used for various instructions, 
                    ; should not be changed inside of them
    call mobMovement
    call behaveMob
    call renderExclaInter

  mobMainFinish:
    pop R2
    pop R1
    pop R0
    rts

; will check chase and alert
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

      ; cancel delaymove
      loadn R1, #10
      add R1, R1, R0 ; addr to delayMobMove1
      loadn R2, #0
      storei R1, R2 ; stores 10

      ; restores alert timer
      loadn R1, #13
      add R1, R1, R0 ; addr to alert timer1
      loadn R2, #12
      storei R1, R2
      
      inc R1 ; addr to alert timer2
      loadn R2, #65000
      storei R1, R2

      jmp behaveMobFinish ; finish

    conditionChaseFalse:
      loadn R2, #7
      add R2, R2, R0 ; addr to chase bool
      loadi R4, R2
      cmp R4, R3 ; chase bool == 1?
      jne testAlertBool ; if chaseBool == 0 test alertBool
      
      ; -1 to script alert
      loadn R2, #16
      add R2, R2, R0 
      loadi R2, R2 ; addr of script alert
      loadn R4, #65535
      storei R2, R4

      ; -1 to returnscript
      loadn R2, #18
      add R2, R2, R0
      loadi R2, R2 ; addr to return script
      storei R2, R4

      loadn R2, #7
      add R2, R2, R0 ; addr to chase bool

      loadn R4, #0
      storei R2, R4 ;
      inc R2 ; addr to alert bool
      storei R2, R3 ; stores 0 to chaseBool and 1 to alertBool

      ; updates alert script so mob will run to last coord player was seen
      loadn R1, #6
      add R1, R1, R0 ; addr to  mobcoord
      loadi R2, R1 ; mob coord
      loadn R6, #40

      div R3, R2, R6 ; mob.y
      mod R2, R2, R6 ; mob.x

      load R4, playerCoordInMap
      div R5, R4, R6 ; player.y
      mod R4, R4, R6 ; player.x

      loadn R1, #16
      add R1, R1, R0 ; addr to addr of scriptalert
      loadi R1, R1 ; addr of script alert
      loadn R7, #0
      storei R1, R7 ; stores phase number 0
      inc R1 ; next addr

      cmp R3, R5 ; if mob.y <=> player.y
      jle behaveMobConditionChaseFalseMobYLesser
      jgr behaveMobConditionChaseFalseMobYGreater
      jeq behaveMobConditionChaseFalseMobXTest

      behaveMobConditionChaseFalseMobYLesser:
        mul R5, R5, R6 ; player.y * 40
        add R5, R5, R2 ; player.y * 40 + mob.x
        storei R1, R5 ; 1st phase
        inc R1
        loadn R7, #'d'
        storei R1, R7 ; stores side to go
        
        inc R1
        jmp behaveMobConditionChaseFalseMobXTest

      behaveMobConditionChaseFalseMobYGreater:
        mul R5, R5, R6 ; player.y * 40
        add R5, R5, R2 ; player.y * 40 + mob.x
        storei R1, R5 ; 1st phase
        inc R1
        loadn R7, #'u'
        storei R1, R7 ; stores side to go

        inc R1
        jmp behaveMobConditionChaseFalseMobXTest
      
      behaveMobConditionChaseFalseMobXTest:
        ; we are already at y coord, just add player.x - mob.x
        add R3, R5, R4 ; past coord added + player.x
        sub R3, R3, R2 ; - mob.x
        storei R1, R3
        inc R1

        cmp R2, R4 ; mob.x <=> player.x
        jgr behaveMobConditionChaseFalseMobXGreater

        loadn R3, #'r'
        storei R1, R3 ; store side to move
        inc R1 
        loadn R3, #1
        storei R1, R3 ; store right face        

        jmp behaveMobFinish

        behaveMobConditionChaseFalseMobXGreater:
          loadn R3, #'l'
          storei R1, R3 ; store side to move
          inc R1 
          loadn R3, #0
          storei R1, R3 ; store right face 

      jmp behaveMobFinish
    
    testAlertBool:
      loadn R3, #8
      add R2, R3, R0 ; addr to alert bool
      loadi R2, R2
      loadn R3, #1
      cmp R2, R3
      jne testReturnBool ; if alertBool == 0, test return bool

      call delayMobAlert
      jmp behaveMobFinish
    
    testReturnBool:
      loadn R1, #17
      add R1, R1, R0 ; addr to return bool
      loadi R2, R1
      loadn R3, #1
      cmp R2, R3
      jne behaveMobFinish ; if == 0, finish

  behaveMobFinish:
    pop R7
    pop R6
    pop R5
    pop R4
    pop R3
    pop R2
    pop R1
    rts


returnBoolAction:
  push R1
  push R2
  push R3
  push R4
  push R5
  push R6
  push R7

  ; check if scriptReturn[0] == -1
  loadn R5, #18 
  add R5, R5, R0 ; addr to addr to script return
  loadi R5, R5 ; addr to script return
  
  loadi R4, R5 ; script[0]
  loadn R3, #65535
  cmp R3, R4
  jne returnBoolActionScriptActive

  ; here, script[0] == -1
  loadn R7, #12
  add R7, R7, R0 ; addr to addr to std script
  loadi R6, R7 ; addr to std script
  
  ; scriptreturn[0] = 0
  loadn R7, #0
  storei R5, R7

  inc R6 ; addr to first coord
  loadi R6, R6 ; first coord
  loadn R7, #40
  mod R1, R6, R7 ; final.x
  div R2, R6, R7 ; final.y

  loadn R4, #6
  add R4, R4, R0 ; addr to mob coord
  loadi R4, R4 ; mob.coord
  mod R3, R4, R7 ; mob.x
  div R4, R4, R7 ; mob.y

  ; check if mob.x > final.x
  cmp R3, R1
  jeg returnBoolActionXEG ; if x eq or gr
  
  ; if x lesser
  inc R5
  inc R5 ; addr to side to move
  loadn R7, #'r'
  storei R5, R7 ; stores left side walk
  
  dec R5 ; addr to store first coord to be reached
  jmp returnBoolActionStoreX

  returnBoolActionXEG:
    inc R5
    inc R5 ; addr to side to move
    loadn R7, #'l'
    storei R5, R7 ; stores right side walk

    dec R5 ; addr to store first coord to be reached

returnBoolActionStoreX:
  loadn R7, #40
  mul R3, R4, R7 ; mob.y *40
  add R3, R3, R1 ; mob.y*40 + final.x
  storei R5, R3

  inc R5
  inc R5 ; addr for new coord

  ; check if mob.y > final.y
  cmp R4, R2
  jeg returnBoolActionYEG ; if y eq or gr

  ; if y lesser
  loadn R7, #'d'
  inc R5 ; addr to sside to move
  storei R5, R7 ; stores down side walk
  
  dec R5 ; addr for next coord
  jmp returnBoolActionStoreY

  returnBoolActionYEG:
    loadn R7, #'u'
    inc R5 ; addr to sside to move
    storei R5, R7 ; stores up side walk
  
    dec R5 ; addr for next coord
  
  returnBoolActionStoreY:
    loadn R7, #40
    mul R2, R2, R7 ; final.y *40
    add R2, R2, R1 ; final.y *40 + final.x

    storei R5, R2

  jmp returnBoolActionFinish

  ; R5 = addr to phaseNum
  ; R4 = script[0]
  returnBoolActionScriptActive:
    loadn R7, #2
    mul R4, R4, R7 ; mults phaseNum by 2
    add R4, R4, R5 ; addr to current coord - 1
    inc R4 ; addr to cur coord

    loadi R3, R4 ; cur coord to be reached
    loadn R7, #0 
    cmp R3, R7 ; if eq to 0, we finished, else, execute script
    jeq returnBoolActionScriptEnd

    ; if here, we did not reach end of script, let's execute it
    ; R3 must be addr of script
    loadn R7, #6
    add R2, R7, R0 ; R2 must be addr of mob coord
    loadn R7, #18
    add R3, R7, R0 ; R3 must be addr of script
    loadi R3, R3 ; actual address
    call scriptAction

    jmp returnBoolActionFinish

    returnBoolActionScriptEnd:
      ; stores -1 to phasenum
      loadn R7, #65535
      storei R5, R7

      ; stores 0 to return bool
      loadn R7, #17
      add R6, R7, R0 ; addr to return bool
      loadn R7, #0
      storei R6, R7

returnBoolActionFinish:
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
  call renderMob ; try removing this rendermob, it might be useless
  jmp mobMovementFinish

  mobMovementAlertTest:
    inc R3 ; addr of alert bool
    loadi R2, R3
    cmp R2, R1 ; if alert bool = 1, script alert
               ;else, test return bool
    jne mobMovementReturnBool

    ; ALERT SCRIPT HERE
    call scriptAlert
    call renderMob
    jmp mobMovementFinish

  mobMovementReturnBool:
    loadn R3, #17
    add R3, R3, R0 ; addr to return bool
    loadi R2, R3
    cmp R2, R1 ; if returnBool == 1, script return
               ; else, scriptmain
    jne mobMovementScriptMain

    ; return sctipt here
    call returnBoolAction
    call renderMob
    jmp mobMovementFinish

  mobMovementScriptMain:
    call scriptMain

  mobMovementFinish:
    pop R3
    pop R2
    pop R1
    rts

scriptAlert:
  push R1
  push R2
  push R3
  push R4
  push R5
  push R6
  push R7

  loadn R1, #16
  add R1, R1, R0
  loadi R3, R1 ; addr to script alert
  loadi R2, R3 ; scriptalert[0]
  loadn R1, #65535
  cmp R2, R1 ; if scriptalert[0] == -1, choose next action
  jeq scripAlertChoice ; if -1, choose next script for mob

  loadn R2, #6
  add R2, R2, R0 ; addr to mobCoord needed in scriptAction
  call scriptAction ; else, execute current script

  loadi R4, R3 ; reads phase number

  ; check if we reached the end (script[1 + 2*phaseNum] == 0 or 1)
  loadn R5, #2
  mul R4, R4, R5
  inc R4
  add R6, R3, R4 ; R6 = addr script[1+2*phaseNum]
  loadi R4, R6 ; R4 = script[1+2*phaseNum]

  loadn R5, #0
  cmp R4, R5 ; if == 0, scriptAlert[0] = -1 and mob.side = 0
             ; else, test if == 1
  jne scriptAlertTestSideRightEnd
  
  loadn R1, #9
  add R1, R0, R1 ; addr to mob is side looking
  storei R1, R5 ; stores 0, facing left

  inc R1 ; addr to delaymove 1
  loadn R5, #10
  storei R1, R5

  ; unrender pixel
  loadn R1, #6
  add R1, R1, R0 ; addr to mob coord
  loadi R1, R1 ; mob coord
  loadn R2, #40
  add R1, R1, R2 ; left leg
  inc R1 ; right of right leg coord

  loadn R4, #renderVar
  loadi R2, R4
  cmp R1, R2 ; must be eq or gr than min rendervar
  jle scriptAlertResetScript

  inc R4
  loadi R3, R4
  cmp R1, R3 ; must be lesser than max rendervar
  jeg scriptAlertResetScript

  loadn R3, #mapTotal
  add R3, R1, R3 ; addr to pix info
  loadi R3, R3 ; pix info
  sub R1, R1, R2 ; coord - min rendervar.. finds coord in render

  outchar R3, R1

  jmp scriptAlertResetScript

  scriptAlertTestSideRightEnd:
    loadn R5, #1
    cmp R4, R5 ; test if == 1, script[0] == -1 and mob.side = 1
               ; else, finish
    jne scriptAlertFinish

    loadn R1, #9
    add R1, R0, R1 ; addr to mob is side looking
    storei R1, R5 ; stores 1, facing right

    inc R1 ; addr to delaymove 1
    loadn R5, #10
    storei R1, R5

    ; unrender pixel
    loadn R1, #6
    add R1, R1, R0 ; addr to mob coord
    loadi R1, R1 ; mob coord
    loadn R2, #40
    add R1, R1, R2 ; left leg
    dec R1 ; left of left leg coord

    loadn R4, #renderVar
    loadi R2, R4
    cmp R1, R2 ; must be eq or gr than min rendervar
    jle scriptAlertResetScript

    inc R4
    loadi R3, R4
    cmp R1, R3 ; must be lesser than max rendervar
    jeg scriptAlertResetScript

    loadn R3, #mapTotal
    add R3, R1, R3 ; addr to pix info
    loadi R3, R3 ; pix info
    sub R1, R1, R2 ; coord - min rendervar.. finds coord in render

    outchar R3, R1

  scriptAlertResetScript:
    ; scriptAlert[0] = -1
    loadn R3, #16
    add R3, R3, R0 ; addr to addr to script alert
    loadi R3, R3 ; addr to script alert

    loadn R5, #65535
    storei R3, R5
    
    jmp scriptAlertFinish  

  scripAlertChoice:
    ; we'll make a rand number, (mob.coord + player.coord + mob.side)*11 + 19
    loadn R1, #6
    add R1, R1, R0
    loadi R1, R1 ; mob.coord
    loadn R2, #9
    add R2, R2, R0
    loadi R2, R2 ; side of mob
    add R1, R1, R2 ; mob.coord + side

    load R2, playerCoordInMap
    add R1, R1, R2 ; mob.coord + side + player.coord
    loadn R5, #11
    loadn R6, #19
    mul R1, R1, R5
    add R1, R1, R6

    ; I. move or turn around? R1 mod 2; move = 1/2; turn = 1/2
    loadn R7, #2
    mod R2, R1, R7
    loadn R7, #1
    cmp R2, R7 ; if 1 turn
               ; else, move
    jeq scriptAlertChoiceTurn

    ; II. if movement, how much? Each number means two steps
    loadn R7, #3
    mod R2, R1, R7 ; R2 = number of moves + 1
    inc R2

    ; III. which sides? up_right != right_up
    loadn R7, #7
    mod R3, R1, R7
    loadn R7, #0
    cmp R3, R7 ; 0 =  right, up
               ; 1 = down, right
               ; 2 = up, right
               ; 3 = down, left
               ; 4 = right, down
               ; 5 = left, up
               ; 6 = up, left
    jeq scriptAlertChoiceIIIRU
    
    loadn R7, #1
    cmp R3, R7 ; down, right
    jeq scriptAlertChoiceIIIDR

    loadn R7, #2
    cmp R3, R7 ; up, right
    jeq scriptAlertChoiceIIIUR

    loadn R7, #3
    cmp R3, R7 ; down, left
    jeq scriptAlertChoiceIIIDL

    loadn R7, #4
    cmp R3, R7 ; right, down
    jeq scriptAlertChoiceIIIRD

    loadn R7, #5
    cmp R3, R7 ; left, up
    jeq scriptAlertChoiceIIILU

    loadn R7, #6
    cmp R3, R7 ; up, left
    jeq scriptAlertChoiceIIIUL

    scriptAlertChoiceIIIRU:
      loadn R3, #'r' ; first move
      loadn R4, #'u' ; last move
      jmp scriptAlertChoiceIV

    scriptAlertChoiceIIIDR:
      loadn R3, #'d' ; first move
      loadn R4, #'r' ; last move
      jmp scriptAlertChoiceIV

    scriptAlertChoiceIIIUR:
      loadn R3, #'u' ; first move
      loadn R4, #'r' ; last move
      jmp scriptAlertChoiceIV

    scriptAlertChoiceIIIDL:
      loadn R3, #'d' ; first move
      loadn R4, #'l' ; last move
      jmp scriptAlertChoiceIV

    scriptAlertChoiceIIIRD:
      loadn R3, #'r' ; first move
      loadn R4, #'d' ; last move
      jmp scriptAlertChoiceIV

    scriptAlertChoiceIIILU:
      loadn R3, #'l' ; first move
      loadn R4, #'u' ; last move
      jmp scriptAlertChoiceIV

    scriptAlertChoiceIIIUL:
      loadn R3, #'u' ; first move
      loadn R4, #'l' ; last move
      jmp scriptAlertChoiceIV

    ; IV. amount of moves for each side
    ; ((total) mod (amount of moves)) + 1
    scriptAlertChoiceIV:
      mod R5, R1, R2 ; (totalSum mod totalMoves) + 1 
      inc R5
      sub R6, R2, R5 ; totalMoves - R5
      store scriptAlertCurCoordSum, R5

      loadn R5, #3
      mul R6, R6, R5 ; secondMove * 3
      load R5, scriptAlertCurCoordSum
      store scriptAlertCurCoordSum, R6

      loadn R6, #3
      mul R5, R5, R6 ; firstMove * 3
      load R6, scriptAlertCurCoordSum ; mult both by 3

    ; V. side mob will end up facing
    loadn R7, #2
    mod R7, R1, R7 ; totalSum mod 2

    ; mix everything up and generate script
    ; R3 = first move side
    ; R4 = last move side
    ; R5 = amount of moves first side x2
    ; R6 = amount of moves last side x2
    ; R7 = side mob will end up facing
    loadn R1, #16
    add R1, R1, R0 ; addr to addr of scriptalert
    loadi R1, R1 ; addr to script alert

    loadn R2, #0
    storei R1, R2 ; stores phase num

    inc R1
    inc R1 ; addr to first side to move
    storei R1, R3 ; stores it
    loadn R2, #'r'
    cmp R3, R2 ; check what side it is
    jeq scriptAlertChoiceFirstMoveRight

    loadn R2, #'l'
    cmp R3, R2 ; check what side it is
    jeq scriptAlertChoiceFirstMoveLeft

    loadn R2, #'u'
    cmp R3, R2 ; check what side it is
    jeq scriptAlertChoiceFirstMoveUp

    loadn R2, #'d'
    cmp R3, R2 ; check what side it is
    jeq scriptAlertChoiceFirstMoveDown

    ; IF THIS DOESN'T WORK, I CAN TRY (initialCoord/40 + 1)*40 -2  WHEN INVALID!!!!!!!
    scriptAlertChoiceFirstMoveRight:
      dec R1 ; addr where we'll store a coord
      loadn R3, #6
      add R2, R0, R3 ; addr to mob coord
      loadi R2, R2 ; mob coord
      
      ; we need to test if new coord is valid
      ; if first pos mod 40 > 29: (29 +9 = 38) AND (last pos mod 40 > 38 OR last pos mod 40 < 29)
      ; invalid
      loadn R3, #40
      mod R2, R2, R3 ; coord mod 40
      loadn R3, #29
      cmp R2, R3 ; (coord) mod 40 > 29 if eq or le, valid
                 ; else, next test
      jel scriptAlertChoiceFirstMoveRightValid

      loadn R2, #6
      add R2, R2, R0 ; addr to mob coord
      loadi R2, R2 ; mob coord
      add R2, R2, R5 ; add movement
      store scriptAlertCurCoordSum, R2
      loadn R3, #40
      mod R3, R2, R3 ; (coord + move) mod 40 > 38
      loadn R2, #38
      cmp R3, R2 ; if (coord + move) mod 40 > 38, invalid
                 ; else, test < 29
      jgr scriptAlertChoiceFirstMoveRightInvalid ; if greater, invalid

      loadn R2, #29
      cmp R3, R2 ; if (coord + move) mod 40 < 29, invalid
                 ; else, valid
      jeg scriptAlertChoiceFirstMoveRightValid

      scriptAlertChoiceFirstMoveRightInvalid:
        ; Coord is invalid here
        ; (initialCoord/40 + 1)*40 -2
        ; we have to take mob.coord again
        load R2, scriptAlertCurCoordSum
        sub R2, R2, R5 ; sub movement
        loadn R3, #40
        div R2, R2, R3 ; coord / 40
        inc R2
        mul R2, R2, R3 ; (coord / 40 +1)*40
        dec R2
        dec R2 ; -2

        storei R1, R2

        jmp scriptAlertChoiceGenerateScriptII        

      scriptAlertChoiceFirstMoveRightValid:
        ; find new coord
        loadn R2, #6
        add R2, R2, R0 ; addr to mob coord
        loadi R2, R2 ; mob coord
        add R2, R2, R5 ; add movement

        ; store new coord
        storei R1, R2
        
        jmp scriptAlertChoiceGenerateScriptII

    ; IF THIS DOESN'T WORK, I CAN TRY (curCoord/40)*40 +1 WHEN INVALID!!!!!!!
    scriptAlertChoiceFirstMoveLeft:
      dec R1 ; addr where we'll store a coord
      loadn R3, #6
      add R2, R0, R3 ; addr to mob coord
      loadi R2, R2 ; mob coord
      
      ; we need to test if new coord is valid
      ; if first pos < 10 (10 + 9 = 1) AND (last pos <1 OR last pos >10)
      ; invalid
      loadn R3, #40
      mod R2, R2, R3 ; coord mod 40
      loadn R3, #10
      cmp R2, R3 ; (coord) mod 40 < 10 if eq or gr, valid
                 ; else, next test
      jeg scriptAlertChoiceFirstMoveLeftValid

      loadn R2, #6
      add R2, R2, R0 ; addr to mob coord
      loadi R2, R2 ; mob coord
      sub R2, R2, R5 ; subs movement
      store scriptAlertCurCoordSum, R2 ; stores for future use
      loadn R3, #40
      mod R3, R2, R3 ; (coord - move) mod 40 < 1
      loadn R2, #1
      cmp R3, R2 ; if (coord - move) mod 40 < 1, invalid
                 ; else, test > 10
      jle scriptAlertChoiceFirstMoveLeftInvalid ; if lesser, invalid

      loadn R2, #10
      cmp R3, R2 ; if (coord - move) mod 40 > 10, invalid
                 ; else, valid
      jel scriptAlertChoiceFirstMoveLeftValid

      scriptAlertChoiceFirstMoveLeftInvalid:
        ; Coord is invalid here
        ; if negative or 0: coord = 1
        ; else if positive: (curCoord/40 +1)*40 + 1
        ; we have to take mob.coord again
        load R2, scriptAlertCurCoordSum ; (coord - move)

        ; check if it's 0 or negative
        loadn R3, #0
        cmp R2, R3 
        jeq scriptAlertChoiceFirstMoveLeftInvalidZeroNeg

        ; check if negative
        shiftr0 R2, #15
        loadn R3, #1
        cmp R2, R3
        jeq scriptAlertChoiceFirstMoveLeftInvalidZeroNeg

        ; invalid positive
        load R2, scriptAlertCurCoordSum
        loadn R3, #40
        div R2, R2, R3 ; curCoord/40
        inc R2 ; curCoord/40 +1
        mul R2, R2, R3 ; (curCoord/40 +1)*40
        inc R2 ; (curCoord/40 +1)*40 + 1

        storei R1, R2
        
        jmp scriptAlertChoiceGenerateScriptII

      scriptAlertChoiceFirstMoveLeftInvalidZeroNeg:
        ; coord = 1
        loadn R3, #1
        storei R1, R3

        jmp scriptAlertChoiceGenerateScriptII

      scriptAlertChoiceFirstMoveLeftValid:
        ; load coord
        loadn R3, #6
        add R2, R0, R3 ; addr to mob coord
        loadi R2, R2 ; mob coord
        sub R2, R2, R5 ; subs movement
        
        ; store it
        storei R1, R2
        jmp scriptAlertChoiceGenerateScriptII
      
    scriptAlertChoiceFirstMoveUp:
      dec R1 ; addr where we'll store a coord
      loadn R3, #6
      add R2, R0, R3 ; addr to mob coord
      loadi R2, R2 ; mob coord
      
      ; we need to test if new coord is valid
      ; if coord - 40*move < 0: invalid
      loadn R3, #40
      mul R3, R3, R5 ; move*40
      sub R2, R2, R3 ; coord - 40*move < 0: invalid
      store scriptAlertCurCoordSum, R2 ; store for future use
      shiftr0 R2, #15 ; takes MSB
      loadn R3, #1

      cmp R2, R3 ; if equal, invalid
                 ; else, valid
      jne scriptAlertChoiceFirstMoveUpValid

      ; compliment 2
      load R2, scriptAlertCurCoordSum
      not R2, R2
      inc R2

      scriptAlertChoiceFirstMoveUpInvalid:
        ; coordInvalid + (positive(coordInvalid)/40 + 1)*40
        loadn R3, #40
        div R2, R2, R3
        inc R2
        mul R2, R2, R3 ; (positive(coordInvalid)/40 + 1)*40
        load R3, scriptAlertCurCoordSum
        add R2, R2, R3 ; + coordResult

        storei R1, R2
        jmp scriptAlertChoiceGenerateScriptII

      scriptAlertChoiceFirstMoveUpValid:
        load R2, scriptAlertCurCoordSum
        storei R1, R2
        jmp scriptAlertChoiceGenerateScriptII

    scriptAlertChoiceFirstMoveDown:
      dec R1 ; addr where we'll store a coord
      loadn R3, #6
      add R2, R0, R3 ; addr to mob coord
      loadi R2, R2 ; mob coord
      
      ; we need to test if new coord is valid
      ; if coord + 40*move > 1678: invalid
      loadn R3, #40
      mul R3, R3, R5 ; move*40
      add R2, R2, R3 ; coord + 40*move > 1678: invalid
      store scriptAlertCurCoordSum, R2 ; store for future use
      loadn R3, #1678
      cmp R2, R3 ; if coord + 40*move > 1678: invalid
                 ; else, valid
      jel scriptAlertChoiceFirstMoveDownValid

      scriptAlertChoiceFirstMoveDownInvalid:
        ; invalid - ((invalid - 1640)/40)*40 = valid
        loadn R3, #1640
        sub R2, R2, R3
        loadn R3, #40
        div R2, R2, R3
        mul R2, R2, R3 ; ((invalid -1640)/40)*40
        load R3, scriptAlertCurCoordSum
        sub R2, R3, R2 ; invalid - ((invalid - 1640)/40)*40 

      scriptAlertChoiceFirstMoveDownValid:
        storei R1, R2
        jmp scriptAlertChoiceGenerateScriptII

    scriptAlertChoiceGenerateScriptII:
      ; mix everything up and generate script
      ; R2 = last coord stored
      ; R4 = last move side
      ; R6 = amount of moves last side x2
      ; R7 = side mob will end up facing
      inc R1
      inc R1 
      inc R1 ; addr to last side to move
      storei R1, R4 ; stores it

      loadn R3, #'r'
      cmp R4, R3 ; check what side it is
      jeq scriptAlertChoiceGenerateScriptIIRight

      loadn R3, #'l'
      cmp R4, R3 ; check what side it is
      jeq scriptAlertChoiceGenerateScriptIILeft

      loadn R3, #'u'
      cmp R4, R3 ; check what side it is
      jeq scriptAlertChoiceGenerateScriptIIUp

      loadn R3, #'d'
      cmp R4, R3 ; check what side it is
      jeq scriptAlertChoiceGenerateScriptIIDown

      ; IF THIS DOESN'T WORK, I CAN TRY (curCoord/40 + 1)*40 -2  WHEN INVALID!!!!!!!
      scriptAlertChoiceGenerateScriptIIRight:
        dec R1 ; addr where we'll store a coord
        
        ; we need to test if new coord is valid
        ; if first pos mod 40 > 29: (29 +9 = 38) AND (last pos mod 40 > 38 OR last pos mod 40 < 29)
        ; invalid
        loadn R3, #40
        mod R5, R2, R3 ; coord mod 40
        loadn R3, #29
        cmp R5, R3 ; (coord) mod 40 > 29 if eq or le, valid
                 ; else, next test
        jel scriptAlertChoiceGenerateScriptIIRightValid

        add R3, R2, R6 ; add movement
        loadn R4, #40
        mod R4, R3, R4 ; (coord + move) mod 40 > 38
        loadn R5, #38
        cmp R4, R5 ; if (coord + move) mod 40 > 38, invalid
                   ; else, test < 29
        jgr scriptAlertChoiceGenerateScriptIIRightInvalid ; if greater, invalid

        loadn R5, #29
        cmp R4, R5 ; if (coord + move) mod 40 < 29, invalid
                   ; else, valid
        jeg scriptAlertChoiceGenerateScriptIIRightValid

        scriptAlertChoiceGenerateScriptIIRightInvalid:
          ; Coord is invalid here
          ; (initialCoord/40 + 1)*40 -2
          ; we have to take mob.coord again
          sub R3, R3, R6 ; subtract movement so we get initialcoord
          loadn R4, #40
          div R3, R3, R4 ; (initialCoord/40)
          inc R4
          mul R3, R3, R4 ; (initialCoord/40 + 1)*40
          dec R3
          dec R3 ; (initialCoord/40 + 1)*40 -2

          storei R1, R3

          jmp scriptAlertChoiceGenerateScriptIII       

        scriptAlertChoiceGenerateScriptIIRightValid:
          ; find coord
          add R3, R2, R6 ; add movement
          ; store new coord
          storei R1, R3
          
          jmp scriptAlertChoiceGenerateScriptIII   

      ; IF THIS DOESN'T WORK, I CAN TRY (curCoord/40)*40 +1 WHEN INVALID!!!!!!!
      scriptAlertChoiceGenerateScriptIILeft:
        dec R1 ; addr where we'll store a coord
        
        ; we need to test if new coord is valid
        ; if first pos < 10 (10 + 9 = 1) AND (last pos <1 OR last pos >10)
        ; invalid
        loadn R4, #40
        mod R3, R2, R4 ; coord mod 40
        loadn R5, #10
        cmp R3, R5 ; (coord) mod 40 < 10 if eq or gr, valid
                   ; else, next test
        jeg scriptAlertChoiceGenerateScriptIILeftValid

        sub R3, R2, R6 ; subs movement
        mod R4, R3, R4 ; (coord - move) mod 40 < 1
        loadn R5, #1
        cmp R4, R5 ; if (coord - move) mod 40 < 1, invalid
                   ; else, test > 10
        jle scriptAlertChoiceGenerateScriptIILeftInvalid ; if lesser, invalid

        loadn R5, #10
        cmp R4, R5 ; if (coord - move) mod 40 > 10, invalid
                   ; else, valid
        jel scriptAlertChoiceGenerateScriptIILeftValid
      
        scriptAlertChoiceGenerateScriptIILeftInvalid:
          ; Coord is invalid here
          ; if negative or 0: coord = 1
          ; else if positive: (curCoord/40 +1)*40 + 1
          
          ; check if = 0
          loadn R5, #0
          cmp R3, R5 
          jeq scriptAlertChoiceGenerateScriptIILeftInvalidZeroNeg

          ; check if negative
          mov R4, R3
          shiftr0 R4, #15
          loadn R5, #1
          cmp R4, R5
          jeq scriptAlertChoiceGenerateScriptIILeftInvalidZeroNeg
          
          ; invalid positive
          ; (curCoord/40 +1)*40 + 1
          loadn R4, #40
          div R3, R3, R4 ; curCoord/40
          inc R3 ; curCoord/40 +1
          mul R3, R3, R4 ; (curCoord/40 +1)*40
          inc R3 ; (curCoord/40 +1)*40 + 1

          storei R1, R3

          jmp scriptAlertChoiceGenerateScriptIII

          scriptAlertChoiceGenerateScriptIILeftInvalidZeroNeg:
            ; min possible coord = 1
            loadn R3, #1
            storei R1, R3

            jmp scriptAlertChoiceGenerateScriptIII

          scriptAlertChoiceGenerateScriptIILeftValid:
            ; find new coord
            sub R3, R2, R6

            ; store it
            storei R1, R3
            jmp scriptAlertChoiceGenerateScriptIII

      scriptAlertChoiceGenerateScriptIIUp:
        dec R1 ; addr where we'll store a coord
        
        ; we need to test if new coord is valid
        ; if coord - 40*move < 0: invalid
        loadn R5, #40
        mul R3, R6, R5 ; move*40
        sub R3, R2, R3 ; coord - 40*move < 0: invalid
        store scriptAlertCurCoordSum, R3 ; store for future use
        shiftr0 R3, #15 ; takes MSB
        loadn R5, #1
        cmp R3, R5 ; if equal, invalid
                   ; else, valid
        jne scriptAlertChoiceGenerateScriptIIUpValid

        ; compliment 2
        load R3, scriptAlertCurCoordSum
        not R3, R3
        inc R3

        scriptAlertChoiceGenerateScriptIIUpInvalid:
          ; coordInvalid + (positive(coordInvalid)/40 + 1)*40
          loadn R5, #40
          div R4, R3, R5
          inc R4
          mul R4, R4, R5 ; (positive(coordResult)/40 + 1)*40
          load R2, scriptAlertCurCoordSum ; without compliment 2
          add R3, R2, R4 ; + coordResult
          
          storei R1, R3
          jmp scriptAlertChoiceGenerateScriptIII

        scriptAlertChoiceGenerateScriptIIUpValid:
          load R3, scriptAlertCurCoordSum
          storei R1, R3
          jmp scriptAlertChoiceGenerateScriptIII

      scriptAlertChoiceGenerateScriptIIDown:
        dec R1 ; addr where we'll store a coord
        
        ; we need to test if new coord is valid
        ; if coord + 40*move > 1678: invalid
        loadn R5, #40
        mul R5, R5, R6 ; move*40
        add R3, R2, R5 ; coord + 40*move > 1678: invalid
        loadn R4, #1678
        cmp R3, R4 ; if coord + 40*move > 1678: invalid
                   ; else, valid
        jel scriptAlertChoiceGenerateScriptIIDownValid

        scriptAlertChoiceGenerateScriptIIDownInvalid:
          ; invalid - ((invalid - 1640)/40)*40 = valid
          loadn R4, #1640
          sub R4, R3, R4 ; invalid - 1640
          div R4, R4, R5 ; (invalid - 1640)/40
          mul R4, R4, R5 ; ((invalid - 1640)/40)*40
          sub R3, R3, R4 ; invalid - ((invalid - 1640)/40)*40 

        scriptAlertChoiceGenerateScriptIIDownValid:
          storei R1, R3
          jmp scriptAlertChoiceGenerateScriptIII

      ; here we store side mob wil end facing
      scriptAlertChoiceGenerateScriptIII:
        inc R1
        inc R1

        storei R1, R7
        jmp scriptAlertFinish

      scriptAlertChoiceTurn:
      ; INCREASE DELAYMOBMOVE MORE !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        loadn R1, #9
        add R1, R1, R0 ; addr to side
        loadi R2, R1
        cmp R2, R7 ; if side is 1, side = 0
                  ; else, side = 1
        jne scriptAlertChoiceTurnRight

        dec R7
        storei R1, R7 ; stores 0 to side

        inc R1 ; addr to delaymove 1
        loadn R5, #10
        storei R1, R5

        loadn R1, #6
        add R1, R1, R0 ; addr to mob coord
        loadi R1, R1 ; mob coord
        loadn R2, #40
        add R1, R1, R2 ; right leg
        inc R1 ; right of right leg coord

        loadn R4, #renderVar
        loadi R2, R4
        cmp R1, R2 ; must be eq or gr than min rendervar
        jle scriptAlertFinish

        inc R4
        loadi R3, R4
        cmp R1, R3 ; must be lesser than max rendervar
        jeg scriptAlertFinish

        loadn R3, #mapTotal
        add R3, R1, R3 ; addr to pix info
        loadi R3, R3 ; pix info
        sub R1, R1, R2 ; coord - min rendervar.. finds coord in render

        outchar R3, R1

        jmp scriptAlertFinish

        scriptAlertChoiceTurnRight:
          storei R1, R7 ; stores 1 to side

          inc R1 ; addr to delaymove 1
          loadn R5, #10
          storei R1, R5

          loadn R1, #6
          add R1, R1, R0 ; addr to mob coord
          loadi R1, R1 ; mob coord
          loadn R2, #40
          add R1, R1, R2 ; left leg
          dec R1 ; left of left leg coord

          loadn R4, #renderVar
          loadi R2, R4
          cmp R1, R2 ; must be eq or gr than min rendervar
          jle scriptAlertFinish

          inc R4
          loadi R3, R4
          cmp R1, R3 ; must be lesser than max rendervar
          jeg scriptAlertFinish

          loadn R3, #mapTotal
          add R3, R1, R3 ; addr to pix info
          loadi R3, R3 ; pix info
          sub R1, R1, R2 ; coord - min rendervar.. finds coord in render

          outchar R3, R1

          jmp scriptAlertFinish

  scriptAlertFinish:
    pop R7
    pop R6
    pop R5
    pop R4
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

  ; DELAYYYYYYYYYYYYYYYYYYYYYYYYYYY
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
    call mobMoveRight
    
    loadn R6, #15
    add R6, R6, R0 ; addr to last movement
    loadn R7, #'h'
    storei R6, R7

    jmp scriptChaseFinish

  scriptChaseWalkLeft:
    call mobMoveLeft
    
    loadn R6, #15
    add R6, R6, R0 ; addr to last movement
    loadn R7, #'h'
    storei R6, R7

    jmp scriptChaseFinish

  scriptChaseWalkUp:
    call mobMoveUp
    
    loadn R6, #15
    add R6, R6, R0 ; addr to last movement
    loadn R7, #'v'
    storei R6, R7

    jmp scriptChaseFinish

  scriptChaseWalkDown:
    call mobMoveDown
    
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

  loadn R2, #6
  add R2, R2, R0 ; addr of mob coord
  
  ; reads script number of mob
  loadn R1, #12
  add R1, R1, R0
  loadi R3, R1 ; R3 will hold addr of script!!! 

  call scriptAction ; will use R2 as addr of mobCoord

  scriptMainFinish:
    pop R3
    pop R2
    pop R1
    rts

; R2 must be addr of mob coord
; R3 must be addr of script
scriptAction:
  push R2
  push R3
  push R4
  push R5
  push R6

  loadi R4, R3 ; reads phase number

  ; check if we reached the end (script[1 + 2*phaseNum] == 0)
  loadn R5, #2
  mul R4, R4, R5
  inc R4
  add R6, R3, R4 ; R6 = addr script[1+2*phaseNum]
  loadi R4, R6 ; R4 = script[1+2*phaseNum]

  ; check if we finished
  loadn R5, #0
  cmp R4, R5 ; if == 0, phaseNum = 0
  jeq scriptActionLastPhase

  inc R5
  cmp R4, R5 ; if == 5, phaseNum = 0, side = 1
  jeq scriptActionLastPhaseSideRight

  ; check if mob already in checkpoint, 
  ; mob might have 0 movement in scriptalert, so second coord will be
  ; equal to first, it will move and break the script
  loadi R2, R2 ; mobCoord
  cmp R2, R4
  jeq scriptActionAddPhase

  ; R3 = script1 addr
  ; R2 = addr of mob coord
  ; R4 = script[1+2*phaseNum]
  call mobMoveChoice
  loadi R2, R2 ; new value of mobCoord
  cmp R2, R4
  cne renderMob ; if mob coord == script[1 + 2*phasenum] 
                        ; we've reached our destintion, inc 1 to sscript[0]
  jne scriptActionFinish

  scriptActionAddPhase:
    loadi R4, R3
    inc R4 ; loads script#[0] inc and stores it
    storei R3, R4

  call renderMob
  jmp scriptActionFinish

  ; store side right to mob
  scriptActionLastPhaseSideRight:
    loadn R4, #9
    add R4, R4, R0 ; addr to side
    loadn R5, #1
    storei R4, R5

    ; restore background
    loadn R1, #6
    add R1, R1, R0 ; addr to mob coord
    loadi R1, R1 ; mob coord

    ; reaching coord
    loadn R2, #40
    add R1, R1, R2 ; one coord below
    dec R1 ; coord to restore
    
    ; checks if coord is on screen
    loadn R5, #renderVar
    loadi R4, R5
    cmp R1, R4 ; has to be eq or gr
              ; else, delay and finish
    jle scriptActionLastPhase

    inc R5
    loadi R5, R5 ; max render var
    cmp R1, R5 ; has to be le
              ; else, delay and finish
    jeg scriptActionLastPhase

    ; let's restore the background now
    loadn R2, #mapTotal
    add R2, R2, R1 ; addr to pix info
    loadi R2, R2 ; pix info

    sub R1, R1, R4 ; coord in screen
    outchar R2, R1

  ; R3 must be addr of script
  scriptActionLastPhase:
    loadn R4, #0
    storei R3, R4 ; restarts num phase

    call renderMob  

  scriptActionFinish:
    pop R6
    pop R5
    pop R4
    pop R3
    pop R2
    rts

renderMob:
  push FR
  push R1
  push R2
  push R3
  push R4
  push R5
  push R6
  push R7
  ; check if coord right to render 
  ; checks first y
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
    jle renderMobFinish

    ; now checking max renderCoord
    inc R5
    loadi R2, R5
    cmp R1, R2 ; check if mapCoord lesser than maxCoord (exclusive)
    jeg renderMobFinish

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

        jmp renderMobFinish

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

  renderMobFinish:
    pop R7
    pop R6
    pop R5
    pop R4
    pop R3
    pop R2
    pop R1
    pop FR
    rts


; will use R3 as script addr and
; R0 as mob addr
; R6 = addr script[1+2*phaseNum]
mobMoveChoice:
  push R1
  push R2
  push R6
  
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
  ceq mobMoveRight

  loadn R2, #'l'
  cmp R1, R2 ; if true, move left
  ceq mobMoveLeft

  loadn R2, #'d'
  cmp R1, R2 ; if true, move down
  ceq mobMoveDown

  loadn R2, #'u'
  cmp R1, R2 ; if true, move up
  ceq mobMoveUp

  loadn R2, #'s'
  cmp R1, R2 ; if true, change side and add to delaymove
  ceq mobMoveSide

  mobMoveChoiceFinish:
    pop R6
    pop R2
    pop R1
    rts

mobMoveSide:
  push R1
  push R2
  push R3
  push R4
  push R5

  loadn R1, #9
  add R1, R1, R0 ; addr to side
  loadi R2, R1 ; side mob is looking at

  loadn R3, #0
  cmp R2, R3 ; if equal, store 1
             ; else, store 0
  jne mobMoveSideStoreLeft

  loadn R3, #1
  storei R1, R3 ; stores right side

  ; restore background
  loadn R1, #6
  add R1, R1, R0 ; addr to mob coord
  loadi R1, R1 ; mob coord

  ; reaching coord
  loadn R2, #40
  add R1, R1, R2 ; one coord below
  dec R1 ; coord to restore
  
  ; checks if coord is on screen
  loadn R5, #renderVar
  loadi R4, R5
  cmp R1, R4 ; has to be eq or gr
             ; else, delay and finish
  jle mobMoveSideDelay

  inc R5
  loadi R5, R5 ; max render var
  cmp R1, R5 ; has to be le
             ; else, delay and finish
  jeg mobMoveSideDelay

  ; let's restore the background now
  loadn R2, #mapTotal
  add R2, R2, R1 ; addr to pix info
  loadi R2, R2 ; pix info

  sub R1, R1, R4 ; coord in screen
  outchar R2, R1

  jmp mobMoveSideDelay

  mobMoveSideStoreLeft:
    storei R1, R3 ; stores left side

    ; restore background
    loadn R1, #6
    add R1, R1, R0 ; addr to mob coord
    loadi R1, R1 ; mob coord

    ; reaching coord
    loadn R2, #40
    add R1, R1, R2 ; one doord below
    inc R1 ; coord to restore
    
    ; checks if coord is on screen
    loadn R5, #renderVar
    loadi R4, R5
    cmp R1, R4 ; has to be eq or gr
              ; else, delay and finish
    jle mobMoveSideDelay

    inc R5
    loadi R5, R5 ; max render var
    cmp R1, R5 ; has to be le
              ; else, delay and finish
    jeg mobMoveSideDelay

    ; let's restore the background now
    loadn R2, #mapTotal
    add R2, R2, R1 ; addr to pix info
    loadi R2, R2 ; pix info

    sub R1, R1, R4 ; coord in screen
    outchar R2, R1
  
  mobMoveSideDelay:
    loadn R1, #10
    add R1, R1, R0 ; addr to delaymob move 1
    loadn R2, #25
    storei R1, R2 ; stores 25 to delaymob move, 25 times more
  
  mobMoveSideFinish:
    pop R5
    pop R4
    pop R3
    pop R2
    pop R1
    rts


mobMoveUp:
  push R1
  push R2
  push R3
  push R4
  push R5
  push R6
  push R7

  loadn R2, #6
  add R2, R2, R0 ; addr to mapcoord
  loadi R1, R2

  ; if coord < 40, do nothing
  loadn R4, #40
  cmp R1, R4
  jle mobMoveUpFinish

  ; update map coord
  call renderSymbolBackground ; unrender symbol chase/alert
  loadi R3, R2
  sub R3, R3, R4; -40 mapcoord
  storei R2, R3

  ; test side to restore background
  loadn R4, #9
  add R1, R0, R4 ; addr to side
  loadi R1, R1

  loadn R4, #0
  cmp R1, R4 ; if not equal, restore right
  jne mobMoveUpRestoreRight

  ; test render coords
  loadn R4, #40
  add R3, R3, R4 ; one down y axis, test wings line

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
  dec R1 ; addr to min rendervar

  inc R3 ; past wings coord
  loadn R5, #mapTotal
  add R5, R3, R5 ; addr to pix info
  loadi R6, R5 ; pix info
  loadi R4, R1 ; min rendervar
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
    jle mobMoveUpFinish

    inc R2
    loadi R1, R2 ; max rendervar
    cmp R3, R1 ; must be lesser than max coord
                ; else, finish
    jeg mobMoveUpFinish

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

    jmp mobMoveUpFinish

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
      jle mobMoveUpFinish

      inc R2
      loadi R1, R2 ; max rendervar
      cmp R3, R1 ; must be lesser than max coord
                  ; else, finish
      jeg mobMoveUpFinish

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

  mobMoveUpFinish:
    pop R7
    pop R6
    pop R5
    pop R4
    pop R3
    pop R2
    pop R1
    rts


mobMoveDown:
  push R1
  push R2
  push R3
  push R4
  push R5
  push R6
  push R7

  loadn R2, #6
  add R2, R2, R0 ; addr to mapcoord
  loadi R1, R2

  ; if coord > 1639, do nothing
  loadn R4, #1639
  cmp R1, R4
  jgr mobMoveDownFinish

  ; update map coord
  call renderSymbolBackground ; unrender symbol chase/alert
  loadi R3, R2
  loadn R4, #40
  add R3, R3, R4; +40 mapcoord
  storei R2, R3

  ; restore background
  loadn R4, #40
  sub R3, R3, R4 ; past mob coord
  
  loadn R5, #renderVar
  loadi R4, R5 ; map coord must equal or  greater than min var render

  cmp R3, R4 ; if equal or greater, test maxCoord
              ; else, finish
  jle mobMoveDownFinish

  inc R5 ; addr to max coord
  loadi R4, R5
  cmp R3, R4 ; if lesser, render background
              ; else, finish
  jeg mobMoveDownFinish

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

  mobMoveDownFinish:
    pop R7
    pop R6
    pop R5
    pop R4
    pop R3
    pop R2
    pop R1
    rts


mobMoveLeft:
  push R1
  push R2
  push R3
  push R4
  push R5
  push R6
  push R7

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
  jeq mobMoveLeftFinish

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
    jle mobMoveLeftFinish

    inc R5 ; addr to max rendervar
    loadi R4, R5
    cmp R3, R4 ; if lesser, render background
              ; else, do nothing
    jeg mobMoveLeftFinish

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

mobMoveLeftFinish:
  pop R7
  pop R6
  pop R5
  pop R4
  pop R3
  pop R2
  pop R1
  rts


mobMoveRight:
  push R1
  push R2
  push R3
  push R4
  push R5
  push R6
  push R7

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
  jeq mobMoveRightFinish

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
    jle mobMoveRightFinish

    inc R5 ; addr to max rendervar
    loadi R4, R5
    cmp R3, R4 ; if lesser, render background
                ; else, do nothing
    jeg mobMoveRightFinish

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

  mobMoveRightFinish:
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
  loadn R4, #2000
  storei R1, R4 ; stores 65000  in timer 2
  loadn R2, #1 ; bool = true

  jmp delayMoveMobFinish

  delayMoveMobTimer1Not0:
    dec R2
    storei R1, R2 ; decrements and stores timer 1

    inc R1 ; addr to timer 2
    loadn R2, #2000
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
    loadn R4, #75
    storei R2, R4 ; stores 50 to timer1
    inc R2
    loadn R4, #65000
    storei R2, R4 ; stores 65000 to timer2
    loadn R4, #6
    sub R2, R2, R4 ; addr of alertBool
    storei R2, R3 ; stores 0 to alertBool

    ; resets delayMobMov
    loadn R1, #10
    add R1, R1, R0 ; addr to delayMobMove1
    loadn R2, #0
    storei R1, R2 ; resets it
    inc R1 ; addr to delayMobMove2
    storei R1, R2 ; resets it

    ; activates return bool
    loadn R1, #17
    add R1, R1, R0 ; addr to return bool
    loadn R2, #1
    storei R1, R2 ; activates

    ; unrenders inter
    loadn R1, #6
    add R1, R1, R0 ; addr to mobCoord
    loadi R1, R1
    loadn R2, #80
    sub R1, R1, R2 ; coord inMap of inter

    ; tests if coord in screen
    loadn R4, #renderVar
    loadi R3, R4 ; min rendervar
    cmp R1, R3 ; has to be eq or gr
               ; else, finish
    jle delayMobAlertFinish

    inc R4
    loadi R4, R4 ; max rendervar
    cmp R1, R4 ; has to be le
               ; else, finish
    jeg delayMobAlertFinish

    ; getting pixel info on mapTotal
    loadn R2, #mapTotal
    add R2, R1, R2 ; addr of mapTotal pix
    loadi R2, R2 ; pix info
    
    ; gets coordinRender
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
  loadn R2, #80
  sub R1, R1, R2 ; coord of symbol inmap

  ; check if coord on screen
  loadn R3, #renderVar
  loadi R2, R3 ; min rendervar

  cmp R1, R2 ; has to be eq or gr
  jle renderExclaInterFinish

  inc R3
  loadi R3, R3 ; max rendervar
  cmp R1, R3 ; has to be le
  jeg renderExclaInterFinish

  ; actual rendering
  sub R2, R1, R2 ; coord - min rendervar
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
    loadn R2, #80
    sub R1, R1, R2 ; coord to symbol
    
    ; check if symbol below min rendervar
    load R2, renderVar ; min var of render
    cmp R1, R2 ; has to be eq or gr
    jle renderExclaInterFinish

    loadn R2, #renderVar
    inc R2
    loadi R2, R2
    cmp R1, R2 ; has to be le
    jeg renderExclaInterFinish

    ; actual rendering
    load R2, renderVar
    sub R1, R1, R2 ; coord - min rendervar

    loadn R3, #3135 ; interogation
    outchar R3, R1

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

    ; mob map coord must be eq or lower than maxRenderVar + 79
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
      ; check if coord on screen
      loadn R4, #renderVar
      loadi R3, R4 ; min render var
      cmp R5, R3 ; must be eq or gr
      jle renderSymbolBackgroundFinish

      inc R4
      loadi R4, R4 ; max rendervar
      cmp R5, R4 ; must be le
      jeg renderSymbolBackgroundFinish

      ; actual rendering
      loadn R3, #mapTotal
      add R3, R3, R5 ; addr pixel info in map for background
      loadi R3, R3 ; info for pixel
      load R4, renderVar
      sub R4, R5, R4 ; symbol coord in map - min render pixel = symbol coord in render
                      ; R4 = symbol coord in render
      outchar R3, R4
    
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
    
    loadn R0, #2000
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
  loadn R0, #2000
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
  
  loadn R1, #32 ; space
  cmp R0, R1
  jeq playerMoveSpace

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

  playerMoveSpace:
   ; check if player in right coord
    load R0, playerCoordInMap
    loadn R1, #1275
    cmp R0, R1 
    jeq playerMoveSpaceEatBaby

    loadn R1, #1274
    cmp R0, R1 
    jeq playerMoveSpaceEatBaby

    loadn R1, #1273
    cmp R0, R1 
    jeq playerMoveSpaceEatBaby

    loadn R1, #1312
    cmp R0, R1 
    jeq playerMoveSpaceEatBaby

    loadn R1, #1351
    cmp R0, R1 
    jeq playerMoveSpaceEatBaby

    loadn R1, #1391
    cmp R0, R1 
    jeq playerMoveSpaceEatBaby

    jmp playerMoveFinish

    playerMoveSpaceEatBaby:
      loadn R0, #1
      store babyBee, R0 ; stores 1 to baby bee, baby bee has been eaten
      
      call render
      call renderPlayer

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
      ; check if coord on screen
      ; player render coord always equal to coordInMap
      loadn R3, #renderVar
      loadi R2, R3 ; min rendervar

      load R3, playerCoordInMap

      cmp R3, R2 ; has to be eq or gr
      jle checkRightLegStealth

      loadn R3, #renderVar
      inc R3
      loadi R2, R3 ; max rendervar
      load R3, playerCoordInMap

      cmp R3, R2 ; has to be le
      jeg checkRightLegStealth

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
      ; check if coord on screen
      ; player render coord always equal to coordInMap
      loadn R3, #renderVar
      loadi R2, R3 ; min rendervar

      load R3, playerCoordInMap

      cmp R3, R2 ; has to be eq or gr
      jle checkRightLegStealth

      loadn R3, #renderVar
      inc R3
      loadi R2, R3 ; max render var
      load R3, playerCoordInMap

      cmp R3, R2 ; has to be le
      jeg checkRightLegStealth

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

    loadn R2, #1
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
        ; check if coord on screen
        ; player render coord always equal to coordInMap
        loadn R3, #renderVar
        loadi R2, R3 ; min rendervar

        load R3, playerCoordInMap

        cmp R3, R2 ; has to be eq or gr
        jle finishRenderPlayer
        
        loadn R3, #renderVar
        inc R3
        loadi R2, R3 ; max render var
        load R3, playerCoordInMap

        cmp R3, R2 ; has to be le
        jeg finishRenderPlayer

        outchar R1, R0

  checkLeftLegStealth:
    ; checks if left leg is in stealth coord
    loadn R2, #1
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

        ; check if coord on screen
        ; player render coord always equal to coordInMap
        loadn R3, #renderVar
        loadi R2, R3 ; min rendervar

        load R3, playerCoordInMap

        cmp R3, R2 ; has to be eq or gr
        jle activateStealth
        
        loadn R3, #renderVar
        inc R3
        loadi R2, R3 ; max render var
        load R3, playerCoordInMap

        cmp R3, R2 ; has to be le
        jeg activateStealth

        outchar R1, R0

  activateStealth:
    loadn R2, #1
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

checkCollision:
  push R0
  push R1
  push R2

  ; loads all possible collision coords into an array
  load R0, playerCoordInMap
  loadn R1, #40
  dec R0 ; left of left face
  loadn R2, #checkCollisionPlayerCoords
  storei R2, R0
  
  add R0, R0, R1 ; left of left leg
  inc R2
  storei R2, R0

  add R0, R0, R1
  inc R0 ; below left leg
  inc R2
  storei R2, R0

  inc R2
  inc R0 ; below right leg
  storei R2, R0

  sub R0, R0, R1
  inc R0 ; right of right leg
  inc R2
  storei R2, R0

  sub R0, R0, R1 ; right of right face
  inc R2
  storei R2, R0

  dec R0
  sub R0, R0, R1 ; above right face
  inc R2
  storei R2, R0

  dec R0 ; above left face
  inc R2
  storei R2, R0

  ; checks if mob1 is active and in range
  loadn R1, #1
  load R0, mob1
  cmp R0, R1

  loadn R0, #mob1
  ceq checkCollisionMob

  ; checks if mob2 is active and in range
  load R0, mob2
  cmp R0, R1

  loadn R0, #mob2
  ceq checkCollisionMob

  ; checks if mob3 is active and in range
  load R0, mob3
  cmp R0, R1

  loadn R0, #mob3
  ceq checkCollisionMob

  ; checks if mob4 is active and in range
  load R0, mob4
  cmp R0, R1

  loadn R0, #mob4
  ceq checkCollisionMob

  pop R2
  pop R1
  pop R0
  rts

; will check if player and mob touches, so player gets killed
checkCollisionMob:
  push R0
  push R1
  push R2
  push R3
  push R4
  push R5

  loadn R3, #0 ; var for first loop
  loadn R2, #checkCollisionPlayerCoords
  loadn R4, #8 ; first loop limit

  loadn R1, #6
  add R0, R0, R1 ; addr to mob coord
  loadi R0, R0 ; mob coord
  call checkCollisionMobFirstLoop
  
  inc R0 ; mob left face
  loadn R2, #checkCollisionPlayerCoords
  loadn R3, #0
  call checkCollisionMobFirstLoop

  loadn R5, #40
  add R0, R0, R5 ; mob right leg coord
  loadn R2, #checkCollisionPlayerCoords
  loadn R3, #0
  call checkCollisionMobFirstLoop

  dec R0 ; mob left leg
  loadn R2, #checkCollisionPlayerCoords
  loadn R3, #0
  call checkCollisionMobFirstLoop

  jmp checkCollisionMobFinish
  
  ; will loop through collisionplayercoords
  checkCollisionMobFirstLoop:
    loadi R1, R2 ; cur coord to be checked
    cmp R0, R1
    ceq playerDeath

    inc R2 ; next coord to be checked
    inc R3 ; increments var to limit

    cmp R3, R4 ; R3 mas be lesser than 8
    jle checkCollisionMobFirstLoop
    rts

  checkCollisionMobFinish:
    pop R5
    pop R4
    pop R3
    pop R2
    pop R1
    pop R0
    rts

playerDeath:
  ; delay so player can see collision
  call collisionDelay

  call printdeathscreenScreen
  loadn R0, #1
  store curLevel, R0 ; goes back to first level

  ; restart scripts
  call restartScripts

  call spaceLoop ; loops until space is pressed
  jmp startGame ; jumps to 0

collisionDelay:
  push R0
  push R1

  loadn R0, #10000
  loadn R1, #0
  collisionDelayLoop:
    dec R0
    cmp R0, R1
    jne collisionDelayLoop
  
  pop R1
  pop R0
  rts

restartScripts:
  push R0
  push R1

  ; restarting alert and return scripts
  loadn R0, #scriptReturnMob1
  loadn R1, #65535
  storei R0, R1
  loadn R0, #scriptAlertMob1
  storei R0, R1
  loadn R0, #scriptReturnMob2
  storei R0, R1
  loadn R0, #scriptAlertMob2
  storei R0, R1
  loadn R0, #scriptReturnMob3
  storei R0, R1
  loadn R0, #scriptAlertMob3
  storei R0, R1
  loadn R0, #scriptReturnMob4
  storei R0, R1
  loadn R0, #scriptAlertMob4
  storei R0, R1

  ; restarting std scripts
  loadn R0, #script1
  loadn R1, #0
  storei R0, R1

  loadn R0, #script2
  storei R0, R1

  loadn R0, #script3
  storei R0, R1

  loadn R0, #script4
  storei R0, R1

  loadn R0, #script5
  storei R0, R1

  loadn R0, #script6
  storei R0, R1

  loadn R0, #script7
  storei R0, R1

  loadn R0, #script8
  storei R0, R1

  pop R1
  pop R0
  rts


printdeathscreenScreen:
  push R0
  push R1
  push R2
  push R3

  loadn R0, #deathscreen
  loadn R1, #0
  loadn R2, #1200

  printdeathscreenScreenLoop:

    add R3,R0,R1
    loadi R3, R3
    outchar R3, R1
    inc R1
    cmp R1, R2

    jne printdeathscreenScreenLoop

  pop R3
  pop R2
  pop R1
  pop R0
  rts

printinstructionScreen:
  push R0
  push R1
  push R2
  push R3
  push FR

  loadn R0, #instructionScreen
  loadn R1, #0
  loadn R2, #1200

  printinstructionScreenScreenLoop:

    add R3,R0,R1
    loadi R3, R3
    outchar R3, R1
    inc R1
    cmp R1, R2

    jne printinstructionScreenScreenLoop

  pop FR
  pop R3
  pop R2
  pop R1
  pop R0
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

babyBee: var #1
  static babyBee, #0 ; has baby bee been eaten?


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


; MOB INFOS
mob1: var #19
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
  static mob1 + #11, #2000 ; delay mobMove2
  static mob1 + #12, #0 ; pointer to script
  static mob1 + #13, #12 ; alertTimer 1, changed from 75
  static mob1 + #14, #65000 ; alertTimer 2 from max
  static mob1 + #15, #0 ; last movememt, vertical or horizontal
  static mob1 + #16, #scriptAlertMob1 ; pointer
  static mob1 + #17, #0 ; return bool
  static mob1 + #18, #scriptReturnMob1 ; pointer

scriptReturnMob1: var #6
  static scriptReturnMob1 + #0, #65535 ; phase number
  static scriptReturnMob1 + #1, #0 ; coord to go
  static scriptReturnMob1 + #2, #0 ; side to go
  static scriptReturnMob1 + #3, #0 ; coord to go
  static scriptReturnMob1 + #4, #0 ; side to go 
  static scriptReturnMob1 + #5, #0 ; finish

scriptAlertMob1: var #6
  static scriptAlertMob1 + #0, #65535 ; phase number
  static scriptAlertMob1 + #1, #0 ; coord to go
  static scriptAlertMob1 + #2, #0 ; side to go
  static scriptAlertMob1 + #3, #0 ; coord to go
  static scriptAlertMob1 + #4, #0 ; side to go 
  static scriptAlertMob1 + #5, #0 ; side to look at

mob2: var #19
  static mob2 + #0, #0 ; if it's active or not
  static mob2 + #1, #2822 ; left face skin
  static mob2 + #2, #2823 ; right face skin
  static mob2 + #3, #2825 ; left leg skin
  static mob2 + #4, #2824 ; right leg skin
  static mob2 + #5, #2053 ; wings
  static mob2 + #6, #0 ; mobCoordInMap; coord in render will be calculated
  static mob2 + #7, #0 ; chase bool
  static mob2 + #8, #0 ; alert bool
  static mob2 + #9, #1 ; side that mob is looking at, 0 for left, 1 for right
  static mob2 + #10, #1 ; delay mobMove1 
  static mob2 + #11, #2000 ; delay mobMove2
  static mob2 + #12, #0 ; pointer to script
  static mob2 + #13, #12 ; alertTimer 1, changed from 75
  static mob2 + #14, #65000 ; alertTimer 2 from max
  static mob2 + #15, #0 ; last movememt, vertical or horizontal
  static mob2 + #16, #scriptAlertMob2 ; pointer
  static mob2 + #17, #0 ; return bool
  static mob2 + #18, #scriptReturnMob2 ; pointer

scriptReturnMob2: var #6
  static scriptReturnMob2 + #0, #65535 ; phase number
  static scriptReturnMob2 + #1, #0 ; coord to go
  static scriptReturnMob2 + #2, #0 ; side to go
  static scriptReturnMob2 + #3, #0 ; coord to go
  static scriptReturnMob2 + #4, #0 ; side to go 
  static scriptReturnMob2 + #5, #0 ; finish

scriptAlertMob2: var #6
  static scriptAlertMob2 + #0, #65535 ; phase number
  static scriptAlertMob2 + #1, #0 ; coord to go
  static scriptAlertMob2 + #2, #0 ; side to go
  static scriptAlertMob2 + #3, #0 ; coord to go
  static scriptAlertMob2 + #4, #0 ; side to go 
  static scriptAlertMob2 + #5, #0 ; side to look at

mob3: var #19
  static mob3 + #0, #0 ; if it's active or not
  static mob3 + #1, #2822 ; left face skin
  static mob3 + #2, #2823 ; right face skin
  static mob3 + #3, #2825 ; left leg skin
  static mob3 + #4, #2824 ; right leg skin
  static mob3 + #5, #2053 ; wings
  static mob3 + #6, #0 ; mobCoordInMap; coord in render will be calculated
  static mob3 + #7, #0 ; chase bool
  static mob3 + #8, #0 ; alert bool
  static mob3 + #9, #1 ; side that mob is looking at, 0 for left, 1 for right
  static mob3 + #10, #1 ; delay mobMove1 
  static mob3 + #11, #2000; delay mobMove2
  static mob3 + #12, #0 ; pointer to script
  static mob3 + #13, #12 ; alertTimer 1, changed from 75
  static mob3 + #14, #65000 ; alertTimer 2 from max
  static mob3 + #15, #0 ; last movememt, vertical or horizontal
  static mob3 + #16, #scriptAlertMob3 ; pointer
  static mob3 + #17, #0 ; return bool
  static mob3 + #18, #scriptReturnMob3 ; pointer

scriptReturnMob3: var #6
  static scriptReturnMob3 + #0, #65535 ; phase number
  static scriptReturnMob3 + #1, #0 ; coord to go
  static scriptReturnMob3 + #2, #0 ; side to go
  static scriptReturnMob3 + #3, #0 ; coord to go
  static scriptReturnMob3 + #4, #0 ; side to go 
  static scriptReturnMob3 + #5, #0 ; finish

scriptAlertMob3: var #6
  static scriptAlertMob3 + #0, #65535 ; phase number
  static scriptAlertMob3 + #1, #0 ; coord to go
  static scriptAlertMob3 + #2, #0 ; side to go
  static scriptAlertMob3 + #3, #0 ; coord to go
  static scriptAlertMob3 + #4, #0 ; side to go 
  static scriptAlertMob3 + #5, #0 ; side to look at

mob4: var #19
  static mob4 + #0, #0 ; if it's active or not
  static mob4 + #1, #2822 ; left face skin
  static mob4 + #2, #2823 ; right face skin
  static mob4 + #3, #2825 ; left leg skin
  static mob4 + #4, #2824 ; right leg skin
  static mob4 + #5, #2053 ; wings
  static mob4 + #6, #0 ; mobCoordInMap; coord in render will be calculated
  static mob4 + #7, #0 ; chase bool
  static mob4 + #8, #0 ; alert bool
  static mob4 + #9, #1 ; side that mob is looking at, 0 for left, 1 for right
  static mob4 + #10, #1 ; delay mobMove1 
  static mob4 + #11, #2000; delay mobMove2
  static mob4 + #12, #0 ; pointer to script
  static mob4 + #13, #12 ; alertTimer 1, changed from 75
  static mob4 + #14, #65000 ; alertTimer 2 from max
  static mob4 + #15, #0 ; last movememt, vertical or horizontal
  static mob4 + #16, #scriptAlertMob4 ; pointer
  static mob4 + #17, #0 ; return bool
  static mob4 + #18, #scriptReturnMob4 ; pointer

scriptReturnMob4: var #6
  static scriptReturnMob4 + #0, #65535 ; phase number
  static scriptReturnMob4 + #1, #0 ; coord to go
  static scriptReturnMob4 + #2, #0 ; side to go
  static scriptReturnMob4 + #3, #0 ; coord to go
  static scriptReturnMob4 + #4, #0 ; side to go 
  static scriptReturnMob4 + #5, #0 ; finish

scriptAlertMob4: var #6
  static scriptAlertMob4 + #0, #65535 ; phase number
  static scriptAlertMob4 + #1, #0 ; coord to go
  static scriptAlertMob4 + #2, #0 ; side to go
  static scriptAlertMob4 + #3, #0 ; coord to go
  static scriptAlertMob4 + #4, #0 ; side to go 
  static scriptAlertMob4 + #5, #0 ; side to look at

; starts at 841
script1: var #8
  static script1 + #0, #0 ; phase number
  static script1 + #1, #841
  static script1 + #2, #'l'
  static script1 + #3, #877
  static script1 + #4, #'r' ; right
  static script1 + #5, #841
  static script1 + #6, #'l' ; left
  static script1 + #7, #0

; starts at 1152
script2: var #12
  static script2 + #0, #0 ; phase number
  static script2 + #1, #1152
  static script2 + #2, #'l' 
  static script2 + #3, #1158
  static script2 + #4, #'r' ; right
  static script2 + #5, #1438
  static script2 + #6, #'d' ; down
  static script2 + #7, #1158
  static script2 + #8, #'u' ; up
  static script2 + #9, #1152
  static script2 + #10, #'l' ; left
  static script2 + #11, #0

; starts at 1143
script3: var #24
  static script3 + #0, #0 ; phase number
  static script3 + #1, #1143
  static script3 + #2, #'l'
  static script3 + #3, #1147
  static script3 + #4, #'r' ; right
  static script3 + #5, #1387
  static script3 + #6, #'d' ; down
  static script3 + #7, #1385
  static script3 + #8, #'l' ; left
  static script3 + #9, #1265
  static script3 + #10, #'u' ; up
  static script3 + #11, #1261
  static script3 + #12, #'l' ; left
  static script3 + #13, #1101
  static script3 + #14, #'u' ; up
  static script3 + #15, #1097
  static script3 + #16, #'l' ; left
  static script3 + #17, #977
  static script3 + #18, #'u' ; up
  static script3 + #19, #983
  static script3 + #20, #'r' ; right
  static script3 + #21, #1143
  static script3 + #22, #'d' ; down
  static script3 + #23, #0

; starts at 1084
script4: var #12
  static script4 + #0, #0 ; phase number
  static script4 + #1, #1085
  static script4 + #2, #'u'
  static script4 + #3, #1097
  static script4 + #4, #'r' ; right
  static script4 + #5, #1377
  static script4 + #6, #'d' ; down
  static script4 + #7, #1365
  static script4 + #8, #'l' ; left
  static script4 + #9, #1085
  static script4 + #10, #'u' ; up
  static script4 + #11, #0

; coord 1629
script5: var #6
  static script5 + #0, #0
  static script5 + #1, #1629
  static script5 + #2, #0
  static script5 + #3, #65535
  static script5 + #4, #'s'
  static script5 + #5, #0

; starts at 875
script6: var #4
  static script6 + #0, #0 ; phase number
  static script6 + #1, #875
  static script6 + #2, #0
  static script6 + #3, #1

; starts at 1270
script7: var #4
  static script7 + #0, #0 ; phase number
  static script7 + #1, #1155
  static script7 + #2, #0
  static script7 + #3, #1

; starts at 1628
script8: var #8
  static script8 + #0, #0 ; phase number
  static script8 + #1, #1624
  static script8 + #2, #'l'
  static script8 + #3, #1636
  static script8 + #4, #'r' ; right
  static script8 + #5, #1624
  static script8 + #6, #'l' ; left
  static script8 + #7, #0

scriptAlertCurCoordSum: var #1
  static scriptAlertCurCoordSum + #0, #0 

curLevel: var #1
  static curLevel, #1

; for slide of begginning of level
slideCounter: var #2
  static slideCounter + #0, #10
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

checkCollisionPlayerCoords: var #8
  static checkCollisionPlayerCoords + #0, #0
  static checkCollisionPlayerCoords + #1, #0
  static checkCollisionPlayerCoords + #2, #0
  static checkCollisionPlayerCoords + #3, #0
  static checkCollisionPlayerCoords + #4, #0
  static checkCollisionPlayerCoords + #5, #0
  static checkCollisionPlayerCoords + #6, #0
  static checkCollisionPlayerCoords + #7, #0


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

menu : var #1200
  ;Linha 0
  static menu + #0, #2560
  static menu + #1, #2560
  static menu + #2, #2560
  static menu + #3, #2560
  static menu + #4, #2560
  static menu + #5, #2560
  static menu + #6, #2560
  static menu + #7, #2560
  static menu + #8, #2560
  static menu + #9, #2560
  static menu + #10, #2560
  static menu + #11, #2560
  static menu + #12, #2560
  static menu + #13, #2560
  static menu + #14, #2560
  static menu + #15, #2560
  static menu + #16, #2560
  static menu + #17, #2560
  static menu + #18, #2560
  static menu + #19, #2560
  static menu + #20, #2560
  static menu + #21, #2560
  static menu + #22, #2560
  static menu + #23, #2560
  static menu + #24, #2560
  static menu + #25, #2560
  static menu + #26, #2560
  static menu + #27, #2560
  static menu + #28, #2560
  static menu + #29, #2560
  static menu + #30, #2560
  static menu + #31, #2560
  static menu + #32, #2560
  static menu + #33, #2560
  static menu + #34, #2560
  static menu + #35, #2560
  static menu + #36, #2560
  static menu + #37, #2560
  static menu + #38, #2560
  static menu + #39, #2560

  ;Linha 1
  static menu + #40, #2560
  static menu + #41, #2560
  static menu + #42, #2560
  static menu + #43, #2560
  static menu + #44, #2560
  static menu + #45, #2560
  static menu + #46, #2560
  static menu + #47, #2560
  static menu + #48, #2560
  static menu + #49, #2560
  static menu + #50, #2560
  static menu + #51, #2560
  static menu + #52, #2560
  static menu + #53, #2560
  static menu + #54, #2560
  static menu + #55, #2560
  static menu + #56, #2560
  static menu + #57, #2560
  static menu + #58, #2560
  static menu + #59, #2560
  static menu + #60, #2560
  static menu + #61, #2560
  static menu + #62, #2560
  static menu + #63, #2560
  static menu + #64, #2560
  static menu + #65, #2560
  static menu + #66, #2560
  static menu + #67, #2560
  static menu + #68, #2560
  static menu + #69, #2560
  static menu + #70, #2560
  static menu + #71, #2560
  static menu + #72, #2560
  static menu + #73, #2560
  static menu + #74, #2560
  static menu + #75, #2560
  static menu + #76, #2560
  static menu + #77, #2560
  static menu + #78, #2560
  static menu + #79, #2560

  ;Linha 2
  static menu + #80, #2560
  static menu + #81, #2560
  static menu + #82, #2560
  static menu + #83, #2560
  static menu + #84, #2560
  static menu + #85, #2560
  static menu + #86, #2560
  static menu + #87, #2560
  static menu + #88, #2560
  static menu + #89, #2560
  static menu + #90, #2560
  static menu + #91, #2560
  static menu + #92, #2560
  static menu + #93, #2560
  static menu + #94, #2560
  static menu + #95, #2560
  static menu + #96, #2560
  static menu + #97, #2560
  static menu + #98, #2560
  static menu + #99, #2560
  static menu + #100, #2560
  static menu + #101, #2560
  static menu + #102, #2560
  static menu + #103, #2560
  static menu + #104, #2560
  static menu + #105, #2560
  static menu + #106, #2560
  static menu + #107, #2560
  static menu + #108, #2560
  static menu + #109, #2560
  static menu + #110, #2560
  static menu + #111, #2560
  static menu + #112, #2560
  static menu + #113, #2560
  static menu + #114, #2560
  static menu + #115, #2560
  static menu + #116, #2560
  static menu + #117, #2560
  static menu + #118, #2560
  static menu + #119, #2560

  ;Linha 3
  static menu + #120, #2560
  static menu + #121, #2560
  static menu + #122, #2560
  static menu + #123, #2560
  static menu + #124, #2560
  static menu + #125, #2560
  static menu + #126, #2560
  static menu + #127, #2560
  static menu + #128, #2560
  static menu + #129, #2560
  static menu + #130, #2560
  static menu + #131, #2560
  static menu + #132, #2560
  static menu + #133, #2560
  static menu + #134, #2560
  static menu + #135, #2560
  static menu + #136, #2560
  static menu + #137, #2560
  static menu + #138, #2560
  static menu + #139, #2560
  static menu + #140, #2560
  static menu + #141, #2560
  static menu + #142, #2560
  static menu + #143, #2560
  static menu + #144, #2560
  static menu + #145, #2560
  static menu + #146, #2560
  static menu + #147, #2560
  static menu + #148, #2560
  static menu + #149, #2560
  static menu + #150, #2560
  static menu + #151, #2560
  static menu + #152, #2560
  static menu + #153, #2560
  static menu + #154, #2560
  static menu + #155, #2560
  static menu + #156, #2560
  static menu + #157, #2560
  static menu + #158, #2560
  static menu + #159, #2560

  ;Linha 4
  static menu + #160, #2560
  static menu + #161, #2560
  static menu + #162, #2560
  static menu + #163, #2560
  static menu + #164, #2560
  static menu + #165, #2560
  static menu + #166, #2560
  static menu + #167, #2560
  static menu + #168, #2560
  static menu + #169, #2560
  static menu + #170, #2560
  static menu + #171, #2560
  static menu + #172, #2560
  static menu + #173, #2560
  static menu + #174, #2560
  static menu + #175, #2560
  static menu + #176, #2560
  static menu + #177, #2560
  static menu + #178, #2560
  static menu + #179, #2560
  static menu + #180, #2560
  static menu + #181, #2560
  static menu + #182, #2560
  static menu + #183, #2560
  static menu + #184, #2560
  static menu + #185, #2560
  static menu + #186, #2560
  static menu + #187, #2560
  static menu + #188, #2560
  static menu + #189, #2560
  static menu + #190, #2560
  static menu + #191, #2560
  static menu + #192, #2560
  static menu + #193, #2560
  static menu + #194, #2560
  static menu + #195, #2560
  static menu + #196, #2560
  static menu + #197, #2560
  static menu + #198, #2560
  static menu + #199, #2560

  ;Linha 5
  static menu + #200, #2560
  static menu + #201, #2560
  static menu + #202, #2560
  static menu + #203, #2560
  static menu + #204, #2560
  static menu + #205, #2560
  static menu + #206, #2560
  static menu + #207, #2560
  static menu + #208, #2560
  static menu + #209, #2560
  static menu + #210, #2560
  static menu + #211, #2560
  static menu + #212, #2560
  static menu + #213, #2560
  static menu + #214, #2560
  static menu + #215, #2560
  static menu + #216, #2560
  static menu + #217, #2560
  static menu + #218, #2560
  static menu + #219, #2560
  static menu + #220, #2560
  static menu + #221, #2560
  static menu + #222, #2560
  static menu + #223, #2560
  static menu + #224, #2560
  static menu + #225, #2560
  static menu + #226, #2560
  static menu + #227, #2560
  static menu + #228, #2560
  static menu + #229, #2560
  static menu + #230, #2560
  static menu + #231, #2560
  static menu + #232, #2560
  static menu + #233, #2560
  static menu + #234, #2560
  static menu + #235, #2560
  static menu + #236, #2560
  static menu + #237, #2560
  static menu + #238, #2560
  static menu + #239, #2560

  ;Linha 6
  static menu + #240, #2560
  static menu + #241, #2560
  static menu + #242, #2560
  static menu + #243, #2560
  static menu + #244, #2560
  static menu + #245, #2560
  static menu + #246, #2560
  static menu + #247, #2560
  static menu + #248, #2560
  static menu + #249, #2560
  static menu + #250, #2560
  static menu + #251, #2560
  static menu + #252, #2560
  static menu + #253, #2560
  static menu + #254, #2560
  static menu + #255, #2560
  static menu + #256, #2560
  static menu + #257, #2560
  static menu + #258, #2560
  static menu + #259, #2560
  static menu + #260, #2560
  static menu + #261, #2560
  static menu + #262, #2560
  static menu + #263, #2560
  static menu + #264, #2560
  static menu + #265, #2560
  static menu + #266, #2560
  static menu + #267, #2560
  static menu + #268, #2560
  static menu + #269, #2560
  static menu + #270, #2560
  static menu + #271, #2560
  static menu + #272, #2560
  static menu + #273, #2560
  static menu + #274, #2560
  static menu + #275, #2560
  static menu + #276, #2560
  static menu + #277, #2560
  static menu + #278, #2560
  static menu + #279, #2560

  ;Linha 7
  static menu + #280, #2560
  static menu + #281, #2560
  static menu + #282, #2560
  static menu + #283, #2560
  static menu + #284, #2560
  static menu + #285, #2560
  static menu + #286, #2560
  static menu + #287, #2560
  static menu + #288, #2560
  static menu + #289, #2560
  static menu + #290, #2560
  static menu + #291, #2560
  static menu + #292, #2560
  static menu + #293, #2560
  static menu + #294, #2560
  static menu + #295, #2560
  static menu + #296, #2560
  static menu + #297, #2560
  static menu + #298, #2560
  static menu + #299, #2560
  static menu + #300, #2560
  static menu + #301, #2560
  static menu + #302, #2560
  static menu + #303, #2560
  static menu + #304, #2560
  static menu + #305, #2560
  static menu + #306, #2560
  static menu + #307, #2560
  static menu + #308, #2560
  static menu + #309, #2560
  static menu + #310, #2560
  static menu + #311, #2560
  static menu + #312, #2560
  static menu + #313, #2560
  static menu + #314, #2560
  static menu + #315, #2560
  static menu + #316, #2560
  static menu + #317, #2560
  static menu + #318, #2560
  static menu + #319, #2560

  ;Linha 8
  static menu + #320, #2560
  static menu + #321, #2560
  static menu + #322, #2560
  static menu + #323, #2560
  static menu + #324, #2560
  static menu + #325, #2560
  static menu + #326, #2560
  static menu + #327, #2560
  static menu + #328, #2560
  static menu + #329, #2560
  static menu + #330, #2560
  static menu + #331, #2560
  static menu + #332, #2560
  static menu + #333, #2560
  static menu + #334, #2560
  static menu + #335, #2560
  static menu + #336, #2560
  static menu + #337, #2560
  static menu + #338, #2560
  static menu + #339, #2560
  static menu + #340, #2560
  static menu + #341, #2560
  static menu + #342, #2560
  static menu + #343, #2560
  static menu + #344, #2560
  static menu + #345, #2560
  static menu + #346, #2560
  static menu + #347, #2560
  static menu + #348, #2560
  static menu + #349, #2560
  static menu + #350, #2560
  static menu + #351, #2560
  static menu + #352, #2560
  static menu + #353, #2560
  static menu + #354, #2560
  static menu + #355, #2560
  static menu + #356, #2560
  static menu + #357, #2560
  static menu + #358, #2560
  static menu + #359, #2560

  ;Linha 9
  static menu + #360, #2560
  static menu + #361, #2560
  static menu + #362, #2304
  static menu + #363, #2304
  static menu + #364, #2304
  static menu + #365, #0
  static menu + #366, #2560
  static menu + #367, #2560
  static menu + #368, #2560
  static menu + #369, #2560
  static menu + #370, #2560
  static menu + #371, #2560
  static menu + #372, #2560
  static menu + #373, #2560
  static menu + #374, #2560
  static menu + #375, #2560
  static menu + #376, #2560
  static menu + #377, #2560
  static menu + #378, #2560
  static menu + #379, #2560
  static menu + #380, #2560
  static menu + #381, #2560
  static menu + #382, #2560
  static menu + #383, #2560
  static menu + #384, #2560
  static menu + #385, #2560
  static menu + #386, #2560
  static menu + #387, #2560
  static menu + #388, #2560
  static menu + #389, #2560
  static menu + #390, #2560
  static menu + #391, #2560
  static menu + #392, #2560
  static menu + #393, #2560
  static menu + #394, #2560
  static menu + #395, #2560
  static menu + #396, #2560
  static menu + #397, #2560
  static menu + #398, #2560
  static menu + #399, #2560

  ;Linha 10
  static menu + #400, #2560
  static menu + #401, #2304
  static menu + #402, #2560
  static menu + #403, #2560
  static menu + #404, #2560
  static menu + #405, #2560
  static menu + #406, #2560
  static menu + #407, #2560
  static menu + #408, #2560
  static menu + #409, #2560
  static menu + #410, #2560
  static menu + #411, #2560
  static menu + #412, #2560
  static menu + #413, #2560
  static menu + #414, #2560
  static menu + #415, #2560
  static menu + #416, #2560
  static menu + #417, #2560
  static menu + #418, #2560
  static menu + #419, #2560
  static menu + #420, #2560
  static menu + #421, #2560
  static menu + #422, #2560
  static menu + #423, #2560
  static menu + #424, #2560
  static menu + #425, #2560
  static menu + #426, #2560
  static menu + #427, #2560
  static menu + #428, #2560
  static menu + #429, #2560
  static menu + #430, #2560
  static menu + #431, #2560
  static menu + #432, #2560
  static menu + #433, #2560
  static menu + #434, #2560
  static menu + #435, #2560
  static menu + #436, #2560
  static menu + #437, #2560
  static menu + #438, #2560
  static menu + #439, #2560

  ;Linha 11
  static menu + #440, #2560
  static menu + #441, #2304
  static menu + #442, #2560
  static menu + #443, #2560
  static menu + #444, #2560
  static menu + #445, #2560
  static menu + #446, #2560
  static menu + #447, #2560
  static menu + #448, #2560
  static menu + #449, #2560
  static menu + #450, #2560
  static menu + #451, #2560
  static menu + #452, #2560
  static menu + #453, #2560
  static menu + #454, #2560
  static menu + #455, #2560
  static menu + #456, #2560
  static menu + #457, #2560
  static menu + #458, #2560
  static menu + #459, #1792
  static menu + #460, #2560
  static menu + #461, #2560
  static menu + #462, #2560
  static menu + #463, #2560
  static menu + #464, #2560
  static menu + #465, #2560
  static menu + #466, #2560
  static menu + #467, #768
  static menu + #468, #768
  static menu + #469, #768
  static menu + #470, #2560
  static menu + #471, #2560
  static menu + #472, #2560
  static menu + #473, #2560
  static menu + #474, #2560
  static menu + #475, #2560
  static menu + #476, #2560
  static menu + #477, #2560
  static menu + #478, #2560
  static menu + #479, #2560

  ;Linha 12
  static menu + #480, #2560
  static menu + #481, #2304
  static menu + #482, #2560
  static menu + #483, #2560
  static menu + #484, #2560
  static menu + #485, #2560
  static menu + #486, #0
  static menu + #487, #2304
  static menu + #488, #2304
  static menu + #489, #2560
  static menu + #490, #2560
  static menu + #491, #2304
  static menu + #492, #2304
  static menu + #493, #2304
  static menu + #494, #2560
  static menu + #495, #768
  static menu + #496, #768
  static menu + #497, #768
  static menu + #498, #2560
  static menu + #499, #2560
  static menu + #500, #768
  static menu + #501, #2304
  static menu + #502, #2560
  static menu + #503, #2560
  static menu + #504, #2304
  static menu + #505, #2304
  static menu + #506, #768
  static menu + #507, #2560
  static menu + #508, #2560
  static menu + #509, #2560
  static menu + #510, #768
  static menu + #511, #2560
  static menu + #512, #2304
  static menu + #513, #2304
  static menu + #514, #2304
  static menu + #515, #2560
  static menu + #516, #2304
  static menu + #517, #2304
  static menu + #518, #1792
  static menu + #519, #2560

  ;Linha 13
  static menu + #520, #2560
  static menu + #521, #0
  static menu + #522, #2560
  static menu + #523, #2560
  static menu + #524, #2560
  static menu + #525, #2560
  static menu + #526, #2560
  static menu + #527, #2560
  static menu + #528, #2560
  static menu + #529, #2304
  static menu + #530, #768
  static menu + #531, #2560
  static menu + #532, #2560
  static menu + #533, #2560
  static menu + #534, #768
  static menu + #535, #2560
  static menu + #536, #2560
  static menu + #537, #2560
  static menu + #538, #768
  static menu + #539, #2304
  static menu + #540, #768
  static menu + #541, #768
  static menu + #542, #2560
  static menu + #543, #2560
  static menu + #544, #2304
  static menu + #545, #2304
  static menu + #546, #768
  static menu + #547, #2560
  static menu + #548, #2560
  static menu + #549, #2560
  static menu + #550, #768
  static menu + #551, #2304
  static menu + #552, #2560
  static menu + #553, #2560
  static menu + #554, #2560
  static menu + #555, #768
  static menu + #556, #2560
  static menu + #557, #2560
  static menu + #558, #2304
  static menu + #559, #2560

  ;Linha 14
  static menu + #560, #2560
  static menu + #561, #2304
  static menu + #562, #2560
  static menu + #563, #2560
  static menu + #564, #2560
  static menu + #565, #2560
  static menu + #566, #2560
  static menu + #567, #2304
  static menu + #568, #0
  static menu + #569, #2304
  static menu + #570, #768
  static menu + #571, #2560
  static menu + #572, #2560
  static menu + #573, #2560
  static menu + #574, #768
  static menu + #575, #2560
  static menu + #576, #2560
  static menu + #577, #2560
  static menu + #578, #768
  static menu + #579, #2304
  static menu + #580, #768
  static menu + #581, #768
  static menu + #582, #2560
  static menu + #583, #2560
  static menu + #584, #2304
  static menu + #585, #2304
  static menu + #586, #768
  static menu + #587, #2560
  static menu + #588, #2560
  static menu + #589, #2560
  static menu + #590, #768
  static menu + #591, #2304
  static menu + #592, #2560
  static menu + #593, #2560
  static menu + #594, #2560
  static menu + #595, #768
  static menu + #596, #2304
  static menu + #597, #2304
  static menu + #598, #2304
  static menu + #599, #2560

  ;Linha 15
  static menu + #600, #2560
  static menu + #601, #2304
  static menu + #602, #2560
  static menu + #603, #2560
  static menu + #604, #2560
  static menu + #605, #2560
  static menu + #606, #2304
  static menu + #607, #2560
  static menu + #608, #2560
  static menu + #609, #2304
  static menu + #610, #768
  static menu + #611, #2560
  static menu + #612, #2560
  static menu + #613, #2560
  static menu + #614, #768
  static menu + #615, #2560
  static menu + #616, #2560
  static menu + #617, #2560
  static menu + #618, #768
  static menu + #619, #2304
  static menu + #620, #2560
  static menu + #621, #2304
  static menu + #622, #2304
  static menu + #623, #2304
  static menu + #624, #2304
  static menu + #625, #2560
  static menu + #626, #3967
  static menu + #627, #2560
  static menu + #628, #2560
  static menu + #629, #2560
  static menu + #630, #768
  static menu + #631, #2304
  static menu + #632, #2560
  static menu + #633, #2560
  static menu + #634, #2560
  static menu + #635, #768
  static menu + #636, #2560
  static menu + #637, #2560
  static menu + #638, #2560
  static menu + #639, #2560

  ;Linha 16
  static menu + #640, #2560
  static menu + #641, #2560
  static menu + #642, #2304
  static menu + #643, #2304
  static menu + #644, #2304
  static menu + #645, #2304
  static menu + #646, #2560
  static menu + #647, #2304
  static menu + #648, #2304
  static menu + #649, #2304
  static menu + #650, #768
  static menu + #651, #2560
  static menu + #652, #2560
  static menu + #653, #2560
  static menu + #654, #768
  static menu + #655, #2560
  static menu + #656, #2560
  static menu + #657, #2560
  static menu + #658, #768
  static menu + #659, #2304
  static menu + #660, #2560
  static menu + #661, #2560
  static menu + #662, #2304
  static menu + #663, #2304
  static menu + #664, #2560
  static menu + #665, #2560
  static menu + #666, #2560
  static menu + #667, #768
  static menu + #668, #768
  static menu + #669, #768
  static menu + #670, #2560
  static menu + #671, #2304
  static menu + #672, #2560
  static menu + #673, #2560
  static menu + #674, #2560
  static menu + #675, #2560
  static menu + #676, #2304
  static menu + #677, #2304
  static menu + #678, #2304
  static menu + #679, #2560

  ;Linha 17
  static menu + #680, #2560
  static menu + #681, #2560
  static menu + #682, #2560
  static menu + #683, #2560
  static menu + #684, #2560
  static menu + #685, #2560
  static menu + #686, #2560
  static menu + #687, #2560
  static menu + #688, #2560
  static menu + #689, #2560
  static menu + #690, #2560
  static menu + #691, #2560
  static menu + #692, #2560
  static menu + #693, #2560
  static menu + #694, #2560
  static menu + #695, #2560
  static menu + #696, #2560
  static menu + #697, #2560
  static menu + #698, #2560
  static menu + #699, #2560
  static menu + #700, #2560
  static menu + #701, #2560
  static menu + #702, #2560
  static menu + #703, #2560
  static menu + #704, #2560
  static menu + #705, #2560
  static menu + #706, #2560
  static menu + #707, #2560
  static menu + #708, #2560
  static menu + #709, #2560
  static menu + #710, #2560
  static menu + #711, #2560
  static menu + #712, #2560
  static menu + #713, #2560
  static menu + #714, #2560
  static menu + #715, #2560
  static menu + #716, #2560
  static menu + #717, #2560
  static menu + #718, #2560
  static menu + #719, #2560

  ;Linha 18
  static menu + #720, #2560
  static menu + #721, #2560
  static menu + #722, #2560
  static menu + #723, #2560
  static menu + #724, #2560
  static menu + #725, #2560
  static menu + #726, #2560
  static menu + #727, #2560
  static menu + #728, #2560
  static menu + #729, #2560
  static menu + #730, #2560
  static menu + #731, #2560
  static menu + #732, #2560
  static menu + #733, #2560
  static menu + #734, #2560
  static menu + #735, #2560
  static menu + #736, #2560
  static menu + #737, #2048
  static menu + #738, #2048
  static menu + #739, #2560
  static menu + #740, #2048
  static menu + #741, #2048
  static menu + #742, #2560
  static menu + #743, #2560
  static menu + #744, #2560
  static menu + #745, #2560
  static menu + #746, #2560
  static menu + #747, #2560
  static menu + #748, #2560
  static menu + #749, #2560
  static menu + #750, #2560
  static menu + #751, #2560
  static menu + #752, #2560
  static menu + #753, #2560
  static menu + #754, #2560
  static menu + #755, #2560
  static menu + #756, #2560
  static menu + #757, #2560
  static menu + #758, #2560
  static menu + #759, #2560

  ;Linha 19
  static menu + #760, #2560
  static menu + #761, #2560
  static menu + #762, #2560
  static menu + #763, #2560
  static menu + #764, #2560
  static menu + #765, #2560
  static menu + #766, #2560
  static menu + #767, #2560
  static menu + #768, #2560
  static menu + #769, #2560
  static menu + #770, #2560
  static menu + #771, #2560
  static menu + #772, #2560
  static menu + #773, #2560
  static menu + #774, #2560
  static menu + #775, #2560
  static menu + #776, #2560
  static menu + #777, #2048
  static menu + #778, #3967
  static menu + #779, #2048
  static menu + #780, #3967
  static menu + #781, #2048
  static menu + #782, #2560
  static menu + #783, #2560
  static menu + #784, #2560
  static menu + #785, #2560
  static menu + #786, #2560
  static menu + #787, #2560
  static menu + #788, #2560
  static menu + #789, #2560
  static menu + #790, #2560
  static menu + #791, #2560
  static menu + #792, #2560
  static menu + #793, #2560
  static menu + #794, #2560
  static menu + #795, #2560
  static menu + #796, #2560
  static menu + #797, #2560
  static menu + #798, #2560
  static menu + #799, #2560

  ;Linha 20
  static menu + #800, #2560
  static menu + #801, #2560
  static menu + #802, #2560
  static menu + #803, #2560
  static menu + #804, #2560
  static menu + #805, #2560
  static menu + #806, #2560
  static menu + #807, #2560
  static menu + #808, #2560
  static menu + #809, #2560
  static menu + #810, #2560
  static menu + #811, #2560
  static menu + #812, #2560
  static menu + #813, #2560
  static menu + #814, #2560
  static menu + #815, #2560
  static menu + #816, #2560
  static menu + #817, #2048
  static menu + #818, #2048
  static menu + #819, #3967
  static menu + #820, #2048
  static menu + #821, #2048
  static menu + #822, #2560
  static menu + #823, #2560
  static menu + #824, #2560
  static menu + #825, #2560
  static menu + #826, #2560
  static menu + #827, #2560
  static menu + #828, #2560
  static menu + #829, #2560
  static menu + #830, #2560
  static menu + #831, #2560
  static menu + #832, #2560
  static menu + #833, #2560
  static menu + #834, #2560
  static menu + #835, #2560
  static menu + #836, #2560
  static menu + #837, #2560
  static menu + #838, #2560
  static menu + #839, #2560

  ;Linha 21
  static menu + #840, #2560
  static menu + #841, #2560
  static menu + #842, #2128
  static menu + #843, #2162
  static menu + #844, #2149
  static menu + #845, #2163
  static menu + #846, #2163
  static menu + #847, #2560
  static menu + #848, #2560
  static menu + #849, #2560
  static menu + #850, #2560
  static menu + #851, #2560
  static menu + #852, #2560
  static menu + #853, #2560
  static menu + #854, #2560
  static menu + #855, #2560
  static menu + #856, #2560
  static menu + #857, #2560
  static menu + #858, #2048
  static menu + #859, #3967
  static menu + #860, #2048
  static menu + #861, #2560
  static menu + #862, #2560
  static menu + #863, #2560
  static menu + #864, #3967
  static menu + #865, #2560
  static menu + #866, #2560
  static menu + #867, #2560
  static menu + #868, #2560
  static menu + #869, #2560
  static menu + #870, #2128
  static menu + #871, #2156
  static menu + #872, #2149
  static menu + #873, #2145
  static menu + #874, #2163
  static menu + #875, #2149
  static menu + #876, #2560
  static menu + #877, #2560
  static menu + #878, #2560
  static menu + #879, #2560

  ;Linha 22
  static menu + #880, #2560
  static menu + #881, #2560
  static menu + #882, #2131
  static menu + #883, #2160
  static menu + #884, #2145
  static menu + #885, #2147
  static menu + #886, #2149
  static menu + #887, #2560
  static menu + #888, #2560
  static menu + #889, #2560
  static menu + #890, #2560
  static menu + #891, #2560
  static menu + #892, #2560
  static menu + #893, #2560
  static menu + #894, #2560
  static menu + #895, #2560
  static menu + #896, #2816
  static menu + #897, #3967
  static menu + #898, #3967
  static menu + #899, #2816
  static menu + #900, #3967
  static menu + #901, #3967
  static menu + #902, #2816
  static menu + #903, #3967
  static menu + #904, #2560
  static menu + #905, #3967
  static menu + #906, #2560
  static menu + #907, #2560
  static menu + #908, #2560
  static menu + #909, #2560
  static menu + #910, #2128
  static menu + #911, #2156
  static menu + #912, #2145
  static menu + #913, #2169
  static menu + #914, #2560
  static menu + #915, #2560
  static menu + #916, #2560
  static menu + #917, #2560
  static menu + #918, #2560
  static menu + #919, #2560

  ;Linha 23
  static menu + #920, #2560
  static menu + #921, #2560
  static menu + #922, #2164
  static menu + #923, #2159
  static menu + #924, #2560
  static menu + #925, #2560
  static menu + #926, #2560
  static menu + #927, #2560
  static menu + #928, #2560
  static menu + #929, #2560
  static menu + #930, #2560
  static menu + #931, #2560
  static menu + #932, #2560
  static menu + #933, #2560
  static menu + #934, #2560
  static menu + #935, #2816
  static menu + #936, #2816
  static menu + #937, #3967
  static menu + #938, #3967
  static menu + #939, #2816
  static menu + #940, #3967
  static menu + #941, #3967
  static menu + #942, #2816
  static menu + #943, #2816
  static menu + #944, #2560
  static menu + #945, #2560
  static menu + #946, #2560
  static menu + #947, #2560
  static menu + #948, #2560
  static menu + #949, #2560
  static menu + #950, #2164
  static menu + #951, #2152
  static menu + #952, #2149
  static menu + #953, #2560
  static menu + #954, #2560
  static menu + #955, #2560
  static menu + #956, #2560
  static menu + #957, #2560
  static menu + #958, #2560
  static menu + #959, #2560

  ;Linha 24
  static menu + #960, #2560
  static menu + #961, #2560
  static menu + #962, #2128
  static menu + #963, #2156
  static menu + #964, #2145
  static menu + #965, #2169
  static menu + #966, #2110
  static menu + #967, #2560
  static menu + #968, #2560
  static menu + #969, #2560
  static menu + #970, #2560
  static menu + #971, #2560
  static menu + #972, #2560
  static menu + #973, #2560
  static menu + #974, #2560
  static menu + #975, #2816
  static menu + #976, #2816
  static menu + #977, #3967
  static menu + #978, #3967
  static menu + #979, #2816
  static menu + #980, #3967
  static menu + #981, #3967
  static menu + #982, #2816
  static menu + #983, #3967
  static menu + #984, #2560
  static menu + #985, #2560
  static menu + #986, #2560
  static menu + #987, #2560
  static menu + #988, #2560
  static menu + #989, #2560
  static menu + #990, #2119
  static menu + #991, #2145
  static menu + #992, #2157
  static menu + #993, #2149
  static menu + #994, #2560
  static menu + #995, #2560
  static menu + #996, #2560
  static menu + #997, #2560
  static menu + #998, #2560
  static menu + #999, #2560

  ;Linha 25
  static menu + #1000, #2560
  static menu + #1001, #2560
  static menu + #1002, #2127
  static menu + #1003, #2162
  static menu + #1004, #3840
  static menu + #1005, #2087
  static menu + #1006, #2153
  static menu + #1007, #2087
  static menu + #1008, #2560
  static menu + #1009, #2560
  static menu + #1010, #2560
  static menu + #1011, #2560
  static menu + #1012, #2560
  static menu + #1013, #2560
  static menu + #1014, #3840
  static menu + #1015, #2816
  static menu + #1016, #2816
  static menu + #1017, #3967
  static menu + #1018, #3967
  static menu + #1019, #2816
  static menu + #1020, #3967
  static menu + #1021, #3967
  static menu + #1022, #2816
  static menu + #1023, #2816
  static menu + #1024, #2560
  static menu + #1025, #2560
  static menu + #1026, #2560
  static menu + #1027, #2560
  static menu + #1028, #2560
  static menu + #1029, #2560
  static menu + #1030, #2145
  static menu + #1031, #2164
  static menu + #1032, #2560
  static menu + #1033, #2560
  static menu + #1034, #2560
  static menu + #1035, #2560
  static menu + #1036, #2560
  static menu + #1037, #2560
  static menu + #1038, #2560
  static menu + #1039, #2560

  ;Linha 26
  static menu + #1040, #2560
  static menu + #1041, #2560
  static menu + #1042, #2150
  static menu + #1043, #2159
  static menu + #1044, #2162
  static menu + #1045, #2560
  static menu + #1046, #2560
  static menu + #1047, #2560
  static menu + #1048, #2560
  static menu + #1049, #2560
  static menu + #1050, #2560
  static menu + #1051, #2560
  static menu + #1052, #2560
  static menu + #1053, #2560
  static menu + #1054, #2560
  static menu + #1055, #2816
  static menu + #1056, #2816
  static menu + #1057, #3967
  static menu + #1058, #3967
  static menu + #1059, #2816
  static menu + #1060, #3967
  static menu + #1061, #3967
  static menu + #1062, #2816
  static menu + #1063, #2816
  static menu + #1064, #2560
  static menu + #1065, #2560
  static menu + #1066, #2560
  static menu + #1067, #2560
  static menu + #1068, #2560
  static menu + #1069, #2560
  static menu + #1070, #2100
  static menu + #1071, #2096
  static menu + #1072, #2125
  static menu + #1073, #2120
  static menu + #1074, #2170
  static menu + #1075, #2560
  static menu + #1076, #2560
  static menu + #1077, #2560
  static menu + #1078, #2560
  static menu + #1079, #2560

  ;Linha 27
  static menu + #1080, #2560
  static menu + #1081, #2560
  static menu + #1082, #2153
  static menu + #1083, #2158
  static menu + #1084, #2163
  static menu + #1085, #2164
  static menu + #1086, #2162
  static menu + #1087, #2165
  static menu + #1088, #2147
  static menu + #1089, #2164
  static menu + #1090, #2153
  static menu + #1091, #2159
  static menu + #1092, #2158
  static menu + #1093, #2163
  static menu + #1094, #2560
  static menu + #1095, #2560
  static menu + #1096, #2816
  static menu + #1097, #3967
  static menu + #1098, #3967
  static menu + #1099, #2816
  static menu + #1100, #3967
  static menu + #1101, #3967
  static menu + #1102, #2816
  static menu + #1103, #2560
  static menu + #1104, #2560
  static menu + #1105, #2560
  static menu + #1106, #2560
  static menu + #1107, #2560
  static menu + #1108, #2560
  static menu + #1109, #2560
  static menu + #1110, #2560
  static menu + #1111, #2560
  static menu + #1112, #2560
  static menu + #1113, #2560
  static menu + #1114, #2560
  static menu + #1115, #2560
  static menu + #1116, #2560
  static menu + #1117, #2560
  static menu + #1118, #2560
  static menu + #1119, #2560

  ;Linha 28
  static menu + #1120, #2560
  static menu + #1121, #2560
  static menu + #1122, #2560
  static menu + #1123, #2560
  static menu + #1124, #2560
  static menu + #1125, #2560
  static menu + #1126, #2560
  static menu + #1127, #2560
  static menu + #1128, #2560
  static menu + #1129, #2560
  static menu + #1130, #2560
  static menu + #1131, #2560
  static menu + #1132, #2560
  static menu + #1133, #2560
  static menu + #1134, #2560
  static menu + #1135, #2560
  static menu + #1136, #2560
  static menu + #1137, #2560
  static menu + #1138, #2560
  static menu + #1139, #2560
  static menu + #1140, #2560
  static menu + #1141, #2560
  static menu + #1142, #2560
  static menu + #1143, #2560
  static menu + #1144, #2560
  static menu + #1145, #2560
  static menu + #1146, #2560
  static menu + #1147, #2560
  static menu + #1148, #2560
  static menu + #1149, #2560
  static menu + #1150, #2560
  static menu + #1151, #2560
  static menu + #1152, #2560
  static menu + #1153, #2560
  static menu + #1154, #2560
  static menu + #1155, #2560
  static menu + #1156, #2560
  static menu + #1157, #2560
  static menu + #1158, #2560
  static menu + #1159, #2560

  ;Linha 29
  static menu + #1160, #2560
  static menu + #1161, #2560
  static menu + #1162, #2560
  static menu + #1163, #2560
  static menu + #1164, #2560
  static menu + #1165, #2560
  static menu + #1166, #2560
  static menu + #1167, #2560
  static menu + #1168, #2560
  static menu + #1169, #2560
  static menu + #1170, #2560
  static menu + #1171, #2560
  static menu + #1172, #2560
  static menu + #1173, #2560
  static menu + #1174, #2560
  static menu + #1175, #2560
  static menu + #1176, #2560
  static menu + #1177, #2560
  static menu + #1178, #2560
  static menu + #1179, #2560
  static menu + #1180, #2560
  static menu + #1181, #2560
  static menu + #1182, #2560
  static menu + #1183, #2560
  static menu + #1184, #2560
  static menu + #1185, #2560
  static menu + #1186, #2560
  static menu + #1187, #2560
  static menu + #1188, #2560
  static menu + #1189, #2560
  static menu + #1190, #2560
  static menu + #1191, #2560
  static menu + #1192, #2560
  static menu + #1193, #2560
  static menu + #1194, #2560
  static menu + #1195, #2560
  static menu + #1196, #2560
  static menu + #1197, #2560
  static menu + #1198, #2560
  static menu + #1199, #2560

nextlevel : var #1200
  ;Linha 0
  static nextlevel + #0, #3072
  static nextlevel + #1, #3072
  static nextlevel + #2, #3072
  static nextlevel + #3, #3072
  static nextlevel + #4, #3072
  static nextlevel + #5, #3072
  static nextlevel + #6, #3072
  static nextlevel + #7, #3072
  static nextlevel + #8, #3072
  static nextlevel + #9, #3072
  static nextlevel + #10, #3072
  static nextlevel + #11, #3072
  static nextlevel + #12, #3072
  static nextlevel + #13, #3072
  static nextlevel + #14, #3072
  static nextlevel + #15, #3072
  static nextlevel + #16, #3072
  static nextlevel + #17, #3072
  static nextlevel + #18, #3072
  static nextlevel + #19, #3072
  static nextlevel + #20, #3072
  static nextlevel + #21, #3072
  static nextlevel + #22, #3072
  static nextlevel + #23, #3072
  static nextlevel + #24, #3072
  static nextlevel + #25, #3072
  static nextlevel + #26, #3072
  static nextlevel + #27, #3072
  static nextlevel + #28, #3072
  static nextlevel + #29, #3072
  static nextlevel + #30, #3072
  static nextlevel + #31, #3072
  static nextlevel + #32, #3072
  static nextlevel + #33, #3072
  static nextlevel + #34, #3072
  static nextlevel + #35, #3072
  static nextlevel + #36, #3072
  static nextlevel + #37, #3072
  static nextlevel + #38, #3072
  static nextlevel + #39, #3072

  ;Linha 1
  static nextlevel + #40, #3072
  static nextlevel + #41, #3072
  static nextlevel + #42, #3072
  static nextlevel + #43, #3072
  static nextlevel + #44, #3072
  static nextlevel + #45, #3072
  static nextlevel + #46, #3072
  static nextlevel + #47, #3072
  static nextlevel + #48, #3072
  static nextlevel + #49, #3072
  static nextlevel + #50, #3072
  static nextlevel + #51, #3072
  static nextlevel + #52, #3072
  static nextlevel + #53, #3072
  static nextlevel + #54, #3072
  static nextlevel + #55, #3072
  static nextlevel + #56, #3072
  static nextlevel + #57, #3072
  static nextlevel + #58, #3072
  static nextlevel + #59, #3072
  static nextlevel + #60, #3072
  static nextlevel + #61, #3072
  static nextlevel + #62, #3072
  static nextlevel + #63, #3072
  static nextlevel + #64, #3072
  static nextlevel + #65, #3072
  static nextlevel + #66, #3072
  static nextlevel + #67, #3072
  static nextlevel + #68, #3072
  static nextlevel + #69, #3072
  static nextlevel + #70, #3072
  static nextlevel + #71, #3072
  static nextlevel + #72, #3072
  static nextlevel + #73, #3072
  static nextlevel + #74, #3072
  static nextlevel + #75, #3072
  static nextlevel + #76, #3072
  static nextlevel + #77, #3072
  static nextlevel + #78, #3072
  static nextlevel + #79, #3072

  ;Linha 2
  static nextlevel + #80, #3072
  static nextlevel + #81, #3072
  static nextlevel + #82, #3072
  static nextlevel + #83, #3072
  static nextlevel + #84, #3072
  static nextlevel + #85, #3072
  static nextlevel + #86, #1024
  static nextlevel + #87, #1024
  static nextlevel + #88, #1024
  static nextlevel + #89, #1024
  static nextlevel + #90, #1024
  static nextlevel + #91, #1024
  static nextlevel + #92, #3072
  static nextlevel + #93, #3072
  static nextlevel + #94, #3072
  static nextlevel + #95, #3072
  static nextlevel + #96, #1024
  static nextlevel + #97, #1024
  static nextlevel + #98, #1024
  static nextlevel + #99, #1024
  static nextlevel + #100, #1024
  static nextlevel + #101, #1024
  static nextlevel + #102, #3072
  static nextlevel + #103, #3072
  static nextlevel + #104, #3072
  static nextlevel + #105, #3072
  static nextlevel + #106, #1024
  static nextlevel + #107, #1024
  static nextlevel + #108, #1024
  static nextlevel + #109, #1024
  static nextlevel + #110, #1024
  static nextlevel + #111, #1024
  static nextlevel + #112, #3072
  static nextlevel + #113, #3072
  static nextlevel + #114, #3072
  static nextlevel + #115, #3072
  static nextlevel + #116, #3072
  static nextlevel + #117, #3072
  static nextlevel + #118, #3072
  static nextlevel + #119, #3072

  ;Linha 3
  static nextlevel + #120, #3072
  static nextlevel + #121, #3072
  static nextlevel + #122, #3072
  static nextlevel + #123, #3072
  static nextlevel + #124, #3072
  static nextlevel + #125, #3072
  static nextlevel + #126, #3072
  static nextlevel + #127, #3072
  static nextlevel + #128, #3072
  static nextlevel + #129, #3072
  static nextlevel + #130, #3072
  static nextlevel + #131, #3072
  static nextlevel + #132, #3072
  static nextlevel + #133, #3072
  static nextlevel + #134, #3072
  static nextlevel + #135, #3072
  static nextlevel + #136, #3072
  static nextlevel + #137, #3072
  static nextlevel + #138, #3072
  static nextlevel + #139, #3072
  static nextlevel + #140, #3072
  static nextlevel + #141, #3072
  static nextlevel + #142, #3072
  static nextlevel + #143, #3072
  static nextlevel + #144, #3072
  static nextlevel + #145, #3072
  static nextlevel + #146, #3072
  static nextlevel + #147, #3072
  static nextlevel + #148, #3072
  static nextlevel + #149, #3072
  static nextlevel + #150, #3072
  static nextlevel + #151, #3072
  static nextlevel + #152, #3072
  static nextlevel + #153, #3072
  static nextlevel + #154, #3072
  static nextlevel + #155, #3072
  static nextlevel + #156, #3072
  static nextlevel + #157, #3072
  static nextlevel + #158, #3072
  static nextlevel + #159, #3072

  ;Linha 4
  static nextlevel + #160, #3072
  static nextlevel + #161, #3072
  static nextlevel + #162, #3072
  static nextlevel + #163, #3072
  static nextlevel + #164, #3072
  static nextlevel + #165, #3072
  static nextlevel + #166, #3072
  static nextlevel + #167, #3072
  static nextlevel + #168, #3072
  static nextlevel + #169, #3072
  static nextlevel + #170, #3072
  static nextlevel + #171, #3072
  static nextlevel + #172, #3072
  static nextlevel + #173, #3072
  static nextlevel + #174, #3072
  static nextlevel + #175, #3072
  static nextlevel + #176, #3072
  static nextlevel + #177, #3072
  static nextlevel + #178, #3072
  static nextlevel + #179, #3072
  static nextlevel + #180, #3072
  static nextlevel + #181, #3072
  static nextlevel + #182, #3072
  static nextlevel + #183, #3072
  static nextlevel + #184, #3072
  static nextlevel + #185, #3072
  static nextlevel + #186, #3072
  static nextlevel + #187, #3072
  static nextlevel + #188, #3072
  static nextlevel + #189, #3072
  static nextlevel + #190, #3072
  static nextlevel + #191, #3072
  static nextlevel + #192, #3072
  static nextlevel + #193, #3072
  static nextlevel + #194, #3072
  static nextlevel + #195, #3072
  static nextlevel + #196, #3072
  static nextlevel + #197, #3072
  static nextlevel + #198, #3072
  static nextlevel + #199, #3072

  ;Linha 5
  static nextlevel + #200, #3072
  static nextlevel + #201, #1024
  static nextlevel + #202, #1024
  static nextlevel + #203, #1024
  static nextlevel + #204, #1024
  static nextlevel + #205, #1024
  static nextlevel + #206, #1024
  static nextlevel + #207, #3072
  static nextlevel + #208, #3072
  static nextlevel + #209, #3072
  static nextlevel + #210, #3072
  static nextlevel + #211, #1024
  static nextlevel + #212, #1024
  static nextlevel + #213, #1024
  static nextlevel + #214, #1024
  static nextlevel + #215, #1024
  static nextlevel + #216, #1024
  static nextlevel + #217, #3072
  static nextlevel + #218, #3072
  static nextlevel + #219, #3072
  static nextlevel + #220, #3072
  static nextlevel + #221, #1024
  static nextlevel + #222, #1024
  static nextlevel + #223, #1024
  static nextlevel + #224, #1024
  static nextlevel + #225, #1024
  static nextlevel + #226, #1024
  static nextlevel + #227, #3072
  static nextlevel + #228, #3072
  static nextlevel + #229, #3072
  static nextlevel + #230, #3072
  static nextlevel + #231, #1024
  static nextlevel + #232, #1024
  static nextlevel + #233, #1024
  static nextlevel + #234, #1024
  static nextlevel + #235, #1024
  static nextlevel + #236, #1024
  static nextlevel + #237, #3072
  static nextlevel + #238, #3072
  static nextlevel + #239, #3072

  ;Linha 6
  static nextlevel + #240, #3072
  static nextlevel + #241, #3072
  static nextlevel + #242, #3072
  static nextlevel + #243, #3072
  static nextlevel + #244, #3072
  static nextlevel + #245, #3072
  static nextlevel + #246, #3072
  static nextlevel + #247, #3072
  static nextlevel + #248, #3072
  static nextlevel + #249, #3072
  static nextlevel + #250, #3072
  static nextlevel + #251, #3072
  static nextlevel + #252, #3072
  static nextlevel + #253, #3072
  static nextlevel + #254, #3072
  static nextlevel + #255, #3072
  static nextlevel + #256, #3072
  static nextlevel + #257, #3072
  static nextlevel + #258, #3072
  static nextlevel + #259, #3072
  static nextlevel + #260, #3072
  static nextlevel + #261, #3072
  static nextlevel + #262, #3072
  static nextlevel + #263, #3072
  static nextlevel + #264, #3072
  static nextlevel + #265, #3072
  static nextlevel + #266, #3072
  static nextlevel + #267, #3072
  static nextlevel + #268, #3072
  static nextlevel + #269, #3072
  static nextlevel + #270, #3072
  static nextlevel + #271, #3072
  static nextlevel + #272, #3072
  static nextlevel + #273, #3072
  static nextlevel + #274, #3072
  static nextlevel + #275, #3072
  static nextlevel + #276, #3072
  static nextlevel + #277, #3072
  static nextlevel + #278, #3072
  static nextlevel + #279, #3072

  ;Linha 7
  static nextlevel + #280, #3072
  static nextlevel + #281, #3072
  static nextlevel + #282, #3072
  static nextlevel + #283, #3072
  static nextlevel + #284, #3072
  static nextlevel + #285, #3072
  static nextlevel + #286, #3072
  static nextlevel + #287, #3072
  static nextlevel + #288, #3072
  static nextlevel + #289, #3072
  static nextlevel + #290, #3072
  static nextlevel + #291, #3072
  static nextlevel + #292, #3072
  static nextlevel + #293, #3072
  static nextlevel + #294, #3072
  static nextlevel + #295, #3072
  static nextlevel + #296, #3072
  static nextlevel + #297, #3072
  static nextlevel + #298, #3072
  static nextlevel + #299, #3072
  static nextlevel + #300, #3072
  static nextlevel + #301, #3072
  static nextlevel + #302, #3072
  static nextlevel + #303, #3072
  static nextlevel + #304, #3072
  static nextlevel + #305, #3072
  static nextlevel + #306, #3072
  static nextlevel + #307, #3072
  static nextlevel + #308, #3072
  static nextlevel + #309, #3072
  static nextlevel + #310, #3072
  static nextlevel + #311, #3072
  static nextlevel + #312, #3072
  static nextlevel + #313, #3072
  static nextlevel + #314, #3072
  static nextlevel + #315, #3072
  static nextlevel + #316, #3072
  static nextlevel + #317, #3072
  static nextlevel + #318, #3072
  static nextlevel + #319, #3072

  ;Linha 8
  static nextlevel + #320, #3072
  static nextlevel + #321, #3072
  static nextlevel + #322, #3072
  static nextlevel + #323, #3072
  static nextlevel + #324, #3072
  static nextlevel + #325, #3072
  static nextlevel + #326, #1024
  static nextlevel + #327, #1024
  static nextlevel + #328, #1024
  static nextlevel + #329, #1024
  static nextlevel + #330, #1024
  static nextlevel + #331, #1024
  static nextlevel + #332, #3072
  static nextlevel + #333, #3072
  static nextlevel + #334, #3072
  static nextlevel + #335, #3072
  static nextlevel + #336, #1024
  static nextlevel + #337, #1024
  static nextlevel + #338, #1024
  static nextlevel + #339, #1024
  static nextlevel + #340, #1024
  static nextlevel + #341, #1024
  static nextlevel + #342, #3072
  static nextlevel + #343, #3072
  static nextlevel + #344, #3072
  static nextlevel + #345, #3072
  static nextlevel + #346, #1024
  static nextlevel + #347, #1024
  static nextlevel + #348, #1024
  static nextlevel + #349, #1024
  static nextlevel + #350, #1024
  static nextlevel + #351, #1024
  static nextlevel + #352, #3072
  static nextlevel + #353, #3072
  static nextlevel + #354, #3072
  static nextlevel + #355, #3072
  static nextlevel + #356, #3072
  static nextlevel + #357, #3072
  static nextlevel + #358, #3072
  static nextlevel + #359, #3072

  ;Linha 9
  static nextlevel + #360, #3072
  static nextlevel + #361, #3072
  static nextlevel + #362, #3072
  static nextlevel + #363, #3072
  static nextlevel + #364, #3072
  static nextlevel + #365, #3072
  static nextlevel + #366, #3072
  static nextlevel + #367, #3072
  static nextlevel + #368, #3072
  static nextlevel + #369, #3072
  static nextlevel + #370, #3072
  static nextlevel + #371, #3072
  static nextlevel + #372, #3072
  static nextlevel + #373, #3072
  static nextlevel + #374, #3072
  static nextlevel + #375, #3072
  static nextlevel + #376, #3072
  static nextlevel + #377, #3072
  static nextlevel + #378, #3072
  static nextlevel + #379, #3072
  static nextlevel + #380, #3072
  static nextlevel + #381, #3072
  static nextlevel + #382, #3072
  static nextlevel + #383, #3072
  static nextlevel + #384, #3072
  static nextlevel + #385, #3072
  static nextlevel + #386, #3072
  static nextlevel + #387, #3072
  static nextlevel + #388, #3072
  static nextlevel + #389, #3072
  static nextlevel + #390, #3072
  static nextlevel + #391, #3072
  static nextlevel + #392, #3072
  static nextlevel + #393, #3072
  static nextlevel + #394, #3072
  static nextlevel + #395, #3072
  static nextlevel + #396, #3072
  static nextlevel + #397, #3072
  static nextlevel + #398, #3072
  static nextlevel + #399, #3072

  ;Linha 10
  static nextlevel + #400, #3072
  static nextlevel + #401, #3072
  static nextlevel + #402, #3072
  static nextlevel + #403, #3072
  static nextlevel + #404, #3072
  static nextlevel + #405, #3072
  static nextlevel + #406, #3072
  static nextlevel + #407, #2304
  static nextlevel + #408, #2304
  static nextlevel + #409, #3072
  static nextlevel + #410, #3072
  static nextlevel + #411, #2304
  static nextlevel + #412, #2304
  static nextlevel + #413, #3072
  static nextlevel + #414, #3072
  static nextlevel + #415, #3072
  static nextlevel + #416, #3072
  static nextlevel + #417, #3072
  static nextlevel + #418, #3072
  static nextlevel + #419, #3072
  static nextlevel + #420, #3072
  static nextlevel + #421, #3072
  static nextlevel + #422, #3072
  static nextlevel + #423, #3072
  static nextlevel + #424, #3072
  static nextlevel + #425, #3072
  static nextlevel + #426, #3072
  static nextlevel + #427, #3072
  static nextlevel + #428, #3072
  static nextlevel + #429, #3072
  static nextlevel + #430, #3072
  static nextlevel + #431, #3072
  static nextlevel + #432, #3072
  static nextlevel + #433, #3072
  static nextlevel + #434, #3072
  static nextlevel + #435, #3072
  static nextlevel + #436, #3072
  static nextlevel + #437, #3072
  static nextlevel + #438, #3072
  static nextlevel + #439, #3072

  ;Linha 11
  static nextlevel + #440, #3072
  static nextlevel + #441, #1024
  static nextlevel + #442, #1024
  static nextlevel + #443, #1024
  static nextlevel + #444, #1024
  static nextlevel + #445, #1024
  static nextlevel + #446, #1024
  static nextlevel + #447, #2304
  static nextlevel + #448, #2304
  static nextlevel + #449, #2304
  static nextlevel + #450, #3072
  static nextlevel + #451, #2304
  static nextlevel + #452, #2304
  static nextlevel + #453, #2304
  static nextlevel + #454, #2304
  static nextlevel + #455, #2304
  static nextlevel + #456, #2304
  static nextlevel + #457, #2304
  static nextlevel + #458, #2304
  static nextlevel + #459, #3072
  static nextlevel + #460, #3072
  static nextlevel + #461, #2304
  static nextlevel + #462, #2304
  static nextlevel + #463, #2304
  static nextlevel + #464, #1024
  static nextlevel + #465, #1024
  static nextlevel + #466, #1024
  static nextlevel + #467, #3072
  static nextlevel + #468, #3072
  static nextlevel + #469, #3072
  static nextlevel + #470, #3072
  static nextlevel + #471, #1024
  static nextlevel + #472, #1024
  static nextlevel + #473, #1024
  static nextlevel + #474, #1024
  static nextlevel + #475, #1024
  static nextlevel + #476, #1024
  static nextlevel + #477, #3072
  static nextlevel + #478, #3072
  static nextlevel + #479, #3072

  ;Linha 12
  static nextlevel + #480, #3072
  static nextlevel + #481, #3072
  static nextlevel + #482, #3072
  static nextlevel + #483, #3072
  static nextlevel + #484, #3072
  static nextlevel + #485, #3072
  static nextlevel + #486, #3072
  static nextlevel + #487, #2304
  static nextlevel + #488, #2304
  static nextlevel + #489, #2304
  static nextlevel + #490, #2304
  static nextlevel + #491, #2304
  static nextlevel + #492, #2304
  static nextlevel + #493, #2304
  static nextlevel + #494, #3072
  static nextlevel + #495, #3072
  static nextlevel + #496, #2304
  static nextlevel + #497, #3072
  static nextlevel + #498, #2304
  static nextlevel + #499, #2304
  static nextlevel + #500, #2304
  static nextlevel + #501, #2304
  static nextlevel + #502, #3072
  static nextlevel + #503, #2304
  static nextlevel + #504, #2304
  static nextlevel + #505, #2304
  static nextlevel + #506, #3072
  static nextlevel + #507, #3072
  static nextlevel + #508, #3072
  static nextlevel + #509, #3072
  static nextlevel + #510, #3072
  static nextlevel + #511, #3072
  static nextlevel + #512, #3072
  static nextlevel + #513, #3072
  static nextlevel + #514, #3072
  static nextlevel + #515, #3072
  static nextlevel + #516, #3072
  static nextlevel + #517, #3072
  static nextlevel + #518, #3072
  static nextlevel + #519, #3072

  ;Linha 13
  static nextlevel + #520, #3072
  static nextlevel + #521, #3072
  static nextlevel + #522, #3072
  static nextlevel + #523, #3072
  static nextlevel + #524, #3072
  static nextlevel + #525, #3072
  static nextlevel + #526, #3072
  static nextlevel + #527, #2304
  static nextlevel + #528, #2304
  static nextlevel + #529, #2304
  static nextlevel + #530, #2304
  static nextlevel + #531, #2304
  static nextlevel + #532, #2304
  static nextlevel + #533, #2304
  static nextlevel + #534, #2304
  static nextlevel + #535, #2304
  static nextlevel + #536, #2304
  static nextlevel + #537, #3072
  static nextlevel + #538, #3072
  static nextlevel + #539, #3072
  static nextlevel + #540, #3072
  static nextlevel + #541, #3072
  static nextlevel + #542, #3072
  static nextlevel + #543, #2304
  static nextlevel + #544, #3072
  static nextlevel + #545, #3072
  static nextlevel + #546, #3072
  static nextlevel + #547, #3072
  static nextlevel + #548, #3072
  static nextlevel + #549, #3072
  static nextlevel + #550, #3072
  static nextlevel + #551, #3072
  static nextlevel + #552, #3072
  static nextlevel + #553, #3072
  static nextlevel + #554, #3072
  static nextlevel + #555, #3072
  static nextlevel + #556, #3072
  static nextlevel + #557, #3072
  static nextlevel + #558, #3072
  static nextlevel + #559, #3072

  ;Linha 14
  static nextlevel + #560, #3072
  static nextlevel + #561, #3072
  static nextlevel + #562, #3072
  static nextlevel + #563, #3072
  static nextlevel + #564, #3072
  static nextlevel + #565, #3072
  static nextlevel + #566, #1024
  static nextlevel + #567, #2304
  static nextlevel + #568, #2304
  static nextlevel + #569, #1024
  static nextlevel + #570, #2304
  static nextlevel + #571, #2304
  static nextlevel + #572, #2304
  static nextlevel + #573, #2304
  static nextlevel + #574, #3072
  static nextlevel + #575, #3072
  static nextlevel + #576, #1024
  static nextlevel + #577, #1024
  static nextlevel + #578, #2304
  static nextlevel + #579, #2304
  static nextlevel + #580, #2304
  static nextlevel + #581, #2304
  static nextlevel + #582, #3072
  static nextlevel + #583, #2304
  static nextlevel + #584, #3072
  static nextlevel + #585, #3072
  static nextlevel + #586, #1024
  static nextlevel + #587, #1024
  static nextlevel + #588, #1024
  static nextlevel + #589, #1024
  static nextlevel + #590, #1024
  static nextlevel + #591, #1024
  static nextlevel + #592, #3072
  static nextlevel + #593, #3072
  static nextlevel + #594, #3072
  static nextlevel + #595, #3072
  static nextlevel + #596, #3072
  static nextlevel + #597, #3072
  static nextlevel + #598, #3072
  static nextlevel + #599, #3072

  ;Linha 15
  static nextlevel + #600, #3072
  static nextlevel + #601, #3072
  static nextlevel + #602, #3072
  static nextlevel + #603, #3072
  static nextlevel + #604, #3072
  static nextlevel + #605, #3072
  static nextlevel + #606, #3072
  static nextlevel + #607, #2304
  static nextlevel + #608, #2304
  static nextlevel + #609, #3072
  static nextlevel + #610, #3072
  static nextlevel + #611, #2304
  static nextlevel + #612, #2304
  static nextlevel + #613, #3072
  static nextlevel + #614, #2304
  static nextlevel + #615, #2304
  static nextlevel + #616, #2304
  static nextlevel + #617, #2304
  static nextlevel + #618, #2304
  static nextlevel + #619, #3072
  static nextlevel + #620, #3072
  static nextlevel + #621, #2304
  static nextlevel + #622, #2304
  static nextlevel + #623, #3072
  static nextlevel + #624, #2304
  static nextlevel + #625, #2304
  static nextlevel + #626, #3072
  static nextlevel + #627, #3072
  static nextlevel + #628, #3072
  static nextlevel + #629, #3072
  static nextlevel + #630, #3072
  static nextlevel + #631, #3072
  static nextlevel + #632, #3072
  static nextlevel + #633, #2304
  static nextlevel + #634, #2304
  static nextlevel + #635, #2304
  static nextlevel + #636, #3072
  static nextlevel + #637, #3072
  static nextlevel + #638, #3072
  static nextlevel + #639, #3072

  ;Linha 16
  static nextlevel + #640, #3072
  static nextlevel + #641, #3072
  static nextlevel + #642, #3072
  static nextlevel + #643, #3072
  static nextlevel + #644, #3072
  static nextlevel + #645, #3072
  static nextlevel + #646, #3072
  static nextlevel + #647, #3072
  static nextlevel + #648, #3072
  static nextlevel + #649, #3072
  static nextlevel + #650, #3072
  static nextlevel + #651, #3072
  static nextlevel + #652, #3072
  static nextlevel + #653, #3072
  static nextlevel + #654, #3072
  static nextlevel + #655, #3072
  static nextlevel + #656, #3072
  static nextlevel + #657, #3072
  static nextlevel + #658, #3072
  static nextlevel + #659, #3072
  static nextlevel + #660, #3072
  static nextlevel + #661, #3072
  static nextlevel + #662, #3072
  static nextlevel + #663, #3072
  static nextlevel + #664, #3072
  static nextlevel + #665, #3072
  static nextlevel + #666, #3072
  static nextlevel + #667, #3072
  static nextlevel + #668, #3072
  static nextlevel + #669, #3072
  static nextlevel + #670, #3072
  static nextlevel + #671, #3072
  static nextlevel + #672, #2304
  static nextlevel + #673, #3072
  static nextlevel + #674, #3072
  static nextlevel + #675, #3072
  static nextlevel + #676, #2304
  static nextlevel + #677, #3072
  static nextlevel + #678, #3072
  static nextlevel + #679, #3072

  ;Linha 17
  static nextlevel + #680, #3072
  static nextlevel + #681, #1024
  static nextlevel + #682, #1024
  static nextlevel + #683, #1024
  static nextlevel + #684, #1024
  static nextlevel + #685, #1024
  static nextlevel + #686, #1024
  static nextlevel + #687, #3072
  static nextlevel + #688, #3072
  static nextlevel + #689, #3072
  static nextlevel + #690, #3072
  static nextlevel + #691, #2304
  static nextlevel + #692, #2304
  static nextlevel + #693, #1024
  static nextlevel + #694, #1024
  static nextlevel + #695, #1024
  static nextlevel + #696, #1024
  static nextlevel + #697, #3072
  static nextlevel + #698, #3072
  static nextlevel + #699, #3072
  static nextlevel + #700, #3072
  static nextlevel + #701, #1024
  static nextlevel + #702, #1024
  static nextlevel + #703, #1024
  static nextlevel + #704, #1024
  static nextlevel + #705, #1024
  static nextlevel + #706, #1024
  static nextlevel + #707, #3072
  static nextlevel + #708, #3072
  static nextlevel + #709, #3072
  static nextlevel + #710, #2304
  static nextlevel + #711, #2304
  static nextlevel + #712, #1024
  static nextlevel + #713, #1024
  static nextlevel + #714, #1024
  static nextlevel + #715, #1024
  static nextlevel + #716, #2304
  static nextlevel + #717, #3072
  static nextlevel + #718, #3072
  static nextlevel + #719, #3072

  ;Linha 18
  static nextlevel + #720, #3072
  static nextlevel + #721, #3072
  static nextlevel + #722, #3072
  static nextlevel + #723, #3072
  static nextlevel + #724, #3072
  static nextlevel + #725, #3072
  static nextlevel + #726, #3072
  static nextlevel + #727, #3072
  static nextlevel + #728, #3072
  static nextlevel + #729, #3072
  static nextlevel + #730, #3072
  static nextlevel + #731, #2304
  static nextlevel + #732, #2304
  static nextlevel + #733, #3072
  static nextlevel + #734, #3072
  static nextlevel + #735, #3072
  static nextlevel + #736, #2304
  static nextlevel + #737, #2304
  static nextlevel + #738, #2304
  static nextlevel + #739, #2304
  static nextlevel + #740, #2304
  static nextlevel + #741, #2304
  static nextlevel + #742, #3072
  static nextlevel + #743, #3072
  static nextlevel + #744, #2304
  static nextlevel + #745, #2304
  static nextlevel + #746, #2304
  static nextlevel + #747, #2304
  static nextlevel + #748, #2304
  static nextlevel + #749, #2304
  static nextlevel + #750, #3072
  static nextlevel + #751, #2304
  static nextlevel + #752, #3072
  static nextlevel + #753, #3072
  static nextlevel + #754, #3072
  static nextlevel + #755, #3072
  static nextlevel + #756, #2304
  static nextlevel + #757, #3072
  static nextlevel + #758, #3072
  static nextlevel + #759, #3072

  ;Linha 19
  static nextlevel + #760, #3072
  static nextlevel + #761, #3072
  static nextlevel + #762, #3072
  static nextlevel + #763, #3072
  static nextlevel + #764, #3072
  static nextlevel + #765, #3072
  static nextlevel + #766, #3072
  static nextlevel + #767, #3072
  static nextlevel + #768, #3072
  static nextlevel + #769, #3072
  static nextlevel + #770, #3072
  static nextlevel + #771, #2304
  static nextlevel + #772, #2304
  static nextlevel + #773, #3072
  static nextlevel + #774, #3072
  static nextlevel + #775, #3072
  static nextlevel + #776, #2304
  static nextlevel + #777, #3072
  static nextlevel + #778, #3072
  static nextlevel + #779, #2304
  static nextlevel + #780, #2304
  static nextlevel + #781, #2304
  static nextlevel + #782, #3072
  static nextlevel + #783, #3072
  static nextlevel + #784, #2304
  static nextlevel + #785, #2304
  static nextlevel + #786, #2304
  static nextlevel + #787, #3072
  static nextlevel + #788, #3072
  static nextlevel + #789, #2304
  static nextlevel + #790, #3072
  static nextlevel + #791, #2304
  static nextlevel + #792, #3072
  static nextlevel + #793, #3072
  static nextlevel + #794, #2304
  static nextlevel + #795, #2304
  static nextlevel + #796, #3072
  static nextlevel + #797, #3072
  static nextlevel + #798, #3072
  static nextlevel + #799, #3072

  ;Linha 20
  static nextlevel + #800, #3072
  static nextlevel + #801, #3072
  static nextlevel + #802, #3072
  static nextlevel + #803, #3072
  static nextlevel + #804, #3072
  static nextlevel + #805, #3072
  static nextlevel + #806, #1024
  static nextlevel + #807, #1024
  static nextlevel + #808, #1024
  static nextlevel + #809, #1024
  static nextlevel + #810, #1024
  static nextlevel + #811, #2304
  static nextlevel + #812, #2304
  static nextlevel + #813, #3072
  static nextlevel + #814, #3072
  static nextlevel + #815, #3072
  static nextlevel + #816, #2304
  static nextlevel + #817, #2304
  static nextlevel + #818, #2304
  static nextlevel + #819, #2304
  static nextlevel + #820, #2304
  static nextlevel + #821, #2304
  static nextlevel + #822, #3072
  static nextlevel + #823, #3072
  static nextlevel + #824, #2304
  static nextlevel + #825, #2304
  static nextlevel + #826, #2304
  static nextlevel + #827, #2304
  static nextlevel + #828, #2304
  static nextlevel + #829, #2304
  static nextlevel + #830, #1024
  static nextlevel + #831, #2304
  static nextlevel + #832, #3072
  static nextlevel + #833, #3072
  static nextlevel + #834, #2304
  static nextlevel + #835, #3072
  static nextlevel + #836, #3072
  static nextlevel + #837, #3072
  static nextlevel + #838, #3072
  static nextlevel + #839, #3072

  ;Linha 21
  static nextlevel + #840, #3072
  static nextlevel + #841, #3072
  static nextlevel + #842, #3072
  static nextlevel + #843, #3072
  static nextlevel + #844, #3072
  static nextlevel + #845, #3072
  static nextlevel + #846, #3072
  static nextlevel + #847, #3072
  static nextlevel + #848, #3072
  static nextlevel + #849, #3072
  static nextlevel + #850, #3072
  static nextlevel + #851, #2304
  static nextlevel + #852, #2304
  static nextlevel + #853, #3072
  static nextlevel + #854, #3072
  static nextlevel + #855, #3072
  static nextlevel + #856, #2304
  static nextlevel + #857, #3072
  static nextlevel + #858, #3072
  static nextlevel + #859, #3072
  static nextlevel + #860, #3072
  static nextlevel + #861, #2304
  static nextlevel + #862, #2304
  static nextlevel + #863, #2304
  static nextlevel + #864, #2304
  static nextlevel + #865, #3072
  static nextlevel + #866, #2304
  static nextlevel + #867, #3072
  static nextlevel + #868, #3072
  static nextlevel + #869, #3072
  static nextlevel + #870, #3072
  static nextlevel + #871, #2304
  static nextlevel + #872, #3072
  static nextlevel + #873, #3072
  static nextlevel + #874, #3072
  static nextlevel + #875, #3072
  static nextlevel + #876, #3072
  static nextlevel + #877, #3072
  static nextlevel + #878, #3072
  static nextlevel + #879, #3072

  ;Linha 22
  static nextlevel + #880, #3072
  static nextlevel + #881, #3072
  static nextlevel + #882, #3072
  static nextlevel + #883, #3072
  static nextlevel + #884, #3072
  static nextlevel + #885, #3072
  static nextlevel + #886, #3072
  static nextlevel + #887, #3072
  static nextlevel + #888, #3072
  static nextlevel + #889, #3072
  static nextlevel + #890, #3072
  static nextlevel + #891, #2304
  static nextlevel + #892, #2304
  static nextlevel + #893, #2304
  static nextlevel + #894, #2304
  static nextlevel + #895, #2304
  static nextlevel + #896, #3072
  static nextlevel + #897, #2304
  static nextlevel + #898, #2304
  static nextlevel + #899, #2304
  static nextlevel + #900, #3072
  static nextlevel + #901, #3072
  static nextlevel + #902, #2304
  static nextlevel + #903, #2304
  static nextlevel + #904, #3072
  static nextlevel + #905, #3072
  static nextlevel + #906, #3072
  static nextlevel + #907, #2304
  static nextlevel + #908, #2304
  static nextlevel + #909, #2304
  static nextlevel + #910, #3072
  static nextlevel + #911, #2304
  static nextlevel + #912, #3072
  static nextlevel + #913, #3072
  static nextlevel + #914, #2304
  static nextlevel + #915, #3072
  static nextlevel + #916, #3072
  static nextlevel + #917, #3072
  static nextlevel + #918, #3072
  static nextlevel + #919, #3072

  ;Linha 23
  static nextlevel + #920, #3072
  static nextlevel + #921, #1024
  static nextlevel + #922, #1024
  static nextlevel + #923, #1024
  static nextlevel + #924, #1024
  static nextlevel + #925, #1024
  static nextlevel + #926, #1024
  static nextlevel + #927, #3072
  static nextlevel + #928, #3072
  static nextlevel + #929, #3072
  static nextlevel + #930, #3072
  static nextlevel + #931, #1024
  static nextlevel + #932, #1024
  static nextlevel + #933, #1024
  static nextlevel + #934, #1024
  static nextlevel + #935, #1024
  static nextlevel + #936, #1024
  static nextlevel + #937, #3072
  static nextlevel + #938, #3072
  static nextlevel + #939, #3072
  static nextlevel + #940, #3072
  static nextlevel + #941, #1024
  static nextlevel + #942, #1024
  static nextlevel + #943, #1024
  static nextlevel + #944, #1024
  static nextlevel + #945, #1024
  static nextlevel + #946, #1024
  static nextlevel + #947, #3072
  static nextlevel + #948, #3072
  static nextlevel + #949, #3072
  static nextlevel + #950, #3072
  static nextlevel + #951, #1024
  static nextlevel + #952, #1024
  static nextlevel + #953, #1024
  static nextlevel + #954, #1024
  static nextlevel + #955, #1024
  static nextlevel + #956, #1024
  static nextlevel + #957, #3072
  static nextlevel + #958, #3072
  static nextlevel + #959, #3072

  ;Linha 24
  static nextlevel + #960, #3072
  static nextlevel + #961, #3072
  static nextlevel + #962, #3072
  static nextlevel + #963, #3072
  static nextlevel + #964, #3072
  static nextlevel + #965, #3072
  static nextlevel + #966, #3072
  static nextlevel + #967, #3072
  static nextlevel + #968, #3072
  static nextlevel + #969, #3072
  static nextlevel + #970, #3072
  static nextlevel + #971, #3072
  static nextlevel + #972, #3072
  static nextlevel + #973, #3072
  static nextlevel + #974, #3072
  static nextlevel + #975, #3072
  static nextlevel + #976, #3072
  static nextlevel + #977, #3072
  static nextlevel + #978, #3072
  static nextlevel + #979, #3072
  static nextlevel + #980, #3072
  static nextlevel + #981, #3072
  static nextlevel + #982, #3072
  static nextlevel + #983, #3072
  static nextlevel + #984, #3072
  static nextlevel + #985, #3072
  static nextlevel + #986, #3072
  static nextlevel + #987, #3072
  static nextlevel + #988, #3072
  static nextlevel + #989, #3072
  static nextlevel + #990, #3072
  static nextlevel + #991, #3072
  static nextlevel + #992, #3072
  static nextlevel + #993, #3072
  static nextlevel + #994, #3072
  static nextlevel + #995, #3072
  static nextlevel + #996, #3072
  static nextlevel + #997, #3072
  static nextlevel + #998, #3072
  static nextlevel + #999, #3072

  ;Linha 25
  static nextlevel + #1000, #3072
  static nextlevel + #1001, #3072
  static nextlevel + #1002, #3072
  static nextlevel + #1003, #3072
  static nextlevel + #1004, #3072
  static nextlevel + #1005, #3072
  static nextlevel + #1006, #3072
  static nextlevel + #1007, #3072
  static nextlevel + #1008, #3072
  static nextlevel + #1009, #3072
  static nextlevel + #1010, #3072
  static nextlevel + #1011, #3072
  static nextlevel + #1012, #3072
  static nextlevel + #1013, #3072
  static nextlevel + #1014, #3072
  static nextlevel + #1015, #3072
  static nextlevel + #1016, #3072
  static nextlevel + #1017, #3072
  static nextlevel + #1018, #3072
  static nextlevel + #1019, #3072
  static nextlevel + #1020, #3072
  static nextlevel + #1021, #3072
  static nextlevel + #1022, #3072
  static nextlevel + #1023, #3072
  static nextlevel + #1024, #3072
  static nextlevel + #1025, #3072
  static nextlevel + #1026, #3072
  static nextlevel + #1027, #3072
  static nextlevel + #1028, #3072
  static nextlevel + #1029, #3072
  static nextlevel + #1030, #3072
  static nextlevel + #1031, #3072
  static nextlevel + #1032, #3072
  static nextlevel + #1033, #3072
  static nextlevel + #1034, #3072
  static nextlevel + #1035, #3072
  static nextlevel + #1036, #3072
  static nextlevel + #1037, #3072
  static nextlevel + #1038, #3072
  static nextlevel + #1039, #3072

  ;Linha 26
  static nextlevel + #1040, #3072
  static nextlevel + #1041, #3072
  static nextlevel + #1042, #3072
  static nextlevel + #1043, #3072
  static nextlevel + #1044, #3072
  static nextlevel + #1045, #3072
  static nextlevel + #1046, #1024
  static nextlevel + #1047, #1024
  static nextlevel + #1048, #1024
  static nextlevel + #1049, #1024
  static nextlevel + #1050, #1024
  static nextlevel + #1051, #1024
  static nextlevel + #1052, #3072
  static nextlevel + #1053, #3072
  static nextlevel + #1054, #3072
  static nextlevel + #1055, #3072
  static nextlevel + #1056, #1024
  static nextlevel + #1057, #1024
  static nextlevel + #1058, #1024
  static nextlevel + #1059, #1024
  static nextlevel + #1060, #1024
  static nextlevel + #1061, #1024
  static nextlevel + #1062, #3072
  static nextlevel + #1063, #3072
  static nextlevel + #1064, #3072
  static nextlevel + #1065, #3072
  static nextlevel + #1066, #1024
  static nextlevel + #1067, #1024
  static nextlevel + #1068, #1024
  static nextlevel + #1069, #1024
  static nextlevel + #1070, #1024
  static nextlevel + #1071, #1024
  static nextlevel + #1072, #3072
  static nextlevel + #1073, #3072
  static nextlevel + #1074, #3072
  static nextlevel + #1075, #3072
  static nextlevel + #1076, #3072
  static nextlevel + #1077, #3072
  static nextlevel + #1078, #3072
  static nextlevel + #1079, #3072

  ;Linha 27
  static nextlevel + #1080, #3072
  static nextlevel + #1081, #3072
  static nextlevel + #1082, #3072
  static nextlevel + #1083, #3072
  static nextlevel + #1084, #3072
  static nextlevel + #1085, #3072
  static nextlevel + #1086, #3072
  static nextlevel + #1087, #3072
  static nextlevel + #1088, #3072
  static nextlevel + #1089, #3072
  static nextlevel + #1090, #3072
  static nextlevel + #1091, #3072
  static nextlevel + #1092, #3072
  static nextlevel + #1093, #3072
  static nextlevel + #1094, #3072
  static nextlevel + #1095, #3072
  static nextlevel + #1096, #3072
  static nextlevel + #1097, #3072
  static nextlevel + #1098, #3072
  static nextlevel + #1099, #3072
  static nextlevel + #1100, #3072
  static nextlevel + #1101, #3072
  static nextlevel + #1102, #3072
  static nextlevel + #1103, #3072
  static nextlevel + #1104, #3072
  static nextlevel + #1105, #3072
  static nextlevel + #1106, #3072
  static nextlevel + #1107, #3072
  static nextlevel + #1108, #3072
  static nextlevel + #1109, #3072
  static nextlevel + #1110, #3072
  static nextlevel + #1111, #3072
  static nextlevel + #1112, #3072
  static nextlevel + #1113, #3072
  static nextlevel + #1114, #3072
  static nextlevel + #1115, #3072
  static nextlevel + #1116, #3072
  static nextlevel + #1117, #3072
  static nextlevel + #1118, #3072
  static nextlevel + #1119, #3072

  ;Linha 28
  static nextlevel + #1120, #3072
  static nextlevel + #1121, #3072
  static nextlevel + #1122, #3072
  static nextlevel + #1123, #3072
  static nextlevel + #1124, #3072
  static nextlevel + #1125, #3072
  static nextlevel + #1126, #3072
  static nextlevel + #1127, #3072
  static nextlevel + #1128, #3072
  static nextlevel + #1129, #3072
  static nextlevel + #1130, #3072
  static nextlevel + #1131, #3072
  static nextlevel + #1132, #3072
  static nextlevel + #1133, #3072
  static nextlevel + #1134, #3072
  static nextlevel + #1135, #3072
  static nextlevel + #1136, #3072
  static nextlevel + #1137, #3072
  static nextlevel + #1138, #3072
  static nextlevel + #1139, #3072
  static nextlevel + #1140, #3072
  static nextlevel + #1141, #3072
  static nextlevel + #1142, #3072
  static nextlevel + #1143, #3072
  static nextlevel + #1144, #3072
  static nextlevel + #1145, #3072
  static nextlevel + #1146, #3072
  static nextlevel + #1147, #3072
  static nextlevel + #1148, #3072
  static nextlevel + #1149, #3072
  static nextlevel + #1150, #3072
  static nextlevel + #1151, #3072
  static nextlevel + #1152, #3072
  static nextlevel + #1153, #3072
  static nextlevel + #1154, #3072
  static nextlevel + #1155, #3072
  static nextlevel + #1156, #3072
  static nextlevel + #1157, #3072
  static nextlevel + #1158, #3072
  static nextlevel + #1159, #3072

  ;Linha 29
  static nextlevel + #1160, #3072
  static nextlevel + #1161, #3072
  static nextlevel + #1162, #3072
  static nextlevel + #1163, #3072
  static nextlevel + #1164, #3072
  static nextlevel + #1165, #3072
  static nextlevel + #1166, #3072
  static nextlevel + #1167, #3072
  static nextlevel + #1168, #3072
  static nextlevel + #1169, #3072
  static nextlevel + #1170, #3072
  static nextlevel + #1171, #3072
  static nextlevel + #1172, #3072
  static nextlevel + #1173, #3072
  static nextlevel + #1174, #3072
  static nextlevel + #1175, #3072
  static nextlevel + #1176, #3072
  static nextlevel + #1177, #3072
  static nextlevel + #1178, #3072
  static nextlevel + #1179, #3072
  static nextlevel + #1180, #3072
  static nextlevel + #1181, #3072
  static nextlevel + #1182, #3072
  static nextlevel + #1183, #3072
  static nextlevel + #1184, #3072
  static nextlevel + #1185, #3072
  static nextlevel + #1186, #3072
  static nextlevel + #1187, #3072
  static nextlevel + #1188, #3072
  static nextlevel + #1189, #3072
  static nextlevel + #1190, #3072
  static nextlevel + #1191, #3072
  static nextlevel + #1192, #3072
  static nextlevel + #1193, #3072
  static nextlevel + #1194, #3072
  static nextlevel + #1195, #3072
  static nextlevel + #1196, #3072
  static nextlevel + #1197, #3072
  static nextlevel + #1198, #3072
  static nextlevel + #1199, #3072

endGame : var #1200
  ;Linha 0
  static endGame + #0, #2816
  static endGame + #1, #2816
  static endGame + #2, #2816
  static endGame + #3, #2816
  static endGame + #4, #2816
  static endGame + #5, #2816
  static endGame + #6, #2816
  static endGame + #7, #2816
  static endGame + #8, #2816
  static endGame + #9, #2816
  static endGame + #10, #2816
  static endGame + #11, #2816
  static endGame + #12, #2816
  static endGame + #13, #2816
  static endGame + #14, #2816
  static endGame + #15, #2816
  static endGame + #16, #2816
  static endGame + #17, #2816
  static endGame + #18, #2816
  static endGame + #19, #2816
  static endGame + #20, #2816
  static endGame + #21, #2816
  static endGame + #22, #2816
  static endGame + #23, #2816
  static endGame + #24, #2816
  static endGame + #25, #2816
  static endGame + #26, #2816
  static endGame + #27, #2816
  static endGame + #28, #2816
  static endGame + #29, #2816
  static endGame + #30, #2816
  static endGame + #31, #2816
  static endGame + #32, #2816
  static endGame + #33, #2816
  static endGame + #34, #2816
  static endGame + #35, #2816
  static endGame + #36, #2816
  static endGame + #37, #2816
  static endGame + #38, #2816
  static endGame + #39, #2816

  ;Linha 1
  static endGame + #40, #2816
  static endGame + #41, #2816
  static endGame + #42, #2816
  static endGame + #43, #2816
  static endGame + #44, #2816
  static endGame + #45, #2816
  static endGame + #46, #2816
  static endGame + #47, #2816
  static endGame + #48, #3072
  static endGame + #49, #3072
  static endGame + #50, #2816
  static endGame + #51, #2816
  static endGame + #52, #2816
  static endGame + #53, #2816
  static endGame + #54, #2816
  static endGame + #55, #2816
  static endGame + #56, #2816
  static endGame + #57, #2816
  static endGame + #58, #2816
  static endGame + #59, #2816
  static endGame + #60, #2816
  static endGame + #61, #2816
  static endGame + #62, #2816
  static endGame + #63, #2816
  static endGame + #64, #2816
  static endGame + #65, #2816
  static endGame + #66, #2816
  static endGame + #67, #2816
  static endGame + #68, #2816
  static endGame + #69, #2816
  static endGame + #70, #2816
  static endGame + #71, #2816
  static endGame + #72, #2816
  static endGame + #73, #2816
  static endGame + #74, #2816
  static endGame + #75, #2816
  static endGame + #76, #2816
  static endGame + #77, #2816
  static endGame + #78, #2816
  static endGame + #79, #2816

  ;Linha 2
  static endGame + #80, #2816
  static endGame + #81, #2816
  static endGame + #82, #2816
  static endGame + #83, #2816
  static endGame + #84, #2816
  static endGame + #85, #2816
  static endGame + #86, #2816
  static endGame + #87, #2816
  static endGame + #88, #2816
  static endGame + #89, #3072
  static endGame + #90, #2816
  static endGame + #91, #2816
  static endGame + #92, #2816
  static endGame + #93, #2816
  static endGame + #94, #2816
  static endGame + #95, #2816
  static endGame + #96, #2816
  static endGame + #97, #2816
  static endGame + #98, #2816
  static endGame + #99, #2816
  static endGame + #100, #2816
  static endGame + #101, #2816
  static endGame + #102, #2816
  static endGame + #103, #2816
  static endGame + #104, #2816
  static endGame + #105, #2816
  static endGame + #106, #2816
  static endGame + #107, #2816
  static endGame + #108, #2816
  static endGame + #109, #2816
  static endGame + #110, #2816
  static endGame + #111, #2816
  static endGame + #112, #2816
  static endGame + #113, #2816
  static endGame + #114, #2816
  static endGame + #115, #2816
  static endGame + #116, #2816
  static endGame + #117, #2816
  static endGame + #118, #2816
  static endGame + #119, #2816

  ;Linha 3
  static endGame + #120, #2816
  static endGame + #121, #2816
  static endGame + #122, #2816
  static endGame + #123, #2816
  static endGame + #124, #2304
  static endGame + #125, #2304
  static endGame + #126, #2304
  static endGame + #127, #2304
  static endGame + #128, #2816
  static endGame + #129, #2816
  static endGame + #130, #2816
  static endGame + #131, #2816
  static endGame + #132, #2816
  static endGame + #133, #2816
  static endGame + #134, #2816
  static endGame + #135, #2816
  static endGame + #136, #2816
  static endGame + #137, #2816
  static endGame + #138, #2816
  static endGame + #139, #2816
  static endGame + #140, #2816
  static endGame + #141, #2816
  static endGame + #142, #2816
  static endGame + #143, #2816
  static endGame + #144, #2816
  static endGame + #145, #2816
  static endGame + #146, #2816
  static endGame + #147, #2816
  static endGame + #148, #2816
  static endGame + #149, #2816
  static endGame + #150, #2816
  static endGame + #151, #2816
  static endGame + #152, #2816
  static endGame + #153, #2816
  static endGame + #154, #2816
  static endGame + #155, #2816
  static endGame + #156, #2816
  static endGame + #157, #2816
  static endGame + #158, #2816
  static endGame + #159, #2816

  ;Linha 4
  static endGame + #160, #2816
  static endGame + #161, #2816
  static endGame + #162, #2816
  static endGame + #163, #2816
  static endGame + #164, #2304
  static endGame + #165, #2304
  static endGame + #166, #2304
  static endGame + #167, #2304
  static endGame + #168, #2816
  static endGame + #169, #2816
  static endGame + #170, #2816
  static endGame + #171, #2816
  static endGame + #172, #2816
  static endGame + #173, #2816
  static endGame + #174, #2816
  static endGame + #175, #2816
  static endGame + #176, #2816
  static endGame + #177, #2816
  static endGame + #178, #2816
  static endGame + #179, #2816
  static endGame + #180, #2816
  static endGame + #181, #2816
  static endGame + #182, #2816
  static endGame + #183, #2816
  static endGame + #184, #2816
  static endGame + #185, #2816
  static endGame + #186, #2816
  static endGame + #187, #2816
  static endGame + #188, #2816
  static endGame + #189, #2816
  static endGame + #190, #2816
  static endGame + #191, #2816
  static endGame + #192, #2816
  static endGame + #193, #2816
  static endGame + #194, #2816
  static endGame + #195, #2816
  static endGame + #196, #2816
  static endGame + #197, #2816
  static endGame + #198, #2816
  static endGame + #199, #2816

  ;Linha 5
  static endGame + #200, #2816
  static endGame + #201, #2816
  static endGame + #202, #2816
  static endGame + #203, #2816
  static endGame + #204, #2304
  static endGame + #205, #2304
  static endGame + #206, #2304
  static endGame + #207, #2304
  static endGame + #208, #2816
  static endGame + #209, #2816
  static endGame + #210, #2816
  static endGame + #211, #2816
  static endGame + #212, #2816
  static endGame + #213, #2816
  static endGame + #214, #2816
  static endGame + #215, #2816
  static endGame + #216, #2816
  static endGame + #217, #2816
  static endGame + #218, #2816
  static endGame + #219, #2816
  static endGame + #220, #2816
  static endGame + #221, #2816
  static endGame + #222, #2816
  static endGame + #223, #2816
  static endGame + #224, #2816
  static endGame + #225, #2816
  static endGame + #226, #2816
  static endGame + #227, #2816
  static endGame + #228, #2816
  static endGame + #229, #2816
  static endGame + #230, #2816
  static endGame + #231, #2816
  static endGame + #232, #2816
  static endGame + #233, #2816
  static endGame + #234, #2816
  static endGame + #235, #2816
  static endGame + #236, #2816
  static endGame + #237, #2816
  static endGame + #238, #2816
  static endGame + #239, #2816

  ;Linha 6
  static endGame + #240, #2816
  static endGame + #241, #2816
  static endGame + #242, #2816
  static endGame + #243, #2816
  static endGame + #244, #2304
  static endGame + #245, #2304
  static endGame + #246, #2304
  static endGame + #247, #2304
  static endGame + #248, #2816
  static endGame + #249, #2816
  static endGame + #250, #2816
  static endGame + #251, #2816
  static endGame + #252, #2816
  static endGame + #253, #2816
  static endGame + #254, #2816
  static endGame + #255, #2816
  static endGame + #256, #2816
  static endGame + #257, #2816
  static endGame + #258, #2816
  static endGame + #259, #2816
  static endGame + #260, #2816
  static endGame + #261, #2816
  static endGame + #262, #2816
  static endGame + #263, #2816
  static endGame + #264, #2816
  static endGame + #265, #2816
  static endGame + #266, #2816
  static endGame + #267, #2816
  static endGame + #268, #2816
  static endGame + #269, #2816
  static endGame + #270, #2816
  static endGame + #271, #2816
  static endGame + #272, #2816
  static endGame + #273, #2816
  static endGame + #274, #2816
  static endGame + #275, #2816
  static endGame + #276, #2816
  static endGame + #277, #2816
  static endGame + #278, #2816
  static endGame + #279, #2816

  ;Linha 7
  static endGame + #280, #2816
  static endGame + #281, #2816
  static endGame + #282, #2816
  static endGame + #283, #2816
  static endGame + #284, #2816
  static endGame + #285, #2816
  static endGame + #286, #2816
  static endGame + #287, #2816
  static endGame + #288, #2816
  static endGame + #289, #2816
  static endGame + #290, #2816
  static endGame + #291, #2816
  static endGame + #292, #2816
  static endGame + #293, #2816
  static endGame + #294, #2816
  static endGame + #295, #2816
  static endGame + #296, #2816
  static endGame + #297, #2816
  static endGame + #298, #2816
  static endGame + #299, #2816
  static endGame + #300, #2816
  static endGame + #301, #2816
  static endGame + #302, #2816
  static endGame + #303, #2816
  static endGame + #304, #2816
  static endGame + #305, #2816
  static endGame + #306, #2816
  static endGame + #307, #2816
  static endGame + #308, #2816
  static endGame + #309, #2816
  static endGame + #310, #2816
  static endGame + #311, #2816
  static endGame + #312, #2816
  static endGame + #313, #2816
  static endGame + #314, #2816
  static endGame + #315, #2816
  static endGame + #316, #2816
  static endGame + #317, #2816
  static endGame + #318, #2816
  static endGame + #319, #2816

  ;Linha 8
  static endGame + #320, #2816
  static endGame + #321, #2816
  static endGame + #322, #2816
  static endGame + #323, #2816
  static endGame + #324, #2816
  static endGame + #325, #2816
  static endGame + #326, #2816
  static endGame + #327, #2816
  static endGame + #328, #2816
  static endGame + #329, #2816
  static endGame + #330, #2816
  static endGame + #331, #2816
  static endGame + #332, #2816
  static endGame + #333, #2816
  static endGame + #334, #2816
  static endGame + #335, #2816
  static endGame + #336, #2816
  static endGame + #337, #2816
  static endGame + #338, #2816
  static endGame + #339, #2816
  static endGame + #340, #2816
  static endGame + #341, #2816
  static endGame + #342, #2816
  static endGame + #343, #2816
  static endGame + #344, #2816
  static endGame + #345, #2816
  static endGame + #346, #2816
  static endGame + #347, #2816
  static endGame + #348, #2816
  static endGame + #349, #2816
  static endGame + #350, #2816
  static endGame + #351, #2816
  static endGame + #352, #2816
  static endGame + #353, #2816
  static endGame + #354, #2816
  static endGame + #355, #2816
  static endGame + #356, #2816
  static endGame + #357, #2816
  static endGame + #358, #2816
  static endGame + #359, #2816

  ;Linha 9
  static endGame + #360, #2816
  static endGame + #361, #2816
  static endGame + #362, #2816
  static endGame + #363, #2816
  static endGame + #364, #2816
  static endGame + #365, #2816
  static endGame + #366, #2816
  static endGame + #367, #2816
  static endGame + #368, #2816
  static endGame + #369, #2816
  static endGame + #370, #2816
  static endGame + #371, #2816
  static endGame + #372, #2816
  static endGame + #373, #2816
  static endGame + #374, #2816
  static endGame + #375, #2816
  static endGame + #376, #2816
  static endGame + #377, #2816
  static endGame + #378, #2816
  static endGame + #379, #2816
  static endGame + #380, #2816
  static endGame + #381, #2816
  static endGame + #382, #2816
  static endGame + #383, #2816
  static endGame + #384, #2816
  static endGame + #385, #2816
  static endGame + #386, #2816
  static endGame + #387, #2816
  static endGame + #388, #2816
  static endGame + #389, #2816
  static endGame + #390, #2816
  static endGame + #391, #2816
  static endGame + #392, #2816
  static endGame + #393, #2816
  static endGame + #394, #2816
  static endGame + #395, #2816
  static endGame + #396, #2816
  static endGame + #397, #2816
  static endGame + #398, #2816
  static endGame + #399, #2816

  ;Linha 10
  static endGame + #400, #2816
  static endGame + #401, #2816
  static endGame + #402, #2816
  static endGame + #403, #2816
  static endGame + #404, #512
  static endGame + #405, #512
  static endGame + #406, #512
  static endGame + #407, #512
  static endGame + #408, #512
  static endGame + #409, #512
  static endGame + #410, #512
  static endGame + #411, #512
  static endGame + #412, #2816
  static endGame + #413, #2816
  static endGame + #414, #2816
  static endGame + #415, #2816
  static endGame + #416, #2816
  static endGame + #417, #2816
  static endGame + #418, #2816
  static endGame + #419, #2816
  static endGame + #420, #2816
  static endGame + #421, #2816
  static endGame + #422, #2816
  static endGame + #423, #2816
  static endGame + #424, #2816
  static endGame + #425, #2816
  static endGame + #426, #2816
  static endGame + #427, #2816
  static endGame + #428, #2816
  static endGame + #429, #2816
  static endGame + #430, #2816
  static endGame + #431, #2816
  static endGame + #432, #2816
  static endGame + #433, #2816
  static endGame + #434, #2816
  static endGame + #435, #2816
  static endGame + #436, #2816
  static endGame + #437, #2816
  static endGame + #438, #2816
  static endGame + #439, #2816

  ;Linha 11
  static endGame + #440, #2816
  static endGame + #441, #2816
  static endGame + #442, #2816
  static endGame + #443, #2816
  static endGame + #444, #2816
  static endGame + #445, #2816
  static endGame + #446, #2816
  static endGame + #447, #512
  static endGame + #448, #512
  static endGame + #449, #2816
  static endGame + #450, #2816
  static endGame + #451, #2816
  static endGame + #452, #512
  static endGame + #453, #2816
  static endGame + #454, #2816
  static endGame + #455, #2816
  static endGame + #456, #512
  static endGame + #457, #512
  static endGame + #458, #2816
  static endGame + #459, #2816
  static endGame + #460, #2816
  static endGame + #461, #2816
  static endGame + #462, #2816
  static endGame + #463, #2816
  static endGame + #464, #2816
  static endGame + #465, #2816
  static endGame + #466, #2816
  static endGame + #467, #2816
  static endGame + #468, #2816
  static endGame + #469, #2816
  static endGame + #470, #2816
  static endGame + #471, #2816
  static endGame + #472, #2816
  static endGame + #473, #2816
  static endGame + #474, #2816
  static endGame + #475, #2816
  static endGame + #476, #2816
  static endGame + #477, #2816
  static endGame + #478, #2816
  static endGame + #479, #2816

  ;Linha 12
  static endGame + #480, #2816
  static endGame + #481, #2816
  static endGame + #482, #2816
  static endGame + #483, #2816
  static endGame + #484, #2816
  static endGame + #485, #2816
  static endGame + #486, #2816
  static endGame + #487, #512
  static endGame + #488, #512
  static endGame + #489, #2816
  static endGame + #490, #2816
  static endGame + #491, #2816
  static endGame + #492, #512
  static endGame + #493, #512
  static endGame + #494, #2816
  static endGame + #495, #512
  static endGame + #496, #2816
  static endGame + #497, #2816
  static endGame + #498, #512
  static endGame + #499, #2816
  static endGame + #500, #2816
  static endGame + #501, #2816
  static endGame + #502, #2816
  static endGame + #503, #2816
  static endGame + #504, #2816
  static endGame + #505, #2816
  static endGame + #506, #2816
  static endGame + #507, #2816
  static endGame + #508, #2816
  static endGame + #509, #2816
  static endGame + #510, #2816
  static endGame + #511, #2816
  static endGame + #512, #2816
  static endGame + #513, #2816
  static endGame + #514, #2816
  static endGame + #515, #2816
  static endGame + #516, #2816
  static endGame + #517, #2816
  static endGame + #518, #2816
  static endGame + #519, #2816

  ;Linha 13
  static endGame + #520, #2816
  static endGame + #521, #2816
  static endGame + #522, #2816
  static endGame + #523, #2816
  static endGame + #524, #2816
  static endGame + #525, #2816
  static endGame + #526, #2816
  static endGame + #527, #512
  static endGame + #528, #512
  static endGame + #529, #2816
  static endGame + #530, #2816
  static endGame + #531, #2816
  static endGame + #532, #512
  static endGame + #533, #2816
  static endGame + #534, #512
  static endGame + #535, #512
  static endGame + #536, #512
  static endGame + #537, #512
  static endGame + #538, #512
  static endGame + #539, #2816
  static endGame + #540, #2816
  static endGame + #541, #2816
  static endGame + #542, #2816
  static endGame + #543, #2816
  static endGame + #544, #2816
  static endGame + #545, #2816
  static endGame + #546, #2816
  static endGame + #547, #2816
  static endGame + #548, #2816
  static endGame + #549, #2816
  static endGame + #550, #2816
  static endGame + #551, #2816
  static endGame + #552, #2816
  static endGame + #553, #2816
  static endGame + #554, #2816
  static endGame + #555, #2816
  static endGame + #556, #2816
  static endGame + #557, #2816
  static endGame + #558, #2816
  static endGame + #559, #2816

  ;Linha 14
  static endGame + #560, #2816
  static endGame + #561, #2816
  static endGame + #562, #2816
  static endGame + #563, #2816
  static endGame + #564, #2816
  static endGame + #565, #2816
  static endGame + #566, #2816
  static endGame + #567, #512
  static endGame + #568, #512
  static endGame + #569, #2816
  static endGame + #570, #2816
  static endGame + #571, #2816
  static endGame + #572, #512
  static endGame + #573, #2816
  static endGame + #574, #512
  static endGame + #575, #512
  static endGame + #576, #2816
  static endGame + #577, #2816
  static endGame + #578, #2816
  static endGame + #579, #2816
  static endGame + #580, #2816
  static endGame + #581, #2816
  static endGame + #582, #2816
  static endGame + #583, #2816
  static endGame + #584, #2816
  static endGame + #585, #2816
  static endGame + #586, #2816
  static endGame + #587, #2816
  static endGame + #588, #2816
  static endGame + #589, #2816
  static endGame + #590, #2816
  static endGame + #591, #2816
  static endGame + #592, #2816
  static endGame + #593, #2816
  static endGame + #594, #2816
  static endGame + #595, #2816
  static endGame + #596, #2816
  static endGame + #597, #2816
  static endGame + #598, #2816
  static endGame + #599, #2816

  ;Linha 15
  static endGame + #600, #2816
  static endGame + #601, #2816
  static endGame + #602, #2816
  static endGame + #603, #2816
  static endGame + #604, #2816
  static endGame + #605, #2816
  static endGame + #606, #2816
  static endGame + #607, #512
  static endGame + #608, #512
  static endGame + #609, #2816
  static endGame + #610, #2816
  static endGame + #611, #2816
  static endGame + #612, #512
  static endGame + #613, #2816
  static endGame + #614, #512
  static endGame + #615, #2816
  static endGame + #616, #512
  static endGame + #617, #512
  static endGame + #618, #512
  static endGame + #619, #512
  static endGame + #620, #512
  static endGame + #621, #512
  static endGame + #622, #512
  static endGame + #623, #2304
  static endGame + #624, #2816
  static endGame + #625, #2816
  static endGame + #626, #2816
  static endGame + #627, #2816
  static endGame + #628, #2816
  static endGame + #629, #2816
  static endGame + #630, #2816
  static endGame + #631, #2816
  static endGame + #632, #2816
  static endGame + #633, #2816
  static endGame + #634, #2816
  static endGame + #635, #2816
  static endGame + #636, #2816
  static endGame + #637, #2816
  static endGame + #638, #2816
  static endGame + #639, #2816

  ;Linha 16
  static endGame + #640, #2816
  static endGame + #641, #2816
  static endGame + #642, #2816
  static endGame + #643, #2816
  static endGame + #644, #2816
  static endGame + #645, #2816
  static endGame + #646, #2816
  static endGame + #647, #2816
  static endGame + #648, #2816
  static endGame + #649, #2816
  static endGame + #650, #2816
  static endGame + #651, #2816
  static endGame + #652, #2816
  static endGame + #653, #2816
  static endGame + #654, #2816
  static endGame + #655, #2816
  static endGame + #656, #2816
  static endGame + #657, #2816
  static endGame + #658, #2816
  static endGame + #659, #2816
  static endGame + #660, #2816
  static endGame + #661, #2816
  static endGame + #662, #2816
  static endGame + #663, #2816
  static endGame + #664, #2816
  static endGame + #665, #2816
  static endGame + #666, #2816
  static endGame + #667, #2816
  static endGame + #668, #2816
  static endGame + #669, #2816
  static endGame + #670, #2816
  static endGame + #671, #2816
  static endGame + #672, #2816
  static endGame + #673, #2816
  static endGame + #674, #2816
  static endGame + #675, #2816
  static endGame + #676, #2816
  static endGame + #677, #2816
  static endGame + #678, #2816
  static endGame + #679, #2816

  ;Linha 17
  static endGame + #680, #2816
  static endGame + #681, #2816
  static endGame + #682, #2816
  static endGame + #683, #2816
  static endGame + #684, #2816
  static endGame + #685, #2816
  static endGame + #686, #2816
  static endGame + #687, #2816
  static endGame + #688, #2816
  static endGame + #689, #2816
  static endGame + #690, #2816
  static endGame + #691, #2816
  static endGame + #692, #2816
  static endGame + #693, #2816
  static endGame + #694, #2816
  static endGame + #695, #512
  static endGame + #696, #512
  static endGame + #697, #512
  static endGame + #698, #512
  static endGame + #699, #512
  static endGame + #700, #2816
  static endGame + #701, #2816
  static endGame + #702, #2816
  static endGame + #703, #2816
  static endGame + #704, #2816
  static endGame + #705, #2816
  static endGame + #706, #2816
  static endGame + #707, #2816
  static endGame + #708, #2816
  static endGame + #709, #2816
  static endGame + #710, #512
  static endGame + #711, #2816
  static endGame + #712, #2816
  static endGame + #713, #2816
  static endGame + #714, #2816
  static endGame + #715, #2816
  static endGame + #716, #2816
  static endGame + #717, #2816
  static endGame + #718, #2816
  static endGame + #719, #2816

  ;Linha 18
  static endGame + #720, #2816
  static endGame + #721, #2816
  static endGame + #722, #2816
  static endGame + #723, #2816
  static endGame + #724, #2816
  static endGame + #725, #2816
  static endGame + #726, #2816
  static endGame + #727, #2816
  static endGame + #728, #2816
  static endGame + #729, #2816
  static endGame + #730, #2816
  static endGame + #731, #2816
  static endGame + #732, #2816
  static endGame + #733, #2816
  static endGame + #734, #2816
  static endGame + #735, #512
  static endGame + #736, #2816
  static endGame + #737, #2816
  static endGame + #738, #2816
  static endGame + #739, #2816
  static endGame + #740, #2816
  static endGame + #741, #2816
  static endGame + #742, #2816
  static endGame + #743, #2816
  static endGame + #744, #2816
  static endGame + #745, #2816
  static endGame + #746, #2816
  static endGame + #747, #2816
  static endGame + #748, #2816
  static endGame + #749, #2816
  static endGame + #750, #512
  static endGame + #751, #2816
  static endGame + #752, #2816
  static endGame + #753, #2816
  static endGame + #754, #2816
  static endGame + #755, #2816
  static endGame + #756, #2816
  static endGame + #757, #2816
  static endGame + #758, #2816
  static endGame + #759, #2816

  ;Linha 19
  static endGame + #760, #2816
  static endGame + #761, #2816
  static endGame + #762, #2816
  static endGame + #763, #2816
  static endGame + #764, #2816
  static endGame + #765, #2816
  static endGame + #766, #2816
  static endGame + #767, #2816
  static endGame + #768, #2816
  static endGame + #769, #2816
  static endGame + #770, #2816
  static endGame + #771, #2816
  static endGame + #772, #2816
  static endGame + #773, #2816
  static endGame + #774, #2816
  static endGame + #775, #512
  static endGame + #776, #2816
  static endGame + #777, #2816
  static endGame + #778, #2816
  static endGame + #779, #2816
  static endGame + #780, #2816
  static endGame + #781, #512
  static endGame + #782, #512
  static endGame + #783, #512
  static endGame + #784, #512
  static endGame + #785, #2816
  static endGame + #786, #2816
  static endGame + #787, #2816
  static endGame + #788, #2816
  static endGame + #789, #2816
  static endGame + #790, #512
  static endGame + #791, #2816
  static endGame + #792, #2816
  static endGame + #793, #2816
  static endGame + #794, #2816
  static endGame + #795, #2816
  static endGame + #796, #2816
  static endGame + #797, #2816
  static endGame + #798, #2816
  static endGame + #799, #2816

  ;Linha 20
  static endGame + #800, #2816
  static endGame + #801, #2816
  static endGame + #802, #2816
  static endGame + #803, #2816
  static endGame + #804, #2816
  static endGame + #805, #2816
  static endGame + #806, #2816
  static endGame + #807, #2816
  static endGame + #808, #2816
  static endGame + #809, #2816
  static endGame + #810, #2816
  static endGame + #811, #2816
  static endGame + #812, #2816
  static endGame + #813, #2816
  static endGame + #814, #2816
  static endGame + #815, #512
  static endGame + #816, #512
  static endGame + #817, #512
  static endGame + #818, #512
  static endGame + #819, #512
  static endGame + #820, #2816
  static endGame + #821, #512
  static endGame + #822, #2816
  static endGame + #823, #2816
  static endGame + #824, #512
  static endGame + #825, #2816
  static endGame + #826, #2816
  static endGame + #827, #512
  static endGame + #828, #512
  static endGame + #829, #512
  static endGame + #830, #512
  static endGame + #831, #2816
  static endGame + #832, #2816
  static endGame + #833, #2816
  static endGame + #834, #2816
  static endGame + #835, #2816
  static endGame + #836, #2816
  static endGame + #837, #2816
  static endGame + #838, #2816
  static endGame + #839, #2816

  ;Linha 21
  static endGame + #840, #2816
  static endGame + #841, #2816
  static endGame + #842, #2816
  static endGame + #843, #2816
  static endGame + #844, #2816
  static endGame + #845, #2816
  static endGame + #846, #2816
  static endGame + #847, #2816
  static endGame + #848, #2816
  static endGame + #849, #2816
  static endGame + #850, #2816
  static endGame + #851, #2816
  static endGame + #852, #2816
  static endGame + #853, #2816
  static endGame + #854, #2816
  static endGame + #855, #512
  static endGame + #856, #2816
  static endGame + #857, #2816
  static endGame + #858, #2816
  static endGame + #859, #2816
  static endGame + #860, #512
  static endGame + #861, #512
  static endGame + #862, #2816
  static endGame + #863, #2816
  static endGame + #864, #512
  static endGame + #865, #512
  static endGame + #866, #2816
  static endGame + #867, #512
  static endGame + #868, #2816
  static endGame + #869, #2816
  static endGame + #870, #512
  static endGame + #871, #2816
  static endGame + #872, #2816
  static endGame + #873, #2816
  static endGame + #874, #2816
  static endGame + #875, #2816
  static endGame + #876, #2816
  static endGame + #877, #2816
  static endGame + #878, #2816
  static endGame + #879, #2816

  ;Linha 22
  static endGame + #880, #2816
  static endGame + #881, #2816
  static endGame + #882, #2816
  static endGame + #883, #2816
  static endGame + #884, #2816
  static endGame + #885, #2816
  static endGame + #886, #2816
  static endGame + #887, #2816
  static endGame + #888, #2816
  static endGame + #889, #2816
  static endGame + #890, #2816
  static endGame + #891, #2816
  static endGame + #892, #2816
  static endGame + #893, #2816
  static endGame + #894, #2816
  static endGame + #895, #512
  static endGame + #896, #2816
  static endGame + #897, #2816
  static endGame + #898, #2816
  static endGame + #899, #512
  static endGame + #900, #512
  static endGame + #901, #512
  static endGame + #902, #2816
  static endGame + #903, #2816
  static endGame + #904, #512
  static endGame + #905, #512
  static endGame + #906, #2816
  static endGame + #907, #512
  static endGame + #908, #2816
  static endGame + #909, #2816
  static endGame + #910, #512
  static endGame + #911, #2816
  static endGame + #912, #2816
  static endGame + #913, #2816
  static endGame + #914, #2816
  static endGame + #915, #2816
  static endGame + #916, #2816
  static endGame + #917, #2816
  static endGame + #918, #2816
  static endGame + #919, #2816

  ;Linha 23
  static endGame + #920, #2816
  static endGame + #921, #2816
  static endGame + #922, #2816
  static endGame + #923, #2816
  static endGame + #924, #2816
  static endGame + #925, #2816
  static endGame + #926, #2816
  static endGame + #927, #2816
  static endGame + #928, #2816
  static endGame + #929, #2816
  static endGame + #930, #2816
  static endGame + #931, #2816
  static endGame + #932, #2816
  static endGame + #933, #2816
  static endGame + #934, #2816
  static endGame + #935, #512
  static endGame + #936, #512
  static endGame + #937, #512
  static endGame + #938, #512
  static endGame + #939, #512
  static endGame + #940, #2816
  static endGame + #941, #512
  static endGame + #942, #2816
  static endGame + #943, #2816
  static endGame + #944, #512
  static endGame + #945, #2816
  static endGame + #946, #2816
  static endGame + #947, #512
  static endGame + #948, #512
  static endGame + #949, #512
  static endGame + #950, #512
  static endGame + #951, #2816
  static endGame + #952, #2816
  static endGame + #953, #2816
  static endGame + #954, #2816
  static endGame + #955, #2816
  static endGame + #956, #2816
  static endGame + #957, #2816
  static endGame + #958, #2816
  static endGame + #959, #2816

  ;Linha 24
  static endGame + #960, #2816
  static endGame + #961, #2816
  static endGame + #962, #2816
  static endGame + #963, #2816
  static endGame + #964, #2816
  static endGame + #965, #2816
  static endGame + #966, #2816
  static endGame + #967, #2816
  static endGame + #968, #2816
  static endGame + #969, #2816
  static endGame + #970, #2816
  static endGame + #971, #2816
  static endGame + #972, #2816
  static endGame + #973, #2816
  static endGame + #974, #2816
  static endGame + #975, #2816
  static endGame + #976, #2816
  static endGame + #977, #2816
  static endGame + #978, #2816
  static endGame + #979, #2816
  static endGame + #980, #2816
  static endGame + #981, #2816
  static endGame + #982, #2816
  static endGame + #983, #2816
  static endGame + #984, #2816
  static endGame + #985, #2816
  static endGame + #986, #2816
  static endGame + #987, #2816
  static endGame + #988, #2816
  static endGame + #989, #2816
  static endGame + #990, #2816
  static endGame + #991, #2816
  static endGame + #992, #2816
  static endGame + #993, #2816
  static endGame + #994, #2816
  static endGame + #995, #2816
  static endGame + #996, #2816
  static endGame + #997, #2816
  static endGame + #998, #2816
  static endGame + #999, #2816

  ;Linha 25
  static endGame + #1000, #2816
  static endGame + #1001, #2816
  static endGame + #1002, #2816
  static endGame + #1003, #2816
  static endGame + #1004, #2816
  static endGame + #1005, #2816
  static endGame + #1006, #2816
  static endGame + #1007, #2816
  static endGame + #1008, #2816
  static endGame + #1009, #2816
  static endGame + #1010, #2816
  static endGame + #1011, #2816
  static endGame + #1012, #2816
  static endGame + #1013, #2816
  static endGame + #1014, #2816
  static endGame + #1015, #2816
  static endGame + #1016, #2816
  static endGame + #1017, #2816
  static endGame + #1018, #2816
  static endGame + #1019, #2816
  static endGame + #1020, #2816
  static endGame + #1021, #2816
  static endGame + #1022, #2816
  static endGame + #1023, #2816
  static endGame + #1024, #2816
  static endGame + #1025, #2816
  static endGame + #1026, #2816
  static endGame + #1027, #2816
  static endGame + #1028, #2816
  static endGame + #1029, #2816
  static endGame + #1030, #2816
  static endGame + #1031, #2816
  static endGame + #1032, #2816
  static endGame + #1033, #2816
  static endGame + #1034, #2816
  static endGame + #1035, #2816
  static endGame + #1036, #2816
  static endGame + #1037, #2816
  static endGame + #1038, #2816
  static endGame + #1039, #2816

  ;Linha 26
  static endGame + #1040, #2816
  static endGame + #1041, #2816
  static endGame + #1042, #2816
  static endGame + #1043, #2816
  static endGame + #1044, #2816
  static endGame + #1045, #2816
  static endGame + #1046, #2816
  static endGame + #1047, #2816
  static endGame + #1048, #2816
  static endGame + #1049, #2816
  static endGame + #1050, #2816
  static endGame + #1051, #2816
  static endGame + #1052, #2816
  static endGame + #1053, #2816
  static endGame + #1054, #2816
  static endGame + #1055, #2816
  static endGame + #1056, #2816
  static endGame + #1057, #2816
  static endGame + #1058, #2816
  static endGame + #1059, #2816
  static endGame + #1060, #2816
  static endGame + #1061, #2816
  static endGame + #1062, #2816
  static endGame + #1063, #2816
  static endGame + #1064, #2816
  static endGame + #1065, #2816
  static endGame + #1066, #2816
  static endGame + #1067, #2816
  static endGame + #1068, #2816
  static endGame + #1069, #2816
  static endGame + #1070, #2816
  static endGame + #1071, #2816
  static endGame + #1072, #2816
  static endGame + #1073, #2816
  static endGame + #1074, #2816
  static endGame + #1075, #2816
  static endGame + #1076, #2816
  static endGame + #1077, #2816
  static endGame + #1078, #2816
  static endGame + #1079, #2816

  ;Linha 27
  static endGame + #1080, #2816
  static endGame + #1081, #2816
  static endGame + #1082, #2816
  static endGame + #1083, #2816
  static endGame + #1084, #2816
  static endGame + #1085, #2816
  static endGame + #1086, #2816
  static endGame + #1087, #2816
  static endGame + #1088, #2816
  static endGame + #1089, #2816
  static endGame + #1090, #2816
  static endGame + #1091, #2816
  static endGame + #1092, #2816
  static endGame + #1093, #2816
  static endGame + #1094, #2816
  static endGame + #1095, #2816
  static endGame + #1096, #2816
  static endGame + #1097, #2816
  static endGame + #1098, #2816
  static endGame + #1099, #2816
  static endGame + #1100, #2816
  static endGame + #1101, #2816
  static endGame + #1102, #2816
  static endGame + #1103, #2816
  static endGame + #1104, #2816
  static endGame + #1105, #2816
  static endGame + #1106, #2816
  static endGame + #1107, #2816
  static endGame + #1108, #2816
  static endGame + #1109, #2816
  static endGame + #1110, #2816
  static endGame + #1111, #2816
  static endGame + #1112, #2816
  static endGame + #1113, #2816
  static endGame + #1114, #2816
  static endGame + #1115, #2816
  static endGame + #1116, #2816
  static endGame + #1117, #2816
  static endGame + #1118, #2816
  static endGame + #1119, #2816

  ;Linha 28
  static endGame + #1120, #2816
  static endGame + #1121, #2816
  static endGame + #1122, #2816
  static endGame + #1123, #2816
  static endGame + #1124, #2816
  static endGame + #1125, #2816
  static endGame + #1126, #2816
  static endGame + #1127, #2816
  static endGame + #1128, #2816
  static endGame + #1129, #2816
  static endGame + #1130, #2816
  static endGame + #1131, #2816
  static endGame + #1132, #2816
  static endGame + #1133, #2816
  static endGame + #1134, #2816
  static endGame + #1135, #2816
  static endGame + #1136, #2816
  static endGame + #1137, #2816
  static endGame + #1138, #2816
  static endGame + #1139, #2816
  static endGame + #1140, #2816
  static endGame + #1141, #2816
  static endGame + #1142, #2816
  static endGame + #1143, #2816
  static endGame + #1144, #2816
  static endGame + #1145, #2816
  static endGame + #1146, #2816
  static endGame + #1147, #2816
  static endGame + #1148, #2816
  static endGame + #1149, #2816
  static endGame + #1150, #2816
  static endGame + #1151, #2816
  static endGame + #1152, #2816
  static endGame + #1153, #2816
  static endGame + #1154, #2816
  static endGame + #1155, #2816
  static endGame + #1156, #2816
  static endGame + #1157, #2816
  static endGame + #1158, #2816
  static endGame + #1159, #2816

  ;Linha 29
  static endGame + #1160, #2816
  static endGame + #1161, #2816
  static endGame + #1162, #2816
  static endGame + #1163, #2816
  static endGame + #1164, #2816
  static endGame + #1165, #2816
  static endGame + #1166, #2816
  static endGame + #1167, #2816
  static endGame + #1168, #2816
  static endGame + #1169, #2816
  static endGame + #1170, #2816
  static endGame + #1171, #2816
  static endGame + #1172, #2816
  static endGame + #1173, #2816
  static endGame + #1174, #2816
  static endGame + #1175, #2816
  static endGame + #1176, #2816
  static endGame + #1177, #2816
  static endGame + #1178, #2816
  static endGame + #1179, #2816
  static endGame + #1180, #2816
  static endGame + #1181, #2816
  static endGame + #1182, #2816
  static endGame + #1183, #2816
  static endGame + #1184, #2816
  static endGame + #1185, #2816
  static endGame + #1186, #2816
  static endGame + #1187, #2816
  static endGame + #1188, #2816
  static endGame + #1189, #2816
  static endGame + #1190, #2816
  static endGame + #1191, #2816
  static endGame + #1192, #2816
  static endGame + #1193, #2816
  static endGame + #1194, #2816
  static endGame + #1195, #2816
  static endGame + #1196, #2816
  static endGame + #1197, #2816
  static endGame + #1198, #2816
  static endGame + #1199, #2816

deathscreen : var #1200
  ;Linha 0
  static deathscreen + #0, #2560
  static deathscreen + #1, #2560
  static deathscreen + #2, #2560
  static deathscreen + #3, #2560
  static deathscreen + #4, #2560
  static deathscreen + #5, #2560
  static deathscreen + #6, #2560
  static deathscreen + #7, #2560
  static deathscreen + #8, #2560
  static deathscreen + #9, #2560
  static deathscreen + #10, #2560
  static deathscreen + #11, #2560
  static deathscreen + #12, #2560
  static deathscreen + #13, #2560
  static deathscreen + #14, #2560
  static deathscreen + #15, #2560
  static deathscreen + #16, #2560
  static deathscreen + #17, #2560
  static deathscreen + #18, #2560
  static deathscreen + #19, #2560
  static deathscreen + #20, #2560
  static deathscreen + #21, #3840
  static deathscreen + #22, #3840
  static deathscreen + #23, #3840
  static deathscreen + #24, #3840
  static deathscreen + #25, #3840
  static deathscreen + #26, #3840
  static deathscreen + #27, #3840
  static deathscreen + #28, #3840
  static deathscreen + #29, #3840
  static deathscreen + #30, #3840
  static deathscreen + #31, #3840
  static deathscreen + #32, #2816
  static deathscreen + #33, #2816
  static deathscreen + #34, #2816
  static deathscreen + #35, #2560
  static deathscreen + #36, #2560
  static deathscreen + #37, #2560
  static deathscreen + #38, #2560
  static deathscreen + #39, #2560

  ;Linha 1
  static deathscreen + #40, #2560
  static deathscreen + #41, #2560
  static deathscreen + #42, #2560
  static deathscreen + #43, #2560
  static deathscreen + #44, #2560
  static deathscreen + #45, #2560
  static deathscreen + #46, #2560
  static deathscreen + #47, #2560
  static deathscreen + #48, #2560
  static deathscreen + #49, #2560
  static deathscreen + #50, #2560
  static deathscreen + #51, #2560
  static deathscreen + #52, #2560
  static deathscreen + #53, #2560
  static deathscreen + #54, #2560
  static deathscreen + #55, #2560
  static deathscreen + #56, #2560
  static deathscreen + #57, #2560
  static deathscreen + #58, #2560
  static deathscreen + #59, #2560
  static deathscreen + #60, #2560
  static deathscreen + #61, #3840
  static deathscreen + #62, #3840
  static deathscreen + #63, #3840
  static deathscreen + #64, #3840
  static deathscreen + #65, #2816
  static deathscreen + #66, #2816
  static deathscreen + #67, #2816
  static deathscreen + #68, #2816
  static deathscreen + #69, #2816
  static deathscreen + #70, #2816
  static deathscreen + #71, #2816
  static deathscreen + #72, #2816
  static deathscreen + #73, #2816
  static deathscreen + #74, #2816
  static deathscreen + #75, #2560
  static deathscreen + #76, #2560
  static deathscreen + #77, #2560
  static deathscreen + #78, #2560
  static deathscreen + #79, #2560

  ;Linha 2
  static deathscreen + #80, #2560
  static deathscreen + #81, #2560
  static deathscreen + #82, #2560
  static deathscreen + #83, #2560
  static deathscreen + #84, #2560
  static deathscreen + #85, #2560
  static deathscreen + #86, #2560
  static deathscreen + #87, #2560
  static deathscreen + #88, #2560
  static deathscreen + #89, #2560
  static deathscreen + #90, #2560
  static deathscreen + #91, #2560
  static deathscreen + #92, #2560
  static deathscreen + #93, #2560
  static deathscreen + #94, #2560
  static deathscreen + #95, #2560
  static deathscreen + #96, #2560
  static deathscreen + #97, #2560
  static deathscreen + #98, #2560
  static deathscreen + #99, #2560
  static deathscreen + #100, #2560
  static deathscreen + #101, #2816
  static deathscreen + #102, #2816
  static deathscreen + #103, #2816
  static deathscreen + #104, #2816
  static deathscreen + #105, #2816
  static deathscreen + #106, #2816
  static deathscreen + #107, #2816
  static deathscreen + #108, #2816
  static deathscreen + #109, #2816
  static deathscreen + #110, #2816
  static deathscreen + #111, #2816
  static deathscreen + #112, #2816
  static deathscreen + #113, #2816
  static deathscreen + #114, #2816
  static deathscreen + #115, #2560
  static deathscreen + #116, #2560
  static deathscreen + #117, #2560
  static deathscreen + #118, #2560
  static deathscreen + #119, #2560

  ;Linha 3
  static deathscreen + #120, #2560
  static deathscreen + #121, #2560
  static deathscreen + #122, #2560
  static deathscreen + #123, #2560
  static deathscreen + #124, #2560
  static deathscreen + #125, #2560
  static deathscreen + #126, #2560
  static deathscreen + #127, #2560
  static deathscreen + #128, #2560
  static deathscreen + #129, #2560
  static deathscreen + #130, #2560
  static deathscreen + #131, #2560
  static deathscreen + #132, #2560
  static deathscreen + #133, #2560
  static deathscreen + #134, #2560
  static deathscreen + #135, #2560
  static deathscreen + #136, #2560
  static deathscreen + #137, #2560
  static deathscreen + #138, #2560
  static deathscreen + #139, #2560
  static deathscreen + #140, #2560
  static deathscreen + #141, #2816
  static deathscreen + #142, #2816
  static deathscreen + #143, #2816
  static deathscreen + #144, #2816
  static deathscreen + #145, #2816
  static deathscreen + #146, #2816
  static deathscreen + #147, #2816
  static deathscreen + #148, #2816
  static deathscreen + #149, #2816
  static deathscreen + #150, #3840
  static deathscreen + #151, #3840
  static deathscreen + #152, #3840
  static deathscreen + #153, #3840
  static deathscreen + #154, #3840
  static deathscreen + #155, #2560
  static deathscreen + #156, #2560
  static deathscreen + #157, #2560
  static deathscreen + #158, #2560
  static deathscreen + #159, #2560

  ;Linha 4
  static deathscreen + #160, #2560
  static deathscreen + #161, #2560
  static deathscreen + #162, #2560
  static deathscreen + #163, #2560
  static deathscreen + #164, #2560
  static deathscreen + #165, #2560
  static deathscreen + #166, #2560
  static deathscreen + #167, #2560
  static deathscreen + #168, #2560
  static deathscreen + #169, #2560
  static deathscreen + #170, #2560
  static deathscreen + #171, #2560
  static deathscreen + #172, #2560
  static deathscreen + #173, #2560
  static deathscreen + #174, #2560
  static deathscreen + #175, #2560
  static deathscreen + #176, #2560
  static deathscreen + #177, #2560
  static deathscreen + #178, #2560
  static deathscreen + #179, #2560
  static deathscreen + #180, #2560
  static deathscreen + #181, #2816
  static deathscreen + #182, #2816
  static deathscreen + #183, #2816
  static deathscreen + #184, #2816
  static deathscreen + #185, #2816
  static deathscreen + #186, #3840
  static deathscreen + #187, #3840
  static deathscreen + #188, #3840
  static deathscreen + #189, #3840
  static deathscreen + #190, #3840
  static deathscreen + #191, #3840
  static deathscreen + #192, #3840
  static deathscreen + #193, #3840
  static deathscreen + #194, #3840
  static deathscreen + #195, #2560
  static deathscreen + #196, #2560
  static deathscreen + #197, #2560
  static deathscreen + #198, #2560
  static deathscreen + #199, #2560

  ;Linha 5
  static deathscreen + #200, #2560
  static deathscreen + #201, #2560
  static deathscreen + #202, #2560
  static deathscreen + #203, #2560
  static deathscreen + #204, #2560
  static deathscreen + #205, #2560
  static deathscreen + #206, #2560
  static deathscreen + #207, #2560
  static deathscreen + #208, #2560
  static deathscreen + #209, #2560
  static deathscreen + #210, #2560
  static deathscreen + #211, #2560
  static deathscreen + #212, #2560
  static deathscreen + #213, #2560
  static deathscreen + #214, #1536
  static deathscreen + #215, #1536
  static deathscreen + #216, #1536
  static deathscreen + #217, #2560
  static deathscreen + #218, #2560
  static deathscreen + #219, #2560
  static deathscreen + #220, #2560
  static deathscreen + #221, #3840
  static deathscreen + #222, #3840
  static deathscreen + #223, #3840
  static deathscreen + #224, #3840
  static deathscreen + #225, #3840
  static deathscreen + #226, #3840
  static deathscreen + #227, #3840
  static deathscreen + #228, #3840
  static deathscreen + #229, #3840
  static deathscreen + #230, #3840
  static deathscreen + #231, #3840
  static deathscreen + #232, #3840
  static deathscreen + #233, #3840
  static deathscreen + #234, #3840
  static deathscreen + #235, #2560
  static deathscreen + #236, #2560
  static deathscreen + #237, #2560
  static deathscreen + #238, #2560
  static deathscreen + #239, #2560

  ;Linha 6
  static deathscreen + #240, #2560
  static deathscreen + #241, #2560
  static deathscreen + #242, #2560
  static deathscreen + #243, #2560
  static deathscreen + #244, #2560
  static deathscreen + #245, #2560
  static deathscreen + #246, #2560
  static deathscreen + #247, #2560
  static deathscreen + #248, #2560
  static deathscreen + #249, #2560
  static deathscreen + #250, #2560
  static deathscreen + #251, #2560
  static deathscreen + #252, #1536
  static deathscreen + #253, #768
  static deathscreen + #254, #768
  static deathscreen + #255, #1536
  static deathscreen + #256, #1536
  static deathscreen + #257, #1536
  static deathscreen + #258, #1536
  static deathscreen + #259, #1536
  static deathscreen + #260, #2560
  static deathscreen + #261, #2560
  static deathscreen + #262, #3840
  static deathscreen + #263, #3840
  static deathscreen + #264, #3840
  static deathscreen + #265, #3840
  static deathscreen + #266, #3840
  static deathscreen + #267, #3840
  static deathscreen + #268, #3840
  static deathscreen + #269, #3840
  static deathscreen + #270, #3840
  static deathscreen + #271, #3840
  static deathscreen + #272, #3840
  static deathscreen + #273, #3840
  static deathscreen + #274, #3840
  static deathscreen + #275, #2560
  static deathscreen + #276, #2560
  static deathscreen + #277, #2560
  static deathscreen + #278, #2560
  static deathscreen + #279, #2560

  ;Linha 7
  static deathscreen + #280, #2560
  static deathscreen + #281, #2560
  static deathscreen + #282, #2560
  static deathscreen + #283, #2560
  static deathscreen + #284, #2560
  static deathscreen + #285, #2560
  static deathscreen + #286, #2560
  static deathscreen + #287, #2560
  static deathscreen + #288, #2560
  static deathscreen + #289, #2560
  static deathscreen + #290, #2560
  static deathscreen + #291, #1536
  static deathscreen + #292, #768
  static deathscreen + #293, #1536
  static deathscreen + #294, #1536
  static deathscreen + #295, #768
  static deathscreen + #296, #1536
  static deathscreen + #297, #1536
  static deathscreen + #298, #1536
  static deathscreen + #299, #1536
  static deathscreen + #300, #2560
  static deathscreen + #301, #2560
  static deathscreen + #302, #3840
  static deathscreen + #303, #3840
  static deathscreen + #304, #3840
  static deathscreen + #305, #3840
  static deathscreen + #306, #3840
  static deathscreen + #307, #3840
  static deathscreen + #308, #3840
  static deathscreen + #309, #3840
  static deathscreen + #310, #3840
  static deathscreen + #311, #3840
  static deathscreen + #312, #2816
  static deathscreen + #313, #2816
  static deathscreen + #314, #2816
  static deathscreen + #315, #2560
  static deathscreen + #316, #2560
  static deathscreen + #317, #2560
  static deathscreen + #318, #2560
  static deathscreen + #319, #2560

  ;Linha 8
  static deathscreen + #320, #2560
  static deathscreen + #321, #2560
  static deathscreen + #322, #2560
  static deathscreen + #323, #2560
  static deathscreen + #324, #2560
  static deathscreen + #325, #2560
  static deathscreen + #326, #2560
  static deathscreen + #327, #2560
  static deathscreen + #328, #2560
  static deathscreen + #329, #2560
  static deathscreen + #330, #2560
  static deathscreen + #331, #768
  static deathscreen + #332, #1536
  static deathscreen + #333, #1536
  static deathscreen + #334, #1536
  static deathscreen + #335, #256
  static deathscreen + #336, #2048
  static deathscreen + #337, #1536
  static deathscreen + #338, #1536
  static deathscreen + #339, #1536
  static deathscreen + #340, #1536
  static deathscreen + #341, #2560
  static deathscreen + #342, #2560
  static deathscreen + #343, #3840
  static deathscreen + #344, #3840
  static deathscreen + #345, #3840
  static deathscreen + #346, #3840
  static deathscreen + #347, #2816
  static deathscreen + #348, #2816
  static deathscreen + #349, #2816
  static deathscreen + #350, #2816
  static deathscreen + #351, #2816
  static deathscreen + #352, #2816
  static deathscreen + #353, #2816
  static deathscreen + #354, #2560
  static deathscreen + #355, #2560
  static deathscreen + #356, #2560
  static deathscreen + #357, #2560
  static deathscreen + #358, #2560
  static deathscreen + #359, #2560

  ;Linha 9
  static deathscreen + #360, #2560
  static deathscreen + #361, #2560
  static deathscreen + #362, #2560
  static deathscreen + #363, #2560
  static deathscreen + #364, #2560
  static deathscreen + #365, #2560
  static deathscreen + #366, #2560
  static deathscreen + #367, #2560
  static deathscreen + #368, #2560
  static deathscreen + #369, #2560
  static deathscreen + #370, #2560
  static deathscreen + #371, #768
  static deathscreen + #372, #1536
  static deathscreen + #373, #1536
  static deathscreen + #374, #1536
  static deathscreen + #375, #1536
  static deathscreen + #376, #256
  static deathscreen + #377, #1536
  static deathscreen + #378, #1536
  static deathscreen + #379, #1536
  static deathscreen + #380, #1536
  static deathscreen + #381, #2560
  static deathscreen + #382, #2560
  static deathscreen + #383, #2816
  static deathscreen + #384, #2816
  static deathscreen + #385, #2816
  static deathscreen + #386, #2816
  static deathscreen + #387, #2816
  static deathscreen + #388, #2816
  static deathscreen + #389, #2816
  static deathscreen + #390, #2816
  static deathscreen + #391, #2816
  static deathscreen + #392, #2816
  static deathscreen + #393, #2816
  static deathscreen + #394, #2560
  static deathscreen + #395, #2560
  static deathscreen + #396, #2560
  static deathscreen + #397, #2560
  static deathscreen + #398, #2560
  static deathscreen + #399, #2560

  ;Linha 10
  static deathscreen + #400, #2560
  static deathscreen + #401, #2560
  static deathscreen + #402, #2560
  static deathscreen + #403, #2560
  static deathscreen + #404, #2560
  static deathscreen + #405, #2560
  static deathscreen + #406, #2560
  static deathscreen + #407, #2560
  static deathscreen + #408, #2560
  static deathscreen + #409, #2560
  static deathscreen + #410, #2560
  static deathscreen + #411, #768
  static deathscreen + #412, #2560
  static deathscreen + #413, #1536
  static deathscreen + #414, #1536
  static deathscreen + #415, #1536
  static deathscreen + #416, #1536
  static deathscreen + #417, #1536
  static deathscreen + #418, #1536
  static deathscreen + #419, #1536
  static deathscreen + #420, #1536
  static deathscreen + #421, #2560
  static deathscreen + #422, #2560
  static deathscreen + #423, #2560
  static deathscreen + #424, #2816
  static deathscreen + #425, #2816
  static deathscreen + #426, #2816
  static deathscreen + #427, #2816
  static deathscreen + #428, #2816
  static deathscreen + #429, #2816
  static deathscreen + #430, #2816
  static deathscreen + #431, #2816
  static deathscreen + #432, #2816
  static deathscreen + #433, #2560
  static deathscreen + #434, #2560
  static deathscreen + #435, #2560
  static deathscreen + #436, #2560
  static deathscreen + #437, #2560
  static deathscreen + #438, #2560
  static deathscreen + #439, #2560

  ;Linha 11
  static deathscreen + #440, #2560
  static deathscreen + #441, #2560
  static deathscreen + #442, #2560
  static deathscreen + #443, #2560
  static deathscreen + #444, #2560
  static deathscreen + #445, #2560
  static deathscreen + #446, #2560
  static deathscreen + #447, #2560
  static deathscreen + #448, #2560
  static deathscreen + #449, #2560
  static deathscreen + #450, #2560
  static deathscreen + #451, #768
  static deathscreen + #452, #2560
  static deathscreen + #453, #1536
  static deathscreen + #454, #1536
  static deathscreen + #455, #1536
  static deathscreen + #456, #1536
  static deathscreen + #457, #1536
  static deathscreen + #458, #1536
  static deathscreen + #459, #256
  static deathscreen + #460, #1536
  static deathscreen + #461, #2560
  static deathscreen + #462, #2560
  static deathscreen + #463, #2560
  static deathscreen + #464, #2560
  static deathscreen + #465, #3840
  static deathscreen + #466, #3840
  static deathscreen + #467, #2816
  static deathscreen + #468, #2816
  static deathscreen + #469, #2816
  static deathscreen + #470, #3840
  static deathscreen + #471, #3840
  static deathscreen + #472, #2560
  static deathscreen + #473, #2560
  static deathscreen + #474, #2560
  static deathscreen + #475, #2560
  static deathscreen + #476, #2560
  static deathscreen + #477, #2560
  static deathscreen + #478, #2560
  static deathscreen + #479, #2560

  ;Linha 12
  static deathscreen + #480, #2560
  static deathscreen + #481, #2560
  static deathscreen + #482, #2560
  static deathscreen + #483, #2560
  static deathscreen + #484, #2560
  static deathscreen + #485, #2560
  static deathscreen + #486, #2560
  static deathscreen + #487, #2560
  static deathscreen + #488, #2560
  static deathscreen + #489, #2560
  static deathscreen + #490, #2560
  static deathscreen + #491, #2560
  static deathscreen + #492, #2560
  static deathscreen + #493, #1536
  static deathscreen + #494, #1536
  static deathscreen + #495, #1536
  static deathscreen + #496, #1536
  static deathscreen + #497, #256
  static deathscreen + #498, #1536
  static deathscreen + #499, #1536
  static deathscreen + #500, #2560
  static deathscreen + #501, #2560
  static deathscreen + #502, #2560
  static deathscreen + #503, #2560
  static deathscreen + #504, #2560
  static deathscreen + #505, #3840
  static deathscreen + #506, #3840
  static deathscreen + #507, #2560
  static deathscreen + #508, #2560
  static deathscreen + #509, #2560
  static deathscreen + #510, #3840
  static deathscreen + #511, #3840
  static deathscreen + #512, #2560
  static deathscreen + #513, #2560
  static deathscreen + #514, #2560
  static deathscreen + #515, #2560
  static deathscreen + #516, #2560
  static deathscreen + #517, #2560
  static deathscreen + #518, #2560
  static deathscreen + #519, #2560

  ;Linha 13
  static deathscreen + #520, #2560
  static deathscreen + #521, #2560
  static deathscreen + #522, #2560
  static deathscreen + #523, #2560
  static deathscreen + #524, #2560
  static deathscreen + #525, #2560
  static deathscreen + #526, #2560
  static deathscreen + #527, #2560
  static deathscreen + #528, #2560
  static deathscreen + #529, #2560
  static deathscreen + #530, #2560
  static deathscreen + #531, #2560
  static deathscreen + #532, #2560
  static deathscreen + #533, #2560
  static deathscreen + #534, #1536
  static deathscreen + #535, #1536
  static deathscreen + #536, #1536
  static deathscreen + #537, #1536
  static deathscreen + #538, #2560
  static deathscreen + #539, #2560
  static deathscreen + #540, #2560
  static deathscreen + #541, #2560
  static deathscreen + #542, #2560
  static deathscreen + #543, #2560
  static deathscreen + #544, #2560
  static deathscreen + #545, #3840
  static deathscreen + #546, #3840
  static deathscreen + #547, #2560
  static deathscreen + #548, #2560
  static deathscreen + #549, #2560
  static deathscreen + #550, #3840
  static deathscreen + #551, #3840
  static deathscreen + #552, #2560
  static deathscreen + #553, #2560
  static deathscreen + #554, #2560
  static deathscreen + #555, #2560
  static deathscreen + #556, #2560
  static deathscreen + #557, #2560
  static deathscreen + #558, #2560
  static deathscreen + #559, #2560

  ;Linha 14
  static deathscreen + #560, #2560
  static deathscreen + #561, #2560
  static deathscreen + #562, #2560
  static deathscreen + #563, #2560
  static deathscreen + #564, #2560
  static deathscreen + #565, #2560
  static deathscreen + #566, #2560
  static deathscreen + #567, #2560
  static deathscreen + #568, #2560
  static deathscreen + #569, #2560
  static deathscreen + #570, #2560
  static deathscreen + #571, #2560
  static deathscreen + #572, #2560
  static deathscreen + #573, #2560
  static deathscreen + #574, #1536
  static deathscreen + #575, #1536
  static deathscreen + #576, #2560
  static deathscreen + #577, #2560
  static deathscreen + #578, #2560
  static deathscreen + #579, #2560
  static deathscreen + #580, #2560
  static deathscreen + #581, #2560
  static deathscreen + #582, #2560
  static deathscreen + #583, #2560
  static deathscreen + #584, #2560
  static deathscreen + #585, #3840
  static deathscreen + #586, #3840
  static deathscreen + #587, #2560
  static deathscreen + #588, #2560
  static deathscreen + #589, #2560
  static deathscreen + #590, #3840
  static deathscreen + #591, #3840
  static deathscreen + #592, #2560
  static deathscreen + #593, #2560
  static deathscreen + #594, #2560
  static deathscreen + #595, #2560
  static deathscreen + #596, #2560
  static deathscreen + #597, #2560
  static deathscreen + #598, #2560
  static deathscreen + #599, #2560

  ;Linha 15
  static deathscreen + #600, #2560
  static deathscreen + #601, #2560
  static deathscreen + #602, #2560
  static deathscreen + #603, #2560
  static deathscreen + #604, #2560
  static deathscreen + #605, #2560
  static deathscreen + #606, #2560
  static deathscreen + #607, #2560
  static deathscreen + #608, #2560
  static deathscreen + #609, #2560
  static deathscreen + #610, #2560
  static deathscreen + #611, #2560
  static deathscreen + #612, #2560
  static deathscreen + #613, #2560
  static deathscreen + #614, #2560
  static deathscreen + #615, #2560
  static deathscreen + #616, #2560
  static deathscreen + #617, #2560
  static deathscreen + #618, #2560
  static deathscreen + #619, #2560
  static deathscreen + #620, #2560
  static deathscreen + #621, #2560
  static deathscreen + #622, #2560
  static deathscreen + #623, #2560
  static deathscreen + #624, #2560
  static deathscreen + #625, #3840
  static deathscreen + #626, #3840
  static deathscreen + #627, #2560
  static deathscreen + #628, #2560
  static deathscreen + #629, #2560
  static deathscreen + #630, #3840
  static deathscreen + #631, #3840
  static deathscreen + #632, #2560
  static deathscreen + #633, #2560
  static deathscreen + #634, #2560
  static deathscreen + #635, #2560
  static deathscreen + #636, #2560
  static deathscreen + #637, #2560
  static deathscreen + #638, #2560
  static deathscreen + #639, #2560

  ;Linha 16
  static deathscreen + #640, #2560
  static deathscreen + #641, #2560
  static deathscreen + #642, #2560
  static deathscreen + #643, #2560
  static deathscreen + #644, #2560
  static deathscreen + #645, #2560
  static deathscreen + #646, #2560
  static deathscreen + #647, #2560
  static deathscreen + #648, #2560
  static deathscreen + #649, #2560
  static deathscreen + #650, #2560
  static deathscreen + #651, #2560
  static deathscreen + #652, #2560
  static deathscreen + #653, #2560
  static deathscreen + #654, #2560
  static deathscreen + #655, #2560
  static deathscreen + #656, #2560
  static deathscreen + #657, #2560
  static deathscreen + #658, #2560
  static deathscreen + #659, #2560
  static deathscreen + #660, #2560
  static deathscreen + #661, #2560
  static deathscreen + #662, #2560
  static deathscreen + #663, #2560
  static deathscreen + #664, #2560
  static deathscreen + #665, #3840
  static deathscreen + #666, #3840
  static deathscreen + #667, #2560
  static deathscreen + #668, #2560
  static deathscreen + #669, #2560
  static deathscreen + #670, #3840
  static deathscreen + #671, #3840
  static deathscreen + #672, #2560
  static deathscreen + #673, #2560
  static deathscreen + #674, #2560
  static deathscreen + #675, #2560
  static deathscreen + #676, #2560
  static deathscreen + #677, #2560
  static deathscreen + #678, #2560
  static deathscreen + #679, #2560

  ;Linha 17
  static deathscreen + #680, #2560
  static deathscreen + #681, #2132
  static deathscreen + #682, #2152
  static deathscreen + #683, #2149
  static deathscreen + #684, #3840
  static deathscreen + #685, #2146
  static deathscreen + #686, #2156
  static deathscreen + #687, #2159
  static deathscreen + #688, #2159
  static deathscreen + #689, #2157
  static deathscreen + #690, #3840
  static deathscreen + #691, #2152
  static deathscreen + #692, #2145
  static deathscreen + #693, #2163
  static deathscreen + #694, #3840
  static deathscreen + #695, #2167
  static deathscreen + #696, #2153
  static deathscreen + #697, #2164
  static deathscreen + #698, #2152
  static deathscreen + #699, #2149
  static deathscreen + #700, #2162
  static deathscreen + #701, #2149
  static deathscreen + #702, #2148
  static deathscreen + #703, #2092
  static deathscreen + #704, #2560
  static deathscreen + #705, #3840
  static deathscreen + #706, #3840
  static deathscreen + #707, #2560
  static deathscreen + #708, #2560
  static deathscreen + #709, #2560
  static deathscreen + #710, #3840
  static deathscreen + #711, #3840
  static deathscreen + #712, #2560
  static deathscreen + #713, #2560
  static deathscreen + #714, #2560
  static deathscreen + #715, #2560
  static deathscreen + #716, #2560
  static deathscreen + #717, #2560
  static deathscreen + #718, #2560
  static deathscreen + #719, #2560

  ;Linha 18
  static deathscreen + #720, #2560
  static deathscreen + #721, #2160
  static deathscreen + #722, #2149
  static deathscreen + #723, #2164
  static deathscreen + #724, #2152
  static deathscreen + #725, #2145
  static deathscreen + #726, #2156
  static deathscreen + #727, #2163
  static deathscreen + #728, #3840
  static deathscreen + #729, #2150
  static deathscreen + #730, #2145
  static deathscreen + #731, #2156
  static deathscreen + #732, #2156
  static deathscreen + #733, #2092
  static deathscreen + #734, #2560
  static deathscreen + #735, #2560
  static deathscreen + #736, #2560
  static deathscreen + #737, #2560
  static deathscreen + #738, #2560
  static deathscreen + #739, #2560
  static deathscreen + #740, #2560
  static deathscreen + #741, #2560
  static deathscreen + #742, #2560
  static deathscreen + #743, #2560
  static deathscreen + #744, #2560
  static deathscreen + #745, #3840
  static deathscreen + #746, #3840
  static deathscreen + #747, #2560
  static deathscreen + #748, #2560
  static deathscreen + #749, #2560
  static deathscreen + #750, #3840
  static deathscreen + #751, #3840
  static deathscreen + #752, #2560
  static deathscreen + #753, #2560
  static deathscreen + #754, #2560
  static deathscreen + #755, #2560
  static deathscreen + #756, #2560
  static deathscreen + #757, #2560
  static deathscreen + #758, #2560
  static deathscreen + #759, #2560

  ;Linha 19
  static deathscreen + #760, #2560
  static deathscreen + #761, #2560
  static deathscreen + #762, #2560
  static deathscreen + #763, #2560
  static deathscreen + #764, #2560
  static deathscreen + #765, #2560
  static deathscreen + #766, #2560
  static deathscreen + #767, #2560
  static deathscreen + #768, #2560
  static deathscreen + #769, #2560
  static deathscreen + #770, #2560
  static deathscreen + #771, #2560
  static deathscreen + #772, #2560
  static deathscreen + #773, #2560
  static deathscreen + #774, #2560
  static deathscreen + #775, #2560
  static deathscreen + #776, #2560
  static deathscreen + #777, #2560
  static deathscreen + #778, #2560
  static deathscreen + #779, #2560
  static deathscreen + #780, #2560
  static deathscreen + #781, #2560
  static deathscreen + #782, #2560
  static deathscreen + #783, #2560
  static deathscreen + #784, #2560
  static deathscreen + #785, #3840
  static deathscreen + #786, #3840
  static deathscreen + #787, #2560
  static deathscreen + #788, #2560
  static deathscreen + #789, #2560
  static deathscreen + #790, #3840
  static deathscreen + #791, #3840
  static deathscreen + #792, #2560
  static deathscreen + #793, #2560
  static deathscreen + #794, #2560
  static deathscreen + #795, #2560
  static deathscreen + #796, #2560
  static deathscreen + #797, #2560
  static deathscreen + #798, #2560
  static deathscreen + #799, #2560

  ;Linha 20
  static deathscreen + #800, #2560
  static deathscreen + #801, #2113
  static deathscreen + #802, #3840
  static deathscreen + #803, #2150
  static deathscreen + #804, #2156
  static deathscreen + #805, #2149
  static deathscreen + #806, #2149
  static deathscreen + #807, #2164
  static deathscreen + #808, #2153
  static deathscreen + #809, #2158
  static deathscreen + #810, #2151
  static deathscreen + #811, #3840
  static deathscreen + #812, #2156
  static deathscreen + #813, #2153
  static deathscreen + #814, #2150
  static deathscreen + #815, #2149
  static deathscreen + #816, #2092
  static deathscreen + #817, #2560
  static deathscreen + #818, #2560
  static deathscreen + #819, #2560
  static deathscreen + #820, #2560
  static deathscreen + #821, #2560
  static deathscreen + #822, #2560
  static deathscreen + #823, #2560
  static deathscreen + #824, #2560
  static deathscreen + #825, #3840
  static deathscreen + #826, #3840
  static deathscreen + #827, #2560
  static deathscreen + #828, #2560
  static deathscreen + #829, #2048
  static deathscreen + #830, #2560
  static deathscreen + #831, #2560
  static deathscreen + #832, #2560
  static deathscreen + #833, #2560
  static deathscreen + #834, #2560
  static deathscreen + #835, #2560
  static deathscreen + #836, #2560
  static deathscreen + #837, #2560
  static deathscreen + #838, #2560
  static deathscreen + #839, #2560

  ;Linha 21
  static deathscreen + #840, #2560
  static deathscreen + #841, #2158
  static deathscreen + #842, #2159
  static deathscreen + #843, #2167
  static deathscreen + #844, #3840
  static deathscreen + #845, #2156
  static deathscreen + #846, #2159
  static deathscreen + #847, #2163
  static deathscreen + #848, #2164
  static deathscreen + #849, #3840
  static deathscreen + #850, #2164
  static deathscreen + #851, #2159
  static deathscreen + #852, #3840
  static deathscreen + #853, #2145
  static deathscreen + #854, #2156
  static deathscreen + #855, #2156
  static deathscreen + #856, #2094
  static deathscreen + #857, #2560
  static deathscreen + #858, #2560
  static deathscreen + #859, #2560
  static deathscreen + #860, #2560
  static deathscreen + #861, #2560
  static deathscreen + #862, #2560
  static deathscreen + #863, #2560
  static deathscreen + #864, #2560
  static deathscreen + #865, #3840
  static deathscreen + #866, #3840
  static deathscreen + #867, #2560
  static deathscreen + #868, #2560
  static deathscreen + #869, #2048
  static deathscreen + #870, #2560
  static deathscreen + #871, #2560
  static deathscreen + #872, #2560
  static deathscreen + #873, #2560
  static deathscreen + #874, #2560
  static deathscreen + #875, #2560
  static deathscreen + #876, #2560
  static deathscreen + #877, #2560
  static deathscreen + #878, #2560
  static deathscreen + #879, #2560

  ;Linha 22
  static deathscreen + #880, #2560
  static deathscreen + #881, #2560
  static deathscreen + #882, #2560
  static deathscreen + #883, #2560
  static deathscreen + #884, #2560
  static deathscreen + #885, #2560
  static deathscreen + #886, #2560
  static deathscreen + #887, #2560
  static deathscreen + #888, #2560
  static deathscreen + #889, #2560
  static deathscreen + #890, #2560
  static deathscreen + #891, #2560
  static deathscreen + #892, #2560
  static deathscreen + #893, #2560
  static deathscreen + #894, #2560
  static deathscreen + #895, #2560
  static deathscreen + #896, #2560
  static deathscreen + #897, #2560
  static deathscreen + #898, #2560
  static deathscreen + #899, #2560
  static deathscreen + #900, #2560
  static deathscreen + #901, #2560
  static deathscreen + #902, #2560
  static deathscreen + #903, #2560
  static deathscreen + #904, #2560
  static deathscreen + #905, #3840
  static deathscreen + #906, #3840
  static deathscreen + #907, #2560
  static deathscreen + #908, #2048
  static deathscreen + #909, #2560
  static deathscreen + #910, #2560
  static deathscreen + #911, #2560
  static deathscreen + #912, #2560
  static deathscreen + #913, #2560
  static deathscreen + #914, #2560
  static deathscreen + #915, #2560
  static deathscreen + #916, #2560
  static deathscreen + #917, #2560
  static deathscreen + #918, #2560
  static deathscreen + #919, #2560

  ;Linha 23
  static deathscreen + #920, #2560
  static deathscreen + #921, #2132
  static deathscreen + #922, #2152
  static deathscreen + #923, #2149
  static deathscreen + #924, #3840
  static deathscreen + #925, #2163
  static deathscreen + #926, #2164
  static deathscreen + #927, #2153
  static deathscreen + #928, #2158
  static deathscreen + #929, #2151
  static deathscreen + #930, #3840
  static deathscreen + #931, #2159
  static deathscreen + #932, #2150
  static deathscreen + #933, #3840
  static deathscreen + #934, #2150
  static deathscreen + #935, #2145
  static deathscreen + #936, #2164
  static deathscreen + #937, #2149
  static deathscreen + #938, #2092
  static deathscreen + #939, #2560
  static deathscreen + #940, #2560
  static deathscreen + #941, #2560
  static deathscreen + #942, #2560
  static deathscreen + #943, #2560
  static deathscreen + #944, #2560
  static deathscreen + #945, #3840
  static deathscreen + #946, #3840
  static deathscreen + #947, #2560
  static deathscreen + #948, #2560
  static deathscreen + #949, #2560
  static deathscreen + #950, #2560
  static deathscreen + #951, #2560
  static deathscreen + #952, #2560
  static deathscreen + #953, #2560
  static deathscreen + #954, #2560
  static deathscreen + #955, #2560
  static deathscreen + #956, #2560
  static deathscreen + #957, #2560
  static deathscreen + #958, #2560
  static deathscreen + #959, #2560

  ;Linha 24
  static deathscreen + #960, #2560
  static deathscreen + #961, #2145
  static deathscreen + #962, #3840
  static deathscreen + #963, #2147
  static deathscreen + #964, #2162
  static deathscreen + #965, #2165
  static deathscreen + #966, #2149
  static deathscreen + #967, #2156
  static deathscreen + #968, #3840
  static deathscreen + #969, #2148
  static deathscreen + #970, #2149
  static deathscreen + #971, #2147
  static deathscreen + #972, #2162
  static deathscreen + #973, #2149
  static deathscreen + #974, #2149
  static deathscreen + #975, #2092
  static deathscreen + #976, #2560
  static deathscreen + #977, #2560
  static deathscreen + #978, #2560
  static deathscreen + #979, #2560
  static deathscreen + #980, #2560
  static deathscreen + #981, #2560
  static deathscreen + #982, #2560
  static deathscreen + #983, #2560
  static deathscreen + #984, #2560
  static deathscreen + #985, #2560
  static deathscreen + #986, #2560
  static deathscreen + #987, #2560
  static deathscreen + #988, #2560
  static deathscreen + #989, #2560
  static deathscreen + #990, #2560
  static deathscreen + #991, #2560
  static deathscreen + #992, #2560
  static deathscreen + #993, #2560
  static deathscreen + #994, #2560
  static deathscreen + #995, #2560
  static deathscreen + #996, #2560
  static deathscreen + #997, #2560
  static deathscreen + #998, #2560
  static deathscreen + #999, #2560

  ;Linha 25
  static deathscreen + #1000, #2560
  static deathscreen + #1001, #2560
  static deathscreen + #1002, #2560
  static deathscreen + #1003, #2560
  static deathscreen + #1004, #2560
  static deathscreen + #1005, #2560
  static deathscreen + #1006, #2560
  static deathscreen + #1007, #2560
  static deathscreen + #1008, #2560
  static deathscreen + #1009, #2560
  static deathscreen + #1010, #2560
  static deathscreen + #1011, #2560
  static deathscreen + #1012, #2560
  static deathscreen + #1013, #2560
  static deathscreen + #1014, #2560
  static deathscreen + #1015, #2560
  static deathscreen + #1016, #2560
  static deathscreen + #1017, #2560
  static deathscreen + #1018, #2560
  static deathscreen + #1019, #2560
  static deathscreen + #1020, #2560
  static deathscreen + #1021, #2560
  static deathscreen + #1022, #2560
  static deathscreen + #1023, #2560
  static deathscreen + #1024, #2560
  static deathscreen + #1025, #2560
  static deathscreen + #1026, #2560
  static deathscreen + #1027, #2560
  static deathscreen + #1028, #2560
  static deathscreen + #1029, #2560
  static deathscreen + #1030, #2560
  static deathscreen + #1031, #2560
  static deathscreen + #1032, #2560
  static deathscreen + #1033, #2560
  static deathscreen + #1034, #2560
  static deathscreen + #1035, #2560
  static deathscreen + #1036, #2560
  static deathscreen + #1037, #2560
  static deathscreen + #1038, #2560
  static deathscreen + #1039, #2560

  ;Linha 26
  static deathscreen + #1040, #2560
  static deathscreen + #1041, #2132
  static deathscreen + #1042, #2152
  static deathscreen + #1043, #2149
  static deathscreen + #1044, #3840
  static deathscreen + #1045, #2151
  static deathscreen + #1046, #2145
  static deathscreen + #1047, #2162
  static deathscreen + #1048, #2148
  static deathscreen + #1049, #2149
  static deathscreen + #1050, #2158
  static deathscreen + #1051, #3840
  static deathscreen + #1052, #2150
  static deathscreen + #1053, #2145
  static deathscreen + #1054, #2148
  static deathscreen + #1055, #2149
  static deathscreen + #1056, #2163
  static deathscreen + #1057, #3840
  static deathscreen + #1058, #2164
  static deathscreen + #1059, #2159
  static deathscreen + #1060, #3840
  static deathscreen + #1061, #2157
  static deathscreen + #1062, #2149
  static deathscreen + #1063, #2157
  static deathscreen + #1064, #2159
  static deathscreen + #1065, #2162
  static deathscreen + #1066, #2169
  static deathscreen + #1067, #2094
  static deathscreen + #1068, #2094
  static deathscreen + #1069, #2094
  static deathscreen + #1070, #2560
  static deathscreen + #1071, #2560
  static deathscreen + #1072, #2560
  static deathscreen + #1073, #2560
  static deathscreen + #1074, #2560
  static deathscreen + #1075, #2560
  static deathscreen + #1076, #2560
  static deathscreen + #1077, #2560
  static deathscreen + #1078, #2560
  static deathscreen + #1079, #2560

  ;Linha 27
  static deathscreen + #1080, #2560
  static deathscreen + #1081, #2560
  static deathscreen + #1082, #2560
  static deathscreen + #1083, #2560
  static deathscreen + #1084, #2560
  static deathscreen + #1085, #2560
  static deathscreen + #1086, #2560
  static deathscreen + #1087, #2560
  static deathscreen + #1088, #2560
  static deathscreen + #1089, #2560
  static deathscreen + #1090, #2560
  static deathscreen + #1091, #2560
  static deathscreen + #1092, #2560
  static deathscreen + #1093, #2560
  static deathscreen + #1094, #2560
  static deathscreen + #1095, #2560
  static deathscreen + #1096, #2560
  static deathscreen + #1097, #2560
  static deathscreen + #1098, #2560
  static deathscreen + #1099, #2560
  static deathscreen + #1100, #2560
  static deathscreen + #1101, #2560
  static deathscreen + #1102, #2560
  static deathscreen + #1103, #2560
  static deathscreen + #1104, #2560
  static deathscreen + #1105, #2560
  static deathscreen + #1106, #2560
  static deathscreen + #1107, #2560
  static deathscreen + #1108, #2560
  static deathscreen + #1109, #2560
  static deathscreen + #1110, #2560
  static deathscreen + #1111, #2560
  static deathscreen + #1112, #2560
  static deathscreen + #1113, #2560
  static deathscreen + #1114, #2560
  static deathscreen + #1115, #2560
  static deathscreen + #1116, #2560
  static deathscreen + #1117, #2560
  static deathscreen + #1118, #2560
  static deathscreen + #1119, #2560

  ;Linha 28
  static deathscreen + #1120, #2560
  static deathscreen + #1121, #2560
  static deathscreen + #1122, #2560
  static deathscreen + #1123, #2560
  static deathscreen + #1124, #2560
  static deathscreen + #1125, #2560
  static deathscreen + #1126, #2560
  static deathscreen + #1127, #2560
  static deathscreen + #1128, #2560
  static deathscreen + #1129, #2560
  static deathscreen + #1130, #2560
  static deathscreen + #1131, #2560
  static deathscreen + #1132, #2560
  static deathscreen + #1133, #2560
  static deathscreen + #1134, #2560
  static deathscreen + #1135, #2560
  static deathscreen + #1136, #2560
  static deathscreen + #1137, #2560
  static deathscreen + #1138, #2560
  static deathscreen + #1139, #2560
  static deathscreen + #1140, #2560
  static deathscreen + #1141, #2560
  static deathscreen + #1142, #2560
  static deathscreen + #1143, #2560
  static deathscreen + #1144, #2560
  static deathscreen + #1145, #2560
  static deathscreen + #1146, #2560
  static deathscreen + #1147, #2560
  static deathscreen + #1148, #2560
  static deathscreen + #1149, #2560
  static deathscreen + #1150, #2560
  static deathscreen + #1151, #2560
  static deathscreen + #1152, #2560
  static deathscreen + #1153, #2560
  static deathscreen + #1154, #2560
  static deathscreen + #1155, #2560
  static deathscreen + #1156, #2560
  static deathscreen + #1157, #2560
  static deathscreen + #1158, #2560
  static deathscreen + #1159, #2560

  ;Linha 29
  static deathscreen + #1160, #2560
  static deathscreen + #1161, #2560
  static deathscreen + #1162, #2560
  static deathscreen + #1163, #2560
  static deathscreen + #1164, #2560
  static deathscreen + #1165, #2560
  static deathscreen + #1166, #2560
  static deathscreen + #1167, #2560
  static deathscreen + #1168, #2560
  static deathscreen + #1169, #2560
  static deathscreen + #1170, #2560
  static deathscreen + #1171, #2560
  static deathscreen + #1172, #2560
  static deathscreen + #1173, #2560
  static deathscreen + #1174, #2560
  static deathscreen + #1175, #2560
  static deathscreen + #1176, #2560
  static deathscreen + #1177, #2560
  static deathscreen + #1178, #2560
  static deathscreen + #1179, #2560
  static deathscreen + #1180, #2560
  static deathscreen + #1181, #2560
  static deathscreen + #1182, #2560
  static deathscreen + #1183, #2560
  static deathscreen + #1184, #2560
  static deathscreen + #1185, #2560
  static deathscreen + #1186, #2560
  static deathscreen + #1187, #2560
  static deathscreen + #1188, #2560
  static deathscreen + #1189, #2560
  static deathscreen + #1190, #2560
  static deathscreen + #1191, #2560
  static deathscreen + #1192, #2560
  static deathscreen + #1193, #2560
  static deathscreen + #1194, #2560
  static deathscreen + #1195, #2560
  static deathscreen + #1196, #2560
  static deathscreen + #1197, #2560
  static deathscreen + #1198, #2560
  static deathscreen + #1199, #2560

instructionScreen : var #1200
  ;Linha 0
  static instructionScreen + #0, #2560
  static instructionScreen + #1, #2560
  static instructionScreen + #2, #2560
  static instructionScreen + #3, #2560
  static instructionScreen + #4, #2560
  static instructionScreen + #5, #2560
  static instructionScreen + #6, #2560
  static instructionScreen + #7, #2560
  static instructionScreen + #8, #2560
  static instructionScreen + #9, #2560
  static instructionScreen + #10, #2560
  static instructionScreen + #11, #2560
  static instructionScreen + #12, #2560
  static instructionScreen + #13, #2560
  static instructionScreen + #14, #2560
  static instructionScreen + #15, #2560
  static instructionScreen + #16, #2560
  static instructionScreen + #17, #2560
  static instructionScreen + #18, #2560
  static instructionScreen + #19, #2560
  static instructionScreen + #20, #2560
  static instructionScreen + #21, #2560
  static instructionScreen + #22, #2560
  static instructionScreen + #23, #2560
  static instructionScreen + #24, #2560
  static instructionScreen + #25, #2560
  static instructionScreen + #26, #2560
  static instructionScreen + #27, #2560
  static instructionScreen + #28, #2560
  static instructionScreen + #29, #2560
  static instructionScreen + #30, #2560
  static instructionScreen + #31, #2560
  static instructionScreen + #32, #2560
  static instructionScreen + #33, #2560
  static instructionScreen + #34, #2560
  static instructionScreen + #35, #2560
  static instructionScreen + #36, #2560
  static instructionScreen + #37, #2560
  static instructionScreen + #38, #2560
  static instructionScreen + #39, #2560

  ;Linha 1
  static instructionScreen + #40, #2560
  static instructionScreen + #41, #2560
  static instructionScreen + #42, #2560
  static instructionScreen + #43, #2560
  static instructionScreen + #44, #2560
  static instructionScreen + #45, #2560
  static instructionScreen + #46, #2560
  static instructionScreen + #47, #2560
  static instructionScreen + #48, #2560
  static instructionScreen + #49, #2560
  static instructionScreen + #50, #2560
  static instructionScreen + #51, #2560
  static instructionScreen + #52, #2560
  static instructionScreen + #53, #2560
  static instructionScreen + #54, #2560
  static instructionScreen + #55, #2560
  static instructionScreen + #56, #2560
  static instructionScreen + #57, #2560
  static instructionScreen + #58, #2560
  static instructionScreen + #59, #2560
  static instructionScreen + #60, #2560
  static instructionScreen + #61, #2560
  static instructionScreen + #62, #2560
  static instructionScreen + #63, #2560
  static instructionScreen + #64, #2560
  static instructionScreen + #65, #2560
  static instructionScreen + #66, #2560
  static instructionScreen + #67, #2560
  static instructionScreen + #68, #2560
  static instructionScreen + #69, #2560
  static instructionScreen + #70, #2560
  static instructionScreen + #71, #2560
  static instructionScreen + #72, #2560
  static instructionScreen + #73, #2560
  static instructionScreen + #74, #2560
  static instructionScreen + #75, #2560
  static instructionScreen + #76, #2560
  static instructionScreen + #77, #2560
  static instructionScreen + #78, #2560
  static instructionScreen + #79, #2560

  ;Linha 2
  static instructionScreen + #80, #2560
  static instructionScreen + #81, #2560
  static instructionScreen + #82, #2560
  static instructionScreen + #83, #2560
  static instructionScreen + #84, #2560
  static instructionScreen + #85, #2560
  static instructionScreen + #86, #2560
  static instructionScreen + #87, #2560
  static instructionScreen + #88, #2560
  static instructionScreen + #89, #2560
  static instructionScreen + #90, #2560
  static instructionScreen + #91, #2560
  static instructionScreen + #92, #2560
  static instructionScreen + #93, #2560
  static instructionScreen + #94, #2560
  static instructionScreen + #95, #2560
  static instructionScreen + #96, #2560
  static instructionScreen + #97, #2560
  static instructionScreen + #98, #2560
  static instructionScreen + #99, #2560
  static instructionScreen + #100, #2560
  static instructionScreen + #101, #2560
  static instructionScreen + #102, #2560
  static instructionScreen + #103, #2560
  static instructionScreen + #104, #2560
  static instructionScreen + #105, #2560
  static instructionScreen + #106, #2560
  static instructionScreen + #107, #2560
  static instructionScreen + #108, #2560
  static instructionScreen + #109, #2560
  static instructionScreen + #110, #2560
  static instructionScreen + #111, #2560
  static instructionScreen + #112, #2560
  static instructionScreen + #113, #2560
  static instructionScreen + #114, #2560
  static instructionScreen + #115, #2560
  static instructionScreen + #116, #2560
  static instructionScreen + #117, #2560
  static instructionScreen + #118, #2560
  static instructionScreen + #119, #2560

  ;Linha 3
  static instructionScreen + #120, #2560
  static instructionScreen + #121, #2560
  static instructionScreen + #122, #2560
  static instructionScreen + #123, #2128
  static instructionScreen + #124, #2162
  static instructionScreen + #125, #2149
  static instructionScreen + #126, #2163
  static instructionScreen + #127, #2163
  static instructionScreen + #128, #2560
  static instructionScreen + #129, #2560
  static instructionScreen + #130, #2560
  static instructionScreen + #131, #2087
  static instructionScreen + #132, #2167
  static instructionScreen + #133, #2087
  static instructionScreen + #134, #2560
  static instructionScreen + #135, #2087
  static instructionScreen + #136, #2145
  static instructionScreen + #137, #2087
  static instructionScreen + #138, #2560
  static instructionScreen + #139, #2305
  static instructionScreen + #140, #2306
  static instructionScreen + #141, #2560
  static instructionScreen + #142, #2560
  static instructionScreen + #143, #2560
  static instructionScreen + #144, #2560
  static instructionScreen + #145, #2560
  static instructionScreen + #146, #2560
  static instructionScreen + #147, #2560
  static instructionScreen + #148, #2560
  static instructionScreen + #149, #2560
  static instructionScreen + #150, #2560
  static instructionScreen + #151, #2560
  static instructionScreen + #152, #2560
  static instructionScreen + #153, #2560
  static instructionScreen + #154, #2560
  static instructionScreen + #155, #2560
  static instructionScreen + #156, #2560
  static instructionScreen + #157, #2560
  static instructionScreen + #158, #2560
  static instructionScreen + #159, #2560

  ;Linha 4
  static instructionScreen + #160, #2560
  static instructionScreen + #161, #2560
  static instructionScreen + #162, #2560
  static instructionScreen + #163, #2164
  static instructionScreen + #164, #2159
  static instructionScreen + #165, #2560
  static instructionScreen + #166, #2157
  static instructionScreen + #167, #2159
  static instructionScreen + #168, #2166
  static instructionScreen + #169, #2149
  static instructionScreen + #170, #2560
  static instructionScreen + #171, #2087
  static instructionScreen + #172, #2163
  static instructionScreen + #173, #2087
  static instructionScreen + #174, #2560
  static instructionScreen + #175, #2087
  static instructionScreen + #176, #2148
  static instructionScreen + #177, #2087
  static instructionScreen + #178, #2560
  static instructionScreen + #179, #772
  static instructionScreen + #180, #771
  static instructionScreen + #181, #2560
  static instructionScreen + #182, #2560
  static instructionScreen + #183, #2560
  static instructionScreen + #184, #2560
  static instructionScreen + #185, #2560
  static instructionScreen + #186, #2560
  static instructionScreen + #187, #2560
  static instructionScreen + #188, #2560
  static instructionScreen + #189, #2560
  static instructionScreen + #190, #2560
  static instructionScreen + #191, #2560
  static instructionScreen + #192, #2560
  static instructionScreen + #193, #2560
  static instructionScreen + #194, #2560
  static instructionScreen + #195, #2560
  static instructionScreen + #196, #2560
  static instructionScreen + #197, #2560
  static instructionScreen + #198, #2560
  static instructionScreen + #199, #2560

  ;Linha 5
  static instructionScreen + #200, #2560
  static instructionScreen + #201, #2560
  static instructionScreen + #202, #2560
  static instructionScreen + #203, #2560
  static instructionScreen + #204, #2560
  static instructionScreen + #205, #2560
  static instructionScreen + #206, #2560
  static instructionScreen + #207, #2560
  static instructionScreen + #208, #2560
  static instructionScreen + #209, #2560
  static instructionScreen + #210, #2560
  static instructionScreen + #211, #2560
  static instructionScreen + #212, #2560
  static instructionScreen + #213, #2560
  static instructionScreen + #214, #2560
  static instructionScreen + #215, #2560
  static instructionScreen + #216, #2560
  static instructionScreen + #217, #2560
  static instructionScreen + #218, #2560
  static instructionScreen + #219, #2560
  static instructionScreen + #220, #2560
  static instructionScreen + #221, #2560
  static instructionScreen + #222, #2560
  static instructionScreen + #223, #2560
  static instructionScreen + #224, #2560
  static instructionScreen + #225, #2560
  static instructionScreen + #226, #2560
  static instructionScreen + #227, #2560
  static instructionScreen + #228, #2560
  static instructionScreen + #229, #2560
  static instructionScreen + #230, #2560
  static instructionScreen + #231, #2560
  static instructionScreen + #232, #2560
  static instructionScreen + #233, #2560
  static instructionScreen + #234, #2560
  static instructionScreen + #235, #2560
  static instructionScreen + #236, #2560
  static instructionScreen + #237, #2560
  static instructionScreen + #238, #2560
  static instructionScreen + #239, #2560

  ;Linha 6
  static instructionScreen + #240, #2560
  static instructionScreen + #241, #2560
  static instructionScreen + #242, #2560
  static instructionScreen + #243, #2560
  static instructionScreen + #244, #2560
  static instructionScreen + #245, #2560
  static instructionScreen + #246, #2560
  static instructionScreen + #247, #2560
  static instructionScreen + #248, #2560
  static instructionScreen + #249, #2560
  static instructionScreen + #250, #2560
  static instructionScreen + #251, #2560
  static instructionScreen + #252, #2560
  static instructionScreen + #253, #2560
  static instructionScreen + #254, #2560
  static instructionScreen + #255, #2560
  static instructionScreen + #256, #2560
  static instructionScreen + #257, #2560
  static instructionScreen + #258, #2560
  static instructionScreen + #259, #2560
  static instructionScreen + #260, #2560
  static instructionScreen + #261, #2560
  static instructionScreen + #262, #2560
  static instructionScreen + #263, #2560
  static instructionScreen + #264, #2560
  static instructionScreen + #265, #2560
  static instructionScreen + #266, #2560
  static instructionScreen + #267, #2560
  static instructionScreen + #268, #2560
  static instructionScreen + #269, #2560
  static instructionScreen + #270, #2560
  static instructionScreen + #271, #2560
  static instructionScreen + #272, #2560
  static instructionScreen + #273, #2560
  static instructionScreen + #274, #2560
  static instructionScreen + #275, #2560
  static instructionScreen + #276, #2560
  static instructionScreen + #277, #2560
  static instructionScreen + #278, #2560
  static instructionScreen + #279, #2560

  ;Linha 7
  static instructionScreen + #280, #2560
  static instructionScreen + #281, #2560
  static instructionScreen + #282, #2560
  static instructionScreen + #283, #2137
  static instructionScreen + #284, #2159
  static instructionScreen + #285, #2165
  static instructionScreen + #286, #2560
  static instructionScreen + #287, #2145
  static instructionScreen + #288, #2162
  static instructionScreen + #289, #2149
  static instructionScreen + #290, #2560
  static instructionScreen + #291, #2145
  static instructionScreen + #292, #2560
  static instructionScreen + #293, #2147
  static instructionScreen + #294, #2145
  static instructionScreen + #295, #2158
  static instructionScreen + #296, #2153
  static instructionScreen + #297, #2166
  static instructionScreen + #298, #2159
  static instructionScreen + #299, #2162
  static instructionScreen + #300, #2149
  static instructionScreen + #301, #2560
  static instructionScreen + #302, #2150
  static instructionScreen + #303, #2156
  static instructionScreen + #304, #2159
  static instructionScreen + #305, #2167
  static instructionScreen + #306, #2149
  static instructionScreen + #307, #2162
  static instructionScreen + #308, #2560
  static instructionScreen + #309, #2560
  static instructionScreen + #310, #2560
  static instructionScreen + #311, #2560
  static instructionScreen + #312, #2560
  static instructionScreen + #313, #2560
  static instructionScreen + #314, #2560
  static instructionScreen + #315, #2560
  static instructionScreen + #316, #2560
  static instructionScreen + #317, #2560
  static instructionScreen + #318, #2560
  static instructionScreen + #319, #2560

  ;Linha 8
  static instructionScreen + #320, #2560
  static instructionScreen + #321, #2560
  static instructionScreen + #322, #2560
  static instructionScreen + #323, #2560
  static instructionScreen + #324, #2560
  static instructionScreen + #325, #2560
  static instructionScreen + #326, #2560
  static instructionScreen + #327, #2560
  static instructionScreen + #328, #2560
  static instructionScreen + #329, #2560
  static instructionScreen + #330, #2560
  static instructionScreen + #331, #2560
  static instructionScreen + #332, #2560
  static instructionScreen + #333, #2560
  static instructionScreen + #334, #2560
  static instructionScreen + #335, #2560
  static instructionScreen + #336, #2560
  static instructionScreen + #337, #2560
  static instructionScreen + #338, #2560
  static instructionScreen + #339, #2560
  static instructionScreen + #340, #2560
  static instructionScreen + #341, #2560
  static instructionScreen + #342, #2560
  static instructionScreen + #343, #2560
  static instructionScreen + #344, #2560
  static instructionScreen + #345, #2560
  static instructionScreen + #346, #2560
  static instructionScreen + #347, #2560
  static instructionScreen + #348, #2560
  static instructionScreen + #349, #2560
  static instructionScreen + #350, #2560
  static instructionScreen + #351, #2560
  static instructionScreen + #352, #2560
  static instructionScreen + #353, #2560
  static instructionScreen + #354, #2560
  static instructionScreen + #355, #2560
  static instructionScreen + #356, #2560
  static instructionScreen + #357, #2560
  static instructionScreen + #358, #2560
  static instructionScreen + #359, #2560

  ;Linha 9
  static instructionScreen + #360, #2560
  static instructionScreen + #361, #2560
  static instructionScreen + #362, #2560
  static instructionScreen + #363, #2145
  static instructionScreen + #364, #2158
  static instructionScreen + #365, #2148
  static instructionScreen + #366, #2560
  static instructionScreen + #367, #2169
  static instructionScreen + #368, #2159
  static instructionScreen + #369, #2165
  static instructionScreen + #370, #2560
  static instructionScreen + #371, #2145
  static instructionScreen + #372, #2162
  static instructionScreen + #373, #2149
  static instructionScreen + #374, #2560
  static instructionScreen + #375, #2152
  static instructionScreen + #376, #2165
  static instructionScreen + #377, #2158
  static instructionScreen + #378, #2151
  static instructionScreen + #379, #2162
  static instructionScreen + #380, #2169
  static instructionScreen + #381, #2110
  static instructionScreen + #382, #2560
  static instructionScreen + #383, #2560
  static instructionScreen + #384, #2560
  static instructionScreen + #385, #2560
  static instructionScreen + #386, #2560
  static instructionScreen + #387, #2137
  static instructionScreen + #388, #2159
  static instructionScreen + #389, #2165
  static instructionScreen + #390, #2560
  static instructionScreen + #391, #2147
  static instructionScreen + #392, #2145
  static instructionScreen + #393, #2158
  static instructionScreen + #394, #2560
  static instructionScreen + #395, #2152
  static instructionScreen + #396, #2153
  static instructionScreen + #397, #2148
  static instructionScreen + #398, #2149
  static instructionScreen + #399, #2560

  ;Linha 10
  static instructionScreen + #400, #2560
  static instructionScreen + #401, #2560
  static instructionScreen + #402, #2560
  static instructionScreen + #403, #2560
  static instructionScreen + #404, #2560
  static instructionScreen + #405, #2560
  static instructionScreen + #406, #2560
  static instructionScreen + #407, #2560
  static instructionScreen + #408, #2560
  static instructionScreen + #409, #2560
  static instructionScreen + #410, #2560
  static instructionScreen + #411, #2560
  static instructionScreen + #412, #2560
  static instructionScreen + #413, #2560
  static instructionScreen + #414, #2560
  static instructionScreen + #415, #2560
  static instructionScreen + #416, #2560
  static instructionScreen + #417, #2560
  static instructionScreen + #418, #2560
  static instructionScreen + #419, #2560
  static instructionScreen + #420, #2560
  static instructionScreen + #421, #2560
  static instructionScreen + #422, #2560
  static instructionScreen + #423, #2560
  static instructionScreen + #424, #2560
  static instructionScreen + #425, #2560
  static instructionScreen + #426, #2560
  static instructionScreen + #427, #2560
  static instructionScreen + #428, #2560
  static instructionScreen + #429, #2560
  static instructionScreen + #430, #2560
  static instructionScreen + #431, #2560
  static instructionScreen + #432, #2560
  static instructionScreen + #433, #2560
  static instructionScreen + #434, #2560
  static instructionScreen + #435, #2560
  static instructionScreen + #436, #2560
  static instructionScreen + #437, #2560
  static instructionScreen + #438, #2560
  static instructionScreen + #439, #2560

  ;Linha 11
  static instructionScreen + #440, #2560
  static instructionScreen + #441, #2560
  static instructionScreen + #442, #2560
  static instructionScreen + #443, #2560
  static instructionScreen + #444, #2560
  static instructionScreen + #445, #2560
  static instructionScreen + #446, #2560
  static instructionScreen + #447, #2560
  static instructionScreen + #448, #2560
  static instructionScreen + #449, #2560
  static instructionScreen + #450, #2560
  static instructionScreen + #451, #2560
  static instructionScreen + #452, #2560
  static instructionScreen + #453, #2560
  static instructionScreen + #454, #2560
  static instructionScreen + #455, #2560
  static instructionScreen + #456, #2560
  static instructionScreen + #457, #2560
  static instructionScreen + #458, #2560
  static instructionScreen + #459, #2560
  static instructionScreen + #460, #2560
  static instructionScreen + #461, #2560
  static instructionScreen + #462, #2560
  static instructionScreen + #463, #2560
  static instructionScreen + #464, #2560
  static instructionScreen + #465, #2560
  static instructionScreen + #466, #2560
  static instructionScreen + #467, #2146
  static instructionScreen + #468, #2149
  static instructionScreen + #469, #2152
  static instructionScreen + #470, #2153
  static instructionScreen + #471, #2158
  static instructionScreen + #472, #2148
  static instructionScreen + #473, #2560
  static instructionScreen + #474, #2160
  static instructionScreen + #475, #2156
  static instructionScreen + #476, #2145
  static instructionScreen + #477, #2158
  static instructionScreen + #478, #2164
  static instructionScreen + #479, #2163

  ;Linha 12
  static instructionScreen + #480, #2560
  static instructionScreen + #481, #2560
  static instructionScreen + #482, #2560
  static instructionScreen + #483, #2121
  static instructionScreen + #484, #2158
  static instructionScreen + #485, #2166
  static instructionScreen + #486, #2145
  static instructionScreen + #487, #2148
  static instructionScreen + #488, #2149
  static instructionScreen + #489, #2560
  static instructionScreen + #490, #2164
  static instructionScreen + #491, #2152
  static instructionScreen + #492, #2149
  static instructionScreen + #493, #2560
  static instructionScreen + #494, #2146
  static instructionScreen + #495, #2149
  static instructionScreen + #496, #2149
  static instructionScreen + #497, #2163
  static instructionScreen + #498, #2087
  static instructionScreen + #499, #2560
  static instructionScreen + #500, #2146
  static instructionScreen + #501, #2145
  static instructionScreen + #502, #2163
  static instructionScreen + #503, #2149
  static instructionScreen + #504, #2560
  static instructionScreen + #505, #2560
  static instructionScreen + #506, #2560
  static instructionScreen + #507, #2560
  static instructionScreen + #508, #2560
  static instructionScreen + #509, #2560
  static instructionScreen + #510, #2560
  static instructionScreen + #511, #2560
  static instructionScreen + #512, #2560
  static instructionScreen + #513, #2560
  static instructionScreen + #514, #2560
  static instructionScreen + #515, #2560
  static instructionScreen + #516, #2560
  static instructionScreen + #517, #2560
  static instructionScreen + #518, #2560
  static instructionScreen + #519, #2560

  ;Linha 13
  static instructionScreen + #520, #2560
  static instructionScreen + #521, #2560
  static instructionScreen + #522, #2560
  static instructionScreen + #523, #2560
  static instructionScreen + #524, #2560
  static instructionScreen + #525, #2560
  static instructionScreen + #526, #2560
  static instructionScreen + #527, #2560
  static instructionScreen + #528, #2560
  static instructionScreen + #529, #2560
  static instructionScreen + #530, #2560
  static instructionScreen + #531, #2560
  static instructionScreen + #532, #2560
  static instructionScreen + #533, #2560
  static instructionScreen + #534, #2560
  static instructionScreen + #535, #2560
  static instructionScreen + #536, #2560
  static instructionScreen + #537, #2560
  static instructionScreen + #538, #2560
  static instructionScreen + #539, #2560
  static instructionScreen + #540, #2560
  static instructionScreen + #541, #2560
  static instructionScreen + #542, #2560
  static instructionScreen + #543, #2560
  static instructionScreen + #544, #2560
  static instructionScreen + #545, #2560
  static instructionScreen + #546, #2560
  static instructionScreen + #547, #2123
  static instructionScreen + #548, #2149
  static instructionScreen + #549, #2149
  static instructionScreen + #550, #2160
  static instructionScreen + #551, #2560
  static instructionScreen + #552, #2145
  static instructionScreen + #553, #2158
  static instructionScreen + #554, #2560
  static instructionScreen + #555, #2149
  static instructionScreen + #556, #2169
  static instructionScreen + #557, #2149
  static instructionScreen + #558, #2560
  static instructionScreen + #559, #2560

  ;Linha 14
  static instructionScreen + #560, #2560
  static instructionScreen + #561, #2560
  static instructionScreen + #562, #2560
  static instructionScreen + #563, #2145
  static instructionScreen + #564, #2158
  static instructionScreen + #565, #2148
  static instructionScreen + #566, #2560
  static instructionScreen + #567, #2149
  static instructionScreen + #568, #2145
  static instructionScreen + #569, #2164
  static instructionScreen + #570, #2560
  static instructionScreen + #571, #2164
  static instructionScreen + #572, #2152
  static instructionScreen + #573, #2149
  static instructionScreen + #574, #2153
  static instructionScreen + #575, #2162
  static instructionScreen + #576, #2560
  static instructionScreen + #577, #2146
  static instructionScreen + #578, #2145
  static instructionScreen + #579, #2146
  static instructionScreen + #580, #2169
  static instructionScreen + #581, #2560
  static instructionScreen + #582, #2560
  static instructionScreen + #583, #2560
  static instructionScreen + #584, #2560
  static instructionScreen + #585, #2560
  static instructionScreen + #586, #2560
  static instructionScreen + #587, #2560
  static instructionScreen + #588, #2560
  static instructionScreen + #589, #2560
  static instructionScreen + #590, #2560
  static instructionScreen + #591, #2560
  static instructionScreen + #592, #2560
  static instructionScreen + #593, #2560
  static instructionScreen + #594, #2560
  static instructionScreen + #595, #2560
  static instructionScreen + #596, #2560
  static instructionScreen + #597, #2560
  static instructionScreen + #598, #2560
  static instructionScreen + #599, #2560

  ;Linha 15
  static instructionScreen + #600, #2560
  static instructionScreen + #601, #2560
  static instructionScreen + #602, #2560
  static instructionScreen + #603, #2560
  static instructionScreen + #604, #2560
  static instructionScreen + #605, #2560
  static instructionScreen + #606, #2560
  static instructionScreen + #607, #2560
  static instructionScreen + #608, #2560
  static instructionScreen + #609, #2560
  static instructionScreen + #610, #2560
  static instructionScreen + #611, #2560
  static instructionScreen + #612, #2560
  static instructionScreen + #613, #2560
  static instructionScreen + #614, #2560
  static instructionScreen + #615, #2560
  static instructionScreen + #616, #2560
  static instructionScreen + #617, #2560
  static instructionScreen + #618, #2560
  static instructionScreen + #619, #2560
  static instructionScreen + #620, #2560
  static instructionScreen + #621, #2560
  static instructionScreen + #622, #2560
  static instructionScreen + #623, #2560
  static instructionScreen + #624, #2560
  static instructionScreen + #625, #2560
  static instructionScreen + #626, #2560
  static instructionScreen + #627, #2145
  static instructionScreen + #628, #2164
  static instructionScreen + #629, #2560
  static instructionScreen + #630, #2164
  static instructionScreen + #631, #2152
  static instructionScreen + #632, #2149
  static instructionScreen + #633, #2560
  static instructionScreen + #634, #2164
  static instructionScreen + #635, #2159
  static instructionScreen + #636, #2160
  static instructionScreen + #637, #2560
  static instructionScreen + #638, #2560
  static instructionScreen + #639, #2560

  ;Linha 16
  static instructionScreen + #640, #2560
  static instructionScreen + #641, #2560
  static instructionScreen + #642, #2560
  static instructionScreen + #643, #2167
  static instructionScreen + #644, #2153
  static instructionScreen + #645, #2164
  static instructionScreen + #646, #2152
  static instructionScreen + #647, #2560
  static instructionScreen + #648, #2164
  static instructionScreen + #649, #2152
  static instructionScreen + #650, #2149
  static instructionScreen + #651, #2560
  static instructionScreen + #652, #2163
  static instructionScreen + #653, #2160
  static instructionScreen + #654, #2145
  static instructionScreen + #655, #2147
  static instructionScreen + #656, #2149
  static instructionScreen + #657, #2560
  static instructionScreen + #658, #2155
  static instructionScreen + #659, #2149
  static instructionScreen + #660, #2169
  static instructionScreen + #661, #2110
  static instructionScreen + #662, #2560
  static instructionScreen + #663, #1827
  static instructionScreen + #664, #2850
  static instructionScreen + #665, #2560
  static instructionScreen + #666, #2560
  static instructionScreen + #667, #2560
  static instructionScreen + #668, #2560
  static instructionScreen + #669, #2560
  static instructionScreen + #670, #2560
  static instructionScreen + #671, #2560
  static instructionScreen + #672, #2560
  static instructionScreen + #673, #2560
  static instructionScreen + #674, #2560
  static instructionScreen + #675, #2560
  static instructionScreen + #676, #2560
  static instructionScreen + #677, #2560
  static instructionScreen + #678, #2560
  static instructionScreen + #679, #2560

  ;Linha 17
  static instructionScreen + #680, #2560
  static instructionScreen + #681, #2560
  static instructionScreen + #682, #2560
  static instructionScreen + #683, #2560
  static instructionScreen + #684, #2560
  static instructionScreen + #685, #2560
  static instructionScreen + #686, #2560
  static instructionScreen + #687, #2560
  static instructionScreen + #688, #2560
  static instructionScreen + #689, #2560
  static instructionScreen + #690, #2560
  static instructionScreen + #691, #2560
  static instructionScreen + #692, #2560
  static instructionScreen + #693, #2560
  static instructionScreen + #694, #2560
  static instructionScreen + #695, #2560
  static instructionScreen + #696, #2560
  static instructionScreen + #697, #2560
  static instructionScreen + #698, #2560
  static instructionScreen + #699, #2560
  static instructionScreen + #700, #2560
  static instructionScreen + #701, #2560
  static instructionScreen + #702, #2560
  static instructionScreen + #703, #2560
  static instructionScreen + #704, #2560
  static instructionScreen + #705, #2560
  static instructionScreen + #706, #2560
  static instructionScreen + #707, #2156
  static instructionScreen + #708, #2149
  static instructionScreen + #709, #2150
  static instructionScreen + #710, #2164
  static instructionScreen + #711, #2560
  static instructionScreen + #712, #2147
  static instructionScreen + #713, #2159
  static instructionScreen + #714, #2162
  static instructionScreen + #715, #2158
  static instructionScreen + #716, #2149
  static instructionScreen + #717, #2162
  static instructionScreen + #718, #2560
  static instructionScreen + #719, #2560

  ;Linha 18
  static instructionScreen + #720, #2560
  static instructionScreen + #721, #2560
  static instructionScreen + #722, #2560
  static instructionScreen + #723, #2560
  static instructionScreen + #724, #2560
  static instructionScreen + #725, #2560
  static instructionScreen + #726, #2560
  static instructionScreen + #727, #2560
  static instructionScreen + #728, #2560
  static instructionScreen + #729, #2560
  static instructionScreen + #730, #2560
  static instructionScreen + #731, #2560
  static instructionScreen + #732, #2560
  static instructionScreen + #733, #2560
  static instructionScreen + #734, #2560
  static instructionScreen + #735, #2560
  static instructionScreen + #736, #2560
  static instructionScreen + #737, #2560
  static instructionScreen + #738, #2560
  static instructionScreen + #739, #2560
  static instructionScreen + #740, #2560
  static instructionScreen + #741, #2560
  static instructionScreen + #742, #2560
  static instructionScreen + #743, #2560
  static instructionScreen + #744, #2560
  static instructionScreen + #745, #2560
  static instructionScreen + #746, #2560
  static instructionScreen + #747, #2560
  static instructionScreen + #748, #2560
  static instructionScreen + #749, #2560
  static instructionScreen + #750, #2560
  static instructionScreen + #751, #2560
  static instructionScreen + #752, #2560
  static instructionScreen + #753, #2560
  static instructionScreen + #754, #2560
  static instructionScreen + #755, #2560
  static instructionScreen + #756, #2560
  static instructionScreen + #757, #2560
  static instructionScreen + #758, #2560
  static instructionScreen + #759, #2560

  ;Linha 19
  static instructionScreen + #760, #2560
  static instructionScreen + #761, #2560
  static instructionScreen + #762, #2560
  static instructionScreen + #763, #2114
  static instructionScreen + #764, #2165
  static instructionScreen + #765, #2164
  static instructionScreen + #766, #2560
  static instructionScreen + #767, #2146
  static instructionScreen + #768, #2149
  static instructionScreen + #769, #2560
  static instructionScreen + #770, #2147
  static instructionScreen + #771, #2145
  static instructionScreen + #772, #2162
  static instructionScreen + #773, #2149
  static instructionScreen + #774, #2150
  static instructionScreen + #775, #2165
  static instructionScreen + #776, #2156
  static instructionScreen + #777, #2560
  static instructionScreen + #778, #2167
  static instructionScreen + #779, #2153
  static instructionScreen + #780, #2164
  static instructionScreen + #781, #2152
  static instructionScreen + #782, #2560
  static instructionScreen + #783, #2560
  static instructionScreen + #784, #2560
  static instructionScreen + #785, #2560
  static instructionScreen + #786, #2560
  static instructionScreen + #787, #2159
  static instructionScreen + #788, #2150
  static instructionScreen + #789, #2560
  static instructionScreen + #790, #2164
  static instructionScreen + #791, #2152
  static instructionScreen + #792, #2149
  static instructionScreen + #793, #2560
  static instructionScreen + #794, #2560
  static instructionScreen + #795, #2560
  static instructionScreen + #796, #2560
  static instructionScreen + #797, #2560
  static instructionScreen + #798, #2560
  static instructionScreen + #799, #2560

  ;Linha 20
  static instructionScreen + #800, #2560
  static instructionScreen + #801, #2560
  static instructionScreen + #802, #2560
  static instructionScreen + #803, #2560
  static instructionScreen + #804, #2560
  static instructionScreen + #805, #2560
  static instructionScreen + #806, #2560
  static instructionScreen + #807, #2560
  static instructionScreen + #808, #2560
  static instructionScreen + #809, #2560
  static instructionScreen + #810, #2560
  static instructionScreen + #811, #2560
  static instructionScreen + #812, #2560
  static instructionScreen + #813, #2560
  static instructionScreen + #814, #2560
  static instructionScreen + #815, #2560
  static instructionScreen + #816, #2560
  static instructionScreen + #817, #2560
  static instructionScreen + #818, #2560
  static instructionScreen + #819, #2560
  static instructionScreen + #820, #2560
  static instructionScreen + #821, #2560
  static instructionScreen + #822, #2560
  static instructionScreen + #823, #2560
  static instructionScreen + #824, #2560
  static instructionScreen + #825, #2560
  static instructionScreen + #826, #2560
  static instructionScreen + #827, #2560
  static instructionScreen + #828, #2560
  static instructionScreen + #829, #2560
  static instructionScreen + #830, #2560
  static instructionScreen + #831, #2560
  static instructionScreen + #832, #2560
  static instructionScreen + #833, #2560
  static instructionScreen + #834, #2560
  static instructionScreen + #835, #2560
  static instructionScreen + #836, #2560
  static instructionScreen + #837, #2560
  static instructionScreen + #838, #2560
  static instructionScreen + #839, #2560

  ;Linha 21
  static instructionScreen + #840, #2560
  static instructionScreen + #841, #2560
  static instructionScreen + #842, #2560
  static instructionScreen + #843, #2164
  static instructionScreen + #844, #2152
  static instructionScreen + #845, #2149
  static instructionScreen + #846, #2560
  static instructionScreen + #847, #2145
  static instructionScreen + #848, #2148
  static instructionScreen + #849, #2165
  static instructionScreen + #850, #2156
  static instructionScreen + #851, #2164
  static instructionScreen + #852, #2560
  static instructionScreen + #853, #2146
  static instructionScreen + #854, #2149
  static instructionScreen + #855, #2149
  static instructionScreen + #856, #2163
  static instructionScreen + #857, #2094
  static instructionScreen + #858, #2560
  static instructionScreen + #859, #2560
  static instructionScreen + #860, #2560
  static instructionScreen + #861, #2560
  static instructionScreen + #862, #2560
  static instructionScreen + #863, #2560
  static instructionScreen + #864, #2560
  static instructionScreen + #865, #2560
  static instructionScreen + #866, #2560
  static instructionScreen + #867, #2163
  static instructionScreen + #868, #2147
  static instructionScreen + #869, #2162
  static instructionScreen + #870, #2149
  static instructionScreen + #871, #2149
  static instructionScreen + #872, #2158
  static instructionScreen + #873, #2110
  static instructionScreen + #874, #2560
  static instructionScreen + #875, #3391
  static instructionScreen + #876, #2560
  static instructionScreen + #877, #2560
  static instructionScreen + #878, #2560
  static instructionScreen + #879, #2560

  ;Linha 22
  static instructionScreen + #880, #2560
  static instructionScreen + #881, #2560
  static instructionScreen + #882, #2560
  static instructionScreen + #883, #2560
  static instructionScreen + #884, #2560
  static instructionScreen + #885, #2560
  static instructionScreen + #886, #2560
  static instructionScreen + #887, #2560
  static instructionScreen + #888, #2560
  static instructionScreen + #889, #2560
  static instructionScreen + #890, #2560
  static instructionScreen + #891, #2560
  static instructionScreen + #892, #2560
  static instructionScreen + #893, #2560
  static instructionScreen + #894, #2560
  static instructionScreen + #895, #2560
  static instructionScreen + #896, #2560
  static instructionScreen + #897, #2560
  static instructionScreen + #898, #2560
  static instructionScreen + #899, #2560
  static instructionScreen + #900, #2560
  static instructionScreen + #901, #2560
  static instructionScreen + #902, #2560
  static instructionScreen + #903, #2560
  static instructionScreen + #904, #2560
  static instructionScreen + #905, #2560
  static instructionScreen + #906, #2560
  static instructionScreen + #907, #2560
  static instructionScreen + #908, #2560
  static instructionScreen + #909, #2560
  static instructionScreen + #910, #2560
  static instructionScreen + #911, #2560
  static instructionScreen + #912, #2560
  static instructionScreen + #913, #2560
  static instructionScreen + #914, #2560
  static instructionScreen + #915, #2560
  static instructionScreen + #916, #2560
  static instructionScreen + #917, #2560
  static instructionScreen + #918, #2560
  static instructionScreen + #919, #2560

  ;Linha 23
  static instructionScreen + #920, #2560
  static instructionScreen + #921, #2560
  static instructionScreen + #922, #2560
  static instructionScreen + #923, #2132
  static instructionScreen + #924, #2152
  static instructionScreen + #925, #2149
  static instructionScreen + #926, #2169
  static instructionScreen + #927, #2560
  static instructionScreen + #928, #2167
  static instructionScreen + #929, #2159
  static instructionScreen + #930, #2158
  static instructionScreen + #931, #2087
  static instructionScreen + #932, #2164
  static instructionScreen + #933, #2560
  static instructionScreen + #934, #2156
  static instructionScreen + #935, #2153
  static instructionScreen + #936, #2155
  static instructionScreen + #937, #2149
  static instructionScreen + #938, #2560
  static instructionScreen + #939, #2163
  static instructionScreen + #940, #2149
  static instructionScreen + #941, #2149
  static instructionScreen + #942, #2153
  static instructionScreen + #943, #2158
  static instructionScreen + #944, #2151
  static instructionScreen + #945, #2560
  static instructionScreen + #946, #2560
  static instructionScreen + #947, #2560
  static instructionScreen + #948, #2560
  static instructionScreen + #949, #2560
  static instructionScreen + #950, #2560
  static instructionScreen + #951, #2560
  static instructionScreen + #952, #2560
  static instructionScreen + #953, #768
  static instructionScreen + #954, #2560
  static instructionScreen + #955, #2560
  static instructionScreen + #956, #2560
  static instructionScreen + #957, #2560
  static instructionScreen + #958, #768
  static instructionScreen + #959, #2560

  ;Linha 24
  static instructionScreen + #960, #2560
  static instructionScreen + #961, #2560
  static instructionScreen + #962, #2560
  static instructionScreen + #963, #2560
  static instructionScreen + #964, #2560
  static instructionScreen + #965, #2560
  static instructionScreen + #966, #2560
  static instructionScreen + #967, #2560
  static instructionScreen + #968, #2560
  static instructionScreen + #969, #2560
  static instructionScreen + #970, #2560
  static instructionScreen + #971, #2560
  static instructionScreen + #972, #2560
  static instructionScreen + #973, #2560
  static instructionScreen + #974, #2560
  static instructionScreen + #975, #2560
  static instructionScreen + #976, #2560
  static instructionScreen + #977, #2560
  static instructionScreen + #978, #2560
  static instructionScreen + #979, #2560
  static instructionScreen + #980, #2560
  static instructionScreen + #981, #2560
  static instructionScreen + #982, #2560
  static instructionScreen + #983, #2560
  static instructionScreen + #984, #2560
  static instructionScreen + #985, #2560
  static instructionScreen + #986, #2560
  static instructionScreen + #987, #2560
  static instructionScreen + #988, #768
  static instructionScreen + #989, #768
  static instructionScreen + #990, #2560
  static instructionScreen + #991, #2560
  static instructionScreen + #992, #2560
  static instructionScreen + #993, #768
  static instructionScreen + #994, #768
  static instructionScreen + #995, #3072
  static instructionScreen + #996, #768
  static instructionScreen + #997, #768
  static instructionScreen + #998, #2560
  static instructionScreen + #999, #2560

  ;Linha 25
  static instructionScreen + #1000, #2560
  static instructionScreen + #1001, #2560
  static instructionScreen + #1002, #2560
  static instructionScreen + #1003, #2169
  static instructionScreen + #1004, #2159
  static instructionScreen + #1005, #2165
  static instructionScreen + #1006, #2560
  static instructionScreen + #1007, #2162
  static instructionScreen + #1008, #2159
  static instructionScreen + #1009, #2145
  static instructionScreen + #1010, #2157
  static instructionScreen + #1011, #2153
  static instructionScreen + #1012, #2158
  static instructionScreen + #1013, #2151
  static instructionScreen + #1014, #2560
  static instructionScreen + #1015, #2159
  static instructionScreen + #1016, #2166
  static instructionScreen + #1017, #2149
  static instructionScreen + #1018, #2162
  static instructionScreen + #1019, #2560
  static instructionScreen + #1020, #2560
  static instructionScreen + #1021, #2560
  static instructionScreen + #1022, #3134
  static instructionScreen + #1023, #2560
  static instructionScreen + #1024, #2560
  static instructionScreen + #1025, #2560
  static instructionScreen + #1026, #2560
  static instructionScreen + #1027, #768
  static instructionScreen + #1028, #768
  static instructionScreen + #1029, #768
  static instructionScreen + #1030, #768
  static instructionScreen + #1031, #2560
  static instructionScreen + #1032, #768
  static instructionScreen + #1033, #3328
  static instructionScreen + #1034, #3072
  static instructionScreen + #1035, #2816
  static instructionScreen + #1036, #3072
  static instructionScreen + #1037, #1280
  static instructionScreen + #1038, #2560
  static instructionScreen + #1039, #2560

  ;Linha 26
  static instructionScreen + #1040, #2560
  static instructionScreen + #1041, #2560
  static instructionScreen + #1042, #2560
  static instructionScreen + #1043, #2560
  static instructionScreen + #1044, #2560
  static instructionScreen + #1045, #2560
  static instructionScreen + #1046, #2560
  static instructionScreen + #1047, #2560
  static instructionScreen + #1048, #2560
  static instructionScreen + #1049, #2560
  static instructionScreen + #1050, #2560
  static instructionScreen + #1051, #2560
  static instructionScreen + #1052, #2560
  static instructionScreen + #1053, #2560
  static instructionScreen + #1054, #2560
  static instructionScreen + #1055, #2560
  static instructionScreen + #1056, #2560
  static instructionScreen + #1057, #2560
  static instructionScreen + #1058, #2560
  static instructionScreen + #1059, #2560
  static instructionScreen + #1060, #2560
  static instructionScreen + #1061, #2560
  static instructionScreen + #1062, #2560
  static instructionScreen + #1063, #2560
  static instructionScreen + #1064, #2560
  static instructionScreen + #1065, #2560
  static instructionScreen + #1066, #2560
  static instructionScreen + #1067, #768
  static instructionScreen + #1068, #768
  static instructionScreen + #1069, #768
  static instructionScreen + #1070, #768
  static instructionScreen + #1071, #2560
  static instructionScreen + #1072, #3328
  static instructionScreen + #1073, #2816
  static instructionScreen + #1074, #3328
  static instructionScreen + #1075, #3072
  static instructionScreen + #1076, #1280
  static instructionScreen + #1077, #2816
  static instructionScreen + #1078, #1280
  static instructionScreen + #1079, #2560

  ;Linha 27
  static instructionScreen + #1080, #2560
  static instructionScreen + #1081, #2560
  static instructionScreen + #1082, #2560
  static instructionScreen + #1083, #2164
  static instructionScreen + #1084, #2152
  static instructionScreen + #1085, #2149
  static instructionScreen + #1086, #2153
  static instructionScreen + #1087, #2162
  static instructionScreen + #1088, #2560
  static instructionScreen + #1089, #2146
  static instructionScreen + #1090, #2145
  static instructionScreen + #1091, #2163
  static instructionScreen + #1092, #2149
  static instructionScreen + #1093, #2110
  static instructionScreen + #1094, #2560
  static instructionScreen + #1095, #2560
  static instructionScreen + #1096, #2560
  static instructionScreen + #1097, #2560
  static instructionScreen + #1098, #2560
  static instructionScreen + #1099, #2560
  static instructionScreen + #1100, #2560
  static instructionScreen + #1101, #2826
  static instructionScreen + #1102, #2827
  static instructionScreen + #1103, #2062
  static instructionScreen + #1104, #2560
  static instructionScreen + #1105, #2560
  static instructionScreen + #1106, #2560
  static instructionScreen + #1107, #2560
  static instructionScreen + #1108, #256
  static instructionScreen + #1109, #256
  static instructionScreen + #1110, #2560
  static instructionScreen + #1111, #2560
  static instructionScreen + #1112, #2560
  static instructionScreen + #1113, #3328
  static instructionScreen + #1114, #768
  static instructionScreen + #1115, #768
  static instructionScreen + #1116, #2560
  static instructionScreen + #1117, #1280
  static instructionScreen + #1118, #768
  static instructionScreen + #1119, #2560

  ;Linha 28
  static instructionScreen + #1120, #2560
  static instructionScreen + #1121, #2560
  static instructionScreen + #1122, #2560
  static instructionScreen + #1123, #2560
  static instructionScreen + #1124, #2560
  static instructionScreen + #1125, #2560
  static instructionScreen + #1126, #2560
  static instructionScreen + #1127, #2560
  static instructionScreen + #1128, #2560
  static instructionScreen + #1129, #2560
  static instructionScreen + #1130, #2560
  static instructionScreen + #1131, #2560
  static instructionScreen + #1132, #2560
  static instructionScreen + #1133, #2560
  static instructionScreen + #1134, #2560
  static instructionScreen + #1135, #2560
  static instructionScreen + #1136, #2560
  static instructionScreen + #1137, #2560
  static instructionScreen + #1138, #2560
  static instructionScreen + #1139, #2560
  static instructionScreen + #1140, #2560
  static instructionScreen + #1141, #2829
  static instructionScreen + #1142, #2828
  static instructionScreen + #1143, #2560
  static instructionScreen + #1144, #2560
  static instructionScreen + #1145, #2560
  static instructionScreen + #1146, #2560
  static instructionScreen + #1147, #2560
  static instructionScreen + #1148, #256
  static instructionScreen + #1149, #256
  static instructionScreen + #1150, #2560
  static instructionScreen + #1151, #2560
  static instructionScreen + #1152, #2560
  static instructionScreen + #1153, #2560
  static instructionScreen + #1154, #2560
  static instructionScreen + #1155, #2560
  static instructionScreen + #1156, #2560
  static instructionScreen + #1157, #2560
  static instructionScreen + #1158, #2560
  static instructionScreen + #1159, #2560

  ;Linha 29
  static instructionScreen + #1160, #2560
  static instructionScreen + #1161, #2560
  static instructionScreen + #1162, #2560
  static instructionScreen + #1163, #2560
  static instructionScreen + #1164, #2560
  static instructionScreen + #1165, #2560
  static instructionScreen + #1166, #2560
  static instructionScreen + #1167, #2560
  static instructionScreen + #1168, #2560
  static instructionScreen + #1169, #2560
  static instructionScreen + #1170, #2560
  static instructionScreen + #1171, #2560
  static instructionScreen + #1172, #2560
  static instructionScreen + #1173, #2560
  static instructionScreen + #1174, #2560
  static instructionScreen + #1175, #2560
  static instructionScreen + #1176, #2560
  static instructionScreen + #1177, #2560
  static instructionScreen + #1178, #2560
  static instructionScreen + #1179, #2560
  static instructionScreen + #1180, #2560
  static instructionScreen + #1181, #2560
  static instructionScreen + #1182, #2560
  static instructionScreen + #1183, #2560
  static instructionScreen + #1184, #2560
  static instructionScreen + #1185, #2560
  static instructionScreen + #1186, #2560
  static instructionScreen + #1187, #2560
  static instructionScreen + #1188, #2560
  static instructionScreen + #1189, #2560
  static instructionScreen + #1190, #2560
  static instructionScreen + #1191, #2560
  static instructionScreen + #1192, #2560
  static instructionScreen + #1193, #2560
  static instructionScreen + #1194, #2560
  static instructionScreen + #1195, #2560
  static instructionScreen + #1196, #2560
  static instructionScreen + #1197, #2560
  static instructionScreen + #1198, #2560
  static instructionScreen + #1199, #2560
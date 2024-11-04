call render
call renderPlayer
jmp inGame


inGame:
  ; update coord of mobs and player then rend map (if map slide, else just rend mobs and player), then rend mobs and player
  ; there is no need for array with all coords of map, simple array that only has the values
  ; coords with special properties, walls, sceranio to hide, mobs and player

  call DelayMove
  ; put renderPlayer inside movement routine, why keep rendering withou change in screen?
  ;call renderPlayer
  jmp inGame


DelayMove:
  push R0
  push R1
  
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
  loadn R1, #10
  loadn R0, #65000
  store delayPlayerMove2,  R0
  store delayPlayerMove1, R1

  pop R1
  pop R0
  rts

playerMove:
  ; if inchar == 'w' check if map limit, check if in render line for upper rendering
  push R0
  push R1
  push R2
  push R3
  push R4

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

    ; render pixels under player's left side
    dec R0
    dec R0   ; index of pixel in mapTotal upper left of character
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

    ; render pixels under player's right side
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
  
  ; skins are 2305 - 2306
  ;           771  - 772
  load R0, playerCoordRender ; R0 = mem(playerCoordRender)
  loadn R1, #2305
  outchar R1, R0

  loadn R2, #1
  add R0, R0, R2 ; next coord to the right
  add R1, R1, R2 ; next skin
  outchar R1, R0

  loadn R3, #40
  add R0, R0, R3 ; one coord down
  loadn R1, #772 ; lower right skin
  outchar R1, R0

  sub R0, R0, R2 ; one coord left
  sub R1, R1, R2 ; next skin
  outchar R1, R0

  pop R3
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



delayPlayerMove1: var #1
  static delayPlayerMove1, #0
  
delayPlayerMove2: var #1
  static delayPlayerMove2, #0


; skins will divided between 1. mob
;                            |_ 2: act
;                               |_ 3: sub-act
;                                  |_ 4: position
;                                     |_ 5: quadrant

; player skins
skinPlayerFrontStop: var #4
  static skinPlayerFrontStop + #0, #2305
  static skinPlayerFrontStop + #1, #2306
  static skinPlayerFrontStop + #2, #2307
  static skinPlayerFrontStop + #3, #2308


playerCoordRender: var #1
  static playerCoordRender, #38
  ; last pos is 1158

playerCoordInMap: var #1
  static playerCoordInMap, #38
  ; last pos is 1638


; stores min and max coord to be rendered
renderVar: var #2
  static renderVar + #0, #0     ; first coord rendered
  static renderVar + #1, #1200  ; can't reach this number



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

mapTotal : var #1200
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
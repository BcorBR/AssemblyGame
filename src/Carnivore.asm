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


; first update player coords based in delayed condition, when condition is satisfied, coords are updated and rendering occurs
DelayMove:
  push R0
  push R1
  push R2

  load R0, delayPlayerMove ; takes delay count, if 0 call movement function and increment 40 in movement function, else decrement here
  loadn R1, #0
  cmp R0, R1
  ceq playerMove
  jeq finishDelayMove ; if already 0, skips dec so wont underflow, it will be stored 40, it will skip one count only, no problem

  loadn R1, #1 ; decrements delayCounter in 1
  loadn R2, #delayPlayerMove
  sub R0, R0, R1
  storei R2, R0

  finishDelayMove:
    pop R2
    pop R1
    pop R0
    rts

  playerMove:
    ; if inchar == 'w' check if map limit, check if in render line for upper rendering
    push R0
    push R1

    inchar R0
    loadn R1, #'w'
    cmp R0, R1
    jeq playerMoveUp
    jmp playerMoveFinish


    playerMoveUp:
      loadn R0, #40 ; delay player movement
      store delayPlayerMove, R0

      load R0, playerCoordInMap
      ; if playerCoorMap below 40 (1st line 0 indexed), can't go upper, limit of map reached
      loadn R1, #40
      cmp R0, R1
      ; if greater or equal, it's below the first line of the map, call map slide and decrement playerCoordInMap by 40 else do nothing
      ; if greater or equal, also decrement playerCoordRender by 40, but increment it on mapslide!!, if mapslide is acomplished position on screen must not change
      jle playerMoveFinish ; if lesser, finish routine
      

      ; condition here to ask if it should go to map slide
      call mapSlide
      
      ; we might have under/overflow problems in the coordinates? maybe these lines might fix the problem?
      sub R0, R0, R1 ; R0 = player coordinates in map minus 40
      store playerCoordInMap, R0 ; player coord in map updated to memoryy
      
      ; we might have under/overflow problems in the coordinates? maybe these lines might fix the problem?
      load R0, playerCoordRender
      sub R0, R0, R1 ; R0 = player coordinates in video minus 40...  
                    ; if mapslide was accomplished, it wrongly incremented it, fixing it in this line!!!
      store playerCoordRender, R0 ; player coord in map updated to memoryy
      ; incremented on mapslide

      

      call renderPlayer

      jmp playerMoveFinish



  playerMoveFinish:
    pop R1
    pop R0
    rts

renderPlayer:
  breakp
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

  loadn R0, #mapaTotal ; R0 = base addr map
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


mapSlide:
  ; if inchar == 's' AND R2 == 1680, return
  ; if inchar == 'w' AND R1 == 0, return
  push R0
  push R1
  push R2
  push R3

  load R0, playerCoordRender   ; wil slide down if player in screen coord greater than 999
  loadn R3, #999 ; 5th line 0-indexed bottom to top
  cmp R3, R0      
  jgr slideDown
  
  loadn R3, #240    ; will slide up if player in screen coord below 240
  cmp R3, R0
  jle slideUp

  jmp slideFinish ;change this later

  slideDown:
    breakp
    loadn R1, #renderVar  ; R0 = key; R1 = end: (renderdvar); R2 = mem(rendervar)
    loadi R2, R1          ; there is a filter if it reaches limit
    loadn R3, #0
    cmp R3, R2
    jne renderAboveInc    ; if not in pixel limit jump next step, else return
    jmp slideFinish

    renderAboveInc:
    loadn R3, #40
    sub R2, R2, R3       ; adds to max pixel rendering
    storei R1, R2
    
    inc R1                ; subs to min pixel rendering
    loadi R2, R1
    sub R2, R2, R3
    storei R1, R2

    call render
    
    ; increment playerCoordRender by 40 to be then decremented 
    loadn R0, #playerCoordRender ; addr of playerCoordRender
    loadi R1, R0 ; R1 = mem(playerCoordRender)
    loadn R2, #40 
    add R1, R1, R2
    storei R0, R1

    jmp slideFinish

    
  slideUp:
    loadn R1, #renderVar  ; R0 = key; R1 = end: (renderdvar +1); R2 = mem(rendervar+1)
    inc R1                ; takes second num in array of rendervar (max number)
    loadi R2, R1
    loadn R3, #1680
    cmp R3, R2
    jne renderBelow    ; if not in pixel limit jump next step, else return
    jmp slideFinish

    renderBelow:
    loadn R3, #40
    add R2, R2, R3       ; adds to max pixel rendering
    storei R1, R2
    
    dec R1                ; subs to min pixel rendering
    loadi R2, R1
    add R2, R2, R3
    storei R1, R2

    call render
    jmp slideFinish

    slideFinish:
      pop R3
      pop R2
      pop R1
      pop R0
      rts


delayPlayerMove: var #1
  static delayPlayerMove, #0


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
  static playerCoordRender, #220

playerCoordInMap: var #1
  static playerCoordInMap, #220


; stores min and max coord to be rendered
renderVar: var #2
  static renderVar + #0, #0     ; first coord rendered
  static renderVar + #1, #1200  ; can't reach this number



mapaTotal : var #1680

  ;Linha 0
  static mapaTotal + #0, #2560
  static mapaTotal + #1, #2560
  static mapaTotal + #2, #2560
  static mapaTotal + #3, #2560
  static mapaTotal + #4, #2560
  static mapaTotal + #5, #2560
  static mapaTotal + #6, #2560
  static mapaTotal + #7, #2560
  static mapaTotal + #8, #2560
  static mapaTotal + #9, #2560
  static mapaTotal + #10, #2560
  static mapaTotal + #11, #768
  static mapaTotal + #12, #768
  static mapaTotal + #13, #768
  static mapaTotal + #14, #768
  static mapaTotal + #15, #768
  static mapaTotal + #16, #2560
  static mapaTotal + #17, #768
  static mapaTotal + #18, #768
  static mapaTotal + #19, #768
  static mapaTotal + #20, #2560
  static mapaTotal + #21, #1280
  static mapaTotal + #22, #2816
  static mapaTotal + #23, #1280
  static mapaTotal + #24, #768
  static mapaTotal + #25, #768
  static mapaTotal + #26, #2560
  static mapaTotal + #27, #2560
  static mapaTotal + #28, #2560
  static mapaTotal + #29, #2560
  static mapaTotal + #30, #2560
  static mapaTotal + #31, #2560
  static mapaTotal + #32, #2560
  static mapaTotal + #33, #2560
  static mapaTotal + #34, #2560
  static mapaTotal + #35, #2560
  static mapaTotal + #36, #2816
  static mapaTotal + #37, #2816
  static mapaTotal + #38, #256
  static mapaTotal + #39, #2816

  ;Linha 1
  static mapaTotal + #40, #2560
  static mapaTotal + #41, #2560
  static mapaTotal + #42, #2560
  static mapaTotal + #43, #2560
  static mapaTotal + #44, #2560
  static mapaTotal + #45, #2560
  static mapaTotal + #46, #2560
  static mapaTotal + #47, #2560
  static mapaTotal + #48, #2560
  static mapaTotal + #49, #2560
  static mapaTotal + #50, #768
  static mapaTotal + #51, #768
  static mapaTotal + #52, #768
  static mapaTotal + #53, #768
  static mapaTotal + #54, #768
  static mapaTotal + #55, #768
  static mapaTotal + #56, #768
  static mapaTotal + #57, #2560
  static mapaTotal + #58, #768
  static mapaTotal + #59, #768
  static mapaTotal + #60, #768
  static mapaTotal + #61, #2304
  static mapaTotal + #62, #1280
  static mapaTotal + #63, #768
  static mapaTotal + #64, #1536
  static mapaTotal + #65, #768
  static mapaTotal + #66, #768
  static mapaTotal + #67, #2560
  static mapaTotal + #68, #2560
  static mapaTotal + #69, #2560
  static mapaTotal + #70, #768
  static mapaTotal + #71, #768
  static mapaTotal + #72, #2560
  static mapaTotal + #73, #2560
  static mapaTotal + #74, #2560
  static mapaTotal + #75, #2560
  static mapaTotal + #76, #2560
  static mapaTotal + #77, #2816
  static mapaTotal + #78, #2816
  static mapaTotal + #79, #256

  ;Linha 2
  static mapaTotal + #80, #2560
  static mapaTotal + #81, #2560
  static mapaTotal + #82, #2560
  static mapaTotal + #83, #2560
  static mapaTotal + #84, #2560
  static mapaTotal + #85, #2560
  static mapaTotal + #86, #2560
  static mapaTotal + #87, #2560
  static mapaTotal + #88, #2560
  static mapaTotal + #89, #768
  static mapaTotal + #90, #768
  static mapaTotal + #91, #768
  static mapaTotal + #92, #768
  static mapaTotal + #93, #768
  static mapaTotal + #94, #768
  static mapaTotal + #95, #768
  static mapaTotal + #96, #768
  static mapaTotal + #97, #768
  static mapaTotal + #98, #2560
  static mapaTotal + #99, #1792
  static mapaTotal + #100, #2304
  static mapaTotal + #101, #2816
  static mapaTotal + #102, #2304
  static mapaTotal + #103, #1536
  static mapaTotal + #104, #2816
  static mapaTotal + #105, #1536
  static mapaTotal + #106, #2560
  static mapaTotal + #107, #2560
  static mapaTotal + #108, #2560
  static mapaTotal + #109, #768
  static mapaTotal + #110, #768
  static mapaTotal + #111, #768
  static mapaTotal + #112, #768
  static mapaTotal + #113, #2560
  static mapaTotal + #114, #2560
  static mapaTotal + #115, #2560
  static mapaTotal + #116, #2560
  static mapaTotal + #117, #2560
  static mapaTotal + #118, #2816
  static mapaTotal + #119, #2816

  ;Linha 3
  static mapaTotal + #120, #2560
  static mapaTotal + #121, #2560
  static mapaTotal + #122, #2560
  static mapaTotal + #123, #2560
  static mapaTotal + #124, #2560
  static mapaTotal + #125, #2560
  static mapaTotal + #126, #2560
  static mapaTotal + #127, #2560
  static mapaTotal + #128, #2560
  static mapaTotal + #129, #2560
  static mapaTotal + #130, #768
  static mapaTotal + #131, #768
  static mapaTotal + #132, #768
  static mapaTotal + #133, #768
  static mapaTotal + #134, #768
  static mapaTotal + #135, #768
  static mapaTotal + #136, #768
  static mapaTotal + #137, #2560
  static mapaTotal + #138, #1792
  static mapaTotal + #139, #2816
  static mapaTotal + #140, #1792
  static mapaTotal + #141, #2304
  static mapaTotal + #142, #768
  static mapaTotal + #143, #768
  static mapaTotal + #144, #1536
  static mapaTotal + #145, #2560
  static mapaTotal + #146, #2560
  static mapaTotal + #147, #2560
  static mapaTotal + #148, #768
  static mapaTotal + #149, #768
  static mapaTotal + #150, #768
  static mapaTotal + #151, #768
  static mapaTotal + #152, #768
  static mapaTotal + #153, #768
  static mapaTotal + #154, #2560
  static mapaTotal + #155, #2560
  static mapaTotal + #156, #2560
  static mapaTotal + #157, #2560
  static mapaTotal + #158, #2560
  static mapaTotal + #159, #2560

  ;Linha 4
  static mapaTotal + #160, #2560
  static mapaTotal + #161, #2560
  static mapaTotal + #162, #2560
  static mapaTotal + #163, #2560
  static mapaTotal + #164, #2560
  static mapaTotal + #165, #2560
  static mapaTotal + #166, #2560
  static mapaTotal + #167, #2560
  static mapaTotal + #168, #2560
  static mapaTotal + #169, #2560
  static mapaTotal + #170, #2560
  static mapaTotal + #171, #768
  static mapaTotal + #172, #768
  static mapaTotal + #173, #768
  static mapaTotal + #174, #768
  static mapaTotal + #175, #768
  static mapaTotal + #176, #2560
  static mapaTotal + #177, #2560
  static mapaTotal + #178, #2560
  static mapaTotal + #179, #1792
  static mapaTotal + #180, #768
  static mapaTotal + #181, #2560
  static mapaTotal + #182, #2560
  static mapaTotal + #183, #2560
  static mapaTotal + #184, #2560
  static mapaTotal + #185, #2560
  static mapaTotal + #186, #2560
  static mapaTotal + #187, #2560
  static mapaTotal + #188, #768
  static mapaTotal + #189, #768
  static mapaTotal + #190, #768
  static mapaTotal + #191, #768
  static mapaTotal + #192, #768
  static mapaTotal + #193, #768
  static mapaTotal + #194, #2560
  static mapaTotal + #195, #2560
  static mapaTotal + #196, #2560
  static mapaTotal + #197, #2560
  static mapaTotal + #198, #2560
  static mapaTotal + #199, #2560

  ;Linha 5
  static mapaTotal + #200, #2560
  static mapaTotal + #201, #2560
  static mapaTotal + #202, #2560
  static mapaTotal + #203, #2560
  static mapaTotal + #204, #2560
  static mapaTotal + #205, #2560
  static mapaTotal + #206, #2560
  static mapaTotal + #207, #2560
  static mapaTotal + #208, #2560
  static mapaTotal + #209, #2560
  static mapaTotal + #210, #2560
  static mapaTotal + #211, #2560
  static mapaTotal + #212, #256
  static mapaTotal + #213, #256
  static mapaTotal + #214, #256
  static mapaTotal + #215, #2560
  static mapaTotal + #216, #2560
  static mapaTotal + #217, #2560
  static mapaTotal + #218, #2560
  static mapaTotal + #219, #2560
  static mapaTotal + #220, #2560
  static mapaTotal + #221, #768
  static mapaTotal + #222, #768
  static mapaTotal + #223, #768
  static mapaTotal + #224, #768
  static mapaTotal + #225, #2560
  static mapaTotal + #226, #2560
  static mapaTotal + #227, #2560
  static mapaTotal + #228, #2560
  static mapaTotal + #229, #768
  static mapaTotal + #230, #768
  static mapaTotal + #231, #768
  static mapaTotal + #232, #768
  static mapaTotal + #233, #2560
  static mapaTotal + #234, #2560
  static mapaTotal + #235, #2560
  static mapaTotal + #236, #2560
  static mapaTotal + #237, #2560
  static mapaTotal + #238, #2560
  static mapaTotal + #239, #2560

  ;Linha 6
  static mapaTotal + #240, #2560
  static mapaTotal + #241, #2560
  static mapaTotal + #242, #768
  static mapaTotal + #243, #768
  static mapaTotal + #244, #768
  static mapaTotal + #245, #768
  static mapaTotal + #246, #2560
  static mapaTotal + #247, #2560
  static mapaTotal + #248, #2560
  static mapaTotal + #249, #2560
  static mapaTotal + #250, #768
  static mapaTotal + #251, #768
  static mapaTotal + #252, #256
  static mapaTotal + #253, #256
  static mapaTotal + #254, #256
  static mapaTotal + #255, #768
  static mapaTotal + #256, #768
  static mapaTotal + #257, #768
  static mapaTotal + #258, #768
  static mapaTotal + #259, #768
  static mapaTotal + #260, #768
  static mapaTotal + #261, #768
  static mapaTotal + #262, #768
  static mapaTotal + #263, #768
  static mapaTotal + #264, #768
  static mapaTotal + #265, #768
  static mapaTotal + #266, #768
  static mapaTotal + #267, #2560
  static mapaTotal + #268, #2560
  static mapaTotal + #269, #2560
  static mapaTotal + #270, #256
  static mapaTotal + #271, #256
  static mapaTotal + #272, #2560
  static mapaTotal + #273, #2560
  static mapaTotal + #274, #2560
  static mapaTotal + #275, #2560
  static mapaTotal + #276, #2560
  static mapaTotal + #277, #2560
  static mapaTotal + #278, #2560
  static mapaTotal + #279, #2560

  ;Linha 7
  static mapaTotal + #280, #2560
  static mapaTotal + #281, #768
  static mapaTotal + #282, #768
  static mapaTotal + #283, #768
  static mapaTotal + #284, #768
  static mapaTotal + #285, #768
  static mapaTotal + #286, #768
  static mapaTotal + #287, #2560
  static mapaTotal + #288, #2560
  static mapaTotal + #289, #768
  static mapaTotal + #290, #768
  static mapaTotal + #291, #768
  static mapaTotal + #292, #768
  static mapaTotal + #293, #256
  static mapaTotal + #294, #768
  static mapaTotal + #295, #768
  static mapaTotal + #296, #768
  static mapaTotal + #297, #768
  static mapaTotal + #298, #768
  static mapaTotal + #299, #768
  static mapaTotal + #300, #768
  static mapaTotal + #301, #768
  static mapaTotal + #302, #768
  static mapaTotal + #303, #768
  static mapaTotal + #304, #768
  static mapaTotal + #305, #768
  static mapaTotal + #306, #768
  static mapaTotal + #307, #768
  static mapaTotal + #308, #2560
  static mapaTotal + #309, #2560
  static mapaTotal + #310, #256
  static mapaTotal + #311, #256
  static mapaTotal + #312, #2560
  static mapaTotal + #313, #2560
  static mapaTotal + #314, #2560
  static mapaTotal + #315, #2560
  static mapaTotal + #316, #2560
  static mapaTotal + #317, #2560
  static mapaTotal + #318, #2560
  static mapaTotal + #319, #2560

  ;Linha 8
  static mapaTotal + #320, #768
  static mapaTotal + #321, #768
  static mapaTotal + #322, #768
  static mapaTotal + #323, #768
  static mapaTotal + #324, #768
  static mapaTotal + #325, #768
  static mapaTotal + #326, #768
  static mapaTotal + #327, #768
  static mapaTotal + #328, #2560
  static mapaTotal + #329, #768
  static mapaTotal + #330, #768
  static mapaTotal + #331, #768
  static mapaTotal + #332, #768
  static mapaTotal + #333, #768
  static mapaTotal + #334, #768
  static mapaTotal + #335, #768
  static mapaTotal + #336, #768
  static mapaTotal + #337, #768
  static mapaTotal + #338, #768
  static mapaTotal + #339, #768
  static mapaTotal + #340, #768
  static mapaTotal + #341, #768
  static mapaTotal + #342, #768
  static mapaTotal + #343, #768
  static mapaTotal + #344, #768
  static mapaTotal + #345, #768
  static mapaTotal + #346, #768
  static mapaTotal + #347, #768
  static mapaTotal + #348, #2560
  static mapaTotal + #349, #2560
  static mapaTotal + #350, #256
  static mapaTotal + #351, #256
  static mapaTotal + #352, #2560
  static mapaTotal + #353, #2560
  static mapaTotal + #354, #2560
  static mapaTotal + #355, #2560
  static mapaTotal + #356, #2560
  static mapaTotal + #357, #2560
  static mapaTotal + #358, #2560
  static mapaTotal + #359, #2560

  ;Linha 9
  static mapaTotal + #360, #768
  static mapaTotal + #361, #768
  static mapaTotal + #362, #768
  static mapaTotal + #363, #768
  static mapaTotal + #364, #768
  static mapaTotal + #365, #768
  static mapaTotal + #366, #768
  static mapaTotal + #367, #768
  static mapaTotal + #368, #2560
  static mapaTotal + #369, #768
  static mapaTotal + #370, #768
  static mapaTotal + #371, #768
  static mapaTotal + #372, #768
  static mapaTotal + #373, #2304
  static mapaTotal + #374, #768
  static mapaTotal + #375, #768
  static mapaTotal + #376, #768
  static mapaTotal + #377, #768
  static mapaTotal + #378, #768
  static mapaTotal + #379, #768
  static mapaTotal + #380, #768
  static mapaTotal + #381, #768
  static mapaTotal + #382, #768
  static mapaTotal + #383, #768
  static mapaTotal + #384, #768
  static mapaTotal + #385, #768
  static mapaTotal + #386, #768
  static mapaTotal + #387, #768
  static mapaTotal + #388, #2560
  static mapaTotal + #389, #2560
  static mapaTotal + #390, #256
  static mapaTotal + #391, #256
  static mapaTotal + #392, #2560
  static mapaTotal + #393, #2560
  static mapaTotal + #394, #2560
  static mapaTotal + #395, #2560
  static mapaTotal + #396, #2560
  static mapaTotal + #397, #2560
  static mapaTotal + #398, #2560
  static mapaTotal + #399, #2560

  ;Linha 10
  static mapaTotal + #400, #2560
  static mapaTotal + #401, #768
  static mapaTotal + #402, #768
  static mapaTotal + #403, #768
  static mapaTotal + #404, #768
  static mapaTotal + #405, #768
  static mapaTotal + #406, #768
  static mapaTotal + #407, #2560
  static mapaTotal + #408, #2560
  static mapaTotal + #409, #2560
  static mapaTotal + #410, #768
  static mapaTotal + #411, #768
  static mapaTotal + #412, #2304
  static mapaTotal + #413, #2816
  static mapaTotal + #414, #2304
  static mapaTotal + #415, #768
  static mapaTotal + #416, #768
  static mapaTotal + #417, #768
  static mapaTotal + #418, #768
  static mapaTotal + #419, #768
  static mapaTotal + #420, #768
  static mapaTotal + #421, #768
  static mapaTotal + #422, #768
  static mapaTotal + #423, #768
  static mapaTotal + #424, #768
  static mapaTotal + #425, #768
  static mapaTotal + #426, #768
  static mapaTotal + #427, #2560
  static mapaTotal + #428, #2560
  static mapaTotal + #429, #2560
  static mapaTotal + #430, #256
  static mapaTotal + #431, #256
  static mapaTotal + #432, #2560
  static mapaTotal + #433, #2560
  static mapaTotal + #434, #768
  static mapaTotal + #435, #2560
  static mapaTotal + #436, #2560
  static mapaTotal + #437, #2560
  static mapaTotal + #438, #2560
  static mapaTotal + #439, #2560

  ;Linha 11
  static mapaTotal + #440, #2560
  static mapaTotal + #441, #2560
  static mapaTotal + #442, #768
  static mapaTotal + #443, #768
  static mapaTotal + #444, #768
  static mapaTotal + #445, #768
  static mapaTotal + #446, #2560
  static mapaTotal + #447, #2560
  static mapaTotal + #448, #2560
  static mapaTotal + #449, #2560
  static mapaTotal + #450, #1024
  static mapaTotal + #451, #256
  static mapaTotal + #452, #768
  static mapaTotal + #453, #2304
  static mapaTotal + #454, #1280
  static mapaTotal + #455, #2816
  static mapaTotal + #456, #256
  static mapaTotal + #457, #256
  static mapaTotal + #458, #1280
  static mapaTotal + #459, #2816
  static mapaTotal + #460, #768
  static mapaTotal + #461, #768
  static mapaTotal + #462, #768
  static mapaTotal + #463, #768
  static mapaTotal + #464, #768
  static mapaTotal + #465, #768
  static mapaTotal + #466, #2560
  static mapaTotal + #467, #2560
  static mapaTotal + #468, #2560
  static mapaTotal + #469, #2560
  static mapaTotal + #470, #256
  static mapaTotal + #471, #256
  static mapaTotal + #472, #2560
  static mapaTotal + #473, #768
  static mapaTotal + #474, #768
  static mapaTotal + #475, #768
  static mapaTotal + #476, #2560
  static mapaTotal + #477, #2560
  static mapaTotal + #478, #2560
  static mapaTotal + #479, #2560

mapaTotal : var #1200
  ;Linha 12
  static mapaTotal + #480, #2560
  static mapaTotal + #481, #2560
  static mapaTotal + #482, #2560
  static mapaTotal + #483, #256
  static mapaTotal + #484, #256
  static mapaTotal + #485, #2560
  static mapaTotal + #486, #2560
  static mapaTotal + #487, #1792
  static mapaTotal + #488, #768
  static mapaTotal + #489, #1024
  static mapaTotal + #490, #2816
  static mapaTotal + #491, #1024
  static mapaTotal + #492, #1536
  static mapaTotal + #493, #768
  static mapaTotal + #494, #2560
  static mapaTotal + #495, #256
  static mapaTotal + #496, #256
  static mapaTotal + #497, #2560
  static mapaTotal + #498, #2560
  static mapaTotal + #499, #1280
  static mapaTotal + #500, #256
  static mapaTotal + #501, #256
  static mapaTotal + #502, #1792
  static mapaTotal + #503, #2560
  static mapaTotal + #504, #256
  static mapaTotal + #505, #256
  static mapaTotal + #506, #2560
  static mapaTotal + #507, #2560
  static mapaTotal + #508, #2560
  static mapaTotal + #509, #2560
  static mapaTotal + #510, #256
  static mapaTotal + #511, #256
  static mapaTotal + #512, #2560
  static mapaTotal + #513, #256
  static mapaTotal + #514, #256
  static mapaTotal + #515, #768
  static mapaTotal + #516, #2560
  static mapaTotal + #517, #2560
  static mapaTotal + #518, #2560
  static mapaTotal + #519, #2560

  ;Linha 13
  static mapaTotal + #520, #2560
  static mapaTotal + #521, #2560
  static mapaTotal + #522, #2560
  static mapaTotal + #523, #256
  static mapaTotal + #524, #256
  static mapaTotal + #525, #2560
  static mapaTotal + #526, #1792
  static mapaTotal + #527, #2816
  static mapaTotal + #528, #1792
  static mapaTotal + #529, #1280
  static mapaTotal + #530, #1024
  static mapaTotal + #531, #1536
  static mapaTotal + #532, #2816
  static mapaTotal + #533, #1536
  static mapaTotal + #534, #768
  static mapaTotal + #535, #2560
  static mapaTotal + #536, #2560
  static mapaTotal + #537, #2560
  static mapaTotal + #538, #2560
  static mapaTotal + #539, #2560
  static mapaTotal + #540, #256
  static mapaTotal + #541, #256
  static mapaTotal + #542, #2560
  static mapaTotal + #543, #2560
  static mapaTotal + #544, #256
  static mapaTotal + #545, #256
  static mapaTotal + #546, #2560
  static mapaTotal + #547, #2560
  static mapaTotal + #548, #2560
  static mapaTotal + #549, #2560
  static mapaTotal + #550, #256
  static mapaTotal + #551, #256
  static mapaTotal + #552, #2560
  static mapaTotal + #553, #256
  static mapaTotal + #554, #256
  static mapaTotal + #555, #2560
  static mapaTotal + #556, #2560
  static mapaTotal + #557, #2560
  static mapaTotal + #558, #2560
  static mapaTotal + #559, #2560

  ;Linha 14
  static mapaTotal + #560, #2560
  static mapaTotal + #561, #2560
  static mapaTotal + #562, #2560
  static mapaTotal + #563, #256
  static mapaTotal + #564, #256
  static mapaTotal + #565, #2560
  static mapaTotal + #566, #768
  static mapaTotal + #567, #1792
  static mapaTotal + #568, #1280
  static mapaTotal + #569, #2816
  static mapaTotal + #570, #1280
  static mapaTotal + #571, #768
  static mapaTotal + #572, #1536
  static mapaTotal + #573, #768
  static mapaTotal + #574, #2560
  static mapaTotal + #575, #2560
  static mapaTotal + #576, #2560
  static mapaTotal + #577, #2560
  static mapaTotal + #578, #2560
  static mapaTotal + #579, #2560
  static mapaTotal + #580, #256
  static mapaTotal + #581, #256
  static mapaTotal + #582, #2560
  static mapaTotal + #583, #2560
  static mapaTotal + #584, #2560
  static mapaTotal + #585, #2560
  static mapaTotal + #586, #2560
  static mapaTotal + #587, #2560
  static mapaTotal + #588, #2560
  static mapaTotal + #589, #2560
  static mapaTotal + #590, #2560
  static mapaTotal + #591, #2560
  static mapaTotal + #592, #2560
  static mapaTotal + #593, #256
  static mapaTotal + #594, #256
  static mapaTotal + #595, #2560
  static mapaTotal + #596, #2560
  static mapaTotal + #597, #2560
  static mapaTotal + #598, #2560
  static mapaTotal + #599, #2560

  ;Linha 15
  static mapaTotal + #600, #2560
  static mapaTotal + #601, #2560
  static mapaTotal + #602, #2560
  static mapaTotal + #603, #256
  static mapaTotal + #604, #256
  static mapaTotal + #605, #2560
  static mapaTotal + #606, #2560
  static mapaTotal + #607, #768
  static mapaTotal + #608, #768
  static mapaTotal + #609, #1280
  static mapaTotal + #610, #768
  static mapaTotal + #611, #2560
  static mapaTotal + #612, #2560
  static mapaTotal + #613, #2560
  static mapaTotal + #614, #2560
  static mapaTotal + #615, #2560
  static mapaTotal + #616, #2560
  static mapaTotal + #617, #2560
  static mapaTotal + #618, #2560
  static mapaTotal + #619, #2560
  static mapaTotal + #620, #256
  static mapaTotal + #621, #256
  static mapaTotal + #622, #2560
  static mapaTotal + #623, #2560
  static mapaTotal + #624, #2560
  static mapaTotal + #625, #2560
  static mapaTotal + #626, #2560
  static mapaTotal + #627, #2560
  static mapaTotal + #628, #2560
  static mapaTotal + #629, #2560
  static mapaTotal + #630, #2560
  static mapaTotal + #631, #2560
  static mapaTotal + #632, #2560
  static mapaTotal + #633, #256
  static mapaTotal + #634, #256
  static mapaTotal + #635, #2560
  static mapaTotal + #636, #2560
  static mapaTotal + #637, #2560
  static mapaTotal + #638, #2560
  static mapaTotal + #639, #2560

  ;Linha 16
  static mapaTotal + #640, #2560
  static mapaTotal + #641, #2560
  static mapaTotal + #642, #2560
  static mapaTotal + #643, #2560
  static mapaTotal + #644, #2560
  static mapaTotal + #645, #2560
  static mapaTotal + #646, #2560
  static mapaTotal + #647, #2560
  static mapaTotal + #648, #2560
  static mapaTotal + #649, #2560
  static mapaTotal + #650, #2560
  static mapaTotal + #651, #2560
  static mapaTotal + #652, #2560
  static mapaTotal + #653, #2560
  static mapaTotal + #654, #2560
  static mapaTotal + #655, #2560
  static mapaTotal + #656, #2560
  static mapaTotal + #657, #2560
  static mapaTotal + #658, #2560
  static mapaTotal + #659, #2560
  static mapaTotal + #660, #2560
  static mapaTotal + #661, #2560
  static mapaTotal + #662, #2560
  static mapaTotal + #663, #2560
  static mapaTotal + #664, #2560
  static mapaTotal + #665, #2560
  static mapaTotal + #666, #2560
  static mapaTotal + #667, #2560
  static mapaTotal + #668, #2560
  static mapaTotal + #669, #2560
  static mapaTotal + #670, #2560
  static mapaTotal + #671, #2560
  static mapaTotal + #672, #2560
  static mapaTotal + #673, #2560
  static mapaTotal + #674, #2560
  static mapaTotal + #675, #2560
  static mapaTotal + #676, #2560
  static mapaTotal + #677, #2560
  static mapaTotal + #678, #2560
  static mapaTotal + #679, #2560

  ;Linha 17
  static mapaTotal + #680, #2560
  static mapaTotal + #681, #2560
  static mapaTotal + #682, #2560
  static mapaTotal + #683, #2560
  static mapaTotal + #684, #2560
  static mapaTotal + #685, #2560
  static mapaTotal + #686, #2560
  static mapaTotal + #687, #2560
  static mapaTotal + #688, #2560
  static mapaTotal + #689, #2560
  static mapaTotal + #690, #2560
  static mapaTotal + #691, #2560
  static mapaTotal + #692, #2560
  static mapaTotal + #693, #2560
  static mapaTotal + #694, #2560
  static mapaTotal + #695, #2560
  static mapaTotal + #696, #2560
  static mapaTotal + #697, #2560
  static mapaTotal + #698, #2560
  static mapaTotal + #699, #2560
  static mapaTotal + #700, #2560
  static mapaTotal + #701, #2560
  static mapaTotal + #702, #2560
  static mapaTotal + #703, #2560
  static mapaTotal + #704, #2560
  static mapaTotal + #705, #2560
  static mapaTotal + #706, #2560
  static mapaTotal + #707, #2560
  static mapaTotal + #708, #2560
  static mapaTotal + #709, #2560
  static mapaTotal + #710, #2560
  static mapaTotal + #711, #2560
  static mapaTotal + #712, #2560
  static mapaTotal + #713, #2560
  static mapaTotal + #714, #2560
  static mapaTotal + #715, #2560
  static mapaTotal + #716, #2560
  static mapaTotal + #717, #2560
  static mapaTotal + #718, #2560
  static mapaTotal + #719, #2560

  ;Linha 18
  static mapaTotal + #720, #2560
  static mapaTotal + #721, #2560
  static mapaTotal + #722, #2560
  static mapaTotal + #723, #2560
  static mapaTotal + #724, #2560
  static mapaTotal + #725, #2560
  static mapaTotal + #726, #2560
  static mapaTotal + #727, #2560
  static mapaTotal + #728, #2560
  static mapaTotal + #729, #2560
  static mapaTotal + #730, #2560
  static mapaTotal + #731, #2560
  static mapaTotal + #732, #2560
  static mapaTotal + #733, #2560
  static mapaTotal + #734, #2560
  static mapaTotal + #735, #2560
  static mapaTotal + #736, #2560
  static mapaTotal + #737, #2560
  static mapaTotal + #738, #2560
  static mapaTotal + #739, #2560
  static mapaTotal + #740, #2560
  static mapaTotal + #741, #2560
  static mapaTotal + #742, #2560
  static mapaTotal + #743, #2560
  static mapaTotal + #744, #2560
  static mapaTotal + #745, #2560
  static mapaTotal + #746, #2560
  static mapaTotal + #747, #2560
  static mapaTotal + #748, #2560
  static mapaTotal + #749, #2560
  static mapaTotal + #750, #2560
  static mapaTotal + #751, #2560
  static mapaTotal + #752, #2560
  static mapaTotal + #753, #2560
  static mapaTotal + #754, #2560
  static mapaTotal + #755, #2560
  static mapaTotal + #756, #2560
  static mapaTotal + #757, #2560
  static mapaTotal + #758, #2560
  static mapaTotal + #759, #2560

  ;Linha 19
  static mapaTotal + #760, #2560
  static mapaTotal + #761, #2560
  static mapaTotal + #762, #2560
  static mapaTotal + #763, #2560
  static mapaTotal + #764, #2560
  static mapaTotal + #765, #2560
  static mapaTotal + #766, #2560
  static mapaTotal + #767, #2560
  static mapaTotal + #768, #2560
  static mapaTotal + #769, #2560
  static mapaTotal + #770, #2560
  static mapaTotal + #771, #2560
  static mapaTotal + #772, #2560
  static mapaTotal + #773, #2560
  static mapaTotal + #774, #2560
  static mapaTotal + #775, #2560
  static mapaTotal + #776, #2560
  static mapaTotal + #777, #2560
  static mapaTotal + #778, #2560
  static mapaTotal + #779, #2560
  static mapaTotal + #780, #2560
  static mapaTotal + #781, #2560
  static mapaTotal + #782, #2560
  static mapaTotal + #783, #2560
  static mapaTotal + #784, #2560
  static mapaTotal + #785, #2560
  static mapaTotal + #786, #2560
  static mapaTotal + #787, #2560
  static mapaTotal + #788, #2560
  static mapaTotal + #789, #2560
  static mapaTotal + #790, #2560
  static mapaTotal + #791, #2560
  static mapaTotal + #792, #2560
  static mapaTotal + #793, #2560
  static mapaTotal + #794, #2560
  static mapaTotal + #795, #2560
  static mapaTotal + #796, #2560
  static mapaTotal + #797, #2560
  static mapaTotal + #798, #2560
  static mapaTotal + #799, #2560

  ;Linha 20
  static mapaTotal + #800, #256
  static mapaTotal + #801, #2560
  static mapaTotal + #802, #2560
  static mapaTotal + #803, #256
  static mapaTotal + #804, #256
  static mapaTotal + #805, #256
  static mapaTotal + #806, #256
  static mapaTotal + #807, #256
  static mapaTotal + #808, #256
  static mapaTotal + #809, #256
  static mapaTotal + #810, #256
  static mapaTotal + #811, #256
  static mapaTotal + #812, #256
  static mapaTotal + #813, #2560
  static mapaTotal + #814, #2560
  static mapaTotal + #815, #256
  static mapaTotal + #816, #256
  static mapaTotal + #817, #256
  static mapaTotal + #818, #256
  static mapaTotal + #819, #256
  static mapaTotal + #820, #256
  static mapaTotal + #821, #256
  static mapaTotal + #822, #256
  static mapaTotal + #823, #256
  static mapaTotal + #824, #256
  static mapaTotal + #825, #2560
  static mapaTotal + #826, #2560
  static mapaTotal + #827, #256
  static mapaTotal + #828, #256
  static mapaTotal + #829, #256
  static mapaTotal + #830, #256
  static mapaTotal + #831, #256
  static mapaTotal + #832, #256
  static mapaTotal + #833, #256
  static mapaTotal + #834, #256
  static mapaTotal + #835, #256
  static mapaTotal + #836, #256
  static mapaTotal + #837, #256
  static mapaTotal + #838, #2560
  static mapaTotal + #839, #2560

  ;Linha 21
  static mapaTotal + #840, #2560
  static mapaTotal + #841, #2560
  static mapaTotal + #842, #2560
  static mapaTotal + #843, #2560
  static mapaTotal + #844, #2560
  static mapaTotal + #845, #2560
  static mapaTotal + #846, #2560
  static mapaTotal + #847, #2560
  static mapaTotal + #848, #2560
  static mapaTotal + #849, #2560
  static mapaTotal + #850, #2560
  static mapaTotal + #851, #2560
  static mapaTotal + #852, #2560
  static mapaTotal + #853, #2560
  static mapaTotal + #854, #2560
  static mapaTotal + #855, #2560
  static mapaTotal + #856, #2560
  static mapaTotal + #857, #2560
  static mapaTotal + #858, #2560
  static mapaTotal + #859, #2560
  static mapaTotal + #860, #2560
  static mapaTotal + #861, #2560
  static mapaTotal + #862, #2560
  static mapaTotal + #863, #2560
  static mapaTotal + #864, #2560
  static mapaTotal + #865, #2560
  static mapaTotal + #866, #2560
  static mapaTotal + #867, #2560
  static mapaTotal + #868, #2560
  static mapaTotal + #869, #2560
  static mapaTotal + #870, #2560
  static mapaTotal + #871, #2560
  static mapaTotal + #872, #2560
  static mapaTotal + #873, #2560
  static mapaTotal + #874, #2560
  static mapaTotal + #875, #2560
  static mapaTotal + #876, #2560
  static mapaTotal + #877, #2560
  static mapaTotal + #878, #2560
  static mapaTotal + #879, #2560

  ;Linha 22
  static mapaTotal + #880, #2560
  static mapaTotal + #881, #2560
  static mapaTotal + #882, #2560
  static mapaTotal + #883, #2560
  static mapaTotal + #884, #2560
  static mapaTotal + #885, #2560
  static mapaTotal + #886, #2560
  static mapaTotal + #887, #2560
  static mapaTotal + #888, #2560
  static mapaTotal + #889, #2560
  static mapaTotal + #890, #2560
  static mapaTotal + #891, #2560
  static mapaTotal + #892, #2560
  static mapaTotal + #893, #2560
  static mapaTotal + #894, #2560
  static mapaTotal + #895, #2560
  static mapaTotal + #896, #2560
  static mapaTotal + #897, #2560
  static mapaTotal + #898, #2560
  static mapaTotal + #899, #2560
  static mapaTotal + #900, #2560
  static mapaTotal + #901, #2560
  static mapaTotal + #902, #2560
  static mapaTotal + #903, #2560
  static mapaTotal + #904, #2560
  static mapaTotal + #905, #2560
  static mapaTotal + #906, #2560
  static mapaTotal + #907, #2560
  static mapaTotal + #908, #2560
  static mapaTotal + #909, #2560
  static mapaTotal + #910, #2560
  static mapaTotal + #911, #2560
  static mapaTotal + #912, #2560
  static mapaTotal + #913, #2560
  static mapaTotal + #914, #2560
  static mapaTotal + #915, #2560
  static mapaTotal + #916, #2560
  static mapaTotal + #917, #2560
  static mapaTotal + #918, #2560
  static mapaTotal + #919, #2560

  ;Linha 23
  static mapaTotal + #920, #2560
  static mapaTotal + #921, #2560
  static mapaTotal + #922, #2560
  static mapaTotal + #923, #2048
  static mapaTotal + #924, #2048
  static mapaTotal + #925, #256
  static mapaTotal + #926, #256
  static mapaTotal + #927, #2048
  static mapaTotal + #928, #2560
  static mapaTotal + #929, #2560
  static mapaTotal + #930, #2048
  static mapaTotal + #931, #2048
  static mapaTotal + #932, #2048
  static mapaTotal + #933, #2560
  static mapaTotal + #934, #2560
  static mapaTotal + #935, #256
  static mapaTotal + #936, #256
  static mapaTotal + #937, #256
  static mapaTotal + #938, #256
  static mapaTotal + #939, #256
  static mapaTotal + #940, #256
  static mapaTotal + #941, #256
  static mapaTotal + #942, #256
  static mapaTotal + #943, #256
  static mapaTotal + #944, #256
  static mapaTotal + #945, #256
  static mapaTotal + #946, #256
  static mapaTotal + #947, #256
  static mapaTotal + #948, #256
  static mapaTotal + #949, #256
  static mapaTotal + #950, #256
  static mapaTotal + #951, #2048
  static mapaTotal + #952, #2048
  static mapaTotal + #953, #2048
  static mapaTotal + #954, #2048
  static mapaTotal + #955, #2560
  static mapaTotal + #956, #2560
  static mapaTotal + #957, #2048
  static mapaTotal + #958, #2560
  static mapaTotal + #959, #2560

  ;Linha 24
  static mapaTotal + #960, #2560
  static mapaTotal + #961, #2560
  static mapaTotal + #962, #2560
  static mapaTotal + #963, #2048
  static mapaTotal + #964, #2560
  static mapaTotal + #965, #2560
  static mapaTotal + #966, #2560
  static mapaTotal + #967, #2560
  static mapaTotal + #968, #2560
  static mapaTotal + #969, #2560
  static mapaTotal + #970, #2560
  static mapaTotal + #971, #2560
  static mapaTotal + #972, #2560
  static mapaTotal + #973, #2560
  static mapaTotal + #974, #2560
  static mapaTotal + #975, #2560
  static mapaTotal + #976, #2560
  static mapaTotal + #977, #2560
  static mapaTotal + #978, #2560
  static mapaTotal + #979, #2560
  static mapaTotal + #980, #2560
  static mapaTotal + #981, #2560
  static mapaTotal + #982, #2560
  static mapaTotal + #983, #2560
  static mapaTotal + #984, #2560
  static mapaTotal + #985, #2560
  static mapaTotal + #986, #2560
  static mapaTotal + #987, #2560
  static mapaTotal + #988, #2560
  static mapaTotal + #989, #2560
  static mapaTotal + #990, #2560
  static mapaTotal + #991, #2560
  static mapaTotal + #992, #2560
  static mapaTotal + #993, #2560
  static mapaTotal + #994, #2560
  static mapaTotal + #995, #2560
  static mapaTotal + #996, #2560
  static mapaTotal + #997, #2048
  static mapaTotal + #998, #2560
  static mapaTotal + #999, #2560

  ;Linha 25
  static mapaTotal + #1000, #2560
  static mapaTotal + #1001, #2560
  static mapaTotal + #1002, #2560
  static mapaTotal + #1003, #2048
  static mapaTotal + #1004, #2560
  static mapaTotal + #1005, #2560
  static mapaTotal + #1006, #2560
  static mapaTotal + #1007, #2560
  static mapaTotal + #1008, #2560
  static mapaTotal + #1009, #2560
  static mapaTotal + #1010, #2560
  static mapaTotal + #1011, #2560
  static mapaTotal + #1012, #2560
  static mapaTotal + #1013, #2560
  static mapaTotal + #1014, #2560
  static mapaTotal + #1015, #2560
  static mapaTotal + #1016, #2560
  static mapaTotal + #1017, #2560
  static mapaTotal + #1018, #2560
  static mapaTotal + #1019, #2560
  static mapaTotal + #1020, #2560
  static mapaTotal + #1021, #2560
  static mapaTotal + #1022, #2560
  static mapaTotal + #1023, #2560
  static mapaTotal + #1024, #2560
  static mapaTotal + #1025, #2560
  static mapaTotal + #1026, #2560
  static mapaTotal + #1027, #2560
  static mapaTotal + #1028, #2560
  static mapaTotal + #1029, #2560
  static mapaTotal + #1030, #2560
  static mapaTotal + #1031, #2560
  static mapaTotal + #1032, #2560
  static mapaTotal + #1033, #2560
  static mapaTotal + #1034, #2560
  static mapaTotal + #1035, #2560
  static mapaTotal + #1036, #2560
  static mapaTotal + #1037, #256
  static mapaTotal + #1038, #2560
  static mapaTotal + #1039, #2560

  ;Linha 26
  static mapaTotal + #1040, #2560
  static mapaTotal + #1041, #2560
  static mapaTotal + #1042, #2560
  static mapaTotal + #1043, #2048
  static mapaTotal + #1044, #2560
  static mapaTotal + #1045, #2560
  static mapaTotal + #1046, #2560
  static mapaTotal + #1047, #2048
  static mapaTotal + #1048, #2048
  static mapaTotal + #1049, #256
  static mapaTotal + #1050, #2048
  static mapaTotal + #1051, #2048
  static mapaTotal + #1052, #2048
  static mapaTotal + #1053, #2048
  static mapaTotal + #1054, #2048
  static mapaTotal + #1055, #2048
  static mapaTotal + #1056, #2560
  static mapaTotal + #1057, #2560
  static mapaTotal + #1058, #2560
  static mapaTotal + #1059, #2048
  static mapaTotal + #1060, #2048
  static mapaTotal + #1061, #2048
  static mapaTotal + #1062, #2048
  static mapaTotal + #1063, #2560
  static mapaTotal + #1064, #2560
  static mapaTotal + #1065, #2048
  static mapaTotal + #1066, #2048
  static mapaTotal + #1067, #2048
  static mapaTotal + #1068, #2048
  static mapaTotal + #1069, #2048
  static mapaTotal + #1070, #2560
  static mapaTotal + #1071, #2560
  static mapaTotal + #1072, #2048
  static mapaTotal + #1073, #768
  static mapaTotal + #1074, #2048
  static mapaTotal + #1075, #2048
  static mapaTotal + #1076, #2048
  static mapaTotal + #1077, #256
  static mapaTotal + #1078, #2560
  static mapaTotal + #1079, #2560

  ;Linha 27
  static mapaTotal + #1080, #2560
  static mapaTotal + #1081, #2560
  static mapaTotal + #1082, #2560
  static mapaTotal + #1083, #2048
  static mapaTotal + #1084, #2560
  static mapaTotal + #1085, #2560
  static mapaTotal + #1086, #2560
  static mapaTotal + #1087, #2560
  static mapaTotal + #1088, #2560
  static mapaTotal + #1089, #2560
  static mapaTotal + #1090, #2560
  static mapaTotal + #1091, #2560
  static mapaTotal + #1092, #2560
  static mapaTotal + #1093, #2560
  static mapaTotal + #1094, #2560
  static mapaTotal + #1095, #2560
  static mapaTotal + #1096, #2560
  static mapaTotal + #1097, #2560
  static mapaTotal + #1098, #2560
  static mapaTotal + #1099, #2560
  static mapaTotal + #1100, #2560
  static mapaTotal + #1101, #2560
  static mapaTotal + #1102, #2048
  static mapaTotal + #1103, #2560
  static mapaTotal + #1104, #2560
  static mapaTotal + #1105, #256
  static mapaTotal + #1106, #768
  static mapaTotal + #1107, #256
  static mapaTotal + #1108, #768
  static mapaTotal + #1109, #2048
  static mapaTotal + #1110, #2560
  static mapaTotal + #1111, #2560
  static mapaTotal + #1112, #2560
  static mapaTotal + #1113, #2560
  static mapaTotal + #1114, #2560
  static mapaTotal + #1115, #2560
  static mapaTotal + #1116, #2560
  static mapaTotal + #1117, #2560
  static mapaTotal + #1118, #2560
  static mapaTotal + #1119, #2560

  ;Linha 28
  static mapaTotal + #1120, #2560
  static mapaTotal + #1121, #2560
  static mapaTotal + #1122, #2560
  static mapaTotal + #1123, #2048
  static mapaTotal + #1124, #2560
  static mapaTotal + #1125, #2560
  static mapaTotal + #1126, #2560
  static mapaTotal + #1127, #2560
  static mapaTotal + #1128, #2560
  static mapaTotal + #1129, #2560
  static mapaTotal + #1130, #2560
  static mapaTotal + #1131, #2560
  static mapaTotal + #1132, #2560
  static mapaTotal + #1133, #2560
  static mapaTotal + #1134, #2560
  static mapaTotal + #1135, #2560
  static mapaTotal + #1136, #2560
  static mapaTotal + #1137, #2560
  static mapaTotal + #1138, #2560
  static mapaTotal + #1139, #2560
  static mapaTotal + #1140, #2560
  static mapaTotal + #1141, #2560
  static mapaTotal + #1142, #2048
  static mapaTotal + #1143, #2560
  static mapaTotal + #1144, #2560
  static mapaTotal + #1145, #2560
  static mapaTotal + #1146, #2560
  static mapaTotal + #1147, #2560
  static mapaTotal + #1148, #2560
  static mapaTotal + #1149, #2048
  static mapaTotal + #1150, #2560
  static mapaTotal + #1151, #2560
  static mapaTotal + #1152, #2560
  static mapaTotal + #1153, #2560
  static mapaTotal + #1154, #2560
  static mapaTotal + #1155, #2560
  static mapaTotal + #1156, #2560
  static mapaTotal + #1157, #2560
  static mapaTotal + #1158, #2560
  static mapaTotal + #1159, #2560

  ;Linha 29
  static mapaTotal + #1160, #2560
  static mapaTotal + #1161, #2560
  static mapaTotal + #1162, #2560
  static mapaTotal + #1163, #2048
  static mapaTotal + #1164, #2560
  static mapaTotal + #1165, #2560
  static mapaTotal + #1166, #2560
  static mapaTotal + #1167, #2816
  static mapaTotal + #1168, #2816
  static mapaTotal + #1169, #2816
  static mapaTotal + #1170, #2816
  static mapaTotal + #1171, #2816
  static mapaTotal + #1172, #2816
  static mapaTotal + #1173, #2560
  static mapaTotal + #1174, #2560
  static mapaTotal + #1175, #2560
  static mapaTotal + #1176, #256
  static mapaTotal + #1177, #2560
  static mapaTotal + #1178, #2560
  static mapaTotal + #1179, #2048
  static mapaTotal + #1180, #2560
  static mapaTotal + #1181, #2560
  static mapaTotal + #1182, #2048
  static mapaTotal + #1183, #2560
  static mapaTotal + #1184, #2560
  static mapaTotal + #1185, #2560
  static mapaTotal + #1186, #2560
  static mapaTotal + #1187, #2560
  static mapaTotal + #1188, #2560
  static mapaTotal + #1189, #2048
  static mapaTotal + #1190, #2560
  static mapaTotal + #1191, #2560
  static mapaTotal + #1192, #2560
  static mapaTotal + #1193, #2560
  static mapaTotal + #1194, #2560
  static mapaTotal + #1195, #2560
  static mapaTotal + #1196, #2560
  static mapaTotal + #1197, #2560
  static mapaTotal + #1198, #2560
  static mapaTotal + #1199, #2560

  ;Linha 30
  static mapaTotal + #1200, #2560
  static mapaTotal + #1201, #2560
  static mapaTotal + #1202, #2560
  static mapaTotal + #1203, #2048
  static mapaTotal + #1204, #2560
  static mapaTotal + #1205, #2560
  static mapaTotal + #1206, #2816
  static mapaTotal + #1207, #256
  static mapaTotal + #1208, #2816
  static mapaTotal + #1209, #2816
  static mapaTotal + #1210, #2816
  static mapaTotal + #1211, #2816
  static mapaTotal + #1212, #2816
  static mapaTotal + #1213, #2816
  static mapaTotal + #1214, #2560
  static mapaTotal + #1215, #2560
  static mapaTotal + #1216, #256
  static mapaTotal + #1217, #2560
  static mapaTotal + #1218, #2560
  static mapaTotal + #1219, #2048
  static mapaTotal + #1220, #2560
  static mapaTotal + #1221, #2560
  static mapaTotal + #1222, #2048
  static mapaTotal + #1223, #2048
  static mapaTotal + #1224, #2048
  static mapaTotal + #1225, #2048
  static mapaTotal + #1226, #2048
  static mapaTotal + #1227, #2560
  static mapaTotal + #1228, #2560
  static mapaTotal + #1229, #2048
  static mapaTotal + #1230, #2048
  static mapaTotal + #1231, #2048
  static mapaTotal + #1232, #2048
  static mapaTotal + #1233, #2048
  static mapaTotal + #1234, #2048
  static mapaTotal + #1235, #2560
  static mapaTotal + #1236, #2560
  static mapaTotal + #1237, #2048
  static mapaTotal + #1238, #2560
  static mapaTotal + #1239, #2560

  ;Linha 31
  static mapaTotal + #1240, #2560
  static mapaTotal + #1241, #2560
  static mapaTotal + #1242, #2560
  static mapaTotal + #1243, #2048
  static mapaTotal + #1244, #2560
  static mapaTotal + #1245, #2560
  static mapaTotal + #1246, #2816
  static mapaTotal + #1247, #256
  static mapaTotal + #1248, #2816
  static mapaTotal + #1249, #256
  static mapaTotal + #1250, #2816
  static mapaTotal + #1251, #2816
  static mapaTotal + #1252, #256
  static mapaTotal + #1253, #2816
  static mapaTotal + #1254, #2560
  static mapaTotal + #1255, #2560
  static mapaTotal + #1256, #256
  static mapaTotal + #1257, #2560
  static mapaTotal + #1258, #2560
  static mapaTotal + #1259, #2048
  static mapaTotal + #1260, #2560
  static mapaTotal + #1261, #2560
  static mapaTotal + #1262, #2560
  static mapaTotal + #1263, #2560
  static mapaTotal + #1264, #2560
  static mapaTotal + #1265, #2560
  static mapaTotal + #1266, #768
  static mapaTotal + #1267, #2560
  static mapaTotal + #1268, #2560
  static mapaTotal + #1269, #2048
  static mapaTotal + #1270, #2560
  static mapaTotal + #1271, #2560
  static mapaTotal + #1272, #2560
  static mapaTotal + #1273, #2560
  static mapaTotal + #1274, #2560
  static mapaTotal + #1275, #2560
  static mapaTotal + #1276, #2560
  static mapaTotal + #1277, #2048
  static mapaTotal + #1278, #2560
  static mapaTotal + #1279, #2560

  ;Linha 32
  static mapaTotal + #1280, #2560
  static mapaTotal + #1281, #2560
  static mapaTotal + #1282, #2560
  static mapaTotal + #1283, #2048
  static mapaTotal + #1284, #2560
  static mapaTotal + #1285, #2560
  static mapaTotal + #1286, #2816
  static mapaTotal + #1287, #2816
  static mapaTotal + #1288, #256
  static mapaTotal + #1289, #2816
  static mapaTotal + #1290, #2816
  static mapaTotal + #1291, #256
  static mapaTotal + #1292, #2816
  static mapaTotal + #1293, #2816
  static mapaTotal + #1294, #2560
  static mapaTotal + #1295, #2560
  static mapaTotal + #1296, #256
  static mapaTotal + #1297, #2560
  static mapaTotal + #1298, #2560
  static mapaTotal + #1299, #2048
  static mapaTotal + #1300, #2560
  static mapaTotal + #1301, #2560
  static mapaTotal + #1302, #2560
  static mapaTotal + #1303, #2560
  static mapaTotal + #1304, #2560
  static mapaTotal + #1305, #2560
  static mapaTotal + #1306, #2048
  static mapaTotal + #1307, #2560
  static mapaTotal + #1308, #2560
  static mapaTotal + #1309, #2048
  static mapaTotal + #1310, #2560
  static mapaTotal + #1311, #2560
  static mapaTotal + #1312, #2560
  static mapaTotal + #1313, #2560
  static mapaTotal + #1314, #2560
  static mapaTotal + #1315, #2560
  static mapaTotal + #1316, #2560
  static mapaTotal + #1317, #2048
  static mapaTotal + #1318, #2560
  static mapaTotal + #1319, #2560

  ;Linha 33
  static mapaTotal + #1320, #2560
  static mapaTotal + #1321, #2560
  static mapaTotal + #1322, #2560
  static mapaTotal + #1323, #256
  static mapaTotal + #1324, #2560
  static mapaTotal + #1325, #2560
  static mapaTotal + #1326, #2560
  static mapaTotal + #1327, #2816
  static mapaTotal + #1328, #2816
  static mapaTotal + #1329, #2816
  static mapaTotal + #1330, #2816
  static mapaTotal + #1331, #2816
  static mapaTotal + #1332, #2816
  static mapaTotal + #1333, #2560
  static mapaTotal + #1334, #2560
  static mapaTotal + #1335, #2560
  static mapaTotal + #1336, #256
  static mapaTotal + #1337, #2560
  static mapaTotal + #1338, #2560
  static mapaTotal + #1339, #2048
  static mapaTotal + #1340, #2048
  static mapaTotal + #1341, #2048
  static mapaTotal + #1342, #2048
  static mapaTotal + #1343, #2048
  static mapaTotal + #1344, #2560
  static mapaTotal + #1345, #2560
  static mapaTotal + #1346, #2048
  static mapaTotal + #1347, #2560
  static mapaTotal + #1348, #2560
  static mapaTotal + #1349, #2048
  static mapaTotal + #1350, #2560
  static mapaTotal + #1351, #2560
  static mapaTotal + #1352, #2560
  static mapaTotal + #1353, #2560
  static mapaTotal + #1354, #2816
  static mapaTotal + #1355, #2816
  static mapaTotal + #1356, #2816
  static mapaTotal + #1357, #2048
  static mapaTotal + #1358, #2560
  static mapaTotal + #1359, #2560

  ;Linha 34
  static mapaTotal + #1360, #2560
  static mapaTotal + #1361, #2560
  static mapaTotal + #1362, #2560
  static mapaTotal + #1363, #2560
  static mapaTotal + #1364, #2560
  static mapaTotal + #1365, #2560
  static mapaTotal + #1366, #2560
  static mapaTotal + #1367, #2560
  static mapaTotal + #1368, #2560
  static mapaTotal + #1369, #2560
  static mapaTotal + #1370, #2560
  static mapaTotal + #1371, #2560
  static mapaTotal + #1372, #2560
  static mapaTotal + #1373, #2560
  static mapaTotal + #1374, #2560
  static mapaTotal + #1375, #2560
  static mapaTotal + #1376, #2560
  static mapaTotal + #1377, #2560
  static mapaTotal + #1378, #2560
  static mapaTotal + #1379, #2048
  static mapaTotal + #1380, #256
  static mapaTotal + #1381, #2560
  static mapaTotal + #1382, #2560
  static mapaTotal + #1383, #2560
  static mapaTotal + #1384, #2560
  static mapaTotal + #1385, #2560
  static mapaTotal + #1386, #2560
  static mapaTotal + #1387, #2560
  static mapaTotal + #1388, #2560
  static mapaTotal + #1389, #2560
  static mapaTotal + #1390, #2560
  static mapaTotal + #1391, #2560
  static mapaTotal + #1392, #2560
  static mapaTotal + #1393, #2816
  static mapaTotal + #1394, #2816
  static mapaTotal + #1395, #256
  static mapaTotal + #1396, #256
  static mapaTotal + #1397, #2048
  static mapaTotal + #1398, #2560
  static mapaTotal + #1399, #2560

  ;Linha 35
  static mapaTotal + #1400, #2560
  static mapaTotal + #1401, #2560
  static mapaTotal + #1402, #2560
  static mapaTotal + #1403, #2560
  static mapaTotal + #1404, #2560
  static mapaTotal + #1405, #2560
  static mapaTotal + #1406, #2560
  static mapaTotal + #1407, #2560
  static mapaTotal + #1408, #2560
  static mapaTotal + #1409, #2560
  static mapaTotal + #1410, #2560
  static mapaTotal + #1411, #2560
  static mapaTotal + #1412, #2560
  static mapaTotal + #1413, #2560
  static mapaTotal + #1414, #2560
  static mapaTotal + #1415, #2560
  static mapaTotal + #1416, #2560
  static mapaTotal + #1417, #2560
  static mapaTotal + #1418, #2560
  static mapaTotal + #1419, #2048
  static mapaTotal + #1420, #256
  static mapaTotal + #1421, #2560
  static mapaTotal + #1422, #2560
  static mapaTotal + #1423, #2560
  static mapaTotal + #1424, #2560
  static mapaTotal + #1425, #2560
  static mapaTotal + #1426, #2560
  static mapaTotal + #1427, #2560
  static mapaTotal + #1428, #2560
  static mapaTotal + #1429, #2560
  static mapaTotal + #1430, #2560
  static mapaTotal + #1431, #2560
  static mapaTotal + #1432, #2560
  static mapaTotal + #1433, #2816
  static mapaTotal + #1434, #256
  static mapaTotal + #1435, #2816
  static mapaTotal + #1436, #2816
  static mapaTotal + #1437, #2048
  static mapaTotal + #1438, #2560
  static mapaTotal + #1439, #2560

  ;Linha 36
  static mapaTotal + #1440, #2560
  static mapaTotal + #1441, #2560
  static mapaTotal + #1442, #2560
  static mapaTotal + #1443, #2048
  static mapaTotal + #1444, #2560
  static mapaTotal + #1445, #2560
  static mapaTotal + #1446, #2560
  static mapaTotal + #1447, #2048
  static mapaTotal + #1448, #2048
  static mapaTotal + #1449, #2048
  static mapaTotal + #1450, #2048
  static mapaTotal + #1451, #2048
  static mapaTotal + #1452, #2048
  static mapaTotal + #1453, #2048
  static mapaTotal + #1454, #2048
  static mapaTotal + #1455, #2048
  static mapaTotal + #1456, #2048
  static mapaTotal + #1457, #2048
  static mapaTotal + #1458, #2048
  static mapaTotal + #1459, #256
  static mapaTotal + #1460, #256
  static mapaTotal + #1461, #2560
  static mapaTotal + #1462, #2560
  static mapaTotal + #1463, #256
  static mapaTotal + #1464, #2048
  static mapaTotal + #1465, #2560
  static mapaTotal + #1466, #2560
  static mapaTotal + #1467, #2560
  static mapaTotal + #1468, #2560
  static mapaTotal + #1469, #2560
  static mapaTotal + #1470, #2560
  static mapaTotal + #1471, #2048
  static mapaTotal + #1472, #2048
  static mapaTotal + #1473, #2048
  static mapaTotal + #1474, #2048
  static mapaTotal + #1475, #2048
  static mapaTotal + #1476, #2048
  static mapaTotal + #1477, #2048
  static mapaTotal + #1478, #2560
  static mapaTotal + #1479, #2560

  ;Linha 37
  static mapaTotal + #1480, #2560
  static mapaTotal + #1481, #2560
  static mapaTotal + #1482, #2560
  static mapaTotal + #1483, #2048
  static mapaTotal + #1484, #2560
  static mapaTotal + #1485, #2560
  static mapaTotal + #1486, #2560
  static mapaTotal + #1487, #2560
  static mapaTotal + #1488, #2560
  static mapaTotal + #1489, #2560
  static mapaTotal + #1490, #2560
  static mapaTotal + #1491, #2560
  static mapaTotal + #1492, #2560
  static mapaTotal + #1493, #2560
  static mapaTotal + #1494, #2560
  static mapaTotal + #1495, #2560
  static mapaTotal + #1496, #2560
  static mapaTotal + #1497, #2560
  static mapaTotal + #1498, #2560
  static mapaTotal + #1499, #2560
  static mapaTotal + #1500, #2560
  static mapaTotal + #1501, #2560
  static mapaTotal + #1502, #2560
  static mapaTotal + #1503, #768
  static mapaTotal + #1504, #2048
  static mapaTotal + #1505, #2560
  static mapaTotal + #1506, #2560
  static mapaTotal + #1507, #2560
  static mapaTotal + #1508, #2560
  static mapaTotal + #1509, #2560
  static mapaTotal + #1510, #2560
  static mapaTotal + #1511, #2560
  static mapaTotal + #1512, #2560
  static mapaTotal + #1513, #2560
  static mapaTotal + #1514, #2560
  static mapaTotal + #1515, #2560
  static mapaTotal + #1516, #2560
  static mapaTotal + #1517, #2048
  static mapaTotal + #1518, #2560
  static mapaTotal + #1519, #2560

  ;Linha 38
  static mapaTotal + #1520, #2560
  static mapaTotal + #1521, #2560
  static mapaTotal + #1522, #2560
  static mapaTotal + #1523, #2048
  static mapaTotal + #1524, #2560
  static mapaTotal + #1525, #2560
  static mapaTotal + #1526, #2560
  static mapaTotal + #1527, #2560
  static mapaTotal + #1528, #2560
  static mapaTotal + #1529, #2560
  static mapaTotal + #1530, #2560
  static mapaTotal + #1531, #2560
  static mapaTotal + #1532, #2560
  static mapaTotal + #1533, #2560
  static mapaTotal + #1534, #2560
  static mapaTotal + #1535, #2560
  static mapaTotal + #1536, #2560
  static mapaTotal + #1537, #2560
  static mapaTotal + #1538, #2560
  static mapaTotal + #1539, #2560
  static mapaTotal + #1540, #2560
  static mapaTotal + #1541, #2560
  static mapaTotal + #1542, #2560
  static mapaTotal + #1543, #256
  static mapaTotal + #1544, #2048
  static mapaTotal + #1545, #2048
  static mapaTotal + #1546, #2048
  static mapaTotal + #1547, #2048
  static mapaTotal + #1548, #2560
  static mapaTotal + #1549, #2560
  static mapaTotal + #1550, #2560
  static mapaTotal + #1551, #2560
  static mapaTotal + #1552, #2560
  static mapaTotal + #1553, #2560
  static mapaTotal + #1554, #2560
  static mapaTotal + #1555, #2560
  static mapaTotal + #1556, #2560
  static mapaTotal + #1557, #2048
  static mapaTotal + #1558, #2560
  static mapaTotal + #1559, #2560

  ;Linha 39
  static mapaTotal + #1560, #2560
  static mapaTotal + #1561, #2560
  static mapaTotal + #1562, #2560
  static mapaTotal + #1563, #2048
  static mapaTotal + #1564, #2560
  static mapaTotal + #1565, #2560
  static mapaTotal + #1566, #256
  static mapaTotal + #1567, #256
  static mapaTotal + #1568, #256
  static mapaTotal + #1569, #256
  static mapaTotal + #1570, #256
  static mapaTotal + #1571, #256
  static mapaTotal + #1572, #256
  static mapaTotal + #1573, #256
  static mapaTotal + #1574, #256
  static mapaTotal + #1575, #256
  static mapaTotal + #1576, #256
  static mapaTotal + #1577, #256
  static mapaTotal + #1578, #256
  static mapaTotal + #1579, #256
  static mapaTotal + #1580, #2560
  static mapaTotal + #1581, #2560
  static mapaTotal + #1582, #2560
  static mapaTotal + #1583, #768
  static mapaTotal + #1584, #2048
  static mapaTotal + #1585, #2560
  static mapaTotal + #1586, #2560
  static mapaTotal + #1587, #2560
  static mapaTotal + #1588, #2560
  static mapaTotal + #1589, #2560
  static mapaTotal + #1590, #2560
  static mapaTotal + #1591, #2560
  static mapaTotal + #1592, #2560
  static mapaTotal + #1593, #2048
  static mapaTotal + #1594, #2048
  static mapaTotal + #1595, #2048
  static mapaTotal + #1596, #2048
  static mapaTotal + #1597, #2048
  static mapaTotal + #1598, #2560
  static mapaTotal + #1599, #2560

  ;Linha 40
  static mapaTotal + #1600, #2560
  static mapaTotal + #1601, #2560
  static mapaTotal + #1602, #2560
  static mapaTotal + #1603, #2560
  static mapaTotal + #1604, #2560
  static mapaTotal + #1605, #2560
  static mapaTotal + #1606, #2560
  static mapaTotal + #1607, #2560
  static mapaTotal + #1608, #2560
  static mapaTotal + #1609, #2560
  static mapaTotal + #1610, #2560
  static mapaTotal + #1611, #2560
  static mapaTotal + #1612, #2560
  static mapaTotal + #1613, #2560
  static mapaTotal + #1614, #2560
  static mapaTotal + #1615, #2560
  static mapaTotal + #1616, #2560
  static mapaTotal + #1617, #2560
  static mapaTotal + #1618, #2560
  static mapaTotal + #1619, #2560
  static mapaTotal + #1620, #2560
  static mapaTotal + #1621, #2560
  static mapaTotal + #1622, #2560
  static mapaTotal + #1623, #2560
  static mapaTotal + #1624, #2560
  static mapaTotal + #1625, #2560
  static mapaTotal + #1626, #2560
  static mapaTotal + #1627, #2560
  static mapaTotal + #1628, #2560
  static mapaTotal + #1629, #2560
  static mapaTotal + #1630, #2560
  static mapaTotal + #1631, #2560
  static mapaTotal + #1632, #2560
  static mapaTotal + #1633, #2560
  static mapaTotal + #1634, #2560
  static mapaTotal + #1635, #2560
  static mapaTotal + #1636, #2560
  static mapaTotal + #1637, #2560
  static mapaTotal + #1638, #2560
  static mapaTotal + #1639, #2560

  ;Linha 41
  static mapaTotal + #1640, #2560
  static mapaTotal + #1641, #2560
  static mapaTotal + #1642, #2560
  static mapaTotal + #1643, #2560
  static mapaTotal + #1644, #2560
  static mapaTotal + #1645, #2560
  static mapaTotal + #1646, #2560
  static mapaTotal + #1647, #2560
  static mapaTotal + #1648, #2560
  static mapaTotal + #1649, #2560
  static mapaTotal + #1650, #2560
  static mapaTotal + #1651, #2560
  static mapaTotal + #1652, #2560
  static mapaTotal + #1653, #2560
  static mapaTotal + #1654, #2560
  static mapaTotal + #1655, #2560
  static mapaTotal + #1656, #2560
  static mapaTotal + #1657, #2560
  static mapaTotal + #1658, #2560
  static mapaTotal + #1659, #2560
  static mapaTotal + #1660, #2560
  static mapaTotal + #1661, #2560
  static mapaTotal + #1662, #2560
  static mapaTotal + #1663, #2560
  static mapaTotal + #1664, #2560
  static mapaTotal + #1665, #2560
  static mapaTotal + #1666, #2560
  static mapaTotal + #1667, #2560
  static mapaTotal + #1668, #2560
  static mapaTotal + #1669, #2560
  static mapaTotal + #1670, #2560
  static mapaTotal + #1671, #2560
  static mapaTotal + #1672, #2560
  static mapaTotal + #1673, #2560
  static mapaTotal + #1674, #2560
  static mapaTotal + #1675, #2560
  static mapaTotal + #1676, #2560
  static mapaTotal + #1677, #2560
  static mapaTotal + #1678, #2560
  static mapaTotal + #1679, #2560
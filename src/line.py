def drawLine(xmob, ymob, xplayer, yplayer):
    if abs(xplayer - xmob) > abs(yplayer - ymob):
        drawLineH(xmob, ymob, xplayer, yplayer)
    else:
        drawLineV(xmob, ymob, xplayer, yplayer)

def drawLineH(xmob, ymob, xplayer, yplayer):
    if xmob > xplayer:
        xmob, xplayer = xplayer, xmob
        ymob, yplayer = yplayer, ymob

    dx = xplayer - xmob
    dy = yplayer - ymob

    dir = -1 if dy < 0 else 1
    dy *= dir

    if dx != 0:
        y = ymob
        p = 2*dy - dx
        for i in range(dx+1):
            print(xmob + i, y)
            #putPixel(xmob + i, y)
            
            #if mapProp == 1:
             #   bool = False
              #  jmp fora

            if p >= 0:
                y += dir
                p = p - 2*dx
            p = p + 2*dy
    #bool = True

def drawLineV(xmob, ymob, xplayer, yplayer):
    if ymob > yplayer:
        xmob, xplayer = xplayer, xmob
        ymob, yplayer = yplayer, ymob
    
    # PRINTAR X Y 
    dx = xplayer - xmob
    dy = yplayer - ymob

    dir = -1 if dx < 0 else 1
    dx *= dir

    if dy != 0:
        x = xmob
        p = 2*dx - dy
        for i in range(dy +1):
            print(x, ymob+i)
            #putPixel(x, ymob + i)
            #if mapProp == 1:
             #   bool = False
              #  jmp fora

            if p >= 0:
                x += dir
                p = p - 2*dy
            p = p + 2*dx
    else: # straight line
        for i in range(dy +1):
            print(x, ymob+i)
            #putPixel(x, ymob + i)
            #if mapProp == 1:
             #   bool = False
              #  jmp fora
    #bool = true

drawLine(26, 19, 28, 15)
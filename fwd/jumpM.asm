IDEAL
MODEL small
p186
STACK 0f500h
MAX_BMP_WIDTH = 320
MAX_BMP_HEIGHT = 200

SMALL_BMP_HEIGHT = 40
SMALL_BMP_WIDTH = 40

DATASEG
    Clock equ es:6Ch
    OneBmpLine 	db MAX_BMP_WIDTH dup (0)  ; One Color line read buffer
    ScreenLineMax 	db MAX_BMP_WIDTH dup (0)  ; One Color line read buffer
    ;BMP File data
    FileHandle	dw ?
    Header 	    db 54 dup(0)
    Palette 	db 400h dup (0)
    picMain db 'mainJ.bmp',0
    picIns db 'inst.bmp',0
    picG db 'Gamef.bmp',0
    picGa2 db 'Gamef-2.bmp',0
    picJ db 'wPlayer.bmp',0
    picB db 'blackS.bmp',0
    picJL db 'wPlayerL.bmp',0
    picE1 db 'p1.bmp',0
    picE2 db 'p2.bmp',0
    picE3 db 'p3.bmp',0
    picE4 db 'p4.bmp',0
    picE5 db 'p5.bmp',0
    picE6 db 'p6.bmp',0
    picE7 db 'p7.bmp',0
    picK1 db 'fG1.bmp',0
    picK2 db 'fG2.bmp',0
    picK3 db 'fG3.bmp',0
    picK4 db 'fG4.bmp',0
    picG1 db 'g1.bmp',0
    picG2 db 'g2.bmp',0
    picG3 db 'g3.bmp',0
    picG4 db 'g4.bmp',0
    picG5 db 'g5.bmp',0
    picG6 db 'g6.bmp',0
    picG7 db 'g7.bmp',0
    picG8 db 'g8.bmp',0
    picG9 db 'g9.bmp',0
    picG10 db 'g10.bmp',0
    picG11 db 'g11.bmp',0
    picG12 db 'g12.bmp',0
    picG13 db 'g13.bmp',0
    Opic dw ?
    topX dw ?
    topY dw ?
    topXp dw ?
    topYp dw ?
    botX dw ?
    botY dw ?
    lengthX dw ?
    lengthY dw ?
    check dw 0
    playerX dw 11
    playerY dw 79
    keyRight db 1
    keyLeft db 0
    greenUp db 0
    greenBot db 1
    greenRight db 0
    greenLeft db 0
    endFlag db 0
    counter db 0
    
    BmpFileErrorMsg    	db 'Error At Opening Bmp File .', 0dh, 0ah,'$'
    ErrorFile           db 0
    
    BmpLeft dw ?
    BmpTop dw ?
    BmpColSize dw ?
    BmpRowSize dw ?	
    x db 10
CODESEG
start:
    mov ax, @data
    mov ds, ax
    call SetGraphic
    call startG

    
    
exit:
    
    mov ah,0
    int 16h
    mov ax,2
    int 10h
    
    mov ax, 4c00h
    int 21h	
;========================
;==========================
;===== Procedures  Area ===
;==========================
;==========================
proc startG                                      ; פונקציית תחילת המשחק המציגה את המסך הראשי ועושה קלט ופעולות לפי הקלט
 mov [counter],0
 mov bx,offset picMain
 mov [Opic],bx
 mov [topXp],0
 mov [topYp],0
 mov [lengthX],320
 mov [lengthY],200
 call ppic1
 call showMouse
loopStart:
 call getMouse
 mov [topX],113
 mov [topY],93
 mov [botX],202
 mov [botY],114
 call limits
 cmp [check],1
 jne cIns
 mov [check],0
 call dMouse
 call theGame
cIns:
 mov [topX],60
 mov [topY],137
 mov [botX],257
 mov [botY],158
 call limits
 cmp [check],1
 jne nFound
 mov [check],0
 call dMouse
 call Instructions
 nFound:
 jmp loopStart
ret
endp startG

proc Instructions                                ;פונקציית ההוראות המציגה את מסך ההוראות וקולטת על ידי עכבר האם לחזור למסך הראשי
 mov bx,offset picIns
 mov [Opic],bx
 mov [topXp],0
 mov [topYp],0
 mov [lengthX],320
 mov [lengthY],200
 call ppic1
 call showMouse
loopIns:
 call getMouse
 mov [topX],132
 mov [topY],162
 mov [botX],183
 mov [botY],171
 call limits
 cmp [check],1
 jne loopIns
 mov [check],0
 call dMouse
 call startG
ret 
endp Instructions

proc printK                                                                               ; פונקצייה המדפיסה את גיף הניצחון
 mov [topXp],0
 mov [topYp],0
 mov [lengthX],320
 mov [lengthY],200
 mov [Opic],offset picK1
 call ppic1
 call countsec
 mov [Opic],offset picK2
 call ppic1
 call countsec
 mov [Opic],offset picK3
 call ppic1
 call countsec
 mov [Opic],offset picK4
 call ppic1
 ret 
endp printK

proc won                     ;פונקצייה הבודקת האם הגעת לנקודת הסיום ואם כן האם אתה צריך לעבור שלב או לנצח את המשחק ופעולם בהתאם
 cmp [playerX],296
 jne sofWon
 cmp [playerY],114
 jne sofWon
 cmp [counter],1
 jne plusC
 mov [playerX],11
 mov [playerY],79
 call dMouse
 mov cx,10
loopWon: 
 call printK
 call countsec
 loop loopWon
 call startG
 jmp sofWon
plusC:
 inc [counter]
 mov [playerX],11
 mov [playerY],79
 call theGame
sofWon: 
 ret 
endp won

proc printExp                                                                                ;פונקציה המדפיסה גיף פיצוץ 
 mov ax,[playerX]
 mov [topXp],ax
 mov ax,[playerY]
 mov [topYp],ax
 mov [lengthX],14
 mov [lengthY],14
 mov [Opic],offset picE1
 call ppic1
 call countsec
 mov [Opic],offset picE2
 call ppic1
 call countsec
 mov [Opic],offset picE3
 call ppic1
 call countsec
 mov [Opic],offset picE4
 call ppic1
 call countsec
 mov [Opic],offset picE5
 call ppic1
 call countsec
 mov [Opic],offset picE6
 call ppic1
 call countsec 
 mov [Opic],offset picE7
 call ppic1
 call countsec
 call clearPlayer
 ret 
endp printExp

proc GameO                                                                           ;פונקציה המדפיסה גיף של סיום המשחק
 mov [topXp],0
 mov [topYp],0
 mov [lengthX],320
 mov [lengthY],200
 mov [Opic],offset picG1
 call ppic1
 call countsec
 mov [Opic],offset picG2
 call ppic1
 call countsec
 mov [Opic],offset picG3
 call ppic1
 call countsec
 mov [Opic],offset picG4
 call ppic1
 call countsec
 mov [Opic],offset picG5
 call ppic1
 call countsec
 mov [Opic],offset picG6
 call ppic1
 call countsec 
 mov [Opic],offset picG7
 call ppic1
 call countsec
 mov [Opic],offset picG8
 call ppic1
 call countsec
 mov [Opic],offset picG9
 call ppic1
 call countsec
 mov [Opic],offset picG10
 call ppic1
 call countsec
 mov [Opic],offset picG11
 call ppic1
 call countsec
 mov [Opic],offset picG12
 call ppic1
 call countsec
 mov cx,20
loopGOf:
 mov [Opic],offset picG13
 call ppic1
 call countsec
 loop loopGof
 ret
endp GameO

proc endOfGame                                                                            ;פונקציית סיום המשחק שמוחקת  את השחקן ואת קוראת לפיצוץ ואחרי זה מעדכנת את השחקן והערכים ההתחלתיים שלו וקוראת לפונקציה הראשית  
 call clearPlayer  
 call printExp
 mov [playerX],11
 mov [playerY],79
 call GameO
 call dMouse
 call startG
 ret
endp endOfGame

proc colorUp                   ;פונקצייה הבודקת את הצבעים בצד למעלה של הדמות ואם זה אדום מסיימת את המשחק ואם יש ירוק אז greenUp=1
pusha
 mov cx,[playerX]
 mov dx,[playerY]
 sub dx,1
 mov bx,14
loopColorUp:
 mov ah,0dh
 int 10h
 cmp al,0dh
 jne checkGreenUp
 call clearPlayer
call endOfGame
 jmp sofUp
checkGreenUp:
 cmp al,18h
 jne checkBxLoopUp
 mov [greenUp],1
checkBxLoopUp:
 cmp bx,0
 je sofUp
 dec bx
 inc cx
 jmp loopColorUp
sofUp:
popa
 ret 
endp colorUp

proc colorBot                  ;פונקציה הבודקת את הצבעים בצד למעלה של הדמות ואם זה אדום מסיימת את המשחק ואם יש ירוק אז greenBot=1
pusha
 mov cx,[playerX]
 mov dx,[playerY]
 add dx,19
 mov bx,14
loopColorBot:
 mov ah,0dh
 int 10h
 cmp al,0dh
 jne checkGreenBot
 cmp [endFlag],1
 jne nextBot
 call startG
nextBot:
 call clearPlayer
 call endOfGame
 jmp sofBot
checkGreenBot:
 cmp al,18h
 jne checkBxLoopBot
 mov [greenBot],1
checkBxLoopBot:
 cmp bx,0
 je sofBot
 dec bx
 inc cx
 jmp loopColorBot
sofBot:
popa
 ret
endp colorBot

proc colorRight           ;פונקציה הבודקת את הצבעים בצד ימין של התמונה ואם יש אדום אז מסיימת את המשחק ואם יש ירוק אז greenRight=1
pusha
 mov cx,[playerX]
 mov dx,[playerY]
 add cx,15
 mov bx,18
loopColorRight:
 mov ah,0dh
 int 10h
 cmp al,0dh
 jne checkGreenRight
 call clearPlayer
 call endOfGame
 jmp sofRight
checkGreenRight:
 cmp al,18h
 jne checkBxLoopRight
 mov [greenRight],1
checkBxLoopRight:
 cmp bx,0
 je sofRight
 dec bx
 inc dx
 jmp loopColorRight
sofRight:
popa
 ret 
endp colorRight

proc colorLeft               ;פונקציה הבודקת את הצבעים של הדמות בצד שמאל ואם יש אדום אז מסיימת את המשחק ואם יש ירוק אז greenLeft=1
pusha 
 mov cx,[playerX]
 mov dx,[playerY]
 dec cx
 mov bx,18
loopColorLeft:
 mov ah,0dh
 int 10h
 cmp al,0dh
 jne checkGreenLeft
 call clearPlayer
 call endOfGame
 jmp sofLeft
checkGreenLeft:
 cmp al,18h
 jne checkBxLoopLeft
 mov [greenLeft],1
checkBxLoopLeft:
 cmp bx,0
 je sofLeft
 dec bx 
 inc dx
 jmp loopColorLeft
sofLeft:
popa
 ret
endp colorLeft

proc theGame              ;פונקציית המשחק שלפי קאונטר יודעת לאיזה שלב לגשת ומדפיסה אתה הדמות בנקודת הפתיחה וקוראת לפונקצית המקשים
 cmp [counter],0
 jne game2
 call screenGame
 jmp printScreen
game2:
 call screenGame2
printScreen:
 call ppic1
 call showPlayer
 call Key
ret 
endp theGame
 
proc printRight                                                                   ;פונקציה המדפיסה אתה הדמות לכיוון ימין
 mov bx,offset picJ
 mov [Opic],bx
 mov ax,[playerX]
 mov [topXp],ax
 mov ax,[playerY]
 mov [topYp],ax
 mov [lengthX],14
 mov [lengthY],18
 call ppic1
 ret
endp printRight

proc printLeft                                                                    ;פונקציה המדפיסה את הדמות לכיוון שמאל
mov bx,offset picJL
 mov [Opic],bx
 mov ax,[playerX]
 mov [topXp],ax
 mov ax,[playerY]
 mov [topYp],ax
 mov [lengthX],14
 mov [lengthY],18
 call ppic1
 ret 
endp printLeft

proc Key;פונקציה הקולטת מקשים ועובדת רק עם מקשי החיצים(למעלה,ימין ושמאל)ואז אם זה ימינה בודקת שאין ירוק מימין ואם זה שמאלה בודקת שאין ירוק משמאל ואם לא אז מזיזה אותם פיקסל אחד בהתאם ואם זה למעלה בודקת איזה מקש נלחץ קודם וקוראת לפונקצית הפרבולה המתאימה
WaitForData :
 call zeroFlags
 mov ah, 1
 Int 16h
 jz WaitForData
 mov ah, 0
 int 16h
 cmp ah,'d'
  jne checkRed
 mov [counter],1
 call won
checkRed:
 cmp ah, 4dh;right
 jne leftPressed
rightPressed:
 call colorRight
 cmp [greenRight],1
 je WaitForData
 call clearPlayer
 add [playerX],1
 call printRight
 mov [keyRight],1
 mov [keyLeft],0
 call won
 call blackBot
 jmp sofKey
leftPressed:
 cmp ah, 4bh;left
 jne upPressed
 call colorLeft
 cmp [greenLeft],1
 je WaitForData
 call clearPlayer
 sub [playerX],1
 call printLeft
 mov [keyRight],0
 mov [keyLeft],1
 call won
 call blackBot
 jmp sofKey
upPressed:
 cmp ah, 48h;up
 jne sofKey
 cmp [keyRight],1
 jne checkKeyLeftPressed
 call rightParabola
 jmp sofKey
checkKeyLeftPressed:
 cmp [keyLeft],1
 jne sofKey
 call leftParabola
sofKey:
 call zeroFlags
 jmp WaitForData
ret 
endp Key

proc rightParabola;פונקציה הבודקת האם מימין ומלמעלה יש ירוק אם לא מזיזה אותו פיקסל אחד ימין ואחד למעלה כך 20 פעם ואז בודקת אם מימין ומלמטה יש ירוק אם לא אז מזיזה את הדמות פיקסל אחד לימין ופיקסל אחד למטה כך 20 פעם
 mov cx,20
parabolaRightUp:
 call colorUp
 cmp [greenUp],1
 jne checkGreenParabolaRight
 call colorBot
 jmp sofRightParabola
checkGreenParabolaRight:
 call colorRight
 cmp [greenRight],1
 jne checkGreenParabola
 call colorBot
 jmp sofRightParabola
checkGreenParabola:
 call clearPlayer
 add [playerX],1
 sub [playerY],1
 call printRight
 call won
 loop parabolaRightUp
 mov cx,20
parabolaRightDown:
 call colorUp
 cmp [greenUp],1
 jne checkGreenParabolaD
 call colorBot
 cmp [greenBot],1
 je sofRightParabola
 call blackBot
 jmp sofRightParabola
checkGreenParabolaD:
 call zeroFlags
 call colorRight
 cmp [greenRight],1
 je sofRightParabola
 call colorBot
 cmp [greenBot],1
 je sofRightParabola
 call clearPlayer
 add [playerX],1
 add [playerY],1
 call printRight
 call won
 call countsec
 loop parabolaRightDown
sofRightParabola:
 call zeroFlags
 call blackBot
 call zeroFlags
 ret
endp rightParabola

proc leftParabola;פונקציה הבודקת האם משמאל ומלמעלה יש ירוק אם לא מזיזה אותו פיקסל אחד שמאל ואחד למעלה כך 20 פעם ואז בודקת אם משמאל ומלמטה יש ירוק אם לא אז מזיזה את הדמות פיקסל אחד לשמאל ופיקסל אחד למטה כך 20 פעם
 mov cx,20
parabolaLeftUp:
 call colorUp
 cmp [greenUp],1
 je sofLeftParabloa
checkLeftGreen: 
 call colorLeft
 cmp [greenLeft],1
 je sofLeftParabloa
 call clearPlayer
 dec [playerX]
 sub [playerY],1
 call printLeft
 call won
 cmp cx,0
 je nextLeft
 dec cx
 jmp parabolaLeftUp
nextLeft:
 mov cx,20
parabolaLeftDown:
 call zeroFlags
 call colorLeft
 cmp [greenLeft],1
 je sofLeftParabloa
 call colorBot
 cmp [greenBot],1
 je sofLeftParabloa
 call clearPlayer
 dec [playerX]
 add [playerY],1
 call printLeft
 call won
 call countsec
 loop parabolaLeftDown
sofLeftParabloa:
 call zeroFlags
loopBlackParabola:
 call colorBot
 cmp [greenBot],1
 je sofSofiParabolaLeft
 call printLeft
 inc [playerY]
 call printLeft
 jmp loopBlackParabola
sofSofiParabolaLeft:
 ret 
endp  leftParabola

proc zeroFlags                                                                       ;פונקציה המאפסת את הדגלים של הצבעים
 mov [greenBot],0
 mov [greenUp],0
 mov [greenRight],0
 mov [greenLeft],0
 ret 
endp zeroFlags

proc blackBot                                                  ;פונקציה שמורידה את הדמות פיקסל אחד למטה כל עוד אין ירוק מתחתיו
pusha
loopBlack:
 mov cx,[playerX]
 mov dx,[playerY]
 add dx,18
 mov bx,14
loopColorBlack:
 call zeroFlags
 call colorBot
 cmp [greenBot],1
 jne checkBxBlack
 jmp checkGreenBlack
checkBxBlack:
 cmp bx,0
 je checkGreenBlack
 dec bx
 jmp loopColorBlack
checkGreenBlack:
 cmp [greenBot],1
 je sofBlack
 call clearPlayer
 inc [playerY]
 call showPlayer
 call countsec
 jmp loopBlack
sofBlack:
popa
 ret 
endp blackBot

proc clearPlayer                                                         ;פונקציה המדפיסה שחור במקום הדמות(מוחקת אותו(
mov bx,offset picB
 mov [Opic],bx
 mov ax,[playerX]
 mov [topXp],ax
 mov ax,[playerY]
 mov [topYp],ax
 mov [lengthX],14
 mov [lengthY],18
 call ppic1
 ret 
endp clearPlayer

proc screenGame                                                         ;פונקציה המדפיסה את זירת המשחק של השלב הראשון
 mov bx,offset picG
 mov [Opic],bx
 mov [topXp],0
 mov [topYp],0
 mov [lengthX],320
 mov [lengthY],200
ret 
endp screenGame

proc screenGame2                                                            ;פונקציה המדפיסה את זירת המשחק של השלב השני
 mov bx,offset picGa2
 mov [Opic],bx
 mov [topXp],0
 mov [topYp],0
 mov [lengthX],320
 mov [lengthY],200
 ret 
endp screenGame2

proc showPlayer                                                                                                                                           ;פונקציה המראה את הדמות לכיוון ימין
 mov bx,offset picJ
 mov [Opic],bx
 mov ax,[playerX]
 mov [topXp],ax
 mov ax,[playerY]
 mov [topYp],ax
 mov [lengthX],14
 mov [lengthY],18
 call ppic1
ret 
endp showPlayer
proc dMouse
 mov ax,2
 int 33h
ret 
endp dMouse

proc limits                                                      ; check =1פונקציה הבודקת גבולות ואם העכבר שנמצא בתוך הגבולות
push bp
mov bp,sp
pusha
    shr bx,1
    jnc sof
shr cx,1
cmp cx, [topX]
jae fxs
jmp sof
fxs:
cmp dx,[topY]
jae fys
jmp sof
fys:
cmp cx,[botX]
jbe fxl
jmp sof
fxl:
cmp dx,[botY]
jbe fyl
jmp sof
fyl:
mov [check],1
sof:
popa
pop bp
ret 8
endp limits

proc showMouse                                                                                     ;פונקציה המראה עכבר
 mov ax,0h
 int 33h
 mov ax,1h
 int 33h
 ret 
endp showMouse

proc getMouse                                                                                     ;פונקציה הקולטת עכבר
mov ax,3h
int 33h
ret 
endp getMouse

proc ppic1
    pusha
    mov bh, 0
    mov bl, [byte ptr x]
    add [x], 3
    mov ax,[topXp]
    mov [BmpLeft],ax;topx
    mov ax,[topYp]
    mov [BmpTop],ax;topy
    mov ax,[lengthX]
    mov [BmpColSize],ax ;xl
    mov ax,[lengthY]
    mov [BmpRowSize] ,ax ;yl
    mov dx,[Opic]
    call OpenShowBmp 
    cmp [ErrorFile],1
    jne continue
    jmp exitError
exitError:
    mov dx, offset BmpFileErrorMsg
    mov ah,9
    int 21h	
continue:
    popa	
ret
endp ppic1

proc countsec
    pusha
    push es
    mov ax, 40h
    mov es, ax
    mov ax, [Clock]	

    ; count 3 sec
    mov cx, 1 ; number of ticks to wait
DelayLoop:
    mov ax, [Clock]
Tick:
    cmp ax, [Clock]
    je Tick
    loop DelayLoop

    pop es
    popa
ret
endp countsec
; input :
;	1.BmpLeft offset from left (where to start draw the picture) 
;	2. BmpTop offset from top
;	3. BmpColSize picture width , 
;	4. BmpRowSize bmp height 
;	5. dx offset to file name with zero at the end 
proc OpenShowBmp near
    push cx
    push bx
    call OpenBmpFile
    cmp [ErrorFile],1
    je @@ExitProc
    call ReadBmpHeader
    ; from  here assume bx is global param with file handle. 
    call ReadBmpPalette
    call CopyBmpPalette
    call ShowBMP 
    call CloseBmpFile
@@ExitProc:
    pop bx
    pop cx
    ret
endp OpenShowBmp	
; input dx filename to open
proc OpenBmpFile	near						 
    mov ah, 3Dh
    xor al, al
    int 21h
    jc @@ErrorAtOpen
    mov [FileHandle], ax
    jmp @@ExitProc	
@@ErrorAtOpen:
    mov [ErrorFile],1
@@ExitProc:	
    ret
endp OpenBmpFile

proc CloseBmpFile near
    mov ah,3Eh
    mov bx, [FileHandle]
    int 21h
    ret
endp CloseBmpFile

; Read 54 bytes the Header
proc ReadBmpHeader	near					
    push cx
    push dx
    
    mov ah,3fh
    mov bx, [FileHandle]
    mov cx,54
    mov dx,offset Header
    int 21h
    
    pop dx
    pop cx
    ret
endp ReadBmpHeader

proc ReadBmpPalette near ; Read BMP file color palette, 256 colors * 4 bytes (400h)
                         ; 4 bytes for each color BGR + null)			
    push cx
    push dx
    
    mov ah,3fh
    mov cx,400h
    mov dx,offset Palette
    int 21h
    
    pop dx
    pop cx
    
    ret
endp ReadBmpPalette


; Will move out to screen memory the colors
; video ports are 3C8h for number of first color
; and 3C9h for all rest
proc CopyBmpPalette		near					
                                        
    push cx
    push dx
    
    mov si,offset Palette
    mov cx,256
    mov dx,3C8h
    mov al,0  ; black first							
    out dx,al ;3C8h
    inc dx	  ;3C9h
CopyNextColor:
    mov al,[si+2] 		; Red				
    shr al,2 			; divide by 4 Max (cos max is 63 and we have here max 255 ) (loosing color resolution).				
    out dx,al 						
    mov al,[si+1] 		; Green.				
    shr al,2            
    out dx,al 							
    mov al,[si] 		; Blue.				
    shr al,2            
    out dx,al 							
    add si,4 			; Point to next color.  (4 bytes for each color BGR + null)				
                                
    loop CopyNextColor
    
    pop dx
    pop cx
    ret
endp CopyBmpPalette

proc ShowBMP 
; BMP graphics are saved upside-down.
; Read the graphic line by line (BmpRowSize lines in VGA format),
; displaying the lines from bottom to top.
    push cx
    
    mov ax, 0A000h
    mov es, ax
    
    mov cx,[BmpRowSize]
    
    mov ax,[BmpColSize] ; row size must dived by 4 so if it less we must calculate the extra padding bytes
    xor dx,dx
    mov si,4
    div si
    mov bp,dx
    
    mov dx,[BmpLeft]
    
@@NextLine:
    push cx
    push dx
    
    mov di,cx  ; Current Row at the small bmp (each time -1)
    add di,[BmpTop] ; add the Y on entire screen
    ; next 5 lines  di will be  = cx*320 + dx , point to the correct screen line
    mov cx,di
    shl cx,6
    shl di,8
    add di,cx
    add di,dx
    
    ; small Read one line
    mov ah,3fh
    mov cx,[BmpColSize]  
    add cx,bp  ; extra  bytes to each row must be divided by 4
    mov dx,offset ScreenLineMax
    int 21h
    ; Copy one line into video memory
    cld ; Clear direction flag, for movsb
    mov cx,[BmpColSize]  
    mov si,offset ScreenLineMax
    rep movsb ; Copy line to the screen
    pop dx
    pop cx
    loop @@NextLine
    pop cx
    ret
endp ShowBMP 

proc  SetGraphic
    mov ax,13h   ; 320 X 200 
                 ;Mode 13h is an IBM VGA BIOS mode. It is the specific standard 256-color mode 
    int 10h
    ret
endp 	SetGraphic

 proc ClearScreen
    push cx
    push ax
    push di
    push es		           ; Save ES value - IMPORTANT, or else the clock loop in the main program wouldn't work properly.
    mov ax,0A000h          ; BIOS graphics (not text).
    mov es,ax
    xor di,di
    xor ax,ax
    mov cx,32000d          ; 320 X 200, 64000 bytes in memory.
    cld
    rep stosw
    pop es
    pop di
    pop ax
    pop cx
    ret
endp ClearScreen

END start
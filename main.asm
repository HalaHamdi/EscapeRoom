
.Model Small
.stack 64 
.data

;Enter Name Screen Data
Player1_Name db 30, ?,30 dup('$')
enterName_request db 'Please enter your name: ','$'
continue_request db 'Press enter key to continue.','$'
Enter_ScanCode db 01ch,'$'
dot db '.','$'

;Game Option Screen Data
Option1_String db "* To start chatting press 1 $"
Option2_String db "* To Choose Game Level press 2 $"
Option3_String db "* To End The program press ESC $"

;Choosing Level Screen Data
Level1 db "-For an Easy Level press 1 $"
Level2 db "-For a Hard Level Press 2 $"
Key1Pressed db " This is the Chatting screen $"
Level1Pressed db "This is Level 1 screen $"
Level2Pressed db "This is Level 2 screen $"

;Maze drawing attributes
cx1 dw 30
cx2 dw 210
dx1 dw 20
dx2 dw 135
Color db 09

;Drawing Horizontal Line attributes
Horizintal_Line_Start_Column dw ?
Horizintal_Line_End_Column dw ?
Horizintal_Line_Row dw ?

;Temp Variables that are commonly used by left & right arrows
Icon_middle_Row dw ? ;for icons who have an odd height (5 pixels, 7 pixels, etc.)
Icon_Start_End_Column dw ? ;for icons who have an odd height (5 pixels, 7 pixels, etc.)

;Common drawing attributes for all 4 hints
Icon_Height dw 4
Icon_HalfHeight dw 2 ;please note that it's a good practice to calculate this variable within the code by dividing the height by 2 , however , my computer doesn't perform division operations, thats why i haven't done s

;speed up hint data
ArrowsCount dw 4 ;the speedup icon will consist of 4 following arrows
SpeedUP_Icon_Start_Column dw 34
SpeedUP_Icon_Start_Row dw 22
SpeedUP_Icon_End_Row dw ? ;SpeedUP_Icon_Start_Row + _Icon_Height
SpeedUP_Icon_End_Column dw ?
SpeedUP_Left_Part_Color db 0Bh ;light blue
SpeedUP_Right_Part_Color db 0Ch ;light red

;freeze hint data
Freeze_Icon_Start_Column dw 50
Freeze_Icon_Start_Row dw 22
Freeze_Icon_End_Row dw ? ;Freeze_Icon_Start_Row + Icon_Height
Freeze_Icon_End_Column dw ?
Freeze_Color db 0Ch ;light red

;Forward hint data
Forward_Icon_Start_Column dw 70
Forward_Icon_Start_Row dw 22
Forward_Icon_End_Row dw ? ;Forward_Icon_Start_Row + Icon_Height
Forward_Icon_End_Column dw ?
Forward_Color db 03h ;dark blue

;Backward hint data
Backward_Icon_Start_Column dw 100
Backward_Icon_Start_Row dw 22
Backward_Icon_End_Row dw ? ;Backward_Icon_Start_Row + Icon_Height
Backward_Icon_End_Column dw ?
Backward_Color db 0Fh ;white

;player1 data
X_coordinate_Start dw 0
Y_coordinate_Start dw 0
X_coordinate_End dw 4
Y_coordinate_End dw 4


;Finishing the game Data
end1 db 'END GAME','$'
winner db 'The winner is ','$'
Nameofwinner db 'Nadeen','$' ;this data will be changed next
movtooptions db 'To move to the option screen please press Enter','$'

.code 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;DRAWING PROCEDURES;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;DRAWING PLAYER1;;;;;;;;;;;;;;;;;;;;;;;;;;;
initialDraw PROC

    mov cx,X_coordinate_Start
    mov dx,Y_coordinate_Start
    mov al,5
    mov ah,0ch
    row: int 10h
    inc cx
    cmp cx,X_coordinate_End
    JNE row
    mov cx,0
    inc dx
    cmp dx,Y_coordinate_End
    JNE row
    RET
initialDraw ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;END OF DRAWING PLAYER1;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;UTILITY FUNCTIONS USED IN DRAWING THE MAZE;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;drow vertical gaps
Drow1 PROC FAR
      mov dx,dx1
      mov al,Color
        Gapline:
        mov cx,cx1
        Gap:int 10h
        inc cx 
        cmp cx,cx2
        jnz Gap
        add dx ,7
        cmp  dx,dx2
        jb Gapline  
        ret
Drow1 ENDP
;;;drow horizontal blocks
Drow2 PROC far
      mov dx,dx1
      mov al,Color
        mov cx,cx1
        Gap2:int 10h
        inc dx
        cmp dx,dx2
        jnz Gap2
        ret
Drow2 ENDP 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;END OF UTILITY FUNCTIONS USED IN DRAWING THE MAZE;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;DRAWING THE MAZE;;;;;;;;;;;;;;;;;;;;;;;;;;;
DrawMaze PROC
            ;;;;drow the maze border
        mov ah,0ch
        mov cx,30
        mov dx,27
        mov al,9
        h:int 10h
        inc dx
        cmp dx,132
        jnz h
        mov cx,210
        mov dx,20
        mov al,9
        r:int 10h
        inc dx
        cmp dx,125
        jnz r
        call Drow1
        mov cx1,31
        mov cx2,41
        mov dx1,34
        mov dx2,48
        mov Color,0
        call Drow1
        mov cx1,31
        mov cx2,41
        mov dx1,55
        mov dx2,69
        mov Color,0
        call Drow1
        mov cx1,31
        mov cx2,41
        mov dx1,97
        mov dx2,132
        mov Color,0
        call Drow1
        mov cx1,42
        mov dx1,97
        mov dx2,104
        mov Color,9
        call Drow2
        mov cx1,43
        mov dx1,111
        mov dx2,118
        mov Color,9
        call Drow2
        mov cx1,42
        mov cx2,52
        mov dx1,76
        mov dx2,83
        mov Color,0
        call Drow1
        mov cx1,52
        mov dx1,34
        mov dx2,41
        mov Color,9
        call Drow2
        mov cx1,52
        mov dx1,55
        mov dx2,62
        mov Color,9
        call Drow2
        mov cx1,52
        mov cx2,62
        mov dx1,34
        mov dx2,41
        mov Color,0
        call Drow1
        mov cx1,62
        mov cx2,72
        mov dx1,48
        mov dx2,55
        mov Color,0
        call Drow1
        mov cx1,62
        mov cx2,72
        mov dx1,90
        mov dx2,97
        mov Color,0
        call Drow1
        mov cx1,72
        mov dx1,76
        mov dx2,83
        mov Color,9
        call Drow2
        mov cx1,72
        mov dx1,104
        mov dx2,111
        mov Color,9
        call Drow2
        mov cx1,75
        mov dx1,90
        mov dx2,97
        mov Color,9
        call Drow2
        mov cx1,72
        mov cx2,82
        mov dx1,104
        mov dx2,125
        mov Color,0
        call Drow1
        mov cx1,72
        mov cx2,82
        mov dx1,83
        mov dx2,90
        mov Color,0
        call Drow1
         mov cx1,72
        mov cx2,82
        mov dx1,62
        mov dx2,69
        mov Color,0
        call Drow1
        mov cx1,72
        mov cx2,82
        mov dx1,27
        mov dx2,34
        mov Color,0
        call Drow1
        mov cx1,85
        mov dx1,27
        mov dx2,34
        mov Color,9
        call Drow2
        mov cx1,85
        mov dx1,55
        mov dx2,62
        mov Color,9
        call Drow2
        mov cx1,85
        mov dx1,104
        mov dx2,111
        mov Color,9
        call Drow2
        mov cx1,90
        mov dx1,90
        mov dx2,97
        mov Color,9
        call Drow2
        mov cx1,90
        mov cx2,100
        mov dx1,41
        mov dx2,48
        mov Color,0
        call Drow1
        mov cx1,90
        mov cx2,100
        mov dx1,90
        mov dx2,97
        mov Color,0
        call Drow1
        mov cx1,105
        mov dx1,34
        mov dx2,41
        mov Color,9
        call Drow2
        mov cx1,105
        mov cx2,115
        mov dx1,34
        mov dx2,41
        mov Color,0
        call Drow1
        mov cx1,130
        mov cx2,140
        mov dx1,111
        mov dx2,118
        mov Color,0
        call Drow1
        mov cx1,135
        mov dx1,125
        mov dx2,132
        mov Color,9
        call Drow2
        mov cx1,125
        mov dx1,118
        mov dx2,125
        mov Color,9
        call Drow2
        mov cx1,150
        mov dx1,41
        mov dx2,48
        mov Color,9
        call Drow2
        mov cx1,180
        mov dx1,104
        mov dx2,118
        mov Color,9
        call Drow2
        mov cx1,180
        mov cx2,190
        mov dx1,97
        mov dx2,104
        mov Color,0
        call Drow1
        mov cx1,180
        mov cx2,190
        mov dx1,118
        mov dx2,125
        mov Color,0
        call Drow1
        mov cx1,150
        mov cx2,160
        mov dx1,69
        mov dx2,76
        mov Color,0
        call Drow1
        mov cx1,180
        mov cx2,190
        mov dx1,76
        mov dx2,83
        mov Color,0
        call Drow1
        mov cx1,190
        mov cx2,210
        mov dx1,125
        mov dx2,132
        mov Color,0
        call Drow1
        mov cx1,200
        mov dx1,34
        mov dx2,41
        mov Color,9
        call Drow2
        mov cx1,200
        mov dx1,62
        mov dx2,83
        mov Color,9
        call Drow2
        mov cx1,200
        mov cx2,220
        mov dx1,27
        mov dx2,55
        mov Color,0
        call Drow1
        mov cx1,200
        mov cx2,220
        mov dx1,62
        mov dx2,90
        mov Color,0
        call Drow1
        mov cx1,200
        mov cx2,220
        mov dx1,104
        mov dx2,118
        mov Color,0
        call Drow1
        mov cx1,210
        mov dx1,20
        mov dx2,125
        mov Color,9
        call Drow2
        RET
DrawMaze ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;END OF DRAWING THE MAZE;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;UTILITY FUNCTIONS USED IN DRAWING HINTS;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  \
;   \
;   /
;  /
DrawARightArrow PROC
    ;cx takes the initial x coordinate to start drawing the arrow at
    ;dx takes the initial y coordinate to start drawing the arrow at
    draw_right_arrow_upper_part: int 10h
    inc cx
    inc dx
    cmp dx,Icon_middle_Row
    JNE draw_right_arrow_upper_part
    draw_right_arrow_bottom_part: int 10h
    inc dx
    dec cx
    cmp cx,Icon_Start_End_Column
    JNB draw_right_arrow_bottom_part                     
    ret
DrawARightArrow ENDP

;   /
;  /
;  \ 
;   \
DrawALeftArrow PROC
    ;cx takes the initial x coordinate to start drawing the arrow at
    ;dx takes the initial y coordinate to start drawing the arrow at
    draw_left_arrow_upper_part: int 10h
    dec cx
    inc dx
    cmp dx,Icon_middle_Row
    JNE draw_left_arrow_upper_part
    draw_left_arrow_bottom_part: int 10h
    inc dx
    inc cx
    cmp cx,Icon_Start_End_Column
    JNA draw_left_arrow_bottom_part                     
    ret
DrawALeftArrow ENDP

;_________
DrawAHorizontalLine PROC
    mov cx,Horizintal_Line_Start_Column
    mov dx,Horizintal_Line_Row
    draw_horizontal_line: int 10h
    inc cx
    cmp cx,Horizintal_Line_End_Column
    JNA draw_horizontal_line
    ret
DrawAHorizontalLine ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;END OF UTILITY FUNCTIONS USED IN DRAWING HINTS;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;DRAWING HINTS' PROCDURES;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
DrawForwardHint PROC

    ;draw pixel attributes
    mov al,Forward_Color
    MOV AH,0Ch

    mov cx, Forward_Icon_Start_Column
    mov dx, Forward_Icon_Start_Row

    ;calculating Forward_Icon_middle_Row
    mov si,dx
    Add si,Icon_HalfHeight
    mov Icon_middle_Row,si

    ;setting x and y coordinates to draw a horizontal line at the middle of the hint's coordinates
    mov Horizintal_Line_Row,si
    mov Horizintal_Line_Start_Column,cx
    add cx,Icon_Height
    mov Horizintal_Line_End_Column,cx

    call DrawAHorizontalLine

    ;Reinitializing the coordinates of the forward hint
    mov cx, Forward_Icon_Start_Column
    mov dx, Forward_Icon_Start_Row

    ;CALCULATING THE ATTRIBUTES TO DRAW THE RIGHT ARROW
    add cx,Icon_HalfHeight
    mov Icon_Start_End_Column,cx

    call DrawARightArrow
    ret
DrawForwardHint ENDP


DrawBackwardHint PROC
    
    ;draw pixel attributes
    mov al,Backward_Color
    MOV AH,0Ch

    mov cx, Backward_Icon_Start_Column
    mov dx, Backward_Icon_Start_Row

    ;calculating Backward_Icon_middle_Row
    mov si,dx
    Add si,Icon_HalfHeight
    mov Icon_middle_Row,si

    ;setting x and y coordinates to draw a horizontal line at the middle of the hint's coordinates
    mov Horizintal_Line_Row,si
    mov Horizintal_Line_Start_Column,cx
    add cx,Icon_Height
    mov Horizintal_Line_End_Column,cx

    call DrawAHorizontalLine

    ;Reinitializing the coordinates of the backward hint
    mov cx, Backward_Icon_Start_Column
    mov dx, Backward_Icon_Start_Row

    ;CALCULATING THE ATTRIBUTES TO DRAW THE LEFT ARROW
    add cx,Icon_HalfHeight
    mov Icon_Start_End_Column,cx

    call DrawALeftArrow
    ret
DrawBackwardHint ENDP

DrawFreezeHint PROC
    
    ;draw pixel attributes
    mov al,Freeze_Color
    MOV AH,0Ch
    
    mov cx, Freeze_Icon_Start_Column
    mov dx, Freeze_Icon_Start_Row

    ;calculating Freeze_Icon_End_Column
    mov si,cx
    Add si,Icon_Height
    mov Freeze_Icon_End_Column,si
        
    ;calculating Freeze_Icon_End_Row
    mov si,dx
    Add si,Icon_Height
    mov Freeze_Icon_End_Row,si

    ;calculating Freeze_Icon_middle_Row
    mov si,dx
    Add si,Icon_HalfHeight
    mov Icon_middle_Row,si
    
    ;mov the cx to the middle of the diamond
    add cx, Icon_HalfHeight
    mov Icon_Start_End_Column,cx

    call DrawALeftArrow
    ;setting the drawing attributes to draw the right arrow to the right of the left arrow
    mov Icon_Start_End_Column,cx
    mov dx, Freeze_Icon_Start_Row
    call DrawARightArrow

    ret
DrawFreezeHint ENDP

DrawSpeedUpHint PROC
        
        ;draw pixel attributes
        mov al,SpeedUP_Left_Part_Color
        MOV AH,0Ch

        ;cx takes the initial x coordinate to draw the first arrow at
        ;dx takes the initial y coordinate to draw the first arrow at
        mov cx, SpeedUP_Icon_Start_Column
        mov dx, SpeedUP_Icon_Start_Row
        
        ;calculating SpeedUp_Icon_middle_Row
        mov si,dx
        Add si,Icon_HalfHeight
        mov Icon_middle_Row,si
        
        ;calculating SpeedUP_Icon_End_Row
        mov si,dx
        Add si,Icon_Height
        mov SpeedUP_Icon_End_Row,si

        mov Icon_Start_End_Column,cx
        call DrawARightArrow

        ;re-setting the arrow's drawing positions 
        add cx,2
        mov Icon_Start_End_Column,cx
        mov dx, SpeedUP_Icon_Start_Row
        call DrawARightArrow
        
        ;DRAWING another 2 following arrows with a different color
        mov al,SpeedUP_Right_Part_Color
        add cx,2
        mov Icon_Start_End_Column,cx
        mov dx, SpeedUP_Icon_Start_Row
        call DrawARightArrow
        
        add cx,2
        mov Icon_Start_End_Column,cx
        mov dx, SpeedUP_Icon_Start_Row
        call DrawARightArrow
        
        mov si, SpeedUP_Icon_Start_Column
        add si,ArrowsCount
        dec si
        add si,Icon_Height
        mov SpeedUP_Icon_End_Column,si
        
        ret
DrawSpeedUpHint ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;END OD DRAWING HINTS' PROCEDURES;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;DRAW LEVEL 2;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;description
DrawLevel2 PROC
    ;;clear screen
    mov ax,0600h
    mov cx,0
    mov bh,0
    mov dx,184fh
    int 10h
    
    ;;;;graphic mode 
    mov ah,0
    mov al,13h
    int  10h

    ;Initializing the maze
    call DrawMaze

    ;Initializing the maze with all hints
    call DrawSpeedUpHint
    call DrawFreezeHint
    call DrawForwardHint
    call DrawBackwardHint

    ;Initializing player1 between the positions (X_coordinate_Start,Y_coordinate_Start) and (X_coordinate_End,Y_coordinate_End) 
    call initialDraw
    ret
DrawLevel2 ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;END OF DRAWING LEVEL 2;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;END OF DRAWING PROCEDURES;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;LOGIC PROCEDURES;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;MOVING LOGIC FOR PLAYER1;;;;;;;;;;;;;;;;;;;;;;;;;;;
movRight PROC
    ;deleting the mostleft column
    mov cx,X_coordinate_Start
    mov dx,Y_coordinate_Start
    mov al,0h
    mov ah,0ch
    deleteColumn1: int 10h
    inc dx
    cmp dx,Y_coordinate_End
    JNE deleteColumn1
    
    ;set the X_start to it's new value
    mov di,offset X_coordinate_Start
    mov si, [di]
    inc si
    mov [di],si
    
    ;drawing a new column after the mostright column
    mov cx,X_coordinate_End
    mov dx,Y_coordinate_Start
    mov al,5h
    mov ah,0ch
    drawNewColumn1: int 10h
    inc dx
    cmp dx,Y_coordinate_End
    JNE drawNewColumn1
    
    ;set the X_end to it's new value
    mov di,offset X_coordinate_End
    mov si, [di]
    inc si
    mov [di],si

    ret
movRight ENDP

;description
movLeft PROC
    
    ;set the X_end to it's new value
    mov di,offset X_coordinate_End
    mov si, [di]
    dec si
    mov [di],si

    ;deleting the mostright column
    mov cx,X_coordinate_End
    mov dx,Y_coordinate_Start
    mov al,0h
    mov ah,0ch
    deleteColumn2: int 10h
    inc dx
    cmp dx,Y_coordinate_End
    JNE deleteColumn2
    
    ;set the X_start to it's new value
    mov di,offset X_coordinate_Start
    mov si, [di]
    dec si
    mov [di],si
    ;drawing a new column after the mostright column
    mov cx,X_coordinate_Start
    mov dx,Y_coordinate_Start
    mov al,5h
    mov ah,0ch
    drawNewColumn2: int 10h
    inc dx
    cmp dx,Y_coordinate_End
    JNE drawNewColumn2

    ret
movLeft ENDP

;description
movUP PROC
    
    ;set the X_end to it's new value
    mov di,offset Y_coordinate_End
    mov si, [di]
    dec si
    mov [di],si

    ;deleting the mostright column
    
    mov dx,Y_coordinate_End
    mov cx,X_coordinate_Start
    mov al,0h
    mov ah,0ch
    deleteColumn3: int 10h
    inc cx
    cmp cx,X_coordinate_End
    JNE deleteColumn3
    
    ;set the X_start to it's new value
    mov di,offset Y_coordinate_Start
    mov si, [di]
    dec si
    mov [di],si
    ;drawing a new column after the mostright column
    mov dx,Y_coordinate_Start
    mov cx,X_coordinate_Start
    mov al,5h
    mov ah,0ch
    drawNewColumn3: int 10h
    inc cx
    cmp cx,X_coordinate_End
    JNE drawNewColumn3

    ret
movUP ENDP

;description
movDown PROC
    
    ;deleting the mostright column
    
    mov dx,Y_coordinate_Start
    mov cx,X_coordinate_Start
    mov al,0h
    mov ah,0ch
    deleteColumn4: int 10h
    inc cx
    cmp cx,X_coordinate_End
    JNE deleteColumn4
    
    ;set the X_start to it's new value
    mov di,offset Y_coordinate_Start
    mov si, [di]
    inc si
    mov [di],si
    
    ;drawing a new column after the mostright column
    mov dx,Y_coordinate_End
    mov cx,X_coordinate_Start
    mov al,5h
    mov ah,0ch
    drawNewColumn4: int 10h
    inc cx
    cmp cx,X_coordinate_End
    JNE drawNewColumn4

    ;set the X_end to it's new value
    mov di,offset Y_coordinate_End
    mov si, [di]
    inc si
    mov [di],si

    ret
movDown ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;END OF MOVING LOGIC FOR PLAYER1;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;END OF LOGIC PROCEDURES;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Level2 Screen;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;description
Level2Screen PROC
    
    ;initialize the screen with the maze + the player + the hints
    call DrawLevel2

    ;MOVING LOGIC
    ;get key pressed
    getKeyPressed:
    mov ah,0
    int 16h
    ;the key scancode is stored in al
    cmp ah,4Dh
    JE rightArrowKey
    cmp ah,4Bh
    JE leftArrowKey
    cmp ah,48h
    JE upArrowKey
    cmp ah,50h
    JE downArrowKey
    JMP getKeyPressed
    rightArrowKey: call movRight
    JMP getKeyPressed
    leftArrowKey: call movLeft
    JMP getKeyPressed
    upArrowKey: call movUP
    JMP getKeyPressed
    downArrowKey: call movDown
    JMP getKeyPressed
    
    Ret
Level2Screen ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ChooseLevelScreen PROC


; text mode to clear screen

mov ax,03h
int 10h 

; moving cursor to  row =18 col=0 to draw a line
; in text mode
; in al is the Ascci code of  "-"
mov dx,1200H
mov ah,2
int 10h
mov ah,9
mov al,2DH
mov cx,4FH
mov bl,03h
int 10h




; moving cursor to  row =5 col=25

mov ah,2
mov dx,0819H
int 10h

; Printing the first string
mov ah,9
mov dx,offset Level1
int 21h

;new line  with a bit of space =3 betwen lines

mov ah,3h
int 10h

mov ah,2
add dh,3
mov dl,19H
int 10h
;printing the  second string 
mov ah,9
mov dx,offset Level2
int 21h






keyPressed:mov ah,0
int 16h
jz keyPressed
; checking that the scan code is for 1
cmp ah,2
jz Level1Screen_Label
; checking that the scan code is for 2
cmp ah,3
jz Level2Screen_Label
; that means that the user clicked other key than those 3 stated
JMP keyPressed



Level1Screen_Label:
mov ax,03h
int 10h

mov ah,9
mov dx,offset Level1Pressed
int 21h
JMP EndChooseLevelScreen


Level2Screen_Label:
mov ax,03h
int 10h

call Level2Screen

EndChooseLevelScreen:
ret




ChooseLevelScreen ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



; ;Screen 2
OptionsScreen PROC

; text mode to clear screen
mov ax,03h
int 10h

; moving cursor to  row =5 col=25

mov ah,2
mov dx,0819H
int 10h

; Printing the first string
mov ah,9
mov dx,offset Option1_String
int 21h

;new line  with a bit of space =3 betwen lines

mov ah,3h
int 10h

mov ah,2
add dh,3
mov dl,19H
int 10h
;printing the  second string 
mov ah,9
mov dx,offset Option2_String
int 21h

;new line 

mov ah,3h
int 10h

mov ah,2
add dh,3
mov dl,19H
int 10h

;printing the  Third string 
mov ah,9
mov dx,offset Option3_String
int 21h

CheckkeyPressed:
mov ah,0
int 16h
jz CheckkeyPressed
; checking that the scan code is for F1
cmp ah,2
jz Key1Action
; checking that the scan code is for F2
cmp ah,3
jz Key2Action
; checking that the scan code if for ESC
cmp  ah,1
jz EndProgram
; that means that the user clicked other key than those 3 stated
jmp CheckkeyPressed




Key1Action:
; clears the screen
mov ax,03h
int 10h
; Draws Chatting Module
mov ah,9
mov dx,offset Key1Pressed
int 21h
jmp EndOptionScreen




Key2Action:
call ChooseLevelScreen
jmp EndOptionScreen



EndProgram:
; this code to end exit the program
MOV AH, 4CH
MOV AL, 01
INT 21H

EndOptionScreen:ret  
OptionsScreen ENDP
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Enter_Name_Screen PROC
    ;clear the screen
        Mov ax, 03h
        int 10h

        ;setting the cursor
        ;dh=row=10 dl=column=20
        mov ah,2h
        mov dh, 10d    
        mov dl,20d
        int 10h
        
        ;print enterName_request
        mov ah,9h
        mov dx, offset enterName_request
        int 21h
        
        ;get the name from the user
        mov ah, 0Ah
        mov dx,offset Player1_Name
        int 21h

        ;setting the cursor
        ;dh=row=12 dl=column=20
        mov ah,2h
        mov dh, 12d    
        mov dl,20d
        int 10h
        
        ;print continue_request
        mov ah,9h
        mov dx, offset continue_request
        int 21h
        
        ;getting the cursor position
        mov ah,3H
        mov bh,0h 
        int 10H

        ;loop until the pressed key is enter
        Not_Enter_Key:

        ;printing a dot as long as the pressed key is not enter
        inc dl
        call waiting

        ;getting the key pressed
        ;ah will hold the scancode of the pressed key
        mov ah,0h 
        int 16h
        
        ;check if this char is the scan code of enter or not
        cmp ah,Enter_ScanCode
        JNE Not_Enter_Key
        
        ;navigate to option's screen
        call OptionsScreen
        ret
Enter_Name_Screen ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Printing a dot Procedure (.)
waiting PROC
        mov ah,9h
        mov dx, offset dot
        int 21h
        ret
waiting ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;Finishing game screen Proc;;;;;;;
finishgame PROC
;;;;clear screan
mov ax,0600h
mov bh,07
mov cx,0
mov dx, 184Fh
int 10h
; moving cursor to  row =12 col=30

mov ah,2
mov bh,0
mov dh,6
mov dl,39
int 10h
push dx  ;to get the cursor position back again

; Printing the first string
mov ah,9
lea dx,end1
int 21h

pop dx


mov ah,2
add dh,2
mov dl,32
int 10h

push dx


mov ah,9
lea dx,winner
int 21h

pop dx

mov ah,2
add dl,14
int 10h

push dx

;printing the  name of the winner should be changed later
mov ah,9
lea dx,Nameofwinner
int 21h

pop dx

mov ah,2
add dh,2
mov dl,20
int 10h

;moving to option screen
mov ah,9
lea dx,movtooptions
int 21h

WaitingForPressing:
mov ah,0
int 16h
jz WaitingForPressing
; checking that the scancode is for Enter
cmp ah,28
jnz WaitingForPressing
;should go to option screen

call OptionsScreen
ret
finishgame ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;THE MAIN PROCEDURE;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Main PROC Far
Mov ax, @data 
mov ds ,ax

call Enter_Name_Screen
call finishgame

EndCode :
ret
Main ENDP
end Main

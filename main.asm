
.Model Small
.stack 64 
.data

;Enter Name Screen Data
Player1_Name db 30, ?,30 dup('$')
Player2_Name db 30, ?,30 dup('$')
NormalStatus db 'Normal','$'
FrozenStatus db 'Frozen','$'
SpeededUpStatus db 'Speeded Up','$'
StatusPlayer1 db 0                       ;to indicate the current state of the player(Normal,Frozen,SpeededUP)
StatusPlayer2 db 0
enterName_request db 'Please Enter First Player name: ','$'
enterName_request2 db 'Please Enter Second Player name: ','$'
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

;Attribute to check Level of the maze
Level db 1

;Deleting attributes (for deleting player or hints)
Delete_X_coordinate_start dw 4
Delete_X_coordinate_End dw 4
Delete_Y_coordinate_start dw 4
Delete_Y_coordinate_End dw 4

;Hint check attributes
HintExist db 0
HintColor db ? ;for drowing or clearing hints
currentSpeed dw 2
movedirection db 0 ;indicates the direction of hint that the player take (forward/backward)


;Status Bar attributes
PLayerStatus dw ?

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
SpeedUP_Icon_Start_Column dw 120
SpeedUP_Icon_Start_Row dw 29
SpeedUP_Icon_End_Row dw ? ;SpeedUP_Icon_Start_Row + _Icon_Height
SpeedUP_Icon_End_Column dw ?
SpeedUP_Left_Part_Color db 2h ;light blue
SpeedUP_Right_Part_Color db 2h ;light red

;freeze hint data
Freeze_Icon_Start_Column dw 160
Freeze_Icon_Start_Row dw 70
Freeze_Icon_End_Row dw ? ;Freeze_Icon_Start_Row + Icon_Height
Freeze_Icon_End_Column dw ?
Freeze_Color db 0Ch ;light red

;Forward hint data
Forward_Icon_Start_Column dw 60
Forward_Icon_Start_Row dw 127
Forward_Icon_End_Row dw 131 ;Forward_Icon_Start_Row + Icon_Height
Forward_Icon_End_Column dw 64
Forward_Color db 03h ;dark blue

;Backward hint data
Backward_Icon_Start_Column dw 61
Backward_Icon_Start_Row dw 57
Backward_Icon_End_Row dw 61 ;Backward_Icon_Start_Row + Icon_Height
Backward_Icon_End_Column dw 65
Backward_Color db 0Fh ;white

;player1 data
X_coordinate_Start dw 0
Y_coordinate_Start dw 0
X_coordinate_End dw 4
Y_coordinate_End dw 4


; Saving the time for chaning the speed
StartTimePlayer1CL db ?
StartTimePlayer1Ch db ?
StartTimePlayer1DH db ?
SpeedChangedClicks dw 10   ;this is the amount of ticks that the player will remain is this chaning speed mode per sec

;Finishing the game Data
end1 db 'END GAME','$'
winner db 'The winner is ','$'
Nameofwinner db 'Nadeen','$' ;this data will be changed next
movtooptions db 'To move to the option screen please press Enter','$'

.code 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;UTILITY FUNCTIONS USED IN Check IF THERE IS A HINT OR NOT;;;;;;;;;;;;;;;;;;;;;;;;;;;

;CHECK FOR HINTS IN THE FOLLOWING RIGHT MOVE
CheckHintRight PROC
	mov DX,Y_coordinate_Start                   ;initialize Y_coordinate of search

	SearchHintVertically:
    mov cx,X_coordinate_End
    inc cx                                      ;to reach  the following column (start position of cx  in the loop)
	mov bx,currentSpeed
	add bx,cx	                                ;to reach  the last column (end condition of the loop)

	SearchHintHorizontally:       
	mov ah,0Dh                                  ;for the color interupt
	cmp cx,bx
	je CheckEndVertical
    int 10H                                      ; AL = COLOR  find color pixel interrupt
	inc cx
	cmp al,0
	je SearchHintHorizontally
	mov HintExist,al                            ;Set Hint Exist With Color Found 
    jmp ENDLOOP

    CheckEndVertical:
    inc dx                                       
    cmp dx, Y_coordinate_End
    jne SearchHintVertically                    ; Continue searching if end is not reached 

ENDLOOP:

ret
CheckHintRight ENDP



;CHECK FOR HINTS IN THE FOLLOWING LEFT MOVE
CheckHintLeft PROC
    mov DX,Y_coordinate_Start                   ;initialize Y_coordinate of search

	SearchHintVerticallyL:
    mov cx,X_coordinate_Start
    dec cx                                      ;to reach  the following column (start position of cx  in the loop)
	mov bx,cx
	sub bx,currentSpeed                                ;to reach  the last column (end condition of the loop)

	SearchHintHorizontallyL:       
	mov ah,0Dh                                  ;for the color interupt
	cmp cx,bx
	je CheckEndVerticalL
    int 10H                                      ; AL = COLOR  find color pixel interrupt
	dec cx
	cmp al,0
	je SearchHintHorizontallyL
	mov HintExist,al                            ;Set Hint Exist With Color Found 
    jmp ENDLOOPL

    CheckEndVerticalL:
    inc dx                                       
    cmp dx, Y_coordinate_End
    jne SearchHintVerticallyL                   ; Continue searching if end is not reached 
ENDLOOPL:
ret
CheckHintLeft ENDP


;CHECK FOR HINTS IN THE FOLLOWING UP MOVE

CheckHintUP PROC
	mov DX,Y_coordinate_Start                   ;initialize Y_coordinate of search
    
    mov bx ,DX                 
    sub bx,currentSpeed                          ;to reach  the last column (end condition of the loop)

	SearchHintVerticallyU:
    mov cx,X_coordinate_Start
    inc cx                                      ;to reach  the following column (start position of cx  in the loop)
	              
	SearchHintHorizontallyU:       
	mov ah,0Dh                                  ;for the color interupt
	cmp cx,X_coordinate_End    
	je CheckEndVerticallyU
    int 10H                                      ; AL = COLOR  find color pixel interrupt
	inc cx
	cmp al,0
	je SearchHintHorizontallyU
	mov HintExist,al                            ;Set Hint Exist With Color Found 
    jmp ENDLOOPU

    CheckEndVerticallyU:
    dec dx                                       
    cmp dx, bx
    jne SearchHintVerticallyU                    ; Continue searching if end is not reached 

ENDLOOPU:

ret
CheckHintUP ENDP


;CHECK FOR HINTS IN THE FOLLOWING DOWN MOVE
CheckHintDown PROC
	mov DX,Y_coordinate_End                  ;initialize Y_coordinate of search
    
    mov bx ,DX                 
    add bx,currentSpeed                          ;to reach  the last column (end condition of the loop)
    inc dx   ; to be changed 
	SearchHintVerticallyD:
    mov cx,X_coordinate_Start
	              
	SearchHintHorizontallyD:       
	mov ah,0Dh                                  ;for the color interupt
	cmp cx,X_coordinate_End    
	je CheckEndVerticallyD
    int 10H                                      ; AL = COLOR  find color pixel interrupt
	inc cx
	cmp al,0
	je SearchHintHorizontallyD
	mov HintExist,al                              ;Set Hint Exist With Color Found 
                          
    jmp ENDLOOPD

    CheckEndVerticallyD:
    inc dx                                       
    cmp dx, bx
    jne SearchHintVerticallyD                    ; Continue searching if end is not reached 

ENDLOOPD:
ret
CheckHintDown ENDP

;Move Forward function 
MoveForward PROC
    mov di,Y_coordinate_End
	mov Delete_Y_coordinate_End,di

	mov di,Y_coordinate_Start
	mov Delete_Y_coordinate_Start,di

	mov di,X_coordinate_Start
	mov Delete_X_coordinate_Start,di

	mov di,X_coordinate_End
	mov Delete_X_coordinate_End,di
	
	call deletePlayer

    cmp movedirection,0 
    je Back 
    cmp Level,2                 ;Check if we are in Level 1 OR 2
    je Level2_forward
	mov X_coordinate_Start,166  ;if move direction is forward (forward hint is taken) In Level one
    mov X_coordinate_End,170
    mov Y_coordinate_End,76
    mov Y_coordinate_Start,72
    jmp SetDelete_CO

    Level2_forward:
    mov X_coordinate_Start,120  ;if move direction is forward (forward hint is taken) In Level Two
    mov X_coordinate_End,124
    mov Y_coordinate_End,88
    mov Y_coordinate_Start,84

    SetDelete_CO:

    mov di,Forward_Icon_End_Row        ;Set Coordinate of the hint to be deleted
	mov Delete_Y_coordinate_End,di

	mov di,Forward_Icon_Start_Row
    dec di
	mov Delete_Y_coordinate_Start,di

	mov di,Forward_Icon_Start_Column
    dec di
	mov Delete_X_coordinate_Start,di

	mov di,Forward_Icon_End_Column
	mov Delete_X_coordinate_End,di

    call deletePlayer                   ;To Delete Hint
    jmp RETURN
    Back:                               ;if move direction is backward (backward hint is taken)
    cmp Level,2
    je Level2_Back
    mov X_coordinate_Start,162          ;Coordinates in Level one
    mov X_coordinate_End,166
    mov Y_coordinate_End,66
    mov Y_coordinate_Start,62
     
    jmp SetDelete_CO_Back

    Level2_Back:
    mov X_coordinate_Start,45  ;if move direction is backward (backward hint is taken) IN level 2
    mov X_coordinate_End,49
    mov Y_coordinate_End,102
    mov Y_coordinate_Start,98
    SetDelete_CO_Back: 

    mov di,Backward_Icon_End_Row        ;Set Coordinate of the hint to be deleted
	mov Delete_Y_coordinate_End,di

	mov di,Backward_Icon_Start_Row
    dec di
	mov Delete_Y_coordinate_Start,di

	mov di,Backward_Icon_Start_Column
    dec di
	mov Delete_X_coordinate_Start,di

	mov di,Backward_Icon_End_Column
	mov Delete_X_coordinate_End,di

    call deletePlayer                    ;To Delete Hint
    RETURN:
	ret
MoveForward ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; To Freeze the player ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;description
FreezePlayer PROC

    mov di,Freeze_Icon_End_Row        ;Set Coordinate of the hint to be deleted
	mov Delete_Y_coordinate_End,di

	mov di,Freeze_Icon_Start_Row
    dec di
	mov Delete_Y_coordinate_Start,di

	mov di,Freeze_Icon_Start_Column
    dec di
	mov Delete_X_coordinate_Start,di

	mov di,Freeze_Icon_End_Column
    inc di
	mov Delete_X_coordinate_End,di

    call deletePlayer    

     ;the satus and speed of player to be freezed
    mov bx,0
    mov currentSpeed,bx
    mov bx,1  
    mov StatusPlayer1,1
    mov StatusPlayer2,1
    
    ; to get the system time
    mov ah,2
    int 1Ah   ; ch=hours / cl =minutes / dh =seconds 
    mov StartTimePlayer1Ch,Ch 
    mov StartTimePlayer1CL,cl      
    mov StartTimePlayer1Dh ,Dh   
    ret
FreezePlayer ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; To Speed The Player ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;description
SpeedPlayer PROC
    mov di,SpeedUP_Icon_End_Row        ;Set Coordinate of the hint to be deleted
	mov Delete_Y_coordinate_End,di

	mov di,SpeedUP_Icon_Start_Row
    dec di
	mov Delete_Y_coordinate_Start,di

	mov di,SpeedUP_Icon_Start_Column
    dec di
	mov Delete_X_coordinate_Start,di

	mov di,SpeedUP_Icon_End_Column
    inc di
	mov Delete_X_coordinate_End,di

    call deletePlayer  

      ;the satus and speed of player to be freezed
    mov bx,4
    mov currentSpeed,bx
    mov bx,2  
    mov StatusPlayer1,2
    mov StatusPlayer2,2
    
    ; to get the system time
    mov ah,2
    int 1Ah   ; ch=hours / cl =minutes / dh =seconds 
    mov StartTimePlayer1Ch,Ch 
    mov StartTimePlayer1CL,cl      
    mov StartTimePlayer1Dh ,Dh  

    ret
SpeedPlayer ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Reset Player Speed ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;description
CheckResetPlayerSpeed PROC

    ; The Bx will sotre the time difference in seconds between current
    ; Time and the time the player took the hint

    ; to get the system time
    mov ah,2
    int 1Ah   ; ch=hours / cl =minutes / dh =seconds 

    mov bx,0
    cmp StartTimePlayer1Ch,ch
    je CalculateMinutes
    mov bx,3600
    CalculateMinutes:cmp StartTimePlayer1CL ,cl
    je CalculateSeconds
    cmp bx,0
    je AddingMinutes
    ; sub bx,3540
    mov bx,60
    jmp CalculateSeconds
    AddingMinutes:mov bx,60
    CalculateSeconds:cmp StartTimePlayer1DH,dh
    je ActionToTake
    jG StartSecondsGreater
    sub dh,StartTimePlayer1DH
    mov cl,dh
    mov ch,0
    cmp bx,0
    je AddSeconds
    sub bx,cx
    jmp ActionToTake


    StartSecondsGreater:
    mov cl,StartTimePlayer1DH
    sub cl,dh
    mov ch,0
    cmp bx,0
    je AddSeconds
    sub bx,cx
    jmp ActionToTake

    AddSeconds:mov bx,cx
    

    ActionToTake:
    cmp bx,SpeedChangedClicks 
    jl EndCheckSpeed

    ; retrun to noraml speed
    mov bx,2
    mov currentSpeed,bx
    mov bx,0 
    mov StatusPlayer1,0
    mov StatusPlayer2,0

EndCheckSpeed:
    ret
CheckResetPlayerSpeed ENDP

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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;UTILITY FUNCTIONS USED IN DRAWING THE MAZE LEVEL TWO;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;drow horizontal gaps or blocks
Drowhorizontal PROC FAR
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
Drowhorizontal ENDP
;;;drow vertical blocks or gaps
Drowvertical PROC far
      mov dx,dx1
      mov al,Color
        mov cx,cx1
        Gap3:int 10h
        inc dx
        cmp dx,dx2
        jnz Gap3
        ret
Drowvertical ENDP 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;END OF UTILITY FUNCTIONS USED IN DRAWING THE MAZE LEVEL TWO;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;UTILITY FUNCTIONS USED IN DRAWING THE MAZE LEVEL ONE;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;drow horizontal gaps or blocks
Drow1 PROC FAR
      mov dx,dx1
      mov al,Color
        Gapline1:
        mov cx,cx1
        Gap1:int 10h
        inc cx 
        cmp cx,cx2
        jnz Gap1
        add dx ,12
        cmp  dx,dx2
        jb Gapline1
        ret
Drow1 ENDP
;;;drow vertical blocks or gaps
Drow2 PROC far
      mov al,Color
        mov cx,cx1
        Gapline2:
        mov dx,dx1
        Gap2:int 10h
        inc dx
        cmp dx,dx2
        jnz Gap2
        add cx,15
        cmp cx,cx2
        jne Gapline2
        ret
Drow2 ENDP 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;END OF UTILITY FUNCTIONS USED IN DRAWING  MAZE LEVEL ONE;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;DRAWING  MAZE OF LEVEL ONE;;;;;;;;;;;;;;;;;;;;;;;;;;;
DrawMaze1 PROC FAR

    ;;;;drow the maze border
        mov ah,0ch
        mov cx,100
        mov dx,20
        mov al,11
        above:int 10h
        inc cx
        cmp cx,220
        jnz above
        mov cx,100
        mov dx,116
        mov al,11
        below:int 10h
        inc cx
        cmp cx,220
        jnz below
        mov cx1,100
        mov cx2,235
        mov dx1,20
        mov dx2,116
        mov Color,11
        call Drow2

       ;In this part we start to change cx,dx to drow the details of the maze
        mov cx1,100
        mov cx2,115
        mov dx1,44
        mov dx2,56
        mov Color,11
        call Drow1

        mov cx1,100
        mov cx2,115
        mov dx1,80
        mov dx2,92
        mov Color,11
        mov dx,dx1
        mov al,Color
        call Drow1
        
        mov cx1,100
        mov cx2,115
        mov dx1,104
        mov dx2, 116
        mov Color,0
        call Drow2

        mov cx1,115
        mov cx2,130
        mov dx1,21
        mov dx2, 32
        mov Color,0
        call Drow2

        mov cx1,115
        mov cx2,130
        mov dx1,68
        mov dx2, 92
        mov Color,0
        call Drow2

        mov cx1,115
        mov cx2,130
        mov dx1,32
        mov dx2, 44
        mov Color,11
        call Drow1
        
        mov cx1,115
        mov cx2,145
        mov dx1,68
        mov dx2, 80
        mov Color,11
        call Drow1

        mov cx1,115
        mov cx2,130
        mov dx1,80
        mov dx2, 92
        mov Color,0
        call Drow1

        mov cx1,115
        mov cx2,160
        mov dx1,92
        mov dx2, 104
        mov Color,11
        call Drow1

        mov cx1,130
        mov cx2,145
        mov dx1,44
        mov dx2, 56
        mov Color,11
        call Drow2
        
        mov cx1,130
        mov cx2,145
        mov dx1,21
        mov dx2, 44
        mov Color,0
        call Drow2

        mov cx1,130
        mov cx2,145
        mov dx1,56
        mov dx2, 68
        mov Color,0
        call Drow2

        mov cx1,130
        mov cx2,145
        mov dx1,69
        mov dx2, 80
        mov Color,0
        call Drow2

        mov cx1,130
        mov cx2,145
        mov dx1,92
        mov dx2, 116
        mov Color,0
        call Drow2

        mov cx1,130
        mov cx2,145
        mov dx1,32
        mov dx2, 44
        mov Color,0
        call Drow1

        mov cx1,130
        mov cx2,145
        mov dx1,56
        mov dx2, 68
        mov Color,0
        call Drow1

        mov cx1,130
        mov cx2,145
        mov dx1,104
        mov dx2, 116
        mov Color,11
        call Drow1

        mov cx1,145
        mov cx2,160
        mov dx1,21
        mov dx2, 32
        mov Color,0
        call Drow2

        mov cx1,145
        mov cx2,160
        mov dx1,44
        mov dx2, 56
        mov Color,0
        call Drow2

        mov cx1,145
        mov cx2,160
        mov dx1,80
        mov dx2, 92
        mov Color,0
        call Drow2

        mov cx1,145
        mov cx2,160
        mov dx1,93
        mov dx2, 104
        mov Color,0
        call Drow2
        
        mov cx1,145
        mov cx2,160
        mov dx1,32
        mov dx2, 44
        mov Color,11
        call Drow1

        
        mov cx1,145
        mov cx2,160
        mov dx1,104
        mov dx2, 116
        mov Color,0
        call Drow1

        mov cx1,160
        mov cx2,175
        mov dx1,21
        mov dx2, 32
        mov Color,0
        call Drow2

        mov cx1,160
        mov cx2,175
        mov dx1,69
        mov dx2, 80
        mov Color,0
        call Drow2

        mov cx1,160
        mov cx2,175
        mov dx1,81
        mov dx2, 116
        mov Color,0
        call Drow2

        mov cx1,160
        mov cx2,175
        mov dx1,68
        mov dx2,92
        mov Color,0
        call Drow2

        mov cx1,160
        mov cx2,175
        mov dx1,68
        mov dx2,80
        mov Color,11
        call Drow1
        
        mov cx1,160
        mov cx2,175
        mov dx1,104
        mov dx2,116
        mov Color,11
        call Drow1

        mov cx1,175
        mov cx2,190
        mov dx1,21
        mov dx2,44
        mov Color,0
        call Drow2

        mov cx1,175
        mov cx2,190
        mov dx1,69
        mov dx2,80
        mov Color,0
        call Drow2


        mov cx1,175
        mov cx2,190
        mov dx1,105
        mov dx2,116
        mov Color,0
        call Drow2


        mov cx1,175
        mov cx2,190
        mov dx1,44
        mov dx2,56
        mov Color,11
        call Drow1

        mov cx1,190
        mov cx2,205
        mov dx1,56
        mov dx2,68
        mov Color,11
        call Drow1


        mov cx1,190
        mov cx2,205
        mov dx1,56
        mov dx2,68
        mov Color,11
        call Drow2

        mov cx1,190
        mov cx2,205
        mov dx1,21
        mov dx2,44
        mov Color,0
        call Drow2

        mov cx1,190
        mov cx2,205
        mov dx1,57
        mov dx2,68
        mov Color,0
        call Drow2

        mov cx1,190
        mov cx2,205
        mov dx1,81
        mov dx2,92
        mov Color,0
        call Drow2

        mov cx1,190
        mov cx2,205
        mov dx1,105
        mov dx2,116
        mov Color,0
        call Drow2

        mov cx1,175
        mov cx2,205
        mov dx1,32
        mov dx2,44
        mov Color,11
        call Drow1

        mov cx1,145
        mov cx2,190
        mov dx1,80
        mov dx2, 92
        mov Color,11
        call Drow1

        mov cx1,130
        mov cx2,145
        mov dx1,44
        mov dx2, 56
        mov Color,11
        call Drow1

        mov cx1,190
        mov cx2,205
        mov dx1,92
        mov dx2, 116
        mov Color,11
        call Drow1

        mov cx1,205
        mov cx2,220
        mov dx1,45
        mov dx2, 56
        mov Color,0
        call Drow2

        mov cx1,205
        mov cx2,220
        mov dx1,93
        mov dx2, 116
        mov Color,0
        call Drow2

        mov cx1,205
        mov cx2,220
        mov dx1,92
        mov dx2, 104
        mov Color,11
        call Drow1

        mov cx1,220
        mov cx2,235
        mov dx1,21
        mov dx2, 32
        mov Color,0
        call Drow2
        ret
DrawMaze1 ENDP   

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;DRAWING THE MAZE OF LEVEL TWO;;;;;;;;;;;;;;;;;;;;;;;;;;;
DrawMaze2 PROC FAR
            ;;;drow the maze border
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
        call Drowhorizontal


        mov cx1,31
        mov cx2,41
        mov dx1,34
        mov dx2,48
        mov Color,0
        call Drowhorizontal


        mov cx1,31
        mov cx2,41
        mov dx1,55
        mov dx2,69
        mov Color,0
        call Drowhorizontal


        mov cx1,31
        mov cx2,41
        mov dx1,97
        mov dx2,132
        mov Color,0
        call Drowhorizontal


        mov cx1,42
        mov dx1,97
        mov dx2,104
        mov Color,9
        call Drowvertical


        mov cx1,43
        mov dx1,111
        mov dx2,118
        mov Color,9
        call Drowvertical


        mov cx1,42
        mov cx2,52
        mov dx1,76
        mov dx2,83
        mov Color,0
        call Drowhorizontal


        mov cx1,52
        mov dx1,34
        mov dx2,41
        mov Color,9
        call Drowvertical


        mov cx1,52
        mov dx1,55
        mov dx2,62
        mov Color,9
        call Drowvertical


        mov cx1,52
        mov cx2,62
        mov dx1,34
        mov dx2,41
        mov Color,0
        call Drowhorizontal


        mov cx1,62
        mov cx2,72
        mov dx1,48
        mov dx2,55
        mov Color,0
        call Drowhorizontal


        mov cx1,62
        mov cx2,72
        mov dx1,90
        mov dx2,97
        mov Color,0
        call Drowhorizontal


        mov cx1,72
        mov dx1,76
        mov dx2,83
        mov Color,9
        call Drowvertical


        mov cx1,72
        mov dx1,104
        mov dx2,111
        mov Color,9
        call Drowvertical


        mov cx1,75
        mov dx1,90
        mov dx2,97
        mov Color,9
        call Drowvertical


        mov cx1,72
        mov cx2,82
        mov dx1,104
        mov dx2,125
        mov Color,0
        call Drowhorizontal


        mov cx1,72
        mov cx2,82
        mov dx1,83
        mov dx2,90
        mov Color,0
        call Drowhorizontal


         mov cx1,72
        mov cx2,82
        mov dx1,62
        mov dx2,69
        mov Color,0
        call Drowhorizontal


        mov cx1,72
        mov cx2,82
        mov dx1,27
        mov dx2,34
        mov Color,0
        call Drowhorizontal


        mov cx1,85
        mov dx1,27
        mov dx2,34
        mov Color,9
        call Drowvertical


        mov cx1,85
        mov dx1,55
        mov dx2,62
        mov Color,9
        call Drowvertical


        mov cx1,85
        mov dx1,104
        mov dx2,111
        mov Color,9
        call Drowvertical


        mov cx1,90
        mov dx1,90
        mov dx2,97
        mov Color,9
        call Drowvertical


        mov cx1,90
        mov cx2,100
        mov dx1,41
        mov dx2,48
        mov Color,0
        call Drowhorizontal


        mov cx1,90
        mov cx2,100
        mov dx1,90
        mov dx2,97
        mov Color,0
        call Drowhorizontal


        mov cx1,105
        mov dx1,34
        mov dx2,41
        mov Color,9
        call Drowvertical


        mov cx1,105
        mov cx2,115
        mov dx1,34
        mov dx2,41
        mov Color,0
        call Drowhorizontal


        mov cx1,130
        mov cx2,140
        mov dx1,111
        mov dx2,118
        mov Color,0
        call Drowhorizontal


        mov cx1,135
        mov dx1,125
        mov dx2,132
        mov Color,9
        call Drowvertical


        mov cx1,125
        mov dx1,118
        mov dx2,125
        mov Color,9
        call Drowvertical


        mov cx1,150
        mov dx1,41
        mov dx2,48
        mov Color,9
        call Drowvertical


        mov cx1,180
        mov dx1,104
        mov dx2,118
        mov Color,9
        call Drowvertical


        mov cx1,180
        mov cx2,190
        mov dx1,97
        mov dx2,104
        mov Color,0
        call Drowhorizontal


        mov cx1,180
        mov cx2,190
        mov dx1,118
        mov dx2,125
        mov Color,0
        call Drowhorizontal


        mov cx1,150
        mov cx2,160
        mov dx1,69
        mov dx2,76
        mov Color,0
        call Drowhorizontal


        mov cx1,180
        mov cx2,190
        mov dx1,76
        mov dx2,83
        mov Color,0
        call Drowhorizontal


        mov cx1,190
        mov cx2,210
        mov dx1,125
        mov dx2,132
        mov Color,0
        call Drowhorizontal


        mov cx1,200
        mov dx1,34
        mov dx2,41
        mov Color,9
        call Drowvertical


        mov cx1,200
        mov dx1,62
        mov dx2,83
        mov Color,9
        call Drowvertical


        mov cx1,200
        mov cx2,220
        mov dx1,27
        mov dx2,55
        mov Color,0
        call Drowhorizontal


        mov cx1,200
        mov cx2,220
        mov dx1,62
        mov dx2,90
        mov Color,0
        call Drowhorizontal


        mov cx1,200
        mov cx2,220
        mov dx1,104
        mov dx2,118
        mov Color,0
        call Drowhorizontal


        mov cx1,210
        mov dx1,20
        mov dx2,125
        mov Color,9
        call Drowvertical
        RET
DrawMaze2 ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;END OF DRAWING THE MAZE;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;UTILITY FUNCTIONS USED IN DRAWING HINTS;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  \
;   \
;   /
;  /
DrawARightArrow PROC FAR
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
DrawALeftArrow PROC FAR
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
DrawAHorizontalLine PROC FAR
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
DrawForwardHint PROC FAR

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


DrawBackwardHint PROC FAR
    
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

DrawFreezeHint PROC FAR
    
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

DrawSpeedUpHint PROC FAR
        
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
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Drow Status Bar;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrowStatusBar PROC far

   ;clear the screen
    Mov ax, 03h
    int 10h


    mov ah,0
    mov al,13h
    int 10h
   ;DROW PLAYER1 NAME

lea di,Player1_Name+2                       ;THE START OF THE NAME
mov bl,Player1_Name+1   
inc bl
mov bh,0
push bx

; SET THE CURSOR TO THE TOP LEFT CORNER 
mov dl,0
mov dh,0
mov bh,0

NOTENDSTRING:
 mov bx,5
 mov ah,2
 inc dl
 int 10h
 mov ah,9
 mov al,[di]
 mov cx,1
 int 10h
 inc di
 pop bx
 dec bx
 push bx
 cmp bx,0
jne NOTENDSTRING
 mov ah,9
 mov bh,0
 mov al,':'
 mov cx,1
 mov bl,05
 int 10h
pop bx

;Drow Status Player1

inc dl 
mov ah,2
mov bh,0    
int 10h           ;setting cursor in its right position to write status 
cmp StatusPlayer1,0
jne NotNormal
lea dx,NormalStatus 
jmp PrintStatusP1                     
NotNormal:
cmp StatusPlayer1,1
jne NotFrozen 
lea dx,FrozenStatus
jmp PrintStatusP1
NotFrozen:
lea dx,SpeededUpStatus
PrintStatusP1:
mov ah,09
int 21h

;DROW PLAYER2 NAME

lea di,Player2_Name+2                       ;THE START OF THE NAME
mov bl,Player2_Name+1   
inc bl
mov bh,0
push bx

; SET THE CURSOR TO THE TOP LEFT CORNER 

mov dl,20
mov dh,0
mov bh,0

NOTENDSTRING2:
 mov bx,1
 mov ah,2
 inc dl
 int 10h
 mov ah,9
 mov al,[di]
 mov cx,1
 int 10h
 inc di
 pop bx
 dec bx
 push bx
 cmp bx,0
jne NOTENDSTRING2
 mov ah,9
 mov bh,0
 mov al,':'
 mov cx,1
 mov bl,01
 int 10h
pop bx
 
;Drow Status Player2

inc dl 
mov ah,2
mov bh,0    
int 10h           ;setting cursor in its right position to write status 
cmp StatusPlayer2,0
jne NotNormal2
lea dx,NormalStatus 
jmp PrintStatusP2  

NotNormal2:
cmp StatusPlayer2,1
jne NotFrozen2 
lea dx,FrozenStatus
jmp PrintStatusP2

NotFrozen2:
lea dx,SpeededUpStatus

PrintStatusP2:
mov ah,09
int 21h

ret
DrowStatusBar ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;DRAW LEVEL 2;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;description
DrawLevel2 PROC FAR


     ;SET LEVEL 
    mov Level,2

    ;Initializing the maze
    call DrawMaze2


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
;description
movRight PROC FAR
    ;the si is a counter that counts the number of single right moves we will perform 
    ;A right move consists of (currentspeed) single right moves 
    ;We'll excute this function currentspeed times or till we face an invalid single right move 
    mov si,0
    
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Wall constrain;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;checking the validity of moving right
    ;setting attributes for reading the pixel color (note that the color is returned in al)
    Continue_The_Right_Move_If_Valid: 
    mov AH,0Dh	
    mov BH,0
    
    ;setting dx and cx to scan through the column right to the player
    mov dx,Y_coordinate_End
    mov cx,X_coordinate_End
    ;the column just right to the player
    inc cx
    
    ;Scanning is done from buttom to top
    Continue_Scanning_Right_Column: 
    ;Read graphics pixel and comparing it with the Maze color
    int 10h
    cmp al,9h
    JE Going_To_End_Of_Moving_Right
    dec dx
    cmp dx,Y_coordinate_Start
    JG Continue_Scanning_Right_Column
    
    call CheckHintRight
    mov movedirection,0
	cmp HintExist,0 ; if there is no hint near next move --> do nothing
	JE NO_HintRight ;continue normally
    cmp HintExist,9
    je NO_HintRight
    mov bl,Forward_Color
    cmp HintExist,bl       ; if there is forward move hint in next move --> set move direction and apply hint
    jne Hint2R
    mov movedirection,1                ; if there is backward move hint in next move --> reset move direction and apply hint
    call MoveForward
    jmp initializePlayerR
    Hint2R:
    mov bl,Backward_Color
    cmp HintExist,bl
    jne Hint3R 
    call MoveForward
	jmp initializePlayerR
    Hint3R :
    mov bl,Freeze_Color 
    cmp HintExist,bl
    jne Hint4R 
    call FreezePlayer
    ; call DrowStatusBar          ;to be uncommented
    Hint4R :
    mov bl,SpeedUP_Left_Part_Color 
    cmp HintExist,bl
    jne NO_HintRight
    call SpeedPlayer
    ; call DrowStatusBar          ;to be uncommented
	NO_HintRight:  ;If There Is No Hint Continue Normally

    ;This lines is done to JUMP TWICE TILL THE END OF THE PROCEDURE IF THE PLAYER DON'T HAVE THE CREDIT TO MOVE RIGHT
    JMP SKIP_THIS_R
    Going_To_End_Of_Moving_Right: JMP End_Of_Moving_Right
    SKIP_THIS_R:

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;the moving logic;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    ; First Lets check if he is not in normal speed
    cmp StatusPlayer1,0
    je MovingRightItself
    call CheckResetPlayerSpeed 

	MovingRightItself:
    mov di,Y_coordinate_End
	mov Delete_Y_coordinate_End,di

	mov di,Y_coordinate_Start
	mov Delete_Y_coordinate_Start,di

	mov di,X_coordinate_Start
	mov Delete_X_coordinate_Start,di

	mov di,X_coordinate_Start
	inc di
	mov Delete_X_coordinate_End,di  

	call deletePlayer

	mov di,X_coordinate_End
	inc di
	mov X_coordinate_End,di
	
	mov di,X_coordinate_Start
	inc di
	mov X_coordinate_Start,di
	
    initializePlayerR:
	call initializePlayer
    mov HintExist,0   ;reset hint exist

    ;check if we performed {#currentSpeed} single right moves or not
    inc si
    cmp si,currentSpeed
    JE End_Of_Moving_Right
    JMP Continue_The_Right_Move_If_Valid

    End_Of_Moving_Right:
	ret
movRight ENDP

;description
movLeft PROC FAR
    ;the si is a counter that counts the number of single left moves we will perform 
    ;A left move consists of (currentspeed) single left moves 
    ;We'll excute this function currentspeed times or till we face an invalid single left move 
    mov si,0
    
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Wall constrain;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;checking the validity of moving left
    ;setting attributes for reading the pixel color
    ;note that the color is returned in al
    Continue_The_Left_Move_If_Valid:
    mov AH,0Dh	
    mov BH,0
    
    ;setting dx and cx to scan through the column left the player
    mov dx,Y_coordinate_End
    ;the column just left to the player
    mov cx,X_coordinate_Start
    
    ;scanning is done from bottom to top
    Continue_Scanning_Left_Column: 
    ;Read graphics pixel and comparing it with the Maze color
    int 10h
    cmp al,9h
    JE Going_To_End_Of_Moving_Left
    dec dx
    cmp dx,Y_coordinate_Start
    ;continue scanning as long as dx is greater that the player's start
    JG Continue_Scanning_Left_Column

    call CheckHintLeft
	mov movedirection,0
	cmp HintExist,0 ; if there is no hint near next move --> do nothing
	JE NO_HintLeft ;continue normally
    cmp HintExist,9
    je NO_HintLeft
    mov bl,Forward_Color
    cmp HintExist,bl       ; if there is forward move hint in next move --> set move direction and apply hint
    jne Hint2L
    mov movedirection,1                ; if there is backward move hint in next move --> reset move direction and apply hint
    call MoveForward
    jmp initializePlayerR
    Hint2L:
    mov bl,Backward_Color
    cmp HintExist,bl
    jne Hint3L
    call MoveForward
	jmp initializePlayerR
    Hint3L:
    mov bl,Freeze_Color 
    cmp HintExist,bl
    jne Hint4L
    call FreezePlayer
    ; call DrowStatusBar          ;to be uncommented
    Hint4L:
    mov bl,SpeedUP_Left_Part_Color 
    cmp HintExist,bl
    jne NO_HintLeft
    call SpeedPlayer
    ; call DrowStatusBar          ;to be uncommented
	NO_HintLeft:  ;If There Is No Hint Continue Normally

    ;This lines is done to JUMP TWICE TILL THE END OF THE PROCEDURE IF THE PLAYER DON'T HAVE THE CREDIT TO MOVE Left
    JMP SKIP_THIS_L
    Going_To_End_Of_Moving_Left: JMP End_Of_Moving_Left
    SKIP_THIS_L:

    ; First Lets check if he is not in normal speed
    cmp StatusPlayer1,0
    je MovingLeftItself
    call CheckResetPlayerSpeed 

	MovingLeftItself:
	mov di,Y_coordinate_End
	mov Delete_Y_coordinate_End,di

	mov di,Y_coordinate_Start
	mov Delete_Y_coordinate_Start,di

	mov di,X_coordinate_End
	dec di
	mov Delete_X_coordinate_Start,di

	mov di,X_coordinate_End
	mov Delete_X_coordinate_End,di

	call deletePlayer
	
	mov di,X_coordinate_End
	dec di
	mov X_coordinate_End,di
	
	mov di,X_coordinate_Start
	dec di
	mov X_coordinate_Start,di

	initializePlayerl:
	call initializePlayer
    
    ;check if we performed {#currentSpeed} single left moves or not
    inc si
    cmp si,currentSpeed
    JE End_Of_Moving_Left
    JMP Continue_The_Left_Move_If_Valid
	
    End_Of_Moving_Left:
    ret
movLeft ENDP

;description
movUP PROC FAR
    ;the si is a counter that counts the number of single up moves we will perform 
    ;An up move consists of (currentspeed) single up moves 
    ;We'll excute this function currentspeed times or till we face an invalid single up move 
    mov si,0
    
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Wall constrain;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;checking the validity of moving up
    ;setting attributes for reading the pixel color
    ;note that the color is returned in al
    Continue_The_Up_Move_If_Valid:
    mov AH,0Dh	
    mov BH,0
    
    ;setting dx and cx to scan through the row above the player
    ;dx holds the coordinate of the row just above the player
    mov dx,Y_coordinate_Start
    mov cx,X_coordinate_End
    
    ;scanning is done from left to right
    Continue_Scanning_Upper_Row: 
    ;Read graphics pixel and comparing it with the Maze color
    int 10h
    cmp al,9h
    JE Going_To_End_Of_Moving_Up
    dec cx
    cmp cx,X_coordinate_Start
    JG Continue_Scanning_Upper_Row
    
    call CheckHintUP
	mov movedirection,0
	cmp HintExist,0 ; if there is no hint near next move --> do nothing
	JE NO_HintUP ;continue normally
    cmp HintExist,9
    je NO_HintUP
    mov bl,Forward_Color
    cmp HintExist,bl       ; if there is forward move hint in next move --> set move direction and apply hint
    jne Hint2U
    mov movedirection,1                ; if there is backward move hint in next move --> reset move direction and apply hint
    call MoveForward
    jmp initializePlayerU
    Hint2U:
    mov bl,Backward_Color
    cmp HintExist,bl
    jne Hint3U
    call MoveForward
	jmp initializePlayerU
    Hint3U:
    mov bl,Freeze_Color 
    cmp HintExist,bl
    jne Hint4U
    call FreezePlayer
    ; call DrowStatusBar          ;to be uncommented
    Hint4U:
     mov bl,SpeedUP_Left_Part_Color 
    cmp HintExist,bl
    jne NO_HintUP
    call SpeedPlayer
    ; call DrowStatusBar          ;to be uncommented
     NO_HintUP:

    JMP SKIP_THIS_U
    Going_To_End_Of_Moving_Up: JMP End_Of_Moving_Up
    SKIP_THIS_U:
    
    ; First Lets check if he is not in normal speed
    cmp StatusPlayer1,0
    je MovingUpItself
    call CheckResetPlayerSpeed 

	MovingUpItself:
    mov di,Y_coordinate_End
	mov Delete_Y_coordinate_End,di

	mov di,Y_coordinate_End
	dec di
	mov Delete_Y_coordinate_Start,di

	mov di,X_coordinate_Start
	mov Delete_X_coordinate_Start,di

	mov di,X_coordinate_End
	mov Delete_X_coordinate_End,di
	
	call deletePlayer
	
	mov di,Y_coordinate_End
	dec di
	mov Y_coordinate_End,di
	
	mov di,Y_coordinate_Start
	dec di
	mov Y_coordinate_Start,di

	initializePlayerU :
	call initializePlayeR
	
    ;check if we performed {#currentSpeed} single up moves or not
    inc si
    cmp si,currentSpeed
    JE End_Of_Moving_Up
    JMP Continue_The_Up_Move_If_Valid
	
    End_Of_Moving_Up:
	ret
movUP ENDP

;description
movDown PROC FAR
    ;the si is a counter that counts the number of single down moves we will perform 
    ;A down move consists of (currentspeed) single down moves 
    ;We'll excute this function currentspeed times or till we face an invalid single down move 
    mov si,0
    
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Wall constrain;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;checking the validity of moving down
    ;setting attributes for reading the pixel color
    ;note that the color is returned in al
    Continue_The_Down_Move_If_Valid:
    mov AH,0Dh	
    mov BH,0
    
    ;setting dx and cx to scan through the row below the player
    ; dx holds the coordinate of the row just below the player
    mov dx,Y_coordinate_End
    inc dx
    mov cx,X_coordinate_End
    
    ;scanning is done from left to right
    Continue_Scanning_Below_Row: 
    ;Read graphics pixel and comparing it with the Maze color
    int 10h
    cmp al,9h
    JE Going_To_End_Of_Moving_Down
    dec cx
    cmp cx,X_coordinate_Start
    JG Continue_Scanning_Below_Row
    
    call CheckHintDown
	mov movedirection,0
	cmp HintExist,0 ; if there is no hint near next move --> do nothing
	JE NO_HintDOWN ;continue normally
    cmp HintExist,9
    je NO_HintDOWN
    mov bl,Forward_Color
    cmp HintExist,bl       ; if there is forward move hint in next move --> set move direction and apply hint
    jne Hint2D
    mov movedirection,1                ; if there is backward move hint in next move --> reset move direction and apply hint
    call MoveForward
    
    jmp initializePlayerD
    Hint2D:
    mov bl,Backward_Color
    cmp HintExist,bl
    jne Hint3D
    call MoveForward
	jmp initializePlayerD
    Hint3D:
    mov bl,Freeze_Color 
    cmp HintExist,bl
    jne Hint4D
    call FreezePlayer
    ; call DrowStatusBar          ;to be uncommented
    Hint4D:
     mov bl,SpeedUP_Left_Part_Color 
    cmp HintExist,bl
    jne NO_HintDOWN
    call SpeedPlayer
    ; call DrowStatusBar          ;to be uncommented
    NO_HintDOWN:
    
    JMP SKIP_THIS_D
    Going_To_End_Of_Moving_Down: JMP End_Of_Moving_Down
    SKIP_THIS_D:
    
    ;deleting the mosttop row

    ; First Lets check if he is not in normal speed
    cmp StatusPlayer1,0
    je MovingDownItself
    call CheckResetPlayerSpeed 

	MovingDownItself:
    mov di,Y_coordinate_Start
	inc di
	mov Delete_Y_coordinate_End,di

	mov di,Y_coordinate_Start
	mov Delete_Y_coordinate_Start,di

	mov di,X_coordinate_Start
	mov Delete_X_coordinate_Start,di

	mov di,X_coordinate_End
	mov Delete_X_coordinate_End,di
	
	call deletePlayer
	
	mov di,Y_coordinate_End
	inc di
	mov Y_coordinate_End,di
	
	mov di,Y_coordinate_Start
	inc di
	mov Y_coordinate_Start,di

	initializePlayerD:
	call initializePlayer
	
    ;check if we performed {#currentSpeed} single down moves or not
    inc si
    cmp si,currentSpeed
    JE End_Of_Moving_Down
    JMP Continue_The_Down_Move_If_Valid

    End_Of_Moving_Down:
	ret
movDown ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;END OF MOVING LOGIC FOR PLAYER1;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;END OF LOGIC PROCEDURES;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Level2 Screen;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;description
Level2Screen PROC FAR
    
   
     ;Drow Status Bar
    call DrowStatusBar


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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;DROW LEVEL ONE;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
DrawLevel1 PROC FAR
;;clear screen
    ; mov ax,0600h
    ; mov cx,0
    ; mov bh,0
    ; mov dx,184fh
    ; int 10h
    
    ; ;;;;graphic mode 
    ; mov ah,0
    ; mov al,13h
    ; int  10h
    ;SET LEVEL 
    mov Level,1
    ;Initializing the maze
    call DrawMaze1
    ;Initializing Hintss Coordinates
    mov Forward_Icon_Start_Column ,130
    mov Forward_Icon_Start_Row ,110
    mov Forward_Icon_End_Row , 114
    mov Forward_Icon_End_Column ,134


    ;Backward hint data
    mov Backward_Icon_Start_Column ,193
    mov Backward_Icon_Start_Row , 95
    mov Backward_Icon_End_Row ,99
    mov Backward_Icon_End_Column , 197


    ;Freeze hint data
    mov Freeze_Icon_Start_Column ,140
    mov Freeze_Icon_Start_Row , 50

    ;Speed Up hint data 
    mov SpeedUP_Icon_Start_Column ,120
    mov SpeedUP_Icon_Start_Row ,25

    ;Initializing the maze with all hints
    call DrawSpeedUpHint
    call DrawFreezeHint
    call DrawForwardHint
    call DrawBackwardHint

    ;Initializing player1 between the positions (X_coordinate_Start,Y_coordinate_Start) and (X_coordinate_End,Y_coordinate_End) 
    call initialDraw
    ret
DrawLevel1 ENDP
;description
Level1Screen PROC FAR
    
    ;Drow Status Bar
    call DrowStatusBar
     
    ;initialize the screen with the maze + the player + the hints
    call DrawLevel1

    ;MOVING LOGIC
    ;get key pressed
    getKeyPressed1:
    mov ah,0
    int 16h
    ;the key scancode is stored in al
    cmp ah,4Dh
    JE rightArrowKey1
    cmp ah,4Bh
    JE leftArrowKey1
    cmp ah,48h
    JE upArrowKey1
    cmp ah,50h
    JE downArrowKey1
    JMP getKeyPressed1
    rightArrowKey1: call movRight
    JMP getKeyPressed1
    leftArrowKey1: call movLeft
    JMP getKeyPressed
    upArrowKey1: call movUP
    JMP getKeyPressed1
    downArrowKey1: call movDown
    JMP getKeyPressed1
    
    Ret
Level1Screen ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ChooseLevelScreen PROC FAR


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
call Level1Screen
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
OptionsScreen PROC FAR

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

Enter_Name_Screen PROC FAR
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

        ;print enterName_request2
        mov ah,9h
        mov dx, offset enterName_request2
        int 21h
        
        ;get the name of player2 from the user
        mov ah, 0Ah
        mov dx,offset Player2_Name
        int 21h

        ;Set Cursor
        mov ah,2h
        mov dh, 14d    
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


;description
deletePlayer PROC
	       MOV CX,Delete_X_coordinate_End  	;set the width (X) up to 64 (based on image resolution)
	       MOV DX, Delete_Y_coordinate_End 	;set the height (Y) up to 64 (based on image resolution)
           MOV AH,0Ch   	;set the configuration to writing a pixel
           mov al, 0h     ; color of the current coordinates
	       MOV BH,00h   	;set the page number
	Deleteit:INT 10h      	;execute the configuration
	       DEC Cx
		   cmp Cx,Delete_X_coordinate_Start       	;  loop iteration in x direction
	       JNE Deleteit      	;  check if we can draw c urrent x and y and excape the y iteration
	       mov Cx, Delete_X_coordinate_End 	;  if loop iteration in y direction, then x should start over so that we sweep the grid
	       DEC DX       	;  loop iteration in y direction
	       cmp Dx,Delete_Y_coordinate_Start
		   JE  EndDeleting   	;  both x and y reached 00 so end program
		   Jmp Deleteit
	EndDeleting:
	ret
deletePlayer ENDP

;description
initializePlayer PROC
	       MOV CX, X_coordinate_End	;set the width (X) up to 64 (based on image resolution)
	       MOV DX, Y_coordinate_End	;set the hieght (Y) up to 64 (based on image resolution
	       MOV AH,0Ch   	;set the configuration to writing a pixel
           mov al,5
	       MOV BH,00h   	;set the page number
      Drawit: INT 10h      	;execute the configuration
	       DEC Cx
		   cmp Cx,X_coordinate_Start       	;  loop iteration in x direction
	       JNE Drawit      				;  check if we can draw c urrent x and y and excape the y iteration
	       mov Cx,X_coordinate_End 			;  if loop iteration in y direction, then x should start over so that we sweep the grid
	       DEC DX       				;  loop iteration in y direction
	       cmp Dx,Y_coordinate_Start
		   JE  END_drawing   			;  both x and y reached 00 so end program
		   Jmp Drawit
	END_drawing:
	ret
initializePlayer ENDP


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

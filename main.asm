
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

;Finishing the game Data
end1 db 'END GAME','$'
winner db 'The winner is ','$'
Nameofwinner db 'Nadeen','$' ;this data will be changed next
movtooptions db 'To move to the option screen please press Enter','$'
.code 
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
jz Level1Screen
; checking that the scan code is for 2
cmp ah,3
jz Level2Screen
; that means that the user clicked other key than those 3 stated
JMP keyPressed



Level1Screen:
mov ax,03h
int 10h

mov ah,9
mov dx,offset Level1Pressed
int 21h
JMP EndChooseLevelScreen


level2Screen:
mov ax,03h
int 10h

mov ah,9
mov dx,offset Level2Pressed
int 21h

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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Main PROC Far
Mov ax, @data 
mov ds ,ax

call Enter_Name_Screen
call finishgame

EndCode :
ret
Main ENDP
end Main


.Model Small
.stack 64 
.data
String1 db "* To start chatting press 1 $"
String2 db "* To Choose Game Level press 2 $"
String3 db "* To End The program press ESC $"

Level1 db "-For an Easy Level press 1 $"
Level2 db "-For a Hard Level Press 2 $"
Key1Pressed db " This is the Chatting screen $"
Level1Pressed db "This is Level 1 screen $"
Level2Pressed db "This is Level 2 screen $"


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
mov dx,offset String1
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
mov dx,offset String2
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
mov dx,offset String3
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

Main PROC Far
Mov ax, @data 
mov ds ,ax

call OptionsScreen

EndCode :
ret
Main ENDP
end Main

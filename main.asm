.MODEL small
.STACK 64
.DATA

.CODE 
Main proc far
mov ax, @data
mov ds ,ax 

;delete all screen
mov ax , 0600h
mov cx,0
mov  dx,184fh
int 10h


Main endp
end Main
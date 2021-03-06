; Problem 2 - Even Fibonacc numbers
; =================================
;
; Each new term in the Fibonacci sequence is generated by adding the previous 
; two terms. By starting with 1 and 2, the first 10 terms will be:
; 
; 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, ...
; 
; By considering the terms in the Fibonacci sequence whose values do not 
; exceed four million, find the sum of the even-valued terms.
;
.686
.model flat, stdcall

include main.inc

WriteInt PROTO value:DWORD
IsEvenNumber PROTO value:DWORD
.CONST

; welcomeMsg BYTE 'Hello World',0
; dwSizeOfMessage DWORD ($ - welcomeMsg)

.DATA? ; BSS

.DATA
hWnd DWORD ?

.CODE

main PROC
	LOCAL lastTerm:DWORD
	LOCAL currentTerm:DWORD
	LOCAL temp:DWORD
	LOCAL dwBytesWritten:DWORD
	LOCAL result:DWORD
	
	invoke GetStdHandle, STD_OUTPUT_HANDLE
	mov hWnd, eax
	
	mov result, 0
	mov lastTerm, 1
	mov currentTerm, 2
	
	xor eax, eax
	xor ebx, ebx
L1:
	invoke WriteInt, lastTerm
	mov eax, lastTerm
	mov ebx, currentTerm
	mov lastTerm, ebx
	add ebx, eax
	mov currentTerm, ebx
	
	invoke IsEvenNumber, lastTerm
	.if eax==0 ; Even
		mov eax, lastTerm
		add result, eax
	.endif
	
	cmp currentTerm, 4000000
	ja EXIT
	jmp L1
EXIT:
	invoke WriteInt, lastTerm
	invoke WriteInt, currentTerm
	nop
	 		
	invoke ExitProcess, EXIT_SUCCESS
main endp

WriteInt proc uses eax ebx ecx edx, value:DWORD
	LOCAL buffer[1024]:BYTE
	LOCAL dwCharsToWrite:DWORD
	LOCAL dwCharsWritten:DWORD
	
	
	mov eax, value
	mov ebx, 10
	xor ecx, ecx
L1:
	mov edx, 0
	div ebx
	push edx
	inc ecx
	cmp eax, 10
	jb EXIT
	jmp L1
EXIT:
	
	; Add characters to buffer
	add al, 030h
	mov buffer[0], al
	mov ebx, 1
L2:
	pop edx
	add dl, 030h
	mov buffer[ebx], dl
	inc ebx
	loop L2
	
	; Add Space character
	mov buffer[ebx], 020h
	inc ebx
	
	; Mark end of string
	mov buffer[ebx],0
	
	mov dwCharsToWrite, ebx
	invoke WriteConsole, hWnd, addr buffer, dwCharsToWrite, addr dwCharsWritten, 0
	
	ret
	
WriteInt endp

IsEvenNumber proc value:DWORD
	
	mov eax, value
	and eax, 1
	ret
IsEvenNumber endp

end main
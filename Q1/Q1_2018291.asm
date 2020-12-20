/* Name: KIRTI GAUTAM
   Roll_Number: 2018291 */
bits 16                      ;code starts with 16 bit
org 0x7c00		;assemble instructions from Origin 0x7c00

boot_1:		
	mov ax, 0x2401
	int 0x15
	mov ax, 0x3
	int 0x10
	cli
	lgdt [gdt_pointer]  ;load gdt
	mov eax, cr0
	or eax,0x1		;set bit to protected mode
	mov cr0, eax
	jmp CODE_SEG:boot_2018291	;jump to code segment
	
gdt_start:			;to enable 32 bit, we require Global Descriptor Table  
	dq 0x0
gdt_code:
	dw 0xFFFF
	dw 0x0
	db 0x0
	db 10011010b
	db 11001111b
	db 0x0
gdt_data:
	dw 0xFFFF
	dw 0x0
	db 0x0
	db 10010010b
	db 11001111b
	db 0x0
gdt_end:
gdt_pointer:
	dw gdt_end - gdt_start
	dd gdt_start

CODE_SEG equ gdt_code - gdt_start		;offsets into gdt
DATA_SEG equ gdt_data - gdt_start

bits 32			;start 32 bit mode
boot_2018291:
	mov ax, DATA_SEG
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	mov ss, ax
	mov esi,hello
	mov ebx,0xb8040	;position of string
	mov edx, cr0
  	mov ecx, 32          
    	mov ebx, 0xb8010	;position of cr0
    	
.loop:				;loop to print cr0 contents
    mov eax, 00000430h   	;red color on black bg
    shl edx, 1           	;protected bit
    adc eax, 0           	
    mov [ebx], ax
    add ebx, 2
    dec ecx
    jnz .loop
.loop2:		;loop to print hello world
	lodsb		;with each loop, a character is printed
	or al,al
	jz halt
	or eax,0x0400		;red on black string
	mov word [ebx], ax
	add ebx,2
	jmp .loop2
	

	
	
halt:
	cli
	hlt
hello: db "    HELLO, WORLD!!", 0

times 510 - ($-$$) db 0   ;510 minus the number of bytes before this position 
dw 0xaa55		;boot signature

section .data
    mensajeIngresarNum db 'Ingrese un numero (0-9): ', 0
    mensajeIngresarNum_len equ $ - mensajeIngresarNum

    mensajeDeError db 'Entrada invalida. Por favor ingrese un valor adecuado: ', 0
    mensajeDeError_len equ $ - mensajeDeError

    matrix db 9 dup(0) 
    matrixTranspuesta db 9 dup(0)  
    saltoDeLinea db 10, 0

section .bss
    input resb 2  ; Espacio para almacenar la entrada del usuario

section .text
    global _start

_start:
    ; Capturar los elementos de la matriz
    mov ecx, 9
    mov esi, matrix
    
cicloPrincipal:
    push ecx
    push esi
    call capturaDeNumero
    pop esi
    pop ecx
    mov [esi], al
    inc esi
    loop cicloPrincipal

    call transponerMatriz

    ; Muestra la matrix original
    mov ecx, 9
    mov esi, matrix
    call mostrarMatriz
    call mostrarSaltoDeLinea

    ; Muestra la matrix transpuesta
    mov ecx, 9
    mov esi, matrixTranspuesta
    call mostrarMatriz
    call mostrarSaltoDeLinea

    ; Se termina el programa
    call salidaDelPrograma

capturaDeNumero:
    ; Muestra el mensaje para solicitar el numero
    mov eax, 4
    mov ebx, 1
    mov edx, mensajeIngresarNum_len
    mov ecx, mensajeIngresarNum
    int 80h

capturaDeNumeroReintento:
    ; Lee lo que el usuario ingresa 
    mov eax, 3
    mov ebx, 0
    mov ecx, input
    mov edx, 2
    int 80h

    ; Valida que el input sea un número del 0 al 9
    mov al, [input]
    cmp al, '0'
    jb inputInvalido  ; <0 = invalido 

    cmp al, '9'
    ja inputInvalido  ; >9 = invalido

    ; Verifica si se ingresó más de un carácter
    mov ah, [input+1]
    cmp ah, 10        ; Verifica si el segundo carácter es una nueva línea (Enter)
    jne inputInvalido2

    sub al, '0'  ; Convierte a numero
    ret

inputInvalido:
    ; Muestra que el input es invalido
    mov eax, 4
    mov ebx, 1
    mov edx, mensajeDeError_len
    mov ecx, mensajeDeError
    int 80h
    jmp capturaDeNumeroReintento
    
inputInvalido2:
    jmp capturaDeNumeroReintento

transponerMatriz:
    mov esi, matrix
    mov edi, matrixTranspuesta

    mov al, [esi]
    mov [edi], al
    mov al, [esi+1]
    mov [edi+3], al
    mov al, [esi+2]
    mov [edi+6], al

    mov al, [esi+3]
    mov [edi+1], al
    mov al, [esi+4]
    mov [edi+4], al
    mov al, [esi+5]
    mov [edi+7], al

    mov al, [esi+6]
    mov [edi+2], al
    mov al, [esi+7]
    mov [edi+5], al
    mov al, [esi+8]
    mov [edi+8], al

    ret

mostrarMatriz:
    mov ecx, 3

mostrarMatrizFila:
    push ecx
    mov ecx, 3

mostrarMatrizColumna:
    push ecx
    push esi
    call mostrarNumero
    pop esi
    pop ecx
    inc esi
    loop mostrarMatrizColumna
    call mostrarSaltoDeLinea
    pop ecx
    loop mostrarMatrizFila
    ret

mostrarNumero:
    mov al, [esi]
    add al, '0'
    mov [input], al
    mov eax, 4
    mov ebx, 1
    mov ecx, input
    mov edx, 1
    int 80h
    ret

mostrarSaltoDeLinea:
    mov eax, 4
    mov ebx, 1
    mov ecx, saltoDeLinea
    mov edx, 1
    int 80h
    ret

salidaDelPrograma:
    mov eax, 1
    xor ebx, ebx
    int 80h
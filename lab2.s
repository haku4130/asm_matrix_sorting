bits    64
; Sorting columns of matrix by min elements using insertion sort with binary search
section .data
n:
        dd      3
m:
        dd      5
matrix:
        dd      4, 6, 1, 8, 2
        dd      1, 2, 3, 4, 5
        dd      0, -7, 3, -1, -1
min:
        dd      0, 0, 0, 0, 0
section .text
global  _start
_start:
        mov     ecx, [m]
        cmp     ecx, 1
        jle     exit

        ; Сортировка столбцов матрицы по возрастанию минимальных элементов
        mov     ebx, matrix
        mov     esi, min
        xor     ecx, ecx
        mov     edx, [n]
sort_columns:
        mov     edi, ecx
        mov     eax, [esi + ecx * 4]
        mov     ebx, [matrix + ecx * 4]

        ; Сортировка вставками
        mov     edi, ecx
        dec     edi
        cmp     edi, -1
        jl      sort_min

shift_right:
        mov     edx, [matrix + edi * 4 + ebx]
        cmp     edx, eax
        jl      move_left
        jmp     sorted

move_left:
        mov     [matrix + (edi + 1) * 4 + ebx], edx
        dec     edi
        cmp     edi, -1
        jge     shift_right

sorted:
        mov     [matrix + (edi + 1) * 4 + ebx], eax

        ; Бинарный поиск минимального элемента
        mov     edi, ecx
        xor     eax, eax
        mov     ebx, [matrix + edi * 4 + edx]
        mov     esi, edx
        dec     edi
        cmp     edi, -1
        jl      sort_min

search:
        mov     eax, edi
        add     eax, esi
        shr     eax, 1
        mov     ecx, [matrix + eax * 4 + edx]

        cmp     ecx, [esi * 4 + min]
        jge     greater

        mov     ebx, ecx
        mov     esi, eax
        jmp     less

greater:
        inc     eax
        cmp     eax, edi
        jle     search

        mov     ebx, [matrix + edi * 4 + edx]
        mov     esi, edi

less:
        dec     eax
        cmp     eax, edi
        jge     search

        mov     [esi * 4 + min], ebx
        mov     [edx + esi * 4], [matrix + ecx * 4 + edx]
        mov     ecx, [n]
        mov     edi, matrix
        mov     eax, esi
        dec     eax

shift_columns:
        mov     ebx, [edi + eax * 4]
        mov     edx, [edi + esi * 4]
        mov     [edi + esi * 4], ebx
        mov     [edi + eax * 4], edx
	inc eax
	cmp eax, ecx
	jl shift_columns

sort_min:
	inc ecx
	cmp ecx, [m]
	jl sort_columns

exit:
	mov eax, 60
	xor edi, edi
	syscall

default rel
extern SDL_Init
extern SDL_CreateWindow
extern SDL_CreateRenderer
extern SDL_SetRenderDrawColor
extern SDL_RenderClear
extern SDL_RenderFillRect
extern SDL_RenderPresent
extern SDL_PollEvent
extern SDL_Quit
extern SDL_DestroyRenderer
extern SDL_DestroyWindow
extern SDL_Delay
section .data
    title db "Game Example", 0
section .bss
    window resq 1
    renderer resq 1
    event resb 56
    square_rect resd 4
section .text
global WinMain
WinMain:
    push rbp
    mov rbp, rsp 
    sub rsp, 48
    mov ecx, 0x20
    call SDL_Init
    test eax, eax
    js exit
    mov rcx, title
    mov rdx, 0x2FFF0000
    mov r8, 0x2FFF0000
    mov r9, 1300
    mov qword [rsp + 32], 1000
    mov qword [rsp + 40], 0
    call SDL_CreateWindow
    mov [window], rax
    test rax, rax
    jz exit
    mov rcx, [window]
    xor rdx, rdx
    call SDL_CreateRenderer
    mov [renderer], rax
    mov dword [square_rect + 0], 650
    mov dword [square_rect + 4], 450
    mov dword [square_rect + 8], 70
    mov dword [square_rect + 12], 70
game_loop:
    mov rcx, event 
    call SDL_PollEvent
    test eax, eax
    jz render_scene
    mov eax, [event]
    cmp eax, 0x100
    je clean_exit
    cmp eax, 0x300
    jne game_loop
    mov eax, [event + 16]
    cmp eax, 26
    je move_up
    cmp eax, 22
    je move_down
    cmp eax, 4
    je move_left
    cmp eax, 7
    je move_right
    jmp game_loop
move_up:
    sub dword [square_rect + 4], 15
    jmp game_loop
move_down:
    add dword [square_rect + 4], 15
    jmp game_loop
move_left:
    sub dword [square_rect + 0], 15
    jmp game_loop
move_right:
    add dword [square_rect + 0], 15
    jmp game_loop
render_scene:
    mov rcx, [renderer]
    mov rdx, 20
    mov r8, 25
    mov r9, 35
    mov qword [rsp + 32], 255
    call SDL_SetRenderDrawColor
    mov rcx, [renderer]
    mov rdx, square_rect
    call SDL_RenderFillRect
    mov rcx, [renderer]
    call SDL_RenderPresent
    mov ecx, 16
    call SDL_Delay
    jmp game_loop
clean_exit:
    mov rcx, [renderer]
    call SDL_DestroyRenderer
    mov rcx, [window]
    call SDL_DestroyWindow
    call SDL_Quit
exit:
    xor eax, eax
    add rsp, 48
    pop rbp
    ret

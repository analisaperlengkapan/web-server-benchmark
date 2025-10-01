section .data
    response db 'HTTP/1.1 200 OK', 13, 10
             db 'Content-Type: application/json', 13, 10
             db 13, 10
             db '{"message":"Hello, world!"}', 0
    response_len equ $ - response
    
    sockaddr:
        dw 2                    ; AF_INET
        dw 0x901f              ; Port 8080 in network byte order
        dd 0                    ; INADDR_ANY
        times 8 db 0           ; padding

section .bss
    client_sock resd 1
    buffer resb 1024

section .text
    global _start

_start:
    ; Create socket: socket(AF_INET, SOCK_STREAM, 0)
    mov rax, 41            ; sys_socket
    mov rdi, 2             ; AF_INET
    mov rsi, 1             ; SOCK_STREAM
    mov rdx, 0             ; protocol
    syscall
    mov r12, rax           ; Save socket fd
    
    ; Bind socket
    mov rax, 49            ; sys_bind
    mov rdi, r12           ; socket fd
    lea rsi, [sockaddr]    ; address
    mov rdx, 16            ; address length
    syscall
    
    ; Listen
    mov rax, 50            ; sys_listen
    mov rdi, r12           ; socket fd
    mov rsi, 10            ; backlog
    syscall
    
accept_loop:
    ; Accept connection
    mov rax, 43            ; sys_accept
    mov rdi, r12           ; socket fd
    xor rsi, rsi           ; NULL
    xor rdx, rdx           ; NULL
    syscall
    mov r13, rax           ; Save client fd
    
    ; Read request (we'll ignore it for this simple example)
    mov rax, 0             ; sys_read
    mov rdi, r13           ; client fd
    lea rsi, [buffer]
    mov rdx, 1024
    syscall
    
    ; Write response
    mov rax, 1             ; sys_write
    mov rdi, r13           ; client fd
    lea rsi, [response]
    mov rdx, response_len
    syscall
    
    ; Close client socket
    mov rax, 3             ; sys_close
    mov rdi, r13
    syscall
    
    jmp accept_loop

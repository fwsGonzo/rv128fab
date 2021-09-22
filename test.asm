.org 0x100020003000400050006000

.global _start
_start:             ;; Entry point label
	;; Build a 128-bit value using t1 as temporary register
	set t0, t1, 0xAAAA1111222233334444555566667770
	xor sp, sp
	add sp, t0  ;; Set stack pointer

	li  s0, 4
	xor s1, s1
repeat:
	add s0, -1
	bne s0, s1, repeat

	call my_function ;; A regular function call
	;; We return here after the function ends.

exit:
	li a7, 1        ;; Syscall 1 (exit)
	li a0, 0x666    ;; Exit code (1st arg)
	ecall           ;; Execute syscall
	jmp exit        ;; Loop exit to prevent problems

hello_world:        ;; String label
	.type hello_world, @object
	.string "Hello World!" ;; Zt-string

my_function:
	add sp, -32
	sq a0, sp+0     ;; Save A0

	li t0, 2        ;; Syscall 2 (print)
	sw t0, sp+16    ;; Store 32-bit value
	lw sp+16, a7    ;; Load 32-bit value

	la a0, hello_world ;; address of string
	ecall           ;; Execute syscall

	lq sp+0, a0     ;; Restore A0

	ret

.globl Pause
Pause:
	push {r0}
	mov r0,#0xAF0000
	wait$:
		sub r0,#1
		cmp r0,#0
		bne wait$
	pop {r0}
	mov pc,lr

.globl Timer
Timer:
	delay .req r2
	ldr r3,=0x20003000 // address of a counter that increments at 1MHz.
	ldrd r0,r1,[r3,#4]
	add delay,r0
	loop$:
		ldrd r0,r1,[r3,#4]
		cmp delay,r0
		bgt loop$
	mov pc,lr

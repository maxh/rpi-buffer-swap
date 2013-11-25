.globl Pause
Pause:
	push {r6}
	mov r6,#0xAF0000
	wait$:
		sub r6,#1
		cmp r6,#0
		bne wait$
	pop {r6}
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

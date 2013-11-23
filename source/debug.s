// Flashes the ACT pin r0 number of times.
.globl DebugFlash
DebugFlash:

	cmp r0,#0
	movls pc,lr // If the number of times to flash is <=0, return.

	push {r6,lr}
	flashCounter .req r6
	mov flashCounter,r0

	// Enable output to the 'act' light.
	pinNum .req r0
	pinFunc .req r1
	mov pinNum,#16
	mov pinFunc,#1
	bl SetGpioFunction
	.unreq pinNum
	.unreq pinFunc

	pinNum .req r0
	pinVal .req r1
	flashLoop$:
		mov pinNum,#16
		mov pinVal,#0 // pinVal = 0 => LED on.
		bl SetGpio
		bl Pause

		mov pinNum,#16
		mov pinVal,#1 // pinVal = 1 => LED off.
		bl SetGpio
		bl Pause
	
		sub flashCounter,#1
		cmp flashCounter,#0
		bgt flashLoop$

	.unreq pinNum
	.unreq pinVal
	.unreq flashCounter
	pop {r6,pc}

// Infinite pit of failure to bail out of execution.
.globl Fail
Fail:
	b Fail

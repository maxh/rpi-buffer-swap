.globl GetGpioAddress
GetGpioAddress:
	ldr r0,=0x20200000
	mov pc,lr

// Enables output on GPIO.
.globl SetGpioFunction
SetGpioFunction:
	cmp r0,#53 // GPIO pin number; there are 54 pins.
	cmpls r1,#7 // Each pin has 8 functions.
	movhi pc,lr

	push {lr}
	mov r2,r0 // Store the GPIO pin number so it doesn't get overwritten.
	bl GetGpioAddress

	functionLoop$:
		cmp r2,#9
		subhi r2,#10 // Subtract 10 from GPIO pin number.
		addhi r0,#4 // Add 4 to the GPIO Controller address.
		bhi functionLoop$
	
	add r2, r2,lsl #1 // r2 * 3 = r2 * 2 + r2 = (r2 << 1) + r2
	lsl r1,r2
	str r1,[r0]
	pop {pc}

// Turns a GPIO pin on or off.
.globl SetGpio
SetGpio:
	pinNum .req r0
	pinVal .req r1

	cmp pinNum,#53
	movhi pc,lr
	push {lr}
	mov r2,pinNum
	.unreq pinNum
	pinNum .req r2
	bl GetGpioAddress
	gpioAddr .req r0

	pinBank .req r3
	lsr pinBank,pinNum,#5
	lsl pinBank,#2
	add gpioAddr,pinBank
	.unreq pinBank

	and pinNum,#31
	setBit .req r3
	mov setBit,#1
	lsl setBit,pinNum
	.unreq pinNum

	teq pinVal,#0
	.unreq pinVal
	streq setBit,[gpioAddr,#40]
	strne setBit,[gpioAddr,#28]
	.unreq setBit
	.unreq gpioAddr
	pop {pc}

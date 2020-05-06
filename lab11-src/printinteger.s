//Note
//mov can only do 0-255 while ldr can do any but are stupider
//we compare registers
.data	//data declaration
//Varible declaration
	
.text	//function declaration

//UMULL FUNCTIONALITY R1*MAGIC_NUMBER/2^(32+LSR)  = R1*0.1 = R1/10
div10:
	  /* r0 contains the argument to be divided by 10 */
   ldr r1, .Ls_magic_number_10 /* r1 ← magic_number */
   smull r1, r2, r1, r0   /* r1 ← Lower32Bits(r1*r0). r2 ← Upper32Bits(r1*r0) */
   mov r2, r2, ASR #2     /* r2 ← r2 >> 2 */
   mov r1, r0, LSR #31    /* r1 ← r0 >> 31 */
   add r0, r2, r1         /* r0 ← r2 + r1 */
   bx lr                  /* leave function */
   .align 4
   .Ls_magic_number_10: .word 0x66666667
   
	.global printx	//declare printx
	.global printd	//declare printd

printx:	//printx function
	//get rightmost 4 bits using lsl and lsr 28
	//compare to 10 (greater than add 87, if not add 48)
	//add to stack
	//compare whats left with 0 (if not equal 0, branch to start, if so, pop stack)
	
	push {fp, lr}	//push fp,lr
	
	//r0: each character, we will do lsl and lsr on it
	//r4: remaining number, lsr 4 after each add to stack
	//r5: count how many elements in stack
	//r6: the register that hold comparison value
	mov r4, r0
	mov r5, #0
	
	//branch rightmost4: get the rightmost 4 bits of r4
	rightmost4: 
		//mov r0, r4	//load r0 with remaining number
		lsl r0, r0, #28
		lsr r0, r0, #28	//now r0 is load with rightmost 4 digits
		
		
		mov r6, #10
		cmp r0, r6
		blt char09	//caseA char is 0-9
		//caseB: char is A-F
		add r0, r0, #87	//add 87 10+87=97 since its lower case
		bl add2stk	//branch to add2stk
		
	//caseA: char is 0-9
	char09:
		add r0, r0, #48		//add 48 to char to make it ascii
		//bl add2stk	//branch to add2stk
		
	add2stk:
		push {r0}
		//str r0, [sp, #-1]!	//push r0 into sp
		add r5, r5, #1	//increment the counter
		lsr r4, r4, #4	//right shift r4 permanently
		
		mov r6, #0
		mov r0, r4
		cmp r4, r6	//compare r4 with 0
		bne	rightmost4	//branch to rightmost4 if not equal 0 
		//case r4 is 0, now we pop and putchar
		bl popstk
		
	popstk:
		pop {r0}
		//ldr r0, [sp]!	//pop first element in the stack
		bl putchar	//call putchar
		sub r5, r5, #1		//decrement counter
		mov r6, #0
		cmp r5, r6	//compare r5 with 0
		bne	popstk	//branch popstk if there is still element in the stac
		
	
	pop {fp, pc}	//pop fp,pc
	

printd:	//printd function

	//r0: integer bit string
	//r3: MSB and also copy of r0 after division
	//r4: prev copy of r0 before division
	//r5: count how many elements in stack
	//r6 0xFFFFFFFF holder 
	//r7: remainder
	//r8: 10*div(int), minuend to get remainder 
	//r9:	multiplier value 10 
	//r10: 	sign indicator, if negative, set to 255 later on during push, set to -3 so when pop 48-3 = 45 = '-'
	
	push {fp,lr}	//push fp,lr
	
	firstbitcomp:		//compare 1st bit, if 1->sub FFFFFF+1 
		mov r3, r0	//copy r0 to r3
		lsr r3, r3, #31		//now r3 is the MSB of r0
		cmp r3, #1	//compare to 1, if 1->negative, if not go to varset
		bne varset
		mov r6, #0xFFFFFFFF		//set r6 to 0xFFFFFFFF
		sub r0, r6,r0			//r0 = r0 - r6
		add r0, r0, #1			//r0 = r0 + 1
		mov r10, #255			//set r10 to 255
		bl varset
	
	varset:
		mov r3, r0	//copy r0 to r3
		mov r4, r0	//copy r0 to r4
		mov r5, #0	//initialize counter 
		mov r9, #10	//set multiplier
		
	div:
		bl div10	
		//now r0 is divided by 10
	
	lr:
		mov r3, r0	//copy division result to r3
		mul r8, r0, r9	//r8 = r0*r9	
		sub r7, r4, r8	//r7 = r4-r8
		push {r7}		//push r7
		add r5, r5, #1	//increment counter
		mov r4, r3	//then update r4 with r3
		mov r0, r3	//then we update r0 with r3 
		cmp r3, #0	//compare r3 with 0. if not equal, we div again and go lr and push new
		bne div
		//compare r10 to 255, if not equal->positive->go pop
		//if equal->negative->push (-3)->ascii(-3+48) = 45 = '-'
		cmp r10, #255	
		bne pop
		mov r10, #-3
		push {r10}	//push '-'
		add r5, r5, #1	//increment counter
		
	pop:
		pop {r0}	//pop stack
		add r0, r0, #48	//add 48 to make it ascii
		sub r5, r5, #1	//decrement counter 
		bl putchar	//put char
		cmp r5, #0	//if counter ==0
		bne pop	//branch if there is more element on stack
		
	pop {fp, pc}	//pop fp,pc
	
	
	



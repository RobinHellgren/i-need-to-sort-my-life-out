	.data
datalen:
	.word	64	# 32
data:
	.word	0xffff7e81
	.word	0x00000001
	.word	0x00000002
	.word	0xffff0001
	.word	0x00000000
	.word	0x00000001
	.word	0xffffffff
	.word	0x00000000
	.word	0xe3456687
	.word	0xa001aa88
	.word	0xf0e159ea
	.word	0x9152137b
	.word	0xaab385a1
	.word	0x31093c54
	.word	0x42102f37
	.word	0x00ee655b
	
	.word	0x14ad6482
	.word	0xd9ade2c1
	.word	0xa9855d8b
	.word	0x97890d37
	.word	0x50b114b8
	.word	0xa827fb27
	.word	0xe5057c2e
	.word	0xbb295862
	.word	0x6d69dea2
	.word	0x8c28d031
	.word	0xacb931b2
	.word	0x0a60adeb
	.word	0x3df36973
	.word	0x1d4b6774
	.word	0xc304b7cb
	.word	0xb39ce70f
	
	.word	0xffff7e81
	.word	0x00000001
	.word	0x00000002
	.word	0xffff0001
	.word	0x00000000
	.word	0x00000001
	.word	0xffffffff
	.word	0x00000000
	.word	0xe3456687
	.word	0xa001aa88
	.word	0xf0e159ea
	.word	0x9152137b
	.word	0xaab385a1
	.word	0x31093c54
	.word	0x42102f37
	.word	0x00ee655b
	
	.word	0x14ad6482
	.word	0xd9ade2c1
	.word	0xa9855d8b
	.word	0x97890d37
	.word	0x50b114b8
	.word	0xa827fb27
	.word	0xe5057c2e
	.word	0xbb295862
	.word	0x6d69dea2
	.word	0x8c28d031
	.word	0xacb931b2
	.word	0x0a60adeb
	.word	0x3df36973
	.word	0x1d4b6774
	.word	0xc304b7cb
	.word	0xb39ce70f
newLine: .asciiz "\n"
	.text
main:
	la $s0, data #Create an active working pointer
	la $s1, data #Create an "bookmark" pointer
	la $s2, data #Create a pointer pointing to the first position in the array
	la $s3 , data #Create an pointer to keep track of the last element of the array
	
	#Move the pointers foward to avoid manipulation of datalen
	addi $s0, $s0, 8
	addi $s1, $s1, 8
	addi $s2, $s2, 8
	#this code block get the length of the array from the datalen variable, multiplies it by 4 to represent the size of every word in the array
	#and then moves the last element pointer to the adress for the last element
	lw $t1, datalen
	li $t2, 4
	mult $t1, $t2
	mflo $s4
	add $s3, $s3, $s4
	j sortLoop
	nop
	
sortLoop:
	#move the pointer to the next word and then check if it's pointing to the last element, 
	#if it does branch to the print results part of the code
	addi $s0, $s0, 4
	bge $s0, $s3, resetPointerForR
	nop
	addi $s1, $s1, 4
loadWord:
	lw $t1, ($s0)
	lw $t2, -4($s0)
compareValues:
	#Compare the loaded words, if the current word is smaller than the value behind it -> swap the values, 
	#then check if the pointer is pointing at the first element of the array. If it is reset the pointer to the bookmarked pointers location
	blt $t1, $t2, swapBack
	nop
	bge $s0, $s2, movePointerBack
	nop
	j resetPointer
	nop
swapBack:
	#Swap the positions of the two words
	sw $t1,-4($s0)
	sw $t2,($s0)
	bgt $s0, $s2, movePointerBack
	nop
	j resetPointer
	nop
movePointerBack:
	addi $s0, $s0, -4
	j loadWord
	nop
resetPointer:
	move $s0, $s1
	j sortLoop
	nop
	#Print results portion, prints every value in the array with a newline character after every entry
resetPointerForR:
	sub $s0, $s0, $s4
fetchNextR:
	lw $a0, ($s0)
	addi $s0, $s0, 4
	la $v0, 1
	syscall
	la $v0, 4
	la $a0, newLine
	syscall
printResult:
	blt $s0, $s3, fetchNextR
	nop 
	la $v0, 10
	syscall


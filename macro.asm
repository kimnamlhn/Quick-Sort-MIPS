#*****************************KHAI BAO BIEN GLOBAL **********************************

.data
buffer: .space 10
.eqv CR 0xD
.eqv LF 0xA
.eqv SPACE 0x20
.eqv BASE 10

#**********************************HAM MARCO XU LY FILE**********************************

#ham mo file
.macro openFile (%path, %mode) # mode: 0 doc file , 1 ghi vao file
.data
openfile: .asciiz %path
.text
li $v0, 13
la $a0, openfile
li $a1, %mode
li $a2, 0
syscall
move $t0,$v0
li $v0,4 
la $a0,openfile
syscall
move $v0,$t0
.end_macro

#tai gia tri tu file
.macro loadFile(%descriptor)
li $t1,0
li $t3,0
while:
	getChar(%descriptor)
	move $t0,$v0
	beq $v1,$0,breakWhile
	beq $t0,CR,returnValue
	beq $t0,LF,returnValue
	beq $t0,SPACE,returnValue
	charToInteger($t0)
	baseToDecimal($t1,$t0)
	j while
returnValue:
	beq $t3,0,firshPush
	pushString($t1)
	li $t1,0
	j while
firshPush:
	pushString($t1)
	popString($t4)
	li $t1,0
	addi $t3,$t3,1
	j while
breakWhile:
	pushString($t1)
	move $v0,$t3
	move $v1,$t4
.end_macro

#luu file lai
.macro saveFile(%descriptor,%size)
move $a0, %descriptor
li $t7, 0
saveFileWhile:
	beq $t7,%size,done
	addi $t7,$t7,1
	popString($t8)
	integerToString($t8)
	la $a1,buffer
	move $a2,$v1
	addi $a2,$a2,1 
	li $v0,15
	syscall
	j saveFileWhile
done:

.end_macro

#dong file
.macro closeFile(%descriptor)
move $a0,%descriptor
li $v0,16
syscall
.end_macro

#*****************************HAM MARCO CHUYEN DOI KIEU DU LIEU*********************************

#Char to integer
.macro charToInteger(%c)
subi %c,%c,48
.end_macro

.macro integerToChar(%i)
addi %i,%i,48
.end_macro

#chuyen base thanh so thap phan
.macro baseToDecimal(%hi, %lo)
mul %hi,%hi,BASE
add %hi,%hi,%lo
.end_macro

#chuyen integer thanh string
.macro integerToString(%i) 
la $t6,buffer 	
beqz %i,nullBuffer
li $t2, 0
li $t5, 10
while:
	beqz %i,done
	addi $t2,$t2,1
	div %i,$t5
	mfhi $t3
	pushString($t3)
	mflo %i
	j while
nullBuffer:
	integerToChar(%i)
	sb %i, ($t6)
	addi $t6,$t6,1
	li $v1, 1
	j end
done:
	move $v1,$t2
	while1:
		beqz $t2,end
		subi $t2,$t2,1
		popString($t1)
		integerToChar($t1)
		sb $t1,($t6)
		addi $t6,$t6,1
		j while1
end:
	li $t1,SPACE
	sb $t1, ($t6)
.end_macro

#*****************************HAM MARCO LAY THEM BOT DATA*********************************

#lay char
.macro getChar(%descriptor)
.text
li $v0,14
move $a0,%descriptor
la $a1, buffer
li $a2, 1
syscall
move $v1,$v0
lb $v0, buffer
.end_macro

#day gia tri vao 
.macro pushString (%register)
    sub $sp, $sp, 4
    sw %register, ($sp)
.end_macro

#lay gia tri ra
.macro popString (%register)
    lw %register, ($sp)
    add $sp, $sp, 4
.end_macro
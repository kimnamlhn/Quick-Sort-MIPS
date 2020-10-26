.include "macro.asm"

#*********************************MO FILE VA LAY DU LIEU******************************
openFile("E:/quickSort/input_sort.txt",0)
move $s0,$v0 				
loadFile($s0) 				
move $s7,$v1
		
#*********************************CHUONG TRINH CHINH********************************
main: 						
li $a1, 0 					
subi $a2,$v1,1 				
la $a0,($sp) 				

jal quickSort

j writeToFile
	
#*********************************CAC HAM CUA QUICK SORT******************************

swap:
	add $sp, $sp, -20	
	sw $a0, 0($sp)		
	sw $a1, 4($sp)
	sw $a2, 8($sp)
	sw $s0, 12($sp)
	sw $s1, 16($sp)
	
	sll $t0, $a1, 2		
	add $t0, $a0, $t0	
	lw $s0, 0($t0)		

	sll $t1, $a2, 2		
	add $t1, $a0, $t1	
	lw $s1, 0($t1)  	

	sw $s0, 0($t1)		
	sw $s1, 0($t0)
	
	lw $a0, 0($sp)		
	lw $a1, 4($sp)
	lw $a2, 8($sp)
	lw $s0, 12($sp)
	lw $s1, 16($sp)
	addi $sp, $sp, 20	
	jr $ra			

partition:
	add $sp, $sp, -16	
	sw $a0, 0($sp)		
	sw $a1, 4($sp)		
	sw $a2, 8($sp)		
	sw $ra, 12($sp)		
	
	move $s0, $a1		
	move $s1, $a2		
	
	move $t5, $s1		
	
	sll $t0, $s1, 2		
	add $t0, $a0, $t0
	lw $s3, 0($t0)		

	subi $s1, $s1, 1		

	bigLoop:
		leftLoop:
			sll $t1, $s0, 2		
			add $t1, $a0, $t1	
			lw $t2, 0($t1)		
			
			bgt $s0, $s1, leftLoopDone 
			bge $t2, $s3, leftLoopDone			
			
			addi	$s0, $s0, 1
			j leftLoop
		
		leftLoopDone:
		
		rightLoop:
			sll $t3, $s1, 2		
			add $t3, $a0, $t3	
			lw $t4, 0($t3)		
			
			bgt $s0, $s1, rightLoopDone 
			ble $t4, $s3, rightLoopDone		
			
			subi	$s1, $s1, 1
			
			j rightLoop
		rightLoopDone:
		
		bge $s0, $s1, breakLoop
		move $a1, $s0	
		move $a2, $s1
		jal swap			
		addi $s0, $s0, 1		
		subi $s1, $s1, 1		
		j  bigLoop
	
	breakLoop:
		move $a1, $s0
		move $a2, $t5
		jal swap			
		add $v0, $s0, 0		
	
		lw $a0, 0($sp)		
		lw $a1, 4($sp)
		lw $a2, 8($sp)	
		lw $ra, 12($sp)
		addi $sp, $sp, 16	
		jr $ra			


quickSort:
	add $sp, $sp, -20	
	sw $a0, 0($sp)		
	sw $a1, 4($sp)		
	sw $a2, 8($sp)		
	sw $s1, 12($sp)		
	sw $ra, 16($sp)		
	
	bge $a1, $a2, endQuickSort	#hight #low

	jal partition		
	move $s4, $v0		
	
	lw $a1, 4($sp)			
	subi $a2, $s4, 1		
	jal quickSort		

	addi $a1, $s4, 1		
	lw $a2, 8($sp)		
	jal quickSort		
	
	endQuickSort:
		lw $a0, 0($sp)		
		lw $a1, 4($sp)	
		lw $a2, 8($sp)		
		lw $s1, 12($sp)
		lw $ra, 16($sp)
		addi $sp, $sp, 20	
		jr $ra		


#*****************************GHI DATA VAO FILEb OUTPUT.TXT**********************************

writeToFile:
	openFile("E:/QuickSort/output_sort.txt",1)
	move $s2,$v0
	saveFile($s2,$s7)
	closeFile($s2)
	closeFile($s0)
	addi $v0,$0, 10
	syscall


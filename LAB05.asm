.data
array:		.space	400
tbnhap:		.asciiz "Nhap do dai mang (1 <= n <= 100): "
nhappt1:	.asciiz "Nhap phan tu thu "
nhappt2:	.asciiz " (so nguyen duong): "
tbxuat: 	.asciiz "Mang da sap xep:\n"
tbtrungvi: 	.asciiz "\nTrung vi cua mang: "
tbchonsort:	.asciiz "Chon hinh thuc sort (bubblesort(1), selectionsort(2), insertionsort(3)): "
space:		.asciiz " "
tbnhaplai:	.asciiz "Vui long nhap lai: "
.text
	
main:
	#$s0: n
	#$s1: array
	la	$s1, array
	add	$t7, $zero, $s1
	input:
		input_n:
			li	$v0, 4
			la	$a0, tbnhap
			syscall #yeu cau nhap n
	
			li	$v0, 5
			syscall #nhap n
	
			slti	$t0, $v0, 1
			bne	$t0, $zero, input_n #$v0 < 1 => nhap lai n
			
			slti	$t0, $v0, 101
			beq	$t0, $zero, input_n #$v0 >= 101 => nhap lai n
		
			add	$s0, $v0, $zero #luu n vao $s0
		end_input_n:
		
		li	$t0, 0
		array_inp_loop: #for i = 0 -> n-1
			
			
			#bat dau thong bao nhap phan tu thu i
			li	$v0, 4
			la 	$a0, nhappt1
			syscall
			
			li	$v0, 1
			add	$a0, $zero, $t0
			syscall
			
			li	$v0, 4
			la 	$a0, nhappt2
			syscall
			#ket thuc thong bao nhap phan tu thu i
	
			check_positive:
				li	$v0, 5
				syscall #nhap phan tu
				
				slt 	$t1, $zero, $v0 #$t1 = 1 neu phan tu nguyen duong
				
				bne	$t1, $zero, end_check_positive #phan tu nguyen duong -> ngung vong lap
				
				li	$v0, 4
				la 	$a0, tbnhaplai
				syscall #thong bao nhap lai
				
				j 	check_positive	#nhap lai neu phan tu <= 0
				
			end_check_positive:
			
			
			
			sw	$v0, 0($t7)	#luu phan tu vao mang
			addi	$t0, $t0, 1
			addi 	$t7, $t7, 4	#tang dia chi len 1 word
			bne 	$t0, $s0, array_inp_loop
		end_array_inp_loop:
		
		 
		choose_type:
			la 	$a0, tbchonsort
			li	$v0, 4
			syscall	#thong bao chon hinh thuc sort
			
			li 	$v0, 5
			syscall
			
			li	$t0, 1
			beq	$t0, $v0, bubblesort
			li	$t0, 2
			beq	$t0, $v0, selectionsort
			li	$t0, 3
			beq 	$t0, $v0, insertionsort
			
			j 	choose_type
		end_choose_type:
	end_input:

	
	
	
	
	bubblesort:
		li	$t0, 0
	
		bubblesort_loop_i:#for i = 0 -> n-1

			
			li	$t1, 0
			la	$t7, array
			bubblesort_loop_j:#for j = 0 -> n-2
				addi 	$t1, $t1, 1
				beq	$t1, $s0, end_bubblesort_loop_j
				
				lw 	$t3, 0($t7)	#load a[j]
				lw	$t4, 4($t7)	#load a[j+1]
				
				slt 	$t2, $t4, $t3 	#so sanh a[j] voi a[j+1]
				
				
				beq	$t2, $zero, endif1 #if a[j+1] < a[j] then swap(a[j],a[j+1])
					sw	$t3, 4($t7)
					sw	$t4, 0($t7)
				endif1:
				addi 	$t7, $t7, 4
				j	bubblesort_loop_j
			end_bubblesort_loop_j:
			addi 	$t0, $t0, 1
			bne	$t0, $s0, bubblesort_loop_i
		end_bubblesort_loop_i:
		j output
	end_bubblesort:
	
	
	selectionsort:
		la	$t7, array	#t7 luu dia chi mang tam thoi (cho vong for i)
		la	$t6, array	#t6 luu dia chi mang tam thoi (cho vong for j)
		li	$t0, 0		#t0 luu gia tri i
		li 	$t1, 0		#t1 luu gia tri j
		
		selectionsort_loop_i: #t0 luu i, for i = 0 -> n-1
			
			add	$t6, $zero, $t7
			add	$t5, $zero, $t7	#t5 luu dia chi phan tu se duoc swap voi $t7
			add 	$t1, $zero, $t0
			lw	$t2, 0($t7)	#t2 luu gia tri nho nhat tu i den n
			selectionsort_loop_j: #t1 luu j, for j = i -> n
				
				lw	$t3, 0($t6)
				slt 	$t4, $t3, $t2
				
				beq	$t4, $zero, endif2 #neu $t3 < $t2 thi cap nhat $t2 va $t5
					add 	$t2, $zero, $t3
					add	$t5, $zero, $t6
				endif2:
				
				addi	$t1, $t1, 1
				addi 	$t6, $t6, 4
				bne	$t1, $s0, selectionsort_loop_j
			end_selectionsort_loop_j:
			
			#doi gia tri giua mem $t5 va $t7
			lw 	$t3, 0($t7)
			sw	$t2, 0($t7)
			sw	$t3, 0($t5)
					
			addi	$t0, $t0, 1
			addi 	$t7, $t7, 4
			bne	$t0, $s0, selectionsort_loop_i
		end_selectionsort_loop_i:
		
		
		j output
	end_selectionsort:
	
	
	insertionsort:
		li	$t0, 0
		la	$t7, array
		insertionsort_loop_i: #for i = 0 -> n-1
		
			add	$t6, $zero, $t7
			add 	$t1, $zero, $t0
			insertionsort_loop_j:#while 
				
				beq	$t1, $zero, end_insertionsort_loop_j
				
				
				lw	$t2, -4($t6)
				lw 	$t3, 0($t6)
				slt 	$t4, $t3, $t2
				
				beq	$t4, $zero, end_insertionsort_loop_j
				sw	$t2, 0($t6)
				sw	$t3, -4($t6)
				
				subi	$t6, $t6, 4
				subi	$t1, $t1, 1
				j	insertionsort_loop_j	
			end_insertionsort_loop_j:
			addi	$t0, $t0, 1
			addi	$t7, $t7, 4
			bne	$t0, $s0, insertionsort_loop_i
		end_insertionsort_loop_i:  
		j output
	end_insertionsort:

	output:
		la	$t7, array	#t7 luu dia chi tam thoi cua array cho output_loop
		li	$t0, 0
		
		li 	$v0, 4
		la	$a0, tbxuat
		syscall
		
		output_loop:	#t0 luu gia tri i, for i = 1 -> n
			addi 	$t0, $t0, 1
			
			li	$v0, 1
			lw 	$a0, 0($t7)
			syscall	#xuat phan tu thu i
			
			li	$v0, 4
			la	$a0, space
			syscall	#xuat dau cach
			
			addi 	$t7, $t7, 4	#tang dia chi len 1 word
			bne	$t0, $s0, output_loop
		end_output_loop:
		
		li	$v0, 4
		la	$a0, tbtrungvi
		syscall	#thong bao xuat phan tu trung vi
		
		la	$t7, array
		li	$v0, 1
		
		addi	$t0, $s0, -1
		srl	$t0, $t0, 1
		#tinh (n-1)/2
		
		sll	$t0, $t0, 2
		add	$t7, $t7, $t0
		lw	$a0, 0($t7)
		#load phan tu trung vi tu mang
		
		syscall #xuat trung vi
		
	end_output:
end:

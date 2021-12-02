# Fall 2021 CSE12 Lab 4 Test File
#
#------------------------------------------------------------------------

## Macro that stores the value in %reg on the stack 
##  and moves the stack pointer.
.macro push(%reg)
	subi $sp $sp 4
	sw %reg 0($sp)
.end_macro 

# Macro takes the value on the top of the stack and 
#  loads it into %reg then moves the stack pointer.
.macro pop(%reg)
	lw %reg 0($sp)
	addi $sp $sp 4	
.end_macro

# prints a string
.macro print_str(%str)

	.data
	str_to_print: .asciiz %str

	.text
	push($a0)                        # push $a0 and $v0 to stack so
	push($v0)                         # values are not overwritten
	
	addiu $v0, $zero, 4
	la    $a0, str_to_print
	syscall

	pop($v0)                        # pop $a0 and $v0 off stack
	pop($a0)
.end_macro


# data segment
.data
black: .word 0x00000000
white: .word 0x00ffffff
red: .word 0x00ff0000
green: .word 0x0000ff00
blue: .word 0x000000f
orange: .word 0xffa500
yellow: .word 0x00ffff00
cyan: .word 0x0000ffff
midnightblue: .word 0x00191970
firebrick: .word 0x00b22222
slategray: .word 0x00708090
mediumseagreen: .word 0x003cb371
darkgreen: .word 0x00006400
indigo: .word 0x004b0082

.text
main: nop

# 0. Clear bitmap test
print_str("-------------------------------\nClear_Bitmap Test:\n")
print_str("Paints entire bitmap a medium sea green color")
print_str("\n\n(Check the bitmap display tool to see if it worked.)")
lw $a0, slategray
jal clear_bitmap

# 1. Pixel test
print_str("\n\n-------------------------------\nPixel Test:\n")
print_str("Draws a cyan and a yellow pixel in the top left and bottom right respectively")
jal pixel_test

# 2. horizontal line test
print_str("\n\n-------------------------------\nHorizontal Line test:\n")
print_str("Draws an orange horizontal line")
jal horizontal_line_test

# 3. vertical line test
print_str("\n\n-------------------------------\nVertical Line test:\n")
print_str("Draws a firebrick colored vertical line")
jal vertical_line_test

# 3. crosshair test
print_str("\n\n-------------------------------\nCrosshair Test:\n")
print_str("Draws an indigo crosshair")
jal crosshair_test

#Exit when done
li $v0 10 
syscall

#------------------------------------------------------------------------
pixel_test: nop 
	push($ra)
	
	# Check for Clear_Bitmap test color
	print_str("\n\nGet_pixel($a0 = 0x00300020) should return: 0x00708090\nYour get_pixel($a0 = 0x00300020) returns:  ")
	li $a0, 0x00300020
	jal get_pixel
	move $a0, $v0
	li $v0, 34
	syscall
	
	# cyan point at  (0, 0)
	li $a0, 0x00000001
	lw $a1, cyan
	jal draw_pixel
	
	# yellow point at  (127,127)
	li $a0, 0x007F007E
	lw $a1, yellow
	jal draw_pixel
	
	print_str("\n\nGet_pixel($a0 = 0x00000001) should return: 0x0000ffff\nYour get_pixel($a0 = 0x00000001) returns:  ")
	li $a0, 0x00000001
	jal get_pixel
	move $a0, $v0
	li $v0, 34
	syscall
	
	print_str("\n\nGet_pixel($a0 = 0x007F007E) should return: 0x00ffff00\nYour get_pixel($a0 = 0x007F007E) returns:  ")
	li $a0, 0x007F007E
	jal get_pixel
	move $a0, $v0
	li $v0, 34
	syscall
	
	pop($ra)
	jr $ra
#------------------------------------------------------------------------  
horizontal_line_test: nop    
	push($ra)
	
	li $a0, 0x00000020
	lw $a1, yellow
	jal draw_horizontal_line
	
	print_str("\n\nGet_pixel($a0 = 0x00550020) should return: 0x00ffff00\nYour get_pixel($a0 = 0x00550020) returns:  ")
	li $a0, 0x00550020
	jal get_pixel
	move $a0, $v0
	li $v0, 34
	syscall

	print_str("\n\nGet_pixel($a0 = 0x00000020) should return: 0x00ffff00\nYour get_pixel($a0 = 0x00000020) returns:  ")
	li $a0, 0x00000020
	jal get_pixel
	move $a0, $v0
	li $v0, 34
	syscall

	print_str("\n\nGet_pixel($a0 = 0x007F0020) should return: 0x00ffff00\nYour get_pixel($a0 = 0x007F0020) returns:  ")
	li $a0, 0x007F0020
	jal get_pixel
	move $a0, $v0
	li $v0, 34
	syscall
	
	print_str("\n\nGet_pixel($a0 = 0x00100040) should return: 0x00708090\nYour get_pixel($a0 = 0x00100040) returns:  ")
	li $a0, 0x00200040
	jal get_pixel
	move $a0, $v0
	li $v0, 34
	syscall
	
	pop($ra)
	jr $ra

vertical_line_test: nop    
	push($ra)

	li $a0, 0x00000035
	lw $a1, firebrick
	jal draw_vertical_line
	
	print_str("\n\nGet_pixel($a0 = 0x00500055) should return: 0x00b22222\nYour get_pixel($a0 = 0x00500055) returns:  ")
	li $a0, 0x00350055
	jal get_pixel
	move $a0, $v0
	li $v0, 34
	syscall

	print_str("\n\nGet_pixel($a0 = 0x00500000) should return: 0x00b22222\nYour get_pixel($a0 = 0x00500000) returns:  ")
	li $a0, 0x00350000
	jal get_pixel
	move $a0, $v0
	li $v0, 34
	syscall

	print_str("\n\nGet_pixel($a0 = 0x0050007F) should return: 0x00b22222\nYour get_pixel($a0 = 0x0050007F) returns:  ")
	li $a0, 0x0035007F
	jal get_pixel
	move $a0, $v0
	li $v0, 34
	syscall
	
	print_str("\n\nGet_pixel($a0 = 0x00400050) should return: 0x00708090\nYour get_pixel($a0 = 0x00400050) returns:  ")
	li $a0, 0x00400035
	jal get_pixel
	move $a0, $v0
	li $v0, 34
	syscall
	
	pop($ra)
	jr $ra

#------------------------------------------------------------------------  
crosshair_test: nop
	push($ra)
	
	li $a0, 0x00500040
	lw $a1, darkgreen
	jal draw_crosshair
	
	print_str("\n\nGet_pixel($a0 = 0x00500040) should return: 0x00708090\nYour get_pixel($a0 = 0x00500040) returns:  ")
	li $a0, 0x00500040
	jal get_pixel
	move $a0, $v0
	li $v0, 34
	syscall
	
	print_str("\n\nGet_pixel($a0 = 0x00450040) should return: 0x00006400\nYour get_pixel($a0 = 0x00450040) returns:  ")
	li $a0, 0x00450040
	jal get_pixel
	move $a0, $v0
	li $v0, 34
	syscall
	
	print_str("\n\nGet_pixel($a0 = 0x00500045) should return: 0x00006400\nYour get_pixel($a0 = 0x00500045) returns:  ")
	li $a0, 0x00500045
	jal get_pixel
	move $a0, $v0
	li $v0, 34
	syscall
	
	pop($ra)
	jr $ra
#------------------------------------------------------------------------  
# Be sure to use the lab4_s21_template.asm and rename it to lab4.asm so it
# is included here!
# 
.include "lab4.asm"

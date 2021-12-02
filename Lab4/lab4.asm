#######################################################
#### # Created by: Bruni, Jason
# jabruni
# 1 December 2021
#
# Assignment: Lab 4: Functions and Graphs
# CSE 12, Computer Systems and Assembly Language
# UC Santa Cruz, Fall 2021
#
# Description: This program allows users to change the background 
#     		of the bitmap display, and "draw" horizontal 
#     		and vertical lines.
#########################################################
####


# Fall 2021 CSE12 Lab 4 Template
######################################################
# Macros made for you (you will need to use these)
######################################################

# Macro that stores the value in %reg on the stack 
#	and moves the stack pointer.
.macro push(%reg)
	subi $sp $sp 4
	sw %reg 0($sp)
.end_macro 

# Macro takes the value on the top of the stack and 
#	loads it into %reg then moves the stack pointer.
.macro pop(%reg)
	lw %reg 0($sp)
	addi $sp $sp 4	
.end_macro

#################################################
# Macros for you to fill in (you will need these)
#################################################

# Macro that takes as input coordinates in the format
#	(0x00XX00YY) and returns x and y separately.
# args: 
#	%input: register containing 0x00XX00YY
#	%x: register to store 0x000000XX in
#	%y: register to store 0x000000YY in
.macro getCoordinates(%input %x %y)
	andi %y, %input, 0x000000FF
	andi %x, %input, 0x00FF0000
	srl %x, %input, 16
.end_macro

# Macro that takes Coordinates in (%x,%y) where
#	%x = 0x000000XX and %y= 0x000000YY and
#	returns %output = (0x00XX00YY)
# args: 
#	%x: register containing 0x000000XX
#	%y: register containing 0x000000YY
#	%output: register to store 0x00XX00YY in
.macro formatCoordinates(%output %x %y)
	sll %x %x 16
	add %output %x %y
.end_macro 

# Macro that converts pixel coordinate to address
# 	  output = origin + 4 * (x + 128 * y)
# 	where origin = 0xFFFF0000 is the memory address
# 	corresponding to the point (0, 0), i.e. the memory
# 	address storing the color of the the top left pixel.
# args: 
#	%x: register containing 0x000000XX
#	%y: register containing 0x000000YY
#	%output: register to store memory address in
.macro getPixelAddress(%output %x %y)
	mul %output, %y, 128
	add %output, %output, %x
	mul %output, %output, 4
	add %output, %output, 0xFFFF0000
.end_macro


.text
# prevent this file from being run as main
li $v0 10 
syscall

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#  Subroutines defined below
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#*****************************************************
# Clear_bitmap: Given a color, will fill the bitmap 
#	display with that color.
# -----------------------------------------------------
# Inputs:
#	$a0 = Color in format (0x00RRGGBB) 
# Outputs:
#	No register outputs
#*****************************************************
clear_bitmap: nop
	# YOUR CODE HERE, only use t registers (and a, v where appropriate)
	li $t1, 0xffff0000
	li $t2, 0xfffffffc
	# Loop for clearing the bitmap display
	loop:
	beq $t1, $t2, endLoop
	NOP
	sw $a0, ($t1)
	addi $t1, $t1, 4
	j loop
	endLoop:
jr $ra

#*****************************************************
# draw_pixel: Given a coordinate in $a0, sets corresponding 
#	value in memory to the color given by $a1
# -----------------------------------------------------
#	Inputs:
#		$a0 = coordinates of pixel in format (0x00XX00YY)
#		$a1 = color of pixel in format (0x00RRGGBB)
#	Outputs:
#		No register outputs
#*****************************************************
draw_pixel: nop
	lw $t0 0xffff0000
	getCoordinates($a0 $t1 $t2)
	getPixelAddress($t3 $t1 $t2)
	sw $a1,($t3)
	jr $ra
	
#*****************************************************
# get_pixel:
#  Given a coordinate, returns the color of that pixel	
#-----------------------------------------------------
#	Inputs:
#		$a0 = coordinates of pixel in format (0x00XX00YY)
#	Outputs:
#		Returns pixel color in $v0 in format (0x00RRGGBB)
#*****************************************************
get_pixel: nop
	# YOUR CODE HERE, only use t registers (and a, v where appropriate)
	lw $t0, 0xffff0000
	getCoordinates($a0 $t1 $t2)
	getPixelAddress($t3 $t1 $t2)
	lw $v0, ($t3)
	jr $ra

#*****************************************************
# draw_horizontal_line: Draws a horizontal line
# ----------------------------------------------------
# Inputs:
#	$a0 = y-coordinate in format (0x000000YY)
#	$a1 = color in format (0x00RRGGBB) 
# Outputs:
#	No register outputs
#*****************************************************
draw_horizontal_line: nop
	# YOUR CODE HERE, only use t registers (and a, v where appropriate)
	push($ra)
	push($t0)
	push($t1)
	push($t2)
	push($t3)
	push($t4)
	push($t5)
	lw $t0, 0xffff0000
	formatCoordinates($t1, $zero, $a0)
	getCoordinates($t1, $t2, $t3)
	getPixelAddress($t4, $zero, $t3)
	li $t5, 128 #counter for 128 bits
	#Horizontal line loop
	HorizonLoop:
	sw $a1, ($t4)
	addi $t4, $t4, 4
	addi $t5, $t5, -1
	bnez $t5, HorizonLoop
	NOP
	pop($t5)
	pop($t4)
	pop($t3)
	pop($t2)
	pop($t1)
	pop($t0)
	pop($ra)
 	jr $ra


#*****************************************************
# draw_vertical_line: Draws a vertical line
# ----------------------------------------------------
# Inputs:
#	$a0 = x-coordinate in format (0x000000XX)
#	$a1 = color in format (0x00RRGGBB) 
# Outputs:
#	No register outputs
#*****************************************************
draw_vertical_line: nop
	# YOUR CODE HERE, only use t registers (and a, v where appropriate)
	push($ra)
	push($t0)
	push($t1)
	push($t2)
	push($t3)
	push($t4)
	push($t5)
	lw $t0, 0xffff0000
	formatCoordinates($t1, $a0, $zero)
	getCoordinates($t1, $t2, $t3)
	getPixelAddress($t4, $t2, $zero)
	li $t5, 128 #Counter for 128 bits
	# Vertical line loop
	VertLoop:
	sw $a1, ($t4)
	add $t4, $t4, 512
	addi $t5, $t5, -1
	bnez $t5, VertLoop
	NOP
	pop($t5)
	pop($t4)
	pop($t3)
	pop($t2)
	pop($t1)
	pop($t0)
	pop($ra)
 	jr $ra


#*****************************************************
# draw_crosshair: Draws a horizontal and a vertical 
#	line of given color which intersect at given (x, y).
#	The pixel at (x, y) should be the same color before 
#	and after running this function.
# -----------------------------------------------------
# Inputs:
#	$a0 = (x, y) coords of intersection in format (0x00XX00YY)
#	$a1 = color in format (0x00RRGGBB) 
# Outputs:
#	No register outputs
#*****************************************************
draw_crosshair: nop
	push($ra)
	
	# HINT: Store the pixel color at $a0 before drawing the horizontal and 
	# vertical lines, then afterwards, restore the color of the pixel at $a0 to 
	# give the appearance of the center being transparent.
	
	# Note: Remember to use push and pop in this function to save your t-registers
	# before calling any of the above subroutines.  Otherwise your t-registers 
	# may be overwritten.  
	
	# YOUR CODE HERE, only use t0-t7 registers (and a, v where appropriate)
	push($t1)
	push($t2)
	push($t3)
	getCoordinates($a0, $t1, $t2)
	getPixelAddress($t3, $t1, $t2)
	sw $a1, ($t3)
	jal draw_horizontal_line
	jal draw_vertical_line
	la $a1 0x00708090
	getCoordinates($a0, $t1, $t2)
	getPixelAddress($t3, $t1, $t2)
	sw $a1, ($t3)
	jal draw_pixel
	pop($t3)
	pop($t2)
	pop($t1)
	# HINT: at this point, $ra has changed (and you're likely stuck in an infinite loop). 
	# Add a pop before the below jump return (and push somewhere above) to fix this.
	pop($ra)
	jr $ra
	

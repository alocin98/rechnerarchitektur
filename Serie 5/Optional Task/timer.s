/*
-----------------------------------------------------------
 Series 5 - Raspberry Pi Programming Optional Task - Timer

 Group members:
 Cedric Aebi; Nicolas Müller; Gan Altuntas

 Individualised code by:
 Cedric Aebi; Nicolas Müller; Gan Altuntas

 Exercise Version:
 ** Version 1 **

 Notes:
 We provide hints and guidance in the comments below and
 strongly encourage you to follow the skeleton.
 However, you are free to change the code as you like.

-----------------------------------------------------------
*/

.global main
.func main

main:
	// This will setup the wiringPi library.
	// In case something goes wrong, we exit the program
	BL      wiringPiSetupGpio
	CMP	    R0, #-1
	BEQ	    exit


configurePins:
	// Set the data pin to 'output' mode
	LDR	    R0, .DATA_PIN
	LDR	    R1, .OUTPUT
	BL	    pinMode

	// Set the latch pin to 'output' mode
	LDR     R0, .LATCH_PIN
  	LDR     R1, .OUTPUT
  	BL      pinMode

	// Set the clock pin to 'output' mode
	LDR     R0, .CLOCK_PIN
  	LDR     R1, .OUTPUT
  	BL      pinMode

	//Set the sound pin to 'output' mode
	LDR     R0, .SOUND_PIN
	LDR     R1, .OUTPUT
	BL	    pinMode

	// Set the pins of BUTTON 1 and BUTTON 2 to 'input' mode
	LDR	    R0, .BUTTON1_PIN
	LDR	    R1, .INPUT
	BL	    pinMode

	LDR	    R0, .BUTTON2_PIN
	LDR	    R1, .INPUT
	BL	    pinMode

    	//This sets the pull-up or pull-down resistor mode on the BUTTON2_PIN
	LDR	    R0, .BUTTON1_PIN
	LDR	    R1, .PUD_UP
	BL	    pullUpDnControl

    	//This sets the pull-up or pull-down resistor mode on the BUTTON2_PIN
	LDR	    R0, .BUTTON2_PIN
	LDR	    R1, .PUD_UP
	BL	    pullUpDnControl


start:
    /*
    This extra function initializes some Registers, which we need later. Then jumps to the main Loop
    */
	
	//Register for led bar
	MOV	    R5, #1

	//State of the two buttons (R7 for button 1, R8 for button 2). 0 means it's not yet pressed
	MOV	    R7,  #0
	MOV	    R8,  #0
	
	//Register that holds Timer in minutes
	MOV	    R9,  #0

	BL	    setTime
	

setTime:
    	
	BL	showLedNumber
	
	//Check for Button1 to be pressed
	LDR	    R0, .BUTTON1_PIN
	MOV	    R1, #200
	MOV	    R2, R7
	BL	    waitForButton
	MOV	    R7, R1

	//If pressed, increase Time
	CMP	R0, #1
	ADDEQ	R9, #1
	BL	showLedNumber

	//Check for Button2 to be pressed
	LDR	    R0, .BUTTON2_PIN
	MOV	    R1, #200
	MOV	    R2, R7
	BL	    waitForButton
	MOV	    R7, R1

	//If pressed, start Timer
	CMP	R0, #1
	BLEQ	startTimer

	B	setTime
	
startTimer:
	
	BL	timerRoutine
	

knightRiderLoop:
	/*
	This is the main Loop which lets the LED run, and does the most important
    thing. The shiftOut subroutine is fot converting seriell data into parallel for the display.
	To do so
	1. Set the latch pin to low
	2. Send the data with shiftOut
	3. Set the latch pin to high
	*/
	
	//To show the current state of the LED bar, we call a subroutine to display R5
	BL 	    showLed

	// Detect button presses and increase/decrease the delay
	// Use the 'waitForButton' subroutine for each button
	//Check if button pressed Right
	LDR	    R0, .BUTTON1_PIN
	MOV	    R1, R10
	MOV	    R2, R7
	BL	    waitForButton
	MOV	    R7, R1
	

	/* Other logic goes here, like updating variables, branching to the loop label, etc. */


	/* Let the LED run */
	//Do a left shift when R9 is 0
	CMP	    R9, #0
	LSLEQ	R5, R5, #1

	//Do a right shift when R9 is 1 (R9 = 1 means the LED travels to the right)
	CMP	    R9, #1
	LSREQ	R5, R5, #1

	//If the LED is on 128 then we change the direction information in R9 to 1, so the LED now
    	//travels to the right
	CMP	    R5, #128
	MOVEQ	R9, #1
	SUBEQ	R10,#1				//Decreases the delay by 1 with each direction change

    	//If the LED is on 1 then we change the direction information in R9 to 1, so the LED now
    	//travels to the left
	CMP	    R5, #1
	MOVEQ	R9, #0
	SUBEQ	R10,#1              //Decreses the delay by 1 with each direction change
	
	//End Loop if game finished. When the delay reaches 20 (which is nearly too fast to play), we go to the
    	//end loop which finishes the game
	CMP	    R10, #20
	BEQ	    end
	
	
	//Jump to Loop if the delay is not yet 20
	B       knightRiderLoop


exit:	
	MOV 	R7, #1				// System call 1, exit
	SWI 	0				// Perform system call


/*
-------------------------------------------------------------------------
 SUBROUTINES
-------------------------------------------------------------------------

If you wish, you can define your own subroutines here.
Make sure you save the registers on the stack to avoid conflicts.
Here is an example:

foo:
	STMDB SP!, {R3, R4, LR}
	// ... do something here with registers R3 and R4 ...
	LDMIA SP!, {R3, R4, PC} // end of foo subroutine, restore registers and jump

*/

waitForButton:
	/*
	-----------------------------------------------------------------
	 Input arguments:
	 R0:	buttonPin
	 R1: 	timeout (millis)
	 R2: 	previous button state

	 Output:
	 R0:	1 if button pressed (falling edge), 0 otherwise
	 R1:	state of button 1 if button pressed (falling edge), 0 otherwise(High/Low)
	-----------------------------------------------------------------
	*/
	STMDB   SP!, {R2-R10, LR}

	MOV	    R5, R0 		// R5: buttonPin
	MOV	    R6, R1		// R6: timeout
	MOV	    R9, R2		// R9: (previous) button state
	MOV	    R10, #0		// R10: button pressed or not

	@ get start time
	BL	    millis
	MOV	    R7, R0 		// R7: start time

	waitingLoopForButton:

		// read button pin state
		MOV	    R0, R5
		BL	    digitalRead

		// Check if edge is falling (1 -> 0)
		SUB	    R1, R9, R0
		MOV	    R9, R0			// previous = current
		CMP	    R1, #1
		MOVEQ	R10, #1

		// compute elapsed time
		BL	    millis
		SUB	    R0, R0, R7

		// check if elapsed time < time out
		CMP	    R0, R6
		BMI	    waitingLoopForButton
		B	    returnButtonPress

	returnButtonPress:
	MOV	    R0, R10				// return 1 if button pressed within time window
	MOV	    R1, R9
	LDMIA   SP!, {R2-R10, PC}


showLed:
    /*This is the main logic to run the LED. It utilizes the shiftOut subroutine to
     show the state of the LED on the display */
	STMDB   SP!, {R0-R5, LR}
	
	// Set latch pin low (read serial data)
	LDR	    R0, .LATCH_PIN
	LDR	    R1, .LOW
	BL	    digitalWrite

	// Send serial data (shiftOut)
	LDR	    R0, .DATA_PIN
	LDR	    R1, .CLOCK_PIN
	LDR	    R2, .LSBFIRST
	MOV	    R3, R5
	BL	    shiftOut

	// Set latch pin high (write serial data to parallel output)
	LDR	    R0, .LATCH_PIN
	LDR	    R1, .HIGH
	BL	    digitalWrite

	LDMIA   SP!, {R0-R5, PC}

makeSound:
    /*This gets called by the rightPaddle subroutine. It just makes a sound */
	STMDB   SP!, {R0,R1, LR}
	
	//Set sound pin HIGH (read serial data)
	LDR	    R0, .SOUND_PIN
	LDR	    R1, .HIGH
	BL	    digitalWrite

    //waits for 10ms
	MOV	    R0, #10
	BL	    delay

	// Set sound pin LOW (read serial data)
	LDR	    R0, .SOUND_PIN
	LDR	    R1, .LOW
	BL	    digitalWrite

	
	LDMIA   SP!, {R0,R1, PC}
	
timerRoutine:
	/*
	-----------------------------------------------------------------
	 Input arguments:
	 R9:	timer in minutes
	-----------------------------------------------------------------
	*/

	STMDB   SP!, {R0,R10,R11,LR}
	
	MOV	R11, #0	

	MOV	R10, #60
	BL      timerOneMinute
	
	timerOneMinute:
		CMP	R11, #1
		BLEQ	makeSound
		MOVEQ	R5, #0
		BLEQ	showLed

		CMP	R11, #0
		BLEQ	showLedNumber


		CMP	R11, #1
		MOVEQ	R11, #0

		CMP	R11, #0
		MOVEQ	R11, #1
		

		MOV	R0, #1000
		BL      delay


		SUB	R10, #1
		CMP     R10, #0
		BGT	timerOneMinute
		BL	checkEnd

	checkEnd:
	
		SUB	R9, #1
		CMP	R9, #0
		BGT	timerOneMinute
		
	LDMIA   SP!, {R0,R10,R11,PC}

showLedNumber:
	/*
	-----------------------------------------------------------------
	Shows the number of R9 in the Led bar. 
	Input arguments:
	 R9:	timer in minutes
	-----------------------------------------------------------------
	*/

	STMDB   SP!, {R0,R10, LR}
	
	CMP	R9, #0
	LDREQ	R5, .ONE_MINUTE
	
	CMP	R9, #1
	LDREQ	R5, .ONE_MINUTE

	CMP	R9, #2
	LDREQ	R5, .TWO_MINUTE

	CMP	R9, #3
	LDREQ	R5, .THREE_MINUTE

	CMP	R9, #4
	LDREQ	R5, .FOUR_MINUTE

	CMP	R9, #5
	LDREQ	R5, .FIVE_MINUTE

	CMP	R9, #6
	LDREQ	R5, .SIX_MINUTE

	CMP	R9, #7
	LDREQ	R5, .SEVEN_MINUTE

	CMP	R9, #8
	LDREQ	R5, .EIGHT_MINUTE

	BL	showLed
	
	LDMIA   SP!, {R0,R10, PC}


// Constants for high- and low signals on the pins
.HIGH:			.word	1
.LOW:			.word	0

// The mode of the pin can be set to input or output.
.OUTPUT:		.word	1
.INPUT:			.word 	0

// For buttons (pull up / pull down)
.PUD_OFF:		.word	0
.PUD_DOWN:		.word	1
.PUD_UP:		.word	2

// For serial to parallel converter (74HC595 chip)
.LSBFIRST:		.word	0		// Least significant bit first
.MSBFIRST:		.word 	1		// Most significant bit first

.DATA_PIN:		.word	17 		// DS Pin of 74HC595 (Pin14)
.LATCH_PIN:		.word	27		// ST_CP Pin of 74HC595 (Pin12)
.CLOCK_PIN:		.word	22		// CH_CP Pin of 74HC595 (Pin11)
.SOUND_PIN:		.word	24		//Sound Pin

// Button pins
.BUTTON1_PIN:		.word	18
.BUTTON2_PIN:		.word	25

//For LED
.ONE_MINUTE:		.word	1		
.TWO_MINUTE:		.word	2
.THREE_MINUTE:		.word	4
.FOUR_MINUTE:		.word	8
.FIVE_MINUTE:		.word	16
.SIX_MINUTE:		.word	32
.SEVEN_MINUTE:		.word	64
.EIGHT_MINUTE:		.word	128

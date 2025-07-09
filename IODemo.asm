; IODemo.asm
; Produces a "bouncing" animation on the LEDs.
; The LED pattern is initialized with the switch state.

ORG 0

Start:
	; Get and store the switch values
	IN     Switches
    STORE  SwitchValue
 	STORE  Value
    CALL   FindLowestSetBit
    JNEG   Start
    STORE  Result
    LOADI  0
    ADDI   1
    STORE  SwitchCounter
Shift:
    LOAD   Value
    SHIFT  -1
    STORE  Value
    LOAD   Result
    ADDI   -1
    STORE  Result
    JNEG   FindNext
    JUMP   Shift
FindNext:
    LOAD   Value
    CALL   FindLowestSetBit
    JNEG   CheckNumSwitch
    STORE  Result
    LOAD   SwitchCounter
    ADDI   1
    STORE  SwitchCounter
    JUMP   Shift
    
CheckNumSwitch:
	LOAD SwitchCounter
    ADDI -2
    JPOS Start

StartPattern:
	LOAD   SwitchValue
	OUT    LEDs
	STORE  Pattern
	
Left:
	; Slow down the loop so humans can watch it.
	CALL   Delay

	; Check if the left place is 1 and if so, switch direction
	LOAD   Pattern
	AND    Bit9         ; bit mask
	JNZ    Right        ; bit9 is 1; go right
	
	LOAD   Pattern
	SHIFT  1
	STORE  Pattern
	OUT    LEDs

	JUMP   Left
	
Right:
	; Slow down the loop so humans can watch it.
	CALL   Delay

	; Check if the right place is 1 and if so, switch direction
	LOAD   Pattern
	AND    Bit0         ; bit mask
	JNZ    Left         ; bit0 is 1; go left
	
	LOAD   Pattern
	SHIFT  -1
	STORE  Pattern
	OUT    LEDs
	
	JUMP   Right
	
; To make things happen on a human timescale, the timer is
; used to delay for half a second.
Delay:
	OUT    Timer
WaitingLoop:
	IN     Timer
	ADDI   -5
	JNEG   WaitingLoop
	RETURN
    
; Find lowest bit function
FindLowestSetBit:
    STORE Value_Copy
    LOADI 0
    STORE Counter
    
Loop:
	LOAD  Value_Copy
    AND   Bit0
    JPOS  Found
	LOAD  Counter
    ADDI  -16
    JZERO NotFound
    LOAD  Counter
    ADDI  1
    STORE Counter
    LOAD  Value_Copy
    SHIFT -1
    STORE Value_Copy
	JUMP  Loop
Found:
	LOAD  Counter
    RETURN
NotFound:
	LOADI -1
    RETURN

; Variables
Pattern:   DW 0
Counter:   DW 0
Value: 	   DW 0
Value_Copy: DW 0
Result:    DW 0
SwitchValue: DW 0
SwitchCounter: DW 0

; Useful values
Bit0:      DW &B0000000001
Bit9:      DW &B1000000000

; IO address constants
Switches:  EQU 000
LEDs:      EQU 001
Timer:     EQU 002
Hex0:      EQU 004
Hex1:      EQU 005
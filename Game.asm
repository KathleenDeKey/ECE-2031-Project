; IODemo.asm
; Produces a "bouncing" animation on the LEDs.
; The LED pattern is initialized with the switch state.

ORG 0
	LOADI  0
    STORE  RandNum
    STORE  Score

InitializeVar:
	LOADI  0
    STORE  RandNum

CheckAllSwitchesDown:
	IN     Switches
 	JZERO  Switch9Up
    JUMP   CheckAllSwitchesDown
    
Switch9Up:
	IN     Switches
    AND    Bit9
    JPOS   CalcRandNum
    LOAD   RandNum
    ADDI   1
    STORE  RandNum
    JUMP   Switch9Up
    
CalcRandNum:
    LOAD   RandNum
    AND    BitLow
    JZERO  SetOne
    STORE  RandNum
    JUMP   SetLEDDisplay
SetOne:
	LOADI  1
    STORE  RandNum

SetLEDDisplay:
	IN     Switches
    OUT    LEDs
    LOAD   RandNum
    OUT    hex0
    LOAD   Score
    OUT    hex1

CheckSwitchUp:
	;CALL   Delay
	IN     Switches
    AND    MaskBit9
    JZERO  CheckSwitchUp
    
SetLEDandCheckBit:
    OR     Bit9
	OUT    LEDs
    STORE  SwitchValue
    LOAD   RandNum
    CALL   FindLowestSetBit
    STORE  Answer
    LOAD   SwitchValue
    CALL   FindLowestSetBit
    SUB    Answer
    JZERO  IncrementScore

ChangeScoreToZero:
	LOADI  0
    STORE  Score
    OUT    hex1
    JUMP   Finish

IncrementScore:
	LOAD   Score
    ADDI   1
    STORE  Score
    OUT    hex1
    JUMP   Finish

Finish:
	JUMP   InitializeVar
   
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
RandNum:   DW 0
Score:     DW 0
SwitchValue: DW 0
Value_Copy:     DW 0
Counter:   DW 0
Answer:    DW 0


; Useful values
Bit0:      DW &B0000000001
Bit9:      DW &B1000000000
BitLow:    DW &H00FF
MaskBit9:  DW &B0111111111

; IO address constants
Switches:  EQU 000
LEDs:      EQU 001
Timer:     EQU 002
Hex0:      EQU 004
Hex1:      EQU 005

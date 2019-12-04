.MODEL SMALL

.STACK 100H

;--------------MUSICAL KEYBOARD-----------
;-----------------------------------------
;-------------TO USE THE PROGRAM----------
;------------q-w-e-r-t-y-u-Q-W-E---------- LOWER CASE qwertyu and SHIFT+Q,W,E FOR NOTES
;-----------PRESS M FOR SHREK MODE--------
;--------------PRESS X TO EXIT------------
;-----------------------------------------

;TO RUN THE PROGRAM
;1. Download DOSBOX 16 bit emulator
;2. Download Turbo Assembler (TASM)
;3. Mount your C:/TASM folder using MOUNT command and include the asm file in the folder
;3.5 mount c c://tasm (DONE INSIDE OF DOSBOX STEP 3 THROUGH 6)
;4. Use TASM to assemble the .asm file via "tasm m.asm" as long as m.asm is in the same directory as TASM and TLINK
;5. run "tlink m.obj" to link the file
;6. run "m.exe"

;IO Speaker - Programmable interval timer (PIT) Ports
PIT_TIMER_COUNT equ 42h ;Use PIT_TIMER_COUNT for port name instead of 42h.
PIT_TIMER_CONRTOL equ 43h ;Use PIT_TIMER_CONTROL for port name instead of 43h.
SYSTEM_CONTROL_PORT_B equ 61h ;Use SYSTEM_CONTROL_PORT_B for port name instead of 61h
;Cnote equ 146 ;146 frequency is note C
;Dnote equ 164 ;164 = D
;Enote equ 182 ;182 = E
;Fnote equ 195 ;195 = F
;Gnote equ 219 ;219 = G
;Anote equ 243 ;243 = A
;Bnote equ 274 ;274 = B
;Cnote equ 292 ;292 = C

;1. Program the PIT to use timer 2 as a square wave generator. Write byte
;10110110b to the PIT Control Port.
;2. Load count value, LSB (bits 0-7) then MSB (bits 8-15).
;3. Enable the speaker output by writing a 1 to bits 0 & 1 of System Control
;Port B. Do not modify any other bits as they control other PC functions.
;4. Write a 0 to bits 0 and 1 of the System Control Port B to stop the tone.
;Do not modify any other bits as they control other PC functions. 
;These steps are from spot.pcc.edu source 

.DATA 

.CODE
SOUND   PROC 
    
  ;DI Register takes in the square wave Frequency in hertz(HZ)
  PUSH BX ;BX register is pushed, used to delay between notes
  MOV AL, 0B6H ;Sets port 42h to channel 2 and issues square wave pulses for sound
  OUT PIT_TIMER_CONRTOL, AL  ;command register port
  MOV DX, 14h ;frequency fundamental = Bb. 13h=A
  DIV DI
  OUT PIT_TIMER_COUNT, AL ;saves lower byte of frequency to PIT Timer 2 Count port
  MOV AL, AH
  OUT PIT_TIMER_COUNT, AL ;saves higher byte of frequency to computer speaker port
  IN  AL, SYSTEM_CONTROL_PORT_B ;Reads port mode from system control port
  MOV AH, AL
  OR  AL, 3 ;set 2 least sig bits - turns on the speaker!
  OUT SYSTEM_CONTROL_PORT_B, AL ;bits are done being set now
L1: MOV CX, 10000 ;Amount to Delay loop counter
L2: LOOP    L2   
  DEC BX ;Used to delay between notes
  JNZ L1
  MOV AL, AH
  OUT SYSTEM_CONTROL_PORT_B, AL 
  POP BX ;Restore original value of BX
  RET
SOUND   ENDP
MAIN    PROC 
  MOV BX, 50
KEYBOARDPIANO: MOV AH, 0
  INT 16H   ;read char
  CMP AL, 'x'
  JE  EXIT
  CMP AL, 'q' ; fundamental frequency (tonic)
  JE  Bb 
  CMP AL, 'w' ; 9:8hz relationship to fundamental (supertonic, major second)
  JE  C
  CMP AL, 'e' ; 5:4hz relationship to fundamental (mediant, major third)
  JE  D
  CMP AL, 'r' ; 4:3hz relationship to fundamental (subdominant, perfect fourth) 
  JE  Eb
  CMP AL, 't' ; 3:2hz relationship to fundamental (dominant, perfect fifth)
  JE  F
  CMP AL, 'y' ; 5:3hz relationship to fundamental (submediant, major sixth)
  JE  G                         
  CMP AL, 'u' ; 15:8hz relationship to fundamental (leading tone, major seventh)                          
  JE  A 
  CMP AL, 'Q' ; Fundmental frequency, one octave higher
  JE  Bb2 
  CMP AL, 'W' ; Supertonic, one octave higher
  JE  C2 
  CMP AL, 'E' ; Mediant, one octave higher
  JE  D2                    
  CMP AL, 'm' ; m for music -> jumps to final countdown song.
  JE  FINALCOUNTDOWN ; m->Final Countdown Song
  JNZ KEYBOARDPIANO
Bb: MOV DI, 131 ; mov 131 frequency onto the DI register
  CALL    SOUND ; call the sound function which takes in frequency and outputs note
  JMP KEYBOARDPIANO ; jump to beginning of function to allow new note
C: MOV DI, 147
  CALL    SOUND
  JMP KEYBOARDPIANO
D: MOV DI, 165  ;c
  CALL    SOUND        
  JMP KEYBOARDPIANO
Eb: MOV DI, 175
  CALL    SOUND
  JMP KEYBOARDPIANO
F:    MOV DI, 196
  CALL    SOUND
  JMP KEYBOARDPIANO
G: MOV DI, 220
  CALL    SOUND
  JMP KEYBOARDPIANO
A: MOV DI, 247
  CALL    SOUND
  JMP KEYBOARDPIANO 
Bb2: MOV DI, 262
  CALL    SOUND
  JMP KEYBOARDPIANO 
C2: MOV DI, 294
  CALL    SOUND
  JMP KEYBOARDPIANO 
D2: MOV DI, 330  ;c
  CALL    SOUND        
  JMP KEYBOARDPIANO     
EXIT:   MOV AH, 00H
  MOV AL, 03H
  INT 10H
  MOV AX, 4C00H
  INT 21H
  RET
   
FINALCOUNTDOWN:  

  MOV DI, 243       
  CALL    SOUND
  MOV DI, 219   
  CALL    SOUND
  MOV DI, 243  
  CALL    SOUND
  MOV DI, 243   
  CALL    SOUND
  MOV DI, 243   
  CALL    SOUND
  MOV DI, 243    
  CALL    SOUND
  MOV DI, 164   
  CALL    SOUND
  MOV DI, 164     
  CALL    SOUND
  MOV DI, 164   
  CALL    SOUND
  MOV DI, 164   
  CALL    SOUND 
  ;END OF FIRST MEASURE
  
  MOV DI, 82   
  CALL    SOUND
  MOV DI, 82   
  CALL    SOUND
  MOV DI, 82  
  CALL    SOUND
  MOV DI, 82   
  CALL    SOUND  
  MOV DI, 82  
  CALL    SOUND 
  MOV DI, 82   
  CALL    SOUND
  MOV DI, 260
  CALL    SOUND
  MOV DI, 243  
  CALL    SOUND 
  MOV DI, 260   
  CALL    SOUND  
  MOV DI, 260
  CALL    SOUND
  MOV DI, 243
  CALL    SOUND 
  MOV DI, 243
  CALL    SOUND
  MOV DI, 219   
  CALL    SOUND
  MOV DI, 219    
  CALL    SOUND 
  MOV DI, 219   
  CALL    SOUND
  MOV DI, 219
  CALL    SOUND  
  ;END OF SECOND MEASURE
  
  MOV DI, 65  
  CALL    SOUND
  MOV DI, 65
  CALL    SOUND   
  MOV DI, 65  
  CALL    SOUND
  MOV DI, 65
  CALL    SOUND    
  MOV DI, 65  
  CALL    SOUND 
  MOV DI, 65
  CALL    SOUND   
  MOV DI, 260
  CALL    SOUND
  MOV DI, 243
  CALL    SOUND    
  MOV DI, 260
  CALL    SOUND
  MOV DI, 260    
  CALL    SOUND 
  MOV DI, 260   
  CALL    SOUND
  MOV DI, 260   
  CALL    SOUND 
  MOV DI, 164   
  CALL    SOUND
  MOV DI, 164  
  CALL    SOUND    
  MOV DI, 164  
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND 
  ;END OF THIRD MEASURE
  
  MOV DI, 146
  CALL    SOUND
  MOV DI, 146
  CALL    SOUND    
  MOV DI, 146   
  CALL    SOUND
  MOV DI, 146
  CALL    SOUND
  MOV DI, 146
  CALL    SOUND
  MOV DI, 146
  CALL    SOUND 
  MOV DI, 219   
  CALL    SOUND 
  MOV DI, 195
  CALL    SOUND   
  MOV DI, 219
  CALL    SOUND
  MOV DI, 219  
  CALL    SOUND   
  MOV DI, 195   
  CALL    SOUND 
  MOV DI, 195 
  CALL    SOUND   
  MOV DI, 189
  CALL    SOUND
  MOV DI, 189  
  CALL    SOUND  
  
  MOV DI, 219   
  CALL    SOUND 
  MOV DI, 219
  CALL    SOUND 
  ;END OF MEASURE 4
  
    
  MOV DI, 195
  CALL    SOUND
  MOV DI, 195  
  CALL    SOUND 
  MOV DI, 195   
  CALL    SOUND 
  MOV DI, 195
  CALL    SOUND   
  MOV DI, 195
  CALL    SOUND
  MOV DI, 195  
  CALL    SOUND       
  MOV DI, 243   
  CALL    SOUND
  MOV DI, 219   
  CALL    SOUND
  MOV DI, 243  
  CALL    SOUND
  MOV DI, 243     
  CALL    SOUND
  MOV DI, 243   
  CALL    SOUND
  MOV DI, 243    
  CALL    SOUND
  MOV DI, 164   
  CALL    SOUND
  MOV DI, 164     
  CALL    SOUND
  MOV DI, 164   
  CALL    SOUND
  MOV DI, 164   
  CALL    SOUND
  ;END OF FIFTH MEASURE     
    
  MOV DI, 82   
  CALL    SOUND
  MOV DI, 82   
  CALL    SOUND
  MOV DI, 82  
  CALL    SOUND
  MOV DI, 82   
  CALL    SOUND  
  MOV DI, 82  
  CALL    SOUND 
  MOV DI, 82   
  CALL    SOUND
  MOV DI, 260
  CALL    SOUND
  MOV DI, 243  
  CALL    SOUND 
  MOV DI, 260   
  CALL    SOUND  
  MOV DI, 260
  CALL    SOUND
  MOV DI, 243
  CALL    SOUND 
  MOV DI, 243
  CALL    SOUND
  MOV DI, 219  
  CALL    SOUND
  MOV DI, 219    
  CALL    SOUND 
  MOV DI, 219   
  CALL    SOUND
  MOV DI, 219
  CALL    SOUND  
  ;END OF SIXTH MEASURE
  
  MOV DI, 65  
  CALL    SOUND
  MOV DI, 65
  CALL    SOUND   
  MOV DI, 65   
  CALL    SOUND
  MOV DI, 65
  CALL    SOUND    
  MOV DI, 65 
  CALL    SOUND 
  MOV DI, 65
  CALL    SOUND   
  MOV DI, 260
  CALL    SOUND
  MOV DI, 243
  CALL    SOUND    
  MOV DI, 260
  CALL    SOUND
  MOV DI, 260     
  CALL    SOUND 
  MOV DI, 260  
  CALL    SOUND
  MOV DI, 260   
  CALL    SOUND 
  MOV DI, 164   
  CALL    SOUND
  MOV DI, 164  
  CALL    SOUND    
  MOV DI, 164   
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND    
  ;END OF SEVENTH MEASURE
  
  
  MOV DI, 146
  CALL    SOUND
  MOV DI, 146
  CALL    SOUND    
  MOV DI, 146  
  CALL    SOUND
  MOV DI, 146
  CALL    SOUND
  MOV DI, 146
  CALL    SOUND
  MOV DI, 146
  CALL    SOUND 
  
  MOV DI, 219   
  CALL    SOUND 
  MOV DI, 195
  CALL    SOUND   
  MOV DI, 219
  CALL    SOUND
  MOV DI, 219  
  CALL    SOUND 
  
  MOV DI, 195   
  CALL    SOUND 
  MOV DI, 195 
  CALL    SOUND   
  MOV DI, 189
  CALL    SOUND
  MOV DI, 189  
  CALL    SOUND  
  
  MOV DI, 219   
  CALL    SOUND 
  MOV DI, 219
  CALL    SOUND 
  ;END OF 8TH MEASURE  
  
  MOV DI, 195
  CALL    SOUND  
  MOV DI, 195
  CALL    SOUND
  MOV DI, 195
  CALL    SOUND
  MOV DI, 195
  CALL    SOUND
  MOV DI, 195
  CALL    SOUND
  MOV DI, 195
  CALL    SOUND
  MOV DI, 189 
  CALL    SOUND
  MOV DI, 195  
  CALL    SOUND
  MOV DI, 219    
  CALL    SOUND
  MOV DI, 219  
  CALL    SOUND
  MOV DI, 219   
  
  CALL    SOUND  
  MOV DI, 219  
  CALL    SOUND 
  MOV DI, 219   
  CALL    SOUND  
  MOV DI, 219   
  CALL    SOUND 
  MOV DI, 195
  CALL    SOUND
  MOV DI, 219
  CALL    SOUND
  ;END OF NINTH MEASURE
  
  MOV DI, 243
  CALL    SOUND
  MOV DI, 243
  CALL    SOUND
  MOV DI, 219
  CALL    SOUND
  MOV DI, 219
  CALL    SOUND
  MOV DI, 195
  CALL    SOUND
  MOV DI, 195
  CALL    SOUND
  MOV DI, 182
  CALL    SOUND
  MOV DI, 182
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND 
  MOV DI, 164
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  MOV DI, 260
  CALL    SOUND 
  MOV DI, 260
  CALL    SOUND
  MOV DI, 260
  CALL    SOUND
  MOV DI, 260
  CALL    SOUND
  ;END OF TENTH MEASURE  
  
  MOV DI, 243
  CALL    SOUND 
  MOV DI, 243
  CALL    SOUND
  MOV DI, 121
  CALL    SOUND
  MOV DI, 121
  CALL    SOUND
  MOV DI, 243
  CALL    SOUND
  MOV DI, 243
  CALL    SOUND
  MOV DI, 121
  CALL    SOUND
  MOV DI, 121
  CALL    SOUND 
  MOV DI, 243
  CALL    SOUND
  MOV DI, 243
  CALL    SOUND
  MOV DI, 243
  CALL    SOUND
  MOV DI, 260
  CALL    SOUND 
  MOV DI, 260
  CALL    SOUND  
  MOV DI, 260
  CALL    SOUND 
  MOV DI, 243
  CALL    SOUND
  MOV DI, 219
  CALL    SOUND 
  ;END OF ELEVENTH MEASURE
  
  MOV DI, 243
  CALL    SOUND
  MOV DI, 243
  CALL    SOUND
  MOV DI, 243
  CALL    SOUND
  MOV DI, 243
  CALL    SOUND
  MOV DI, 243
  CALL    SOUND
  MOV DI, 243
  CALL    SOUND
  MOV DI, 243
  CALL    SOUND
  MOV DI, 243
  CALL    SOUND
  MOV DI, 121
  CALL    SOUND    
  MOV DI, 121
  CALL    SOUND
  MOV DI, 121
  CALL    SOUND
  MOV DI, 121
  CALL    SOUND
  MOV DI, 121
  CALL    SOUND
  MOV DI, 121
  CALL    SOUND
  MOV DI, 121
  CALL    SOUND
  MOV DI, 121
  CALL    SOUND
  ;END OF 12TH MEASURE
  
  MOV DI, 164
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  MOV DI, 82
  CALL    SOUND 
  MOV DI, 82
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  MOV DI, 82
  CALL    SOUND
  MOV DI, 82
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  ;END OF 13TH MEASURE 
  
  MOV DI, 164
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  MOV DI, 82
  CALL    SOUND 
  MOV DI, 82
  CALL    SOUND  
  MOV DI, 164
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  MOV DI, 146
  CALL    SOUND
  MOV DI, 146
  CALL    SOUND
  ;END 14th MEASURE
  
  MOV DI, 164
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  MOV DI, 82
  CALL    SOUND
  MOV DI, 82
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  MOV DI, 82
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  MOV DI, 188
  CALL    SOUND 
  MOV DI, 188
  CALL    SOUND 
  MOV DI, 188
  CALL    SOUND
  MOV DI, 195
  CALL    SOUND
  MOV DI, 195
  CALL    SOUND
  ;END OF 15TH MEASURE
  
  MOV DI, 188
  CALL    SOUND
  MOV DI, 188
  CALL    SOUND
  MOV DI, 188
  CALL    SOUND 
  MOV DI, 188
  CALL    SOUND 
  MOV DI, 164
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND  
  ;END OF 16TH MEASURE
  
  MOV DI, 82
  CALL    SOUND
  MOV DI, 82
  CALL    SOUND 
  MOV DI, 82
  CALL    SOUND
  MOV DI, 82
  CALL    SOUND
  MOV DI, 82
  CALL    SOUND 
  MOV DI, 82
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  MOV DI, 82
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  MOV DI, 188
  CALL    SOUND 
  MOV DI, 188
  CALL    SOUND 
  MOV DI, 188
  CALL    SOUND
  MOV DI, 195
  CALL    SOUND 
  MOV DI, 195
  CALL    SOUND
  ;END OF 17TH MEASURE
  
  MOV DI, 164
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  ;END OF 18TH MEASURE 
  
  MOV DI, 82
  CALL    SOUND
  MOV DI, 82
  CALL    SOUND 
  MOV DI, 82
  CALL    SOUND
  MOV DI, 82
  CALL    SOUND
  MOV DI, 82
  CALL    SOUND 
  MOV DI, 82
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  MOV DI, 82
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  MOV DI, 188
  CALL    SOUND
  MOV DI, 188
  CALL    SOUND
  MOV DI, 188
  CALL    SOUND
  MOV DI, 195
  CALL    SOUND
  MOV DI, 195
  CALL    SOUND
  ;END OF 19TH MEASURE
  
  MOV DI, 188
  CALL    SOUND
  MOV DI, 188
  CALL    SOUND
  MOV DI, 188
  CALL    SOUND
  MOV DI, 188
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  MOV DI, 146
  CALL    SOUND
  MOV DI, 121
  CALL    SOUND
  MOV DI, 121
  CALL    SOUND 
  MOV DI, 121
  CALL    SOUND
  MOV DI, 121
  CALL    SOUND
  MOV DI, 121
  CALL    SOUND
  MOV DI, 121
  CALL    SOUND
  MOV DI, 121
  CALL    SOUND
  MOV DI, 121
  CALL    SOUND
  ;END OF 20TH MEASURE
  
  MOV DI, 82
  CALL    SOUND 
  MOV DI, 82
  CALL    SOUND
  MOV DI, 82
  CALL    SOUND
  MOV DI, 82
  CALL    SOUND
  MOV DI, 82
  CALL    SOUND
  MOV DI, 82
  CALL    SOUND
  MOV DI, 195
  CALL    SOUND 
  MOV DI, 195
  CALL    SOUND
  MOV DI, 188
  CALL    SOUND
  MOV DI, 188
  CALL    SOUND
  MOV DI, 188
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  MOV DI, 146
  CALL    SOUND
  MOV DI, 146
  CALL    SOUND
  MOV DI, 73
  CALL    SOUND
  ;END OF 21ST MEASURE
  
  MOV DI, 146
  CALL    SOUND
  MOV DI, 146
  CALL    SOUND
  MOV DI, 146
  CALL    SOUND
  MOV DI, 146
  CALL    SOUND
  MOV DI, 146
  CALL    SOUND
  MOV DI, 146
  CALL    SOUND
  MOV DI, 146
  CALL    SOUND
  MOV DI, 146
  CALL    SOUND
  MOV DI, 146
  CALL    SOUND
  MOV DI, 146
  CALL    SOUND
  MOV DI, 146
  CALL    SOUND
  MOV DI, 146
  CALL    SOUND
  MOV DI, 146
  CALL    SOUND
  MOV DI, 146
  CALL    SOUND
  MOV DI, 146
  CALL    SOUND
  MOV DI, 146
  CALL    SOUND
  ;END OF 22ND MEASURE  
  
  MOV DI, 65
  CALL    SOUND
  MOV DI, 65
  CALL    SOUND
  MOV DI, 65
  CALL    SOUND
  MOV DI, 65
  CALL    SOUND
  MOV DI, 65
  CALL    SOUND
  MOV DI, 65
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  MOV DI, 65
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  MOV DI, 188
  CALL    SOUND
  MOV DI, 188
  CALL    SOUND
  MOV DI, 188
  CALL    SOUND
  MOV DI, 195
  CALL    SOUND
  MOV DI, 195
  CALL    SOUND
  ;END OF 23RD MEASURE
  
  MOV DI, 188
  CALL    SOUND
  MOV DI, 188
  CALL    SOUND
  MOV DI, 188
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  MOV DI, 146
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND 
  ;END OF 24TH MEASURE
  
  MOV DI, 98
  CALL    SOUND
  MOV DI, 98
  CALL    SOUND
  MOV DI, 98
  CALL    SOUND
  MOV DI, 98
  CALL    SOUND
  MOV DI, 98
  CALL    SOUND
  MOV DI, 98
  CALL    SOUND 
  MOV DI, 195
  CALL    SOUND
  MOV DI, 98
  CALL    SOUND
  MOV DI, 195
  CALL    SOUND
  MOV DI, 195
  CALL    SOUND
  MOV DI, 195
  CALL    SOUND
  MOV DI, 195
  CALL    SOUND 
  MOV DI, 219
  CALL    SOUND
  MOV DI, 219
  CALL    SOUND
  MOV DI, 219
  CALL    SOUND
  MOV DI, 219
  CALL    SOUND
  ;END OF 25TH MEASURE
  
  MOV DI, 195
  CALL    SOUND
  MOV DI, 195
  CALL    SOUND
  MOV DI, 195
  CALL    SOUND
  MOV DI, 188
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  ;END OF 26TH MEASURE
  
  MOV DI, 98
  CALL    SOUND
  MOV DI, 98
  CALL    SOUND
  MOV DI, 98
  CALL    SOUND
  MOV DI, 98
  CALL    SOUND
  MOV DI, 98
  CALL    SOUND
  MOV DI, 98  ;creates effect of rearticulation
  CALL    SOUND
  MOV DI, 164 ;creates effect of rearticulation
  CALL    SOUND
  MOV DI, 98  ;creates effect of rearticulation, same note, drop octave, same note
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  MOV DI, 188
  CALL    SOUND
  MOV DI, 188
  CALL    SOUND
  MOV DI, 188
  CALL    SOUND
  MOV DI, 195
  CALL    SOUND
  MOV DI, 195
  CALL    SOUND
  ;END OF 27TH MEASURE
  
  MOV DI, 188
  CALL    SOUND
  MOV DI, 188
  CALL    SOUND
  MOV DI, 188
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  MOV DI, 146
  CALL    SOUND
  MOV DI, 73
  CALL    SOUND
  MOV DI, 146
  CALL    SOUND
  MOV DI, 146
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  MOV DI, 188
  CALL    SOUND
  MOV DI, 188
  CALL    SOUND 
  ;END OF 28TH MEASURE 
  
  MOV DI, 146
  CALL    SOUND
  MOV DI, 146
  CALL    SOUND 
  MOV DI, 146
  CALL    SOUND
  MOV DI, 146
  CALL    SOUND
  MOV DI, 73
  CALL    SOUND
  MOV DI, 73
  CALL    SOUND
  MOV DI, 73
  CALL    SOUND
  MOV DI, 73
  CALL    SOUND
  MOV DI, 146
  CALL    SOUND
  MOV DI, 146
  CALL    SOUND
  MOV DI, 146
  CALL    SOUND
  MOV DI, 146
  CALL    SOUND
  MOV DI, 73
  CALL    SOUND
  MOV DI, 73
  CALL    SOUND
  MOV DI, 146
  CALL    SOUND
  MOV DI, 146
  CALL    SOUND
  ;END OF 29TH MEASURE
  
  MOV DI, 41
  CALL    SOUND 
  MOV DI, 41
  CALL    SOUND 
  MOV DI, 41
  CALL    SOUND
  MOV DI, 41
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  MOV DI, 82
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  MOV DI, 195
  CALL    SOUND
  MOV DI, 195
  CALL    SOUND
  MOV DI, 195
  CALL    SOUND
  MOV DI, 195
  CALL    SOUND 
  MOV DI, 188
  CALL    SOUND
  MOV DI, 188
  CALL    SOUND
  MOV DI, 188
  CALL    SOUND
  MOV DI, 188
  CALL    SOUND 
  ;END OF 30TH MEASURE
  
  MOV DI, 188
  CALL    SOUND
  MOV DI, 188
  CALL    SOUND
  MOV DI, 188
  CALL    SOUND
  MOV DI, 188
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  MOV DI, 243
  CALL    SOUND
  MOV DI, 219
  CALL    SOUND
  MOV DI, 243
  CALL    SOUND
  MOV DI, 243
  CALL    SOUND
  MOV DI, 243
  CALL    SOUND
  MOV DI, 243
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  ;END OF 31ST MEASURE
  
  MOV DI, 65  
  CALL    SOUND
  MOV DI, 65
  CALL    SOUND   
  MOV DI, 65  
  CALL    SOUND
  MOV DI, 65
  CALL    SOUND    
  MOV DI, 65 
  CALL    SOUND 
  MOV DI, 65
  CALL    SOUND   
  MOV DI, 260
  CALL    SOUND
  MOV DI, 243
  CALL    SOUND    
  MOV DI, 260
  CALL    SOUND
  MOV DI, 260    
  CALL    SOUND 
  MOV DI, 243  
  CALL    SOUND
  MOV DI, 243   
  CALL    SOUND 
  MOV DI, 219  
  CALL    SOUND
  MOV DI, 219  
  CALL    SOUND    
  MOV DI, 219   
  CALL    SOUND
  MOV DI, 219
  CALL    SOUND 
  ;END OF 32ND MEASURE
  
  MOV DI, 65  
  CALL    SOUND
  MOV DI, 65
  CALL    SOUND   
  MOV DI, 65   
  CALL    SOUND
  MOV DI, 65
  CALL    SOUND    
  MOV DI, 65  
  CALL    SOUND 
  MOV DI, 65
  CALL    SOUND   
  MOV DI, 260
  CALL    SOUND
  MOV DI, 243
  CALL    SOUND    
  MOV DI, 260
  CALL    SOUND
  MOV DI, 260     
  CALL    SOUND 
  MOV DI, 260   
  CALL    SOUND
  MOV DI, 260   
  CALL    SOUND 
  MOV DI, 164   
  CALL    SOUND
  MOV DI, 164  
  CALL    SOUND    
  MOV DI, 164   
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND 
  ;END OF 33RD MEASURE
  
  MOV DI, 146
  CALL    SOUND
  MOV DI, 146
  CALL    SOUND    
  MOV DI, 146   
  CALL    SOUND
  MOV DI, 146
  CALL    SOUND
  MOV DI, 146
  CALL    SOUND
  MOV DI, 146
  CALL    SOUND   
  MOV DI, 219   
  CALL    SOUND 
  MOV DI, 195
  CALL    SOUND   
  MOV DI, 219
  CALL    SOUND
  MOV DI, 219  
  CALL    SOUND   
  MOV DI, 195   
  CALL    SOUND 
  MOV DI, 195 
  CALL    SOUND   
  MOV DI, 189
  CALL    SOUND
  MOV DI, 189  
  CALL    SOUND    
  MOV DI, 219   
  CALL    SOUND 
  MOV DI, 219
  CALL    SOUND 
  ;END OF 34TH MEASURE
  
    
  MOV DI, 195
  CALL    SOUND
  MOV DI, 195  
  CALL    SOUND 
  MOV DI, 195  
  CALL    SOUND 
  MOV DI, 195
  CALL    SOUND   
  MOV DI, 195
  CALL    SOUND
  MOV DI, 195  
  CALL    SOUND       
  MOV DI, 243   
  CALL    SOUND
  MOV DI, 219   
  CALL    SOUND
  MOV DI, 243  
  CALL    SOUND
  MOV DI, 243     
  CALL    SOUND
  MOV DI, 243   
  CALL    SOUND
  MOV DI, 243    
  CALL    SOUND
  MOV DI, 164  
  CALL    SOUND
  MOV DI, 164     
  CALL    SOUND
  MOV DI, 164   
  CALL    SOUND
  MOV DI, 164   
  CALL    SOUND
  ;END OF 35TH MEASURE     
    
  MOV DI, 82   
  CALL    SOUND
  MOV DI, 82   
  CALL    SOUND
  MOV DI, 82   
  CALL    SOUND
  MOV DI, 82   
  CALL    SOUND  
  MOV DI, 82   
  CALL    SOUND 
  MOV DI, 82   
  CALL    SOUND 
  MOV DI, 260
  CALL    SOUND
  MOV DI, 243  
  CALL    SOUND 
  MOV DI, 260   
  CALL    SOUND  
  MOV DI, 260
  CALL    SOUND
  MOV DI, 243
  CALL    SOUND 
  MOV DI, 243
  CALL    SOUND
  MOV DI, 219   
  CALL    SOUND
  MOV DI, 219    
  CALL    SOUND 
  MOV DI, 219   
  CALL    SOUND
  MOV DI, 219
  CALL    SOUND  
  ;END OF 36TH MEASURE
  
  MOV DI, 65   
  CALL    SOUND
  MOV DI, 65
  CALL    SOUND   
  MOV DI, 65  
  CALL    SOUND
  MOV DI, 65
  CALL    SOUND    
  MOV DI, 65  
  CALL    SOUND 
  MOV DI, 65
  CALL    SOUND   
  MOV DI, 260
  CALL    SOUND
  MOV DI, 243
  CALL    SOUND    
  MOV DI, 260
  CALL    SOUND
  MOV DI, 260      
  CALL    SOUND 
  MOV DI, 260 
  CALL    SOUND
  MOV DI, 260   
  CALL    SOUND 
  MOV DI, 164  
  CALL    SOUND
  MOV DI, 164  
  CALL    SOUND    
  MOV DI, 164   
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND    
  ;END OF 37TH MEASURE
    
  MOV DI, 146
  CALL    SOUND
  MOV DI, 146
  CALL    SOUND    
  MOV DI, 146   
  CALL    SOUND
  MOV DI, 146
  CALL    SOUND
  MOV DI, 146
  CALL    SOUND
  MOV DI, 146
  CALL    SOUND   
  MOV DI, 219   
  CALL    SOUND 
  MOV DI, 195
  CALL    SOUND   
  MOV DI, 219
  CALL    SOUND
  MOV DI, 219  
  CALL    SOUND   
  MOV DI, 195   
  CALL    SOUND 
  MOV DI, 195 
  CALL    SOUND   
  MOV DI, 189
  CALL    SOUND
  MOV DI, 189  
  CALL    SOUND    
  MOV DI, 219   
  CALL    SOUND 
  MOV DI, 219
  CALL    SOUND 
  ;END OF 38TH MEASURE  
  
  MOV DI, 195
  CALL    SOUND  
  MOV DI, 195
  CALL    SOUND
  MOV DI, 195
  CALL    SOUND
  MOV DI, 195
  CALL    SOUND
  MOV DI, 195
  CALL    SOUND
  MOV DI, 195
  CALL    SOUND
  MOV DI, 189 
  CALL    SOUND
  MOV DI, 195   
  CALL    SOUND
  MOV DI, 219    
  CALL    SOUND
  MOV DI, 219   
  CALL    SOUND
  MOV DI, 219   
  
  CALL    SOUND  
  MOV DI, 219  
  CALL    SOUND 
  MOV DI, 219   
  CALL    SOUND  
  MOV DI, 219   
  CALL    SOUND 
  MOV DI, 195
  CALL    SOUND
  MOV DI, 219
  CALL    SOUND
  ;END OF 39TH MEASURE
  
  MOV DI, 243
  CALL    SOUND
  MOV DI, 243
  CALL    SOUND
  MOV DI, 219
  CALL    SOUND
  MOV DI, 219
  CALL    SOUND
  MOV DI, 195
  CALL    SOUND
  MOV DI, 195
  CALL    SOUND
  MOV DI, 182
  CALL    SOUND
  MOV DI, 182
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND 
  MOV DI, 164
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  MOV DI, 260
  CALL    SOUND 
  MOV DI, 260
  CALL    SOUND
  MOV DI, 260
  CALL    SOUND
  MOV DI, 260
  CALL    SOUND
  ;END OF 40TH MEASURE  
  
  MOV DI, 243
  CALL    SOUND 
  MOV DI, 243
  CALL    SOUND
  MOV DI, 243
  CALL    SOUND
  MOV DI, 243
  CALL    SOUND
  MOV DI, 121
  CALL    SOUND
  MOV DI, 121
  CALL    SOUND
  MOV DI, 121
  CALL    SOUND
  MOV DI, 121
  CALL    SOUND 
  MOV DI, 243
  CALL    SOUND
  MOV DI, 243
  CALL    SOUND
  MOV DI, 243
  CALL    SOUND
  MOV DI, 260
  CALL    SOUND 
  MOV DI, 260
  CALL    SOUND  
  MOV DI, 260
  CALL    SOUND 
  MOV DI, 243
  CALL    SOUND
  MOV DI, 219
  CALL    SOUND 
  ;END OF 41ST MEASURE
  
  MOV DI, 243
  CALL    SOUND
  MOV DI, 243
  CALL    SOUND
  MOV DI, 243
  CALL    SOUND
  MOV DI, 243
  CALL    SOUND
  MOV DI, 243
  CALL    SOUND
  MOV DI, 243
  CALL    SOUND
  MOV DI, 243
  CALL    SOUND
  MOV DI, 243
  CALL    SOUND
  MOV DI, 121
  CALL    SOUND    
  MOV DI, 121
  CALL    SOUND
  MOV DI, 121
  CALL    SOUND
  MOV DI, 121
  CALL    SOUND
  MOV DI, 243
  CALL    SOUND
  MOV DI, 243
  CALL    SOUND
  MOV DI, 243
  CALL    SOUND
  MOV DI, 243
  CALL    SOUND
  ;END OF 42ND MEASURE
  
  MOV DI, 328
  CALL    SOUND
  MOV DI, 328
  CALL    SOUND
  MOV DI, 328
  CALL    SOUND
  MOV DI, 328
  CALL    SOUND
  MOV DI, 82
  CALL    SOUND
  MOV DI, 82
  CALL    SOUND
  MOV DI, 82
  CALL    SOUND
  MOV DI, 82
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  MOV DI, 328
  CALL    SOUND
  MOV DI, 328
  CALL    SOUND
  MOV DI, 328
  CALL    SOUND
  MOV DI, 292
  CALL    SOUND
  MOV DI, 292
  CALL    SOUND
  MOV DI, 328
  CALL    SOUND
  MOV DI, 328
  CALL    SOUND
  MOV DI, 328
  CALL    SOUND
  MOV DI, 328
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  MOV DI, 82
  CALL    SOUND
  MOV DI, 82
  CALL    SOUND
  MOV DI, 82
  CALL    SOUND
  MOV DI, 41
  CALL    SOUND
  MOV DI, 41
  CALL    SOUND
  MOV DI, 41
  CALL    SOUND 
  MOV DI, 41
  CALL    SOUND
  MOV DI, 41
  CALL SOUND
  ;END OF 43RD MEASURE  (PLAY AT 3993 CYCLES = 1:30)    
  
  JMP KEYBOARDPIANO

MAIN    ENDP
END MAIN     

; bblow = 65
; c = 146 fundamental     73 bass
; d = 164 major second 9/8 ratio  
; eb= 175 minor third 6/5 ratio 
; e = 182 major third 5/4 ratio 
; enat = 188 e natural
; f = 195 perfect fourth 4/3 ratio
; g = 219 perfect fifth 3/2 ratio
; a = 243 major sixth 5/3 ratio 
; bb= 260 minor seventh 16/9 ratio
; b = 274 major seventh 15/8 ratio
; c2nd octave = 292 - 2/1 ratio


;REFERENCES:
;http://www.fysnet.net/snd.htm
;https://www.youtube.com/watch?v=NdztXxqMqV8  
;http://swag.outpostbbs.net/SOUND/0038.PAS.html 
;https://www.csee.umbc.edu/courses/undergraduate/CMSC211/Summer00/Burt/lectures/CntlHardware/timer.html
;https://stackoverflow.com/questions/34500138/play-music-with-assembly-code/34546765  
;http://spot.pcc.edu/~wlara/asmx86/asmx86_manual_9.pdf
;https://codereview.stackexchange.com/questions/87322/a-virtual-piano   
;http://spot.pcc.edu/~wlara/asmx86/asmx86_lab_10.pdf
;https://en.wikipedia.org/wiki/IBM_Personal_Computer (peripheral integrated circuits, programmable interval timer) 
;https://musescore.com/user/928016/scores/649531    <--Music Source

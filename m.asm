.MODEL SMALL

.STACK 100H

;IO Speaker - Programmable interval timer (PIT) Ports
PIT_TIMER_COUNT equ 42h ;Use PIT_TIMER_COUNT for port name instead of 42h.
PIT_TIMER_CONRTOL equ 43h ;Use PIT_TIMER_CONTROL for port name instead of 43h.
SYSTEM_CONTROL_PORT_B equ 61h ;Use SYSTEM_CONTROL_PORT_B for port name instead of 61h

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
  CMP AL, 'm' ; m for music -> jumps to shrek song.
  JE  SHREK ; m->Shrek
  JNZ KEYBOARDPIANO
Bb: MOV DI, 131
  CALL    SOUND
  JMP KEYBOARDPIANO
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
   
SHREK:  

  MOV DI, 146   ;c quarter     
  CALL    SOUND
  MOV DI, 146   
  CALL    SOUND
  MOV DI, 146  
  CALL    SOUND
  MOV DI, 146   
  
  CALL    SOUND
  MOV DI, 219   ;g 8th
  CALL    SOUND
  MOV DI, 219  
  
  CALL    SOUND
  MOV DI, 182   ;e 8th
  CALL    SOUND
  MOV DI, 91   
  
  CALL    SOUND
  MOV DI, 182   ;e quarter
  CALL    SOUND
  MOV DI, 182   
  CALL    SOUND
  MOV DI, 182   
  CALL    SOUND
  MOV DI, 182   
  
  CALL    SOUND
  MOV DI, 164   ;d 8th
  CALL    SOUND
  MOV DI, 164   
  
  
  CALL    SOUND  
  MOV DI, 146   ;c 8th
  CALL    SOUND 
  MOV DI, 73   
  
  CALL    SOUND ;c 8th
  MOV DI, 146
  CALL    SOUND
  MOV DI, 146  
  
  CALL    SOUND 
  MOV DI, 195   ;f quarter
  CALL    SOUND  
  MOV DI, 195
  CALL    SOUND
  MOV DI, 195
  CALL    SOUND 
  MOV DI, 195
  CALL    SOUND
  
  MOV DI, 182   ;e 8th
  CALL    SOUND
  MOV DI, 91    
  
  CALL    SOUND ;e 8th
  MOV DI, 182   
  CALL    SOUND
  MOV DI, 182
  CALL    SOUND  
  
  MOV DI, 164   ;d 8th
  CALL    SOUND
  MOV DI, 82
  CALL    SOUND  
  
  MOV DI, 164   ;d 8th
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND    
  
  MOV DI, 146  ;c 8th
  CALL    SOUND 
  MOV DI, 145
  CALL    SOUND   
  MOV DI, 146
  CALL    SOUND
  MOV DI, 73
  CALL    SOUND    
  
  MOV DI, 146
  CALL    SOUND
  MOV DI, 146  ;c 8th  
  
  CALL    SOUND 
  MOV DI, 219   ;g 8th
  CALL    SOUND
  MOV DI, 219   
  CALL    SOUND 
  MOV DI, 219   ;g 8th
  CALL    SOUND
  MOV DI, 219 
    
  
  MOV DI, 182   ;e quarter
  CALL    SOUND
  MOV DI, 91
  CALL    SOUND
  MOV DI, 182
  CALL    SOUND
  MOV DI, 182
  CALL    SOUND  
  
  MOV DI, 164   ;d quarter
  CALL    SOUND
  MOV DI, 82
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND
  MOV DI, 164
  CALL    SOUND 
  
  MOV DI, 146   ;c quarter
  CALL    SOUND 
  MOV DI, 73
  CALL    SOUND   
  MOV DI, 146
  CALL    SOUND
  MOV DI, 146  
  CALL    SOUND 
  
  MOV DI, 122   ;a quarter
  CALL    SOUND 
  MOV DI, 122
  CALL    SOUND   
  MOV DI, 122
  CALL    SOUND
  MOV DI, 122  
  CALL    SOUND  
  
  MOV DI, 110   ;g quarter
  CALL    SOUND 
  MOV DI, 111
  CALL    SOUND   
  MOV DI, 112
  CALL    SOUND
  MOV DI, 113  
  CALL    SOUND 
  MOV DI, 114   ;g quarter
  CALL    SOUND 
  MOV DI, 115
  CALL    SOUND   
  MOV DI, 116
  CALL    SOUND
  MOV DI, 117  
  CALL    SOUND     
  
  MOV DI, 146   ;c quarter NEW MEASURE
  CALL    SOUND
  MOV DI, 73   
  CALL    SOUND
  MOV DI, 146  
  CALL    SOUND
  MOV DI, 146   
  
  CALL    SOUND
  MOV DI, 219   ;g 8th
  CALL    SOUND
  MOV DI, 219  
  
  CALL    SOUND
  MOV DI, 182   ;e 8th
  CALL    SOUND
  MOV DI, 91   
  
  CALL    SOUND
  MOV DI, 182   ;e 8th
  CALL    SOUND
  MOV DI, 182     
  
  CALL    SOUND
  MOV DI, 164   ;d 8th
  CALL    SOUND
  MOV DI, 82    
  
  CALL    SOUND
  MOV DI, 164   ;d 8th
  CALL    SOUND
  MOV DI, 164 
  
  
  CALL    SOUND  
  MOV DI, 146   ;c 8th
  CALL    SOUND 
  MOV DI, 73   
  
  CALL    SOUND ;c 8th
  MOV DI, 146
  CALL    SOUND
  MOV DI, 146  
  
  CALL    SOUND 
  MOV DI, 195   ;f quarter
  CALL    SOUND  
  MOV DI, 193
  CALL    SOUND
  MOV DI, 191
  CALL    SOUND 
  MOV DI, 189
  CALL    SOUND 
  
  CALL    SOUND
  MOV DI, 182   ;e 8th
  CALL    SOUND
  MOV DI, 91   
  
  CALL    SOUND
  MOV DI, 182   ;e 8th
  CALL    SOUND
  MOV DI, 182 
  
  CALL    SOUND
  MOV DI, 164   ;d 8th
  CALL    SOUND
  MOV DI, 82    
  
  CALL    SOUND
  MOV DI, 146   ;d 8th
  CALL    SOUND
  MOV DI, 146   
  
  CALL    SOUND
  MOV DI, 219   ;g 8th
  CALL    SOUND
  MOV DI, 219  
  
  CALL    SOUND
  MOV DI, 109   ;g 8th
  CALL    SOUND
  MOV DI, 109   
  
  CALL    SOUND
  MOV DI, 182   ;e 8th
  CALL    SOUND
  MOV DI, 91      
  CALL    SOUND
  MOV DI, 182   ;e 8th
  CALL    SOUND
  MOV DI, 182 
                   
  CALL    SOUND
  MOV DI, 164   ;d 8th
  CALL    SOUND
  MOV DI, 164   
  
  CALL    SOUND
  MOV DI, 82   ;d 8th
  CALL    SOUND
  MOV DI, 164    
  CALL    SOUND
  MOV DI, 82   ;d 8th
  CALL    SOUND
  MOV DI, 82   
  
  CALL    SOUND  
  MOV DI, 146   ;c 8th
  CALL    SOUND 
  MOV DI, 73   
  CALL    SOUND  
  MOV DI, 146   ;c 8th
  CALL    SOUND 
  MOV DI, 146     
  
  CALL    SOUND
  MOV DI, 164   ;d 8th
  CALL    SOUND
  MOV DI, 163    
  CALL    SOUND
  MOV DI, 165   ;d 8th
  CALL    SOUND
  MOV DI, 162    
  
  CALL    SOUND
  MOV DI, 121   ;a 8th
  CALL    SOUND
  MOV DI, 125    
  CALL    SOUND
  MOV DI, 129   ;a 8th
  CALL    SOUND
  MOV DI, 133    
  CALL    SOUND
  MOV DI, 137   ;a 8th
  CALL    SOUND
  MOV DI, 141    
  CALL    SOUND
  MOV DI, 145   ;a 8th
  CALL    SOUND

  JMP KEYBOARDPIANO

MAIN    ENDP
END MAIN     

; c = 146 fundamental
; d = 164 major second 9/8 ratio
; e = 182 major third 5/4 ratio
; f = 195 perfect fourth 4/3 ratio
; g = 219 perfect fifth 3/2 ratio
; a = 243 major sixth 5/3 ratio 
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


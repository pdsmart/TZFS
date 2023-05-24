;--------------------------------------------------------------------------------------------------------
;-
;- Name:            tzfs_bank3.asm
;- Created:         July 2019
;- Author(s):       Philip Smart
;- Description:     Sharp MZ series tzfs (tranZPUter Filing System).
;-                  Bank 3 - F000:FFFF - 
;-
;-                  This assembly language program is a branch from the original RFS written for the
;-                  MZ80A_RFS upgrade board. It is adapted to work within the similar yet different 
;-                  environment of the tranZPUter SW which has a large RAM capacity (512K) and an
;-                  I/O processor in the K64F/ZPU.
;-
;- Credits:         
;- Copyright:       (c) 2018-2023 Philip Smart <philip.smart@net2net.org>
;-
;- History:         May 2020  - Branch taken from RFS v2.0 and adapted for the tranZPUter SW.
;-                  Jul 2021  - Updated to add configurable tape read/write for MZ80K,80B and 800 series
;-                              machines.
;-                  Feb 2023  - TZFS now running on FusionX. Small changes to ensure compatibility.
;-
;--------------------------------------------------------------------------------------------------------
;- This source file is free software: you can redistribute it and-or modify
;- it under the terms of the GNU General Public License as published
;- by the Free Software Foundation, either version 3 of the License, or
;- (at your option) any later version.
;-
;- This source file is distributed in the hope that it will be useful,
;- but WITHOUT ANY WARRANTY; without even the implied warranty of
;- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;- GNU General Public License for more details.
;-
;- You should have received a copy of the GNU General Public License
;- along with this program.  If not, see <http://www.gnu.org/licenses/>.
;--------------------------------------------------------------------------------------------------------


            ;============================================================
            ;
            ; TZFS BANK 3 - Utilities and additional commands.
            ;
            ;============================================================

            ORG     BANKRAMADDR

            ;-------------------------------------------------------------------------------
            ; START OF UTILITY METHODS
            ;-------------------------------------------------------------------------------

            ; Method to skip white space whilst locating a comma. Once found, advance to the next first non-white space character.
            ; Outputs:
            ;     Z  = No comma - either comma found but no following characters or no comma found.
            ;     NZ = comma found, DE points to next non-white character.
SKIPCOMMA:  LD      A,(DE)                                               ; Scan the parameter buffer for a comma.
            INC     DE
            CP      ' '
            JR      Z,SKIPCOMMA     
            CP      000H
            RET     Z                                                    ; End of string, no comma found.
            CP      ','
            JR      NZ,SKIPCOMMA
SKIPCOM2:   LD      A,(DE)                                               ; Comma found now advance to first non-white char.
            CP      000H                                                 ; End of string?
            RET     Z
            CP      ' '                                                  ; Non comma found, return success.
            RET     NZ
            INC     DE                                                   ; Whitespace so advance to next char.
            JR      SKIPCOM2

            ; Method to validate a model code, the single character should be one of:
            ; 0, K = MZ-80K
            ; 1, C = MZ-80C
            ; 2, 1 = MZ-1200
            ; 3, A = MZ-80A
            ; 4, 7 = MZ-700
            ; 5, 8 = MZ-800
            ; 6, B = MZ-80B
            ; 7, 2 = MZ-2000
            ; 8, O = Original memory load, original machine configuration, ie. MZ-800 as an MZ-800..
            ; 9, o = Original memory load, alternative mode, ie. MZ-700 on MZ-800 host..
            ; Outputs:
            ;    C = Binary model number 0..7
            ;    Z = Model code valid.
            ;   NZ = Invalid code.
CHECKMODEL: LD      C,MODE_MZ80K
            CP      'K'                                                   ; MZ-80K
            RET     Z                                                     ; 0
            INC     C
            CP      'C'                                                   ; MZ-80C
            RET     Z                                                     ; 1
            INC     C
            CP      '1'                                                   ; MZ-1200
            RET     Z                                                     ; 2
            INC     C
            CP      'A'                                                   ; MZ-80A
            RET     Z                                                     ; 3
            INC     C
            CP      '7'                                                   ; MZ-700
            RET     Z                                                     ; 4
            INC     C
            CP      '8'                                                   ; MZ-800
            RET     Z                                                     ; 5
            INC     C
            CP      'B'                                                   ; MZ-80B
            RET     Z                                                     ; 6
            INC     C
            CP      '2'                                                   ; MZ-2000
            RET     Z                                                     ; 7
            INC     C
            CP      'O'                                                   ; Original host, ie. MZ-800 as an MZ-800
            RET     Z                                                     ; 8
            INC     C
            CP      'S'                                                   ; Original host, alternative mode, ie. MZ-700 mode on MZ-800 host.
            RET                                                           ; 9?

            ; Get optional machine model code. Format is: CMD<param>[,][machine model code]
            ; Outputs:
            ;     A = Model number.
GETMODEL:   CALL    SKIPCOMMA
            JR      Z,READMODEL                                          ; No comma found so no parameter, read default model from CPLD.
            LD      A,(DE)                                               ; Get code
            CALL    CHECKMODEL
            LD      A,C
            JR      NZ,READMODEL
            RET
READMODEL:  IN      A,(CPLDINFO)                                         ; Get the model number from the underlying hardware.
            AND     007H                                                 ; Mask in the relevant bits, A = Model number.
            RET

            ;
            ; Pallet Reg. & Border Reg. set
            ;      PLT0~3  Black
            ;      Border  Black
            ;
            ; output: BC = 6CFH, A = 0
            ;
PLTST:      PUSH    HL                                           
            LD      BC,05F0H                                             ; C=port (Pallet Write), B=count
            LD      HL,PLTDT                                             ; Data
            OTIR                                                                          
            XOR     A                                                                     
            LD      BC,06CFH                                             ; Border Black
            OUT     (C),A                                                ; Send to port.
            POP     HL                                           
            RET  

            ; Initialization table for Palette
            ;
PLTDT:      DB      0,10H,20H,30H,40H    

            ;-------------------------------------------------------------------------------
            ; END OF UTILITY METHODS
            ;-------------------------------------------------------------------------------

            ;-------------------------------------------------------------------------------
            ; START OF ADDITIONAL TZFS COMMAND METHODS
            ;-------------------------------------------------------------------------------

            ;
            ;       Memory correction
            ;       command 'M'
            ;
MCORX:      CALL    READ4HEX                                             ; correction address
            RET     C
MCORX1:     CALL    NLPHL                                                ; corr. adr. print
            CALL    SPHEX                                                ; ACC ASCII display
            CALL    PRNTS                                                ; space print
            LD      DE,BUFER                                             ; Input the data.
            CALL    GETL
            LD      A,(DE)
            CP      01Bh                                                 ; If . pressed, exit.
            RET     Z
            PUSH    HL
            POP     BC
            CALL    HLHEX                                                ; If the existing address is no longer hex, reset. HLASCII(DE). If it is hex, take as the address to store data into.
            JR      C,MCRX3                                              ; Line is corrupted as the address is no longer in Hex, reset.
            INC     DE
            INC     DE
            INC     DE
            INC     DE
            INC     DE                                                   ;
            CALL    _2HEX                                                ; Get value entered.
            JR      C,MCORX1                                             ; Not hex, reset.
            CP      (HL)                                                 ; Not same as memory, reset.
            JR      NZ,MCORX1
            INC     DE                                                   ; 
            LD      A,(DE)                                               ; Check if no data just CR, if so, move onto next address.
            CP      00Dh                                                 ; not correction
            JR      Z,MCRX2
            CALL    _2HEX                                                ; Get the new entered data. ACCHL(ASCII)
            JR      C,MCORX1                                             ; New data not hex, reset.
            LD      (HL),A                                               ; data correct so store.
MCRX2:      INC     HL
            JR      MCORX1
MCRX3:      LD      H,B                                                  ; memory address
            LD      L,C
            JR      MCORX1

            ; Dump method when called interbank as HL cannot be passed.
            ;
            ; BC = Start
            ; DE = End
DUMPBC:     PUSH    BC
            POP     HL
            JR      DUMP

            ; Command line utility to dump memory.
            ; Get start and optional end addresses from the command line, ie. XXXX[XXXX]
            ; Paging is implemented, 23 lines at a time, pressing U goes back 100H, pressing D scrolls down 100H
            ;
DUMPX:      CALL    HLHEX                                                ; Get start address if present into HL
            JR      NC,DUMPX1
            LD      DE,(DUMPADDR)                                        ; Setup default start and end.
            JR      DUMPX2
DUMPX1:     INC     DE
            INC     DE
            INC     DE
            INC     DE
            PUSH    HL
            CALL    HLHEX                                                ; Get end address if present into HL
            POP     DE                                                   ; DE = Start address
            JR      NC,DUMPX4                                            ; Both present? Then display.
DUMPX2:     LD      A,(SCRNMODE)
            BIT     0,A
            LD      HL,000A0h                                            ; Make up an end address based on 160 bytes from start for 40 column mode.
            JR      Z,DUMPX3
            LD      HL,00140h                                            ; Make up an end address based on 320 bytes from start for 80 column mode.
DUMPX3:     ADD     HL,DE
DUMPX4:     EX      DE,HL
            ;
            ; HL = Start
            ; DE = End
DUMP:       LD      A,23
DUMP0:      LD      (TMPCNT),A
            LD      A,(SCRNMODE)                                         ; Configure output according to screen mode, 40/80 chars.
            BIT     0,A
            JR      NZ,DUMP1
            LD      B,008H                                               ; 40 Char, output 23 lines of 40 char.
            LD      C,017H
            JR      DUMP2
DUMP1:      LD      B,010h                                               ; 80 Char, output 23 lines of 80 char.
            LD      C,02Fh
DUMP2:      CALL    NLPHL
DUMP3:      CALL    SPHEX
            INC     HL
            PUSH    AF
            LD      A,(DSPXY)
            ADD     A,C
            LD      (DSPXY),A
            POP     AF
            CP      020h
            JR      NC,DUMP4
            LD      A,02Eh
DUMP4:      CALL    ?ADCN
            CALL    PRNT3
            LD      A,(DSPXY)
            INC     C
            SUB     C
            LD      (DSPXY),A
            DEC     C
            DEC     C
            DEC     C
            PUSH    HL
            SBC     HL,DE
            POP     HL
            JR      NC,DUMP9
DUMP5:      DJNZ    DUMP3
            LD      A,(TMPCNT)
            DEC     A
            JR      NZ,DUMP0
DUMP6:      CALL    GETKY                                                ; Pause, X to quit, D to go down a block, U to go up a block.
            OR      A
            JR      Z,DUMP6
            CP      'D'
            JR      NZ,DUMP7
            LD      A,8
            JR      DUMP0
DUMP7:      CP      'U'
            JR      NZ,DUMP8
            PUSH    DE
            LD      DE,00100H
            OR      A
            SBC     HL,DE
            POP     DE
            LD      A,8
            JR      DUMP0
DUMP8:      CP      'X'
            JR      Z,DUMP9
            JR      DUMP
DUMP9:      LD      (DUMPADDR),HL                                        ; Store last address so we can just press D for next page,
            CALL    NL
            RET

            ;-------------------------------------------------------------------------------
            ; END OF ADDITIONAL TZFS COMMAND METHODS
            ;-------------------------------------------------------------------------------

            ;-------------------------------------------------------------------------------
            ; START OF TIMER TEST FUNCTIONALITY
            ;-------------------------------------------------------------------------------

            ; Test the 8253 Timer, configure it as per the monitor and display the read back values.
TIMERTST:   CALL    NL
            LD      DE,MSG_TIMERTST
            CALL    MSG
            CALL    NL
            LD      DE,MSG_TIMERVAL
            CALL    MSG
            LD      A,01h
            LD      DE,8000h
            CALL    TIMERTST1
NDE:        JP      NDE
            JP      ST1X
TIMERTST1:  DI      
            PUSH    BC
            PUSH    DE
            PUSH    HL
            LD      (AMPM),A
            LD      A,0F0H
            LD      (TIMFG),A
ABCD:       LD      HL,0A8C0H
            XOR     A
            SBC     HL,DE
            PUSH    HL
            INC     HL
            EX      DE,HL

            LD      HL,CONTF    ; Control Register
            LD      (HL),0B0H   ; 10110000 Control Counter 2 10, Write 2 bytes 11, 000 Interrupt on Terminal Count, 0 16 bit binary
            LD      (HL),074H   ; 01110100 Control Counter 1 01, Write 2 bytes 11, 010 Rate Generator, 0 16 bit binary
            LD      (HL),030H   ; 00110100 Control Counter 1 01, Write 2 bytes 11, 010 interrupt on Terminal Count, 0 16 bit binary

            LD      HL,CONT2    ; Counter 2
            LD      (HL),E
            LD      (HL),D

            LD      HL,CONT1    ; Counter 1
            LD      (HL),00AH
            LD      (HL),000H

            LD      HL,CONT0    ; Counter 0
            LD      (HL),00CH
            LD      (HL),0C0H

;            LD      HL,CONT2    ; Counter 2
;            LD      C,(HL)
;            LD      A,(HL)
;            CP      D
;            JP      NZ,L0323H                
;            LD      A,C
;            CP      E
;            JP      Z,CDEF                
            ;

L0323H:     PUSH    AF
            PUSH    BC
            PUSH    DE
            PUSH    HL
            ;
            LD      HL,CONTF    ; Control Register
            LD      (HL),080H
            LD      HL,CONT2    ; Counter 2
            LD      C,(HL)
            LD      A,(HL)
            CALL    PRTHX
            LD      A,C
            CALL    PRTHX
            ;
            CALL    PRNTS
            ;
            LD      HL,CONTF    ; Control Register
            LD      (HL),040H
            LD      HL,CONT1    ; Counter 1
            LD      C,(HL)
            LD      A,(HL)
            CALL    PRTHX
            LD      A,C
            CALL    PRTHX
            ;
            CALL    PRNTS
            ;
            LD      HL,CONTF    ; Control Register
            LD      (HL),000H
            LD      HL,CONT0    ; Counter 0
            LD      C,(HL)
            LD      A,(HL)
            CALL    PRTHX
            LD      A,C
            CALL    PRTHX
            ;
            LD      A,0C4h      ; Move cursor left.
            LD      E,0Eh      ; 4 times.
L0330:      CALL    DPCT
            DEC     E
            JR      NZ,L0330
            ;
;            LD      C,20
;L0324:      CALL    DLY12
;            DEC     C
;            JR      NZ,L0324
            ;
            POP     HL
            POP     DE
            POP     BC
            POP     AF
            ;
            LD      HL,CONT2    ; Counter 2
            LD      C,(HL)
            LD      A,(HL)
            CP      D
            JP      NZ,L0323H                
            LD      A,C
            CP      E
            JP      NZ,L0323H                
            ;
            ;
            PUSH    AF
            PUSH    BC
            PUSH    DE
            PUSH    HL
            CALL    NL
            CALL    NL
            CALL    NL
            LD      DE,MSG_TIMERVAL2
            CALL    MSG
            POP     HL
            POP     DE
            POP     BC
            POP     AF

            ;
CDEF:       POP     DE
            LD      HL,CONT1
            LD      (HL),00CH
            LD      (HL),07BH
            INC     HL

L0336H:     PUSH    AF
            PUSH    BC
            PUSH    DE
            PUSH    HL
            ;
            LD      HL,CONTF    ; Control Register
            LD      (HL),080H
            LD      HL,CONT2    ; Counter 2
            LD      C,(HL)
            LD      A,(HL)
            CALL    PRTHX
            LD      A,C
            CALL    PRTHX
            ;
            CALL    PRNTS
            CALL    DLY1SEC
            ;
            LD      HL,CONTF    ; Control Register
            LD      (HL),040H
            LD      HL,CONT1    ; Counter 1
            LD      C,(HL)
            LD      A,(HL)
            CALL    PRTHX
            LD      A,C
            CALL    PRTHX
            ;
            CALL    PRNTS
            CALL    DLY1SEC
            ;
            LD      HL,CONTF    ; Control Register
            LD      (HL),000H
            LD      HL,CONT0    ; Counter 0
            LD      C,(HL)
            LD      A,(HL)
            CALL    PRTHX
            LD      A,C
            CALL    PRTHX
            ;
            CALL    DLY1SEC
            ;
            LD      A,0C4h      ; Move cursor left.
            LD      E,0Eh      ; 4 times.
L0340:      CALL    DPCT
            DEC     E
            JR      NZ,L0340
            ;
            POP     HL
            POP     DE
            POP     BC
            POP     AF

            LD      HL,CONT2    ; Counter 2
            LD      C,(HL)
            LD      A,(HL)
            CP      D
            JR      NZ,L0336H                
            LD      A,C
            CP      E
            JR      NZ,L0336H                
            CALL    NL
            LD      DE,MSG_TIMERVAL3
            CALL    MSG
            POP     HL
            POP     DE
            POP     BC
            EI      
            RET   
            ;-------------------------------------------------------------------------------
            ; END OF TIMER TEST FUNCTIONALITY
            ;-------------------------------------------------------------------------------

            ;-------------------------------------------------------------------------------
            ; START OF PRINTER CMDLINE TOOLS FUNCTIONALITY
            ;-------------------------------------------------------------------------------
PTESTX:     LD      A,(DE)
            CP      '&'                                                  ; plotter test
            JR      NZ,PTST1X
PTST0X:     INC     DE
            LD      A,(DE)
            CP      'L'                                                  ; 40 in 1 line
            JR      Z,.LPTX
            CP      'S'                                                  ; 80 in 1 line
            JR      Z,..LPTX
            CP      'C'                                                  ; Pen change
            JR      Z,PENX
            CP      'G'                                                  ; Graph mode
            JR      Z,PLOTX
            CP      'T'                                                  ; Test
            JR      Z,PTRNX
;
PTST1X:     CALL    PMSGX
ST1X2:      RET
.LPTX:      LD      DE,LLPT                                              ; 01-09-09-0B-0D
            JR      PTST1X
..LPTX:     LD      DE,SLPT                                              ; 01-09-09-09-0D
            JR      PTST1X
PTRNX:      LD      A,004h                                               ; Test pattern
            JR      LE999
PLOTX:      LD      A,002h                                               ; Graph mode
LE999:      CALL    LPRNTX
            JR      PTST0X
PENX:       LD      A,01Dh                                               ; 1 change code (text mode)
            JR      LE999
;
;
;       1 char print to $LPT
;
;        in: ACC print data
;
;
LPRNTX:     LD      C,000h                                               ; RDAX test
            LD      B,A                                                  ; print data store
            CALL    RDAX
            LD      A,B
            OUT     (0FFh),A                                             ; data out
            LD      A,080h                                               ; RDP high
            OUT     (0FEh),A
            LD      C,001h                                               ; RDA test
            CALL    RDAX
            XOR     A                                                    ; RDP low
            OUT     (0FEh),A
            RET
;
;       $LPT msg.
;       in: DE data low address
;       0D msg. end
;
PMSGX:      PUSH    DE
            PUSH    BC
            PUSH    AF
PMSGX1:     LD      A,(DE)                                               ; ACC = data
            CALL    LPRNTX
            LD      A,(DE)
            INC     DE
            CP      00Dh                                                 ; end ?
            JR      NZ,PMSGX1
            POP     AF
            POP     BC
            POP     DE
            RET

;
;       RDA check
;
;       BRKEY in to monitor return
;       in: C RDA code
;
RDAX:       IN      A,(0FEh)
            AND     00Dh
            CP      C
            RET     Z
            CALL    BRKEY
            JR      NZ,RDAX
            LD      SP,ATRB
            JR      ST1X2

            ;    40 CHA. IN 1 LINE CODE (DATA)
LLPT:       DB      01H                                                  ; TEXT MODE
            DB      09H
            DB      09H
            DB      0BH
            DB      0DH

            ;    80 CHA. 1 LINE CODE (DATA)
SLPT:       DB      01H                                                  ; TEXT MODE
            DB      09H
            DB      09H
            DB      09H
            DB      0DH

            ;-------------------------------------------------------------------------------
            ; END OF PRINTER CMDLINE TOOLS FUNCTIONALITY
            ;-------------------------------------------------------------------------------

            ;-------------------------------------------------------------------------------
            ; START OF ADDITIONAL CMT CONTROLLER FUNCTIONALITY
            ;-------------------------------------------------------------------------------

            ; Method to setup the delay loop count to set the half-wave period of the sampling, short and long CMT pulses.
            ; To allow the user to compensate for tape stretch or drive belt wear, a compensation value can be added/subtracted
            ; from the precise time values.
            ;
            ; Opcode timings:
            ; CALL      - 17 T-states time from caller into function.
            ; LD        - 7  T-states no longer used, hard coded value.
            ; LD A,(nn) - 13 T-states time to load up the configurable loop count
            ; DEC       - 4  T-states time to dec A
            ; JP cc     - 10 T-states time to test and loop for next iteration
            ; NOP       - 4  T-states additional delay for fine tuning.
            ; RET       - 10 T-states time to return to caller.
            ;
            ; Example:
            ;          17 + 7 + ((4+10)*x) + 12 + 10 = 564 * 1/3546000 = 159uS + (7 + 13 * (1/3546000)) = 164.5uS
            ;          (66 + (14 * x)) / 3540000 = delay 
            ;          MZ-700 - x = ((delay * 3540000) - 66) / 14
            ;          MZ-80A - x = ((delay * 2000000) - 66) / 14
CMTSETDLY:  IF BUILD_MZ700+BUILD_MZ1500 > 0
            PUSH    BC                                                       ; Store the compensation value in B to be added into fixed delay value.
            LD      A,(CMTDLYCOMP)
            LD      B,A
            ;
            LD      A,(HWMODEL)                                              ; Get the machine model we are conforming to.
            CP      5                                                        ; MZ-800 has its own timing.
            JR      Z,CMTSETDLY0
            CP      6                                                        ; MZ-80B uses 1800 baud settings
            JR      Z,CMTSETDLY1
            CP      7                                                        ; MZ-2000 uses 1800 baud settings
            JR      Z,CMTSETDLY1
            ;
            ; K Series
            LD      A,86                                                     ; Remainder of the machines use a 1200 baud setting,
            ADD     A,B
            LD      (CMTSAMPLECNT),A                                         ; 368uS sample point.
            LD      A,56                                                     ; 
            ADD     A,B
            LD      (CMTDLY1CNTM),A                                          ; 240us 
            LD      A,62                                                     ; 
            ADD     A,B
            LD      (CMTDLY1CNTS),A                                          ;       + 264uS = 504uS
            LD      A,113
            ADD     A,B
            LD      (CMTDLY2CNTM),A                                          ; 464uS 
            LD      A,120
            ADD     A,B
            LD      (CMTDLY2CNTS),A                                          ;       + 494uS = 958uS
            JR      CMTDLYEXIT
            ; MZ-800
CMTSETDLY0: LD      A,89                                                     ; 379uS sample point
            ADD     A,B
            LD      (CMTSAMPLECNT),A
            LD      A,56                                                     ; 240uS
            ADD     A,B
            LD      (CMTDLY1CNTM),A
            LD      A,66                                                     ;       + 278uS = 518uS
            ADD     A,B
            LD      (CMTDLY1CNTS),A
            LD      A,114                                                    ; 470uS
            ADD     A,B
            LD      (CMTDLY2CNTM),A                                          ; 
            LD      A,120                                                    ;       + 494uS = 964uS
            ADD     A,B
            LD      (CMTDLY2CNTS),A                                          ; 
            JR      CMTDLYEXIT
            ; B Series
CMTSETDLY1: LD      A,52                                                     ; 255uS sample point.
            ADD     A,B
            LD      (CMTSAMPLECNT),A              
            LD      A,37                                                     ; 166.75uS
            ADD     A,B
            LD      (CMTDLY1CNTM),A
            LD      A,37                                                     ;        + 166uS = 332.75uS
            ADD     A,B
            LD      (CMTDLY1CNTS),A
            LD      A,80                                                     ; 333uS 
            ADD     A,B
            LD      (CMTDLY2CNTM),A                                          ; 
            LD      A,80                                                     ;        + 334uS = 667uS
            ADD     A,B
            LD      (CMTDLY2CNTS),A                                          ; 
            JR      CMTDLYEXIT
            ENDIF

            ; The values below are for an MZ-80A running at 2MHz under the FusionX board.
            ; If TZFS runs on more platforms then a table will be the best method forward.
            IF BUILD_MZ80A > 0
            PUSH    BC                                                       ; Store the compensation value in B to be added into fixed delay value.
            LD      A,(CMTDLYCOMP)
            LD      B,A
            ;
            LD      A,(HWMODEL)                                              ; Get the machine model we are conforming to.
            CP      5                                                        ; MZ-800 has its own timing.
            JR      Z,CMTSETDLY0
            CP      6                                                        ; MZ-80B uses 1800 baud settings
            JR      Z,CMTSETDLY1
            CP      7                                                        ; MZ-2000 uses 1800 baud settings
            JR      Z,CMTSETDLY1
            ;
            ; K Series
            LD      A,47                                                     ; Remainder of the machines use a 1200 baud setting,
            ADD     A,B
            LD      (CMTSAMPLECNT),A                                         ; 368uS sample point.
            LD      A,30                                                     ; 
            ADD     A,B
            LD      (CMTDLY1CNTM),A                                          ; 240us 
            LD      A,33                                                     ; 
            ADD     A,B
            LD      (CMTDLY1CNTS),A                                          ;       + 264uS = 504uS
            LD      A,62
            ADD     A,B
            LD      (CMTDLY2CNTM),A                                          ; 464uS 
            LD      A,66
            ADD     A,B
            LD      (CMTDLY2CNTS),A                                          ;       + 494uS = 958uS
            JR      CMTDLYEXIT
            ; MZ-800
CMTSETDLY0: LD      A,49                                                     ; 379uS sample point
            ADD     A,B
            LD      (CMTSAMPLECNT),A
            LD      A,30                                                     ; 240uS
            ADD     A,B
            LD      (CMTDLY1CNTM),A
            LD      A,35                                                     ;       + 278uS = 518uS
            ADD     A,B
            LD      (CMTDLY1CNTS),A
            LD      A,62                                                     ; 470uS
            ADD     A,B
            LD      (CMTDLY2CNTM),A                                          ; 
            LD      A,66                                                     ;       + 494uS = 964uS
            ADD     A,B
            LD      (CMTDLY2CNTS),A                                          ; 
            JR      CMTDLYEXIT
            ; B Series
CMTSETDLY1: LD      A,32                                                     ; 255uS sample point.
            ADD     A,B
            LD      (CMTSAMPLECNT),A              
            LD      A,19                                                     ; 166.75uS
            ADD     A,B
            LD      (CMTDLY1CNTM),A
            LD      A,19                                                     ;        + 166uS = 332.75uS
            ADD     A,B
            LD      (CMTDLY1CNTS),A
            LD      A,43                                                     ; 333uS 
            ADD     A,B
            LD      (CMTDLY2CNTM),A                                          ; 
            LD      A,43                                                     ;        + 334uS = 667uS
            ADD     A,B
            LD      (CMTDLY2CNTS),A                                          ; 
            JR      CMTDLYEXIT
            ENDIF
CMTDLYEXIT: POP     BC
            RET

            ;READ INFORMATION
            ;      CF=1:ERROR
RDITZFS:    DI      
            CALL    CMTSETDLY                                                ; Setup the delay loop counters according to machine model being used.
            LD      D,04H
            LD      BC,0080H
            LD      HL,IBUFE
RD1:        CALL    MOTOR
            JR      C,STPEIR
            CALL    TMARK
            JR      C,STPEIR
            CALL    RTAPETZFS
            JR      C,STPEIR
            JR      EIRTN
;RET2S:      BIT     3,D
;            JR      Z,EIRTN
STPEIR:     CALL    BRKEY                                                    ; Double check reason for exit, was it a break key?
            LD      A,01H
            JR      NC,STPEIR1
            LD      A,02H
STPEIR1:    LD      (RESULT),A                                               ; Store result for later use.
            SCF                                                              ; Indicate error condition.
EIRTN:      CALL    MSTOP
            EI      
            RET  

            ;READ DATA
RDDTZFS:    DI      
            CALL    CMTSETDLY                                                ; Setup the delay loop counters according to machine model being used.
            LD      D,08H
            LD      BC,(SIZE)
            JR      RD1

            ;
            ;READ TAPE
            ;      BC=SIZE
            ;      DE=LOAD ADDRESS
RTAPETZFS:  PUSH    DE
            PUSH    BC
            PUSH    HL
            LD      H,02H
RTP2:       CALL    SPDIN
            JR      C,TRTN1                                                  ;BREAK
            JR      Z,RTP2
            LD      D,H
            LD      HL,0000H
            LD      (SUMDT),HL
            POP     HL
            POP     BC
            PUSH    BC
            PUSH    HL
RTP3:       CALL    RBYTE
            JR      C,TRTN1
            LD      (HL),A
            INC     HL
            DEC     BC
            LD      A,B
            OR      C
            JR      NZ,RTP3
            LD      HL,(SUMDT)
            CALL    RBYTE
            JR      C,TRTN1
            LD      E,A
            CALL    RBYTE
            JR      C,TRTN1
            CP      L
            JR      NZ,RTP5
            LD      A,E
            CP      H
            JR      Z,TRTN1
RTP5:       DEC     D
            JR      Z,RTP6
            LD      H,D
            JR      RTP2
RTP6:       SCF     
TRTN1:      POP     HL
            POP     BC
            POP     DE
            RET     


;---------------------------------------------------------------------------------------------------------------------
            ; The FDC controller uses it's busy/wait signal as a ROM address line input, this
            ; causes a jump in the code dependent on the signal status. It gets around the 2MHz Z80 not being quick
            ; enough to process the signal by polling.
            ALIGN_NOPS FDCJMP1
            ORG      FDCJMP1
FDCJMPL3:   JP       (IX)      
;---------------------------------------------------------------------------------------------------------------------

            ;    EDGE (TAPE DATA EDGE DETECT)
            ;    BC=KEYPB (E001H)
            ;    DE=CSTR  (E002H)
            ;    EXIT CF=0 OK   CF=1 BREAK

EDGE:       LD      A,0F8H                                                   ; BREAK KEY IN (88H WOULD BE BETTER!!) 
            LD      (KEYPA),A
            NOP     
EDG1:       LD      A,(KEYPB)
            AND     81H                                                      ; SHIFT & BREAK
            JR      NZ,L060E
            SCF     
            RET     

L060E:      LD      A,(KEYPC)
            AND     20H
            JR      NZ,EDG1                                                  ; CSTR D5 = 0
EDG2:       LD      A,(KEYPB)                                                ; 13
            AND     81H                                                      ; 7
            JR      NZ,L061A                                                 ; 12 if condition met, 7 if not
            SCF     
            RET     

L061A:      LD      A,(KEYPC)                                                ; 13
            AND     20H                                                      ; 7
            JR      Z,EDG2                                                   ; CSTR D5 = 1  12/7
            RET                                                              ; 10


            ; 1 BYTE READ
            ;      DATA=A
            ;      SUMDT STORE
RBYTE:      PUSH    HL
            LD      HL,0800H                                                 ; 8 BITS
RBY1:       CALL    SPDIN
            JR      C,RBY3                                                   ;BREAK
            JR      Z,RBY2                                                   ;BIT=0
            PUSH    HL
            LD      HL,(SUMDT)                                               ;CHECKSUM
            INC     HL
            LD      (SUMDT),HL
            POP     HL
            SCF     
RBY2:       RL      L
            DEC     H
            JR      NZ,RBY1
            CALL    EDGE
            LD      A,L
RBY3:       POP     HL
            RET     
            ;TAPE MARK DETECT
            ;      E=L:INFORMATION
            ;      E=S:DATA
TMARK:      PUSH    HL
            LD      HL,1414H
            BIT     3,D
            JR      NZ,TM0
            ADD     HL,HL
TM0:        LD      (TMCNT),HL
TM1:        LD      HL,(TMCNT)
TM2:        CALL    SPDIN
            JR      C,RBY3
            JR      Z,TM1
            DEC     H
            JR      NZ,TM2
TM3:        CALL    SPDIN
            JR      C,RBY3
            JR      NZ,TM1
            DEC     L
            JR      NZ,TM3
            CALL    EDGE
            JR      RBY3
            ;READ 1 BIT
SPDIN:      CALL    EDGE                                                     ;WAIT ON HIGH
            RET     C                                                        ;BREAK

            ; LD A,(nn)  - 13 T-states
            ; DEC        - 4  T-states
            ; JP cc      - 10 T-states
            ; LD A,(nn)  - 13 T-states
            ; K Series = 368uS
            ; B Series = 255uS
            ; 800      = 379uS
            ; 74 (time from edge detection to here) + 13 + ((4+10)*x) + 13 = 798 * 1/3580000 = 178uS
            LD      A,(CMTSAMPLECNT)
SPDIN_1:    DEC     A
            JP      NZ,SPDIN_1

            LD      A,(KEYPC)                                                ;READ BIT
            AND     020H
            RET     


            ; DELAY FOR SHORT PULSE - MARK
            ;                     
            ; CALL      - 17 T-states
            ; LD        - 7  T-states
            ; LD A,(nn) - 13 T-states
            ; DEC       - 4  T-states
            ; JP cc     - 10 T-states
            ; NOP       - 4  T-states
            ; RET       - 10 T-states
            ; 17 + 13 + ((4+10)*37) + 12 + 10 = 564 * 1/3546000 = 159uS + (7 + 13 * (1/3546000)) = 164.5uS
DLYSHORTM:  LD      A,(CMTDLY1CNTM)  ; LD      A,37
DLYSHORT_1: DEC     A
            JP      NZ,DLYSHORT_1
            NOP
            NOP
            RET     

            ; DELAY FOR SHORT PULSE - SPACE
            ;                     
            ; CALL      - 17 T-states
            ; LD        - 7  T-states
            ; LD A,(nn) - 13 T-states
            ; DEC       - 4  T-states
            ; JP cc     - 10 T-states
            ; NOP       - 4  T-states
            ; RET       - 10 T-states
            ; 17 + 13 + ((4+10)*37) + 12 + 10 = 564 * 1/3546000 = 159uS + (7 + 13 * (1/3546000)) = 164.5uS
DLYSHORTS:  LD      A,(CMTDLY1CNTS)  ; LD      A,37
DLYSHORT_2: DEC     A
            JP      NZ,DLYSHORT_2
            NOP
            NOP
            RET     

            ; DELAY FOR LONG PULSE - MARK 
            ;
            ; CALL      - 17 T-states
            ; LD        - 7  T-states
            ; LD A,(nn) - 13 T-states
            ; DEC       - 4  T-states
            ; JP cc     - 10 T-states
            ; NOP       - 4  T-states
            ; RET       - 10 T-states
            ; LD        - 7  T-states
            ; LD (nn),A - 13 T-states
            ; 17 + 13 + ((4+10)*80) + 8 + 10 = 560 * 1/3546000 = 327.6uS + (7 + 13 * (1/3546000)) = 333.2uS
DLYLONGM:   LD      A,(CMTDLY2CNTM)    ; LD      A,80  
DLYLONG_1:  DEC     A
            JP      NZ,DLYLONG_1
            NOP
            NOP
            RET     

            ; DELAY FOR LONG PULSE - SPACE
            ;
            ; CALL      - 17 T-states
            ; LD        - 7  T-states
            ; LD A,(nn) - 13 T-states
            ; DEC       - 4  T-states
            ; JP cc     - 10 T-states
            ; NOP       - 4  T-states
            ; RET       - 10 T-states
            ; LD        - 7  T-states
            ; LD (nn),A - 13 T-states
            ; 17 + 13 + ((4+10)*80) + 8 + 10 = 560 * 1/3546000 = 327.6uS + (7 + 13 * (1/3546000)) = 333.2uS
DLYLONGS:   LD      A,(CMTDLY2CNTS)    ; LD      A,80  
DLYLONG_2:  DEC     A
            JP      NZ,DLYLONG_2
            NOP
            NOP
            RET     

            ; Method to create a delay of 1 Second.
DLY1SEC:    PUSH    BC
            LD      BC,1000
DLY1S_1:    CALL    DLY1MSEC
            DEC     BC
            LD      A,B
            OR      C
            JR      NZ,DLY1S_1
            POP     BC
            RET

            ; Method to create a delay of 1mSec, from caller point of call to next instruction after call.
DLY1MSEC:   LD      A, 249
DLY1MS_1:   DEC     A
            JP      NZ,DLY1MS_1
            NOP
            NOP
            RET     


            ; SHORT AND LONG PULSE FOR 1 BIT WRITE
            ;
SHORTTZFS:  PUSH    AF                                                       ; 12
            LD      A,03H                                                    ; 9
            LD      (CSTPT),A                                                ; E003H PC3=1:16
            CALL    DLYSHORTM
            LD      A,02H                                                    ; 9
            LD      (CSTPT),A                                                ; E003H PC3=0:16
            CALL    DLYSHORTS
            POP     AF                                                       ; 11
            RET                                                              ; 11
            ;
LONGTZFS:   PUSH    AF                                                       ; 11
            LD      A,03H                                                    ; 9
            LD      (CSTPT),A                                                ; 16
            CALL    DLYLONGM
            LD      A,02H                                                    ; 9
            LD      (CSTPT),A                                                ; 16
            CALL    DLYLONGS
            POP     AF                                                       ; 11
            RET                                                              ; 11

            ; GAP + TAPEMARK
            ; E   =@L@ LONG GAP
            ;     =@s@ SHORT GAP
GAPTZFS:    PUSH    BC
            PUSH    DE
            LD      A,(HWMODEL)                                              ; Get model so we can set the header pulse count.
            CP      6
            JR      Z,GAPTZFS_0
            CP      7
            JR      Z,GAPTZFS_0
            LD      BC,55F0H                                                 ; K Series machines have 22000 lead in short pulses.
            JR      GAPTZFS_00
GAPTZFS_0:  LD      BC,2710H                                                 ; 10,000 short pulses for 1800 baud cassettes
GAPTZFS_00: LD      A,E
            LD      DE,2828H
            CP      0CCH                                                     ; "L"
            JP      Z,GAPTZFS_1
            LD      BC,2AF8H
            LD      DE,1414H
GAPTZFS_1:  CALL    SHORTTZFS                                                ; Write out the number of short pulses as the start.
            DEC     BC
            LD      A,B
            OR      C
            JR      NZ,GAPTZFS_1
GAPTZFS_2:  CALL    LONGTZFS                                                 ; Write out the Tape Mark Long pulses
            DEC     D
            JR      NZ,GAPTZFS_2
GAPTZFS_3:  CALL    SHORTTZFS                                                ; Write out the Tape Mark Short pulses
            DEC     E
            JR      NZ,GAPTZFS_3
            CALL    LONGTZFS
            POP     DE
            POP     BC
            RET     

            ; 
            ; Method to write the tape header block.
            ;
WRITZFS:    DI      
            PUSH    DE
            PUSH    BC
            PUSH    HL
            CALL    CMTSETDLY                                                ; Setup the delay loop counters according to machine model being used.
            LD      D,0D7H
            LD      E,0CCH
            LD      HL,IBUFE
            LD      BC,00080H
WRITZFS_0:  CALL    CKSUM
            CALL    MOTOR
            JR      C,WRITZFS_2                 
            LD      A,E
            CP      0CCH
            JR      NZ,WRITZFS_1                
            ;
            PUSH    HL
            PUSH    DE
            PUSH    BC
            LD      DE,MSGCMTWRITE
            LD      BC,NAME
            CALL    ?PRINTMSG
            POP     BC
            POP     DE
            POP     HL
            ;
WRITZFS_1:  CALL    GAPTZFS
            CALL    WTAPETZFS
WRITZFS_2:  POP     HL
            POP     BC
            POP     DE
            CALL    MSTOP
            PUSH    AF
            LD      A,(TIMFG)
            CP      0F0H
            JR      NZ,WRITZFS_3                
            EI      
WRITZFS_3:  POP     AF
            RET     

            ; Method to write the tape data block.
            ; EXIT CF=0 : OK
            ;        =1 : BREAK

WRDTZFS:    DI      
            PUSH    DE
            PUSH    BC
            PUSH    HL
            CALL    CMTSETDLY                                                ; Setup the delay loop counters according to machine model being used.
            LD      D,0D7H                                                   ; "W"
            LD      E,53H                                                    ; "S"
L047D:      LD      BC,(SIZE)                                                ; WRITE DATA BYTE SIZE
            LD      HL,(DTADR)                                               ; WRITE DATA ADDRESS
            LD      A,B
            OR      C
            JR      Z,RET1
            JR      WRITZFS_0

            ;    TAPE WRITE
            ;    BC=BYTE SIZE
            ;    HL=DATA LOW ADDRESS
            ;    EXIT CF=0 : OK
            ;           =1 : BREAK
WTAPETZFS:  PUSH    DE
            PUSH    BC
            PUSH    HL
            LD      D,02H
            LD      A,0F8H                                                   ; 88H WOULD BE BETTER!!
            LD      (KEYPA),A                                                ; E000H
WTAP1:      LD      A,(HL)
            CALL    WBYTE                                                    ; 1 BYTE WRITE
            LD      A,(KEYPB)                                                ; E001H
            AND     81H                                                      ; SHIFT & BREAK
            JP      NZ,WTAP2
            LD      A,02H                                                    ; BREAK IN CODE
            SCF     
            JR      WTAP3

WTAP2:      INC     HL
            DEC     BC
            LD      A,B
            OR      C
            JP      NZ,WTAP1
            LD      HL,(SUMDT)                                               ; SUM DATA SET
            LD      A,H
            CALL    WBYTE
            LD      A,L
            CALL    WBYTE
            CALL    LONGTZFS
            DEC     D
            JP      NZ,L04C2
            OR      A
            JP      WTAP3

L04C2:      LD      B,0
L04C4:      CALL    SHORTTZFS
            DEC     B
            JP      NZ,L04C4
            POP     HL
            POP     BC
            PUSH    BC
            PUSH    HL
            JP      WTAP1

WTAP3:
RET1:       POP     HL
            POP     BC
            POP     DE
            RET     

            ;    1 BYTE WRITE
WBYTE:      PUSH    BC
            LD      B,8
            CALL    LONGTZFS
WBY1:       RLCA    
            CALL    C,LONGTZFS
            CALL    NC,SHORTTZFS
            DEC     B
            JP      NZ,WBY1
            POP     BC
            RET     
            
            ;-------------------------------------------------------------------------------
            ; END OF ADDITIONAL CMT CONTROLLER FUNCTIONALITY
            ;-------------------------------------------------------------------------------



            ;---------------------------------------------------------------------------------------------------------------------
            ; The FDC controller uses it's busy/wait signal as a ROM address line input, this
            ; causes a jump in the code dependent on the signal status. It gets around the 2MHz Z80 not being quick
            ; enough to process the signal by polling.
            ALIGN_NOPS FDCJMP2
            ORG      FDCJMP2               
FDCJMPH3:   JP       (IY)
            ;---------------------------------------------------------------------------------------------------------------------

            ;-------------------------------------------------------------------------------
            ; START OF ADDITIONAL TZFS COMMAND METHODS
            ;-------------------------------------------------------------------------------

            ; Cmd tool to Fill memory.
            ; Read cmd line the start address, end address and byte to initialise with, if one not present, use 00H
            ;
FILL:       CALL    READ4HEX
            JR      C,FILLERR
            PUSH    HL
            CALL    READ4HEX
            JR      C,FILLERR
            LD      (TMPADR),DE
            POP     DE                                                    ; DE = Start addr
            OR      A
            SBC     HL,DE                                                 ; HL - DE = Count
            PUSH    HL
            POP     BC                                                    ; Count of bytes to fill
            JR      C,FILLERR                                             ; Overflow, End > Start
            JR      Z,FILLERR                                             ; Nothing to do, Start = End
            PUSH    DE
            LD      DE,(TMPADR)
            CALL    _2HEX                                                 ; Get optional byte to use for fill, default to 00H 
            JR      NC,FILL1
            LD      A,000H
FILL1:      POP     HL
            LD      (HL),A
            PUSH    HL
            POP     DE
            INC     DE
            LDIR                                                          ; Copy (HL) -> (DE) filling memory with same byte.
            RET
FILLERR:    LD      DE,MSGNOPARAM
            CALL    ?PRINTMSG
            RET

            ; Tape Compensation Setup.
            ; Set a value which is added to or subtracted from the tape delay timing.
            ; This compensation value is to allow for old stretched tapes or machines with warped/stretched drive bands.
            ;
TAPECOMP:   LD      A,(DE)                                               ; Test the first character, if minus then set bit 0 in B for later use.
            CP      '-'
            LD      A,0
            JR      NZ,TAPECOMP1
            INC     DE                                                   ; Skip over minus.
            INC     A                                                    ; Set bit 0 to indicate negative number.
TAPECOMP1:  LD      B,A
            CALL    ConvertStringToNumber                                ; Convert the input into compensation value.
            JP      NZ,BADNUMERR
            LD      A,L
            CP      080H                                                 ; Numbers > 127 are illegal.
            JP      NC,BADNUMERR
            BIT     0,B
            JR      Z,TAPECOMP2
            NEG
TAPECOMP2:  LD      (CMTDLYCOMP),A                                       ; Store compensation value to be used by delay calculations.
            RET

            ; Copy - Source, Destination, Size.
COPYM:      CALL    READ4HEX                                             ; Start address
            JR      C,COPYMERR
            LD      (TMPADR),HL
            CALL    READ4HEX
            JR      C,COPYMERR
            LD      (TMPCNT),HL
            CALL    READ4HEX
            JR      C,COPYMERR
            PUSH    HL
            POP     BC
            LD      HL,(TMPCNT)
            LD      DE,(TMPADR)
            LDIR
COPYMERR:   RET

            ; Write to I/O port. 16bit address to BC, 8bit value to A.
WRITEIO:    CALL    READ4HEX                                             ; Get 16bit I/O port.
            JR      C,WRITEIOER
            PUSH    HL                                                   ; Swap to BC so B=15:8, C=7:0
            POP     BC
            CALL    _2HEX                                                ; Get 8 bit data.
            OUT     (C),A                                                ; Write 8 bit data to 16bit port.
WRITEIOER:  RET

            ; Read 16bit I/O port value.
READIO:     CALL    READ4HEX                                             ; Get 16bit I/O port.
            JR      C,READIOER
            PUSH    HL                                                   ; Swap to BC so B=15:8, C=7:0
            POP     BC
            IN      A,(C)                                                ; Get 8bit value from 16bit I/O port.
            CALL    PRTHX                                                ; Print.
            CALL    NL
READIOER:   RET
 
            ; FusionX doesnt yet have the video capabilities, so no need to build in the logic.
SETVMODE:   IF BUILD_FUSIONX = 0
              ; Method to set the video mode.
              ; Param: 0 - Enable FPGA and set to MZ-80K mode.
              ;        1 - Enable FPGA and set to MZ-80C mode.
              ;        2 - Enable FPGA and set to MZ-1200 mode.
              ;        3 - Enable FPGA and set to MZ-80A mode (base mode on MZ-80A hardware).
              ;        4 - Enable FPGA and set to MZ-700 mode (base mode on MZ-700 hardware).
              ;        5 - Enable FPGA and set to MZ-1500 mode.
              ;        6 - Enable FPGA and set to MZ-800 mode.
              ;        7 - Enable FPGA and set to MZ-80B mode.
              ;        8 - Enable FPGA and set to MZ-2000 mode.
              ;        9 - Enable FPGA and set to MZ-2200 mode.
              ;       10 - Enable FPGA and set to MZ-2500 mode.
              ;        O - Turn off FPGA Video, turn on mainboard video.
              IN    A,(CPLDINFO)                                         ; Get configuration of hardware.
              BIT   3,A
              JP    Z,NOFPGAERR                                          ; No hardware so cannot change mode.
              PUSH  DE                                                   ; Preserve DE in case no number given.
              POP   BC
              CALL  ConvertStringToNumber                                ; Convert the input into 0 (disable) or frequency in KHz.
              JR    NZ,SETVMODEOFF
              LD    A,H
              CP    0
              JP    NZ,BADNUMERR                                         ; Check that the given mode is in range 0 - 7.
              LD    A,L
              CP    10
              JP    NC,BADNUMERR
              ;
SETVMODE0:    IN    A,(CPLDCFG) 
              OR    MODE_VIDEO_FPGA                                      ; Set the tranZPUter CPLD hardware to enable the FPGA video mode.
              OUT   (CPLDCFG),A                                 
              ;
              IN    A,(VMCTRL)                                           ; Get current setting.
              AND   0F0H                                                 ; Clear old mode setting.
              OR    L                                                    ; Add in new setting.
              OUT   (VMCTRL),A
              RLC   L                                                    ; Shift mode to position for SCRNMODE storage.
              RLC   L
              RLC   L
              RLC   L
              LD    A,(SCRNMODE)                                         ; Repeat for the screen mode variable, used when resetting or changing display settings.
              AND   007H                                                 ; Clear video mode setting.
              OR    L                                                    ; Add in new setting.
              SET   2, A                                                 ; Set flag to indicate video mode override - ie, dont use base machine mode.
SETVMODECLR:  SET   1, A                                                 ; Ensure flag set so on restart the FPGA video mode is selected.
              LD    (SCRNMODE),A
              LD    A, 016H                                              ; Clear the screen so we start from a known position.
              CALL  PRNT
              LD    A,071H                                               ; Blue background and white characters.
              LD    HL,ARAM
              CALL  CLR8
              RET
SETVMODEOFF:  LD    A,(DE)
              CP    'O'
              JR    Z,SETVMODE1
              CP    'o'
              JP    NZ,BADNUMERR
SETVMODE1:    LD    A,(SCRNMODE)                                         ; Disable flag to enable FPGA on restart.
              RES   1,A
              LD    (SCRNMODE),A
              IN    A,(CPLDCFG) 
              AND   ~MODE_VIDEO_FPGA                                     ; Set the tranZPUter CPLD hardware to disable the FPGA video mode.
              OUT   (CPLDCFG),A                                 
              RET
            ENDIF
            
            ; Method to set the VGA output mode of the external display.
SETVGAMODE: IF BUILD_FUSIONX = 0
              IN    A,(CPLDINFO)                                         ; Get configuration of hardware.
              BIT   3,A
              JP    Z,NOFPGAERR                                          ; No hardware so cannot change mode.
              CALL  ConvertStringToNumber                                ; Convert the input into 0-3, 0 = off, 1 = 640x480, 2=1024x768, 3=800x600.
              JP    NZ,BADNUMERR
              LD    A,H
              CP    0
              JP    NZ,BADNUMERR                                         ; Check that the given mode is in range 0 - 15.
              LD    A,L
              CP    15
              JP    NC,BADNUMERR
              ;
           ;  RRC   L
           ;  RRC   L                                                    ; Value to top 2 bits ready to be applied to VGA mode register.
              ;
SETVGAMODE1:  IN    A,(CPLDCFG) 
              OR    MODE_VIDEO_FPGA                                      ; Set the tranZPUter CPLD hardware to enable the FPGA video mode.
              OUT   (CPLDCFG),A                                 
              ;
              LD    A, L                                                 ; Add in new setting.
              OUT   (VMVGAMODE),A
              LD    (SCRNMODE2), A
              JP    SETVMODECLR
            ENDIF

            ; Method to set the VGA border colour on the external display.
SETVBORDER: IF BUILD_FUSIONX = 0
              IN    A,(CPLDINFO)                                         ; Get configuration of hardware.
              BIT   3,A
              JP    Z,NOFPGAERR                                          ; No hardware so cannot change mode.
              CALL  ConvertStringToNumber                                ; Convert the input into 0 - 7, bit 2 = Red, 1 = Green, 0 = Blue.
              JP    NZ,BADNUMERR
              LD    A,H
              CP    0
              JP    NZ,BADNUMERR                                         ; Check that the given mode is in range 0 - 7.
              LD    A,L
              CP    7
              JP    NC,BADNUMERR
              ;
              IN    A,(CPLDCFG) 
              OR    MODE_VIDEO_FPGA                                      ; Set the tranZPUter CPLD hardware to enable the FPGA video mode.
              OUT   (CPLDCFG),A                                 
              ;
              LD    A,L
              OUT   (VMVGATTR),A
              RET
            ENDIF  ; BUILD_FUSIONX

            ; Method to enable/disable the alternate CPU frequency and change it's values.
            ;
SETFREQ:    IF BUILD_FUSIONX = 0
              CALL  ConvertStringToNumber                                ; Convert the input into 0 (disable) or frequency in KHz.
              JP    NZ,BADNUMERR
              LD    (TZSVC_CPU_FREQ),HL                                  ; Set the required frequency in the service structure.
              LD    A,H
              CP    L
              JR    NZ,SETFREQ1
              LD    A, TZSVC_CMD_CPU_BASEFREQ                            ; Switch to the base frequency.
              JR    SETFREQ2
SETFREQ1:     LD    A, TZSVC_CMD_CPU_ALTFREQ                             ; Switch to the alternate frequency.
SETFREQ2:     CALL  SVC_CMD
              OR    A
              JP    NZ,SETFREQERR
              LD    A,H
              CP    L
              RET   Z                                                    ; If we are disabling the alternate cpu frequency (ie. = 0) exit.
              LD    A, TZSVC_CMD_CPU_CHGFREQ                             ; Switch to the base frequency.
              CALL  SVC_CMD
              OR    A
              JP    NZ,SETFREQERR
              RET
            ENDIF  ; BUILD_FUSIONX

            ; FusionX doesnt have the soft CPU capabilities, so no need to build in the logic.
SETT80:     IF BUILD_FUSIONX = 0

              ; Method to configure the hardware to use the T80 CPU instantiated in the FPGA.
              ;
              IN    A,(CPUINFO)
              LD    C,A
              AND   CPUMODE_IS_SOFT_MASK
              CP    CPUMODE_IS_SOFT_AVAIL
              JP    NZ,SOFTCPUERR
              LD    A,C
              AND   CPUMODE_IS_T80
              JP    Z,NOT80ERR 
             ;LD    L,VMMODE_VGA_640x480                                  ; Enable VGA mode for a better display.
             ;CALL  SETVGAMODE1
              LD    A, TZSVC_CMD_CPU_SETT80                               ; We need to ask the K64F to switch to the T80 as it may involve loading of ROMS.
              CALL  SVC_CMD
              OR    A
              JP    NZ,SETT80ERR
              RET
            ENDIF  ; BUILD_FUSIONX

            ; Method to configure the hardware to use the original Z80 CPU installed on the tranZPUter board.
            ;
SETZ80:     IF BUILD_FUSIONX = 0
              IN    A,(CPUINFO)
              AND   CPUMODE_IS_SOFT_MASK
              CP    CPUMODE_IS_SOFT_AVAIL
              JP    NZ,SOFTCPUERR
              CALL  SETVMODE1                                            ; Turn off VGA mode, return to default MZ video.
              LD    A, TZSVC_CMD_CPU_SETZ80
              CALL  SVC_CMD
              OR    A
              JP    NZ,SETZ80ERR
              RET
            ENDIF  ; BUILD_FUSIONX

            ; Method to configure the hardware to use the ZPU Evolution CPU instantiated in the FPGA.
            ;
SETZPUEVO:  IF BUILD_FUSIONX = 0
              IN    A,(CPUINFO)
              LD    C,A
              AND   CPUMODE_IS_SOFT_MASK
              CP    CPUMODE_IS_SOFT_AVAIL
              JP    NZ,SOFTCPUERR
              LD    A,C
              AND   CPUMODE_IS_ZPU_EVO
              JP    Z,NOZPUERR 
              LD    L,VMMODE_VGA_640x480                                  ; Enable VGA mode for a better display.
              CALL  SETVGAMODE1
              LD    A, TZSVC_CMD_CPU_SETZPUEVO                            ; We need to ask the K64F to switch to the ZPU Evo as it may involve loading of ROMS.
              CALL  SVC_CMD
              OR    A
              JP    NZ,SETZPUERR
              HALT                                                          ; ZPU will take over so stop the Z80 from further processing.
            ENDIF  ; BUILD_FUSIONX

            ;----------------------------------------------
            ; Hardware Emulation Mode Activation Routines.
            ;----------------------------------------------

SETMZ80K:   IF BUILD_FUSIONX = 0
              LD    D, TZSVC_CMD_EMU_SETMZ80K                             ; We need to ask the K64F to switch to the Sharp MZ80K emulation as it involves loading ROMS.
              JR    SETEMUMZ
            ENDIF  ; BUILD_FUSIONX
SETMZ80C:   IF BUILD_FUSIONX = 0
              LD    D, TZSVC_CMD_EMU_SETMZ80C
              JR    SETEMUMZ
            ENDIF  ; BUILD_FUSIONX
SETMZ1200:  IF BUILD_FUSIONX = 0
              LD    D, TZSVC_CMD_EMU_SETMZ1200
              JR    SETEMUMZ
            ENDIF  ; BUILD_FUSIONX
SETMZ80A:   IF BUILD_FUSIONX = 0
              LD    D, TZSVC_CMD_EMU_SETMZ80A
              JR    SETEMUMZ
            ENDIF  ; BUILD_FUSIONX
SETMZ700:   IF BUILD_FUSIONX = 0
              LD    D, TZSVC_CMD_EMU_SETMZ700
              JR    SETEMUMZ
            ENDIF  ; BUILD_FUSIONX
SETMZ1500:  IF BUILD_FUSIONX = 0
              LD    D, TZSVC_CMD_EMU_SETMZ1500
              JR    SETEMUMZ
            ENDIF  ; BUILD_FUSIONX
SETMZ800:   IF BUILD_FUSIONX = 0
              LD    D, TZSVC_CMD_EMU_SETMZ800
              JR    SETEMUMZ
            ENDIF  ; BUILD_FUSIONX
SETMZ80B:   IF BUILD_FUSIONX = 0
              LD    D, TZSVC_CMD_EMU_SETMZ80B
              JR    SETEMUMZ
            ENDIF  ; BUILD_FUSIONX
SETMZ2000:  IF BUILD_FUSIONX = 0
              LD    D, TZSVC_CMD_EMU_SETMZ2000
              JR    SETEMUMZ
            ENDIF  ; BUILD_FUSIONX
SETMZ2200:  IF BUILD_FUSIONX = 0
              LD    D, TZSVC_CMD_EMU_SETMZ2200
              JR    SETEMUMZ
            ENDIF  ; BUILD_FUSIONX
SETMZ2500:  IF BUILD_FUSIONX = 0
              LD    D, TZSVC_CMD_EMU_SETMZ2500
              JR    SETEMUMZ
            ENDIF  ; BUILD_FUSIONX
            ;
            ; General function to determine if the emulator MZ hardware is present and activate it. Activation requires making a request to the
            ; I/O processor as it needs to load up the correct BIOS etc prior to activating the emulation.
            ;
SETEMUMZ:   IF BUILD_FUSIONX = 0
              IN    A,(CPUINFO)                                           ; Verify that the FPGA has emuMZ capabilities.
              LD    C,A
              AND   CPUMODE_IS_SOFT_MASK
              CP    CPUMODE_IS_SOFT_AVAIL
              JR    NZ,SOFTCPUERR
              LD    A,C
              AND   CPUMODE_IS_EMU_MZ
              JR    Z,NOEMUERR 
              LD    L,VMMODE_VGA_640x480                                  ; Enable VGA mode for a better display.
              CALL  SETVGAMODE1
              ;
              PUSH  DE                                                    ; Setup the initial video mode based on the required emulation.
              LD    A,D
              SUB   TZSVC_CMD_EMU_SETMZ80K
              LD    L,A
              LD    H,0
              CALL  SETVMODE0
              POP   DE
              ;
              LD    A, D                                                  ; Load up the required emulation mode.
              CALL  SVC_CMD
              OR    A
              JR    NZ,SETT80ERR
              HALT
            ENDIF   ; BUILD_FUSIONX

            ; Simple routine to clear screen or attributes.
CLR8:       LD      BC,00800H
            PUSH    DE
            LD      D,A
CLR8_1:     LD      (HL),D
            INC     HL
            DEC     BC
            LD      A,B
            OR      C
            JR      NZ,CLR8_1
            POP     DE
            RET  
            ;
            ; Message addresses are in Bank2.
            ;
NOFPGAERR:  IF BUILD_FUSIONX = 0
              LD    DE,MSGNOFPGA
              JR    BADNUM2
            ENDIF   ; BUILD_FUSIONX
SETT80ERR:  IF BUILD_FUSIONX = 0
              LD    DE,MSGT80ERR
              JR    BADNUM2
            ENDIF   ; BUILD_FUSIONX
SETZ80ERR:  IF BUILD_FUSIONX = 0
              LD    DE,MSGZ80ERR
              JR    BADNUM2
            ENDIF   ; BUILD_FUSIONX
SETZPUERR:  IF BUILD_FUSIONX = 0
              LD    DE,MSGZPUERR
              JR    BADNUM2
            ENDIF   ; BUILD_FUSIONX
SOFTCPUERR: IF BUILD_FUSIONX = 0
              LD    DE,MSGNOSOFTCPU
              JR    BADNUM2
            ENDIF   ; BUILD_FUSIONX
NOT80ERR:   IF BUILD_FUSIONX = 0
              LD    DE,MSGNOT80CPU
              JR    BADNUM2
            ENDIF   ; BUILD_FUSIONX
NOZPUERR:   IF BUILD_FUSIONX = 0
              LD    DE,MSGNOZPUCPU
              JR    BADNUM2
            ENDIF   ; BUILD_FUSIONX
NOEMUERR:   IF BUILD_FUSIONX = 0
              LD    DE,MSGNOEMU
              JR    BADNUM2
            ENDIF   ; BUILD_FUSIONX
SETFREQERR: LD      DE,MSGFREQERR
            JR      BADNUM2
BADNUMERR:  LD      DE,MSGBADNUM
BADNUM2:    CALL    ?PRINTMSG
            RET


            ;-------------------------------------------------------------------------------
            ; END OF ADDITIONAL TZFS COMMAND METHODS
            ;-------------------------------------------------------------------------------

            ; Ensure we fill the entire 4K by padding with FF's.
            ;
            ALIGN_NOPS      10000H

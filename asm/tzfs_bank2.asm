;--------------------------------------------------------------------------------------------------------
;-
;- Name:            tzfs_bank2.asm
;- Created:         July 2019
;- Author(s):       Philip Smart
;- Description:     Sharp MZ series tzfs (tranZPUter Filing System).
;-                  Bank 2 - F000:FFFF - Help and messages
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
;-                  Dec 2020  - Updates to accommodate v1.3 of the tranZPUter SW-700 board where soft
;-                              CPU's now become possible.
;-                  Feb 2023  - TZFS now running on FusionX. Small changes to ensure compatibility.
;-                  May 2023  - Added tape delay compensation command.
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
            ; TZFS BANK 2 - Help and message functions.
            ;
            ;============================================================
            ORG     BANKRAMADDR

            ;-------------------------------------------------------------------------------
            ; START OF PRINT ROUTINE METHODS
            ;-------------------------------------------------------------------------------

            ; Method to print out a true ASCII character, not the Sharp values. This is done using the mapping table ATBL for the
            ; range 0..127, 128.. call the original Sharp routine.
            ; Input: A = Ascii character.
PRINTASCII: PUSH    HL
            PUSH    BC
            CP      080H                                                 ; Anything above 080H isnt ascii so call original routine.
            JR      NC,PRINTASCII1
            CP      00DH                                                 ; Carriage Return? Dont map just execute via original Sharp call.
            JR      Z,PRINTASCII1
            LD      HL,ATBL
            LD      C,A
            LD      B,0
            ADD     HL,BC
            LD      A,(HL)
            CALL    ?DSP
PRINTASCII0:POP     BC
            POP     HL
            RET
PRINTASCII1:CALL    PRNT
            JR      PRINTASCII0

            ; Method to print out a string residing in this bank.
            ;
            ; As string messages take up space and banks are limited, it makes sense to locate all strings in one
            ; bank and print them out from here, hence this method.
            ;
            ; Also, as strings often require embedded values to be printed (aka printf), a basic mechanism for printing out stack
            ; parameters is provided. A PUSH before calling this method followed by an embedded marker (ie. 0xFF) will see the stack
            ; value printed in hex at the point in the string where the marker appears.
            ;
            ; Input:  DE = Address, in this bank or any other location EXCEPT another bank.
            ;         BC = Value to print with marker 0xFB if needed.
            ;         Upto 4 stack values accessed by markers 0xFF, 0xFE, 0xFD, 0xFC
PRINTMSG:   LD      A,(DE)
            CP      000H                                                 ; End of string?
            RET     Z
            CP      0FFH                                                 ; Marker to print out first stack parameter.
            JR      Z,PRINTMSG3
            CP      0FEH                                                 ; Marker to print out second stack parameter.
            JR      Z,PRINTMSG6
            CP      0FDH                                                 ; Marker to print out third stack parameter.
            JR      Z,PRINTMSG7
            CP      0FCH                                                 ; Marker to print out fourth stack parameter.
            JR      Z,PRINTMSG8
            CP      0FBH                                                 ; Marker to print out BC.
            JR      Z,PRINTMSG9
            CP      0FAH                                                 ; Marker to print out a filename with filename address stored in BC.
            JR      Z,PRINTMSG10
            CALL    PRINTASCII
PRINTMSG2:  INC     DE
            JR      PRINTMSG
PRINTMSG3:  LD      HL,6+0                                               ; Get first stack parameter, there are 2 pushes on the stack plus return address before the parameters.
PRINTMSG4:  ADD     HL,SP
            LD      A,(HL)
            INC     HL
            LD      H,(HL)
            LD      L,A
PRINTMSG5:  CALL    PRTHL
            JR      PRINTMSG2
PRINTMSG6:  LD      HL,6+2
            JR      PRINTMSG4
PRINTMSG7:  LD      HL,6+4
            JR      PRINTMSG4
PRINTMSG8:  LD      HL,6+6
            JR      PRINTMSG4
PRINTMSG9:  PUSH    BC                                                   ; Print out contents of BC as 4 digit hex.
            POP     HL
            JR      PRINTMSG5
PRINTMSG10: PUSH    DE                                                   ; Print out a filename with pointer stored in BC.
            PUSH    BC
            POP     DE
            CALL    PRTFN
            POP     DE
            JR      PRINTMSG2


            ; Method to print out the filename within an MZF header or SD Card header.
            ; The name may not be terminated as the full 17 chars are used, so this needs
            ; to be checked. Also, the filename uses Sharp Ascii so call the original Sharp 
            ; print routine.
            ;
            ; Input: DE = Address of filename.
            ;
PRTFN:      PUSH    BC
            LD      B,FNSIZE                                             ; Maximum size of filename.
PRTMSG:     LD      A,(DE)
            INC     DE
            CP      000H                                                 ; If there is a valid terminator, exit.
            JR      Z,PRTMSGE
            CP      00DH
            JR      Z,PRTMSGE
            CALL    PRNT
            DJNZ    PRTMSG                                               ; Else print until 17 chars have been processed.
            CALL    NL
PRTMSGE:    POP     BC
            RET

            ; A modified print string routine with full screen pause to print out the help screen text or other page text. The routine prints out true ascii
            ; as opposed to Sharp modified ascii. It can be called with a multi line string or many times with single string, pausing if rowcount gets to end of string.
            ; A string is NULL terminated.
PRTSTR:     PUSH    AF
            PUSH    BC
            PUSH    DE
            PUSH    HL
            LD      HL,TMPCNT
            OR      A
            JR      NZ,PRTSTR1                                           ; Carry set skip row count init, used when calling multiple times.
            LD      (HL),A
PRTSTR1:    LD      A,(DE)
            CP      000H                                                 ; NULL terminates the string.
            JR      Z,PRTSTR3
            CP      00DH                                                 ; As does CR.
            JR      Z,PRTSTR3
PRTSTR2:    CALL    PRINTASCII
            INC     DE
            JR      PRTSTR1
            ;
PRTSTR3:    PUSH    AF
            LD      A,(HL)
            CP      24                                                   ; Check to see if a page of output has been displayed, if it has, pause.
            JR      C,PRTSTR5
PRTSTR4:    CALL    GETKY
            CP      ' '
            JR      NZ,PRTSTR4
            XOR     A
            LD      (HL),A
PRTSTR5:    POP     AF
            INC     (HL)                                                 ; Increment row count, used in repeated calls not clearing rowcount to zero.
            OR      A
            JR      NZ, PRTSTR2
            POP     HL
            POP     DE
            POP     BC
            POP     AF
            RET     

            ; Method to convert a string with Sharp ASCII codes into standard ASCII codes via map lookup.
            ; Inputs: DE = pointer to string for conversion.
            ;         B  = Maximum number of characters to convert if string not terminated.
            ;
CNVSTR_SA:  PUSH    HL
            PUSH    DE
            PUSH    BC
CNVSTRSA1:  LD      A,(DE)                                                   ; Get character for conversion.
            OR      A                                                        ; Exit at End of String (NULL, CR)
            JR      Z,CNVSTRSAEX
            CP      00DH
            JR      Z,CNVSTRSAEX
            CP      020H                                                     ; No point mapping control characters.
            JR      C,CNVSTRSA2
            ;
            LD      HL,SHARPTOASC                                            ; Start of mapping table.
            PUSH    BC
            LD      C,A
            LD      B,0
            ADD     HL,BC                                                    ; Add in character offset.
            POP     BC
            LD      A,(HL)
            LD      (DE),A                                                   ; Map character.
CNVSTRSA2:  INC     DE
            DJNZ    CNVSTRSA1
CNVSTRSAEX: POP     BC                                                       ; Restore all registers used except AF.
            POP     DE
            POP     HL
            RET

            ; Method to convert a string with standard ASCII into Sharp ASCII codes via scan lookup in the mapping table.
            ; Inputs: DE = pointer to string for conversion.
            ;         B  = Maximum number of characters to convert if string not terminated.
CNVSTR_AS:  PUSH    HL
            PUSH    DE
            PUSH    BC
CNVSTRAS1:  LD      A,(DE)                                                   ; Get character for conversion.
            OR      A                                                        ; Exit at End of String (NULL, CR)
            JR      Z,CNVSTRSAEX
            CP      00DH
            JR      Z,CNVSTRSAEX
            CP      020H                                                     ; No point mapping control characters.
            JR      C,CNVSTRAS5

            LD      HL,SHARPTOASC + 020H
            PUSH    BC
            LD      B, 0100H - 020H
CNVSTRAS2:  CP      (HL)                                                     ; Go through table looking for a match.
            JR      Z,CNVSTRAS3
            INC     HL
            DJNZ    CNVSTRAS2
            JR      CNVSTRAS4                                                ; No match then dont convert.
CNVSTRAS3:  LD      BC,SHARPTOASC                                            ; On match or expiration of BC subtract table starting point to arrive at index.
            OR      A
            SBC     HL,BC
            LD      A,L                                                      ; Index is used as the converted character.
CNVSTRAS4:  LD      (DE),A
            POP     BC
CNVSTRAS5:  INC     DE
            DJNZ    CNVSTRAS1
            JR      CNVSTRSAEX

            ; TRUE ASCII TO DISPLAY CODE TABLE
            ;
ATBL:       DB      0CCH   ; NUL '\0' (null character)     
            DB      0E0H   ; SOH (start of heading)     
            DB      0F2H   ; STX (start of text)        
            DB      0F3H   ; ETX (end of text)          
            DB      0CEH   ; EOT (end of transmission)  
            DB      0CFH   ; ENQ (enquiry)              
            DB      0F6H   ; ACK (acknowledge)          
            DB      0F7H   ; BEL '\a' (bell)            
            DB      0F8H   ; BS  '\b' (backspace)       
            DB      0F9H   ; HT  '\t' (horizontal tab)  
            DB      0FAH   ; LF  '\n' (new line)        
            DB      0FBH   ; VT  '\v' (vertical tab)    
            DB      0FCH   ; FF  '\f' (form feed)       
            DB      0FDH   ; CR  '\r' (carriage ret)    
            DB      0FEH   ; SO  (shift out)            
            DB      0FFH   ; SI  (shift in)                
            DB      0E1H   ; DLE (data link escape)        
            DB      0C1H   ; DC1 (device control 1)     
            DB      0C2H   ; DC2 (device control 2)     
            DB      0C3H   ; DC3 (device control 3)     
            DB      0C4H   ; DC4 (device control 4)     
            DB      0C5H   ; NAK (negative ack.)        
            DB      0C6H   ; SYN (synchronous idle)     
            DB      0E2H   ; ETB (end of trans. blk)    
            DB      0E3H   ; CAN (cancel)               
            DB      0E4H   ; EM  (end of medium)        
            DB      0E5H   ; SUB (substitute)           
            DB      0E6H   ; ESC (escape)               
            DB      0EBH   ; FS  (file separator)       
            DB      0EEH   ; GS  (group separator)      
            DB      0EFH   ; RS  (record separator)     
            DB      0F4H   ; US  (unit separator)       
            DB      000H   ; SPACE                         
            DB      061H   ; !                             
            DB      062H   ; "                          
            DB      063H   ; #                          
            DB      064H   ; $                          
            DB      065H   ; %                          
            DB      066H   ; &                          
            DB      067H   ; '                          
            DB      068H   ; (                          
            DB      069H   ; )                          
            DB      06BH   ; *                          
            DB      06AH   ; +                          
            DB      02FH   ; ,                          
            DB      02AH   ; -                          
            DB      02EH   ; .                          
            DB      02DH   ; /                          
            DB      020H   ; 0                          
            DB      021H   ; 1                          
            DB      022H   ; 2                          
            DB      023H   ; 3                          
            DB      024H   ; 4                          
            DB      025H   ; 5                          
            DB      026H   ; 6                          
            DB      027H   ; 7                          
            DB      028H   ; 8                          
            DB      029H   ; 9                          
            DB      04FH   ; :                          
            DB      02CH   ; ;                          
            DB      051H   ; <                          
            DB      02BH   ; =                          
            DB      057H   ; >                          
            DB      049H   ; ?                          
            DB      055H   ; @
            DB      001H   ; A
            DB      002H   ; B
            DB      003H   ; C
            DB      004H   ; D
            DB      005H   ; E
            DB      006H   ; F
            DB      007H   ; G
            DB      008H   ; H
            DB      009H   ; I
            DB      00AH   ; J
            DB      00BH   ; K
            DB      00CH   ; L
            DB      00DH   ; M
            DB      00EH   ; N
            DB      00FH   ; O
            DB      010H   ; P
            DB      011H   ; Q
            DB      012H   ; R
            DB      013H   ; S
            DB      014H   ; T
            DB      015H   ; U
            DB      016H   ; V
            DB      017H   ; W
            DB      018H   ; X
            DB      019H   ; Y
            DB      01AH   ; Z
            DB      052H   ; [
            DB      059H   ; \  '\\'
            DB      054H   ; ]
            DB      0BEH   ; ^
            DB      03CH   ; _
            DB      0C7H   ; `
            DB      081H   ; a
            DB      082H   ; b
            DB      083H   ; c
            DB      084H   ; d
            DB      085H   ; e
            DB      086H   ; f
            DB      087H   ; g
            DB      088H   ; h
            DB      089H   ; i
            DB      08AH   ; j
            DB      08BH   ; k
            DB      08CH   ; l
            DB      08DH   ; m
            DB      08EH   ; n
            DB      08FH   ; o
            DB      090H   ; p
            DB      091H   ; q
            DB      092H   ; r
            DB      093H   ; s
            DB      094H   ; t
            DB      095H   ; u
            DB      096H   ; v
            DB      097H   ; w
            DB      098H   ; x
            DB      099H   ; y
            DB      09AH   ; z
            DB      0BCH   ; {
            DB      080H   ; |
            DB      040H   ; }
            DB      0A5H   ; ~
            DB      0C0H   ; DEL
ATBLE:      EQU     $

            ; Mapping table to convert between Sharp ASCII and standard ASCII.
            ; Sharp -> ASCII : Index with Sharp value into table to obtain conversion.
            ; ASCII -> Sharp : Scan into table looking for value, on match the idx is the conversion. NB 0x20 = 0x20.
SHARPTOASC: DB      000H,  020H,  020H,  020H,  020H,  020H,  020H,  020H,  020H,  020H,  020H,  020H,  020H,  000H,  020H,  020H ; 0x0F
            DB      020H,  020H,  020H,  020H,  020H,  020H,  020H,  020H,  020H,  020H,  020H,  020H,  020H,  020H,  020H,  020H ; 0x1F
            DB      020H,  021H,  022H,  023H,  024H,  025H,  026H,  027H,  028H,  029H,  02AH,  02BH,  02CH,  02DH,  02EH,  02FH ; 0x2F
            DB      030H,  031H,  032H,  033H,  034H,  035H,  036H,  037H,  038H,  039H,  03AH,  03BH,  03CH,  03DH,  03EH,  03FH ; 0x3F
            DB      040H,  041H,  042H,  043H,  044H,  045H,  046H,  047H,  048H,  049H,  04AH,  04BH,  04CH,  04DH,  04EH,  04FH ; 0x4F
            DB      050H,  051H,  052H,  053H,  054H,  055H,  056H,  057H,  058H,  059H,  05AH,  05BH,  05CH,  05DH,  05EH,  05FH ; 0x5F
            DB      020H,  020H,  020H,  020H,  020H,  020H,  020H,  020H,  020H,  020H,  020H,  020H,  020H,  020H,  020H,  020H ; 0x6F
            DB      020H,  020H,  020H,  020H,  020H,  020H,  020H,  020H,  020H,  020H,  020H,  020H,  020H,  020H,  020H,  020H ; 0x7F
            DB      020H,  020H,  020H,  020H,  020H,  020H,  020H,  020H,  020H,  020H,  020H,  020H,  020H,  020H,  020H,  020H ; 0x8F
            DB      020H,  020H,  065H,  020H,  020H,  020H,  074H,  067H,  068H,  020H,  062H,  078H,  064H,  072H,  070H,  063H ; 0x9F
            DB      071H,  061H,  07AH,  077H,  073H,  075H,  069H,  020H,  04FH,  06BH,  066H,  076H,  020H,  075H,  042H,  06AH ; 0xAF
            DB      06EH,  020H,  055H,  06DH,  020H,  020H,  020H,  06FH,  06CH,  041H,  06FH,  061H,  020H,  079H,  020H,  020H ; 0xBF
            DB      020H,  020H,  020H,  020H,  020H,  020H,  020H,  020H,  020H,  020H,  020H,  020H,  020H,  020H,  020H,  020H ; 0xCF
            DB      020H,  020H,  020H,  020H,  020H,  020H,  020H,  020H,  020H,  020H,  020H,  020H,  020H,  020H,  020H,  020H ; 0xDF
            DB      020H,  020H,  020H,  020H,  020H,  020H,  020H,  020H,  020H,  020H,  020H,  020H,  020H,  020H,  020H,  020H ; 0xEF
            DB      020H,  020H,  020H,  020H,  020H,  020H,  020H,  020H,  020H,  020H,  020H,  020H,  020H,  020H,  020H,  020H ; 0xFF

            ;-------------------------------------------------------------------------------
            ; END OF PRINT ROUTINE METHODS
            ;-------------------------------------------------------------------------------


            ; The FDC controller uses it's busy/wait signal as a ROM address line input, this
            ; causes a jump in the code dependent on the signal status. It gets around the 2MHz Z80 not being quick
            ; enough to process the signal by polling.
            ALIGN_NOPS FDCJMP1
            ORG      FDCJMP1
FDCJMPL2:   JP       (IX)      


            ;-------------------------------------------------------------------------------
            ;
            ; Message table
            ;
            ;-------------------------------------------------------------------------------
            ;        0                                       + <- 39
            ;        -----------------------------------------
MSGSON:     DB      "+ TZFS v1.8.0 ",                                                     NULL                     ; Version 1.0-> first split from RFS v2.0
MSGSONEND:  DB      " **",                                                          CR,   NULL                     ; Signon banner termination.
MSGSONT80:  IF BUILD_FUSIONX = 0
              DB    "(T80)",                                                              NULL                     ; T80 CPU detected.
            ENDIF   ; BUILD_FUSIONX
MSGNOTFND:  DB      "Not Found",                                                    CR,   NULL
MSGBADCMD:  DB      "???",                                                          CR,   NULL
MSGSDRERR:  DB      "SD Read error, Sec:",0FBH,                                           NULL
MSGSVFAIL:  DB      "Save failed.",                                                 CR,   NULL
MSGERAFAIL: DB      "Erase failed.",                                                CR,   NULL
MSGCDFAIL:  DB      "Directory invalid.",                                           CR,   NULL
MSGERASEDIR:DB      "Deleted dir entry:",0FBH,                                            NULL
MSGCMTDATA: DB      "Load:",0FEH,",Exec:",0FFH, ",Size:",                     0FBH, CR,   NULL
MSGNOTBIN:  DB      "Not binary",                                                   CR,   NULL
MSGLOAD:    DB      CR,   "Loading ",'"',0FAH,'"',                                  CR,   NULL
MSGSAVE:    DB      CR,   "Filename: ",                                                   NULL
MSGE1:      DB      CR,   "Check sum error!",                                       CR,   NULL                     ; Check sum error.
MSGCMTWRITE:DB      CR,   "Writing ", '"',0FAH,'"',                                 CR,   NULL
MSGOK:      DB      CR,   "OK!",                                                    CR,   NULL
MSGSAVEOK:  DB      "Tape image saved.",                                            CR,   NULL
MSGBOOTDRV: DB      CR,   "Floppy boot drive ?",                                          NULL
MSGLOADERR: DB      CR,   "Disk loading error",                                     CR,   NULL
MSGIPLLOAD: DB      CR,   "Disk loading ",                                                NULL
MSGDSKNOTMST:DB     CR,   "This is not a boot disk",                                CR,   NULL
MSGREAD4HEX:DB      "Bad hex number",                                               CR,   NULL
MSGT2SDERR: DB      "Copy from Tape to SD Failed",                                  CR,   NULL
MSGSD2TERR: DB      "Copy from SD to Tape Failed",                                  CR,   NULL
MSGT2SDOK:  DB      "Success, Tape to SD done.",                                    CR,   NULL
MSGSD2TOK:  DB      "Success, SD to Tape done.",                                    CR,   NULL
MSGUNKNHW:  DB      "Unknown hardware, cannot change!",                             CR,   NULL
MSGFAILBIOS:DB      "Failed to load alternate BIOS!",                               CR,   NULL
MSGFAILEXIT:DB      "TZFS exit failed, I/O proc error!",                            CR,   NULL
MSGFREQERR: DB      "Error, failed to change frequency!",                           CR,   NULL
MSGBADNUM:  DB      "Error, bad number supplied!",                                  CR,   NULL
MSGNOFPGA:  IF BUILD_FUSIONX = 0
              DB    "Error, no FPGA video module!",                                 CR,   NULL
            ENDIF   ; BUILD_FUSIONX
MSGT80ERR:  IF BUILD_FUSIONX = 0
              DB    "Error, failed to switch to T80 CPU!",                          CR,   NULL
            ENDIF   ; BUILD_FUSIONX
MSGZ80ERR:  IF BUILD_FUSIONX = 0
              DB    "Error, failed to switch to Z80 CPU!",                          CR,   NULL
            ENDIF   ; BUILD_FUSIONX
MSGZPUERR:  IF BUILD_FUSIONX = 0
              DB    "Error, failed to switch to ZPU CPU!",                          CR,   NULL
            ENDIF   ; BUILD_FUSIONX
MSGNOSOFTCPU:IF BUILD_FUSIONX = 0
              DB   "No soft cpu hardware!",                                        CR,   NULL
            ENDIF   ; BUILD_FUSIONX
MSGNOT80CPU:IF BUILD_FUSIONX = 0
              DB    "T80 not available!",                                           CR,   NULL
            ENDIF   ; BUILD_FUSIONX
MSGNOEMU:   IF BUILD_FUSIONX = 0
              DB    "No Sharp MZ Series Emu hardware!",                             CR,   NULL
            ENDIF   ; BUILD_FUSIONX
;
OKCHECK:    DB      ", CHECK: ",                                                    CR,   NULL
OKMSG:      DB      " OK.",                                                         CR,   NULL
DONEMSG:    DB      11h
            DB      "RAM TEST COMPLETE.",                                           CR,   NULL
BITMSG:     DB      " BIT:  ",                                                      CR,   NULL
BANKMSG:    DB      " BANK: ",                                                      CR,   NULL
MSG_TIMERTST:DB     "8253 TIMER TEST",                                              CR,   NULL
MSG_TIMERVAL:DB     "READ VALUE 1: ",                                               CR,   NULL
MSG_TIMERVAL2:DB    "READ VALUE 2: ",                                               CR,   NULL
MSG_TIMERVAL3:DB    "READ DONE.",                                                   CR,   NULL
MSGNOINSTR: DB      "Bad instruction.",                                             CR,   NULL
MSGNOPARAM: DB      "Bad parameter.",                                               CR,   NULL


            ; The FDC controller uses it's busy/wait signal as a ROM address line input, this
            ; causes a jump in the code dependent on the signal status. It gets around the 2MHz Z80 not being quick
            ; enough to process the signal by polling.
            ALIGN_NOPS FDCJMP2
            ORG      FDCJMP2               
FDCJMPH2:   JP       (IY)

            ; Continuation of messages after the Floppy Disk controller fixed location.
MSGNOZPUCPU:DB      "ZPU Evo not available!",                                       CR,   NULL
MSGNOCMTDIR:DB      "CMT has no directory.",                                        CR,   NULL
MSGNOVERIFY:DB      "No Verify for SD drive.",                                      CR,   NULL

SVCRESPERR: DB      "I/O Response Error, time out!",                                CR,   NULL
SVCIOERR:   DB      "I/O Error, time out!",                                         CR,   NULL

;TESTMSG:    DB      "HL is:",0FBH,    00DH,       000H
;TESTMSG2:   DB      "DE is:",0FBH,    00DH,       000H
;TESTMSG3:   DB      "BC is:",0FBH,    00DH,       000H
;TESTMSG4:   DB      "4 is:",0FBH,    00DH,       000H



            ;-------------------------------------------------------------------------------
            ; START OF HELP SCREEN FUNCTIONALITY
            ;-------------------------------------------------------------------------------

            ; Simple help screen to display commands.
HELP:       LD      DE, HELPSCR
            XOR     A                                                     ; Paging starts at 0.
            CALL    PRTSTR
            RET

            ; Help text. Use of lower case, due to Sharp's non standard character set, is not easy, you have to manually code each byte
            ; hence using upper case.
HELPSCR:    ;       "--------- 40 column width -------------"
            DB      "4        40 col mode",                                00DH
            DB      "8        80 col mode",                                00DH
           ;DB      "40A      select MZ-80A 40col Mode",                   00DH
           ;DB      "80A      select MZ-80A 80col Mode",                   00DH
           ;DB      "80B      select MZ-80B Mode",                         00DH
           ;DB      "700      select MZ-700 40col Mode",                   00DH
           ;DB      "7008     select MZ-700 80col Mode",                   00DH
            DB      "ASMXXXX  assemble into dest XXXX",                    00DH
            DB      "B        toggle keyboard bell",                       00DH
            DB      "BASIC    load BASIC SA-5510",                         00DH
            DB      "CD[d]    switch to SD directory [d]",                 00DH
            DB      "CPXXXXYYYYZZZZ",                                      00DH
            DB      "         copy XXXX to YYYY of size ZZZZ",             00DH
            DB      "CPM      load CPM",                                   00DH
            DB      "DXXXX[YYYY]",                                         00DH 
            DB      "         dump mem XXXX to YYYY",                      00DH
            DB      "DASMXXXX[YYYY]",                                      00DH
            DB      "         disassemble XXXX to YYYY",                   00DH
            DB      "DIR[wc]  SD dir listing, wc=wildcard",                00DH
            DB      "ECfn     erase file, fn=No or Filename",              00DH
            DB      "EX       exit TZFS, reset as original",               00DH
            DB      "Fx       boot fd drive x",                            00DH
            DB      "FILLXXXXYYYY[ZZ]",                                    00DH
            DB      "         Fill memory from XXXX to YYYY",              00DH
            DB      "FREQn    set CPU to nKHz, 0 default",                 00DH
            DB      "H        this help screen",                           00DH
            DB      "JXXXX    jump to location XXXX",                      00DH
            DB      "LTfn[,M] load tape, fn=Filename",                     00DH
            DB      "         M = HW Mode, K=80K,C=80C,",                  00DH
            DB      "             1=1200,A=80A,7=700,8=800,",              00DH
            DB      "             B=80B, 2=2000",                          00DH
            DB      "LCfn[,M] load from SD, fn=No or FileN",               00DH
            DB      "         add NX for no exec, ie.LCNX",                00DH
            DB      "MXXXX    edit memory starting at XXXX",               00DH
            IF BUILD_FUSIONX = 0
              DB    "MZmc     activate hardware emulation",                00DH
              DB    "         mc =80K,80C,1200,80A,700,800,",              00DH
              DB    "             80B,2000",                               00DH
            ENDIF   ; BUILD_FUSIONX
            DB      "P        test printer",                               00DH
            DB      "R        test dram memory",                           00DH
            DB      "RIOXXXX  Read I/O port XXXX and print",               00DH
           ;DB      "SDDd     change to SD directory {d}",                 00DH
            DB      "SD2Tfn[,M] copy SD to tape",                          00DH
            DB      "STXXXXYYYYZZZZ[,M]",                                  00DH
            DB      "         save memory to tape",                        00DH
            DB      "SCXXXXYYYYZZZZ",                                      00DH
            DB      "         save mem to card, XXXX=start",               00DH
            DB      "                 YYYY=end, ZZZZ=exec",                00DH
            DB      "T        test timer",                                 00DH
            DB      "TC[-]XX  set tape delay compensation",                00DH
            DB      "T2SD[B][,M]",                                         00DH
            DB      "         copy tape to SD, B=Bulk",                    00DH
            IF BUILD_FUSIONX = 0
              DB    "T80      switch to soft T80 CPU",                     00DH
            ENDIF   ; BUILD_FUSIONX
            DB      "V        verify tape save",                           00DH
            DB      "WIOXXXXYY Write YY to I/O port XXXX",                 00DH
            IF BUILD_FUSIONX = 0
              DB    "VBORDERn set vga border colour",                      00DH
              DB    "VMODEn   set video mode",                             00DH
              DB    "VGAn     set VGA mode",                               00DH
              DB    "Z80      switch to hard Z80 CPU",                     00DH
              DB    "ZPU      switch to ZPU Evo CPU / zOS",                00DH
            ENDIF   ; BUILD_FUSIONX
            ;       "--------- 40 column width -------------"
            DB                                                              000H

            ;-------------------------------------------------------------------------------
            ; END OF HELP SCREEN FUNCTIONALITY
            ;-------------------------------------------------------------------------------
            ;
            ; Ensure we fill the entire 4K by padding with FF's.
            ;
            ALIGN_NOPS      10000H

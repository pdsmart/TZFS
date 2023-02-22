            ;****************************************************************
            ;
            ; MZ-2000 Initial Program Loader Firmware.
            ;
            ; Disassembled with dz80 v2.1 and comments copied from the
            ; MZ-80B IPL disassembly.
            ;
            ;****************************************************************

            ; I/O registers.
            ;
            ; 0xE0 = 8255 Port A - A7 : L APSS Search for next program
            ;                      A6 : L Automatic playback at end of rewind
            ;                      A5 : L Automatic rewind during playback(recording)
            ;                      A4 : L Invert Video
            ;                      A3 : L Stop Cassette
            ;                      A2 : L Play Cassette
            ;                      A1 : L Fast Forward
            ;                      A0 : L Rewind
            ; 0xE1 = 8255 Port B - B7 : H Detected BREAK key during cassette playback
            ;                      B6 :   Tape Read Data
            ;                      B5 : L Cassette Loaded
            ;                      B4 : L Write/Record enabled
            ;                      B3 : L Tape End detected
            ;                      B2 :  
            ;                      B1 :  
            ;                      B0 : H Video Blanking detected
            ; 0xE2 = 8255 Port C - C7 :   Tape write data
            ;                      C6 : L Record (H = Play)
            ;                      C5 : H Block FF, REW, STOP
            ;                      C4 : L Eject Tape
            ;                      C3 : L Start IPL (enter boot mode and boot memory configuration, ie. 0x0000:0x7FFF - ROM, 0x8000:0xFFFF Ram (lower bank remapped to upper bank)
            ;                      C2 :   Sound output (bit toggle to generate a frequency).
            ;                      C1 : H Set memory to normal mode, no ROM, RAM = 0x0000:0xFFFF
            ;                      C0 : H Blank screen via video gate
            ; 0xE3 = 8255 Control
            ; 0xE4 = 8253 Counter 0 - 31.25KHz divider
            ; 0xE5 = 8253 Counter 1 - Output of counter 0, normally 1 second pulse
            ; 0xE6 = 8253 Counter 2 - Output of counter 1, counts 12 hours.
            ; 0xE7 = 8253 Control
            ; 0xE8 = PIO  Port A
            ;                      A7 : H 0xD000:0xD7FF or 0xC000:0xFFFF VRAN paged in.
            ;                      A6 : H Select Character VRAM (H) or Graphics VRAM (L)
            ;                      A5 : H Select 80 char mode, 40 char mode = L
            ;                      A4 : L Select all key strobe lines active, for detection of any key press.
            ;                      A3-A0: Keyboard strobe lines
            ; 0xE9 = PIO  Port A Control
            ; 0xEA = PIO  Port B
            ;                      B7-B0: Keyboard data lines 
            ; 0xEB = PIO  Port B Control
            ; 0xF4 = Colour CRT Background Colour Selection
            ; 0xF5 = Priority, Bit 3 = 0, Character comes to foreground, = 1, Graphics comes to foreground. 2:0 = Colour
            ; 0xF6 = Bit 4 Graphics Display on CRT (H), 2:0 colour VRAM enable to Colour CRT / CRT (if enabled).
            ; 0xF7 = Selection of VRAM bank in memory map when enabled, 0 = None, 1 = Blue, 2 = Red, 3 = Green
            ;
FDC         EQU     0D8h                                       ; MB8866 IO Region 0D8h - 0DBh
FDC_CR      EQU     FDC + 000h                                 ; Command Register
FDC_STR     EQU     FDC + 000h                                 ; Status Register
FDC_TR      EQU     FDC + 001h                                 ; Track Register
FDC_SCR     EQU     FDC + 002h                                 ; Sector Register
FDC_DR      EQU     FDC + 003h                                 ; Data Register
FDC_MOTOR   EQU     FDC + 004h                                 ; DS[0-3] and Motor control. 4 drives  DS= BIT 0 -> Bit 2 = Drive number, 2=1,1=0,0=0 DS0, 2=1,1=0,0=1 DS1 etc
                                                               ;  bit 7 = 1 MOTOR ON LOW (Active)
FDC_SIDE    EQU     FDC + 005h                                 ; Side select, Bit 0 when set = SIDE SELECT LOW, 
FDC_DDEN    EQU     FDC + 006h                                 ; Double density enable, 0 = double density, 1 = single density disks.
PPIA        EQU     0E0H                                       ; 8255 Port A
PPIB        EQU     0E1H                                       ; 8255 Port B
PPIC        EQU     0E2H                                       ; 8255 Port C
PPICTL      EQU     0E3H                                       ; 8255 Control Port
PIOA        EQU     0E8H                                       ; Z80 PIO Port A
PIOCTLA     EQU     0E9H                                       ; Z80 PIO Port A Control Port
PIOB        EQU     0EAH                                       ; Z80 PIO Port B
PIOCTLB     EQU     0EBH                                       ; Z80 PIO Port B Control Port
CRTBKCOLR   EQU     0F4H                                       ; Configure external CRT background colour.
CRTGRPHPRIO EQU     0F5H                                       ; Graphics priority register, character or a graphics colour has front display priority.
CRTGRPHSEL  EQU     0F6H                                       ; Graphics output select on CRT or external CRT
GRAMCOLRSEL EQU     0F7H                                       ; Graphics RAM colour bank select.
GRAMADDRL   EQU     0C000H                                     ; Graphics RAM lower address.
IBUFE       EQU     0CF00H                                     ; Cassette header start.
FDNAME      EQU     0CF07H                                     ; Floppy disk name when floppy sector read.(ie after type+IPLPRO).
ATRB        EQU     0CF00H                                     ; Tape attribute byte.
NAME        EQU     0CF01H                                     ; Tape image name.
SIZE        EQU     0CF12H                                     ; Tape image size.
DTADR       EQU     0CF14H                                     ; Tape image load address.
SUMDT       EQU     0FFE0H                                     ; Check sum data.
TMCNT       EQU     0FFE2H                                     ; 
IBADR1      EQU     0CF00H                                     ; 
IBADR2      EQU     08000H
NTRACK      EQU     0FFE0H                                     ; Track number.
NSECT       EQU     0FFE1H                                     ; Sector number.
BSIZE       EQU     0FFE2H                                     ; Size of file to read.
STTR        EQU     0FFE4H                                     ; Starting track.
STSE        EQU     0FFE5H                                     ; Starting sector.
MTFG        EQU     0FFE6H                                     ; Motor flag.
CLBF0       EQU     0FFE7H                                     ; 
CLBF1       EQU     0FFE8H
CLBF2       EQU     0FFE9H
CLBF3       EQU     0FFEAH
RETRY       EQU     0FFEBH
DRINO       EQU     0FFECH
PRGSTART    EQU     00000H




            ORG     PRGSTART

            ; NST = Rising edge, set memory to normal state, ie. 0x0000:FFFF = RAM and reset Z80.
            ; BST = Falling edge, enter IPL mode and reset Z80.

            ; Build time configuration code - build the original version when BUILDVERSION = 0 or the TZPU enhanced version when BUILDVERSION = 1
           ;IF      BUILDVERSION = 1
           ;ELSE
           ;ENDIF

RESET:      JR      START               
            ;
            ; NST RESET - Toggling 
            ;
NST:        LD      A,003H                                     ; Set PC1 NST=1, this toggles the memory into the normal state and resets the CPU thus executing from 0000 in RAM BANK 1
            OUT     (PPICTL),A                                                                                      
            ;
START:      LD      A,082H                                     ; 8255 A=OUT B=IN C=OUT
            OUT     (PPICTL),A                                                                                      
            LD      A,058H                                     ; BST=1 NST=0 OPEN=1 WRITE=1 
            OUT     (PPIC),A                                                                                        
            LD      SP,SUMDT                                   ; Setup stack
            LD      A,0F7H                                                                                          
            OUT     (PPIA),A                                   ; All signals inactive, stop cassette.                                                                             
            LD      A,00FH                                                                                          
            OUT     (PIOCTLA),A                                ; Setup PIO A
            LD      A,0CFH                                                                                          
            OUT     (PIOCTLB),A                                ; Setup PIO B                                                                            
            LD      A,0FFH                                                                                          
            OUT     (PIOCTLB),A                                                                                     
            ;
            ; tranZPUter build ensure the FPGA and CPLD are set to the correct initial operating mode.
            IF      BUILDVERSION = 1
              LD    A,VMMODE_MZ2000                            ; Ensure correct video mode is selected in FPGA.
              OUT   (VMCTRL),A
              LD    A,MODE_MZ2000|MODE_VIDEO_FPGA|SYSMODE_MZ2000|MODE_RESET_PRESERVE
              ;LD    A,MODE_MZ2000|SYSMODE_MZ2000|MODE_RESET_PRESERVE
              OUT   (CPLDCFG),A
            ENDIF
            ;
            XOR     A                                          ; Set Graphics VRAM to default, no access to GRAM.
            OUT     (CRTGRPHSEL),A                                                                                                               
            OUT     (CRTBKCOLR),A                              ; Set background colour on external output to black.
            INC     A                                                                                                                      
            OUT     (GRAMCOLRSEL),A                            ; Activate Blue graphics RAM bank for graphics operations (this is the default installed bank, red and green are optional).                                                                                   
            LD      A,007H                                     
            OUT     (CRTGRPHPRIO),A                            ; Enable all colour bank graphic output with character priority.
            LD      A,0D3H                                     
            OUT     (PIOA),A                                   ; 11010011 = VRAM paged in for characters, 40 char mode, keyboard strobe bank 3.
                                                               ; A7 : H 0xD000:0xD7FF or 0xC000:0xFFFF VRAN paged in.
                                                               ; A6 : H Select Character VRAM (H) or Graphics VRAM (L)
                                                               ; A5 : H Select 80 char mode, 40 char mode = L
                                                               ; A4 : L Select all key strobe lines active, for detection of any key press.
                                                               ; A3-A0: Keyboard strobe lines
            LD      HL,0D000H                                  
            LD      A,0D8H                                     ; Set to character VRAM top address.
CLEAR:      LD      (HL),000H                                  ; DISPLAY CLEAR
            INC     HL                                                                                                                     
            CP      H                                                                                                                      
            JR      NZ,CLEAR                                   
            LD      A,0FFH                                     ; Disable all PPI A signals.
                                                               ; A7 : L APSS Search for next program
                                                               ; A6 : L Automatic playback at end of rewind
                                                               ; A5 : L Automatic rewind during playback(recording)
                                                               ; A4 : L Invert Video
                                                               ; A3 : L Stop Cassette
                                                               ; A2 : L Play Cassette
                                                               ; A1 : L Fast Forward
                                                               ; A0 : L Rewind
            OUT     (PPIA),A                                                                                                               
            LD      A,003H                                     ; Select GREEN graphics RAM bank.                                                                            
            OUT     (GRAMCOLRSEL),A                                                                                                               
            CALL    FILLVRAM                                   ; Clear it.
            LD      A,002H                                     ; Select RED graphics RAM bank. 
            OUT     (GRAMCOLRSEL),A                                                                                                               
            CALL    FILLVRAM                                      
            LD      A,001H                                     ; Select BLUE graphics RAM bank. 
            OUT     (GRAMCOLRSEL),A                                   
            CALL    FILLVRAM                                      
            LD      A,013H                                     ; 00010011 = Disable VRAM (select RAM), keystrobe bank 3.
            OUT     (PIOA),A                                   
            XOR     A                                          ; Clear control variables.
            LD      (DRINO),A           
            LD      (MTFG),A            

            ; Boot time function selection key processing.
KEYIN:      IF      BUILDVERSION = 1
              CALL  KEYS1
              BIT   6,A                                        ; F - Floppy disk
              JP    Z,FD
              BIT   3,A                                        ; C - Cassette.
              JR    Z,CMT                                                                                                                  
              BIT   0,A                                        ; / - Boot external rom.
              JP    Z,EXROMT                                                                                                               
              LD    B,016H
              CALL  KEYS
              BIT   4,A                                        ; T - TZFS Monitor
              JP    Z,TZFS
              BIT   6,A                                        ; V - Verification Test
              JP    Z,VTEST
              LD    B,010H
              CALL  KEYS
              BIT   0,A                                        ; F1
              JP    Z,FUNC_F1
              BIT   1,A                                        ; F2
              JP    Z,FUNC_F2
              BIT   2,A                                        ; F3
              JP    Z,FUNC_F3
              BIT   3,A                                        ; F4
              JP    Z,FUNC_F4
              BIT   4,A                                        ; F5
              JP    Z,FUNC_F5
              BIT   5,A                                        ; F6
              JP    Z,FUNC_F6
              BIT   6,A                                        ; F7
              JP    Z,FUNC_F7
              BIT   7,A                                        ; F8
              JP    Z,FUNC_F8
            ELSE
              CALL  KEYS1                                      ; Get a key to decide on first action.
              BIT   3,A                                        ; C - Cassette.
              JR    Z,CMT                                                                                                                  
              BIT   0,A                                        ; / - Boot external rom.
              JP    Z,EXROMT                                                                                                               
            ENDIF
            JR      NKIN                                       ; No selection, so standard startup, try FDC then CMT.
                                                                                                                                           
FILLVRAM:   LD      HL,GRAMADDRL                               ; Base of Video Graphics RAM in address space.
            DI                                                 
            IN      A,(PIOA)                                   ; Read the PIO register and enable Graphics RAM           
            SET     7,A                                        
            RES     6,A                                        
            OUT     (PIOA),A                                   
            LD      DE,GRAMADDRL + 1
            LD      (HL),000H
            LD      BC,03E7FH
L0082:      LDIR    
            RES     7,A                                        ; Read the PIO and disable Video/Graphics RAM (use normal RAM).
            SET     6,A
            OUT     (PIOA),A
            EI      
            RET     

KEYS1:      LD      B,014H                                     ;Preserve A4-A7, set A4 to prevent all strobes low, then select line 5 (0-4).
KEYS:       IN      A,(PIOA)                                                                                                               
            AND     0F0H                                                                                                                   
            OR      B                                                                                                                      
            OUT     (PIOA),A                                                                                                               
            IN      A,(PIOB)                                   ;Read the strobed key.
            RET     

NKIN:       IF      BUILDVERSION = 1
              JP    TRYAG                                      ; Straight to the menu, dont auto start FD or cassette.
            ELSE
              CALL  FDCC                                       ; FD available?
              JP    Z,FD                                       ; Yes, try and boot from floppy.
              JR    CMT                                        ; No, boot from CMT.
            ENDIF

            ;
            ; Check to see if the Floppy Disk interface is installed. 
            ; NZ = not installed.
            ; Z  = installed.
            ;
FDCC:       LD      A,0A5H
            LD      B,A
            OUT     (FDC_TR),A
            CALL    DLY80U
            IN      A,(FDC_TR)
            CP      B
            RET     
            ;
            ;                                                  ;
            ;  CMT CONTROL                                     ;
            ;                                                  ;
            ;
CMT:        CALL    MOTORSTOP
            CALL    KYEMES
            CALL    RDINF
            JR      C,ST1               
            CALL    LDMSG
            LD      HL,NAME
            LD      E,010H
            LD      C,010H
            CALL    DISP2
            LD      A,(IBUFE)
            CP      001H
            JR      NZ,MISMCH           
            CALL    RDDAT
ST1:        PUSH    AF
            CALL    FR                                         ; Rewind tape.
            POP     AF
            JP      C,TRYAG
            JP      NST                                        ; Set to normal memory mode and restart at 0x0000

MISMCH:     LD      HL,MES16
            LD      E,00AH
            LD      C,00FH
            CALL    DISP
            CALL    MOTORSTOP
            SCF     
            JR      ST1                 
            ;
            ;READ INFORMATION
            ;      CF=1:ERROR
QRDI:
RDINF:      DI      
            IN      A,(PPIC)
            SET     5,A
            OUT     (PPIC),A
            LD      D,004H
            LD      BC,0080H
            LD      HL,IBUFE
RD1:        CALL    MOTOR
            JR      C,STPEIR            
            CALL    TMARK
            JR      C,STPEIR            
            CALL    RTAPE
            JR      C,STPEIR            
            BIT     3,D
            JR      Z,EIRTN             
STPEIR:     CALL    MOTORSTOP
EIRTN:      EI      
            RET     
            ;
            ;
            ;READ DATA
            ;
QRDD:
RDDAT:      DI      
            LD      D,008H
            LD      BC,(0CF12H)
            LD      HL,IBADR2
            JR      RD1                 
            ;
            ;
            ;READ TAPE
            ;      BC=SIZE
            ;      DE=LOAD ADDRSS
RTAPE:      PUSH    DE
            PUSH    BC
            PUSH    HL
            LD      H,002H
RTP2:       CALL    SPDIN
            JR      C,TRTN1                                    ; BREAK
            JR      Z,RTP2              
            LD      D,H
            LD      HL,00000H
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

RTP6:       CALL    BOOTER
            SCF     
TRTN1:      POP     HL
            POP     BC
            POP     DE
            RET     

EDGE:       IN      A,(PPIB)
            CPL     
            RLCA    
            RET     C                                          ; BREAK
            RLCA    
            JR      NC,EDGE                                    ; WAIT ON LOW
L016A:      IN      A,(PPIB)
            CPL     
            RLCA    
            RET     C                                          ; BREAK
            RLCA    
            JR      C,L016A                                    ; WAIT ON HIGH
            RET     
            ; 1 BYTE READ
            ;      DATA=A
            ;      SUMDT STORE
RBYTE:      PUSH    HL
            LD      HL,00800H                                  ; 8 BITS
RBY1:       CALL    SPDIN
            JR      C,RBY3                                     ; BREAK
            JR      Z,RBY2                                     ; BIT=0
            PUSH    HL
            LD      HL,(SUMDT)                                 ;CHECKSUM
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
            LD      HL,01414H
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

SPDIN:      CALL    EDGE                                       ;WAIT ON HIGH
            RET     C                                          ;BREAK
            CALL    DLY2
            IN      A,(PPIB)                                   ;READ BIT
            AND     040H
            RET     
            ;
            ;
            ;MOTOR ON
MOTOR:      PUSH    DE
            PUSH    BC
            PUSH    HL
            IN      A,(PPIB)
            AND     020H
            JR      Z,MOTRD             
            LD      HL,MES6
            LD      E,00AH
            LD      C,00EH
            CALL    DISP
            CALL    OPEN
MOT1:       IN      A,(PIOB)
            CPL     
            RLCA    
            JR      C,MOTR              
            IN      A,(PPIB)
            AND     020H
            JR      NZ,MOT1             
            CALL    KYEMES
            CALL    DEL1M
MOTRD:      CALL    PLAY
MOTR:       POP     HL
            POP     BC
            POP     DE
            RET     
            ;
            ;
            ;MOTOR STOP
MOTORSTOP:  LD      A,0F7H
            OUT     (PPIA),A
            CALL    DEL6
            LD      A,0FFH
            OUT     (PPIA),A
            RET     
            ;EJECT
OPEN:       LD      A,008H                                     ;Reset PC4 - EJECT activate
            OUT     (PPICTL),A
            CALL    DEL6
            LD      A,009H
            OUT     (PPICTL),A                                 ;Set PC4 - Deactivate EJECT
            RET     

KYEMES:     LD      HL,MES3
            LD      E,004H
            LD      C,01CH
            CALL    DISP
            RET     
            ;
            ;PLAY
PLAY:       LD      A,0FBH
            OUT     (PPIA),A
            CALL    DEL6
            LD      A,0FFH
            OUT     (PPIA),A
            RET     

FR:         LD      A,0FEH
FR1:        OUT     (PPIA),A
            CALL    DEL6
            LD      A,0FFH
            OUT     (PPIA),A
            IN      A,(PPIC)
            RES     5,A
            OUT     (PPIC),A
            RET     
            ;
            ;TIMING DEL
DM1:        PUSH    AF
DM1A:       XOR     A
DM1B:       DEC     A
            JR      NZ,DM1B             
            DEC     BC
            LD      A,B
            OR      C
            JR      NZ,DM1A             
            POP     AF
            POP     BC
            RET     

DEL6:       PUSH    BC
            LD      BC,RDINF
            JR      DM1                 

DEL1M:      PUSH    BC
            LD      BC,060FH
            JR      DM1                 
            ;
            ;TAPE DELAY TIMING
            ;
            ;
DLY2:       LD      A,031H
DLY2A:      DEC     A
            JP      NZ,DLY2A
            RET     

LDMSG:      LD      HL,MES1                                    ; Address of string to display.
            LD      E,000H                                     ; Offset into first 256 characters of screen for message display.
            LD      C,00EH                                     ; Number of characters to display.
            JR      DISP                                       

DISP2:      LD      A,0D3H
            OUT     (PIOA),A
            JR      DISP1                                      

BOOTER:     LD      HL,MES8
            LD      E,00AH
            LD      C,00DH
DISP:       LD      A,0D3H                                     ; Page in character video ram.
            OUT     (PIOA),A
            EXX     
            LD      HL,0D000H                                  ; Clear screen, entire 0xD000:0xDFFF area
            LD      A,0D8H                                     ; Top of character VRAM.
DISP3:      LD      (HL),000H
            INC     HL
            CP      H
            JR      NZ,DISP3                                   ; When H moves to 0x0E then complete.
            EXX     
DISP1:      XOR     A
            LD      B,A
            LD      D,0D0H                                     ; E points to offset in 0xD000 area for message display, given by caller.
            LDIR                                               ; HL set by caller to message string. C set to string length, B always 0.
            LD      A,013H                                     ; Restore memory, page out video ram.
            OUT     (PIOA),A
            RET     

            ;
            ; Print method with full screen addressable.
            ;
PRTSTR:     IF      BUILDVERSION = 1
              LD    A,0D3H                                     ; Enable VRAM.
              OUT   (PIOA),A
              LD    A,(HL)                                     ; HL points to destination address and null terminated string.
              LD    E,A
              INC   HL
              LD    A,(HL)
              LD    D,A
PRTSTR1:      INC   HL
              LD    A,(HL)                                     ; Copy from source (HL) to destination (DE) until a null byte is encountered.
              OR    A
              JR    Z,PRTSTR2
              LD    (DE),A
              INC   DE
              JR    PRTSTR1
PRTSTR2:      LD    A,013H                                     ; Restore memory, page out video ram.
              OUT   (PIOA),A
              RET
            ENDIF

            ;
MES1:       DB      "IPL is loading"
MES3:       DB      "IPL is looking for a program"
MES6:       IF      BUILDVERSION = 1
             DB     "Make ready CMT"
            ELSE
             DB     "Make ready CMT"
            ENDIF
MES8:       DB      "Loading error"
MES9:       DB      "Make ready FD"
MES10:      IF      BUILDVERSION = 1
              DW    0D05AH
              DB    "Select boot option:",000H
            ELSE
              DB    "Press F or C"
            ENDIF
MES11:      IF      BUILDVERSION = 1
              DW    0D0ABH
              DB    "F:  Floppy diskette",000H
            ELSE
              DB    "F:Floppy diskette"
            ENDIF
MES12:      IF      BUILDVERSION = 1
              DW    0D0D3H
              DB    "C:  Cassette tape",000H
            ELSE
              DB    "C:Cassette tape"
            ENDIF
MES13:      DB      "Drive No? (1-4)"
MES14:      DB      "This diskette is not master"
MES15:      DB      "Pressing S key starts the CMT"
MES16:      DB      "File mode error"
            ;
IPLMC:      DB      01H
            DB      "IPLPRO"

            IF      BUILDVERSION = 1
MESBOOT:      DW    0D0FBH
              DB    "B:  NST Boot", 000H
MESTZFS:      DW    0D123H
              DB    "T:  TZFS Monitor", 000H
MESF1:        DW    0D14BH
              DB    "F1: BASIC 1Z-001",000H
MESF2:        DW    0D173H
              DB    "F2: BASIC 1Z-002",000H
MESF3:        DW    0D19BH
              DB    "F3: MZ-80A",000H
MESF4:        DW    0D1C3H
              DB    "F4: MZ-700",000H
MESF5:        DW    0D1EBH
              DB    "F5: MZ-80B",000H
MESF6:        DW    0D213H
              DB    000H, "F6: ",000H
MESF7:        DW    0D23BH
              DB    000H, "F7: ",000H
MESF8:        DW    0D263H
              DB    000H, "F8: ",000H
            ENDIF

            ; IY Offset locations points to FD control record.
            ; NTRACK  0FFE0H
            ; NSECT   0FFE1H
            ; BSIZE   0FFE2H
            ; STTR    0FFE4H
            ; STSE    0FFE5H
            ; MTFG    0FFE6H
            ; CLBF0   0FFE7H
            ; CLBF1   0FFE8H
            ; CLBF2   0FFE9H
            ; CLBF3   0FFEAH
            ; RETRY   0FFEBH
            ; DRINO   0FFECH
            ;
            ;     DRIVE NO=DRINO (0-3)
            ;
            ;  CASE OF SEQUENTIAL READ
            ;     DRIVE NO=DRINO (0-3)
            ;     BYTE SIZE     =IY+2,3
            ;     ADDRESS       =IX+0,1
            ;     NEXT TRACK    =IY+0
            ;     NEXT SECTOR   =IY+1
            ;     START TRACK   =IY+4
            ;     START SECTOR  =IY+5
            ;
            ; Floppy record track 1, sector 1:
            ; 0x00         Attribute (1 = machine code).
            ; 0x01 : 0x06  Disk indicator, IPLPRO for bootable disks.
            ; 0x07 : 0x0F  Floppy image name
            ; 0x10 : 0x11 
            ; 0x12 : 0x13  Load address of file.
            ; 0x14 : 0x15  Size of file/boot file.
            ; Boot file commences at track 1, sector 2.
            ; Data is inverted (due to MB8877 controller).
            ;
            ;FD
FD:         LD      IX,IBUFE
            XOR     A
            LD      (0CF1EH),A                                 ; Image load location.
            LD      (0CF1FH),A
            LD      IY,SUMDT
            LD      HL,0100H                                   ; Load one 256 byte sector - the disk record.
            LD      (IY+002H),L
            LD      (IY+003H),H
            CALL    BREAD                                      ; Read the first sector to verify if it is a valid disk.
            LD      HL,IBUFE                                   ; Perform a MASTER CHECK, ie. code 01 + IPLPRO
            LD      DE,IPLMC
            LD      B,006H
MCHECK:     LD      C,(HL)                                     ; Should be 0x1 and IPLPRO at beginning of first track to indicate bootable disk.
            LD      A,(DE)
            CP      C
            JP      NZ,NMASTE
            INC     HL
            INC     DE
            DJNZ    MCHECK                                     
            CALL    LDMSG                                      ; Ok, so bootable, indicate loading.
            LD      HL,FDNAME                                  ; Offset into first sector for name of file.
            LD      E,010H
            LD      C,00AH
            CALL    DISP2                                      ; Display Floppy image name.
            LD      IX,IBADR2
            LD      HL,(0CF14H)                                ; Setup size of image load.
            LD      (IY+002H),L
            LD      (IY+003H),H
            CALL    BREAD
            CALL    MOFF
            JP      NST

NODISK:     LD      HL,MES9
            LD      E,00AH
            LD      C,00DH
            CALL    DISP
            JP      ERR1
            ;
            ; READY CHECK
            ;
READY:      LD      A,(MTFG)                                   ; Motor flag
            RRCA    
            CALL    NC,MTON                                    ; Check if motor is already running (cant read hardware so maintain in memory mirror flag).
            LD      A,(DRINO)                                  ; Get drive number.
            OR      084H                                       ; Ensure the motor on and high select bit are set (Drives 0-3 are represented in hardware as 4-7).
            OUT     (FDC_MOTOR),A                              ; Send to motor/drive select register.
            XOR     A
            CALL    DLY60M                                     ; Small delay to allow the motor to spin up etc.
            LD      HL,00000H
REDY0:      DEC     HL                                         ; Delay loop, 65536 loops checking for the BUSY flag to be reset.
            LD      A,H
            OR      L
            JR      Z,NODISK                                   
            IN      A,(FDC_CR)                                 ; Get controller statue.
            CPL                                                ; Data bus is inverted on original Sharp controller.
            RLCA    
            JR      C,REDY0                                    ; Bit set, controller busy, loop. No new command can be issued whilst the controller is busy.
            LD      A,(DRINO)   
            LD      C,A
            LD      HL,CLBF0                                   ; Get correct control block flag for selected drive.
            LD      B,000H
            ADD     HL,BC
            BIT     0,(HL)                                     ; Check to see if drive calibrated. Exit if it has been calibrated.
            RET     NZ
            CALL    RCLB                                       ; Else call calibration, set flag and exit.
            SET     0,(HL)
            RET     
            ;
            ; MOTOR ON
            ;
MTON:       LD      A,080H                                     ; Spin up motor by enabling motor control.
            OUT     (FDC_MOTOR),A
            LD      B,00AH                                     ; Wait 1 second for spinup.
MTD1:       LD      HL,03C19H
MTD2:       DEC     HL
            LD      A,L
            OR      H
            JR      NZ,MTD2                                    
            DJNZ    MTD1                                       
            LD      A,001H                                     ; Set flag to indicate motor running.
            LD      (MTFG),A
            RET     
            ;
            ; Track SEEK
            ;
SEEK:       LD      A,01BH                                     ; Send seek command to controller, the previous stored track will be searched.
            CPL     
            OUT     (FDC_CR),A
            CALL    BUSY                                       ; Wait until the BUSY flag is cleared.
            CALL    DLY60M
            IN      A,(FDC_STR)                                ; Get status for caller to inspect.
            CPL     
            AND     099H                                       ; Mask Nit Ready, Seek Error, CRC Error, Busy flags, any set the error occurred.
            RET     
            ;
            ;MOTOR OFF
            ;
MOFF:       CALL    DLY1M                                      ; Delay 1ms to allow previous commands to complete.
            XOR     A                                          ; Clear the motor (and drive select) flags.
            OUT     (FDC_MOTOR),A
            LD      (CLBF0),A                                  ; Clear all disk control block flags.
            LD      (CLBF1),A
            LD      (CLBF2),A
            LD      (CLBF3),A
            LD      (MTFG),A
            RET     
            ;
            ; RECALIBRATION
            ;
RCLB:       PUSH    HL                                         ; Recalibration is made by sending the RESTORE command to the controller.
            LD      A,00BH
            CPL     
            OUT     (FDC_CR),A
            CALL    BUSY                                       ; Wait until the BUSY flag is reset.
            CALL    DLY60M
            IN      A,(FDC_STR)                                ; Inspect status, TRACK 0 flag should be set.
            CPL     
            AND     085H
            XOR     004H
            POP     HL
            RET     Z                                          ; If track 0 flag set, exit.
            JP      ERR                                        ; Otherwise display error message as track 0 cannot be located, ie. no disk or corruption.
            ;
            ; BUSY AND WAIT
            ;
BUSY:       PUSH    DE                                         ; Loop 65536 x 7 times for the BUSY flag in the controller to be reset.
            PUSH    HL                                         ; Normally a command would have been sent and this method called.
            CALL    DLY80U
            LD      E,007H
BUSY2:      LD      HL,00000H
BUSY0:      DEC     HL
            LD      A,H
            OR      L
            JR      Z,BUSY1                                    
            IN      A,(FDC_STR)                                ; Get status, invert due to original controller bus being inverted, the test bit 0, ie. BUSY flag.
            CPL     
            RRCA    
            JR      C,BUSY0                                    
            POP     HL
            POP     DE
            RET     

BUSY1:      DEC     E
            JR      NZ,BUSY2                                   
            JP      ERR
            ;
            ; DATA CHECK
            ;
CONVRT:     LD      B,000H
            LD      DE,0010H
            LD      HL,(0CF1EH)
            XOR     A
TRANS:      SBC     HL,DE
            JR      C,TRANS1                                   
            INC     B
            JR      TRANS                                      

TRANS1:     ADD     HL,DE
            LD      H,B                                        ; B contains the track.
            INC     L                                          ; L contains the sector.
            LD      (IY+004H),H
            LD      (IY+005H),L
DCHK:       LD      A,(DRINO)                                  ; Check drive number is valid.
            CP      004H
            JR      NC,DTCK1                                   
            LD      A,(IY+004H)                                ; Check track boundary
            CP      046H
            JR      NC,DTCK1                                   
            LD      A,(IY+005H)                                ; Check sector boundary, cant be less than 1 or greater than 16
            OR      A
            JR      Z,DTCK1                                    
            CP      011H
            JR      NC,DTCK1                                   
            LD      A,(IY+002H)                                ; Check the load size is not zero.
            OR      (IY+003H)
            RET     NZ
DTCK1:      JP      ERR
            ;
            ; SEQUENTIAL READ
            ;
            ;     DRIVE NO=DRINO (0-3)
            ;     BYTE SIZE     =IY+2,3
            ;     ADDRESS       =IX+0,1
            ;     NEXT TRACK    =IY+0
            ;     NEXT SECTOR   =IY+1
            ;     START TRACK   =IY+4
            ;     START SECTOR  =IY+5
BREAD:      DI      
            CALL    CONVRT
            LD      A,00AH                                     ; 10 tries before giving up.
            LD      (RETRY),A
READ1:      CALL    READY                                      ; Perform a recalibration and check for drive readiness.
            LD      D,(IY+003H)                                ; Test to see if the size is a multiple of the sector size, if it isnt then increment sector count.
            LD      A,(IY+002H)                                ; D:A contain the number of bytes to read. D is in 256 blocks.
            OR      A
            JR      Z,RE0                                      
            INC     D
RE0:        LD      A,(IY+005H)                                ; Get start sector.
            LD      (IY+001H),A                                ; Set as next sector.
            LD      A,(IY+004H)                                ; Get start track.
            LD      (IY+000H),A                                ; Set as next track.
            PUSH    IX
            POP     HL
RE8:        SRL     A                                          ; Adjust track to account for heads, so shift right 1 place.
            CPL     
            OUT     (FDC_DR),A
            JR      NC,RE1                                     ; Set side according to track LSB. 1 sets the /SIDE1 signal to select lower head.
            LD      A,001H
            JR      RE2                                        

RE1:        LD      A,000H
RE2:        CPL     
            OUT     (FDC_SIDE),A
            CALL    SEEK                                       ; Seek to track loaded, 0 at start.
            JR      NZ,REE                                     ; SEEK sets the NZ flag if any error occurred.
            LD      C,FDC_DR                                   ; FDC Data register for INI command below.
            LD      A,(IY+000H)                                ; Get track and set.
            SRL     A                                          ; Adjust for two heads.
            CPL     
            OUT     (FDC_TR),A
            LD      A,(IY+001H)                                ; Get sector and set.
            CPL     
            OUT     (FDC_SCR),A
            EXX     
            LD      HL,RE3                                     ; Place address onto stack for RET C in data input loop.
            PUSH    HL
            EXX     
            LD      A,094H                                     ; Command: multiple sector read.
            CPL     
            OUT     (FDC_CR),A
            CALL    WAIT                                       ; Wait until controller finished processing and deactivates busy flag.
RE6:        LD      B,000H
RE4:        IN      A,(FDC_STR)                                ; Read Command Type II Status Register values.
            RRCA    
            RET     C                                          ; Exit if the controller is busy.
            RRCA    
            JR      C,RE4                                      ; Wait for DRQ to go active.          
            INI                                                ; Read byte from controller, decrement B and increment HL.
            JR      NZ,RE4                                     ; B = 0? Loop for the expected number of bytes in sector.
            INC     (IY+001H)
            LD      A,(IY+001H)                                ; Next sector past limit?
            CP      011H                                       ; 16 Sectors per track is the limit.
            JR      Z,RETS                                     ; Complete track read, exit.
            DEC     D                                          ; Next 256 byte block.
            JR      NZ,RE6                                     ; Loop until all bytes we expect are read.
            JR      RE5                                        ; Exit when all are read.

RETS:       DEC     D                                          ; We hit track end so decrement block as per above when we continue to loop.
RE5:        LD      A,0D8H                                     ; Command: FORCED INTERRUPT to abort the multiple sector transfer command.
            CPL     
            OUT     (FDC_CR),A
            CALL    BUSY                                       ; Wait until the BUSY signal goes inactive.
RE3:        IN      A,(FDC_STR)                                ; Get type 4 command status values.
            CPL     
            AND     0FFH                                       ; All flags should be reset if successful, retry otherwise.
            JR      NZ,REE                                     
            EXX     
            POP     HL
            EXX     
            LD      A,(IY+001H)                                ; Get last sector read.
            CP      011H                                       ; Greater than 16?
            JR      NZ,REX                                     ; If less, skip track increment.
            LD      A,001H                                     ; Set to sector 1 and increment track.
            LD      (IY+001H),A
            INC     (IY+000H)
REX:        LD      A,D                                        ; Check D (bytes in 256 byte chunks expected).
            OR      A
            JR      NZ,RE7                                     ; If it is not zero then we need to retry,
            LD      A,080H                                     ; Turn motor off to complete.
            OUT     (FDC_MOTOR),A
            RET     

RE7:        LD      A,(IY+000H)                                ; Retrieve next track and redo the read with remaining bytes.
            JR      RE8                                        

REE:        LD      A,(RETRY)                                  ; The abort (FORCED INTERRUPT) command wasnt successful so retry the complete read.
            DEC     A
            LD      (RETRY),A
            JR      Z,ERR                                      ; Retries expired then raise error.
            CALL    RCLB                                       ; Perform a recalibration before the retry.
            JP      READ1
            ;
            ; Wait until BUSY flag resets - controller has accepted the command, processed it and now ready for data in/out.
            ;
WAIT:       PUSH    DE
            PUSH    HL
            CALL    DLY80U                                     ; Short delay to allow the controller to act on the commmand.
      ;      LD      E,008H                                     ; 8 x 65536 x 1/CPU FREQ max delay. 131ms with a 4MHz clock.
            LD      E,0FFH                                     ; 8 x 65536 x 1/CPU FREQ max delay. 131ms with a 4MHz clock.
WAIT2:      LD      HL,00000H
WAIT0:      DEC     HL
            LD      A,H
            OR      L
            JR      Z,WAIT1             
            IN      A,(FDC_STR)                                ; Get BUSY flag, loop if it is set.
            CPL     
            RRCA    
            JR      NC,WAIT0            
            POP     HL
            POP     DE
            RET     

WAIT1:      DEC     E
            JR      NZ,WAIT2            
            JR      ERR                 

NMASTE:     LD      HL,MES14
            LD      E,007H
            LD      C,01BH
            CALL    DISP
            JR      ERR1                
            ;
            ;                                                  ;
            ;   ERRROR OR BREAK                                ;
            ;                                                  ;
            ;
ERR:        CALL    BOOTER
ERR1:       CALL    MOFF
            LD      SP,SUMDT

TRYAG:      IF      BUILDVERSION = 1
              LD    HL,MES10
              CALL  PRTSTR
              CALL  FDCC                                       ; Check for the FD Interface.
              JR    NZ,MENU1                                   ; NZ = FD not available.
              LD    HL,MES11                                   ; Floppy menu choice.
              CALL  PRTSTR
MENU1:        LD    HL,MES12                                   ; Cassette menu choice.
              CALL  PRTSTR
              LD    HL,MESBOOT                                 ; Boot current RAM program.
              CALL  PRTSTR
              LD    HL,MESTZFS                                 ; TZFS menu choice.
              CALL  PRTSTR
              LD    HL,MESF1                                   ; Function 1 menu choice.
              CALL  PRTSTR
              LD    HL,MESF2                                   ; Function 2 menu choice.
              CALL  PRTSTR
              LD    HL,MESF3                                   ; Function 3 menu choice.
              CALL  PRTSTR
              LD    HL,MESF4                                   ; Function 4 menu choice.
              CALL  PRTSTR
              LD    HL,MESF5                                   ; Function 5 menu choice.
              CALL  PRTSTR
              LD    HL,MESF6                                   ; Function 6 menu choice.
              CALL  PRTSTR
              LD    HL,MESF7                                   ; Function 7 menu choice.
              CALL  PRTSTR
              LD    HL,MESF8                                   ; Function 8 menu choice.
              CALL  PRTSTR
GETCHOICE:    CALL  KEYS1
              BIT   6,A                                        ; F - Floppy disk
              JP    Z,DNO
              BIT   3,A                                        ; C - Cassette.
              JP    Z,CMT                                                                                                                  
              BIT   2,A                                        ; B - Boot current RAM 0x0000 program.
              JP    Z,NST
              BIT   0,A                                        ; / - Boot external rom.
              JP    Z,EXROMT                                                                                                               
              LD    B,016H
              CALL  KEYS
              BIT   4,A                                        ; T - TZFS Monitor
              JP    Z,TZFS
              BIT   6,A                                        ; V - Verification Test
              JP    Z,VTEST
              LD    B,010H
              CALL  KEYS
              BIT   0,A                                        ; F1
              JP    Z,FUNC_F1
              BIT   1,A                                        ; F2
              JP    Z,FUNC_F2
              BIT   2,A                                        ; F3
              JP    Z,FUNC_F3
              BIT   3,A                                        ; F4
              JP    Z,FUNC_F4
              BIT   4,A                                        ; F5
              JP    Z,FUNC_F5
              BIT   5,A                                        ; F6
              JP    Z,FUNC_F6
              BIT   6,A                                        ; F7
              JP    Z,FUNC_F7
              BIT   7,A                                        ; F8
              JP    Z,FUNC_F8
              JR    GETCHOICE
            ELSE
              CALL  FDCC                                       ; Check for the FD Interface.
              JR    NZ,TRYAG3                                  ; NZ = FD not available.
              LD    HL,MES10
              LD    E,05AH
              LD    C,00CH
              CALL  DISP2
              LD    E,0ABH
              LD    C,011H
              CALL  DISP2
              LD    E,0D3H
              LD    C,00FH
              CALL  DISP2
TRYAG1:       CALL  KEYS1
              BIT   3,A
              JP    Z,CMT
              BIT   6,A
              JR    Z,DNO               
              JR    TRYAG1              
            ENDIF

DNO:        LD      HL,MES13
            LD      E,00AH
            LD      C,00FH
            CALL    DISP
DNO10:      LD      D,012H
            CALL    DNO0
            JR      NC,DNO3             
            LD      D,018H
            CALL    DNO0
            JR      NC,DNO3             
            JR      DNO10               

DNO3:       LD      A,B
            LD      (DRINO),A
            JP      FD

TRYAG3:     LD      HL,MES15
            LD      E,054H
            LD      C,01DH
            CALL    DISP2
TRYAG4:     LD      B,006H
TRYAG5:     CALL    KEYS
            BIT     3,A
            JP      Z,CMT
            JR      TRYAG5              

DNO0:       IN      A,(PIOA)
            AND     0F0H
            OR      D
            OUT     (PIOA),A
            IN      A,(PIOB)
            LD      B,000H
            LD      C,004H
            RRCA    
DNO1:       RRCA    
            RET     NC
            INC     B
            DEC     C
            JR      NZ,DNO1             
            RET     
            ;
            ;  TIME DELAY (1M &60M &80U )
            ;
DLY80U:     PUSH    DE
            LD      DE,000DH
            JP      DLYT

DLY1M:      PUSH    DE
            LD      DE,L0082
            JP      DLYT

DLY60M:     PUSH    DE
            LD      DE,01A2CH
DLYT:       DEC     DE
            LD      A,E
            OR      D
            JR      NZ,DLYT             
            POP     DE
            RET     
            ;
            ;
            ;                                                  ;
            ;   INTRAM EXROM                                   ;
            ;                                                  ;
            ;
EXROMT:     LD      HL,IBADR2
            LD      IX,EROM1
            JR      SEROMA              

EROM1:      IN      A,(0F9H)                                   ; Check to see if the external ROM has been installed.
            CP      000H
            JP      NZ,NKIN                                    ; Byte is not 0, no rom so exit.
            LD      IX,EROM2
ERMT1:      JR      SEROMA              

EROM2:      IN      A,(0F9H)
            LD      (HL),A
            INC     HL
            LD      A,L
            OR      H
            JR      NZ,ERMT1            
            OUT     (0F8H),A
            JP      NST

            ; Output a 16bit address to the external ROM control registers.
SEROMA:     LD      A,H
            OUT     (0F8H),A
            LD      A,L
            OUT     (0F9H),A
            LD      D,004H
SEROMD:     DEC     D                                          ; Short pause for the address to latch.
            JR      NZ,SEROMD           
            JP      (IX)                                       ; Pass control to the function provided in IX for address evaluation.

            ;
            ; Load option extensions under the tranZPUter.
            ;
TZFS:       IF      BUILDVERSION = 1
              JP    TRYAG
            ENDIF

FUNC_F1:    IF      BUILDVERSION = 1
              LD    HL,FN_1
              CALL  SDLOADFILE
              JP    TRYAG
FN_1:         DB    "BASIC MZ-1Z001",NULL,NULL,NULL
            ENDIF

FUNC_F2:    IF      BUILDVERSION = 1
              LD    HL,FN_2
              CALL  SDLOADFILE
              JP    TRYAG
FN_2:         DB    "BASIC MZ-1Z002",NULL,NULL,NULL
            ENDIF

FUNC_F3:    IF      BUILDVERSION = 1
              CALL  SETMZ80A
              JP    TRYAG
            ENDIF

FUNC_F4:    IF      BUILDVERSION = 1
              CALL  SETMZ700
              JP    TRYAG
            ENDIF

FUNC_F5:    IF      BUILDVERSION = 1
              CALL  SETMZ80B
              JP    TRYAG
            ENDIF

FUNC_F6:    IF      BUILDVERSION = 1
              LD    HL,FN_6
              CALL  SDLOADFILE
              JP    TRYAG
FN_6:         DB    NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL
            ENDIF

FUNC_F7:    IF      BUILDVERSION = 1
              LD    HL,FN_7
              CALL  SDLOADFILE
              JP    TRYAG
FN_7:         DB    NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL
            ENDIF

            ; A simple graphics test routine, not optimised, just to indicate if the graphics are working on the tranZPUter.
FUNC_F8:    IF      BUILDVERSION = 1
              LD    A,0AFH                                     ; Setup to enable FPGA video.
              OUT   (06EH),A
              LD    A,000H
              OUT   (0B9H),A
              LD    A,07FH  
              OUT   (0B8H),A
              LD    A,0D3H              
              OUT   (PIOA),A
F8CLR:        LD    HL,0D800H                                   
              LD    A,0E0H 
F8CLR1:       LD    (HL),070H                                  ; Load zero's
              INC   HL                                                                                                                      
              CP    H                                                                                                                       
              JR    NZ,F8CLR1            
              ;
F8LOOP:       LD    A,001H                                     ; Select BLUE graphics RAM bank. 
              OUT   (GRAMCOLRSEL),A
              CALL  FUNCFILLW
              LD    A,002H                                     ; Select RED graphics RAM bank. 
              OUT   (GRAMCOLRSEL),A
              CALL  FUNCFILLW
              LD    A,003H                                     ; Select GREEN graphics RAM bank. 
              OUT   (GRAMCOLRSEL),A
              CALL  FUNCFILLW
              JR    F8LOOP

FUNCFILLW:    EX    AF,AF'                                     ; 2nd bank
              XOR   A
FUNCFILLW1:   EX    AF,AF'                                     ; 1st bank
              CALL  FUNCFILL
              EX    AF,AF'                                     ; 2nd bank
              INC   A
              JR    NZ,FUNCFILLW1
              EX    AF,AF'                                     ; 1st bank
              CALL  FUNCFILL
              RET

FUNCFILL:     DI                                               
              LD    HL,GRAMADDRL                               ; Base of Video Graphics RAM in address space.
              IN    A,(PIOA)                                   ; Read the PIO register and enable Graphics RAM           
              SET   7,A                                        
              RES   6,A                                        
              OUT   (PIOA),A                                   
              LD    DE,GRAMADDRL + 1
              EX    AF,AF'
              LD    (HL),A
              LD    BC,03E7FH
              LDIR  
              EX    AF,AF'
              ;
FUNCFILL2:    IN    A,(PIOA)
              RES   7,A                                        ; Read the PIO and disable Video/Graphics RAM (use normal RAM).
              SET   6,A
              OUT   (PIOA),A
              EI      
              RET     
            ENDIF

            ;-------------------------------------------------------------------------------
            ; SERVICE COMMAND METHODS
            ;-------------------------------------------------------------------------------

SDLOADFILE: IF      BUILDVERSION = 1
              ; HL Contains the source filename to use, copy into structure.
              LD    DE,TZSVC_FILENAME
              LD    BC,TZSVCFILESZ
              LDIR                                             ; Copy in the MZF filename.
              LD    HL,00000H                                  ; Setup the load address to 0x0000 = default load address in IPL mode.
              LD    (TZSVC_LOADADDR),HL
              ;
              LD    A,TZSVC_FTYPE_MZF                          ; Default to full file load.
              LD    (TZSVC_FILE_TYPE),A

              LD    A,0FFH                                     ; We have to use filenames not index numbers so mark as unused.
              LD    (TZSVC_FILE_NO), A 

              LD    A,000H                                     ; tranZPUter memory is target for file load.
              LD    (TZSVC_MEM_TARGET), A

              LD    A,TZSVC_CMD_LOADFILE
              LD    (TZSVCCMD), A                              ; Load up the command into the service record.
              CALL  SVC_CMD                                    ; And make communications with the I/O processor, returning with the required record.
              OR    A
              JR    Z, SDLOADFIL2
              LD    HL,SVCIOERR
SDLOADFIL1:   CALL  PRTSTR
              RET
SDLOADFIL2:   LD    A,(TZSVCRESULT)                            ; Check result, non zero will be a file error.
              OR    A
              LD    HL,SVCFILERR
              JR    NZ,SDLOADFIL1
              ;
              JP    NST                                        ; Initiate a normal state restart to run the loaded program.
            ENDIF

            ;----------------------------------------------
            ; Hardware Emulation Mode Activation Routines.
            ;----------------------------------------------

SETMZ80K:   IF      BUILDVERSION = 1
              LD    D, TZSVC_CMD_EMU_SETMZ80K                             ; We need to ask the K64F to switch to the Sharp MZ80K emulation as it involves loading ROMS.
              JR    SETEMUMZ
            ENDIF
SETMZ80C:   IF      BUILDVERSION = 1
              LD    D, TZSVC_CMD_EMU_SETMZ80C
              JR    SETEMUMZ
            ENDIF
SETMZ1200:  IF      BUILDVERSION = 1
              LD    D, TZSVC_CMD_EMU_SETMZ1200
              JR    SETEMUMZ
            ENDIF
SETMZ80A:   IF      BUILDVERSION = 1
              LD    D, TZSVC_CMD_EMU_SETMZ80A
              JR    SETEMUMZ
            ENDIF
SETMZ700:   IF      BUILDVERSION = 1
              LD    D, TZSVC_CMD_EMU_SETMZ700
              JR    SETEMUMZ
            ENDIF
SETMZ1500:  IF      BUILDVERSION = 1
              LD    D, TZSVC_CMD_EMU_SETMZ1500
              JR    SETEMUMZ
            ENDIF
SETMZ800:   IF      BUILDVERSION = 1
              LD    D, TZSVC_CMD_EMU_SETMZ800
              JR    SETEMUMZ
            ENDIF
SETMZ80B:   IF      BUILDVERSION = 1
              LD    D, TZSVC_CMD_EMU_SETMZ80B
              JR    SETEMUMZ
            ENDIF
SETMZ2000:  IF      BUILDVERSION = 1
              LD    D, TZSVC_CMD_EMU_SETMZ2000
              JR    SETEMUMZ
            ENDIF
SETMZ2200:  IF      BUILDVERSION = 1
              LD    D, TZSVC_CMD_EMU_SETMZ2200
              JR    SETEMUMZ
            ENDIF
SETMZ2500:  IF      BUILDVERSION = 1
              LD    D, TZSVC_CMD_EMU_SETMZ2500
              JR    SETEMUMZ
            ENDIF

SETEMUMZ:   IF      BUILDVERSION = 1
              IN    A,(CPUINFO)                                           ; Verify that the FPGA has emuMZ capabilities.
              LD    C,A
              AND   CPUMODE_IS_SOFT_MASK
              CP    CPUMODE_IS_SOFT_AVAIL
              JR    NZ,SOFTCPUERR
              LD    A,C
              AND   CPUMODE_IS_EMU_MZ
              JR    Z,NOEMUERR 
             ;LD    L,VMMODE_VGA_640x480                                  ; Enable VGA mode for a better display.
             ;CALL  SETVGAMODE1
              ;
              PUSH  DE                                                    ; Setup the initial video mode based on the required emulation.
              LD    A,D
              SUB   TZSVC_CMD_EMU_SETMZ80K
              LD    L,A
              LD    H,0
             ;CALL  SETVMODE0
              POP   DE
              ;
              LD    A, D                                                  ; Load up the required emulation mode.
              CALL  SVC_CMD
              OR    A
              JR    NZ,SETT80ERR
              HALT
SOFTCPUERR:   LD    HL,SVCNOCPUERR
              JR    EMUMZERR
SETT80ERR:    LD    HL,SVCT80ERR
              JR    EMUMZERR
NOEMUERR:     LD    HL,SVCNOEMUERR
EMUMZERR:     CALL  PRTSTR
              RET
            ENDIF

            ; Method to send a command to the I/O processor and verify it is being acted upon.
            ; THe method, after sending the command, polls the service structure result to see if the I/O processor has updated it. If it doesnt update the result
            ; then after a period of time the command is resent. After a number of retries the command aborts with error. This is needed in case of the I/O processor crashing
            ; we dont want the host to lock up.
            ;
            ; Inputs:
            ;      A = Command.
            ; Outputs:
            ;      A = 0 - Success, command being processed.
            ;      A = 1 - Failure, no contact with I/O processor.
            ;      A = 2 - Failure, no result from I/O processor, it could have crashed or SD card removed!
SVC_CMD:    IF      BUILDVERSION = 1
              PUSH  BC
              LD    (TZSVCCMD), A                              ; Load up the command into the service record.
              LD    A,TZSVC_STATUS_REQUEST
              LD    (TZSVCRESULT),A                            ; Set the service structure result to REQUEST, if this changes then the K64 is processing.

              LD    BC, TZSVCWAITIORETRIES                     ; Safety in case the IO request wasnt seen by the I/O processor, if we havent seen a response in the service

SVC_CMD1:     PUSH  BC
              LD    A,(TZSVCCMD)
              OUT   (SVCREQ),A                                 ; Make the service request via the service request port.

              LD    BC,0
SVC_CMD2:     LD    A,(TZSVCRESULT)
              CP    TZSVC_STATUS_REQUEST                       ; I/O processor when it recognises the request sets the status to PROCESSING or gives a result, if this hasnt occurred the the K64F hasnt begun processing.
              JR    NZ, SVC_CMD3
              DEC   BC
              LD    A,B
              OR    C
              JR    NZ, SVC_CMD2
              POP   BC
              DEC   BC
              LD    A,B
              OR    C
              JR    NZ,SVC_CMD1                                ; Retry sending the I/O command.
              ;
              PUSH  DE
              PUSH  HL
              LD    HL,SVCIOERR
              CALL  PRTSTR
              POP   HL
              POP   DE
              POP   BC
              LD    A,1                                        ; No response, error.
              RET
SVC_CMD3:     POP   BC
              ;
              LD    BC,TZSVCWAITCOUNT                          ; Number of loops to wait for a response before setting error.
SVC_CMD4:     PUSH  BC
              LD    BC,0
SVC_CMD5:     LD    A,(TZSVCRESULT)
              CP    TZSVC_STATUS_PROCESSING                    ; Wait until the I/O processor sets the result, again timeout in case it locks up.
              JR    NZ, SVC_CMD6
              DEC   BC
              LD    A,B
              OR    C
              JR    NZ,SVC_CMD5
              POP   BC
              DEC   BC
              LD    A,B
              OR    C
              JR    NZ,SVC_CMD4                                ; Retry polling for result.
              ;
              PUSH  DE
              PUSH  HL
              LD    HL,SVCRESPERR
              CALL  PRTSTR
              POP   HL
              POP   DE
              POP   BC
              LD    A,2
              RET
SVC_CMD6:     XOR   A                                          ; Success.
              POP   BC
              POP   BC
              RET
            ENDIF

SVCIOERR:   IF      BUILDVERSION = 1
              DW    0D00AH
              DB    "I/O Error, time out!", NULL
            ENDIF
SVCRESPERR: IF      BUILDVERSION = 1
              DW    0D00AH
              DB    "I/O Response Error, time out!", NULL
            ENDIF
SVCFILERR:  IF      BUILDVERSION = 1
              DW    0D00AH
              DB    "File not found error!", NULL
            ENDIF
SVCNOCPUERR:IF      BUILDVERSION = 1
              DW    0D00AH
              DB    "No SoftCPU available in FPGA!", NULL
            ENDIF
SVCT80ERR:  IF      BUILDVERSION = 1
              DW    0D00AH
              DB    "Error, failed to switch to T80 CPU!", NULL
            ENDIF
SVCNOEMUERR:IF      BUILDVERSION = 1
              DW    0D00AH
              DB    "No emuMZ available in FPGA!", NULL
            ENDIF

            ; Method to perform a series of dev tests to visually or physically check CPLD/FPGA/firmware changes.
VTEST:      IF      BUILDVERSION = 1
              LD    A,0AFH                                     ; Setup to enable FPGA video.
              OUT   (06EH),A
              LD    A,0D3H                                     ; Page in character video ram.
              OUT   (PIOA),A
VTF0:         LD    HL,0D000H                                   
              LD    A,0D8H                                     ; Set to character VRAM top address.
VTF1:         LD    (HL),030H                                  ; Load zero's
              INC   HL                                                                                                                      
              CP    H                                                                                                                       
              JR    NZ,VTF1            
              LD    A,0E0H
VTF2:         LD    (HL),071H                                  ; Set blue background white foreground.
              INC   HL                                                                                              
              CP    H                                                                                                                                 
              JR    NZ,VTF2            
              LD    A,031H
              PUSH  AF
VTF3:         LD    HL,0D028H
              LD    DE,0D000H
VTF4:         LD    A,(HL)
              LD    (DE),A
              INC   HL
              INC   DE
              LD    A,0D4H
              CP    H
              JR    NZ,VTF4
              LD    HL,0D3C0H
              LD    A,0D8H
              EX    AF,AF'
              POP   AF
VTF5:         LD    (HL),A
              EX    AF,AF'
              INC   HL
              CP    H
              JR    Z,VTF6
              EX    AF,AF'
              JR    VTF5
VTF6:         EX    AF,AF'
              INC   A
              PUSH  AF
              LD    HL,0D000H
              LD    A,(HL)
              LD    C,A
VTF7:         LD    A,(HL)
              CP    C
              JR    NZ,VTFER
              INC   HL
             ;LD    A,H
             ;CP    0D3H
             ;JR    NZ,VTF7
              LD    A,L
              CP    027H
              JR    NZ,VTF7
              POP   AF
              OR    A
              JR    Z,VTF8
              PUSH  AF
              JR    VTF3
VTF8:         LD    C,0
VTF9:         LD    HL,0D000H
              LD    A,0D4H
VTF10:        LD    (HL),C
              INC   HL
              CP    H
              JR    NZ,VTF10
VTF11:        LD    HL,0D000H
VTF12:        LD    A,(HL)
              CP    C
              JR    NZ,VTFER
              INC   HL
              LD    A,H
              CP    0D4H
              JR    NZ,VTF12
              INC   C
              JR    VTF9

VTFER:        JP    GETCHOICE
            ENDIF

            ;-------------------------------------------------------------------------------
            ; END OF SERVICE COMMAND METHODS
            ;-------------------------------------------------------------------------------

            ; Align to rom size.
            IF      BUILDVERSION = 1
              ; TranZPUter virtual rom can be any size upto 64K, currently = 4K.
              DS    01000H - 1 - ($ + 01000H - 1) % 01000H, 0FFh
            ELSE
              ; Original ROM is 2K in size.
              DS    0800H - 1 - ($ + 0800H - 1) % 0800H, 0FFh
            ENDIF

            ; Configuration for TZFS service structure memory allocation.
TZSVCMEM:   EQU     07D80H                                               ; Start of a memory structure used to communicate with the K64F I/O processor for services such as disk access.

            ; Bring in the TZFS definitions and service structure definition,
            INCLUDE "tzfs_definitions.asm"
            INCLUDE "tzfs_svcstruct.asm"


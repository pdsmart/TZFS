; -----------------------------
; PLE-monitor   CMT-driver
; FI:M-CMT   ver 0.1  6.05.84
; -----------------------------
;
        INCLD  MACRO
;
$CMT:   ENT
        DEFW   $RS             ;###diff Lx
        DEFM   "CMT"
        DEFB   0
        DEFB   5FH             ;Seq, W, R
$CMTF2: DEFB   C0H             ;CMT, 1OPN
        DEFB   0
        DEFW   CTINI           ;INIT
        DEFW   CTRINF          ;RO
        DEFW   CTWINF          ;WO
        DEFW   .RET            ;START
        DEFW   256             ;Block/byte
        DEFW   CTRDAT          ;INP
        DEFW   CTWDAT          ;OUT
        DEFW   0               ;DELETE
        DEFW   0               ;WDIR
        DEFW   ER59            ;FREE
;
CTINI:  TEST1  "T"             ; Change EOF process
        CALL   TEST1
        DEFB   "T"
        ENDM
        LD     HL,$CMTF2
        SET    ##EOFE,M        ; Tape BASIC mode
        RET    Z
        RES    ##EOFE,M        ; Disk BASIC mode
        OR     A
        RET
;
CTWINF: CALL   PUSHR
        LD     DE,IBUFE
        LD     A,M
        LD     C,5
        CP     2               ; BTX 2 ==> 5
        JR     Z,CTWF2
        LD     C,4
        CP     3               ; BSD 3 ==> 4
        JR     Z,CTWF2
        LD     C,A
;
CTWF2:  LD     A,C
        LD     (DE),A
        INC    HL
        INC    DE
        LD     BC,17
        LDIR
        INC    HL
        INC    HL
        LD     BC,6
        LDIR
        LD     B,128-24
        CALL   ?CLRDE
        LD     HL,IBUFE

        LD     BC,128
        CALL   SAVE1
        JR     CTWD9
;
CTWDAT: CALL   SAVE2
;
CTWD9:  JP     C,BREAKX        ; break!
        RET                    ; ok!
;-------------------------------
;
; read inf
;   ent HL:adrs
;-------------------------------
CTRINF: LD     A,37H           ; SCF
        LD     (CTRDAT),A
        PUSH   HL
        LD     HL,IBUFE
        LD     BC,128
        CALL   LOAD1
        JR     C,CTERR         ; error or break
        LD     DE,FINMES       ; "Found"
        CALL   FNMPRT          ; ? file name
        POP    DE
        LD     A,(ZLOG)
        OR     A               ; ROPEN or LOAD?
        LD     A,M
        JP     NZ,CTRI1        ; R
        LD     C,2             ; L BTX 5 ==> 2
        CP     5
        JR     Z,CTRI2
CTRI1:  LD     C,3             ;   BSD 4 ==> 3
        CP     4
        JR     Z,CTRI2
        LD     C,A
        SUB    2
        CP     2
        JP     C,ER61          ; file mode error!
;
CTRI2:  LD     A,C
        LD     (DE),A
        INC    HL
        INC    DE
        LD     BC,17
        LDIR
        XOR    A
        LD     B,2
        CALL   ?CLRDE
        LD     BC,6
        LDIR
        LD     B,32-18-2-6
        JP     ?CLRDE
;----------------------------------
;
;  read data
;    ent HL:adrs
;        BC:byte size
;----------------------------------
CTRDAT: XOR    A               ; XOR A / SCF
        JR     NC,CTRD2
        LD     A,AFH           ;XOR A

        LD     (CTRDAT),A
        PUSH   HL              ; first time only
        LD     HL,ELMD
        LD     DE,LDNGMS       ; "Loading"
        CALL   FNMPRT          ; ? file name
        POP    HL
;
CTRD2:  CALL   LOAD2
        RET    NC              ; ok!
;
CTERR:  CP     2
        JP     NZ,BREAKX       ; break!
        LD     A,70+80H
        JP     ERRORJ          ; error!
;-----------------------------------
;
; CMT SAVE
;
;-----------------------------------
SAVE1:  ENT                    ; Inf.
        LD     A,CCH
        JR     SAVE3
;
SAVE2:  ENT                    ; Data
        LD     A,53H
;
SAVE3:  LD     (SPSV+1),SP     ;;;
        LD     SP,IBUFE        ;;;
        PUSH   DE
        LD     E,A
        LD     D,D7H           ; 'W'=Dreg.
        LD     A,B
        OR     C
        JR     Z,RET1
        CALL   CKSUM           ; check sum set
        CALL   MOTOR           ; motor on
        JR     C,WRI3          ; break!
        LD     A,E
        CP     CCH
        JR     NZ,WRI2         ; write Data
        PUSH   DE
        LD     DE,WRTMES       ; "Writing"
        CALL   FNMPRT          ; ? file name
        POP    DE
;
WRI2:   DI
        CALL   GAP             ; write gap
        CALL   NC,WTAPE        ; write Inf. or Data
;
WRI3:   DI
        CALL   MSTOP           ; motor off
;
RET1:   POP    DE
;
SPSV:   LD     SP,0            ;xxx
        PUSH   AF
        SVC    .EI
        RST    3
        DEFB   .EI
        ENDM

        POP    AF
        RET
;--------------------------------
;
; CMT LOAD
;
;--------------------------------
LOAD1:  ENT                    ; Inf.
        LD     A,CCH
        JR     LOAD3
;
LOAD2:  ENT                    ; Data
        LD     A,53H
LOAD3:  LD     (SPSV+1),SP     ;;;
        LD     SP,IBUFE        ;;;
        PUSH   DE
        LD     D,D2H           ; 'L'->Dreg
        LD     E,A
        LD     A,B
        OR     C
        JR     Z,RET1
        CALL   MOTOR           ; motor on
        DI
        CALL   NC,TMARK        ; read gap & tape mark
        CALL   NC,RTAPE        ; read Inf. or Data
        JR     WRI3
;-------------------------------------
;
; CMT VERIFY
;
;-------------------------------------
CMTVRF: ENT                    ; Data
        PUSH   HL
        LD     DE,VFNGMS       ; "Verifying"
        LD     HL,ELMD
        CALL   FNMPRT          ; ? file name
        POP    HL
        CALL   LOAD?2
        RET    NC              ; ok!
        CP     2
        JP     NZ,BREAKX       ; break!
        LD     A,3+80H
        JP     ERRORJ          ; error!
;
LOAD?2: ENT
        LD     (SPSV+1),SP     ;;;
        LD     SP,IBUFE        ;;;
        PUSH   DE
        LD     D,D2H
        LD     E,53H
        LD     A,B
        OR     C
        JR     Z,RET1
        CALL   CKSUM           ; check sum set
        CALL   MOTOR           ; motor on
        DI
;
        CALL   NC,TMARK        ; read gap & tape mark
        CALL   NC,TVRFY        ; verify
        JR     WRI3

;----------------------------------------
; motor on
;    exit CF=0:ok
;         CF=1:break
;----------------------------------------
MOTOR:  CALL   PUSHR
        SVC    .DI
        RST    3
        DEFB   .DI
        ENDM
        LD     A,F8H
        OUT    (LSD0),A        ; break set
        LD     B,10
;
MOT1:   IN     A,(LSD2)
        AND    10H
        JR     Z,MOT4
;
MOT2:   LD     B,FFH           ; 2sec delay
;
MOT3:   CALL   DLY7            ; 7ms delay
        DJNZ   MOT3            ; motor entry adjust
        XOR    A               ; CF=0
        RET
;
MOT4:   LD     A,6
        OUT    (LSD3),A
        INC    A
        OUT    (LSD3),A
        DJNZ   MOT1
        LD     A,(CMTMSG)
        OR     A
        JR     NZ,MOT6
        SVC    .CR2
        RST    3
        DEFB   .CR2
        ENDM
        LD     A,7FH           ; Play mark
        SVC    .CRT1X
        RST    3
        DEFB   .CRT1X
        ENDM
        LD     A," "
        SVC    .CRT1C
        RST    3
        DEFB   .CRT1C
        ENDM
        LD     A,D
        CP     D7H             ; 'W'
        LD     DE,RECMES       ; "RECORD."
        JR     Z,MOT5          ; write
        LD     DE,PLYMES       ; "PLAY"
;
MOT5:   SVC    .CRTMS
        RST    3
        DEFB   .CRTMS
        ENDM
        SVC    .CR2
        RST    3
        DEFB   .CR2

        ENDM
;
MOT6:   IN     A,(LSD2)
        AND    10H
        JR     NZ,MOT2
        IN     A,(LSD1)
        AND    80H
        JR     NZ,MOT6
        SCF                    ; CF=1,break!
        RET
;-----------------------------------
;
; write tape
;
;   in   BC=byte size
;        HL=adr.
;
;   exit CF=0:ok.
;        CF=1:break
;-----------------------------------
WTAPE:  PUSH   DE
        PUSH   BC
        PUSH   HL
        LD     D,2             ; repeat set
        LD     A,F8H
        OUT    (LSD0),A        ; break set
;
WTAP1:  LD     A,M
        CALL   WBYTE           ; 1 byte write
        IN     A,(LSD1)
        AND    80H             ; break check
        SCF
        JR     Z,RTP5          ; break!
        INC    HL
        DEC    BC
        LD     A,B
        OR     C
        JR     NZ,WTAP1
        LD     HL,(SUMDT)      ; check sum write
        LD     A,H
        CALL   WBYTE           ; high
        LD     A,L
        CALL   WBYTE           ; low
        CALL   LONG
        XOR    A
        DEC    D
        JR     Z,RTP5          ; ok!
        LD     B,A             ; Breg=256
;
WTAP2:  CALL   SHORT           ; write short 256
        DJNZ   WTAP2
        POP    HL
        POP    BC
        PUSH   BC
        PUSH   HL
        JR     WTAP1           ; repeat
;-------------------------------------
;
; read tape
;

;   in   BC=byte size
;        HL=load adr.
;
;   exit CF=0:ok
;        CF=1,Acc=2:error
;        else:break
;-------------------------------------
RTAPE:  PUSH   DE
        PUSH   BC
        PUSH   HL
        LD     D,2             ; repeat set
;
RTP1:   CALL   EDGE            ; edge search:(49c)
        JR     C,RTP5          ; break!:7c
; reading point search
        CALL   DLY3            ; 17c (1232c)
        IN     A,(LSD2)
        AND    20H
        JR     Z,RTP1          ; again
        LD     HL,0
        LD     (SUMDT),HL
        POP    HL
        POP    BC
        PUSH   BC
        PUSH   HL
;
RTP3:   CALL   RBYTE           ; 1 byte read
        JR     C,RTP5          ; error!
        LD     M,A             ; data->(mem.)
        INC    HL
        DEC    BC
        LD     A,B
        OR     C
        JR     NZ,RTP3
        LD     HL,(SUMDT)      ; check sum
        CALL   RBYTE           ; high
        JR     C,RTP5          ; error!
        CP     H
        JR     NZ,RTP6         ; error!
        CALL   RBYTE           ; low
        JR     C,RTP5          ; error!
        CP     L
        JR     NZ,RTP6         ; error!
;
RTP4:   XOR    A
;
RTP5:   POP    HL
        POP    BC
        POP    DE
        RET
;
RTP6:   DEC    D
        JR     NZ,RTP1         ; repeat
;
VFERR:  LD     A,2             ; error
        SCF
        JR     RTP5
;-------------------------------------
;
; verify tape

;
;   in   BC=byte size
;        HL=adr.
;
;   exit CF=0:ok
;        CF=1,Acc=2:error
;        else:break
;-------------------------------------
TVRFY:  PUSH   DE
        PUSH   BC
        PUSH   HL
        LD     D,2             ; repeat set
;
TVF1:   CALL   EDGE            ; edge search:(49c)
        JR     C,RTP5          ; break!:7c
; reading point search
        CALL   DLY3            ; 17c (1232c)
        IN     A,(LSD2)
        AND    20H
        JR     Z,TVF1          ; again
        POP    HL
        POP    BC
        PUSH   BC
        PUSH   HL
;
TVF2:   CALL   RBYTE           ; 1 byte read
        JR     C,RTP5          ; error!
        CP     M               ; CP A.(mem.)
        JR     NZ,VFERR        ; verify error!
        INC    HL
        DEC    BC
        LD     A,B
        OR     C
        JR     NZ,TVF2
        LD     HL,(CSMDT)      ; Check sum.
        CALL   RBYTE           ; high
        JR     C,RTP5          ; error!
        CP     H
        JR     NZ,VFERR        ; error!
        CALL   RBYTE           ; low
        JR     C,RTP5          ; error!
        CP     L
        JR     NZ,VFERR        ; error!
        DEC    D
        JR     NZ,TVF1         ; repeat
        JR     RTP4            ; ok!
;
RECMES: DEFM   'RECORD.'

PLYMES: DEFM   'PLAY'
        DEFB   0
;--------------------------------------
;
; file name print
;--------------------------------------
FNMPRT: LD     A,(CMTMSG)
        OR     A
        RET    NZ
        SVC    .CR2
        RST    3

        DEFB   .CR2
        ENDM
        SVC    .CRTMS
        RST    3
        DEFB   .CRTMS
        ENDM
        PUSH   HL
        INC    HL
        LD     A,'"'
        SVC    .CRT1C
        RST    3
        DEFB   .CRT1C
        ENDM
        LD     D,16
;
FNMLP:  LD     A,M
        CP     0DH
        JR     Z,FNMLE
        SVC    .CRT1C
        RST    3
        DEFB   .CRT1C
        ENDM
        INC    HL
        DEC    D
        JR     NZ,FNMLP
;
FNMLE:  LD     A,'"'
        SVC    .CRT1C
        RST    3
        DEFB   .CRT1C
        ENDM
        SVC    .CR2
        RST    3
        DEFB   .CR2
        ENDM
        POP    HL
        RET
;
WRTMES: DEFM   'WRITING   '


        DEFB   0
FINMES: DEFM   'FOUND     '


        DEFB   0
LDNGMS: DEFM   'LOADING   '


        DEFB   0
VFNGMS: DEFM   'VERIFYING '


        DEFB   0
;
;
;-----------------------------------------
;
; tape format
;

;          <LONG>       <SHORT>
;      <460us><496us><240us>  <264us>
;      b      b      b  b     b  b
;      gxxxxxx°      gxx°  gxx°  g
; xxxxxt    b hxxxxxxt  hxxt  hxxt
;      b    b        b    b
;      b    b        b    b
;      / /  /        / /  /
;      ! ! Read point! ! Read point
;      ! 368us       ! 368us
;      Read edge     Read edge
;
;-----------------------------------------
;
; Information format  : Data format
;                     :
; * gap               : * gap
;     short 10 sec    :     short 5 sec
;           (22000)   :           (11000)
; * tape mark         : * tape mark
;     long  40        :     long  20
;     short 40        :     short 20
; * long 1            : * long 1
; * Information       : * Data
;               block :             block
;     (128 bytes)     :     (???? bytes)
; * check sum         : * check sum
;     (2 bytes)       :     (2 bytes)
; * long 1            : * long 1
; * short 256         : * short 256
; * Information       : * Data
;               block :             block
;     (128 bytes)     :     (???? bytes)
; * check sum         : * check sum
;     (2 bytes)       :     (2 bytes)
; * long 1            : * long 1
;
;-----------------------------------------
;
;
;   EDGE   (tape data edge search)
;          (85c+111c)/4= 49 clock
;
;   exit CF=0:ok
;        CF=1:break
;
EDGE:   LD     A,F8H
        OUT    (LSD0),A        ; break set
        NOP
;
EDG1:   IN     A,(LSD1)
        AND    81H             ; shift & break
        JR     NZ,EDG2
        SCF
        RET
;
EDG2:   IN     A,(LSD2)        ; 11c
        AND    20H             ; 7c
        JR     NZ,EDG1         ; CSTR D5=0: 7c/12c
;

EDG3:   IN     A,(LSD1)        ; 11c
        AND    81H             ; 7c
        JR     NZ,EDG4         ; 7c/12c
        SCF
        RET
;
EDG4:   IN     A,(LSD2)        ; 7c
        AND    20H             ; 7c
        JR     Z,EDG3          ; CSTR D5=1: 7c/12c
        RET                    ; 10c
;--------------------------------------
;
;   1 byte read
;
;     exit  SUMDT=Store
;           CF=1:break
;           CF=0:data=Acc
;--------------------------------------
RBYTE:  PUSH   DE
        PUSH   BC
        PUSH   HL
        LD     HL,0800H        ; 8 repeat set
;
RBY1:   CALL   EDGE            ; edge search:(49c)
        JP     C,TM4           ; break!:7c
; reading point search:17c(1232c)
        CALL   DLY3            ; 17c (1232c)
        IN     A,(LSD2)        ; data read
        AND    20H             ; CF=0
        JP     Z,RBY2          ; again
        PUSH   HL
        LD     HL,(SUMDT)      ; check sum set
        INC    HL
        LD     (SUMDT),HL
        POP    HL
        SCF                    ; CF=1
;
RBY2:   LD     A,L
        RLA                    ; rotate left
        LD     L,A
        DEC    H
        JP     NZ,RBY1         ; repeat
        CALL   EDGE
        LD     A,L
        JR     TM4             ; ok!
;-------------------------------------
;
;  1 byte write
;    in Acc=data
;-------------------------------------
WBYTE:  PUSH   BC
        LD     B,8             ; 8 repeat set
        CALL   LONG            ; write long
;
WBY1:   RLCA                   ; rotate left
        CALL   C,LONG          ; 'H' long
        CALL   NC,SHORT        ; 'L' short
        DEC    B
        JP     NZ,WBY1         ; repeat
        POP    BC

        RET
;-------------------------------------
;
;   tape mark read
;
;     in   E=CCH:Inf.  long40,short40
;           else:Data  long20,short20
;
;     exit CF=0:ok
;          CF=1:break
;
;-------------------------------------
TMARK:  CALL   GAPCK
;
        PUSH   DE
        PUSH   BC
        PUSH   HL
        LD     HL,2828H        ; H=40,L=40
        LD     A,E
        CP     CCH             ;'L'
        JR     Z,TM0
        LD     HL,1414H        ; H=20,L=20
;
TM0:    LD     (TMCNT),HL
;
TM1:    LD     HL,(TMCNT)
;
TM2:    CALL   EDGE            ; edge search:(49c)
        JR     C,TM4           ; break!:7c
; reading point search:17c(1232c)
        CALL   DLY3            ; 17c (1232c)
        IN     A,(LSD2)
        AND    20H
        JR     Z,TM1           ; again
        DEC    H
        JR     NZ,TM2
;
TM3:    CALL   EDGE            ; edge search:(49c)
        JR     C,TM4           ; break!:7c
; reading point search:17c(1232c)
        CALL   DLY3            ; 17c (1232c)
        IN     A,(LSD2)
        AND    20H
        JR     NZ,TM1          ; again
        DEC    L
        JR     NZ,TM3
        CALL   EDGE
;
TM4:    POP    HL
;
TM5:    POP    BC
        POP    DE
        RET
;------------------------------------
;
;   check sum set
;
;    in   BC=byte size
;         HL=adr.
;

;    exit SUMDT=store
;         CSMDT=store
;------------------------------------
CKSUM:  PUSH   DE
        PUSH   BC
        PUSH   HL
        LD     DE,0
;
CKS1:   LD     A,B
        OR     C
        JR     NZ,CKS2
        EX     DE,HL
        LD     (SUMDT),HL
        LD     (CSMDT),HL
        JR     TM4             ; ret
;
CKS2:   LD     A,(HL)
        PUSH   BC
        LD     B,8             ; 8 bits
;
CKS3:   RLCA                   ; rotate left
        JR     NC,CKS4
        INC    DE
;
CKS4:   DJNZ   CKS3
        POP    BC
        INC    HL
        DEC    BC
        JR     CKS1
;--------------------------------------
;
;   gap + tape mark
;
;     in   E=CCH:short gap (10 sec)
;           else:short GAP ( 5 sec)
;--------------------------------------
GAP:    PUSH   DE
        PUSH   BC
        LD     A,E
        LD     BC,55F0H        ; Inf. 22000(10 sec)
        LD     DE,2828H        ;      short40,long40
        CP     CCH             ;'L'
        JP     Z,GAP1
        LD     BC,2AF8H        ; Data 11000( 5 sec)
        LD     DE,1414H        ;short20,long20
;
GAP1:   CALL   SHORT           ; write short
        DEC    BC
        LD     A,B
        OR     C
        JR     NZ,GAP1
;
GAP2:   CALL   LONG            ; write long
        DEC    D
        JR     NZ,GAP2
;
GAP3:   CALL   SHORT           ; write short
        DEC    E
        JR     NZ,GAP3
        CALL   LONG

        JR     TM5
;-----------------------------------------
;
;   GAP check
;   (long100 search)
;-----------------------------------------
GAPCK:  PUSH   DE
        PUSH   BC
        PUSH   HL
;
GAPCK1: LD     H,100           ; 100 repeat set
;
GAPCK2: CALL   EDGE            ; edge search:(49c)
        JR     C,TM4           ; error!:7c
        CALL   DLY3            ; reading point search:17c(1232c)
        IN     A,(LSD2)
        AND    20H
        JR     NZ,GAPCK1       ; again
        DEC    H
        JR     NZ,GAPCK2
        JR     TM4
;----------------------------------------
;
;  SHORT AND LONG PULSE FOR 1 BIT WRITE
;----------------------------------------
SHORT:  PUSH   AF              ; 11c
        LD     A,03H           ; 7c
        OUT    (LSD3),A        ; 11c
        CALL   DLY1            ; 17c (408c)
        CALL   DLY1            ; 17c (408c)
        LD     A,02H           ; 7c
        OUT    (LSD3),A        ; 11c
        CALL   DLY1            ; 17c (408c)
        CALL   DLY1            ; 17c (408c)
        POP    AF              ; 10c
        RET                    ; 10c
;
;
LONG:   PUSH   AF              ; 11c
        LD     A,03H           ; 7c
        OUT    (LSD3),A        ; 11c
        CALL   DLY4            ; 17c (1704c)
        LD     A,02H           ; 7c
        OUT    (LSD3),A        ; 11c
        CALL   DLY4            ; 17c (1704c)
        POP    AF              ; 10c
        RET                    ; 10c
;----------------------------------------
;
;  MOTOR STOP
;----------------------------------------
MSTOP:  PUSH   AF
        PUSH   BC
        PUSH   DE
        LD     B,10
;
MST1:   IN     A,(LSD2)        ; motor check
        AND    10H
        JR     Z,MST3          ; ok
        LD     A,06H           ; motor off

        OUT    (LSD3),A
        INC    A
        OUT    (LSD3),A
        DJNZ   MST1
;
MST3:   POP    DE
        POP    BC
        POP    AF
        RET
;-------------------------------------------
;
;   7.046 ms delay ... 24989c
;-------------------------------------------
DLY7:   ENT
        PUSH   BC              ; 11c
        LD     B,20            ; 7c
;
DLY.7:  CALL   DLY3            ; 17*19+17 (23332c)
        CALL   DLY0            ; 17*19+17 (  226c)
        DJNZ   DLY.7           ; 13*19+8
        POP    BC              ; 10c
        RET                    ; 10c
;-------------------------------------------
;
;   14 clock delay
;-------------------------------------------
DLY0:   NOP                    ; 4c
        RET                    ; 10c
;-------------------------------------------
;
;   347.4 us delay ... 1232c
;-------------------------------------------
DLY3:   NOP                    ; 4c
        LD     A,76            ; 7c
;
DLYA:   DEC    A               ;  4*XX+4
        JR     NZ,DLYA         ; 12*XX+7
        RET                    ; 10c
;-----------------------------------
;
; Delay for short.
;   115.0 us delay ... 408c
;-----------------------------------
DLY1:   ENT
        LD     A,24            ; 7c
        JR     DLYA            ; 12c
;-----------------------------------
;
; Delay for long.
;   480.4 us delay ... 1704c
;-----------------------------------
DLY4:   ENT
        LD     A,105           ; 7c
        JR     DLYA            ; 12c
;
        END

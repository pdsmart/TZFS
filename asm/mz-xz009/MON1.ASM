        LIST
        INCLD  MACRO

; ---------------------------
; MZ-800     crt port define
; FI:CRTEQU  ver 1.0  7.26.84
; ---------------------------
;

;
; custom  lsi ports
;
;
;
LSPAL:  EQU    0F0H            ;pallet
LSFC:   EQU    0FCH
LSE0:   EQU    0E0H
LSE1:   EQU    0E1H
LSE2:   EQU    0E2H
LSE3:   EQU    0E3H
LSE4:   EQU    0E4H
LSE5:   EQU    0E5H
LSE6:   EQU    0E6H
LSD0:   EQU    0D0H
LSD1:   EQU    0D1H
LSD2:   EQU    0D2H
LSD3:   EQU    0D3H
;
LSWF:   EQU    0CCH
LSRF:   EQU    0CDH
LSDMD:  EQU    0CEH
LSSCR:  EQU    0CFH
;
;
;
;  work area
;
TEXTBF: EQU    2000H
BITBUF: EQU    8000H
FONTBF: EQU    1000H
ERRTXT: EQU    FDA0H
        END
        SKP    H

        INCLD  XPL1
; ----------------------------
; MZ-800      Monitor part-1
; FI:PL1      ver 1.0  7.30.84
; ----------------------------
;
;
;
        ORG    0
        JP     STARTP
        JP     GETL
        JP     CR1
        JP     CR2
        JP     CRT1S
        JP     PRNTT
        JP     CRT1C
        JP     CRTMSG
;
.IOSVC: EQU    3
        JP     IOSVC           ;RST3 superviser call entry
;
        JP     INKEY0
BRKCHK: ENT
        JP     BRKEY
        JP     SAVE1
        JP     SAVE2
        JP     LOAD1
        JP     LOAD2
        JP     LOAD?2
        JP     .RET            ;RST6
        JP     TIMST
;
;
        DEFS   2               ;dummy
;
        JP     .RET            ;RST7 debuger reserve
;
        JP     TIMRD
BEEP:   JP     CTRLG
$TEMPO: ENT
        JP     ?TEMP
        JP     MLDSP
        JP     MLDSP
        JP     GETL
;
SYSSTA: ENT
        DEFW   $START
ERRORP: ENT
        DEFS   2
;
        JP     CRTMSG          ;org 51H
;
        DEFS   4
;
        JP     INKEY$          ;org 58H
;---------------------------------
;
;   crt driver contrl code tabel
;
;---------------------------------

CONTTB: DEFW   .RET            ;@ 00
        DEFW   .RET            ;A 01
        DEFW   .RET            ;B 02
        DEFW   CTR.M           ;C 03
        DEFW   .RET            ;D 04
        DEFW   CTR.E           ;E 05 sft lock
        DEFW   CTR.F           ;F 06 sft normal
        DEFW   .RET            ;G 07 beep
        DEFW   .RET            ;H 08
        DEFW   CTAB            ;I 09
        DEFW   .RET            ;J 0A
        DEFW   .RET            ;K 0B
        DEFW   .RET            ;L 0C
        DEFW   CTR.M           ;M 0D cr
        DEFW   SPLSW           ;N 0E spool exec/stop
        DEFW   .RET            ;O 0F
        DEFW   DEL             ;P 10 del
        DEFW   CDOWN           ;Q 11 cursor down
        DEFW   CUP             ;R 12 cursor up
        DEFW   CRIGHT          ;S 13 cursor right
        DEFW   CLEFT           ;T 14 cursor left
        DEFW   HOME            ;U 15 home
        DEFW   HCLSW           ;V 16 clr
        DEFW   CTR.W           ;W 17 graph
        DEFW   INST            ;X 18 inst
        DEFW   CTR.Y           ;Y 19 alpha
        DEFW   .RET            ;Z 1A
        DEFW   CTR.M           ;[ 1B esc
        DEFW   .RET            ;\ 1C
        DEFW   .RET            ;] 1D
        DEFW   .RET            ;^ 1E
        DEFW   .RET            ;_ 1F
        SKP    H

;
CTRLJB: ADD    A,A
        LD     HL,CONTTB
        CALL   ADDHLA
        CALL   INDRCT
        JP     (HL)
;
;
.NOP:   ENT
        NOP
;
.HL:    ENT
        JP     (HL)
;
;
DI:     
        EI
        PUSH   AF
        CALL   MWAIT
        CALL   SPLOFF
        POP    AF
        DI
.RET:   ENT
        RET
;
;
EI:     
        PUSH   AF
        CALL   SPLON
        POP    AF
        EI
        RET
;----------------------------------
;
;   register all push program
;
; PUSHRA : PUSH IX,HL,BC,DE,AF
; PUSHR  : PUSH IX,HL,BC,DE
;  Destroy IX
;
;----------------------------------
PUSHRA: ENT
        EX     (SP),IX
        PUSH   HL
        PUSH   BC
        PUSH   DE
        PUSH   AF
        PUSH   HL
        LD     HL,POPRA
        EX     (SP),HL
        JP     (IX)
PUSHR:  ENT
        EX     (SP),IX
        PUSH   HL
        PUSH   BC
        PUSH   DE
        PUSH   HL
        LD     HL,POPR
        EX     (SP),HL
        JP     (IX)

POPRA:  POP    AF
POPR:   POP    DE
        POP    BC
        POP    HL
        POP    IX
        RET
;
;
;
;---------------------------------
;
;      cold startup routine
;
;---------------------------------
;ORG DAH
;
COLDST: DI
        LD     SP,0000H
        IM     2
        OUT    (LSE1),A
        LD     HL,(SYSSTA)
        JP     (HL)            ;system entry jump
;
;
;
;---------------------------------
;
;    BREAK,can't cont
;---------------------------------
BREAKX: ENT
        XOR    A
        DEFB   21H
;---------------------------------
;    BREAK,can cont
;---------------------------------
BREAKZ: ENT
        LD     A,80H
        DEFB   21H
;---------------------------------
;    I/O error
;---------------------------------
IOERR:  ENT
        OR     80H
;---------------------------------
;    Error occur
;---------------------------------
ERRORJ: ENT
        PUSH   AF
        CALL   MLDSP
        POP    AF
        LD     HL,(ERRORP)
        JP     (HL)            ;error jump
;
        SKP    H

;
;---------------------------------
;
;  B = String bytes (till 00H)
;
;---------------------------------
COUNT:  PUSH   DE
        LD     B,0
COUNT2: LD     A,(DE)
        OR     A
        JR     Z,COUNT9
        INC    DE
        INC    B
        JR     NZ,COUNT2
        DEC    B
COUNT9: POP    DE
        RET
;---------------------------------
;
;    IOOUT
;
;    Ent. HL=I/O data tabel
;         B =counter
;
;---------------------------------
IOOUT:  ENT
        LD     A,(HL)
        INC    HL
        LD     C,(HL)
        INC    HL
        OUT    (C),A
        DJNZ   IOOUT
        RET
;
;
;
;
;
DEVASC: ENT
        SVC    .DEASC
        RST    3
        DEFB   .DEASC
        ENDM
        LD     A,D
        OR     A
        JP     NZ,ER03
        LD     A,E
        CP     B
        RET    C
        JP     ER03
;
        SKP    H

;
;
        ORG    011BH
;---------------------------------
;
;
;  CHECK ACC
;     CALL CHKACC
;     DEFB N
;     DEFB X1
;     DEFB X2
;      :   :
;     DEFB XN
;---------------------------------
CHKACC: ENT
        EX     (SP),HL
        PUSH   BC
        LD     B,M
        INC    HL
        CP     M
        JR     Z,CHACC1
        DJNZ   -4
        INC    HL
        JR     CHACC9
CHACC1: INC    HL
        DJNZ   -1
CHACC9: POP    BC
        EX     (SP),HL
        RET
;---------------------------------
;  LD DE,(HL+)
;---------------------------------
LDDEMI: ENT
        LD     E,M
        INC    HL
        LD     D,M
        INC    HL
        RET
;---------------------------------
;  LD DE,(HL)
;---------------------------------
LDDEMD: ENT
        LD     E,M
        INC    HL
        LD     D,M
        DEC    HL
        RET
;---------------------------------
; Clear (HL) B bytes
;---------------------------------
?CLRHL: ENT
        XOR    A
;---------------------------------
; Set  (HL) B bytes
;---------------------------------
?SETHL: ENT
        LD     M,A
        INC    HL
        DJNZ   -2
        RET

        SKP    H

;---------------------------------
; Clear (DE) B bytes
;---------------------------------
?CLRDE: ENT
        XOR    A
;---------------------------------
;  Set (DE) B bytes
;---------------------------------
?SETDE: ENT
        LD     (DE),A
        INC    DE
        DJNZ   -2
        RET
;---------------------------------
;  LD (DE),(HL)  B bytes
;---------------------------------
LDDEHL: ENT
        LD     A,M
        LD     (DE),A
        INC    HL
        INC    DE
        DJNZ   -4
        RET
;---------------------------------
;  LD (HL),(DE)  B bytes
;---------------------------------
LDHLDE: ENT
        LD     A,(DE)
        LD     M,A
        INC    HL
        INC    DE
        DJNZ   -4
        RET
;---------------------------------
;  LD HL,(HL)
;---------------------------------
INDRCT: ENT
        PUSH   AF
        LD     A,M
        INC    HL
        LD     H,M
        LD     L,A
        POP    AF
        RET
;---------------------------------
;  ADD HL,A
;---------------------------------
ADDHLA: ENT
        ADD    A,L
        LD     L,A
        RET    NC
        INC    H
        RET
        SKP    H

;---------------------------------
; Fetch subroutines
;---------------------------------
INCHLF: ENT
        INC    HL
HLFTCH: ENT
        LD     A,M
        CP     " "
        JR     Z,INCHLF
        RET
;---------------------------------
; TEST1 "x" ;test 1 char
;---------------------------------
TEST1:  ENT
        CALL   HLFTCH
        EX     (SP),HL
        CP     M
        INC    HL
        EX     (SP),HL
        RET    NZ
        INC    HL
        RET
;---------------------------------
;  TESTX "x"  ;check 1 char
;---------------------------------
TESTX:  ENT
        CALL   HLFTCH
        EX     (SP),HL
        CP     M
        INC    HL
        EX     (SP),HL
        INC    HL
        RET    Z               ;OK
        LD     A,1
        JP     ERRORJ          ;Syntax error
;
;
;
;
        SKP    H

;---------------------------------
; SVC(RST3) table
;---------------------------------
;MACRO SVCT
;@2:EQU @1H
;DEFW @3
;
;
IOSVCT: 
        SVCT   00, .MONOP, MONOP  ;00
.MONOP: EQU    00H
        DEFW   MONOP
        ENDM
        SVCT   01, .CR1  , CR1
.CR1:   EQU    01H
        DEFW   CR1
        ENDM
        SVCT   02, .CR2  , CR2
.CR2:   EQU    02H
        DEFW   CR2
        ENDM
        SVCT   03, .CRT1C, CRT1C
.CRT1C: EQU    03H
        DEFW   CRT1C
        ENDM
        SVCT   04, .CRT1X, CRT1CX ;04
.CRT1X: EQU    04H
        DEFW   CRT1CX
        ENDM
        SVCT   05, .CRTMS, CRTSIMU
.CRTMS: EQU    05H
        DEFW   CRTSIMU
        ENDM
        SVCT   06, .LPTOT, LPTOUT
.LPTOT: EQU    06H
        DEFW   LPTOUT
        ENDM
        SVCT   07, .LPT1C, LPT1C
.LPT1C: EQU    07H
        DEFW   LPT1C
        ENDM
        SVCT   08, .&CR  , &CR    ;08
.&CR:   EQU    08H
        DEFW   &CR
        ENDM
        SVCT   09, .&1C  , &1C
.&1C:   EQU    09H
        DEFW   &1C
        ENDM
        SVCT   0A, .&1CX , &1CX
.&1CX:  EQU    0AH
        DEFW   &1CX
        ENDM
        SVCT   0B, .&MSG , &MSG
.&MSG:  EQU    0BH
        DEFW   &MSG
        ENDM
        SVCT   0C, .GETL , GETL   ;0C
.GETL:  EQU    0CH
        DEFW   GETL

        ENDM
        SVCT   0D, .INKEY, INKEY$
.INKEY: EQU    0DH
        DEFW   INKEY$
        ENDM
        SVCT   0E, .BREAK, BRKEY
.BREAK: EQU    0EH
        DEFW   BRKEY
        ENDM
        SVCT   0F, .HALT , HALT
.HALT:  EQU    0FH
        DEFW   HALT
        ENDM
        SVCT   10, .DI   , DI     ;10
.DI:    EQU    10H
        DEFW   DI
        ENDM
        SVCT   11, .EI   , EI
.EI:    EQU    11H
        DEFW   EI
        ENDM
        SVCT   12, .CURMV, CURMOV
.CURMV: EQU    12H
        DEFW   CURMOV
        ENDM
        SVCT   13, .DEASC, DEASC
.DEASC: EQU    13H
        DEFW   DEASC
        ENDM
        SVCT   14, .DEHEX, DEHEX  ;14
.DEHEX: EQU    14H
        DEFW   DEHEX
        ENDM
        SVCT   15, .CKHEX, CKHEX
.CKHEX: EQU    15H
        DEFW   CKHEX
        ENDM
        SVCT   16, .ASCHL, ASCHL
.ASCHL: EQU    16H
        DEFW   ASCHL
        ENDM
        SVCT   17, .COUNT, COUNT
.COUNT: EQU    17H
        DEFW   COUNT
        ENDM
        SVCT   18, .ADDP0, ADDP0  ;18
.ADDP0: EQU    18H
        DEFW   ADDP0
        ENDM
        SVCT   19, .ADDP1, ADDP1
.ADDP1: EQU    19H
        DEFW   ADDP1
        ENDM
        SVCT   1A, .ADDP2, ADDP2
.ADDP2: EQU    1AH
        DEFW   ADDP2
        ENDM
        SVCT   1B, .ERRX , ERRX
.ERRX:  EQU    1BH
        DEFW   ERRX

        ENDM
        SVCT   1C, .?DACN, ?DACN  ;1C
.?DACN: EQU    1CH
        DEFW   ?DACN
        ENDM
        SVCT   1D, .?ADCN, ?ADCN
.?ADCN: EQU    1DH
        DEFW   ?ADCN
        ENDM
        SVCT   1E, .STICK, STICK  ;no ope
.STICK: EQU    1EH
        DEFW   STICK
        ENDM
        SVCT   1F, .STRIG, STRIG  ;no ope
.STRIG: EQU    1FH
        DEFW   STRIG
        ENDM
        SVCT   20, .BELL , CTRLG  ;20
.BELL:  EQU    20H
        DEFW   CTRLG
        ENDM
        SVCT   21, .PLAY , PLAY
.PLAY:  EQU    21H
        DEFW   PLAY
        ENDM
        SVCT   22, .SOUND, MSOUND
.SOUND: EQU    22H
        DEFW   MSOUND
        ENDM
        SVCT   23, .MCTRL, MCTRL
.MCTRL: EQU    23H
        DEFW   MCTRL
        ENDM
        SVCT   24, .IOOUT, IOOUT  ;24
.IOOUT: EQU    24H
        DEFW   IOOUT
        ENDM
        SVCT   25, .TIMRD, TIMRD
.TIMRD: EQU    25H
        DEFW   TIMRD
        ENDM
        SVCT   26, .TIMST, TIMST
.TIMST: EQU    26H
        DEFW   TIMST
        ENDM
        SVCT   27, .INP1C, INP1C0
.INP1C: EQU    27H
        DEFW   INP1C0
        ENDM
        SKP    H

;
        SVCT   28, .CLRIO, CLRIO  ;28
.CLRIO: EQU    28H
        DEFW   CLRIO
        ENDM
        SVCT   29, .SEGAD, SEGADR
.SEGAD: EQU    29H
        DEFW   SEGADR
        ENDM
        SVCT   2A, .OPSEG, OPSEG
.OPSEG: EQU    2AH
        DEFW   OPSEG
        ENDM
        SVCT   2B, .DLSEG, DELSEG
.DLSEG: EQU    2BH
        DEFW   DELSEG
        ENDM
        SVCT   2C, .DEVNM, DEV    ;2C
.DEVNM: EQU    2CH
        DEFW   DEV
        ENDM
        SVCT   2D, .DEVFN, DEV&FN
.DEVFN: EQU    2DH
        DEFW   DEV&FN
        ENDM
        SVCT   2E, .LUCHK, LUCHK
.LUCHK: EQU    2EH
        DEFW   LUCHK
        ENDM
        SVCT   2F, .LOPEN, LOPEN
.LOPEN: EQU    2FH
        DEFW   LOPEN
        ENDM
        SVCT   30, .LOADF, LOADFL ;30
.LOADF: EQU    30H
        DEFW   LOADFL
        ENDM
        SVCT   31, .SAVEF, SAVEFL
.SAVEF: EQU    31H
        DEFW   SAVEFL
        ENDM
        SVCT   32, .VRFYF, VRFYFL
.VRFYF: EQU    32H
        DEFW   VRFYFL
        ENDM
        SVCT   33, .RWOPN, RWOPEN
.RWOPN: EQU    33H
        DEFW   RWOPEN
        ENDM
        SVCT   34, .INSTT, INPSTRT;34
.INSTT: EQU    34H
        DEFW   INPSTRT
        ENDM
        SVCT   35, .INMSG, INPMSG
.INMSG: EQU    35H
        DEFW   INPMSG
        ENDM
        SVCT   36, .INDAT, INPDT
.INDAT: EQU    36H
        DEFW   INPDT

        ENDM
        SVCT   37, .PRSTR, PRTSTR
.PRSTR: EQU    37H
        DEFW   PRTSTR
        ENDM
        SVCT   38, .CLKL , CLKL   ;38
.CLKL:  EQU    38H
        DEFW   CLKL
        ENDM
        SVCT   39, .DIR  , FDIR
.DIR:   EQU    39H
        DEFW   FDIR
        ENDM
        SVCT   3A, .SETDF, SETDFL
.SETDF: EQU    3AH
        DEFW   SETDFL
        ENDM
        SVCT   3B, .LSALL, LSALL
.LSALL: EQU    3BH
        DEFW   LSALL
        ENDM
        SVCT   3C, .FINIT, FINIT  ;3C
.FINIT: EQU    3CH
        DEFW   FINIT
        ENDM
        SVCT   3D, .DELET, FDELET
.DELET: EQU    3DH
        DEFW   FDELET
        ENDM
        SVCT   3E, .RENAM, FRENAM
.RENAM: EQU    3EH
        DEFW   FRENAM
        ENDM
        SVCT   3F, .LOCK , FLOCK
.LOCK:  EQU    3FH
        DEFW   FLOCK
        ENDM
        SVCT   40, .RECST, RECST  ;40
.RECST: EQU    40H
        DEFW   RECST
        ENDM
        SVCT   41, .INREC, INREC
.INREC: EQU    41H
        DEFW   INREC
        ENDM
        SVCT   42, .PRREC, PRREC
.PRREC: EQU    42H
        DEFW   PRREC
        ENDM
        SVCT   43, .ERCVR, ERRCVR
.ERCVR: EQU    43H
        DEFW   ERRCVR
        ENDM
        SVCT   44, .SWAP , FSWAP  ;44
.SWAP:  EQU    44H
        DEFW   FSWAP
        ENDM
        SVCT   45, .CLS  , HCLS
.CLS:   EQU    45H
        DEFW   HCLS

        ENDM
        SVCT   46, .POSCK, POSCK
.POSCK: EQU    46H
        DEFW   POSCK
        ENDM
        SVCT   47, .POSSV, POSSV
.POSSV: EQU    47H
        DEFW   POSSV
        ENDM
        SVCT   48, .PSET , PSET   ;48
.PSET:  EQU    48H
        DEFW   PSET
        ENDM
        SVCT   49, .LINE , WLINE
.LINE:  EQU    49H
        DEFW   WLINE
        ENDM
        SVCT   4A, .PATTR, CHARW
.PATTR: EQU    4AH
        DEFW   CHARW
        ENDM
        SVCT   4B, .BOX  , WBOX
.BOX:   EQU    4BH
        DEFW   WBOX
        ENDM
        SVCT   4C, .PAINT, WPAINT ;4C
.PAINT: EQU    4CH
        DEFW   WPAINT
        ENDM
        SVCT   4D, .CIRCL, WCIRCL
.CIRCL: EQU    4DH
        DEFW   WCIRCL
        ENDM
        SVCT   4E, .POINT, ?POINT
.POINT: EQU    4EH
        DEFW   ?POINT
        ENDM
        SVCT   4F, .HCPY , HCPY
.HCPY:  EQU    4FH
        DEFW   HCPY
        ENDM
        SVCT   50, .DSMOD, DSMODE ;50
.DSMOD: EQU    50H
        DEFW   DSMODE
        ENDM
        SVCT   51, .DPLBK, DPALBK
.DPLBK: EQU    51H
        DEFW   DPALBK
        ENDM
        SVCT   52, .DPLST, DPALST
.DPLST: EQU    52H
        DEFW   DPALST
        ENDM
        SVCT   53, .DWIND, DWIND
.DWIND: EQU    53H
        DEFW   DWIND
        ENDM
        SVCT   54, .DCOL , DCOLOR
.DCOL:  EQU    54H
        DEFW   DCOLOR

        ENDM
        SVCT   55, .DGCOL, DGCOL  ;55
.DGCOL: EQU    55H
        DEFW   DGCOL
        ENDM
        SVCT   56, .ICRT , ICRT
.ICRT:  EQU    56H
        DEFW   ICRT
        ENDM
        SVCT   57, .SYMBL, SYMBOL
.SYMBL: EQU    57H
        DEFW   SYMBOL
        ENDM
        SKP    H

;---------------------------------
;
; SVC handlar (RST3)
;
;---------------------------------
IOSVC:  EX     (SP),HL
        PUSH   AF
        LD     A,M
        INC    HL
        PUSH   HL
        LD     HL,IOSVCT
        ADD    A,A
        ADD    A,L
        JR     NC,+3
        INC    H
        LD     L,A
        LD     A,M
        INC    HL
        LD     H,M
        LD     L,A
        LD     (IOSVCX+1),HL
        POP    HL
        POP    AF
        EX     (SP),HL
IOSVCX: JP     0               ;xxx
;
;  I/O device call (RST5)
;
IOCALL: ENT
        PUSH   HL
        PUSH   DE
        LD     (IOCALX+1),IX
        LD     IX,IOERR
        OR     A
IOCALX: CALL   0               ;xxx
        POP    DE
        POP    HL
        RET    NC
        OR     A
        SCF
        RET    Z
        JP     IOERR
;
;
        END
        SKP    H

        INCLD  XMUTI
;
;  Convert BINARY(HL) to ASCII(DE)
;
ASCHL:  ENT
        PUSH   HL
        PUSH   BC
        PUSH   DE
        LD     DE,10000
        CALL   ASCHL2
        LD     DE,1000
        CALL   ASCHL2
        LD     DE,100
        CALL   ASCHL2
        LD     DE,10
        CALL   ASCHL2
        LD     A,L
        POP    DE
        OR     "0"
        LD     (DE),A
        INC    DE
        XOR    A
        LD     (DE),A
        POP    BC
        POP    HL
        RET
;
ASCHL2: LD     A,FFH
ASCHL4: INC    A
        OR     A
        SBC    HL,DE
        JR     NC,ASCHL4
        ADD    HL,DE
        OR     A
        JR     NZ,ASCHL6
        OR     B
        RET    Z               ;Zero sup.
        XOR    A
ASCHL6: LD     B,1
        OR     "0"
        POP    DE
        EX     (SP),HL
        LD     M,A
        INC    HL
        EX     (SP),HL
        PUSH   DE
        RET
        SKP    H

;
;  Convert ASCII(HL) to BINARY(DE)
;
DEASC:  ENT
        TEST1  "$"
        CALL   TEST1
        DEFB   "$"
        ENDM
        JR     Z,DEHEX
        LD     DE,0
DEASC2: CALL   HLFTCH
        SUB    "0"
        CP     10
        RET    NC
        INC    HL
        PUSH   HL
        LD     HL,DE
        ADD    HL,HL           ;2
        JR     C,ER02'
        ADD    HL,HL           ;4
        JR     C,ER02'
        ADD    HL,DE           ;5
        JR     C,ER02'
        ADD    HL,HL           ;10
        JR     C,ER02'
        LD     E,A
        LD     D,0
        ADD    HL,DE
        JR     C,ER02'
        EX     DE,HL
        POP    HL
        JR     DEASC2
;
ER02':  LD     A,2
        JP     ERRORJ
        SKP    H

;
; Convert HEX(HL) to BINARY(DE)
;
DEHEX:  ENT
        LD     DE,0
DEHEX2: LD     A,M
        CALL   CKHEX
        RET    C
        INC    HL
        EX     DE,HL
        ADD    HL,HL           ;2
        JR     C,ER02'
        ADD    HL,HL           ;4
        JR     C,ER02'
        ADD    HL,HL           ;8
        JR     C,ER02'
        ADD    HL,HL           ;16
        JR     C,ER02'
        ADD    A,L
        LD     L,A
        EX     DE,HL
        JR     DEHEX2
;
; Chck hex
;
CKHEX:  ENT
        SUB    "0"
        CP     10
        CCF
        RET    NC
        SUB    "A"-"0"
        CP     6
        CCF
        RET    C
        ADD    A,10
        RET
;
; SVC .HALT   ;Halt if SPACE,
;             ;and break check
;
HALT:   ENT
        CALL   HALTSB
        CP     " "
        RET    NZ
        CALL   HALTSB
        OR     A
        JR     Z,-4
        RET
HALTSB: SVC    .BREAK
        RST    3
        DEFB   .BREAK
        ENDM
        JR     Z,HALTBR
        LD     A,FFH
        SVC    .INKEY
        RST    3
        DEFB   .INKEY
        ENDM
        CP     1BH
        RET    NZ

HALTBR: JP     BREAKZ
        RET
        SKP    H

;
; SVC .SETDF  ;set default
;   ent DE:equipment table
;       A: channel
;
SETDFL: ENT
        LD     (DDEV),DE
        LD     (DCHAN),A
        RET
;
; Pointer update
;
ADDP0:  ENT
        LD     HL,(POOL)
        ADD    HL,DE
        LD     (POOL),HL
ADDP1:  ENT
        LD     HL,(VARST)
        ADD    HL,DE
        LD     (VARST),HL
ADDP2:  ENT
        LD     HL,(STRST)
        ADD    HL,DE
        LD     (STRST),HL
        LD     HL,(VARED)
        ADD    HL,DE
        LD     (VARED),HL
        LD     HL,(TMPEND)
        ADD    HL,DE
        LD     (TMPEND),HL
        RET
;
        SKP    H

;
; SVC .ERRX  ;Print error message
;
ERRX:   ENT
        LD     C,A
        SVC    .BELL
        RST    3
        DEFB   .BELL
        ENDM
        SVC    .CR2
        RST    3
        DEFB   .CR2
        ENDM
        BIT    7,C
        JR     Z,ERRX1
        LD     HL,KEYBUF
        PUSH   HL
        CALL   SETDNM
        POP    DE
        SVC    .CRTMS          ;Device name
        RST    3
        DEFB   .CRTMS
        ENDM
ERRX1:  LD     A,C
        AND    7FH
        LD     C,A
        SVC    .DI
        RST    3
        DEFB   .DI
        ENDM
        OUT    (LSE3),A        ;bank change
        JR     ERRX0
;
ERRXU:  LD     C,69
ERRX0:  LD     DE,ERRTXT
ERRX2:  DEC    C
        JR     Z,ERRX4
        LD     A,(DE)
        INC    DE
        OR     A
        JP     P,-3
        JR     Z,ERRXU
        JR     ERRX2
;
ERRX4:  LD     A,(DE)
        CP     80H
        JR     Z,ERRXU
        EX     DE,HL
        LD     DE,KEYBUF
ERRX6:  LD     A,(HL)
        OR     A
        JP     M,ERRX8
        LDI
        JR     ERRX6
ERRX8:  AND    7FH
        LD     (DE),A
        OUT    (LSE1),A        ;bank change
        SVC    .EI
        RST    3
        DEFB   .EI

        ENDM
        INC    DE
        LD     HL,MESER
        LD     B,8
        CALL   LDDEHL
        LD     DE,KEYBUF
        SVC    .CRTMS
        RST    3
        DEFB   .CRTMS
        ENDM
        RET
;
        SKP    H

;
SETDNM: ENT
        LD     DE,(ZEQT)
        INC    DE
        INC    DE
        SVC    .COUNT
        RST    3
        DEFB   .COUNT
        ENDM
        CALL   LDHLDE
        LD     A,(ZCH)
        ADD    A,"1"
        LD     M,A             ;ch#
        LD     A,(ZFLAG2)
        AND    0FH             ;max ch#
        JR     Z,+3
        INC    HL
        LD     M,":"
        INC    HL
        LD     M,0
        RET
;
MESER:  DEFM   " ERROR"

        DEFB   0
;
;
        END
        SKP    H

        INCLD  XPARM
;-----------------------------------
;
;
;    display mode
;
;
;   ent. acc   mode    colors  dmd
;         1  320*200     4      0
;         2  320*200    16      2
;         3  640*200     2      4
;         4  640*200     4      6
;
;
;-----------------------------------
;
DSMODE: ENT
        CALL   PUSHR
        LD     B,A
;
        LD     A,(MEMOP)       ;option vram exist ?
        OR     A
        LD     A,B
        JR     NZ,DSM0
        CP     2
        JR     Z,CERR
        CP     4
        JR     Z,CERR
;
;
;
DSM0:   PUSH   AF
        DEC    A
        LD     D,FFH
        LD     HL,PAL4T
        LD     BC,0403H
        JR     Z,DSM00         ;skip if 320*200  4 colors
        DEC    A
        LD     HL,PAL16T
        LD     BC,100FH
        JR     Z,DSM00         ;skip if 320*200 16 colors
        DEC    A
        LD     HL,PAL2T
        LD     BC,0201H
        JR     Z,DSM00         ;skip if 640*200  2 colors
        LD     HL,PAL4T        ; 640 *200  4 colors
        LD     BC,0805H
        LD     D,FDH
;
DSM00:  LD     (CPLANE),BC     ;c cplane
        LD     A,D
        LD     (PMASK),A       ;plane mask
        LD     (PALAD),HL
        CALL   PALOFF
        POP    AF
        DEC    A
        RLCA
        LD     (DMD),A
        OUT    (LSDMD),A
        AND    4               ;bit 2 only

        CALL   DWIDTH          ;acc=0 -->40 chr
        CALL   CONSOI          ;(YS,YE)=0,24 palint
        OR     A
        RET
;
;
CERR:   
        SCF
        RET
        SKP    H

;-----------------------------------
;
;
;  console & palette & color init
;
;-----------------------------------
CONSOI: LD     HL,1800H        ;(ys,ye)=(0,24)
        CALL   DWIND
;
;JR PALINT
;
PALINT: LD     A,(CPLANE)
        LD     (CMODE),A
        XOR    A
        CALL   DPALBK          ;init palette block reg.
        LD     HL,PALAD
        LD     E,(HL)
        INC    HL
        LD     D,(HL)
        EX     DE,HL
        LD     DE,PALTBL       ;init palette reg.
        PUSH   DE
        LD     BC,4
        LDIR
        POP    HL
PALOUT: LD     B,4
        LD     C,LSPAL
        OTIR
        RET
;--------------------------------
;
;   Palette all clr
;
;
;--------------------------------
PALOFF: ENT
        PUSH   BC
        XOR    A
        LD     B,5
        LD     C,LSPAL
PALOF1: OUT    (C),A
        ADD    A,10H
        DJNZ   PALOF1
        POP    BC
        RET
;
;
        SKP    H

;----------------------------------
;
;
;   pallet  block regster set
;
;      ent  acc=pal block number
;
;----------------------------------
DPALBK: ENT
        CALL   PUSHR
        LD     (PALBK),A
        LD     E,A
        LD     A,(DMD)
        CP     2
        JR     NZ,PALBK1       ;skip if not 320*200 16 col
;
        LD     A,E
        RLCA                   ;*2
        RLCA                   ;*4
        LD     HL,PALTBL
        LD     B,4
        PUSH   HL
PALBK0: LD     (HL),A
        ADD    A,11H
        INC    HL
        DJNZ   PALBK0
        POP    HL
        CALL   PALOUT
PALBK1: LD     A,E
        OR     40H
        OUT    (LSPAL),A
        RET
;
        SKP    H

;----------------------------------
;
;   pallet  regster set
;
;      ent  acc=pal register number
;           b  =pal color code
;
;----------------------------------
;
DPALST: ENT
        CALL   PUSHR
        LD     HL,PALTBL
        LD     D,0
        LD     E,A             ;pallet register number
        ADD    HL,DE
        OR     A
        RLCA
        RLCA
        RLCA
        RLCA
        OR     B               ;pallet color code
        LD     (HL),A
        OUT    (LSPAL),A
        RET
;
        SKP    H

;
;----------------------------------
;
;
;   display color set
;
;           Acc=col code
;----------------------------------
;
DCOLOR: ENT
        PUSH   AF
        CALL   COLS
        LD     (CMODE),A
        POP    AF
        RET
;
;
DGCOL:  ENT
        PUSH   AF
        CALL   COLS
        LD     (GMODE),A
        POP    AF
        RET
;
COLS:   ENT
        PUSH   BC
        LD     B,A
        LD     A,(DMD)
        CP     6
        LD     A,B
        JR     NZ,COLS1        ;skip if not 640*200 4
        CP     2
        JR     C,COLS1
        ADD    A,2             ;2 or 3 only
COLS1:  POP    BC
        RET
;
        SKP    H

;----------------------------------
;
;
;  display window set
;
;
;
;----------------------------------
DWIND:  ENT
        CALL   PUSHR
        LD     (YS),HL         ;save YS,YE
        LD     A,H
        SUB    L
        INC    A
        LD     (YW),A          ;YW=YE-YS+1 :lines
        LD     B,A
        ADD    A,A
        ADD    A,A
        ADD    A,B
        LD     (SW),A          ;SW=YW*5
        EX     DE,HL
        LD     H,0
        LD     L,A
        ADD    HL,HL           ;*2
        ADD    HL,HL           ;*4
        ADD    HL,HL           ;*8
        LD     (SSW),HL
        EX     DE,HL
        INC    H
        LD     A,H
        ADD    A,A
        ADD    A,A
        ADD    A,H
        LD     (SEA),A         ;SEA=(YE+1)*5
        LD     A,L
        ADD    A,A
        ADD    A,A
        ADD    A,L
        LD     (SSA),A         ;SSA=YS*5
        LD     HL,0
        LD     (SOF),HL        ;SOF=0
        LD     HL,SEA
        LD     BC,6CFH         ;B counter C scrool reg
        OTDR
        CALL   HCLS
        JP     HOME
        SKP    H

;----------------------------------
;
;
;  display chracter size change
;
;     if acc=1 then 640 chr
;     if acc=0 then 320 chr
;----------------------------------
;
DWIDTH: ENT
        CALL   PUSHR
        OR     A
        LD     A,40
        LD     DE,2300H
        JR     Z,DWID1
        ADD    A,A             ;80 chr
        LD     DE,0023H
DWID1:  LD     (CWIDTH),A
        LD     H,0
        LD     L,A
        ADD    HL,HL           ;*2
        ADD    HL,HL           ;*4
        ADD    HL,HL           ;*8
        LD     (CSIZE),HL
        DEC    A
        LD     (XE),A
;
        LD     A,D
        LD     (PTW0),A
        LD     (PTW0+1),A
        LD     (PTB0),A
        LD     A,E
        LD     (PTW1),A
        LD     (PTW1+1),A
        LD     (PTB1),A
        LD     BC,0B07H        ;patch counter
        LD     HL,CHTBL        ;patch table addr
        CALL   PATCH
        CALL   CHGRPH          ;mon-grph
        JP     HCLS
;
;
PATCH:  ENT
;
;  word patch
;
PATCHW: LD     E,(HL)          ;addr read
        INC    HL
        LD     D,(HL)
        INC    HL
PTW0:   INC    HL              ;nop
        INC    HL              ;nop
        LD     A,(HL)          ;data read
        INC    HL
        LD     (DE),A
        INC    DE
        LD     A,(HL)
        INC    HL
        LD     (DE),A
PTW1:   NOP                    ;inc hl

        NOP                    ;inc hl
        DJNZ   PATCHW
;
;    byte patch
;
        LD     B,C
PATCHB: LD     E,(HL)          ;addr read
        INC    HL
        LD     D,(HL)
        INC    HL
PTB0:   INC    HL              ;nop
        LD     A,(HL)
        INC    HL
        LD     (DE),A
PTB1:   NOP                    ;inc hl
        DJNZ   PATCHB
        RET
;
        SKP    H

;--------------------------------
;
;
;    PL-EX crt driver patch tabel
;
;
;--------------------------------
;
CHTBL:  
;
;  word patch
;
        DEFW   XPD1+1          ;ld de,xxxxh
        DEFW   80
        DEFW   40
        DEFW   XPC1            ;sla c
        DEFW   21CBH
        DEFW   0               ;nop
        DEFW   XPC2+1          ;ld bc,xxxxh
        DEFW   400
        DEFW   200
        DEFW   XPC3+1          ;ld hl,xxxxh
        DEFW   BITBUF+16000
        DEFW   BITBUF+8000
        DEFW   XPDE3+1         ;ld de,xxxxh
        DEFW   80
        DEFW   40
        DEFW   XPDE4+1         ;ld bc,xxxxh
        DEFW   560
        DEFW   280
        DEFW   XPIN2+1         ;ld de,xxxxh
        DEFW   80
        DEFW   40
        DEFW   XPIN3+1         ;ld de,xxxxh
        DEFW   FFB0H
        DEFW   FFD8H
        DEFW   XPIN4+1         ;ld bc,xxxxh
        DEFW   FDD0H
        DEFW   FEE8H
        DEFW   XPLI2+1         ;ld de,xxxxh
        DEFW   80
        DEFW   40
        DEFW   XPSC2+1         ;ld bc,xxxxh
        DEFW   639
        DEFW   319
;
;
;
;byte patch
;
;
        DEFW   XPDE1+1         ;ld l,xxh
        DEFB   79
        DEFB   39
        DEFW   XPDE2+1         ;ld c,xxh
        DEFB   79
        DEFB   39
        DEFW   XPIN1+1         ;ld c,xxh
        DEFB   79
        DEFB   39

        DEFW   XPLI1+1         ;ld a,xxh
        DEFB   79
        DEFB   39
        DEFW   XPSC1+1         ;ld c,xxh
        DEFB   80
        DEFB   40
        DEFW   XPCU1           ;add hl,hl
        DEFB   29H
        DEFB   0               ;nop
        DEFW   XPCU2           ;add hl,hl
        DEFB   29H
        DEFB   0               ;nop
;
;
        END
        SKP    H

        INCLD  XDSP
;
;---------------------------------
;
;
;    crt 1 character display
;
;       acc=ascii code
;
;
;---------------------------------
;
ACCDI:  ENT
        CALL   PUSHRA
        LD     HL,(POSADR)
        LD     C,A
        CP     20H             ;convert space
        JR     NZ,ACCDI0
        XOR    A
ACCDI0: LD     (HL),A
        LD     HL,(BITADR)
        LD     A,C
        CALL   BITMAP
        XOR    A               ;patch cursor
        LD     (CDOWN2+2),A
        CALL   CRIGHT
        LD     A,7
        LD     (CDOWN2+2),A
        RET
;
        SKP    H

;----------------------------------
;
;    bitmap extention
;
;    ent Acc:ascii  code
;        HL :bitadr
;
;----------------------------------
;
BITMAP: ENT
;
        SVC    .?ADCN          ;ascii->display
        RST    3
        DEFB   .?ADCN
        ENDM
        DI
        EXX
        PUSH   HL
        LD     H,0
        LD     L,A             ;display code
        LD     A,(CMODE)
        OR     80H             ;replace mode
        OUT    (LSWF),A
;
        ADD    HL,HL           ;*2
        ADD    HL,HL           ;*4
        ADD    HL,HL           ;*8
        SET    4,H             ;offset fontbuf $1000
        EXX
        LD     B,8
XPD1:   LD     DE,40           ;cwidth 80<--80 chr
        IN     A,(LSE0)        ;bank change !!
BITM1:  EXX
        LD     A,(HL)          ;font pattern read
        INC    HL              ;next pointer
        EXX
        LD     (HL),A          ;font pattern write
        ADD    HL,DE           ;next laster
        DJNZ   BITM1
        IN     A,(LSE1)        ;   bank reset !!
        EI
        EXX
        POP    HL
        EXX
        RET
        SKP    H

;----------------------------------
;
;
;     manegement   utility
;
;
;----------------------------------

;     exit D=begin line
;          E=end line+1
;
LBOUND: ENT
        CALL   TBCALC
LBOUN1: LD     A,M
        OR     A
        JR     Z,LBOUN2
        DEC    HL
        DEC    E
        LD     A,(YS)
        CP     E
        JR     C,LBOUN1
LBOUN2: LD     D,E
LBOUN3: INC    E
        INC    HL
        LD     A,M
        OR     A
        RET    Z
        LD     A,(YE)
        CP     E
        JR     NC,LBOUN3
        RET
;
;
TBCALC: ENT
        LD     E,H
        LD     D,0
        LD     HL,SCRNT0
        ADD    HL,DE
        RET
;
        END
        SKP    H

        INCLD  XCLS
;-----------------------------------
;
;     clear  window
;
;
;
;-----------------------------------
HCLSW:  ENT
        CALL   PUSHR
        LD     A,(YS)
        LD     H,A
        CALL   TBCALC
        LD     A,(YW)          ;YW=YE-YS+1
        LD     B,A             ;lines
        LD     E,A             ;store YW
;
        CALL   ?CLRHL          ;mangement buf clr
;
CLSWT:  LD     C,E             ;restore YW
        LD     A,(YE)
;JR CLSLT
;
;
;-----------------------------------
;
;
;    clear   line
;
;    C=lines Acc=line no.
;
;-----------------------------------
;
CLSLT:  
        INC    A
        LD     L,0
        LD     H,A
        PUSH   HL              ;start pos x,y
        CALL   PONT
        LD     B,0
XPC1:   NOP                    ;40  SLA C<--80
        NOP
        PUSH   BC
        CALL   PUSHW
        POP    HL              ;pop counter
        ADD    HL,HL           ;*2
        ADD    HL,HL           ;*4
        ADD    HL,HL           ;*8
        LD     C,L
        LD     B,H
        POP    HL              ;start pos x,y
        CALL   PONTB
        CALL   PUSHW
        JR     CLRSCR
;
;-----------------------------------
;
;    clear   screen
;
;

;
;
;-----------------------------------
HCLS:   ENT
        CALL   PUSHRA
CLST:   LD     HL,TEXTBF+2000
        LD     BC,50
        CALL   PUSHW
        LD     B,25
        LD     HL,SCRNT0
        CALL   ?CLRHL          ;manegement buf clr
CLSB:   
;
;  color mode
;
XPC2:   LD     BC,200          ;or 400
XPC3:   LD     HL,BITBUF+8000  ;or +16000
        CALL   PUSHW
        JR     CLRSCR
;-----------------------------------
;
;   PUSH Write
;
;
;  Ent:HL=cls point addr
;      BC=counts *40
;
;-----------------------------------
;
PUSHW:  ENT
        LD     (PUSHW1+1),SP
        LD     (PUSHW2+1),HL
        LD     HL,0
        LD     A,(CPLANE)      ;display active plane
        OR     80H             ;replace mode
        OUT    (LSWF),A
;
PUSHW0: DI
PUSHW2: LD     SP,0            ;xx
        IN     A,(LSE0)        ;bank
;
        PUSH   HL
        PUSH   HL
        PUSH   HL
        PUSH   HL
        PUSH   HL              ;10
        PUSH   HL
        PUSH   HL
        PUSH   HL
        PUSH   HL
        PUSH   HL              ;20
        PUSH   HL
        PUSH   HL
        PUSH   HL
        PUSH   HL
        PUSH   HL              ;30
        PUSH   HL
        PUSH   HL
        PUSH   HL
        PUSH   HL

        PUSH   HL              ;40
        IN     A,(LSE1)        ;bank
        LD     (PUSHW2+1),SP
PUSHW1: LD     SP,0            ;xxx
        EI
;
        DEC    BC
        LD     A,C
        OR     B
        JR     NZ,PUSHW0
        RET
;----------------------------------
;
;    scrool parameter initial
;
;
;----------------------------------
;
CLRSCR: 
        LD     HL,0
        LD     (SOF),HL
        LD     B,2
        LD     C,LSSCR         ;lsi scrool register
        OUT    (C),H
        DEC    B
        OUT    (C),L
        JP     HOME
;
;
        END
        SKP    H

        INCLD  XDEL
;----------------------------------
;
;
;
;     delete chacter
;
;
;----------------------------------
;
;
DEL:    
        EXX
        PUSH   HL
        PUSH   DE
        PUSH   BC
        EXX
        CALL   DEL0
        EXX
        POP    BC
        POP    DE
        POP    HL
        EXX
        RET
;
DEL0:   
        LD     HL,(CURXY)
        DEC    L
        JP     P,DEL1
;
        CALL   TBCALC
        LD     A,(HL)
        LD     H,E
        LD     L,0
        OR     A
        JR     Z,DEL1
        LD     A,(YS)
        CP     H
        JR     Z,DEL1
        DEC    H
XPDE1:  LD     L,39            ;XE 39 or 79
DEL1:   
        LD     (CURXY),HL
        CALL   LINCAL
;BC lines HL' counts HL last curxy
        CALL   PONTC
        PUSH   BC              ;lines store
        LD     D,H
        LD     E,L
        INC    HL
        EXX
        PUSH   HL              ;HL' counts
        EXX
        POP    BC
        LDIR
        XOR    A
        LD     (DE),A          ;last addr space
        POP    BC              ;lines pop
        LD     HL,(CURXY)
        INC    HL

        CALL   PONTB           ;bitmap addr
DELB11: EXX
        LD     D,9             ;laster set
        LD     HL,(MAXCF)
        DEC    D
        EXX
        JR     DELB2           ;line first time only
        SKP    H

;----------------------------------
;  DELB
;
;  ent.
;  BC  lines
;  HL  start address
;----------------------------------
DELB:   
;
XPDE2:  LD     C,39            ;79 xe
        DEC    B               ;last line ?
        JR     Z,DELB0         ;skip if end of func.
        INC    DE              ;next addr calc
        INC    DE
        LD     H,D
        LD     L,E
        JR     DELB11
;
DELB1:  LD     HL,(MAXCF)      ;
        DEC    D               ;last laster ?
        EXX
        JR     Z,DELB          ;skip if next line
XPDE3:  LD     DE,40           ;cwidth  80
        ADD    HL,DE
;
DELB2:  EXX                    ;next plane ?
        RRC    L
        JR     C,DELB1
        LD     A,L
        AND    H               ;pmask
        EXX
        JR     Z,DELB2         ;skip if warp
        DI
        PUSH   HL
        PUSH   BC
        OUT    (LSRF),A        ;read plane
        OUT    (LSWF),A        ;write plane
        IN     A,(LSE0)        ;bank change
        OUT    (LSE0),A        ;cg off
        LD     D,H
        LD     E,L
        DEC    DE
        LD     A,C
        OR     A
        JR     Z,XPDE4
        LD     A,B             ;line counter
        LD     B,0
        LDIR
        DEC    A
        JR     Z,DELB3         ;skip if last counter
XPDE4:  LD     BC,280          ; 560
        ADD    HL,BC
        LD     A,(HL)
        LD     (DE),A
DELB3:  IN     A,(LSE1)        ;bank off
        EI
        POP    BC
        POP    HL
        JP     DELB2
;

;
DELB0:  
        EX     DE,HL
        INC    C
        LD     E,C
        LD     D,B
        LD     B,8
        DI
        IN     A,(LSE0)        ;bank change
        OUT    (LSE0),A        ;cg off
        LD     A,(CPLANE)
        OR     80H             ;replace mode
        OUT    (LSWF),A
DELB01: XOR    A
        LD     (HL),A          ;space fill
        SBC    HL,DE
        DJNZ   DELB01
        IN     A,(LSE1)        ;bank off
        EI
        LD     HL,(CURXY)
        JP     CURMOV
;
        SKP    H

;----------------------------------

;
;
;     insert chacter
;
;
;----------------------------------
;
;
INST:   
;
        EXX
        PUSH   HL
        PUSH   DE
        PUSH   BC
        EXX
        CALL   INST0
        EXX
        POP    BC
        POP    DE
        POP    HL
        EXX
        RET
;
;
INST0:  
        LD     HL,(CURXY)
        CALL   LINCAL
;BC lines HL' counts HL last curxy
        PUSH   HL              ;store last-next pos x,y
        CALL   PONT
        DEC    HL              ;last addr
        LD     A,(HL)
        OR     A
        JR     NZ,INSTE        ;no insert space
        PUSH   BC              ;lines store
        LD     D,H
        LD     E,L
        DEC    HL
        EXX
        PUSH   HL              ;HL' counts
        EXX
        POP    BC
        LDDR
        XOR    A
        LD     (DE),A          ;last addr space
        POP    BC              ;lines pop
        POP    HL
        CALL   PONTB           ;bitmap addr
        DEC    HL
        LD     A,C
        LD     (LASTC+1),A
        DEC    B
        JR     Z,INSEF         ;first time ended
        JR     INSB1
;
INSTE:  POP    HL
        RET
;

;
;----------------------------------
;
;
;       insert operation
;
;            <<bitmap>>
;
;       ent. B =line counter
;
;----------------------------------
;
INSB:   
        DEC    B               ;last line ?
        JR     Z,INSEND        ;skip if end of func.
INSB1:  
XPIN1:  LD     C,39            ;79 xe
        CALL   INSLIN
        JR     INSB
;
;---------------------------------
;
;
;       insert operation
;
;             <<bitmap end >>
;
;---------------------------------
INSEND: 
LASTC:  LD     C,0             ;patch
INSEF:  CALL   INSLIN
        CALL   PONTCB
XPIN2:  LD     DE,40           ;cwidth 80
        LD     B,8
        DI
        LD     A,(CPLANE)
        OR     80H             ;replace mode
        OUT    (LSWF),A
        IN     A,(LSE0)        ;bank change
        OUT    (LSE0),A        ;cg off
INSB01: XOR    A
        LD     (HL),A          ;space fill
        ADD    HL,DE
        DJNZ   INSB01
        IN     A,(LSE1)        ;bank off
        EI
        RET
;
        SKP    H

;----------------------------------
;
;       insert operation
;
;              1 line only
;
;   ent.
;         HL=first destination addr
;         C =bytes
;
;----------------------------------
INSLIN: 
        EXX
        LD     D,9             ;laster counter set
INSL1:  LD     HL,(MAXCF)      ;
        DEC    D               ;last laster ?
        EXX
        RET    Z
        CALL   INSLAS
XPIN3:  LD     DE,FFD8H        ;FFB0h <--80
        ADD    HL,DE
        EXX
        JR     INSL1
;
;
;
;
;---------------------------------
;
;       insert operation
;
;              1 laster only
;
;
;   ent.  E'=plane data(maxcf)
;         HL=first destination addr
;         C=bytes
;
;---------------------------------
INSLAS: EXX                    ;next plane ?
        RRC    L
        LD     A,L
        EXX
        RET    C               ;next laster
        EXX
        AND    H               ;pmask
        EXX
        JR     Z,INSLAS        ;skip if warp
        PUSH   HL
        PUSH   BC
        DI
        OUT    (LSRF),A        ;read plane
        OUT    (LSWF),A        ;write plane
        IN     A,(LSE0)        ;bank change
        OUT    (LSE0),A        ;cg off
        LD     D,H
        LD     E,L
        DEC    HL
        LD     A,C
        OR     A

        JR     Z,XPIN4
        LD     A,B             ;line counter
        LD     B,0
        LDDR
        OR     A
        JR     Z,INSLA1        ;skip if last line
XPIN4:  LD     BC,FEE8H        ;FDD0H <--80
        ADD    HL,BC
        LD     A,(HL)
        LD     (DE),A
INSLA1: IN     A,(LSE1)        ;bank off
        EI
        POP    BC
        POP    HL
        JP     INSLAS
;
;-------------------------------
;
;
;   line cal
;
;
;-------------------------------
;
LINCAL: 
        LD     B,1
XPLI1:  LD     A,39            ;xe 39 or 79
        SUB    L
        LD     C,A
        EXX
XPLI2:  LD     DE,40           ;cwidth 80
        LD     H,0
        LD     L,A
        EXX
LINC1:  INC    H               ;next line check
        LD     A,(YE)
        CP     H
        JR     C,LINC2         ;scrool end check
        CALL   TBCALC
        LD     A,(HL)
        OR     A
        LD     H,E
        JR     Z,LINC2         ;manage ment check
        INC    B
        EXX
        ADD    HL,DE
        EXX
        JR     LINC1
;
;
LINC2:  LD     L,0
        RET
;
;
;
        END
        SKP    H

        INCLD  XSCR
;----------------------------------
;
;    scrool main logic
;
;
;
;
;----------------------------------
SCROOL: CALL   PUSHRA
;---------------------------------
;
;  text buf scrool & clr
;
;---------------------------------
SCRTX:  LD     A,(YS)
        LD     H,A
        LD     L,0
        CALL   PONT            ;start addr  cal
        LD     D,H
        LD     E,L             ;DE destination addr
        LD     B,0
XPSC1:  LD     C,40            ;cwidth 80
        ADD    HL,BC           ;HL source addr
;
        LD     A,(YW)          ;scrool lines
        DEC    A
        JR     Z,SCR0          ;skip if 1 line mode
        PUSH   BC
        PUSH   HL
        LD     HL,0
SCR1:   ADD    HL,BC
        DEC    A
        JR     NZ,SCR1
        LD     B,H             ;scrool bytes
        LD     C,L
        POP    HL              ;pop source addr
        LDIR
        POP    BC
SCR0:   LD     B,C
        CALL   ?CLRDE          ;last line clr
;-----------------------------------
;
;   maneger buf scrool & clr
;
;-----------------------------------
        LD     A,(YS)
        LD     H,A
        CALL   TBCALC          ;exit HL maneger addr
        LD     A,(YW)          ;scrool lines
        DEC    A               ;1 line mode check
        LD     B,A
        LD     (HL),0
        INC    HL
        LD     D,H
        LD     E,L
        INC    DE
        CALL   NZ,LDHLDE       ;(hl)<--(de)
        LD     (HL),0          ;last line manegement
;

;----------------------------------
;
;    calculation xferad
;
;----------------------------------
SCRCAL: LD     A,(YE)
        LD     H,A
        LD     L,0             ;HL=(0,YE)
        CALL   PONTB
        LD     (XFERAD+1),HL   ;xferad data
;----------------------------------
;
;    scrool offset calc
;
;----------------------------------
SCXFER: 
        LD     DE,40
        LD     HL,(SOF)        ;lsi scrool offset
        ADD    HL,DE
        PUSH   HL
        LD     DE,(SSW)        ;lsi scrool width
        OR     A
        SBC    HL,DE
        POP    HL
        JR     NZ,SCXF1        ;sof<ssw
        LD     HL,0
SCXF1:  LD     (SOF),HL
;----------------------------------
;
;   scrool  offset out
;
;----------------------------------
;
SCXF2:  IN     A,(LSDMD)       ;lsi status
        AND    40H             ;vblank check
        JR     NZ,SCXF2
        DI
        LD     C,LSSCR         ;lsi scrool port
        LD     B,2
        OUT    (C),H
        DEC    B
        OUT    (C),L
        LD     A,(CMODE)       ;crt mode st
        OUT    (LSRF),A        ;single mode
        OR     80H             ;replace mode
        OUT    (LSWF),A
;----------------------------------
;
;  xfer   buffer -->> graphic ram
;
;----------------------------------
        IN     A,(LSE0)        ; bank change
        OUT    (LSE0),A        ; cg off
XFERAD: LD     HL,0            ;LD HL,xxxxh
        LD     (HL),0
        LD     D,H
        LD     E,L
        INC    DE
XPSC2:  LD     BC,319          ;xfer bytes
        LDIR

        IN     A,(LSE1)        ;  bank reset
        EI
;----------------------------------
;
;
;      scrool operation ended
;
;        cursor window end pos
;
;----------------------------------
BOS:    
        LD     A,(YE)
        LD     H,A
        LD     L,0
        JP     CURMOV
;
        END
        SKP    H

        INCLD  XCURSOR
;-------------------------------
;
;     cursor  routines
;
;
;
;
;
;-------------------------------
;
CURSOR: 
        CALL   PUSHRA
;
;cursor data pattern
        EXX
        PUSH   HL              ;push hl'
        LD     HL,CURDT1
        LD     A,(CURMAK)
        OR     A
        JR     Z,CURS0
        LD     HL,CURDT2
        DEC    A
        JR     Z,CURS0
        LD     HL,CURDT3
CURS0:  EXX
;
        DI
        LD     A,(CURFLG)
        XOR    1
        LD     (CURFLG),A
        LD     HL,(BITADR)
        LD     D,0
        LD     A,(CWIDTH)
        LD     E,A
        LD     B,8             ;counter
        LD     A,(CMODE)
        OR     20H             ;xor mode
        OUT    (LSWF),A        ;wf
        IN     A,(LSE0)        ;bank change
        OUT    (LSE0),A        ;cg off
;
CURS1:  EXX
        LD     A,(HL)
        INC    HL
        EXX
        LD     (HL),A
        ADD    HL,DE
        DJNZ   CURS1
        IN     A,(LSE1)        ;bank reset
        EXX
        POP    HL              ;pop hl'
        EXX
        EI
        RET
;
;
;
HCURON: ENT
        CALL   PUSHRA

        XOR    A
        OUT    (LSD0),A        ;reset 556
        CPL
        OUT    (LSD0),A
        LD     A,(CURFLG)
        OR     A
        RET    NZ
        JR     CURSOR
;
;
HCUROF: ENT
        CALL   PUSHRA
        LD     A,(CURFLG)
        OR     A
        RET    Z
        JR     CURSOR
;
;
FLASH:  ENT
        IN     A,(LSD2)        ;bit 6
        RLCA
        RLCA
        JR     NC,HCURON
        JR     HCUROF
;
;--------------------------------
;
;   cursor   move
;
;                ent HL x,y
;
;--------------------------------
;
CURMOV: ENT
        CALL   PUSHR
        LD     (CURXY),HL
        CALL   PONT            ;cursor addr cal
        LD     (POSADR),HL
        CALL   PONTCB          ;bitmap cursor pos cal
        LD     (BITADR),HL
        RET
        SKP    H

;-------------------------------
;
;   poniter calc
;
;          ent hl=curxy
;              hl=text addr
;-------------------------------
PONTC:  ENT
        LD     HL,(CURXY)
PONT:   ENT
        PUSH   DE
        PUSH   AF
        LD     D,20H           ;offset textbuf
        LD     E,L
        LD     A,H
        ADD    A,A             ;2
        ADD    A,A             ;4
        ADD    A,H             ;5
        LD     L,A
        LD     H,0
        ADD    HL,HL           ;10
        ADD    HL,HL           ;20
        ADD    HL,HL           ;40
XPCU1:  NOP                    ;ADD HL,HL *80
        ADD    HL,DE
        POP    AF
        POP    DE
        RET
        SKP    H

;----------------------------------
;
;     pointer cal
;
;         ent hl=curxy
;             hl=bitmap addr
;
;----------------------------------
PONTCB: ENT
        LD     HL,(CURXY)
PONTB:  ENT
        PUSH   DE
        PUSH   AF
        LD     D,H
        LD     E,0             ;de=h*256
        LD     A,L
        LD     L,H             ;l=curx
        LD     H,E             ;h=0
        ADD    HL,HL           ;*2
        ADD    HL,HL           ;*4
        ADD    HL,HL           ;*8
        ADD    HL,HL           ;*16
        ADD    HL,HL           ;*32
        ADD    HL,HL           ;*64
        ADD    HL,DE           ;*320
XPCU2:  NOP                    ;ADD HL,HL *640
        CALL   ADDHLA
        SET    7,H             ;offset bitmap addr
        POP    AF
        POP    DE
        RET
;
;------------------------------
;
;
;
;    cursor left,right,down,up
;
;
;------------------------------
;
HOME:   LD     L,0
        LD     A,(YS)
        LD     H,A
        JP     CSET
;
;
CR2:    CALL   PUSHR
        LD     HL,(CURXY)
        LD     A,L
        OR     A
        JR     NZ,CR1
        CALL   TBCALC
        LD     A,(HL)
        OR     A
        RET    Z
CR1:    LD     A,0DH
        JP     CRT1C
;
;

CTR.M:  XOR    A
        LD     (CRTSFG+1),A    ;sft mode reset
        LD     HL,(CURXY)
        PUSH   HL
        INC    H
        CALL   TBCALC
        LD     A,(YE)
        LD     D,A
CTR.ML: LD     A,M
        OR     A
        JR     Z,CTR.M4
        INC    HL
        INC    E
        LD     A,D
        CP     E
        JR     NC,CTR.ML
CTR.M4: DEC    E
        POP    HL
        LD     H,E
        JR     CTR.M2
;
CDOWN:  LD     HL,(CURXY)
        JR     CDOWN2
;
CRIGHT: LD     HL,(CURXY)
        INC    L
        LD     A,(XE)
        CP     L
        JR     NC,CSET
CTR.M2: 
        LD     L,0
CDOWN2: INC    H
        JR     CDOWN3          ;patch
        PUSH   HL
        CALL   TBCALC
        LD     (HL),1
        POP    HL
CDOWN3: 
        LD     A,(YE)
        CP     H
        JR     NC,CSET
        LD     H,A
        PUSH   HL
        CALL   SCROOL
        POP    HL
CSET:   JP     CURMOV
;
;
CUP:    LD     HL,(CURXY)
        JR     CUP2
;
CLEFT:  LD     HL,(CURXY)
        LD     A,L
        OR     A
        JR     NZ,CSET2
        LD     A,(XE)
        LD     L,A
CUP2:   LD     A,(YS)
        CP     H
        JR     C,CSET3

        LD     A,(YS)
        LD     H,A
        DEFB   3EH
CSET2:  DEC    L
        DEFB   3EH
CSET3:  DEC    H
        JR     CSET
;
;
CTR.F:  
CTR.Y:  XOR    A               ;ALPHA
        DEFB   21H
CTR.E:  LD     A,1             ;Shift lock
        DEFB   21H
CTR.W:  LD     A,2             ;GRAPH
        LD     (CURMAK),A
        RET
;
;----------------------------------
;
;
;
;     tab function
;
;
;----------------------------------
;
CTAB:   LD     B,0             ;tab
        LD     HL,(CURXY)
        INC    L
        LD     A,L
CTAB1:  INC    B
        SUB    10
        JR     NC,CTAB1
        XOR    A
CTAB2:  ADD    A,10
        DJNZ   CTAB2
        LD     L,A
;
        LD     A,(XE)          ;boader check
        CP     L
        RET    C
;
        PUSH   HL
        LD     A,(INPFLG)
        OR     A
        JR     Z,CTAB4
        LD     A,(CURX)
;
        LD     H,A
        LD     A,L
        SUB    H
        JR     Z,CTAB4
        LD     B,A
CTAB3:  PUSH   BC
        LD     A,20H           ;space
        CALL   PLTOUT
        POP    BC
        DJNZ   CTAB3
CTAB4:  POP    HL

        JP     CURMOV
;------------------------------
;
; tab print function
;
;
;------------------------------
RNTT:  ENT
        CALL   CRT1S
        LD     A,(CURX)
        SUB    10
        JR     NC,-2
        ADD    A,10
        RET    Z
        JR     PRNTT
;
;
        END
        SKP    H

        INCLD  XKB
;------------------------------
;
;   GET LINE     V0.1A
;
;                  '84.7.11
;
;------------------------------
;
BINPUT: ENT
        PUSH   HL
        LD     HL,(CURXY)
        PUSH   HL
        PUSH   DE
        CALL   TBCALC
        POP    DE
        LD     M,0
        POP    HL
        CALL   GETL
        JR     C,BINERT
        LD     A,L
        OR     A
        JR     Z,BINERT
        LD     H,0
        ADD    HL,DE
        EX     DE,HL
        OR     A
BINERT: POP    HL
        RET
;
;
GETL:   ENT
        PUSH   BC
        PUSH   HL
        PUSH   DE
LINP02: CALL   INKEY1
        CP     0DH             ;CR?
        JP     Z,GCRT
        CP     1BH             ;Break?
        JR     Z,LINP.B
        PUSH   AF
        LD     A,(CURMAK)
        CP     2               ;Graph mode?
        JR     NZ,LINP10
        POP    AF
        CP     17H
        JR     NC,LINP11
        CP     11H
        JR     C,LINP11
;
        LD     HL,(CTRSFT)
        BIT    6,L             ;Ctrl?
        JR     Z,LINP11
;
LINP32: SVC    .CRT1X
        RST    3
        DEFB   .CRT1X
        ENDM
        JR     LINP02
;

LINP10: POP    AF
LINP11: SVC    .CRT1C
        RST    3
        DEFB   .CRT1C
        ENDM
        JR     LINP02
;
LINP.B: SCF                    ;break key on
LINP80: 
        SVC    .CR1
        RST    3
        DEFB   .CR1
        ENDM
        POP    DE
        POP    HL
        POP    BC
        RET
;
GCRT:   LD     HL,(CURXY)
        CALL   LBOUND          ;begin end search
        LD     A,E
        SUB    D
        LD     E,A             ;E:Y.length
        LD     H,D             ;H:line count
        LD     L,0
        CALL   PONT            ;calc start address
        LD     A,(CWIDTH)      ;X size
        LD     D,A
        POP    BC              ;store address set
        PUSH   BC
        EXX
        PUSH   HL
        LD     HL,(LINLIM)     ;L:line inp limit
        EXX
;
GCRT10: 
        LD     A,(HL)          ;A<--ascii code
GCRT36: INC    HL
        LD     (BC),A          ;(BC)<--ascii code
        INC    BC
        EXX
        DEC    L
        JR     Z,GCRT40        ;line limit?
        EXX
        DEC    D
        JR     NZ,GCRT10       ;X right end ?
        LD     A,(CWIDTH)
        LD     D,A
        DEC    E
        JR     NZ,GCRT10       ;line count=0 ?
        EXX
GCRT40: POP    HL
        EXX
        XOR    A
        LD     (BC),A          ;end address=0
        LD     L,C
        LD     H,B
        POP    DE
        PUSH   DE
        PUSH   HL

        OR     A
        SBC    HL,DE
        LD     B,L
        POP    HL
        LD     A,20H           ;clschr?
        LD     D,A
        JP     Z,LINP80
        DEC    HL
GCRT50: LD     A,M
        OR     A
        JR     Z,GCRT52
        CP     D
        JR     NZ,GCRT54
        LD     M,0
GCRT52: DEC    HL
        DJNZ   GCRT50
        JR     GCRT56
GCRT54: LD     A,M
        OR     A
        JR     NZ,+4
        LD     M," "
        DEC    HL
        DJNZ   GCRT54
GCRT56: OR     A
        JP     LINP80
;
;-------------------------------
;
;     KEY      V0.1A
;
;                   '84.7.11
;
;-------------------------------
;
; INKEY$[(ACC)]
;   A=FF : INKEY$   =GET
;   A=0  : INKEY$(0)=KEY DATA
;   A>0  : INKEY$(1)=FLASH GET
;
INKEY$: ENT
        INC    A
        JR     Z,INKEYFF
        DEC    A
        JP     Z,INKEY0
;
;
INKEY1: ENT
        CALL   KBFCHR
        CALL   PUSHR
        CALL   HCURON
        EX     AF,AF'
        PUSH   AF
        CALL   KEYSNS
        LD     A,(REPTF)
?KEY10: EX     AF,AF'
?KEY12: LD     B,16            ;chattering
?KEY14: CALL   FLASH
        CALL   KEYSNS
        BIT    1,A
        JR     NZ,?KEY12       ;same key ?

        DJNZ   ?KEY14
        BIT    0,A
        JR     Z,?KEY20        ;key on ?
        BIT    2,A
        JR     NZ,?KEY24       ;new key ?
        EX     AF,AF'
        DEC    A
        JR     NZ,?KEY10
        LD     A,6             ;Repeat step time
        JR     ?KEY26
?KEY20: PUSH   HL
        PUSH   DE
        PUSH   BC
        LD     HL,KYDTB2
        LD     DE,KYDTB1
        LD     BC,10
        LDIR                   ;(KYDTB1)<--(KYDTB2)
        POP    BC
        POP    DE
        POP    HL
?KEY24: LD     A,40H           ;Repeat init time
?KEY26: LD     (REPTF),A
?KEY28: CALL   FLASH
        CALL   KEYGET
        OR     A
        JR     Z,?KEY29
        LD     (KEYDAT),A
        LD     C,A
        CALL   HCUROF
        POP    AF
        EX     AF,AF'
        LD     A,C
        RET
;
?KEY29: 
        PUSH   HL
        PUSH   BC
        LD     B,10
        LD     HL,KYDTB1
?KEY30: LD     (HL),FFH
        INC    HL
        DJNZ   ?KEY30
        POP    BC
        POP    HL
        JR     ?KEY28
;
INKEYFF:ENT
        CALL   KBFCHR
        PUSH   HL
        CALL   KEYGET
        LD     HL,KEYDAT
        OR     A
        JR     Z,INKEY9
        CP     M
        JR     NZ,INKEY9
        POP    HL
        XOR    A
        RET
INKEY9: LD     M,A
        POP    HL

        RET
;
INKEY0: ENT
        CALL   KBFCHR
        CALL   KEYGET
        LD     (KEYDAT),A
        RET
;
KBFCHR: PUSH   HL              ;function key buffer
        LD     HL,(INBUFC)
        LD     A,L             ;INBUFC
        CP     H               ;INBUFL
        POP    HL
        RET    Z
        EX     (SP),HL
        INC    A
        LD     (INBUFC),A
        LD     HL,INBUFL       ;INBUF-1
        CALL   ADDHLA
        LD     A,M
        POP    HL
        RET
;
;
;
KEYSNS: CALL   PUSHR
        LD     DE,KYDTB2
        LD     HL,KYDTB1
        LD     BC,0A00H
        DI
KEYSN0: LD     A,B
        ADD    A,EFH
        OUT    (D0H),A
        CP     F8H             ;special strobe
        IN     A,(D1H)
        JR     NZ,+4
        OR     7FH
        CP     FFH
        JR     Z,+4
        SET    0,C             ;bit 0=key on
        EX     DE,HL
        CP     M
        LD     M,A
        EX     DE,HL
        JR     Z,+4
        SET    1,C             ;bit 1=not same key
        CPL
        AND    M
        JR     Z,+4
        SET    2,C             ;bit 2=new key
        INC    HL
        INC    DE
        DJNZ   KEYSN0
        LD     A,C
KEYSNE: EI
        RET
;
KEYGET: CALL   PUSHR
        LD     HL,KYDTB1
        LD     DE,KYDTB2

        PUSH   HL
        PUSH   DE
        LD     BC,10
        LDIR                   ;(KYDTB2)<--(KYDTB1)
        POP    HL
        POP    DE
        LD     BC,0AF9H
        DI
        LD     A,C
        OUT    (D0H),A
        NOP
        IN     A,(D1H)
        LD     (DE),A
KEYGL1: LD     A,C
        OUT    (D0H),A
        CP     F8H             ;special strobe
        IN     A,(D1H)
        LD     (DE),A
        JR     Z,KEYG13
        CPL
        AND    M               ;same--->Acc=0
KEYGL3: LD     M,A
        INC    DE
        INC    HL
        DEC    C
        DJNZ   KEYGL1
        EI
       LD     BC,0A00H
KYSTCK: DEC    HL
        LD     A,M
        OR     A
        JR     NZ,KEYGIN       ;not same-->KEYGIN
        INC    C
        DJNZ   KYSTCK
        LD     B,10
KEYGL2: DEC    DE
        LD     A,(DE)
        CP     FFH
        JR     NZ,REPKIN
REPKI3: DJNZ   KEYGL2
KEYNUL: XOR    A
        JR     KEYSNE
;
KEYG13: XOR    A
        JR     KEYGL3
;
REPKIN: LD     A,B
        CP     2
        JR     NZ,REPKI2
        LD     A,(DE)
        AND    81H
        JR     NZ,REPKI3
        LD     A,1BH           ;break key
        JR     KEYSNE
REPKI2: CP     1
        JR     Z,KEYNUL
        LD     A,(REPCD1)
        CP     B
        JR     NZ,REPKI3
        LD     A,(DE)

        PUSH   DE
        LD     D,A
        LD     A,(REPCD2)
        AND    D
        POP    DE
        JR     NZ,REPKI3
        LD     A,(KEYDAT)
        JR     KEYSNE
;
KEYGIN: PUSH   AF
        LD     A,B
        LD     (REPCD1),A
        LD     A,M
        LD     (REPCD2),A
        POP    AF
        DEC    B
        JR     NZ,KEYGI6
        CALL   ABITB           ;function key
        LD     A,(CTRSFT)
        BIT    6,A
        JR     Z,KEYNUL
        BIT    0,A
        LD     A,B
        JR     NZ,+4
        ADD    A,5
        CP     10
        JR     NC,KEYNUL
        LD     L,A
        LD     H,0
        ADD    HL,HL
        ADD    HL,HL
        ADD    HL,HL
        ADD    HL,HL
        LD     BC,FUNBUF
        ADD    HL,BC
        LD     A,M
        OR     A
        JR     Z,KEYNUL
        LD     DE,INBUFC
        LD     A,1
        LD     (DE),A
        INC    DE
        LD     BC,16
        LDIR
        LD     A,(INBUF)
        JP     KEYSNE
KEYGI6: CALL   ABITB
        LD     A,C
        ADD    A,A
        ADD    A,A
        ADD    A,A
        ADD    A,B
        LD     L,A
        LD     H,0
        LD     A,(CTRSFT)
        BIT    6,A             ;ctrl key
        LD     BC,NOMALB
        JR     Z,CTRLIN
        PUSH   AF
        LD     A,(CURMAK)

        CP     1               ;shift+lock
        JR     NZ,SFTLKL
        POP    AF
        XOR    1
        PUSH   AF
SFTLKL: POP    AF
        BIT    0,A             ;shift key
        JR     NZ,+5
        LD     BC,SHIFTB
        LD     A,(CURMAK)
        CP     2               ;graph
        JR     NZ,CHRSET
        LD     BC,GRPHB
        LD     A,(CTRSFT)
        BIT    0,A
        JR     Z,CHRSET
        LD     BC,GRPHS
CHRSET: CALL   ?KYTBL
        LD     A,C
        JP     KEYSNE
CTRLIN: CALL   ?KYTBL
        LD     A,C
        CP     20H
        JP     C,KEYSNE
        LD     HL,CTKYTB
        LD     B,5
        CP     M
        JR     Z,CTRLC1
        INC    HL
        DJNZ   -4
        CP     40H
        JP     C,KEYNUL
        CP     5BH
        JP     NC,KEYNUL
        SUB    40H
        JP     KEYSNE
CTRLC1: LD     A,32
        SUB    B
        JP     KEYSNE
;
ABITB:  LD     B,8
        RRCA
        JR     C,ABITB2
        DJNZ   -3
        RET
ABITB2: DEC    B
        RET
;
;
BRKEY:  ENT
        LD     A,E8H
        OUT    (D0H),A
        NOP
        IN     A,(D1H)
        AND    81H
        RET    Z
        RLCA
        RET    C
        JR     BRKEY
;

KYDTB1: DEFS   1
CTRSFT: DEFS   9
KYDTB2: DEFS   10
REPTF:  DEFB   0
REPCD1: DEFB   0
REPCD2: DEFB   1
;
;
NOMALB: DEFW   0BEAH
        DEF8   90,17,FC,19,09,3B,3A,0D
        DEFW   1790H
        DEFW   19FCH
        DEFW   3B09H
        DEFW   0D3AH
        ENDM
        DEF8   18,10,12,11,13,14,3F,2F
        DEFW   1018H
        DEFW   1112H
        DEFW   1413H
        DEFW   2F3FH
        ENDM
;
SHIFTB: DEFW   0C2AH
        DEF8   90,17,FB,05,09,2B,2A,0D
        DEFW   1790H
        DEFW   05FBH
        DEFW   2B09H
        DEFW   0D2AH
        ENDM
        DEF8   16,15,12,11,13,14,C6,5F
        DEFW   1516H
        DEFW   1112H
        DEFW   1413H
        DEFW   5FC6H
        ENDM
;
GRPHB:  DEFW   0CE9H
        DEF8   90,17,68,05,09,84,E9,0D
        DEFW   1790H
        DEFW   0568H
        DEFW   8409H
        DEFW   0DE9H
        ENDM
        DEF8   16,15,12,11,13,14,8F,8B
        DEFW   1516H
        DEFW   1112H
        DEFW   1413H
        DEFW   8B8FH
        ENDM
;
GRPHS:  DEFW   0C6AH
        DEF8   90,17,6C,19,09,FE,89,0D
        DEFW   1790H
        DEFW   196CH
        DEFW   FE09H
        DEFW   0D89H
        ENDM
        DEF8   16,15,12,11,13,14,8A,7B
        DEFW   1516H
        DEFW   1112H

        DEFW   1413H
        DEFW   7B8AH
        ENDM
;
CTKYTB: DEFB   5BH             ;  [
        DEFB   5CH             ;  \
        DEFB   5DH             ;  ]
        DEFB   5EH             ;  ^
        DEFB   2FH             ;  /
        END
        SKP    H

        INCLD  XPL2
;-----------------------------------
;
;
;  CRT message out
;
;   05H,06H simulated
;
;      ent. DE=msg top addr
;           eof is NULL
;           mode code 05h,06h
;          CR is reset mode
;-----------------------------------
;
CRTSIMU:CALL   PUSHR
CRTSI2: LD     A,(DE)          ;get msg data
        INC    DE              ;next pointer
        OR     A
        RET    Z               ;eof code is NULL
        LD     C,A
        CP     05H             ;sft lock in
        JR     Z,CRTSIE        ;CTR.E
        CP     06H             ;normal mode
        JR     Z,CRTSIF        ;CTR.F
        SUB    "A"
        CP     26
        JR     NC,CRTSI4       ;skip not if code A-Z
CRTSFG: LD     A,0             ;xxx
        OR     A
        JR     Z,CRTSI4
        LD     HL,SMLTBL-"A"   ;sftlock code trans.
        LD     B,0
        ADD    HL,BC
        LD     C,M
;
CRTSI4: LD     A,C
        SVC    .CRT1C
        RST    3
        DEFB   .CRT1C
        ENDM
        CP     0DH
        JR     NZ,CRTSI2
CRTSIF: XOR    A
CRTSIE: LD     (CRTSFG+1),A
        JR     CRTSI2
;
SMLTBL: 
        DEFB   0A1H            ;a
        DEFB   09AH            ;b
        DEFB   09FH            ;c
        DEFB   09CH            ;d
        DEFB   092H            ;e
        DEFB   0AAH            ;f
        DEFB   097H            ;g
        DEFB   098H            ;h
        DEFB   0A6H            ;i
        DEFB   0AFH            ;j
        DEFB   0A9H            ;k
        DEFB   0B8H            ;l
        DEFB   0B3H            ;m

        DEFB   0B0H            ;n
        DEFB   0B7H            ;o
        DEFB   09EH            ;p
        DEFB   0A0H            ;q
        DEFB   09DH            ;r
        DEFB   0A4H            ;s
        DEFB   096H            ;t
        DEFB   0A5H            ;u
        DEFB   0ABH            ;v
        DEFB   0A3H            ;w
        DEFB   09BH            ;x
        DEFB   0BDH            ;y
        DEFB   0A2H            ;z
        SKP    H

EQTBL:  ENT
;---------------------------------
;
;
;
; CRT/KB driver
;
;
;---------------------------------
$CRT:   ENT
        DEFW   $KB
        DEFM   "CRT"
        DEFB   0
        DEFB   8AH             ;Streem, O1C, W
        DEFW   0
        DEFW   CRTINI
        DEFW   .RET            ;ROPEN
        DEFW   .RET            ;WOPEN
        DEFW   .RET            ;CLOSE
        DEFW   .RET            ;KILL
        DEFW   CRTIN
        DEFW   CRTOUT
        DEFW   CRTPOS
$KB:    ENT
        DEFW   $LPT
        DEFM   "KB"
        DEFW   0
        DEFB   81H             ;Streem, R
        DEFW   0
        DEFW   .RET            ;INIT
       DEFW   .RET            ;ROPEN
        DEFW   .RET            ;WOPEN
        DEFW   .RET            ;CLOSE
        DEFW   .RET            ;KILL
        DEFW   CRTIN
        DEFW   .RET
        DEFW   .RET
;
CRTIN:  SVC    .GETL
        RST    3
        DEFB   .GETL
        ENDM
        LD     A,80H           ;BREAKZ
        RET    C
        SVC    .COUNT
        RST    3
        DEFB   .COUNT
        ENDM
        RET
CRTOUT: EX     AF,AF'
        LD     HL,CRT1C
        LD     A,(DISPX)       ;0=msg/1=msgx
        OR     A
        JR     Z,+5
        LD     HL,CRT1CX
        EX     AF,AF'
        JP     (HL)
CRTPOS: LD     A,(CURX)
        RET
        SKP    H

;
;----------------------------------
;
;
; CRT(LPT) routine
;
;     CRT1C  &1C
;     CRT1CX &1CX
;     CRTMSG &MSG
;            &CR
;
;---------------------------------
;
&CR:    LD     A,0DH
;
&1C:    PUSH   AF
        LD     A,(FILOUT)      ;0=crt/1=lpt
        OR     A
        JR     NZ,&1CL
        POP    AF
        JR     CRT1C
&1CL:   POP    AF
        JP     LPT1C
;
&1CX:   PUSH   AF
        LD     A,(FILOUT)      ;0=crt/1=lpt
        OR     A
        JR     NZ,&1CXL
        POP    AF
        JR     CRT1CX
&1CXL:  POP    AF
        JP     LPT1CX
;
&MSG:   CALL   PUSHR
        LD     HL,&1C
        JR     CRTMS2
;
CRTMSG: CALL   PUSHR
        LD     HL,CRT1C
CRTMS2: LD     A,(DE)
        OR     A
        RET    Z
        CALL   .HL
        INC    DE
        JR     CRTMS2
        SKP    H

;
CRT1S:  LD     A," "
CRT1C:  ENT
        CALL   PUSHRA
CRT1C0: 
        LD     C,A
        LD     A,(INPFLG)      ;plot on/off
        OR     A
        JR     Z,CRT1C9        ;skip if plot off
        LD     A,C
        CP     20H
        JR     NC,CRT1C4       ;skip if normal ascii
        LD     DE,(CURXY)      ;control code only
        LD     HL,(XS)
        CP     14H
        JR     Z,CRT1C1        ;skip if left code
        CP     12H
        JR     NZ,CRT1C2       ;
        LD     HL,(YS)         ;skip if up code
        LD     E,D
CRT1C1: LD     A,L
        CP     E
        JP     NC,BEEP         ;error range
CRT1C2: 
        LD     HL,PLTCOD       ;plotter code  trans.
        LD     B,0
        ADD    HL,BC
        LD     A,M
        INC    A
        JR     Z,CRT1C9        ; no operation when ffh
        DEC    A
        JP     Z,BEEP          ;beep when null code
CRT1C4: CALL   PLTOUT
CRT1C9: LD     A,C
        CP     20H
        JP     C,CTRLJB        ;control code trans.
        JP     ACCDI           ;1 byte disply ent.=acc
;
CRT1CX: CALL   PUSHRA
        LD     C,A
        CP     0DH
        JR     Z,CRT1C0
        CALL   ACCDI
        LD     A,(INPFLG)      ;plot on/off
        OR     A
        RET    Z
        LD     A,C
;       JR     PLTOTX
        SKP    H

;
PLTOTX: ENT
        CP     11H
        JR     C,PLT2E
        CP     17H
        JR     C,PLTOK
        CP     20H
        JR     C,PLT2E
PLTOUT: CP     60H
        JR     C,PLTOK
        CP     70H
        JR     C,PLT2E
        CP     C1H
        JR     C,PLTOK
        CALL   CHKACC
        DEFB   3
        DEFW   CFD7H
        DEFB   FFH
        JR     Z,PLTOK
PLT2E:  LD     A,2EH
PLTOK:  JP     LPTOUT
;
PLTCOD: DEFB   0               ;00
        DEFB   0               ;01
        DEFB   0               ;02
        DEFB   0               ;03
        DEFB   FFH             ;04 CTR.D
        DEFB   FFH             ;05 CTR.E
        DEFB   FFH             ;06 CTR.F
        DEFB   1DH             ;07
        DEFB   0               ;08
        DEFB   FFH             ;09 CTAB
        DEFB   0               ;0A
        DEFB   0               ;0B
        DEFB   0               ;0C
        DEFB   0DH             ;0D
        DEFB   0               ;0E
        DEFB   0               ;0F
        DEFB   0               ;10 DEL
        DEFB   0AH             ;11 DOWN
        DEFB   03H             ;12 UP
        DEFB   20H             ;13 RIGHT
        DEFB   0EH             ;14 LEFT
        DEFB   0               ;15 HOME
        DEFB   0               ;16 CLR
        DEFB   FFH             ;17 GRAPH
        DEFB   0               ;18 INST
        DEFB   FFH             ;19 ALPHA
        DEFB   FFH             ;1A KANA
        DEFB   0DH             ;1B
        DEFB   FFH             ;1C hirakana
        DEFB   0               ;1D
        DEFB   0               ;1E
        DEFB   0               ;1F
        SKP    H

;
;--------------------------------
;
;  Monitor hot start
;
;
;--------------------------------
STARTP: 
        DI
        XOR    A
        OUT    (LSDMD),A       ;mz-800 320*200 4col
        LD     (INPFLG),A      ;plot on/off
        LD     (FILOUT),A      ;0=crt/1=lpt
        LD     SP,0000H        ;stack pointer set
        IM     2               ;interruptt mode 2
        LD     A,4
        OUT    (LSD3),A        ;8253 int disable
        OUT    (LSE0),A        ;bank dram
        OUT    (LSE1),A        ;bank dram
        CALL   PALOFF          ;palette all off
        LD     A,0FH           ;interrupt vector
        LD     I,A
        LD     A,FEH           ;interrupt addrs
        OUT    (FDH),A         ;PIO int vector set
        LD     A,0FH
        OUT    (FDH),A         ;PIO mode 0
        PUSH   BC
        CALL   CRTPWR          ;CRT power on init
        CALL   PSGPWR          ;PSG power on init
        CALL   EMMPWR          ;EMM power on init
        POP    BC
STRTP2: DEFB   21H             ;dummy byte
        JR     STRTP9
        XOR    A
        LD     (STRTP2),A
        LD     D,A
        LD     E,A
        SVC    .TIMST
        RST    3
        DEFB   .TIMST
        ENDM
        LD     DE,$CMT
        LD     A,B
        OR     A
        JR     Z,STRTP4
        DEC    A
        JR     Z,STRTP4
        LD     DE,$FD
        DEC    A
        JR     Z,STRTP4
        LD     DE,$QD
STRTP4: LD     A,C
        SVC    .SETDF
        RST    3
        DEFB   .SETDF
        ENDM
STRTP9: JP     COLDST
;
;
;

;
CRTPWR: 
;  check vram option ?
;
        DI
        XOR    A
        OUT    (LSDMD),A       ;320*200 4 color
        LD     A,14H
        OUT    (LSRF),A
        LD     A,94H
        OUT    (LSWF),A
        IN     A,(LSE0)
        OUT    (LSE0),A        ;cg off
        LD     HL,9FFFH
        LD     A,(HL)          ;read
        LD     C,A
        CPL
        LD     (HL),A          ;write
        CP     (HL)            ;verify
        LD     (HL),C          ;pop mem
        LD     A,0
        JR     NZ,CRTPW0
        INC    A
CRTPW0: LD     (MEMOP),A
        IN     A,(LSE1)
        EI
;
        LD     A,1             ;window (0,24)
        CALL   DSMODE          ;320*200 4 color
;
; data free area init
;
;
        XOR    A
        LD     (CURFLG),A      ;cursor off
        LD     (CURMAK),A      ;nomal char
        RET
;
;
        END
        SKP    H

        INCLD  XMON-USR
; -----------------------------
; MZ-2Z009    User I/O driver
; FI:MON-USR  ver 1.0A 03.17.84
; -----------------------------
;
;
;
$USR:   ENT
        DEFW   0
        DEFM   "USR"
        DEFB   0
        DEFB   9FH             ;STRM, FNM, W1C, R1C, W, R
        DEFW   0
        DEFW   .RET            ;INIT
        DEFW   USRRO           ;ROPEN
        DEFW   USRWO           ;WOPEN
        DEFW   .RET            ;CLOSE
        DEFW   .RET            ;KILL
        DEFW   USRIN           ;INP
        DEFW   USROUT          ;OUT
        DEFW   .RET            ;POS
;
USRRO:  
USRWO:  LD     HL,ELMD1
        SVC    .DEASC
        RST    3
        DEFB   .DEASC
        ENDM
        LD     A,D
        OR     E
        JP     Z,ER60
        LD     (ZWRK1),DE
        RET
;
USRIN:  
USROUT: LD     HL,(ZWRK1)
        JP     (HL)
        END
        END

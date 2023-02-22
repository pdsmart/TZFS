; -----------------------------
; MZ-800 BASIC  Graphic command
; FI:GRPH  ver 1.0B 9.21.84
; Programed by T.Miho
; -----------------------------
;
        INCLD  MACRO
;
BITFU2: DEFB   0               ;Default W0/W1
COL:    ENT                    ;Color code
        DEFB   03H
;
;;;;;;;;;;;;;;;
;
; SET/RESET [c,w]x,y
;
SET:    ENT
        DEFB   F6H
RESET:  ENT
        XOR    A
        PUSH   AF
        CALL   COORD0
        SVC    .POSSV
        RST    3
        DEFB   .POSSV
        ENDM
        POP    AF              ;SET/RESET
        PUSH   HL
        EXX
        SVC    .PSET
        RST    3
        DEFB   .PSET
        ENDM
        POP    HL
        RET
;
;;;;;;;;;;;;;;;;;;
;
; LINE/BLINE [c,w] x0,y0,x1,y1,.....
;
LINE:   ENT
        DEFB   F6H
BLINE:  ENT
        XOR    A
        LD     (LINE4+1),A
        CALL   COORD0
        CALL   HCH2CH
LINE2:  EXX
        PUSH   HL              ;YS
        PUSH   DE              ;XS
        EXX
        CALL   COORD
        POP    DE              ;XS
        EX     (SP),HL         ;YS,Text
        EXX
LINE4:  LD     A,0             ;LINE/BLINE
        SVC    .LINE
        RST    3
        DEFB   .LINE
        ENDM

        POP    HL
        TEST1  ","
        CALL   TEST1
        DEFB   ","
        ENDM
        JR     Z,LINE2
        SVC    .POSSV
        RST    3
        DEFB   .POSSV
        ENDM
        RET
        SKP    H

;
;;;;;;;;;;;;;;;;;;;;;;;;
;
; PATTERN [C,W] N,X$
;
PATTER: ENT
        CALL   COLCON
        CALL   IDEEXP
        XOR    A
        BIT    7,D
        JR     Z,GRDSP4
        PUSH   HL
        LD     H,A
        LD     L,A
        SBC    HL,DE
        EX     DE,HL
        POP    HL
        LD     A,1
GRDSP4: EX     AF,AF'
        LD     A,D
        OR     A
        JR     NZ,ER03A
        LD     A,E
        PUSH   AF
        EX     AF,AF'
        PUSH   AF
        CALL   HCH2CH
        CALL   STREXP
        POP    AF
        LD     C,A
        POP    AF
        PUSH   HL
        LD     H,C
        SVC    .PATTR
        RST    3
        DEFB   .PATTR
        ENDM
        POP    HL
        CALL   ENDCHK
        JR     NZ,PATTER
        RET
        SKP    H

;;;;;;;;;;;;;;;;;;;
;
;  POSITION x,y
;
POSITI: ENT
        CALL   COORD
        SVC    .POSSV
        RST    3
        DEFB   .POSSV
        ENDM
        RET
;
;  Get X-Y coordinate
;
COORD0: CALL   COLCON
COORD:  CALL   COORD1          ;Get x,y coordinate
        PUSH   DE
        TEST1  ','
        CALL   TEST1
        DEFB   ','
        ENDM
        CALL   COORD1
        PUSH   DE
        EXX
        POP    HL
        POP    DE
        EXX
        RET
;
;
COORD1: CALL   IDEEXP
        LD     A,D             ;0000 ... 3FFF
        ADD    A,40H           ;C000 ... FFFF
        RET    P
ER03A:  JP     ER03
        SKP    H

;;;;;;;;;;;;;;;;;;;;;;;
;
; color palette
;
PALET:  ENT
        CALL   ENDCHK
        JP     Z,ER01
        CALL   PALRD
        CALL   COLCK2
        AND    03H
        PUSH   AF
        LD     A,(PALBK)
        LD     D,E
        SRL    D
        SRL    D
        CP     D
        JP     NZ,ER22
        TESTX  ','
        CALL   TESTX
        DEFB   ','
        ENDM
        CALL   PALRD
        LD     B,A
        POP    AF
        SVC    .DPLST
        RST    3
        DEFB   .DPLST
        ENDM
        RET
;
PALRD:  CALL   IBYTE
        CP     16              ;0 .. 15 check
        JR     NC,ER03A
        RET
;
        SKP    H

;;;;;;;;;;;;;;;;;;;;
;
;  BOX [c,w] xs,ys,xe,ye
BOX:    ENT
        CALL   COORD0
        EXX
        PUSH   HL              ;YS
        PUSH   DE              ;XS
        EXX
        CALL   HCH2CH
        CALL   COORD
        EXX
        PUSH   HL              ;YE
        PUSH   DE              ;XE
        EXX
        CALL   ENDCHK
        JR     Z,BOX9
        CALL   CH2CH
        CALL   ENDCHK
        LD     A,(COL)
        CALL   NZ,COLCHK
        SCF
BOX9:   EXX
        POP    DE
        POP    HL
        EXX
        POP    DE
        EX     (SP),HL
        SVC    .BOX
        RST    3
        DEFB   .BOX
        ENDM
        POP    HL
        RET
        SKP    H

;
;;;;;;;;;;;;;;;;;;
;
; COLOR c,w
;
COLOR:  ENT
        CALL   COLSUB
        LD     A,(COL)
        SVC    .DCOL
        RST    3
        DEFB   .DCOL
        ENDM
        LD     (SELCOL),A
        LD     A,(PWMODE)
        LD     (BITFU2),A
        CALL   ENDZ
        RET
;
;;;;;;;;;;;;;;;;
;
; COLOR CONTROL EXP
;
COLCON: ENT
        TEST1  ","
        CALL   TEST1
        DEFB   ","
        ENDM
        TEST1  "["
        CALL   TEST1
        DEFB   "["
        ENDM
        JR     NZ,COLCN1
        CALL   COLSUB
        LD     A,(COL)
        SVC    .DGCOL
        RST    3
        DEFB   .DGCOL
        ENDM
        TESTX  "]"
        CALL   TESTX
        DEFB   "]"
        ENDM
        TEST1  ","
        CALL   TEST1
        DEFB   ","
        ENDM
        RET
;
COLCN1: LD     A,(SELCOL)
        LD     (COL),A
        SVC    .DGCOL
        RST    3
        DEFB   .DGCOL
        ENDM
COLCN2: LD     A,(BITFU2)
        LD     (PWMODE),A
        RET
;
COLSUB: TEST1  ","
        CALL   TEST1

        DEFB   ","
        ENDM
        JR     Z,COLC8
        CALL   COLCHK
        LD     (COL),A
        TEST1  ','
        CALL   TEST1
        DEFB   ','
        ENDM
        JR     NZ,COLCN2
COLC9:  CALL   IBYTE
        CP     2
        JR     NC,ER03B
        LD     (PWMODE),A
        RET
;
COLC8:  LD     A,(SELCOL)
        LD     (COL),A
        JR     COLC9
;
COLCHK: ENT
        PUSH   BC
        CALL   IBYTE
        POP    BC
COLCK2: LD     A,(CRTMD1)
        RRA
        JR     C,CMD1
        RRA
        JR     C,CMD2
        RRA
        JR     C,CMD3
CMD1:   LD     A,E
        CP     4
        JR     NC,ER03B
        RET
CMD2:   LD     A,E
        CP     16
        JR     NC,ER03B
        RET
CMD3:   LD     A,E
        CP     2
        RET    C
ER03B:  JP     ER03
;
        SKP    H

;;;;;;;;;;;;;;;;;;;;
;
;PAINT COMMAND
;
PAINT:  ENT
        CALL   COLCON
        CALL   POSITI
        LD     B,0
        LD     DE,PAINTB
        PUSH   DE
        CALL   ENDCHK
        JR     Z,PAINT3
PAINT1: CALL   CH2CH
        PUSH   DE
        CALL   COLCHK
        POP    DE
        LD     (DE),A
        INC    DE
        INC    B
        LD     A,B
        CP     16
        JP     Z,ER01
        CALL   ENDCHK
        JR     NZ,PAINT1
PAINT2: EX     (SP),HL         ;data adrs
        PUSH   HL
        LD     HL,-527
        ADD    HL,SP
        LD     (PAIWED),HL
        POP    HL
        SVC    .PAINT
        RST    3
        DEFB   .PAINT
        ENDM
        JP     C,ER06
        POP    HL
        RET
;
PAINT3: LD     A,(COL)
        LD     (DE),A
        INC    B               ; data count
        JR     PAINT2
PAINTB: DEFS   16
        SKP    H

;;;;;;;;;;;;;;;;;;;;
;
;CIRCLE COMMAND
;
CIRCLE: ENT
        PUSH   HL
        LD     HL,0
        LD     (CW.H+1),HL
        LD     (CW.XS+1),HL
        LD     (CW.YS+1),HL
        LD     (CW.XE+1),HL
        LD     (CW.YE+1),HL
        LD     HL,KK
        CALL   CLRFAC
        LD     HL,FLT2PI
        LD     DE,SK           ;\Åmﬂ·m\l=2PAI
        CALL   LDIR5
        POP    HL
;\s\∫l y›-ƒ
        CALL   COORD0
        SVC    .POSSV
        RST    3
        DEFB   .POSSV
        ENDM
        CALL   HCH2CH
        CALL   IDEEXP
        PUSH   HL
        LD     A,D
        AND    C0H
        JP     NZ,ER03
        EX     DE,HL
        LD     (CW.R+2),HL     ;ﬁŸZs
        LD     (CW.XS+1),HL
        LD     (CW.XE+1),HL
        LD     HL,(INTFAC)
        LD     DE,CIR.R
        CALL   LDIR5
        POP    HL
        CALL   ENDCHK
        JP     Z,CW
        CALL   CH2CH
        TEST1  ','
        CALL   TEST1
        DEFB   ','
        ENDM
        JR     Z,CIRCL2
        CALL   HIRIT
        CALL   ENDCHK
        JP     Z,CW
        CALL   CH2CH
CIRCL2: TEST1  ','
        CALL   TEST1
        DEFB   ','
        ENDM
        JR     Z,CIRCL8
        LD     IX,CW.XS+1
        LD     IY,KK
        CALL   STX
        CALL   ENDCHK
        JP     Z,CW

        CALL   CH2CH
CIRCL8: TEST1  ','
        CALL   TEST1
        DEFB   ','
        ENDM
        JR     Z,CIRCL4
        LD     IX,CW.XE+1
        LD     IY,SK
        CALL   STX
        CALL   ENDCHK
        JP     Z,CW
        CALL   CH2CH
CIRCL4: TESTX  'O'
        CALL   TESTX
        DEFB   'O'
        ENDM
        SCF
        JR     +3
CW:     XOR    A
        PUSH   HL
        PUSH   AF
        LD     HL,KK
        LD     DE,SK
        CALL   SUB
        CALL   LDIR5
        LD     A,(KK)
        OR     A
        LD     B,0
        JR     Z,CW2           ;KK=SK
        LD     HL,KK+1
        RES    7,M
        DEC    HL              ;HL:= ABS(KK-SK)
        LD     DE,FLTPAI
        CALL   CMP
        LD     B,1
        JR     C,CW2           ;        ABS() < PI
        LD     DE,FLT2PI
        CALL   CMP
        LD     B,2
        JR     C,CW2           ;  PI <= ABS() < 2*PI
        LD     B,3             ;2*PI <= ABS()
CW2:    LD     A,(SK+1)
        AND    80H
        OR     B
        LD     B,A
        POP    AF              ;CF='O'
        LD     A,B
        EXX
CW.XS:  LD     DE,0            ;Start X
CW.YS:  LD     HL,0            ;Start Y
CW.H:   LD     BC,0            ;HIRITU
        EXX
CW.XE:  LD     DE,0            ;End X
CW.YE:  LD     HL,0            ;End Y
CW.R:   LD     IX,0            ;R
        SVC    .CIRCL
        RST    3
        DEFB   .CIRCL
        ENDM
        POP    HL

        OR     A
        RET
;
HIRIT:  CALL   IDEEXP
        CALL   PUSHR
        LD     HL,(INTFAC)
        INC    HL
        BIT    7,M
        JP     NZ,ER03
        DEC    HL
        LD     DE,FLONE
        CALL   CMP
        RET    Z
        LD     A,1
        JR     C,HI
        LD     HL,FLONE
        LD     DE,CIRW3
        PUSH   DE
        CALL   LDIR5
        POP    HL
        LD     DE,(INTFAC)
        CALL   DIV
        LD     A,2
HI:     LD     (CW.H+1),A
        LD     DE,256DT
        CALL   MUL
        LD     DE,0.5DT
        CALL   ADD
        CALL   HLFLT
        LD     A,L
        LD     (CW.H+2),A
        BIT    0,H
        RET    Z
        XOR    A
        LD     (CW.H+1),A
        RET
;
STX:    PUSH   IX
        PUSH   IY
        CALL   IDEEXP
        POP    DE              ;KK/SK
        POP    IX
        PUSH   HL
        PUSH   IX
        LD     HL,(INTFAC)
        CALL   LDIR5
        LD     HL,(INTFAC)
        LD     DE,HL
        REP5   INC,DE
        INC    DE
        INC    DE
        INC    DE
        INC    DE
        INC    DE
        ENDM
        CALL   LDIR5
        CALL   COS             ;HL=(INTFAC)+5
        LD     DE,CIR.R
        CALL   MUL
        CALL   STXSUB

        LD     HL,(INTFAC)
        CALL   SIN
        LD     DE,CIR.R
        CALL   MUL
        CALL   NEG
        CALL   STXSUB
        POP    IX
        POP    HL
        RET
;
STXSUB: INC    HL
        BIT    7,M
        PUSH   AF
        RES    7,M
        DEC    HL
        LD     DE,0.5DT
        CALL   ADD
        POP    AF
        INC    HL
        JR     Z,+4
        SET    7,M
        DEC    HL
        CALL   HLFLT
        EX     DE,HL
        POP    HL              ;RET ADRS
        EX     (SP),HL         ;Save coordinate
        LD     M,E
        INC    HL
        LD     M,D
        INC    HL
        INC    HL
        EX     (SP),HL
        JP     (HL)
;
;
;CIRCLE WORK AREA PART-2
;
CIR.R:  DEFS   5
;
CIRW3:  DEFS   5
;
256DT:  DEF5   89,00,00,00,00
        DEFW   0089H
        DEFW   0000H
        DEFB   00H
        ENDM
0.5DT:  DEF5   80,00,00,A7,C6
        DEFW   0080H
        DEFW   A700H
        DEFB   C6H
        ENDM
;
KK:     DEFS   5
SK:     DEFS   5
;
; SYMBOL command
;
DIRARE: EQU    27D0H
;
SMBOL:  ENT

        CALL   COORD0          ;position load
        SVC    .POSSV          ;position input
        RST    3
        DEFB   .POSSV
        ENDM
        CALL   HCH2CH
;string pointer load
        CALL   STREXP
;string zero check
        LD     A,B
        OR     A
        PUSH   BC
        PUSH   HL
        LD     C,B
        LD     B,0
        LD     HL,DIRARE
        EX     DE,HL
        JR     Z,SMBL2
        LDIR                   ;string data xfer
SMBL2:  POP    HL
        CALL   HCH2CH
        CALL   IBYTE           ;yoko bairitsu
        LD     A,D
        OR     E
        JR     Z,ERJP3         ;zero error
        PUSH   DE
        CALL   HCH2CH
        CALL   IBYTE           ;tate bairitsu
        LD     A,D
        OR     E
ERJP3:  JP     Z,ER03          ;zero error
        LD     A,E
        POP    DE
        LD     D,A
        CALL   ENDCHK          ;end check
        PUSH   DE
        JR     Z,SMBL1
        CALL   HCH2CH
        CALL   IBYTE           ;angle load
        LD     A,3
        CP     E
        JP     C,ER03
        LD     A,E
        DEFB   06H
SMBL1:  XOR    A
        POP    DE
        POP    BC
        LD     C,A             ;angle push
        LD     A,B             ;string length
        OR     A
        RET    Z               ;zero return
        LD     A,C             ;angle pop
        PUSH   HL
        EX     DE,HL
        LD     DE,DIRARE
        SVC    .SYMBL
        RST    3
        DEFB   .SYMBL
        ENDM
        POP    HL

        RET
;
        SKP    H

;
;;;;;;;;;;;;;;
;
;  HCOPY 1/2/3
;  CLS   1/2/3
;
HCOPY:  ENT
        CALL   ENDZ
        PUSH   HL
        LD     A,00H           ;ASAHI modify
        SVC    .HCPY
        RST    3
        DEFB   .HCPY
        ENDM
        POP    HL
        RET
;
CLS:    ENT
        CALL   ENDZ
        PUSH   HL
        SVC    .CLS
        RST    3
        DEFB   .CLS
        ENDM
        POP    HL
        RET
;
        END

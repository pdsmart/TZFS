; -----------------------------
; MZ-800 BASIC  Data conversion
; FI:CONV  ver 1.0A 7.18.84
; Programed by T.Miho
; -----------------------------
;
        INCLD  MACRO
;
;
%BAR:   EQU    C4H
%YEN:   EQU    7DH
%POND:  EQU    FBH
;
ENDZ:   ENT
        CALL   ENDCHK
        RET    Z
        JP     ER01
;
TESTP:  ENT
        XOR    A
        LD     (FILOUT),A
        TEST1  FBH             ;/
        CALL   TEST1
        DEFB   FBH
        ENDM
        RET    NZ              ;ZF=0
        TESTX  "P"
        CALL   TESTX
        DEFB   "P"
        ENDM
        CALL   LPTTMD          ;Check text mode
        LD     A,"P"
        LD     (FILOUT),A
        CP     A               ;ZF=1
        RET
;
ASCFIV: ENT
        LD     DE,DGBF00
        LD     B,0             ;Zero sup.
        PUSH   DE
        SVC    .ASCHL
        RST    3
        DEFB   .ASCHL
        ENDM
        POP    DE
        RET
        SKP    H

;
; Fetch subroutines
;
ICH28H: ENT
        INC    HL
HCH28H: ENT
        CALL   HLFTCH
CH28H:  ENT
        CP     "("
        JR     CHXX2
;
HCH29H: ENT
        CALL   HLFTCH
CH29H:  ENT
        CP     ")"
        JR     CHXX2
;
HCH2CH: ENT
        CALL   HLFTCH
CH2CH:  ENT
        CP     ','
;
CHXX2:  INC    HL
        RET    Z
        JP     ER01
;
SKPDI:  ENT
        INC    DE
SKPDE:  ENT
        LD     A,(DE)
        CP     ' '
        JR     Z,SKPDI
        RET
;
;
;(DE)=1.0
LDIR1:  ENT
        LD     HL,FLONE
;(DE)=(HL) 5BYTES SET
LDIR5:  ENT
        LD     BC,5
        LDIR
        RET
        SKP    H

;
;(HL)=DE
FLTHEX: ENT
        CALL   CLRFAC          ;EXT(FLOAT)
        LD     A,E
        OR     D
        RET    Z
        BIT    7,D
        LD     A,7FH
        JR     Z,NORFLH
        LD     A,D
        CPL
        LD     D,A
        LD     A,E
        CPL
        LD     E,A
        INC    DE
        LD     A,FFH
;
NORFLH: LD     B,91H
SFL:    DEC    B
        BIT    7,D
        JR     NZ,FLHXRT
        RL     E
        RL     D
        JR     SFL
FLHXRT: LD     M,B
        INC    HL
        AND    D
        LD     M,A
        INC    HL
        LD     M,E
        DEC    HL
        DEC    HL
        RET
;
;0-9 THEN CY=0
TSTNUM: ENT
        CP     "0"
        RET    C
        CP     ":"
        CCF
        RET
;
;VAR THEN CY=0
TSTVAR: ENT
        CP     5FH
        RET    Z
        CP     "0"
        RET    C
        CP     5BH
        CCF
        RET    C
        CP     ":"
        CCF
        RET    NC
        CP     41H
        RET
        SKP    H

;
;CONV FLOAT(HL)_ASC(DE)
CVFLAS: ENT
        CALL   CLRFAC          ;EXT
        LD     (DGITCO),A
        LD     (DGITFG),A
        LD     (EXPFLG),A
        LD     (PRODFL+1),A
        LD     A,5
        LD     (PRCSON),A
DEFTCL: CALL   SKPDE
        INC    DE
        CP     "+"
        JR     Z,DEFTCL
        CP     "-"
        JR     NZ,CHKAND
        CALL   DEFTCL
        JP     TOGLE
;
CHKAND: CP     "$"
        JR     NZ,ZRSKIP
        PUSH   HL
        EX     DE,HL
        SVC    .DEHEX
        RST    3
        DEFB   .DEHEX
        ENDM
        EX     (SP),HL
        CALL   FLTHEX
        POP    DE
        LD     A,5
        RET
;
ZRSKIP: CP     "0"
        JR     NZ,MDLAG
        LD     A,(DE)
        INC    DE
        JR     ZRSKIP
;
FTCHL:  LD     A,(DE)
        INC    DE
MDLAG:  CP     " "
        JR     Z,FTCHL
        CP     "."
        JR     Z,POINTS
        CALL   TSTNUM
        JR     C,TST23H
        SUB    "0"
        CALL   MULTEN
        CALL   MULDEC
        LD     A,1
        LD     (DGITFG),A
        LD     A,(DGITCO)
        INC    A
        LD     (DGITCO),A
        JR     FTCHL
;
POINTS: LD     A,1
        LD     (PRODFL+1),A
        LD     C,A

POINT:  LD     A,(DE)
        INC    DE
        CP     " "
        JR     Z,POINT
        CALL   TSTNUM
        JR     C,PESC
        INC    C
        SUB    "0"
        JR     Z,SDFGRE
        PUSH   AF
        LD     A,1
        LD     (DGITFG),A
        POP    AF
SDFGRE: PUSH   AF
        LD     A,(DGITFG)
        LD     B,A
        LD     A,(DGITCO)
        ADD    A,B
        LD     (DGITCO),A
        POP    AF
        CALL   MULTEN
        CALL   MULDEC
        JR     POINT
;
PESC:   DEC    C
        JR     Z,TST23H
        CALL   DIVTEN
        JR     PESC
;
;
TST23H: CP     "E"
        JR     Z,EXPON!
;
TSTPRC: DEC    DE
        LD     A,(EXPFLG)
        OR     A
        RET    NZ
PRODFL: LD     A,0             ;xxx
        OR     A
        RET    NZ
        LD     A,5
        RET
;
EXPON!: LD     A,(DE)
        CP     "-"
        JR     Z,EXPON
        CP     "+"
        JR     Z,EXPON
        CALL   TSTNUM
        JR     C,TSTPRC
EXPON:  LD     A,1
        LD     (PRODFL+1),A
        PUSH   HL
        LD     HL,MUL
        LD     (EXJPVC),HL
        LD     HL,0000H
        LD     A,(DE)
        INC    DE
        CP     "+"
        JR     Z,CBEGIN

        CP     "-"
        JR     NZ,CLMIDL
        PUSH   HL
        LD     HL,DIV
        LD     (EXJPVC),HL
        POP    HL
CBEGIN: LD     A,(DE)
        INC    DE
CLMIDL: SUB    "0"
        JR     C,ESCPER
        CP     0AH
        JR     NC,ESCPER
        PUSH   DE
        CALL   ADHLCK
        LD     E,L
        LD     D,H
        CALL   ADHLCK
        CALL   ADHLCK
        CALL   ADDECK
        LD     E,A
        LD     D,0
        CALL   ADDECK
        POP    DE
        JR     CBEGIN
ESCPER: LD     A,H
        OR     A
        JR     NZ,OVERF'
        LD     A,L
        POP    HL
        PUSH   DE
        PUSH   BC
        PUSH   HL
        LD     DE,ZFAC
        PUSH   DE
        CALL   LDIR1
        POP    HL
        LD     B,A
        INC    B
        JR     +5
        CALL   MULTEN
        DJNZ   -3
        EX     DE,HL
        POP    HL
        DEFB   CDH
EXJPVC: DEFS   2
        POP    BC
        POP    DE
        JP     TSTPRC
;
DIVTEN: PUSH   AF
        PUSH   BC
        PUSH   DE
        LD     DE,FLTEN
        CALL   DIV
        POP    DE
        POP    BC
        POP    AF
        RET
;
ADDECK: ADD    HL,DE

        RET    NC
        JR     OVERF'
;
ADHLCK: ADD    HL,HL
        RET    NC
OVERF': JP     ER02            ;OVERFLOW
;
MULDEC: PUSH   DE
        PUSH   HL
        LD     HL,ZFAC         ;*****
        LD     E,A
        LD     D,0
        CALL   FLTHEX
        EX     DE,HL
        POP    HL
        PUSH   BC
        CALL   ADD
        POP    BC
        POP    DE
        RET
;
;
;CONV ASC(DE)_FLOAT(HL)
CVNMFL: ENT
        LD     A,5
        LD     (PRCSON),A
        LD     A,M
        OR     A
        JR     Z,ONLYZ#
        INC    HL
        LD     A,M
        DEC    HL
        RLCA
ONLYZ#: LD     A,20H
        JR     NC,PLUS
        CALL   TOGLE
        LD     A,"-"
PLUS:   PUSH   AF
        CALL   CVASF1
        CALL   ADJDGT
        POP    AF
        DEC    DE
        LD     (DE),A
        RET
;
;
CMP2:   PUSH   BC
        CALL   CMP
        POP    BC
        RET
        SKP    H

;
INT:    ENT
        CALL   PUSHR
        LD     A,M
        CP     81H
        JP     C,CLRFAC
        LD     A,M
        CP     A0H
        RET    NC
        INC    HL
        CALL   RCHLBC
        PUSH   HL
        LD     L,M
        LD     B,0
INTSFL: SRL    E
        RR     D
        RR     C
        RR     L
        INC    A
        INC    B
        CP     A0H
        JR     NZ,INTSFL
INTSBL: SLA    L
        RL     C
        RL     D
        RL     E
        DJNZ   INTSBL
        LD     A,L
        POP    HL
        LD     M,A
        DEC    HL
        LD     M,C
        DEC    HL
        LD     M,D
        DEC    HL
        LD     M,E
        RET
;
RCHLBC: LD     E,M
        INC    HL
        LD     D,M
        INC    HL
        LD     C,M
        INC    HL
        RET
        SKP    H

;
FRACT:  ENT
        LD     A,M
        CP     81H
        RET    C
        PUSH   DE
        PUSH   HL
        LD     DE,FRACW
        PUSH   DE
        CALL   LDIR5
        POP    HL
        CALL   INT
        EX     DE,HL
        POP    HL
        CALL   SUB
        POP    DE
        RET
;
FRACW:  DEFS   5
;
;
MULTEN: PUSH   AF
        PUSH   BC
        PUSH   DE
        LD     DE,FLTEN
        CALL   MUL
        POP    DE
        POP    BC
        POP    AF
        RET
        SKP    H

;
HLFLT:  ENT
        INC    HL
        BIT    7,M
        JR     Z,NORHLC
        CALL   NORHLC
        LD     A,H
        CPL
        LD     H,A
        LD     A,L
        CPL
        LD     L,A
        INC    HL
        RET
;
NORHLC: DEC    HL
        LD     A,M
        CP     91H
        JP     NC,ER02         ;OVERFLOW
        CP     81H
        JR     C,HXZRRT
        PUSH   AF
        INC    HL
        LD     A,M
        INC    HL
        LD     L,M
        LD     H,A
        POP    AF
        SET    7,H
HXFLSL: CP     90H
        RET    Z
        INC    A
        SRL    H
        RR     L
        JR     HXFLSL
;
HXZRRT: CCF
        LD     HL,0
        RET
;
;
SNGMXO: DEF5   9B,3E,BC,20,00
        DEFW   3E9BH
        DEFW   20BCH
        DEFB   00H
        ENDM
SNGMXP: DEF5   98,18,96,80,00
        DEFW   1898H
        DEFW   8096H
        DEFB   00H
        ENDM
        DEF5   94,74,24,00,00
        DEFW   7494H
        DEFW   0024H
        DEFB   00H
        ENDM
        DEF5   91,43,50,00,00
        DEFW   4391H
        DEFW   0050H
        DEFB   00H

        ENDM
        DEF5   8E,1C,40,00,00
        DEFW   1C8EH
        DEFW   0040H
        DEFB   00H
        ENDM
        DEF5   8A,7A,00,00,00
        DEFW   7A8AH
        DEFW   0000H
        DEFB   00H
        ENDM
        DEF5   87,48,00,00,00
        DEFW   4887H
        DEFW   0000H
        DEFB   00H
        ENDM
FLTEN:  ENT
        DEF5   84,20,00,00,00
        DEFW   2084H
        DEFW   0000H
        DEFB   00H
        ENDM
FLONE:  ENT
        DEF5   81,00,00,00,00
        DEFW   0081H
        DEFW   0000H
        DEFB   00H
        ENDM
        DEF5   7D,4C,CC,CC,CD
        DEFW   4C7DH
        DEFW   CCCCH
        DEFB   CDH
        ENDM
SLLMT:  DEF5   66,2B,CC,77,12
        DEFW   2B66H
        DEFW   77CCH
        DEFB   12H
        ENDM
        SKP    H

;
EXPASC: LD     HL,(HLBUF2)
        LD     B,0
TENCOM: LD     DE,FLTEN
        CALL   CMP2
        JR     C,ONECOM
        CALL   DIVTEN
        INC    B
        JR     TENCOM
ONECOM: LD     DE,FLONE
        CALL   CMP2
        JR     NC,COMOK
        CALL   MULTEN
        DEC    B
        JR     ONECOM
COMOK:  PUSH   BC
        CALL   CVASF1
        CALL   ADJDGT
        POP    BC
        PUSH   DE
        EX     DE,HL
SERNOP: LD     A,M
        OR     A
        JR     Z,SEROK
        INC    HL
        JR     SERNOP
SEROK:  DEC    HL
        LD     A,M
        INC    HL
        CP     "0"
        JR     NZ,USEXPE
        INC    B
        DEC    HL
USEXPE: LD     A,"E"
        LD     M,A
        INC    HL
        LD     A,B
        LD     B,"+"
        BIT    7,A
        JR     Z,EXSGPT
        NEG
        LD     B,"-"
EXSGPT: LD     M,B
        INC    HL
        LD     M,"0"
EXTNPT: SUB    0AH
        JR     C,EXONPT
        INC    M
        JR     EXTNPT
EXONPT: ADD    A,3AH
        INC    HL
        LD     M,A
        INC    HL
        LD     M,0
        POP    DE
        RET
        SKP    H

;
INTPAR: PUSH   HL
        CALL   HLFLT
        LD     DE,DGBF11
        PUSH   DE
        LD     B,1             ;Non zero-sup.
        SVC    .ASCHL
        RST    3
        DEFB   .ASCHL
        ENDM
        POP    HL
        LD     A,"0"
        LD     B,5
        CP     M
        JR     NZ,INTDGO
        INC    HL
        DJNZ   -4
        JR     INTDGE
INTDGO: LD     A,B
        LD     (DGITCO),A
        LD     A,1
        LD     (DGITFG),A
INTDGE: LD     A,"."
        LD     (DGBF16),A
        POP    HL
        CALL   FRACT
        JP     FRACDG
;
;
CVASF1: LD     (HLBUF2),HL
        XOR    A
        LD     (DGITCO),A
        LD     (DGITFG),A
        PUSH   HL
        LD     HL,DGBF07
        LD     M,FFH
        LD     B,33
        LD     A,"0"
        INC    HL
        LD     M,A
        DJNZ   -2
        LD     A,"."
        LD     (DGBF16),A
        POP    HL
        LD     A,M
        OR     A
        RET    Z
        LD     DE,SNGMXO
        CALL   CMP
        CCF
        RET    C
        LD     DE,SLLMT
        CALL   CMP
        RET    C
        LD     DE,ZFAC1
        PUSH   DE
        CALL   LDIR5
        POP    HL
        LD     A,M
        CP     81H

        JR     C,FRACDG        ;
        CP     90H
        JP     C,INTPAR        ;
        LD     IX,DGBF08
        LD     DE,SNGMXP
        CALL   GENDGT
        CALL   GEND?
        RET    NC              ;C=0
FRACDG: LD     IX,DGBF17
FRCAGN: LD     DE,SNGMXO
        PUSH   BC
        PUSH   IX
        CALL   MUL
        POP    IX
        POP    BC
        REP5   INC,DE
        INC    DE
        INC    DE
        INC    DE
        INC    DE
        INC    DE
        ENDM
        CALL   GENDGT
        CALL   GEND?
        JR     C,FRCAGN
        RET
;
;
CVASFL: ENT
        LD     A,5
        LD     (PRCSON),A
        PUSH   HL
        LD     DE,ZFAC2
        PUSH   DE
        CALL   LDIR5
        POP    HL
        CALL   CVASF1
        CALL   ADJDG2
        POP    HL
        RET
;
ZERADJ: LD     DE,DGBF16
        LD     (DE),A
        DEC    DE
        RET
;
ADJDG2: JP     C,EXPASC
ADJDGT: LD     HL,(HLBUF2)
        LD     A,M
        OR     A
        JR     Z,ZERADJ
        LD     DE,DGBF08
        DEC    DE
        EX     DE,HL
        LD     DE,1
SSNTO1: INC    HL
        LD     A,M
        CP     "."
        JR     NZ,TST30H
        LD     DE,0

        JR     SSNTO1
TST30H: CP     "0"
        JR     Z,SSNTO1
        ADD    HL,DE
        LD     DE,8
        ADD    HL,DE
        LD     A,M
FRCASL: LD     M,"0"
        CP     35H
        JR     C,BCKSER
ADDLOP: DEC    HL
        LD     A,M
        CP     "."
        JR     Z,ADDLOP
        INC    A
        JR     Z,MAXNO
        LD     M,A
        CP     ":"
        JR     Z,FRCASL
        INC    HL
BCKSER: LD     DE,DGBF16
        EX     DE,HL
        OR     A
        SBC    HL,DE
        EX     DE,HL
        JR     C,KUMI
        LD     HL,DGBF16
        JR     INTDI2
KUMI:   DEC    HL
        LD     A,M
        CP     "."
        DEC    HL
        JR     Z,INTDIS
        INC    HL
        CP     "0"
        JR     Z,BCKSER
        PUSH   HL
        LD     DE,DGBF25
        SBC    HL,DE
        POP    HL
        JP     NC,EXPASC
INTDIS: INC    HL
INTDI2: LD     M,0
        LD     DE,DGBF08
TSTFST: LD     A,(DE)
        CP     "0"
        JR     NZ,ZEONLY
        INC    DE
        JR     TSTFST
ZEONLY: OR     A
        RET    NZ
        DEC    DE
        LD     A,"0"
        LD     (DE),A
        RET
;
;
MAXNO:  LD     HL,DGBF00
        LD     DE,M1E08
        PUSH   BC

        LD     BC,6
        LDIR
        POP    BC
        LD     DE,DGBF00
        RET
;
M1E08:  DEFM   "1E+08"

        DEFB   0
;
;
GENDGT: LD     A,(DE)
        CP     7DH
        RET    Z
INTGDL: CALL   CMP
        JR     C,GTESTB
        INC    (IX+0)
        PUSH   IX
        PUSH   BC
        CALL   SUB
        POP    BC
        POP    IX
        LD     A,1
        LD     (DGITFG),A
        JR     INTGDL
;
GTESTB: INC    IX
        REP5   INC,DE
        INC    DE
        INC    DE
        INC    DE
        INC    DE
        INC    DE
        ENDM
        LD     A,(DGITFG)
        LD     B,A
        LD     A,(DGITCO)
        ADD    A,B
        LD     (DGITCO),A
        CALL   GEND?
        RET    NC
        JR     GENDGT
;
GEND?:  LD     A,M
        OR     A
        RET    Z
        LD     A,(DGITCO)
        CP     9
        RET
;
DGITCO: DEFS   1
DGITFG: DEFS   1
EXPFLG: DEFS   1
HLBUF2: DEFS   2
;
        SKP    H

;
; USING CONVERSION
;
USINGS: ENT
        DEFS   2               ;USING START
USINGP: ENT
        DEFS   2               ;USING POINTER
;
USNGSB: ENT
        LD     HL,(USINGP)
        PUSH   DE
USNGS2: LD     A,M
        OR     A
        JP     Z,ER03
        CALL   USGCD?
        JR     Z,USNGS4
        LD     (BC),A
        INC    BC
        INC    HL
        JR     USNGS2
USNGS4: EX     AF,AF'
        LD     A,(PRCSON)
        CP     3
        JP     NZ,FLTUSG
        EX     AF,AF'
        CP     "!"
        JP     Z,1CHOUT
        CP     "&"
        JP     Z,2CHOUT
        JP     ER04
;
1CHOUT: EX     (SP),HL
        PUSH   BC
        CALL   CVTSDC
        OR     A
        LD     A," "
        JR     Z,+3
        LD     A,(DE)
        POP    BC
        LD     (BC),A
        INC    BC
AFTPR': POP    HL
        INC    HL
AFTPRT: LD     A,M
        OR     A
        JR     Z,BRTUSG
        CALL   USGCD?
        JR     Z,RETUSG
        LD     (BC),A
        INC    BC
        INC    HL
        JR     AFTPRT
        SKP    H

BRTUSG: LD     HL,(USINGS)
RETUSG: LD     (USINGP),HL
        XOR    A
        LD     (BC),A
        RET
;
2CHOUT: LD     D,2
AG2CH&: INC    HL
        LD     A,M
        CP     "&"
        JR     Z,26FOUN
        INC    D
        CP     " "
        JR     Z,AG2CH&
        JP     ER03
26FOUN: EX     (SP),HL
        LD     A,M
        CP     D
        JR     C,TRIZ&&
        INC    HL
        CALL   INDRCT
        PUSH   BC
        LD     BC,(STRST)
        ADD    HL,BC
        POP    BC
&PRLOP: LD     A,M
        LD     (BC),A
        INC    BC
        INC    HL
        DEC    D
        JR     NZ,&PRLOP
        JP     AFTPR'
;
TRIZ&&: LD     E,M
        INC    HL
        CALL   INDRCT
        LD     A,E
        OR     A
        JR     Z,&&SPCF
        PUSH   BC
        LD     BC,(STRST)
        ADD    HL,BC
        POP    BC
PR&&L1: LD     A,M
        LD     (BC),A
        INC    BC
        INC    HL
        DEC    E
        JR     Z,&&SPC'
        DEC    D
        JR     NZ,PR&&L1
        JP     AFTPR'
&&SPCF: LD     A," "
        LD     (BC),A
        INC    BC
&&SPC': DEC    D
        JR     NZ,&&SPCF
        JP     AFTPR'
        SKP    H

;
; Check using code
;
USGCD?: CALL   CHKACC
        DEFB   4
        DEFM   "!&#+"
        RET    Z
        LD     E,A
        CP     "*"
        JR     Z,USGCD2
        CALL   ?POND
        JR     Z,USGCD2
        CP     "."
        LD     E,"#"
        JR     Z,USGCD2
        CP     %BAR
        RET    NZ
        INC    HL
        LD     A,M
        OR     A
        JP     Z,ER03
        RET
USGCD2: INC    HL
        LD     A,M
        CP     E
        DEC    HL
        LD     A,M
        RET
;
;
FLTUSG: XOR    A
        LD     (FPLUSF),A
        LD     (PUASTF),A      ;PUT * FLG
        LD     (PUYENF),A      ;]
        LD     (PUAFMF),A      ;AFTER-FLG
        LD     (PUCOMF),A      ;PUT , FLG
        LD     (INTLEN),A      ;INT LENGTH
        LD     (RPLUSF),A      ;###+
        LD     (PUEXPF),A      ;^^^^
        DEC    A
        LD     (FRCLEN),A      ;FRAC LENGTH
        EX     AF,AF'
        LD     D,0
        CP     "#"
        JP     Z,PFLENG
        CP     "*"
        JP     Z,ASTRSK
        CALL   ?POND
        JP     Z,YENUSG
        CP     "."
        JP     Z,PULSLS
        CP     "+"
        JP     Z,PLUSUS
        JP     ER04
;
ASTRSK: LD     A,1
        LD     (PUASTF),A
        INC    HL
        INC    D
        INC    HL

        INC    D
        LD     A,M
        CALL   ?POND
        JR     NZ,PULSLS
        JR     YENUS2
;
YENUSG: INC    HL
        INC    D
YENUS2: INC    HL
        INC    D
        LD     (PUYENF),A
        JR     PULSLS
;
PLUSUS: LD     A,1
        LD     (FPLUSF),A
;
PFLENG: INC    HL
        INC    D
;
PULSLS: EX     DE,HL
        DEC    H
PUGTFC: INC    H
        LD     A,(DE)
        INC    DE
        CP     "#"
        JR     Z,PUGTFC
        CP     ","
        JR     NZ,PUCONP
        LD     A,1
        LD     (PUCOMF),A
        JR     PUGTFC
PUCONP: CP     "."
        JR     Z,PUPOIT
        CP     "-"
        JR     NZ,PUAFMO
        LD     A,1
        LD     (PUAFMF),A
        INC    DE
        JR     PUAFQO
PUAFMO: CP     "+"
        JR     NZ,PUAFQO
        LD     A,(FPLUSF)
        OR     A
        JR     NZ,PUAFQO
        LD     A,1
        LD     (RPLUSF),A
        INC    DE
PUAFQO: DEC    DE
        LD     A,H
        LD     (INTLEN),A
        JR     BEGUSG
;
PUPOIT: LD     A,H
        LD     (INTLEN),A
        LD     H,FFH
PUPOFC: INC    H
        LD     A,(DE)
        INC    DE
        CP     "#"
        JR     Z,PUPOFC

        CP     "-"
        JR     NZ,PUCOPQ
        LD     A,1
        LD     (PUAFMF),A
        INC    DE
        JR     PUCOPP
PUCOPQ: CP     "+"
        JR     NZ,PUCOPP
        LD     A,(FPLUSF)
        OR     A
        JR     NZ,PUCOPP
        LD     A,1
        LD     (RPLUSF),A
        INC    DE
PUCOPP: DEC    DE
        LD     A,H
        LD     (FRCLEN),A
        JR     BEGUSG
;
NEXPP': POP    DE
        JR     NEXPPU
;
BEGUSG: LD     H,4
        PUSH   DE
CHEXPU: LD     A,(DE)
        INC    DE
        CP     "^"
        JR     NZ,NEXPP'
        DEC    H
        JR     NZ,CHEXPU
        POP    AF
        LD     A,1
        LD     (PUEXPF),A
NEXPPU: POP    HL
        PUSH   DE
        INC    HL
        LD     A,M
        RES    7,M
        DEC    HL
        LD     (USGSGN),A
        LD     A,(INTLEN)
        LD     D,A
        DEFB   3EH
FRCLEN: DEFS   1
        LD     E,A
        DEFB   3EH
PUEXPF: DEFS   1
        PUSH   BC
        CALL   USNGCV
        POP    BC
        DEFB   3EH
PUCOMF: DEFS   1
        OR     A
        JR     Z,LADJS1
        PUSH   BC
        PUSH   DE
        LD     A,(INTLEN)
        LD     L,A
        LD     H,0
        ADD    HL,DE

        LD     DE,DGBF00
        LD     C,0
        DEC    HL
COMN3D: LD     B,3
COMSK3: LD     A,M
        CP     " "
        JR     Z,ESCPUC
        INC    C
        LD     (DE),A
        INC    DE
        DEC    HL
        DJNZ   COMSK3
        LD     A,M
        CP     " "
        JR     Z,ESCPUC
        LD     A,","
        LD     (DE),A
        INC    DE
        INC    C
        JR     COMN3D
;
ESCPUC: DEFB   3EH
INTLEN: DEFS   1
        CP     C
        JP     C,ER02
        LD     B,C
        LD     L,A
        LD     H,0
        POP    DE
        PUSH   DE
        ADD    HL,DE
        LD     DE,DGBF00
        DEC    HL
        LD     A,(DE)
        LD     M,A
        DEC    HL
        INC    DE
        DJNZ   -4
        POP    DE
        POP    BC
LADJS1: DEFB   3EH
PUAFMF: DEFS   1
        OR     A
        JR     NZ,LADJS2
        DEFB   3EH
RPLUSF: DEFS   1
        OR     A
        JR     NZ,LADJS2
        DEFB   3EH
FPLUSF: DEFS   1
        OR     A
        JR     NZ,PTPLS1
        LD     A,(USGSGN)
        RLCA
        JR     NC,LADJS2
        LD     A,(DE)
        CP     " "
        LD     H,"-"
        JR     Z,FPUTER
        CP     30H

        JP     NZ,ER02
FPUTER: PUSH   DE
PUPTML: LD     A,(DE)
        INC    DE
        CP     " "
        JR     Z,PUPTML
        CP     30H
        JR     Z,PUPTML
        OR     A
        JR     NZ,+3
        DEC    DE
        DEC    DE
        DEC    DE
        LD     A,H
        LD     (DE),A
        POP    DE
        JR     LADJS2
;
PTPLS1: DEFB   3EH
USGSGN: DEFS   1
        RLCA
        LD     H,"+"
        JR     NC,FPUTER
        LD     H,"-"
        JR     FPUTER
;
LADJS2: DEFB   3EH
PUYENF: DEFS   1
        OR     A
        JR     Z,LADJS3
        LD     A,(DE)
        CP     " "
        JR     NZ,LADJS3
        PUSH   DE
        LD     A,(DE)
        INC    DE
        CP     " "
        JR     Z,-4
        DEC    DE
        DEC    DE
        LD     A,(PUYENF)
        LD     (DE),A
        POP    DE
LADJS3: DEFB   3EH
PUASTF: DEFS   1
        OR     A
        JR     Z,LADJS4
        PUSH   DE
ASTFIL: LD     A,(DE)
        CP     " "
        JR     NZ,LADJ4'
        LD     A,"*"
        LD     (DE),A
        INC    DE
        JR     ASTFIL
LADJ4': POP    DE
LADJS4: LD     A,(DE)
        OR     A
        JR     Z,USPRL8
        LD     (BC),A

        INC    BC
        INC    DE
        JR     LADJS4
USPRL8: LD     A,(RPLUSF)
        OR     A
        JR     Z,TST2DH        ;-
        LD     A,(USGSGN)
        RLCA
        LD     A,"+"
LSDVZR: JR     NC,PULSTX
        LD     A,"-"
PULSTX: LD     (BC),A
        INC    BC
        JR     RETPU$
;
TST2DH: LD     A,(PUAFMF)      ;-
        OR     A
        JR     Z,RETPU$
        LD     A,(USGSGN)
        RLCA
        LD     A," "
        JR     LSDVZR
;
RETPU$: POP    HL
        JP     AFTPRT
;
;
?POND:  CP     %POND           ;EX
        RET    Z
        CP     "$"
        RET
        SKP    H

;
USNGCV: OR     A
        JP     Z,USGCV2
        PUSH   DE
        LD     A,M
        OR     A
        JR     Z,USCMOK
        PUSH   HL
        LD     A,D
        LD     DE,ZFAC1
        PUSH   AF
        CALL   LDIR1
        POP    AF
        OR     A
        JR     Z,BMULED
        LD     B,A
        LD     HL,ZFAC1
        JR     +5
        CALL   MULTEN
        DJNZ   -3
BMULED: POP    HL
        LD     B,0
USTNCM: LD     DE,ZFAC1
        CALL   CMP2
        JR     C,USTOCM
        CALL   DIVTEN
        INC    B
        JR     USTNCM
USTOCM: PUSH   HL
        LD     HL,ZFAC1
        CALL   DIVTEN
        POP    HL
USONCM: LD     DE,ZFAC1
        CALL   CMP2
        JR     NC,USCMOK
        CALL   MULTEN
        DEC    B
        JR     USONCM
USCMOK: POP    DE
        PUSH   BC
        CALL   USGCV1
        POP    BC
        PUSH   DE
        LD     A,(DE)
        CP     "."
        JR     NZ,FLADSR
        LD     DE,DGBF16
        DEC    DE
        LD     A,(DE)
        CP     31H
        POP    DE
        PUSH   DE
        JR     NZ,USEX0C
        EX     DE,HL
        INC    HL
        LD     M,31H
        DEC    HL
        JR     MIDDCX
;
FLADSR: LD     A,(DE)

        CP     31H
        JR     NZ,USEX0C
        EX     DE,HL
        INC    HL
        LD     A,M
        DEC    HL
        CP     "."
        LD     A,"0"
        JR     Z,+4
        LD     A," "
        LD     M,A
        INC    HL
        LD     A,M
        CP     "."
        JR     Z,-4
        LD     M,31H
MIDDCX: EX     DE,HL
        INC    B
USEX0C: LD     A,(DE)
        INC    DE
        OR     A
        JR     NZ,USEX0C
        DEC    DE
        JP     USEXPE
;
USGCV2: PUSH   DE
        CALL   USGCV1
        POP    AF
        OR     A
        RET    NZ
        PUSH   HL
        LD     HL,DGBF16
        DEC    HL
        LD     A,"0"
        CP     M
FOVVXC: JP     NZ,ER02
        DEC    HL
        LD     A," "
        CP     M
        JR     NZ,FOVVXC
        POP    HL
        RET
;
USGCV1: PUSH   DE
        CALL   CVASF1
        JP     C,ER02
        POP    HL
        PUSH   HL
        LD     H,0
        INC    L
        JR     Z,+3
        DEC    L
        LD     DE,DGBF17
        ADD    HL,DE
        LD     A,M
        LD     M,0
        DEFB   11H
FRCASU: LD     M,"0"
        CP     35H
        JR     C,BCKSEU

        DEC    HL
        LD     A,M
        CP     "."
        JR     Z,-4
        INC    A
        JP     Z,ER02
        LD     M,A
        CP     ":"
        JR     Z,FRCASU
BCKSEU: LD     HL,KEYBM1       ;¯¯KEYBUF
        LD     DE,2000H
        LD     M,D
        INC    HL
        DEC    E
        JR     NZ,-3
        POP    HL
        PUSH   HL
        LD     E,H
        LD     D,0
        LD     HL,KEYBUF
        ADD    HL,DE
        PUSH   HL
        LD     HL,DGBF07
        LD     M," "
        INC    HL
        LD     D,7
BF00SP: LD     A,M
        CP     "0"
        JR     NZ,BF00ED
        LD     M," "
        INC    HL
        DEC    D
        JR     NZ,BF00SP
BF00ED: POP    HL
        PUSH   HL
        LD     B,E
        LD     A,B
        OR     A
        JR     Z,BFST11
        LD     DE,DGBF16
BFSTL1: DEC    HL
        DEC    DE
        LD     A,(DE)
        LD     M,A
        CP     " "
        JR     Z,BFST11
        DJNZ   BFSTL1
        DEC    DE
        LD     A,(DE)
        CP     " "
        JR     Z,BFST11
        INC    A
        JP     NZ,ER02
;
BFST11: POP    HL
        POP    DE
        INC    E
        JR     Z,EDSTRT
        LD     B,E
        LD     DE,DGBF17

        LD     M,"."
BFSTL2: INC    HL
        DEC    B
        JR     Z,EDSTRT
        LD     A,(DE)
        INC    DE
        LD     M,A
        JR     BFSTL2
EDSTRT: LD     M,0
        LD     DE,KEYBUF
        RET
;
        END

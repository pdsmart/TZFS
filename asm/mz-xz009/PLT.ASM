; -----------------------------
; MZ-800 BASIC  Plotter package
; FI:PLT  ver 1.0A 8.25.84
; Programed by T.Miho
; -----------------------------
;
        INCLD  MACRO
;
P.PLT:  EQU    0
PNCHNM: DEFB   "N"             ;N,S,L
;
NEWON:  ENT
        LD     BC,ER59'
        LD     DE,NEWONT       ;NEW ON
NEWON2: LD     A,(DE)          ; omit plotter
        INC    DE
        ADD    A,A
        JR     Z,NEWON4
        LD     HL,SJPTBL
        CALL   ADDHLA
        LD     M,C
        INC    HL
        LD     M,B
        JR     NEWON2
NEWON4: XOR    A               ; PLOT OFF
        LD     (INPFLG),A
        LD     A,(PNMODE)
        DEC    A
        CALL   NZ,MODETX       ; PMODE TX
        LD     HL,NEWAD2
NEWON9: LD     (TEXTST),HL
        RET
        SKP    H

;
NEWONT: DEFB   A2H             ;PMODE
        DEFB   A3H             ;PSKIP
        DEFB   A4H             ;PLOT
        DEFB   A5H             ;PLINE
        DEFB   A6H             ;RLINE
        DEFB   A7H             ;PMOVE
        DEFB   A8H             ;RMOVE
        DEFB   AEH             ;PCOLOR
        DEFB   AFH             ;PHOME
        DEFB   B0H             ;HSET
        DEFB   B1H             ;GPRINT
        DEFB   B3H             ;AXIS
        DEFB   BBH             ;PCIRCLE
        DEFB   BCH             ;PTEST
        DEFB   BDH             ;PAGE
        DEFB   0
;
LPTTMD: ENT
        LD     B,1             ;Check text mode
        JR     +4
LPTGMD: ENT
        LD     B,2             ;Check graph mode
        LD     A,(PNMODE)
        CP     B
        RET    Z
        JP     LPTMER
;
        SKP    H

;
NEWAD2: ENT
;
MODE:   ENT
        CALL   MODE0           ;"PMODE" command
        XOR    A
        LD     (LPOSB),A       ;LPT TAB
        RET
;
MODE0:  LD     A,(INPFLG)
        OR     A
        JP     NZ,LPTMER
        CALL   PPCHCK
        TEST1  "G"
        CALL   TEST1
        DEFB   "G"
        ENDM
        JP     Z,PGRAPH
        TESTX  "T"
        CALL   TESTX
        DEFB   "T"
        ENDM
        TEST1  "N"
        CALL   TEST1
        DEFB   "N"
        ENDM
        JR     Z,TEXTN
        TEST1  "L"
        CALL   TEST1
        DEFB   "L"
        ENDM
        JR     Z,TEXTN
        TESTX  "S"
        CALL   TESTX
        DEFB   "S"
        ENDM
TEXTN:  LD     (PNCHNM),A
        CALL   ENDZ
        CALL   OUTA3H
MODETX: LD     A,1
        LD     (PNMODE),A
        SVC    .LPTOT
        RST    3
        DEFB   .LPTOT
        ENDM
        LD     A,(PNCHNM)
        CP     "N"
        RET    Z
        CP     "L"
        LD     A,0BH
        JR     Z,XLPTOT
T80CH:  LD     A,9
        SVC    .LPTOT
        RST    3
        DEFB   .LPTOT
        ENDM
        SVC    .LPTOT
        RST    3
        DEFB   .LPTOT
        ENDM

XLPTOT: SVC    .LPTOT
        RST    3
        DEFB   .LPTOT
        ENDM
        RET
;
OUTA3H: LD     A,0AH
        SVC    .LPTOT
        RST    3
        DEFB   .LPTOT
        ENDM
        LD     A,3
        JR     XLPTOT
;
PGRAPH: INC    HL              ;Graphic mode
        CALL   ENDZ
        LD     A,2
        LD     (PNMODE),A
        JR     XLPTOT
        SKP    H

;
SKIP:   ENT
        CALL   PPCHCK
        CALL   LPTTMD          ;SKIP n
        CALL   IDEEXP
        LD     A,E
        OR     A
        RET    Z
        CP     -20
        JR     NC,SKIPPS
        CP     21
        JP     NC,ER03
SKIPPS: CALL   ENDZ
        BIT    7,E
        JR     NZ,SKIPD
SKIPI:  LD     A,0AH
        SVC    .LPTOT
        RST    3
        DEFB   .LPTOT
        ENDM
        DEC    E
        JR     NZ,SKIPI
        RET
;
SKIPD:  LD     A,03H
        SVC    .LPTOT
        RST    3
        DEFB   .LPTOT
        ENDM
        INC    E
        JR     NZ,SKIPD
        RET
;
PNMX99: PUSH   HL
        LD     HL,999
        JR     +6
PNMX48: PUSH   HL
        LD     HL,480
        PUSH   HL
        ADD    HL,DE
        POP    HL
        JR     C,PNMX2
        SBC    HL,DE
        JP     C,ER03
PNMX2:  POP    HL
        RET
        SKP    H

;
PLINE:  ENT                    ; PLINE %n,x,y
        LD     C,"D"
        DEFB   11H
RLINE:  ENT                    ; RLINE %n,x,y"
        LD     C,"J"
        DEFB   11H
PMOVE:  ENT                    ; PMOVE x,y
        LD     C,"M"
        DEFB   11H
RMOVE:  ENT                    ; RMOVE x,y
        LD     C,"R"
        CALL   PPCHCK
        CALL   LPTGMD
        LD     A,C
        LD     (LINEC+1),A
        CP     "M"
        JR     NC,LINE5        ;"M","R"
        TEST1  "%"
        CALL   TEST1
        DEFB   "%"
        ENDM
        JR     NZ,LINE5
        CALL   IBYTE
        LD     A,E
        DEC    A
        CP     16
        JP     NC,ER03
        DEC    DE
        LD     A,"L"
        SVC    .LPTOT
        RST    3
        DEFB   .LPTOT
        ENDM
        CALL   NUMPLT
        CALL   LPTCR
        CALL   ENDCHK
        RET    Z
        CALL   CH2CH
LINE5:  CALL   IDEEXP
        CALL   CH2CH
        CALL   PNMX48
        PUSH   DE
        CALL   IDEEXP
        CP     ","
        JR     Z,LINEXY
        CALL   ENDZ
LINEXY: CALL   PNMX99
        POP    BC
        PUSH   DE
LINEC:  LD     A,0             ;Plotter command
        SVC    .LPTOT
        RST    3
        DEFB   .LPTOT
        ENDM
        LD     E,C
        LD     D,B
        CALL   NUMPLT          ;X
        CALL   LPTCOM
        POP    DE

        CALL   NUMPLT          ;Y
        CALL   LPTCR
        CALL   ENDCHK
        RET    Z
        INC    HL
        JR     LINE5
        SKP    H

;
PCOLOR: ENT
        CALL   PPCHCK
        CALL   IBYTE           ;PCOLOR n
        LD     A,E
        CP     4
        JP     NC,ER03
        CALL   ENDZ
        LD     A,(PNMODE)
        CP     2
        JR     Z,PNMBR2
        CALL   OUTA3H
        LD     A,2
        SVC    .LPTOT
        RST    3
        DEFB   .LPTOT
        ENDM
        CALL   PNMBR2
        JP     PRTTX
;
PNMBR2: LD     A,"C"
        SVC    .LPTOT
        RST    3
        DEFB   .LPTOT
        ENDM
        LD     A,E
        OR     30H
        SVC    .LPTOT
        RST    3
        DEFB   .LPTOT
        ENDM
LPTCR:  LD     A,0DH
        JR     +4
LPTCOM: LD     A,","
YLPTOT: SVC    .LPTOT
        RST    3
        DEFB   .LPTOT
        ENDM
        RET
;
PHOME:  ENT
        LD     C,"H"
        DEFB   11H
HSET:   ENT
        LD     C,"I"
        CALL   LPTGMD          ;PHOME / HSET
        CALL   ENDZ
        LD     A,C
        JR     YLPTOT
;
        SKP    H

;
GPRINT: ENT
        CALL   PPCHCK
        CALL   LPTGMD          ;GPRINT [n,s],x$
        TEST1  "["
        CALL   TEST1
        DEFB   "["
        ENDM
        JR     NZ,SYMBL2
        CALL   IBYTE
        CP     64
        JP     NC,ER03
        PUSH   DE
        CALL   HCH2CH
        CALL   IBYTE
        CP     4
        JP     NC,ER03
        PUSH   DE
        TESTX  "]"
        CALL   TESTX
        DEFB   "]"
        ENDM
        POP    BC
        POP    DE
        PUSH   BC
        LD     A,"S"
        SVC    .LPTOT
        RST    3
        DEFB   .LPTOT
        ENDM
        CALL   NUMPLT
        CALL   LPTCOM
        POP    DE
        LD     A,"Q"
        SVC    .LPTOT
        RST    3
        DEFB   .LPTOT
        ENDM
        CALL   NUMPLT
        CALL   LPTCR
        CALL   ENDCHK
        RET    Z
        CALL   CH2CH
SYMBL2: CALL   STREXP
        CALL   ENDCHK
        JR     Z,SYMBL5
        CALL   CH2CH
        DEC    HL
SYMBL5: LD     A,B
        OR     A
        JR     Z,SYMBL4
        LD     A,"P"
        SVC    .LPTOT
        RST    3
        DEFB   .LPTOT
        ENDM
SYMBL3: LD     A,(DE)
        SVC    .LPTOT
        RST    3
        DEFB   .LPTOT

        ENDM
        INC    DE
        DJNZ   SYMBL3
        CALL   LPTCR
SYMBL4: CALL   ENDCHK
        RET    Z
        INC    HL
        JR     SYMBL2
        SKP    H

;
AXIS:   ENT
        CALL   LPTGMD          ;AXIS x,p,r
        CALL   IBYTE
        CP     2
        JP     NC,ER03
        PUSH   AF
        CALL   HCH2CH
        CALL   IDEEXP
        PUSH   DE
        CALL   CH2CH
        CALL   IBYTE
        OR     A
        JP     Z,ER03
        CALL   ENDZ
        LD     A,"X"
        SVC    .LPTOT
        RST    3
        DEFB   .LPTOT
        ENDM
        POP    BC
        POP    AF
        PUSH   DE
        PUSH   BC
        OR     30H
        SVC    .LPTOT
        RST    3
        DEFB   .LPTOT
        ENDM
        CALL   LPTCOM
        POP    DE
        CALL   PNMX99
        CALL   NUMPLT
        CALL   LPTCOM
        POP    DE
        CALL   NUMPLT
        JP     LPTCR
        SKP    H

;
PCIRCLE:ENT
        CALL   LPTGMD          ;PCIRCLE x,y,r,s,e,d
        PUSH   HL
        LD     DE,0
        LD     HL,CRS
        CALL   FLTHEX
        LD     DE,360
        LD     HL,CRE
        CALL   FLTHEX
        LD     HL,FLTEN
        LD     DE,CRTEN
        CALL   LDIR5
        POP    HL
        CALL   EXPR            ;X
        CALL   CH2CH
        PUSH   HL
        LD     HL,CRX
        EX     DE,HL
        CALL   LDIR5
        POP    HL
        CALL   EXPR            ;Y
        CALL   CH2CH
        PUSH   HL
        LD     HL,CRY
        EX     DE,HL
        CALL   LDIR5
        POP    HL
        CALL   EXPR            ;R
        PUSH   HL
        PUSH   AF
        LD     HL,CRR
        EX     DE,HL
        CALL   LDIR5
        LD     A,(CRR+1)
        RLCA
        JP     C,ER03
        POP    AF
        CP     ","
        JR     NZ,CIREND
        POP    HL
        INC    HL
        CALL   EXPR            ;S
        PUSH   HL
        PUSH   AF
        LD     HL,CRS
        EX     DE,HL
        CALL   LDIR5
        POP    AF
        CP     ","
        JR     NZ,CIREND
        POP    HL
        INC    HL
        CALL   EXPR            ;E
        PUSH   HL
        PUSH   AF
        LD     HL,CRE
        EX     DE,HL
        CALL   LDIR5
        POP    AF

        CP     ","
        JR     NZ,CIREND
        POP    HL
        INC    HL
        CALL   EXPR            ;D
        PUSH   HL
        LD     HL,CRTEN
        EX     DE,HL
        CALL   LDIR5
        LD     A,(CRTEN+1)
        RLCA
        JP     C,ER03
CIREND: 
        POP    HL
        CALL   ENDZ
        PUSH   HL
;
        LD     HL,CRE
        LD     DE,CRS
        LD     A,(CRTEN)
        OR     A
        CALL   NZ,CMP
        JP     C,ER03
;
        CALL   CRXYRS          ;CAL X,Y
;
        LD     HL,CRXX         ;MOVE X,Y
        LD     (CRMOVX+1),HL
        LD     HL,CRYY
        LD     (CRMOVY+1),HL
        CALL   CRMOVE
        LD     A,(CRTEN)
        OR     A
        JR     Z,CREDLI
;
CRCLP:  LD     HL,CRS          ;S+D
        LD     DE,CRTEN
        CALL   ADD
        LD     DE,CRE
        CALL   CMP
        JR     NC,EDLINE
        CALL   CRXYRS
        CALL   CRLINE
;
        SVC    .BREAK
        RST    3
        DEFB   .BREAK
        ENDM
        JR     NZ,CRCLP
;
        POP    HL
        RET
;
EDLINE: CALL   CREDST
        CALL   CRLINE
        POP    HL
        RET
;
CREDST: LD     HL,CRE
        LD     DE,CRS

        LD     BC,5
        LDIR
        JR     CRXYRS
;
CREDLI: LD     HL,CRX
        LD     (CRMOVX+1),HL
        LD     HL,CRY
        LD     (CRMOVY+1),HL
        CALL   CRLINE
        CALL   CREDST
        LD     HL,CRXX
        LD     (CRMOVX+1),HL
        LD     HL,CRYY
        LD     (CRMOVY+1),HL
        CALL   CRLINE
        POP    HL
        RET
;
CRLINE: LD     A,"D"
        DEFB   21H
CRMOVE: LD     A,"M"
        PUSH   AF
CRMOVX: LD     HL,CRX
        CALL   HLFLT
        PUSH   HL
        EX     DE,HL
        CALL   PNMX99
CRMOVY: LD     HL,CRY
        CALL   HLFLT
        PUSH   HL
        EX     DE,HL
        CALL   PNMX99
        POP    HL
        POP    DE
        POP    AF
        SVC    .LPTOT
        RST    3
        DEFB   .LPTOT
        ENDM
        PUSH   HL
        CALL   NUMPLT
        CALL   LPTCOM
        POP    DE
        CALL   NUMPLT
        JP     LPTCR
;
CRXYRS: LD     DE,(INTFAC)
        LD     HL,CRS
        CALL   LDIR5
        LD     HL,(INTFAC)
        CALL   RAD
        CALL   COS
        LD     DE,CRR
        CALL   MUL
        LD     DE,CRX
        CALL   ADD
        LD     DE,CRXX
        CALL   LDIR5
        LD     DE,(INTFAC)
        LD     HL,CRS

        CALL   LDIR5
        LD     HL,(INTFAC)
        CALL   RAD
        CALL   SIN
        LD     DE,CRR
        CALL   MUL
        LD     DE,CRY
        CALL   ADD
        LD     DE,CRYY
        JP     LDIR5
;
CRX:    DEFS   5
CRY:    DEFS   5
CRR:    DEFS   5
CRS:    DEFS   5
CRE:    DEFS   5
CRTEN:  DEFS   5
CRXX:   DEFS   5
CRYY:   DEFS   5
        DEFS   5
;
;
;
NUMPLT: PUSH   AF
        PUSH   HL
        LD     HL,(INTFAC)
        CALL   FLTHEX
        CALL   CVNMFL
        SVC    .COUNT
        RST    3
        DEFB   .COUNT
        ENDM
NUMPL2: LD     A,(DE)
        SVC    .LPTOT
        RST    3
        DEFB   .LPTOT
        ENDM
        INC    DE
        DJNZ   NUMPL2
        POP    HL
        POP    AF
        RET
;
        SKP    H

;
TEST:   ENT
        CALL   PPCHCK
        CALL   LPTTMD          ;TEST command
        CALL   ENDZ
        LD     A,04H
        SVC    .LPTOT
        RST    3
        DEFB   .LPTOT
        ENDM
        RET
;
PAGE:   ENT
        CALL   LPTTMD          ;PAGE n
        CALL   IDEEXP
        LD     A,E
        OR     A
        JP     Z,ER03
        CP     73
        JP     NC,ER03
        CALL   ENDZ
        LD     A,9
        SVC    .LPTOT
        RST    3
        DEFB   .LPTOT
        ENDM
        SVC    .LPTOT
        RST    3
        DEFB   .LPTOT
        ENDM
        LD     A,(PSEL)
        BIT    P.PLT,A
        JR     Z,PAGE2
        CALL   NUMPLT          ;Plotter only
        JP     LPTCR
PAGE2:  LD     A,E             ;Except plotter
        LD     DE,KEYBUF
        CALL   HEXACC
        DEC    DE
        DEC    DE
        LD     A,(DE)
        SVC    .LPTOT
        RST    3
        DEFB   .LPTOT
        ENDM
        INC    DE
        LD     A,(DE)
        SVC    .LPTOT
        RST    3
        DEFB   .LPTOT
        ENDM
        RET
;
PLOT:   ENT
        LD     A,M
        CP     9DH             ;PLOT ON/OFF
        JR     Z,PLOTO'
        CP     A1H             ;OFF
        JP     NZ,ER01
        XOR    A

PLOTOK: LD     (INPFLG),A
        INC    HL
        RET
PLOTO': CALL   LPTTMD
        CALL   PPCHCK
        LD     A,(PNCHNM)
        CP     "L"
        JP     Z,LPTMER
        CALL   PRTTX
PL40C:  LD     A,(INPFLG)
        OR     A
        JR     NZ,PLOTOK
        CALL   CONSOI
        LD     A,16H
        SVC    .CRT1C
        RST    3
        DEFB   .CRT1C
        ENDM
        OR     01H
        JR     PLOTOK
;
PRTTX:  LD     A,1
        SVC    .LPTOT
        RST    3
        DEFB   .LPTOT
        ENDM
        LD     A,(CRTMD2)
        CP     3
        RET    C
        CALL   T80CH
        RET
;
PPCHCK: LD     A,(PSEL)
        BIT    P.PLT,A         ;if not plotter
        JP     Z,LPTMER        ; then err
        RET
;
NEWAD0: ENT
;
        END

; -----------------------------
; MZ-800 BASIC  Expression part
; FI:EXPR  ver 1.0A 8.25.84
; Programed by T.Miho
; -----------------------------
;
;
        INCLD  MACRO
;
IBYTE:  ENT                    ;0..255
        CALL   IDEEXP
DCHECK: ENT
        LD     A,D
        OR     A
        JP     NZ,ER03
        LD     A,E
        RET
;
DEEXP:  ENT
        CALL   EXPR8
        REP5   DEC,DE
        DEC    DE
        DEC    DE
        DEC    DE
        DEC    DE
        DEC    DE
        ENDM
        JR     STDEFC
;
IDEEXP: ENT                    ;DE=(HL)
        CALL   EXPR
STDEFC: ENT
        PUSH   AF
        PUSH   HL
        EX     DE,HL
        CALL   STROMT
        CALL   HLFLT
        EX     DE,HL
        POP    HL
        POP    AF
        RET
;
STREXP: ENT
        CALL   EXPR
        PUSH   AF
        CALL   STROK
        PUSH   HL
        EX     DE,HL
        CALL   CVTSDC
        POP    HL
        POP    AF
        RET
;
CVTSDC: ENT
        LD     B,M
        INC    HL
        LD     E,M
        INC    HL
        LD     D,M
        LD     HL,(STRST)

        ADD    HL,DE
        EX     DE,HL
        LD     A,B
        RET
        SKP    H

;
EXPR:   ENT
        LD     DE,(VARED)
        LD     (TMPEND),DE
EXPRNX: ENT
        LD     DE,(INTFAC)
        PUSH   DE
        CALL   EXPR8
        POP    DE
        RET
;
EXPR8:  PUSH   DE
        LD     DE,(TMPEND)
        CALL   MEMECK
        POP    DE
;
;
EXPR7:  CALL   EXPR6
EXPR7L: CP     EAH             ;XOR
        RET    NZ
        LD     A,(PRCSON)
        PUSH   AF
        INC    HL
        CALL   EXPR6
        POP    BC
        PUSH   AF
        PUSH   HL
        CALL   ADJUST
        CALL   .XOR.
        POP    HL
        POP    AF
        JR     EXPR7L
;
EXPR6:  CALL   EXPR5
EXPR6L: CP     EBH             ;OR
        RET    NZ
        LD     A,(PRCSON)
        PUSH   AF
        INC    HL
        CALL   EXPR5
        POP    BC
        PUSH   AF
        PUSH   HL
        CALL   ADJUST
        CALL   .OR.
        POP    HL
        POP    AF
        JR     EXPR6L
;
EXPR5:  CALL   EXPR4
EXPR5L: CP     ECH             ;AND
        RET    NZ
        LD     A,(PRCSON)
        PUSH   AF
        INC    HL
        CALL   EXPR4
        POP    BC
        PUSH   AF
        PUSH   HL
        CALL   ADJUST

        CALL   .AND.
        POP    HL
        POP    AF
        JR     EXPR5L
;
EXPR4:  TEST1  EDH             ;NOT
        CALL   TEST1
        DEFB   EDH
        ENDM
        JR     NZ,EXPR3
        CALL   EXPR3
        PUSH   AF
        PUSH   HL
        LD     HL,-5
        ADD    HL,DE
        CALL   .NOT.
        POP    HL
        POP    AF
        RET

EXPR3:  CALL   EXPR2
EXPR3L: CP     EEH             ;><
        RET    C
        PUSH   AF              ;stk OPC
        LD     A,(PRCSON)
        PUSH   AF              ;stk OPC, PRCSON
        INC    HL
        CALL   EXPR2
        POP    BC              ;stk OPC;      B=PRCSON
        EX     (SP),HL         ;stk RJOB;     HL=OPC
        PUSH   AF              ;stk RJOB,NEXT
        PUSH   HL              ;stk RJOB,NEXT,OPC
        CALL   ADJUST
        CALL   CMP
        EX     AF,AF'          ;AF' = result
        POP    AF              ;stk RJOB,NEXT; A=OPC
        CP     F6H             ;<
        JR     NZ,NXTCP1
        EX     AF,AF'
        JR     C,TRUE
FALSE:  LD     BC,0
RLBACK: LD     M,C
        INC    HL
        LD     M,B
        INC    HL
        XOR    A
        LD     M,A
        INC    HL
        LD     M,A
        INC    HL
        LD     M,A
        LD     A,5
        LD     (PRCSON),A
        POP    AF              ;POP NEXT
        POP    HL              ;POP RJOB
        JR     EXPR3L
;
TRUE:   LD     BC,8081H
        JR     RLBACK
;

NXTCP1: CP     F5H             ;>
        JR     NZ,NXTCP2
        EX     AF,AF'
        JR     Z,FALSE
        JR     C,FALSE
        JR     TRUE
;
NXTCP2: CP     F4H             ;=
        JR     NZ,NXTCP3
        EX     AF,AF'
        JR     Z,TRUE
        JR     FALSE
;
NXTCP3: CP     F2H             ;=>,>=
        JR     C,NXTCP4
        EX     AF,AF'
        JR     NC,TRUE
        JR     FALSE
;
NXTCP4: CP     F0H             ;=<,<=
        JR     C,NXTCP5
        EX     AF,AF'
        JR     Z,TRUE
        JR     C,TRUE
        JR     FALSE
;
NXTCP5: EX     AF,AF'          ;<>,><
        JR     Z,FALSE
        JR     TRUE
;
;
EXPR2:  CALL   EXPR1
EXPR2L: CP     F7H             ;+,-
        RET    C
        LD     A,(PRCSON)
        PUSH   AF
        INC    HL
        JR     Z,EXPR2A        ;+
        CALL   EXPR1
        POP    BC
        PUSH   AF
        PUSH   HL
        CALL   ADJUST
        CALL   SUB
EXPR2X: POP    HL
        POP    AF
        JR     EXPR2L
EXPR2A: CALL   EXPR1
        POP    BC
        PUSH   AF
        PUSH   HL
        CALL   ADJUST
        CALL   ADD
        JR     EXPR2X
;
;
EXPR1:  CALL   EXPR0
EXPR1L: CP     F9H             ;MOD, YEN
        RET    C
        LD     A,(PRCSON)

        PUSH   AF
        INC    HL
        JR     Z,EXPR1A        ;YEN
        CALL   EXPR0
        POP    BC
        PUSH   AF
        PUSH   HL
        CALL   ADJUST
        CALL   MOD
EXPR1X: POP    HL
        POP    AF
        JR     EXPR1L
EXPR1A: CALL   EXPR0
        POP    BC
        PUSH   AF
        PUSH   HL
        CALL   ADJUST
        CALL   YEN
        JR     EXPR1X
;
;
EXPR0:  CALL   EXPRZ
EXPR0L: CP     FBH             ;/,*
        RET    C
        LD     A,(PRCSON)
        PUSH   AF
        INC    HL
        JR     Z,EXPR0A        ;/
        CALL   EXPRZ
        POP    BC
        PUSH   AF
        PUSH   HL
        CALL   ADJUST
        CALL   MUL
EXPR0X: POP    HL
        POP    AF
        JR     EXPR0L
EXPR0A: CALL   EXPRZ
        POP    BC
        PUSH   AF
        PUSH   HL
        CALL   ADJUST
        CALL   DIV
        JR     EXPR0X
;
EXPRZ:  TEST1  F7H             ;+
        CALL   TEST1
        DEFB   F7H
        ENDM
        JR     Z,EXPRZ
        CP     F8H             ;-
        JR     NZ,EXPRY
        INC    HL
        CALL   EXPRY
        JR     EXPRX2
;
EXPRY:  CALL   FACTOR
EXPRYL: CP     FDH             ;^
        RET    NZ
        LD     A,(PRCSON)

        PUSH   AF
        INC    HL
        CALL   EXPRX
        POP    BC
        PUSH   AF
        PUSH   HL
        CALL   ADJUST          ;
        CALL   POWERS          ;(HL)^(DE)
        POP    HL
        POP    AF
        JR     EXPRYL
;
EXPRX:  TEST1  F7H             ;+
        CALL   TEST1
        DEFB   F7H
        ENDM
        JR     Z,EXPRX
        CP     F8H             ;-
        JR     NZ,FACTOR
        INC    HL
        CALL   FACTOR
EXPRX2: PUSH   AF
        PUSH   HL
        LD     HL,-5
        ADD    HL,DE
        CALL   NEG
        POP    HL
        POP    AF
        RET
;
        SKP    H

FACTOR: CALL   ENDCHK
        JP     Z,ER01
        CALL   FAC0
        JP     HLFTCH
;
FAC0:   PUSH   HL
        LD     HL,(MEMLMT)
        SCF
        SBC    HL,DE
        JP     C,ER06          ;TOO COMPLEX EXPR
        POP    HL
        CP     E4H             ;PI
        JR     Z,FACPAI
        CP     20H
        JR     NC,VARFNC       ;IM 20 ....
;
FACNUM: ENT                    ;Factor(numeric)
        INC    HL
        CP     15H
        JR     C,FACINT
        CALL   LDIR5           ;IM 15
        JR     FACR5
FACPAI: INC    HL
        PUSH   HL
        LD     HL,FLTPAI
        CALL   LDIR5
        POP    HL
FACR5:  LD     A,5
FACRX:  LD     (PRCSON),A
        RET
;
FACINT: CP     0BH             ;IM 00 .. 14
        JR     NC,FACI4
        DEC    A
        JP     M,ER01          ;IM 00
        LD     B,0
        LD     C,A
        JR     FACI6
;
FACI4:  LD     C,M             ;IM 0B .. 14
        INC    HL
        LD     B,M
        INC    HL
        CP     0CH
        JR     NZ,FACI6
        INC    BC
        INC    BC
        LD     A,(BC)
        INC    BC
        EX     AF,AF'
        LD     A,(BC)
        LD     B,A
        EX     AF,AF'
        LD     C,A
FACI6:  PUSH   HL
        PUSH   DE
        EX     DE,HL
        LD     E,C
        LD     D,B
        CALL   FLTHEX

        POP    DE
        POP    HL
        LD     A,5
FACRX5: REP5   INC,DE
        INC    DE
        INC    DE
        INC    DE
        INC    DE
        INC    DE
        ENDM
        JR     FACRX
;
VARFNC: CP     '"'
        JR     NZ,VARFN1
        INC    HL
        PUSH   HL
        CALL   STRLCK          ;B=len(HL str.)
        EX     (SP),HL         ;New text point
        PUSH   HL              ;Old text point
        LD     HL,(TMPEND)
        PUSH   BC
        LD     BC,(STRST)
        OR     A
        SBC    HL,BC           ;HL=OFSET+ADR
        POP    BC
        EX     DE,HL
        LD     M,B             ;FAC set len.
        INC    HL
        LD     M,E             ;FAC set adrs
        INC    HL
        LD     M,D
        INC    HL
        INC    HL
        INC    HL
        POP    DE              ;Old text point
        PUSH   HL              ;New expr point
        LD     HL,(TMPEND)
        CALL   STRENT          ;(HL)_(DE),B
        LD     (TMPEND),HL
        POP    DE              ;New expr point
        POP    HL              ;New text point
        LD     A,3
        LD     (PRCSON),A
        RET
;
VARFN1: CP     "("
        JR     NZ,FUNC
        INC    HL              ;( ... )
        CALL   EXPR8
        JP     CH29H
;
;
;
FUNC:   OR     A               ;Function
        JP     P,VARFN2
        CP     E7H             ;SPC ==>
        INC    HL
        JR     NZ,FUNC1
        LD     B,5             ;param is numeric
        LD     A,A8H           ;   SPACE$

        PUSH   AF
        JR     FUNC2
FUNC1:  CP     FFH
        JP     NZ,ER01
        LD     A,M
        INC    HL
        CP     A0H
        JP     Z,CHR$OP        ;CHR$
        CP     C8H
        JP     NC,ER01
        CP     BAH
        JR     NC,GETJPA       ;complex
        CP     9CH             ;JOY STICK
        JR     Z,GETJPA
        CP     9DH             ;JOY STRIG
        JP     Z,GETJPA
        PUSH   AF
        CP     B3H
        JR     NC,SYSV         ;system var
        LD     B,3
        CP     ABH
        JR     NC,FUNC2        ;param is string
        LD     B,5             ;param is numeric
        CP     88H             ;RND
        JR     Z,RNDONL
FUNC2:  CALL   HCH28H
FUNC4:  PUSH   BC
        CALL   EXPR8
        CALL   CH29H
        POP    AF
        CALL   STRCK
FUNC6:  POP    AF
        PUSH   DE
        PUSH   HL
        LD     HL,-5
        ADD    HL,DE
        CALL   GETJPA
        POP    HL
        POP    DE
        RET
;
;
RNDONL: TEST1  "("
        CALL   TEST1
        DEFB   "("
        ENDM
        JR     Z,FUNC4
SYSV:   LD     A,5
        LD     (PRCSON),A
        PUSH   HL
        LD     HL,FLONE
        CALL   LDIR5
        POP    HL
        JR     FUNC6
        SKP    H

;
GETJPA: PUSH   HL
        ADD    A,A
        LD     L,A
        LD     H,0
        LD     BC,FJPTBL
        ADD    HL,BC
        LD     A,M
        INC    HL
        LD     H,M
        LD     L,A
        EX     (SP),HL
        RET
;
SIZE:   ENT
        EX     DE,HL
        LD     HL,-527
        ADD    HL,SP
        LD     BC,(TMPEND)
        OR     A
        SBC    HL,BC
        EX     DE,HL
        JR     NC,PUT2B
        XOR    A
        JR     PUT1B
;
CSRH:   ENT
        LD     A,(CURX)
        JR     PUT1B
CSRV:   ENT
        LD     A,(CURY)
        JR     PUT1B
POSH:   ENT
        LD     DE,(POINTX)
        JR     PUT2B
POSV:   ENT
        LD     DE,(POINTY)
        JR     PUT2B
ERR:    ENT
        LD     A,(ERRCOD)
PUT1B:  LD     E,A
        LD     D,0
PUT2B:  LD     A,5
        LD     (PRCSON),A
        JP     FLTHEX
;
ERL:    ENT
        LD     DE,(ERRLNO)
        CALL   FLTHEX
        INC    HL
        BIT    7,M
        DEC    HL
        RET    Z
        LD     DE,FL64K
        JP     ADD
;
FL64K:  DEF5   91,00,00,00,00  ;65536
        DEFW   0091H
        DEFW   0000H
        DEFB   00H

        ENDM
        SKP    H

;
CHR$OP: CALL   HCH28H
        LD     B,0
CHR$LP: PUSH   BC              ;counter
        PUSH   DE              ;FAC
        CALL   DEEXP
        CALL   DCHECK
        POP    DE              ;FAC
        POP    BC              ;counter
        PUSH   AF              ;data
        INC    B
        TEST1  ","
        CALL   TEST1
        DEFB   ","
        ENDM
        JR     Z,CHR$LP
        CALL   CH29H
        LD     A,B             ;length
        EXX
        LD     B,A
        LD     HL,(TMPEND)     ;string start
        CALL   ADDHLA
        LD     DE,HL           ;string end+1
        CALL   MEMECK
CHR$4:  DEC    HL
        POP    AF              ;data
        LD     M,A
        DJNZ   CHR$4
        EXX
        LD     A,B             ;length
        EXX
        LD     B,A
;
;HL=String start
;DE=String end+1
;B =String length
;DE'=FAC
;HL'=TEXT,??
;
STEXR2: LD     (TMPEND),DE
        LD     DE,(STRST)
        OR     A
        SBC    HL,DE
        PUSH   HL
        LD     A,B
        EXX
        EX     DE,HL
        LD     M,A
        INC    HL
        POP    BC
        LD     M,C
        INC    HL
        LD     M,B
        LD     BC,3            ;
        ADD    HL,BC
STRPRS: EX     DE,HL
        LD     A,3
        LD     (PRCSON),A
        RET
        SKP    H

;
HEX$:   ENT
        PUSH   HL
        CALL   HLFLT
        CALL   HEXHL
        SVC    .COUNT
        RST    3
        DEFB   .COUNT
        ENDM
;
; DE:adrs
; B:length
; (SP):Text pointer
;
PUTSTR: ENT
        LD     A,B
        OR     A
        JR     Z,NULSPC
        LD     HL,(TMPEND)
        PUSH   HL
        PUSH   BC
        CALL   STRENT
        POP    BC
        EX     DE,HL
        POP    HL
        EXX
        POP    DE
        EXX
        JR     STEXR2
NULSPC: POP    HL
        CALL   CLRFAC
        JR     STRPRS
;
SPACE$: ENT
        PUSH   HL
        CALL   HLINCK
        LD     B,A
        LD     C,A
        OR     A
        LD     A," "
        PUSH   DE
        CALL   NZ,?SETDE
        POP    DE
        LD     B,C
        JR     PUTSTR
;
HLINCK: CALL   HLFLT
        LD     DE,KEYBUF
        LD     A,H
        OR     A
        JP     NZ,ER03
        LD     A,L
        RET
        SKP    H

;
;
STR$:   ENT
        PUSH   HL
        CALL   CVNMFL
        LD     A,(DE)
        CP     " "
        JR     NZ,+3
        INC    DE
        SVC    .COUNT
        RST    3
        DEFB   .COUNT
        ENDM
        JR     PUTSTR
;
        SKP    H

EOF:    ENT
        CALL   HCH28H
        CALL   GETLU
        LD     B,A
        CALL   HCH29H
        LD     A,B
        PUSH   HL
        PUSH   DE
        SVC    .SEGAD
        RST    3
        DEFB   .SEGAD
        ENDM
        LD     DE,-1
        JR     C,EOF2
        INC    HL
        BIT    ##EOF,M
        JR     NZ,EOF2
        LD     DE,0
EOF2:   POP    HL
        CALL   FLTHEX
        LD     A,5
        LD     (PRCSON),A
EOF8:   REP5   INC,HL
        INC    HL
        INC    HL
        INC    HL
        INC    HL
        INC    HL
        ENDM
        EX     DE,HL
        POP    HL
        RET
;
POINT:  ENT
        CALL   HCH28H
        PUSH   DE              ;EXPR pointer
        CALL   DEEXP           ;X
        LD     BC,DE           ;X
        POP    DE              ;EXPR pointer
        PUSH   DE              ;EXPR pointer
        PUSH   BC              ;X
        CALL   CH2CH
        CALL   DEEXP           ;Y
        CALL   CH29H
        EX     (SP),HL         ;HL=X
        EX     DE,HL
        SVC    .POINT
        RST    3
        DEFB   .POINT
        ENDM
        INC    A
        JP     Z,ER03          ;Out of range
        DEC    A
        POP    DE              ;TEXT pointer
        POP    HL              ;EXPR pointer
        PUSH   DE              ;TEXT pointer
        CALL   PUT1B
        JR     EOF8
        SKP    H

;
ASC:    ENT
        PUSH   HL
        CALL   CVTSDC
        OR     A
        JR     Z,+3
        LD     A,(DE)
        JR     LEN2
;
LEN:    ENT
        PUSH   HL
        CALL   CVTSDC
LEN2:   POP    HL
        JP     PUT1B
;
VAL:    ENT
        PUSH   HL
        CALL   CVTSDC
        LD     HL,(TMPEND)
        PUSH   HL
        CALL   STRENT
        LD     M,0
        POP    DE
        POP    HL
        JP     CVFLAS
        SKP    H

;
LEFT$:  ENT
        CALL   CH28EX
        CALL   CH29H
        CALL   BCHECK
        EX     DE,HL
        LD     A,M
        CP     C
        JR     NC,+3
        LD     C,A
        LD     M,C
        LD     BC,5
FACSTR: LD     A,3
        ADD    HL,BC
        EX     DE,HL
        LD     (PRCSON),A
        JP     HLFTCH
;
RIGHT$: ENT
        CALL   CH28EX
        CALL   CH29H
        CALL   BCHECK
        EX     DE,HL
        LD     A,M
        SUB    C
        JR     NC,MID$EE
        XOR    A
        LD     C,M
MID$EE: LD     M,C
        INC    HL
        ADD    A,M
        LD     M,A
        INC    HL
        JR     NC,+3
        INC    M
        LD     BC,3            ;
        JR     FACSTR
        SKP    H

;
MID$:   ENT
        CALL   CH28EX
        CALL   BCHECK
        OR     A
        JP     Z,ER03
        PUSH   AF
        TEST1  ")"
        CALL   TEST1
        DEFB   ")"
        ENDM
        LD     A,FFH
        JR     Z,MID$2
        CALL   HCH2CH
        PUSH   DE
        EX     DE,HL
        LD     BC,5
        ADD    HL,BC
        EX     DE,HL
        CALL   DEEXP
        CALL   CH29H
        CALL   DCHECK
        POP    DE
MID$2:  POP    BC
        LD     C,A
        EX     DE,HL
        LD     A,M
        SUB    B
        JR     C,MIDNUL
        INC    A
        CP     C
        JR     NC,+3
        LD     C,A
        LD     A,B
        DEC    A
        JR     MID$EE
;
MIDNUL: XOR    A
        LD     C,A
        JR     MID$EE
;
BCHECK: LD     A,B
        OR     A
        JP     NZ,ER03
        LD     A,C
        RET
;
CH28EX: CALL   HCH28H
        PUSH   DE
        CALL   EXPR8
        CALL   CH2CH
        CALL   STROK
        CALL   DEEXP
        LD     C,E
        LD     B,D
        POP    DE
        RET
        SKP    H

;
TI$:    ENT
        PUSH   HL
        PUSH   DE
        LD     HL,(TMPEND)
        PUSH   HL
        LD     A,"0"
        LD     B,6
        CALL   ?SETHL
        SVC    .TIMRD          ;A,DE
        RST    3
        DEFB   .TIMRD
        ENDM
        POP    HL
        OR     A
        JR     Z,TI$2
        INC    M
        INC    HL
        INC    M
        INC    M
        DEC    HL
TI$2:   EX     DE,HL
        LD     BC,8CA0H        ;10H
        CALL   CLDGIT
        LD     BC,E10H         ;1H
        CALL   CLDGIT
        CP     3AH
        JR     C,TI$4
        SUB    10
        DEC    DE
        LD     (DE),A
        DEC    DE
        LD     A,(DE)
        INC    A
        LD     (DE),A
        INC    DE
        INC    DE
TI$4:   DEC    DE
        DEC    DE
        LD     A,(DE)
        INC    DE
        LD     B,A
        LD     A,(DE)
        INC    DE
        LD     C,A
        LD     A,B
        CP     32H
        JR     NZ,TI$6
        LD     A,C
        CP     34H
        JR     NZ,TI$6
        LD     HL,(TMPEND)
        LD     A,"0"
        LD     B,6
        CALL   ?SETHL
        JR     TI$8
TI$6:   LD     BC,258H         ;10M
        CALL   CLDGIT
        LD     BC,3CH          ;1M
        CALL   CLDGIT

        LD     BC,0AH          ;10S
        CALL   CLDGIT
        LD     A,30H
        ADD    A,L
        LD     (DE),A
TI$8:   LD     HL,(TMPEND)
        LD     DE,6
        EX     DE,HL
        ADD    HL,DE
        LD     (TMPEND),HL
        EX     DE,HL
        LD     DE,(STRST)
        OR     A
        SBC    HL,DE
        EX     DE,HL
        POP    HL
        LD     M,6
        INC    HL
        LD     M,E
        INC    HL
        LD     M,D
        INC    HL
        INC    HL
        INC    HL
        EX     DE,HL
        POP    HL
        LD     A,3
        LD     (PRCSON),A
        JP     HLFTCH
;
CLDGIT: OR     A
        SBC    HL,BC
        JR     C,CLDGRT
        LD     A,(DE)
        INC    A
        LD     (DE),A
        JR     CLDGIT
CLDGRT: ADD    HL,BC
        INC    DE
        RET
;
TIMDAI: ENT
        TESTX  F4H             ;TI$=....
        CALL   TESTX
        DEFB   F4H
        ENDM
        CALL   STREXP
        LD     A,B
        CP     6
        JP     NZ,ER03
        PUSH   HL
        PUSH   DE
        LD     HL,0
        CALL   TIMASC
        CP     24
        JP     NC,ER03
        CP     12
        LD     A,0
        JR     C,TIMDA2
        PUSH   DE

        LD     DE,12
        OR     A
        SBC    HL,DE
        POP    DE
        INC    A
TIMDA2: PUSH   AF
        CALL   TIMASC
        CP     60
        JP     NC,ER03
        CALL   TIMASC
        CP     60
        JP     NC,ER03
        POP    AF
        EX     DE,HL
        SVC    .TIMST
        RST    3
        DEFB   .TIMST
        ENDM
        POP    DE
        POP    HL
        RET
;
TIMASC: PUSH   DE
        LD     D,H
        LD     E,L
        ADD    HL,HL
        ADD    HL,HL
        ADD    HL,DE
        LD     D,H
        LD     E,L
        ADD    HL,HL
        ADD    HL,DE
        ADD    HL,HL
        ADD    HL,HL
        POP    DE
        LD     A,(DE)
        INC    DE
        SUB    30H
        JP     C,ER03
        CP     0AH
        JP     NC,ER03
        PUSH   BC
        LD     C,A
        ADD    A,A
        ADD    A,A
        ADD    A,C
        ADD    A,A
        LD     C,A
        LD     A,(DE)
        INC    DE
        SUB    30H
        JP     C,ER03
        CP     0AH
        JP     NC,ER03
        ADD    A,C
        LD     C,A
        LD     B,0
        ADD    HL,BC
        POP    BC
        RET

        SKP    H

;
INTGTV: ENT
        LD     DE,(VARED)
        LD     (TMPEND),DE
        LD     DE,(INTFAC)
GETVAR: PUSH   DE
        CALL   VSRTST
GETFNV: LD     A,M
        CP     "("
        JP     Z,ARRAY
        PUSH   HL
        CALL   CHVRNM
        JR     NC,CRNVAR
        LD     A,C
        LD     C,L
        LD     B,H
        POP    HL
        POP    DE
        RET
;
CRNVAR: LD     A,(DE)
        ADD    A,C             ;VAR.LEN.+TYPE
        ADD    A,2
        PUSH   BC
        EX     DE,HL
        LD     HL,(TMPEND)
        PUSH   HL
        OR     A
        SBC    HL,DE
        INC    HL
        LD     C,L
        LD     B,H
        POP    HL
        PUSH   DE
        EX     DE,HL
        LD     L,A
        LD     H,0
        ADD    HL,DE
        EX     DE,HL
        CALL   MEMECK
        LDDR
        LD     E,A
        LD     D,0
        SVC    .ADDP2
        RST    3
        DEFB   .ADDP2
        ENDM
        POP    HL
        POP    BC
        LD     DE,KEYBUF
        LD     M,C             ;TYPE SET
        INC    HL
        SCF
        SBC    A,C             ;B=A-C-1
        LD     B,A
VARSL1: LD     A,(DE)          ;VAR.LEN.&NAME
        LD     M,A
        INC    DE
        INC    HL
        DJNZ   VARSL1

        PUSH   HL
        LD     B,C
        CALL   ?CLRHL          ;VAR.CLR
        LD     M,A             ;VAR.END MARK
        LD     A,C
        POP    BC
        POP    HL
        POP    DE
        RET
;
VSRTST: CALL   HLFTCH
        SUB    "A"
        CP     26
        JP     NC,ER01
        LD     DE,KEYBUF
        LD     B,0
VSRTS1: INC    DE
        LD     A,M
        CALL   TSTVAR
        JR     C,TSTTYP
        LD     (DE),A
        INC    B
        LD     A,B
        CP     3
        JR     C,+3
        DEC    B
        INC    HL
        JR     VSRTS1
TSTTYP: LD     DE,KEYBUF
        EX     DE,HL
        LD     M,B
        EX     DE,HL
        LD     C,5
        CP     24H             ;$
        RET    NZ
        LD     C,3
        INC    HL
        RET
;
ADJUST: LD     HL,-5
        EX     DE,HL
        ADD    HL,DE
        EX     DE,HL
        ADD    HL,DE
        LD     A,B
        JP     STRCK
;
;
STRLCK: LD     B,FFH
STRLL1: INC    B
        LD     A,M
        OR     A
        RET    Z
        INC    HL
        CP     '"'
        RET    Z
        JR     STRLL1
;
STRENT: ENT
        LD     A,B

        OR     A
        RET    Z
        CALL   LDHLDE
        EX     DE,HL
        CALL   MEMECK
        EX     DE,HL
        RET
;
;
MEMECK: ENT                    ;SBC SP,DE
        PUSH   HL
        LD     HL,-512
        ADD    HL,SP
        SBC    HL,DE
        POP    HL
        RET    NC
        JP     ER06'
;
;
;
; PUSH DE
; KEYBUF..LEN. NAME
; HL=(
;
ARRAY0: LD     DE,(INTFAC)
        PUSH   DE
        JR     ARRAY2
;
ARRAY:  XOR    A
        LD     (AUTDIM),A
        INC    HL
        LD     (ARYTXT),HL
ARRAY2: LD     B,0
        EXX
        POP    HL              ;POP FAC
        PUSH   HL              ;PUSH FAC
        PUSH   HL              ;PUSH FAC1
        LD     HL,(TMPEND)
        LD     DE,KEYBUF
        PUSH   HL
        LD     A,(DE)
        LD     M,A
        INC    DE
        INC    HL
        LD     B,A
        CALL   STRENT
        POP    DE
        LD     (TMPEND),HL
        LD     HL,(STRST)
        EX     DE,HL
        OR     A
        SBC    HL,DE
        EX     (SP),HL         ;NAME ADR.
        PUSH   HL              ;PUSH FAC1
        EXX
TSALOP: POP    DE              ;POP FAC1
        PUSH   DE              ;PUSH FAC1
        PUSH   BC              ;PUSH B,TYPE(C)
        LD     BC,(ARYTXT)
        LD     A,(AUTDIM)

        PUSH   BC
        PUSH   AF
        LD     BC,(DGBF00)
        PUSH   BC
        CALL   DEEXP           ;¯¯DE=EXP(INT)
        BIT    7,D
        JP     NZ,ER03
        EX     AF,AF'
        POP    BC
        LD     (DGBF00),BC
        POP    AF
        LD     (AUTDIM),A
        POP    BC
        LD     (ARYTXT),BC
        EX     AF,AF'
        INC    HL
        CP     ")"
        JR     Z,TSFARY
        CP     ","
        JP     NZ,ER01
        POP    BC              ;POP B,TYPE(C)
        INC    B               ;(.,.,.,.)
        LD     A,B
        CP     4
        JP     NC,ER03
        EXX
        POP    HL              ;POP FAC1
        POP    DE              ;POP NAME ADR.
        EXX
        PUSH   DE              ;ANS
        EXX
        PUSH   DE              ;PUSH NAME ADR.
        PUSH   HL              ;PUSH FAC1
        EXX
        JR     TSALOP
;
TSFARY: POP    BC              ;POP B,TYPE(C)
        EXX
        POP    HL              ;POP FAC1
        POP    DE              ;POP NAME ADR.
        EXX
        INC    B               ;ARRAY POINT
        PUSH   DE              ;ANS
        PUSH   HL              ;PUSH TEXT POINT
        EXX
        LD     HL,(STRST)
        ADD    HL,DE
        LD     B,M
        INC    B
        LD     DE,KEYBUF
        CALL   LDDEHL
        EXX
        SET    7,C
        CALL   CHVRNM
        RES    7,C
        JR     NC,ARYDIM
        LD     A,B
        CP     M
        JP     NZ,ER07         ;DUPLICATE
;LD A,(AUTDIM)

;OR A
;JP NZ,ER07
        INC    HL
        EX     DE,HL
        POP    HL
        LD     (DGBF00),HL     ;TEXT END
        EXX
        LD     HL,0000H
        EXX
        EX     DE,HL
ADRCL:  LD     E,M
        INC    HL
        LD     D,M
        INC    HL
        EX     (SP),HL
        PUSH   DE
        EXX
        POP    DE
        CALL   DIMMUL
        EXX
        PUSH   HL
        OR     A
        SBC    HL,DE
        JP     NC,ER03
        EXX
        POP    DE
        CALL   DIMADD
        EXX
        POP    HL
        DJNZ   ADRCL
        PUSH   HL
        EXX
        LD     A,C
        LD     D,B
        BIT    6,A
        JR     NZ,VARDIM
        AND    0FH
        LD     E,A
        PUSH   AF
        CALL   DIMMUL
        PUSH   HL
        EXX
        POP    BC
        POP    AF
        POP    HL
        ADD    HL,BC
        LD     C,L
        LD     B,H
VARDME: LD     HL,(DGBF00)
        POP    DE
        RET
;
VARDIM: LD     E,M
        INC    HL
        LD     D,M
        POP    HL
        LD     C,L
        LD     B,H
        LD     M,E
        INC    HL

        LD     M,D
        AND    0FH
        JR     VARDME
;
;
ARYDIM: EXX
        LD     A,(AUTDIM)
        OR     A
        JP     Z,ER03
        POP    HL              ;TEXT POINT
        LD     (DGBF00),HL
        EXX
        LD     DE,(TMPEND)
        LD     L,B
        LD     H,0
        ADD    HL,HL
        ADD    HL,DE
        EX     DE,HL
        INC    DE
        CALL   MEMECK
        LD     M,B
        INC    HL
        EXX
        LD     HL,1
        EXX
ADRCL': POP    DE
        LD     A,(AUTDIM)
        OR     A
        JR     NZ,ADRC''
        PUSH   HL              ;1
        EX     DE,HL
        LD     DE,10
        SCF
        SBC    HL,DE
        JP     NC,ER03
        POP    HL              ;1
ADRC'': INC    DE
        LD     M,E
        INC    HL
        LD     M,D
        INC    HL
        PUSH   DE
        EXX
        POP    DE
        CALL   DIMMUL
        EXX
        DJNZ   ADRCL'
        LD     E,C
        LD     D,0
        PUSH   BC
        PUSH   DE
        EXX
        POP    DE
        CALL   DIMMUL
        PUSH   HL
        EXX
        POP    BC
        PUSH   BC              ;2 A*B*C*D
        EX     DE,HL
        LD     HL,(TMPEND)     ;(.,.,.)*2

        LD     L,M
        LD     H,0
        ADD    HL,HL
        LD     A,(KEYBUF)      ;+NAME
        ADD    A,5             ;+TY+LN+NL+(.,.)
        ADD    A,L
        LD     L,A
        LD     A,0
        ADC    A,H
        LD     H,A
        JR     C,DIMOVM
        ADD    HL,BC
        JR     C,DIMOVM
        PUSH   HL              ;3 LEN
        ADD    HL,DE           ;+TEMPEND
DIMOVM: JP     C,ER06'
        EX     DE,HL
        CALL   MEMECK
        PUSH   HL              ;4 TMPEND
        EXX
        POP    HL              ;4 TMPEND
        LD     BC,(STRST)      ;VAR END
        DEC    BC
        OR     A
        SBC    HL,BC
        PUSH   HL              ;4 TRANS LEN
        EXX
        POP    BC              ;4 TRANS LEN
        LDDR
        POP    DE              ;3 LEN
        SVC    .ADDP2
        RST    3
        DEFB   .ADDP2
        ENDM
        POP    BC              ;2 CLR LEN
        PUSH   DE              ;2 LEN
        EXX
        POP    DE              ;2 LEN
        LD     H,B
        LD     L,C
        POP    BC              ;1 TYPE
        LD     A,C
        OR     80H
        LD     M,A
        INC    HL
        DEC    DE
        LD     M,E
        INC    HL
        LD     M,D
        INC    HL
        LD     DE,KEYBUF
        LD     A,(DE)
        INC    A
        LD     B,A
        CALL   LDHLDE
        LD     DE,(TMPEND)
        LD     A,(DE)
        LD     M,A
        INC    HL
        INC    DE

        ADD    A,A
        LD     B,A
        CALL   LDHLDE
        PUSH   HL
        EXX
        POP    HL
DIMCLR: XOR    A
        LD     M,A
        INC    HL
        DEC    BC
        LD     A,B
        OR     C
        JR     NZ,DIMCLR
        LD     M,A
        EXX
        POP    DE
        LD     A,(AUTDIM)
        OR     A
        JR     Z,VARCUL
        LD     HL,(DGBF00)
        RET
;
VARCUL: LD     HL,(ARYTXT)
        PUSH   DE
        JP     ARRAY2
        SKP    H

;
DIM:    ENT
        LD     A,FFH
        LD     (AUTDIM),A
NXTDIM: CALL   VSRTST
        LD     A,M
        CALL   CH28H
        CALL   ARRAY0
        CALL   HLFTCH
        CP     ","
        RET    NZ
        INC    HL
        JR     NXTDIM
;
DIMADD: ADD    HL,DE
        RET    NC
        JR     SORDIM
;
DIMMUL: PUSH   BC
        EX     DE,HL
        LD     C,L
        LD     A,H
        LD     HL,0
        CALL   DMMULS
        LD     A,C
        CALL   DMMULS
        POP    BC
        RET
;
DMMULS: OR     A
        JR     Z,SKPMUL
        LD     B,8
DMMULP: ADD    HL,HL
        JR     C,SORDIM
        RLCA
        JR     NC,DMMULE
        ADD    HL,DE
        JR     C,SORDIM
DMMULE: DJNZ   DMMULP
        RET
;
SKPMUL: LD     A,H
        LD     H,L
        LD     L,0
        OR     A
        RET    Z
SORDIM: JP     ER06
;
;
ARYTXT: DEFS   2
AUTDIM: DEFS   1
        SKP    H

;
VARFN2: SUB    "A"
        CP     26
        JP     NC,ER01
        LD     BC,(FNVRBF)
        LD     A,B
        OR     C
        JR     NZ,FNGTVR
        CALL   GETVAR
FNGTV2: PUSH   DE
        PUSH   HL
        LD     L,C
        LD     H,B
        LD     B,A
        LD     C,A
        CALL   LDDEHL
        POP    HL
        LD     A,C
        POP    DE
        JP     FACRX5
;
FNGTVR: PUSH   DE
        CALL   VSRTST
        PUSH   HL
        INC    B
        LD     DE,KEYBUF
        LD     HL,(TMPEND)
        CALL   STRENT
        LD     B,0
        LD     HL,(FNVRBF)
        CALL   HLFTCH
        CP     F4H
        JR     Z,FNSHNO
        CP     "("
        JR     NZ,SERROL       ;¯¯JP NZ,ER01
FNGTL1: INC    HL
        INC    B
        PUSH   BC
        CALL   VSRTST
        LD     A,C
        POP    DE
        CP     E               ;TYPE
        LD     C,E             ;¯¯
        JR     NZ,FNGTL2
        PUSH   DE
        LD     C,B
        INC    C
        PUSH   HL
        LD     HL,(TMPEND)
        LD     DE,KEYBUF
        CALL   HLDECK
        POP    HL
        POP    BC
        JR     Z,FNSHOK
FNGTL2: CALL   HLFTCH
        CP     ")"
        JR     Z,FNSHNO
        CP     ","
        JR     Z,FNGTL1        ;¯¯¯
SERROL: JP     ER01            ;¯¯

FNSHNO: LD     HL,(TMPEND)
        LD     DE,KEYBUF
        LD     A,M
        LD     (DE),A
        LD     B,A
        INC    HL
        INC    DE
        LD     A,M
        LD     (DE),A
        DJNZ   -4
        POP    HL
        POP    DE
        CALL   FNGTV1
        JR     FNGTV2
;
FNSHOK: LD     HL,(FNTXBF)
        CALL   HCH28H
        DEC    B
        JR     Z,FNSH13
        DEC    HL
FNSH11: PUSH   BC
FNSH12: CALL   IFSKSB
        CALL   ENDCHK
        JP     Z,ER01
        CP     ")"
        JP     Z,ER01
        CP     ","
        JR     NZ,FNSH12
        POP    BC
        DJNZ   FNSH11
        INC    HL
FNSH13: EX     DE,HL
        POP    HL
        EX     (SP),HL
        EX     DE,HL
        LD     BC,(FNVRBF)
        PUSH   BC
        LD     BC,0
        LD     (FNVRBF),BC
        CALL   EXPR8
        POP    HL
        LD     (FNVRBF),HL
        POP    HL
        JP     HLFTCH
;
FNGTV1: PUSH   DE
        JP     GETFNV
        SKP    H

;
CHVRNM: ENT
        LD     HL,(VARST)
ASLOP:  LD     DE,KEYBUF
        LD     A,M
        OR     A
        RET    Z
        CP     40H
        JR     NC,ARYATA
        CP     C
        JR     NZ,SKIPUS
        INC    HL
        LD     A,(DE)
        CP     M
        JR     NZ,SKIPU2
        LD     B,A
VARCL1: INC    DE
        INC    HL
        LD     A,(DE)          ;ÛÛ
        CP     M               ;ÛÛ
;CALL NZ,SMALCH
        JR     NZ,SKIPU3
        DJNZ   VARCL1
        INC    HL
        SCF
        RET
SKIPU3: INC    HL
        DJNZ   SKIPU3
        LD     A,C
        JR     ARSKFN
SKIPU2: LD     A,C
        DEC    HL
SKIPUS: AND    0FH             ;TYPE
        INC    HL
        ADD    A,M             ;NAME LEN.
        INC    HL
ARSKFN: LD     E,A
        LD     D,0
       ADD    HL,DE
        JR     ASLOP
;
;
ARYATA: CP     C               ;TYPE
        JR     Z,ARMSN1
        INC    HL
MIDNAM: LD     E,M
        INC    HL
        LD     D,M
        DEC    HL
        ADD    HL,DE
        JR     ASLOP
;
NXTVR1: LD     A,C
        SUB    B
        CPL
        LD     C,A
        LD     B,FFH
        ADD    HL,BC
        POP    BC
NXTVR:  DEC    HL

        DEC    HL
        JR     MIDNAM
;
;
ARMSN1: LD     A,M
        EXX
        LD     C,A
        LD     B,00H
        EXX
        INC    HL
        PUSH   DE
        LD     E,M
        INC    HL
        LD     D,M
        INC    HL
        EX     DE,HL
        ADD    HL,DE
;LD (ARYEDA),HL
        EX     DE,HL
        POP    DE
        LD     A,(DE)
        CP     M               ;NAME LEN.
        JR     NZ,NXTVR
        PUSH   BC
        LD     B,A
        LD     C,A
AYNMCK: INC    HL
        INC    DE
        LD     A,(DE)          ;ÛÛ
        CP     M               ;ÛÛ
        JR     NZ,NXTVR1
        DJNZ   AYNMCK
        INC    HL
        POP    BC
        SCF
        RET
        SKP    H

;
DEFFN:  ENT
        CALL   VSRTST
        SET    6,C
        PUSH   HL
        CALL   CHVRNM
        JP     C,ER07          ;ARY DEF ERR
        LD     M,C
        EX     (SP),HL
        PUSH   HL
        DEC    HL
FNSKP1: CALL   IFSKSB
        OR     A
        JR     Z,FNSKED
        CP     3AH             ;:
        JR     NZ,FNSKP1
FNSKED: POP    DE
        PUSH   HL
        INC    HL
        SBC    HL,DE
        LD     A,(KEYBUF)
        ADD    A,4
        LD     C,A
        LD     B,0
        LD     A,L
        ADD    HL,BC
        LD     B,A
        PUSH   HL
        EXX
        POP    BC
        PUSH   BC
        PUSH   HL
        PUSH   DE
        PUSH   BC
        LD     HL,0
        ADD    HL,SP
        LD     DE,(TMPEND)
        DEC    H
        OR     A
        SBC    HL,DE
        LD     A,12
        JP     C,NESTER
        POP    BC
        POP    DE
        POP    HL
        LD     HL,(TMPEND)
        PUSH   HL
        ADD    HL,BC
        EX     (SP),HL
        PUSH   HL
        LD     DE,(STRST)      ;VAR END
        OR     A
        SBC    HL,DE
        LD     C,L
        LD     B,H
        POP    HL
        POP    DE
        LDDR
        POP    DE
        SVC    .ADDP2

        RST    3
        DEFB   .ADDP2
        ENDM
        DEC    DE
        POP    HL
        EX     (SP),HL
        INC    HL
        LD     M,E
        INC    HL
        LD     M,D
        INC    HL
        LD     DE,KEYBUF
        LD     A,(DE)
        LD     M,A
        LD     B,A
        INC    DE
        INC    HL
        LD     A,(DE)
        LD     M,A
        DJNZ   -4
        INC    HL
        PUSH   HL
        EXX
        POP    HL
        CALL   LDHLDE
        LD     M,0
        POP    HL
        RET
;
FNEXP:  ENT
        PUSH   DE
        CALL   VSRTST
        POP    IX
        PUSH   BC
        SET    6,C
        LD     DE,(FNTXBF)
        LD     (FNTXBF),HL
        PUSH   DE
        CALL   CHVRNM
        JP     NC,ER15         ;UNDEF FN
        LD     DE,(FNVRBF)
        LD     (FNVRBF),HL
        PUSH   DE
        PUSH   IX
        DEC    HL
FNEQSK: CALL   IFSKSB
        CALL   ENDCHK
        JP     Z,ER01
        CP     F4H             ;=
        JR     NZ,FNEQSK
        INC    HL
        POP    DE
        PUSH   DE
        CALL   EXPR8
        POP    DE
        LD     HL,(FNTXBF)
        POP    BC
        LD     (FNVRBF),BC
        POP    BC
        LD     (FNTXBF),BC

        EX     DE,HL
        POP    BC
        LD     A,C
        CALL   STRCK
        LD     BC,5
        ADD    HL,BC
        EX     DE,HL
        CALL   HLFTCH
        CP     "("
        RET    NZ
        PUSH   DE
        LD     B,1
SK29LP: PUSH   BC
        CALL   IFSKSB
        POP    BC
        CALL   ENDCK0
        JP     Z,ER01
        CP     "("
        JR     NZ,+3
        INC    B
        CP     ")"
        JR     NZ,SK29LP
        DJNZ   SK29LP
        INC    HL
        CALL   HLFTCH
        POP    DE
        RET
;
STRCK:  CP     3
        JR     NZ,STROMT
STROK:  ENT
        LD     A,(PRCSON)
        CP     3
        RET    Z
        JP     ER04            ;TYPE MISMATCH
STROMT: ENT
        LD     A,(PRCSON)
        CP     3
        RET    NZ
        JP     ER04
;
FNVRBF: ENT
        DEFW   0
FNTXBF: DEFS   2
        SKP    H

;
;
;
HLDECK: LD     A,(DE)
        CP     M
        RET    NZ
        PUSH   BC
        PUSH   DE
        PUSH   HL
        LD     B,C
HLDEC1: LD     A,(DE)
        CP     M
        JR     NZ,HLDEC2
        INC    DE
        INC    HL
        DJNZ   HLDEC1
        XOR    A
HLDEC2: POP    HL
        POP    DE
        POP    BC
        RET
;
; Joy stick command
;
STCK:   ENT
        CALL   HCH28H
        PUSH   DE
        CALL   DEEXP
        CALL   DCHECK
        CP     3
        JP     NC,ER03
        POP    DE
        PUSH   AF
        CALL   HCH29H
        POP    AF
        SVC    .STICK
        RST    3
        DEFB   .STICK
        ENDM
        EX     DE,HL
        PUSH   DE
        CALL   PUT1B
        JP     EOF8
;
STIG:   ENT
        CALL   HCH28H
        PUSH   DE
        CALL   DEEXP
        CALL   DCHECK
        CP     5
        JP     NC,ER03
        POP    DE
        PUSH   AF
        CALL   HCH29H
        POP    AF
        SVC    .STRIG
        RST    3
        DEFB   .STRIG
        ENDM
        EX     DE,HL

        PUSH   DE
        CALL   PUT1B
        JP     EOF8
;
        END

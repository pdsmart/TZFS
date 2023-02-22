; ---------------------------------
; MZ-800 BASIC  Statement interprit
; FI:STMNT  ver 1.0A 9.06.84
; Programed by T.Miho
; ---------------------------------
;
        INCLD  MACRO
;
LET:    ENT
        TEST1  FFH
        CALL   TEST1
        DEFB   FFH
        ENDM
        JP     Z,PFUNCT
        CALL   INTGTV
        PUSH   BC
        PUSH   BC
        PUSH   AF
        TESTX  F4H             ;=
        CALL   TESTX
        DEFB   F4H
        ENDM
        CALL   EXPR
        POP    BC
        LD     A,(PRCSON)
        CP     B
        JP     NZ,ER04
        EX     (SP),HL         ; VAR ADRS<>TEXTPOINT
        EX     DE,HL
        CP     05H
        JR     Z,DAIBCK
        PUSH   BC
        CALL   STRDAI
        POP    AF
        POP    HL
        POP    BC
        RET
;
DAIBCK: LD     C,A
        LD     B,0
        LDIR
        POP    HL
        POP    BC
        RET
;
PFUNCT: ENT
        TESTX  C4H
        CALL   TESTX
        DEFB   C4H
        ENDM
        JP     TIMDAI          ;TI$=...
;
STRLET: ENT
        PUSH   DE
        EX     DE,HL
        JR     STRDI2
;
STRDAI: ENT
        PUSH   DE
        CALL   CVTSDC

STRDI2: LD     HL,KEYBM1
        LD     M,A
        LD     B,A
        LD     C,A
        INC    HL
        CALL   LDHLDE
        POP    HL
        LD     A,M
        CP     C
        JR     Z,SMLNST
        PUSH   HL
        OR     A
        CALL   NZ,DELSTR
        POP    HL
        LD     A,(KEYBM1)
        OR     A
        JR     Z,STRNL1
        PUSH   HL
        LD     BC,(VARST)
        SBC    HL,BC
        EX     DE,HL
        LD     HL,(VARED)
        DEC    HL
        DEC    HL
        LD     M,E
        INC    HL
        LD     M,D
        INC    HL
        LD     BC,(STRST)
        OR     A
        POP    DE
        PUSH   HL
        SBC    HL,BC
        EX     DE,HL
        LD     M,A
        LD     B,A
        INC    HL
        LD     M,E
        INC    HL
        LD     M,D
        POP    HL
        LD     DE,KEYBM1
        INC    DE
        CALL   STRENT
        CALL   LDHL00
        LD     (TMPEND),HL
        LD     (VARED),HL
        RET
;
STRNL1: LD     M,0
        RET
;
SMLNST: INC    HL
        LD     E,M
        INC    HL
        LD     D,M
        LD     HL,(STRST)
        ADD    HL,DE
        LD     DE,KEYBM1
        LD     B,C

        INC    DE
        JP     STRENT
;
DELSTR: LD     C,M
        LD     B,0
        INC    BC
        INC    BC
        INC    HL
        LD     E,M
        INC    HL
        LD     D,M
        LD     HL,(STRST)
        ADD    HL,DE
        DEC    HL
        DEC    HL
        LD     E,L
        LD     D,H
        ADD    HL,BC
        PUSH   BC
        PUSH   DE
        EX     DE,HL
        LD     HL,(VARED)
        OR     A
        SBC    HL,DE
        LD     C,L
        LD     B,H
        EX     DE,HL
        POP    DE
        PUSH   DE
        JR     Z,+4
        LDIR
        POP    DE
        POP    BC
        LD     HL,(VARED)
        OR     A
        SBC    HL,BC
        LD     (VARED),HL
        EX     DE,HL
STRDE1: LD     E,M
        INC    HL
        LD     D,M
        LD     A,D
        OR     E
        RET    Z
        LD     HL,(VARST)
        ADD    HL,DE
        LD     A,M
        INC    HL
        LD     E,M
        INC    HL
        LD     D,M
        OR     A
        EX     DE,HL
        SBC    HL,BC
        EX     DE,HL
        LD     M,D
        DEC    HL
        LD     M,E
        PUSH   BC
        LD     C,A

        LD     B,0
        LD     HL,(STRST)
        ADD    HL,DE
        ADD    HL,BC
        POP    BC
        JR     STRDE1
        SKP    H

;
FOR:    ENT                    ;FOR TO STEP
        POP    BC
        LD     (FORRTA),BC
        CALL   LET
        LD     IX,0
        ADD    IX,SP
        LD     (FRTXPT),HL
        CALL   VAROFST
        LD     (FORVAD+1),BC
FOR3:   LD     E,(IX+0)
        LD     D,(IX+1)
        LD     HL,FF12H
        OR     A
        SBC    HL,DE
        JR     NZ,FOR1
        LD     E,(IX+6)
        LD     D,(IX+7)
        EX     DE,HL
        OR     A
        SBC    HL,BC
        JR     Z,FOR2          ;EQL FORVAR
        LD     DE,012H
        ADD    IX,DE
        JR     FOR3
FOR2:   LD     DE,012H
        ADD    IX,DE
        LD     SP,IX
FOR1:   LD     HL,(FRTXPT)
        TESTX  E0H             ;TO
        CALL   TESTX
        DEFB   E0H
        ENDM
        CALL   EXPR
        PUSH   AF
        PUSH   HL
        EX     DE,HL
        LD     DE,TODTBF
        CALL   LDIR5
        POP    HL
        POP    AF
        CP     E1H             ;STEP
        LD     DE,FLONE
        JR     NZ,SSTEP1
        INC    HL
        CALL   EXPR
SSTEP1: LD     (FRTXPT),HL
        LD     HL,FFF6H        ;-10
        ADD    HL,SP
        LD     SP,HL
        EX     DE,HL
        CALL   LDIR5
        LD     HL,TODTBF
        CALL   LDIR5
FORVAD: LD     HL,0
        PUSH   HL
        DEFB   21H
FRTXPT: DEFS   2
        PUSH   HL
        LD     HL,(NXTLPT)

        PUSH   HL
        LD     HL,FF12H        ;FOR MARK
        PUSH   HL
        LD     HL,-512
        ADD    HL,SP
        LD     DE,(TMPEND)
        SBC    HL,DE
        LD     A,11            ;FOR..NEXT ERR
        JP     C,NESTER
        LD     HL,(FRTXPT)
        DEFB   C3H
FORRTA: DEFS   2
;
;
NEXT:   ENT                    ;NEXT
        LD     A,5
        LD     (PRCSON),A
        POP    BC
        LD     (NEXRTA),BC
NEXT6:  PUSH   AF
        POP    BC
        LD     (FRTXPT),HL
        LD     IX,0
        ADD    IX,SP
        LD     (FORSTK),IX
        LD     E,(IX+0)
        LD     D,(IX+1)
        LD     HL,FF12H
        OR     A
        SBC    HL,DE
        JP     NZ,ER13
        PUSH   BC
        POP    AF
        JR     NZ,NEXT1
;
        LD     E,(IX+4)        ;FOR TEXTPO
        LD     D,(IX+5)
        EX     DE,HL
        LD     (NEXT4+1),HL
;
        LD     E,(IX+6)        ;FORVAD
        LD     D,(IX+7)
        LD     HL,(VARST)
        ADD    HL,DE
;
        LD     BC,8            ;STEP ADR
        ADD    IX,BC
        PUSH   IX
        POP    DE
        CALL   ADD
        INC    DE
        LD     A,(DE)
        LD     IX,(FORSTK)
        LD     DE,0DH
        ADD    IX,DE
        PUSH   IX
        POP    DE
        BIT    7,A
        JR     NZ,+3
        EX     DE,HL

        CALL   CMP
        JR     C,NEXT3         ;END
        DEFB   31H
FORSTK: DEFS   2
        LD     HL,2
        ADD    HL,SP
        LD     A,M
        INC    HL
        LD     H,M
        LD     L,A
        LD     (NXTLPT),HL
NEXT4:  LD     HL,0            ;TEXTPO
NEXT5:  DEFB   C3H
NEXRTA: DEFS   2
NEXT3:  LD     DE,012H
        LD     HL,(FORSTK)
        ADD    HL,DE
        LD     SP,HL
        LD     HL,(FRTXPT)
        TEST1  ","
        CALL   TEST1
        DEFB   ","
        ENDM
        JR     NZ,NEXT5
;
        LD     (FRTXPT),HL
NEXT1:  LD     IX,0
        ADD    IX,SP
        LD     (FORSTK),IX
        LD     HL,(FRTXPT)
        TEST1  ","
        CALL   TEST1
        DEFB   ","
        ENDM
        JP     Z,NEXT6
        CALL   INTGTV
        LD     (FRTXPT),HL
        CALL   VAROFST
        LD     IX,(FORSTK)
NEXT12: LD     E,(IX+0)
        LD     D,(IX+1)
        LD     HL,FF12H
        OR     A
        SBC    HL,DE
        JP     NZ,ER13
        LD     L,(IX+6)
        LD     H,(IX+7)
        OR     A
        SBC    HL,BC
        LD     HL,(FRTXPT)
        JP     Z,NEXT6
        LD     DE,012H
        ADD    IX,DE
        LD     (FORSTK),IX
        LD     SP,(FORSTK)
        JR     NEXT12
;
VAROFST:LD     HL,BC
        LD     BC,(VARST)
        OR     A

        SBC    HL,BC
        LD     BC,HL
        RET
;
TODTBF: DEFS   5
;
FRLNBF: DEFS   2
FRNLPT: DEFS   2
;
FORSKS: CALL   IFSKSB
        OR     A
        RET    NZ
        INC    HL
        PUSH   DE
        LD     E,M
        INC    HL
        LD     D,M
        LD     A,D
        OR     E
        INC    HL
        LD     (FRNLPT+1),DE
        LD     E,M
        INC    HL
        LD     D,M
        LD     (FRLNBF+1),DE
        POP    DE
        SCF
        RET    Z
        JR     FORSKS
        SKP    H

;
USR:    ENT                    ;USR(adrs,source$,dest$)
        CALL   CH28H
        CALL   IDEEXP          ;adrs
        LD     (USRADR+1),DE
        TEST1  ","
        CALL   TEST1
        DEFB   ","
        ENDM
        JR     NZ,USR2
        CALL   EXPR            ;source$
        CALL   STROK
        LD     (USRSRC+1),DE
        TEST1  ","
        CALL   TEST1
        DEFB   ","
        ENDM
        JR     NZ,USR2
        CALL   INTGTV          ;dest$
        CALL   STROK
        LD     (USRDST+1),BC
        XOR    A
USR2:   PUSH   HL
        PUSH   AF
USRSRC: LD     HL,0            ;xxx
        CALL   CVTSDC
        LD     IX,ERRORJ
        XOR    A
USRADR: CALL   0               ;xxx
        POP    AF
        JR     NZ,USR8
        LD     A,B             ;dest$ exist
        EX     DE,HL
USRDST: LD     DE,0            ;xxx
        CALL   STRLET
USR8:   POP    HL
        JP     HCH29H
        SKP    H

;
;
PAUSE:  ENT                    ;PAUSE command
        CALL   IDEEXP
PAUSE2: LD     A,D
        OR     E
        RET    Z
        LD     B,FBH           ;JAPAN 00H
        DJNZ   +0
        SVC    .BREAK
        RST    3
        DEFB   .BREAK
        ENDM
        RET    Z
        DEC    DE
        JR     PAUSE2
;
REM:    ENT                    ;REM   command
LABEL:  ENT                    ;LABEL command
DATA:   ENT                    ;DATA  command
GSUB:   ENT                    ;GOSUB command
        DEC    HL
DATA0:  CALL   IFSKSB
        OR     A
        SCF
        RET    Z
        CP     ":"
        RET    Z
        JR     DATA0
;
OUT@:   ENT                    ;OUT @port,data
        CALL   IBYTE
        SUB    E0H
        CP     7
        JP     C,ER03          ;E0H .. E6H
        CALL   HCH2CH
        PUSH   DE
        CALL   IBYTE
        POP    BC
        OUT    (C),A
        RET
;
INP@:   ENT                    ;INP @port,vara
        CALL   IBYTE
        CALL   HCH2CH
        PUSH   DE
        CALL   INTGTV
        CP     5
        JP     NZ,ER04
        EX     (SP),HL
        PUSH   BC
        EX     (SP),HL
        POP    BC
        IN     E,(C)
        LD     D,0
        CALL   FLTHEX
        POP    HL
        RET
        SKP    H

;
CURSOR: ENT                    ;CURSOR x,y
        CALL   CSRXY
        EX     DE,HL
        SVC    .CURMV
        RST    3
        DEFB   .CURMV
        ENDM
        EX     DE,HL
        RET
;
CSRXY:  ENT
        LD     B,24
        LD     C,39
        LD     A,(CRTMD2)      ;80 char. mode change
        CP     3
        JR     C,CSRXY3
        LD     C,79
CSRXY3: CALL   CSRXY2
        JP     C,ER03
        RET
;
CSRXY2: PUSH   BC
        CALL   IBYTE
        PUSH   AF
        CALL   HCH2CH
        CALL   IBYTE
        LD     D,E
        POP    AF
        LD     E,A
        POP    BC
        LD     A,C
        CP     E
        RET    C
        LD     A,B
        CP     D
        RET
;
GETOP:  ENT                    ;GET var
        CALL   INTGTV
        LD     (PRCSON),A
        CP     5
        JR     Z,GETSUJ
        PUSH   HL              ;GET STR
        PUSH   BC
        LD     A,FFH
        SVC    .INKEY
        RST    3
        DEFB   .INKEY
        ENDM
        OR     A
        JR     Z,NLGTKY
        LD     HL,(TMPEND)
        LD     M,A
        LD     A,1
NLGTKY: POP    DE
        CALL   STRLET
        POP    HL
        RET
;

GETSUJ: PUSH   HL
        PUSH   BC
        LD     A,FFH
        SVC    .INKEY
        RST    3
        DEFB   .INKEY
        ENDM
        SUB    30H
        CP     0AH
        JR     C,+3
        XOR    A
        LD     E,A
        LD     D,0
        POP    HL
        CALL   FLTHEX
        POP    HL
        RET
        SKP    H

;
POKE:   ENT                    ;POKE ad,d1,d2,d3,...
        CALL   IDEEXP
        CALL   CH2CH
POKELP: PUSH   DE
        CALL   IBYTE
        POP    DE
        LD     (DE),A
        INC    DE
        TEST1  ","
        CALL   TEST1
        DEFB   ","
        ENDM
        RET    NZ
        JR     POKELP
;
LIMIT:  ENT                    ;LIMIT adrs
        PUSH   HL
        TEST1  "M"
        CALL   TEST1
        DEFB   "M"
        ENDM
        JR     NZ,LIMIT1
        TEST1  "A"
        CALL   TEST1
        DEFB   "A"
        ENDM
        JR     NZ,LIMIT1
        TEST1  "X"
        CALL   TEST1
        DEFB   "X"
        ENDM
        JR     NZ,LIMIT1
        EX     (SP),HL
        LD     HL,(MEMMAX)
        JR     LIMIT2
LIMIT1: POP    HL
        CALL   IDEEXP
        PUSH   HL
        LD     HL,(MEMMAX)
        OR     A
        SBC    HL,DE
        JP     C,ER06'
        LD     HL,(TMPEND)
        INC    H
        INC    H
        INC    H
        INC    H
        OR     A
        SBC    HL,DE
        JP     NC,ER03
        EX     DE,HL
LIMIT2: CALL   MEMSET
        POP    HL
        POP    DE
        LD     SP,(INTFAC)
        LD     BC,FFFFH
        PUSH   BC
        PUSH   DE
        RET

        SKP    H

;
RETURN: ENT                    ;RETURN linenumber
        POP    IX
RETRN2: POP    BC
        PUSH   BC
        LD     A,B
        INC    A
        JP     NZ,ER14
        LD     A,C
        CP     12H
        JR     Z,RETRN6
        CP     FEH
        JP     NZ,ER14
        POP    BC
        CALL   ENDCHK
        EX     DE,HL
        POP    HL
        LD     (LNOBUF),HL
        POP    HL
        LD     (NXTLPT),HL
        POP    HL
        PUSH   IX
        RET    Z
        EX     DE,HL
        JP     GOTO
RETRN6: EX     DE,HL
        LD     HL,12H
        ADD    HL,SP
        LD     SP,HL
        EX     DE,HL
        JR     RETRN2
;
GOSUB:  ENT                    ;GOSUB linenumber
        PUSH   HL
        CALL   GSUB
        EX     DE,HL
        POP    HL
        POP    BC
        PUSH   DE
        EXX
        LD     HL,(NXTLPT)
        PUSH   HL
        LD     HL,(LNOBUF)
        PUSH   HL
        LD     HL,FFFEH
        PUSH   HL
        LD     HL,-512
        ADD    HL,SP
        LD     DE,(TMPEND)
        SBC    HL,DE
        LD     A,10
        JP     C,NESTER
        EXX
        PUSH   BC
        JR     GOTO
        SKP    H

;
ON:     ENT                    ;ON command
        TEST1  C1H
        CALL   TEST1
        DEFB   C1H
        ENDM
        JP     Z,ONERRG        ;ON ERROR
        CALL   IDEEXP
        LD     C,E
        LD     B,D
        CP     87H
        JP     NC,ER01
        CP     82H
        JR     NZ,ON.4
        CALL   INCHLF
        LD     E,81H
        CP     E4H
        JR     Z,ON.2
        CP     E0H
        JP     NZ,ER01
        DEC    E
ON.2:   LD     A,E
ON.4:   PUSH   HL
        LD     HL,SJPTBL
        SUB    80H
        ADD    A,A
        LD     E,A
        LD     D,0
        ADD    HL,DE
        CALL   INDRCT
        EX     (SP),HL
        INC    HL
        LD     A,B
        OR     A
        JR     NZ,ON.9
        LD     A,C
        OR     A
        JR     Z,ON.9
        LD     B,A
ON.6:   DEC    B
        RET    Z
        CALL   HLFTCH
        CALL   LINE?
        JP     NZ,ER01
        CALL   DTSKL1
        OR     A
        RET    Z
        INC    HL
        TEST1  ","
        CALL   TEST1
        DEFB   ","
        ENDM
        JR     Z,ON.6
        POP    DE
        JP     ENDZ
ON.9:   POP    DE
        JP     DATA
        SKP    H

;
GOTO:   ENT                    ;GOTO linenumber
        CALL   GETLIN
        EX     DE,HL
        JR     NZ,+5
        LD     HL,(TEXTST)     ;GOTO 0
        LD     (NXTLPT),HL
        XOR    A
        LD     (CONTFG),A
        JP     NXLINE
;
IF:     ENT                    ;IF THEN ELSE
        CALL   EXPR
        EX     AF,AF'
        LD     A,(DE)
        OR     A
        JR     Z,IFALSE
        EX     AF,AF'
        CP     E2H             ;THEN
        JR     NZ,IF.4
IF.2:   CALL   INCHLF
        CALL   LINE?
        JR     Z,GOTO
IF.4:   POP    AF
        JP     MAIN
;
LINE?:  ENT
        CP     '"'
        RET    Z
LINE?2: ENT
        CP     0BH
        RET    Z
        CP     0CH
        RET
;
ELSE:   ENT
        CALL   IFSKIP
        JR     NC,-3
        RET
;
IFALSE: DEC    HL
        CALL   IFSKIP
        JR     NC,IF.2
        JP     ENDLIN
;
IFSKIP: CALL   IFSKSB
        OR     A
        SCF
        RET    Z
        CP     C2H             ;ELSE
        RET    Z
        CP     93H             ;IF
        JR     NZ,IFSKIP
        CALL   IFSKIP
        RET    C
        JR     IFSKIP
;
DTSKSB: ENT
        INC    HL
        LD     A,M

        JR     DTSKL1
;
IFSKSB: ENT
        INC    HL
        LD     A,M
        CP     94H             ;DATA
        JR     Z,IFDASK
DTSKL1: OR     A
        RET    Z
        CP     '"'
        JR     Z,IFDQSK
        CP     FEH             ;FUNC/OPTION
        JR     NC,IFFNRT
        CP     97H             ;REM
        JR     Z,IFDASK
        CP     27H             ;'
        JR     Z,IFDASK
        CP     20H
        RET    NC
        CP     0BH
        RET    C
        CP     15H
        JR     NC,ISKFLT
        INC    HL
IFFNRT: INC    HL
        RET
;
;
IFDASK: LD     A,M
        OR     A
        RET    Z
        CP     3AH
        RET    Z
        CP     '"'
        JR     Z,DADQSK
        INC    HL
        JR     IFDASK
;
DADQSK: CALL   IFDQSK
        OR     A
        RET    Z
        INC    HL
        JR     IFDASK
;
ISKFLT: AND    0FH
        ADD    A,L
        LD     L,A
        LD     A,20H
        RET    NC
        INC    H
        RET
;
IFDQSK: INC    HL
        LD     A,M
        OR     A
        RET    Z
        CP     '"'
        RET    Z
        JR     IFDQSK
        SKP    H

;
;
BEEP:   ENT                    ;BEEP command
        SVC    .BELL
        RST    3
        DEFB   .BELL
        ENDM
        RET
;
BYE:    ENT                    ;BYE command
        CALL   ENDZ
        SVC    .CLRIO
        RST    3
        DEFB   .CLRIO
        ENDM
        SVC    .MONOP
        RST    3
        DEFB   .MONOP
        ENDM
        RET
        SKP    H

;
CONSOL: ENT                    ;CONSOLE x,xl,y,yl
        JR     Z,CONSOI
        LD     A,(YS)
;
;CONSCK
        LD     D,0
        LD     E,A
        TEST1  ","
        CALL   TEST1
        DEFB   ","
        ENDM
        JR     Z,CONSOK
        CALL   IBYTE
        CALL   HCH2CH
CONSOK: LD     C,E
        PUSH   BC
        CALL   IBYTE
        POP    BC
        DEC    A
        JP     M,ER03
        ADD    A,C
        CP     25
        JP     NC,ER03
        LD     B,A
;
        PUSH   HL
        LD     H,B
        LD     L,C
        SVC    .DWIND
        RST    3
        DEFB   .DWIND
        ENDM
        POP    HL
        RET
CONSOI: ENT                    ;CONSOLE INIT
        PUSH   HL
        LD     HL,1800H
        SVC    .DWIND
        RST    3
        DEFB   .DWIND
        ENDM
        POP    HL
        RET
;
BOOT:   ENT                    ;BOOT command
        DI
        OUT    (E4H),A
        JP     0
        SKP    H

;
;
SEARCH: ENT                    ;SEARCH#n "xxxx"
        XOR    A
        DEFB   1
LIST:   ENT                    ;LIST#n   Start-End
        LD     A,1
        LD     (SELTF),A
        PUSH   AF
        CALL   GETLU
        SVC    .LUCHK
        RST    3
        DEFB   .LUCHK
        ENDM
        JP     C,ER64
        BIT    1,A             ;W?
        JP     Z,ER64
        TEST1  ","
        CALL   TEST1
        DEFB   ","
        ENDM
        POP    AF
        OR     A
        JR     NZ,LIST10
        CALL   STREXP          ;SEARCH command only
        LD     A,B
        LD     (SECLEN),A
        LD     (SESTR),DE
        CALL   ENDZ
        JR     LIST10
;
LIST0:  ENT
        LD     A,2
        LD     (SELTF),A
LIST10: CALL   GTSTED
        LD     (LISTSN),DE
        LD     (LISTEN),BC
        LD     A,FFH
        LD     (DISPX),A
        CALL   PUSHR
        LD     HL,(TEXTST)
LIST20: CALL   LDDEMI
        LD     A,D
        OR     E
        RET    Z
        EX     DE,HL
        ADD    HL,DE
        DEC    HL
        DEC    HL
        EX     DE,HL
        PUSH   DE
        CALL   LDDEMI
        PUSH   HL
        DEFB   21H
LISTSN: DEFS   2
        OR     A
        SBC    HL,DE
        JR     C,LIST30
        JR     Z,LIST30
        POP    HL

        POP    HL
        JR     LIST20
;
LIST30: DEFB   21H
LISTEN: DEFS   2
        OR     A
        SBC    HL,DE
        JR     NC,LIST40
        POP    HL
        POP    HL
        RET
;
;
LIST40: EX     DE,HL
        CALL   ASCFIV
        SVC    .COUNT
        RST    3
        DEFB   .COUNT
        ENDM
        LD     HL,KEYBUF
        CALL   LDHLDE
        LD     M," "
        INC    HL
        EX     DE,HL
        POP    HL
        CALL   CVTXIM
        LD     A,(SELTF)
        OR     A
        JR     NZ,LIST50
        CALL   SSEST
        JR     NC,LIST60
LIST50: LD     DE,KEYBUF
        SVC    .COUNT
        RST    3
        DEFB   .COUNT
        ENDM
        SVC    .PRSTR
        RST    3
        DEFB   .PRSTR
        ENDM
        CALL   PRTCR
LIST60: POP    HL
        LD     A,(SELTF)
        CP     2
        JR     Z,LIST20        ;ASCII SAVE
        SVC    .HALT
        RST    3
        DEFB   .HALT
        ENDM
        JR     LIST20
;
;
;
; HL=TEXT START ADDRESS
;
SSEST:  EX     DE,HL
SSESTL: PUSH   HL
        CALL   SSESTS
        POP    HL
        RET    C

        RET    Z
        INC    HL
        JR     SSESTL
;
;;;;;;;;;;;;;;;;;;;;;;
;
;  ent HL:CMP pointer
;
;  ext CY=1  sane string
;      CY=0  Acc=0 not same & text end
;            Acc=FFH not same chr
;
SSESTS: LD     A,(SECLEN)      ;String Length
        LD     B,A
        LD     DE,(SESTR)      ;String address
SSEST0: LD     A,(HL)
        INC    HL
        OR     A
        RET    Z
        CP     5
        JR     Z,SSEST1
        CP     6
        JR     NZ,SSEST2
SSEST1: JR     SSEST0
;
SSEST2: PUSH   HL
        LD     C,A
SSEST4: LD     A,(DE)
        INC    DE
        CP     5
        JR     Z,SSEST3
        CP     6
        JR     NZ,SSEST5
SSEST3: DEC    B
        SCF
        POP    HL
        RET    Z
        PUSH   HL
        JR     SSEST4
SSEST5: SUB    C
        POP    HL
        OR     A
        RET    NZ              ;1 Chr not same
        DEC    B
        SCF
        RET    Z
        JR     SSEST0
;
;
SECLEN: DEFS   1               ;Stling length
;
SESTR:  DEFS   2               ;Stling Addrsess
;
SSESTW: DEFS   2               ;Line No.
;
SELTF:  DEFS   1               ;0:SEARCH , 1:LIST
;
        SKP    H

;
KLIST:  ENT                    ;KEY LIST
        TESTX  87H             ;LIST
        CALL   TESTX
        DEFB   87H
        ENDM
        CALL   TESTP
        PUSH   HL
        LD     C,0
KLSTLP: SVC    .&CR
        RST    3
        DEFB   .&CR
        ENDM
        LD     A,C
        ADD    A,"1"
        LD     D,A
        LD     E," "
        CP     3AH
        JR     NZ,+5
        LD     DE,"01"
        LD     (KEYME2),DE
        LD     DE,KEYME1       ;'DEF KEY('
        SVC    .&MSG
        RST    3
        DEFB   .&MSG
        ENDM
        LD     A,C
        CALL   KEYBCL
        LD     B,M
        INC    HL
        PUSH   BC
        CALL   STKYMS          ;(DE)=MSTRING
        POP    BC
        INC    C
        LD     A,C
        CP     10
        JR     NZ,KLSTLP
        SVC    .&CR
        RST    3
        DEFB   .&CR
        ENDM
        POP    HL
        RET
;
STKYMS: LD     A,B
        OR     A
        LD     C,0
        JR     NZ,STKYM1
        LD     A,'"'
        SVC    .&1CX
        RST    3
        DEFB   .&1CX
        ENDM
        SVC    .&1CX
        RST    3
        DEFB   .&1CX
        ENDM
        RET
STKYM1: LD     A,M
        CP     20H

        JR     C,CHRME1
        CP     '"'
        JR     Z,CHRME1
        LD     A,C
        CP     1
        JR     Z,CHRM22
        OR     A
        LD     DE,KEYME3
        JR     NZ,+4
        INC    DE
        INC    DE
        SVC    .&MSG
        RST    3
        DEFB   .&MSG
        ENDM
CHRM22: LD     A,M
        SVC    .&1CX
        RST    3
        DEFB   .&1CX
        ENDM
        INC    HL
        LD     C,1
        DJNZ   STKYM1
STKYE2: LD     A,'"'
..&1CX: SVC    .&1CX
        RST    3
        DEFB   .&1CX
        ENDM
        RET
;
CHRME1: LD     A,C
        CP     FFH
        JR     Z,CHRM12
        OR     A
        LD     DE,KEYME4
        JR     NZ,+4
        INC    DE
        INC    DE
        SVC    .&MSG
        RST    3
        DEFB   .&MSG
        ENDM
CHRM16: PUSH   BC
        PUSH   HL
        LD     L,M
        LD     H,0
        CALL   ASCFIV
        SVC    .&MSG
        RST    3
        DEFB   .&MSG
        ENDM
        POP    HL
        POP    BC
        INC    HL
        LD     C,FFH
        DJNZ   STKYM1
        LD     A,")"
        JP     ..&1CX
;
CHRM12: LD     A,","

        SVC    .&1CX
        RST    3
        DEFB   .&1CX
        ENDM
        JR     CHRM16
;
KEYME1: DEFM   'DEF KEY('

KEYME2: DEFS   2
        DEFM   ')='
        DEFB   0
KEYME3: DEFM   ')+"'
        DEFB   0
KEYME4: DEFM   '"+CHR$('

        DEFB   0
        SKP    H

;
DEFOP:  ENT                    ;DEF command
        TEST1  B2H
        CALL   TEST1
        DEFB   B2H
        ENDM
        JR     Z,DEFKEY        ;DEF KEY(n)="..."
        TESTX  FFH
        CALL   TESTX
        DEFB   FFH
        ENDM
        TESTX  C7H
        CALL   TESTX
        DEFB   C7H
        ENDM
        JP     DEFFN           ;DEF FNx(x)=expr
;
DEFKEY: TESTX  "("
        CALL   TESTX
        DEFB   "("
        ENDM
        CALL   IBYTE
        TESTX  ")"
        CALL   TESTX
        DEFB   ")"
        ENDM
        TESTX  F4H             ;=
        CALL   TESTX
        DEFB   F4H
        ENDM
        LD     A,E
        DEC    A
        CP     10
        JP     NC,ER03
        PUSH   HL
        CALL   KEYBCL
        EX     (SP),HL
        CALL   STREXP          ;A,DE
        EX     (SP),HL
        LD     A,B
        CP     16
        JR     C,+4
        LD     A,15
        LD     M,A
        OR     A
        JR     Z,ESCKPT
        LD     B,A
        INC    HL
        LD     A,(DE)
        LD     M,A
        INC    DE
        INC    HL
        DJNZ   -4
ESCKPT: POP    HL
        EI
        RET
;
;
KEYBCL: ADD    A,A
        ADD    A,A

        ADD    A,A
        ADD    A,A
        LD     HL,FUNBUF
        JP     ADDHLA
;
        END

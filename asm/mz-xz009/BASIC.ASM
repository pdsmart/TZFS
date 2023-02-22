; --------------------------
; MZ-800 BASIC  Main program
; FI:BASIC  ver 1.0A 9.06.84
; Programed by T.Miho
; --------------------------
;
        INCLD  MACRO
;
%YEN:   EQU    7DH
;
$BASIC: ENT
        PUSH   BC
        CALL   CLSHET
        POP    BC
        LD     HL,NEWAD0
        LD     (TEXTST),HL
        LD     HL,CLSST
        LD     (SYSSTA),HL
        LD     A,B
        OR     A
COLDRT: JP     Z,$BAS2         ;JP $BAS3  Change
        CP     1
        JR     Z,$BAS2
        LD     HL,ARUN
        LD     DE,INBUFL
        LD     BC,16
        LDIR
$BAS2:  LD     DE,IMDBUF
        SVC    .CRTMS
        RST    3
        DEFB   .CRTMS
        ENDM
        SVC    .BELL
        RST    3
        DEFB   .BELL
        ENDM
        LD     A,C3H
        LD     (COLDRT),A
        LD     HL,$BAS3
        LD     (COLDRT+1),HL
;
$BAS3:  LD     HL,NEWAD0
MEMCLI: LD     M,0
        INC    HL
        LD     A,H
        CP     FFH             ;mem max
        JR     C,MEMCLI
        CALL   MEMSET
        CALL   NEWTXT
        CALL   IOINIT
        JR     HOTENT
;
ARUN:   DEFB   15
        DEFM   'RUN "AUTO RUN"'



        DEFB   0DH
;
;

CLSHET: LD     A,1             ;INIT "CRT:M1"
        SVC    .DSMOD
        RST    3
        DEFB   .DSMOD
        ENDM
        XOR    A
        LD     (PWMODE),A
        INC    A
        LD     (CRTMD2),A
        LD     (CRTMD1),A
        SVC    .ICRT
        RST    3
        DEFB   .ICRT
        ENDM
        RET
;
CLSST:  CALL   CLSHET
;
HOTENT: LD     HL,ERRORA
        LD     (ERRORP),HL
;
;
OK:     ENT
        SVC    .CR2
        RST    3
        DEFB   .CR2
        ENDM
        LD     DE,OKMES
        SVC    .CRTMS
        RST    3
        DEFB   .CRTMS
        ENDM
        SVC    .CR1
        RST    3
        DEFB   .CR1
        ENDM
INPAGN: ENT
        LD     A,(CONTFG)
        OR     A
        JR     NZ,INPAG2
        LD     SP,(INTFAC)
        LD     HL,FFFFH
        PUSH   HL
        LD     (STACK),SP
INPAG2: LD     HL,0            ;Set direct-mode
        LD     (LNOBUF),HL
        XOR    A
        LD     (CMTMSG),A
        CALL   AUTODS
        SVC    .ERCVR          ;FD,QD motor off
        RST    3
        DEFB   .ERCVR
        ENDM
        LD     DE,KEYBUF
        SVC    .GETL
        RST    3
        DEFB   .GETL
        ENDM
        JR     NC,NORINP
AUTOFF: LD     HL,AUTOFG

        LD     A,M
        OR     A
        LD     M,0
        JR     NZ,OK
        JR     INPAGN
;
;
NORINP: CALL   SKPDE
        OR     A
        JR     Z,INPAGN
        CALL   TSTNUM
        JP     NC,EDITOR
        LD     HL,IMDBUF       ;Direct command
        PUSH   HL
        CALL   CVIMTX
        INC    HL
        LD     (NXTLPT),HL
        CALL   LDHL00
        POP    HL
        JR     MAIN
;
; Execute
;
MAIN9:  CALL   ENDZ
;
MAIN:   ENT
        LD     (STACK),SP
MAIN0:  ENT
        LD     DE,MAIN9
        PUSH   DE
MAIN2:  LD     (TEXTPO),HL
        CALL   BRKCHK
        JP     Z,BREAKZ
MAIN4:  LD     A,M
        INC    HL
        CP     80H
        JR     NC,STATEM
        CP     "'"
        JP     Z,DATA
        CP     " "
        JR     Z,MAIN4
        CP     ":"
        JR     Z,MAIN2
        OR     A
        JR     Z,ENDLIN        ;END OF LINE
        DEC    HL
        SUB    "A"
        CP     26
        JP     C,LET
        JP     ER01
;
ENDLIN: ENT
        LD     HL,(NXTLPT)
NXLINE: ENT
        LD     E,M
        INC    HL
        LD     D,M
        LD     A,D
        OR     E
        JR     Z,ENDPRG        ;END OF PROGRAM

        LD     (CMTMSG),A
        EX     DE,HL
        ADD    HL,DE
        DEC    HL
        LD     (NXTLPT),HL
        EX     DE,HL
        INC    HL
        CALL   LDDEMI
        LD     (LNOBUF),DE
        CALL   TRDISP
        POP    DE
        JR     MAIN
;
ENDPRG: POP    HL
        CALL   ?DIRECT
        JP     Z,OK
        XOR    A
        LD     (CONTFG),A
        LD     A,(ERRORF)
        CP     2
        JP     Z,ER20
        PUSH   HL
        JP     END             ;end command
;
;
STATEM: CP     FFH             ;command jp
        JP     Z,PFUNCT
        LD     DE,GJPTBL
        CP     FEH
        JR     NZ,NROSTM
        LD     A,M
        INC    HL
        JR     MIDFJP
NROSTM: CP     E0H
        JP     NC,ER01
        LD     DE,SJPTBL
MIDFJP: ADD    A,A
        PUSH   HL
        EX     DE,HL
        LD     E,A
        LD     D,0
        ADD    HL,DE
        LD     A,M
        INC    HL
        LD     H,M
        LD     L,A
        EX     (SP),HL
ENDCHK: ENT
        CALL   HLFTCH
ENDCK0: ENT
        OR     A
        RET    Z
        CP     ":"
        RET
;
?DIRECT:ENT                    ;Direct mode ?
        PUSH   HL
        LD     HL,(LNOBUF)
        LD     A,L
        OR     H

        POP    HL
        RET
;
        SKP    H

;
;    TABLE
;
;
CTBL1:  ENT
        TBL    GOT,O           ; 80
        DEFM   "GOT"
        DEFB   "O"+80H
        ENDM
        TBL    GOSU,B
        DEFM   "GOSU"
        DEFB   "B"+80H
        ENDM
        DEFB   80H
        TBL    RU,N
        DEFM   "RU"
        DEFB   "N"+80H
        ENDM
        TBL    RETUR,N
        DEFM   "RETUR"

        DEFB   "N"+80H
        ENDM
        TBL    RESTOR,E
        DEFM   "RESTOR"

        DEFB   "E"+80H
        ENDM
        TBL    RESUM,E
        DEFM   "RESUM"

        DEFB   "E"+80H
        ENDM
        TBL    LIS,T
        DEFM   "LIS"
        DEFB   "T"+80H
        ENDM
        DEFB   80H             ; 88
        TBL    DELET,E
        DEFM   "DELET"

        DEFB   "E"+80H
        ENDM
        TBL    RENU,M
        DEFM   "RENU"
        DEFB   "M"+80H
        ENDM
        TBL    AUT,O
        DEFM   "AUT"
        DEFB   "O"+80H
        ENDM
        TBL    EDI,T
        DEFM   "EDI"
        DEFB   "T"+80H
        ENDM
        TBL    FO,R

        DEFM   "FO"
        DEFB   "R"+80H
        ENDM
        TBL    NEX,T
        DEFM   "NEX"
        DEFB   "T"+80H
        ENDM
        TBL    PRIN,T
        DEFM   "PRIN"
        DEFB   "T"+80H
        ENDM
;
        DEFB   80H             ; 90
        TBL    INPU,T
        DEFM   "INPU"
        DEFB   "T"+80H
        ENDM
        DEFB   80H
        TBL    I,F
        DEFM   "I"
        DEFB   "F"+80H
        ENDM
        TBL    DAT,A
        DEFM   "DAT"
        DEFB   "A"+80H
        ENDM
        TBL    REA,D
        DEFM   "REA"
        DEFB   "D"+80H
        ENDM
        TBL    DI,M
        DEFM   "DI"
        DEFB   "M"+80H
        ENDM
        TBL    RE,M
        DEFM   "RE"
        DEFB   "M"+80H
        ENDM
        TBL    EN,D            ; 98
        DEFM   "EN"
        DEFB   "D"+80H
        ENDM
        TBL    STO,P
        DEFM   "STO"
        DEFB   "P"+80H
        ENDM
        TBL    CON,T
        DEFM   "CON"
        DEFB   "T"+80H
        ENDM
        TBL    CL,S
        DEFM   "CL"
        DEFB   "S"+80H
        ENDM
        DEFB   80H
        TBL    O,N
        DEFM   "O"
        DEFB   "N"+80H
        ENDM
        TBL    LE,T

        DEFM   "LE"
        DEFB   "T"+80H
        ENDM
        TBL    NE,W
        DEFM   "NE"
        DEFB   "W"+80H
        ENDM
;
        TBL    POK,E           ; A0
        DEFM   "POK"
        DEFB   "E"+80H
        ENDM
        TBL    OF,F
        DEFM   "OF"
        DEFB   "F"+80H
        ENDM
        TBL    PMOD,E
        DEFM   "PMOD"
        DEFB   "E"+80H
        ENDM
        TBL    PSKI,P
        DEFM   "PSKI"
        DEFB   "P"+80H
        ENDM
        TBL    PLO,T
        DEFM   "PLO"
        DEFB   "T"+80H
        ENDM
        TBL    PLIN,E
        DEFM   "PLIN"
        DEFB   "E"+80H
        ENDM
        TBL    RLIN,E
        DEFM   "RLIN"
        DEFB   "E"+80H
        ENDM
        TBL    PMOV,E
        DEFM   "PMOV"
        DEFB   "E"+80H
        ENDM
        TBL    RMOV,E          ; A8
        DEFM   "RMOV"
        DEFB   "E"+80H
        ENDM
        TBL    TRO,N
        DEFM   "TRO"
        DEFB   "N"+80H
        ENDM
        TBL    TROF,F
        DEFM   "TROF"
        DEFB   "F"+80H
        ENDM
        TBL    INP,@
        DEFM   "INP"
        DEFB   "@"+80H
        ENDM
        TBL    DEFAUL,T
        DEFM   "DEFAUL"

        DEFB   "T"+80H

        ENDM
        TBL    GE,T
        DEFM   "GE"
        DEFB   "T"+80H
        ENDM
        TBL    PCOLO,R
        DEFM   "PCOLO"

        DEFB   "R"+80H
        ENDM
        TBL    PHOM,E
        DEFM   "PHOM"
        DEFB   "E"+80H
        ENDM
;
        TBL    HSE,T           ; B0
        DEFM   "HSE"
        DEFB   "T"+80H
        ENDM
        TBL    GPRIN,T
        DEFM   "GPRIN"

        DEFB   "T"+80H
        ENDM
        TBL    KE,Y
        DEFM   "KE"
        DEFB   "Y"+80H
        ENDM
        TBL    AXI,S
        DEFM   "AXI"
        DEFB   "S"+80H
        ENDM
        TBL    LOA,D
        DEFM   "LOA"
        DEFB   "D"+80H
        ENDM
        TBL    SAV,E
        DEFM   "SAV"
        DEFB   "E"+80H
        ENDM
        TBL    MERG,E
        DEFM   "MERG"
        DEFB   "E"+80H
        ENDM
        TBL    CHAI,N
        DEFM   "CHAI"
        DEFB   "N"+80H
        ENDM
        TBL    CONSOL,E        ; B8
        DEFM   "CONSOL"

        DEFB   "E"+80H
        ENDM
        TBL    SEARC,H
        DEFM   "SEARC"

        DEFB   "H"+80H
        ENDM
        TBL    OUT,@
        DEFM   "OUT"

        DEFB   "@"+80H
        ENDM
        TBL    PCIRCL,E
        DEFM   "PCIRCL"

        DEFB   "E"+80H
        ENDM
        TBL    PTES,T
        DEFM   "PTES"
        DEFB   "T"+80H
        ENDM
        TBL    PAG,E
        DEFM   "PAG"
        DEFB   "E"+80H
        ENDM
        TBL    WAI,T
        DEFM   "WAI"
        DEFB   "T"+80H
        ENDM
        TBL    SWA,P
        DEFM   "SWA"
        DEFB   "P"+80H
        ENDM
;
        DEFB   80H             ; C0
        TBL    ERRO,R
        DEFM   "ERRO"
        DEFB   "R"+80H
        ENDM
        TBL    ELS,E
        DEFM   "ELS"
        DEFB   "E"+80H
        ENDM
        TBL    US,R
        DEFM   "US"
        DEFB   "R"+80H
        ENDM
        TBL    BY,E
        DEFM   "BY"
        DEFB   "E"+80H
        ENDM
        DEFB   80H
        DEFB   80H
        TBL    DE,F
        DEFM   "DE"
        DEFB   "F"+80H
        ENDM
        DEFB   80H             ; C8
        DEFB   80H
        TBL    LABE,L
        DEFM   "LABE"
        DEFB   "L"+80H
        ENDM
        DEFB   80H
        DEFB   80H
        DEFB   80H
        TBL    WOPE,N
        DEFM   "WOPE"
        DEFB   "N"+80H
        ENDM

        TBL    CLOS,E
        DEFM   "CLOS"
        DEFB   "E"+80H
        ENDM
;
        TBL    ROPE,N          ; D0
        DEFM   "ROPE"
        DEFB   "N"+80H
        ENDM
        TBL    XOPE,N
        DEFM   "XOPE"
        DEFB   "N"+80H
        ENDM
        DEFB   80H
        DEFB   80H
        DEFB   80H
        TBL    DI,R
        DEFM   "DI"
        DEFB   "R"+80H
        ENDM
        DEFB   80H
        DEFB   80H
        TBL    RENAM,E         ; D8
        DEFM   "RENAM"

        DEFB   "E"+80H
        ENDM
        TBL    KIL,L
        DEFM   "KIL"
        DEFB   "L"+80H
        ENDM
        TBL    LOC,K
        DEFM   "LOC"
        DEFB   "K"+80H
        ENDM
        TBL    UNLOC,K
        DEFM   "UNLOC"

        DEFB   "K"+80H
        ENDM
        TBL    INI,T
        DEFM   "INI"
        DEFB   "T"+80H
        ENDM
        DEFB   80H
        DEFB   80H
        DEFB   80H
;
        TBL    T,O             ; E0
        DEFM   "T"
        DEFB   "O"+80H
        ENDM
        TBL    STE,P
        DEFM   "STE"
        DEFB   "P"+80H
        ENDM
        TBL    THE,N
        DEFM   "THE"
        DEFB   "N"+80H
        ENDM

        TBL    USIN,G
        DEFM   "USIN"
        DEFB   "G"+80H
        ENDM
        DEFB   80H             ;PI
        TBL    AL,L
        DEFM   "AL"
        DEFB   "L"+80H
        ENDM
        TBL    TA,B
        DEFM   "TA"
        DEFB   "B"+80H
        ENDM
        TBL    SP,C
        DEFM   "SP"
        DEFB   "C"+80H
        ENDM
        DEFB   80H             ; E8
        DEFB   80H
        TBL    .XO,R
        DEFM   ".XO"
        DEFB   "R"+80H
        ENDM
        TBL    .O,R
        DEFM   ".O"
        DEFB   "R"+80H
        ENDM
        TBL    .AN,D
        DEFM   ".AN"
        DEFB   "D"+80H
        ENDM
        TBL    .NO,T
        DEFM   ".NO"
        DEFB   "T"+80H
        ENDM
        TBL    >,<
        DEFM   ">"
        DEFB   "<"+80H
        ENDM
        TBL    <,>
        DEFM   "<"
        DEFB   ">"+80H
        ENDM
;
        TBL    =,<             ; F0
        DEFM   "="
        DEFB   "<"+80H
        ENDM
        TBL    <,=
        DEFM   "<"
        DEFB   "="+80H
        ENDM
        TBL    =,>
        DEFM   "="
        DEFB   ">"+80H
        ENDM
        TBL    >,=
        DEFM   ">"
        DEFB   "="+80H
        ENDM

        DEFB   "="+80H
        DEFB   ">"+80H
        DEFB   "<"+80H
        DEFB   "+"+80H
        DEFB   "-"+80H         ; F8
        DEFB   %YEN+80H
        TBL    .MO,D
        DEFM   ".MO"
        DEFB   "D"+80H
        ENDM
        DEFB   "/"+80H
        DEFB   "*"+80H
        DEFB   "^"+80H
;
        DEFB   FFH
;
GTABL:  ENT
        DEFB   80H             ; FE 80
        TBL    CSE,T
        DEFM   "CSE"
        DEFB   "T"+80H
        ENDM
        TBL    CRESE,T
        DEFM   "CRESE"

        DEFB   "T"+80H
        ENDM
        TBL    CCOLO,R
        DEFM   "CCOLO"

        DEFB   "R"+80H
        ENDM
        DEFB   80H
        DEFB   80H
        DEFB   80H
        DEFB   80H
        DEFB   80H             ; FE 88
        DEFB   80H
        TBL    SOUN,D
        DEFM   "SOUN"
        DEFB   "D"+80H
        ENDM
        DEFB   80H
        TBL    NOIS,E
        DEFM   "NOIS"
        DEFB   "E"+80H
        ENDM
        TBL    BEE,P
        DEFM   "BEE"
        DEFB   "P"+80H
        ENDM
        DEFB   80H             ; MZ-1500 VOICE
        DEFB   80H
;
        TBL    COLO,R          ; FE 90
        DEFM   "COLO"
        DEFB   "R"+80H
        ENDM
        DEFB   80H             ; MZ-1500 PRTY
        TBL    SE,T

        DEFM   "SE"
        DEFB   "T"+80H
        ENDM
        TBL    RESE,T
        DEFM   "RESE"
        DEFB   "T"+80H
        ENDM
        TBL    LIN,E
        DEFM   "LIN"
        DEFB   "E"+80H
        ENDM
        TBL    BLIN,E
        DEFM   "BLIN"
        DEFB   "E"+80H
        ENDM
        TBL    PA,L
        DEFM   "PA"
        DEFB   "L"+80H
        ENDM
        TBL    CIRCL,E
        DEFM   "CIRCL"

        DEFB   "E"+80H
        ENDM
        TBL    BO,X            ; FE 98
        DEFM   "BO"
        DEFB   "X"+80H
        ENDM
        TBL    PAIN,T
        DEFM   "PAIN"
        DEFB   "T"+80H
        ENDM
        TBL    POSITIO,N
        DEFM   "POSITIO"

        DEFB   "N"+80H
        ENDM
        TBL    PATTER,N
        DEFM   "PATTER"

        DEFB   "N"+80H
        ENDM
        TBL    HCOP,Y
        DEFM   "HCOP"
        DEFB   "Y"+80H
        ENDM
        DEFB   80H             ; MZ-1500 KPATTERN
        DEFB   80H             ; MZ-1500 FPRINT
        DEFB   80H
;
        TBL    SYMBO,L         ; FE A0
        DEFM   "SYMBO"

        DEFB   "L"+80H
        ENDM
        DEFB   80H
        TBL    MUSI,C
        DEFM   "MUSI"
        DEFB   "C"+80H
        ENDM

        TBL    TEMP,O
        DEFM   "TEMP"
        DEFB   "O"+80H
        ENDM
        TBL    CURSO,R
        DEFM   "CURSO"

        DEFB   "R"+80H
        ENDM
        TBL    VERIF,Y
        DEFM   "VERIF"

        DEFB   "Y"+80H
        ENDM
        TBL    CL,R
        DEFM   "CL"
        DEFB   "R"+80H
        ENDM
        TBL    LIMI,T
        DEFM   "LIMI"
        DEFB   "T"+80H
        ENDM
        DEFB   80H             ; FE A8
        DEFB   80H
        DEFB   80H
        DEFB   80H
        DEFB   80H
        DEFB   80H
        TBL    BOO,T
        DEFM   "BOO"
        DEFB   "T"+80H
        ENDM
;
;
        DEFB   FFH
;
;
;
CTBL2:  ENT
        TBL    IN,T            ; FF 80
        DEFM   "IN"
        DEFB   "T"+80H
        ENDM
        TBL    AB,S
        DEFM   "AB"
        DEFB   "S"+80H
        ENDM
        TBL    SI,N
        DEFM   "SI"
        DEFB   "N"+80H
        ENDM
        TBL    CO,S
        DEFM   "CO"
        DEFB   "S"+80H
        ENDM
        TBL    TA,N
        DEFM   "TA"
        DEFB   "N"+80H
        ENDM
        TBL    L,N

        DEFM   "L"
        DEFB   "N"+80H
        ENDM
        TBL    EX,P
        DEFM   "EX"
        DEFB   "P"+80H
        ENDM
        TBL    SQ,R
        DEFM   "SQ"
        DEFB   "R"+80H
        ENDM
        TBL    RN,D            ; FF 88
        DEFM   "RN"
        DEFB   "D"+80H
        ENDM
        TBL    PEE,K
        DEFM   "PEE"
        DEFB   "K"+80H
        ENDM
        TBL    AT,N
        DEFM   "AT"
        DEFB   "N"+80H
        ENDM
        TBL    SG,N
        DEFM   "SG"
        DEFB   "N"+80H
        ENDM
        TBL    LO,G
        DEFM   "LO"
        DEFB   "G"+80H
        ENDM
        TBL    FRA,C
        DEFM   "FRA"
        DEFB   "C"+80H
        ENDM
        TBL    PA,I
        DEFM   "PA"
        DEFB   "I"+80H
        ENDM
        TBL    RA,D
        DEFM   "RA"
        DEFB   "D"+80H
        ENDM
;
        DEFB   80H             ; FF 90
        DEFB   80H
        DEFB   80H
        DEFB   80H
        DEFB   80H
        DEFB   80H
        DEFB   80H
        DEFB   80H
        DEFB   80H             ; FF 98
        DEFB   80H
        DEFB   80H
        DEFB   80H
        TBL    STIC,K
        DEFM   "STIC"
        DEFB   "K"+80H
        ENDM

        TBL    STRI,G
        DEFM   "STRI"
        DEFB   "G"+80H
        ENDM
        DEFB   80H             ; MZ-1500 JOY
        DEFB   80H
;
        TBL    CHR,$           ; FF A0
        DEFM   "CHR"
        DEFB   "$"+80H
        ENDM
        TBL    STR,$
        DEFM   "STR"
        DEFB   "$"+80H
        ENDM
        TBL    HEX,$
        DEFM   "HEX"
        DEFB   "$"+80H
        ENDM
        DEFB   80H
        DEFB   80H
        DEFB   80H
        DEFB   80H
        DEFB   80H
        TBL    SPACE,$         ; FF A8
        DEFM   "SPACE"

        DEFB   "$"+80H
        ENDM
        DEFB   80H
        DEFB   80H             ; MZ-1500 ASCCHR$
        TBL    AS,C
        DEFM   "AS"
        DEFB   "C"+80H
        ENDM
        TBL    LE,N
        DEFM   "LE"
        DEFB   "N"+80H
        ENDM
        TBL    VA,L
        DEFM   "VA"
        DEFB   "L"+80H
        ENDM
        DEFB   80H
        DEFB   80H
;
        DEFB   80H             ; FF B0
        DEFB   80H
        DEFB   80H             ; MZ-1500 HEXCHR$
        TBL    ER,N
        DEFM   "ER"
        DEFB   "N"+80H
        ENDM
        TBL    ER,L
        DEFM   "ER"
        DEFB   "L"+80H
        ENDM
        TBL    SIZ,E
        DEFM   "SIZ"
        DEFB   "E"+80H

        ENDM
        TBL    CSR,H
        DEFM   "CSR"
        DEFB   "H"+80H
        ENDM
        TBL    CSR,V
        DEFM   "CSR"
        DEFB   "V"+80H
        ENDM
        TBL    POS,H           ; FF B8
        DEFM   "POS"
        DEFB   "H"+80H
        ENDM
        TBL    POS,V
        DEFM   "POS"
        DEFB   "V"+80H
        ENDM
        TBL    LEFT,$
        DEFM   "LEFT"
        DEFB   "$"+80H
        ENDM
        TBL    RIGHT,$
        DEFM   "RIGHT"

        DEFB   "$"+80H
        ENDM
        TBL    MID,$
        DEFM   "MID"
        DEFB   "$"+80H
        ENDM
        DEFB   80H             ; MZ-1500 FONT$
        DEFB   80H
        DEFB   80H
;
        DEFB   80H             ; FF C0
        DEFB   80H
        DEFB   80H
        DEFB   80H
        TBL    TI,$
        DEFM   "TI"
        DEFB   "$"+80H
        ENDM
        TBL    POIN,T
        DEFM   "POIN"
        DEFB   "T"+80H
        ENDM
        TBL    EO,F
        DEFM   "EO"
        DEFB   "F"+80H
        ENDM
        TBL    F,N
        DEFM   "F"
        DEFB   "N"+80H
        ENDM
;
        DEFB   FFH
;
; JPTABLE
;
SJPTBL: ENT

        DEFW   GOTO            ; 80
        DEFW   GOSUB
        DEFW   ER01
        DEFW   RUN
        DEFW   RETURN
        DEFW   RESTOR
        DEFW   RESUME
        DEFW   LIST
        DEFW   ER01            ; 88
        DEFW   DELETE
        DEFW   RENUM
        DEFW   AUTO
        DEFW   EDIT
        DEFW   FOR
        DEFW   NEXT
        DEFW   PRINT
;
        DEFW   ER01            ; 90
        DEFW   INPUT
        DEFW   ER01
        DEFW   IF
        DEFW   DATA
        DEFW   READ
        DEFW   DIM
        DEFW   REM
        DEFW   END             ; 98
        DEFW   STOP
        DEFW   CONT
        DEFW   CLS
        DEFW   ER01
        DEFW   ON
        DEFW   LET
        DEFW   NEW
;
        DEFW   POKE            ; A0
        DEFW   ER01
        DEFW   MODE
        DEFW   SKIP
        DEFW   PLOT
        DEFW   PLINE
        DEFW   RLINE
        DEFW   PMOVE
        DEFW   RMOVE           ; A8
        DEFW   TRON
        DEFW   TROFF
        DEFW   INP@
        DEFW   DEFAULT
        DEFW   GETOP
        DEFW   PCOLOR
        DEFW   PHOME
;
        DEFW   HSET            ; B0
        DEFW   GPRINT
        DEFW   KLIST
        DEFW   AXIS
        DEFW   LOAD
        DEFW   SAVE
        DEFW   MERGE
        DEFW   CHAIN
        DEFW   CONSOL          ; B8

        DEFW   SEARCH
        DEFW   OUT@
        DEFW   PCIRCLE
        DEFW   TEST
        DEFW   PAGE
        DEFW   PAUSE
        DEFW   SWAP
;
        DEFW   ER01            ; C0
        DEFW   ERROR
        DEFW   ELSE
        DEFW   USR
        DEFW   BYE
        DEFW   ER01
        DEFW   ER01
        DEFW   DEFOP
        DEFW   ER01            ; C8
        DEFW   ER01
        DEFW   LABEL
        DEFW   ER01
        DEFW   ER01
        DEFW   ER01
        DEFW   WOPEN
        DEFW   CLOSE
;
        DEFW   ROPEN           ; D0
        DEFW   XOPEN
        DEFW   ER01
        DEFW   ER01
        DEFW   ER01
        DEFW   DIR
        DEFW   ER01
        DEFW   ER01
        DEFW   RENAME          ; D8
        DEFW   KILL
        DEFW   LOCK
        DEFW   UNLOCK
        DEFW   INIT
        DEFW   ER01
        DEFW   ER01
        DEFW   ER01
;
;
GJPTBL: ENT
        DEFW   ER01            ; FE 80
        DEFW   ER01
        DEFW   ER01
        DEFW   ER01
        DEFW   ER01
        DEFW   ER01
        DEFW   ER01
        DEFW   ER01
        DEFW   ER01            ; FE 88
        DEFW   ER01
        DEFW   SOUND
        DEFW   ER01
        DEFW   NOISE
        DEFW   BEEP
; MZ-1500 .VOICE:ENT
        DEFW   ER01

        DEFW   ER01
;
        DEFW   COLOR           ; FE 90
        DEFW   ER01
        DEFW   SET
        DEFW   RESET
        DEFW   LINE
        DEFW   BLINE
        DEFW   PALET
        DEFW   CIRCLE
        DEFW   BOX             ; FE 98
        DEFW   PAINT
        DEFW   POSITION
        DEFW   PATTERN
        DEFW   HCOPY
        DEFW   ER01
        DEFW   ER01
        DEFW   ER01
;
        DEFW   SMBOL           ; FE A0
        DEFW   ER01
        DEFW   MUSIC
        DEFW   TEMPO
        DEFW   CURSOR
        DEFW   VERIFY
        DEFW   CLR
        DEFW   LIMIT
        DEFW   ER01            ; FE A8
        DEFW   ER01
        DEFW   ER01
        DEFW   ER01
        DEFW   ER01
        DEFW   ER01
        DEFW   BOOT
;
;
FJPTBL: ENT
        DEFW   INTOPR          ; FF 80
        DEFW   ABS
        DEFW   SIN
        DEFW   COS
        DEFW   TAN
        DEFW   LOG             ;LN
        DEFW   EXP
        DEFW   SQR
        DEFW   RND             ; FF 88
        DEFW   PEEK
        DEFW   ATN
        DEFW   SGN
        DEFW   LOGD            ;LOG
        DEFW   FRACT
        DEFW   PAI
        DEFW   RAD
;
        DEFW   ER01            ; FF 90
        DEFW   ER01
        DEFW   ER01
        DEFW   ER01
        DEFW   ER01
        DEFW   ER01

        DEFW   ER01
        DEFW   ER01
        DEFW   ER01            ; FF 98
        DEFW   ER01
        DEFW   ER01
        DEFW   ER01
        DEFW   STCK
        DEFW   STIG
        DEFW   ER01
        DEFW   ER01
;
        DEFW   ER01            ; FF A0 CHR$
        DEFW   STR$
        DEFW   HEX$
        DEFW   ER01
        DEFW   ER01
        DEFW   ER01
        DEFW   ER01
        DEFW   ER01
        DEFW   SPACE$          ; FF A8
        DEFW   ER01
        DEFW   ER01
        DEFW   ASC
        DEFW   LEN
        DEFW   VAL
        DEFW   ER01
        DEFW   ER01
;
        DEFW   ER01            ; FF B0
        DEFW   ER01
        DEFW   ER01
        DEFW   ERR
        DEFW   ERL
        DEFW   SIZE
        DEFW   CSRH
        DEFW   CSRV
        DEFW   POSH            ; FF B8
        DEFW   POSV
        DEFW   LEFT$
        DEFW   RIGHT$
        DEFW   MID$
        DEFW   ER01
        DEFW   ER01
        DEFW   ER01
;
        DEFW   ER01            ; FF C0
        DEFW   ER01
        DEFW   ER01
        DEFW   ER01
        DEFW   TI$
        DEFW   POINT
        DEFW   EOF
        DEFW   FNEXP           ;FN
        DEFW   ER01            ; FF C8
        DEFW   ER01
        DEFW   ER01
        DEFW   ER01
        DEFW   ER01
        DEFW   ER01
        DEFW   ER01

        DEFW   ER01
        SKP    H

;
; GET LINE ADRS
;
GETLIN: ENT
        TEST1  0CH
        CALL   TEST1
        DEFB   0CH
        ENDM
        JR     NZ,GLIN2
        CALL   LDDEMI
        OR     FFH
        RET
GLIN2:  INC    HL
        CP     0BH
        JR     NZ,GLIN4
        LD     E,M
        INC    HL
        LD     D,M
        INC    HL
        LD     A,E
        OR     D
        RET    Z
        EX     DE,HL
        CALL   LNOSER
        JP     C,ER16
        EX     DE,HL
        DEC    HL
        LD     M,D
        DEC    HL
        LD     M,E
        DEC    HL
        LD     M,0CH
        INC    HL
        INC    HL
        INC    HL
        OR     FFH
        LD     (REFFLG),A
        RET
GLIN4:  CP     '"'
        JP     NZ,ER01
        LD     (LABA+1),HL
        LD     B,0
GLIN6:  LD     A,M
        OR     A
        JR     Z,GLIN8
        INC    HL
        CP     '"'
        JR     Z,GLIN8
        INC    B
        JR     GLIN6
GLIN8:  LD     A,B
        OR     A
        JP     Z,ER01
        LD     (LABN+1),A
        EX     DE,HL
        CALL   LABSER
        JP     C,ER16
        EX     DE,HL
        OR     FFH
        RET

        SKP    H

;
; LABSER .. Label search
; LNOSER .. Line# search
;
LABSER: PUSH   BC
        LD     BC,LABSUB
        JR     LNOSR0
LNOSER: PUSH   BC
        LD     BC,LNOSUB
LNOSR0: LD     (LNOSR?+1),BC
        PUSH   DE
        EX     DE,HL
        LD     HL,(TEXTST)
LNOSR2: LD     C,M
        INC    HL
        LD     B,M
        LD     A,B
        OR     C
        SCF
        JR     Z,LNOSR9
        DEC    HL
        PUSH   HL
        ADD    HL,BC
        EX     (SP),HL
LNOSR?: CALL   0
        JR     C,LNOSR8
        JR     Z,LNOSR8
        POP    HL
        JR     LNOSR2
LNOSR8: POP    DE              ;DMY
LNOSR9: POP    DE
        POP    BC
        RET
;
LNOSUB: INC    HL
        INC    HL
        INC    HL
        LD     A,D
        CP     M
        RET    NZ
        DEC    HL
        LD     A,E
        CP     M
        DEC    HL
        DEC    HL
        RET
;
LABSUB: PUSH   HL
        INC    HL
        INC    HL
        INC    HL
        INC    HL
        TEST1  CAH             ;LABEL
        CALL   TEST1
        DEFB   CAH
        ENDM
        JR     NZ,LABSR9
        TEST1  '"'
        CALL   TEST1
        DEFB   '"'

        ENDM
        JR     NZ,LABSR9
LABN:   LD     B,0             ;Label length
LABA:   LD     DE,0            ;Label adrs
LABSR2: LD     A,(DE)
        CP     M
        JR     NZ,LABSR9
        INC    HL
        INC    DE
       DJNZ   LABSR2
        LD     A,M
        CP     '"'
        JR     Z,LABSR9
        OR     A
LABSR9: SCF
        CCF
        POP    HL
        RET
;
; START.LINE - END.LINE
;
GTSTED: ENT
        LD     DE,0000H
        LD     BC,FFFFH
        CALL   END2C
        RET    Z
        CP     "-"
        JR     Z,GTNXNM
        CP     "."
        LD     DE,(EDLINE)
        JR     Z,NX2C2D
        TESTX  0BH
        CALL   TESTX
        DEFB   0BH
        ENDM
        LD     E,M
        INC    HL
        LD     D,M
NX2C2D: INC    HL
        CALL   END2C
        JR     Z,ONELLN
        CP     "-"
        JR     Z,GTNXNM
ONELLN: LD     C,E
        LD     B,D
        RET
;
GTNXNM: INC    HL
        CALL   END2C
        RET    Z
        CP     "."
        JR     NZ,GTEDNO
        LD     BC,(EDLINE)
        INC    HL
        RET
;
GTEDNO: TESTX  0BH
        CALL   TESTX
        DEFB   0BH
        ENDM

        LD     C,M
        INC    HL
        LD     B,M
        INC    HL
        RET
;
END2C:  ENT
        CALL   ENDCHK
        RET    Z
        CP     ","
        RET
        SKP    H

;
;  REFADR ... Line ref = Adrs
;  REFLNO ... Line ref = Number
;
REFADR: CALL   PUSHR
        LD     A,FFH
        LD     (REFFLG),A
        LD     HL,CVASUB
        JR     REFL2
;
REFLNO: ENT
        CALL   PUSHR
        CALL   CLRFLG
REFLNX: ENT
        LD     A,(REFFLG)
        OR     A
        RET    Z
        XOR    A
        LD     (REFFLG),A
        LD     HL,CVLSUB
REFL2:  LD     (CVRTLN+1),HL
        LD     HL,(TEXTST)
        DEC    HL
REFL4:  INC    HL
        LD     A,M
        INC    HL
        OR     M
        RET    Z
        INC    HL
        LD     E,M
        INC    HL
        LD     D,M
        LD     (CVALN+1),DE
REFL6:  CALL   IFSKSB
        OR     A
        JR     Z,REFL4
CVRTLN: JP     0
;
CVLSUB: CP     0CH
        JR     NZ,REFL6
        DEC    HL
        LD     E,M
        INC    HL
        LD     D,M
        PUSH   HL
        EX     DE,HL
        INC    HL
        INC    HL
        LD     E,M
        INC    HL
        LD     D,M
        POP    HL
        LD     M,D
        DEC    HL
        LD     M,E
        DEC    HL
        LD     M,0BH
        INC    HL
        INC    HL
        JR     REFL6

;
CVASUB: CP     0BH
        JR     NZ,REFL6
        DEC    HL
        PUSH   HL
        CALL   INDRCT
        LD     E,L
        LD     D,H
        LD     A,L
        OR     H
        JR     Z,CVAS9
        CALL   LNOSER
        JR     C,CVASE
        EX     DE,HL
        POP    HL
        DEC    HL
        LD     M,0CH
        INC    HL
        LD     M,E
        INC    HL
        LD     M,D
        JR     REFL6
;
CVASE:  PUSH   DE
        LD     A,16            ;UNDEF LINE
        SVC    .ERRX
        RST    3
        DEFB   .ERRX
        ENDM
        LD     A," "
        SVC    .CRT1C
        RST    3
        DEFB   .CRT1C
        ENDM
        POP    HL
        CALL   ASCFIV
        SVC    .CRTMS
        RST    3
        DEFB   .CRTMS
        ENDM
CVALN:  LD     HL,0            ;xxx
        CALL   P.ERL
        SVC    .CR2
        RST    3
        DEFB   .CR2
        ENDM
CVAS9:  POP    HL
        INC    HL
        JR     REFL6
;
REFFLG: DEFB   0
        SKP    H

EDITOR: SVC    .CLRIO
        RST    3
        DEFB   .CLRIO
        ENDM
        CALL   REFLNO
        CALL   CVBCAS
        LD     A,B
        OR     C
        JP     Z,INPAGN
        LD     (EDLINE),BC
        LD     A,(DE)
        CP     20H
        JR     NZ,+3
        INC    DE
        PUSH   AF
        LD     HL,IMDBUF
        CALL   CVIMTX
        PUSH   HL
        LD     HL,(EDLINE)
        LD     E,L
        LD     D,H
        CALL   DELSUB
        POP    HL              ; END POINT
        POP    AF
        OR     A
        JR     Z,EDIT9
        LD     DE,IMDBUF
        OR     A
        SBC    HL,DE
        LD     DE,5
        ADD    HL,DE
        LD     BC,HL
        LD     HL,IMDBUF
        CALL   INSTLIN
EDIT9:  LD     A,(AUTOFG)
        OR     A
        JP     Z,INPAGN
        LD     DE,(EDSTEP)
        LD     HL,(EDLINE)
        ADD    HL,DE
        LD     (EDLINE),HL
        JP     NC,INPAGN
        JP     AUTOFF
;
; INSTLIN  HL .. IMD ADRS
;          BC .. IMD LENGTH
;
INSTLIN:ENT
        LD     (INS.P+1),HL
        PUSH   BC
        LD     BC,(EDLINE)
        LD     HL,(TEXTST)
        JR     INSL4
INSL2:  CALL   LDDEMD
        ADD    HL,DE
INSL4:  CALL   LDDEMD
        LD     A,D
        OR     E
        JR     Z,INSL6
        INC    HL

        INC    HL
        CALL   LDDEMD
        EX     DE,HL
        SBC    HL,BC
        DEC    DE
        DEC    DE
        EX     DE,HL
        JR     C,INSL2
INSL6:  POP    DE              ;DE:=open bytes
        PUSH   HL              ;Push inst-point
        PUSH   DE
        LD     HL,40           ;memory check ofset
        ADD    HL,DE
        LD     BC,(VARED)
        LD     (TMPEND),BC
        ADD    HL,BC
        JP     C,ER06'
        EX     DE,HL
        CALL   MEMECK
        POP    DE              ;DE=open bytes
        SVC    .ADDP0
        RST    3
        DEFB   .ADDP0
        ENDM
        POP    HL              ;HL=inst point
        PUSH   DE              ;DE=open bytes
        PUSH   BC
        EX     (SP),HL         ;HL=old VARED
        POP    BC              ;BC=inst point
        PUSH   HL
        OR     A
        SBC    HL,BC
        LD     BC,HL           ;BC=xfer bytes
        POP    HL              ;HL=old VARED
        LD     DE,(VARED)      ;DE=new VARED
        INC    BC
        LDDR
        INC    HL              ;HL=inst point
        POP    BC              ;BC=open bytes
        LD     M,C
        INC    HL
        LD     M,B
        INC    HL
        LD     DE,(EDLINE)
        LD     M,E
        INC    HL
        LD     M,D
        INC    HL
        EX     DE,HL
INS.P:  LD     HL,IMDBUF       ;xxx
        DEC    BC
        DEC    BC
        DEC    BC
        DEC    BC
        LDIR
        RET
        SKP    H

;
RUN:    JR     Z,RUN0          ;RUN
        CALL   LINE?2
        JP     Z,GOTO          ;RUN linenumber
        JP     FRUN            ;RUN "filename"
RUN0:   CALL   CLR
RUNX:   ENT
        CALL   RUNINT
        LD     DE,(TEXTST)
        LD     SP,(INTFAC)
        LD     HL,FFFFH
        PUSH   HL
        PUSH   HL
        EX     DE,HL
        JP     NXLINE
;
RUNINT: ENT
        PUSH   HL
        CALL   CLRFLG
        LD     (AUTOFG),A
        LD     HL,10
        LD     (EDLINE),HL
        LD     (EDSTEP),HL
        POP    HL
        RET
;
CLRFLG: ENT
        LD     HL,0
        LD     (ERRLNO),HL
        XOR    A
        LD     (DATFLG),A
        LD     (CONTFG),A
        LD     (ERRORF),A
        LD     (ERRCOD),A
        LD     (LSWAP),A
        RET
;
;
;
END:    LD     A,(LSWAP)
        OR     A
        JP     NZ,BSWAP
        SVC    .CLRIO          ;END command
        RST    3
        DEFB   .CLRIO
        ENDM
        XOR    A
        LD     (CONTFG),A
        POP    BC
        JP     OK
       SKP    H

;
AUTO:   CALL   CKCOM
        LD     DE,10           ;AUTO start,step
        LD     BC,10
        JR     Z,AUTO6
        CP     ","
        JR     NZ,AUTO2
        INC    HL
        CALL   IDEEXP
        LD     B,D
        LD     C,E
        LD     DE,10
        JR     AUTO6
;
AUTO2:  CP     "."
        LD     DE,(EDLINE)
        JR     Z,AUTO4
        CP     0BH
        JP     NZ,ER01
        INC    HL
        LD     E,M
        INC    HL
        LD     D,M
;
AUTO4:  INC    HL
        TEST1  ","
        CALL   TEST1
        DEFB   ","
        ENDM
        JR     NZ,AUTO6
        PUSH   DE
        CALL   IDEEXP
        LD     C,E
        LD     B,D
        POP    DE
AUTO6:  CALL   ENDZ
        LD     A,C
        OR     B
        JP     Z,ER03
;
        LD     (EDLINE),DE
        LD     (EDSTEP),BC
        LD     A,1
        LD     (AUTOFG),A
        POP    AF
        JP     INPAGN
;
AUTOFG: DEFS   1
        SKP    H

;
AUTODS: LD     A,(AUTOFG)      ;Disp auto line
        OR     A
        RET    Z
        XOR    A
        JR     EDITL
;
EDIT:   CALL   EDITL           ;EDIT linenumber
        JP     INPAGN
;
EDITL:  LD     DE,(EDLINE)
        CALL   NZ,GTSTED
        PUSH   DE
        EX     DE,HL
        CALL   LNOSER
        POP    DE
        INC    HL
        INC    HL
        INC    HL
        INC    HL
        JR     NC,+5
        LD     HL,.NOP
        EX     DE,HL
        PUSH   DE
        LD     (EDLINE),HL
        CALL   ASCFIV
        SVC    .CRTMS
        RST    3
        DEFB   .CRTMS
        ENDM
        LD     A," "
        SVC    .CRT1C
        RST    3
        DEFB   .CRT1C
        ENDM
        POP    HL
        LD     DE,KEYBUF
        PUSH   DE
        CALL   CVTXIM
        POP    DE
        LD     B,0
EDL2:   LD     A,(DE)
        OR     A
        JR     Z,EDL6
        INC    B
        SVC    .CRT1X
        RST    3
        DEFB   .CRT1X
        ENDM
        INC    DE
        JR     EDL2
EDL6:   LD     A,B
        OR     A
        RET    Z
        LD     A,14H           ; CURSOR BACK
        SVC    .CRT1C
        RST    3
        DEFB   .CRT1C
        ENDM
        DJNZ   -3

        RET
        SKP    H

;
MEMSET: ENT
        PUSH   DE
        LD     DE,-16
        ADD    HL,DE
        POP    DE
        LD     (MEMLMT),HL
        DEC    H
        LD     (INTFAC),HL
        XOR    A
        LD     (LSWAP),A
        RET
;
NEWTXT: ENT
        LD     HL,(TEXTST)
        CALL   LDHL00
        LD     (POOL),HL
        CALL   RUNINT
        JR     CLR
;
NEW:    TEST1  9DH             ;NEW command
        CALL   TEST1
        DEFB   9DH
        ENDM
        CALL   Z,NEWON
        CALL   NEWTXT
        JP     HOTENT
;
;
CLR:    ENT                    ;CLR command
        PUSH   HL
        CALL   CLPTR2
        POP    HL
        SVC    .CLRIO
        RST    3
        DEFB   .CLRIO
        ENDM
        RET
        SKP    H

;
CLPTR:  ENT
        LD     HL,(TEXTST)
        CALL   LDHL00
        LD     (POOL),HL
CLPTR2: LD     HL,(POOL)
        LD     M,0
        INC    HL
        LD     (VARST),HL
        LD     M,0
        INC    HL
        LD     (STRST),HL
        CALL   LDHL00
        LD     (VARED),HL
        LD     (TMPEND),HL
        RET
;
LDHL00: ENT
        LD     M,0
        INC    HL
        LD     M,0
        INC    HL
        RET
;
;
TRON:   CALL   ENDCHK
        LD     A,1
        JR     Z,TROFF+1
        TESTX  FBH             ;/
        CALL   TESTX
        DEFB   FBH
        ENDM
        TESTX  "P"
        CALL   TESTX
        DEFB   "P"
        ENDM
        LD     A,2
        JR     +3
TROFF:  XOR    A               ;TROFF
        LD     (TRDISP+1),A
        RET
;
TRDISP: LD     A,0             ;0,1,2
        OR     A
        RET    Z
        DEC    A
        LD     (FILOUT),A
        JR     Z,TRDSP2
        LD     A,(PNMODE)
        CP     2
        JR     Z,TRDSP9        ;MODE GR
TRDSP2: PUSH   HL
        LD     A,"["
        SVC    .&1C
        RST    3
        DEFB   .&1C
        ENDM
        LD     HL,(LNOBUF)
        CALL   ASCFIV
        SVC    .&MSG

        RST    3
        DEFB   .&MSG
        ENDM
        LD     A,"]"
        SVC    .&1C
        RST    3
        DEFB   .&1C
        ENDM
        POP    HL
TRDSP9: XOR    A
        LD     (FILOUT),A
        RET
        SKP    H

;
DELETE: CALL   END2C
        JP     Z,ER01          ;DELETE
        CALL   LINE?2
        JR     Z,DELLIN
        CP     "-"
        JR     Z,DELLIN
        CP     "."
        JP     NZ,FDEL         ;DELETE "filename"
DELLIN: ENT
        CALL   GTSTED          ;DELETE xxx-yyy
        EX     DE,HL
        LD     E,C
        LD     D,B
        CALL   DELSUB
        JP     OK
;
; Delete (HL)-(DE)
;
DELSUB: ENT
        PUSH   AF
        PUSH   BC
        PUSH   HL
        PUSH   DE
        CALL   REFLNO
        LD     C,L
        LD     B,H
        LD     HL,(TEXTST)
FSTLOP: CALL   LDDEMI
        LD     A,E
        OR     D
        JR     NZ,FDDLST
RTDLTE: POP    DE
        POP    HL
        POP    BC
        POP    AF
        RET
;
POPDLR: POP    DE
        JR     RTDLTE
;
FDDLST: EX     DE,HL
        ADD    HL,DE
        DEC    HL
        DEC    HL
        EX     DE,HL
        PUSH   DE
        LD     E,M
        INC    HL
        LD     D,M
        EX     DE,HL
        LD     (LNOTBF),HL
        SBC    HL,BC
        POP    HL
        JR     C,FSTLOP
        DEC    DE
        DEC    DE
        DEC    DE
        POP    BC              ; DELSUB END LINE NO.
        PUSH   BC

        PUSH   DE              ; DELSUB START ADRS
        PUSH   HL              ; NEXT LINE ADRS
        DEFB   21H
LNOTBF: DEFS   2
        SBC    HL,BC
        POP    HL
        JR     Z,DLSTRT        ; DEL-LINE END FOUND
        JR     NC,POPDLR       ; NOTHING OCCUR
SNDDLP: CALL   LDDEMI
        LD     A,D
        OR     E
        JR     Z,DLEFD'
        EX     DE,HL
        ADD    HL,DE
        EX     DE,HL
        DEC    DE
        DEC    DE
        PUSH   DE
        LD     E,M
        INC    HL
        LD     D,M
        EX     DE,HL
        SBC    HL,BC
        POP    HL
        JR     C,SNDDLP
        JR     Z,DLSTRT
        EX     DE,HL
        DEC    HL
DLEFD': DEC    HL
        DEC    HL
DLSTRT: POP    DE
        PUSH   DE              ;Delete (DE)-(HL)
        PUSH   HL
        OR     A
        EX     DE,HL
        SBC    HL,DE
        EX     DE,HL           ;DE = - bytes
        LD     BC,(VARED)      ;old VARED
        SVC    .ADDP0
        RST    3
        DEFB   .ADDP0
        ENDM
        POP    DE              ;DE = del end
        LD     HL,BC           ;HL = old VARED
        OR     A
        SBC    HL,DE
        LD     BC,HL           ;BC = move bytes
        EX     DE,HL           ;HL = del end
        POP    DE              ;DE = del start
        LDIR
        JR     RTDLTE
;
IDEEX0: CALL   IDEEXP
        LD     A,D
        OR     E
        RET    NZ
       JP     ER03
        SKP    H

;
RENUM:  CALL   CKCOM
        LD     DE,10           ;RENUM xxx,yyy,zzz
        LD     (NEWNO),DE
        LD     (ADDNO),DE
        LD     E,0
        LD     (STLNO),DE
        JR     Z,RNSTRT
        CP     ","
        JR     Z,SKIRE1
        CALL   IDEEX0
        LD     (NEWNO),DE
        CALL   ENDCHK
        JR     Z,RNSTRT
        CALL   HCH2CH
        DEC    HL
SKIRE1: CALL   INCHLF
        CP     ","
        JR     Z,SKMRNU
        CALL   IDEEX0
        LD     (STLNO),DE
        CALL   ENDCHK
        JR     Z,RNSTRT
        CALL   HCH2CH
        DEC    HL
SKMRNU: INC    HL
        CALL   IDEEX0
        LD     (ADDNO),DE
RNSTRT: PUSH   HL
        LD     HL,(STLNO)
        EX     DE,HL
        LD     HL,(NEWNO)
        OR     A
        SBC    HL,DE
        JP     C,ER03
        CALL   REFADR
        LD     HL,(TEXTST)
BEGRNS: LD     E,M
        INC    HL
        LD     D,M
        LD     A,D
        OR     E
        JR     Z,RNUMED
        EX     DE,HL
        ADD    HL,DE
        DEC    HL
        EX     DE,HL
        INC    HL
        LD     C,M
        INC    HL
        LD     B,M
        PUSH   HL
        DEFB   21H
STLNO:  DEFS   2
        OR     A
        SBC    HL,BC
        POP    HL
        JR     Z,BEGREN
        JR     C,BEGREN
        EX     DE,HL

        JR     BEGRNS
;
BEGREN: DEC    HL
        DEC    HL
        DEC    HL
        DEFB   01H
NEWNO:  DEFS   2
        OR     A
        PUSH   AF
RENUML: LD     E,M
        INC    HL
        LD     D,M
        LD     A,D
        OR     E
        JR     Z,RNUMED
        EX     DE,HL
        ADD    HL,DE
        DEC    HL
        EX     DE,HL
        POP    AF
        JR     C,RENOVR
        INC    HL
        LD     M,C
        INC    HL
        LD     M,B
        DEFB   21H
ADDNO:  DEFS   2
        ADD    HL,BC
        PUSH   AF
        LD     C,L
        LD     B,H
        EX     DE,HL
        JR     RENUML
;
RNUMED: POP    AF
        CALL   REFLNX
        POP    HL
        RET
;
RENOVR: LD     HL,10
        LD     (ADDNO),HL
        LD     (NEWNO),HL
        LD     L,0
        LD     (STLNO),HL
        CALL   RNSTRT
        JP     ER03
        SKP    H

;
;
; Error message & exeption
;
MAXERR: EQU    70
;
        ENTRY  01
ER01:   ENT
        LD     A,01
        DEFB   21H
        ENDM
        ENTRY  02
ER02:   ENT
        LD     A,02
        DEFB   21H
        ENDM
        ENTRY  03
ER03:   ENT
        LD     A,03
        DEFB   21H
        ENDM
        ENTRY  04
ER04:   ENT
        LD     A,04
        DEFB   21H
        ENDM
        ENTRY  05
ER05:   ENT
        LD     A,05
        DEFB   21H
        ENDM
        ENTRY  06
ER06:   ENT
        LD     A,06
        DEFB   21H
        ENDM
        ENTRY  07
ER07:   ENT
        LD     A,07
        DEFB   21H
        ENDM
        ENTRY  08
ER08:   ENT
        LD     A,08
        DEFB   21H
        ENDM
        ENTRY  13
ER13:   ENT
        LD     A,13
        DEFB   21H
        ENDM
        ENTRY  14
ER14:   ENT
        LD     A,14

        DEFB   21H
        ENDM
        ENTRY  15
ER15:   ENT
        LD     A,15
        DEFB   21H
        ENDM
        ENTRY  16
ER16:   ENT
        LD     A,16
        DEFB   21H
        ENDM
        ENTRY  17
ER17:   ENT
        LD     A,17
        DEFB   21H
        ENDM
        ENTRY  18
ER18:   ENT
        LD     A,18
        DEFB   21H
        ENDM
        ENTRY  19
ER19:   ENT
        LD     A,19
        DEFB   21H
        ENDM
        ENTRY  20
ER20:   ENT
        LD     A,20
        DEFB   21H
        ENDM
        ENTRY  21
ER21:   ENT
        LD     A,21
        DEFB   21H
        ENDM
        ENTRY  22
ER22:   ENT
        LD     A,22
        DEFB   21H
        ENDM
        ENTRY  24
ER24:   ENT
        LD     A,24
        DEFB   21H
        ENDM
        ENTRY  25
ER25:   ENT
        LD     A,25
        DEFB   21H
        ENDM
        ENTRY  58
ER58:   ENT
        LD     A,58
        DEFB   21H
        ENDM
ER64:   ENT
        LD     A,64
        JR     ERRJ2

;
ER06':  ENT                    ;Nesting error
        LD     A,6
NESTER: ENT
        LD     SP,(INTFAC)
        LD     HL,FFFFH
        PUSH   HL
        LD     (STACK),SP
ERRJ2:  JR     ERRJ1
        SKP    H

;
LPTMER: ENT                    ;LPT:mode error
        LD     HL,(.$LPT)
        DEFB   DDH
CRTMER: ENT                    ;CRT:mode error
        LD     HL,(.$CRT)
        LD     (ZEQT),HL
        XOR    A
        LD     (ZFLAG2),A
        LD     A,68+80H        ;+80H is I/O err
        DEFB   21H
ER59:   ENT
        LD     A,59+80H
        DEFB   21H
ER59':  ENT
        LD     A,59
        DEFB   21H
ER60:   ENT
        LD     A,60+80H
        DEFB   21H
ER61:   ENT
        LD     A,61+80H
ERRJ1:  JP     ERRORJ
;
;
P.ERL:  LD     A,L             ;Print "IN line#"
        OR     H
        RET    Z
        LD     DE,MESIN
        SVC    .CRTMS
        RST    3
        DEFB   .CRTMS
        ENDM
        CALL   ASCFIV
        SVC    .CRTMS
        RST    3
        DEFB   .CRTMS
        ENDM
        RET
;
;
MESIN:  DEFM   " IN "
        DEFB   0
MESBR:  DEFM   "BREAK"

        DEFB   0
;
OKMES:  ENT
        DEFM   "READY"

CONTFG: ENT
        DEFB   0
        DEFB   0
        SKP    H

;
ERROR:  CALL   IBYTE           ;"ERROR" command
        DEC    A
        CP     MAXERR
        JR     C,+4
        LD     A,69-1
        INC    A
;
ERRORA: LD     SP,(STACK)      ;jump from monitor
        PUSH   AF
        SVC    .ERCVR
        RST    3
        DEFB   .ERCVR
        ENDM
        CALL   LDEND
        POP    AF
        OR     A
        JR     Z,.BRKX
        CP     80H
        JR     Z,.BRKZ
        LD     C,A
        LD     HL,0
        LD     (FNVRBF),HL
        CALL   ?DIRECT
        LD     A,C
        JR     Z,ERR2
        LD     HL,(LNOBUF)
        LD     (ERRLNO),HL
        LD     (EDLINE),HL
        LD     HL,(NXTLPT)
        LD     (ERRLPT),HL
        LD     HL,(TEXTPO)
        LD     (ERRPNT),HL
        AND    7FH
        LD     (ERRCOD),A
        LD     A,(ERRORF)
        INC    A
        CP     02H
        JR     Z,ERROPR
        XOR    A
        LD     (CONTFG),A
        LD     (LSWAP),A
        LD     A,C
ERR2:   SVC    .ERRX
        RST    3
        DEFB   .ERRX
        ENDM
ERR4:   LD     HL,(LNOBUF)
        CALL   P.ERL
        JP     OK
;
;
ERROPR: LD     (ERRORF),A      ;Error trap
        LD     HL,(ERRORV)
        PUSH   HL
        JP     NXLINE
;
        SKP    H

.BRKZ:  LD     A,"."           ;Can CONT
.BRKX:                         ;Can't CONT
       LD     HL,(TEXTPO)
        JR     BREAK2
;
STOP:                          ;"STOP" command
        LD     A,"."           ;Can CONT
        POP    DE              ;Dummy POP
BREAK2: PUSH   AF
        PUSH   HL
        SVC    .CR2
        RST    3
        DEFB   .CR2
        ENDM
        SVC    .BELL
        RST    3
        DEFB   .BELL
        ENDM
        LD     DE,MESBR
        SVC    .CRTMS
        RST    3
        DEFB   .CRTMS
        ENDM
        POP    HL
        CALL   ?DIRECT
        JR     Z,BREAK4
        LD     (BREAKT+1),HL   ;Text pointer
        LD     HL,(NXTLPT)
        LD     (BREAKN+1),HL   ;Next line
        LD     HL,(LNOBUF)
        LD     (BREAKL+1),HL   ;Line No.
        LD     (EDLINE),HL
        POP    AF
        LD     (CONTFG),A
        JP     ERR4
BREAK4: POP    AF
        JP     OK
;
;
CONT:   POP    DE              ;"CONT" command
        LD     HL,CONTFG
        LD     A,M
        OR     A
        JP     Z,ER17
        LD     M,0
BREAKL: LD     HL,0            ;Line No.
        LD     (LNOBUF),HL
BREAKN: LD     HL,0            ;Next line
        LD     (NXTLPT),HL
BREAKT: LD     HL,0            ;Text pointer
        JP     MAIN
;
;
        SKP    H

;
RESUME:                        ;"RESUME" command
        LD     A,(ERRORF)
        CP     2
        JP     C,ER21
        DEC    A
        LD     (ERRORF),A
        CALL   ENDCHK
        EX     DE,HL
        LD     HL,(ERRLNO)
        LD     (LNOBUF),HL
        LD     HL,(ERRLPT)
        LD     (NXTLPT),HL
        LD     HL,(ERRPNT)
        JR     NZ,RESUM2
        POP    BC
        JP     MAIN0           ;RESUME
RESUM2: CP     8EH
        JP     Z,DATA          ;RESUME NEXT
        EX     DE,HL
        JP     GOTO            ;RESUME line#
;
ONERRG: ENT
        TESTX  80H             ;GOTO
        CALL   TESTX
        DEFB   80H
        ENDM
        CALL   GETLIN
        JR     Z,OFFER
        LD     (ERRORV),DE
        LD     A,1
ONER9:  LD     (ERRORF),A
        RET
;
;
OFFER:  LD     A,(ERRORF)
        DEC    A
        JR     Z,ONER9
        XOR    A
        LD     (ERRORF),A
        LD     HL,(ERRLNO)
        LD     (LNOBUF),HL
        LD     A,(ERRCOD)
        JP     ERRORA
;
        END

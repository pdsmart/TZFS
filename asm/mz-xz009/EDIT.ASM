; ------------------------------------
; MZ-800 BASIC  Interm.code conversion
; FI:EDIT  ver 1.0A 7.18.84
; Programed by T.Miho
; ------------------------------------
;
        INCLD  MACRO
;
CVIMTX: ENT
        PUSH   DE
        PUSH   BC
        LD     C,0
        DEC    DE
CVIM10: INC    DE
CVIM12: CALL   IMSPACE
        OR     A
        JR     Z,IMEND
        CP     FFH
        JR     Z,IMPAI
        CP     80H
        JP     NC,ER01
        CP     20H
        JR     C,CVIM10
        LD     IX,CVIM12
        PUSH   IX
        CP     '"'
        JR     Z,IMSTR
        CP     "'"
        JR     Z,IMREM
        CP     "?"
        JR     Z,IMPRT
        CP     "."
        JP     Z,IMFLT
        CP     "$"
        JP     Z,IMHEX
        CALL   TSTNUM
        JR     C,IMRSV
        JP     IMNUM
;
IMEND:  LD     M,A
        POP    BC
        POP    DE
        RET
;
IMPAI:  LD     M,E4H
        CALL   IM3R
        JR     CVIM12
;
IMPRT:  LD     A,8FH
        CALL   IM3RS
        JR     IMRSV6
;
IMREM:  LD     M,":"
        CALL   IM3R
        LD     M,"'"
        CALL   IM3RH
        JP     IMDATA
        SKP    H

;
IMSTR:  LD     M,A
        CALL   IM3R
IMSTR2: LD     A,(DE)
        OR     A
        RET    Z
        CP     '"'
        JR     NZ,IMSTR
IM3RS:  LD     M,A
IM3R:   INC    DE
IM3RH:  INC    HL
IM3RC:  INC    C
        RET    NZ
        JP     ER08            ;LINE LENGTH
;
IMVAR:  POP    BC
        LD     A,(DE)
        CALL   TSTVAR
        JR     C,IM3RS
IMVAR2: CALL   IM3RS
        LD     A,(DE)
        CP     "$"
        JR     Z,IM3RS
        CALL   TSTNUM
        RET    C
        JR     IMVAR2
;
IMRSV:  PUSH   BC
        LD     BC,CTBL1
        CALL   IMSER
        JR     NC,IMRSV4
        LD     BC,GTABL
        CALL   IMSER
        LD     C,FEH
        JR     NC,IMRSV2
        LD     BC,CTBL2
        CALL   IMSER
        LD     C,FFH
        JR     C,IMVAR
IMRSV2: LD     M,C
        INC    HL
        LD     M,A
        POP    BC
        CALL   IM3RC
        CALL   IM3RH
        CP     B4H             ; ERL ******
        RET    NZ
        CALL   IMSPACE
        CP     "="
        RET    NZ
        LD     M,F4H           ; = ******
        CALL   IM3R
        JR     IMLNO
        SKP    H

;
IMRSV4: POP    BC
        CALL   IM3RH
IMRSV6: CP     97H             ; REM
        JR     Z,IMDATA
        CP     94H             ; DATA
        JR     Z,IMDATA
        CP     C2H             ; ELSE
        JR     Z,IMELSE
        CP     E2H             ; THEN
        JR     Z,IMLNO
        CP     E0H
        RET    NC
        PUSH   AF
        CALL   IMSPACE
        CP     "/"
        JR     NZ,IMRSV7
        LD     M,FBH           ;/
        CALL   IM3R
        CALL   SKPDE
        CALL   IM3RS
        JR     IMRSV8
IMRSV7: CP     "#"
        JR     NZ,IMRSV8
        CALL   IM3RS
        CALL   SKPDE
        CALL   TSTNUM
        CALL   NC,IMNUM
IMRSV8: POP    AF
        CP     8DH             ; FOR
        RET    NC
;
IMLNO:  CALL   IMSPACE
        CP     '"'
        JR     NZ,IMLNO2
        CALL   IMSTR
        JR     IMLNO
IMLNO2: CP     2CH
        RET    C
        CP     2FH
        JR     C,IMLNO4        ;",-."
        CALL   TSTNUM
        RET    C
        CALL   IMINT
        JR     IMLNO
IMLNO4: CALL   IM3RS
        JR     IMLNO
;
IMELSE: DEC    HL
        LD     M,":"
        INC    HL
        LD     M,A
        CALL   IM3RH
        JR     IMLNO
;
IMDATA: LD     A,(DE)
        CALL   ENDCK0
        RET    Z
        CALL   IM3RS
        CP     '"'

        CALL   Z,IMSTR2
        JR     IMDATA
;
;
IMSER:  PUSH   HL              ;Search in tabale
        PUSH   DE
        LD     HL,BC
        LD     B,7FH
IMSER2: POP    DE
        PUSH   DE
        INC    B
        LD     A,M
        CP     FFH
        JR     NZ,IMSER3
        POP    DE              ;Table end
        POP    HL
        SCF
        RET
;
IMSER3: CP     "."
        JR     NZ,IMSER4
        INC    HL              ;AND OR XOR NOT
        DEC    DE
        LD     A,(DE)
        INC    DE
        CALL   TSTVAR
        JR     NC,IMSER6
IMSER4: LD     A,(DE)
        CP     " "
        JR     NZ,IMSER5
        LD     A,M
        AND    7FH
        SUB    "A"
        CP     26
        JR     C,IMSER6
        CALL   SKPDI
IMSER5: LD     C,M
        INC    HL
        INC    DE
        CP     "."
        JR     Z,IMSER8
        SUB    C
        JR     Z,IMSER4
        CP     80H
        JR     Z,IMSER9
IMSER6: DEC    HL              ;Not match
        BIT    7,M
        INC    HL
        JR     Z,-3
        JR     IMSER2
IMSER8: LD     A,B
        CP     E8H             ;operator
        JR     NC,IMSER6
        CCF
IMSER9: POP    HL              ;Found
        POP    HL
        LD     M,B
        LD     A,B
        RET
;

IMSPACE:LD     A,(DE)
        CP     " "
        RET    NZ
        LD     M,A
        CALL   IM3R
        JR     IMSPACE
        SKP    H

;
IMNUM:  EX     AF,AF'
        PUSH   DE
        CALL   SKPDI
        POP    DE
        CALL   TSTNUM          ;check if one-digit
        JR     NC,IMFLT
        CP     "."
        JR     Z,IMFLT
        CP     "E"
        JR     Z,IMFLT
        EX     AF,AF'
        SUB    "0"-1
        JP     IMFLT           ;ok, JP IM3RS
;
IMFLT:  PUSH   BC
        LD     M,15H
        INC    HL
        PUSH   HL
        CALL   CVFLAS
        POP    HL
        LD     BC,5
        ADD    HL,BC
        LD     A,6
        JR     BCKSPS
;
IMINT:  PUSH   BC
        CALL   CVBCAS
        LD     M,0BH
        INC    HL
        JR     PPOLNO
;
IMHEX:  LD     M,A
        INC    DE
        LD     A,(DE)
        SVC    .CKHEX
        RST    3
        DEFB   .CKHEX
        ENDM
        JP     C,IM3RH
        PUSH   BC
        LD     M,11H
        INC    HL
        PUSH   HL
        EX     DE,HL
        SVC    .DEHEX
        RST    3
        DEFB   .DEHEX
        ENDM
        LD     BC,DE
        EX     DE,HL
        POP    HL
PPOLNO: LD     A,3
        LD     M,C
        INC    HL
        LD     M,B
        INC    HL
BCKSPS: POP    BC
        ADD    A,C
        JP     C,ER08          ;LINE LENGTH

        LD     C,A
BCKSKP: DEC    DE
        LD     A,(DE)
        CP     " "
        JR     Z,-4
        INC    DE
        RET
        SKP    H

;
CVTXIM: ENT
        PUSH   HL
        PUSH   DE
        PUSH   BC
        EXX
        LD     B,0
        EXX
        LD     C,0
CVTX10: LD     A,M
        OR     A
        JR     Z,TXEND
        LD     BC,CVTX10
        PUSH   BC
        CP     "'"
        JR     Z,TXDAT2
        INC    HL
        LD     BC,CTBL1
        CP     20H
        JR     C,TXNUM
        CP     '"'
        JR     Z,TXSTR
        CP     ":"
        JR     Z,TX3AH
        CP     97H             ;REM
        JR     Z,TXDATA
        CP     94H             ;DATA
        JR     Z,TXDATA
        CP     E4H             ;PI
        JR     Z,TXPAI
        CP     FEH
        JR     NC,TXRSV0
        CP     80H
        JP     NC,TXRSV
        JP     STRDE
;
TXEND:  LD     (DE),A
        POP    BC
        POP    DE
        POP    HL
        RET
;
TXPAI:  LD     A,FFH
        JP     STRDE
;
TXRSV0: LD     BC,CTBL2
        JR     NZ,+5
        LD     BC,GTABL
        LD     A,M
        INC    HL
        JR     TXRSV
;
TXDATA: CALL   TXRSV
        RET    Z
TXDAT2: LD     A,M
        CALL   ENDCK0
        RET    Z
        CALL   STRDE
        LD     A,M
        INC    HL

        CP     '"'
        CALL   Z,TXSTR2
        JR     TXDAT2
;
TXSTR:  CALL   STRDE
TXSTR2: LD     A,M
        OR     A
        RET    Z
        INC    HL
        CP     '"'
        JR     NZ,TXSTR
        JR     STRDE
;
TX3AH:  LD     (DE),A
        LD     A,M
        CP     C2H             ; ELSE
        RET    Z
        CP     "'"
        RET    Z
        JR     STRDE'
;
TXNUM:  CP     15H
        JR     Z,TXFLT
        CP     0BH
        JR     NC,TXINT
        DEC    A
        OR     30H
        JR     STRDE
;
TXINT:  PUSH   DE
        LD     E,M
        INC    HL
        LD     D,M
        INC    HL
        PUSH   HL
        CP     12H
        JR     Z,TXINT2
        CP     0CH
        JR     C,TXINT2
        JR     NZ,TXHEX
        EX     DE,HL
        INC    HL
        INC    HL
        LD     E,M
        INC    HL
        LD     D,M
TXINT2: EX     DE,HL
        CALL   ASCFIV
        LD     BC,DE
        POP    HL
        POP    DE
TXINT4: LD     A,(BC)
        OR     A
        RET    Z
        CALL   STRDE
        INC    BC
        JR     TXINT4
;
TXFLT:  PUSH   HL
        PUSH   DE

        CALL   CVASFL
        LD     BC,DE
        POP    DE
        POP    HL
        REP5   INC,HL
        INC    HL
        INC    HL
        INC    HL
        INC    HL
        INC    HL
        ENDM
        JR     TXINT4
;
TXRSV:  CP     80H
        JR     Z,TXRSV4
        EX     AF,AF'
TXRSV2: LD     A,(BC)
        RLCA
        INC    BC
        JR     NC,TXRSV2
        EX     AF,AF'
        DEC    A
        JR     TXRSV
TXRSV4: LD     A,(BC)
        BIT    7,A
        JR     NZ,STRDES
        CP     "."
        CALL   NZ,STRDE
        INC    BC
        JR     TXRSV4
;
STRDES: AND    7FH
STRDE:  LD     (DE),A
        OR     A
        RET    Z
STRDE': INC    DE
        EXX
        INC    B
        EXX
        RET    NZ
        XOR    A
        LD     (DE),A
        DEC    DE
        EXX
        DEC    B
        EXX
        RET
;
TXHEX:  LD     A,"$"
        EX     AF,AF'
        EX     DE,HL
        CALL   HEXHL
        LD     BC,DE
        POP    HL
        POP    DE
        EX     AF,AF'
        CALL   STRDE
        JR     TXINT4
;
HEXHL:  ENT

        LD     DE,DGBF12
        PUSH   DE
        LD     A,H
        CALL   HEXACC
        LD     A,L
        CALL   HEXACC
        XOR    A
        LD     (DE),A
        POP    DE
        LD     B,3
;
ZRSUP:  LD     A,(DE)
        CP     "0"
        RET    NZ
        INC    DE
        DJNZ   ZRSUP
        RET
;
HEXACC: ENT
        PUSH   AF
        RRCA
        RRCA
        RRCA
        RRCA
        AND    0FH
        CALL   HEXAC2
        POP    AF
        AND    0FH
HEXAC2: ADD    A,30H
        CP     3AH
        JR     C,+4
        ADD    A,7
        LD     (DE),A
        INC    DE
        RET
;
CVBCAS: ENT
        PUSH   HL
        EX     DE,HL
        SVC    .DEASC
        RST    3
        DEFB   .DEASC
        ENDM
        LD     BC,DE
        EX     DE,HL
        POP    HL
        JP     BCKSKP
;
        END

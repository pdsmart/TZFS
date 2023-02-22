; ----------------------------
; MZ-800 BASIC  Floating point
; FI:FLOAT  ver 1.0A 7.18.84
; Programed by T.Miho
; ----------------------------
;
        INCLD  MACRO
;
;
CLRFAC: ENT
        PUSH   HL
        LD     B,5
        CALL   ?CLRHL
        POP    HL
        RET
;
NEG:    ENT
        CALL   STROMT
TOGLE:  ENT
        LD     A,M
        OR     A
        RET    Z
        INC    HL
        LD     A,M
        XOR    80H
        LD     M,A
        DEC    HL
        RET
;
;
;(HL)=(HL)-(DE)
;
SUB:    ENT
        CALL   STROMT
        LD     C,A
        LD     A,80H
        JP     ADDSUB
;
;(HL)=(HL)+(DE)
;
ADD:    ENT
        LD     A,(PRCSON)
        CP     03H
        JP     Z,STRADD
        LD     C,A
        XOR    A
ADDSUB: LD     (HLBUF),HL
        PUSH   DE
        PUSH   HL
        LD     (SPBUF),SP
        INC    HL
        INC    DE
        LD     B,M             ;
        XOR    M
        EX     DE,HL
        XOR    M
        DEC    HL
        DEC    DE
        EX     DE,HL
        RLCA

        LD     A,B
        LD     (SIGN),A
        JP     C,FSUB          ;HL-DE
;
FADD:   XOR    A               ;HL+DE
        CP     M
        JP     Z,TRANS         ;(HL)_(DE)
        LD     A,(DE)
        OR     A
        JR     Z,FLEXIT        ;SIGN SET RET
        SUB    M               ;DE-HL
        JP     SFADD
;
;
FLEXIT: LD     SP,(SPBUF)
        POP    HL
        POP    DE
        EI
        LD     A,M
        OR     A
        JP     Z,ABS
        LD     A,(SIGN)
        AND    80H
        INC    HL
        RES    7,M
        OR     M
        LD     M,A
        DEC    HL
        RET
;
TRANS:  LD     B,0
        LD     A,5
        LD     C,A
        EX     DE,HL
        LDIR
        JP     FLEXIT
;
STRADD: LD     B,M
        LD     A,(DE)
        ADD    A,B
        JP     C,ER05          ;STRING TOO LONG
        LD     C,A
        PUSH   DE
        PUSH   HL
        PUSH   DE
        INC    HL
        LD     E,M
        INC    HL
        LD     D,M
        LD     HL,(STRST)
        ADD    HL,DE
        EX     DE,HL
        LD     HL,(TMPEND)
        CALL   STRENT
        EX     (SP),HL
        LD     B,M
        INC    HL
        LD     E,M
        INC    HL
        LD     D,M

        LD     HL,(STRST)
        ADD    HL,DE
        EX     DE,HL
        POP    HL
        CALL   STRENT
        LD     A,C
        LD     DE,(TMPEND)
        LD     BC,(STRST)
        EX     DE,HL
        OR     A
        SBC    HL,BC
        EX     DE,HL
        LD     (TMPEND),HL
        POP    HL
        LD     M,A
        INC    HL
        LD     M,E
        INC    HL
        LD     M,D
        DEC    HL
        DEC    HL
        POP    DE
        RET
;
;
CMP:    ENT
        LD     A,(PRCSON)
        CP     3
        JR     NZ,FLTCP2
        PUSH   DE
        PUSH   HL
        LD     A,(DE)
        OR     M
        JR     Z,STCMPE
        LD     A,(DE)
        CP     M
        JR     C,+3
        LD     A,M
        OR     A
        JR     Z,STCMPF
        INC    HL
        LD     C,M
        INC    HL
        LD     B,M
        EX     DE,HL
        INC    HL
        LD     E,M
        INC    HL
        LD     D,M
        LD     HL,(STRST)
        EX     DE,HL
        ADD    HL,DE
        EX     DE,HL
        ADD    HL,BC
        EX     DE,HL
        LD     B,A
        OR     A
        JR     Z,STCMPE
STCMPL: LD     A,(DE)
        CP     M

        JR     NZ,STCMPE
        INC    DE
        INC    HL
        DJNZ   STCMPL
STCMPF: POP    DE
        POP    HL
        LD     A,(DE)
        CP     M
        EX     DE,HL
        RET
;
STCMPE: POP    HL
        POP    DE
        RET
;
;
;
FLTCP2: INC    DE
        INC    HL
        LD     A,(DE)
        DEC    DE
        XOR    M
        RLCA
        JR     NC,FLTCP3
        LD     A,M
        DEC    HL
        RLCA
        RET
FLTCP3: LD     A,M
        DEC    HL
        RLCA
        JR     NC,FLTCMP
        CALL   FLTCMP
        RET    Z
        CCF
        RET
;
FLTCMP: PUSH   DE
        PUSH   HL
        EX     DE,HL
        LD     A,(DE)
        CP     M
        JR     NZ,SUBNZ
        INC    DE
        INC    HL
        LD     A,M
        OR     80H
        LD     B,A
        LD     A,(DE)
        OR     80H
        CP     B
        JR     NZ,SUBNZ
        LD     A,(PRCSON)
        LD     B,A
        DEC    B
        DEC    B
CMPL:   INC    DE
        INC    HL
        LD     A,(DE)
        CP     M

        JR     NZ,SUBNZ
        DJNZ   CMPL
SUBNZ:  POP    HL
        POP    DE
        RET
;
ZERO:   POP    HL
        PUSH   HL
        CALL   CLRFAC
        JP     FLEXIT
;
FSUB:   CALL   FLTCMP
        JR     Z,ZERO
        JR     NC,SUBOK
        LD     A,(SIGN)
        XOR    80H
        LD     (SIGN),A
        SCF
SUBOK:  EX     AF,AF'
        LD     A,M
        OR     A
        JP     Z,TRANS
        LD     A,(DE)
        OR     A
        JP     Z,FLEXIT
        SUB    M
        JR     C,FSUB11
        CP     32
        JP     NC,TRANS
        JR     SUBOK2
FSUB11: NEG
        CP     32
        JP     NC,FLEXIT
SUBOK2: EX     AF,AF'
        JR     C,SUBOK'
        EX     DE,HL
SUBOK': EX     AF,AF'
        JP     SSUB
;
OVERF:  LD     SP,(SPBUF)
        EI
        POP    HL
        POP    DE
        LD     A,(OFLAG)
        OR     A
        JP     Z,ER02
;SET MAX NUM HERE *****
        RET
;
;
;
;
SFADD:  JR     NC,SNSH
        NEG
        CP     32
        JP     NC,FLEXIT
        EX     DE,HL
        JR     SADD1
SNSH:   CP     32
        JP     NC,TRANS

SADD1:  CALL   SSHIFT
        LD     A,H
        EXX
        ADC    A,H             ; ADJUST WITH CARRY
        EXX
        LD     H,A             ;
        LD     A,L
        EXX
        ADC    A,L
        EXX
        LD     L,A
        LD     A,D
        EXX
        ADC    A,D
        EXX
        LD     D,A
        LD     A,E
        EXX
        ADC    A,E
        EXX
        JR     NC,SSTORE
        RRA
        RR     D
        RR     L
        RR     H
        INC    C
        JP     Z,OVERF
SSTORE: LD     E,A
        LD     A,C
        EXX
        LD     BC,5
        LD     HL,(HLBUF)
        LD     M,A
        ADD    HL,BC
        DI
        LD     SP,HL
        EXX
        PUSH   HL
        PUSH   DE
        JP     FLEXIT
;
SSHIFT: DI
        LD     (SPBF),SP
        EX     AF,AF'
        INC    HL
        LD     SP,HL
        EXX
        POP    DE              ;E,D,L,H
        SET    7,E             ;CY=0
        POP    HL
        OR     A
SHFLP2: EX     AF,AF'
        CP     8
        JR     C,BITET2
        SUB    8
        EX     AF,AF'
        RL     H
        LD     H,L
        LD     L,D
        LD     D,E

        LD     E,0
        JR     SHFLP2
BITET2: OR     A
        JR     Z,BITSE2
BITST2: EX     AF,AF'
        OR     A
        RR     E
        RR     D
        RR     L
        RR     H
        EX     AF,AF'
        DEC    A
        JR     NZ,BITST2
BITSE2: EXX
        EX     DE,HL
        LD     C,M
        INC    HL
        LD     SP,HL
        POP    DE
        SET    7,E
        POP    HL
        EX     AF,AF'
        LD     SP,(SPBF)
        EI
        RET
;
SSUB:   CP     32
        JP     NC,FLEXIT
        CALL   SSHIFT
        LD     A,H
        EXX
        SBC    A,H
        EXX
        LD     H,A
        LD     A,L
        EXX
        SBC    A,L
        EXX
        LD     L,A
        LD     A,D
        EXX
        SBC    A,D
        EXX
        LD     D,A
        LD     A,E
        EXX
        SBC    A,E
        EXX
SSFL2:  OR     A
        JR     Z,BSIFT
SSFL3:  BIT    7,A
        JR     NZ,SSTOR2
        RL     H
        RL     L
        RL     D
        RLA
        DEC    C
        JP     NZ,SSFL3
        JP     ZERO
SSTOR2: LD     E,A

        JP     SSTORE
BSIFT:  LD     A,C
        SUB    8
        LD     C,A
        LD     A,D
        LD     D,L
        LD     L,H
        LD     H,0
        JR     Z,+4
        JR     NC,SSFL2
        JP     ZERO
;
;---------------------
;
EXPCHK: LD     C,A
        INC    HL
        INC    DE
        LD     A,(DE)
        XOR    M
        LD     (SIGN),A
        DEC    HL
        DEC    DE
        RET
;
MUL:    ENT
        CALL   STROMT
        CALL   EXPCHK
        PUSH   DE
        PUSH   HL
        LD     (SPBUF),SP
        LD     A,M
        OR     A
        JP     Z,ZERO
        LD     A,(DE)
        OR     A
        JP     Z,ZERO
        INC    DE
        PUSH   DE
        POP    IX
        ADD    A,M
        LD     E,A
        LD     A,0
        ADC    A,A
        LD     D,A
        LD     (EXPSGN),DE
        INC    HL
        XOR    A
        LD     (CYFLG),A
        LD     D,M
        SET    7,D
        INC    HL
        LD     E,M
        INC    HL
        PUSH   HL
        LD     H,A
        LD     L,A
        EXX
        POP    HL
        LD     D,M
        INC    HL

        LD     E,M
        LD     B,A
        LD     C,A
        LD     H,A
        LD     L,A
        EXX
        LD     A,(IX+0)
        OR     80H
        LD     C,4             ;BYTES COUNTER
SMULL1: LD     B,8             ;BIT COUNTER
        OR     A
        JP     Z,SMULL5
SMULL2: RLCA
        JR     NC,SMULL4
        EX     AF,AF'
        EXX
        LD     A,C
        ADD    A,B
        LD     C,A
        ADC    HL,DE
        EXX
        ADC    HL,DE
        JR     NC,SMULL3
        LD     A,1
        LD     (CYFLG),A
SMULL3: EX     AF,AF'
SMULL4: SRL    D
        RR     E
        EXX
        RR     D
        RR     E
        RR     B
        EXX
        DJNZ   SMULL2
SMULL6: INC    IX
        LD     A,(IX+0)
        DEC    C
        JR     NZ,SMULL1
        EXX
        LD     A,(CYFLG)
        OR     A
        JR     Z,SMULL7
        LD     DE,(EXPSGN)
        INC    DE
        LD     (EXPSGN),DE
        EXX
        SCF
        RR     H
        RR     L
        EXX
        RR     H
        RR     L
        RR     C
SMULL7: BIT    7,C
        JR     Z,SMULL8
        LD     DE,1
        ADD    HL,DE
        EXX
        LD     DE,0
        ADC    HL,DE

        EXX
        JR     NC,SMULL8
        LD     DE,(EXPSGN)
        INC    DE
        LD     (EXPSGN),DE
        EXX
        LD     H,80H
        EXX
SMULL8: POP    IX
        PUSH   IX
        LD     (IX+4),L
        LD     (IX+3),H
        EXX
        LD     (IX+2),L
        LD     (IX+1),H
        LD     HL,(EXPSGN)
        OR     A
        LD     DE,81H
        SBC    HL,DE
        LD     A,H
        ADD    A,0
        JP     M,UNDRFL
        JP     NZ,OVERF
        LD     (IX+0),L
        JP     FLEXIT
;
SMULL5: LD     A,E
        EXX
        LD     B,E
        LD     E,D
        LD     D,A
        EXX
        LD     E,D
        LD     D,0
        JP     SMULL6
;
;
UNDRFL: LD     SP,(SPBUF)      ;****
        JP     ZERO
;
DIV:    ENT
        CALL   STROMT
        CALL   EXPCHK
        PUSH   DE
        PUSH   HL
        LD     (SPBUF),SP
        LD     A,(DE)
        OR     A
        JP     Z,ER02          ;DIVID BY ZERO
        EX     AF,AF'
        LD     A,M
        OR     A
        JP     Z,ZERO
        EXX
        ADD    A,81H
        LD     B,A
        LD     A,0
        ADC    A,A
        EX     AF,AF'
        LD     C,A

        LD     A,B
        SUB    C
        LD     C,A
        EX     AF,AF'
        LD     B,A
        EX     AF,AF'
        LD     A,B
        SBC    A,0
        JP     C,UNDRFL
        JP     NZ,OVERF
        LD     A,C
        PUSH   AF              ;PUSH A(EXP)
        EXX
        INC    DE
        INC    HL
        LD     B,M
        SET    7,B
        INC    HL
        LD     C,M
        INC    HL
        PUSH   HL
        EX     DE,HL
        LD     D,M
        SET    7,D
        INC    HL
        LD     E,M
        INC    HL
        PUSH   HL
        LD     H,B
        LD     L,C
        EXX
        POP    HL
        LD     D,M
        INC    HL
        LD     E,M
        POP    HL
        LD     A,M
        INC    HL
        LD     L,M
        LD     H,A
        EXX                    ;HLH'L'/DED'E'
        LD     C,5             ;C=5
SDIVL1: LD     B,8             ;B=8
        XOR    A
SDIVL2: BIT    7,H
        JR     NZ,SDIVL3
        OR     A
SDIVL4: RLA
        EXX
        ADD    HL,HL
        EXX
        ADC    HL,HL
        DJNZ   SDIVL2
        PUSH   AF
        DEC    C
        JR     NZ,SDIVL1
        JP     SDIVED
;
SDIVL3: OR     A
        EXX

        SBC    HL,DE
        EXX
        SBC    HL,DE
        CCF
        JR     C,SDIVL4
        EXX
        ADD    HL,DE
        EXX
        ADC    HL,DE
        OR     A
        RLA
        EXX
        ADD    HL,HL
        EXX
        ADC    HL,HL
        DJNZ   SDIVL5
        PUSH   AF
        LD     B,8
        DEC    C
        JP     Z,SDIVED
SDIVL5: EXX
        OR     A
        SBC    HL,DE
        EXX
        SBC    HL,DE
        SCF
        RLA
        DJNZ   SDIVL6
        PUSH   AF
        LD     B,8
        DEC    C
        JR     Z,SDIVED
SDIVL6: EXX
        ADD    HL,HL
        EXX
        ADC    HL,HL
        JR     C,SDIVL5
        JP     SDIVL2
;
SDIVED: POP    AF
        LD     H,A             ;H'
        EXX
        POP    AF
        LD     E,A             ;E
        POP    AF
        LD     D,A             ;D
        POP    AF
        LD     C,A             ;C
        POP    AF
        LD     B,A             ;B
        POP    AF              ;A(EXP)
SDIVL9: BIT    7,B
        JR     NZ,SDIVE2
        EXX
        SLA    H
        EXX
        RL     E
        RL     D
        RL     C
        RL     B

        DEC    A
        JP     NZ,SDIVL9
        JP     ZERO
SDIVE2: EXX
        RL     H
        EXX
        JR     NC,SDIVL8
        LD     HL,1
        ADD    HL,DE
        EX     DE,HL
        LD     HL,0
        ADC    HL,BC
        LD     B,H
        LD     C,L
        JR     NC,SDIVL8
        LD     B,80H
        INC    A
SDIVL8: POP    HL
        PUSH   HL
        LD     M,A
        INC    HL
        LD     M,B
        INC    HL
        LD     M,C
        INC    HL
        LD     M,D
        INC    HL
        LD     M,E
        JP     FLEXIT
;
HLBUF:  DEFS   2
SIGN:   DEFS   1
SPBUF:  DEFS   2
SPBF:   DEFS   2
CYFLG:  DEFS   1
EXPSGN: DEFS   2
OFLAG:  DEFS   1
;
        SKP    H

;
TSTSGN: INC    HL
        BIT    7,M
        DEC    HL
        RET
;
MULTWO: INC    M
        RET    NZ
        JP     ER02
;
DIVTWO: LD     A,M
        OR     A
        RET    Z
        DEC    M
        RET    NZ
        JP     CLRFAC
;
ADDHL5: PUSH   HL
        INC    HL
        INC    HL
        INC    HL
        INC    HL
        INC    HL
        EX     DE,HL
        LD     HL,(MEMMAX)
        DEC    HL
        SBC    HL,DE
        JP     C,ER06
        POP    HL
        RET
;
FACSET: PUSH   HL
        LD     (SNFAC0),HL
        CALL   ADDHL5
        EX     DE,HL
        LD     (SNFAC1),HL
        CALL   ADDHL5
        EX     DE,HL
        LD     (SNFAC2),HL
        CALL   ADDHL5
        LD     (SNFAC3),DE
        POP    HL
        RET
;
;
POWERS: ENT                    ;(HL)^(DE)
        CALL   STROMT
        EX     DE,HL
        LD     A,M
        OR     A
        JP     Z,POWR1
        EX     DE,HL
        LD     A,M
        OR     A
        JP     Z,CLRFAC
        CALL   TSTSGN
        JR     Z,POWER1
        CALL   TOGLE
        EX     DE,HL
        PUSH   DE

        PUSH   HL
        LD     DE,ZFAC1
        CALL   LDIR5           ;(ZFAC1)=(DE)
        LD     HL,ZFAC1
        CALL   FRACT
        LD     A,M
        OR     A
        JP     NZ,ER03
        POP    HL
        PUSH   HL
        CALL   HLFLT
        BIT    0,L
        POP    DE
        POP    HL
        JR     Z,POWER1
        CALL   POWER1
        JP     TOGLE
;
POWER1: EX     DE,HL
        LD     A,M
        OR     A
        JR     Z,POWR1
        CALL   TSTSGN
        JR     Z,POWER2
        CALL   TOGLE
        CALL   POWER2
        PUSH   DE
        PUSH   HL
        LD     DE,ZFAC1
        CALL   LDIR1           ;(ZFAC1)=1
        LD     HL,ZFAC1
        POP    DE
        CALL   DIV             ;(ZFAC1)/(HL)
        PUSH   DE
        CALL   LDIR5           ;(HL)=(ZFAC1)
        POP    HL
        POP    DE
        RET
;
POWR1:  PUSH   DE
        CALL   LDIR1
        POP    HL
        RET
;
POWER2: PUSH   DE
        LD     DE,ZFAC1
        CALL   LDIR5           ;(ZFAC1)=(DE)
        POP    HL
        CALL   LOG             ;LOG(HL)
        LD     DE,ZFAC1
        CALL   MUL             ;(HL)*(DE)
        JP     EXP             ;EXP(HL)
        SKP    H

;
.NOT.:  ENT
        CALL   STROMT
        PUSH   DE
        PUSH   HL
        CALL   HLFLT
        LD     A,L
        CPL
        LD     E,A
        LD     A,H
        CPL
        LD     D,A
        JR     AND9
;
.AND.:  ENT
        LD     A,A2H           ;AND D
        DEFB   1
.OR.:   ENT
        LD     A,B2H           ;OR D
        DEFB   1
.XOR.:  ENT
        LD     A,AAH           ;XOR D
;
        LD     (AND2),A
        INC    A
        LD     (AND4),A
        CALL   STROMT
        PUSH   DE
        PUSH   HL
        CALL   HLFLT
        EX     DE,HL
        CALL   HLFLT
        LD     A,H
AND2:   AND    D               ;AND, OR, XOR
        LD     D,A
        LD     A,L
AND4:   AND    E               ;AND, OR, XOR
        LD     E,A
AND9:   POP    HL
        CALL   FLTHEX
        POP    DE
        RET
        SKP    H

;
ABS:    ENT
        INC    HL
        RES    7,M
        DEC    HL
        RET
;
INTOPR: ENT
        CALL   TSTSGN
        JP     Z,INT
        CALL   MVFAC1
        CALL   INT
        LD     DE,ZFAC1
        CALL   CMP
        RET    Z
ONESUB: LD     DE,FLONE
        JP     SUB
;
ONEADD: LD     DE,FLONE
        JP     ADD
;
ONECMP: LD     DE,FLONE
        JP     CMP
;
MVFAC1: PUSH   HL
        PUSH   DE
        LD     DE,ZFAC1
        CALL   LDIR5
        POP    DE
        POP    HL
        RET
;
;
MOD:    ENT
        CALL   INT
        EX     DE,HL
        CALL   INT
        EX     DE,HL
        CALL   MVFAC1
        CALL   DIV
        CALL   INT
        CALL   MUL
        PUSH   DE
        LD     DE,ZFAC1
        CALL   SUB
        POP    DE
        JP     TOGLE
;
;
YEN:    ENT
        CALL   INT
        EX     DE,HL
        CALL   INT
        EX     DE,HL
        CALL   DIV
        JP     INT
;
;
SQR:    ENT
        LD     A,M

        OR     A
        RET    Z
        CALL   TSTSGN
        JP     NZ,ER03
        CALL   LOG
        CALL   DIVTWO
        JP     EXP
;
RETONE: PUSH   HL
        EX     DE,HL
        CALL   LDIR1
        POP    HL
        POP    BC
        RET
;
ATNLM1: DEFB   7EH
        DEFB   4CH
;
ATNLM2: DEFB   80H
        DEFB   2BH
;
ATN:    ENT
        PUSH   BC
        INC    HL
        LD     A,M
        RES    7,M
        DEC    HL
        PUSH   AF
        CALL   ATN''
        POP    AF
        POP    BC
        RLCA
        RET    NC
        JP     TOGLE
;
ATN'':  CALL   ONECMP
        JR     C,ATN'
        CALL   ADDHL5
        PUSH   DE
        PUSH   HL
        CALL   LDIR5
        POP    DE
        PUSH   DE
        CALL   LDIR1
        POP    HL
        POP    DE
        CALL   DIV
        CALL   ATN'
        LD     DE,FLTHPI       ;PI/2
        CALL   SUB
        JP     ABS
;
ATN':   LD     A,FFH
        LD     (SINSGN),A
        LD     DE,ATNLM1
        CALL   CMP
        JR     C,ATNCUL
        LD     DE,ATNLM2
        CALL   CMP
        PUSH   AF

        CALL   ADDHL5
        POP    AF
        PUSH   HL
        PUSH   DE
        CALL   LDIR5
        POP    HL
        JR     C,ATNMID
        CALL   ONEADD
        EX     (SP),HL
        CALL   SUB
        POP    DE
        CALL   DIV
        CALL   ATNCUL
        LD     DE,FLTQPI       ;PI/4
        JP     ADD
;
ATNMID: LD     DE,SQRTMO
        CALL   MUL
        CALL   ONEADD
        EX     (SP),HL
        LD     DE,SQRTMO
        CALL   SUB
        POP    DE
        CALL   DIV
        CALL   ATNCUL
        CALL   MULTWO
        LD     DE,FLTQPI       ;PI/4
        CALL   ADD
        JP     DIVTWO
;
SQRTMO: DEF5   7F,54,13,CC,D0
        DEFW   547FH
        DEFW   CC13H
        DEFB   D0H
        ENDM
;
ATNCUL: PUSH   BC
        PUSH   HL
        CALL   FACSET
        POP    HL
        PUSH   HL
        PUSH   DE
        CALL   LDIR5
        POP    HL
        LD     E,L
        LD     D,H
        CALL   MUL
        LD     DE,(SNFAC2)
        POP    HL
        PUSH   HL
        CALL   LDIR5
        LD     A,(PRCSON)
        DEC    A
        CP     04H
        LD     B,A
        LD     HL,TANTBL
        JP     Z,SIN6
        LD     B,10
        JP     SIN6
;

COS:    ENT
        PUSH   BC
        LD     A,M
        OR     A
        JP     Z,RETONE
        LD     DE,FLTHPI       ;PI/2
        CALL   SUB
        CALL   TOGLE
        POP    BC
;
SIN:    ENT
        PUSH   BC
        INC    HL
        LD     A,M
        RES    7,M
        AND    80H
        CPL
        LD     (SINSGN),A
        DEC    HL
        LD     DE,FLT2PI       ;PI*2
        PUSH   HL
        CALL   CMP
        JR     C,SIN1
        CALL   DIV
        CALL   FRACT
        CALL   MUL
SIN1:   LD     DE,FLTPAI
        CALL   CMP
        JR     C,SIN2
        CALL   SUB
        LD     A,(SINSGN)
        XOR    80H
        LD     (SINSGN),A
SIN2:   LD     DE,FLTHPI       ;PI/2
        CALL   CMP
        JR     C,SIN4
        LD     DE,FLTPAI
        CALL   SUB
        CALL   ABS
SIN4:   CALL   FACSET
        POP    HL
        PUSH   DE
        LD     DE,FLTQPI       ;PI/4
        CALL   CMP
        JR     NC,COSCUL
        POP    DE
        PUSH   HL
        PUSH   DE
        CALL   LDIR5
        POP    HL
        LD     E,L
        LD     D,H
        CALL   MUL
        LD     DE,(SNFAC2)
        POP    HL
        PUSH   HL
        CALL   LDIR5
        LD     A,(PRCSON)
        LD     B,A
        LD     HL,SINTBL

SIN6:   PUSH   BC
        PUSH   HL
        LD     HL,(SNFAC2)
        LD     DE,(SNFAC3)
        CALL   MUL
        POP    HL
        PUSH   HL
        LD     DE,(SNFAC1)
        PUSH   DE
        CALL   LDIR5
        POP    HL
        LD     DE,(SNFAC2)
        CALL   MUL
        EX     DE,HL
        LD     HL,(SNFAC0)
        CALL   ADD
        POP    HL
        LD     DE,5
        ADD    HL,DE
        POP    BC
        DJNZ   SIN6
        POP    HL
        POP    BC
        LD     A,(SINSGN)
        INC    HL
        XOR    M
        CPL
        LD     M,A
        DEC    HL
        LD     A,(PRCSON)
        CP     08H
        LD     A,M
        JR     Z,SIN9
        CP     5CH             ; ADJUST
SIN8:   RET    NC
        JP     CLRFAC
;
SIN9:   CP     4DH             ; ADJUST
        JR     SIN8
;
COSCUL: LD     DE,FLTHPI       ;PI/2
        CALL   SUB
        CALL   ABS
        POP    DE
        PUSH   HL
        PUSH   DE
        CALL   LDIR5
        POP    HL
        LD     E,L
        LD     D,H
        CALL   MUL
        LD     DE,(SNFAC2)
        CALL   LDIR1
        POP    DE
        PUSH   DE
        CALL   LDIR1
        LD     A,(PRCSON)
        LD     B,A
        LD     HL,COSTBL
        JR     SIN6

;
SINSGN: DEFS   1
;
;
TAN:    ENT
        PUSH   BC
        PUSH   HL
        CALL   ADDHL5
        EX     DE,HL
        LD     (SNFAC4),HL
        CALL   ADDHL5
        LD     (SNFAC5),DE
        POP    HL
        PUSH   HL
        CALL   LDIR5
        LD     HL,(SNFAC4)
        EX     DE,HL
        POP    HL
        PUSH   HL
        CALL   LDIR5
        LD     HL,(SNFAC5)
        CALL   SIN
        POP    DE
        PUSH   DE
        CALL   LDIR5
        LD     HL,(SNFAC4)
        CALL   COS
        EX     DE,HL
        POP    HL
        CALL   DIV
        POP    BC
        RET
;
SINTBL: DEF5   7E,AA,AA,AA,AB
        DEFW   AA7EH
        DEFW   AAAAH
        DEFB   ABH
        ENDM
        DEF5   7A,08,88,88,89
        DEFW   087AH
        DEFW   8888H
        DEFB   89H
        ENDM
        DEF5   74,D0,0D,00,D0
        DEFW   D074H
        DEFW   000DH
        DEFB   D0H
        ENDM
        DEF5   6E,38,EF,1D,2B
        DEFW   386EH
        DEFW   1DEFH
        DEFB   2BH
        ENDM
        DEF5   67,D7,32,2B,40
        DEFW   D767H
        DEFW   2B32H
        DEFB   40H
        ENDM
        DEF5   60,30,92,30,9D
        DEFW   3060H

        DEFW   3092H
        DEFB   9DH
        ENDM
        DEF5   58,D7,3F,9F,3A
        DEFW   D758H
        DEFW   9F3FH
        DEFB   3AH
        ENDM
        DEF5   50,4A,96,3B,82
        DEFW   4A50H
        DEFW   3B96H
        DEFB   82H
        ENDM
;
COSTBL: DEF5   80,80,00,00,00
        DEFW   8080H
        DEFW   0000H
        DEFB   00H
        ENDM
        DEF5   7C,2A,AA,AA,AB
        DEFW   2A7CH
        DEFW   AAAAH
        DEFB   ABH
        ENDM
        DEF5   77,B6,0B,60,B6
        DEFW   B677H
        DEFW   600BH
        DEFB   B6H
        ENDM
        DEF5   71,50,0D,00,D0
        DEFW   5071H
        DEFW   000DH
        DEFB   D0H
        ENDM
        DEF5   6B,93,F2,7D,BC
        DEFW   936BH
        DEFW   7DF2H
        DEFB   BCH
        ENDM
        DEF5   64,0F,76,C7,80
        DEFW   0F64H
        DEFW   C776H
        DEFB   80H
        ENDM
        DEF5   5C,C9,CB,A5,46
        DEFW   C95CH
        DEFW   A5CBH
        DEFB   46H
        ENDM
        DEF5   54,57,3F,9F,3A
        DEFW   5754H
        DEFW   9F3FH
        DEFB   3AH
        ENDM
;
TANTBL: DEF5   7F,AA,AA,AA,AB
        DEFW   AA7FH
        DEFW   AAAAH
        DEFB   ABH
        ENDM

        DEF5   7E,4C,CC,CC,CD
        DEFW   4C7EH
        DEFW   CCCCH
        DEFB   CDH
        ENDM
        DEF5   7E,92,49,24,92
        DEFW   927EH
        DEFW   2449H
        DEFB   92H
        ENDM
        DEF5   7D,63,8E,38,E4
        DEFW   637DH
        DEFW   388EH
        DEFB   E4H
        ENDM
        DEF5   7D,BA,2E,8B,A3
        DEFW   BA7DH
        DEFW   8B2EH
        DEFB   A3H
        ENDM
        DEF5   7D,1D,89,D8,9E
        DEFW   1D7DH
        DEFW   D889H
        DEFB   9EH
        ENDM
        DEF5   7D,88,88,88,89
        DEFW   887DH
        DEFW   8888H
        DEFB   89H
        ENDM
        DEF5   7C,70,F0,F0,F1
        DEFW   707CH
        DEFW   F0F0H
        DEFB   F1H
        ENDM
        DEF5   7C,D7,94,35,E5
        DEFW   D77CH
        DEFW   3594H
        DEFB   E5H
        ENDM
        DEF5   7C,43,0C,30,C3
        DEFW   437CH
        DEFW   300CH
        DEFB   C3H
        ENDM
;
;
SGN:    ENT
        LD     DE,0
        LD     A,M
        OR     A
        JR     Z,SGNSET
        CALL   TSTSGN
        INC    DE
        JR     Z,SGNSET
        DEC    DE
        DEC    DE
SGNSET: CALL   FLTHEX
        RET
;

;
RAD:    ENT
        LD     DE,FLTRAD
        JR     +5
PAI:    ENT
        LD     DE,FLTPAI
        PUSH   BC
        CALL   MUL
        POP    BC
        RET
;
FLT2PI: ENT
        DEF5   83,49,0F,DA,A2  ;PI*2
        DEFW   4983H
        DEFW   DA0FH
        DEFB   A2H
        ENDM
FLTPAI: ENT
        DEF5   82,49,0F,DA,A2  ;PI
        DEFW   4982H
        DEFW   DA0FH
       DEFB   A2H
        ENDM
FLTHPI: DEF5   81,49,0F,DA,A2  ;PI/2
        DEFW   4981H
        DEFW   DA0FH
        DEFB   A2H
        ENDM
FLTQPI: DEF5   80,49,0F,DA,A2  ;PI/4
        DEFW   4980H
        DEFW   DA0FH
        DEFB   A2H
        ENDM
;
FLTRAD: DEF5   7B,0E,FA,35,13
        DEFW   0E7BH
        DEFW   35FAH
        DEFB   13H
        ENDM
;
;
PEEK:   ENT
        PUSH   HL
        CALL   HLFLT
        LD     E,(HL)
        LD     D,0
        POP    HL
        CALL   FLTHEX
        RET
;
;
RND:    ENT
        LD     A,M
        OR     A
        JR     Z,RNDMIZ
        CALL   TSTSGN
        JR     Z,NORRND
RNDMIZ: PUSH   HL
        LD     HL,4193H
        LD     (SEED),HL

        POP    HL
        XOR    A
        LD     R,A
NORRND: PUSH   BC
        LD     DE,(SEED)
        LD     A,R
        XOR    D
        RRC    A
        RRC    A
        RRC    A
        LD     D,A
        LD     A,R
        XOR    E
        RLC    A
        RLC    A
        LD     E,D
        LD     D,A
        LD     (SEED),DE
        PUSH   HL
        INC    HL
        RES    7,D
        LD     M,D
        INC    HL
        LD     M,E
        INC    HL
        LD     A,R
        LD     M,A
        POP    HL
        LD     M,81H
        CALL   ONESUB
        POP    BC
        RET
SEED:   DEFW   4193H
;
EXP:    ENT
        PUSH   BC
        LD     A,M
        OR     A
        JP     Z,RETONE
        INC    HL
        LD     A,M
        LD     (EXPSIN),A
        RES    7,M
        DEC    HL
        LD     DE,LNTWO'
        CALL   MUL
        PUSH   HL
        CALL   ADDHL5
        PUSH   DE
        CALL   LDIR5
        POP    HL
        CALL   INT
        PUSH   HL
        CALL   HLFLT
        XOR    A
        CP     H
        JP     NZ,ER02
        LD     A,L
        LD     (EXPOFF),A
        POP    DE

        POP    HL
        PUSH   HL
        CALL   SUB
        PUSH   DE
        PUSH   HL
        CALL   LDIR1
        POP    DE
        POP    HL
        CALL   DIVTWO
        EX     DE,HL
        XOR    A
        LD     B,8
EXPLP1: PUSH   BC
        PUSH   AF
        CALL   CMP
        JR     C,EXPNL1
        CALL   SUB
        POP    AF
        SET    7,A
        PUSH   AF
EXPNL1: POP    AF
        RLC    A
        EX     DE,HL
        PUSH   AF
        CALL   DIVTWO
        POP    AF
        EX     DE,HL
        POP    BC
        DJNZ   EXPLP1
        LD     (EXPHBT),A
        PUSH   DE
        LD     DE,LNTWO
        LD     A,(PRCSON)
        BIT    3,A
        JR     NZ,+5
        LD     DE,LNTWOF
        CALL   MUL
        POP    DE
        PUSH   DE
        CALL   LDIR5
        POP    HL
        LD     A,(PRCSON)
        BIT    3,A
        JP     Z,EXPSKP
        CALL   MULTWO
        LD     DE,FLTEN
        CALL   ADD
        CALL   DIVTWO
        POP    DE
        PUSH   DE
        CALL   MUL
        LD     DE,FLTEN
        CALL   DIVTWO
        CALL   ADD
        CALL   MULTWO
        POP    DE
        PUSH   DE
        CALL   MUL
        LD     DE,FLT120
        CALL   MUL

        CALL   MULTWO
        CALL   ONEADD
        CALL   DIVTWO
        POP    DE
        PUSH   DE
        CALL   MUL
        CALL   ONEADD
        POP    DE
        PUSH   DE
        CALL   MUL
EXPSK': CALL   ONEADD
        EX     (SP),HL
        EX     DE,HL
        PUSH   DE
        CALL   LDIR1
        POP    HL
        LD     DE,EXDTBL
        LD     A,(EXPHBT)
        LD     B,8
EXPCLP: RLC    A
        JR     NC,SKPEXP
        PUSH   AF
        PUSH   BC
        CALL   MUL
        POP    BC
        POP    AF
SKPEXP: REP5   INC,DE
        INC    DE
        INC    DE
        INC    DE
        INC    DE
        INC    DE
        ENDM
        DJNZ   EXPCLP
        LD     A,(EXPOFF)
        ADD    A,M
        JP     C,ER02
        LD     M,A
        POP    DE
        CALL   MUL
        POP    BC
        LD     A,(EXPSIN)
        RLC    A
        RET    NC
        PUSH   BC
        PUSH   DE
        PUSH   HL
        CALL   LDIR5
        POP    DE
        PUSH   DE
        CALL   LDIR1
        POP    HL
        POP    DE
        CALL   DIV
        POP    BC
        RET
;
EXPSKP: POP    DE
        PUSH   DE
        CALL   MUL

        LD     A,M
        OR     A
        CALL   NZ,DIVTWO
        CALL   ADD
        JP     EXPSK'
;
EXPOFF: DEFS   1
EXPSIN: DEFS   1
EXPHBT: DEFS   1
;
LOGD:   ENT
        PUSH   BC
        CALL   LOG
        LD     DE,LOGE10
        CALL   MUL
        POP    BC
        RET
;
LOG:    ENT                    ;LN(HL)
        PUSH   BC
        CALL   TSTSGN
        JP     NZ,ER03
        LD     A,M
        OR     A
        JP     Z,ER03
        SUB    81H
        LD     (LOGEXP),A
        LD     M,81H
        XOR    A
        LD     B,8
        LD     DE,EXDTBL
LOGCLL: PUSH   BC
        PUSH   AF
        CALL   CMP
        JR     C,LOGNCL
        PUSH   HL
        LD     HL,40
        ADD    HL,DE
        EX     DE,HL
        EX     (SP),HL
        CALL   MUL
        POP    DE
        POP    AF
        SET    7,A
        PUSH   AF
LOGNCL: POP    AF
        RLC    A
        REP5   INC,DE
        INC    DE
        INC    DE
        INC    DE
        INC    DE
        INC    DE
        ENDM
        POP    BC
        DJNZ   LOGCLL
        LD     (SNFAC0),HL
        CALL   ADDHL5
        EX     DE,HL
        LD     E,A

        LD     D,0
        CALL   FLTHEX
        LD     A,M
        OR     A
        JR     Z,NOTDCR
        SUB    08H
        LD     M,A
NOTDCR: LD     A,(LOGEXP)
        CP     80H
        JR     C,+4
        NEG
        PUSH   HL
        CALL   ADDHL5
        EX     DE,HL
        LD     (SNFAC1),HL
        LD     E,A
        LD     D,0
        CALL   FLTHEX
        LD     A,(LOGEXP)
        AND    80H
        INC    HL
        OR     M
        LD     M,A
        DEC    HL
        EX     DE,HL
        POP    HL
        CALL   ADD
        LD     A,(PRCSON)
        LD     DE,LNTWO!
        CP     05H
        JR     Z,+5
        LD     DE,LNTWO
        CALL   MUL
        PUSH   HL
        LD     DE,(SNFAC1)
        LD     HL,(SNFAC0)
        PUSH   HL
        PUSH   DE
        CALL   LDIR5
        POP    HL
        CALL   ONEADD
        EX     (SP),HL
        CALL   SUB
        POP    DE
        CALL   DIV
        PUSH   DE
        CALL   LDIR5
        POP    HL
        PUSH   DE
        LD     E,L
        LD     D,H
        CALL   MUL
        POP    DE
        PUSH   HL
        PUSH   DE
        CALL   LDIR5
        POP    HL
        LD     DE,LOGDAT
        CALL   ADD
        EX     DE,HL

        POP    HL
        CALL   MUL
        LD     DE,FLTEN
        CALL   MULTWO
        CALL   ADD
        CALL   DIVTWO
        EX     DE,HL
        LD     HL,(SNFAC0)
        CALL   MUL
        LD     DE,FLTHR'
        CALL   MUL
        POP    DE
        CALL   ADD
       POP    BC
        RET
;
LOGEXP: DEFS   1
;
;
LOGE10: DEF5   7F,5E,5B,D8,A9
        DEFW   5E7FH
        DEFW   D85BH
        DEFB   A9H
        ENDM
;
;
FLTHR': DEF5   7F,4C,CC,CC,CD
        DEFW   4C7FH
        DEFW   CCCCH
        DEFB   CDH
        ENDM
;
LOGDAT: DEF5   81,55,55,55,56
        DEFW   5581H
        DEFW   5555H
        DEFB   56H
        ENDM
;
EXDTBL: DEF5   81,35,04,F3,34  ;2^(1/2)
        DEFW   3581H
        DEFW   F304H
        DEFB   34H
        ENDM
        DEF5   81,18,37,F0,52  ;2^(1/4)
        DEFW   1881H
        DEFW   F037H
        DEFB   52H
        ENDM
        DEF5   81,0B,95,C1,E4  ;2^(1/8)
        DEFW   0B81H
        DEFW   C195H
        DEFB   E4H
        ENDM
        DEF5   81,05,AA,C3,68  ;2^(1/16)
        DEFW   0581H
        DEFW   C3AAH
        DEFB   68H
        ENDM
        DEF5   81,02,CD,86,99  ;2^(1/32)
        DEFW   0281H

        DEFW   86CDH
        DEFB   99H
        ENDM
        DEF5   81,01,64,D1,F4  ;2^(1/64)
        DEFW   0181H
        DEFW   D164H
        DEFB   F4H
        ENDM
        DEF5   81,00,B1,ED,50  ;2^(1/128)
        DEFW   0081H
        DEFW   EDB1H
        DEFB   50H
        ENDM
        DEF5   81,00,58,D7,D3  ;2^(1/256)
        DEFW   0081H
        DEFW   D758H
        DEFB   D3H
        ENDM
        DEF5   80,35,04,F3,34
        DEFW   3580H
        DEFW   F304H
        DEFB   34H
        ENDM
        DEF5   80,57,44,FC,CB
        DEFW   5780H
        DEFW   FC44H
        DEFB   CBH
        ENDM
        DEF5   80,6A,C0,C6,E8
        DEFW   6A80H
        DEFW   C6C0H
        DEFB   E8H
        ENDM
        DEF5   80,75,25,7D,16
        DEFW   7580H
        DEFW   7D25H
        DEFB   16H
        ENDM
        DEF5   80,7A,83,B2,DC
        DEFW   7A80H
        DEFW   B283H
        DEFB   DCH
        ENDM
        DEF5   80,7D,3E,0C,0D
        DEFW   7D80H
        DEFW   0C3EH
        DEFB   0DH
        ENDM
        DEF5   80,7E,9E,11,5D
        DEFW   7E80H
        DEFW   119EH
        DEFB   5DH
        ENDM
        DEF5   80,7F,4E,CB,5A
        DEFW   7F80H
        DEFW   CB4EH
        DEFB   5AH
        ENDM
;
FLT120: DEF5   7A,08,88,88,89

        DEFW   087AH
        DEFW   8888H
        DEFB   89H
        ENDM
;
LNTWO:  DEF5   80,31,72,17,F8
        DEFW   3180H
        DEFW   1772H
        DEFB   F8H
        ENDM
;
LNTWOF: DEF5   80,31,72,17,F8
        DEFW   3180H
        DEFW   1772H
        DEFB   F8H
        ENDM
;
LNTWO': DEF5   81,38,AA,3B,2A  ;1/LN(2)
        DEFW   3881H
        DEFW   3BAAH
        DEFB   2AH
        ENDM
;
LNTWO!: DEF5   80,31,72,17,F8  ; *
        DEFW   3180H
        DEFW   1772H
        DEFB   F8H
        ENDM
;
;
SNFAC0: DEFS   2
SNFAC1: DEFS   2
SNFAC2: DEFS   2
SNFAC3: DEFS   2
SNFAC4: DEFS   2
SNFAC5: DEFS   2
;
        END

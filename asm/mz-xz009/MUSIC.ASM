; ---------------------------
; MZ-800 BASIC  Music command
; FI:MUSIC  ver 1.0A 7.18.84
; Programed by T.Miho
; ---------------------------
;
        INCLD  MACRO
;
DIRARE: EQU    27D0H
NMAX:   EQU    83              ;/ÙÄs max
;
;
; SOUND m,l /  SOUND=(r,d)
;
SOUND:  ENT
        TEST1  0F4H            ;=
        CALL   TEST1
        DEFB   0F4H
        ENDM
        JR     NZ,SOUND1
        CALL   HCH28H          ;(
        CALL   IBYTE
        CP     16
        SET    7,A
        JR     SOUND2
;
SOUND1: CALL   IBYTE
        CP     NMAX+1
SOUND2: JP     NC,ER03
        PUSH   AF
        CALL   HCH2CH          ;,
        CALL   IDEEXP
        POP    AF
        PUSH   AF
        OR     A
        CALL   M,HCH29H        ;)
        POP    AF
        PUSH   HL
        SVC    .SOUND
        RST    3
        DEFB   .SOUND
        ENDM
        POP    HL
        RET
;
; TEMPO n  (n= 1 to 7 )
;
TEMPO:  ENT
        CALL   IBYTE
        DEC    A
        CP     7
        INC    A
        JP     $TEMPO
        SKP    H

;
;;;;;;;;;;;;;;;;;;;;;
;
; NOISE  A1$;A2$,B1$;...
; MUSIC  A1$;A2$;...;A6$,B1$;...
;
NOISE:  ENT
        LD     A,08H           ;pattern (3)
        DEFB   1
;
MUSIC:  ENT
        LD     A,07H           ;pattern (0,1,2)
        LD     (MUNOF),A       ;channel pattern
        CALL   HLFTCH
        LD     B,3
        CP     BEH             ;WAIT
        JR     Z,MCTRL
        DEC    B
        CP     99H             ;STOP
        JR     Z,MCTRL
        CP     DCH             ;INIT
        JR     NZ,MUSIC1
;
        LD     DE,MUSCHO
        LD     B,4
        LD     A,2
        CALL   ?SETDE
MCTRL:  PUSH   HL
        SVC    .MCTRL
        RST    3
        DEFB   .MCTRL
        ENDM
        POP    HL
        INC    HL
        RET
;
MUSIC1: CALL   ENDCHK
        RET    Z
        XOR    A
        LD     (MUDNO),A
        LD     (MUCHNO),A
        LD     B,A
        LD     A,0DH
        LD     DE,DIRARE
        LD     (MMBU1A),DE
        LD     (DE),A
        CALL   ?SETDE
        LD     A,(MUNOF)
        LD     (MUNOF2),A
MUSI1:  LD     DE,MUNOF2
        LD     A,(DE)
        RRC    A
        LD     (DE),A
        PUSH   AF
        LD     B,0
        JR     NC,MUSI3
        CALL   HLFTCH
        CP     ";"
        JR     Z,MUSI3
        CALL   STREXP

MUSI3:  PUSH   HL
        LD     A,(MUCHNO)
        CP     4
        JP     Z,ER01          ;Ch no over
        INC    A
        LD     (MUCHNO),A
        INC    B
        JP     Z,ER05
        LD     A,(MUDNO)
        ADD    A,B
        JP     C,ER05          ;data no. over
        LD     (MUDNO),A
        LD     HL,(MMBU1A)
        CALL   LDHLDE
        LD     (MMBU1A),HL
        DEC    HL
        LD     M,0DH
        POP    HL
        POP    AF
        JR     NC,MUSI1
        CALL   ENDCHK
        JR     Z,MUSI4
        TEST1  ','
        CALL   TEST1
        DEFB   ','
        ENDM
        JR     Z,MUSI4
        TEST1  ';'
        CALL   TEST1
        DEFB   ';'
        ENDM
        JR     MUSI1
MUSI4:  PUSH   HL
        LD     HL,DIRARE
        LD     IX,HL
        LD     IY,MUSCHO
        LD     B,4
MUSI5:  PUSH   BC
        PUSH   HL
        LD     HL,IX
        LD     DE,DIRARE
        XOR    A
        SBC    HL,DE
        LD     (IY+4),L
        POP    HL
        LD     (MUSI6+1),SP
        CALL   MML.EN
MUSI6:  LD     SP,0            ;xxx
        POP    BC
        INC    HL
        INC    IY
        DJNZ   MUSI5
        LD     B,3
        SVC    .MCTRL          ;MWAIT
        RST    3
        DEFB   .MCTRL
        ENDM
MUSI8:  LD     BC,100H
        LD     HL,DIRARE
        LD     DE,DIRARE+700H

        LDIR
        LD     B,4
        LD     HL,MMCHDA
MUSDS:  LD     E,M
        LD     D,0
        INC    HL
        PUSH   HL
        LD     HL,DIRARE+700H
        ADD    HL,DE
        LD     A,M
        CP     0FFH
        JR     Z,MUSDS1
        LD     A,4
        SUB    B
        PUSH   BC
        EX     DE,HL
        SVC    .PLAY
        RST    3
        DEFB   .PLAY
        ENDM
        POP    BC
MUSDS1: POP    HL
        DJNZ   MUSDS
        LD     B,1
        SVC    .MCTRL          ;PSGON
        RST    3
        DEFB   .MCTRL
        ENDM
;
        POP    HL
        JP     MUSIC1
;
MUSCHO: DEFW   0202H           ;Oct data eny ch.
        DEFW   0202H
MMCHDA: DEFS   4               ;Play & Noise Data addr
;
MUDNO:  DEFS   1               ;total data No.
MUCHNO: DEFS   1               ;ch no.
MMBU1A: DEFS   2               ;MML data buffer
MUNOF:  DEFS   1               ;07:MUSIC 08:NOISE
MUNOF2: DEFS   1               ;rotate(MUNOF)
;
        SKP    H

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; MML(HL) => IOCSM(IX) trans
; END code=00H or 0DH or C8H
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
MML.EN: CALL   MML.WC
MML.E0: CALL   HLFTCH
        CALL   MMAGCH
        JR     C,MMTCAL
        LD     C,0
        CALL   MML.AG          ;String:A-G
        JR     MMTCA9
;
MMTCAL: CALL   MMENCH
        JP     Z,MMLEND
        LD     B,12
        EX     DE,HL
        LD     HL,MMTCAT       ;Call address table
MMTCA0: CP     M               ;cmp chr
        INC    HL
        JR     Z,MMTCAJ
        DEC    B
        JP     Z,ER03
        INC    HL
        INC    HL
        JR     MMTCA0
MMTCAJ: LD     C,M
        INC    HL
        LD     B,M
        EX     DE,HL
        INC    HL
        CALL   .BC
MMTCA9: JP     C,ER03
        JR     MML.E0
;
.BC:    PUSH   BC
        RET
;
MMTCAT: DEFM   '#'
        DEFW   MML.SH
        DEFM   '+'
        DEFW   MML.UO
        DEFB   D7H
        DEFW   MML.UO
        DEFM   '-'
        DEFW   MML.DO
        DEFB   CFH
        DEFW   MML.DO
        DEFM   'O'
        DEFW   MML.O
        DEFM   'N'
        DEFW   MML.N
        DEFM   'T'
        DEFW   MML.T
        DEFM   'V'
        DEFW   MML.V
        DEFM   'S'
        DEFW   MML.S

        DEFM   'M'
        DEFW   MML.M
        DEFM   'L'
        DEFW   MML.L
;
MML.DO: LD     C,-12           ;-
        DEFB   11H
;
MML.UO: LD     C,12            ;+
        TEST1  "#"
        CALL   TEST1
        DEFB   "#"
        ENDM
        JR     NZ,+3
        INC    C
        DEFB   11H
;
MML.SH: LD     C,1             ;#
        CALL   HLFTCH
        CALL   MMAGCH
        RET    C
MML.AG: LD     B,A
        INC    HL
        CALL   MML.DL
        CCF
        CALL   C,MML.L1
        RET    C
        LD     A,B
        CP     'R'
        JR     Z,MML.R
        PUSH   HL
        LD     HL,ONCTT-41H    ;A-G
        CALL   ADDHLA
        LD     B,(IY+0)
        INC    B
        LD     A,M
        POP    HL
        ADD    A,C
        SUB    12
        ADD    A,12
        DJNZ   -2
        JR     MML.N0
;
MML.R:  XOR    A
MML.R0: PUSH   AF
        CALL   MML.WO
        POP    AF
MML.W1: LD     (IX+0),A
        INC    IX
        RET
;
MML.O:  CALL   MML.DL          ;O
        JR     NC,+4
        LD     A,2
        CP     7
        CCF
        RET    C
        LD     (IY+0),A        ;oct No.
        RET
;

MML.N:  CALL   MML.DL          ;N
        RET    C
MML.N0: CP     NMAX+1
        CCF
        RET    C
        JR     MML.R0
;
MML.T:  CALL   MML.DL          ;T
        JR     NC,+4
        LD     A,4
        DEC    A
        CP     7
        CCF
        RET    C
        ADD    A,6AH
        LD     (MML.W),A
        RET
;
MML.V:  CALL   MML.DL          ;V
        JR     NC,+4
        LD     A,15
        CP     16
        CCF
        RET    C
        ADD    A,80H
        LD     (MML.W+1),A
        RET
;
MML.L:  CALL   MML.DL          ;L
        JR     NC,+4
        LD     A,5
MML.L1: CP     10
        CCF
        RET    C
MML.L2: ADD    A,60H
        LD     (MML.W+2),A
        RET
;
MML.S:  CALL   MML.DL          ;S
        RET    C
        CP     9
        CCF
        RET    C
        ADD    A,90H
        LD     (MML.W+3),A
        RET
;
MML.M:  CALL   MML.DL          ;M
        RET    C
        OR     A
        SCF
        RET    Z
        LD     B,A
        LD     C,0A0H
        LD     (MML.W+4),BC
        OR     A
        RET
;
;
MML.DL: CALL   HLFTCH

        CALL   MMENCH
        SCF
        CALL   NZ,TSTNUM
        RET    C               ;RET not number
        SVC    .DEASC
        RST    3
        DEFB   .DEASC
        ENDM
        JP     DCHECK
;
MMAGCH: CP     'R'             ;A-G & R check
        RET    Z
        CP     'A'
        RET    C
        CP     'H'
        CCF
        RET
;
MMENCH: OR     A
        RET    Z
        CP     0DH
        RET    Z
        CP     0C8H
        RET
;
MMLEND: CALL   MML.WO
        LD     A,FFH           ;Music Data end
        CALL   MML.W1
        JP     MUSI6
;
MML.WO: LD     DE,MML.W
        LD     B,6
        LD     A,(DE)
        OR     A
        CALL   NZ,MML.W1
        INC    DE
        DJNZ   -6
;
MML.WC: LD     DE,MML.W
        LD     B,6
        JP     ?CLRDE
;
;
ONCTT:  DEFB   9               ;A
        DEFB   11              ;B
        DEFB   0               ;C
        DEFB   2               ;D
        DEFB   4               ;E
        DEFB   5               ;F
        DEFB   7               ;G
;
MML.W:  DEFB   0               ;T
        DEFB   0               ;V
        DEFB   0               ;L
        DEFB   0               ;S
        DEFB   0               ;Mn
        DEFB   0
;
        END

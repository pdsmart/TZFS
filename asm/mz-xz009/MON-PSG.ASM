; ----------------------------
; MZ800-monitor  PSG handlar
; FI:MON-PSG  ver 001  7.26.84
; ----------------------------
;
        INCLD  MACRO
;
SYS:    EQU    1               ;0 MZ-1500 1 PLE
;
NMAX:   EQU    83              ;/Ÿƒs max
PSGA:   EQU    F2H
PSG3:   EQU    3F2H
PSG9:   EQU    9F2H
;
        IF     SYS
MUSCH:  EQU    6
MAXCH:  EQU    8
PSGALL: EQU    E9H
PSGOFF: EQU    4E9H
        ENDIF
;
        IF     SYS-1
MUSCH:  EQU    3
MAXCH:  EQU    4
PSGALL: EQU    F2H
PSGOFF: EQU    4F2H
        ENDIF
;----------------------------------
;
; INTM (music interrupt mode )
;0 no operation
;1 music or noise
;2 sound n.time
;
;----------------------------------
;
INTM:   ENT
        DEFB   0
SBUSY:  DEFB   0               ;music or noise only
INTC:   DEFB   0
;----------------------------------
;
;   sound out current tabel
;
;
;----------------------------------
;    tone 1a
;
STBL:   DEFB   80H             ;frequency (l)
        DEFB   00H             ;frequency (h)
        DEFB   9FH             ;attenation
;    tone 2a
        DEFB   A0H             ;frequency (l)
        DEFB   00H             ;frequency (h)
        DEFB   BFH             ;attenation
;    tone 3a
        DEFB   C0H             ;frequency (l)
        DEFB   00H             ;frequency (h)
STN0:   DEFB   DFH             ;attenation
;

        IF     SYS
;    tone 1b
;
        DEFB   80H             ;frequency (l)
        DEFB   00H             ;frequency (h)
        DEFB   9FH             ;attenation
;    tone 2b
        DEFB   A0H             ;frequency (l)
        DEFB   00H             ;frequency (h)
        DEFB   BFH             ;attenation
;    tone 3b
        DEFB   C0H             ;frequency (l)
        DEFB   00H             ;frequency (h)
STN1:   DEFB   DFH             ;attenation
        ENDIF
        SKP    H

;----------------------------------
;
; play table
;
;----------------------------------
PTBL:   DEFB   00H             ;ch no.
        DEFB   00H             ;atc0
        DEFB   00H             ;atc1
        DEFB   00H             ;emva(l)
        DEFB   00H             ;emva(h)
        DEFB   00H             ;att
        DEFB   00H             ;length0
        DEFB   00H             ;tempo0
        DEFB   00H             ;length1
        DEFB   00H             ;tempo1
        DEFB   00H             ;qbuf(l)
        DEFB   00H             ;qbuf(h)
        DEFB   00H             ;emvp
        DEFB   00H             ;status
        DEFB   00H             ;vol
        DEFB   00H             ;reserve
        DEFB   01H             ;ch no.
        DEFS   15              ;ch1
        DEFB   02H             ;ch no.
        DEFS   15              ;ch2
        DEFB   03H             ;ch no.
        DEFS   15              ;noise1
;
        IF     SYS
        DEFB   04H             ;ch no.
        DEFS   15              ;ch3
        DEFB   05H             ;ch no.
        DEFS   15              ;ch4
        DEFB   06H             ;ch no.
        DEFS   15              ;ch5
        DEFB   07H             ;ch no.
        DEFS   15              ;noise2
        ENDIF
;----------------------------------
;
;
;  ontyo     tabel
;
;----------------------------------
LTBL:   DEFB   1               ;0
        DEFB   2               ;1
        DEFB   3               ;2
        DEFB   4               ;3
        DEFB   6               ;4
        DEFB   8               ;5
        DEFB   12              ;6
        DEFB   16              ;7
        DEFB   24              ;8
        DEFB   32              ;9
;----------------------------------
;
;
; tempo tabel
;
;----------------------------------

        DEFB   23              ;1  64
        DEFB   20              ;2  74
        DEFB   17              ;3  90
        DEFB   13              ;4  114
        DEFB   10              ;5  152
        DEFB   7               ;6  222
        DEFB   3               ;7  450
        SKP    H

;----------------------------------
;    emvelop pattern tabel
;
;    ATT ¿Ÿ€€Ÿ    code
;
;           0        3
;          -1        4
;          +1        5
;           r        0
;         max        1
;         min        2
;----------------------------------
ETBL:   DEFB   00H             ;emvp 0
        DEFB   05H
        DEFB   03H
        DEFB   03H             ;dummy
;
        DEFB   0FH             ;emvp 1
        DEFB   04H
        DEFB   01H
        DEFB   03H             ;dummy
;
        DEFB   00H             ;emvp 2
        DEFB   05H
        DEFB   02H
        DEFB   00H
;
        DEFB   0FH             ;emvp 3
        DEFB   04H
        DEFB   01H
        DEFB   00H
;
        DEFB   00H             ;emvp 4
        DEFB   05H
        DEFB   02H
        DEFB   03H
;
        DEFB   0FH             ;emvp 5
        DEFB   04H
        DEFB   03H
        DEFB   03H             ;dummy
;
        DEFB   00H             ;emvp 6
        DEFB   05H
        DEFB   04H
        DEFB   00H
;
        DEFB   0FH             ;emvp 7
        DEFB   04H
        DEFB   05H
        DEFB   00H
;
        DEFB   00H             ;emvp 8
        DEFB   03H
        DEFB   03H
        DEFB   00H
        SKP    H

;----------------------------------
;
;  frequency tabel
;
;----------------------------------
NTBL:   DEFW   3F00H           ; A
        DEFW   3B07H           ; A#
        DEFW   3802H           ; B
;
;      octave 1
;
        DEFW   340FH           ; C
        DEFW   3200H           ; C#
        DEFW   2F03H           ; D
        DEFW   2C09H           ; D#
        DEFW   2A01H           ; E
        DEFW   270BH           ; F
        DEFW   2507H           ; F#
        DEFW   2306H           ; G
        DEFW   2106H           ; G#
        DEFW   1F08H           ; A
        DEFW   1D0CH           ; A#
        DEFW   1C01H           ; B
;
;      octave 2
;
        DEFW   1A08H           ; C
        DEFW   1900H           ; C#
        DEFW   1709H           ; D
        DEFW   1604H           ; D#
        DEFW   1500H           ; E
        DEFW   130DH           ; F
        DEFW   120CH           ; F#
        DEFW   110BH           ; G
        DEFW   100BH           ; G#
        DEFW   0F0CH           ; A
        DEFW   0E0EH           ; A#
        DEFW   0E00H           ; B
;
;      octave 3
;
        DEFW   0D04H           ; C
        DEFW   0C08H           ; C#
        DEFW   0B0DH           ; D
        DEFW   0B02H           ; D#
        DEFW   0A08H           ; E
        DEFW   090FH           ; F
        DEFW   0906H           ; F#
        DEFW   080DH           ; G
        DEFW   0805H           ; G#
        DEFW   070EH           ; A
        DEFW   0707H           ; A#
        DEFW   0700H           ; B
;
;      octave 4
;
        DEFW   060AH           ; C
        DEFW   0604H           ; C#
        DEFW   050EH           ; D
        DEFW   0509H           ; D#

        DEFW   0504H           ; E
        DEFW   040FH           ; F
        DEFW   040BH           ; F#
        DEFW   0407H           ; G
        DEFW   0403H           ; G#
        DEFW   030FH           ; A
        DEFW   030BH           ; A#
        DEFW   0308H           ; B
;
;      octave 5
;
        DEFW   0305H           ; C
        DEFW   0302H           ; C#
        DEFW   020FH           ; D
        DEFW   020DH           ; D#
        DEFW   020AH           ; E
        DEFW   0208H           ; F
        DEFW   0205H           ; F#
        DEFW   0203H           ; G
        DEFW   0201H           ; G#
        DEFW   010FH           ; A
        DEFW   010EH           ; A#
        DEFW   010CH           ; B
;
;      octave 6
;
        DEFW   010AH           ; C
        DEFW   0109H           ; C#
        DEFW   0108H           ; D
        DEFW   0106H           ; D#
        DEFW   0105H           ; E
        DEFW   0104H           ; F
        DEFW   0103H           ; F#
        DEFW   0102H           ; G
        DEFW   0101H           ; G#
        DEFW   0100H           ; A
        DEFW   000FH           ; A#
        DEFW   000EH           ; B
;
;
;
MSTBL:  DEFW   BF9FH
        DEFW   FFDFH
;
;
;
TSOUT:  DEFB   80H             ;ch 0
        DEFB   00H
        DEFB   90H             ;att
TSOUTC: DEFB   00H             ;counter(l)
        DEFB   00H             ;counter(h)
        SKP    H

;----------------------------------
;
;
; Music interrupt routine
;
;
;----------------------------------
PSGINT: ENT
        PUSH   IY
        CALL   INT0
        POP    IY
        EI
        RETI
;
INT0:   CALL   PUSHRA
        CALL   MSTART          ;8253 intialize
;
        LD     A,(INTM)
        OR     A
        JP     Z,MSTOP0
        DEC    A
        JP     NZ,SDINT        ;skip if sound out
;
        LD     BC,PSG9         ;psg data out
        LD     HL,STBL
        OTIR
;
        IF     SYS
        LD     B,9
        INC    C
        OTIR
        ENDIF
;
        LD     B,8
        LD     A,(SBUSY)
        OR     A
        JP     Z,MSTOP0        ;channel all close
        LD     C,A
INT1:   DEC    B
        RET    M
        RLC    C
        JR     NC,INT1
        PUSH   BC
        LD     A,B
        CALL   INTER
        BIT    0,(IY+13)
        CALL   Z,NINT
        CALL   MINT
        POP    BC
        JR     INT1
        SKP    H

;----------------------------------
;
;  Emvelop     control
;
;----------------------------------
NINT:   DEC    (HL)            ;HL=chx act0
        RET    NZ
        INC    HL              ;new couter set
        LD     A,(HL)          ;load atc1
        DEC    HL
        LD     (HL),A          ;save atc0
        INC    HL
        INC    HL
        LD     E,(HL)          ;HL=enva
        INC    HL
        LD     D,(HL)          ;HL=enva+1
        EX     DE,HL
NINT1:  LD     A,(HL)          ;env ¿Ÿ€€Ÿ data
        OR     A               ;data check 0
        JR     NZ,NINT2        ;noskip if repeat
        DEC    HL
        DEC    HL
        JR     NINT1
;
;
NINT2:  EX     DE,HL           ;de=curent emva
        INC    HL
        DEC    A
        JR     Z,NINT3         ;skip if max Acc=1
        DEC    A
        JR     Z,NINT5         ;skip if min Acc=2
        DEC    A
        RET    Z               ;¿Ÿ€€Ÿ 0  Acc=3
;
        DEC    A               ;Acc=4
        LD     A,(HL)          ;att data
        JR     Z,NINT4         ;skip if dec att
        INC    A               ;Acc=5
        CP     15              ;max
        JR     Z,NINT7
        JR     C,NINT7
NINT3:  LD     A,15            ;maximam
        JR     NINT6
NINT4:  DEC    A               ;dec att
        JP     M,NINT5
        LD     C,(IY+14)       ;vol minimum
        CP     C
        JR     NC,NINT7
NINT5:  LD     A,(IY+14)       ;minimum
NINT6:  INC    DE              ;de=next curent emva
NINT7:  LD     (HL),A          ;new att data
        DEC    HL
        LD     (HL),D
        DEC    HL
        LD     (HL),E
;
ATTSET: AND    0FH
        LD     B,A             ;acc=att data
ATTS1:  LD     A,(IX+2)        ;stbl att
        AND    F0H

        OR     B
        LD     (IX+2),A        ;stbl att
        RET
        SKP    H

;----------------------------------
;
;    new data interpret routine
;
;----------------------------------
;
MINT:   DEC    (IY+6)          ;length0
        RET    NZ
        DEC    (IY+7)          ;tempo0
        LD     A,(IY+8)        ;length1
        LD     (IY+6),A        ;length counter preset
        RET    NZ
        LD     A,(IY+9)        ;tempo1
        LD     (IY+7),A        ;tempo counter preset
        LD     E,(IY+10)       ;que addr(l)
        LD     D,(IY+11)       ;que addr(h)
;
;
MINT1:  LD     A,(DE)
        INC    DE
        CP     FFH
        JR     Z,MINT2
        CP     A0H
        JR     Z,MINT3
        CP     90H
        JR     NC,MINT4
        CP     80H
        JR     NC,MINT5
        CP     60H
        JR     NC,MINT6
        SUB    9
        LD     (IY+10),E       ;que addr (l)
        LD     (IY+11),D       ;que addr (h)
        SET    0,(IY+13)       ;rflag set
        JR     C,MINT7
        RES    0,(IY+13)       ;rflag reset
        CALL   SETNO           ;Nn
MINT7:  LD     A,(IY+2)        ;att
        LD     (IY+1),A
        LD     A,(IY+8)        ;length
        LD     (IY+6),A
        LD     A,(IY+9)        ;tempo
        LD     (IY+7),A
        BIT    0,(IY+13)
        JR     NZ,MEND
;
;
        LD     A,(IY+12)       ;emv pattern
        LD     BC,ETBL
        ADD    A,A             ;*2
        ADD    A,A             ;*4
        LD     H,0
        LD     L,A
        ADD    HL,BC           ;HL=ETBL+4*A
        LD     A,(HL)
        OR     A
        JR     NZ,MINT71
        LD     A,(IY+14)       ;vol minimum
MINT71: LD     (IY+5),A        ;att
        CALL   ATTSET

        INC    HL
        LD     (IY+3),L        ;emva (l)
        LD     (IY+4),H        ;emva (h)
        RET
;
;
;
MINT3:  LD     A,(DE)          ;Mn
        INC    DE
        LD     (IY+2),A        ;atc1
MINT11: JR     MINT1
;
MINT2:  CALL   BRESET          ;channel reset
MEND:   LD     A,0FH
        JP     ATTSET
;
;
MINT4:  SUB    90H             ;Sn
        LD     (IY+12),A       ;curent emv no.
        JR     MINT11
;
;
MINT5:  SUB    80H             ;Vn
        CPL
        AND    0FH
        LD     (IY+14),A       ;vol minimum
        JR     MINT11
;
;
;  tempo  &  length
;
;
MINT6:  SUB    60H             ;Tn,Ln
        LD     B,0
        LD     C,A
        LD     HL,LTBL
        ADD    HL,BC
        CP     0AH
        LD     A,(HL)
        JR     NC,MINT61
        LD     (IY+8),A        ;length1
        JR     MINT11
MINT61: LD     (IY+9),A        ;tempo1
        JR     MINT11
        SKP    H

;--------------------------------
;
;
;    onpu  set
;
;     acc  = onpu map data
;     ix   = set mout tbladdr
;--------------------------------
;
SETNO:  ADD    A,A             ;*2
        LD     HL,NTBL
        LD     B,0
        LD     C,A
        ADD    HL,BC
        LD     B,(HL)
        LD     A,(IX+0)
        AND    F0H
        OR     B
        LD     (IX+0),A
        INC    HL
        LD     A,(HL)
        LD     (IX+1),A
        RET
;----------------------------------
;
;  SOUND=(reg,data)
;
;    ent A.... reg+80H
;        DE... data
;
;
;  SOUND n,time
;
;    ent A.... n
;        DE... time
;
;----------------------------------
;
MSOUND: ENT
        OR     A
        JP     P,SOUT
        AND    0FH
        LD     C,PSGA          ;psg-a
;
        IF     SYS
;
        CP     8
        JR     C,+5
        SUB    8
        INC    C               ;C=psg sel, A=reg#.
;
        ENDIF
;
        ADD    A,A
        ADD    A,A
        ADD    A,A
        ADD    A,A
        OR     80H
        LD     B,A             ;B = 1rrr0000
;

        BIT    4,A
        JR     NZ,MSND.A       ;att
        CP     E0H
        JR     Z,MSND.N        ;noise ctrl
        LD     A,D             ;freq
        CP     04H
        JR     NC,MER3
        LD     A,E
        AND    0FH
        OR     B               ;1rrrffff
        OUT    (C),A
        LD     A,D
        LD     B,4
        RL     E
        RLA
        DJNZ   -3
        OUT    (C),A           ;0fffffff
        RET
;
MSND.N: BIT    3,E
        JR     NZ,MER3
MSND.A: LD     A,E
        AND    F0H
        OR     D
        JR     NZ,MER3
        LD     A,E
        OR     B
        OUT    (C),A           ;1rrrcccc
        RET
;
MER3:   JP     ER03
;
;--------------------------------
;
;    sout
;
;--------------------------------
;
SDINT:  LD     HL,(TSOUTC)
        DEC    HL
        LD     (TSOUTC),HL
        LD     A,L
        OR     H
        RET    NZ
        JP     MSTOP0
;
;
; SOUND n,l
;
;
SOUT:   ENT
        LD     C,A
        LD     A,D
        OR     E
        RET    Z
        LD     A,C
;
        LD     IX,TSOUT
        CP     NMAX+1
        RET    NC

        SUB    9
        PUSH   AF
        LD     A,90H
        JR     NC,SOUT1
        LD     A,9FH
SOUT1:  LD     (IX+2),A        ;TSOUT att
        CALL   MWAIT0
        POP    AF
        CALL   NC,SETNO        ;skip if not rest
        DI
        LD     A,2
        LD     (INTM),A
        LD     (TSOUTC),DE
        LD     HL,TSOUT
        LD     BC,PSG3         ;psg-a out
        OTIR
        CALL   MSTART
        EI
        RET
;
;--------------------------------
;
;     Interpret  point set
;
;
;   in Acc=channel
;
;   exit ix:stbl
;        iy:ptbl
;        hl:ptbl+1
;
;----------------------------------
INTER:  PUSH   BC
        PUSH   AF
        CP     3
        JR     C,INTER1
        DEC    A
;
        IF     SYS
        CP     6
        JR     NZ,INTER1
        DEC    A
        ENDIF
;
INTER1: LD     HL,STBL
        LD     B,A
        ADD    A,A             ;*2
        ADD    A,B             ;*3
        LD     C,A
        LD     B,0
        ADD    HL,BC
        PUSH   HL
        POP    IX
;
        POP    AF
        ADD    A,A             ;*2
        ADD    A,A             ;*4
        ADD    A,A             ;*8
        ADD    A,A             ;*16
        LD     HL,PTBL

        LD     B,0
        LD     C,A
        ADD    HL,BC
        PUSH   HL
        POP    IY
        INC    HL
        POP    BC
        RET
        SKP    H

;--------------------------------
;
;     play,noise
;
;--------------------------------
;
;
PLAY:   ENT
        CP     FFH
        JR     NZ,PLY0
        LD     A,MAXCH-1
PLYALL: PUSH   AF
        PUSH   DE
        CALL   PLY0
        POP    DE
        POP    AF
        DEC    A
        JP     M,PSGON
        JR     PLYALL
;
PLY0:   PUSH   AF
        LD     HL,STN0
        IF     SYS
        CP     4
        JR     C,PLY00
        LD     HL,STN1
        ENDIF
;
PLY00:  CP     3
        JR     Z,PLY1
;
        IF     SYS
        CP     7
        JR     Z,PLY1
        ENDIF
;
        LD     A,DFH
        JR     PLY2
;
PLY1:   LD     A,E7H           ;noise channel out
        OUT    (PSGALL),A
        LD     A,FFH
PLY2:   LD     (HL),A          ;STN0 or STN1
        DI
        LD     A,1
        LD     (INTM),A
        POP    AF
        CALL   INTER
        CALL   BSET
        CALL   MINT1
        EI
        RET
;
;
PSGON:  ENT
        DI
        LD     A,(INTM)
        OR     A
        CALL   NZ,MSTART
        EI

        RET
;
BRESET: LD     B,86H
        JR     BSET0
;
BSET:   LD     B,C6H
BSET0:  LD     HL,SBUSY
        LD     A,(IY+0)
        OR     A
        RLCA
        RLCA
        RLCA                   ;00xxx000
        OR     B               ;10xxx110 or 11xxx110
        LD     (BSET1),A
        DEFB   CBH             ;SET n,(HL) or reset
BSET1:  DEFB   0
        RET
        SKP    H

;----------------------------------
;
; sft+break or error or music stop
;
;----------------------------------
;
MLDSP:  ENT
MSTOP:  CALL   PUSHR
;
MSTOP0: XOR    A
        LD     (INTM),A
        LD     (SBUSY),A
;
        LD     BC,PSGOFF
        LD     HL,MSTBL
        OTIR
        LD     B,MUSCH
        LD     HL,STBL+2
MSTOP1: LD     A,(HL)
        AND    F0H
        OR     0FH
        LD     (HL),A
        INC    HL
        INC    HL
        INC    HL
        DJNZ   MSTOP1
        LD     A,3
        OUT    (FCH),A         ;pio disenable
        XOR    A
        IF     SYS-1
        RET                    ;8253 gate no effect
        ENDIF
;
        IF     SYS
        LD     HL,E008H        ;mz-700 compatible mode
        JP     LDHLA           ;8253 gate disable
        ENDIF
;
;----------------------------------
;
; music wait
;
;----------------------------------
;
MWAIT:  ENT
;
MWAIT0: LD     A,(INTM)
        OR     A
        RET    Z
MWAIT1: SVC    .BREAK
        RST    3
        DEFB   .BREAK
        ENDM
        JR     NZ,MWAIT
        JP     BREAKZ
        SKP    H

;----------------------------------
;  SVC .MCTRL ; music control
;    B=0: init
;    B=1: psgon
;    B=2: stop
;    B=3: wait
;----------------------------------
;
MCTRL:  ENT
        DEC    B
        JP     Z,PSGON
        DEC    B
        JR     Z,MSTOP         ;1
        DEC    B
        JR     Z,MWAIT0        ;2
;----------------------------------
;
; PSG power on init
;
;
;----------------------------------
PSGPWR: ENT
        CALL   MSTOP
        LD     BC,5FCH
        LD     HL,PIOTBL
        OTIR
        LD     DE,MUINID
        LD     A,FFH
        JP     PLAY
;
;
        IF     SYS
PIOTBL: DEFB   FCH             ;Vector
        DEFB   FFH             ;mode 3 (bit mode)
        DEFB   3FH             ;I/O
        DEFB   37H             ;interrupt control
        DEFB   EFH             ;interrupt mask
;
;
MSTART: OUT    (E3H),A
        LD     A,30H
        LD     HL,E007H
        LD     (HL),A          ;8253 control
        LD     BC,22A5H        ;10ms =22F6H
        LD     L,4             ;HL=E004H
        LD     (HL),C          ;8253 time const
        LD     (HL),B
        DEC    HL              ;HL=E003H
        LD     (HL),4          ;8253 int disable
        LD     (HL),0          ;8253 music disable
        LD     A,01H
        LD     L,8             ;HL=E008H
        LD     (HL),A          ;8253 gate enable
        LD     A,83H
        OUT    (FCH),A         ;pio int enable
        OUT    (E1H),A
        RET
        ENDIF
;
        IF     SYS-1

MSTART: 
        LD     HL,PIOTBL
        LD     BC,5FCH
        OTIR
        LD     HL,CTCTBL
        LD     B,6
        JP     IOOUT
;
;
PIOTBL: DEFB   FCH             ;Vector
        DEFB   FFH             ;mode 3 (bit mode)
        DEFB   3FH             ;I/O
        DEFB   17H             ;interrupt control
        DEFB   EFH             ;interrupt mask
;
CTCTBL: DEFW   D730H
        DEFW   D4B0H           ;10 ms =2B4CH
        DEFW   D42AH
        DEFW   D304H
        DEFW   D300H
        DEFW   FC83H
        ENDIF
;
MUINID: DEFB   65H             ;L5
        DEFB   6DH             ;T4
        DEFB   98H             ;S8
        DEFW   FFA0H           ;M255
        DEFB   FFH             ;END
        IF     SYS
;----------------------------------
;
;
; BELL (BEEP)  use 8253
;----------------------------------
CTRLG:  ENT
        CALL   PUSHR
        LD     (CTRLG9+1),SP
        SVC    .DI
        LD     SP,IBUFE
        OUT    (E4H),A         ;K/C mapping
        CALL   02BEH           ;ROM MLDSP
        LD     A,1
        LD     DE,E003H
        LD     (DE),A          ;8253 music gate on
        LD     HL,03F9H
        CALL   02AEH           ;ROM MLDST+3
        LD     BC,18H
        EX     (SP),HL         ;wait
        DJNZ   -1
        DEC    C
        JR     NZ,-4
        CALL   02BEH           ;ROM MLDSP
        XOR    A
        LD     (DE),A          ;8253 music gate off
        OUT    (E0H),A         ;K/C mapping
        OUT    (E1H),A
        SVC    .EI
CTRLG9: LD     SP,0            ;xxx
        RET
        ENDIF

;
        IF     SYS-1
;
CTRLG:  ENT
        CALL   PUSHR
        SVC    .DI
        RST    3
        DEFB   .DI
        ENDM
        LD     HL,BEEP0
        LD     B,4
        CALL   IOOUT
        LD     BC,18H
        EX     (SP),HL
        DJNZ   -1
        DEC    C
        JR     NZ,-4
        LD     HL,BEEP1
        LD     B,2
        CALL   IOOUT
        SVC    .EI
        RST    3
        DEFB   .EI
        ENDM
        RET
;
;
BEEP0:  
        DEFW   D736H
        DEFW   D301H
        DEFW   D4F9H
        DEFW   D403H
;
BEEP1:  
        DEFW   D736H
        DEFW   D300H
;--------------------------------
;
;        tempo set
;                  acc=1-7
;--------------------------------
?TEMP:  ENT
        CALL   PUSHRA
        LD     DE,TEMPOW
        AND    0FH
        ADD    A,69H
        LD     (DE),A
        LD     B,3
        SVC    .MCTRL          ;MWAIT
        RST    3
        DEFB   .MCTRL
        ENDM
        LD     A,FFH           ;Channel all
        SVC    .PLAY
        RST    3
        DEFB   .PLAY
        ENDM
        LD     B,1
        SVC    .MCTRL          ;PSGON
        RST    3

        DEFB   .MCTRL
        ENDM
        RET
;
TEMPOW: DEFS   1
        DEFB   FFH
;
        ENDIF
        END

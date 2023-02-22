; -------------------------------
; MZ-800 Monitor  Graphic-package
; FI:MON-GRPH  ver 1.0A 9.05.84
;
; -------------------------------
;
;
        INCLD  MACRO
KEYBF:  EQU    11A4H           ;KEYBUF label
;-------------------------------
;
; INIT "CRT:
;
;-------------------------------
CRTINI: ENT
        TEST1  'M'
        CALL   TEST1
        DEFB   'M'
        ENDM
        JR     Z,CRMD
        OR     A
        JR     Z,ICRT
        CP     'B'
        JP     NZ,ER03
;-------------------------------
;
; CRT palette block
;
;-------------------------------
;
PBLOCK: XOR    A
        LD     (PALBK),A
        LD     A,(CRTMD2)
        CP     2
        JP     NZ,ER68
        INC    HL
        LD     B,4
        CALL   DEVASC
        LD     (PALBK),A
        SVC    .DPLBK
        RST    3
        DEFB   .DPLBK
        ENDM
        JR     CRTLP
;
;---------------------------------
;
; CRT mode
;
; 1.....320x200 4 Color
; 2.....320x200 16 Color
; 3.....640x200 2 Color
; 4.....640x200 4 Color
;
;---------------------------------
;
CRMD:   LD     B,5
        CALL   DEVASC
        OR     A
        JR     Z,ER3JP

        LD     B,A
        SVC    .DSMOD
        RST    3
        DEFB   .DSMOD
        ENDM
        JP     C,ER68
        LD     A,B
        LD     (CRTMD2),A
        XOR    A
        LD     (INPFLG),A
        SCF
        ADC    A,A
        DJNZ   -1
        LD     (CRTMD1),A
        CALL   ICRT2
;
CRTLP:  TEST1  0
        CALL   TEST1
        DEFB   0
        ENDM
        RET    Z
        CP     ','
        INC    HL
        JR     Z,CRTINI
ER3JP:  JP     ER03
;
ICRT:   ENT
        LD     A,(CRTMD2)
        SVC    .DSMOD
        RST    3
        DEFB   .DSMOD
        ENDM
ICRT2:  CALL   COLINI
        XOR    A
        LD     (PALBK),A
        SVC    .DPLBK
        RST    3
        DEFB   .DPLBK
        ENDM
        RET
;
COLINI: LD     A,(CRTMD1)
        LD     B,3
        RRA
        JR     C,CI1
        LD     B,15
        RRA
        JR     C,CI1
        LD     B,1
        RRA
        JR     C,CI1
        LD     B,3
CI1:    LD     A,B
        LD     (SELCOL),A
        SVC    .DCOL
        RST    3
        DEFB   .DCOL
        ENDM
        RET
        SKP    H

;------------------------
;
;
; BYTE CONVERT TABLE
;
;-----------------------
TDOTL:  ENT
        DEFB   FFH
        DEFB   FEH
        DEFB   FCH
        DEFB   F8H
        DEFB   F0H
        DEFB   E0H
        DEFB   C0H
        DEFB   80H
;
TDOTR:  ENT
        DEFB   01H
        DEFB   03H
        DEFB   07H
        DEFB   0FH
        DEFB   1FH
        DEFB   3FH
        DEFB   7FH
        DEFB   FFH
;
TDOTN:  ENT
        DEFB   01H
        DEFB   02H
        DEFB   04H
        DEFB   08H
        DEFB   10H
        DEFB   20H
        DEFB   40H
        DEFB   80H
;-------------------------------
;
;   //  64 - 32  TRANS   //
;
;-------------------------------
;
CHGRPH: ENT
        LD     BC,703H
        LD     HL,CHGTBL
        JP     PATCH
;
;
CHGTBL: 
;    word patch table
;
        DEFW   SYMS42+1
        DEFW   BE80H
        DEFW   9F40H
;
        DEFW   RNGCK0+1
        DEFW   -640
        DEFW   -320
;
        DEFW   LRBSR
        DEFW   640

        DEFW   320
;
        DEFW   BFL0+1
        DEFW   80
        DEFW   40
;
        DEFW   BFL1+1
        DEFW   80
        DEFW   40
;
        DEFW   BFC0+1
        DEFW   -640
        DEFW   -320
;
        DEFW   BFC1+1
        DEFW   639
        DEFW   319
;
;    byte patch table
;
        DEFW   ADCH            ;adrs
        DEFB   29H             ;640 ADD HL,HL
        DEFB   00H             ;320
;
        DEFW   SYMS21+1
        DEFB   80
        DEFB   40
;
        DEFW   SYMS41+1
        DEFB   80
        DEFB   40
;
        SKP    H

;----------------------------------
;
;     address  calc
;
;
;       ent.   de=x (0-13FH,27FH)
;              hl=y (0-C7H)
;
;       ext.   hl=vram addr
;               a=vram bit
;               c=de/8
;----------------------------------
ADCH:   ADD    HL,HL           ;NOP
        LD     A,E
        AND    7
        LD     B,A
;
        LD     A,E
        AND    F8H
        ADD    A,D
        RRCA
        RRCA
        RRCA
        LD     C,A
        LD     A,B
        LD     B,80H           ;vramh
        LD     D,H
        LD     E,L
        ADD    HL,HL
        ADD    HL,HL
        ADD    HL,DE
        ADD    HL,HL
        ADD    HL,HL
        ADD    HL,HL           ;HL=HL*40
        ADD    HL,BC
        RET
;-----------------------------
;
;   READ  POINT
;
;    Ent:DE=X (0-13FH,27EH)
;        HL=Y (0-C7H)
;
;-----------------------------
?POINT: ENT
        CALL   RNGCK
        JP     C,OVER
        CALL   ADCH
;
        RLCA
        RLCA
        RLCA
        OR     46H
        LD     (PNT2+1),A
        LD     C,LSRF
        LD     A,(MAXCF)
        LD     B,A
;
        DI
        IN     A,(LSE0)

        XOR    A
PNT1:   RR     B
        JR     C,PNT4
        OUT    (C),B
        OR     A
PNT2:   BIT    0,(HL)          ;bit n,(hl)
        JR     Z,PNT3
        SCF
PNT3:   RLA
        JR     PNT1
;
PNT4:   LD     B,A
        IN     A,(LSE1)
        EI
        LD     A,(CPLANE)
        AND    B
        LD     B,A
        LD     A,(DMD)
        CP     6
        LD     A,B
        RET    NZ
;
        CP     4
        RET    C
;
        SUB    2
        RET
        SKP    H

;---------------------------------
;
;
;     MODE SET (PWMODE,GMODE)
;
;       ent.   A= 0  RESET
;              A<>0  SET
;---------------------------------
SETW:   LD     A,FFH
MODSET: PUSH   BC
        OR     A
        LD     A,(GMODE)
        LD     C,A
        LD     A,(PWMODE)
        JR     Z,RESET
;
SET:    OR     A
        LD     A,C0H           ;w0 pset
        JR     Z,SET1
        LD     A,40H           ;w1 or
;
SET1:   OR     C
        OUT    (LSWF),A        ;Write mode set
        POP    BC
        RET
;
;
RESET:  OR     A
        LD     A,60H           ;w1 reset
        JR     NZ,SET1
;
        LD     A,(CPLANE)
        LD     B,A
        LD     A,C             ;reverse  color
        CPL
        AND    B               ;mask color
        OR     C0H             ;w0 pset mode
        OUT    (LSWF),A        ;Write mode set
        POP    BC
        RET
        SKP    H

;-----------------------------
;
; Point Write/Erase
;
;    Ent:DE=X (0-13FH,27EH)
;       HL=Y (0-C7H)
;
;-----------------------------
PSET:   ENT
        CALL   MODSET
PSET0:  CALL   RNGCK
        JP     C,OVER
        CALL   ADCH
        EX     DE,HL
        LD     HL,TDOTN
        LD     B,0
        LD     C,A
        ADD    HL,BC
        DI
        IN     A,(LSE0)
        LDI
        IN     A,(LSE1)
        EI
        XOR    A
        RET
;
;
;--------------------------------
;
; RANGE  CHECK
;
;    Ent:DE=X (0-13FH,27EH)
;        HL=Y (0-C7H)
;
;    ext:if over then  CF=1
;
;--------------------------------
RNGCK:  ENT
        PUSH   BC
        PUSH   DE
        PUSH   HL
        LD     A,H
        RLCA
        JR     C,RNGER
;
        LD     BC,-200
        ADD    HL,BC
        JR     C,RNGER
;
        LD     A,D
        RLCA
        JR     C,RNGER
;
        EX     DE,HL
RNGCK0: LD     BC,-640         ;-320
        ADD    HL,BC
RNGER:  POP    HL
        POP    DE
        POP    BC
        RET

;
;
        SKP    H

;------------------------------
;
; Draw  line
;
;    ent  DE':X0, DE:X
;         HL':Y0, HL:Y
;         A  := 0 BLINE
;             <>0  LINE
;
;    ext  DE':X
;         HL':Y
;-------------------------------
;
;
X0:     EQU    KEYBF           ;2
DX:     EQU    X0+2            ;2
XDIRE:  EQU    DX+2            ;1
Y0:     EQU    XDIRE+1         ;2
DY:     EQU    Y0+2            ;2
YDIRE:  EQU    DY+2            ;1
;
;
WLINE0: LD     A,FFH
WLINE:  ENT
        CALL   MODSET
        PUSH   DE
        PUSH   HL
        EXX
        LD     (X0),DE
        LD     (Y0),HL
        EXX
        PUSH   HL              ;y
        PUSH   DE              ;x
        EX     DE,HL
        LD     HL,(Y0)
        CALL   PLS
        LD     (YDIRE),A
        LD     (DY),HL
        POP    DE              ;x
        JP     NC,WYLIN        ;skip if y=y0
        PUSH   HL              ;dy
        LD     HL,(X0)
        CALL   PLS
        LD     (XDIRE),A
        LD     (DX),HL
        POP    BC              ;dy
        POP    DE              ;y
        JP     NC,WTLIN        ;skip if x=x0
        XOR    A
        SBC    HL,BC
        JR     NC,WLIN04       ;skip if dx>dy
        LD     HL,X0           ;parameter change
        LD     DE,Y0
        LD     B,5
WLIN02: LD     A,(DE)
        LD     C,M
        LD     M,A
        LD     A,C
        LD     (DE),A
        INC    HL

        INC    DE
        DJNZ   WLIN02
;
        LD     A,0EBH          ;ex de,hl
WLIN04: LD     (PLOT),A
        LD     (PLOT1),A
        LD     A,(YDIRE)
        AND    A
        LD     A,23H           ;inc hl
        JR     Z,DIRE1
        LD     A,2BH           ;dec hl
DIRE1:  LD     (PP2),A
;
        LD     A,(XDIRE)
        AND    A
        LD     A,13H           ;inc de
        JR     Z,DIRE2
        LD     A,1BH           ;dec de
DIRE2:  LD     (PP1),A
;
        EXX
        LD     HL,(DX)         ;initial parm set
        LD     D,H
        LD     E,L
        SRL    H
        RR     L
        LD     BC,(DY)
        EXX
;
        LD     HL,(Y0)         ;first point  set
        LD     DE,(X0)
        LD     BC,(DX)
;
PLOT:   EX     DE,HL           ;nop
        PUSH   HL
        PUSH   DE
        PUSH   BC
        CALL   PSET0
        POP    BC
        POP    DE
        POP    HL
PLOT1:  EX     DE,HL           ;nop
;
;
        DEC    BC
        LD     A,B
        INC    A
        JR     Z,FINW          ;skip if end of line
;
; pointer calc .
;
PP1:    DEFS   1               ;inc de/dec de
        EXX
        OR     A
        SBC    HL,BC
        EXX
        JP     NC,PLOT
        EXX
        ADD    HL,DE
        EXX

PP2:    DEFS   1               ;inc hl/dec hl
        JP     PLOT
;
;
FINW:   EXX
        POP    HL
        POP    DE
        EXX
        RET
;
WYLIN:  POP    HL              ;Y
WYLIN0: CALL   WBOXSB
        CALL   WBOXSB
        CALL   YLINE
        JR     FINW
;
WTLIN:  EX     DE,HL
        LD     DE,(X0)
        JR     WYLIN0
;
;
;
PLS:    LD     A,H
        ADD    A,40H
        LD     H,A
        LD     A,D
        ADD    A,40H
        LD     D,A
;
        OR     A
        SBC    HL,DE
        JR     C,PLS1
        LD     A,H
        OR     L
        RET    Z
OVER:   LD     A,FFH
        SCF
        RET
;
PLS1:   OR     A
        EX     DE,HL
        LD     HL,0
        SBC    HL,DE
        XOR    A
        SCF
        RET
        SKP    H

;-------------------------
;
;
;  Write sector
;
;-------------------------
;
WSECTR: CALL   WSPUT
        LD     HL,(POINTX)
        PUSH   HL
        PUSH   BC              ;POINTY
        EXX
        CALL   WSPUT
        LD     B,2
        JP     WBOX2
;
WSPUT:  POP    IX              ;Ret adrs
        EX     DE,HL
        CP     2
        CALL   Z,WSCTRH
        LD     BC,(POINTX)
        ADD    HL,BC
        PUSH   HL              ;X
        EX     DE,HL
        CP     1
        CALL   Z,WSCTRH
        LD     BC,(POINTY)
        ADD    HL,BC
        PUSH   HL              ;Y
        JP     (IX)
;
WSCTRH: BIT    7,H
        JP     Z,HIRITU
        CALL   WSCTRV
        CALL   HIRITU
WSCTRV: EX     AF,AF'
        CALL   NEGHL
        EX     AF,AF'
        RET
        SKP    H

;
;-----------------------------
;
; Circle Write
;  ent DE:End X    DE':Start X
;      HL:End Y    HL':Start Y
;      IX:R        BC':Hiritu
;      A:Angle flag
;      if CF then sector
;
;  uses KEYBUF
;-----------------------------
WCIRCL: ENT
        PUSH   AF
        CALL   SETW            ;set pwmode
        POP    AF
        PUSH   AF
        LD     (CIR3+1),IX     ;R
        LD     (SYUX),DE
        LD     (SYUY),HL
        EXX
        LD     (CIR.HF),BC
        LD     (KAIX),DE
        LD     (KAIY),HL
        LD     A,C             ;CIR.HF
        CALL   C,WSECTR
        LD     HL,(KAIX)
        LD     DE,(KAIY)
;ﾅ BLOCK NO."ﾙ\⌒/BL \ﾄﾙ
        CALL   BLCKRU
        LD     (KBL),A
        LD     HL,(SYUX)
        LD     DE,(SYUY)
;ﾅ BLOCK NO."ﾙ\⌒/SBL \［ﾄﾙ
        CALL   BLCKRU
        LD     (SBL),A
;
        LD     HL,CIR.BK
        LD     B,8
        CALL   ?CLRHL
        LD     HL,KBL
        POP    AF
        LD     B,A
        AND    0FH
        JR     Z,CIR4          ;KK=SK
        CP     3
        JR     Z,CIR15         ;2PI <= ABS(KK-SK)
        LD     A,M
        INC    HL
        CP     M
        JR     NZ,CIR4
        LD     A,B
        CP     81H
        JR     Z,CIR4
        JR     CIR14
;
CIR15:  LD     A,9
        LD     M,A
        INC    HL
        LD     M,A

CIR14:  LD     B,8
        LD     HL,CIR.BK
        INC    A
        CALL   ?SETHL
        LD     A,B0H           ;OR B
        CALL   CHENGE
        JR     CIR3
;
CIR4:   LD     A,A0H           ;AND B
        CALL   CHENGE
        LD     D,00H
        LD     HL,(KBL)
        LD     B,H
        LD     A,L
CIR2:   LD     HL,CIR.BK-1
        LD     E,A
        ADD    HL,DE
        LD     M,1
        CP     B               ;\s\ﾛﾛﾚjlﾄ \［ﾛﾛﾚjli ﾃ\l
        JR     Z,CIR3
        AND    7
        INC    A
        JR     CIR2
CIR3:   LD     HL,0            ;;;R
        LD     (DYY),HL
        LD     (XX),HL
        LD     HL,1
        LD     (CI.D),HL
        LD     (YY),HL
CIR7:   LD     HL,(DYY)
        LD     DE,(CI.D)
        XOR    A
        SBC    HL,DE
        LD     (DYY),HL
;
        LD     HL,(YY)
        DEC    HL
        LD     (CYE),HL
        LD     A,(CIR.HF)
        OR     A
        LD     DE,HL
        CALL   NZ,HIRITU
        CP     1
        JR     Z,+3
        EX     DE,HL
        LD     (YYY),DE
        LD     (YYHI),HL
;
        LD     HL,(XX)
        OR     A
        LD     DE,HL
        CALL   NZ,HIRITU
        CP     1
        JR     Z,+3
        EX     DE,HL
        LD     (XXX),DE
        LD     (XXHI),HL
;
        LD     HL,(XXX)
        CALL   NEGHL

        LD     (FUXX),HL       ;FUXX = -XXX
        LD     HL,(YYY)
        CALL   NEGHL
        LD     (FUYE),HL       ;FUYE = -YYY
        LD     HL,(YYHI)
        CALL   NEGHL
        LD     (FUYYHI),HL     ;FUYYHI = -YYHI
        LD     HL,(XXHI)
        CALL   NEGHL
        LD     (FUXXHI),HL     ;FUXXHI = -XXHI
        LD     HL,(CYE)
        CALL   NEGHL
        LD     (FUNOYE),HL     ;FUNOYE = -YE
;
        LD     HL,CIR.BK
        LD     A,M             ;BLOCK NO.1
        OR     A
        INC    HL
        JR     Z,P222
        EXX
        LD     HL,(XXX)
        LD     (PL1+1),HL
        LD     B,0
        LD     DE,(FUNOYE)
        BIT    7,D
        JR     Z,P12
        LD     A,(KBL)
        CP     1
        JR     NZ,P11
        LD     HL,(KAIY)
        XOR    A
        SBC    HL,DE
        JR     Z,P11
        JR     C,P12
P11:    INC    B
P12:    LD     A,(SBL)
        CP     1
        JR     NZ,P13
        LD     HL,(SYUY)
        XOR    A
        SBC    HL,DE
        JR     Z,P13
        JR     NC,P14
P13:    LD     A,1
P14:    AND    B
        JR     Z,P15
        LD     HL,(FUYYHI)
        CALL   PLALL
P15:    EXX
;
P222:   LD     A,M             ;BLOCK NO.2
        OR     A
        INC    HL
        JR     Z,P3
        EXX
        LD     B,0
        LD     HL,(YYY)
        LD     (PL1+1),HL
        LD     DE,(CYE)
        LD     A,(KBL)

        CP     2
        JR     NZ,P21
        LD     HL,(KAIX)
        XOR    A
        SBC    HL,DE
        JR     Z,P21
        JR     C,P22
P21:    INC    B
P22:    LD     A,(SBL)
        CP     2
        JR     NZ,P23
        LD     HL,(SYUX)
        XOR    A
        SBC    HL,DE
        JR     Z,P23
        JR     NC,P24
P23:    LD     A,1
P24:    AND    B
        JR     Z,P25
        LD     HL,(FUXXHI)
        CALL   PLALL
P25:    EXX
;
P3:     LD     A,M             ;BLOCK NO.3
        OR     A
        INC    HL
        JR     Z,P4
        EXX
        LD     B,0
        LD     HL,(FUYE)
        LD     (PL1+1),HL
        LD     DE,(FUNOYE)
        BIT    7,D
        JR     Z,P32
        LD     A,(KBL)
        CP     3
        JR     NZ,P31
        LD     HL,(KAIX)
        XOR    A
        SBC    HL,DE
        JR     Z,P31
        JR     C,P32
P31:    INC    B
P32:    LD     A,(SBL)
        CP     3
        JR     NZ,P33
        LD     HL,(SYUX)
        XOR    A
        SBC    HL,DE
        JR     Z,P33
        JR     NC,P34
P33:    LD     A,1
P34:    AND    B
        JR     Z,P35
        LD     HL,(FUXXHI)
        CALL   PLALL
P35:    EXX
;
P4:     LD     A,M             ;BLOCK NO.4
        OR     A

        INC    HL
        JR     Z,P5
        EXX
        LD     B,0
        LD     HL,(FUXX)
        LD     (PL1+1),HL
        LD     DE,(FUNOYE)
        LD     A,(KBL)
        CP     4
        JR     NZ,P41
        LD     HL,(KAIY)
        XOR    A
        SBC    HL,DE
        JR     Z,P41
        JR     NC,P42
P41:    INC    B
P42:    XOR    A
        BIT    7,D
        JR     Z,P44
        LD     A,(SBL)
        CP     4
        JR     NZ,P43
        LD     HL,(SYUY)
        XOR    A
        SBC    HL,DE
        JR     Z,P43
        JR     C,P44
P43:    LD     A,1
P44:    AND    B
        JR     Z,P45
        LD     HL,(FUYYHI)
        CALL   PLALL
P45:    EXX
;
P5:     LD     A,M             ;BLOCK NO.5
        OR     A
        INC    HL
        JR     Z,P6
        EXX
        LD     B,0
        LD     HL,(FUXX)
        LD     (PL1+1),HL
        LD     DE,(CYE)
        LD     A,(KBL)
        CP     5
        JR     NZ,P51
        LD     HL,(KAIY)
        XOR    A
        SBC    HL,DE
        JR     Z,P51
        JR     NC,P52
P51:    INC    B
P52:    LD     A,(SBL)
        CP     5
        JR     NZ,P53
        LD     HL,(SYUY)
        XOR    A
        SBC    HL,DE
        JR     Z,P53
        JR     C,P54

P53:    LD     A,1
P54:    AND    B
        JR     Z,P55
        LD     HL,(YYHI)
        CALL   PLALL
P55:    EXX
;
P6:     LD     A,M             ;BLOCK NO.6
        OR     A
        INC    HL
        JR     Z,P7
        EXX
        LD     B,0
        LD     HL,(FUYE)
        LD     (PL1+1),HL
        LD     DE,(FUNOYE)
        LD     A,(KBL)
        CP     6
        JR     NZ,P61
        LD     HL,(KAIX)
        XOR    A
        SBC    HL,DE
        JR     Z,P61
        JR     NC,P62
P61:    INC    B
P62:    XOR    A
        BIT    7,D
        JR     Z,P64
        LD     A,(SBL)
        CP     6
        JR     NZ,P63
        LD     HL,(SYUX)
        XOR    A
        SBC    HL,DE
        JR     Z,P63
        JR     C,P64
P63:    LD     A,1
P64:    AND    B
        JR     Z,P65
        LD     HL,(XXHI)
        CALL   PLALL
P65:    EXX
;
P7:     LD     A,M             ;BLOCK NO.7
        OR     A
        INC    HL
        JR     Z,P8
        EXX
        LD     HL,(YYY)
        LD     (PL1+1),HL
        LD     DE,(CYE)
        LD     B,0
        LD     A,(KBL)
        CP     7
        JR     NZ,P71
        LD     HL,(KAIX)
        XOR    A
        SBC    HL,DE
        JR     Z,P71
        JR     NC,P72

P71:    INC    B
P72:    LD     A,(SBL)
        CP     7
        JR     NZ,P73
        LD     HL,(SYUX)
        XOR    A
        SBC    HL,DE
        JR     Z,P73
        JR     C,P74
P73:    LD     A,1
P74:    AND    B
        JR     Z,P75
        LD     HL,(XXHI)
        CALL   PLALL
P75:    EXX
;
P8:     LD     A,M             ;BLOCK NO.8
        OR     A
        INC    HL
        JR     Z,PE
        EXX
        LD     HL,(XXX)
        LD     (PL1+1),HL
        LD     DE,(CYE)
        LD     B,0
        LD     A,(KBL)
        CP     8
        JR     NZ,P81
        LD     HL,(KAIY)
        XOR    A
        SBC    HL,DE
        JR     Z,P81
        JR     C,P82
P81:    INC    B
P82:    LD     A,(SBL)
        CP     8
        JR     NZ,P83
        LD     HL,(SYUY)
        XOR    A
        SBC    HL,DE
        JR     Z,P83
        JR     NC,P84
P83:    LD     A,1
P84:    AND    B
        JR     Z,P85
        LD     HL,(YYHI)
        CALL   PLALL
P85:    EXX
;
PE:     LD     HL,(DYY)        ;Zs"ﾙ\o
        BIT    7,H
        JR     Z,CIR10
        LD     DE,(YY)
        LD     HL,(XX)
        DEC    HL
        LD     (XX),HL
        BIT    7,H
        RET    NZ
        XOR    A
        SBC    HL,DE

        RET    C
        LD     HL,(XX)
        ADD    HL,HL
        LD     DE,(DYY)
        ADD    HL,DE
        LD     (DYY),HL
CIR10:  LD     HL,(YY)
        INC    HL
        LD     (YY),HL
        LD     HL,(CI.D)
        INC    HL
        INC    HL
        LD     (CI.D),HL
        JP     CIR7
;
;CIRCLE "ﾛﾛﾜ-ﾞﾙ
;
;BLOCK NUMBER Zﾙ\⌒ "ﾛﾛﾜ-ﾞﾙ
BLCKRU: PUSH   HL
        PUSH   DE
        CALL   ABSHL
        EX     DE,HL
        CALL   ABSHL
        EX     DE,HL
        OR     A
        SBC    HL,DE
        POP    DE
        POP    HL
        JR     C,BLCK1
        BIT    7,H
        JR     NZ,BLCK2
        BIT    7,D
        LD     A,8
        RET    Z
        LD     A,1
        RET
BLCK2:  BIT    7,D
        LD     A,5
        RET    Z
        LD     A,4
        RET
BLCK1:  BIT    7,H
        JR     NZ,BLCK5
        BIT    7,D
        LD     A,7
        RET    Z
        LD     A,2
        RET
BLCK5:  BIT    7,D
        LD     A,6
        RET    Z
        LD     A,3
        RET
;
ABSHL:  BIT    7,H
        RET    Z
NEGHL:  LD     A,H
        CPL
        LD     H,A
        LD     A,L

        CPL
        LD     L,A
        INC    HL
        RET
;
;PLOT ﾜ-ﾞﾙ
PLALL:  LD     DE,(POINTY)
        ADD    HL,DE
        LD     DE,65336
        LD     B,H
        LD     C,L
        ADD    HL,DE
        RET    C
PL1:    LD     HL,0000H        ;LKD HL,XXXXH
        LD     DE,(POINTX)
        ADD    HL,DE
        EX     DE,HL
        LD     HL,64896
        ADD    HL,DE
        RET    C
        LD     H,B
        LD     L,C
        JP     PSET0
;
;
;ﾃﾟﾜ Zs"ﾙ ﾜ-ﾞﾙ
HIRITU: ENT
        PUSH   AF
        PUSH   DE
        LD     B,8
        LD     C,L
        LD     E,H
        XOR    A
        LD     D,A
        LD     H,A
        LD     L,A
        EX     AF,AF'
        LD     A,(CIR.HD)
HR1:    RRA
        JR     NC,HR2
        ADD    HL,DE
        EX     AF,AF'
        ADD    A,C
        JR     NC,HR3
        INC    HL
HR3:    EX     AF,AF'
HR2:    SLA    C
        RL     E
        RL     D
        DJNZ   HR1
        EX     AF,AF'
        BIT    7,A
        JR     Z,+3
        INC    HL
        POP    DE
        POP    AF
        RET
;
CHENGE: LD     (P14),A
        LD     (P24),A

        LD     (P34),A
        LD     (P44),A
        LD     (P54),A
        LD     (P64),A
        LD     (P74),A
        LD     (P84),A
        RET
;
; work area
;
CI.D:   EQU    KEYBF           ;2
DYY:    EQU    CI.D+2          ;2
XX:     EQU    DYY+2           ;2
YY:     EQU    XX+2            ;2
CYE:    EQU    YY+2            ;2
KBL:    EQU    CYE+2           ;1 \ﾄﾙﾛ BLOCK NO.
SBL:    EQU    KBL+1           ;1 \［ﾄﾙﾛ BLOCK NO.
;
;
;ﾛﾛ CYE oﾛｺlym ﾀﾙ\
FUYE:   EQU    SBL+1           ;2
;ﾛﾛ XX oﾛｺlym ﾀﾙ\
FUXX:   EQU    FUYE+2          ;2
;ﾛﾛ CYE ﾃﾟﾜ oﾛｺlym ﾀﾙ\
FUYYHI: EQU    FUXX+2          ;2
;ﾛﾛ XX ﾃﾟﾜ oﾛｺlym ﾀﾙ\
FUXXHI: EQU    FUYYHI+2        ;2
;
FUNOYE: EQU    FUXXHI+2        ;2
;
CIR.BK: EQU    FUNOYE+2        ;9 Block data
;
;
KAIX:   EQU    CIR.BK+9        ;2 \ﾄﾙ X
KAIY:   EQU    KAIX+2          ;2 \ﾄﾙ Y
SYUX:   EQU    KAIY+2          ;2 \［ﾄﾙ X
SYUY:   EQU    SYUX+2          ;2 \［ﾄﾙ Y
XXHI:   EQU    SYUY+2          ;2 XXﾛ ﾃﾟﾜ DATA
YYHI:   EQU    XXHI+2          ;2 YEﾛ ﾃﾟﾜ DATA
;
XXX:    EQU    YYHI+2          ;2
YYY:    EQU    XXX+2           ;2
;
CIR.HF: EQU    YYY+2           ;1
CIR.HD: EQU    CIR.HF+1        ;1
;
        SKP    H

; ----------------------------
;
; Box Write
;    ext DE':xs, DE:xe
;        HL':ys, HL:ye
;
;        if CF then A:fill color
;
; ----------------------------
LSTA:   EQU    KEYBF
RSTA:   EQU    LSTA+2
SPBOX:  EQU    RSTA+2
;
WBOX:   ENT
        LD     (SPBOX),SP
        EX     AF,AF'
        CALL   WBOXSB
        CALL   WBOXSB
        EXX
        PUSH   DE              ;XS Upper
        PUSH   HL              ;YS
        PUSH   DE              ;XS Lower
        EXX
        PUSH   HL              ;YE
        PUSH   DE              ;XE Lower
        PUSH   HL              ;YE
        PUSH   DE              ;XE Upper
        EXX
        PUSH   HL              ;YS
        PUSH   DE              ;XS Upper Left
        PUSH   HL              ;YS
        EXX
        EX     AF,AF'
        CALL   C,BOXF          ;Box fill
        LD     B,4
WBOX2:  EXX
        POP    HL
        POP    DE
        EXX
WBOX4:  POP    HL
        POP    DE
        PUSH   BC
        CALL   WLINE0          ;Box bound
        POP    BC
        DJNZ   WBOX4
        RET
;
WBOXSB: EX     DE,HL
        LD     A,H             ;Compare HL,HL'
        EXX
        EX     DE,HL
        CP     H
        EXX
        JR     Z,WBOXS2
        RET    P
        JR     WBOXS4
WBOXS2: LD     A,L
        EXX
        CP     L
        EXX

        RET    NC
WBOXS4: PUSH   HL
        EXX
        EX     (SP),HL
        EXX
        POP    HL
        RET
;
;--------------------------
;
;  BOX FILL
;
;    ent DE':xs, DE:xe
;        HL':ys, HL:ye
;        A:fill color
;
;--------------------------
BOXF:   
        CALL   COLS            ;Fill Color Set
        LD     B,A
        LD     A,(GMODE)
        CP     B
        JR     NZ,BOXC
        LD     SP,(SPBOX)      ;line routions pop
BOXC:   LD     A,(PWMODE)
        OR     A
        LD     A,C0H           ;w0 pset
        JR     Z,BOXF0
        LD     A,40H           ;w0 or
BOXF0:  OR     B
        OUT    (LSWF),A        ;Write mode set
;
YLINE:  LD     A,H
        OR     D
        RET    M
        CALL   BFCHK
        LD     A,L             ;ye
;
        EXX                    ;hl=ys,de=xs
        BIT    7,H
        JR     Z,+5
        LD     HL,0
        BIT    7,D
        JR     Z,+5
;
        LD     DE,0
        EX     AF,AF'
        CALL   BFCHK
        RET    C
        EX     AF,AF'          ;ye
;
        INC    A
        SUB    L               ;acc=lines(ye-ys+1)
        RET    C
        RET    Z
        EX     AF,AF'          ;acc'=lines
;
        PUSH   HL              ;ye
        CALL   ADCH
        LD     (LSTA),HL

        EXX
        POP    HL              ;ye
        LD     B,A             ;left
        PUSH   BC
        CALL   ADCH
        POP    BC
        LD     (RSTA),HL
        LD     C,A             ;right
        LD     DE,(LSTA)
;
HLINE:  OR     A
        SBC    HL,DE
        JR     Z,BOXI
        DEC    HL
        INC    DE              ;next point
        LD     A,L
        OR     A
        CALL   NZ,BOXL         ;a' reserve
;
BOXH:   LD     HL,TDOTR
        LD     A,B
        LD     B,0
        ADD    HL,BC
        LD     L,(HL)
        LD     C,A
        LD     A,L
        LD     HL,TDOTL
        ADD    HL,BC
        LD     B,(HL)
;
;
        LD     DE,(RSTA)
        PUSH   BC
        CALL   BOXW
        POP    BC
        LD     DE,(LSTA)
        LD     A,B
        JR     BOXW
;
;
;
;
BOXI:   LD     HL,TDOTR
        LD     A,B
        LD     B,0
        ADD    HL,BC
        LD     C,A
        LD     A,FFH
        AND    (HL)
        LD     HL,TDOTL
        ADD    HL,BC
        AND    (HL)
;
;
BOXW:   
        LD     C,A
        EX     AF,AF'
        LD     B,A
        EX     AF,AF'
        EX     DE,HL

        DI
BFL0:   LD     DE,80           ;40
        IN     A,(LSE0)
BOXW1:  LD     (HL),C
        ADD    HL,DE
        DJNZ   BOXW1
        IN     A,(LSE1)
        EI
        RET
;
;
;
;
BOXL:   PUSH   BC
        EX     DE,HL           ;hl=start
        LD     B,A             ;yoko counter
        EX     AF,AF'
        LD     C,A             ;tate counter
        EX     AF,AF'
BFL1:   LD     DE,80           ;40
        DI
BOXL1:  PUSH   HL
        PUSH   BC
        IN     A,(LSE0)
        LD     A,FFH
BOXL0:  LD     (HL),A
        INC    HL
        DJNZ   BOXL0
        IN     A,(LSE1)
        POP    BC
        POP    HL
        ADD    HL,DE
        DEC    C
        JR     NZ,BOXL1
        EI
        POP    BC
        RET
;
;
        SKP    H

;-----------------------------
;
;    box fill range check
;
;-----------------------------
;
BFCHK:  LD     A,H
        OR     A
        JR     NZ,BFCHK0
        LD     A,199
        CP     L
        JR     NC,BFCHK1       ;skip if hl>199
BFCHK0: LD     HL,199
        SCF
BFCHK1: RRA                    ;push cf
        PUSH   HL
BFC0:   LD     HL,-640         ;-320
        ADD    HL,DE
        POP    HL
        JR     NC,BFCHK3       ;skip if de>639,319
BFC1:   LD     DE,639          ;319
        RET
;
BFCHK3: RLA                    ;pop cf
        RET
;-----------------------------
;
; Position check
;
;-----------------------------
POSCK:  ENT
        EXX
        CALL   RNGCK
        EXX
        RET    NC              ;OK
        LD     A,3
        JP     ERRORJ
;-----------------------------
;
; Position save
;
;-----------------------------
POSSV:  ENT
        EXX                    ;Position save
        LD     (POINTX),DE
        LD     (POINTY),HL
        EXX
        RET
        SKP    H

;----------------------------
;
;  SYMBOL
;
;    Ent. A:angle
;         B:string length
;         H:Y ratio
;         L:X ratio
;         DE:string address
;
;----------------------------
;
;
SBDTAP: DEFS   8
;
SDT0:   EQU    1200H
SDT7:   EQU    1207H
;
SCNT:   EQU    1208H           ;1
HCNT:   EQU    SCNT+1          ;1
VCNT:   EQU    HCNT+1          ;1
BCNT:   EQU    VCNT+1          ;1
;
STRAP:  EQU    BCNT+1          ;2
SDTAP:  EQU    STRAP+2         ;2
BDTAP:  EQU    SDTAP+2         ;2
;
DEFX0:  EQU    BDTAP+2         ;1
DEFY0:  EQU    DEFX0+1         ;1
DEFX8:  EQU    DEFY0+1         ;2
DEFY8:  EQU    DEFX8+2         ;2
;
PX:     EQU    DEFY8+2         ;2
PY:     EQU    PX+2            ;2
;
VADD:   EQU    PY+2            ;2
LDOT:   EQU    VADD+2          ;1
;
DEFX:   EQU    LDOT+1          ;1
DEFY:   EQU    DEFX+1          ;1
DEF8:   EQU    DEFY+1          ;2
;
NSDT:   EQU    DEF8+2          ;2
;
;
CLLADD: DEFW   LOD00
        DEFW   LOD90
        DEFW   LOD18
        DEFW   LOD27
;
;
SYMBOL: ENT
        PUSH   BC              ;string length
        PUSH   DE              ;string address
        LD     BC,PX
        LD     D,L
        LD     E,H
        BIT    0,A
        JR     Z,SYMB10        ;skip acc=0,2
;

        EX     DE,HL           ;exchange milti
        INC    BC
        INC    BC              ;bc=py
;
SYMB10: LD     (SYMB18+1),BC
        LD     (DEFX0),HL
        LD     H,0
        ADD    HL,HL
        ADD    HL,HL
        ADD    HL,HL           ;defx8=defx*8
        LD     (DEFX8),HL
;
        LD     L,E
        LD     H,0
        ADD    HL,HL
        ADD    HL,HL
        ADD    HL,HL           ;defy8=defy*8
        LD     (DEFY8),HL
;
;
;   set py ,def8
;
        LD     DE,0
        EX     DE,HL           ;de=defy8
        SBC    HL,DE           ;hl=-defy8
        LD     (DEF8),HL       ;def8=-defy8
        BIT    1,A
        JR     Z,SYMB11        ;skip if acc=0,1
;
        LD     (DEF8),DE       ;def8=defy8
SYMB11: OR     A               ;HL=-defy8
        JP     PO,SYMB12       ;skip if acc=1,2
;
        LD     HL,0
SYMB12: LD     DE,(POINTY)
        ADD    HL,DE           ;pointy or pointy-defy8
        LD     (PY),HL         ;set py
;
;
;     set px def8
;
;
        LD     DE,(DEFX8)
        LD     HL,0
        OR     A               ;de=defx8
        SBC    HL,DE           ;hl=-defx8
        BIT    0,A
        JR     NZ,SYMB13       ;skip if acc=1,3
        BIT    1,A
        LD     (DEF8),DE       ;DE=defx8
        JR     Z,SYMB13        ;skip if acc=0
        LD     (DEF8),HL       ;hl=-defx8
SYMB13: EX     DE,HL           ;de=-defx8
        LD     HL,(POINTX)
        BIT    1,A
        JR     Z,SYMB15        ;skip if acc=0,1
        ADD    HL,DE           ;pointx or pointx-defx8
SYMB15: LD     (PX),HL         ;set px
;
;   calc rotation program addr

;
        ADD    A,A
        LD     HL,CLLADD
        LD     D,0
        LD     E,A
        ADD    HL,DE
        LD     E,(HL)
        INC    HL
        LD     D,(HL)
        LD     (SYMS10+1),DE
;
        CALL   SETW            ;set pwmode
        POP    HL
        POP    BC
;
SYMB17: DEC    B               ;string count down
        RET    M
;
        PUSH   HL
        PUSH   BC
        CALL   SYMS
SYMB18: LD     HL,PX           ;py
        LD     E,(HL)          ;calc px(py)=px(py)+def8
        INC    HL
        LD     D,(HL)
        PUSH   HL
        LD     HL,(DEF8)
        ADD    HL,DE
        EX     DE,HL
        POP    HL
        LD     (HL),D
        DEC    HL
        LD     (HL),E          ;set next disp addr
        POP    BC
        POP    HL
        INC    HL              ;next string pointer
        JR     SYMB17
        SKP    H

;
; //  SYMBOL  SUB.   //
;
;
;
SYMS:   LD     IY,SCNT
        LD     A,(HL)          ;mz ascii -> display
        SVC    .?ADCN          ;font addr calc
        RST    3
        DEFB   .?ADCN
        ENDM
        LD     H,0
        LD     L,A
        ADD    HL,HL
        ADD    HL,HL
        ADD    HL,HL
        LD     A,10H
        ADD    A,H
        LD     H,A             ;hl=hl+1000H
;
        LD     DE,SBDTAP       ;xfer cg data
        LD     BC,8
        DI
        IN     A,(LSE0)
        LDIR
        IN     A,(LSE1)
        EI
;
        LD     B,8             ;rotation pro.
SYMS10: CALL   LOD00           ;LODXX
;
;
        LD     HL,808H
        LD     (HCNT),HL       ;set hcnt,vcnt
        LD     DE,(DEFX0)
        LD     (DEFX),DE
        LD     HL,(PX)
        BIT    7,H
        JR     Z,SYMS20        ;skip if PX>=0
;
        CALL   SSYMB
        RET    C               ;error position
;
;
SYMS11: EXX                    ;data area rotate
        LD     B,8
        LD     HL,SDT0
SYMS12: RLC    (HL)
        INC    HL
        DJNZ   SYMS12
        EXX
        DJNZ   SYMS11
;
        LD     HL,0
SYMS20: LD     (SYMS23+1),HL
        LD     A,F8H
        AND    L
        OR     H
        RRC    A
        RRC    A

        RRC    A
SYMS21: SUB    80              ;40
        RET    NC              ;buffer full check?
;
        LD     L,A             ;SEND DATA ADD.
        LD     H,11H
        LD     (BDTAP),HL
        LD     HL,(PY)
        XOR    A
        BIT    7,H
        JR     Z,SYMS22
;
        INC    IY
        CALL   SSYMB
        DEC    IY
        RET    C               ;error position
;
;
        LD     HL,0
        LD     A,8
        SUB    B
SYMS22: LD     (SYMS24+1),A
SYMS23: LD     DE,0            ;XXH
        PUSH   HL
        PUSH   DE
        CALL   RNGCK
        POP    DE
        POP    HL
        RET    C               ;error position
;
        CALL   ADCH
       LD     (VADD),HL
        LD     HL,TDOTN
        LD     D,0
        LD     E,A
        ADD    HL,DE
        LD     A,(HL)
        LD     (LDOT),A
SYMS24: LD     HL,SDT0
SYMS25: LD     DE,(BDTAP)
        LD     BC,(LDOT)       ;b defx c ldot
        XOR    A
        EXX
        LD     B,(IY+1)        ;hcnt
;
SYMS30: EXX
        LD     (DE),A
        XOR    A
;
        RRC    (HL)
        JR     NC,SYMS31
;
        LD     A,B1H           ;OR C
SYMS31: LD     (SYMS32),A
        LD     A,(DE)
;
SYMS32: OR     C               ;nop
        RLC    C
        JR     NC,SYMS33
        LD     (DE),A

        INC    E               ;next data addr
        JR     Z,SYMS34        ;skip if buffer full
        XOR    A
SYMS33: DJNZ   SYMS32
;
SYMS3A: LD     B,(IY+0AH)      ;defx0
        EXX
        DJNZ   SYMS30          ;hcnt
;
        EXX
        LD     (DE),A
        INC    E
;
SYMS34: DEC    E
        INC    L
        LD     (SDTAP),HL
        LD     HL,(BDTAP)
        EX     DE,HL
        XOR    A
        SBC    HL,DE
        INC    HL
        LD     (NSDT),HL
        LD     A,(DEFY)
        LD     B,A             ;loop counter set
;
SYMS40: EXX
        LD     DE,(VADD)
        LD     HL,(BDTAP)
        LD     BC,(NSDT)
        DI
        IN     A,(LSE0)
        OUT    (LSE0),A
        LDIR
        IN     A,(LSE1)
        EI
SYMS41: LD     DE,80           ;40
        LD     HL,(VADD)
        ADD    HL,DE
        LD     (VADD),HL       ;next disp addr
SYMS42: LD     DE,BE80H        ;9F40H
        OR     A
        SBC    HL,DE
        RET    NC              ;position error check
;
        EXX
        DJNZ   SYMS40
;
SYMS43: LD     A,(DEFY0)       ;
        LD     (DEFY),A        ;set loop counter
        LD     HL,(SDTAP)
        DEC    (IY+2)          ;VCNT
        JP     NZ,SYMS25
        RET
        SKP    H

;
;   //  rotation sub .   //
;
LOD00:  LD     HL,SBDTAP
        LD     DE,SDT0
        LD     C,B
        LD     B,0
        LDIR
        RET
;
;
LOD90:  LD     DE,SDT0
LOD901: EXX
        LD     HL,SBDTAP
        LD     B,8
        XOR    A
;
LOD902: RLC    (HL)
        RRA
        INC    HL
        DJNZ   LOD902
;
        EXX
        LD     (DE),A
        INC    DE
        DJNZ   LOD901
;
        RET
;
;
LOD18:  LD     DE,SDT7
        LD     HL,SBDTAP
;
LOD181: LD     A,(HL)
        EXX
        LD     C,A
        LD     B,8
        XOR    A
;
LOD182: RR     C
        RL     A
        DJNZ   LOD182
;
        EXX
        LD     (DE),A
        INC    HL
        DEC    DE
        DJNZ   LOD181
;
        RET
;
;
LOD27:  LD     DE,SDT7
LOD271: EXX
        LD     HL,SBDTAP
        XOR    A
        LD     B,8
;
LOD272: RLC    (HL)
        RLA

        INC    HL
        DJNZ   LOD272
;
        EXX
        LD     (DE),A
        DEC    DE
        DJNZ   LOD271
        RET
;
;   calc position
;
;
SSYMB:  LD     B,8
        LD     E,(IY+0AH)      ;defx0,defy0
        LD     D,0
;
SSYMB1: ADD    HL,DE
        BIT    7,H
        JR     Z,SSYMB2
        DJNZ   SSYMB1
SSYMB4: SCF
        RET
;
SSYMB2: LD     A,H
        OR     L
        JR     NZ,SSYMB3
        LD     L,E
        DEC    B
        JR     Z,SSYMB4
SSYMB3: LD     (IY+17H),L      ;defx,defy
        LD     (IY+1),B        ;HCNT,VCNT
        OR     A
        RET
        SKP    H

;
;-------------------------------
;
;
; PATTERN
;  ent A:Heighth
;      B:String length
;      H:Direction
;     DE:String adrs
;
;-------------------------------
POINTW: EQU    KEYBF           ;2
STRAD:  EQU    POINTW+2        ;2
PATDA1: EQU    POINTW+250
PATDA2: EQU    POINTW+251
PATDA3: EQU    POINTW+252
PATDA4: EQU    POINTW+263
;
;
CHARW:  ENT
        OR     A               ;no mode ?
        RET    Z               ;yes
        LD     (STRAD),DE
        LD     E,A             ;E'=Height
        LD     C,A             ;C'=Height(work)
        LD     A,H
        OR     A
        LD     A,23H           ;INC HL
        JR     NZ,PATT1        ;DOWN
;
        LD     A,2BH           ;DEC HL
PATT1:  LD     (PATTA),A
        LD     (PATTC),A
        LD     A,B
        OR     A               ;no string ?
        RET    Z               ;yes
;
        LD     HL,(POINTX)
        LD     A,07H
        AND    L
        LD     D,A
        EXX                    ;keep c',e',b',d'
        LD     HL,TDOTL
        LD     D,0
        LD     E,A
        ADD    HL,DE
        LD     A,(HL)
;
        LD     (PATTB+1),A     ;MASK DATA
;
PATT3:  LD     HL,(POINTY)
PATT4:  LD     (POINTW),HL     ;save (POINTY)
;
PATTB:  LD     C,FFH           ;C=mask data
        LD     HL,(STRAD)      ;read DATA
        LD     A,(HL)
;
        EXX                    ;keep c',e',b',d'
        LD     H,A
        LD     A,D

        OR     A               ;X=0 ?
        JR     Z,PATT6         ;yeS
PATT7:  RRC    H
        DEC    A
        JR     NZ,PATT7
PATT6:  LD     A,H
        EXX                    ;A=pattern data
;
        LD     HL,PATDA1
;
        LD     B,8             ;DATA sift
        LD     D,A
PATT80: SRL    D
        RLA
        DJNZ   PATT80
;
        LD     D,A             ;C^D
        AND    C
        LD     (HL),A          ;left set data
;
        LD     A,D
        CPL
        LD     B,A             ;B=CPL(D)=CPL(STRAD)
        AND    C               ;C^CPL(D)
        INC    HL
        LD     (HL),A          ;left reset data
;
        LD     A,C
        CPL
        LD     C,A
        AND    D               ;CPL(C)^D
        INC    HL
        LD     (HL),A          ;right set data
;
        LD     A,C
        AND    B               ;CPL(C)^CPL(D)
        INC    HL
        LD     (HL),A          ;right reset data
;
        LD     DE,(POINTX)
        LD     HL,(POINTW)
;
;
        PUSH   DE
        PUSH   HL
        EX     DE,HL           ;X=X+1
        LD     BC,8
        ADD    HL,BC
        EX     DE,HL
        LD     A,1             ;right mode
        CALL   PATT90
        POP    HL
        POP    DE
;
        XOR    A               ;left mode
        CALL   PATT90
;
;
        LD     HL,(STRAD)      ;next data
        INC    HL

        LD     (STRAD),HL
        EXX
        DJNZ   PATT5           ;B'
;
        DEC    C               ;C' X-->END
        EXX
        JP     Z,PATT70        ;X=X+8 & END
        LD     HL,(POINTW)
PATTC:  INC    HL              ;DEC HL
        LD     (POINTY),HL
;
        XOR    A               ;end
        RET
;
PATT5:  DEC    C               ;C'
        JR     NZ,PATT2        ;next Xposition
        LD     C,E             ;C' E'
        EXX
        CALL   PATT70          ;X=X+8
        JR     PATT3
;
;
PATT2:  EXX
        LD     HL,(POINTW)
PATTA:  INC    HL              ;DEC HL
        JR     PATT4
;
;     pointx+8
;
PATT70: LD     HL,(POINTX)
        LD     BC,8
        ADD    HL,BC
        LD     (POINTX),HL
        RET
;
;---------------------------
;
;     V-RAM write
;         non keep
;
;       A=0 ---->left
;         1 ---->right
;       DE=X positin
;       HL=y position
;---------------------------
ATT90: EX     AF,AF'          ;push AF
        CALL   RNGCK
        RET    C               ;address err
;
        CALL   ADCH            ;get V-RAM address
        LD     B,A             ;B=0 -->no right data
;          HL=V-RAM address
;
        LD     DE,PATDA1       ;(DE)=write data
        EX     AF,AF'          ;pop AF
        OR     A               ;left data ?
        JR     Z,PATT91        ;yes
;
        LD     A,B             ;non right data
        OR     A

        RET    Z
;
        INC    DE              ;DE,PATDA3
        INC    DE
PATT91: CALL   SETW            ;mode set
        DI
        IN     A,(LSE0)
        OUT    (LSE0),A        ;get V-RAM
        LD     A,(DE)          ;B=right data
        LD     (HL),A
        LD     A,(PWMODE)
        OR     A               ;OR mode ?
        JR     NZ,PATT92       ;YES
;
        LD     A,(CPLANE)      ;read color data
        OR     60H
        OUT    (LSWF),A
        INC    DE
        LD     A,(DE)          ;C=reset data
        LD     (HL),A
PATT92: IN     A,(LSE1)
        EI
        RET
;
        LIST
        INCLD  PAINT
;
; --------------------------------
;
;    PAINT   ROUTINE  ( 9.5/84 )
;
;
;            HL: COLOR ADD.
;            B : NUM. of COLOR
;
; -------------------------------
;
DIRAR:  EQU    27D0H
ENKYB:  EQU    12A0H
NDSP:   EQU    KEYBF           ;2
DSP:    EQU    NDSP+2          ;2
NSSP:   EQU    DSP+2           ;1
SSP:    EQU    NSSP+1          ;2
PBXL:   EQU    SSP+2           ;2
PBXR:   EQU    PBXL+2          ;2
;
Y:      EQU    PBXR+2          ;2
BXL:    EQU    Y+2             ;2
BXR:    EQU    BXL+2           ;2
DIRECT: EQU    BXR+2           ;1
JCONT:  EQU    DIRECT+1        ;1
JSAVE:  EQU    JCONT+1         ;1
JSAVE1: EQU    JSAVE+1         ;1
BUFF:   EQU    JSAVE1+1        ;11 DATA BUFF.
;
PEEK:   EQU    DIRAR           ;PROGRAM AREA
;
WORK:   EQU    Y
;
;

;  //  MAIN  ROUTINE   //
;
;
WPAINT: ENT
        LD     A,(GMODE)
        OR     C0H
        OUT    (LSWF),A        ;Write mode set
        EXX
        LD     DE,PEEK         ;MAKE PEEK ROUTINE
        LD     HL,DPEEK
        LD     BC,DPEEK1-DPEEK
        LDIR
        EXX
;
PAIN0:  LD     A,(HL)          ;     COLOR SELECT
        CALL   COLS            ;Bound Color Set
        OR     80H             ;SEARCH MODE SET
        LD     (DPEEK1+1),A
        INC    HL
        EXX
        LD     HL,DPEEK1
        LD     BC,DPEEK2-DPEEK1
        LDIR
        EXX
        DJNZ   PAIN0
;
        EXX
        LD     BC,DPEEK3-DPEEK2+1
        LDIR
        LD     HL,(TMPEND)
        LD     (DSP),HL
        LD     (CSAVE+2),HL
        LD     HL,(PAIWED)
        LD     DE,-6
        ADD    HL,DE
        LD     (SVDT0+1),HL
;
;
        LD     HL,(POINTX)
        DEC    HL
        LD     (BXL),HL        ;BXL=POINTX-1
        INC    HL
        INC    HL
        LD     (BXR),HL        ;BXR=POINTX+1
        DEC    HL
        EX     DE,HL
        LD     HL,0
        LD     (NDSP),HL
        LD     HL,(POINTY)
        LD     (Y),HL
        CALL   RNGCK
        CCF
        RET    NC              ;START OUT RANGE
;
        LD     (SOVER1),SP
        LD     SP,DIRAR+700H
;
;
        CALL   ADCH
        LD     DE,TDOTN

        PUSH   HL
        LD     H,0
        LD     L,A
        ADD    HL,DE
        LD     C,(HL)
        POP    HL
        CALL   PEEK
        AND    C
        JP     NZ,PAINCE       ;ON BOUND
;
        CALL   RBSR
        LD     (BXR),IX        ;SET R.BOUND
        CALL   LBSR
        LD     (BXL),IX        ;SET L.BOUND
        LD     A,FFH
        LD     (DIRECT),A      ;DOWN
        CALL   SVDT
        LD     HL,ENKYB
        LD     (SSP),HL
        XOR    A
        LD     (DIRECT),A
        LD     (NSSP),A
;
PAIN1:  LD     A,(DIRECT)
        CALL   CHDIR0
        LD     A,199
        CP     L
        JR     C,PAINA         ;OUT RANGE
;
        CALL   NBSRCH
        JR     C,PAINA         ;CLOSE
;
        LD     (JCONT),A
        AND    9
        CALL   NZ,PAIND
;
        CALL   CSAVE
        LD     A,(JSAVE)
        OR     A
        JR     NZ,PAINA
;
PAIN3:  CALL   PSRCH
        JR     Z,PAIN1
;
        LD     HL,(BXR)
        PUSH   HL
        PUSH   DE
        CALL   RBSR0
        LD     (BXR),IX
        CALL   SVDT
        POP    HL
        LD     (BXL),HL
        POP    HL
        LD     (BXR),HL
        JR     PAIN1
;
;
PAINA:  LD     HL,(DSP)
        DEC    HL
        LD     DE,-7

        LD     BC,(NDSP)
PAINA1: LD     A,B
        OR     C
        JR     Z,PAINC
;
        LD     A,0FH
        DEC    BC
        CP     (HL)
        ADD    HL,DE
        JR     Z,PAINA1
;
        INC    HL
        PUSH   HL
        LD     (PAINA2+1),HL
        LD     DE,WORK
        LD     BC,7
        LDIR
        EX     DE,HL
        LD     HL,(DSP)
        XOR    A
        POP    BC
        LD     (DSP),BC
        SBC    HL,DE
        JR     Z,PAINA3
;
        LD     B,H
        LD     C,L
PAINA2: LD     HL,00H          ;XXH
        EX     DE,HL
        LDIR
        LD     (DSP),DE
;
PAINA3: LD     HL,(NDSP)
        DEC    HL
        LD     (NDSP),HL
        JP     PAIN3
;
;
PAINC:  LD     HL,(NDSP)
        LD     A,L
        OR     H
        JR     NZ,PAINC0
;
PAINCE: LD     SP,(SOVER1)     ;END JOB
        RET
;
;
PAINC0: DEC    HL
        LD     (NDSP),HL
        LD     HL,(DSP)
        DEC    HL
        LD     DE,WORK+6
        LD     BC,7
        LDDR
        INC    HL
        LD     (DSP),HL
;
PAINC1: CALL   PSRCH
        JR     Z,PAINC
;

        CALL   RBSR0
        LD     (BXR),IX
        JR     PAINC1
;
;
PAIND:  LD     HL,PBXL         ;DATA SAVE
        LD     DE,BUFF
        CALL   PAIND3
        LD     A,(JCONT)
        BIT    0,A
        JR     Z,PAIND1
;
LTW:    LD     HL,(PBXL)
        LD     (BXR),HL
        CALL   TWR
        JR     C,LTW1          ;CLOSE
;
        BIT    0,A
        JR     NZ,LTW
;
LTW1:   CALL   PAIND2
        LD     A,(JCONT)
        CP     9
        RET    NZ
;
PAIND1: LD     HL,(PBXR)
        LD     (BXL),HL
        CALL   TWR
        JR     C,PAIND2
;
        BIT    3,A
        JR     NZ,PAIND1
;
PAIND2: LD     HL,BUFF
        LD     DE,PBXL
PAIND3: LD     BC,11
        LDIR
        RET
;
;
;
;     CHECK  SAVE  DATA
;
;
CSAVE:  LD     IY,00H          ;XXH
        LD     BC,(NDSP)
        LD     HL,00H
        LD     (JSAVE),HL      ;STATUS CLEAR
;
CSAVE1: CALL   DSAVE
        LD     A,(NSSP)
        OR     A
        RET    Z
;
        DEC    A
        LD     (NSSP),A
        LD     (CSAVE2+1),SP
        LD     SP,(SSP)
        POP    IY
        POP    BC

        POP    HL
        LD     (BXR),HL
        POP    HL
        LD     (BXL),HL
        LD     (SSP),SP
CSAVE2: LD     SP,00H          ;XXH
        JR     CSAVE1
;
;
DSAVE:  LD     A,B
        OR     C
        LD     (DSAVEC+1),BC
        JP     Z,DSAVE3
;
        LD     HL,(Y)
        LD     E,(IY+0)
        LD     D,(IY+1)
        XOR    A
        SBC    HL,DE
        JR     NZ,DSAVE2
;
        CALL   COMP
        CP     5
        JR     Z,DSAVE1
;
        CP     0FH
        JR     NZ,DSAVE4
;
        LD     L,(IY+2)        ;SBXL
        LD     H,(IY+3)
        LD     DE,(BXR)
        XOR    A
        SBC    HL,DE
        JR     NC,DSAVE2
;
        LD     HL,(BXL)
        PUSH   HL
        LD     L,(IY+2)
        LD     H,(IY+3)
        PUSH   HL
        LD     (BXL),HL
        LD     A,3
        CALL   ESAVE
        POP    HL
        LD     (BXR),HL
        POP    HL
        LD     (BXL),HL
        CALL   RBSR
        LD     (BXR),IX
        JR     DSAVE2
;
DSAVE1: LD     E,(IY+4)        ;SBXR
        LD     D,(IY+5)
        LD     HL,(BXL)
        XOR    A
        SBC    HL,DE
        JR     NC,DSAVE2
;
        LD     HL,(BXR)
        PUSH   HL

        LD     L,(IY+4)
        LD     H,(IY+5)
        PUSH   HL
        LD     (BXR),HL
        LD     A,4
        CALL   ESAVE
        POP    HL
        LD     (BXL),HL
        POP    HL
        LD     (BXR),HL
        CALL   LBSR
        LD     (BXL),IX
;
DSAVE2: LD     DE,7
        ADD    IY,DE
DSAVEC: LD     BC,00H          ;XXH
        DEC    BC
        JP     DSAVE
;
DSAVE3: LD     A,(JSAVE1)
        OR     A
        CALL   NZ,SVDT
        RET
;
DSAVE4: EX     AF,AF'
        LD     A,0FH
        LD     (JSAVE),A
        EX     AF,AF'
        OR     A
        JR     NZ,DSAVE5
;
        LD     A,0FH
        LD     (IY+6),A
        RET
;
DSAVE5: CP     1
        JR     NZ,DSAVE6
;
        LD     L,(IY+4)        ;SBXR
        LD     H,(IY+5)
        LD     (BXL),HL
        CALL   LBSR
        LD     (BXL),IX
        JR     DSAVE8
;
DSAVE6: CP     0CH
        JR     NZ,DSAVE9
;
DSAVE7: LD     L,(IY+2)        ;SBXL
        LD     H,(IY+3)
        LD     (BXR),HL
        CALL   RBSR
        LD     (BXR),IX
DSAVE8: LD     A,0FH
        LD     (IY+6),A
        LD     (JSAVE1),A      ;SAVE DATA AFTER JOB
        JR     DSAVE2
;
;
DSAVE9: CP     0DH

        JP     NZ,ESAVE
;
        LD     A,(NSSP)
        INC    A
        CP     27
        CCF
        JP     C,SOVER         ;STACK OVER
;
        LD     (NSSP),A
        LD     HL,(BXL)
        PUSH   HL              ;SAVE BXL
        LD     L,(IY+4)
        LD     H,(IY+5)
        LD     (BXL),HL
        CALL   LBSR
        LD     (DSAVEB+2),IY
        LD     DE,7
        ADD    IY,DE
        LD     BC,(DSAVEC+1)
        DEC    BC
        LD     (DSAVEA+1),SP
        LD     SP,(SSP)
        PUSH   IX              ;BXL
        LD     DE,(BXR)
        PUSH   DE
        PUSH   BC
        PUSH   IY
        LD     (SSP),SP
DSAVEA: LD     SP,00H          ;XXH
DSAVEB: LD     IY,00H          ;XXH
        POP    HL
        LD     (BXL),HL
        JP     DSAVE7
;
;
ESAVE:  EX     AF,AF'
        CALL   SVDT
        DEC    DE
        LD     A,0FH
        LD     (DE),A
        EX     AF,AF'
        CP     3
        JR     NZ,ESAVE2
;
ESAVE1: LD     HL,(BXR)
        LD     (BXL),HL
        LD     L,(IY+4)
        LD     H,(IY+5)        ;SBXR
        LD     (BXR),HL
        CALL   LBSR
        PUSH   IX
        POP    HL
        LD     (IY+2),L
        LD     (IY+3),H
        RET
;
ESAVE2: CP     4
        JR     Z,ESAVE3
;
        LD     HL,(DSP)

        PUSH   HL
        LD     (SVDT1+1),IY
        CALL   SVDT
        LD     HL,WORK
        LD     (SVDT1+1),HL
        LD     HL,(BXL)
        PUSH   HL
        CALL   ESAVE1
        POP    HL
        LD     (BXR),HL
        POP    IY
        JR     ESAVE4
;
;
ESAVE3: LD     HL,(BXL)
        LD     (BXR),HL
ESAVE4: LD     L,(IY+2)
        LD     H,(IY+3)
        LD     (BXL),HL
        CALL   RBSR
        PUSH   IX
        POP    HL
        LD     (IY+4),L
        LD     (IY+5),H
        RET
;
;
;     NEXT  BOUNS  SEARCH
;
;
NBSRCH: LD     HL,(BXL)
        LD     (PBXL),HL
        LD     HL,(BXR)
        LD     (PBXR),HL
        CALL   LBSR
        RET    C               ;CLOSE
;
        LD     (BXL),IX
        CALL   RBSR
        LD     (BXR),IX
        CALL   CONT            ;CF=0
        LD     A,B
        RET
;
;    CHANGE  Y DIRECTON
;           &
;    NEXT  Y CO-ORDINATE
;
CHDIR:  LD     A,(DIRECT)
        CPL
        LD     (DIRECT),A
CHDIR0: LD     HL,(Y)
        INC    L
        OR     A
        JR     NZ,CHDIR1
;
        DEC    L
        DEC    L
CHDIR1: LD     (Y),HL
        RET

;
;
TWR:    CALL   CHDIR
        CALL   NBSRCH
        RET    C
;
        PUSH   AF
        LD     HL,(BXL)
        PUSH   HL
        LD     HL,(BXR)
        PUSH   HL
        CALL   CSAVE
        LD     A,(JSAVE)
        OR     A
        CALL   Z,SVDT
;
        POP    HL
        LD     (BXR),HL
        POP    HL
        LD     (BXL),HL
        POP    AF
        RET
;
;
; ***   BOUND  SEARCH   ****
;
;
;
;  //  LEFT BOUNS SEARCH  //
;
LBSR:   LD     DE,(BXR)
        LD     HL,(BXL)
        PUSH   HL
        LD     (BSRCH4+1),DE
        LD     HL,00H
        LD     (BSRCH6+1),HL
        LD     A,2BH           ;DEC IX
        LD     (BSRCH3+1),A
        LD     A,2FH           ;CPL
        LD     (BSRCH5),A
        XOR    A
        LD     (BSRCH7),A
        LD     HL,BSRCHL
        LD     (BSRCH1+1),HL
        LD     HL,BSRCHR
        LD     (BSRCH2+1),HL
        POP    DE
        INC    DE
        JR     BSRCH
;
;  //  RIGHT BOUNS SEARCH  //
;
RBSR:   LD     DE,(BXR)
RBSR0:  LD     HL,(BXL)
        LD     (BSRCH6+1),HL
        DEFB   21H             ;LD HL,640 or 320
LRBSR:  ENT
        DEFW   8002H
        LD     (BSRCH4+1),HL
        LD     A,23H           ;INC IX

        LD     (BSRCH3+1),A
        LD     A,2FH           ;CPL
        LD     (BSRCH7),A
        XOR    A
        LD     (BSRCH5),A
        LD     HL,BSRCHR
        LD     (BSRCH1+1),HL
        LD     HL,BSRCHL
        LD     (BSRCH2+1),HL
        DEC    DE
;
;
;  //  SEARCH ROUTINE  //
;
BSRCH:  LD     HL,(Y)
        PUSH   DE
        POP    IX
        CALL   ADCH
        LD     DE,TDOTN
        PUSH   HL
        LD     H,0
        LD     L,A
        ADD    HL,DE
        LD     C,(HL)
        POP    HL
        CALL   PEEK
        LD     E,A
        AND    C
BSRCH1: JP     Z,BSRCHL        ;JP BSRCHR
;
BSRCH2: CALL   BSRCHR          ;CALL BSRCHL
BSRCH3: DEC    IX              ;INC IX
        RET
;
;   ++  SEARCH  LEFT  +++
;
BSRCHL: DEC    IX
        RRC    C
        JR     NC,BSRCHC
;
        PUSH   IX
        EXX
        POP    DE
        INC    DE
BSRCH6: LD     HL,00H          ;BX
        INC    HL
        SBC    HL,DE
        EXX
        RET    NC
;
        DEC    HL
        CALL   PEEK
        LD     E,A
BSRCHC: LD     A,E
BSRCH7: NOP                    ;CPL
        AND    C
        JP     Z,BSRCHL
        RET
;
;  ++  SEARCH  RIGHT   +++

;
BSRCHR: INC    IX
        RLC    C
        JR     NC,BSRCHA
;
        CALL   BSRCHD
        RET    C
;
        INC    HL
        CALL   PEEK
        LD     E,A
BSRCHA: LD     A,E
BSRCH5: CPL                    ;NOP
        AND    C
        JR     Z,BSRCHR

BSRCHD: PUSH   IX
        EXX
        POP    HL
BSRCH4: LD     DE,BXR
        XOR    A
        SBC    HL,DE
        EXX
        CCF
        RET
;
;
;
;  //  CONT. CHECK  //
;
CONT:   LD     B,0H
        LD     HL,(PBXR)
        LD     DE,(BXR)
        CALL   CONT1
        LD     HL,(PBXL)
        LD     DE,(BXL)
        INC    HL              ;FOR  HL=FFH
        INC    DE              ;FOR  DE=FFH
;
CONT1:  PUSH   HL
        XOR    A
        INC    HL
        SBC    HL,DE
        POP    HL
        RL     B
        INC    DE
        EX     DE,HL
        SBC    HL,DE
        RL     B
        RET
;
;
;  ***  POINT DATA
;
;          SAVE & LOAD  ****
;
;
;  //  DATA  SAVE  //
;
SVDT:   LD     DE,(DSP)

SVDT0:  LD     HL,0000         ; XX  END ADD
        XOR    A
        SBC    HL,DE
        JR     NC,SVDT1
;
SOVER:  ENT
        DEFB   31H             ;STACK POINTER
SOVER1: ENT                    ;LD SP,XXH
        DEFW   00H
        SCF
        RET
;
SVDT1:  LD     HL,WORK
        LD     BC,0007H
        LDIR
        LD     (DSP),DE
        LD     HL,(NDSP)
        INC    HL
        LD     (NDSP),HL
        RET
;
;
;  ***  PAINT & SEARCH  ****
;
;
PSRCH:  LD     HL,(Y)
        LD     DE,(BXR)
        DEC    DE
        CALL   ADCH
        LD     DE,TDOTR
        PUSH   HL
        LD     H,0
        LD     L,A
        ADD    HL,DE
        INC    C
        LD     B,C
        LD     C,(HL)
        POP    HL
;
PSRCH1: CALL   PEEK
        AND    C
        JR     NZ,PSRCH2       ;BOUND
;
        DI
        IN     A,(LSE0)
        LD     (HL),C
        IN     A,(LSE1)
        EI
        LD     C,FFH
        DEC    HL
        DJNZ   PSRCH1
;
        LD     DE,-1
        JR     PSRCH5
;
PSRCH2: LD     E,B
        LD     B,7H
        LD     D,00H
PSRCH3: RLC    A
        JR     C,PSRCH4

;
        SCF
        RR     D
        DJNZ   PSRCH3
;
PSRCH4: IN     A,(LSE0)
        LD     A,C
        AND    D
        LD     (HL),A
        IN     A,(LSE1)
;
        LD     A,E
        DEC    A
        RLC    A
        RLC    A
        RLC    A
        LD     C,A
        LD     A,07H
        AND    C
        LD     D,A
        LD     A,F8H
        AND    C
        OR     B
        LD     E,A
PSRCH5: XOR    A
        LD     HL,(BXL)
        SBC    HL,DE
        RET
;
;
;  //  PEEK  DATA   //
;
DPEEK:  PUSH   HL
        EXX
        POP    HL
        DI
        IN     A,(LSE0)
        LD     C,LSRF
        XOR    A
;
DPEEK1: LD     B,00H           ;RE DATA
        OUT    (C),B
        OR     (HL)
;
DPEEK2: LD     E,A
        IN     A,(LSE1)
        EI
        LD     A,E
        EXX
DPEEK3: RET
;
;
;  //  COMP. BXL,BXR  //
;
COMP:   LD     HL,(BXL)
        LD     E,(IY+2)
        LD     D,(IY+3)
        INC    HL
        INC    DE
        XOR    A

        CALL   COMP1
        LD     HL,(BXR)
        LD     E,(IY+4)
        LD     D,(IY+5)
;
COMP1:  SBC    HL,DE
        RLA
        RLA
        RET    Z
;
        OR     1
        RET
;
        END
;
        END

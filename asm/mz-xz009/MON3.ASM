        INCLD  MACRO
        LIST
        INCLD  XMON-ROM
;
;---------------------------------
;   XMON-ROM   8.30.84
;
;  JISX   MZ-800 --> ASC
;    ent A     :data
;        IX    :output sub
;        (HL)  :tab counter
;        E     :DISPX
;
;---------------------------------
;
;
JISX:   ENT
        CP     0DH
        JR     Z,JISXCR
        CP     0AH
        JR     Z,JISXCR
        CALL   AJISX           ;code change
        CP     20H
        JR     NC,.IX
        BIT    0,E             ;print/p ?
        JR     Z,.IX           ;no
        LD     A," "
.IX:    JP     (IX)
;
JISXCR: CALL   .IX
        LD     M,0
        RET
;
AJISX:  PUSH   BC
        LD     C,0
        CALL   AJISX1
        POP    BC
        RET
;
;
AJISX1: CALL   PUSHR
        LD     HL,(CTABLE)
        LD     B,(HL)          ;code counter set
        INC    HL              ;HL=MZ-800
        LD     D,H             ;DE=JIS
        LD     E,L
        INC    DE
        BIT    0,C             ;MZ-800 --> JIS ?
        JR     Z,AJISX2        ;yes
        EX     DE,HL
AJISX2: CP     (HL)
        JR     Z,AJISX3        ;code match
        INC    HL
        INC    HL
        INC    DE
        INC    DE
        DJNZ   AJISX2
        RET
;
AJISX3: LD     A,(DE)

        RET
;
;
;---------------------------------
;
;
;  JISR   ASC    --> MZ-800
;    ent (A)   :data
;        IX    :input  sub
;
;---------------------------------
;
;
JISR:   ENT
        CALL   .IX             ;input sub :A set
        RET    C
;
        PUSH   BC
        LD     C,1
        CALL   AJISX1
        POP    BC
        OR     A
        RET
;---------------------------------
;
$LPT:   ENT
        DEFW   $CMT
        DEFM   "LPT"
        DEFB   0
        DEFB   8AH             ;Streem, O1C, W
        DEFW   0
        DEFW   LPTINI
        DEFW   ER59            ;ROPEN
        DEFW   .RET            ;WOPEN
        DEFW   .RET            ;CLOSE
        DEFW   .RET            ;KILL
        DEFW   0               ;INP
        DEFW   LPT1C?
        DEFW   LPTPOS
;
;
PIO.AC: EQU    FCH             ;Port-A control
PIO.AD: EQU    FEH             ;Port-A data
PIO.BC: EQU    FDH             ;Port-B control
PIO.BD: EQU    FFH             ;Port-B data
;
P.PLT:  EQU    0               ;1P01, 1P09
P.KP5:  EQU    1               ;KP5
P.JIS:  EQU    2               ;JIS code
P.THRU: EQU    3               ;thrue
;
;
LPTPOS: LD     A,(INPFLG)
        OR     A
        LD     A,(LPOSB)
        RET    Z
        LD     A,(CURX)
        RET
;
;

;
;----------------------------------
;
;        PL ROM CALL
;
;----------------------------------
ROMST:  EQU    03H             ;F403H
ROMST1: EQU    F400H
;
;
TIMST:  ENT
        CALL   ROMJP2
        DEFB   ROMST
;
TIMRD:  ENT
        CALL   ROMJP2
        DEFB   ROMST+3
;
STICK:  ENT
        CALL   ROMJP2
        DEFB   ROMST+6
;
STRIG:  ENT
        CALL   ROMJP2
        DEFB   ROMST+9
;
HCPY:   ENT
        CALL   ROMJP
        DEFB   ROMST+12
;
LPT1C?: ENT
        LD     HL,DISPX
        BIT    0,M
        JR     NZ,LPT1CX
;
LPT1C:  ENT
        PUSH   IY
        EX     AF,AF'
        LD     A,3+15          ;F003+15
        LD     (APL1CD),A
        LD     A,.CRT1C
APL1CF: LD     (APL1CE),A
        EX     AF,AF'
        CALL   APL1C
        POP    IY
        PUSH   BC
        LD     B,A
        LD     A,(INPFLG)
        OR     A
        LD     A,B
        POP    BC
        RET    Z
        RST    3
APL1CE: DEFB   .CRT1C
        RET
APL1C:  LD     IY,JISX
        CALL   ROMJP
APL1CD: DEFB   ROMST+15
;
LPT1CX: ENT

        PUSH   IY
        EX     AF,AF'
        LD     A,3+18          ;F003+18
        LD     (APL1CD),A
        LD     A,.CRT1CX
        JR     APL1CF
;
LPTINI: ENT
        CALL   ROMJP
        DEFB   ROMST+21
;
LPTOUT: ENT
        CALL   ROMJP
        DEFB   ROMST+24
;
PBCCLR: ENT
        CALL   ROMJP
        DEFB   ROMST+27
;
SPLOFF: ENT
        CALL   ROMJP
        DEFB   ROMST+30
;
SPLON:  ENT
        CALL   ROMJP
        DEFB   ROMST+33
;
SPLSW:  ENT
        CALL   ROMJP
        DEFB   ROMST+36
;
LPTM02: ENT
        CALL   ROMJP
        DEFB   ROMST+39
;
;---------------------------
;
;
;
ROMJP:  EX     AF,AF'
        LD     A,(PSEL)
        BIT    P.KP5,A
        JR     Z,ROMJP1
;
        PUSH   BC
        LD     B,3
        SVC    .MCTRL
        RST    3
        DEFB   .MCTRL
        ENDM
        POP    BC
;
ROMJP1: EX     AF,AF'
ROMJP2: EX     AF,AF'
        XOR    A
        LD     (KEY266),HL
        LD     (HERRF),A
        EX     AF,AF'
        DI
        LD     (KEY264),SP

        EX     (SP),HL         ;HL=call stored address
        LD     SP,HL           ;
        POP    HL              ;HL=call address
        OUT    (LSE3),A
        LD     SP,KEY262
        CALL   HLJP
        OUT    (LSE1),A
        LD     SP,(KEY264)
        EX     (SP),HL
        INC    SP
        INC    SP
        EI
        EX     AF,AF'
        LD     A,(HERRF)
        OR     A
        JR     NZ,ROMERR
        EX     AF,AF'
        RET
HLJP:   LD     H,0F4H          ;HL=F4??H
        JP     (HL)
;
;
ROMERR: 
        LD     B,A              ;B=0
        EX     AF,AF'
        DEC    B               ;B=1
        JP     Z,BREAKZ
        DEC    B               ;B=2
        JP     NZ,ERRORJ
ROMER1: LD     HL,(PBCN)       ;INIT M2
        LD     A,H
        OR     L
        JR     Z,LPTM02
        CALL   SPLON
        SVC    .BREAK
        RST    3
        DEFB   .BREAK
        ENDM
        JP     Z,BREAKZ
        JR     ROMER1
;
;
LPTINT: ENT
        DI
        PUSH   AF
        PUSH   HL
        PUSH   BC
        LD     (WKLINT),SP
        LD     SP,WKLINT
        OUT    (LSE3),A
        CALL   ROMST1
        OUT    (LSE1),A
        LD     SP,(WKLINT)
        POP    BC
        POP    HL
        POP    AF
        EI
        RETI
        DEFS   8
WKLINT: DEFW   0

;
        END
        SKP    H

        INCLD  MONOP
; ---------------------------
; MZ-800     Monitor command
; FI:MONOP   ver 1.0A 8.04.84
; ---------------------------
;
MONOP:  ENT
        PUSH   HL
        LD     DE,(ERRORP)
        PUSH   DE
        LD     DE,MONERR
        LD     (ERRORP),DE     ;error ret adr set
        LD     A,(LINLIM)
        PUSH   AF
        LD     A,100           ;getline max set
        LD     (LINLIM),A
        LD     (MONSP+1),SP    ;stack pointer push
        XOR    A
        LD     (FILOUT),A      ;crt mode
MONCLD: LD     SP,0000H        ;stack initize
MONHOT: LD     BC,MONHOT
        PUSH   BC              ;last return addrs set
        SVC    .CR2            ;linefeed & cr
        RST    3
        DEFB   .CR2
        ENDM
        LD     A,"*"           ;prompt disp
        SVC    .CRT1C
        RST    3
        DEFB   .CRT1C
        ENDM
        CALL   MONEDT          ;memory corretion ?
        JR     NC,-3
        LD     A,(DE)
        CP     "*"
        RET    NZ              ;prompt check
        INC    DE
        LD     A,(DE)          ;acc=next interpret data
        INC    DE              ;next interpret data addr
;
;
; moniter tabel command jump
;
        EXX                    ;parameter push
        LD     HL,MNCMTB
        LD     B,10            ;commands counter
MNCMCP: CP     M
        INC    HL
        JR     Z,MNCMOK        ;skip if just command
        INC    HL              ;next search
        INC    HL
        DJNZ   MNCMCP
        EXX
        RET
;
MONERR: LD     C,A
        AND    7FH
        JR     Z,MONCLD        ;Break
        LD     A,C             ;acc=errcode
        SVC    .ERRX           ;display error messege

        RST    3
        DEFB   .ERRX
        ENDM
        SVC    .ERCVR          ;error recover fd/qd
        RST    3
        DEFB   .ERCVR
        ENDM
        JR     MONCLD
;
;
MNCMOK: LD     E,M
        INC    HL
        LD     D,M
        PUSH   DE              ;commnd addr set
        EXX                    ;parameter pop
        RET
;
MNCMTB: DEFM   'D'
        DEFW   MONDMP
        DEFM   'M'
        DEFW   MONSET
        DEFM   'P'
        DEFW   MONPRT
        DEFM   'G'
        DEFW   MONGOT
        DEFM   'F'
        DEFW   MONSCH
        DEFM   'R'
        DEFW   MONSP
        DEFM   'S'
        DEFW   MONSAV
        DEFM   'L'
        DEFW   MONLOD
        DEFM   'V'
        DEFW   MONVRY
        DEFM   'T'
        DEFW   MONTRN
;
MONPRT: LD     A,(FILOUT)      ;lpt/crt
        XOR    1
        LD     (FILOUT),A
        RET
;---------------------------------
;
;     moniter  save commnd
;
;---------------------------------
MONSAV: CALL   SAVTRN          ;set addrs
        RET    C
        EXX
        CALL   FNMST           ;file name set
        EXX
        LD     (ELMD20),BC     ;bytes
        LD     (ELMD22),DE     ;data adrs
        LD     (ELMD24),HL     ;exec adrs
        SVC    .SAVEF          ;save file
        RST    3
        DEFB   .SAVEF
        ENDM
        RET

;---------------------------------
;
;    moniter load command
;
;---------------------------------
MONLOD: CALL   HLSET           ;load addr set
        PUSH   HL              ;hl=load addrs
        PUSH   AF
        CALL   LOAVRY          ;filename set & open
        POP    AF
        POP    HL
        JR     NC,+5           ;user load addr set ??
        LD     HL,(ELMD22)
        SVC    .LOADF          ;load file
        RST    3
        DEFB   .LOADF
        ENDM
        RET
;---------------------------------
;
;    filename set & open
;
;---------------------------------
LOAVRY: CALL   FNMST           ;file name set
        SVC    .LOPEN          ;ropen
        RST    3
        DEFB   .LOPEN
        ENDM
        CP     1
        RET    Z
        JP     ER61            ;File mode error
;---------------------------------
;
;    moniter verify command
;
;---------------------------------
MONVRY: CALL   LOAVRY          ;filename set
        LD     HL,(ELMD22)
        SVC    .VRFYF          ;file verify
        RST    3
        DEFB   .VRFYF
        ENDM
        RET
;---------------------------------
;
;    moniter rerturn command
;
;            to BASIC
;---------------------------------
MONSP:  LD     SP,0000H
        POP    AF
        LD     (LINLIM),A
        POP    HL
        LD     (ERRORP),HL
        POP    HL
        RET
;---------------------------------
;
;     moniter operation
;

;---------------------------------
MONEDT: LD     DE,FF00H        ;moniter work
        SVC    .GETL
        RST    3
        DEFB   .GETL
        ENDM
        JR     C,MONEDE
;
;    check ':xxxx='
;
        LD     A,(DE)
        CP     ":"             ;mem correct ??
        SCF
        RET    NZ
;
        INC    DE
        CALL   HLSET           ;addrs input ?
        RET    C
        LD     A,(DE)
        INC    DE
        XOR    3DH             ;"=" input ?
        RET    NZ
;
;
NEXTAC: CALL   ACSET           ;data read
        CCF
        RET    NC
        LD     M,A             ;mem correction !
        INC    HL              ;next pointer
        JR     NEXTAC
;
;
MONEDE: LD     (DE),A          ;error
        RET
;----------------------------------
;
;    4 ascii to binary (word)
;
;        ent. de=ascii data pointer
;        ext  hl=xxxxH
;
;----------------------------------
HLSET:  PUSH   HL
        CALL   SPCTAC          ;separater search
        PUSH   DE
        CALL   ACSETH          ;2 ascii to binary
        JR     C,HLSETE
        LD     H,A
        CALL   ACSETH          ;2 ascii to binary
        JR     C,HLSETE
        LD     L,A
        POP    AF
        POP    AF
        XOR    A
        RET
;
HLSETE: POP    DE
        POP    HL
        SCF
        RET

;----------------------------------
;
;    separater  search
;
;----------------------------------
SPCTA2: INC    DE
SPCTAC: LD     A,(DE)
        CP     20H
        JR     Z,SPCTA2
        RET
;---------------------------------
;
;    1 ascii to binary (nible)
;
;        ent. de=ascii data pointer
;        ext  acc= 0xH
;
;---------------------------------
ACSETS: LD     A,(DE)
        SVC    .CKHEX          ;0-9 a-f check
        RST    3
        DEFB   .CKHEX
        ENDM
        INC    DE              ;next pointer
        RET
;---------------------------------
;
;    2 ascii to  binary (byte)
;
;        ent. de=ascii data pointer
;        ext  acc= xxH
;
;---------------------------------
ACSET:  CALL   SPCTAC          ;separeter search
        CP     ";"
        JR     Z,SEMIOK        ;skip if ascii input
ACSETH: 
        PUSH   BC
        PUSH   DE
        CALL   ACSETS          ;1 ascii to binary(nible)
        JR     C,ACSTER
        LD     C,A             ;high nible
        CALL   ACSETS          ;1 ascii to binary(nible)
        JR     C,ACSTER
        LD     B,A             ;low nible
        LD     A,C
        RLCA
        RLCA
        RLCA
        RLCA
        ADD    A,B
        LD     C,A
        LD     A,C
        POP    BC
        POP    BC
        OR     A
        RET
;
ACSTER: POP    DE
        POP    BC

        SCF
        RET
;----------------------------------
;
;    ascii  code input mode
;
;----------------------------------
SEMIOK: INC    DE
        LD     A,(DE)
        INC    DE
        OR     A               ;¯¯JR ACSETO
        RET                    ;¯¯
;----------------------------------
;
;    moniter jump commnd
;
;----------------------------------
MONGOT: CALL   HLSET           ;addrs set
        RET    C
        JP     (HL)
;----------------------------------
;
;   moniter dump commnd
;
;----------------------------------
MONDMP: CALL   HLSET           ;top addrs set
        JR     C,MONDP1        ;skip if 'd' only
        PUSH   HL
        CALL   HLSET           ;end addrs set
        JR     C,MONDP2        ;skip if top addrs only
        POP    DE
        EX     DE,HL
        JR     MONDP3
;
;
;
MONDP2: POP    HL              ;
MONDP1: EX     DE,HL
        LD     HL,80H
        ADD    HL,DE           ;last addrs calc
        EX     DE,HL
MONDP3: LD     C,8             ;counter set
        CALL   MONDPS          ;dump list disp
        RET    C
        PUSH   HL
        SBC    HL,DE           ;dump end calc
        POP    HL
        RET    NC
        JR     MONDP3
;
MONDPS: CALL   HLHXPR          ;addrs disp
        LD     B,C
        PUSH   HL
MONDP4: LD     A,M             ;data read
        CALL   ACHXPR          ;1 byte disp
        INC    HL
        LD     A,20H           ;space disp
        SVC    .&1C
        RST    3
        DEFB   .&1C

        ENDM
        DJNZ   MONDP4
        POP    HL
;
        LD     A,"/"           ;separater disp
        SVC    .&1C
        RST    3
        DEFB   .&1C
        ENDM
        LD     B,C
MONDP5: LD     A,M             ;data read
        CP     20H             ;contol code
        JR     NC,+4
        LD     A,"."           ;yes, control code
        SVC    .&1C
        RST    3
        DEFB   .&1C
        ENDM
        INC    HL              ;next pointer
        DJNZ   MONDP5
;
        SVC    .&CR            ;
        RST    3
        DEFB   .&CR
        ENDM
        SVC    .HALT           ;braek & stop
        RST    3
        DEFB   .HALT
        ENDM
        OR     A
        RET
;--------------------------------
;
;    disp addrs
;
;         ent. hl=addrs
;              ':xxxx='
;
;--------------------------------
HLHXPR: LD     A,":"
        SVC    .&1C
        RST    3
        DEFB   .&1C
        ENDM
        LD     A,H
        CALL   ACHXPR          ;acc disp
        LD     A,L
        CALL   ACHXPR          ;acc disp
        LD     A,"="
        SVC    .&1C
        RST    3
        DEFB   .&1C
        ENDM
        RET
;--------------------------------
;
;    acc  disp
;
;         ent. acc = disp data
;

;--------------------------------
ACHXPR: PUSH   AF
        RLCA
        RLCA
        RLCA
        RLCA
        CALL   AC1HXP          ;nible disp
        POP    AF
AC1HXP: AND    0FH             ;ascii trans
        ADD    A,30H
        CP     ":"
        JR     C,+4
        ADD    A,7
        SVC    .&1C            ;disp acc(nible)
        RST    3
        DEFB   .&1C
        ENDM
        RET
;---------------------------------
;
;   moniter mem correction comd
;
;---------------------------------
MONSET: CALL   HLSET           ;
        LD     A,(FILOUT)      ;lpt/crt switch
        PUSH   AF
        XOR    A
        LD     (FILOUT),A      ;crt mode
MONSTL: SVC    .CR2
        RST    3
        DEFB   .CR2
        ENDM
        CALL   HLHXPR          ;addrs disp
        LD     A,M             ;data read
        CALL   ACHXPR          ;data disp
        LD     A,20            ;back space
        SVC    .CRT1C
        RST    3
        DEFB   .CRT1C
        ENDM
        SVC    .CRT1C
        RST    3
        DEFB   .CRT1C
        ENDM
        CALL   MONEDT          ;moniter operation
        JR     NC,MONSTL
        POP    AF
        LD     (FILOUT),A
        RET
;--------------------------------
;
;    moniter search command
;
;--------------------------------
MONSCH: CALL   HLSET           ;start addrs
        RET    C
        PUSH   HL
        CALL   HLSET           ;end addrs
        POP    BC
        RET    C

        PUSH   HL              ;hl end addr
        PUSH   BC              ;bc start addr
        LD     HL,FF00H        ;check data read
        CALL   NEXTAC          ;(hl)<--data
        LD     DE,FF00H
        OR     A
        SBC    HL,DE           ;check data bytes
        LD     C,L
        POP    HL
        PUSH   HL
        EXX
        POP    HL              ;hl start addr
        POP    DE              ;de end addr
        EXX
        RET    Z
MNSHLP: CALL   HLDECK          ;de=FF00h
        JR     NZ,SKPSCH       ;de check databuf
        CALL   MONDPS          ;data disp
        RET    C
SKPSCH: SVC    .BREAK
        RST    3
        DEFB   .BREAK
        ENDM
        RET    Z
        EXX
        INC    HL              ;next check pointer
        PUSH   HL
        SCF
        SBC    HL,DE           ;end check ?
        POP    HL
        RET    NC
        PUSH   HL
        EXX
        POP    HL              ;next check pointer
        JR     MNSHLP
;----------------------------------
;
;    3 pointer data interpret
;
;        ent de=ascii data top addr
;
;        ext de=first data
;            bc=(second-first) data
;            hl=last data
;
;        used save,xfer commnd
;
;     command : save :  xfer
;
;        de   : start:  source
;        bc   : bytes:  bytes
;        hl   : end  :  destination
;----------------------------------
SAVTRN: CALL   HLSET           ;first
        PUSH   HL
        CALL   NC,HLSET        ;second
        POP    BC              ;first
        RET    C
        SBC    HL,BC           ;calc bytes
        INC    HL

        PUSH   HL              ;bytes
        PUSH   BC              ;first
        CALL   HLSET           ;last
        PUSH   HL              ;last
        EXX
        POP    HL              ;last
        POP    DE              ;first
        POP    BC              ;bytes
        RET
;-------------------------------
;
;    moniter xfer command
;
;-------------------------------
MONTRN: CALL   SAVTRN          ;
        RET    C
        EX     DE,HL
        PUSH   HL
        SBC    HL,DE           ;direction check
        POP    HL
        JR     C,LDDRTR
        LDIR
        RET
LDDRTR: ADD    HL,BC           ;last addrs calc
        DEC    HL
        EX     DE,HL
        ADD    HL,BC
        DEC    HL
        EX     DE,HL
        LDDR
        RET
;----------------------------------
;
;     filename set
;
;----------------------------------
FNMST:  LD     A,(DE)
        OR     A
        JR     Z,FNMST2
        INC    DE
        CP     ":"             ;demiliter seach
        JR     NZ,FNMST
FNMST2: SVC    .COUNT          ;count string length
        RST    3
        DEFB   .COUNT
        ENDM
        SVC    .DEVFN          ;interpret dev. file name
        RST    3
        DEFB   .DEVFN
        ENDM
        LD     A,1
        LD     (ELMD),A        ;.OBJ atribut
        RET
;---------------------------------
;
;     check (de) (hl) ?
;
;           hl,de check data point
;             c   counter
;

;---------------------------------
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
        END
        END

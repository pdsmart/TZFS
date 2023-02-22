; --------------------------
; MZ-800 BASIC  IOCS command
; FI:IOCS  ver 1.0B 9.20.84
; Programed by T.Miho
; --------------------------
;
        INCLD  MACRO
;
;
RUNRFL: EQU    11A4H           ;KEYBUF   label
BKEYBF: EQU    11A5H           ;KEYBUF+1 label
;
; ZFLAG1 bit position
;
##RND:  EQU    5               ;FD
##SEQ:  EQU    6               ;CMT, QD, RAM
##STRM: EQU    7               ;CRT, KB, LPT, RS, USR
;
; ZRWX bit position
;
##ROPN: EQU    0               ;R.opened
##WOPN: EQU    1               ;W.opened
##XOPN: EQU    2               ;X.opened
##EOF:  EQU    7               ;End of file
;
;
CMTLU:  EQU    80H
LDALU:  EQU    81H
CRTLU:  EQU    88H
LPTLU:  EQU    89H
DATLU:  EQU    8AH
;
;
CRTLU?: LD     A,(ZLOG)
        CP     CRTLU
        RET
;
PRTEXP: ENT
        CALL   EXPR
        LD     A,(PRCSON)
        CP     3
        PUSH   HL
        EX     DE,HL
        JR     Z,PRTEX2
        CALL   CVNMFL
        POP    HL
        SVC    .COUNT
        RST    3
        DEFB   .COUNT
        ENDM
        RET
PRTEX2: CALL   CVTSDC
        POP    HL
        RET
        SKP    H

;
;  PRINT command
;
PRINT:  ENT
        XOR    A
        LD     (DISPX),A
        CALL   GETLU
        SVC    .LUCHK
        RST    3
        DEFB   .LUCHK
        ENDM
        JP     C,ER44          ;not open
        BIT    2,A             ;X?
        JP     NZ,PRX
        BIT    1,A             ;W?
        JP     Z,ER59          ;can't exec
        CALL   LU2CH
        CALL   CRTLU?
        JR     NZ,PRT04
        LD     A,(SELCOL)
        LD     (COL),A
        TEST1  "["
        CALL   TEST1
        DEFB   "["
        ENDM
        JR     NZ,PRT04
        CALL   COLCHK
        LD     (COL),A
        TESTX  "]"
        CALL   TESTX
        DEFB   "]"
        ENDM
PRT04:  CALL   ENDCHK
        JP     Z,PRTCR
PRT10:  LD     A,M
        CP     E3H             ;USING
        JR     Z,PRUSNG
        LD     BC,PRT20
        PUSH   BC              ;Return adrs
        CP     ";"
        RET    Z
        CP     ","
        RET    Z
        CP     E6H             ;TAB
        JR     Z,PRTAB
        CALL   PRTEXP
        JP     PRTMS2
;
PRT20:  CALL   ENDCHK
        JP     Z,PRTCR
        CP     ","
        JR     NZ,PRT30
        CALL   CRTLU?
        JR     C,PRT25
        IOCALL ZPOS            ;TAB10
        LD     IX,(ZPOS)
        CALL   IOCALL
        ENDM
        LD     B,A
        SUB    10

        JR     NC,-2
        NEG
        LD     B,A
        CALL   PRTAB2
        JR     PRT30
PRT25:  CALL   PRTCR
PRT30:  LD     A,M
        CP     ","
        JR     Z,+4
        CP     ";"
        JR     NZ,+3
        INC    HL
        CALL   ENDCHK
        RET    Z
        JR     PRT10
;
PRTAB:  CALL   CRTLU?
        JP     C,ER59
        CALL   ICH28H
        CALL   IBYTE
        CALL   HCH29H
        IOCALL ZPOS
        LD     IX,(ZPOS)
        CALL   IOCALL
        ENDM
        SUB    E
        RET    NC
        NEG
        LD     B,A
        CALL   CRTLU?
        LD     A,13H           ;Cursor right
        JR     Z,+4
PRTAB2: LD     A," "
        LD     DE,BKEYBF
        PUSH   BC
        PUSH   DE
        CALL   ?SETDE
        POP    DE
        POP    BC
        JR     PRTMS2
        SKP    3
;
PRUSNG: INC    HL              ;PRINT USING
        CALL   STREXP
        LD     A,B
        OR     A
        JP     Z,ER03
        PUSH   HL
        LD     HL,BKEYBF
        PUSH   HL
        PUSH   BC
        CALL   LDHLDE
        POP    BC
        LD     A,F0H
        LD     E,B
        LD     D,0
        INC    DE

        SVC    .OPSEG
        RST    3
        DEFB   .OPSEG
        ENDM
        LD     (USINGS),HL
        LD     (USINGP),HL
        POP    DE
        CALL   LDHLDE
        LD     M,0
        POP    HL
PRUSG2: CALL   ENDCHK
        JR     Z,PRUSG8
        INC    HL
        CP     ","
        JR     Z,PRUSG4
        CP     ";"
        JP     NZ,ER01
PRUSG4: CALL   ENDCHK
        JR     Z,PRUSG9
        CALL   EXPRNX
        PUSH   HL
        LD     BC,(TMPEND)
        PUSH   BC
        CALL   USNGSB
        POP    DE
        CALL   PRTMSG
        POP    HL
        JR     PRUSG2
PRUSG8: CALL   PRTCR
PRUSG9: LD     A,F0H
        SVC    .DLSEG
        RST    3
        DEFB   .DLSEG
        ENDM
        RET
;
;
.CR:    DEFW   0DH             ;FMP
PRTCR:  ENT
        LD     DE,.CR
;
PRTMSG: ENT
        SVC    .COUNT          ;print message
        RST    3
        DEFB   .COUNT
        ENDM
PRTMS2: CALL   CRTLU?
        JR     Z,PRTMC
        SVC    .PRSTR
        RST    3
        DEFB   .PRSTR
        ENDM
        RET
;
PRTMC:  PUSH   AF
        LD     A,(COL)
        SVC    .DCOL
        RST    3
        DEFB   .DCOL
        ENDM

        POP    AF
        SVC    .PRSTR
        RST    3
        DEFB   .PRSTR
        ENDM
        LD     A,(SELCOL)
        SVC    .DCOL
        RST    3
        DEFB   .DCOL
        ENDM
        RET
;
        SKP    H

;
;  READ command
;
READ:   ENT
        LD     A,DATLU
        LD     (ZLOG),A
        JR     INP10
;
;  INPUT command
;
INPUT:  ENT                    ;INPUT command
        CALL   GETLU
        SVC    .LUCHK
        RST    3
        DEFB   .LUCHK
        ENDM
        JP     C,ER44          ;not open
        BIT    2,A             ;X?
        JP     NZ,INX
        BIT    0,A             ;R?
        JP     Z,ER59          ;can't exec
        CALL   LU2CH
        CALL   CRTLU?
        JR     NZ,INP10
        CALL   HLFTCH
        CP     '"'
        LD     DE,MEM?IN
        LD     B,2
        JR     NZ,INP05
        CALL   STREXP
        TESTX  ";"
        CALL   TESTX
        DEFB   ";"
        ENDM
INP05:  LD     A,B
        OR     A
        JR     Z,INP10
INP07:  LD     A,(DE)
        INC    DE
        SVC    .CRT1C
        RST    3
        DEFB   .CRT1C
        ENDM
        DJNZ   INP07
INP10:  LD     (INPSP+1),SP
        LD     DE,(VARED)
        LD     (TMPEND),DE
INP15:  LD     DE,(TMPEND)
        CALL   MEMECK
        CALL   INTGTV
        PUSH   AF
        PUSH   BC
        CALL   ENDCHK
        JR     Z,INP20
        CALL   CH2CH
        JR     INP15
;
ER44:   LD     A,44            ;not opened
        DEFB   21H
ER59:   LD     A,59+80H        ;can't exec

        JP     ERRORJ
;
MEM?IN: DEFM   "? "
;
;
INP20:  XOR    A
        PUSH   AF              ;END=00
        PUSH   HL
        SVC    .INSTT
        RST    3
        DEFB   .INSTT
        ENDM
        LD     HL,(INPSP+1)
        DEC    HL
INP24:  LD     A,M
        OR     A
        JR     Z,INP30
        DEC    HL
        DEC    HL
        LD     B,M
        DEC    HL
        LD     C,M
        DEC    HL
        PUSH   HL
        PUSH   AF              ;Type
        PUSH   BC              ;Adrs
        LD     DE,(TMPEND)
        CALL   INPMX
        LD     H,0
        LD     L,B
        ADD    HL,DE
        LD     M,0
        POP    DE              ;Adrs
        POP    AF              ;Type
        CALL   INSUB
        POP    HL
        JR     INP24
INP30:  POP    HL
INPSP:  LD     SP,0            ;xxx
        RET
;
INPMX:  LD     A,(ZLOG)
        CP     DATLU
        JR     Z,DATINP
        SVC    .INMSG
        RST    3
        DEFB   .INMSG
        ENDM
        RET
        SKP    H

;
;
INSUB:  CP     3               ;String ?
        JR     NZ,INSUB4       ; No
        LD     HL,(TMPEND)     ; Yes
        LD     A,B
        JP     STRLET
;
INSUB4: PUSH   DE
        LD     HL,(INTFAC)
        LD     DE,(TMPEND)
        EX     DE,HL
        CALL   HLFTCH
        CP     "E"
        JP     Z,ER03
        EX     DE,HL
        CALL   CVFLAS
        EX     DE,HL
        TEST1  0
        CALL   TEST1
        DEFB   0
        ENDM
        JP     NZ,ER03
        EX     DE,HL
        POP    DE
        JP     LDIR5
        SKP    H

;
;  RESTORE command
;
RESTOR: ENT
        XOR    A
        LD     (DATFLG),A
        CALL   ENDCHK
        CALL   NZ,GETLIN
        EX     DE,HL
        CALL   NZ,DTSRCX
        EX     DE,HL
        JP     DATA            ;ON RESTORE
;
DATINP: PUSH   HL
        PUSH   DE
        CALL   DATINX
        POP    DE
        POP    HL
        RET
;
DATIN0: LD     HL,(TEXTST)
        CALL   DTSRCX
DATINX: LD     A,(DATFLG)      ;read flag
        CP     1               ;0 is restore top
        JP     Z,ER24          ;1 is out of data
        JR     C,DATIN0        ;2 is ok
        LD     HL,(DATPTR)     ;read pointer
        LD     C,":"
        SVC    .INDAT
        RST    3
        DEFB   .INDAT
        ENDM
        LD     (DATPTR),HL     ;read pointer
        CALL   ENDCHK
        SCF
        CCF
        RET    NZ
        DEC    HL
DTSRCH: CALL   DTSKSB          ;DATA search
        OR     A
        JR     NZ,DTSRC4
        INC    HL
DTSRCX: LD     A,M
        INC    HL
        OR     M
        LD     A,1
        JR     Z,DTSRC9
        INC    HL
        INC    HL
        JR     DTSRCH
DTSRC4: CP     94H             ;DATA
        JR     NZ,DTSRCH
        INC    HL
        LD     (DATPTR),HL     ;read pointer
        LD     A,2
DTSRC9: LD     (DATFLG),A      ;read flag
        RET
        SKP    H

;
;  GETLU ... interpret #n, /P, /T
;    ent HL: pointer
;    ext HL: pointer
;        A:  LU#
;
GETLU:  ENT
        TEST1  "#"
        CALL   TEST1
        DEFB   "#"
        ENDM
        JR     NZ,GETLU2
        CALL   HLFTCH
        CP     20H
        JP     NC,ER01
        PUSH   DE
        PUSH   BC
        LD     DE,ZFAC
        PUSH   DE
        CALL   FACNUM
        EX     (SP),HL
        CALL   HLFLT
        LD     A,H
        OR     A
        JP     NZ,ER64
        OR     L
        JP     Z,ER64
        JP     M,ER64
        POP    HL
        POP    BC
        POP    DE
        RET
GETLU2: TEST1  FBH             ;/
        CALL   TEST1
        DEFB   FBH
        ENDM
        LD     A,CRTLU
        RET    NZ
        TEST1  "P"
        CALL   TEST1
        DEFB   "P"
        ENDM
        LD     A,LPTLU
        RET    Z
        TESTX  "T"
        CALL   TESTX
        DEFB   "T"
        ENDM
        LD     A,CMTLU
        RET
;
;
LU2CH:  LD     A,(ZLOG)
        OR     A
        RET    M
        JP     HCH2CH
        SKP    H

;
;  DEFAULT "dev:"
;
DEFAULT:ENT
        CALL   DEVNAM
        SVC    .SETDF
        RST    3
        DEFB   .SETDF
        ENDM
        RET
;
;  INIT "dev:command"
;
INIT:   ENT
        CALL   ENDCHK
        LD     B,0
        CALL   NZ,STREXP
;
INIT2:  PUSH   HL
        SVC    .DEVNM
        RST    3
        DEFB   .DEVNM
        ENDM
        SVC    .FINIT
        RST    3
        DEFB   .FINIT
        ENDM
        POP    HL
        RET
;
;
;  ROPEN, WOPEN, XOPEN
;
ROPEN:  ENT
        LD     A,1
        DEFB   1
WOPEN:  ENT
        LD     A,2
        DEFB   1
XOPEN:  ENT
        LD     A,4
        PUSH   AF
        LD     (ZRWX),A
        CALL   GETLU
        CP     CRTLU
        JR     NZ,+4
        LD     A,CMTLU
        LD     (ZLOG),A
        CALL   LU2CH
        CALL   ELMT
        POP    AF
        CP     4               ;X
        JR     Z,+4
OPN.B:  LD     A,3             ;BSD
        LD     (ELMD),A
        PUSH   AF
        SVC    .RWOPN
        RST    3
        DEFB   .RWOPN
        ENDM

        LD     A,(ELMD)
        POP    BC
        CP     B
        JP     NZ,ER61
        RET
        SKP    H

;
;  CLOSE/KILL command
;
CLOSE:  ENT
        DEFB   F6H
KILL:   ENT
        XOR    A
        LD     B,A
        CALL   ENDCHK
        JR     Z,CLALL         ;all files
CLKL2:  CALL   GETLU
        CP     CRTLU
        RET    NC
        SVC    .CLKL
        RST    3
        DEFB   .CLKL
        ENDM
        TEST1  ","
        CALL   TEST1
        DEFB   ","
        ENDM
        JR     CLKL2
;
CLALL:  XOR    A
        SVC    .CLKL
        RST    3
        DEFB   .CLKL
        ENDM
        RET
;
;
ELMT:   ENT
        CALL   END2C
        LD     B,0
        CALL   NZ,STREXP
        PUSH   HL
        SVC    .DEVFN
        RST    3
        DEFB   .DEVFN
        ENDM
        POP    HL
        RET
        SKP    H

;
DEVNAM: PUSH   HL
        CALL   HLFTCH
        LD     DE,ELMWRK
        LD     B,1
        CALL   ELMCK
        CALL   NC,ELMCK
        JR     C,DEVNM2
        CALL   ELMCK
        CALL   TSTNUM
        CALL   ELMCK2
        CALL   ENDCHK
        JR     NZ,DEVNM2
        LD     A,":"
        LD     (DE),A
        POP    AF              ;dummy
        LD     DE,ELMWRK
        JR     DEVNM4
DEVNM2: POP    HL
        CALL   ENDCHK
        LD     B,0
        CALL   NZ,STREXP
DEVNM4: PUSH   HL
        SVC    .DEVNM
        RST    3
        DEFB   .DEVNM
        ENDM
        INC    M
        DEC    M
        JP     NZ,ER58
        POP    HL
        RET
;
ELMCK:  CP     "A"
        RET    C
        CP     "Z"+1
        CCF
ELMCK2: RET    C
        LD     (DE),A
        INC    HL
        INC    DE
        LD     A,M
        INC    B
        RET
;
ELMWRK: DEFS   4
        SKP    H

;
; LOAD "dev:filename"
;
LOAD:   ENT
        TEST1  E5H             ;ALL
        CALL   TEST1
        DEFB   E5H
        ENDM
        JR     NZ,LOAD2
        XOR    A
LSALL:  SVC    .LSALL
        RST    3
        DEFB   .LSALL
        ENDM
        RET
LOAD2:  CALL   ELMT
        TEST1  ","
        CALL   TEST1
        DEFB   ","
        ENDM
        JP     Z,LOADA
        PUSH   HL
        CALL   LDRDY
        DEC    A
        JR     Z,LDOBJ
        DEC    A
        JP     NZ,ER61         ;il file mode
        CALL   CKCOM
        CALL   CLRVAR
        CALL   LDFIL
        JR     LOAD9
LDOBJ:  LD     HL,(ELMD22)     ;load addr
        PUSH   HL
        LD     DE,(MEMLMT)
        CALL   COMPR
        LD     DE,(ELMD20)     ;size
        LD     BC,(MEMMAX)
        CALL   NC,MEMOBJ
        JP     C,ER18
        POP    HL
        SVC    .LOADF
        RST    3
        DEFB   .LOADF
        ENDM
LOAD9:  CALL   LDEND
        POP    HL
        RET
;
MEMOBJ: ADD    HL,DE
        RET    C
        EX     DE,HL
        LD     HL,BC
COMPR:  ENT
        PUSH   HL
        OR     A
        SBC    HL,DE
        POP    HL
        RET
;
; CHAIN "dev:filename"

;
CHAIN:  ENT
        CALL   ELMT
        CALL   LDRDY
        CP     2
        JP     NZ,ER61         ;il file mode
        LD     A,(LSWAP)
        OR     A
        JP     Z,RUN2
        JP     SWAP2
        SKP    H

;
; MERGE "dev:filename"
;
MERGE:  ENT
        CALL   CKCOM
        CALL   ELMT
        TEST1  ","
        CALL   TEST1
        DEFB   ","
        ENDM
        JR     Z,MERGEA
        SVC    .LOPEN
        RST    3
        DEFB   .LOPEN
        ENDM
        CP     2
        JP     NZ,ER61
        PUSH   HL
        LD     HL,(VARED)
        LD     (TMPEND),HL
        LD     BC,1000
        ADD    HL,BC
        JP     C,ER06'
        PUSH   HL
        LD     BC,(ELMD20)     ;size
        INC    B
        ADD    HL,BC
        JP     C,ER06'
        SBC    HL,SP
        JP     NC,ER06'
        POP    HL
        PUSH   HL
        SVC    .LOADF
        RST    3
        DEFB   .LOADF
        ENDM
        POP    HL
        CALL   MERGE0
        POP    HL
        RET
;
MERGE0: CALL   LDDEMI
        LD     A,D
        OR     E
        RET    Z
        PUSH   DE
        CALL   LDDEMI
        PUSH   HL
        LD     HL,DE
        LD     (EDLINE),HL
        CALL   DELSUB
        POP    HL
        POP    BC
        PUSH   BC
        PUSH   HL
        CALL   INSTLIN
        POP    HL
        POP    BC
        ADD    HL,BC
        DEC    HL

        DEC    HL
        DEC    HL
        DEC    HL
        JR     MERGE0
        SKP    H

;
;  LOAD/MERGE/RUN  ascii
;
LOADA:  CALL   CKCOM
        LD     A,1
        DEFB   1
MERGEA: LD     A,0
        DEFB   1
RUNA:   LD     A,2
        PUSH   AF
        TESTX  "A"
        CALL   TESTX
        DEFB   "A"
        ENDM
        CALL   ENDZ
        LD     A,1
        LD     (ZRWX),A
        LD     A,LDALU
        LD     (ZLOG),A
        CALL   OPN.B
        POP    AF
        PUSH   AF
        PUSH   HL              ;RJOB
        LD     HL,0
        LD     DE,FFFFH
        OR     A
        CALL   NZ,DELSUB       ;load/run only
        LD     A,LDALU
        SVC    .LUCHK
        RST    3
        DEFB   .LUCHK
        ENDM
        LD     HL,(VARED)
        LD     (TMPEND),HL
        LD     BC,1000
        ADD    HL,BC
        JP     C,ER06
        PUSH   HL              ;load start adrs
        LD     (LDAPTR),HL
LDA2:   LD     HL,-512
        ADD    HL,SP
        LD     DE,(LDAPTR)
        SBC    HL,DE
        JP     C,ER06
        LD     DE,(TMPEND)
        SVC    .INMSG
        RST    3
        DEFB   .INMSG
        ENDM
        LD     A,B
        OR     A
        JR     Z,LDA4
        CALL   CVBCAS
        LD     A,B
        OR     C
        JP     Z,ER03
        LD     HL,(LDAPTR)
        PUSH   HL              ;load pointer
        INC    HL
        INC    HL

        LD     M,C
        INC    HL
        LD     M,B
        INC    HL
        PUSH   HL
        LD     HL,DE
        TEST1  0
        CALL   TEST1
        DEFB   0
        ENDM
        JP     Z,ER03
        POP    HL
        LD     A,(DE)
        CP     " "
        JR     NZ,+3
        INC    DE
        CALL   CVIMTX
        LD     M,0
        INC    HL
        LD     (LDAPTR),HL
        POP    DE              ;old load pointer
        OR     A
        SBC    HL,DE
        EX     DE,HL           ;DE := length
        LD     M,E
        INC    HL
        LD     M,D
        JR     LDA2
LDA4:   LD     HL,(LDAPTR)
        CALL   LDHL00
        CALL   CLR
        POP    HL              ;load start adrs
        CALL   MERGE0
        POP    HL              ;RJOB
        POP    AF
        CP     2               ;RUN ?
        RET    NZ              ;no (load/merge)
        JP     RUNX            ;RUN from text-top
;
LDAPTR: DEFS   2
        SKP    H

;
; RUN "dev:filename"
;
FRUN:   ENT
        CALL   ELMT
        PUSH   HL
        TEST1  ","
        CALL   TEST1
        DEFB   ","
        ENDM
        JR     NZ,RUN1
        CALL   HLFTCH
        CP     "A"
        JP     Z,RUNA
RUN1:   CALL   LDRDY
        POP    HL
        DEC    A
        JR     Z,RUNOBJ
        DEC    A
        JP     NZ,ER61         ;il file mode
        CALL   CLRVAR
RUN2:   CALL   LDFIL           ;jump from CHAIN
        CALL   LDEND
        JP     RUNX
;
RUNOBJ: LD     D,0             ; normal
        LD     BC,FF00H
        TEST1  ","
        CALL   TEST1
        DEFB   ","
        ENDM
        JR     NZ,RUNOB2
        TESTX  "R"
        CALL   TESTX
        DEFB   "R"
        ENDM
        LD     D,1             ;,R
        LD     BC,CFF0H
RUNOB2: LD     A,D
        LD     (RUNRFL),A      ;,R flag
        LD     HL,(ELMD20)     ;size
        LD     DE,(ELMD22)     ;load addr
        PUSH   HL
        CALL   MEMOBJ
        POP    DE              ;size
        LD     HL,$BASIC       ;load file area
        LD     BC,FF00H
        CALL   NC,MEMOBJ
        JP     C,ER06'
        LD     SP,0
        CALL   CLPTR
        XOR    A
        LD     (LOADFG),A
        LD     A,36H           ;count0 mode3
        OUT    (D7H),A         ;8253 mode set
        LD     A,1
        OUT    (D3H),A         ;8253 music enable
        LD     HL,(ELMD22)     ;load addr
        LD     DE,(TMPEND)
        CALL   COMPR

        JR     NC,RUNOB3
;
; destroy BASIC
;
        PUSH   HL
        LD     HL,$BASIC       ;load file area
        LD     (TEXTST),HL
        CALL   CLPTR
        LD     HL,RUNOBE-PRXFER+BKEYBF
        LD     (ERRORP),HL
        POP    HL
;
RUNOB3: LD     DE,(TMPEND)
        CALL   COMPR
        JR     NC,+3
        EX     DE,HL
        PUSH   AF
        PUSH   HL
        LD     HL,PRXFER
        LD     DE,BKEYBF
        PUSH   DE
        LD     BC,RUNTBE-PRXFER
        LDIR
        RET                    ;JP BKEYBF
;
;
;  ORG BKEYBF
;
PRXFER: POP    HL
        SVC    .LOADF
        RST    3
        DEFB   .LOADF
        ENDM
        LD     A,C3H           ;int tbl make
        LD     HL,038DH
        LD     (1038H),A
        LD     (1039H),HL
        LD     A,01H           ;320*200 4 color
        SVC    .DSMOD
        RST    3
        DEFB   .DSMOD
        ENDM
        SVC    .DI
        RST    3
        DEFB   .DI
        ENDM
        EX     AF,AF'
        LD     A,(RUNRFL)      ;run"  " ,r
        OR     A
        CALL   NZ,INITIO-PRXFER+BKEYBF
        EX     AF,AF'
        LD     HL,(ELMD24)     ;exec addr
        LD     A,H
        OR     L
        EXX
        LD     HL,(TMPEND)     ;data store addr
        LD     DE,(ELMD22)     ;load addr
        LD     BC,(ELMD20)     ;size
        OR     D
        OR     E

        JR     Z,PROX0
        LD     A,E9H           ;jp (hl)
        LD     (PRO70P-PRXFER+BKEYBF),A
PROX0:  EXX
        POP    AF              ;ldir flg
        PUSH   HL              ;store exec addr
        LD     HL,PROFF-PRXFER+BKEYBF
        LD     DE,FF00H
        LD     BC,PRO80E-PROFF
        LDIR
        EXX
        JP     FF00H
;
;  ORG FF00H
;
PROFF:  JR     NC,RUNOB4
        LDIR
RUNOB4: EX     AF,AF'
        RET    Z               ;,R
        IN     A,(LSDMD)       ;check dipsw
        AND    2
        LD     A,0             ;mode 800
        OUT    (LSDMD),A       ; 800 mode
        LD     HL,PRO800-PROFF+FF00H
        LD     BC,PRO80E-PRO800
        JR     NZ,MODSET
;
        LD     A,8             ;mode 700
        OUT    (LSDMD),A       ;700 or 800 mode
        IN     A,(LSE0)        ;CG xfer
        LD     HL,1000H
        LD     DE,C000H
        LD     BC,1000H
        LDIR
        IN     A,(LSE1)
;
        LD     HL,PRO700-PROFF+FF00H
        LD     BC,PRO70E-PRO700
MODSET: 
        LD     DE,CFF0H
        LDIR
        POP    HL
        LD     SP,IBUFE
        LD     DE,D800H        ;vram2 for 700 mode
        JP     CFF0H
;
RUNOBE: SVC    .ERRX
        RST    3
        DEFB   .ERRX
        ENDM
        SVC    .ERCVR
        RST    3
        DEFB   .ERCVR
        ENDM
        SVC    .DI
        RST    3
        DEFB   .DI
        ENDM
        HALT
;    ORG CFF0H

PRO700: 
        OUT    (LSE4),A
PRO701: LD     A,71H           ;blue and white
        LD     (DE),A          ;vram2 clr
        INC    DE
        LD     A,D
        CP     E0H
        JR     NZ,PRO701
PRO70P: OUT    (LSE0),A        ;jp (hl)
        JP     (HL)
PRO70E: 
;
;    ORG CFF0H
PRO800: 
        OUT    (LSE0),A        ;700mon rom bank off
        OUT    (LSE3),A        ;800mon rom bank on
        JP     (HL)
PRO80E: 
;
;
;
INITIO: 
        PUSH   AF
        DI                     ;run "file name",r
        IM     1
        LD     HL,RUNTBL-PRXFER+BKEYBF
        LD     B,17
        SVC    .IOOUT          ;io dev init
        RST    3
        DEFB   .IOOUT
        ENDM
        POP    AF
        RET
;
;
;
RUNTBL: 
;   pio channel a
        DEFW   FC00H           ; int vecter
        DEFW   FCCFH           ; mode 3 (bit mode)
        DEFW   FC3FH           ; i/o reg. set
        DEFW   FC07H           ; int seqence (disenable)
;   pio channel b
        DEFW   FD00H           ; int vecter
        DEFW   FDCFH           ; mode 3 (bit mode)
        DEFW   FD00H           ; i/o reg. set
        DEFW   FD07H           ; int seqence (disenable)
;
        DEFW   D774H           ;8253 C1 mode 2
        DEFW   D7B0H           ;     C2 mode 0
        DEFW   D6C0H           ;counter2  12h
        DEFW   D6A8H           ;
        DEFW   D5FBH           ;counter1   1s
        DEFW   D53CH           ;
        DEFW   D305H           ;8253 int ok
        DEFW   CD01H           ;RF mode 700
        DEFW   CC01H           ;WF mode 700
RUNTBE: 
;
        SKP    H

;
LDRDY0: LD     HL,(VARED)
        LD     (TMPEND),HL
        LD     DE,(POOL)
        LD     (OLDPOOL),DE
        OR     A
        SBC    HL,DE
        LD     (VARLN),HL
        LD     HL,-256
        ADD    HL,SP
        LD     (LAST),HL
        LD     DE,(VARED)
        PUSH   HL
        OR     A
        SBC    HL,DE
        JP     C,ER06'
        EX     (SP),HL
        EX     DE,HL
        LD     BC,(VARLN)
        INC    BC
        LDDR
        POP    DE
        SVC    .ADDP0
        RST    3
        DEFB   .ADDP0
        ENDM
        LD     A,1
        LD     (LOADFG),A
        RET
;
LDRDY:  CALL   LDRDY0
        SVC    .LOPEN
        RST    3
        DEFB   .LOPEN
        ENDM
        LD     A,(ELMD)
        RET
;
CLRVAR: LD     HL,(VARED)
        XOR    A
        DEC    HL
        LD     M,A
        DEC    HL
        LD     M,A
        LD     (STRST),HL
        DEC    HL
        LD     M,A
        LD     (VARST),HL
        DEC    HL
        LD     M,A
        LD     (POOL),HL
        LD     HL,4
        LD     (VARLN),HL
        RET
;
OLDPOOL:DEFS   2
VARLN:  DEFS   2
LAST:   DEFS   2
LOADFG: DEFB   0
;

CKCOM:  ENT
        PUSH   AF
        CALL   ?DIRECT
        JP     NZ,ER19
        POP    AF
        RET
        SKP    H

;
LDFIL:  LD     BC,(ELMD20)
        PUSH   BC
        LD     HL,(POOL)
        LD     DE,(TEXTST)
        OR     A
        SBC    HL,DE           ;HL := text area size
        LD     L,0
        SBC    HL,BC
        JP     C,ER06'
        LD     HL,0
        LD     (OLDPOOL),HL
        CALL   RUNINT
        LD     HL,0
        LD     (LNOBUF),HL
        LD     HL,(TEXTST)
        SVC    .LOADF
        RST    3
        DEFB   .LOADF
        ENDM
        POP    BC
        LD     HL,(TEXTST)
        ADD    HL,BC
        LD     (OLDPOOL),HL
        RET
;
LDEND:  ENT
        LD     A,LDALU
        LD     B,0
        SVC    .CLKL
        RST    3
        DEFB   .CLKL
        ENDM
        LD     HL,LOADFG
        LD     A,M
        OR     A
        RET    Z
        LD     M,0
        LD     HL,(OLDPOOL)
        LD     A,H
        OR     L
        JR     NZ,LDEND2
        LD     HL,(TEXTST)
        CALL   LDHL00
LDEND2: EX     DE,HL
        LD     HL,(POOL)
        LD     BC,(VARLN)
        LDIR
        EX     DE,HL
        OR     A
        SBC    HL,DE
        EX     DE,HL
        SVC    .ADDP0
        RST    3
        DEFB   .ADDP0
        ENDM
        RET
        SKP    H

;
; VERIFY "CMT:filename"
;
VERIFY: ENT
        PUSH   HL
        CALL   REFLNX
        POP    HL
        CALL   ELMT
        PUSH   HL
        SVC    .LOPEN
        RST    3
        DEFB   .LOPEN
        ENDM
        CP     2
        JP     NZ,ER61
        LD     HL,(TEXTST)
        SVC    .VRFYF
        RST    3
        DEFB   .VRFYF
        ENDM
        POP    HL
        RET
;
;  SAVE "dev:filename"
;
SAVE:   ENT
        TEST1  E5H             ;ALL
        CALL   TEST1
        DEFB   E5H
        ENDM
        LD     A,1
        JP     Z,LSALL
        PUSH   HL
        CALL   REFLNX
        POP    HL
        CALL   ELMT
        TEST1  ","
        CALL   TEST1
        DEFB   ","
        ENDM
        JR     Z,SAVEA
        PUSH   HL
        LD     A,2
        LD     (ELMD),A
        LD     HL,(TEXTED)
        LD     DE,(TEXTST)
        OR     A
        SBC    HL,DE
        LD     (ELMD20),HL
        LD     A,(ELMD1)
        CP     0DH
        JP     Z,ER60
        SVC    .SAVEF
        RST    3
        DEFB   .SAVEF
        ENDM
        POP    HL
        RET
;
SAVEA:  TESTX  "A"

        CALL   TESTX
        DEFB   "A"
        ENDM
        PUSH   HL
        LD     A,2
        LD     (ZRWX),A
        LD     A,LDALU
        LD     (ZLOG),A
        CALL   OPN.B
        POP    HL
        CALL   LIST0
        CALL   PRTCR
        LD     B,1
        LD     A,LDALU
        SVC    .CLKL
        RST    3
        DEFB   .CLKL
        ENDM
        RET
        SKP    H

;
;  LOCK/UNLOCK "dev:filename"
;
UNLOCK: ENT
        XOR    A
        DEFB   1
LOCK:   ENT
        LD     A,1
        PUSH   AF
        CALL   STREXP
        SVC    .DEVFN
        RST    3
        DEFB   .DEVFN
        ENDM
        POP    AF
        SVC    .LOCK
        RST    3
        DEFB   .LOCK
        ENDM
        RET
;
; DIR[#n] "dev:"
; DIR[/P] dev
;
DIR:    ENT
        CALL   GETLU
        PUSH   AF              ;lu#
        SVC    .LUCHK
       RST    3
        DEFB   .LUCHK
        ENDM
        JP     C,ER44
        BIT    1,A             ;W?
        JP     Z,ER59
        CALL   LU2CH
        CALL   DEVNAM
        LD     B,A             ;ch#
        XOR    A
        SVC    .DIR            ;read directory
        RST    3
        DEFB   .DIR
        ENDM
        LD     A,B             ;A=ch#
        SVC    .SETDF          ;set default
        RST    3
        DEFB   .SETDF
        ENDM
        POP    AF              ;A=lu#
        SVC    .DIR            ;print directory
        RST    3
        DEFB   .DIR
        ENDM
        RET
;
;  DELETE "dev:filename"
;
FDEL:   ENT
        CALL   STREXP
        SVC    .DEVFN
        RST    3

        DEFB   .DEVFN
        ENDM
        SVC    .DELET
        RST    3
        DEFB   .DELET
        ENDM
        RET
;
;  RENAME "dev:oldname","newnae"
;
RENAME: ENT
        CALL   STREXP
        SVC    .DEVFN
        RST    3
        DEFB   .DEVFN
        ENDM
        CALL   HCH2CH
        CALL   STREXP
        SVC    .RENAM
        RST    3
        DEFB   .RENAM
        ENDM
        RET
        SKP    H

;
; random file access
;
PRX:    CALL   RAN0
PRX2:   CALL   PRTEXP
        SVC    .PRREC
        RST    3
        DEFB   .PRREC
        ENDM
        CALL   ENDCHK
        RET    Z
        CALL   CH2CH
        JR     PRX2
;
;
INX:    CALL   RAN0
        LD     DE,(TMPEND)
        CALL   MEMECK
INX2:   CALL   INTGTV
        PUSH   HL
        PUSH   AF
        PUSH   BC
        LD     DE,(TMPEND)
        SVC    .INREC
        RST    3
        DEFB   .INREC
        ENDM
        POP    DE
        POP    AF
        CALL   INSUB
        POP    HL
        CALL   ENDCHK
        RET    Z
        CALL   CH2CH
        JR     INX2
;
RAN0:   TEST1  "("
        CALL   TEST1
        DEFB   "("
        ENDM
        RET    NZ
        CALL   IDEEXP
        LD     A,D
        OR     E
        JP     Z,ER03
        SVC    .RECST
        RST    3
        DEFB   .RECST
        ENDM
        CALL   HCH29H
        TEST1  ","
        CALL   TEST1
        DEFB   ","
        ENDM
        RET
;
        SKP    H

;
;  SWAP "dev:filename"
;
SWAP:   ENT
        LD     A,(LSWAP)
        OR     A
        JP     NZ,ER25
        PUSH   HL
        LD     B,0
        SVC    .DEVNM
        RST    3
        DEFB   .DEVNM
        ENDM
        LD     (SWAPDV),DE
        LD     (SWAPCH),A
        LD     HL,(TEXTED)
        LD     DE,(TEXTST)
        XOR    A
        SBC    HL,DE
        LD     (ELMD20),HL
        SVC    .SWAP
        RST    3
        DEFB   .SWAP
        ENDM
        POP    HL
        CALL   ELMT
        CALL   ENDZ
        LD     A,(ZFLAG1)
        BIT    ##RND,A
        JP     Z,ER59
        PUSH   HL              ;RJOB
        LD     HL,(SWAPNB)
        ADD    HL,SP
        LD     SP,HL
        EX     DE,HL
        LD     HL,SWAPDS
        LD     BC,(SWAPBY)
        LDIR
        CALL   LDRDY
        CP     2
        JP     NZ,ER61
        LD     (SWAP2+1),SP
SWAP2:  LD     SP,0            ;jump from CHAIN
        CALL   LDFIL
        CALL   LDEND
        LD     HL,FFFDH
        PUSH   HL              ;SWAP flag
        PUSH   HL
        LD     A,1
        LD     (LSWAP),A
        LD     HL,(TEXTST)
        JP     NXLINE
;
; Recover SWAP
;
BSWAP:  ENT
        XOR    A
        LD     (LSWAP),A
        POP    IX
BSWAP2: POP    BC

        LD     A,B
        CP     FFH
        JP     NZ,ER25
        LD     A,C
        CP     FDH
        JR     Z,BSWAP6
        CP     FEH
        LD     HL,4
        JR     Z,BSWAP4
        CP     12H
        LD     HL,10H
        JP     NZ,ER25
BSWAP4: ADD    HL,SP
        LD     SP,HL
        JR     BSWAP2
;
BSWAP6: LD     DE,(SWAPDV)
        LD     A,(SWAPCH)
        SVC    .SETDF
        RST    3
        DEFB   .SETDF
        ENDM
        LD     B,0
        SVC    .DEVNM
        RST    3
        DEFB   .DEVNM
        ENDM
        CALL   LDRDY0
        OR     FFH
        SVC    .SWAP
        RST    3
        DEFB   .SWAP
        ENDM
        CALL   LDFIL
        CALL   LDEND
        LD     HL,0
        ADD    HL,SP
        LD     DE,SWAPDS
        LD     BC,(SWAPBY)
        LDIR
        LD     SP,HL
        POP    HL              ;RJOB
        RET
;
SWAPDV: DEFS   2
SWAPCH: DEFS   1
;
; I/O initial for cold-start
;
IOINIT: ENT
        POP    HL
        PUSH   HL
        LD     (ERRORP),HL
        LD     A,"1"
        CALL   IOINI2
        LD     A,"2"
        CALL   IOINI2
        LD     DE,INITD3
        LD     B,INITD4-INITD3
        JR     IOINI4

IOINI2: LD     (INITD1+2),A
        LD     DE,INITD1
        LD     B,INITD3-INITD1
IOINI4: JP     INIT2
;
INITD1: DEFM   "RS?:0,$8C,13"


INITD3: DEFM   "CMT:T"

INITD4: 
;
        END

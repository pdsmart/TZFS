; -----------------------------
; Lx-monitor  IOCS-part
; FI:MON-IOCS  ver 1.01 5.24.84
; -----------------------------
;
        INCLD  MACRO
        ORG    1800H
;
$IOCS:  ENT
        JP     $START
;
; FALG1 bit position
;
##REN:  EQU    0               ;ROPEN enable
##WEN:  EQU    1               ;WOPEN enable
##RCHR: EQU    2               ;Read at 1 char
##WCHR: EQU    3               ;Write at 1 char
##FNM:  EQU    4               ;File name exist
##RND:  EQU    5               ;FD
##SEQ:  EQU    6               ;CMT, QD, XM
##STRM: EQU    7               ;CRT, LPT, RS, USR
;
; FLAG2 bit position
;
##CMT:  EQU    7               ;Disp filename
##1OPN: EQU    6               ;1 file only open
##1WOP: EQU    5               ;1 file only wopen
##EOFE: EQU    4               ;select EOF process
;   bit 0,1,2 ..... max channel
;
; ZRWX bit position
;
##ROPN: EQU    0               ;R.opened
##WOPN: EQU    1               ;W.opened
##XOPN: EQU    2               ;X.opened
##LOPN: EQU    3               ;L.opened
##EOF:  EQU    7               ;End of file
;
; DIR offset
;
#SIZE:  EQU    20
#PTR:   EQU    64              ;BSD block pointer
#BLKNO: EQU    64+16-2         ;BSD block number
;
CMTLU:  EQU    80H
CRTLU:  EQU    88H
LPTLU:  EQU    89H
;
;
CRTLU?: LD     A,(ZLOG)
        CP     CRTLU
        RET
;
ZMODE:  DEFW   0               ;File mode
ZBUFF:  ENT
        DEFW   0               ;Buffer adrs
ZBUFE:  ENT
        DEFW   0               ;Buffer end
        SKP    H

;
; SVC .PRSTR  ;print string into file
;    ent DE:adrs
;        B: length
;
PRTSTR: ENT
        CALL   IO.RDY
        CALL   PRTST0
IO.OK:  ENT
        XOR    A
        LD     (QSEG),A
        RET
;
IO.RDY: ENT
        LD     A,(ZLOG)
        LD     (QSEG),A
        RET
;
PRTST0: CALL   PUSHR
        LD     A,(ZFLAG1)
        BIT    ##STRM,A
        LD     HL,PRT1C
        JR     Z,PRTST2
        BIT    ##WCHR,A        ;Output at
        LD     HL,.ZOUT
        JR     NZ,PRTST2       ;  1 char
.ZOUT:  IOCALL ZOUT            ;  1 line
        LD     IX,(ZOUT)
        CALL   IOCALL
        ENDM
        RET
;
PRTST2: LD     A,B             ;SEQ/RND
        OR     A
        RET    Z
        LD     A,(DE)
PRTST4: CALL   .HL             ;PRT1C or .ZOUT
        INC    DE
        DEC    B
        JR     PRTST2
;
PRT1C:  CALL   PUSHR
        LD     E,(IY+#PTR)
        LD     D,(IY+#PTR+1)
        LD     HL,(ZBUFF)
        ADD    HL,DE
        LD     M,A
        INC    DE
        LD     HL,(ZBLK)
        OR     A
        SBC    HL,DE
        CALL   Z,PRT1B         ;Buffer full
        LD     (IY+#PTR),E
        LD     (IY+#PTR+1),D
        INC    (IY+#SIZE)
        RET    NZ
        INC    (IY+#SIZE+1)
        RET    NZ
        JP     ER55            ;too long file
        SKP    H

;
PRT1B:  PUSH   BC              ;Output 1 block
        LD     B,02H           ;F# not update, blocked
PRT1B0: CALL   ?RND
        LD     IX,.ZOUT
        JR     Z,+6
        LD     IX,PRX1B
        LD     A,B
        CALL   SEQSET
        CALL   .IX
PRT1B9: INC    (IY+#BLKNO)
        LD     DE,0
        POP    BC
        RET
;
.IX:    JP     (IX)
;
PRT1BX: LD     A,1AH           ;Output last block
        LD     E,(IY+#PTR)
        LD     D,(IY+#PTR+1)
PRT1X2: LD     HL,(ZBUFF)
        ADD    HL,DE
        LD     M,A
        INC    DE
        LD     HL,(ZBLK)
        XOR    A
        SBC    HL,DE
        JR     NZ,PRT1X2
        PUSH   BC
        LD     HL,(ZBUFF)
        DEC    HL
        LD     M,FFH           ;EOF mark
        DEC    HL
        LD     M,FFH
        LD     B,06H           ;F# update, blocked
        JR     PRT1B0
;
;
SEQSET: LD     BC,(ZBLK)
        INC    BC
        INC    BC
        LD     HL,(ZBUFF)
        DEC    HL
        DEC    HL
        LD     DE,(ZMODE)
        RET
;
;
.ZEND:  DEFB   F6H
.ZSTRT: XOR    A
        IOCALL ZSTRT
        LD     IX,(ZSTRT)
        CALL   IOCALL
        ENDM
        RET
        SKP    H

;
; SVC .INSTT  ;INPUT command start
;
INPSTRT:ENT
        CALL   CRTLU?          ;input start
        RET    NZ
        PUSH   DE
        LD     DE,KEYBUF
        CALL   BINPUT
        LD     (INPKB+1),DE
        POP    DE
        RET    NC
        JP     BREAKZ
;
; SVC .INMSG  ;input from file
;   ent DE:adrs
;   ext B: length
;
INPMSG: ENT
        PUSH   HL
        PUSH   DE
        CALL   IO.RDY
        LD     HL,(ZTOP)
        INC    HL
        BIT    ##EOF,M
        PUSH   HL
        LD     B,0
        SCF
        CALL   Z,INPMS0
        POP    HL
        CALL   C,INEOF
        POP    DE
        PUSH   AF
        CALL   IO.OK
        LD     L,B
        LD     H,0
        ADD    HL,DE
        LD     M,0
        POP    AF
        POP    HL
        RET
;
INEOF:  SET    ##EOF,M
        LD     HL,ZFLAG2
        BIT    ##EOFE,M
        RET    Z               ;nomally
        JP     ER63            ;old method
;
INPMS0: CALL   CRTLU?          ;input 1 record
        JR     Z,INPKB
        LD     A,(ZFLAG1)
        BIT    ##STRM,A
        LD     HL,INP1C
        JR     Z,INPMC
        BIT    ##RCHR,A
        LD     HL,.ZINP
        JR     NZ,INPMC
.ZINP:  IOCALL ZINP
        LD     IX,(ZINP)
        CALL   IOCALL

        ENDM
        RET
;
INPKB0: LD     A,"?"
        SVC    .CRT1C
        RST    3
        DEFB   .CRT1C
        ENDM
        LD     A," "
        SVC    .CRT1C
        RST    3
        DEFB   .CRT1C
        ENDM
        SVC    .INSTT
        RST    3
        DEFB   .INSTT
        ENDM
INPKB:  LD     HL,0            ;xxx
        CALL   HLFTCH
        OR     A
        JR     Z,INPKB0
        LD     C,0
        SVC    .INDATA
        RST    3
        DEFB   .INDATA
        ENDM
        LD     (INPKB+1),HL
        RET
;
; SVC .INDAT ;read 1 item from buffer
;   ent HL:data pointer
;       DE:input buffer
;       C: separater(nomaly 00H or ":")
;   ext B: length
;       HL:data pointert
;
INPDT:  ENT
        LD     B,0
        TEST1  '"'
        CALL   TEST1
        DEFB   '"'
        ENDM
        JR     NZ,INPDT6
INPDT2: LD     A,M
        OR     A
        RET    Z
        INC    HL
        CP     '"'
        JR     Z,INPDT4
        LD     (DE),A
        INC    DE
        INC    B
        JR     INPDT2
INPDT4: TEST1  ","
        CALL   TEST1
        DEFB   ","
        ENDM
        OR     A               ;Reset CF
        RET
;

INPDT6: LD     A,M
        OR     A
        RET    Z
        CP     C
        RET    Z
        INC    HL
        CP     ","
        RET    Z
        LD     (DE),A
        INC    DE
        INC    B
        JR     INPDT6
;
INPMC:  LD     (INPMC2+1),HL   ;input by chr
        LD     B,0
INPMC2: CALL   0               ;INP1C or (ZINP)
        RET    C
        CP     0DH
        RET    Z
        LD     (DE),A
        INC    DE
        INC    B
        JR     NZ,INPMC2
        JP     ER41            ;I/O error
        SKP    H

;
INP1C0: ENT
        LD     A,(ZFLAG1)
        BIT    ##STRM,A
        JP     NZ,ER59         ;STRM ommit
INP1C:  CALL   PUSHR
        LD     E,(IY+#PTR)
        LD     D,(IY+#PTR+1)
        LD     HL,(ZBLK)
        OR     A
        SBC    HL,DE
        CALL   Z,INP1B
        RET    C
        LD     L,(IY+#BLKNO)
        LD     H,(IY+#BLKNO+1)
        XOR    A
        SBC    HL,DE
        SCF
        RET    Z               ;EOF
        LD     HL,(ZBUFF)
        ADD    HL,DE
        LD     A,M
        INC    DE
        LD     (IY+#PTR),E
        LD     (IY+#PTR+1),D
        RET
;
INP1B:  CALL   ?RND
        JP     NZ,INX1B
        DEFB   F6H             ;not first block
INP1B0: XOR    A               ;first block
        CALL   SEQSET
        CALL   .ZINP
        RET    C
        LD     A,M
        INC    HL
        AND    M
        LD     M,FFH
        INC    A
        LD     DE,0
        RET    NZ              ;Nomal block
        PUSH   HL              ;EOF block
        LD     HL,(ZBUFE)
        LD     BC,(ZBLK)
INP1B2: DEC    HL
        DEC    BC
        LD     A,M
        OR     A
        JR     Z,INP1B2
        POP    HL
        LD     M,B             ;#BLKNO := Block length
        DEC    HL
        LD     M,C
        RET
        SKP    H

;
; SVC .LUCHK  ;check lu & set Z-area
;   ent A: lu
;   ext A: 1:R, 2:W
;       if CF then not-found
;
LUCHK:  ENT
        CALL   PUSHR
        LD     HL,CRTTBL
        CP     CRTLU
        JR     Z,LUCHK4
        LD     HL,LPTTBL
        CP     LPTLU
        JR     Z,LUCHK4
        SVC    .SEGAD
        RST    3
        DEFB   .SEGAD
        ENDM
        RET    C               ;LU# not found
LUCHK4: LD     (ZTOP),HL
        LD     DE,ZLOG
        LD     BC,8
        LDIR
        LD     (ZMODE),HL
        LD     IY,HL
        LD     DE,ELMD
        CALL   LDIR64
        PUSH   HL
        LD     HL,(ZEQT)
        LD     DE,ZNXT
        LD     BC,ZBYTES
        LDIR
        POP    HL
        LD     BC,16
        ADD    HL,BC
        LD     (ZBUFF),HL
        LD     BC,(ZBLK)
        ADD    HL,BC
        LD     (ZBUFE),HL
        LD     A,(ZRWX)
        AND    0FH
        RET
;
;
CRTTBL: DEFB   CRTLU
        DEFB   3               ;W R
        DEFW   $CRT
        DEFW   0
        DEFW   0
;
LPTTBL: DEFB   LPTLU
        DEFB   2               ;W
        DEFW   $LPT
        DEFW   0
        DEFW   0
;
        SKP    H

;
; SVC .DEVNM  ;Interp. dev name
;  ent DE:device name pointer
;  ext DE:equipment table
;      HL:file name pointer
;      A: channel
;
DEV:    ENT
        LD     HL,KEYBUF
        PUSH   HL
        LD     A,B
        OR     A
        CALL   NZ,LDHLDE
        LD     M,0
        LD     HL,EQTBL
        JR     +5
DEV1:   LD     HL,0            ;xxx
        LD     A,L
        OR     H
        JR     Z,DEV8          ;Not found
        LD     (DEV7+1),HL
        CALL   LDDEMI
        LD     (DEV1+1),DE
        LD     DE,KEYBUF
        EX     DE,HL
DEV2:   LD     A,(DE)
        OR     A
        JR     Z,DEV4
        CP     M
        JR     NZ,DEV1         ;Mismatch
        INC    HL
        INC    DE
        JR     DEV2
DEV4:   LD     A,M
        INC    HL
        CP     ":"
        LD     C,0
        JR     Z,DEV5          ;Match
        SUB    "1"
        CP     9
        JR     NC,DEV1         ;Mismatch
        LD     C,A
        LD     A,M
        INC    HL
        CP     ":"
        JR     NZ,DEV1         ;Mismatch
DEV5:   EX     (SP),HL         ;Found
DEV7:   LD     HL,0            ;xxx
        LD     A,C
        JR     DEV9
DEV8:   POP    HL              ;Not found
        PUSH   HL
DEV82:  LD     A,M
        INC    HL
        CP     ":"
        JP     Z,ER58          ;Dev name err
        OR     A
        JR     NZ,DEV82
        LD     HL,(DDEV)
        LD     A,(DCHAN)

DEV9:   LD     (ZEQT),HL
        PUSH   HL
        LD     (ZCH),A
        LD     DE,ZNXT
        LD     BC,ZBYTES
        LDIR
        LD     B,A
        LD     A,(ZFLAG2)
        AND    07H             ;bit 0,1,2
        CP     B
        JP     C,ER58          ;Dev name err (CH#)
        LD     A,B
        POP    DE
        POP    HL
        RET
;
; SVC .DEVFN  ;Interp. dev&file name
;   ent DE:pointer
;       B: length
;
DEV&FN: ENT
        CALL   PUSHR
        SVC    .DEVNM
        RST    3
        DEFB   .DEVNM
        ENDM
        EX     DE,HL
        LD     HL,ELMD1
        LD     B,31
        CALL   ?CLRHL
        LD     HL,ELMD
        SVC    .COUNT
        RST    3
        DEFB   .COUNT
        ENDM
        CALL   SETFNAM
        LD     HL,ZFLAG1
        BIT    ##FNM,M
        RET    Z
        INC    HL
        BIT    ##CMT,M
        RET    NZ
        LD     A,(ELMD1)       ;except CMT,
        CP     0DH             ; no filename is
        JP     Z,ER60          ; error 60.
        RET
        SKP    H

;
; SVC .RWOPEN   ;ROPEN/WOPEN/XOPEN
;
RWOPEN: ENT
        CALL   PUSHR
        CALL   OPEN00
        LD     B,0
        CALL   TYPECK
        JP     DUST
;
OPEN00: LD     A,(ZLOG)
        SVC    .SEGAD
        RST    3
        DEFB   .SEGAD
        ENDM
        JP     NC,ER43         ;LU already opened
        CALL   ?OPEND          ;Check already opened
        LD     HL,8+64+16+5    ;LU, DIR and work
        LD     A,(ZFLAG1)
        LD     DE,(ZBLK)
        INC    DE
        INC    DE
        BIT    ##STRM,A
        JR     NZ,+3
        ADD    HL,DE           ;SEQ,RND
        LD     A,(ZRWX)
        BIT    2,A
        JR     Z,+3
        ADD    HL,DE           ;XO
        EX     DE,HL
        LD     A,(ZLOG)
        SVC    .OPSEG          ;open segment
        RST    3
        DEFB   .OPSEG
        ENDM
        LD     (QSEG),A
        LD     (ZTOP),HL
        EX     DE,HL
        LD     HL,ZLOG
        LD     BC,8
        LDIR                   ;xfer ZLOG to seg
        LD     (ZMODE),DE
        LD     IY,DE
        LD     HL,ELMD
        CALL   LDIR64          ;xfer ELMD to seg
        LD     HL,16
        ADD    HL,DE
        LD     (ZBUFF),HL
        LD     DE,(ZBLK)
        ADD    HL,DE
        LD     (ZBUFE),HL
        CALL   ?RND
        JP     NZ,OPX          ;RND
        LD     A,(ZRWX)        ;SEQ/STRM
        BIT    ##XOPN,A
        JP     NZ,ER59
        BIT    ##WOPN,A
        LD     IX,(ZWO)
        JR     NZ,OPEN20
        LD     A,(ZFLAG1)

        BIT    ##STRM,A
        JR     Z,OPEN30
        LD     IX,(ZRO)        ;STRM RO
OPEN20: LD     HL,ELMD         ;SEQ/STRM WO
        JP     IOCALL
OPEN30: LD     B,(IY+0)        ;SEQ RO
        CALL   SERFLR
        LD     A,(ELMD)
        CP     B
        JP     NZ,ER61
        JP     INP1B0          ;First call
;
; SVC .LOPEN  ;Search for LOAD
;
LOPEN:  ENT
        CALL   PUSHR
        LD     IY,0100H        ;(ZLOG)=0
        LD     (ZLOG),IY       ;(ZRWX)=1 ;R
        LD     IY,ELMD
        CALL   ?RND
        LD     HL,LOPX
        JR     NZ,+5
        LD     HL,SERFLR
        CALL   .HL
        LD     B,80H
        CALL   TYPECK
        LD     A,(ELMD)
        RET
;
;  type check (chained or contiguas)
;
TYPECK: LD     A,(ELMD)
        CP     5
        RET    C
        LD     A,(ELMD18)
        AND    80H
        CP     B
        RET    Z
        JP     ER61
        SKP    H

;
; SVC .CLKL   ;CLOSE/KILL
;   ent A: lu, if A=0 then all-files
;       B: B=0:KILL, B<>0:CLOSE
;
CLKL:   ENT                    ;CLOSE/KILL file
        CALL   PUSHR
        OR     A
        JR     Z,CLKLA
        CALL   CL1F
        JP     DUST
;
CL1F:   SVC    .LUCHK
        RST    3
        DEFB   .LUCHK
        ENDM
        RET    C               ;LU# not found
        CALL   IO.RDY
        PUSH   AF
        CALL   ?RND
        JR     NZ,CL1FR
        BIT    ##STRM,A
        LD     A,B
        JR     Z,CL1FB
        OR     A               ;Streem I/O
        LD     IX,(ZKL)
        JR     Z,+6
        LD     IX,(ZCL)
        CALL   IOCALL
        JR     CL1F8
CL1FB:  OR     A               ;SEQ I/O
        JR     Z,CL1F8
        LD     A,(ZRWX)
        BIT    ##WOPN,A
        CALL   NZ,PRT1BX
        JR     CL1F8
CL1FR:  CALL   CLX             ;RND I/O
CL1F8:  POP    AF
        SVC    .DLSEG
        RST    3
        DEFB   .DLSEG
        ENDM
        RET
;
;  SVC .CLRIO ;clear all i/o
;
CLRIO:  ENT
        CALL   PUSHR
        LD     B,0
CLKLA:  LD     C,8EH           ;all files
CLKLA2: LD     A,C
        PUSH   BC
        SVC    .SEGAD
        RST    3
        DEFB   .SEGAD
        ENDM
        CALL   NC,CL1F
        POP    BC
        DEC    C
        JR     NZ,CLKLA2

        JP     ERRCVR
        SKP    H

;
;  search file (SEQ device)
;
SERFIL: ENT
        CALL   PUSHR           ;Search file
        LD     A,(ZFLAG1)
        BIT    ##SEQ,A
        JP     Z,ER59          ;SEQ only ok
        CALL   .ZSTRT
        LD     A,(ZDIRMX)
        LD     B,A
SERFL2: LD     HL,KEYBUF
        PUSH   BC
        IOCALL ZRO             ;RDINF
        LD     IX,(ZRO)
        CALL   IOCALL
        ENDM
        POP    BC
        SET    0,A             ;A<>0
        RET    C               ;Not found
        LD     DE,IY
        CALL   FNMTCH
        LD     A,M
        RET    Z
        DJNZ   SERFL2
        XOR    A               ;end of dir
        SCF
        RET
;
; search file for WOPEN, SAVE
;  (SEQ device)
;
SERFLW: ENT
        CALL   ?OPEND
        CALL   SERFIL
        JP     NC,ER42         ;already exist
        OR     A
        JP     Z,ER51          ;too many files
        RET
;
; search file for ROPEN
;  (SEQ device)
;
SERFLR: CALL   ?OPEND
        CALL   SERFIL
        JP     C,ER40          ;not found
        CALL   PUSHR
        LD     HL,KEYBUF
        LD     DE,IY
        PUSH   HL
        CALL   LDIR64
        POP    HL
        LD     DE,ELMD
        LD     A,M
LDIR64: LD     BC,64
        LDIR
        OR     A
        RET
        SKP    H

;
; CALL ?OPEND ; Check already opened
;
?OPEND: ENT
        LD     IX,?OPCKX
?OPEN0: ENT
        LD     (?OPEN6+1),IX
        CALL   PUSHR
        LD     A,(ZLOG)
        LD     C,A
        LD     HL,(POOL)
        PUSH   HL
?OPEN2: POP    HL
        LD     A,M
        OR     A
        RET    Z
        LD     B,A
        INC    HL
        CALL   LDDEMI
        PUSH   HL
        ADD    HL,DE
        EX     (SP),HL
        CP     8FH
        JR     NC,?OPEN2       ;non i/o seg.
        CP     C
        JR     Z,?OPEN2        ;same lu
        INC    HL              ;ZRWX
        LD     A,M
        EX     AF,AF'
        INC    HL
        LD     DE,ZEQT
        PUSH   BC
        LD     BC,300H
?OPEN4: LD     A,(DE)
        SUB    M
        OR     C
        LD     C,A
        INC    DE
        INC    HL
        DJNZ   ?OPEN4
        POP    BC
        JR     NZ,?OPEN2       ;Diff. device
        LD     A,B
?OPEN6: CALL   0               ;xxx
        JR     ?OPEN2
;
?OPCKX: LD     A,(ZFLAG2)      ;Same device
        BIT    ##1OPN,A        ;1 file only ?
        JP     NZ,ER43         ;  Yes, already open
        BIT    ##1WOP,A        ;1 file only W ?
        RET    Z               ;  No, ok
        EX     AF,AF'
        LD     B,A
        LD     A,(ZRWX)
        AND    B
        BIT    ##WOPN,A
        RET    Z
        JP     ER43
        SKP    H

;
; SVC .LOADFL
;   ent HL:loaging adrs
;   call after .DEVFN and .LOPEN
;
LOADFL: ENT
        CALL   ?RND
        JP     NZ,LDX
        LD     BC,(ELMD20)
        PUSH   BC
        XOR    A               ;first block
        IOCALL ZINP
        LD     IX,(ZINP)
        CALL   IOCALL
        ENDM
        POP    BC
        RET
;
; SVC .VRFYF  ;verify file
;   ent HL:adrs
;   call after .DEVFN, .LOPEN
;
VRFYFL: ENT
        LD     A,(ZFLAG2)
        BIT    ##CMT,A
        JP     Z,ER59
        LD     BC,(ELMD20)
        JP     CMTVRF
;
;  SVC .SAVEF  ;save file
;   ent DE:adrs
;   call after .DEVFN
;
SAVEFL: ENT
        LD     A,(ELMD)
        CP     5
        JR     C,SAVEF2
        LD     A,80H
        LD     (ELMD18),A      ;contiguas flag
SAVEF2: CALL   ?RND
        JP     NZ,SVX
        BIT    ##STRM,A
        JP     NZ,ER59
        PUSH   DE
        LD     HL,0200H
        LD     (ZLOG),HL
        CALL   ?OPEND
        LD     HL,ELMD
        LD     IY,HL
        IOCALL ZWO
        LD     IX,(ZWO)
        CALL   IOCALL
        ENDM
        LD     BC,(ELMD20)
        POP    HL
        LD     A,04H           ;F# update,unblocked
        IOCALL ZOUT
        LD     IX,(ZOUT)
        CALL   IOCALL
        ENDM

        RET
;
;
?RND:   ENT
        LD     A,(ZFLAG1)
        BIT    ##RND,A
        RET
        SKP    H

;
; SVC .DIR
;   ent A=0 ... read dir
;       A>0 ... output dir
;
FDIR:   ENT
        CALL   PUSHR
        OR     A
        JR     NZ,FDIR3
        LD     HL,100H
        LD     (ZLOG),HL
        CALL   ?OPEND
        LD     HL,ZFLAG1
        BIT    ##STRM,M
        JP     NZ,ER59         ;Streem i/o omit
        BIT    ##RND,M
        JP     NZ,LD.DIR       ;RND
        INC    HL              ;SEQ
        BIT    ##CMT,M
        JP     NZ,ER59         ;CMT ommit
        CALL   MWAIT           ;MUSIC WAIT
        LD     HL,DIRARE
        LD     BC,8            ;clear 0800H bytes
        CALL   ?CLRHL
        DEC    C
        JR     NZ,-4
        CALL   .ZSTRT
        LD     A,(ZDIRMX)
        LD     B,A
        LD     HL,DIRARE
FDIR2:  PUSH   BC
        IOCALL ZRO             ;read infomation
        LD     IX,(ZRO)
        CALL   IOCALL
        ENDM
        PUSH   AF
        LD     BC,32
        ADD    HL,BC
        LD     M,0
        POP    AF
        POP    BC
        JR     C,+4
        DJNZ   FDIR2
        JP     .ZEND
;
FDIR3:  LD     (FDIROT+1),A
        XOR    A
        LD     (DISPX),A
        LD     HL,KEYBUF
        PUSH   HL
        LD     DE,DIRM1
        LD     B,DIRM2-DIRM1
        CALL   LDHLDE
        CALL   SETDNM          ;set device name
        LD     M," "
        INC    HL
        LD     M," "
        INC    HL
        EX     DE,HL
        CALL   ?RND

        LD     IX,(ZFREE)      ;SEQ
        JR     Z,+6
        LD     IX,FREEX        ;RND
        CALL   IOCALL
        JR     C,FDIR4
        LD     HL,BC
        LD     B,0
        SVC    .ASCHL
        RST    3
        DEFB   .ASCHL
        ENDM
        LD     HL,DIRM2
        LD     B,DIRM3-DIRM2
        CALL   LDDEHL
FDIR4:  EX     DE,HL
        LD     M,0DH
        INC    HL
        LD     M,0
        POP    DE
        CALL   FDIROT          ;DIR OF dd: xxx KB FREE
;
        LD     B,64            ;max dir
        LD     HL,DIRARE
FDIR6:  CALL   FDIRS           ;mod  "name"
        LD     DE,32
        ADD    HL,DE
        DJNZ   FDIR6
        JP     DUST
;
FDIRS:  CALL   PUSHR
        LD     A,M
        OR     A
        RET    Z
        RET    M
        LD     DE,KEYBUF
        PUSH   DE
        LD     A," "
        LD     B,38
        CALL   ?SETDE
        LD     A,M
        CP     MAXMOD+1
        JR     C,+4
        LD     A,MAXMOD+1
        LD     IY,HL
        POP    DE
        PUSH   DE
        INC    DE
        LD     HL,DIRM3-3
        LD     BC,3
        ADD    HL,BC
        DEC    A
        JR     NZ,-2
        LDIR
        EX     DE,HL
        BIT    0,(IY+18)
        JR     Z,+4
        LD     M,"*"
        INC    HL
        INC    HL
        LD     M,'"'

        INC    HL
FDIRS2: LD     A,(IY+1)
        CP     0DH
        JR     Z,FDIRS4
        LD     M,A
        INC    IY
        INC    HL
        JR     FDIRS2
FDIRS4: LD     M,'"'
        INC    HL
        LD     M,0DH
        INC    HL
        LD     M,0
        POP    DE
FDIROT: LD     A,0             ;xxx output lu
        SVC    .LUCHK
        RST    3
        DEFB   .LUCHK
        ENDM
        SVC    .COUNT
        RST    3
        DEFB   .COUNT
        ENDM
        SVC    .PRSTR
        RST    3
        DEFB   .PRSTR
        ENDM
        SVC    .HALT
        RST    3
        DEFB   .HALT
        ENDM
        RET
;
DIRM1:  DEFB   0DH
        DEFM   "DIRECTORY OF "



DIRM2:  DEFM   " KB FREE."


DIRM3:  DEFM   "OBJ"           ;1
        DEFM   "BTX"           ;2
        DEFM   "BSD"           ;3
        DEFM   "BRD"           ;4
        DEFM   "RB "           ;5
        DEFM   " ? "           ;6
        DEFM   "LIB"           ;7
        DEFM   " ? "           ;8
        DEFM   " ? "           ;9
        DEFM   "SYS"           ;10
        DEFM   "GR "           ;11
        DEFM   " ? "           ;12
MAXMOD: EQU    11
        SKP    H

;
;  INIT "dev:command"
;
FINIT:  ENT
        PUSH   HL
FINIT2: XOR    A
        LD     (ZLOG),A
        LD     IX,?OPCKY
        LD     (?OPCKY+1),SP
        CALL   ?OPEN0
        POP    HL
        IOCALL ZINIT
        LD     IX,(ZINIT)
        CALL   IOCALL
        ENDM
        RET
;
?OPCKY: LD     SP,0
        LD     B,0
        SVC    .CLKL           ;KILL
        RST    3
        DEFB   .CLKL
        ENDM
        JR     FINIT2
;
; Ask Y or N
;
OKYN:   ENT
        TEST1  "Y"
        CALL   TEST1
        DEFB   "Y"
        ENDM
        RET    Z
        LD     DE,OK?MSG
        SVC    .CRTMS
        RST    3
        DEFB   .CRTMS
        ENDM
        LD     A,1
        SVC    .INKEY
        RST    3
        DEFB   .INKEY
        ENDM
        CP     "Y"
        RET    Z
        JP     BREAKZ
OK?MSG: DEFM   "OK ? [Y/N]"


        DEFB   19H             ;alpha
        DEFB   0
        SKP    H

;
; Filename check
;
CKFIL:  ENT
        LD     DE,ELMD
FNMTCH: ENT
        CALL   PUSHR
        INC    HL
        INC    DE
        LD     A,(DE)
        CP     0DH
        RET    Z
        LD     B,17
FNMTLP: LD     A,(DE)
        CP     M
        RET    NZ
        CP     0DH
        RET    Z
        INC    HL
        INC    DE
        DJNZ   FNMTLP
        OR     A
        RET
;
;
SETFNAM:ENT
        INC    HL
        LD     C,16
SETFN2: LD     A,B
        OR     A
        JR     Z,SETFN4
        LD     A,(DE)
        INC    DE
        DEC    B
        OR     A
        JR     Z,SETFN4
        CP     '"'
        JR     Z,SETFN2
        CP     ":"
        JP     Z,ER60          ;file name err
        LD     M,A
        INC    HL
        DEC    C
        JR     NZ,SETFN2
SETFN4: LD     M,0DH
        INC    HL
SETFN6: LD     A,C
        OR     A
        RET    Z
        LD     M," "
        INC    HL
        DEC    C
        JR     SETFN6
        SKP    H

;
; SVC .SEGAD  ;get segment adrs
;   ent A .... Seg No.
;   ext HL ... Buffer adrs
;
SEGADR: ENT
        LD     HL,(POOL)
SEGAD2: INC    M
        DEC    M
        SCF
        RET    Z               ;not found
        CP     M
        INC    HL
        JR     Z,SEGAD9
        PUSH   DE
        CALL   LDDEMI
        ADD    HL,DE
        POP    DE
        JR     SEGAD2
SEGAD9: INC    HL
        INC    HL
        RET
;
; SVC .DLSEG ;delete segment
;   ent A .... Seg No.
;
DELSEG: ENT
        CALL   PUSHR
        SVC    .SEGAD
        RST    3
        DEFB   .SEGAD
        ENDM
        RET    C               ;Not exist
        DEC    HL
        LD     B,M
        DEC    HL
        LD     C,M             ;BC = length
        DEC    HL              ;HL = del start
        LD     DE,HL           ;DE = del start
        INC    BC
        INC    BC
        INC    BC              ;BC = del size
        PUSH   BC
        ADD    HL,BC           ;HL = del end
        PUSH   HL
        LD     BC,HL
        LD     HL,(TMPEND)
        OR     A
        SBC    HL,BC
        LD     BC,HL           ;BC = Move bytes
        POP    HL              ;HL = del end
        LDIR
        POP    DE              ;DE = del size
        LD     HL,0
        OR     A
        SBC    HL,DE
        EX     DE,HL           ;DE= - delete size
        SVC    .ADDP1
        RST    3
        DEFB   .ADDP1

        ENDM
        OR     A
        RET
;
        SKP    H

;
; SVC .OPSEG ;open segment
;   ent A .... Seg No.
;       DE ... Buffer length
;   ext HL ... Buffer adrs
;
OPSEG:  ENT
        PUSH   AF
        PUSH   BC
        PUSH   DE
        PUSH   DE
        INC    DE
        INC    DE
        INC    DE
        LD     HL,(TMPEND)
        EX     DE,HL           ;
        ADD    HL,DE           ; ADD DE,HL
        EX     DE,HL           ; DE = new TMPEND
        JP     C,ER06
        PUSH   HL
        LD     HL,-512
        ADD    HL,SP
        SBC    HL,DE
        JR     C,ER06
        LD     HL,(MEMLMT)
        DEC    H
        DEC    H
        SBC    HL,DE
        JR     C,ER06
        POP    HL
        PUSH   HL              ;old TMPEND
        LD     BC,(VARST)      ;POOL END
        OR     A
        SBC    HL,BC
        LD     BC,HL           ;BC = move bytes
        POP    HL              ;HL = old TMPEND
        INC    BC
        LDDR
        POP    DE              ;Buffer length
        LD     M,A             ;Seg No.
        INC    HL
        LD     M,E             ;Size
        INC    HL
        LD     M,D
        INC    HL
        PUSH   HL
        INC    DE              ;LEN+1
        PUSH   DE
OPSEG2: LD     M,0
        INC    HL
        DEC    DE
        LD     A,D
        OR     E
        JR     NZ,OPSEG2
        POP    DE              ;LEN+1
        INC    DE
        INC    DE              ;LEN+3
        SVC    .ADDP1
        RST    3
        DEFB   .ADDP1

        ENDM
        POP    HL
        POP    DE
        POP    BC
        POP    AF
        RET
        SKP    H

;
        ERENT  03
ER03:   ENT
        IFD    @2
        ENDIF
        IFU    @2
        LD     A,03
        ENDIF
        DEFB   21H
        ENDM
        ERENT  06
ER06:   ENT
        IFD    @2
        ENDIF
        IFU    @2
        LD     A,06
        ENDIF
        DEFB   21H
        ENDM
        ERENT  28,1
ER28:   ENT
        IFD    1
        LD     A,28+80H
        ENDIF
        IFU    1
        ENDIF
        DEFB   21H
        ENDM
        ERENT  40,1
ER40:   ENT
        IFD    1
        LD     A,40+80H
        ENDIF
        IFU    1
        ENDIF
        DEFB   21H
        ENDM
        ERENT  41,1
ER41:   ENT
        IFD    1
        LD     A,41+80H
        ENDIF
        IFU    1
        ENDIF
        DEFB   21H
        ENDM
        ERENT  42,1
ER42:   ENT
        IFD    1

        LD     A,42+80H
        ENDIF
        IFU    1
        ENDIF
        DEFB   21H
        ENDM
        ERENT  43,1
ER43:   ENT
        IFD    1
        LD     A,43+80H
        ENDIF
        IFU    1
        ENDIF
        DEFB   21H
        ENDM
        ERENT  46,1
ER46:   ENT
        IFD    1
        LD     A,46+80H
        ENDIF
        IFU    1
        ENDIF
        DEFB   21H
        ENDM
        ERENT  50,1
ER50:   ENT
        IFD    1
        LD     A,50+80H
        ENDIF
        IFU    1
        ENDIF
        DEFB   21H
        ENDM
        ERENT  51,1
ER51:   ENT
        IFD    1
        LD     A,51+80H
        ENDIF
        IFU    1
        ENDIF
        DEFB   21H
        ENDM
        ERENT  52,1
ER52:   ENT
        IFD    1
        LD     A,52+80H
        ENDIF
        IFU    1
        ENDIF
        DEFB   21H
        ENDM
        ERENT  53,1
ER53:   ENT
        IFD    1
        LD     A,53+80H
        ENDIF
        IFU    1
        ENDIF
        DEFB   21H
        ENDM

        ERENT  54,1
ER54:   ENT
        IFD    1
        LD     A,54+80H
        ENDIF
        IFU    1
        ENDIF
        DEFB   21H
        ENDM
        ERENT  55,1
ER55:   ENT
        IFD    1
        LD     A,55+80H
        ENDIF
        IFU    1
        ENDIF
        DEFB   21H
        ENDM
        ERENT  58
ER58:   ENT
        IFD    @2
        ENDIF
        IFU    @2
        LD     A,58
        ENDIF
        DEFB   21H
        ENDM
        ERENT  59,1
ER59:   ENT
        IFD    1
        LD     A,59+80H
        ENDIF
        IFU    1
        ENDIF
        DEFB   21H
        ENDM
        ERENT  60,1
ER60:   ENT
        IFD    1
        LD     A,60+80H
        ENDIF
        IFU    1
        ENDIF
        DEFB   21H
        ENDM
        ERENT  61,1
ER61:   ENT
        IFD    1
        LD     A,61+80H
        ENDIF
        IFU    1
        ENDIF
        DEFB   21H
        ENDM
        ERENT  63,1
ER63:   ENT
        IFD    1
        LD     A,63+80H
        ENDIF
        IFU    1

        ENDIF
        DEFB   21H
        ENDM
        ERENT  64
ER64:   ENT
        IFD    @2
        ENDIF
        IFU    @2
        LD     A,64
        ENDIF
        DEFB   21H
        ENDM
ER68:   ENT
        LD     A,68+80H
        JP     ERRORJ
;
;
;  Error recover routine
;
ERRCVR: ENT
        LD     A,(QSEG)
        OR     A
        LD     B,0
        CALL   NZ,CLKL         ;KILL
        CALL   FLOFF           ;FD motor off
        CALL   QDOFF           ;QD motor off
        XOR    A
        LD     (QSEG),A
        JP     DUST            ;I/O open check
;JP MLDSP
        DEFS   3
;
QSEG:   ENT
        DEFB   0
;
        END

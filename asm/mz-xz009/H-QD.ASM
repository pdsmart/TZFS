; ----------------------------
; MZ-800 Monitor  QD driver
; FI:M-QD  ver 0.2A  9.5.84
; ----------------------------
;
        INCLD  MACRO
;
;
;
$QD:    ENT
        DEFW   $USR
        DEFM   "QD"
        DEFW   0
        DEFB   5FH             ;Seq, W, R
        DEFB   40H             ;1OPN
        DEFB   32              ;Max dir
        DEFW   Q.INI
        DEFW   Q.RINF
        DEFW   Q.WINF
        DEFW   Q.ON
        DEFW   1024
        DEFW   Q.RDAT
        DEFW   Q.WDAT
        DEFW   0               ;DELETE
        DEFW   0               ;WRDIR
        DEFW   Q.FREE
;
;
Q.FREE: XOR    A
        SCF
        RET
;
;
Q.INI:  RET    C
        TEST1  "Y"
        CALL   TEST1
        DEFB   "Y"
        ENDM
        JR     Z,Q.INI2
        OR     A
        JP     NZ,ER03
        CALL   OKYN
Q.INI2: CALL   Q.RDY
        RET    C
        SVC    .DI
        RST    3
        DEFB   .DI
        ENDM
        LD     C,2
        JR     QDIOX
        SKP    H

;
;  Dir search start
;
Q.ON:   OR     A
        JR     NZ,QDOFF
        SVC    .DI
        RST    3
        DEFB   .DI
        ENDM
        XOR    A
        LD     (FNUPS),A       ;KILL #
        LD     C,5
        CALL   QDIOR
        LD     BC,1
;
QDIOR:  LD     (QDPC),HL
        LD     (QDPE),DE
        LD     HL,QDPB
        LD     M,B
        DEC    HL
        LD     M,C
        JR     QDIO
;
QDOFF:  ENT
        CALL   PUSHR
        LD     C,6
        JR     QDIOX
;
;  Read inf
;   ent HL:adrs
;
Q.RINF: LD     BC,3
        LD     DE,64
        CALL   QDIOR
        RET    NC
        CP     40              ;not found
        SCF
        RET    NZ
        LD     A,0
        RET
;
; Read data
;  ent HL:buffer adars
;      BC:byte size
;
Q.RDAT: SVC    .DI
        RST    3
        DEFB   .DI
        ENDM
        LD     DE,BC
        LD     BC,0103H
;
QDIOX:  CALL   QDIOR
        SVC    .EI
        RST    3
        DEFB   .EI
        ENDM
        RET
        SKP    H

;
; Write inf
;
Q.WINF: LD     A,37H           ;SCF
        LD     (Q.WD1),A
Q.RDY:  LD     BC,0101H
        JR     QDIOR
;
; Write data
;
Q.WDAT: PUSH   AF
        SVC    .DI
        RST    3
        DEFB   .DI
        ENDM
Q.WD1:  XOR    A               ;XOR A / SCF
        JR     NC,Q.WD2
        LD     A,AFH           ;XOR A
        LD     (Q.WD1),A
        CALL   SERFLW          ;First time only
        LD     (QDPG),HL
        LD     HL,ELMD
        LD     DE,64
        POP    AF
        JR     Q.WD3
;
Q.WD2:  LD     (QDPG),HL
        POP    AF
        SET    0,A
Q.WD3:  LD     (QDPI),BC
        LD     B,A
        LD     C,4
        JR     QDIOX
;
;
;QD WORK
;
;
QDTBL:  ENT
QDPA:   ENT
        DEFB   0
QDPB:   ENT
        DEFB   0
QDPC:   ENT
        DEFW   0
QDPE:   ENT
        DEFW   0
QDPG:   ENT
        DEFW   0
QDPI:   ENT
        DEFW   0
;
HDPT:   ENT
        DEFB   0
HDPT0:  ENT
        DEFB   0
;
FNUPS:  DEFB   0
FNUPS1: DEFB   0
FNUPF:  DEFB   0

;
FNA:    ENT
        DEFB   0
FNB:    ENT
        DEFB   0
;
MTF:    ENT
        DEFB   0
RTYF:   ENT
        DEFB   0
SYNCF:  ENT
        DEFB   0
;
RETSP:  ENT
        DEFW   0
;
FMS:    EQU    EFFFH
;
        SKP    H

;
;------------------------------
;
; QDIO
;
;------------------------------
;
;
QDIO:   ENT
        LD     A,5             ;Retry 5
        LD     (RTYF),A
;
RTY:    DI
        CALL   QMEIN
        EI
        RET    NC
        PUSH   AF
        CP     40
        JR     Z,RTY4
        CALL   MTOF
        LD     A,(QDPA)
        CP     4               ;Write ?
        JR     NZ,RTY3
        LD     A,(FNUPF)
        OR     A
        JR     Z,RTY5
        XOR    A               ;FNUPF CLR
        LD     (FNUPF),A
        LD     A,(FNA)
        PUSH   HL              ;RETSP <= SP-2
        LD     (RETSP),SP
        POP    HL
;
        DI
        CALL   QDSVFN
        EI
        JR     C,RTY2
        CALL   MTOF
;
RTY3:   CP     3               ;Read ?
        JR     NZ,RTY5
        LD     HL,HDPT
        DEC    (HL)
;
RTY5:   POP    AF
        PUSH   AF
        CP     41
        JR     NZ,RTY2
;
        LD     HL,RTYF
        DEC    (HL)
        JR     Z,RTY2
        POP    AF
        LD     A,(FNUPS1)
        LD     (FNUPS),A
        JR     RTY
;
RTY2:   CALL   WRCAN
        CALL   QDHPC
RTY4:   POP    AF

        RET
;
        SKP    H

;
QMEIN:  LD     (RETSP),SP
        LD     A,(QDPA)
        DEC    A
        JR     Z,QDRC          ;Ready Check
        DEC    A
        JR     Z,QDFM          ;Format
        DEC    A
        JR     Z,QDRD          ;Read
        DEC    A
        JP     Z,QDWR          ;Write
        DEC    A
        JR     Z,QDHPC         ;Head Point Clear
        JR     MTOFX           ;Motor Off
;
;-------------------------
;
; Head Point Clear
;
;-------------------------
;
QDHPC:  ENT
        PUSH   AF
        XOR    A
        LD     (HDPT),A
        POP    AF
        RET
;
;-------------------------
;
; Ready Check
;
;-------------------------
;
QDRC:   ENT
        LD     A,(QDPB)
        JP     QREDY
;
        SKP    H

;
;-------------------------
;
; Format
;
;-------------------------
;
QDFM:   ENT
        XOR    A
        CALL   QDSVFN
        CALL   SYNCS2
        LD     BC,FMS
        LD     A,AAH
;
QDFM1:  CPL
        LD     D,A
        CALL   TRANS
        DEC    BC
        LD     A,B
        OR     C
        JR     Z,QDFM2
        LD     A,D
        JR     QDFM1
;
QDFM2:  CALL   EOM
        CALL   MTOF
        CALL   MTON
        LD     A,(FNB)
        DEC    A
        JR     NZ,FMERR
        CALL   SYNCL2
        LD     BC,FMS
        LD     E,55H
QDFM3:  CP     E
        JR     NZ,FMERR
        DEC    BC
        LD     A,B
        OR     C
        JR     Z,QDFM4
        LD     A,E
        CPL
        LD     E,A
        CALL   RDATA
        JR     QDFM3
;
QDFM4:  CALL   RDCRC
MTOFX:  JP     MTOF
;
FMERR:  LD     A,41            ;Hard Err
        SCF
        RET
;
        SKP    H

;
;-------------------------
;
; Read
;
;-------------------------
;
QDRD:   ENT
        LD     A,(MTF)
        OR     A
        CALL   Z,MTON
        CALL   HPS
        RET    C
        CALL   BRKC
;
        CALL   RDATA
        LD     C,A
        CALL   RDATA
        LD     B,A
        OR     C               ;Byte size zero check
        JP     Z,QDWE1
        LD     HL,(QDPE)       ;Byte size check
        SBC    HL,BC
        JP     C,QDWE1
        LD     HL,(QDPC)
;
;Block Data Read
;
BDR:    CALL   RDATA
        LD     (HL),A
        INC    HL
        DEC    BC
        LD     A,B
        OR     C
        JR     NZ,BDR
        CALL   RDCRC
        LD     A,(QDPB)
        BIT    0,A
        JR     NZ,MTOFX
        RET
;
        SKP    H

;
;Head Point Search
;
HPS:    ENT
        LD     HL,FNB
        DEC    (HL)
        JR     Z,HPNFE         ;Not Found
        CALL   SYNCL2
        LD     C,A             ;BLKFLG => C reg
        LD     A,(HDPT)
        LD     HL,HDPT0
        CP     (HL)            ;Search ok ?
        JR     NZ,HPS1
        INC    A               ;HDPT count up
        LD     (HDPT),A
        LD     (HL),A          ;HDPT0 count up
        LD     A,(QDPB)
        XOR    C
        RRA
        RET    NC              ;=
;
;Dummy read
;
DMR:    CALL   RDATA
        LD     C,A
        CALL   RDATA
        LD     B,A
;
DMR1:   CALL   RDATA
        DEC    BC
        LD     A,B
        OR     C
        JR     NZ,DMR1
        CALL   RDCRC
        JR     HPS             ;next
;
HPS1:   INC    (HL)
        JR     DMR
;
HPNFE:  LD     A,40            ;Not Found
        SCF
        RET
;
        SKP    H

;
;-------------------------
;
; Write
;
;-------------------------
;
QDWR:   ENT
        LD     A,(FNUPS)
        LD     (FNUPS1),A
        LD     A,(MTF)
        OR     A
        JR     NZ,QDWR1
        CALL   MTON
        LD     A,(FNUPS)
        LD     HL,FNB
        ADD    A,(HL)
        LD     (FNB),A
        INC    A
        LD     (HDPT),A
        CALL   HPS
        JP     NC,QDWE1        ;Hard err
QDWR1:  LD     A,(QDPB)
        LD     B,A
        AND    1
        JR     NZ,QDWR2
        LD     DE,QDPC
        LD     A,B
        RES    2,A
        CALL   BDW
        CALL   BRKC
;
QDWR2:  LD     DE,QDPG
        LD     A,(QDPB)
        SET    0,A
        CALL   BDW
        CALL   MTOF
        CALL   BRKC
;
        LD     A,(QDPB)
        AND    4
        JR     Z,NFNUP
        LD     A,(FNA)
        LD     HL,FNUPS
        ADD    A,(HL)
        CALL   QDSVFN
        LD     A,1
        LD     (FNUPF),A
QDWR4:  LD     A,(FNA)
        LD     HL,FNUPS1
        ADD    A,(HL)
        INC    A
        LD     (FNB),A
        INC    A
        LD     (HDPT),A
        CALL   HPS
        JR     NC,QDWE1
        LD     A,(QDPB)
        AND    1
        JR     NZ,QDWR3

        LD     DE,QDPC
        CALL   BDV
        RET    C
QDWR3:  LD     DE,QDPG
        CALL   BDV
        RET    C
        LD     A,(FNUPF)
        OR     A
        JR     Z,QDWR5
WRCAN:  XOR    A
        LD     (FNUPS),A
        LD     (FNUPF),A
;
QDWR5:  JP     MTOF
;
QDWE1:  LD     A,41
        SCF
        RET
;
NFNUP:  CALL   MTON
        JR     QDWR4
;
;Block Data Write
;
BDW:    PUSH   AF
        LD     HL,FNUPS
        INC    (HL)
        CALL   SYNCS2
        POP    AF
        CALL   TRANS
        CALL   RSET
        LD     A,C
        CALL   TRANS
        LD     A,B
        CALL   TRANS
;
BDW1:   LD     A,(HL)
        CALL   TRANS
        INC    HL
        DEC    BC
        LD     A,B
        OR     C
        JR     NZ,BDW1
        JP     EOM
;
;HL,BC SET
;
RSET:   EX     DE,HL
        LD     E,(HL)
        INC    HL
        LD     D,(HL)
        INC    HL
        LD     C,(HL)
        INC    HL
        LD     B,(HL)
        EX     DE,HL
        RET
;
;Block Data Verify
;

BDV:    CALL   SYNCL2
        CALL   RSET
        CALL   RDATA
        CP     C
        JR     NZ,QDWE1
        CALL   RDATA
        CP     B
        JR     NZ,QDWE1
;
BDV1:   CALL   RDATA
        CP     (HL)
        JR     NZ,QDWE1
        INC    HL
        DEC    BC
        LD     A,B
        OR     C
        JR     NZ,BDV1
        JP     RDCRC
;
;
; i/o port adrs
;
SIOAD:  EQU    F4H             ; sio A data
SIOBD:  EQU    F5H             ; sio B data
SIOAC:  EQU    F6H             ; sio A control
SIOBC:  EQU    F7H             ; sio B control
;
;
;
; Ready & Write protect
;    Acc = '0' : Ready check
;    Acc = '1' : & Write Protect
;
QREDY:  ENT
        LD     B,A
        LD     A,02H           ;SIO hard check
        OUT    (SIOBC),A
        LD     A,81H
        OUT    (SIOBC),A
        LD     A,02H
        OUT    (SIOBC),A
        IN     A,(SIOBC)
        AND    81H
        CP     81H
        JP     NZ,IOE50        ;Not ready
        LD     A,10H
        OUT    (SIOAC),A
        IN     A,(SIOAC)
        LD     C,A
        AND    08H
        JP     Z,IOE50         ;Not ready
        LD     A,B
        OR     A
        RET    Z               ;No err
        LD     A,C
        AND    20H
        RET    NZ              ;No err
        JP     IOE46           ;Write protect
;
        SKP    H

;
;
; Write FN
;
QDSVFN: ENT
        PUSH   AF
        LD     HL,SIOSD
        LD     B,09H
        CALL   LSINT           ;save init
;
SREDY:  LD     A,10H
        OUT    (SIOAC),A
        IN     A,(SIOAC)
        AND    8
        JP     Z,IOE50         ;Not ready
        LD     A,10H
        OUT    (SIOBC),A
        IN     A,(SIOBC)
        AND    8
        JR     Z,SREDY
        LD     BC,00E9H        ;Wait 160ms
        CALL   TIMW
        CALL   SBRK            ;Send Break
        CALL   SYNCS1          ;FN Only SYNC
        POP    AF
        CALL   TRANS           ;FN=A
        CALL   EOM             ;CRC FLAG(7EH)
        JR     FNEND
;
;
;
; MTON -- QD MOTOR ON
;         READ FILE NUMBER
;         READ &CHECK CRC,FLAG
;
MTON:   ENT
        LD     HL,SIOLD
        LD     B,0BH
        CALL   LSINT           ;load init
;
LREDY:  LD     A,10H
        OUT    (SIOAC),A
        IN     A,(SIOAC)
        AND    8
        JP     Z,IOE50         ;Not ready
        CALL   BRKC
        LD     A,10H
        OUT    (SIOBC),A
        IN     A,(SIOBC)
        AND    8
        JR     Z,LREDY
        LD     BC,00E9H        ;Wait 160ms
        CALL   TIMW
        CALL   SYNCL1          ;LOAD SYNC
        LD     (FNA),A
        INC    A
        LD     (FNB),A
        CALL   RDCRC
FNEND:  LD     HL,SYNCF
        SET    3,(HL)

        XOR    A
        LD     (HDPT0),A
        RET
;
        SKP    H

;
;    sio initial
;
;
LSINT:  LD     C,SIOAC
        OTIR
        LD     A,05H
        LD     (MTF),A
        OUT    (SIOBC),A
        LD     A,80H
        OUT    (SIOBC),A
        RET
;
; Motor off
;
MTOF:   ENT
        PUSH   AF
        LD     A,05H
        OUT    (SIOAC),A
        LD     A,60H
        OUT    (SIOAC),A       ;WRGT OFF,TRANS DISABLE
        LD     A,05H
        OUT    (SIOBC),A
        XOR    A
        LD     (MTF),A
        OUT    (SIOBC),A
        POP    AF
        RET
;
;
        SKP    H

;
; SYNCL1 -- LOAD F.N SYNC ONLY
;                (SEND BREAK 110ms)
; SYNCL2 -- LOAD FIRST FILE SYNC
;                (SEND BREAK 110ms)
; SYNCL3 -- LOAD FILES SYNC
;                (SEND BREAK 002ms)
;
SYNCL2: ENT
        LD     A,58H
        LD     B,0BH
        LD     HL,SIOLD
        CALL   SYNCA
        LD     HL,SYNCF
        BIT    3,(HL)
        LD     BC,3            ;WAIT 2ms
        JR     Z,TMLPL
        RES    3,(HL)
SYNCL1: LD     BC,00A0H        ;WAIT 110ms
;
TMLPL:  CALL   TIMW
        LD     A,05H
        OUT    (SIOBC),A
        LD     A,82H
        OUT    (SIOBC),A
        LD     A,03H
        OUT    (SIOAC),A
        LD     A,D3H
        OUT    (SIOAC),A
        LD     BC,2CC0H        ;loop 220ms
;
SYNCW0: LD     A,10H
        OUT    (SIOAC),A
        IN     A,(SIOAC)
        AND    10H
        JR     Z,SYNCW1
        DEC    BC
        LD     A,B
        OR     C
        JR     NZ,SYNCW0
        JP     IOE54           ;Un format
;
SYNCW1: LD     A,03H
        OUT    (SIOAC),A
        LD     A,C3H
        OUT    (SIOAC),A
        LD     B,9FH           ;loop 3ms
;
SYNCW2: LD     A,10H
        OUT    (SIOAC),A
        IN     A,(SIOAC)
        AND    01H
        JR     NZ,SYNCW3
        DEC    B
        JR     NZ,SYNCW2
        JP     IOE54           ;Un format
;
SYNCW3: LD     A,03H
        OUT    (SIOAC),A
        LD     A,C9H

        OUT    (SIOAC),A
        CALL   RDATA
        JP     RDATA
;
;
;
; SYNCS1 -- SAVE F.N SYNC
;                (SEND BREAK 220ms)
; SYNCS2 -- SAVE FIRST FILE SYNC
;                (SEND BREAK 220ms)
; SYNCS3 -- SAVE FILES SYNC
;                (SEND BREAK 020ms)
;
SYNCS2: ENT
        LD     A,98H
        LD     B,09H
        LD     HL,SIOSD
        CALL   SYNCA
        CALL   SBRK
;
        LD     HL,SYNCF
        BIT    3,(HL)
        LD     BC,001DH        ;WAIT 20ms
        JR     Z,TMLPS
        RES    3,(HL)
SYNCS1: LD     BC,0140H        ;WAIT 220ms
;
TMLPS:  CALL   TIMW
        LD     A,05H
        OUT    (SIOAC),A
        LD     A,EFH
        OUT    (SIOAC),A
        LD     BC,1            ;WAIT 0.7ms
        CALL   TIMW
        LD     A,C0H
        OUT    (SIOAC),A
        LD     A,A5H
        JR     TRANS
;
;
;
; SBRK -- SEND BREAK (00H)
;
SBRK:   ENT
        LD     A,05H
        OUT    (SIOAC),A
        LD     A,FFH
        OUT    (SIOAC),A
        RET
;
;
;
SYNCA:  LD     C,SIOAC
        OUT    (C),A
        LD     A,5
        OUT    (SIOBC),A
        LD     A,80H
        OUT    (SIOBC),A
        OTIR
        RET

;
        SKP    H

;
;
;
; EOM -- End off message
;         Save CRC#1,#2,FLAG
;         File space check
;
;
EOM:    ENT
        LD     BC,1            ;WAIT 0.7ms
        CALL   TIMW
        LD     A,10H
        OUT    (SIOBC),A
        IN     A,(SIOBC)
        AND    8
        RET    NZ
        JP     IOE53           ;NO file space
;
; RDCRC -- READ CRC & CHECK
;
RDCRC:  ENT
        LD     B,3
RDCR1:  CALL   RDATA
        DJNZ   RDCR1
RDCR2:  IN     A,(SIOAC)
        RRCA
        JR     NC,RDCR2        ; Rx Available
        LD     A,01H
        OUT    (SIOAC),A
        IN     A,(SIOAC)
        AND    40H
        JR     NZ,IOE41        ;Hard err
        OR     A
        RET
;
        SKP    H

;
; Save 1 chr by Acc
;     & ready check
;
TRANS:  ENT
        PUSH   AF
TRA1:   IN     A,(SIOAC)
        AND    4               ;TRANS buf null
        JR     Z,TRA1
        POP    AF
        OUT    (SIOAD),A
NRCK:   LD     A,10H
        OUT    (SIOAC),A
        IN     A,(SIOAC)
        AND    08H
        JP     Z,IOE50         ;Not ready
        RET
;
; Read data (1 chr)
;
RDATA:  ENT
        CALL   NRCK
        IN     A,(SIOAC)       ;RR0
        RLCA
        JR     C,IOE41         ;Hard err
        RRCA
        RRCA
        JR     NC,RDATA
        IN     A,(SIOAD)
        OR     A
        RET
;
        SKP    H

;
; i/o err
;
IOE41:  LD     A,41            ;Hard err
        DEFB   21H
IOE46:  LD     A,46            ;Write protect
        DEFB   21H
IOE50:  LD     A,50            ;Not ready
        DEFB   21H
IOE53:  LD     A,53            ;No file space
        DEFB   21H
IOE54:  LD     A,54            ;Un format
        LD     SP,(RETSP)
        SCF
        RET
;
;
;---------------------------------
;
;   wait  timer  clock 3.54368MHz
;
; BC=001H=  0.7ms(  0.698ms)
;    003H=  2.0ms(  2.072ms)
;    01DH= 20.0ms( 19.929ms)
;    0A0H=110.0ms(109.899ms)
;    0E9H=160.0ms(160.036ms)
;    140H=220.0ms(219.787ms)
;
;---------------------------------
;
TIMW:   PUSH   AF
TIMW1:  LD     A,150           ;MZ-1500=152
TIMW2:  DEC    A
        JR     NZ,TIMW2
        DEC    BC
        LD     A,B
        OR     C
        JR     NZ,TIMW1
        POP    AF
        RET
;
        SKP    H

;
;--------------------------------
;
; SIO CH A COMMAND CHAIN
;
; SIOLD -- LOAD INIT. DATA
; SIOSD -- SAVE INIT. DATA
;
;--------------------------------
;
SIOLD:  DEFB   58H             ;CHANNEL RESET
        DEFB   04H             ;POINT WR4
        DEFB   10H             ;X1 CLOCK
        DEFB   05H             ;POINT WR1
        DEFB   04H             ;CRC-16
        DEFB   03H             ;POINT WR3
        DEFB   D0H             ;ENTER HUNT PHASE
;Rx 8bits
        DEFB   06H             ;POINT WR6
        DEFB   16H             ;SYNC CHR(1)
        DEFB   07H             ;POINT WR7
        DEFB   16H             ;SYNC CHR(2)
;
SIOSD:  DEFB   98H             ;CHANNEL RESET
;Tx CRC Generator reset
        DEFB   04H             ;POINT WR4
        DEFB   10H             ;X1 CLOCK
        DEFB   06H             ;POINT WR6
        DEFB   16H             ;SYNC CHR(1)
        DEFB   07H             ;POINT WR7
        DEFB   16H             ;SYNC CHR(2)
        DEFB   05H             ;POINT WR5
        DEFB   6DH             ;Tx CRC ENABLE
;
;
; BREAK CHECK
;
BRKC:   LD     A,E8H
        OUT    (LSD0),A
        NOP
        IN     A,(LSD1)
        AND    81H
        RET    NZ
        CALL   WRCAN
        JP     BREAKX          ;Can't CONT
;
;
; -----------------------------
; MZ-800  monitor
;         LDALL
;         SVALL
;         ver 0.1A 08.08.84
; -----------------------------
;
;   RAM i/o port
;
RCADR:  EQU    EBH             ;RAM file ctrl port
RDADR:  EQU    EAH             ;RAM file data port
;
;   RAM equ table

;
RMLIM:  EQU    0000H           ;RAM file limit
RMADR:  EQU    0002H           ;RAM file usage
RMTOP:  EQU    0010H           ;RAM file top adrs
;
;   LDAL,SVAL WORK
;
RMFRE:  DEFW   0
FAS:    DEFW   0
NFT:    DEFW   0               ;1 File top
NBT:    DEFW   0               ;1 Block top
;
FLAGF:  DEFB   0
FNUPB:  DEFB   0
;
BLKF:   DEFB   0
BLKSL:  DEFB   0
BLKSH:  DEFB   0
;
;  SVC .LSALL
;    ent A=0 ... LOAD ALL
;        A=1 ... SAVE ALL
;
LSALL:  ENT
        CALL   PUSHR
        LD     HL,LDALM
        OR     A
        JR     Z,+5
        LD     HL,SVALM
        LD     (LSAL1+1),HL
        SVC    .CLRIO
        RST    3
        DEFB   .CLRIO
        ENDM
        CALL   QDHPC
        PUSH   HL
        LD     (RETSP),SP
        POP    HL
        XOR    A
        CALL   QREDY
        JR     C,LSAL2
        LD     A,5             ;max retry
        LD     (RTYF),A
LSAL3:  SVC    .DI
        RST    3
        DEFB   .DI
        ENDM
LSAL1:  CALL   0               ;xxx LDALM or SVALM
        CALL   MTOF
        SVC    .EI
        RST    3
        DEFB   .EI
        ENDM
        RET    NC
        CP     41
        JR     NZ,LSAL2
        LD     HL,RTYF
        DEC    M
        JR     NZ,LSAL3
        LD     A,41

LSAL2:  JP     ERRORJ
        SKP    H

;
;  LDALL main roution
;
;
LDALM:  LD     (RETSP),SP
        LD     HL,RMLIM
        CALL   EMLD2
        DEC    DE              ;RMFRE-end point buffer
        DEC    DE              ;end point buffer(2byte)
        LD     (RMFRE),DE      ;RAM buffer MAX adrs
        LD     HL,RMADR
        CALL   EMLD2
        LD     HL,RMTOP
        OR     A
        SBC    HL,DE
        JP     NZ,RMER         ;RAM Not init
        LD     (NFT),DE        ;first NFT set(0010H)
        INC    DE
        INC    DE
        LD     (NBT),DE        ;first NBT set(0012H)
        LD     HL,FAS
        LD     M,0             ;1 file byte size clear
        INC    HL
        LD     M,0
        CALL   MTON
;
LDALN:  LD     HL,FNB
        DEC    M
        JP     Z,LDEND
        CALL   SYNCL2
        LD     (BLKF),A
        CALL   RDATA
        LD     (BLKSL),A
        CALL   RDATA
        LD     (BLKSH),A
;
        LD     HL,(BLKSL)
        LD     DE,(NBT)
        ADD    HL,DE           ;NBT+Block size
        JR     C,LDALEE        ;over
        LD     BC,2
        ADD    HL,BC           ;HL+BLKF+BLKS(H,L)
LDALEE: JP     C,LDALE         ;64K over
        LD     BC,(RMFRE)
        SBC    HL,BC           ;usedadrs-maxused
        JR     Z,FBUF0         ;free just
        JP     NC,LDALE        ;NTB+lodingsize+3>free
FBUF0:  LD     HL,BLKF
        LD     BC,3
        CALL   EMSVD
        EX     DE,HL
        LD     DE,(BLKSL)
        LD     A,D             ;size zero check
        OR     E
        JP     Z,IOE41         ;size zero error
;
;
LEQM:   IN     A,(SIOAC)
        RLCA
        JR     C,LEQME

        RRCA
        RRCA
        JR     NC,LEQM
        IN     A,(SIOAD)
        LD     C,RCADR
        LD     B,H
        OUT    (C),L
        DEC    C
        OUT    (C),A
        INC    HL
        DEC    DE
        LD     A,D
        OR     E
        JR     NZ,LEQM
        CALL   RDCRC
        LD     (NBT),HL
        LD     HL,(FAS)        ;1 file all size
        LD     DE,(BLKSL)
        ADD    HL,DE
        INC    HL
        INC    HL
        INC    HL
        LD     (FAS),HL
        LD     A,(BLKF)
        BIT    2,A
        JR     NZ,LDALO        ;end block ?
;
LDALP:  CALL   BRKCHK
        JP     NZ,LDALN
        JP     BREAKZ
;
LDALO:  LD     DE,(NFT)
        ADD    HL,DE
        INC    HL
        INC    HL
        LD     (NFT),HL        ;next NFT
        PUSH   HL
        EX     DE,HL
        LD     DE,(FAS)
        CALL   EMSV2
        LD     HL,0
        LD     (FAS),HL
        POP    HL
        INC    HL
        INC    HL
        LD     (NBT),HL
        JR     LDALP
;
LDEND:  LD     HL,(NFT)
        LD     DE,RMADR
        EX     DE,HL
        CALL   EMSV2
        EX     DE,HL
        NOP
        LD     DE,0
        CALL   EMSV2
        RET
;
LDALE:  CALL   LDEND
        LD     A,53

LEQME:  SCF
        RET
;
        SKP    H

;
;  SVALL main roution
;
SVALM:  LD     (RETSP),SP
        XOR    A
        LD     (FNUPB),A
        LD     (FLAGF),A
        LD     (FNUPS),A
        LD     HL,RMTOP
        CALL   EMLD2
        LD     A,D
        OR     E
        RET    Z               ;RAM Not file
;
        CALL   MTON
        LD     A,(FNB)
        DEC    A
        JP     NZ,QDER         ;QD Not init
        LD     HL,RMTOP
;
SVALN:  CALL   EMLD2
        LD     (FAS),DE
        LD     A,D
        OR     E
        JR     Z,SVALQ
        INC    HL
        INC    HL
;
;
SVALO:  PUSH   HL
        CALL   SYNCS2
        POP    HL
        CALL   EMLD1
        CALL   TRANS
        INC    HL
        CALL   EMLD2
        LD     (BLKSL),DE
        LD     A,E
        CALL   TRANS
        LD     A,D
        CALL   TRANS
        INC    HL
        INC    HL
SEQM:   LD     C,RCADR
        LD     B,H
        OUT    (C),L
        DEC    C
        IN     B,(C)
;
SEQM1:  IN     A,(SIOAC)
        AND    4
        JR     Z,SEQM1
        LD     A,B
        OUT    (SIOAD),A
        INC    HL
        DEC    DE
        LD     A,D
        OR     E
        JR     NZ,SEQM
;

;   check EOM
;
        LD     BC,1
        CALL   TIMW
        LD     A,10H
        OUT    (SIOBC),A
        IN     A,(SIOBC)
        AND    8
        JR     NZ,SEQM2
        LD     A,53
        LD     (FLAGF),A
        JP     SVALQ
;
SEQM2:  PUSH   HL
        LD     HL,FNUPS
        INC    M
        CALL   BRKCHK
        JP     Z,BREAKZ
        LD     HL,(FAS)
        LD     DE,(BLKSL)
        LD     BC,3
        XOR    A
        SBC    HL,DE
        SBC    HL,BC
        JR     Z,SVALP
        LD     (FAS),HL
        POP    HL
        JR     SVALO
;
SVALP:  POP    HL
        LD     A,(FNUPS)
        LD     (FNUPB),A
        JP     SVALN
;
        SKP    H

;
SVALQ:  LD     A,(FNUPB)
        LD     (FNUPS),A
        CALL   MTOF
        CALL   MTON
        LD     HL,RMTOP
;
SVALT:  CALL   EMLD2
        LD     (FAS),DE
        INC    HL
        INC    HL
;
SVALR:  LD     A,(FNUPB)
        DEC    A
        JP     Z,SVALU
        LD     (FNUPB),A
;
        PUSH   HL
        CALL   SYNCL2
        POP    HL
        LD     D,A
        CALL   EMLD1
        CP     D
        JR     NZ,QDHER
        INC    HL
        CALL   EMLD2
        LD     (BLKSL),DE
        CALL   RDATA
        CP     E
        JR     NZ,QDHER
        CALL   RDATA
        CP     D
        JR     NZ,QDHER
        INC    HL
        INC    HL
;
;
VEQM:   IN     A,(SIOAC)
        RLCA
        JR     C,QDHER
        RRCA
        RRCA
        JR     NC,VEQM
        IN     A,(SIOAD)
;
        LD     C,RCADR
        LD     B,H
        OUT    (C),L
        DEC    C
        IN     B,(C)
        CP     B
        JR     NZ,QDHER
        INC    HL
        DEC    DE
        LD     A,D
        OR     E
        JR     NZ,VEQM
        CALL   RDCRC
        PUSH   HL
        CALL   BRKCHK

        JP     Z,BREAKZ
        LD     HL,(FAS)
        LD     DE,(BLKSL)
        LD     BC,3
        XOR    A
        SBC    HL,DE
        SBC    HL,BC
        JR     Z,SVALS
        LD     (FAS),HL
        POP    HL
        JR     SVALR
;
SVALS:  POP    HL
        JR     SVALT
;
SVALU:  CALL   MTOF
        LD     A,(FNUPS)
        CALL   QDSVFN
        XOR    A
        LD     (FNUPS),A
        LD     A,(FLAGF)
        OR     A
        RET    Z
        SCF
        RET
;
;
QDER:   
RMER:   LD     A,54
        SCF
        RET
;
QDHER:  
        LD     A,41
        SCF
        RET
;
;
        END

; ----------------------------
; MZ-800      RS-232C driver
; FI:MON-RS   ver 001  8.02.84
; ----------------------------
;
        INCLD  MACRO
RSYS:   EQU    1               ;0 700,1500
;          1 800
        IF     RSYS
RMCH:   EQU    3
        ENDIF
;
        IF     RSYS-1
RMCH:   EQU    1
        ENDIF
;
;
$RS:    ENT
        DEFW   $RAM
        DEFM   "RS"
        DEFW   0
        DEFB   8FH             ;Streem, O1C, I1C, W, R
        DEFB   RMCH            ;ch.
        DEFB   0
        DEFW   RSINI           ;INIT
        DEFW   RSRO            ;ROPEN
        DEFW   RSWO            ;WOPEN
        DEFW   RSCL            ;CLOSE
        DEFW   RSKL            ;KILL
        DEFW   RSINP           ;INP1C
        DEFW   RSOUT           ;OUT1C
        DEFW   .RET            ;POS
;
RSINI:  RET    C
        PUSH   IY
        CALL   SETIY
        CALL   RSINT0
        CALL   RSPARM
        JR     RETIY
;
RSINT0: SVC    .DEASC
        RST    3
        DEFB   .DEASC
        ENDM
        LD     (IY+#MONIT),E
        TEST1  ","
        CALL   TEST1
        DEFB   ","
        ENDM
        JP     NZ,ER03
        SVC    .DEASC
        RST    3
        DEFB   .DEASC
        ENDM
        LD     (IY+#INIT),E
        TEST1  0
        CALL   TEST1
        DEFB   0
        ENDM
        RET    Z

        TEST1  ","
        CALL   TEST1
        DEFB   ","
        ENDM
        JP     NZ,ER03
        SVC    .DEASC
        RST    3
        DEFB   .DEASC
        ENDM
        LD     (IY+#CRLF),E
        RET
        SKP    H

;
RSRO:   
RSWO:   PUSH   IY
        CALL   SETIY
        LD     A,(IY+#STAT)
        INC    (IY+#STAT)
        OR     A
        CALL   Z,RSOPEN
        JR     RETIY
;
;
RSCL:   
RSKL:   PUSH   IY
        CALL   SETIY
        DEC    (IY+#STAT)
        LD     A,(IY+#STAT)
        OR     A
        CALL   Z,RCLOSE
        JR     RETIY2
;
;
;
RSINP:  PUSH   IY
        CALL   SETIY
        CALL   RSINP0
        JP     C,IOERR
        CP     (IY+#CRLF)
        JR     NZ,+4
        LD     A,0DH
RETIY2: OR     A
RETIY:  POP    IY
        RET
;
RSINP0: BIT    6,(IY+#INIT)
        JP     Z,GET1C
        LD     IX,GET1C
        LD     HL,IY
        LD     DE,#JISR
        ADD    HL,DE
        JP     JISR
;
RSOUT:  PUSH   IY
        CALL   SETIY
        CP     0DH
        JR     NZ,+5
        LD     A,(IY+#CRLF)
        CALL   RSOUT0
        JR     RETIY
;
RSOUT0: BIT    6,(IY+#INIT)
        JP     Z,PUT1C
        LD     IX,PUT1C
        LD     HL,IY
        LD     DE,#JISX
        ADD    HL,DE
        LD     DE,(DISPX)
        JP     JISX
        SKP    H

;
SETIY:  PUSH   AF
        PUSH   DE
        LD     A,(ZCH)
        INC    A
        LD     IY,$A-TBLN
        LD     DE,TBLN
SETIY2: ADD    IY,DE
        DEC    A
        JR     NZ,SETIY2
        LD     C,(IY+0)
        POP    DE
        POP    AF
        RET
;
;
;***  PORT ADDRESS EQU  ***
;
CHADT:  EQU    B0H
CHACT:  EQU    B1H
CHBDT:  EQU    B2H
CHBCT:  EQU    B3H
;
;
CHCDT:  EQU    D0H
CHCCT:  EQU    D1H
CHDDT:  EQU    D2H
CHDCT:  EQU    D3H
;
#CRLF:  EQU    -8
#JISX:  EQU    -7
#JISR:  EQU    -5
#MONIT: EQU    -3
#INIT:  EQU    -2
#STAT:  EQU    -1
        SKP    H

;
;
        DEFS   1               ;CR or LF
        DEFS   2               ;for JISX
        DEFS   2               ;for JISR
        DEFS   1               ;monitor
        DEFS   1               ;init code
        DEFS   1               ;status
$A:     DEFB   CHACT           ;0
        DEFB   CHADT           ;1
        DEFS   1               ;2 Mask Pattern
        DEFW   1010H           ;3,4
        DEFW   4004H           ;5,6 WR4
        DEFW   C003H           ;7,8 WR3
        DEFW   6005H           ;9,10 WR5
        DEFB   30H
        DEFB   3
;
;
        DEFS   8
$B:     DEFB   CHBCT
        DEFB   CHBDT
        DEFS   1
        DEFW   1010H
        DEFW   4004H
        DEFW   C003H
        DEFW   6005H
        DEFB   30H
        DEFB   3
;
;
        IF     RSYS
        DEFS   8
$C:     DEFB   CHCCT           ;0
        DEFB   CHCDT           ;1
        DEFS   1               ;2 Mask Pattern
        DEFW   1010H           ;3,4
        DEFW   4004H           ;5,6 WR4
        DEFW   C003H           ;7,8 WR3
        DEFW   6005H           ;9,10 WR5
        DEFB   30H
        DEFB   3
;
;
        DEFS   8
$D:     DEFB   CHDCT
        DEFB   CHDDT
        DEFS   1
        DEFW   1010H
        DEFW   4004H
        DEFW   C003H
        DEFW   6005H
        DEFB   30H
        DEFB   3
        ENDIF
;
TBLN:   EQU    $B-$A
;
        SKP    H

;
;
;   Break Check
;
BRK:    CALL   BRKCHK
        RET    NZ
        JP     BREAKZ
;
;     sio  parameter  set
;
;
;
RSPARM: 
        LD     A,18H           ;channel reset
        OUT    (C),A
        LD     A,30H           ;err reset
        OUT    (C),A
        LD     A,(IY+#INIT)    ;inital bit
        AND    0CH             ;stop bit
        JR     NZ,RSP0
        SET    2,(IY+#INIT)    ;1 bit/chr
RSP0:   LD     A,(IY+#INIT)    ;initial bit
        LD     B,A             ;B=init code
        AND    0FH             ;mask
        OR     40H             ;clock rate *16
        LD     (IY+6),A        ;wr4
        LD     A,B
        AND    80H             ;rx disable d7 bit/chr
        OR     40H
        LD     (IY+8),A        ;wr3
        RRA
        AND    7FH             ;dtroff
        OR     0AH             ;tx enable rtson dtroff
        LD     (IY+10),A       ;wr5
        LD     A,B
        OR     7FH
        LD     (IY+2),A        ;bit mask
        CALL   RSSUB
RSTBUF: 
        IN     A,(C)
        RRCA
        RET    NC
        DEC    C
        IN     A,(C)
        INC    C
        LD     A,1
        OUT    (C),A
        IN     A,(C)
        AND    70H
        JR     Z,RSTBUF
        RET
;
;
;
;
;  SIO close
;
;
RCLOSE: RES    0,(IY+8)        ;rx disable
        RES    7,(IY+10)       ;rdy off

        LD     (IY+#STAT),0
RSSUB:  LD     B,10
        PUSH   IY
        POP    HL
        LD     DE,3
        ADD    HL,DE
        OTIR
        RET
;
;
;  SIO open
;
;
RSOPEN: LD     A,30H
        OUT    (C),A           ;err reset
        RET
        SKP    H

;
;
;  in IY=channel data
;      C=channel control port
;
;
;
RSEN:   SET    0,(IY+8)        ;wr3 RX enable
        LD     A,13H
        OUT    (C),A           ;ext/int reset
        LD     A,(IY+8)        ;wr3
        OUT    (C),A           ;wr5
        LD     A,35H           ;err reset
        OUT    (C),A
        LD     A,(IY+10)       ;wr5
        OR     88H             ;dtr,rts on tx enable
        LD     (IY+10),A       ;wr5
        OUT    (C),A
        RET
;
;
RSDIS:  LD     A,3
        OUT    (C),A
        RES    0,(IY+8)        ;wr3 RX disenable
        LD     A,(IY+8)        ;wr3
        OUT    (C),A
;
RDYOF:  RES    7,(IY+10)       ;wr5 dtr reset
        JR     WR5OUT
;
;
RTSON:  SET    1,(IY+10)       ;wr5 rts set
        JR     WR5OUT
;
;
RTSOFF: RES    1,(IY+10)       ;wr5 rts reset
        JR     WR5OUT
;
;
RDYON:  SET    7,(IY+10)       ;wr5 dtr set
WR5OUT: LD     A,5
        OUT    (C),A
        LD     A,(IY+10)       ;wr5
        OUT    (C),A
        OR     A
        RET
        SKP    H

;
;
;     Receive 1 char
;
;
GET1C:  CALL   PUSHR
        LD     C,(IY+0)
GET1:   CALL   BRK
        CALL   DRCKR
        JR     C,GET1
        CALL   RSEN
CHIN:   CALL   BRK
        IN     A,(C)
        RRCA
        JR     NC,CHIN         ;skip if no data
        DEC    C
        IN     A,(C)           ;data input
        INC    C
        AND    (IY+2)          ;mask
        PUSH   AF
        LD     A,1
        OUT    (C),A
        IN     A,(C)
        AND    70H
        JR     NZ,RSER         ;skip if err
        CALL   RDYOF
        POP    AF
        RET
;
;
;
RSER:   LD     B,A
        POP    AF
        PUSH   BC
        CALL   RSPARM
        POP    BC
        LD     A,29            ;framing err
        RLC    B
        RLC    B
        RET    C
        INC    A               ;overrun err
        RLC    B
        RET    C
        INC    A               ;parity err
        SCF
        RET
        SKP    H

;
;
;     Send 1 char
;
;
PUT1C:  CALL   PUSHR
        LD     C,(IY+0)
        LD     D,A
        CALL   RTSON
PUT1:   CALL   BRK
        CALL   DRCKS
        CALL   NC,CTSCK
        JR     C,PUT1
        IN     A,(C)
        BIT    2,A             ;tx buf empty ?
        JR     Z,PUT1
        BIT    7,(IY+#MONIT)   ;all chr send?
        JR     Z,PUT2
        LD     A,1
        OUT    (C),A
        IN     A,(C)
        RRCA
        JR     NC,PUT1
PUT2:   DEC    C
        OUT    (C),D           ;data out
        INC    C
        BIT    6,(IY+#MONIT)   ;rts on/off?
        JR     Z,PUT3
        CALL   RTSOFF
PUT3:   OR     A
        RET
;
;  DCD check
;
DRCKR:  OR     A
        BIT    0,(IY+#MONIT)   ;moniter dr ?
        JR     DRCK1
;
DRCKS:  OR     A               ;carry clear
        BIT    1,(IY+#MONIT)   ;moniter dr ?
DRCK1:  RET    Z
        LD     A,10H           ;ext/int reset
        OUT    (C),A
        IN     A,(C)
        AND    8
        RET    NZ              ;cy=0
        SCF
        RET
;
; CTS check
;
CTSCK:  OR     A
        BIT    2,(IY+#MONIT)   ;moniter cts ?
        RET    Z
        LD     A,10H
        OUT    (C),A
        IN     A,(C)
        AND    20H
        RET    NZ
        SCF

        RET
;
        END

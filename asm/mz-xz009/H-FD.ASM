; ----------------------------
; PL-monitor  FD dummy
; FI:DMY-FD   ver 003  3.28.84
; ----------------------------
;
        INCLD  MACRO
;
;
$FD:    ENT
        DEFW   $QD
        DEFB   0
;
CLX:    ENT                    ;dummy routines
DUST:   ENT
FLOFF:  ENT
FREEX:  ENT
INREC:  ENT
INX1B:  ENT
LD.DIR: ENT
LDX:    ENT
LOPX:   ENT
OPX:    ENT
PRREC:  ENT
PRX1B:  ENT
RECST:  ENT
SVX:    ENT
        OR     A
        RET
;
FLOCK:  ENT
FSWAP:  ENT
        JP     ER59
        SKP    H

;
;  SVC .DELET
;
FDELET: ENT
        CALL   PUSHR
        LD     HL,(ZDELT)      ;SEQ
        LD     A,L
        OR     H
        JR     Z,FREN2
        PUSH   HL
        SVC    .LOPEN
        RST    3
        DEFB   .LOPEN
        ENDM
        LD     A,2
        LD     (ZRWX),A
        CALL   ?OPEND
        JR     FREN4
;
; SVC .RENAM
;
FRENAM: ENT
        CALL   PUSHR
        LD     HL,(ZWDIR)
        LD     A,L
        OR     H
FREN2:  JP     Z,ER59
        PUSH   HL
        SVC    .LOPEN
        RST    3
        DEFB   .LOPEN
        ENDM
        LD     HL,ELMD
        CALL   SETFNAM
        LD     HL,200H
        LD     (ZLOG),HL
        CALL   SERFLW          ;check already exist
FREN4:  POP    IX
        JP     IOCALL
        END

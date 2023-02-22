; ----------------------------
; Lx-monitor  EMM driver
; FI:MON-EMM  ver 005  4.27.84
; ----------------------------
;
        INCLD  MACRO
;
$RAM:   ENT
        DEFW   $FD
        DEFM   "RAM"
        DEFB   0
        DEFB   5FH
        DEFB   20H             ;1WOPN
        DEFB   32              ;Max dir
        DEFW   EMINI           ;INIT
        DEFW   EMRINF
        DEFW   EMWINF
        DEFW   EMON
        DEFW   1024
        DEFW   EMRDAT
        DEFW   EMWDAT
        DEFW   EMDEL
        DEFW   EMWDIR
        DEFW   EMFRKB
;
EMFRKB: CALL   EMFRB
        LD     C,H
        LD     B,0             ;/256
        SRL    C               ;/512
        SRL    C               ;/1024
        OR     A
        RET
;
EMFRB:  PUSH   DE
        LD     HL,0            ;free area(bytes)
        CALL   EMLD2           ;max
        PUSH   DE
        INC    HL
        INC    HL
        CALL   EMLD2           ;use
        POP    HL
        SBC    HL,DE
        JP     C,ER41          ;I/O ERR
        POP    DE
        RET
;
;
EMCLR:  LD     DE,10H
EMSETU: LD     HL,2
        CALL   EMSV2           ;Set used mem
        EX     DE,HL
        LD     DE,0
        JP     EMSV2           ;File end mark
        SKP    H

;
EMINI:  RET    C
        LD     A,(EMFLG)
        OR     A
        JP     Z,ER50
        CALL   OKYN
        TEST1  ","
        CALL   TEST1
        DEFB   ","
        ENDM
        PUSH   HL
        CALL   EMCLR
        POP    HL
        TEST1  0
        CALL   TEST1
        DEFB   0
        ENDM
        RET    Z               ;INIT "EM:"
        SVC    .DEASC          ;INIT "EM:$hhhh"
        RST    3
        DEFB   .DEASC
        ENDM
EMINI2: LD     HL,0
        DI
        LD     B,1
        LD     A,D
        AND    FCH
        CP     FCH
        LD     HL,FFFFH
        JR     Z,EMINI3        ;if >=FC00 then FFFF
        LD     B,3
        LD     A,D
        OR     A
        LD     HL,20H
        JR     NZ,+3           ;if <=00FF then 0020
EMINI3: EX     DE,HL
        LD     A,B
        LD     (EMFLG),A
        LD     HL,0
        CALL   EMSV2           ;Set max mem
        CALL   PBCCLR
        EI
        RET
        SKP    H

;
;  EMM power on routine
;
EMMPWR: ENT
        LD     HL,8
        LD     B,L
        LD     C,0
EMPWR2: CALL   EMLD1
        SUB    L
        OR     C
        LD     C,A
        LD     A,L
        CALL   EMSV1
        INC    L
        DJNZ   EMPWR2
        LD     A,C
        OR     A
        JR     NZ,EMPWR4
        LD     HL,0            ;already initialized
        CALL   EMLD2
        LD     A,2
        INC    D
        JR     Z,+3
        INC    A
        LD     (EMFLG),A
        JP     PBCCLR
EMPWR4: CALL   EMCLR
        LD     HL,0            ;check EMM installed?
        LD     A,5AH
        CALL   EMSV1
        CALL   EMLD1
        SUB    5AH
        LD     DE,C000H        ;Initial set 48KB
        JR     Z,EMINI2
        XOR    A
        LD     (EMFLG),A
        RET
        SKP    H

;
;  Dir search start
;
EMON:   LD     A,(EMFLG)
        OR     A
        JP     Z,ER50
        LD     HL,10H
        LD     (EMPTR),HL
        RET
;
;  Read inf
;    ent HL:adrs
;
EMRINF: LD     BC,HL
        LD     HL,(EMPTR)
        CALL   EMLD2
        LD     A,D
        OR     E
        SCF
        RET    Z
        INC    HL
        INC    HL
        PUSH   HL
        ADD    HL,DE
        JP     C,ER41          ;I/O ERR
        LD     (EMPTR),HL
        POP    HL
        INC    HL
        INC    HL
        INC    HL
        LD     DE,BC
        LD     BC,32-2
        CALL   EMLDD
        LD     BC,32+2
        ADD    HL,BC
        EX     DE,HL
        LD     M,E             ;Save data area adrs
        INC    HL
        LD     M,D
        OR     A
        RET
;
;  Read data
;    ent HL:buffer adrs
;        BC:byte size
;
EMRDAT: EX     DE,HL
        LD     L,(IY+30)
        LD     H,(IY+31)
        INC    HL
        INC    HL
        INC    HL
        CALL   EMLDD
        LD     (IY+30),L
        LD     (IY+31),H
        OR     A
        RET
        SKP    H

;
;  Write file
;    HL:inf adrs
;
EMWINF: PUSH   AF
        CALL   SERFLW
        PUSH   HL
        LD     HL,2
        CALL   EMLD2
        LD     (EMWP0),DE
        PUSH   DE
        LD     HL,64+7
        ADD    HL,DE
        CALL   EMFRE?          ;Check file space
        POP    DE
        INC    DE
        INC    DE
        POP    HL              ;inf adrs
        LD     BC,64
        POP    AF
        CALL   EMSVB
        LD     (EMWP1),DE
        RET
        SKP    H

;
;  Write data
;    HL:data adrs
;    BC:data bytes
;    A0:close flag
;
;
EMWDAT: PUSH   AF
        PUSH   HL
        PUSH   BC
        LD     HL,(EMWP1)
        INC    BC
        INC    BC
        INC    BC
        ADD    HL,BC
        CALL   EMFRE?
        POP    BC
        POP    HL
        LD     DE,(EMWP1)
        POP    AF
        PUSH   AF
        OR     01H             ;data block
        CALL   EMSVB
        LD     (EMWP1),DE
        POP    AF
        BIT    2,A             ;close ?
        RET    Z               ;no
        PUSH   DE              ;yes
        CALL   EMSETU
        POP    HL
        LD     DE,(EMWP0)
        DEC    HL
        DEC    HL
        OR     A
        SBC    HL,DE
        EX     DE,HL
        JP     EMSV2
;
;
EMFRE?: JR     C,ER53A
        PUSH   HL
        LD     HL,0
        CALL   EMLD2
        OR     A
        POP    HL
        SBC    HL,DE
        RET    C
ER53A:  JP     ER53            ;No file pace
        SKP    H

;
;  delete file
;
EMDEL:  LD     HL,(ELMD30)
        LD     DE,-64-5
        ADD    HL,DE           ;HL:=move destination
        CALL   EMLD2           ;DE:=delete size - 2
        EX     DE,HL           ;DE:=move destination
        ADD    HL,DE
        INC    HL
        INC    HL              ;HL:=move source
        PUSH   DE
        PUSH   HL
        LD     HL,2
        CALL   EMLD2
        EX     DE,HL           ;HL:=last use
        POP    DE              ;DE:=move source
        PUSH   DE
        OR     A
        SBC    HL,DE
        INC    HL
        INC    HL
        LD     BC,HL           ;BC:=move bytes
        POP    HL              ;HL:=move source
        POP    DE              ;DE:=move destination
        CALL   EMLDIR
        DEC    DE
        DEC    DE              ;DE:=new last-use
        LD     HL,2
        JP     EMSV2
;
;  write dir
;
EMWDIR: LD     HL,(ELMD30)
        LD     DE,-64
        ADD    HL,DE
        EX     DE,HL
        LD     HL,ELMD
        LD     BC,32
        JP     EMSVD
        SKP    H

;
EM.P0:  EQU    EAH
EM.P1:  EQU    EBH
;
; EMM 1 Byte Write
;   ent A: data
;       HL:EMM adrs
;
EMSV1:  ENT
        PUSH   BC
        LD     C,EM.P1
        LD     B,H
        OUT    (C),L
        OUT    (EM.P0),A
        POP    BC
        OR     A
        RET
;
; EMM 1 Byte Read
;   ent HL:EMM adrs
;   ext A: dat
;
EMLD1:  ENT
        PUSH   BC
        LD     C,EM.P1
        LD     B,H
        OUT    (C),L
        IN     A,(EM.P0)
        POP    BC
        OR     A
        RET
;
; EMM 2 Byte Write
;   ent DE:data
;       HL:EMM adrs
;
EMSV2:  ENT
        LD     A,E
        CALL   EMSV1
        INC    HL
        LD     A,D
        CALL   EMSV1
        DEC    HL
        RET
;
; EMM 2 Byte Read
;   ent HL:EMM adrs
;       DE:data
;
EMLD2:  ENT
        CALL   EMLD1
        LD     E,A
        INC    HL
        CALL   EMLD1
        LD     D,A
        DEC    HL
        RET
        SKP    H

;
; EMM write block
;   ent HL :data Top
;       DE :EMM Adrs
;       BC :byte Size
;       A  :block flag
;
EMSVB:  EX     DE,HL
        CALL   EMSV1
        INC    HL
        LD     A,C
        CALL   EMSV1
        INC    HL
        LD     A,B
        CALL   EMSV1
        INC    HL
        EX     DE,HL
EMSVD:  ENT
        EX     DE,HL
EMSVE:  LD     A,(DE)
        CALL   EMSV1
        INC    HL
        INC    DE
        DEC    BC
        LD     A,B
        OR     C
        JR     NZ,EMSVE
        EX     DE,HL
        RET
;
; EMM BC Byte Read
;   ent DE :Store Top
;       HL :EMM Adrs
;       BC :Byte Size
;
EMLDD:  ENT
        CALL   EMLD1
        LD     (DE),A
        INC    HL
        INC    DE
        DEC    BC
        LD     A,B
        OR     C
        RET    Z
        JR     EMLDD
;
; EMM BC Byte LDIR
;   ent HL :EMM source top
;       DE :EMM destination top
;       BC :Byte Size
;
EMLDIR: ENT
        CALL   EMLD1           ;EMM (HL) Data => Acc
        EX     DE,HL
        CALL   EMSV1           ;Acc => (DE) EMM
        EX     DE,HL
        INC    HL
        INC    DE
        DEC    BC
        LD     A,B

        OR     C
        RET    Z               ;End
        JR     EMLDIR
        END

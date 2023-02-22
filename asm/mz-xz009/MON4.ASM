        ORG    3C00H
        INCLD  MACRO
        LIST
        INCLD  XROM
;----------------------------------
;
; ascii display code trans
;
;----------------------------------
?ADCN:  ENT
        CP     10H             ;EX only
        JR     C,?AD3          ; <10H ==> F0H
        CP     80H
        JR     Z,?AD7          ; 80H ==> 40H
        CP     C0H
        JR     Z,?AD7          ; C0H ==> 80H
        DI
        OUT    (LSE2),A
        CALL   0BB9H
        OUT    (LSE0),A
        EI
        RET
?AD3:   LD     A,F0H
        RET
?AD7:   SUB    40H
        RET
;
?DACN:  ENT
        CP     F0H
        JR     NC,?DA3
        CP     73H
        JR     Z,?AD3          ; 73H ==> F0H
        CP     40H             ;EX only
        JR     Z,?DA7          ; 40H ==> 80H
        CP     80H
        JR     Z,?DA7          ; 80H ==> C0H
        DI
        OUT    (LSE2),A
        CALL   0BCEH
        OUT    (LSE0),A
        EI
        CP     F0H
        RET    NZ
?DA3:   LD     A," "
        RET
?DA7:   ADD    A,40H
        RET
;
;
;
?KYTBL: ENT
        PUSH   AF
        LD     A,L
        SUB    8
        JR     C,?KY0
        SUB    48
        JR     C,?KY1
?KY0:   ADD    A,10
        LD     L,A
        ADD    HL,BC

        LD     C,M
        POP    AF
        RET
?KY1:   LD     A,(BC)
        PUSH   AF
        INC    BC
        LD     A,(BC)
        LD     B,A
        POP    AF
        LD     C,A             ;BC=ROM adrs
        ADD    HL,BC
        DI
        OUT    (LSE2),A
        LD     A,M
        OUT    (LSE0),A
        EI
        CALL   ?DACN
        LD     C,A
        POP    AF
        RET
        END
        END

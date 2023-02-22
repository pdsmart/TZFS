; ---------------------------
; MZ-800     Macro define
; FI:MACRO   ver 1.0  7.26.84
; ---------------------------
;
;
        MACRO  SVC
        RST    3
        DEFB   @1
        ENDM
;
        MACRO  IOCALL
        LD     IX,(@1)
        CALL   IOCALL
        ENDM
;
        MACRO  TEST1
        CALL   TEST1
        DEFB   @1
        ENDM
;
        MACRO  TESTX
        CALL   TESTX
        DEFB   @1
        ENDM
;
        MACRO  DEF8
        DEFW   @2@1H
        DEFW   @4@3H
        DEFW   @6@5H
        DEFW   @8@7H
        ENDM
;
        MACRO  DEF5
        DEFW   @2@1H
        DEFW   @4@3H
        DEFB   @5H
        ENDM
;
        MACRO  REP5
        @1     @2
        @1     @2
        @1     @2
        @1     @2
        @1     @2
        ENDM
;
        MACRO  SVCT
@2:     EQU    @1H
        DEFW   @3
        ENDM
        END

        MACRO  TBL
        DEFM   "@1"
        DEFB   "@2"+80H
        ENDM

        MACRO  ENTRY
ER@1:   ENT
        LD     A,@1
        DEFB   21H
        ENDM

        MACRO  FKEY
        DEFB   FNB@1E-FNB@1S
FNB@1S: DEFM   @2
        IFD    @3
        DEFB   @3
        ENDIF
FNB@1E: DEFS   FNB@1S+15-FNB@1E
        ENDM

        MACRO  ERENT
ER@1:   ENT
        IFD    @2
        LD     A,@1+80H
        ENDIF
        IFU    @2
        LD     A,@1
        ENDIF
        DEFB   21H
        ENDM

; -------------------------
; MZ-800 monitor Work area
; FI:MON2  ver 1.0A 9.05.84
; -------------------------
;
        INCLD  MACRO
        INCLD  XCRTEQU
;
;
;  Interrupt vector
;
;
        ORG    0FF0H
        DEFS   12              ;interrupt reserve
;
        ORG    0FFCH
        DEFW   PSGINT          ;PSG(timer) interrupt
        DEFW   LPTINT          ;Printer intrrupt
;
; Directry entry
;
        ORG    1000H
ELMD:   ENT                    ;file mode
        DEFS   1
ELMD1:  ENT                    ;file name
        DEFS   17
ELMD18: ENT                    ;protection, type
        DEFS   2
ELMD20: ENT                    ;size
        DEFS   2
ELMD22: ENT                    ;adrs
        DEFS   2
ELMD24: ENT                    ;exec
        DEFS   2
ELMD26: ENT
        DEFS   4
ELMD30: ENT
        DEFS   2
ELMD32: ENT
        DEFS   32
;
;  LU table entry
;
ZTOP:   ENT                    ;LU block top
        DEFW   2
ZLOG:   ENT                    ;LU#
        DEFB   0
ZRWX:   ENT                    ;1:R, 2:W, 3:X
        DEFB   0
ZEQT:   ENT                    ;Address of EQTBL
        DEFW   0
ZCH:    ENT                    ;CH#
        DEFB   0
ZEOF:   ENT                    ;EOF?
        DEFB   0
ZWRK1:  ENT                    ;Work 1
        DEFB   0
ZWRK2:  ENT                    ;Work 2
        DEFB   0
;

        SKP    H

;
; EQT table entry
;
ZNXT:   ENT                    ;STRM  SQR    RND
        DEFW   0
ZDEVNM: ENT                    ;-- device name --
        DEFS   4
ZFLAG1: ENT                    ;----- flag 1 ----
        DEFB   1
ZFLAG2: ENT                    ;----- flag 2 ----
        DEFB   0
ZDIRMX: ENT                    ;---- max dir ----
        DEFB   0
ZINIT:  ENT                    ;--- initialize --
        DEFW   0
ZRO:    ENT                    ;ROPEN RDINF
ZMAPS:  ENT                    ;            Map.start
        DEFW   0
ZWO:    ENT                    ;WOPEN WRFIL
ZMAPB:  ENT                    ;            Map.bytes
        DEFW   0
ZCL:    ENT                    ;CLOSE
ZSTRT:  ENT                    ;      START
ZDIRS:  ENT                    ;            Dir.start
        DEFW   0
ZKL:    ENT                    ;KILL
ZBLK:   ENT                    ;      - Block/byte -
        DEFW   0
ZINP:   ENT                    ;INP   RDDAT BREAD
        DEFW   0
ZOUT:   ENT                    ;OUT   WRDAT BWRIT
        DEFW   0
ZPOS:   ENT                    ;Position
ZDELT:  ENT                    ;      DELETE
        DEFW   0
ZWDIR:  ENT                    ;      WR DIR
        DEFW   0
ZFREE:  ENT                    ;      - free bytes -
        DEFW   0
;
ZBYTES: EQU    ZFREE+2-ZNXT    ;Z-area bytes
;
        DEFS   2
;
DCHAN:  ENT                    ;default channel
        DEFS   1
DDEV:   ENT                    ;default device
        DEFS   2
;
;
.$CRT:  ENT
        DEFW   $CRT
.$LPT:  ENT
        DEFW   $LPT
;
        SKP    H

;
;  Work area pointers
;
TEXTST: ENT                    ;Text starat
        DEFS   2
TEXTED: ENT
POOL:   ENT                    ;I/O work
        DEFS   2
POOLED: ENT
VARST:  ENT                    ;Variable start
        DEFS   2
STRST:  ENT                    ;String start
        DEFS   2
VARED:  ENT                    ;Var & string end
        DEFS   2
TMPEND: ENT                    ;Temporaly end
        DEFS   2
INTFAC: ENT                    ;Initial FAC
        DEFS   2
MEMLMT: ENT                    ;LIMIT command
        DEFS   2
MEMMAX: ENT                    ;Last avairable memory
        DEFW   FF00H
;
;
;    cursor / position work
;
;
;
CURXY:  ENT                    ;cursor position
CURX:   ENT
        DEFB   0
CURY:   ENT
        DEFB   0
POSADR: ENT                    ;text buf addr
        DEFW   2000H
BITADR: ENT                    ;bitmap mem addr
        DEFW   8000H
;
POINTX: ENT                    ;Graphic x-coordinate
        DEFS   2
POINTY: ENT                    ;Graphic y-coordinate
        DEFS   2
;
CURFLG: ENT                    ;0:off 1:on
        DEFB   0
CURMAK: ENT                    ;cursor mark 0=normal
        DEFB   0               ;            1=sftlock
;            2=graph
        SKP    H

;
; CRT/LPT work
;
CMTMSG: ENT                    ;if =0 disp cmt-msg
        DEFS   1
INPFLG: ENT                    ;0=plot off 1=plot on
        DEFB   0
DISPX:  ENT                    ;0=MSG 1=MSGX
        DEFS   1
FILOUT: ENT                    ;0=CRT 1=LPT
        DEFB   0
PSEL:   ENT                    ;Printer select
        DEFB   1
PCRLF:  ENT                    ;LPT CRLF CODE
        DEFB   0DH
LPT.TM: ENT                    ;LPT wait time
        DEFB   14
LPOSB:  ENT                    ;LPT position
        DEFB   0
PSMAL:  ENT                    ;LPT small/capital
        DEFB   0
PNMODE: ENT                    ;LPT mode
        DEFB   1               ; 1..text, 2..graph
;
;
;  crt dispmode work
;
;
DMD:    ENT                    ;disp mode  0 320 4  col
        DEFB   0               ;            2 320 16 col
;                  4 640 2  col
;                  6 640 4  col
MEMOP:  ENT                    ;option mem exit
        DEFB   0               ;0= off 1= on
PWMODE: ENT                    ;graphic operation mode
        DEFB   0
CMODE:  ENT                    ;color mode
        DEFB   3
CPLANE: ENT                    ;curent active plane
        DEFB   3
MAXCF:  ENT                    ;maximum plane data
        DEFB   4
PMASK:  ENT                    ;mask plane data
        DEFB   FFH
GMODE:  ENT                    ;graphic color mode
        DEFB   3
;
        DEFS   50H             ;10A0 -- 10EF monitor stack
;
;
;
IBUFE:  ENT                    ;CMT work
        DEFS   128
;
        DEFS   34
        DEFB   EFH             ;FLSDT
        DEFS   2               ;STRFG, DPRNT
TMCNT:  ENT
        DEFS   2
SUMDT:  ENT

        DEFS   2               ;SUMDT
CSMDT:  ENT
        DEFS   2               ;CSMDT
        DEFS   2               ;AMPM, TIMFG
        DEFB   1               ;SWRK
TEMPW:  ENT
        DEFB   4               ;TEMPW
        DEFB   5               ;ONTYO
        DEFS   3               ;OCTV, RATIO
;
KEYBM1: ENT
        DEFS   1
KEYBUF: ENT
        DEFS   262
KEY262: ENT
        DEFS   2
KEY264: ENT
        DEFS   2
KEY266: ENT
        DEFS   4
;
FUNBUF: ENT
        FKEY   1,"RUN   ",0DH
        DEFB   FNB1E-FNB1S
FNB1S:  DEFM   "RUN   "

        IFD    0DH
        DEFB   0DH
        ENDIF
FNB1E:  DEFS   FNB1S+15-FNB1E
        ENDM
        FKEY   2,"LIST "
        DEFB   FNB2E-FNB2S
FNB2S:  DEFM   "LIST "

        IFD    @3
        ENDIF
FNB2E:  DEFS   FNB2S+15-FNB2E
        ENDM
        FKEY   3,"AUTO "
        DEFB   FNB3E-FNB3S
FNB3S:  DEFM   "AUTO "

        IFD    @3
        ENDIF
FNB3E:  DEFS   FNB3S+15-FNB3E
        ENDM
        FKEY   4,"RENUM "
        DEFB   FNB4E-FNB4S
FNB4S:  DEFM   "RENUM "


        IFD    @3
        ENDIF
FNB4E:  DEFS   FNB4S+15-FNB4E
        ENDM
        FKEY   5,"COLOR "      ;QD FD ->"DIR "
        DEFB   FNB5E-FNB5S
FNB5S:  DEFM   "COLOR "

        IFD    @3
        ENDIF
FNB5E:  DEFS   FNB5S+15-FNB5E
        ENDM
        FKEY   6,"CHR$("
        DEFB   FNB6E-FNB6S
FNB6S:  DEFM   "CHR$("

        IFD    @3
        ENDIF
FNB6E:  DEFS   FNB6S+15-FNB6E
        ENDM
        FKEY   7,"DEF KEY("
        DEFB   FNB7E-FNB7S
FNB7S:  DEFM   "DEF KEY("

        IFD    @3
        ENDIF
FNB7E:  DEFS   FNB7S+15-FNB7E
        ENDM
        FKEY   8,"CONT"
        DEFB   FNB8E-FNB8S
FNB8S:  DEFM   "CONT"
        IFD    @3
        ENDIF
FNB8E:  DEFS   FNB8S+15-FNB8E
        ENDM
        FKEY   9,"SAVE  "
        DEFB   FNB9E-FNB9S
FNB9S:  DEFM   "SAVE  "

        IFD    @3
        ENDIF
FNB9E:  DEFS   FNB9S+15-FNB9E
        ENDM
        FKEY   10,"LOAD  "
        DEFB   FNB10E-FNB10S
FNB10S: DEFM   "LOAD  "

        IFD    @3
        ENDIF
FNB10E: DEFS   FNB10S+15-FNB10E
        ENDM
;
INBUFC: ENT                    ;INBUF counter
        DEFB   0
INBUFL: ENT                    ;INBUF length
        DEFB   0
INBUF:  ENT                    ;pending key 16
        DEFS   16
;
LINLIM: ENT                    ;getline buffer limit

        DEFB   255             ;const
KEYDAT: ENT
        DEFB   0
;
;    timer work
;
AMPM:   ENT
        DEFB   0
SECD:   ENT
        DEFW   0
;
;    scrool work
;
XS:     ENT                    ;console X start const=0
        DEFB   0
XE:     ENT                    ;console X end
        DEFB   39
CWIDTH: ENT                    ;console width
        DEFW   40              ;cwidth=xe+1
CSIZE:  ENT                    ;csize=cwidth*8
        DEFW   320
YS:     ENT                    ;console Y start
        DEFB   0
YE:     ENT                    ;console Y end
        DEFB   24
YW:     ENT                    ;console Y width
        DEFB   25              ;yw=ye-ys+1
;
;    scrool custom data
;
SOF:    ENT                    ;scrool offset
        DEFW   0
SW:     ENT                    ;scrool width
        DEFB   7DH             ;sw  = yw*5
SSA:    ENT                    ;scrool start
        DEFB   0               ;ssa = ys*5
SEA:    ENT                    ;scrool end
        DEFB   7DH             ;sea =(ye+1)*5
SSW:    ENT                    ;scrool offset limit
        DEFW   3E8H            ;ssw = sw *8
;
;     crt work (basic used)
;
CRTMD1: ENT                    ;crt bit data
        DEFB   1
CRTMD2: ENT                    ;crt mode no. data
        DEFB   1
SELCOL: ENT                    ;default color
        DEFB   3
PAIWED: ENT
        DEFW   0               ;paint stack end
;
;
;
;     palette work
;
PALBK:  ENT                    ;palette block number
        DEFB   0
PALAD:  ENT                    ;palette init addr
        DEFW   PAL4T

PALTBL: ENT                    ;palette data table
        DEFS   4
;
;
;     palette init data table
;
PAL2T:  ENT                    ;palette
        DEFB   00H             ;PAL 0 black
        DEFB   1FH             ;PAL 1 white
        DEFB   2FH             ;PAL 2 white
        DEFB   3FH             ;PAL 3 white
;
PAL4T:  ENT                    ;palette
        DEFB   00H             ;PAL 0 black
        DEFB   11H             ;PAL 1 blue
        DEFB   22H             ;PAL 2 red
        DEFB   3FH             ;PAL 3 white
;
PAL16T: ENT                    ;palette
        DEFB   00H             ;PAL 0 black
        DEFB   11H             ;PAL 1 blue
        DEFB   22H             ;PAL 2 red
        DEFB   33H             ;PAL 3 purple
;
;
;     cursor  init data table
;
CURDT1: ENT                    ;cursor normal
        DEFB   FFH             ;0
        DEFB   FFH             ;1
        DEFB   FFH             ;2
        DEFB   FFH             ;3
        DEFB   FFH             ;4
        DEFB   FFH             ;5
        DEFB   FFH             ;6
        DEFB   FFH             ;7
;
CURDT2: ENT                    ;cursor sftlock
        DEFB   7EH             ;0
        DEFB   FFH             ;1
        DEFB   FFH             ;2
        DEFB   FFH             ;3
        DEFB   FFH             ;4
        DEFB   FFH             ;5
        DEFB   FFH             ;6
        DEFB   7EH             ;7
;
CURDT3: ENT                    ;cursor graph
        DEFB   00H             ;0
        DEFB   00H             ;1
        DEFB   00H             ;2
        DEFB   00H             ;3
        DEFB   00H             ;4
        DEFB   00H             ;5
        DEFB   00H             ;6
        DEFB   FFH             ;7
;
;   screen management buffer
;
SCRNT0: ENT

        DEFS   25
SCRNTE: DEFB   0
;
;
;     emm  work
;
;
EMFLG:  ENT
        DEFS   1
EMPTR:  ENT
        DEFS   2
EMWP0:  ENT
        DEFS   2
EMWP1:  ENT
        DEFS   2
        SKP    H

; ------------------------------
;
;  lpt work
;
; ------------------------------
;
WPULSE: DEFB   0
WSTROB: DEFB   0
PBCMAW: DEFW   3FF0H
PBCN:   ENT
        DEFW   0               ;
PBCIP:  DEFW   C000H           ;FIFO inp pointer
PBCOP:  DEFW   C000H           ;FIFO out pointer
PBCTOP: DEFW   C000H           ;buffer top
SPLFLG: DEFB   0               ;spool on/stop/off
OUTIMF: DEFB   0               ;output image flag
HPCOUN: DEFB   4               ;printer counter
HERRF:  ENT
        DEFB   0               ;ROM error flag
;
;
;---------------------------------
;
;
;    code translation table
;
;---------------------------------
;
CTABLE: ENT
        DEFW   CTABL1          ;change table address
;
;
CTABL1: DEFB   39              ;change number
;
;
        DEFB   023H            ;#
        DEFB   023H
;
        DEFB   040H            ;@
        DEFB   040H
;
        DEFB   05BH            ;[
        DEFB   05BH
;
        DEFB   05CH            ;\
        DEFB   05CH
;
        DEFB   05DH            ;]
        DEFB   05DH
;
        DEFB   08BH            ;^
        DEFB   05EH
;
        DEFB   090H            ;under_
        DEFB   05FH
;
        DEFB   093H            ;'
        DEFB   060H
;
        DEFB   0A1H            ;a

        DEFB   061H
;
        DEFB   09AH            ;b
        DEFB   062H
;
        DEFB   09FH            ;c
        DEFB   063H
;
        DEFB   09CH            ;d
        DEFB   064H
;
        DEFB   092H            ;e
        DEFB   065H
;
        DEFB   0AAH            ;f
        DEFB   066H
;
        DEFB   097H            ;g
        DEFB   067H
;
        DEFB   098H            ;h
        DEFB   068H
;
        DEFB   0A6H            ;i
        DEFB   069H
;
        DEFB   0AFH            ;j
        DEFB   06AH
;
        DEFB   0A9H            ;k
        DEFB   06BH
;
        DEFB   0B8H            ;l
        DEFB   6CH
;
        DEFB   0B3H            ;m
        DEFB   6DH
;
        DEFB   0B0H            ;n
        DEFB   6EH
;
        DEFB   0B7H            ;o
        DEFB   6FH
;
        DEFB   09EH            ;p
        DEFB   70H
;
        DEFB   0A0H            ;q
        DEFB   71H
;
        DEFB   09DH            ;r
        DEFB   72H
;
        DEFB   0A4H            ;s
        DEFB   73H
;
        DEFB   096H            ;t
        DEFB   74H
;
        DEFB   0A5H            ;u

        DEFB   75H
;
        DEFB   0ABH            ;v
        DEFB   76H
;
        DEFB   0A3H            ;w
        DEFB   77H
;
        DEFB   09BH            ;x
        DEFB   78H
;
        DEFB   0BDH            ;y
        DEFB   79H
;
        DEFB   0A2H            ;z
        DEFB   7AH
;
        DEFB   0BEH            ;{
        DEFB   7BH
;
        DEFB   0C0H            ;Ý
        DEFB   7CH
;
        DEFB   080H            ;}
        DEFB   7DH
;
        DEFB   094H            ;~
        DEFB   7EH
;
        DEFB   07FH            ;
        DEFB   7FH
;
;
        END

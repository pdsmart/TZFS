;--------------------------------------------------------------------------------------------------------
;-
;- Name:            tzfs_mondef.asm
;- Created:         September 2019
;- Author(s):       Philip Smart
;- Description:     Sharp MZ series tzfs (tranZPUter Filing System).
;-                  This assembly language program is a branch from the original RFS written for the
;-                  MZ80A_RFS upgrade board. It is adapted to work within the similar yet different 
;-                  environment of the tranZPUter SW which has a large RAM capacity (512K) and an
;-                  I/O processor in the K64F/ZPU.
;-
;-                  This file contains the SA-1510/1Z-013A monitor specific definitions.
;-
;- Credits:         
;- Copyright:       (c) 2019-21 Philip Smart <philip.smart@net2net.org>
;-
;- History:         May 2020  - Branch taken from RFS v2.0 and adapted for the tranZPUter SW.
;-                  July 2020 - Updates to accommodate v2.1 of the tranZPUter board.
;-
;--------------------------------------------------------------------------------------------------------
;- This source file is free software: you can redistribute it and-or modify
;- it under the terms of the GNU General Public License as published
;- by the Free Software Foundation, either version 3 of the License, or
;- (at your option) any later version.
;-
;- This source file is distributed in the hope that it will be useful,
;- but WITHOUT ANY WARRANTY; without even the implied warranty of
;- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;- GNU General Public License for more details.
;-
;- You should have received a copy of the GNU General Public License
;- along with this program.  If not, see <http://www.gnu.org/licenses/>.
;--------------------------------------------------------------------------------------------------------

;-------------------------------------------------------
; Function entry points in the standard SA-1510 Monitor.
;-------------------------------------------------------
GETL:                   EQU     00003h
LETNL:                  EQU     00006h
NL:                     EQU     00009h
PRNTS:                  EQU     0000Ch
PRNT:                   EQU     00012h
MSG:                    EQU     00015h
MSGX:                   EQU     00018h
GETKY                   EQU     0001Bh
BRKEY                   EQU     0001Eh
?WRI                    EQU     00021h
?WRD                    EQU     00024h
?RDI                    EQU     00027h
?RDD                    EQU     0002Ah
?VRFY                   EQU     0002Dh
MELDY                   EQU     00030h
?TMST                   EQU     00033h
MONIT:                  EQU     00000h
;SS:                     EQU     00089h
;ST1:                    EQU     00095h
HLHEX                   EQU     00410h
_2HEX                   EQU     0041Fh
;?MODE:                  EQU     0074DH
;?KEY                    EQU     008CAh
PRNT3                   EQU     0096Ch
?ADCN                   EQU     00BB9h
?DACN                   EQU     00BCEh
?DSP:                   EQU     00DB5H
?BLNK                   EQU     00DA6h
?DPCT                   EQU     00DDCh
PRTHL:                  EQU     003BAh
PRTHX:                  EQU     003C3h
HEX:                    EQU     003F9h
DPCT:                   EQU     00DDCh
;DLY12:                  EQU     00DA7h
;DLY12A:                 EQU     00DAAh
?RSTR1:                 EQU     00EE6h
;MOTOR:                  EQU     006A3H
CKSUM:                  EQU     0071AH
GAP:                    EQU     0077AH
;WTAPE:                  EQU     00485H
MSTOP:                  EQU     00700H

                        ; ROM location differences between the MZ80A and MZ-700.
                        IF BUILD_MZ80A > 0
SS:                     EQU     00089h
ST1:                    EQU     00095h
WTAPE:                  EQU     00485H
MOTOR:                  EQU     006A3H
?MODE:                  EQU     0074DH
?KEY                    EQU     008CAh
DLY12:                  EQU     00DA7h
DLY12A:                 EQU     00DAAh
                        ELSE
SS:                     EQU     000A2H
ST1:                    EQU     000ADH
WTAPE:                  EQU     0048AH
MOTOR:                  EQU     0069FH
?MODE:                  EQU     0073EH
?KEY                    EQU     009B3H
DLY12:                  EQU     00996H
                        ENDIF

;-----------------------------------------------
;    SA-1510 MONITOR WORK AREA (MZ80A)
;-----------------------------------------------
STACK:                  EQU     010F0H
;
                        ORG     STACK
;
SPV:
IBUFE:                                                                   ; TAPE BUFFER (128 BYTES)
ATRB:                   DS      virtual 1                                ; ATTRIBUTE
NAME:                   DS      virtual FNSIZE                           ; FILE NAME
SIZE:                   DS      virtual 2                                ; BYTESIZE
DTADR:                  DS      virtual 2                                ; DATA ADDRESS
EXADR:                  DS      virtual 2                                ; EXECUTION ADDRESS
COMNT:                  DS      virtual 92                               ; COMMENT
SWPW:                   DS      virtual 10                               ; SWEEP WORK
KDATW:                  DS      virtual 2                                ; KEY WORK
KANAF:                  DS      virtual 1                                ; KANA FLAG (01=GRAPHIC MODE)
DSPXY:                  DS      virtual 2                                ; DISPLAY COORDINATES
MANG:                   DS      virtual 6                                ; COLUMN MANAGEMENT
MANGE:                  DS      virtual 1                                ; COLUMN MANAGEMENT END
PBIAS:                  DS      virtual 1                                ; PAGE BIAS
ROLTOP:                 DS      virtual 1                                ; ROLL TOP BIAS
MGPNT:                  DS      virtual 1                                ; COLUMN MANAG. POINTER
PAGETP:                 DS      virtual 2                                ; PAGE TOP
ROLEND:                 DS      virtual 1                                ; ROLL END
                        DS      virtual 14                               ; BIAS
FLASH:                  DS      virtual 1                                ; FLASHING DATA
SFTLK:                  DS      virtual 1                                ; SHIFT LOCK
REVFLG:                 DS      virtual 1                                ; REVERSE FLAG
SPAGE:                  DS      virtual 1                                ; PAGE CHANGE
FLSDT:                  DS      virtual 1                                ; CURSOR DATA
STRGF:                  DS      virtual 1                                ; STRING FLAG
DPRNT:                  DS      virtual 1                                ; TAB COUNTER
TMCNT:                  DS      virtual 2                                ; TAPE MARK COUNTER
SUMDT:                  DS      virtual 2                                ; CHECK SUM DATA
CSMDT:                  DS      virtual 2                                ; FOR COMPARE SUM DATA
AMPM:                   DS      virtual 1                                ; AMPM DATA
TIMFG:                  DS      virtual 1                                ; TIME FLAG
SWRK:                   DS      virtual 1                                ; KEY SOUND FLAG
TEMPW:                  DS      virtual 1                                ; TEMPO WORK
ONTYO:                  DS      virtual 1                                ; ONTYO WORK
OCTV:                   DS      virtual 1                                ; OCTAVE WORK
RATIO:                  DS      virtual 2                                ; ONPU RATIO
BUFER:                  DS      virtual 81                               ; GET LINE BUFFER

; Quickdisk work area
;QDPA                   EQU     01130h                                   ; QD code 1
;QDPB                   EQU     01131h                                   ; QD code 2
;QDPC                   EQU     01132h                                   ; QD header startaddress
;QDPE                   EQU     01134h                                   ; QD header length
;QDCPA                  EQU     0113Bh                                   ; QD error flag
;HDPT                   EQU     0113Ch                                   ; QD new headpoint possition
;HDPT0                  EQU     0113Dh                                   ; QD actual headpoint possition
;FNUPS                  EQU     0113Eh
;FNUPF                  EQU     01140h
;FNA                    EQU     01141h                                   ; File Number A (actual file number)
;FNB                    EQU     01142h                                   ; File Number B (next file number)
;MTF                    EQU     01143h                                   ; QD motor flag
;RTYF                   EQU     01144h
;SYNCF                  EQU     01146h                                   ; SyncFlags
;RETSP                  EQU     01147h
;BUFER                  EQU     011A3h
;QDIRBF                 EQU     0CD90h



;SPV:
;IBUFE:                                                                  ; TAPE BUFFER (128 BYTES)
;ATRB:                  DS      virtual 1                                ; Code Type, 01 = Machine Code.
;NAME:                  DS      virtual 17                               ; Title/Name (17 bytes).
;SIZE:                  DS      virtual 2                                ; Size of program.
;DTADR:                 DS      virtual 2                                ; Load address of program.
;EXADR:                 DS      virtual 2                                ; Exec address of program.
;COMNT:                 DS      virtual 104                              ; COMMENT
;KANAF:                 DS      virtual 1                                ; KANA FLAG (01=GRAPHIC MODE)
;DSPXY:                 DS      virtual 2                                ; DISPLAY COORDINATES
;MANG:                  DS      virtual 27                               ; COLUMN MANAGEMENT
;FLASH:                 DS      virtual 1                                ; FLASHING DATA
;FLPST:                 DS      virtual 2                                ; FLASHING POSITION
;FLSST:                 DS      virtual 1                                ; FLASHING STATUS
;FLSDT:                 DS      virtual 1                                ; CURSOR DATA
;STRGF:                 DS      virtual 1                                ; STRING FLAG
;DPRNT:                 DS      virtual 1                                ; TAB COUNTER
;TMCNT:                 DS      virtual 2                                ; TAPE MARK COUNTER
;SUMDT:                 DS      virtual 2                                ; CHECK SUM DATA
;CSMDT:                 DS      virtual 2                                ; FOR COMPARE SUM DATA
;AMPM:                  DS      virtual 1                                ; AMPM DATA
;TIMFG:                 DS      virtual 1                                ; TIME FLAG
;SWRK:                  DS      virtual 1                                ; KEY SOUND FLAG
;TEMPW:                 DS      virtual 1                                ; TEMPO WORK
;ONTYO:                 DS      virtual 1                                ; ONTYO WORK
;OCTV:                  DS      virtual 1                                ; OCTAVE WORK
;RATIO:                 DS      virtual 2                                ; ONPU RATIO

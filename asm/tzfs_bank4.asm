;--------------------------------------------------------------------------------------------------------
;-
;- Name:            tzfs_bank4.asm
;- Created:         July 2019
;- Author(s):       Philip Smart
;- Description:     Sharp MZ series tzfs (tranZPUter Filing System).
;-                  Bank 4 - F000:FFFF - 
;-
;-                  This assembly language program is a branch from the original RFS written for the
;-                  MZ80A_RFS upgrade board. It is adapted to work within the similar yet different 
;-                  environment of the tranZPUter SW which has a large RAM capacity (512K) and an
;-                  I/O processor in the K64F/ZPU.
;-
;- Credits:         
;- Copyright:       (c) 2018-2020 Philip Smart <philip.smart@net2net.org>
;-
;- History:         May 2020  - Branch taken from RFS v2.0 and adapted for the tranZPUter SW.
;-                  Dec 2020  - Updates to accommodate v1.3 of the tranZPUter SW-700 board where soft
;-                              CPU's now become possible.
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


            ;============================================================
            ;
            ; TZFS BANK 4 - TZFS commands
            ;
            ;============================================================
            ORG     BANKRAMADDR

            ;-------------------------------------------------------------------------------
            ; START OF ADDITIONAL TZFS COMMANDS
            ;-------------------------------------------------------------------------------

            ; Method to set the video mode.
            ; Param: 0 - Enable FPGA and set to MZ-80K mode.
            ;        1 - Enable FPGA and set to MZ-80C mode.
            ;        2 - Enable FPGA and set to MZ-1200 mode.
            ;        3 - Enable FPGA and set to MZ-80A mode (base mode on MZ-80A hardware).
            ;        4 - Enable FPGA and set to MZ-700 mode (base mode on MZ-700 hardware).
            ;        5 - Enable FPGA and set to MZ-1500 mode.
            ;        6 - Enable FPGA and set to MZ-800 mode.
            ;        7 - Enable FPGA and set to MZ-80B mode.
            ;        8 - Enable FPGA and set to MZ-2000 mode.
            ;        9 - Enable FPGA and set to MZ-2200 mode.
            ;       10 - Enable FPGA and set to MZ-2500 mode.
            ;        O - Turn off FPGA Video, turn on mainboard video.
SETVMODE:   IN      A,(CPLDINFO)                                         ; Get configuration of hardware.
            BIT     3,A
            JP      Z,NOFPGAERR                                          ; No hardware so cannot change mode.
            PUSH    DE                                                   ; Preserve DE in case no number given.
            POP     BC
            CALL    ConvertStringToNumber                                ; Convert the input into 0 (disable) or frequency in KHz.
            JR      NZ,SETVMODEOFF
            LD      A,H
            CP      0
            JP      NZ,BADNUMERR                                         ; Check that the given mode is in range 0 - 7.
            LD      A,L
            CP      10
            JP      NC,BADNUMERR
            ;
SETVMODE0:  IN      A,(CPLDCFG) 
            OR      MODE_VIDEO_FPGA                                      ; Set the tranZPUter CPLD hardware to enable the FPGA video mode.
            OUT     (CPLDCFG),A                                 
            ;
            IN      A,(VMCTRL)                                           ; Get current setting.
            AND     0F0H                                                 ; Clear old mode setting.
            OR      L                                                    ; Add in new setting.
            OUT     (VMCTRL),A
            RLC     L                                                    ; Shift mode to position for SCRNMODE storage.
            RLC     L
            RLC     L
            RLC     L
            LD      A,(SCRNMODE)                                         ; Repeat for the screen mode variable, used when resetting or changing display settings.
            AND     007H                                                 ; Clear video mode setting.
            OR      L                                                    ; Add in new setting.
            SET     2, A                                                 ; Set flag to indicate video mode override - ie, dont use base machine mode.
SETVMODECLR:SET     1, A                                                 ; Ensure flag set so on restart the FPGA video mode is selected.
            LD      (SCRNMODE),A
            LD      A, 016H                                              ; Clear the screen so we start from a known position.
            CALL    PRNT
            LD      A,071H                                               ; Blue background and white characters.
            LD      HL,ARAM
            CALL    CLR8
            RET
SETVMODEOFF:LD      A,(DE)
            CP      'O'
            JR      Z,SETVMODE1
            CP      'o'
            JP      NZ,BADNUMERR
SETVMODE1:  LD      A,(SCRNMODE)                                         ; Disable flag to enable FPGA on restart.
            RES     1,A
            LD      (SCRNMODE),A
            IN      A,(CPLDCFG) 
            AND     ~MODE_VIDEO_FPGA                                     ; Set the tranZPUter CPLD hardware to disable the FPGA video mode.
            OUT     (CPLDCFG),A                                 
            RET
            
            ; Method to set the VGA output mode of the external display.
SETVGAMODE: IN      A,(CPLDINFO)                                         ; Get configuration of hardware.
            BIT     3,A
            JP      Z,NOFPGAERR                                          ; No hardware so cannot change mode.
            CALL    ConvertStringToNumber                                ; Convert the input into 0-3, 0 = off, 1 = 640x480, 2=1024x768, 3=800x600.
            JP      NZ,BADNUMERR
            LD      A,H
            CP      0
            JP      NZ,BADNUMERR                                         ; Check that the given mode is in range 0 - 15.
            LD      A,L
            CP      15
            JP      NC,BADNUMERR
            ;
           ;RRC     L
           ;RRC     L                                                    ; Value to top 2 bits ready to be applied to VGA mode register.
            ;
SETVGAMODE1:IN      A,(CPLDCFG) 
            OR      MODE_VIDEO_FPGA                                      ; Set the tranZPUter CPLD hardware to enable the FPGA video mode.
            OUT     (CPLDCFG),A                                 
            ;
            LD      A, L                                                 ; Add in new setting.
            OUT     (VMVGAMODE),A
            LD      (SCRNMODE2), A
            JP      SETVMODECLR

            ; Method to set the VGA border colour on the external display.
SETVBORDER: IN      A,(CPLDINFO)                                         ; Get configuration of hardware.
            BIT     3,A
            JP      Z,NOFPGAERR                                          ; No hardware so cannot change mode.
            CALL    ConvertStringToNumber                                ; Convert the input into 0 - 7, bit 2 = Red, 1 = Green, 0 = Blue.
            JP      NZ,BADNUMERR
            LD      A,H
            CP      0
            JP      NZ,BADNUMERR                                         ; Check that the given mode is in range 0 - 7.
            LD      A,L
            CP      7
            JP      NC,BADNUMERR
            ;
            IN      A,(CPLDCFG) 
            OR      MODE_VIDEO_FPGA                                      ; Set the tranZPUter CPLD hardware to enable the FPGA video mode.
            OUT     (CPLDCFG),A                                 
            ;
            LD      A,L
            OUT     (VMVGATTR),A
            RET

            ; Method to enable/disable the alternate CPU frequency and change it's values.
            ;
SETFREQ:    CALL    ConvertStringToNumber                                ; Convert the input into 0 (disable) or frequency in KHz.
            JP      NZ,BADNUMERR
            LD      (TZSVC_CPU_FREQ),HL                                  ; Set the required frequency in the service structure.
            LD      A,H
            CP      L
            JR      NZ,SETFREQ1
            LD      A, TZSVC_CMD_CPU_BASEFREQ                            ; Switch to the base frequency.
            JR      SETFREQ2
SETFREQ1:   LD      A, TZSVC_CMD_CPU_ALTFREQ                             ; Switch to the alternate frequency.
SETFREQ2:   CALL    SVC_CMD
            OR      A
            JP      NZ,SETFREQERR
            LD      A,H
            CP      L
            RET     Z                                                    ; If we are disabling the alternate cpu frequency (ie. = 0) exit.
            LD      A, TZSVC_CMD_CPU_CHGFREQ                             ; Switch to the base frequency.
            CALL    SVC_CMD
            OR      A
            JP      NZ,SETFREQERR
            RET

            ; Method to configure the hardware to use the T80 CPU instantiated in the FPGA.
            ;
SETT80:     IN      A,(CPUINFO)
            LD      C,A
            AND     CPUMODE_IS_SOFT_MASK
            CP      CPUMODE_IS_SOFT_AVAIL
            JP      NZ,SOFTCPUERR
            LD      A,C
            AND     CPUMODE_IS_T80
            JP      Z,NOT80ERR 
           ;LD      L,VMMODE_VGA_640x480                                  ; Enable VGA mode for a better display.
           ;CALL    SETVGAMODE1
            LD      A, TZSVC_CMD_CPU_SETT80                               ; We need to ask the K64F to switch to the T80 as it may involve loading of ROMS.
            CALL    SVC_CMD
            OR      A
            JP      NZ,SETT80ERR
            RET

            ; Method to configure the hardware to use the original Z80 CPU installed on the tranZPUter board.
            ;
SETZ80:     IN      A,(CPUINFO)
            AND     CPUMODE_IS_SOFT_MASK
            CP      CPUMODE_IS_SOFT_AVAIL
            JP      NZ,SOFTCPUERR
            CALL    SETVMODE1                                            ; Turn off VGA mode, return to default MZ video.
            LD      A, TZSVC_CMD_CPU_SETZ80
            CALL    SVC_CMD
            OR      A
            JP      NZ,SETZ80ERR
            RET

            ; Method to configure the hardware to use the ZPU Evolution CPU instantiated in the FPGA.
            ;
SETZPUEVO:  IN      A,(CPUINFO)
            LD      C,A
            AND     CPUMODE_IS_SOFT_MASK
            CP      CPUMODE_IS_SOFT_AVAIL
            JP      NZ,SOFTCPUERR
            LD      A,C
            AND     CPUMODE_IS_ZPU_EVO
            JP      Z,NOZPUERR 
            LD      L,VMMODE_VGA_640x480                                  ; Enable VGA mode for a better display.
            CALL    SETVGAMODE1
            LD      A, TZSVC_CMD_CPU_SETZPUEVO                            ; We need to ask the K64F to switch to the ZPU Evo as it may involve loading of ROMS.
            CALL    SVC_CMD
            OR      A
            JP      NZ,SETZPUERR
            HALT                                                          ; ZPU will take over so stop the Z80 from further processing.

            ;----------------------------------------------
            ; Hardware Emulation Mode Activation Routines.
            ;----------------------------------------------

SETMZ80K:   LD      D, TZSVC_CMD_EMU_SETMZ80K                             ; We need to ask the K64F to switch to the Sharp MZ80K emulation as it involves loading ROMS.
            JR      SETEMUMZ
SETMZ80C:   LD      D, TZSVC_CMD_EMU_SETMZ80C
            JR      SETEMUMZ
SETMZ1200:  LD      D, TZSVC_CMD_EMU_SETMZ1200
            JR      SETEMUMZ
SETMZ80A:   LD      D, TZSVC_CMD_EMU_SETMZ80A
            JR      SETEMUMZ
SETMZ700:   LD      D, TZSVC_CMD_EMU_SETMZ700
            JR      SETEMUMZ
SETMZ1500:  LD      D, TZSVC_CMD_EMU_SETMZ1500
            JR      SETEMUMZ
SETMZ800:   LD      D, TZSVC_CMD_EMU_SETMZ800
            JR      SETEMUMZ
SETMZ80B:   LD      D, TZSVC_CMD_EMU_SETMZ80B
            JR      SETEMUMZ
SETMZ2000:  LD      D, TZSVC_CMD_EMU_SETMZ2000
            JR      SETEMUMZ
SETMZ2200:  LD      D, TZSVC_CMD_EMU_SETMZ2200
            JR      SETEMUMZ
SETMZ2500:  LD      D, TZSVC_CMD_EMU_SETMZ2500
            JR      SETEMUMZ
            ;
            ; General function to determine if the emulator MZ hardware is present and activate it. Activation requires making a request to the
            ; I/O processor as it needs to load up the correct BIOS etc prior to activating the emulation.
            ;
SETEMUMZ:   IN      A,(CPUINFO)                                           ; Verify that the FPGA has emuMZ capabilities.
            LD      C,A
            AND     CPUMODE_IS_SOFT_MASK
            CP      CPUMODE_IS_SOFT_AVAIL
            JR      NZ,SOFTCPUERR
            LD      A,C
            AND     CPUMODE_IS_EMU_MZ
            JR      Z,NOEMUERR 
            LD      L,VMMODE_VGA_640x480                                  ; Enable VGA mode for a better display.
            CALL    SETVGAMODE1
            ;
            PUSH    DE                                                    ; Setup the initial video mode based on the required emulation.
            LD      A,D
            SUB     TZSVC_CMD_EMU_SETMZ80K
            LD      L,A
            LD      H,0
            CALL    SETVMODE0
            POP     DE
            ;
            LD      A, D                                                  ; Load up the required emulation mode.
            CALL    SVC_CMD
            OR      A
            JR      NZ,SETT80ERR
            HALT

            ; Simple routine to clear screen or attributes.
CLR8:       LD      BC,00800H
            PUSH    DE
            LD      D,A
CLR8_1:     LD      (HL),D
            INC     HL
            DEC     BC
            LD      A,B
            OR      C
            JR      NZ,CLR8_1
            POP     DE
            RET  
            ;
            ; Message addresses are in Bank2.
            ;
NOFPGAERR:  LD      DE,MSGNOFPGA
            JR      BADNUM2
SETFREQERR: LD      DE,MSGFREQERR
            JR      BADNUM2
SETT80ERR:  LD      DE,MSGT80ERR
            JR      BADNUM2
SETZ80ERR:  LD      DE,MSGZ80ERR
            JR      BADNUM2
SETZPUERR:  LD      DE,MSGZPUERR
            JR      BADNUM2
SOFTCPUERR: LD      DE,MSGNOSOFTCPU
            JR      BADNUM2
NOT80ERR:   LD      DE,MSGNOT80CPU
            JR      BADNUM2
NOZPUERR:   LD      DE,MSGNOZPUCPU
            JR      BADNUM2
NOEMUERR:   LD      DE,MSGNOEMU
            JR      BADNUM2
BADNUMERR:  LD      DE,MSGBADNUM
BADNUM2:    CALL    ?PRINTMSG
            RET

            ;-------------------------------------------------------------------------------
            ; END OF ADDITIONAL TZFS COMMANDS
            ;-------------------------------------------------------------------------------

            ; The FDC controller uses it's busy/wait signal as a ROM address line input, this
            ; causes a jump in the code dependent on the signal status. It gets around the 2MHz Z80 not being quick
            ; enough to process the signal by polling.
            ALIGN_NOPS FDCJMP1
            ORG      FDCJMP1
FDCJMPL4:   JP       (IX)      


            ; The FDC controller uses it's busy/wait signal as a ROM address line input, this
            ; causes a jump in the code dependent on the signal status. It gets around the 2MHz Z80 not being quick
            ; enough to process the signal by polling.
            ALIGN_NOPS FDCJMP2
            ORG      FDCJMP2               
FDCJMPH4:   JP       (IY)


            ; Ensure we fill the entire 4K by padding with FF's.
            ;
            ALIGN_NOPS      10000H

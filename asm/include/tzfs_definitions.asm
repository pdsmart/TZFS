;--------------------------------------------------------------------------------------------------------
;-
;- Name:            TZFS_Definitions.asm
;- Created:         September 2019
;- Author(s):       Philip Smart
;- Description:     Sharp MZ series tzfs (tranZPUter Filing System).
;-                  This assembly language program is a branch from the original RFS written for the
;-                  MZ80A_RFS upgrade board. It is adapted to work within the similar yet different 
;-                  environment of the tranZPUter SW which has a large RAM capacity (512K) and an
;-                  I/O processor in the K64F/ZPU.
;-
;- Credits:         
;- Copyright:       (c) 2018-2023 Philip Smart <philip.smart@net2net.org>
;-
;- History:         May 2020  - Branch taken from RFS v2.0 and adapted for the tranZPUter SW.
;-                  July 2020 - Updates to accommodate v2.1 of the tranZPUter board.
;-                  Feb 2023  - TZFS now running on FusionX. Small changes to ensure compatibility.
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

;-----------------------------------------------
; Features.
;-----------------------------------------------
BUILD_MZ80A             EQU     0                                        ; Build for the standard Sharp MZ80A, no lower memory.
BUILD_MZ700             EQU     1                                        ; Build for the Sharp MZ-700 base hardware.
BUILD_MZ2000            EQU     0                                        ; Build for the Sharp MZ-2000 base hardware.
BUILD_FUSIONX           EQU     1                                        ; Build for the set host using the FusionX board.

; Debugging
ENADEBUG                EQU     0                                        ; Enable debugging logic, 1 = enable, 0 = disable

;-----------------------------------------------
; Entry/compilation start points.
;-----------------------------------------------
MROMADDR                EQU     00000H                                   ; Start of SA1510 Monitor ROM.
UROMADDR                EQU     0E800H                                   ; Start of User ROM Address space.
UROMBSTBL               EQU     UROMADDR + 020H                          ; Entry point to the bank switching table.
TZFSJMPTABLE            EQU     UROMADDR + 00080H                        ; Start of jump table.
BANKRAMADDR             EQU     0F000H                                   ; Start address of the banked RAM used for TZFS functionality.
FDCROMADDR              EQU     0F000H
FDCJMP1                 EQU     0F3FEH                                   ; ROM paged vector 1.
FDCJMP2                 EQU     0F7FEH                                   ; ROM paged vector 2.
FDCJMP3                 EQU     0F7FEH                                   ; ROM paged vector 3.
FDCJMP4                 EQU     0F7FEH                                   ; ROM paged vector 4.
PRGBOOTJMP              EQU     0CF00H                                   ; Location to load bootstrap for original host program.

;-----------------------------------------------
; Common character definitions.
;-----------------------------------------------
SCROLL                  EQU     001H                                     ;Set scroll direction UP.
BELL                    EQU     007H
SPACE                   EQU     020H
TAB                     EQU     009H                                     ;TAB ACROSS (8 SPACES FOR SD-BOARD)
CR                      EQU     00DH
LF                      EQU     00AH
FF                      EQU     00CH
CS                      EQU     0CH                                      ; Clear screen
DELETE                  EQU     07FH
BACKS                   EQU     008H
SOH                     EQU     1                                        ; For XModem etc.
EOT                     EQU     4
ACK                     EQU     6
NAK                     EQU     015H
NUL                     EQU     000H
NULL                    EQU     000H
CTRL_A                  EQU     001H
CTRL_B                  EQU     002H
CTRL_C                  EQU     003H
CTRL_D                  EQU     004H
CTRL_E                  EQU     005H
CTRL_F                  EQU     006H
CTRL_G                  EQU     007H
CTRL_H                  EQU     008H
CTRL_I                  EQU     009H
CTRL_J                  EQU     00AH
CTRL_K                  EQU     00BH
CTRL_L                  EQU     00CH
CTRL_M                  EQU     00DH
CTRL_N                  EQU     00EH
CTRL_O                  EQU     00FH
CTRL_P                  EQU     010H
CTRL_Q                  EQU     011H
CTRL_R                  EQU     012H
CTRL_S                  EQU     013H
CTRL_T                  EQU     014H
CTRL_U                  EQU     015H
CTRL_V                  EQU     016H
CTRL_W                  EQU     017H
CTRL_X                  EQU     018H
CTRL_Y                  EQU     019H
CTRL_Z                  EQU     01AH
ESC                     EQU     01BH
CTRL_SLASH              EQU     01CH
CTRL_LB                 EQU     01BH
CTRL_RB                 EQU     01DH
CTRL_CAPPA              EQU     01EH
CTRL_UNDSCR             EQU     01FH
CTRL_AT                 EQU     000H
NOKEY                   EQU     0F0H
CURSRIGHT               EQU     0F1H
CURSLEFT                EQU     0F2H
CURSUP                  EQU     0F3H
CURSDOWN                EQU     0F4H
DBLZERO                 EQU     0F5H
INSERT                  EQU     0F6H
CLRKEY                  EQU     0F7H
HOMEKEY                 EQU     0F8H
BREAKKEY                EQU     0FBH
GRAPHKEY                EQU     0FCH
ALPHAKEY                EQU     0FDH

;-----------------------------------------------
; Memory mapped ports in hardware.
;-----------------------------------------------
SCRN:                   EQU     0D000H
ARAM:                   EQU     0D800H
DSPCTL:                 EQU     0DFFFH                                   ; Screen 40/80 select register (bit 7)
KEYPA:                  EQU     0E000h
KEYPB:                  EQU     0E001h
KEYPC:                  EQU     0E002h
KEYPF:                  EQU     0E003h
CSTR:                   EQU     0E002h
CSTPT:                  EQU     0E003h
CONT0:                  EQU     0E004h
CONT1:                  EQU     0E005h
CONT2:                  EQU     0E006h
CONTF:                  EQU     0E007h
SUNDG:                  EQU     0E008h
TEMP:                   EQU     0E008h
MEMSW:                  EQU     0E00CH
MEMSWR:                 EQU     0E010H
INVDSP:                 EQU     0E014H
NRMDSP:                 EQU     0E015H
SCLDSP:                 EQU     0E200H
SCLBASE:                EQU     0E2H

;-----------------------------------------------
; IO ports in hardware and values.
;-----------------------------------------------
MMCFG                   EQU     060H                                     ; Memory management configuration latch.
SETXMHZ                 EQU     062H                                     ; Select the alternate clock frequency.
SET2MHZ                 EQU     064H                                     ; Select the system 2MHz clock frequency.
CLKSELRD                EQU     066H                                     ; Read clock selected setting, 0 = 2MHz, 1 = XMHz
SVCREQ                  EQU     068H                                     ; I/O Processor service request.
CPLDSTATUS              EQU     06BH                                     ; Version 2.1 CPLD status register.
CPUCFG                  EQU     06CH                                     ; Version 2.2 CPU configuration register.
CPUSTATUS               EQU     06CH                                     ; Version 2.2 CPU runtime status register.
CPUINFO                 EQU     06DH                                     ; Version 2.2 CPU information register.
CPLDCFG                 EQU     06EH                                     ; Version 2.1 CPLD configuration register.
CPLDINFO                EQU     06FH                                     ; Version 2.1 CPLD version information register.
VMPNUM                  EQU     0A0H                                     ; Set the parameter number to update.
VMPLBYTE                EQU     0A1H                                     ; Update the lower selected parameter byte.
VMPUBYTE                EQU     0A2H                                     ; Update the upper selected parameter byte.
PALSLCTOFF              EQU     0A3H                                     ; set the palette slot Off position to be adjusted.
PALSLCTON               EQU     0A4H                                     ; set the palette slot On position to be adjusted.
PALSETRED               EQU     0A5H                                     ; set the red palette value according to the PALETTE_PARAM_SEL address.
PALSETGREEN             EQU     0A6H                                     ; set the green palette value according to the PALETTE_PARAM_SEL address.
PALSETBLUE              EQU     0A7H                                     ; set the blue palette value according to the PALETTE_PARAM_SEL address.
VMPALETTE               EQU     0B0H                                     ; Select Palette:
                                                                         ;    0xB0 sets the palette. The Video Module supports 4 bit per colour output but there is only enough RAM for 1 bit per colour so the pallette is used to change the colours output.
                                                                         ;      Bits [7:0] defines the pallete number. This indexes a lookup table which contains the required 4bit output per 1bit input.
                                                                         ; GPU:
GPUPARAM                EQU     0B2H                                     ;    0xB2 set parameters. Store parameters in a long word to be used by the graphics command processor.
                                                                         ;      The parameter word is 128 bit and each write to the parameter word shifts left by 8 bits and adds the new byte at bits 7:0.
GPUCMD                  EQU     0B3H                                     ;    0xB3 set the graphics processor unit commands.
GPUSTATUS               EQU     0B3H                                     ;         [7;1] - FSM state, [0] - 1 = busy, 0 = idle
                                                                         ;      Bits [5:0] - 0 = Reset parameters.
                                                                         ;                   1 = Clear to val. Start Location (16 bit), End Location (16 bit), Red Filter, Green Filter, Blue Filter
                                                                         ; 
VMCTRL                  EQU     0B8H                                     ; Video Module control register. [2:0] - 000 (default) = MZ80A, 001 = MZ-700, 010 = MZ800, 011 = MZ80B, 100 = MZ80K, 101 = MZ80C, 110 = MZ1200, 111 = MZ2000. [3] = 0 - 40 col, 1 - 80 col.
VMGRMODE                EQU     0B9H                                     ; Video Module graphics mode. 7/6 = Operator (00=OR,01=AND,10=NAND,11=XOR), 5=GRAM Output Enable, 4 = VRAM Output Enable, 3/2 = Write mode (00=Page 1:Red, 01=Page 2:Green, 10=Page 3:Blue, 11=Indirect), 1/0=Read mode (00=Page 1:Red, 01=Page2:Green, 10=Page 3:Blue, 11=Not used).
VMREDMASK               EQU     0BAH                                     ; Video Module Red bit mask (1 bit = 1 pixel, 8 pixels per byte).
VMGREENMASK             EQU     0BBH                                     ; Video Module Green bit mask (1 bit = 1 pixel, 8 pixels per byte).
VMBLUEMASK              EQU     0BCH                                     ; Video Module Blue bit mask (1 bit = 1 pixel, 8 pixels per byte).
VMPAGE                  EQU     0BDH                                     ; Video Module memory page register. [1:0] switches in 1 16Kb page (3 pages) of graphics ram to C000 - FFFF. Bits [1:0] = page, 00 = off, 01 = Red, 10 = Green, 11 = Blue. This overrides all MZ700/MZ80B page switching functions. [7] 0 - normal, 1 - switches in CGROM for upload at D000:DFFF.
VMVGATTR                EQU     0BEH                                     ; Select VGA Border colour and attributes. Bit 2 = Red, 1 = Green, 0 = Blue.
VMVGAMODE               EQU     0BFH                                     ; Select VGA output mode. Bits [3:0] - Output mode.
GDCRTC                  EQU     0CFH                                     ; MZ-800 CRTC control register
GDCMD                   EQU     0CEH                                     ; MZ-800 CRTC Mode register
GDGRF                   EQU     0CDH                                     ; MZ-800      read format register
GDGWF                   EQU     0CCH                                     ; MZ-800      write format register
MMIO0                   EQU     0E0H                                     ; MZ-700/MZ-800 Memory Management Set 0
MMIO1                   EQU     0E1H                                     ; MZ-700/MZ-800 Memory Management Set 1
MMIO2                   EQU     0E2H                                     ; MZ-700/MZ-800 Memory Management Set 2
MMIO3                   EQU     0E3H                                     ; MZ-700/MZ-800 Memory Management Set 3
MMIO4                   EQU     0E4H                                     ; MZ-700/MZ-800 Memory Management Set 4
MMIO5                   EQU     0E5H                                     ; MZ-700/MZ-800 Memory Management Set 5
MMIO6                   EQU     0E6H                                     ; MZ-700/MZ-800 Memory Management Set 6
MMIO7                   EQU     0E7H                                     ; MZ-700/MZ-800 Memory Management Set 7
SYSCTRL                 EQU     0F0H                                     ; System board control register. [2:0] - 000 MZ80A Mode, 2MHz CPU/Bus, 001 MZ80B Mode, 4MHz CPU/Bus, 010 MZ700 Mode, 3.54MHz CPU/Bus.
GRAMMODE                EQU     0F4H                                     ; MZ80B Graphics mode.  Bit 0 = 0, Write to Graphics RAM I, Bit 0 = 1, Write to Graphics RAM II. Bit 1 = 1, blend Graphics RAM I output on display, Bit 2 = 1, blend Graphics RAM II output on display.

;-----------------------------------------------
; CPLD Configuration constants.
;-----------------------------------------------
MODE_MZ80K              EQU     0                                        ; Set to MZ-80K mode.
MODE_MZ80C              EQU     1                                        ; Set to MZ-80C mode.
MODE_MZ1200             EQU     2                                        ; Set to MZ-1200 mode.
MODE_MZ80A              EQU     3                                        ; Set to MZ-80A mode (base mode on MZ-80A hardware).
MODE_MZ700              EQU     4                                        ; Set to MZ-700 mode (base mode on MZ-700 hardware).
MODE_MZ800              EQU     5                                        ; Set to MZ-800 mode.
MODE_MZ80B              EQU     6                                        ; Set to MZ-80B mode.
MODE_MZ2000             EQU     7                                        ; Set to MZ-2000 mode.
MODE_VIDEO_FPGA         EQU     8                                        ; Bit flag (bit 3) to switch CPLD into using the new FPGA video hardware.
MODE_RESET_PRESERVE     EQU     080H                                     ; Preserve register configuration through reset.

;-----------------------------------------------
; CPLD Command Instruction constants.
;-----------------------------------------------
CPLD_RESET_HOST         EQU     1                                        ; CPLD level command to reset the host system.
CPLD_HOLD_HOST_BUS      EQU     2                                        ; CPLD command to hold the host bus.
CPLD_RELEASE_HOST_BUS   EQU     3                                        ; CPLD command to release the host bus.

;-----------------------------------------------
; FPGA CPU enhancement control bits.
;-----------------------------------------------
CPUMODE_SET_Z80         EQU     000H                                     ; Set the CPU to the hard Z80.
CPUMODE_SET_T80         EQU     001H                                     ; Set the CPU to the soft T80.
CPUMODE_SET_ZPU_EVO     EQU     002H                                     ; Set the CPU to the soft ZPU Evolution.
CPUMODE_SET_EMU_MZ      EQU     004H                                     ; Set the hardware to enable the Sharp MZ Series emulations.
CPUMODE_SET_BBB         EQU     008H                                     ; Place holder for a future soft CPU.
CPUMODE_SET_CCC         EQU     010H                                     ; Place holder for a future soft CPU.
CPUMODE_SET_DDD         EQU     020H                                     ; Place holder for a future soft CPU.
CPUMODE_IS_Z80          EQU     000H                                     ; Status value to indicate if the hard Z80 available.
CPUMODE_IS_T80          EQU     001H                                     ; Status value to indicate if the soft T80 available.
CPUMODE_IS_ZPU_EVO      EQU     002H                                     ; Status value to indicate if the soft ZPU Evolution available.
CPUMODE_IS_EMU_MZ       EQU     004H                                     ; Status value to indicate the Sharp MZ Series Hardware Emulation logic is available.
CPUMODE_IS_BBB          EQU     008H                                     ; Place holder to indicate if a future soft CPU is available.
CPUMODE_IS_CCC          EQU     010H                                     ; Place holder to indicate if a future soft CPU is available.
CPUMODE_IS_DDD          EQU     020H                                     ; Place holder to indicate if a future soft CPU is available.
CPUMODE_RESET_CPU       EQU     080H                                     ; Reset the soft CPU. Active high, when high the CPU is held in RESET, when low the CPU runs.
CPUMODE_IS_SOFT_AVAIL   EQU     040H                                     ; Marker to indicate if the underlying FPGA can support soft CPU's.
CPUMODE_IS_SOFT_MASK    EQU     0C0H                                     ; Mask to filter out the Soft CPU availability flags.
CPUMODE_IS_CPU_MASK     EQU     03FH                                     ; Mask to filter out which soft CPU's are available.

;-----------------------------------------------
; Video Module control bits.
;-----------------------------------------------
MODE_80CHAR             EQU     010H                                     ; Enable 80 character display.
MODE_COLOUR             EQU     020H                                     ; Enable colour display.
SYSMODE_MZ80A           EQU     000H                                     ; System board mode MZ80A, 2MHz CPU/Bus.
SYSMODE_MZ80B           EQU     020H                                     ; System board mode MZ80B, 4MHz CPU/Bus.
SYSMODE_MZ2000          EQU     020H                                     ; System board mode MZ2000, 4MHz CPU/Bus.
SYSMODE_MZ700           EQU     042H                                     ; System board mode MZ700, 3.54MHz CPU/Bus.
VMMODE_MZ80K            EQU     000H                                     ; Video mode = MZ80K
VMMODE_MZ80C            EQU     001H                                     ; Video mode = MZ80C
VMMODE_MZ1200           EQU     002H                                     ; Video mode = MZ1200
VMMODE_MZ80A            EQU     003H                                     ; Video mode = MZ80A
VMMODE_MZ700            EQU     004H                                     ; Video mode = MZ700
VMMODE_MZ800            EQU     005H                                     ; Video mode = MZ800
VMMODE_MZ1500           EQU     006H                                     ; Video mode = MZ1500
VMMODE_MZ80B            EQU     007H                                     ; Video mode = MZ80B
VMMODE_MZ2000           EQU     008H                                     ; Video mode = MZ2000
VMMODE_MZ2200           EQU     009H                                     ; Video mode = MZ2200
VMMODE_MZ2500           EQU     00AH                                     ; Video mode = MZ2500
VMMODE_PCGRAM           EQU     020H                                     ; Enable PCG RAM.
VMMODE_VGA_OFF          EQU     000H                                     ; Set VGA mode off, external monitor is driven by standard internal 60Hz signals.
VMMODE_VGA_INT          EQU     000H                                     ; Set VGA mode off, external monitor is driven by standard internal 60Hz signals.
VMMODE_VGA_INT50        EQU     001H                                     ; Set VGA mode off, external monitor is driven by standard internal 50Hz signals.
VMMODE_VGA_640x480      EQU     002H                                     ; Set external monitor to VGA 640x480 @ 60Hz mode.
VMMODE_VGA_800x600      EQU     003H                                     ; Set external monitor to VGA 800x600 @ 60Hz mode.

;-----------------------------------------------
; GPU commands.
;-----------------------------------------------
GPUCLEARVRAM            EQU     001H                                     ; Clear the VRAM without updating attributes.
GPUCLEARVRAMCA          EQU     002H                                     ; Clear the VRAM/ARAM with given attribute byte,
GPUCLEARVRAMP           EQU     003H                                     ; Clear the VRAM/ARAM with parameters.
GPUCLEARGRAM            EQU     081H                                     ; Clear the entire Framebuffer.
GPUCLEARGRAMP           EQU     082H                                     ; Clear the Framebuffer according to parameters.
GPURESET                EQU     0FFH                                     ; Reset the GPU, return to idle state.

;-----------------------------------------------
; tranZPUter SW Memory Management modes
;-----------------------------------------------
TZMM_ENIOWAIT           EQU     020H                                     ; Memory management IO Wait State enable - insert a wait state when an IO operation to E0-FF is executed.
TZMM_ORIG               EQU     000H                                     ; Original Sharp MZ80A mode, no tranZPUter features are selected except the I/O control registers (default: 0x60-063).
TZMM_BOOT               EQU     001H                                     ; Original mode but E800-EFFF is mapped to tranZPUter RAM so TZFS can be booted.
TZMM_TZFS               EQU     002H + TZMM_ENIOWAIT                     ; TZFS main memory configuration. all memory is in tranZPUter RAM, E800-FFFF is used by TZFS, SA1510 is at 0000-1000 and RAM is 1000-CFFF, 64K Block 0 selected.
TZMM_TZFS2              EQU     003H + TZMM_ENIOWAIT                     ; TZFS main memory configuration. all memory is in tranZPUter RAM, E800-EFFF is used by TZFS, SA1510 is at 0000-1000 and RAM is 1000-CFFF, 64K Block 0 selected, F000-FFFF is in 64K Block 1.
TZMM_TZFS3              EQU     004H + TZMM_ENIOWAIT                     ; TZFS main memory configuration. all memory is in tranZPUter RAM, E800-EFFF is used by TZFS, SA1510 is at 0000-1000 and RAM is 1000-CFFF, 64K Block 0 selected, F000-FFFF is in 64K Block 2.
TZMM_TZFS4              EQU     005H + TZMM_ENIOWAIT                     ; TZFS main memory configuration. all memory is in tranZPUter RAM, E800-EFFF is used by TZFS, SA1510 is at 0000-1000 and RAM is 1000-CFFF, 64K Block 0 selected, F000-FFFF is in 64K Block 3.
TZMM_CPM                EQU     006H + TZMM_ENIOWAIT                     ; CPM main memory configuration, all memory on the tranZPUter board, 64K block 4 selected. Special case for F3C0:F3FF & F7C0:F7FF (floppy disk paging vectors) which resides on the mainboard.
TZMM_CPM2               EQU     007H + TZMM_ENIOWAIT                     ; CPM main memory configuration, F000-FFFF are on the tranZPUter board in block 4, 0040-CFFF and E800-EFFF are in block 5, mainboard for D000-DFFF (video), E000-E800 (Memory control) selected.
                                                                         ; Special case for 0000:003F (interrupt vectors) which resides in block 4, F3C0:F3FF & F7C0:F7FF (floppy disk paging vectors) which resides on the mainboard.
TZMM_COMPAT             EQU     008H + TZMM_ENIOWAIT                     ; Original mode but with main DRAM in Bank 0 to allow bootstrapping of programs from other machines such as the MZ700.
TZMM_HOSTACCESS         EQU     009H + TZMM_ENIOWAIT                     ; Mode to allow code running in Bank 0, address E800:FFFF to access host memory. Monitor ROM 0000-0FFF and Main DRAM 0x1000-0xD000, video and memory mapped I/O are on the host machine, User/Floppy ROM E800-FFFF are in tranZPUter memory. 
TZMM_MZ700_0            EQU     00AH + TZMM_ENIOWAIT                     ; MZ700 Mode - 0000:0FFF is on the tranZPUter board in block 6, 1000:CFFF is on the tranZPUter board in block 0, D000:FFFF is on the mainboard.
TZMM_MZ700_1            EQU     00BH + TZMM_ENIOWAIT                     ; MZ700 Mode - 0000:0FFF is on the tranZPUter board in block 0, 1000:CFFF is on the tranZPUter board in block 0, D000:FFFF is on the tranZPUter in block 6.
TZMM_MZ700_2            EQU     00CH + TZMM_ENIOWAIT                     ; MZ700 Mode - 0000:0FFF is on the tranZPUter board in block 6, 1000:CFFF is on the tranZPUter board in block 0, D000:FFFF is on the tranZPUter in block 6.
TZMM_MZ700_3            EQU     00DH + TZMM_ENIOWAIT                     ; MZ700 Mode - 0000:0FFF is on the tranZPUter board in block 0, 1000:CFFF is on the tranZPUter board in block 0, D000:FFFF is inaccessible.
TZMM_MZ700_4            EQU     00EH + TZMM_ENIOWAIT                     ; MZ700 Mode - 0000:0FFF is on the tranZPUter board in block 6, 1000:CFFF is on the tranZPUter board in block 0, D000:FFFF is inaccessible.
TZMM_MZ800              EQU     00FH + TZMM_ENIOWAIT                     ; MZ800 Mode - Tracks original hardware mode offering MZ700/MZ800 configurations.
TZMM_MZ2000             EQU     010H + TZMM_ENIOWAIT;                    ; MZ2000 Mode - Running on MZ2000 hardware, configuration set according to runtime configuration registers.
TZMM_FPGA               EQU     015H + TZMM_ENIOWAIT                     ; Open up access for the K64F to the FPGA resources such as memory. All other access to RAM or mainboard is blocked.
TZMM_TZPUM              EQU     016H + TZMM_ENIOWAIT                     ; Everything in on mainboard, no access to tranZPUter memory.
TZMM_TZPU               EQU     017H + TZMM_ENIOWAIT                     ; Everything is in tranZPUter domain, no access to underlying Sharp mainboard unless memory management mode is switched. tranZPUter RAM 64K block 0 is selected.
;TZMM_TZPU0              EQU     018H + TZMM_ENIOWAIT                     ; Everything is in tranZPUter domain, no access to underlying Sharp mainboard unless memory management mode is switched. tranZPUter RAM 64K block 0 is selected.
;TZMM_TZPU1              EQU     019H + TZMM_ENIOWAIT                     ; Everything is in tranZPUter domain, no access to underlying Sharp mainboard unless memory management mode is switched. tranZPUter RAM 64K block 1 is selected.
;TZMM_TZPU2              EQU     01AH + TZMM_ENIOWAIT                     ; Everything is in tranZPUter domain, no access to underlying Sharp mainboard unless memory management mode is switched. tranZPUter RAM 64K block 2 is selected.
;TZMM_TZPU3              EQU     01BH + TZMM_ENIOWAIT                     ; Everything is in tranZPUter domain, no access to underlying Sharp mainboard unless memory management mode is switched. tranZPUter RAM 64K block 3 is selected.
;TZMM_TZPU4              EQU     01CH + TZMM_ENIOWAIT                     ; Everything is in tranZPUter domain, no access to underlying Sharp mainboard unless memory management mode is switched. tranZPUter RAM 64K block 4 is selected.
;TZMM_TZPU5              EQU     01DH + TZMM_ENIOWAIT                     ; Everything is in tranZPUter domain, no access to underlying Sharp mainboard unless memory management mode is switched. tranZPUter RAM 64K block 5 is selected.
;TZMM_TZPU6              EQU     01EH + TZMM_ENIOWAIT                     ; Everything is in tranZPUter domain, no access to underlying Sharp mainboard unless memory management mode is switched. tranZPUter RAM 64K block 6 is selected.
;TZMM_TZPU7              EQU     01FH + TZMM_ENIOWAIT                     ; Everything is in tranZPUter domain, no access to underlying Sharp mainboard unless memory management mode is switched. tranZPUter RAM 64K block 7 is selected.

;-----------------------------------------------
; TZ File System Header (MZF)
;-----------------------------------------------
TZFS_ATRB:              EQU     00000h                                   ; Code Type, 01 = Machine Code.
TZFS_NAME:              EQU     00001h                                   ; Title/Name (17 bytes).
TZFS_SIZE:              EQU     00012h                                   ; Size of program.
TZFS_DTADR:             EQU     00014h                                   ; Load address of program.
TZFS_EXADR:             EQU     00016h                                   ; Exec address of program.
TZFS_COMNT:             EQU     00018h                                   ; Comment
TZFS_MZFLEN:            EQU     128                                      ; Length of the MZF header.
TZFS_CMTLEN:            EQU     104                                      ; Length of the comment field

;-----------------------------------------------
; Entry/compilation start points.
;-----------------------------------------------
TPSTART:                EQU     010F0h
MEMSTART:               EQU     01200h
MSTART:                 EQU     0E900h
MZFHDRSZ                EQU     128
TZFSSECTSZ              EQU     256
MROMSIZE                EQU     4096
UROMSIZE                EQU     2048
FNSIZE                  EQU     17

;-----------------------------------------------
; RAM Banks, 0-3 are reserved for TZFS code in
;            the User/Floppy ROM bank area.
;-----------------------------------------------
USRROMPAGES             EQU     3                                        ; User ROM
ROMBANK0                EQU     0                                        ; TZFS Bank 0 - Main RFS Entry point and functions.
ROMBANK1                EQU     1                                        ; TZFS Bank 1 - 
ROMBANK2                EQU     2                                        ; TZFS Bank 2 - 
ROMBANK3                EQU     3                                        ; TZFS Bank 3 - 

OBJCD                   EQU     001H                                     ; MZF contains a binary object.
BTX1CD                  EQU     002H                                     ; MZF contains a BASIC program.
BTX2CD                  EQU     005H                                     ; MZF contains a BASIC program.
TZOBJCD0                EQU     0F8H                                     ; MZF contains a TZFS binary object for page 0.
TZOBJCD1                EQU     0F9H
TZOBJCD2                EQU     0FAH
TZOBJCD3                EQU     0FBH
TZOBJCD4                EQU     0FCH
TZOBJCD5                EQU     0FDH
TZOBJCD6                EQU     0FEH
TZOBJCD7                EQU     0FFH                                     ; MZF contains a TZFS binary object for page 7.

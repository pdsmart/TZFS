;--------------------------------------------------------------------------------------------------------
;-
;- Name:            tzfs_variales.asm
;- Created:         September 2019
;- Author(s):       Philip Smart
;- Description:     Sharp MZ series tzfs (tranZPUter Filing System).
;-                  This assembly language program is a branch from the original RFS written for the
;-                  MZ80A_RFS upgrade board. It is adapted to work within the similar yet different 
;-                  environment of the tranZPUter SW which has a large RAM capacity (512K) and an
;-                  I/O processor in the K64F/ZPU.
;-
;-                  This file holds the TZFS variable definitions.
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

                        ; Starting EC80H - variables used by the filing system.
                        ORG     TZVARMEM

;TZVARMEM:              EQU     0EC80H
;TZVARSIZE:             EQU     00100H
WARMSTART:              DS      virtual 1                                ; Warm start mode, 0 = cold start, 1 = warm start.
SCRNMODE:               DS      virtual 1                                ; Mode of screen, [0] = 0 - 40 char, 1 - 80 char, [1] = 0 - Mainboard video, 1 - FPGA Video, [2] = 1 set VGA mode, 0 = standard, [7:4] Video mode.
SCRNMODE2:              DS      virtual 1                                ; Mode of screen, [3:0] - VGA mode.
MMCFGVAL:               DS      virtual 1                                ; Current memory model value.
HLSAVE:                 DS      virtual 2                                ; Storage for HL during bank switch manipulation.
AFSAVE:                 DS      virtual 2                                ; Storage for AF during bank switch manipulation.
FNADDR:                 DS      virtual 2                                ; Function to be called address.
TMPADR:                 DS      virtual 2                                ; TEMPORARY ADDRESS STORAGE
TMPSIZE:                DS      virtual 2                                ; TEMPORARY SIZE
TMPCNT:                 DS      virtual 2                                ; TEMPORARY COUNTER
TMPLINECNT:             DS      virtual 2                                ; Temporary counter for displayed lines.
TMPSTACKP:              DS      virtual 2                                ; Temporary stack pointer save.
DUMPADDR:               DS      virtual 2                                ; Address used by the D(ump) command so that calls without parameters go onto the next block.
CMTLOLOAD:              DS      virtual 1                                ; Flag to indicate that a tape program is loaded into hi memory then shifted to low memory after ROM pageout.
CMTCOPY:                DS      virtual 1                                ; Flag to indicate that a CMT copy operation is taking place.
CMTAUTOEXEC:            DS      virtual 1                                ; Auto execution flag, run CMT program when loaded if flag clear.
DTADRSTORE:             DS      virtual 2                                ; Backup for load address if actual load shifts to lo memory or to 0x1200 for copy.
SDCOPY:                 DS      virtual 1                                ; Flag to indicate an SD copy is taking place, either CMT->SD or SD->CMT.
RESULT:                 DS      virtual 1                                ; Result variable needed for interbank calls when a result is needed.
SDAUTOEXEC:             DS      virtual 1                                ; Flag to indicate if a loaded file should be automatically executed.
FDCCMD:                 DS      virtual 1                                ; Floppy disk command storage. 
MOTON:                  DS      virtual 1                                ; Motor on flag.
TRK0FD1:                DS      virtual 1                                ; Floppy Disk 1 track 0 indicator.
TRK0FD2:                DS      virtual 1                                ; Floppy Disk 2 track 0 indicator.
TRK0FD3:                DS      virtual 1                                ; Floppy Disk 3 track 0 indicator.
TRK0FD4:                DS      virtual 1                                ; Floppy Disk 4 track 0 indicator.
RETRIES:                DS      virtual 1                                ; Retries count for a command.
BPARA:                  DS      virtual 1   
CMTINACTIVE:            DS      virtual 1                                ; Flag to indicate if the CMT is inactive (1)/SD active (0) for the CMT wrapper handlers.
CMTFILENO:              DS      virtual 1                                ; Sequential file access file number. Used when no filename is given, uses the directory entry number for the set wildcard,
HWMODEL:                DS      virtual 1                                ; Model of machine to tailor code execution 
CMTSAMPLECNT:           DS      virtual 1                                ; Delay count for bit sampling.
CMTDLY1CNTM:            DS      virtual 1                                ; Short pulse delay count MARK
CMTDLY1CNTS:            DS      virtual 1                                ; Short pulse delay count SPACE
CMTDLY2CNTM:            DS      virtual 1                                ; Long pulse delay count MARK
CMTDLY2CNTS:            DS      virtual 1                                ; Long pulse delay count SPACE
CMTDLYCOMP:             DS      virtual 1                                ; Tape delay compensation, -128..+127, to compensate for tape stretch or drive band decay.
                        DS      virtual (TZVARMEM + TZVARSIZE) - $       ; Top of variable area downwards is used as the working stack, SA1510 space isnt used.
TZSTACK:                EQU     TZVARMEM + TZVARSIZE

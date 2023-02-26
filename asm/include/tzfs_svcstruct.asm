;--------------------------------------------------------------------------------------------------------
;-
;- Name:            tzfs_svcstruct.asm
;- Created:         September 2019
;- Author(s):       Philip Smart
;- Description:     Sharp MZ series tzfs (tranZPUter Filing System).
;-                  This assembly language program is a branch from the original RFS written for the
;-                  MZ80A_RFS upgrade board. It is adapted to work within the similar yet different 
;-                  environment of the tranZPUter SW which has a large RAM capacity (512K) and an
;-                  I/O processor in the K64F/ZPU.
;-
;-                  This file holds the TZFS service structure definition.
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

TZSVC_CMD_READDIR       EQU     01H                                      ; Service command to open a directory and return the first block of entries.
TZSVC_CMD_NEXTDIR       EQU     02H                                      ; Service command to return the next block of an open directory.
TZSVC_CMD_READFILE      EQU     03H                                      ; Service command to open a file and return the first block.
TZSVC_CMD_NEXTREADFILE  EQU     04H                                      ; Service command to return the next block of an open file.
TZSVC_CMD_WRITEFILE     EQU     05H                                      ; Service command to create a file and save the first block.
TZSVC_CMD_NEXTWRITEFILE EQU     06H                                      ; Service command to write the next block to the open file.
TZSVC_CMD_CLOSE         EQU     07H                                      ; Service command to close any open file or directory.
TZSVC_CMD_LOADFILE      EQU     08H                                      ; Service command to load a file directly into tranZPUter memory.
TZSVC_CMD_SAVEFILE      EQU     09H                                      ; Service command to save a file directly from tranZPUter memory. 
TZSVC_CMD_ERASEFILE     EQU     0aH                                      ; Service command to erase a file on the SD card.
TZSVC_CMD_CHANGEDIR     EQU     0bH                                      ; Service command to change the active directory on the SD card.
TZSVC_CMD_LOAD40ABIOS   EQU     20H                                      ; Service command requesting that the 40 column version of the SA1510 BIOS is loaded.
TZSVC_CMD_LOAD80ABIOS   EQU     21H                                      ; Service command requesting that the 80 column version of the SA1510 BIOS is loaded.
TZSVC_CMD_LOAD700BIOS40 EQU     22H                                      ; Service command requesting that the MZ700 1Z-013A 40 column BIOS is loaded.
TZSVC_CMD_LOAD700BIOS80 EQU     23H                                      ; Service command requesting that the MZ700 1Z-013A 80 column patched BIOS is loaded.
TZSVC_CMD_LOAD80BIPL    EQU     24H                                      ; Service command requesting the MZ-80B IPL is loaded.
TZSVC_CMD_LOAD800BIOS   EQU     25H                                      ; Service command requesting that the MZ800 9Z-504M BIOS is loaded.
TZSVC_CMD_LOAD2000IPL   EQU     26H                                      ; Service command requesting the MZ-2000 IPL is loaded.
TZSVC_CMD_LOADTZFS      EQU     2FH                                      ; Service command requesting the loading of TZFS. This service is for machines which normally dont have a monitor BIOS. ie. MZ-80B/MZ-2000 and manually request TZFS.
TZSVC_CMD_LOADBDOS      EQU     30H                                      ; Service command to reload CPM BDOS+CCP.
TZSVC_CMD_ADDSDDRIVE    EQU     31H                                      ; Service command to attach a CPM disk to a drive number.
TZSVC_CMD_READSDDRIVE   EQU     32H                                      ; Service command to read an attached SD file as a CPM disk drive.
TZSVC_CMD_WRITESDDRIVE  EQU     33H                                      ; Service command to write to a CPM disk drive which is an attached SD file.
TZSVC_CMD_CPU_BASEFREQ  EQU     40H                                      ; Service command to switch to the mainboard frequency.
TZSVC_CMD_CPU_ALTFREQ   EQU     41H                                      ; Service command to switch to the alternate frequency provided by the K64F.
TZSVC_CMD_CPU_CHGFREQ   EQU     42H                                      ; Service command to set the alternate frequency in hertz.
TZSVC_CMD_CPU_SETZ80    EQU     50H                                      ; Service command to switch to the external Z80 hard cpu.
TZSVC_CMD_CPU_SETT80    EQU     51H                                      ; Service command to switch to the internal T80 soft cpu.
TZSVC_CMD_CPU_SETZPUEVO EQU     52H                                      ; Service command to switch to the internal ZPU Evolution soft cpu.
TZSVC_CMD_EMU_SETMZ80K  EQU     53H                                      ; Service command to switch to the internal Sharp MZ Series Emulation of the MZ80K.
TZSVC_CMD_EMU_SETMZ80C  EQU     54H                                      ; ""                             ""                       ""                 MZ80C.
TZSVC_CMD_EMU_SETMZ1200 EQU     55H                                      ; ""                             ""                       ""                 MZ1200.
TZSVC_CMD_EMU_SETMZ80A  EQU     56H                                      ; ""                             ""                       ""                 MZ80A.
TZSVC_CMD_EMU_SETMZ700  EQU     57H                                      ; ""                             ""                       ""                 MZ700.
TZSVC_CMD_EMU_SETMZ800  EQU     58H                                      ; ""                             ""                       ""                 MZ800.
TZSVC_CMD_EMU_SETMZ1500 EQU     59H                                      ; ""                             ""                       ""                 MZ1500.
TZSVC_CMD_EMU_SETMZ80B  EQU     5AH                                      ; ""                             ""                       ""                 MZ80B.
TZSVC_CMD_EMU_SETMZ2000 EQU     5BH                                      ; ""                             ""                       ""                 MZ2000.
TZSVC_CMD_EMU_SETMZ2200 EQU     5CH                                      ; ""                             ""                       ""                 MZ2200.
TZSVC_CMD_EMU_SETMZ2500 EQU     5DH                                      ; ""                             ""                       ""                 MZ2500.
TZSVC_CMD_EXIT          EQU     07FH                                     ; Service command to terminate TZFS and restart the machine in original mode.
TZSVC_STATUS_OK         EQU     000H                                     ; Flag to indicate the K64F processing completed successfully.
TZSVC_STATUS_REQUEST    EQU     0FEH                                     ; Flag to indicate the Z80 has made a request to the K64F.
TZSVC_STATUS_PROCESSING EQU     0FFH                                     ; Flag to indicate the K64F is processing a command.


                        ; Variables and control structure used by the I/O processor for service calls and requests.
                        ORG     TZSVCMEM

;TZSVCMEM:              EQU     0ED80H                                   ; Start of a memory structure used to communicate with the K64F I/O processor for services such as disk access.
TZSVCSIZE:              EQU     00280H                                   ;
TZSVCDIRSZ:             EQU     20                                       ; Size of the directory/file name.
TZSVCFILESZ:            EQU     17                                       ; Size of a Sharp filename.
TZSVCLONGFILESZ:        EQU     31                                       ; Size of a standard filename.
TZSVCLONGFMTSZ:         EQU     20                                       ; Size of a formatted standard filename for use in directory listings.
TZSVCWILDSZ:            EQU     20                                       ; Size of the wildcard.
TZSVCSECSIZE:           EQU     512
TZSVCDIR_ENTSZ:         EQU     32                                       ; Size of a directory entry.
TZSVCWAITIORETRIES:     EQU     5                                        ; Wait retries for IO response.
TZSVCWAITCOUNT:         EQU     65535                                    ; Wait retries for IO request response.
TZSVC_FTYPE_MZF:        EQU     0                                        ; File type being handled is an MZF
TZSVC_FTYPE_MZFHDR:     EQU     1                                        ; File type being handled is an MZF Header.
TZSVC_FTYPE_CAS:        EQU     2                                        ; File type being handled is an CASsette BASIC script.
TZSVC_FTYPE_BAS:        EQU     3                                        ; File type being handled is an BASic script
TZSVC_FTYPE_ALL:        EQU     10                                       ; Handle any filetype.
TZSVC_FTYPE_ALLFMT:     EQU     11                                       ; Special case for directory listings, all files but truncated and formatted.
TZSVCCMD:               DS      virtual 1                                ; Service command.
TZSVCRESULT:            DS      virtual 1                                ; Service command result.
TZSVCDIRSEC:            DS      virtual 1                                ; Storage for the directory sector number.
TZSVC_FILE_SEC:         EQU     TZSVCDIRSEC                              ; Union of the file and directory sector as only one can be used at a time.
TZSVC_TRACK_NO:         DS      virtual 2                                ; Storage for the virtual drive track number.
TZSVC_SECTOR_NO:        DS      virtual 2                                ; Storage for the virtual drive sector number.
TZSVC_SECTOR_LBA:       EQU     TZSVC_TRACK_NO                           ; Sector in 32bit LBA format.
TZSVC_MEM_TARGET:       EQU     TZSVC_TRACK_NO                           ; Memory command should target, 0 = tranZPUter, 1 = mainboard.
TZSVC_FILE_NO:          DS      virtual 1                                ; File number to be opened in a file service command.
TZSVC_FILE_TYPE:        DS      virtual 1                                ; Type of file being accessed to differentiate between Sharp MZF files and other handled files.
TZSVC_LOADADDR:         DS      virtual 2                                ; Dynamic load address for rom/images.
TZSVC_SAVEADDR:         EQU     TZSVC_LOADADDR                           ; Union of the load address and the cpu frequency change value, the address  of data to be saved.
TZSVC_CPU_FREQ:         EQU     TZSVC_LOADADDR                           ; Union of the load address and the save address value, only one can be used at a time.
TZSVC_LOADSIZE:         DS      virtual 2                                ; Size of image to load.
TZSVC_SAVESIZE:         EQU     TZSVC_LOADSIZE                           ; Size of image to be saved.
TZSVC_DIRNAME:          DS      virtual TZSVCDIRSZ                       ; Service directory/file name.
TZSVC_FILENAME:         DS      virtual TZSVCFILESZ                      ; Filename to be opened/created.
TZSVCWILDC:             DS      virtual TZSVCWILDSZ                      ; Directory wildcard for file pattern matching.
TZSVCSECTOR:            DS      virtual TZSVCSECSIZE                     ; Service command sector - to store directory entries, file sector read or writes.


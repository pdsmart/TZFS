#!/bin/bash
#########################################################################################################
##
## Name:            assemble_roms.sh
## Created:         August 2018
## Author(s):       Philip Smart
## Description:     Sharp MZ series ROM assembly tool
##                  This script takes Sharp MZ ROMS in assembler format and compiles/assembles them
##                  into a ROM file using the GLASS Z80 assembler.
##
## Credits:         
## Copyright:       (c) 2018-23 Philip Smart <philip.smart@net2net.org>
##
## History:         August 2018   - Initial script written.
##                  March 2021    - Added MZ-800 IPL
##                  March 2021    - Updated to compile different versions of Microsoft BASIC.
##                  February 2023 - Updated as TZFS extracted into seperate repository.
##
#########################################################################################################
## This source file is free software: you can redistribute it and#or modify
## it under the terms of the GNU General Public License as published
## by the Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.
##
## This source file is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program.  If not, see <http://www.gnu.org/licenses/>.
#########################################################################################################

ROOTDIR=`pwd | sed 's/\/tools//g'`
TOOLDIR=${ROOTDIR}/tools
JARDIR=${ROOTDIR}/tools
ASM=glass-0.5.jar
BUILDROMLIST="mz2000_ipl_original mz2000_ipl_tzpu mz800_1z_013b mz800_9z_504m mz800_iocs mz80afi monitor_sa1510 monitor_80c_sa1510 monitor_1z-013a monitor_80c_1z-013a monitor_1z-013a-km monitor_80c_1z-013a-km mz80b_ipl"
#BUILDMZFLIST="hi-ramcheck sharpmz-test"
#BUILDMZFLIST="basic_sp-5025 5z009-1b sa-5510_tzfs msbasic_mz80a msbasic_mz700 msbasic_tz40 msbasic_tz80 sharpmz-test"
BUILDMZFLIST="5z009-1b sa-5510_tzfs msbasic_mz80a msbasic_mz700 msbasic_mz1500 msbasic_tz40 msbasic_tz80 sharpmz-test"
ASMDIR=${ROOTDIR}/asm
ASMTMPDIR=${ROOTDIR}/tmp
INCDIR=${ROOTDIR}/asm/include
ROMDIR=${ROOTDIR}/roms
MZFDIR=${ROOTDIR}/MZF/Common

# Go through list and build image.
#
for f in ${BUILDROMLIST} ${BUILDMZFLIST}
do
    echo "Assembling: $f..."

    SRCNAME=${f}
    ASMNAME=${f}.asm
    OBJNAME=${f}.obj
    SYMNAME=${f}.sym
    ROMNAME=${f}.rom
    MZFNAME=${f}.mzf

    # Special handling for the 4 version of MS BASIC.
    if [[ ${SRCNAME} = "msbasic_mz80a" ]]; then
        ASMNAME="msbasic.asm"
        echo "BUILD_VERSION EQU 0" > ${INCDIR}/MSBASIC_BuildVersion.asm
    elif [[ ${SRCNAME} = "msbasic_mz700" ]]; then
        ASMNAME="msbasic.asm"
        echo "BUILD_VERSION EQU 1" > ${INCDIR}/MSBASIC_BuildVersion.asm
    elif [[ ${SRCNAME} = "msbasic_tz40" ]]; then
        ASMNAME="msbasic.asm"
        echo "BUILD_VERSION EQU 2" > ${INCDIR}/MSBASIC_BuildVersion.asm
    elif [[ ${SRCNAME} = "msbasic_tz80" ]]; then
        ASMNAME="msbasic.asm"
        echo "BUILD_VERSION EQU 3" > ${INCDIR}/MSBASIC_BuildVersion.asm
    elif [[ ${SRCNAME} = "msbasic_mz1500" ]]; then
        ASMNAME="msbasic.asm"
        echo "BUILD_VERSION EQU 4" > ${INCDIR}/MSBASIC_BuildVersion.asm
    fi

    # Assemble the source.
    echo "java -jar ${JARDIR}/${ASM} ${ASMDIR}/${ASMNAME} ${ASMTMPDIR}/${OBJNAME} ${ASMTMPDIR}/${SYMNAME}"
    java -jar ${JARDIR}/${ASM} ${ASMDIR}/${ASMNAME} ${ASMTMPDIR}/${OBJNAME} ${ASMTMPDIR}/${SYMNAME} -I ${INCDIR}

    # On successful compile, perform post actions else go onto next build.
    #
    if [ $? = 0 ]
    then
        # The object file is binary, no need to link, copy according to build group.
        if [[ ${BUILDROMLIST} = *"${SRCNAME}"* ]]; then
            echo "Copy ${ASMTMPDIR}/${OBJNAME} to ${ROMDIR}/${ROMNAME}"
            cp ${ASMTMPDIR}/${OBJNAME} ${ROMDIR}/${ROMNAME}
        else
            # Build standard MZF files for inclusion in the SD Drive.
            echo "Copy ${ASMTMPDIR}/${OBJNAME} to ${MZFDIR}/${MZFNAME}"
            cp ${ASMTMPDIR}/${OBJNAME} ${MZFDIR}/${MZFNAME}

            # Create sectored versions of file for inclusion into the ROM Drives.
            for BLOCKSIZE in ${BLOCKSIZELIST}
            do
                FILESIZE=$(stat -c%s "${ASMTMPDIR}/${OBJNAME}")
                if [ $((${FILESIZE} % ${BLOCKSIZE})) -ne 0 ]; then
                    FILESIZE=$(( ((${FILESIZE} / ${BLOCKSIZE})+1 ) * ${BLOCKSIZE} ))
                fi

                dd if=/dev/zero ibs=1 count=${FILESIZE} 2>/dev/null | tr "\000" "\377" > "${MZBDIR}/${SRCNAME}.${BLOCKSIZE}.bin"
                dd if="${ASMTMPDIR}/${OBJNAME}" of="${MZBDIR}/${SRCNAME}.${BLOCKSIZE}.bin" conv=notrunc 2>/dev/null
            done
        fi
    fi
done

# Manual tinkering to build the MZ800 Rom.
cat ${ROMDIR}/mz800_1z_013b.rom ${ROMDIR}/mz800_cgrom.ori ${ROMDIR}/mz800_9z_504m.rom ${ROMDIR}/mz800_iocs.rom > ${ROMDIR}/mz800_ipl.rom

#!/bin/bash -x
#########################################################################################################
##
## Name:            assemble_cpm.sh
## Created:         August 2018
## Author(s):       Philip Smart
## Description:     Sharp MZ series CPM assembly tool
##                  This script builds a CPM version compatible with the MZ-80A RFS system.
##
## Credits:         
## Copyright:       (c) 2018-2023 Philip Smart <philip.smart@net2net.org>
##
## History:         January 2020   - Initial script written.
##                  February 2023  - Updated as TZFS extracted into seperate repository.
##
#########################################################################################################
## This source file is free software: you can redistribute it and/or modify
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
TOOLDIR=${ROOTDIR}//tools
JARDIR=${ROOTDIR}//tools
ASM=glass.jar
BUILDROMLIST="cbios cpm22"
ASMDIR=${ROOTDIR}/asm
ASMTMPDIR=${ROOTDIR}/tmp
INCDIR=${ROOTDIR}/asm/include
ROMDIR=${ROOTDIR}/roms                     # Compiled or source ROM files.
HDRDIR=${ROOTDIR}/hdr                      # MZF headers directory.
MZFDIR=${ROOTDIR}/MZF/Common               # MZF Format source files.
CPMVERSIONS="mz700_80c:0 mz80a_80c:1 mz80a_40c:2"

# As the tranZPUter project has eveolved different variants of CP/M are needed, so this loop along with the CPMVERSIONS string builds the versions as needed.
for ver in ${CPMVERSIONS}
do
    # Setup the version to be built.
    FILEEXT=`echo ${ver} |cut -d: -f1`
    BUILDVER=`echo ${ver}|cut -d: -f2`
    echo "BUILD_VERSION EQU ${BUILDVER}" > ${INCDIR}/cpm_buildversion.asm

    # Go through list and build images.
    #
    for f in ${BUILDROMLIST}
    do
        echo "Assembling: $f..."
    
        # Assemble the source.
        echo "java -jar ${JARDIR}/${ASM} ${ASMDIR}/${f}.asm ${ASMTMPDIR}/${f}.obj ${ASMTMPDIR}/${f}.sym"
        java -jar ${JARDIR}/${ASM} ${ASMDIR}/${f}.asm ${ASMTMPDIR}/${f}.obj ${ASMTMPDIR}/${f}.sym -I ${INCDIR}
    
        # On successful compile, perform post actions else go onto next build.
        #
        if [ $? = 0 ]
        then
            # The object file is binary, no need to link, copy according to build group.
            echo "Copy ${ASMDIR}/${f}.obj to ${ROMDIR}/${f}.bin"
            cp ${ASMTMPDIR}/${f}.obj ${ROMDIR}/${f}.bin
        fi
    done

    # Manual tinkering to produce the loadable MZF file...
    #
    cat ${ROMDIR}/cpm22.bin ${ROMDIR}/cbios.bin  > ${ROMDIR}/cpm223_${FILEEXT}.bin
    cat ${HDRDIR}/cpm22_${FILEEXT}.hdr ${ROMDIR}/cpm223_${FILEEXT}.bin > ${MZFDIR}/cpm223_${FILEEXT}.mzf
done

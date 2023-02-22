#!/bin/bash
#========================================================================================================
# NAME
#     copytosd.sh -  Shell script to copy necessary TZFS, CPM and host program files to SD card for the
#                    tranZPUter SW K64F processor.
#
# SYNOPSIS
#     copytosd.sh [-cdxDMt]
#
# DESCRIPTION
#
# OPTIONS
#     -D<root path> = Absolute path to root of tranZPUter project dir.
#     -M<mediapath> = Path to mounted SD card.
#     -t<targethost>= Target host, MZ-80K, MZ-80A, MZ-700, MZ-800, MZ-1500, MZ-2000
#     -d            = Debug mode.
#     -x            = Shell trace mode.
#     -h            = This help screen.
#
# EXAMPLES
#     copytosd.sh -D/projects/github -M/media/guest/7764-2389 -tMZ-700
#
# EXIT STATUS
#      0    The command ran successfully
#
#      >0    An error ocurred.
#
#EndOfUsage <- do not remove this line
#========================================================================================================
# History:
#          v1.00         : Initial version (C) P. Smart January 2020.
#          v1.10         : Updated to cater for different targets, copying selected files accordingly.
#          v1.11 02/23   : Updated as TZFS extracted into seperate repository.
#========================================================================================================
# This source file is free software: you can redistribute it and#or modify
# it under the terms of the GNU General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This source file is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#========================================================================================================

PROG=${0##*/}
#PARAMS="`basename ${PROG} '.sh'`.params"
ARGS=$*

##############################################################################
# Load program specific variables
##############################################################################

# VERSION of this RELEASE.
#
VERSION="1.10"

# Temporary files.
TMP_DIR=/tmp
TMP_OUTPUT_FILE=${TMP_DIR}/tmpoutput_$$.log
TMP_STDERR_FILE=${TMP_DIR}/tmperror_$$.log

# Log mechanism setup.
#
LOG="/tmp/${PROG}_`date +"%Y_%m_%d"`.log"
LOGTIMEWIDTH=40
LOGMODULE="MAIN"

# Mutex's - prevent multiple threads entering a sensitive block at the same time.
#
MUTEXDIR="/var/tmp"

##############################################################################
# Utility procedures
##############################################################################

# Function to output Usage instructions, which is soley a copy of this script header.
#
function Usage
{
    # Output the lines at the start of this script from NAME to EndOfUsage
    cat $0 | nawk 'BEGIN {s=0} /EndOfUsage/ { exit } /NAME/ {s=1} { if (s==1) print substr( $0, 3 ) }'
    exit 1
}

# Function to output a message in Log format, ie. includes date, time and issuing module.
#
function Log
{
    DATESTR=`date "+%d/%m/%Y %H:%M:%S"`
    PADLEN=`expr ${LOGTIMEWIDTH} + -${#DATESTR} + -1 + -${#LOGMODULE} + -15`
    printf "%s %-${PADLEN}s %s\n" "${DATESTR} [$LOGMODULE]" " " "$*"
}

# Function to terminate the script after logging an error message.
#
function Fatal
{
    Log "ERROR: $*"
    Log "$PROG aborted"
    exit 2
}

# Function to output the Usage, then invoke Fatal to exit with a terminal message.
#
function FatalUsage
{
    # Output the lines at the start of this script from NAME to EndOfUsage
    cat $0 | nawk 'BEGIN {s=0} /EndOfUsage/ { exit } /NAME/ {s=1} { if (s==1) print substr( $0, 3 ) }'
    echo " "
    echo "ERROR: $*"
    echo "$PROG aborted"
    exit 3
}

# Function to output a message if DEBUG mode is enabled. Primarily to see debug messages should a
# problem occur.
#
function Debug
{
    if [ $DEBUGMODE -eq 1 ]; then
        Log "$*"
    fi
}

# Function to output a file if DEBUG mode is enabled.
#
function DebugFile
{
    if [ $DEBUGMODE -eq 1 ]; then
        cat $1
    fi
}

# Setup default media location.
#media=/media/psmart/A6F4-14E8;
#media=/media/psmart/1DBB-7404;
#media=/media/psmart/1BC8-C12D/;
#media=/media/psmart/6B92-7702;
media=/media/psmart/K64F/; 

# Setup default target.
target=MZ-80A
#target=MZ-700
#target=MZ-800
#target=MZ-2000
#target=MZ-80B

# Setup root directory.
rootdir=`pwd | sed 's/\/tools//g'`

# Directory where software is held in root.
softwaredira=${rootdir}

# Process parameters, loading up variables as necessary.
#
if [ $# -gt 0 ]; then
    while getopts ":dhM:t:D:x" opt; do
        case $opt in
            d)     DEBUGMODE=1;;
            D)     rootdir=${OPTARG};;
            M)     media=${OPTARG};;
            t)     target=${OPTARG};;
            x)     set -x; TRACEMODE=1;;
            h)     Usage;;
           \?)     FatalUsage "Unknown option: -${OPTARG}";;
        esac
    done
    shift $(($OPTIND - 1 ))
fi

# Sanity checks.
if [ ! -d "${rootdir}/${softwaredir}" ]; then
    Fatal "-D < root path > is invalid, this should be the directory where the tranZPUter project directory is located."
fi
if [ ! -d "${rootdir}/${softwaredir}/MZF/${target}" ]; then
    Fatal "-t < target host> is invalid, this should be one of: MZ-80K, MZ-80A, MZ-700, MZ-800, MZ-1500, MZ-2000"
fi
if [ ! -d "${media}" ]; then
    Fatal "-M < media path > is invalid, this should be the mounted SD card directory."
fi

# Create necessary directories on the SD card and clean them out.
#for dir in TZFS MZF MZ80K MZ80A MZ80B MZ700 MZ800 MZ1500 MZ2000 CPM MSBAS MSCAS
for dir in BASIC MSBAS MSCAS CPM DSK MZF TZFS
do
    # Clean out the directories to avoid old files being used.
    if [[ "${media}x" != "x" ]]; then
        mkdir -p $media/${dir}/;
        if [ -d $media/${dir} ]; then
            rm -fr $media/${dir}/*;
        fi
    fi

    if [[ "${dir}" = "DSK" ]] || [[ "${dir}" = "MZF" ]]; then
        for subdir in MZ80K MZ80C MZ1200 MZ80A MZ700 MZ700-2 MZ1500 MZ800 MZ80B MZ2000 MZ2200 MZ2500
        do
            # Clean out the directories to avoid old files being used.
            if [[ "${media}x" != "x" ]]; then
                mkdir -p $media/${dir}/${subdir}/;
                if [ -d $media/${dir}/${subdir} ]; then
                    rm -f $media/${dir}/${subdir}/*;
                fi
            fi
        done
    fi
done

# Manually copy required files.
cp -fup ${rootdir}/${softwaredir}/roms/tzfs.rom                        $media/TZFS/; 
cp -fup ${rootdir}/${softwaredir}/roms/sp1002.rom                      $media/TZFS/sp1002.rom; 
cp -fup ${rootdir}/${softwaredir}/roms/sp1002Jp.rom                    $media/TZFS/sp1002.rom; 
cp -fup ${rootdir}/${softwaredir}/roms/monitor_sa1510.rom              $media/TZFS/sa1510.rom; 
cp -fup ${rootdir}/${softwaredir}/roms/monitor_80c_sa1510.rom          $media/TZFS/sa1510-8.rom; 
cp -fup ${rootdir}/${softwaredir}/roms/monitor_1z-013a.rom             $media/TZFS/1z-013a.rom; 
cp -fup ${rootdir}/${softwaredir}/roms/monitor_80c_1z-013a.rom         $media/TZFS/1z-013a-8.rom; 
cp -fup ${rootdir}/${softwaredir}/roms/monitor_1z-013a-km.rom          $media/TZFS/1z-013a-km.rom; 
cp -fup ${rootdir}/${softwaredir}/roms/monitor_80c_1z-013a-km.rom      $media/TZFS/1z-013a-km-8.rom; 
cp -fup ${rootdir}/${softwaredir}/roms/mz80a_*.rom                     $media/TZFS/; 
cp -fup ${rootdir}/${softwaredir}/roms/mz80b_ipl.rom                   $media/TZFS/mz80b_ipl.rom; 
cp -fup ${rootdir}/${softwaredir}/roms/mz80b_cgrom.rom                 $media/TZFS/mz80b_cgrom.rom; 
cp -fup ${rootdir}/${softwaredir}/roms/mz80k_*.rom                     $media/TZFS/; 
cp -fup ${rootdir}/${softwaredir}/roms/mz80ktc.rom                     $media/TZFS/; 
cp -fup ${rootdir}/${softwaredir}/roms/mz80k_jp_cgrom.rom              $media/TZFS/; 
cp -fup ${rootdir}/${softwaredir}/roms/mz80kfdif.rom                   $media/TZFS/; 
cp -fup ${rootdir}/${softwaredir}/roms/700_80K_km.rom                  $media/TZFS/700_80K_km.rom; 
cp -fup ${rootdir}/${softwaredir}/roms/700_80C_km.rom                  $media/TZFS/700_80C_km.rom; 
cp -fup ${rootdir}/${softwaredir}/roms/700_1200_km.rom                 $media/TZFS/700_1200_km.rom; 
cp -fup ${rootdir}/${softwaredir}/roms/700_80A_km.rom                  $media/TZFS/700_80A_km.rom; 
cp -fup ${rootdir}/${softwaredir}/roms/700_700_km.rom                  $media/TZFS/700_700_km.rom; 
cp -fup ${rootdir}/${softwaredir}/roms/700_800_km.rom                  $media/TZFS/700_800_km.rom; 
cp -fup ${rootdir}/${softwaredir}/roms/700_1500_km.rom                 $media/TZFS/700_1500_km.rom; 
cp -fup ${rootdir}/${softwaredir}/roms/700_80B_km.rom                  $media/TZFS/700_80B_km.rom; 
cp -fup ${rootdir}/${softwaredir}/roms/700_2000_km.rom                 $media/TZFS/700_2000_km.rom; 
cp -fup ${rootdir}/${softwaredir}/roms/700_2200_km.rom                 $media/TZFS/700_2200_km.rom; 
cp -fup ${rootdir}/${softwaredir}/roms/700_2500_km.rom                 $media/TZFS/700_2500_km.rom; 
cp -fup ${rootdir}/${softwaredir}/roms/80A_80K_km.rom                  $media/TZFS/80A_80K_km.rom; 
cp -fup ${rootdir}/${softwaredir}/roms/80A_80C_km.rom                  $media/TZFS/80A_80C_km.rom; 
cp -fup ${rootdir}/${softwaredir}/roms/80A_1200_km.rom                 $media/TZFS/80A_1200_km.rom; 
cp -fup ${rootdir}/${softwaredir}/roms/80A_80A_km.rom                  $media/TZFS/80A_80A_km.rom; 
cp -fup ${rootdir}/${softwaredir}/roms/80A_700_km.rom                  $media/TZFS/80A_700_km.rom; 
cp -fup ${rootdir}/${softwaredir}/roms/80A_800_km.rom                  $media/TZFS/80A_800_km.rom; 
cp -fup ${rootdir}/${softwaredir}/roms/80A_1500_km.rom                 $media/TZFS/80A_1500_km.rom; 
cp -fup ${rootdir}/${softwaredir}/roms/80A_80B_km.rom                  $media/TZFS/80A_80B_km.rom; 
cp -fup ${rootdir}/${softwaredir}/roms/80A_2000_km.rom                 $media/TZFS/80A_2000_km.rom; 
cp -fup ${rootdir}/${softwaredir}/roms/80A_2200_km.rom                 $media/TZFS/80A_2200_km.rom; 
cp -fup ${rootdir}/${softwaredir}/roms/80A_2500_km.rom                 $media/TZFS/80A_2500_km.rom; 
cp -fup ${rootdir}/${softwaredir}/roms/2000_80K_km.rom                 $media/TZFS/2000_80K_km.rom; 
cp -fup ${rootdir}/${softwaredir}/roms/2000_80C_km.rom                 $media/TZFS/2000_80C_km.rom; 
cp -fup ${rootdir}/${softwaredir}/roms/2000_1200_km.rom                $media/TZFS/2000_1200_km.rom; 
cp -fup ${rootdir}/${softwaredir}/roms/2000_80A_km.rom                 $media/TZFS/2000_80A_km.rom; 
cp -fup ${rootdir}/${softwaredir}/roms/2000_700_km.rom                 $media/TZFS/2000_700_km.rom; 
cp -fup ${rootdir}/${softwaredir}/roms/2000_800_km.rom                 $media/TZFS/2000_800_km.rom; 
cp -fup ${rootdir}/${softwaredir}/roms/2000_1500_km.rom                $media/TZFS/2000_1500_km.rom; 
cp -fup ${rootdir}/${softwaredir}/roms/2000_80B_km.rom                 $media/TZFS/2000_80B_km.rom; 
cp -fup ${rootdir}/${softwaredir}/roms/2000_2000_km.rom                $media/TZFS/2000_2000_km.rom; 
cp -fup ${rootdir}/${softwaredir}/roms/2000_2200_km.rom                $media/TZFS/2000_2200_km.rom; 
cp -fup ${rootdir}/${softwaredir}/roms/2000_2500_km.rom                $media/TZFS/2000_2500_km.rom; 
cp -fup ${rootdir}/${softwaredir}/roms/mz700_*                         $media/TZFS/;
cp -fup ${rootdir}/${softwaredir}/roms/mz-1e05.rom                     $media/TZFS/;
cp -fup ${rootdir}/${softwaredir}/roms/mz-1e14.rom                     $media/TZFS/;
cp -fup ${rootdir}/${softwaredir}/roms/sfd700.rom                      $media/TZFS/;
cp -fup ${rootdir}/${softwaredir}/roms/mz800_*                         $media/TZFS/;
cp -fup ${rootdir}/${softwaredir}/roms/mz1500_ipl.rom                  $media/TZFS/mz1500_ipl.rom; 
cp -fup ${rootdir}/${softwaredir}/roms/mz2000_ipl_original.rom         $media/TZFS/mz2000_ipl.rom; 
cp -fup ${rootdir}/${softwaredir}/roms/mz2000_ipl_tzpu.rom             $media/TZFS/mz2000_ipl_tzpu.rom; 
cp -fup ${rootdir}/${softwaredir}/roms/mz2000_cgrom.rom                $media/TZFS/mz2000_cgrom.rom; 
cp -fup ${rootdir}/${softwaredir}/roms/cpm22.bin                       $media/CPM/; 
cp -fup ${rootdir}/${softwaredir}/CPM/SDC16M/RAW/*                     $media/CPM/; 
cp -fup ${rootdir}/${softwaredir}/MZF/Common/*                         $media/MZF/;
cp -fup ${rootdir}/${softwaredir}/MZF/MZ-80K/*                         $media/MZF/MZ80K/;
cp -fup ${rootdir}/${softwaredir}/MZF/MZ-80A/*                         $media/MZF/MZ80A/;
cp -fup ${rootdir}/${softwaredir}/MZF/MZ-80B/*                         $media/MZF/MZ80B/;
cp -fup ${rootdir}/${softwaredir}/MZF/MZ-80C/*                         $media/MZF/MZ80C/;
cp -fup ${rootdir}/${softwaredir}/MZF/MZ-700/*                         $media/MZF/MZ700/;
cp -fup ${rootdir}/${softwaredir}/MZF/MZ-700-2/*                       $media/MZF/MZ700-2/;
cp -fup ${rootdir}/${softwaredir}/MZF/MZ-800/*                         $media/MZF/MZ800/;
cp -fup ${rootdir}/${softwaredir}/MZF/MZ-1200/*                        $media/MZF/MZ1200/;
cp -fup ${rootdir}/${softwaredir}/MZF/MZ-1500/*                        $media/MZF/MZ1500/;
cp -fup ${rootdir}/${softwaredir}/MZF/MZ-2000/*                        $media/MZF/MZ2000/;
cp -fup ${rootdir}/${softwaredir}/MZF/MZ-2200/*                        $media/MZF/MZ2200/;
cp -fup ${rootdir}/${softwaredir}/MZF/MZ-2500/*                        $media/MZF/MZ2500/;
cp -fup ${rootdir}/${softwaredir}/BAS/*                                $media/MSBAS/; 
cp -fup ${rootdir}/${softwaredir}/CAS/*                                $media/MSCAS/
cp -fup ${rootdir}/${softwaredir}/Basic/*                              $media/BASIC/; 
cp -fup ${rootdir}/${softwaredir}/DSK/MZ-80K/*                         $media/DSK/MZ80K/;
cp -fup ${rootdir}/${softwaredir}/DSK/MZ-80A/*                         $media/DSK/MZ80A/;
cp -fup ${rootdir}/${softwaredir}/DSK/MZ-80B/*                         $media/DSK/MZ80B/;
cp -fup ${rootdir}/${softwaredir}/DSK/MZ-80C/*                         $media/DSK/MZ80C/;
cp -fup ${rootdir}/${softwaredir}/DSK/MZ-700/*                         $media/DSK/MZ700/;
cp -fup ${rootdir}/${softwaredir}/DSK/MZ-800/*                         $media/DSK/MZ800/;
cp -fup ${rootdir}/${softwaredir}/DSK/MZ-1200/*                        $media/DSK/MZ1200/;
cp -fup ${rootdir}/${softwaredir}/DSK/MZ-1500/*                        $media/DSK/MZ1500/;
cp -fup ${rootdir}/${softwaredir}/DSK/MZ-2000/*                        $media/DSK/MZ2000/;
cp -fup ${rootdir}/${softwaredir}/DSK/MZ-2200/*                        $media/DSK/MZ2200/;
cp -fup ${rootdir}/${softwaredir}/DSK/MZ-2500/*                        $media/DSK/MZ2500/;




echo "Done, TZFS, CPM and host programs copied to SD card."
exit 0

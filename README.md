### *T*ran*Z*puter *F*iling *S*ystem

The TranZputer Filing System is a port of the [Rom Filing System](/sharpmz-upgrades-rfs/) used on the RFS hardware upgrade board. It reuses much of the same software functionality and consequently provides the same services,
the differences lie in the use of a different memory model. It's purpose is to provide methods to manipulate files stored on the SD card and provide an extended command line interface, the TZFS Monitor. The command set includes
SD file manipulation and backup along with a number of commands found on the MZ700/800 computers.

<div style="text-align: justify">
The advent of the tranZPUter FusionX with it's virtual I/O processor prompted the seperation of this software out of the tranZPUter repository into a standalone module. TZFS runs on all the
tranZPUter range, include the newer tzpuFusionX and tzpuFusion devices.
<br><br>

The SD card and ROM's are managed by the K64F I/O processor. A service request API has been written where by a common shared memory block (640byte) is used in conjunction with a physical I/O request to pass commands and data between the
Z80 and the K64F. ie. When the Z80 wants to read an SD file, it creates a request to open a file in the memory block,  makes a physical I/O operation which the K64F detects via interrupt, it opens the file and passes the data back to 
the Z80 one sector at a time in the shared memory.
</div>

Under RFS the software had to be split into many ROM pages and accessed via paging as necessary, the same is true for TZFS but the pages are larger and thus less pages are needed.

The following files form the TranZputer Filing System:

| Module                  | Target Location | Size | Bank | Description                                                                                                                                                             |
|-------------------------|-----------------|------|------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| tzfs.asm                | 0xE800:0xFFFF   | 6K   | 0    | Primary TranZputer Filing System and MZ700/MZ800 Monitor tools.                                                                                                         |
| tzfs_bank2.asm          | 0xF000:0xFFFF   | 4K   | 1    | Message printing routines, static messages, ascii conversion and help screen.                                                                                           |
| tzfs_bank3.asm          | 0xF000:0xFFFF   | 4K   | 2    | Unused.                                                                                                                                                                 |
| tzfs_bank4.asm          | 0xF000:0xFFFF   | 4K   | 3    | Unused.                                                                                                                                                                 |
| monitor_SA1510.asm      | 0x00000:0x01000 | 4K   | 0    | Original SA1510 Monitor for 40 character display loaded into 64K Bank 0 of tranZPUter memory.                                                                           |
| monitor_80c_SA1510.asm  | 0x00000:0x01000 | 4K   | 0    | Original SA1510 Monitor patched for 80 character display loaded upon demand into 64K Bank 0 of tranZPUter memory.                                                       |
| monitor_1Z-013A.asm     | 0x00000:0x01000 | 4K   | 0    | Original 1Z-013A Monitor for the Sharp MZ-700 patched to use the MZ-80A keybaord and attribute RAM colours.                                                             |
| monitor_80c_1Z-013A.asm | 0x00000:0x01000 | 4K   | 0    | Original 1Z-013A Monitor for the Sharp MZ-700 patched to use the MZ-80A keybaord, attribute RAM colours and 80 column mode.                                             |
| MZ80B_IPL.asm           | 0x00000:0x01000 | 4K   | 0    | Original Sharp MZ-80B IPL firmware to bootstrap MZ-80B programs.                                                                                                        |



In addition there are several shell scripts to aid in the building of TZFS software, namely:

| Script            |  Description                                                                                                             |
|------------------ | ------------------------------------------------------------------------------------------------------------------------ |
| assemble_tzfs.sh  | A bash script to build the TranZputer Filing System binary images.                                                       |
| assemble_roms.sh  | A bash script to build all the standard MZ80A ROMS, such as the SA-1510 monitor ROM needed by TZFS.                      |
| flashmmcfg        | A binary program to generate the decoding map file for the tranZPUter SW FlashRAM decoder.                               |
| glass-0.5.1.jar   | A bug fixed version of Glass release 0.5. 0.5 refused to fill to 0xFFFF leaving 1 byte missing, hence the bug fix.       |


### CP/M

<div style="text-align: justify">
CPM v2.23 has been ported to the tranZPUter from the RFS project and enhanced to utilise the full 64K memory available as opposed to 48K under RFS. The Custom BIOS makes use of the tranZPUter memory and saves valuable CP/M TPA space
by relocating logic into another memory bank.
</div>

The following files form the CBIOS and CP/M Operating System:

| Module                 | Target Location | Size | Bank | Description                                                                                                                                                             |
|------------------------|-----------------|------|------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| cbios.asm              | 0xF000:0xFFFF   | 4K   | 0    | CPM CBIOS stubs, interrupt service routines (RTC, keyboard etc) and CP/M disk description tables, buffers etc.                                                          |
| cbiosII.asm            | 0x0000:0xCFFF   | 48K  | 1    | CPM CBIOS, I/O Processor Service API, SD Card Controller functions, Floppy Disk Controller functions, Screen and ANSI Terminal functions, Utilities and Audio functions.|
|                        | 0xE800:0xEFFF   | 2K   | 1    | Additional space for CBIOSII, currently not used.                                                                                                                       |
| cpm22.asm              | 0xDA00:0xEFFF   | 5K   | 0    | The CP/M operating system comprised of the CCP (Console Command Processor) and the BDOS (Basic Disk Operating System). These components can be overwritten by applications that dont need CPM services and are reloaded when an application terminates. |
| cpm22-bios.asm         |                 |      | 0    | The Custom Bios is self contained and this stub no longer contains code.                                                                                                |

Additionally there are several shell scripts to aid in the building of the CP/M software, namely:

| Script            |  Description                                                                                                             |
|------------------ | ------------------------------------------------------------------------------------------------------------------------ |
| assemble_cpm.sh   | A shell script to build the CPM binary in the MZF format application for loading via TZFS.                               |
| make_cpmdisks.sh  | A bash script to build a set of CPM disks, created as binary files for use on the FAT32 formatted SD Card. CPC Extended Disk Formats for use in a Floppy disk emulator or copying to physical medium are also created. |
| glass-0.5.1.jar   | A bug fixed version of Glass release 0.5. 0.5 refused to fill to 0xFFFF leaving 1 byte missing, hence the bug fix.       |

Please refer to the [CP/M](/sharpmz-upgrades-cpm/) section for more details, 

--------------------------------------------------------------------------------------------------------

### TZFS Monitor

<div style="text-align: justify">
On power up of the Sharp MZ-700, a command line interface called the monitor is presented to the user to enable basic actions such as bootstrapping a tape or manual execution of preloaded software. The TZFS monitor is an extension
to the basic monitor and once the tranZPUter SW card has been inserted into the Z80 socket on the mainboard, entering the following command at the monitor prompt '*' will start TZFS:
</div>

``
JE800<cr>
``

It is possible to automate the startup of the computer directly into TZFS. To do this create an empty file in the root directory of the SD card called:

``
'TZFSBOOT.FLG'
``

<div style="text-align: justify">
On startup of the K64F processor, it will boot zOS and then if zOS detects this file it will perform the necessary tasks to ensure TZFS is automatically started on the Sharp MZ-700.
<br><br>
  
Once TZFS has booted, the typical 1Z-013A monitor signon banner will appear and be appended with "+ TZFS" postfix if all works well. The usual '*' prompt appears and you can then issue any of the original 1Z-013A commands along with a set of enhanced
commands, some of which were seen on the MZ80A/ MZ700/ MZ800 range and others are custom. The full set of commands are listed in the table below:
<br><br>
</div>


| Command        | Parameters                                                  | Description                                                                        |
|---------       |-------------------------------------------------------------|------------------------------------------------------------------------------------|
| 4              | n/a                                                         | Switch to 40 Character mode\.                                                      |
| 8              | n/a                                                         | Switch to 80 Character mode\.                                                      |
| 40A            | n/a                                                         | Switch to Sharp MZ-80A 40 column BIOS and mode\.                                   |
| 80A            | n/a                                                         | Switch to Sharp MZ-80A 80 column BIOS and mode\.                                   |
| <s>80B</s>     | <s>n/a</s>                                                  | <s>Switch to Sharp MZ-80B compatible mode.</s>                                     |
| 700            | n/a                                                         | Switch to Sharp MZ-700 40 column BIOS and mode\.                                   |
| 7008           | n/a                                                         | Switch to Sharp MZ-700 80 column BIOS and mode\.                                   |
| B              | n/a                                                         | Enable/Disable key entry beep\.                                                    |
| BASIC          | n/a                                                         | Locates the first BASIC interpreter on the SD card, loads and runs it\.            |
| C              | \[\<8 bit value\>\]                                         | Initialise memory from 0x1200 to Top of RAM with 0x00 or provided value\.          |
| CD             | \[\<directory>\]                                            | Switch to given SD card directory \<directory>. If no directory given, reset to \MZF which is the default. After a directory change the DIR command may take a few seconds to output information as the I/O processor caches the directory contents. |
| CPM            | n/a                                                         | Locates CP/M 2.23 on the SD card, loads and runs it.                               |
| D              | \<address>\[\<address2>\]                                   | Dump memory from \<address> to \<address2> (or 20 lines) in hex and ascii. When a screen is full, the output is paused until a key is pressed\. <br><br>Subsequent 'D' commands without an address value continue on from last displayed address\.<br><br> Recognised keys during paging are:<br> 'D' - page down, 'U' - page up, 'X' - exit, all other keys list another screen of data\.|
| DIR            | \<wild card\>                                               | Listing of the files stored on the SD Card\. Each file title is preceded with a hex number which can be used to identify the file\.<br>A wildcard pattern can be given to filter the results, ie. '\*BASIC\*' will list all files with BASIC in their name.<br>Output is in the form HH&#60;seperator&#62;FileName, where &#60;seperator&#62; identifies the type of file:<br>'.' = Machine code, '-' = BASIC MZ80K/C/A, '<-' = BASIC MZ-700/800, '+' = Other. |
| EC             | \<name> or <br>\<file number>                               | Erase file from SD Card\. The SD Card is searched for a file with \<name> or \<file number> and if found, erased\. |
| EX             | n/a                                                         | Exit from TZFS and return machine to original state, I/O processor will be disabled\. |
| F              | \[\<drive number\>\]                                        | Boot from the given Floppy Disk, if no disk number is given, you will be prompted to enter one\. |
| FREQ           | \<frequency in KHz\>                                        | Change the CPU frequency to the value given, 0 for default\. Any frequency is possible, the CPU is the limiting factor. On the installed 20MHz Z80 CPU frequencies upto 24MHz have been verified\. |
| H              | n/a                                                         | Help screen of all these commands\.                                                |
| J              | \<address>                                                  | Jump \(start execution\) at location \<address>\.                                  |
| L \| LT        | [,\<hardware mode\>]                                        | Load file into memory from Tape and execute\. <br><br>\<hardware mode\> specifies the machine cassette system to be used for the command, ie. MZ-80B uses 1800 baud data rate and selecting this machine will read MZ-80B/MZ-2000 cassettes.<br><br>Hardware option flags:<br>K - MZ-80K, C - MZ-80C. 1 = MZ-1200, A - MZ-80A,<br>7 - MZ-700, 8 - MZ-800, B - MZ-80B, 2 - MZ-2000       |
| LTNX           | [,\<hardware mode\>]                                        | Load file into memory from Tape, dont execute\. <br>\<hardware mode\> is described in LT above. |
| LC             | \<name> or <br>\<file number>[,\<target model\>]            | Load file into memory from SD Card\. The SD Card is searched for a file with \<name> or \<file number> and if found, loaded and executed\.<br>Option argument \<target model\> allows setting the target under which the loaded software should run. This argument is intended for machines such as the MZ-800 where the default is to execute as an MZ-800 but specifying this flag you can force the MZ-700 compatibility mode. The flag is also used to target and run software into the original machine memory. Current flags:<br>8 - Force MZ-800 mode on an MZ-800 host.<br>7 - Force MZ-700 mode on an MZ-800 host.<br>O - Load into the host memory and run as original. |
| LCNX           | \<name> or <br>\<file number>[,\<target model\>]            | Load file into memory from SD Card\. The SD Card is searched for a file with \<name> or \<file number> and if found, loaded and not executed\.<br>\<target model\> as per LC above.|
| M              | \<address>                                                  | Edit and change memory locations starting at \<address>\.                          |
| MZ             | [\<machine\>]                                               | Start the Sharp MZ Series hardware emulator. This reconfigures the host MZ-700 to emulate another MZ Series machine, ie. MZ-80B.<br><br> \<machine\> is an optional parameter and specifies the initial startup machine. Without this option the initial machine will be the MZ-80K and can be changed by the OSD menus. The OSD Menu is invoked by pressing SHIFT+BLANK and closed by pressing the same keys again.<br><br>Machine selection:<br>MZ80K, MZ80C, MZ1200, MZ80A, MZ700, MZ800, MZ80B, MZ2000.
| P              | n/a                                                         | Run a test on connected printer\.                                                  |
| R              | n/a                                                         | Run a memory test on main memory\.                                                 |
| S              | \<start addr> \<end addr> \<exec addr>[,\<hardware mode\>]  | Save a block of memory to tape\. You will be prompted to enter the filename\. <br><br>Ie\. S120020001203 - Save starting at 0x1200 up until 0x2000 and set execution address to 0x1203\.<br><br>\<hardware mode\> is described in LT above.   |
| SC             | \<start addr> \<end addr> \<exec addr>[,\<hardware mode\>]  | Save a block of memory to the SD Card as an MZF file\. You will be prompted to enter the filename which will be used as the name the file is created under on the SD card\.<br><br>\<hardware mode\> is described in LT above. |
| SD2T           | \<name> or <br>\<file number>[,\<hardware mode\>]           | Copy a file from SD Card to Tape\. The SD Card is searched for a file with \<name> or \<file number> and if found, copied to a tape in the CMT\.<br><br>\<hardware mode\> is described in LT above. |
| T              | n/a                                                         | Test the 8253 timer\.                                                              |
| T2SD[B]        | [,\<hardware mode\>]                                        | Copy a file from Tape onto the SD Card. A program is loaded from Tape and written to a free position in the SD Card. Adding B onto the end of the command invokes Batch mode where the command enters a loop converting all programs on 1 or more cassettes, only stops if BREAK key is pressed or an error occurs\.<br><br>\<hardware mode\> is described in LT above. |
| T80            | n/a                                                         | Switch to the soft T80 CPU disabling the hard Z80. |
| V              | n/a                                                         | Verify a file just written to tape with the original data stored in memory         |
| VBORDER        | \<colour>                                                   | Set a VGA border colour.<br>0 = Black<br>1 = Green<br>2 = Blue<br>3 = Cyan<br>4 = Red<br>5 = Yellow<br>6 = Magenta<br>7 = White.\. |
| VMODE          | \<video mode>                                               | Select a video mode using the enhanced FPGA video module. The FPGA reconfigures itself to emulate the video hardware of the chosen machine.<br>0 = MZ-80K<br>1 = MZ-80C<br>2 = MZ- 1200<br>3 = MZ-80A<br>4 = MZ-700<br>5 = MZ-800<br>6 = MZ-80B<br>7 = MZ-2000<br>OFF = Revert to original video hardware\. |
| VGA            | \<vga mode>                                                 | Select a VGA compatible output mode.<br>0 = Original Sharp mode<br>1 = 640x480 @ 60Hz<br>2 = 800x600 @ 60Hz\. |
| Z80            | n/a                                                         | switch to the original hard Z80 processor installed on the tranZPUter board. |
| ZPU            | n/a                                                         | switch to the ZPU EVOlution processor in the FPGA and boot into the zOS Operating System. |

For the directory listing commands, 4 columns of output will be shown when in 80 column mode.

#### Tape Commands

It is now possible to read and write all of the Sharp MZ Series tape formats through TZFS commands. This is a very useful feature if you own other MZ machines such as an MZ-80B where cassettes are not in plentiful supply yet the software programs are available as binary MZF images.

<u>Tape Load</u>

To load a tape into the MZ-700 memory, you can use the commands L, LT or LTNX. L and LT are identical, LTNX loads a program but doesnt execute it, rather reporting the load, size and execution address on completion.

To specify the machine of the source tape, use the \<hardware mode\> option after the command (default, if not present, is MZ-700).<br><br>
ie. Loading a tape using the MZ-80B standard 1800 baud system you would issue the command:<br>
&nbsp;&nbsp;&nbsp;&nbsp;L,B

<u>Tape Save</u>

To save a tape from MZ-700 memory onto the MZ-700 CMT unit you can use the S or identical ST commands. You specify, as a continous command, the starting address (the location in MZ-700 memory your program resides), the end address (last address of your program) and the execution address. Currently you cannot specify the attribute which defaults to OBJCD or executable. 
On issuing the command you are prompted for a filename and the MZF header is then created and the program saved to tape.

To specify the machine of the target tape, use the \<hardware mode\> option after the command (default, if not present, is MZ-700).<br><br>
ie. Saving a program at starting address $1200, ending at $3035 and execution address is $1200 generating a tape to be used on an MZ-80B you would issue the command:<br>
&nbsp;&nbsp;&nbsp;&nbsp;ST120030351200,B

<u>Copy SD File To Tape</u>

To copy an MZF file stored on the SD card onto a tape you would use the SD2T command. You would typically use the CD and DIR commands to locate the necessary file and then provide its unique number as an argument to the command.

To specify the machine of the target tape, use the \<hardware mode\> option after the command (default, if not present, is MZ-700).<br>

ie. Assuming you wanted to copy BASIC MZ-1Z001 to tape for an MZ-2000 machine and the file had the SD card id '0C', you would place a tape into the cassette drive, and issue the command:<br>
&nbsp;&nbsp;&nbsp;&nbsp;SD2T0C,2

<u>Copy Tape To SD File</u>

To copy a tape program onto an SD card you would use the T2SD command. You would typically use the CD commands to switch to the desired directory where the image will be stored (maximum file limit of 255 per directory) and execute this command. The command will then search the tape, load the first program found and save it to SD card using the filename of the tape image.

To specify the machine of the target tape, use the \<hardware mode\> option after the command (default, if not present, is MZ-700).<br>

ie. Assuming you wanted to save an MZ-800 based program to SD card, you would load the tape into the drive and issue the command:<br>
&nbsp;&nbsp;&nbsp;&nbsp;T2SD,8<br>
On completion the file details and SD card Id will be reported.

<u>Bulk Copy Entire Tapes To SD</u>

If you have a tape with multiple files stored or multiple tapes and you need to store them on SD, you would use the T2SDB command. This command is identical to the T2SD command above except it enters a loop reading from tape and saving to SD. Pressing BREAK at any time exits the command.

To specify the machine of the target tape, use the \<hardware mode\> option after the command (default, if not present, is MZ-700).<br>

ie. Assuming you wanted to save an entire MZ-800 tape to SD card, you would load the tape into the drive and issue the command:<br>
&nbsp;&nbsp;&nbsp;&nbsp;T2SDB,8<br>
As each file is read and saved the command will output the start, size and exec addresses along with the stored filename.

--------------------------------------------------------------------------------------------------------

### Sharp BASIC SA-5510

<div style="text-align: justify">
During further development of the Rom Filing System I disassembled the SA-5510 BASIC interpreter (which is standard for an MZ-80A) to make it compatible with an SD card under RFS. As this interpreter is compatible with a Sharp MZ-700/800 I decided to port it to TZFS.
<br><br>

The Byte location of the interpreter is critical as some programs are written to expect functions at known locations so disassembly had to be accurate and modifications/enhancements made outside of the main program. Luckily there is a block of self replication within the interpreter 
that isnt needed for TZFS so this area was used for additional functionality.
<br><br>

Unlike RFS where I could embed a drive specification into the LOAD/SAVE command, TZFS is more powerful and thus required seperate commands to specify SD card directories and wildcards. In addition TZFS has several useful features such as CPU clock thus requiring further command additions.
<br><br>

The table below lists the command extensions with a brief description.
</div>

| Command  | Parameter        | Description                                                                                                                                           |
| -------  | ---------        | -----------                                                                                                                                           |
| LOAD     | "[\<filename\>]" | Look for the program "\<filename\>" in the current SD card directory or CMT (cassette). If \<filename\> isnt given, load the next sequential file.<br>You can also use TZFS index designators instead of a filename, ie. LOAD "1E" would load the program stored in location HEX 1E on the SD card. |
| SAVE     | "[\<filename\>]" | Save the program in memory to the current SD card directory or CMT (cassette) under the name "\<filename\>". <br>If \<filename\> isnt given, save with the name 'DEFAULT\<number\>' where \<number\> is a sequential number starting from 0. |
| DIR      | "[\<wildcard\>]" | List out the current SD card directory in TZFS format applying any given \<wildcard\> filter, ie. DIR M* to list all programs beginning with M. |
| CD       | [\<path\>]       | Change the active SD directory to \<path\>. If no \<path\> given change to root directory. If path = C, ie. CDC then switch to CMT (cassette), all other arguments switch to SD card. |
| FREQ     | [\<freq\>]       | Change CPU to the give frequency \<freq\>. \<freq\> is specified in KHz, ie. 10000 = 10MHz. If no \<freq\> given revert to original mainboard frequency. |


<font size="2">
<div style="text-align: left">
To LOAD or SAVE to the builtin cassette drive, use the commands:<br>
&nbsp;&nbsp;&nbsp;&nbsp;CDC<br>
&nbsp;&nbsp;&nbsp;&nbsp;LOAD<br>
or
<br>
&nbsp;&nbsp;&nbsp;&nbsp;CDC<br>
&nbsp;&nbsp;&nbsp;&nbsp;SAVE "EXAMPLE"
<br>
</div>
</font>

The new version of BASIC SA-5510 is named "BASIC SA-5510-TZ".

NB: I havent yet fully implemented the random file read/write BASIC operations as I dont fully understand the logic. Once I get a suitable program I can analyse I will adapt TZFS so that it works according to the CMT specification.

--------------------------------------------------------------------------------------------------------

### Microsoft BASIC

<div style="text-align: justify">
The Sharp machines have several versions of BASIC available to use, on cassette or floppy, although they have limited compatibility with each other (ie. MZ80A SA5510 differs to the MZ-700 S-BASIC). Each machine can have
several variants, ie. SA-6510 for disk drive use or third party versions such as OM-500. Most of these BASIC interpreters run well under TZFS so long as they were intended for use on a Sharp MZ80K/A/700 albeit they are limited to CMT (cassette) or Floppy storage only.
<br><br>

One drawback of the existing BASIC interpreters is availability of source code to update them with TZFS extensions. Unless you disassemble the binary or edit the binary directly adding TZFS commands is not possible. I came across this same issue during the
development of RFS and needing a version of BASIC to aid in the more complicated tranZPUter hardware debugging I settled on using a version of Microsoft Basic where the source code was freely available, ie. the NASCOM v4.7b version of BASIC from Microsoft.
This version of Basic has quite a large following in the retro world and consequently a plethora of existing BASIC programs. It is also fairly simple to extend with additional commands.
</div>

There are two versions of the NASCOM 4.7b source code available on the internet, either the original or a version stripped of several hardware dependent commands such as LOAD /SAVE /SCREEN but tweaked to add binary/hex variables by [Grant Searle](http://searle.wales/) for his 
[multicomp project](http://searle.x10host.com/Multicomp/index.html). I took both versions to make a third, writing and expanding on available commands including the missing tape commands.

<div style="text-align: justify">
As the projects developed, Microsoft BASIC needed to support a variety of configurations, 5 under RFS and 4 under TZFS. Not counting the RFS versions, on the tranZPUter running TZFS the following are available:
</div>

  * MS-BASIC(MZ-80A) - Original 48K hardware which can be booted from cassette.
  * MS-BASIC(MZ-700) - Original 64K hardware which can be booted from cassette.
  * MS-BASIC(TZFS40) - TZFS upgrade with no video upgrade hardware installed.
  * MS-BASIC(TZFS80) - TZFS upgrade with a video module FPGA upgrade installed offering 80 column display.

Each appears on the TZFS drive and should be used according to hardware and need.  The original [NASCOM Basic Manual](../docs/Nascom_Basic_Manual.pdf) should be consulted for the standard set of commands and functions. The table below outlines additions which I have added to better
suite the MZ-80A / RFS hardware.


| Command  | Parameters                          | Description                                                                        |
|--------- |-------------------------------------|------------------------------------------------------------------------------------|
| CLOAD    | "\<filename\>"                      | Load a cassette image from SD card, ie. tokenised BASIC program\.                  |
| CSAVE    | "\<filename\>"                      | Save current BASIC program to SD card in tokenised cassette image format\.         |
| LOAD     | "\<filename\>"                      | Load a standard ASCII text BASIC program from SD card\.                            |
| SAVE     | "\<filename\>"                      | Save current BASIC program to SD card in ASCII text format\.                       |
| DIR      | \<wildcard\>                        | List out the current directory using any given wildcard\.                          |
| CD       | \<FAT32 PATH\>                      | Change the working directory to the path given. All commands will now use this directory\. On startup, CLOAD/CSAVE default to 0:\CAS and LOAD/SAVE default to 0:\BAS, this command unifies them to use the given directory\. To return to using the defaults, type CD without a path\. |
| FREQ     | \<frequency in KHz\>                | Set the CPU to the given KHz frequency, use 0 to switch to the default mainboard frequency\. Tested ranges 100KHz to 24MHz, dependent on Z80 in use. Will overclock if Z80 is capable\. |
| ANSITERM | 0 = Off, 1 = On                     | Disable or enable (default) the inbuilt Ansi Terminal processor which recognises ANSI escape sequences and converts them into screen actions. This allows for use of portable BASIC programs which dont depend on specialised screen commands. FYI: The Star Trek V2 BASIC program uses ANSI escape sequences\. |


##### NASCOM Cassette Image Converter Tool

<div style="text-align: justify">
NASCOM BASIC programs can be found on the internet as Cassette image files. These files contain all the tape formatting data with embedded tokenised BASIC code. In order to be able to use these files I wrote a converter program which strips out the tape formatting data and reconstructs the BASIC code. In
addition, as this version of BASIC has been enhanced to support new commands, the token values have changed and so this program will automatically update the token value during conversion.
</div>

The converter is designed to run on the command line and it's synopsis is:
    
```bash
NASCONV v1.0

Required:-
  -i | --image <file>      Image file to be converted.
  -o | --output <file>     Target destination file for converted data.

Options:-
  -l | --loadaddr <addr>   MZ80A basic start address. NASCOM address is used to set correct MZ80A address.
  -n | --nasaddr <addr>    Original NASCOM basic start address.
  -h | --help              This help test.
  -v | --verbose           Output more messages.

Examples:
  nasconv --image 3dnc.cas --output 3dnc.bas --nasaddr 0x10fa --loadaddr 0x4341    Convert the file 3dnc.cas from NASCOM cassette format.
```


--------------------------------------------------------------------------------------------------------

## Design Detail

<div style="text-align: justify">
This section provides internal design information for understanding how the tranZPUter SW-700 functions and its interactions with the Host (the original computer).
</div>



### K64F Z80 Host API

<div style="text-align: justify">
The API is based on a common block of RAM within the 64K memory space of the Z80 through which interprocessor communications take place. On the K64F this is declared
in C as a structure and on the Z80 as an assembler reference to memory variables.
<br>
</div>

```c
// Structure to contain inter CPU communications memory for command service processing and results.
// Typically the z80 places a command into the structure in it's memory space and asserts an I/O request,
// the K64F detects the request and reads the lower portion of the struct from z80 memory space, 
// determines the command and then either reads the remainder or writes to the remainder. This struct
// exists in both the z80 and K64F domains and data is sync'd between them as needed.
//
typedef struct __attribute__((__packed__)) {
    uint8_t                          cmd;                                // Command request.
    uint8_t                          result;                             // Result code. 0xFE - set by Z80, command available, 0xFE - set by K64F, command ack and processing. 0x00-0xF0 = cmd complete and result of processing.
    union {
        uint8_t                      dirSector;                          // Virtual directory sector number.
        uint8_t                      fileSector;                         // Sector within open file to read/write.
        uint8_t                      vDriveNo;                           // Virtual or physical SD card drive number.
    };
    union {
        struct {
            uint16_t                 trackNo;                            // For virtual drives with track and sector this is the track number
            uint16_t                 sectorNo;                           // For virtual drives with track and sector this is the sector number. NB For LBA access, this is 32bit and overwrites fileNo/fileType which arent used during raw SD access.
        };
        uint32_t                     sectorLBA;                          // For LBA access, this is 32bit and used during raw SD access.
        struct {
            uint8_t                  memTarget;                          // Target memory for operation, 0 = tranZPUter, 1 = mainboard.
            uint8_t                  spare1;                             // Unused variable.
            uint16_t                 spare2;                             // Unused variable.
        };
    };
    uint8_t                          fileNo;                             // File number of a file within the last directory listing to open/update.
    uint8_t                          fileType;                           // Type of file being processed.
    union {
        uint16_t                     loadAddr;                           // Load address for ROM/File images which need to be dynamic.
        uint16_t                     saveAddr;                           // Save address for ROM/File images which need to be dynamic.
        uint16_t                     cpuFreq;                            // CPU Frequency in KHz - used for setting of the alternate CPU clock frequency.
    };
    union {
        uint16_t                     loadSize;                           // Size for ROM/File to be loaded.
        uint16_t                     saveSize;                           // Size for ROM/File to be saved.
    };
    uint8_t                          directory[TZSVC_DIRNAME_SIZE];      // Directory in which to look for a file. If no directory is given default to MZF.
    uint8_t                          filename[TZSVC_FILENAME_SIZE];      // File to open or create.
    uint8_t                          wildcard[TZSVC_WILDCARD_SIZE];      // A basic wildcard pattern match filter to be applied to a directory search.
    uint8_t                          sector[TZSVC_SECTOR_SIZE];          // Sector buffer generally for disk read/write.
} t_svcControl;
```

<div style="text-align: justify"><br>
Communications are all instigated by the Z80. When it needs a service, it will write a command into the svcControl.cmd field and set the svcControl.result field to 
REQUEST. The Z80 then writes to an output port (configurable but generally 0x68) which in turn sends an interrupt to the K64F. The K64F reads the command and sets the
svcControl.result to PROCESSING - the Z80 waits for this handshake, if it doesnt see it after a timeout period it will resend the command. The Z80 then waits for a valid
result, again if it doesnt get a result in a reasonable time period it retries the sequence and after a number of attempts gives up with an error.
<br><br>

Once the K64F has processed the command (ie. read directory) and stored any necessary data into the structure, it sets the svcControl.result to a valid result (success,
fail or error code) to complete the transaction.
</div>

**API Command List**

| Command                   | Cmd#     | Description                                                   |
| ------------------------- | -------- | ------------------------------------------------------------- |
| TZSVC_CMD_READDIR         |   0x01   | Open a directory and return the first block of entries.       |
| TZSVC_CMD_NEXTDIR         |   0x02   | Return the next block in an open directory.                   |
| TZSVC_CMD_READFILE        |   0x03   | Open a file and return the first block.                       |
| TZSVC_CMD_NEXTREADFILE    |   0x04   | Return the next block in an open file.                        |
| TZSVC_CMD_WRITEFILE       |   0x05   | Create a file and save the first block.                       |
| TZSVC_CMD_NEXTWRITEFILE   |   0x06   | Write the next block to the open file.                        |
| TZSVC_CMD_CLOSE           |   0x07   | Close any open file or directory.                             |
| TZSVC_CMD_LOADFILE        |   0x08   | Load a file directly into tranZPUter memory.                  |
| TZSVC_CMD_SAVEFILE        |   0x09   | Save a file directly from tranZPUter memory.                  |
| TZSVC_CMD_ERASEFILE       |   0x0a   | Erase a file on the SD card.                                  |
| TZSVC_CMD_CHANGEDIR       |   0x0b   | Change active directory on the SD card.                       |
| TZSVC_CMD_LOAD40ABIOS     |   0x20   | Request 40 column version of the SA1510 BIOS to be loaded, change frequency to match the Sharp MZ-80A.    |
| TZSVC_CMD_LOAD80ABIOS     |   0x21   | Request 80 column version of the SA1510 BIOS to be loaded, change frequency to match the Sharp MZ-80A.    |
| TZSVC_CMD_LOAD700BIOS40   |   0x22   | Request 40 column version of the 1Z-013A MZ-700 BIOS to be loaded, change frequency to match the Sharp MZ-700 and action memory page commands. |
| TZSVC_CMD_LOAD700BIOS80   |   0x23   | Request 80 column version of the 1Z-013A MZ-700 BIOS to be loaded, change frequency to match the Sharp MZ-700 and action memory page commands. |
| TZSVC_CMD_LOAD80BIPL      |   0x24   | Request the loading of the MZ-80B IPL, switch frequency and enable Sharp MZ-80B compatible mode. |
| TZSVC_CMD_LOAD800BIOS     |   0x25   | Service command requesting that the MZ800 9Z-504M BIOS is loaded. |
| TZSVC_CMD_LOAD2000IPL     |   0x26   | Service command requesting the MZ-2000 IPL is loaded. |
| TZSVC_CMD_LOADTZFS        |   0x2F   | Service command requesting the loading of TZFS. This service is for machines which normally dont have a monitor BIOS. ie. MZ-80B/MZ-2000 and manually request TZFS. |
| TZSVC_CMD_LOADBDOS        |   0x30   | Reload CPM BDOS+CCP.                                          |
| TZSVC_CMD_ADDSDDRIVE      |   0x31   | Attach a CPM disk to a drive number.                          |
| TZSVC_CMD_READSDDRIVE     |   0x32   | Read an attached SD file as a CPM disk drive.                 |
| TZSVC_CMD_WRITESDDRIVE    |   0x33   | Write to a CPM disk drive which is an attached SD file.       |
| TZSVC_CMD_CPU_BASEFREQ    |   0x40   | Set the tranZPUter to use the mainboard frequency for the Z80. |
| TZSVC_CMD_CPU_ALTFREQ     |   0x41   | Switch the Z80 to use the K64F generated clock, ie. alternative frequency. |
| TZSVC_CMD_CPU_CHGFREQ     |   0x42   | Change the Z80 frequency generated by the K64F to the Hertz value given in svcControl.cpuFreq, the Z80 will be clocked at the nearest timer resolution of this frequency. |
| TZSVC_CMD_CPU_SETZ80      |   0x50   | Switch to the external Z80 hard cpu.                          |
| TZSVC_CMD_CPU_SETT80      |   0x51   | Switch to the internal T80 soft cpu.                          |
| TZSVC_CMD_CPU_SETZPUEVO   |   0x52   | Switch to the internal ZPU Evolution cpu.                     |
| TZSVC_CMD_EMU_SETMZ80K    |   0x53   | Service command to switch to the internal Sharp MZ Series Emulation of the MZ80K. |
| TZSVC_CMD_EMU_SETMZ80C    |   0x54   | ""                             ""                       ""                 MZ80C. |
| TZSVC_CMD_EMU_SETMZ1200   |   0x55   | ""                             ""                       ""                 MZ1200. |
| TZSVC_CMD_EMU_SETMZ80A    |   0x56   | ""                             ""                       ""                 MZ80A. |
| TZSVC_CMD_EMU_SETMZ700    |   0x57   | ""                             ""                       ""                 MZ700. |
| TZSVC_CMD_EMU_SETMZ800    |   0x58   | ""                             ""                       ""                 MZ800. |
| TZSVC_CMD_EMU_SETMZ80B    |   0x59   | ""                             ""                       ""                 MZ80B. |
| TZSVC_CMD_EMU_SETMZ2000   |   0x5A   | ""                             ""                       ""                 MZ2000. |
| TZSVC_CMD_SD_DISKINIT     |   0x60   | Initialise and provide raw access to the underlying SD card.  |
| TZSVC_CMD_SD_READSECTOR   |   0x61   | Provide raw read access to the underlying SD card.            |
| TZSVC_CMD_SD_WRITESECTOR  |   0x62   | Provide raw write access to the underlying SD card.           |
| TZSVC_CMD_EXIT            |   0x7F   | Terminate TZFS and restart the machine in original mode.      |

**API Result List**

| Command                   | Result#  | Description                                                   |
| ------------------------- | -------- | ------------------------------------------------------------- |
| TZSVC_STATUS_OK           |   0x00   | The K64F processing completed successfully.                   |
| TZSVC_STATUS_FILE_ERROR   |   0x01   | A file or directory error.                                    |
| TZSVC_STATUS_BAD_CMD      |   0x02   | Bad service command was requested.                            |
| TZSVC_STATUS_BAD_REQ      |   0x03   | Bad request was made, the service status request flag was not set. |
| TZSVC_STATUS_REQUEST      |   0xFE   | Z80 has posted a request.                                     |
| TZSVC_STATUS_PROCESSING   |   0xFF   | K64F is processing a command.                                 |

--------------------------------------------------------------------------------------------------------

### Z80 Memory Modes

<div style="text-align: justify">
One of the features of the tranZPUter SW-700 hardware design is the ability to create memory maps freely within the 512 macro cell CPLD. Any conceivable memory map within Z80 address space (or any soft-cpu address space upto 18 bits wide)
utilising the 512K Static RAM, 64K mainboard RAM, Video RAM, I/O can be constructed using a boolean equation and then assigned to a Memory Mode, The memory mode is then selected by Z80 software as required, ie. this ability is put to good
use in order to realise TZFS, CP/M and the compatible modes of the Sharp MZ-700 and MZ-80B.
<br><br>

The basis of the memory modes came from version 1 of the tranZPUter SW project where the decoder was based on a Flash RAM. All foreseen memory models required at that time, such as MZ-700, CP/M etc where devised. These modes have been enhanced in later designs
within the CPLD to cater for new features such as the Video Module and no doubt will be further enhanced in the future.
<br><br>

Modes which have been defined are in the table below leaving a few available slots for future expansion.
</div>

| Mode | Target      | Range         | Block&nbsp;&nbsp; | Function     | DRAM Refresh | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
|------|-------------|---------------|-------|----------------|--------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| 0    | Original    |   0000:0FFF     | Main  | MROM           | Yes          | Default, normal host (ie. Sharp MZ80A/MZ-700) operating mode, all memory and IO (except tranZPUter controlled I/O block) are on the mainboard                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
|      |             |   1000:CFFF     | Main  | D-RAM          |              |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
|      |             |   D000:D7FF     | Main  | VRAM           |              |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
|      |             |   D800:DFFF     | Main  | ARAM           |              |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
|      |             |   E000:E7FF     | Main  | MM I/O         |              |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
|      |             |   E800:EFFF     | Main  | User ROM       |              |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
|      |             |   F000:FFFF     | Main  | FDC ROM        |              |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| 1    | Orig+ UROM  |   0000:0FFF     | Main  | MROM           | Yes          | As 0 except User ROM is mapped to tranZPUter RAM and used for loadable   BIOS images.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
|      |             |   1000:CFFF     | Main  | D-RAM          |              |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
|      |             |   D000:D7FF     | Main  | VRAM           |              |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
|      |             |   D800:DFFF     | Main  | ARAM           |              |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
|      |             |   E000:E7FF     | Main  | MM I/O         |              |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
|      |             |   E800:EFFF     | RAM 0 | User ROM       |              |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
|      |             |   F000:FFFF     | Main  | FDC ROM        |              |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| 2    | TZFS        |   0000:0FFF     | RAM 0 | MROM           | No           | Boot mode for TZFS or any other   software requiring use of the tranZPUter RAM. User ROM appears as ROM to the   Monitor so it will call the entry point at 0xE800 as part of it's normal   startup procedure. The software stored at 0xE800 can switch out the mainboard   and run in tranZPUter RAM as required.      Two small holes at F3FE and F7FE exist for the Floppy disk controller   (which have to be 2 bytes wude), these locations need to be on the   mainboard. The floppy disk controller uses them as part of its data   read/write as the Z80 isnt fast enough to poll the FDC. |
|      |             |   1000:CFFF     | RAM 0 | Main RAM       |              |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
|      |             |   D000:D7FF     | Main  | VRAM           |              |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
|      |             |   D800:DFFF     | Main  | ARAM           |              |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
|      |             |   E000:E7FF     | RAM 0 | MM I/O         |              |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
|      |             |   E800:EFFF     | RAM 0 | User ROM       |              |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
|      |             |   F000:FFFF     | RAM 0 | FDC ROM        |              |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| 3    | TZFS        |   0000:0FFF     | RAM 0 | MROM           | No           | Page mode for TZFS, all RAM in   tranZPUter Block 0 except F000:FFFF which is in Block 1, this is page bank2   of TZFS.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
|      |             |   1000:CFFF     | RAM 0 | Main RAM       |              |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
|      |             |   D000:D7FF     | RAM 0 | VRAM           |              |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
|      |             |   D800:DFFF     | RAM 0 | ARAM           |              |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
|      |             |   E000:E7FF     | RAM 0 | MM I/O         |              |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
|      |             |   E800:EFFF     | RAM 0 | User ROM       |              |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
|      |             |   F000:FFFF     | RAM 1 | FDC ROM        |              |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| 4    | TZFS        |   0000:0FFF     | RAM 0 | MROM           | No           | As mode 3 but F000:FFFF is in   Block 2, this is page bank3 of TZFS.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
|      |             |   1000:CFFF     | RAM 0 | Main RAM       |              |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
|      |             |   D000:D7FF     | RAM 0 | VRAM           |              |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
|      |             |   D800:DFFF     | RAM 0 | ARAM           |              |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
|      |             |   E000:E7FF     | RAM 0 | MM I/O         |              |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
|      |             |   E800:EFFF     | RAM 0 | User ROM       |              |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
|      |             |   F000:FFFF     | RAM 2 | FDC ROM        |              |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| 5    | TZFS        |   0000:0FFF     | RAM 0 | MROM           | No           | As mode 3 but F000:FFFF is in   Block 3, this is page bank4 of TZFS.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
|      |             |   1000:CFFF     | RAM 0 | Main RAM       |              |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
|      |             |   D000:D7FF     | RAM 0 | VRAM           |              |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
|      |             |   D800:DFFF     | RAM 0 | ARAM           |              |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
|      |             |   E000:E7FF     | RAM 0 | MM I/O         |              |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
|      |             |   E800:EFFF     | RAM 0 | User ROM       |              |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
|      |             |   F000:FFFF     | RAM 3 | FDC ROM        |              |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| 6    | CP/M        |   0000:FFFF     | RAM 4 | Main RAM       | No           | CP/M, all memory on the   tranZPUter board.       Special case for F3C0:F3FF & F7C0:F7FF (floppy disk paging vectors)   which resides on the mainboard.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| 7    | CP/M        |   0000:0100     | RAM 4 | CP/M Vectors   | No           | CP/M main CBIOS area, 48K + 2K   available for the CBIOS and direct access to mainboard hardware. F000:FFFF   remains in bank 4 and used as the gateway between this memory mode and mode   6.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
|      |             |   0100:CFFF     | RAM 5 | Main RAM       |              |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
|      |             |   D000:D7FF     | Main  | VRAM           |              |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
|      |             |   D800:DFFF     | Main  | ARAM           |              |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
|      |             |   E000:E7FF     | Main  | MM I/O         |              |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
|      |             |   E800:EFFF     | RAM 5 | User ROM       |              |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
|      |             |   F000:FFFF     | RAM 4 | FDC ROM        |              |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| 8    | Orig+ Emu   |   0000:0FFF     | Main  | MROM           | Yes          | Original mode but with the main RAM in the tranZPUter bank 0. This mode is used to bootstrap programs such as MZ-700 programs which bank change on startup and expect the loaded program to be within the main memory which is within a tranZPUter RAM bank.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
|      |             |   1000:CFFF     | RAM 0 | Main RAM       |              |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
|      |             |   D000:D7FF     | Main  | VRAM           |              |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
|      |             |   D800:DFFF     | Main  | ARAM           |              |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
|      |             |   E000:E7FF     | Main  | MM I/O         |              |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
|      |             |   E800:EFFF     | Main  | User ROM       |              |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
|      |             |   F000:FFFF     | Main  | FDC ROM        |              |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| 10   | MZ-700      |   0000:0FFF     | RAM 6 | Main RAM       | No           | MZ-700 mode (OUT $E0) - Monitor   RAM replaced with Main RAM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
|      |             |   1000:CFFF     | RAM 0 | Main RAM       |              |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
|      |             |   D000:D7FF     | Main  | VRAM           |              |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
|      |             |   D800:DFFF     | Main  | ARAM           |              |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
|      |             |   E000:E7FF     | Main  | MM I/O         |              |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
|      |             |   E800:EFFF     | Main  | User ROM       |              |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
|      |             |   F000:FFFF     | Main  | FDC ROM        |              |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| 11   | MZ-700      |   0000:0FFF     | RAM 0 | MROM           | No           | MZ-700 mode (OUT $E0 + $E1) -   I/O and Video block replaced with Main RAM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
|      |             |   1000:CFFF     | RAM 0 | Main RAM       |              |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
|      |             |   D000:D7FF     | RAM 6 | VRAM           |              |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
|      |             |   D800:DFFF     | RAM 6 | ARAM           |              |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
|      |             |   E000:E7FF     | RAM 6 | MM I/O         |              |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
|      |             |   E800:EFFF     | RAM 6 | User ROM       |              |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
|      |             |   F000:FFFF     | RAM 6 | FDC ROM        |              |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| 12   | MZ-700      |   0000:0FFF     | RAM 6 | Main RAM       | No           | MZ-700 mode (OUT $E1 + $E2) -   Monitor RAM replaced with RAM and I/O and Video block replaced with Main RAM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
|      |             |   1000:CFFF     | RAM 0 | Main RAM       |              |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
|      |             |   D000:D7FF     | RAM 6 | VRAM           |              |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
|      |             |   D800:DFFF     | RAM 6 | ARAM           |              |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
|      |             |   E000:E7FF     | RAM 6 | MM I/O         |              |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
|      |             |   E800:EFFF     | RAM 6 | User ROM       |              |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
|      |             |   F000:FFFF     | RAM 6 | FDC ROM        |              |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| 13   | MZ-700      |   0000:0FFF     | RAM 0 | MROM           | No           | MZ-700 mode (OUT $E5) - Upper   memory locked out, Monitor ROM paged in.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
|      |             |   1000:CFFF     | RAM 0 | Main RAM       |              |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
|      |             |   D000:FFFF     | n/a   | Undefined      |              |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| 14   | MZ-700      |   0000:0FFF     | RAM 6 | Main RAM       | No           | MZ-700 mode (OUT $E6) - Monitor   RAM replaced with RAM and Upper memory locked out.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
|      |             |   1000:CFFF     | RAM 0 | Main RAM       |              |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
|      |             |   D000:FFFF     | n/a   | Undefined      |              |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| 15   | MZ-800/MZ-700 |               |       |                |              | See table below. Memory mode is as per the MZ-800. |
| 16   | MZ2000      |   0000:7FFF     | RAM 0 | IPL ROM        | No           | MZ2000 hardware mode, configuration set according to the MZ2000 runtime configuration registers. |
|      |             |   8000:FFFF     | RAM 6 | Lower 32K RAM  |              | During IPL mode, lower 32K RAM mapped to upper 32K address. |
|      |             |   0000:FFFF     | RAM 6 | Main RAM       |              | During RUN mode, full 64K RAM mapped into Z80 address space. |
|      |             |   D000:DFFF     | Main  | VRAM           |              | Video RAM mapped into Z80 address space when PIO Port A Bit 7 set, Bit 6 clear. |
|      |             |   C000:FFFF     | Main  | GRAM           |              | Graphics RAM mapped into Z80 address space when PIO Port A Bit 7 set, Bit 6 set. |
| 21   | K64F Access | 000000:FFFFFF   | n/a   | FPGA Resources | No           | Access the FPGA memory by passing through the full 24bit Z80 address, typically from the K64F.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| 22   | FPGA Access |   0000:FFFF     | n/a   | Host Resources | Yes          | Access to the host mainboard 64K address space only.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
| 23   | K64F Access | 000000:FFFFFF   | RAM   | Main RAM       | No           | Access all memory and IO on the tranZPUter board with the K64F addressing the full 512K RAM.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| 24   | K64F Access |   0000:FFFF     | RAM 0 | Main RAM       | Yes/No       | All memory and IO are on the tranZPUter board, 64K block 0 selected.   Mainboard DRAM is refreshed by the tranZPUter library when using this mode.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| 25   | K64F Access |   0000:FFFF     | RAM 1 | Main RAM       | Yes/No       | All memory and IO are on the tranZPUter board, 64K block 1 selected.   Mainboard DRAM is refreshed by the tranZPUter library when using this mode.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| 26   | K64F Access |   0000:FFFF     | RAM 2 | Main RAM       | Yes/No       | All memory and IO are on the tranZPUter board, 64K block 2 selected.   Mainboard DRAM is refreshed by the tranZPUter library when using this mode.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| 27   | K64F Access |   0000:FFFF     | RAM 3 | Main RAM       | Yes/No       | All memory and IO are on the tranZPUter board, 64K block 3 selected.   Mainboard DRAM is refreshed by the tranZPUter library when using this mode.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| 28   | K64F Access |   0000:FFFF     | RAM 4 | Main RAM       | Yes/No       | All memory and IO are on the tranZPUter board, 64K block 4 selected.   Mainboard DRAM is refreshed by the tranZPUter library when using this mode.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| 29   | K64F Access |   0000:FFFF     | RAM 5 | Main RAM       | Yes/No       | All memory and IO are on the tranZPUter board, 64K block 5 selected.   Mainboard DRAM is refreshed by the tranZPUter library when using this mode.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| 30   | K64F Access |   0000:FFFF     | RAM 6 | Main RAM       | Yes/No       | All memory and IO are on the tranZPUter board, 64K block 6 selected.   Mainboard DRAM is refreshed by the tranZPUter library when using this mode.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| 31   | K64F Access |   0000:FFFF     | RAM 7 | Main RAM       | Yes/No       | All memory and IO are on the tranZPUter board, 64K block 7 selected.   Mainboard DRAM is refreshed by the tranZPUter library when using this mode.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |

<font size="2">
<div style="text-align: left">
Key:<br>
    MROM       = Monitor ROM, the original boot firmware ie. SA-1510 <br>
    D-RAM      = Dynamic RAM on the mainboard. <br>
    VRAM       = Video RAM on the mainboard. <br>
    ARAM       = Colour Attribute RAM on the mainboard. <br>
    MM I/O     = Memory Mapped I/O controllers on the mainboard. <br>
    RAM 0 .. 7 = 64K RAM Block number within the 512K Static RAM chip. <br>
    Main       = Host computer mainboard, ie the Sharp MZ-80A mainboard. <br>
</div>
</font>

##### MZ700/MZ800 Memory Mode

|            MZ-700     |||||                                            | MZ-800                                                                        |
| Register   |0000:0FFF|1000:1FFF|1000:CFFF|C000:CFFF|D000:FFFF          |0000:7FFF|1000:1FFF|2000:7FFF|8000:BFFF|C000:CFFF|C000:DFFF|E000:FFFF          |
| ---------- |---------|---------|---------|---------|---------          |---------|---------|---------|---------|---------|---------|---------          |
| OUT 0xE0   |DRAM     |         |         |         |                   |DRAM     |         |         |         |         |         |                   |
| OUT 0xE1   |         |         |         |         |DRAM               |         |         |         |         |         |         |DRAM               |
| OUT 0xE2   |MONITOR  |         |         |         |                   |MONITOR  |         |         |         |         |         |                   |
| OUT 0xE3   |         |         |         |         |Memory Mapped I/O  |         |         |         |         |         |         |Upper MONITOR ROM  |           
| OUT 0xE4   |MONITOR  |         |DRAM     |         |Memory Mapped I/O  |MONITOR  |CGROM    |DRAM     |VRAM     |         |DRAM     |Upper MONITOR ROM  |
| OUT 0xE5   |         |         |         |         |Inhibit            |         |         |         |         |         |         |Inhibit            |
| OUT 0xE6   |         |         |         |         |<return>           |         |         |         |         |         |         |<return>           |
| IN  0xE0   |         |CGROM*   |         |VRAM*    |                   |         |CGROM    |         |VRAM     |         |         |                   |
| IN  0xE1   |         |DRAM     |         |DRAM     |                   |         |<return> |         |DRAM     |         |         |                   |                                                       

<font size="2">
<div style="text-align: left">
Key:<br>
   &lt;return&gt; = Return to the state prior to the complimentary command being invoked.<br>
   &#42; = MZ-800 host only.<br>
</div>
</font>


--------------------------------------------------------------------------------------------------------

### Z80 CPU Frequency Switching

<div style="text-align: justify">
In order to make the tranZPUter SW-700 compatible with other machines it is necessary to clock the CPU at the speed of that machine. It is also desirable to clock the CPU as fast as possible when using software such
as CP/M for maximum performance.
<br><br>

One of the main issues with frequency switching is that the underlying host cannot have its frequency changed, the host is generally generating the clock and it's circuits have been designed to operate within it's clock
tolerances. The tranZPUter SW-700 overcomes this limitation as described below.
<br><br>

To fulfil the requirement to have a switchable Z80 CPU frequency a positive edge triggered frequency switch has been implemented which takes the host frequency as one input and a square wave generator from the K64F as its second input.
The switching mechanism is tied to the bus control logic and so any access to the host will see the frequency of the CPU being changed to that of the host which ensures continued reliable operation. Under startup conditions, the Z80 is
always clocked by the host clock to ensure original specifications of the machine are met.
<br><br>

A second frequency can be selected if the K64F is present as it has the ability using its onboard timers to generate a programmable square wave output. The K64F sets the frequency of this second clock source
and the Z80 can select it via an I/O OUT command. This gives the software running on the Z80 the opportunity to change it's own frequency, albeit to a fixed set one. An extension to the K64F Host API allows the Z80 to make a request
of the K64F to set the Z80 CPU frequency to any possible value, this is useful in TZFS or CP/M so a user can select their own frequency.
<br><br>

Current testing on a CMOS Z84C0020 20MHz CPU has the following observations:
</div>

   * tranZPUter reliable in the range 1Hz to 24MHz for all functionality.
   * When the mainboard is accessed the frequency slows to 3.54MHz (ie. the system clock) and returns to the higher frequency after the mainboard access has completed.

<div style="text-align: justify"><br>
It is also possible to slow down the CPU for training or debugging purposes albeit access to the host circuitry will always run at the host clock frequency,
<br><br>

On an application running under the Z80, the following table outlines the I/O ports to which it must read/write in order to switch frequencies.
<br></div>

##### <u>Z80 CPU Frequency Switching Ports</u>

| Port    | Dir  | Function                     |
| ----    | ---  | --------                     |
| 0x62    |  W   | Switch Z80 CPU frequency to the second source, ie. the frequency generated by the K64F or external oscillator. |
| 0x64    |  W   | Switch Z80 CPU frequency to default host source. This is the default on RESET. |
| 0x66    |  R   | Bit [0] - Clock Selected, 0 = Host Clock, 1 = second clock source (K64F or external oscillator). |

--------------------------------------------------------------------------------------------------------

## Building tranZPUter SW-700 Software

The tranZPUter SW-700 board requires several software components to function: 

<ul>
  <li style="margin: 1px 0"><b>zOS embedded</b> - the integral operating system running on the K64F I/O processor</li>
  <li style="margin: 1px 0"><b>zOS user</b> - the operating system for a ZPU Evo running as the Sharp MZ-700 main host processor</li>
  <li style="margin: 1px 0"><b>TZFS</b> - the Z80 based operating or filing system running on the Sharp MZ-700</li>
  <li style="margin: 1px 0"><b>CP/M</b> - A real operating system for Microcomputers which I ported to the Sharp MZ-700 and it benefits from a plethora of applications.</li>
</ul>


Building the software requires different procedures and these are described in the sections below.

--------------------------------------------------------------------------------------------------------

### Paths

For ease of reading, the following shortnames refer to the corresponding path in this document. The repository can be found at [TZFS](https://github.com/pdsmart/TZFS).

*tranZPUter Repository*

|  Short Name      | Path                                                                       | Description                                                                                                                                      |
|------------------|----------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------|
| \<cpu\>          | \[\<ABS PATH>\]/tranZPUter/cpu                                             | ZPU VHDL definition files.                                                                                                                       |
| \<build\>        | \[\<ABS PATH>\]/tranZPUter/build                                           | Build files for developing and tesing of the ZPU based tranZPUter board.                                                                         |
| \<devices\>      | \[\<ABS PATH>\]/tranZPUter/devices                                         | RTL definitions of hardware devices used in the ZPU development or tranZPUter development.                                                       |
| \<docs\>         | \[\<ABS PATH>\]/tranZPUter/docs                                            | Any relevant documentation for the project.                                                                                                      |
| \<pcb\>          | \[\<ABS PATH>\]/tranZPUter/pcb                                             | Gerber files, each tranZPUter version (SW, SW-700 and tranZPUter) within it's own sub-directory.                                                 |
| \<schematics\>   | \[\<ABS PATH>\]/tranZPUter/schematics                                      | Kicad schematics and PCB design files including component library definitions.                                                                   |
| \<software\>     | \[\<ABS PATH>\]/tranZPUter/software                                        | Root directory for software used in the project.                                                                                                 |
| \<tools\>        | \[\<ABS PATH>\]/tranZPUter/software/tools                                  | Tools to aid in the compilation and creation of target files.                                                                                    |
| \<asm\>          | \[\<ABS PATH>\]/tranZPUter/software/asm                                    | Z80 assembler files for TZFS, CP/M and various original monitor ROMS.                                                                            |
| \<roms\>         | \[\<ABS PATH>\]/tranZPUter/software/roms                                   | ROM files created by assembling the Z80 source.                                                                                                  |
| \<srctools\>     | \[\<ABS PATH>\]/tranZPUter/software/src/tools                              | tranZPUter v1 Flash RAM memory map decoder file creation tool and NASCOM Basic converter tool.                                                   |
| \<cpm\>          | \[\<ABS PATH>\]/tranZPUter/software/CPM                                    | Original CPM software, grouped according to application including generated Floppy Disk and SD Card images.                                      |
| \<mzf\>          | \[\<ABS PATH>\]/tranZPUter/software/MZF                                    | Original Sharp MZF format applications which will be added into any generated SD Card image.                                                     |
| \<bas\>          | \[\<ABS PATH>\]/tranZPUter/software/BAS                                    | A collection of converted NASCOM Basic programs in readable text format. These are added to generated SD Card images.                            |
| \<cas\>          | \[\<ABS PATH>\]/tranZPUter/software/CAS                                    | A collection of NASCOM Basic tokenized tape programs converted from the NASCOM tape images. These are added to generated SD Card images.         |
| \<cas\>          | \[\<ABS PATH>\]/tranZPUter/software/NASCAS                                 | A collection of original NASCOM cassette images which havent been converted. Use the nasconv tool to convert.                                    |
| \<config\>       | \[\<ABS PATH>\]/tranZPUter/software/config                                 | Configuration files for tools. Currently the disk definition description file for generation of CP/M images.                                     |


--------------------------------------------------------------------------------------------------------

### Tools

<div style="text-align: justify"><br>
All development has been made under Linux, specifically Debian/Ubuntu. I use Windows for the GUI version of CP/M Tools but havent dedicated any time into building TZFS under Windows. I will in due course
create a Docker image with all necessary tools installed, but in the meantime, in order to assemble the Z80 code, the C programs and to work with the CP/M software and CP/M disk images, you will need to obtain and install the following tools.
</div>

NB: For the K64F, the ARM compatible toolchain is currently stored in the repo within the build tree.

|                                                                      |                                                                                                                     |
| ---------------------------------------------------------            | ------------------------------------------------------------------------------------------------------------------- |
[ZPU GCC ToolChain](https://github.com/zylin/zpugcc)                   | The GCC toolchain for ZPU development. Install into */opt* or similar common area.                                  |
[Arduino](https://www.arduino.cc/en/main/software)                     | The Arduino development environment, not really needed unless adding features to the K64F version of zOS from the extensive Arduino library. Not really needed, more for reference. |
[Teensyduino](https://www.pjrc.com/teensy/td_download.html)            | The Teensy3 Arduino extensions to work with the Teensy3.5 board at the Arduino level. Not really needed, more for reference. |
[Z80 Glass Assembler](http://www.grauw.nl/blog/entry/740/)             | A Z80 Assembler for converting Assembly files into machine code. I have had to fix a bug in the 0.5 release as it wouldnt create a byte at location 0xFFFF, this fixed version is stored in the \<tools\> directory in the repository. |
[samdisk](https://simonowen.com/samdisk/)                              | A multi-os command line based low level disk manipulation tool. |
[cpmtools](https://www.cpm8680.com/cpmtools/)                          | A multi-os command line CP/M disk manipulation tool. |
[CPMToolsGUI](http://star.gmobb.jp/koji/cgi/wiki.cgi?page=CpmtoolsGUI) | A Windows based GUI CP/M disk manipulation tool. |
[z88dk](https://www.z88dk.org/forum/)                                  | An excellent C development kit for the Z80 CPU. |
[sdcc](http://sdcc.sourceforge.net/)                                   | Another excellent Small Device C compiler, the Z80 being one of its targets. z88dk provides an enhanced (for the Z80) version of this tool within its package. |

--------------------------------------------------------------------------------------------------------

### Build TZFS

Building the software and final load image can be done by cloning the [repository](https://github.com/pdsmart/tranZPUter.git) and running some of the shell scripts and binaries provided.

TZFS is built as follows:

   1. Make the TZFS binary using \<tools\>/assemble_tzfs.sh, this creates a ROM image \<roms\>/tzfs.rom which contains all the main and banked code. 
   2. Make the original MZ80A/MZ-700 monitor roms using \<tools\>/assemble_roms.sh, this creates \<roms\>/monitor_SA1510.rom, \<roms\>/monitor_80c_SA1510.rom, \<roms\>/monitor_1Z-013A.rom and \<roms\>/monitor_80c_1Z-013A.rom.
   3. Copy and/or delete any required Sharp MZF files into/from the MZF directory.
   4. Copy files to the SD card.

See [below](/sharpmz-upgrades-tranzputer-sw/#a-typical-build) for the typical build stages.


--------------------------------------------------------------------------------------------------------

### Build CPM

To build CP/M please refer to the [CP/M build section](/sharpmz-upgrades-cpm/#building-cpm) for additional information.

The CP/M version for the tranZPUter is slightly simpler to build as it doesnt involve preparing a special SD card or compacted ROM images. 

The CP/M system is built in 4 parts,

    1. the cpm22.bin which contains the CCP, BDOS and a CBIOS stub.
    2. the banked CBIOS which has its primary source in a 4K page located at 0xF000:FFFF and a
       larger, upto 48K page, located in a seperate 64K RAM block.
    3. the concatenation of 1 + 2 + MZF Header into an MZF format file which TZFS can load.
    4. creation of the CPM disk drives which are stored as 16MB FAT32 files on the K64F SD card.

All of the above are encoded into 2 bash scripts, namely 'assemble_cpm.sh' and 'make_cpmdisks.sh' which can be executed as follows:

```bash
cd <software>
tools/assemble_cpm.sh
tools/make_cpmdisks.sh
```

The CPM disk images can be found in \<cpm\>/1M44/RAW for the raw images or \<cpm\>/1M44/DSK for the CPC Extended format disk images. These images are built from the directories in
 \<cpm\>, each directory starting with CPM* is packaged into one 1.44MB drive image. NB. In addition, the directories are also packaged into all the other supported disks as
images in a corresponding directory, ie \<cpm\>/SDC16M for the 16MB SD Card drive image.

The CPM disks which exist as files on the SD Card are stored in \<CPM\>/SDC16M/RAW and have the format CPMDSK\<number\>.RAW, where \<number\> is 00, 01 ... n and corresponds to the
disk drive under CP/M to which they are attached (ie. standard boot, 00 = drive A, 01 = drive B etc. If the Floppy Disk Controller has priority then 00 = drive C, 01 = drive D).
Under a typical run of CP/M upto 6 disks will be attached (the attachment is dynamic but limited to available memory).


--------------------------------------------------------------------------------------------------------

### A Typical Build


A quick start to building the software, creating the SD card and installing it has been
summarized below.

````bash
# Obtain an SD Card and partition into 2 DOS FAT32 formatted partitions, mount them as <SD CARD P1> and <SD CARD P2>. The partition size should be at least 512Mb each.
# The first partition will host the software to run on the K64F I/O processor AND all the Sharp MZ software to be accessed by the Sharp MZ-700.
# The second partition will host the software to run on the ZPU Evo processor when it acts as the main Sharp MZ-700 processor.

# Build zOS (embedded)
cd <zsoft>
./build.sh -C K64F -O zos  -N 0x10000 -d -T
# Flash <z-zOS>/main.hex into the K64F processor via USB or OpenSDA.
cp -r build/SD/* <SD CARD P1>/

# Build zOS (user)
./build.sh -C EVO -O zos -o 0 -M 0x1FD80 -B 0x0000 -S 0x3D80 -N 0x4000 -A 0x100000 -a 0x80000 -n 0x0000 -s 0x0000 -d -Z
cp -r build/SD/* <SD CARD P2>/
# Ensure that the ZPU zOS kernel is copied to the K64F partition as it will be used for loading into the ZPU Evo on reset.
cp -rbuild/SD/ZOS/* <SD CARD P1>/ZOS/

# Build TZFS
cd <software>
tools/assemble_tzfs.sh
# Build the required host (Sharp) ROMS.
tools/assemble_roms.sh
# Build CPM
tools/assemble_cpm.sh
# Build the CPM disks.
tools/make_cpmdisks.sh

# Create the target directories on the SD card 1st partition and copy all the necessary applications and roms.
mkdir -p <SD CARD P1>/TZFS/
mkdir -p <SD CARD P1>/MZF/
mkdir -p <SD CARD P1>/CPM/
mkdir -p <SD CARD P1>/BAS
mkdir -p <SD CARD P1>/CAS
cp <software>/roms/tzfs.rom                   <SD CARD P1>/TZFS/
cp <software>/roms/monitor_SA1510.rom         <SD CARD P1>/TZFS/SA1510.rom
cp <software>/roms/monitor_80c_SA1510.rom     <SD CARD P1>/TZFS/SA1510-8.rom
cp <software>/roms/monitor_1Z-013A.rom        <SD CARD P1>/TZFS/1Z-013A.rom
cp <software>/roms/monitor_80c_1Z-013A.rom    <SD CARD P1>/TZFS/1Z-013A-8.rom
cp <software>/roms/monitor_1Z-013A-KM.rom     <SD CARD P1>/TZFS/1Z-013A-KM.rom
cp <software>/roms/monitor_80c_1Z-013A-KM.rom <SD CARD P1>/TZFS/1Z-013A-KM-8.rom
cp <software>/roms/MZ80B_IPL.rom              <SD CARD P1>/TZFS/MZ80B_IPL.rom
cp <software>/MZF/CPM223.MZF                  <SD CARD P1>/MZF/
cp <software>/roms/cpm22.bin                  <SD CARD P1>/CPM/
cp <software>/CPM/SDC16M/RAW/*                <SD CARD P1>/CPM/
cp <software>/MZF/*                           <SD CARD P1>/MZF/
cp <software>/BAS/*                           <SD CARD P1>/BAS/
cp <software>/CAS/*                           <SD CARD P1>/CAS/

# If you want TZFS to autostart, create an empty flag file as follows.
> <SD CARD P1>/TZFSBOOT.FLG

# If you want to run TZFS commands on each boot, create an autoexec.bat file and place required commands into the file.
> <SD CARD P1>/AUTOEXEC.BAT

# Eject the card and insert it into the SD Card reader on the tranZPUter board.
# Remove the Z80 from the Sharp MZ machine and install the tranZPUter board into the Z80 socket.
# Power on. If the autostart flag has been created, you should see the familiar monitor
# signon message followed by +TZFS. If the autostart flag hasnt been created, enter the command
# JE800 into the monitor to initialise TZFS.
````

To aid in building and preparing an SD card, I use a quick and dirty script \<zSoft\>/buildall which can be used but you would need to change the ROOT_DIR and disable the RSYNC (I use a remote computer to compile zOS and upload into the K64F).

Any errors and the script will abort with a suitable error message.

--------------------------------------------------------------------------------------------------------


## Credits

Where I have used or based any component on a 3rd parties design I have included the original authors copyright notice. All 3rd party software, to my knowledge and research, is open source and freely useable, if there is found to be any component with licensing restrictions, it will be removed from this repository and a suitable link/config provided.

--------------------------------------------------------------------------------------------------------

## Licenses

This design, hardware and software, is licensed under the GNU Public Licence v3.

### The Gnu Public License v3

<div style="text-align: justify">
 The source and binary files in this project marked as GPL v3 are free software: you can redistribute it and-or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
<br><br>

 The source files are distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
<br><br>

 You should have received a copy of the GNU General Public License along with this program.  If not, see http://www.gnu.org/licenses/.
</div>

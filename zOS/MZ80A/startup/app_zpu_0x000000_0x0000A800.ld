/********************************************************************************************************
 *
 * Name:            app_zos_zpu.tmpl
 * Created:         April 2020
 * Author(s):       Philip Smart
 * Description:     ZPUTA/zOS application linker map.
 *                  This is the linker map for application programs to be run under zOS/ZPUTA. It defines
 *                  where an application is loaded and the memory locations of the various components
 *                  such as code (.text), static data (.data), uninitialised variables (.bss) etc.
 *
 * Credits:         
 * Copyright:       (c) 2019-20 Philip Smart <philip.smart@net2net.org>
 *
 * History:         April 2020   - Initial script based on ZPU linker script.
 *
 ********************************************************************************************************
 * This source file is free software: you can redistribute it and#or modify
 * it under the terms of the GNU General Public License as published
 * by the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This source file is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http:#www.gnu.org;licenses;>.
 ********************************************************************************************************/

/* Memory Definitions for a ZPU application running within RAM (either a block of BRAM, DRAM) seperate to tbe Boot BRAM.*/

MEMORY
{
  BOOT (rx)  : ORIGIN = 0x0000A800, LENGTH = 0x20    /* Boot section which shouldnt exist in an app, so a link trap as warning */
  CODE (rx)  : ORIGIN = 0x0000A820, LENGTH = 0x00003800    /* Up to the end of the RAM first less stack space */
  HEAP (rx)  : ORIGIN = 0x0000ED00, LENGTH = 0x00000300    /* Allocated heap space within the application. */
  STACK (rx) : ORIGIN = 0x0000F000, LENGTH = 0x00000000    /* Allocated stack space within the application. */
}

/* Section Definitions */

SECTIONS
{
    /* first section is .fixed_vectors which is used for startup code */
    . = 0x0000A800 ;
    _ramstart = . ;
    __boot_start__ = . ;
    .fixed_vectors :
    {
        KEEP(*(.fixed_vectors)) /* Seed section - allows -gc-sections */
    }>BOOT
    __boot_end__ = . ;
  
    /* Remaining code sections */
    . = ALIGN(4);
    __text_start__ = . ;
    .text :
    {
        *(.text)                     /* remaining code */
        *(.text.*)                   /* remaining code */
        . = ALIGN(4);
        __ctors_start__ = . ;
        KEEP(*(.ctors))
        KEEP(*(.ctors.*))
        __ctors_end__ = . ;
        . = ALIGN(4);
        __dtors_start__ = . ;
        KEEP(*(.dtors))
        KEEP(*(.dtors.*))
        __dtors_end__ = . ;
    } >CODE
    __text_end__ = . ;
  
    /* .rodata section which is used for read-only data (constants) */
    . = ALIGN(4);
    __rodata_start__ = . ;
    .rodata :
    {
        *(.rodata)
        *(.rodata.*)
    } >CODE
    . = ALIGN(4);
    __rodata_end__ = . ;
    _ramend = . ;
  
    /* .data section which is used for initialized data. */
    . = ALIGN(4);
    _datastart = . ;
    .data :
    {
        _data = . ;
        __data_start__ = . ;
        *(.data)
        *(.data.*)
        SORT(CONSTRUCTORS)
        . = ALIGN(4);
        __data_end__ = . ;
    } >CODE
  
    /* .bss section which is used for uninitialized data */
    . = ALIGN(4);
    .bss :
    {
        __bss_start = . ;
        __bss_start__ = . ;
        *(.bss)
        *(.bss.*)
        *(COMMON)
        _ebss = .;
        __bss_end__ = . ;
        _end = . ;
    } >CODE
    _dataend = . ;
  
    /* Variable expanded by build.sh */
    .heap 0x0000ED00:
    {
        /* . = 0x0000ED00; */
        . = ALIGN(4);
        __heap_section_start__ = .;
        __HeapBase = .;
        PROVIDE(end = .);
        . += 0x00000300;
        __end__ = .;
        __HeapLimit = .;
        __heap_section_end__ = .;
    } > HEAP
    
    /* Variable expanded by build.sh */
    .stack 0x0000F000 :
    {
        /* . = 0x0000F000; */
        . = ALIGN(4);
        __stack_section_start__ = .;
        . += 0x00000000;
        __stack_section_end__ = .;
    } > STACK
  
    /* Top of stack pointer, used for sbrk validation. */
    _stack = 0x0000E018;
  
    /* Debug information */
    .debug_loc 0 : { *(.debug_loc) }
    .debug_abbrev 0 : { *(.debug_abbrev) }
    .debug_str 0 : { *(.debug_str) }
    .debug_info 0 : { *(.debug_info) }
    .debug_line 0 : { *(.debug_line) }
    .debug_frame 0 : { *(.debug_frame) }
    .debug_pubnames 0 : { *(.debug_pubnames) }
    .debug_aranges 0 : { *(.debug_aranges) }
    .comment : { *(.comment) }
}

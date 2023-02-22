/////////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Name:            osd.c
// Created:         May 2021
// Version:         v1.0
// Author(s):       Philip Smart
// Description:     The On Screen Display library.
//                  This source file contains the On Screen Display definitions and methods.
//                  The OSD is a popup area on the video controller which can be used to display
//                  text/menus and accept user input. Notably this is intended to be instantiated
//                  inside an I/O processor onboard the FPGA hosting the Sharp MZ Series emulation
//                  and provide a user interface in order to configure/interact with the emulation.
//                 
// Credits:         
// Copyright:       (c) 2019-2021 Philip Smart <philip.smart@net2net.org>
//
// History:         v1.0 May 2021  - Initial write of the OSD software.
//
// Notes:           See Makefile to enable/disable conditional components
//
/////////////////////////////////////////////////////////////////////////////////////////////////////////
// This source file is free software: you can redistribute it and#or modify
// it under the terms of the GNU General Public License as published
// by the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This source file is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.
/////////////////////////////////////////////////////////////////////////////////////////////////////////

#ifdef __cplusplus
extern "C" {
#endif


#if defined(__K64F__)
  #include <stdio.h>
  #include <ctype.h>
  #include <stdint.h>
  #include <string.h>
  #include <unistd.h>
  #include <stdarg.h>
  #include <core_pins.h>
  #include <usb_serial.h>
  #include <Arduino.h>
  #include "k64f_soc.h"
  #include <../../libraries/include/stdmisc.h>
#elif defined(__ZPU__)
  #include <stdint.h>
  #include <stdio.h>
  #include "zpu_soc.h"
  #include <stdlib.h>
  #include <ctype.h>
  #include <stdmisc.h>
#else
  #error "Target CPU not defined, use __ZPU__ or __K64F__"
#endif

#include "ff.h"            /* Declarations of FatFs API */
#include "diskio.h"
#include "utils.h"
#include <fonts.h>
#include <bitmaps.h>
#include <tranzputer.h>
#include <osd.h>

#ifndef __APP__        // Protected methods which should only reside in the kernel on zOS.
static t_OSDWindow    osdWindow    = {.mode=MENU, .params={ {.attr=0,  .row=0,  .col=0,  .maxCol=0,  .maxRow=0,  .lineWrap=1,  .maxX=VC_STATUS_MAX_X_PIXELS, .maxY=VC_STATUS_MAX_Y_PIXELS},
                                                            {.attr=0,  .row=0,  .col=0,  .maxCol=0,  .maxRow=0,  .lineWrap=1,  .maxX=VC_MENU_MAX_X_PIXELS, .maxY=VC_MENU_MAX_Y_PIXELS} },
                                      .debug=0, .inDebug=0, .display=NULL};

// Method to get internal public member values. This module ideally should be written in C++ but with the limitations of the GNU C Compiler for the ZPU (v3.4.2) and the performance penalty on
// an embedded processor, it was decided to write it in C but the methodology and naming conventions (ie. OSDDrawLine = OSD.DrawLine, OSDInit = OSD::OSD constructor) are kept loosly 
// associated with C++. Ideally for this getter method function overloading is required!
//
uint32_t OSDGet(enum OSDPARAMS param)
{
    // Locals.
    //
    uint32_t  result;

    switch(param)
    {
        case ACTIVE_MAX_X:
            result = (uint32_t)osdWindow.params[osdWindow.mode].maxX;
            break;

        case ACTIVE_MAX_Y:
            result = (uint32_t)osdWindow.params[osdWindow.mode].maxY;
            break;

        default:
            result = 0xFFFFFFFF;
            break;
    }
    return(result);
}

// Method to retrieve a font definition structure based on the enumeration.
//
fontStruct *OSDGetFont(enum FONTS font)
{
    // Locals.
    //
    fontStruct    *fontptr;

    // Obtain the font structure based on the provided type.
    switch(font)
    {
        case FONT_3X6:
            fontptr = &font3x6;
            break;

        case FONT_7X8:
            fontptr = &font7x8extended;
            break;

        case FONT_9X16:
            fontptr = &font9x16;
            break;
            
        case FONT_11X16:
            fontptr = &font11x16;
            break;

        case FONT_5X7:
        default:
            fontptr = &font5x7extended;
            break;
    }
    return(fontptr);
}

// Method to retrieve a bitmap definition structure based on the enumeration.
//
bitmapStruct *OSDGetBitmap(enum BITMAPS bitmap)
{
    // Locals.
    //
    fontStruct    *bitmapptr;

    // Obtain the bitmap structure based on the provided type.
    switch(bitmap)
    {
        case BITMAP_ARGO:
        default:
            bitmapptr = & argo;
            break;
    }
    return(bitmapptr);
}

// External method to set a pixel in the active framebuffer.
//
void OSDSetPixel(uint16_t x, uint16_t y, enum COLOUR colour)
{
    if(y >= 0 && y < osdWindow.params[osdWindow.mode].maxY && x >= 0 && x < osdWindow.params[osdWindow.mode].maxX)
    {
        for(uint8_t c=0; c < (VC_MENU_RGB_BITS > VC_STATUS_RGB_BITS ? VC_MENU_RGB_BITS : VC_STATUS_RGB_BITS); c++)
        {
            if(colour & (1 << c))
            {
                osdWindow.display[c][((y * osdWindow.params[osdWindow.mode].maxX) + x)/8] |= 0x80 >> x%8;
            }
        }
    }
    return;
}

// External method to clear a pixel in the active framebuffer.
//
void OSDClearPixel(uint16_t x, uint16_t y, enum COLOUR colour)
{
    if(y >= 0 && y < osdWindow.params[osdWindow.mode].maxY && x >= 0 && x < osdWindow.params[osdWindow.mode].maxX)
    {
        for(uint8_t c=0; c < (VC_MENU_RGB_BITS > VC_STATUS_RGB_BITS ? VC_MENU_RGB_BITS : VC_STATUS_RGB_BITS); c++)
        {
            if(colour & (1 << c))
            {
                osdWindow.display[c][((y * osdWindow.params[osdWindow.mode].maxX) + x)/8] &= ~(0x80 >> x%8);
            }
        }
    }
    return;
}

// External method to change the colour of a pixel
void OSDChangePixelColour(uint16_t x, uint16_t y, enum COLOUR fg, enum COLOUR bg)
{
    // Locals.
    uint8_t  isPixelSet = 0;

    if(y >= 0 && y < osdWindow.params[osdWindow.mode].maxY && x >= 0 && x < osdWindow.params[osdWindow.mode].maxX)
    {
        // See if a pixel is set at this co-ordinate independent of colour.
        for(uint8_t c=0; c < (VC_MENU_RGB_BITS > VC_STATUS_RGB_BITS ? VC_MENU_RGB_BITS : VC_STATUS_RGB_BITS); c++)
        {
            isPixelSet |= osdWindow.display[c][((y * osdWindow.params[osdWindow.mode].maxX) + x)/8];
            // Clear out the pixel as it will be redefined.
            osdWindow.display[c][((y * osdWindow.params[osdWindow.mode].maxX) + x)/8] &= ~(0x80 >> x%8);
        }

        // Go through all the colours and set the new colour.
        for(uint8_t c=0; c < (VC_MENU_RGB_BITS > VC_STATUS_RGB_BITS ? VC_MENU_RGB_BITS : VC_STATUS_RGB_BITS); c++)
        {
            // Active pixels take on the foreground colour.
            if(fg & (1 << c) && (isPixelSet & (0x80 >> x%8)))
            {
                osdWindow.display[c][((y * osdWindow.params[osdWindow.mode].maxX) + x)/8] |= 0x80 >> x%8;
              
            // Inactive pixels take on the background colour.
            } else if(bg & (1 << c) && !(isPixelSet & (0x80 >> x%8)))
            {
                osdWindow.display[c][((y * osdWindow.params[osdWindow.mode].maxX) + x)/8] |= 0x80 >> x%8;
            }
        }
    }

}

// Internal method to write a single character into the status/menu framebuffer. The X/Y location is specified in font units, also the orientation,
// colour and required font.
//
void _OSDwrite(uint8_t x, uint8_t y, int8_t xoff, int8_t yoff, uint8_t xpad, uint8_t ypad, enum ORIENTATION orientation, uint8_t chr, enum COLOUR fg, enum COLOUR bg, fontStruct *font)
{
    // Locals.
    uint16_t   startX;
    uint16_t   startY;
    uint16_t   addr;
    uint16_t   height;
    uint16_t   width;
    uint16_t   spacing;
    uint8_t    vChrRow;
    uint8_t    bytesInChar;
    uint8_t    bitStartOffset;
    uint8_t    bitOffset;
    uint8_t    bitPos;
    uint8_t    chrByteSize;
    uint8_t    chrByteOffset;

    // Check bounds of character.
    if(chr < font->start || chr > font->end)
    {
        if(osdWindow.debug)
            printf("Character out of bounds:%02x(%d,%d)\n", chr, font->start, font->end);
        return;
    }

    // Calculate the starting byte.
    switch(orientation)
    {
        case DEG90:
            width   = font->height;
            height  = font->width;
            spacing = font->spacing;
            startX  = osdWindow.params[osdWindow.mode].maxX - ((y+1) * (width + spacing)) - yoff;
            startY  = x * (height + spacing) + xoff;
            break;

        case DEG180:
            width   = font->width;
            height  = font->height;
            spacing = font->spacing;
            startX  = osdWindow.params[osdWindow.mode].maxX - ((x+1) * (width + spacing)) - xoff;
            startY  = osdWindow.params[osdWindow.mode].maxY - ((y+1) * (height + spacing)) - yoff;
            break;

        case DEG270:
            width   = font->height;
            height  = font->width;
            spacing = font->spacing;
            startX  = (y * (width + spacing)) + yoff;
            startY  = osdWindow.params[osdWindow.mode].maxY - ((x+1) * (height + spacing)) - xoff;
            break;

        case NORMAL:
        default:
            width   = font->width;
            height  = font->height;
            spacing = font->spacing;
            startX  = (x * (width + spacing + 2*xpad)) + xpad + xoff;
            startY  = (y * (height + spacing + 2*ypad)) + ypad + yoff;
            break;
    }

    // Cant write if out of bounds.
    if(startX > osdWindow.params[osdWindow.mode].maxX || startY > osdWindow.params[osdWindow.mode].maxY || startX+width > osdWindow.params[osdWindow.mode].maxX || startY+height > osdWindow.params[osdWindow.mode].maxY)
    {
        if(osdWindow.debug)
            printf("Position out of bounds:%d,%d(%d,%d)\n", startX, startY, x, y);
        return;
    }

    // Write according to orientation.
    switch(orientation)
    {
        case DEG90:
            for(int16_t row=-ypad; row < height+ypad; row++)
            {
                for(int16_t col=-xpad; col < width+spacing+xpad; col++)
                {
                    for(uint8_t colourMode = 0; colourMode < (VC_MENU_RGB_BITS > VC_STATUS_RGB_BITS ? VC_MENU_RGB_BITS : VC_STATUS_RGB_BITS); colourMode++)
                    {
                        // Work out positional information.
                        bytesInChar    = (width/8) + 1;
                        bitStartOffset = ((width%8) != 0 ? (8-(width%8)) : 0);
                        bitPos         = (col+bitStartOffset)/8 == 0 ? bitStartOffset + (col%8) : col%8;
                        chrByteSize    = (width < 8 ? 1 : width/8);
                        chrByteOffset  = (abs(width - col - 1)/8);

                        // When 'in the money', get an 8bit part row of the font based on the row/col.
                        vChrRow = (row < 0 || row >= height || col < 0 || col >= width) ? 0 : font->bitmap[((chr - font->start) * (height * chrByteSize)) + (row * chrByteSize) + chrByteOffset ];
                             
                        // Calculate destination address.
                        //    <- Start pos based on Y       ->     <- Offset to X  ->
                        addr=((startY + row) * (osdWindow.params[osdWindow.mode].maxX/8)) + (startX + col)/8;
                       
                        // Calculate the bit offset in the targetted byte according to the font width.
                        bitOffset = (startX+col)%8;
                       
                        // Test to see if a foreground or background pixel is set and update the framebuffer accordingly.
                        if(vChrRow & 0x80 >> bitPos)
                        {
                            if(fg & (1 << colourMode))
                                osdWindow.display[colourMode][addr] |= 0x80 >> bitOffset;
                            else
                                osdWindow.display[colourMode][addr] &= ~(0x80 >> bitOffset);
                            if(osdWindow.debug && colourMode == 0) { printf("*"); }
                        } else if(bg & (1 << colourMode)) 
                        {
                            osdWindow.display[colourMode][addr] |=   0x80 >> bitOffset;
                            if(osdWindow.debug && colourMode == 0) { printf(" "); }
                        } else
                        {
                            osdWindow.display[colourMode][addr] &= ~(0x80 >> bitOffset);
                            if(osdWindow.debug && colourMode == 0) { printf(" "); }
                        }
                    }

                }
                if(osdWindow.debug)
                    printf("\n");
            }
            break;

        case DEG180:
            for(int16_t row=-ypad; row < height+ypad; row++)
            {
                for(int16_t col=-xpad; col < width+spacing+xpad; col++)
                {
                    for(uint8_t colourMode = 0; colourMode < (VC_MENU_RGB_BITS > VC_STATUS_RGB_BITS ? VC_MENU_RGB_BITS : VC_STATUS_RGB_BITS); colourMode++)
                    {
                        chrByteSize    = (height < 8 ? 1 : height/8);
                        bitStartOffset = ((height%8) != 0 ? (8-(height%8)) : 0);
                        bitPos         = (row+bitStartOffset)/8 == 0 ? bitStartOffset + (row%8) : row%8;

                        // Calculate destination address.
                        //    <- Start pos based on Y       ->     <- Offset to X  ->
                        addr=((startY + row) * (osdWindow.params[osdWindow.mode].maxX/8)) + ((startX + width + spacing - col - 1)/8);

                        // When 'in the money', get an 8bit part row of the font based on the row/col.
                        vChrRow = (row < 0 || row >= height || col < 0 || col >= width) ? 0 : font->bitmap[((chr - font->start) * (width * chrByteSize)) + (height > 8 ? col*2 : col) + (height-row-1)/8];

                        // Calculate the bit offset in the targetted byte according to the font width.
                        bitOffset = 8 - ((startX+(width-col))%8) - 1;

                        if(vChrRow & 0x80 >> bitPos)
                        {
                            if(fg & (1 << colourMode))
                                osdWindow.display[colourMode][addr] |=   1 << bitOffset;
                            else
                                osdWindow.display[colourMode][addr] &= ~(1 << bitOffset);
                            if(osdWindow.debug && colourMode == 0) { printf("*"); }
                        }
                        else if(bg & (1 << colourMode))
                        {
                            osdWindow.display[colourMode][addr] |=   1 << bitOffset;
                            if(osdWindow.debug && colourMode == 0) { printf(" "); }
                        } else
                        {
                            osdWindow.display[colourMode][addr] &= ~(1 << bitOffset);
                            if(osdWindow.debug && colourMode == 0) { printf(" "); }
                        }
                    }
                }
                if(osdWindow.debug)
                    printf("\n");
            }
            break;

        case DEG270:
            for(int16_t row=-ypad; row < height+ypad; row++)
            {
                for(int16_t col=-xpad; col < width+spacing+xpad; col++)
                {
                    for(uint8_t colourMode = 0; colourMode < (VC_MENU_RGB_BITS > VC_STATUS_RGB_BITS ? VC_MENU_RGB_BITS : VC_STATUS_RGB_BITS); colourMode++)
                    {
                        // Work out positional information.
                        bytesInChar    = (width/8) + 1;
                        bitStartOffset = ((width%8) != 0 ? (8-(width%8)) : 0);
                        bitPos         = col%8;
                        chrByteSize    = (width < 8 ? 1 : width/8);
                        chrByteOffset  = (col/8);

                        // When 'in the money', get an 8bit part row of the font based on the row/col.
                        vChrRow = (row < 0 || row >= height || col < 0 || col >= width) ? 0 : font->bitmap[((chr - font->start) * (height * chrByteSize)) + ((height-row-1) * chrByteSize) + chrByteOffset ];
                     
                        // Calculate destination address.
                        //    <- Start pos based on Y       ->     <- Offset to X  ->
                        addr=((startY + row) * (osdWindow.params[osdWindow.mode].maxX/8)) + (startX + col)/8;
                       
                        // Calculate the bit offset in the targetted byte according to the font width.
                        bitOffset = (startX+col)%8;
                       
                        // Test to see if a pixel is set and update the framebuffer accordingly.
                        if(vChrRow & 1 << bitPos)
                        {
                            if(fg & (1 << colourMode))
                                osdWindow.display[colourMode][addr] |= 0x80 >> bitOffset;
                            else
                                osdWindow.display[colourMode][addr] &= ~(0x80 >> bitOffset);
                            if(osdWindow.debug && colourMode == 0) { printf("*"); }
                        }
                        else if(bg & (1 << colourMode))
                        {
                            osdWindow.display[colourMode][addr] |=   0x80 >> bitOffset;
                            if(osdWindow.debug && colourMode == 0) { printf(" "); }
                        } else
                        {
                            osdWindow.display[colourMode][addr] &= ~(0x80 >> bitOffset);
                            if(osdWindow.debug && colourMode == 0)
                            {
                                printf(" ");
                            }
                        }
                    }

                }
                if(osdWindow.debug)
                    printf("\n");
            }
            break;

        case NORMAL:
        default:
            // Trace out the bitmap into the framebuffer.
            for(int16_t row=-ypad; row < height+ypad; row++)
            {
                for(int16_t col=-xpad; col < width+spacing+xpad; col++)
                {
                    for(uint8_t colourMode = 0; colourMode < (VC_MENU_RGB_BITS > VC_STATUS_RGB_BITS ? VC_MENU_RGB_BITS : VC_STATUS_RGB_BITS); colourMode++)
                    {
                        // Calculate destination address.
                        //    <- Start pos based on Y       ->     <- Offset to X  ->
                        addr=((startY + row) * (osdWindow.params[osdWindow.mode].maxX/8)) + ((startX + col)/8);
                   
                        // When 'in the money', get an 8bit part row of the font based on the row/col.
                        vChrRow = (row < 0 || row >= height || col < 0 || col >= width) ? 0 : font->bitmap[((chr - font->start) * (width * (height < 8 ? 1 : height/8))) + (height > 8 ? col*2 : col) + row/8];
                       
                        // Calculate the bit offset in the targetted byte according to the font width.
                        bitOffset = (startX+col)%8;

                        if(vChrRow & (1 << (row % 8)))
                        {
                            if(fg & (1 << colourMode))
                                osdWindow.display[colourMode][addr] |= 0x80 >> bitOffset;
                            else
                                osdWindow.display[colourMode][addr] &= ~(0x80 >> bitOffset);
                            if(osdWindow.debug && colourMode == 0) { printf("*"); }
                        }
                        else if(bg & (1 << colourMode))
                        {
                            osdWindow.display[colourMode][addr] |=   0x80 >> bitOffset;
                            if(osdWindow.debug && colourMode == 0) { printf(" "); }
                        } else
                        {
                            osdWindow.display[colourMode][addr] &= ~(0x80 >> bitOffset);
                            if(osdWindow.debug && colourMode == 0)
                            {
                                printf(" ");
                            }
                        }
                    }
                }
                if(osdWindow.debug)
                    printf("\n");
            }
            break;
    }
}

// Method to draw a stored bitmap onto the OSD display.
void OSDWriteBitmap(uint16_t x, uint16_t y, double xscale, double yscale, enum BITMAPS bitmap, enum COLOUR fg, enum COLOUR bg)
{
    // Locals.
    bitmapStruct *bmptr = OSDGetBitmap(bitmap);
    uint16_t     addr;
    uint16_t     height = bmptr->height;
    uint16_t     width = bmptr->width;
    uint8_t      bytesPerRow = width % 8 == 0 ? width/8 : (width/8)+1;
    uint8_t      vChrRow;
    uint8_t      bitOffset;

    uint16_t     endRow = (int)((y+height)*yscale) > osdWindow.params[osdWindow.mode].maxY ? osdWindow.params[osdWindow.mode].maxY : (int)((y+height)*yscale);
    uint16_t     endCol = (int)((x+width)*xscale) > osdWindow.params[osdWindow.mode].maxX ? osdWindow.params[osdWindow.mode].maxX : (int)((x+width)*xscale);

    // Check parameters.
    if(x >= osdWindow.params[osdWindow.mode].maxX || y >= osdWindow.params[osdWindow.mode].maxY)
    {
        if(osdWindow.debug)
            printf("Bitmap coordinates out of range:(%d,%d)\n", x, y);
        return;
    }
            // Trace out the bitmap into the framebuffer.
            for(int16_t row=y; row < endRow; row++)
            {
                for(int16_t col=x; col < endCol; col++)
                {
                    uint16_t bmAddr = (uint16_t)((((int)(col-x)/xscale)/8) + ((int)((row - y)/yscale) * bytesPerRow));

                    for(uint8_t colourMode = 0; colourMode < (VC_MENU_RGB_BITS > VC_STATUS_RGB_BITS ? VC_MENU_RGB_BITS : VC_STATUS_RGB_BITS); colourMode++)
                    {
                        // Calculate destination address.
                        //    <- Start pos based on Y       ->     <- Offset to X  ->
                        addr=((row * osdWindow.params[osdWindow.mode].maxX)+ ((uint16_t)(col/xscale)))/8;
                   
                        // When 'in the money', get an 8bit part row of the bitmap based on the row/col.
                        //vChrRow = (row < 0 || row >= y+height || col < 0 || col >= x+width) ? 0 : bmptr->bitmap[(uint16_t)((((int)(col-x)/t)/8) + ((int)((row - y)/t) * bytesPerRow))]; 
                        vChrRow = bmptr->bitmap[bmAddr];

                        // Calculate the bit offset in the targetted byte according to the bmptr width.
                        bitOffset = (uint8_t)((col-x)/xscale)%8;
//if(colourMode == 0)
//    printf("(%d,%d)%02x,%02x,%d,%d,%d,%d,%d\n",  row, col, bmptr->bitmap[(uint16_t)((((int)(col-x)/t)/8) + ((int)((row - y)/t) * bytesPerRow))], vChrRow, bitOffset, (col/8) + (row * bytesPerRow), bytesPerRow, height, width);

                        if(vChrRow & (0x80 >> bitOffset))
                        {
                            if(fg & (1 << colourMode))
                                osdWindow.display[colourMode][addr] |= 0x80 >> bitOffset;
                            else
                                osdWindow.display[colourMode][addr] &= ~(0x80 >> bitOffset);
                            //if(osdWindow.debug && colourMode == 0) { printf("*"); }
                            if(colourMode == 0) { printf("*"); }
                        }
                        else if(bg & (1 << colourMode))
                        {
                            osdWindow.display[colourMode][addr] |=   0x80 >> bitOffset;
                            //if(osdWindow.debug && colourMode == 0) { printf(" "); }
                            if(colourMode == 0) { printf(" "); }
                        } else
                        {
                            osdWindow.display[colourMode][addr] &= ~(0x80 >> bitOffset);
                            //if(osdWindow.debug && colourMode == 0)
                            if(colourMode == 0)
                            {
                                printf(" ");
                            }
                        }
                    }
                }
               // if(osdWindow.debug)
                    printf("\n");
            }
}

// External method to write a single character onto the required framebuffer. Font, orientation and colour can be specified. The X/Y co-ordinates
// are at the character level and suitably adjusted based on the font selected.
//
void OSDWriteChar(uint8_t x, uint8_t y, uint8_t xoff, uint8_t yoff, uint8_t xpad, uint8_t ypad, enum FONTS font, enum ORIENTATION orientation, uint8_t chr, enum COLOUR fg, enum COLOUR bg)
{
    // Locals.
    //
    
    _OSDwrite(x, y, xoff, yoff, xpad, ypad, orientation, chr, fg, bg, OSDGetFont(font));
    return;
}

// Method to write a string to the required framebuffer. The X/Y co-ordinates are relative to the orientation, ie. start - NORMAL=0/0, DEG90 = maxX-font width/0, 
// DEG180 = maxX-font width/maxY-font height, DEG270 = 0/maxY-font height.
//
void OSDWriteString(uint8_t x, uint8_t y, int8_t xoff, int8_t yoff, uint8_t xpad, uint8_t ypad, enum FONTS font, enum ORIENTATION orientation, uint8_t *str, enum COLOUR fg, enum COLOUR bg)
{
    // Locals.
    //
    fontStruct    *fontptr;
    uint8_t       startX;
    uint8_t       startY;
    uint8_t       maxX;
    uint8_t       maxY;
    uint8_t       xpos = x;
    uint8_t       ypos = y;

    // Obtain the font structure based on the provided type.
    fontptr = OSDGetFont(font);

    // Use the orientation to set the physical start and maxim coordinates for the given font.
    switch(orientation)
    {
        case DEG90:
            startX=osdWindow.params[osdWindow.mode].maxX/(fontptr->height + fontptr->spacing);
            startY=0;
            maxX=osdWindow.params[osdWindow.mode].maxX/(fontptr->height + fontptr->spacing);
            maxY=osdWindow.params[osdWindow.mode].maxY/(fontptr->width + fontptr->spacing);
            break;

        case DEG180:
            startX=osdWindow.params[osdWindow.mode].maxX/(fontptr->width + fontptr->spacing);
            startY=osdWindow.params[osdWindow.mode].maxY/(fontptr->height + fontptr->spacing);
            maxX=osdWindow.params[osdWindow.mode].maxX/(fontptr->width + fontptr->spacing);
            maxY=osdWindow.params[osdWindow.mode].maxY/(fontptr->height + fontptr->spacing);
            break;

        case DEG270:
            startX=0;
            startY=osdWindow.params[osdWindow.mode].maxY/(fontptr->width + fontptr->spacing);
            maxX=osdWindow.params[osdWindow.mode].maxX/(fontptr->height + fontptr->spacing);
            maxY=osdWindow.params[osdWindow.mode].maxY/(fontptr->width + fontptr->spacing);
            break;

        case NORMAL:
        default:
            startX=0;
            startY=0;
            maxX=osdWindow.params[osdWindow.mode].maxX/(fontptr->width + fontptr->spacing);
            maxY=osdWindow.params[osdWindow.mode].maxY/(fontptr->height + fontptr->spacing);
            break;
    }

    // Output the string.
    for(uint8_t *ptr=str; *ptr != 0x00; ptr++)
    {
        _OSDwrite(xpos++, ypos, xoff, yoff, xpad, ypad, orientation, (*ptr), fg, bg, fontptr);
                
        if(xpos > maxX)
        {
            if(!osdWindow.params[osdWindow.mode].lineWrap)
                xpos--;
            else if(ypos < maxY)
            {
                ypos++;
                xpos=0;
            }
        }
    }
    
    return;
}

// Method to refresh the active screen from the buffer contents.
void OSDRefreshScreen(void)
{
    // Locals.
    //
    uint32_t      addr = VIDEO_OSD_BLUE_ADDR;

    // Loop through the colour buffers and write contents out to the FPGA memory.
    for(uint8_t c=0; c < (VC_MENU_RGB_BITS > VC_STATUS_RGB_BITS ? VC_MENU_RGB_BITS : VC_STATUS_RGB_BITS); c++)
    {
        writeZ80Array(addr, osdWindow.display[c], (VC_MENU_BUFFER_SIZE > VC_STATUS_BUFFER_SIZE ? VC_MENU_BUFFER_SIZE : VC_STATUS_BUFFER_SIZE), FPGA);
        addr += 0x10000;
    }
    return;
}

// Simple screen clear method using memset to erase all pixels to inactive state.
//
void OSDClearScreen(enum COLOUR colour)
{
    // Clear the buffer memory to effect a blank screen.
    for(uint8_t c=0; c < (VC_MENU_RGB_BITS > VC_STATUS_RGB_BITS ? VC_MENU_RGB_BITS : VC_STATUS_RGB_BITS); c++)
    {
        memset(osdWindow.display[c], (colour & 1 << c ? 0xFF : 0x00), VC_MENU_BUFFER_SIZE > VC_STATUS_BUFFER_SIZE ? VC_MENU_BUFFER_SIZE : VC_STATUS_BUFFER_SIZE);
    }
    return;
}

// Clear a portion of the screen and set to a fixed colour.
//
void OSDClearArea(int16_t startX, int16_t startY, int16_t endX, int16_t endY, enum COLOUR colour)
{
    // Locals.
    int16_t    sx = (startX == -1 ? 0 : startX);
    int16_t    sy = (startY == -1 ? 0 : startY);
    int16_t    ex = (endX == -1   ? osdWindow.params[osdWindow.mode].maxX-1 : endX);
    int16_t    ey = (endY == -1   ? osdWindow.params[osdWindow.mode].maxY-1 : endY);

    // Sanity check.
    if(sx < 0 || ex >= osdWindow.params[osdWindow.mode].maxX || sx > ex || sy < 0 || ey >= osdWindow.params[osdWindow.mode].maxY || sy > ey)
        return;

    // Not the most efficient but speed not essential, go through the entire pixel area and clear or set the required colour bit for each pixel.
    //
    for(uint16_t row=0; row < osdWindow.params[osdWindow.mode].maxY; row++)
    {
        for(uint16_t col=0; col < osdWindow.params[osdWindow.mode].maxX; col++)
        {
            for(uint8_t c=0; c < (VC_MENU_RGB_BITS > VC_STATUS_RGB_BITS ? VC_MENU_RGB_BITS : VC_STATUS_RGB_BITS); c++)
            {
                if(row >= sy && row <= ey && col >= sx && col <= ex)
                {
                    if(colour & (1 << c))
                    {
                        osdWindow.display[c][((row * osdWindow.params[osdWindow.mode].maxX) + col)/8] |= 0x80 >> col%8;
                    } else
                    {
                        osdWindow.display[c][((row * osdWindow.params[osdWindow.mode].maxX) + col)/8] &= ~(0x80 >> col%8);
                    }
                }
            }
        }
    }
    return;
}

// Method to draw a line on the active window.
//
void OSDDrawLine(int16_t startX, int16_t startY, int16_t endX, int16_t endY, enum COLOUR colour)
{
    // Locals.
    int16_t    sx  = (startX == -1 ? osdWindow.params[osdWindow.mode].maxX-1 : startX);
    int16_t    sy  = (startY == -1 ? osdWindow.params[osdWindow.mode].maxY-1 : startY);
    int16_t    ex  = (endX == -1   ? osdWindow.params[osdWindow.mode].maxX-1 : endX);
    int16_t    ey  = (endY == -1   ? osdWindow.params[osdWindow.mode].maxY-1 : endY);
    int        dx  =  abs (ex - sx), stx = sx < ex ? 1 : -1;
    int        dy  = -abs (ey - sy), sty = sy < ey ? 1 : -1; 
    int        err = dx + dy, e2; /* error value e_xy */
    int16_t    x  = sx;
    int16_t    y  = sy;

    // Sanity check.
    if(sx < 0 || ex >= osdWindow.params[osdWindow.mode].maxX || sx > ex || ey < 0 || ey >= osdWindow.params[osdWindow.mode].maxY || sy > ey)
        return;

    for (;;)
    {
        setPixel(sx, sy, colour);

        if (sx == ex && sy == ey) break;
        e2 = 2 * err;
        if (e2 >= dy) { err += dy; sx += stx; } /* e_xy+e_x > 0 */
        if (e2 <= dx) { err += dx; sy += sty; } /* e_xy+e_y < 0 */
    }
    return;
}

// Method to draw a circle in the active window.
//
void OSDDrawCircle(int16_t startX, int16_t startY, int16_t radius, enum COLOUR colour)
{
    int16_t    sx  = (startX == -1 ? osdWindow.params[osdWindow.mode].maxX-1 : startX);
    int16_t    sy  = (startY == -1 ? osdWindow.params[osdWindow.mode].maxY-1 : startY);
    int16_t    x   = -radius;
    int16_t    y   = 0;
    int16_t    err = 2-2*radius;            

    do {
        setPixel(((sx-x)/VC_OSD_X_CORRECTION), ((sy+y)/VC_OSD_Y_CORRECTION), colour);                /*   I. Quadrant */
        setPixel(((sx-y)/VC_OSD_X_CORRECTION), ((sy-x)/VC_OSD_Y_CORRECTION), colour);                /*  II. Quadrant */
        setPixel(((sx+x)/VC_OSD_X_CORRECTION), ((sy-y)/VC_OSD_Y_CORRECTION), colour);                /* III. Quadrant */
        setPixel(((sx+y)/VC_OSD_X_CORRECTION), ((sy+x)/VC_OSD_Y_CORRECTION), colour);                /*  IV. Quadrant */

        radius = err;
        if (radius >  x) err += ++x*2+1;                                                             /* e_xy+e_x > 0 */
        if (radius <= y) err += ++y*2+1;                                                             /* e_xy+e_y < 0 */
    } while (x < 0);
    return;
}

// A brute force method to create a filled circle in the active window.
//
void OSDDrawFilledCircle(int16_t startX, int16_t startY, int16_t radius, enum COLOUR colour)
{
    int16_t    sx  = (startX == -1 ? osdWindow.params[osdWindow.mode].maxX-1 : startX);
    int16_t    sy  = (startY == -1 ? osdWindow.params[osdWindow.mode].maxY-1 : startY);
    int16_t    r2  = radius * radius;

    for(int y=-radius; y<=radius; y++)
    {
        for(int x=-radius; x<=radius; x++)
        {
            if(x*x+y*y <= r2)
            {
                setPixel(((sx+x)/VC_OSD_X_CORRECTION), ((sy+y)/VC_OSD_Y_CORRECTION), colour);
            }
        }
    }
    return;
}


// Method to draw an ellipse in the active window.
//
void OSDDrawEllipse(int16_t startX, int16_t startY, int16_t endX, int16_t endY, enum COLOUR colour)
{
    int16_t    sx  = (startX == -1 ? osdWindow.params[osdWindow.mode].maxX-1 : startX);
    int16_t    sy  = (startY == -1 ? osdWindow.params[osdWindow.mode].maxY-1 : startY);
    int16_t    ex  = (endX == -1   ? osdWindow.params[osdWindow.mode].maxX-1 : endX);
    int16_t    ey  = (endY == -1   ? osdWindow.params[osdWindow.mode].maxY-1 : endY);
    uint16_t   a   = abs(ex - sx);
    uint16_t   b   = abs(ey - sy);
    uint16_t   b1  = b & 1;                                                                          /* values of diameter */
    long       dx = 4 * (1 - a) * b * b;
    long       dy = 4 * (b1 + 1) * a * a;                                                            /* error increment */
    long       err = dx + dy + b1 * a * a;
    long       e2;                                                                                   /* error of 1.step */

    if (sx > ex) { sx = ex; ex += a; }                                                               /* if called with swapped points */
    if (sy > ey) sy = ey;                                                                            /* .. exchange them */
    sy += (b + 1) / 2;
    ey  = sy-b1;                                                                                     /* starting pixel */
    a  *= 8 * a; b1 = 8 * b * b;
    do
    {
        setPixel((ex/VC_OSD_X_CORRECTION), (sy/VC_OSD_Y_CORRECTION), colour);                        /*   I. Quadrant */
        setPixel((sx/VC_OSD_X_CORRECTION), (sy/VC_OSD_Y_CORRECTION), colour);                        /*  II. Quadrant */
        setPixel((sx/VC_OSD_X_CORRECTION), (ey/VC_OSD_Y_CORRECTION), colour);                        /* III. Quadrant */
        setPixel((ex/VC_OSD_X_CORRECTION), (ey/VC_OSD_Y_CORRECTION), colour);                        /*  IV. Quadrant */
        e2 = 2 * err;

        /* x step */
        if (e2 >= dx)
        {
           sx++;
           ex--;
           err += dx += b1;
        }

        /* y step */ 
        if (e2 <= dy)
        {
           sy++;
           ey--;
           err += dy += a;
        }
    } while (sx <= ex);

    /* too early stop of flat ellipses a=1 */
    while (sy-ey < b)
    {  
        setPixel(((sx-1)/VC_OSD_X_CORRECTION), (sy/VC_OSD_Y_CORRECTION), colour);                    /*   I. Quadrant */
        setPixel(((ex+1)/VC_OSD_X_CORRECTION), (sy/VC_OSD_Y_CORRECTION), colour);                    /*   I. Quadrant */
        sy++;
        setPixel(((sx-1)/VC_OSD_X_CORRECTION), (ey/VC_OSD_Y_CORRECTION), colour);                    /*   I. Quadrant */
        setPixel(((ex+1)/VC_OSD_X_CORRECTION), (ey/VC_OSD_Y_CORRECTION), colour);                    /*   I. Quadrant */
        ey--;
    }
}

// Method to change the active window used by the OSD routines. Only one window can be active at a time as they share underlying resources
// (ie. FPGA BRAM, OSD display buffer etc).
void OSDSetActiveWindow(enum WINDOWS window)
{
    // Set the starting default window.
    osdWindow.mode = window;
    return;
}

// Initialise the OSD subsystem. This method only needs to be called once, calling subsequent times will free and reallocate memory.
//
uint8_t OSDInit(enum WINDOWS window)
{
    // Locals.
    //
    uint8_t  result = 0;

    // Allocate heap for the OSD display buffers. The size is set to the maximum required buffer.
    if(osdWindow.display != NULL)
    {
        if(osdWindow.debug)
            printf("Freeing OSD display framebuffer:%08lx\n", osdWindow.display);
        free(osdWindow.display);
    } else
    {
        // Allocate largest required block on the heap which will act as the OSD window framebuffer - this is necessary as updating the physical display is time consuming due to control overhead.
        //
        osdWindow.display = malloc(VC_MENU_RGB_BITS * VC_MENU_BUFFER_SIZE > VC_STATUS_RGB_BITS * VC_STATUS_BUFFER_SIZE ? VC_MENU_RGB_BITS * VC_MENU_BUFFER_SIZE : VC_STATUS_RGB_BITS * VC_STATUS_BUFFER_SIZE);
        if(osdWindow.display == NULL)
        {
            printf("Failed to allocate heap for the OSD display framebuffer, %d bytes\n", VC_MENU_RGB_BITS * VC_MENU_BUFFER_SIZE > VC_STATUS_RGB_BITS * VC_STATUS_BUFFER_SIZE ? VC_MENU_RGB_BITS * VC_MENU_BUFFER_SIZE : VC_STATUS_RGB_BITS * VC_STATUS_BUFFER_SIZE);
            result = 1;
        } else
        {
            if(osdWindow.debug)
                printf("OSD window framebuffer allocated: %dBytes@%08lx\n", VC_MENU_RGB_BITS * VC_MENU_BUFFER_SIZE > VC_STATUS_RGB_BITS * VC_STATUS_BUFFER_SIZE ? VC_MENU_RGB_BITS * VC_MENU_BUFFER_SIZE : VC_STATUS_RGB_BITS * VC_STATUS_BUFFER_SIZE, osdWindow.display);
        }
    }
   
    // Clear screen ready for use.
    OSDClearScreen(BLACK);

    // Set the starting default window.
    OSDSetActiveWindow(window);

    return(result);
}

#endif


#ifdef __cplusplus
}
#endif
/*
 * argo64x32.c
 *
 * Sharp Argo logo (small).
 *
 * Created: 8/7/2021
 *  Author: Philip Smart
 */

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

#include "bitmaps.h"

#define BITMAP_WIDTH 64 
#define BITMAP_HEIGHT 32

static const uint8_t argo64x32Data[((BITMAP_WIDTH * BITMAP_HEIGHT)/8)+1]= {
     0x00,0x00,0x00,0x30,0x00,0x00,0x00,0x00
    ,0x00,0x00,0x00,0x78,0x00,0x00,0x00,0x00
    ,0x00,0x00,0x01,0xfc,0x00,0x00,0x00,0x00
    ,0x00,0x00,0x00,0xfc,0x00,0x00,0x00,0x38
    ,0x00,0x00,0x00,0x38,0x00,0x00,0x1c,0x78
    ,0x00,0x00,0x00,0x38,0x00,0x00,0x03,0x90
    ,0x00,0x00,0x00,0x6c,0x00,0x0f,0xbb,0x90
    ,0x00,0x00,0x00,0xee,0x00,0x3b,0x3a,0x38
    ,0x00,0x00,0x00,0xab,0x00,0x3a,0xd7,0x00
    ,0x00,0x00,0x01,0x6d,0x00,0x13,0xfb,0x00
    ,0x00,0x00,0x03,0x45,0x80,0x1b,0x9f,0x00
    ,0x00,0x00,0x02,0x46,0xc0,0x11,0xf8,0x00
    ,0x00,0x00,0x06,0xc6,0x60,0x60,0x70,0x00
    ,0x00,0x00,0x0c,0xc6,0x61,0x80,0xf0,0x00
    ,0x00,0x00,0x0c,0xc7,0xfe,0x07,0xf0,0x00
    ,0x02,0x00,0x1f,0xfc,0x0e,0x7f,0xf0,0x00
    ,0x0f,0xff,0xff,0x87,0xff,0xff,0xf0,0x00
    ,0x1f,0x1f,0x8f,0xc7,0xe7,0xff,0xf0,0x00
    ,0x1c,0xf6,0x73,0x39,0xbc,0xff,0xe0,0x00
    ,0x1c,0xf2,0xfb,0x7d,0xbe,0xff,0xc0,0x00
    ,0x1f,0x37,0x1b,0x85,0xc3,0xff,0x80,0x00
    ,0x0f,0xd7,0xed,0xfb,0x7e,0xff,0x00,0x00
    ,0x0f,0xeb,0xfa,0xfe,0xbf,0x7c,0x00,0x00
    ,0x0f,0xed,0xfd,0x7f,0x6f,0xb8,0x00,0x00
    ,0x0f,0xed,0xfd,0xdf,0xb8,0x1e,0x00,0x00
    ,0x01,0xee,0xfe,0xee,0x1c,0x07,0x00,0x00
    ,0x00,0x0f,0x00,0xf0,0x0f,0x03,0xc0,0x00
    ,0x00,0x07,0x00,0x7c,0x07,0x80,0xc0,0x00
    ,0x00,0x07,0x80,0x1e,0x01,0xc0,0x00,0x00
    ,0x00,0x03,0xc0,0x0f,0x00,0x00,0x00,0x00
    ,0x00,0x03,0xc0,0x06,0x00,0x00,0x00,0x00
    ,0x00,0x01,0x80,0x00,0x00,0x00,0x00,0x00
};

/*
 *	Bitmap Size: 64x32
 */
const bitmapStruct argo64x32 = {
	(byte *) argo64x32Data,
	BITMAP_WIDTH,
	BITMAP_HEIGHT
};
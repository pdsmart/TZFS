; Configurable parameters.
COLW:   EQU     40                      ; Width of the display screen (ie. columns).
ROW:    EQU     25                      ; Number of rows on display screen.
SCRNSZ: EQU     COLW * ROW              ; Total size, in bytes, of the screen display area.
MODE80C:EQU     0                       ; Monitor is being built for an 80 column display.
MODE2K: EQU     0                       ; Monitor is being built for an MZ-2000 machine.

		INCLUDE "1z-013a.asm"

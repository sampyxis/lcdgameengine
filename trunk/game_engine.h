#ifndef game_engine_h
#define game_engine_h

#include <WProgram.h>
#include "lcd_engine.h"


#define BLACK 1
#define WHITE 0

#define LCDWIDTH 128
#define LCDHEIGHT 56

extern void readJoyStick();
extern int getJoyLeftState();
extern int getJoyRightState();
extern int getJoyDownState();
extern int getJoyUpState();
extern int getJoyFireState();
extern void drawLine(uint8_t x0, uint8_t y0, uint8_t x1, uint8_t y1, uint8_t color);
extern void engineSetUp();
extern void screenClear();
extern void screenDisplay();
extern void drawTextDisplay(int x, int y, String s);
extern void clearTextDisplay();




#endif

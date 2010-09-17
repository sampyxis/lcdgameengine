/* 
	Need some helper functions like collision detection
	*/

//#include <avr/pgmspace.h>
#include <WProgram.h>
//#include <util/delay.h>
#include <stdlib.h>

#include "helper.h"

//helper::helper(){}
//helper help;

// Object-to-object bounding-box collision detector:
uint8_t helper::Sprite_Collide(uint8_t x, uint8_t y, uint8_t w, uint8_t h, uint8_t cx, uint8_t cy, uint8_t cw, uint8_t ch) {
  
    int left1, left2;
    int right1, right2;
    int top1, top2;
    int bottom1, bottom2;
	
    left1 = x;
    left2 = cx;
    right1 = x + w;
    right2 = cx + cw;
    top1 = y;
    top2 = cy;
    bottom1 = y + h;
    bottom2 = cy + ch;

    if (bottom1 < top2) return(0);
    if (top1 > bottom2) return(0);

    if (right1 < left2) return(0);
    if (left1 > right2) return(0);

    return(1);

};



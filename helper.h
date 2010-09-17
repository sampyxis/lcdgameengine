#include <WProgram.h>

// Game Variables
// Joystick variables
int joyLeftState = 0;
int joyRightState = 0;
int joyUpState = 0;
int joyDownState = 0;
int joyButtonState = 0;
// Need vars to save the last status
int lastJoyLeftState = 0;
int lastJoyRightState = 0;
int lastJoyUpState = 0;
int lastJoyDownState = 0;
int lastJoyButtonState = 0;

class helper {
 public:
	 helper(){}

	 uint8_t Sprite_Collide(uint8_t x, uint8_t y, uint8_t w, uint8_t h, uint8_t cx, uint8_t cy, uint8_t cw, uint8_t ch);
};

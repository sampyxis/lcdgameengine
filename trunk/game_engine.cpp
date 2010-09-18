#include "game_engine.h"


// Initialize the lcd screen
#define BACKLIGHT_LED 10
lcd_engine glcd(9,8,7,6,5); // LED Pins
#define LOGO16_GLCD_HEIGHT 16 
#define LOGO16_GLCD_WIDTH  16 
#define SCREEN_HEIGHT 56
#define SCREEN_WIDTH 128

// Joystick button vars
// Set up the buttons that will be used instead of the joystick for now
const int buttonPin0 = 2;
const int buttonPin1 = 3;
const int buttonPin2 = 11; 
const int buttonPin3 = 12;
const int buttonPin4 = 13;  

// Joystick variables
int joyLeftState;
int joyRightState;
int joyUpState;
int joyDownState;
int joyButtonState;
// Need vars to save the last status
int lastJoyLeftState;
int lastJoyRightState;
int lastJoyUpState;
int lastJoyDownState;
int lastJoyButtonState;

// Set up the engine / with the lcd
void engineSetUp()
{
  pinMode(0, INPUT); 
  pinMode(1, INPUT); 
  pinMode(2, INPUT); 
  pinMode(3, INPUT); 
  pinMode(4, INPUT);   
  // initialize the button pin as a input:
  pinMode(buttonPin0, INPUT);
  pinMode(buttonPin1, INPUT);
  pinMode(buttonPin2, INPUT);
  pinMode(buttonPin3, INPUT);
  pinMode(buttonPin4, INPUT);
  
  // Set up LCD
  pinMode(BACKLIGHT_LED, OUTPUT);
  digitalWrite(BACKLIGHT_LED, HIGH);
  glcd.st7565_init();
  glcd.st7565_command(CMD_DISPLAY_ON);
  glcd.st7565_command(CMD_SET_ALLPTS_NORMAL);
  glcd.st7565_set_brightness(0x18);
  //glcd.display(); // show splashscreen
  //delay(2000);
  //glcd.clear();
}

void screenClear()
{
  glcd.clear();
}

void screenDisplay()
{
  glcd.display();
}

// Read the joystick
// Read the Joystick
void readJoyStick()
{
    // read the pushbutton input pin:
  joyLeftState = digitalRead(buttonPin0);
  joyUpState = digitalRead(buttonPin1);
  joyRightState = digitalRead(buttonPin2);
  joyDownState = digitalRead(buttonPin3);
  joyButtonState = digitalRead(buttonPin4);

  // save the current state as the last state, 
  //for next time through the loop
  lastJoyLeftState = joyLeftState;
  lastJoyRightState = joyRightState;
  lastJoyUpState = joyUpState;
  lastJoyDownState = joyDownState;
  lastJoyButtonState = joyButtonState;
}

int getJoyLeftState()
{
  return joyLeftState;
}

int getJoyRightState()
{
  return joyRightState;
}

int getJoyDownState()
{
  return joyDownState;
}

int getJoyUpState()
{
  return joyUpState;
}

int getJoyFireState()
{
  return joyButtonState;
}


void drawLine(uint8_t x0, uint8_t y0, uint8_t x1, uint8_t y1, 
		      uint8_t color)
{
  glcd.drawline( x0, y0, x1, y1, color);
}

void drawTextDisplay(int x, int y, String s)
{
    glcd.draw_text_string(x,y, "Test");
}

void clearTextDisplay()
{
  glcd.clear_text_display();
}


// Simple - begining of a game engine
/*
  A simple game
  Snow flakes (later asteroids) are racing towards the player.
  They can go back and forth and up and down to shoot them
  As they shot them, they get points - if the astroids hit the grown they loose points (or loose a life)
  Three lives - and you die and start over.
  
  // TODO
  1) Make the bullets disapear once they leave the screen (destroy) - maybe an array of an array
  2) Make the flakes come at you according to level - small number and slow at first- increase in number and speed as the level gets bigger
  3) Destroy the flake as the bullet hits it
  4) Figure out how to put dynamic text on the screen
  Multiple levels
*/

// Define the LED needs
#include "lcd_engine.h"
#include "helper.h"


#define BACKLIGHT_LED 10
lcd_engine glcd(9,8,7,6,5); // LED Pins
#define LOGO16_GLCD_HEIGHT 16 
#define LOGO16_GLCD_WIDTH  16 
#define SCREEN_HEIGHT 56
#define SCREEN_WIDTH 128

// Initialize the snow flakes!
// Defines for the bitmaps
// These will become the enemies
#define NUMALIENS 10
#define XPOS 0
#define YPOS 1
#define DELTAY 2
uint8_t aliens[NUMALIENS][3];


// set up player positioning
uint8_t x, y;
int oldX, oldY;
int numBullets;
int bullets[20][3];
#define PLAYER_SPEED 3
String x_s;
String y_s;

// Set up the buttons that will be used instead of the joystick for now
const int buttonPin0 = 2;
const int buttonPin1 = 3;
const int buttonPin2 = 11; 
const int buttonPin3 = 12;
const int buttonPin4 = 13;  
int buttonState0 = 0;
int buttonState1 = 0;
int lastButtonState0 = 0;
int lastButtonState1 = 0;
int buttonState2 = 0;     
int buttonState3 = 0;
int lastButtonState2 = 0; 
int lastButtonState3 = 0;
int buttonState4 = 0;      
int lastButtonState4 = 0;  

static unsigned char __attribute__ ((progmem)) alien_bmp[]={
0x30, 0xf0, 0xf0, 0xf0, 0xf0, 0x30, 0xf8, 0xbe, 0x9f, 0xff, 0xf8, 0xc0, 0xc0, 0xc0, 0x80, 0x00, 
0x20, 0x3c, 0x3f, 0x3f, 0x1f, 0x19, 0x1f, 0x7b, 0xfb, 0xfe, 0xfe, 0x07, 0x07, 0x07, 0x03, 0x00, };

static unsigned char __attribute__ ((progmem)) player_bmp[]= {
0x30, 0x78, 0xFE, 0xC7, 0xC7, 0xFE, 0x78, 0x30 
        };
static unsigned char __attribute__ ((progmem)) back64_glcd_bmp[]= {
0x30, 0x78, 0xFE, 0xC7, 0xC7, 0xFE, 0x78, 0x30, 
0x30, 0x78, 0xFE, 0xC7, 0xC7, 0xFE, 0x78, 0x30, 
0x30, 0x78, 0xFE, 0xC7, 0xC7, 0xFE, 0x78, 0x30, 
0x30, 0x78, 0xFE, 0xC7, 0xC7, 0xFE, 0x78, 0x30, 
0x30, 0x78, 0xFE, 0xC7, 0xC7, 0xFE, 0x78, 0x30, 
0x30, 0x78, 0xFE, 0xC7, 0xC7, 0xFE, 0x78, 0x30, 
0x30, 0x78, 0xFE, 0xC7, 0xC7, 0xFE, 0x78, 0x30, 
0x30, 0x78, 0xFE, 0xC7, 0xC7, 0xFE, 0x78, 0x30
        };

// Initiate our helper class
helper help = helper();

void setup()   {      
 
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
  
  Serial.begin(9600);
  x = LCDWIDTH/2;
  y = LCDHEIGHT/2;
  //Serial.print(freeRam());
  
  pinMode(BACKLIGHT_LED, OUTPUT);
  digitalWrite(BACKLIGHT_LED, HIGH);
  glcd.st7565_init();
  glcd.st7565_command(CMD_DISPLAY_ON);
  glcd.st7565_command(CMD_SET_ALLPTS_NORMAL);
  glcd.st7565_set_brightness(0x18);

  //glcd.display(); // show splashscreen
  //delay(2000);
  
  // Set up aliens
    for (uint8_t f=0; f< NUMALIENS; f++) {
    aliens[f][XPOS] = random() % 128;
    aliens[f][YPOS] = 0;
    aliens[f][DELTAY] = random() % 5 + 1;
    srandom(666);     // whatever seed
  }
  
  glcd.clear();
}

void loop()
{
  // Give the player a choice for games
  // Draw Text
  // Get joystick movement
  // If up or down - move to the text and select it
  // For now - play astroids
  astroids();
}

void astroids() {
  // stay in here until the user quits
  while(1)
  {
    readJoyStick();
    translateAstroidShip();
    drawAstroidShip();
    updateAstroidShip();
    moveAstroidShip();
  }
}


void myGame()                     
{
  while(1){
  joyRead();
  drawPlayer();
  dropAliens(alien_bmp, LOGO16_GLCD_HEIGHT, LOGO16_GLCD_WIDTH); // includes the display function - need to move it to a general location
  drawBullet();
  checkCollision();
  //glcd.drawchar(0,0,char(x));
  // will put these back when I can flush
  Serial.flush();
  //glcd.clear();
  glcd.draw_engine_string(0,0, "Score: ");
  
  x_s = "X: " +  String( x, DEC );
   //Serial.println( ls );
  glcd.draw_text_string(85,0, x_s);
  y_s = "Y: " + String( y, DEC);
  glcd.draw_text_string( 45, 0, y_s);
   //glcd.clear_text_display();
  glcd.engine_display();
  //glcd.drawstring(0,1,temp);
  //drawBackground();
  //glcd.display();  
  }
}






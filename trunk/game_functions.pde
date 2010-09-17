


void drawPlayer()
{
    // Now moving the bitmap
    glcd.drawbitmap(oldX, oldY, player_bmp, 8, 8, WHITE);
    glcd.drawbitmap(x, y, player_bmp, 8, 8, BLACK);
    //glcd.display();
   
}

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


// Joystick read
void joyRead()
{
    // read the pushbutton input pin:
  buttonState0 = digitalRead(buttonPin0);
  buttonState1 = digitalRead(buttonPin1);
  buttonState2 = digitalRead(buttonPin2);
  buttonState3 = digitalRead(buttonPin3);
  buttonState4 = digitalRead(buttonPin4);

  // save old vals
  oldX = x;
  oldY = y;
  
    if (buttonState0 == HIGH) {
      // left
      x = x - PLAYER_SPEED;
    }
    if (buttonState1 == HIGH) {
    // up
    y = y - PLAYER_SPEED;
    }
    if (buttonState2 == HIGH) {
      //right
      x = x + PLAYER_SPEED;
    }
    if (buttonState3 == HIGH) {
    // down
    y = y + PLAYER_SPEED;
    }
    if (buttonState4 == HIGH) {
      // fire
      numBullets ++;
      bullets[numBullets][0] = x;
      bullets[numBullets][1] = y;
     }
  
  // if it's off the screen - wrap it around
  if (x > LCDWIDTH) 
      x=0;
  if (x < 0)
      x = LCDWIDTH - 4;
      // this is wrong - i want it to stop at the bottom
  if ( y > LCDHEIGHT )
      y = 0;
   if (y < 0 )
     y = LCDHEIGHT;
     
    // save the current state as the last state, 
    //for next time through the loop
    lastButtonState0 = buttonState0;
    lastButtonState1 = buttonState1;
    lastButtonState2 = buttonState2;
    lastButtonState3 = buttonState3;
    lastButtonState4 = buttonState4;
}

void drawBullet()
{
  for( int i=0; i<numBullets; i++) {
   glcd.setpixel( bullets[i][0], bullets[i][1], WHITE);
   // increments
   bullets[i][1] --;

   glcd.setpixel( bullets[i][0], bullets[i][1], BLACK);
   
   // Bullets always go up - once they hit 0 - delete them
   // Not working yet
   if (bullets[i][1] <= 0 )
   {
     numBullets --; // duh
     
     //for (int j = i; j < (numBullets); j++) {
     // bullets[j][0] == bullets[j+1][0];
     //bullets[j][1] == bullets[j+1][1];
     
      //bullets[(numBullets - j)-1] == 0;
     //}
   }
   
  }
}


void drawBackground()
{
   //not working yet
   for (int i = 0; i< 64; i++) {
   glcd.drawbitmap(0, i + 1,  back64_glcd_bmp, 8, 64, WHITE);
   glcd.drawbitmap(0, i,  back64_glcd_bmp, 8, 64, BLACK);
   }
}

void dropAliens( const uint8_t *bitmap, uint8_t w, uint8_t h) {
  //for the number of aliens alive
  for (uint8_t f=0; f< NUMALIENS; f++) {
    glcd.drawbitmap(aliens[f][XPOS], aliens[f][YPOS], alien_bmp, w, h, BLACK);
  }
    glcd.display();
    // then erase it and move it
    for (uint8_t f=0; f<NUMALIENS; f++) {
      glcd.drawbitmap(aliens[f][XPOS], aliens[f][YPOS], alien_bmp, w, h, 0);
      // move it
    aliens[f][YPOS] += aliens[f][DELTAY];
    // if its gone, reinit
    
    // not  yet 
  }
}

void checkCollision() // really broken
// The problem is the endless loop - really need to start deleting the entries out of the arrays
{
  
  // Change tactic
  // Now - just have the user try to avoid the asteroids
  // Loop through the flakes to see if the are in the same space
  // as the user x and y
  
  for (int i = 0; i < NUMALIENS; i++) {
    if ( help.Sprite_Collide(x, y, 8,8, aliens[i][XPOS], aliens[i][YPOS], 16, 16 ) == 1) {
      aliens[i][XPOS] = 0;
      aliens[i][YPOS] = 0;
      //NUMALIENS --;
     
    }
  }
  /*
  
      if ( icons[i][XPOS] == x ) {
      if (icons[i][YPOS] == y ) {
        // we have a hit!
        icons[i][XPOS] == 0;
        icons[i][YPOS] == 0;
        break;
      }
    }    
  // Loop through bullets and flakes -
  // If they are the same - delete the flake
  for (int i = 0; i<numBullets; i++)
  {
    //Serial.println("i and bullets: " + i );
   // Serial.println("bullets: " + numBullets);
    for (int fi = 0; i< NUMFLAKES; fi++)
    {
     // Serial.println("flakes: " + NUMFLAKES);
     // Serial.println("fi: " + fi);
      if ((bullets[i][1] == icons[fi][YPOS]) && (bullets[i][0] == icons[fi][XPOS])) {// check y first
    // Now check x
      //if (bullets[i][0] == icons[fi][XPOS] ){
        // I would delete it here - but I can't yet - so just draw it on the screen
        glcd.drawstring(1,1, "You hit!");
      //}
    }
    }
  }
  */

}


void stupid_text(int value, char* c) {
  char* v_ret = "";
  // Until I can get the string function to work on a dynamic value
  // I'm going ot do a dumb choose case and pass back the text
  switch ( value ) {
    case 1:
      v_ret = "1";
      break;
    case 2:
      v_ret = "2";
      break;
    case 3:
      v_ret = "3";
      break;
    default:
      v_ret = "?";
      break;
  }
  c = v_ret;
}

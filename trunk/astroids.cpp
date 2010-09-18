/*
 *  ASTEROID.C
 *
 *  David Stafford
 *  Computer Shopper Magazine
 *  "What's the Code?"
 *  October 1994
 *
 *  To build: BCC ASTEROID.C GRAPHICS.LIB
 */


#include <stdio.h>
#include <math.h>
#include "game_engine.h"

typedef struct
  {
  float x, y;    // 2D coordinates, a float so we can store fractional values
  } POINT;


typedef struct
  {
  int    NumPoints;
  POINT  Point[ 3 ];   // Three is enough for now but will have to make
  } SHAPE;             // this more flexible later.


typedef struct
  {
  POINT  Loc;             // Location on the screen
  int    ViewAngle;       // Angle at which the object is facing
  POINT  Direction;       // Direction which the object is moving, in pixels
  SHAPE  Shape;           // The shape of the object
  SHAPE  Screen;          // Actual points it occupies on the screen
  } OBJECT;


struct
  {
  OBJECT Ship;            // The players spaceship
  } g;
// Initialization code.

void Init( )
  {

  g.Ship.Shape.NumPoints = 3;

  g.Ship.Shape.Point[ 0 ].x =   0;
  g.Ship.Shape.Point[ 0 ].y = -4;
  g.Ship.Shape.Point[ 1 ].x =  -2;
  g.Ship.Shape.Point[ 1 ].y =  +2;
  g.Ship.Shape.Point[ 2 ].x =  +2;
  g.Ship.Shape.Point[ 2 ].y =  +2;

  g.Ship.ViewAngle = 0;

  g.Ship.Loc.x = 128/2;
  g.Ship.Loc.y = 56/2;

  g.Ship.Direction.x = 0;
  g.Ship.Direction.y = 0;
  }
  


// Translates a point by rotating it (using simple trig).

void TranslatePoint( POINT *Dest, POINT *Src, int Angle )
  {
  double Radians;

  Radians = Angle * 0.01745;

  Dest->x = Src->x * cos( Radians ) - Src->y * sin( Radians );
  Dest->y = Src->x * sin( Radians ) + Src->y * cos( Radians );
  }


// Translates an object's relative coordinates to actual
// screen coordinates.

void TranslateObject( OBJECT *Object )
  {
  int i;

  for( i = 0; i < Object->Shape.NumPoints; i++ )
    {
    // First, account for rotation
    TranslatePoint( &Object->Screen.Point[ i ], &Object->Shape.Point[ i ], Object->ViewAngle );

    // Now make it relative to the screen location
    Object->Screen.Point[ i ].x += Object->Loc.x;
    Object->Screen.Point[ i ].y += Object->Loc.y;
    }
  }


// Goes through the list of points in an object
// and connects them all with lines.

void DrawObject( OBJECT *Object )
  {
  int i;

  for( i = 1; i < Object->Shape.NumPoints; i++ )
    {
    drawLine( Object->Screen.Point[ i - 1 ].x, Object->Screen.Point[ i - 1 ].y,
          Object->Screen.Point[ i     ].x, Object->Screen.Point[ i     ].y, BLACK );
    }

  drawLine( Object->Screen.Point[ i - 1 ].x, Object->Screen.Point[ i - 1 ].y,
        Object->Screen.Point[ 0     ].x, Object->Screen.Point[ 0     ].y, BLACK );
  }


// Moves an object along its direction.

void MoveObject( OBJECT *Object )
  {
  Object->Loc.x += Object->Direction.x;
  Object->Loc.y += Object->Direction.y;

  // Handle screen wrap-around

  if( Object->Loc.x < 0 )    Object->Loc.x = Object->Loc.x + 128;
  if( Object->Loc.x > 128 )  Object->Loc.x = Object->Loc.x - 56;
  if( Object->Loc.y < 0 )    Object->Loc.y = Object->Loc.y + 56;
  if( Object->Loc.y > 128 )  Object->Loc.y = Object->Loc.y - 56;
  }


#define ROTATE_STEP  3       // Number of degrees to rotate
#define SPEED        0.52    // Speed control
#define FRICTION     0.995   // Speed reduction per frame


void Supervisor( )
  {
  int c = 0, EraseFlag = 1, Color = WHITE;

  
  while( 1 ) // Forever at this point
    {
    drawTextDisplay( 0,0, "Test");
    TranslateObject( &g.Ship );

    DrawObject( &g.Ship );   // Draw the ship

    screenDisplay();
    // Get the joystick status
    readJoyStick();

    MoveObject( &g.Ship );

    // Simulate friction.

    g.Ship.Direction.x *= FRICTION;
    g.Ship.Direction.y *= FRICTION;

    // If a real keystroke is waiting get it


    if( getJoyLeftState() )    // left shift, rotate left
      {
      g.Ship.ViewAngle -= ROTATE_STEP;
      if( g.Ship.ViewAngle < 0 )  g.Ship.ViewAngle = 360 - ROTATE_STEP;
      }

    if( getJoyRightState() )    // right shift, rotate right
      {
      g.Ship.ViewAngle += ROTATE_STEP;
      if( g.Ship.ViewAngle > 359 )  g.Ship.ViewAngle = 0 + ROTATE_STEP;
      }

    if( getJoyFireState() )    // shift-lock, fire
      {
      // Not supported yet.
      }

    if( getJoyUpState() )    // alt, thrust
      {
      double Radians;

      Radians = g.Ship.ViewAngle * 0.01745;

      g.Ship.Direction.x += sin( Radians ) * SPEED;
      g.Ship.Direction.y -= cos( Radians ) * SPEED;
      }

    if( EraseFlag )  DrawObject( &g.Ship );    // Erase the ship

    // Display
    clearTextDisplay();
    screenClear();
    }


  }

void Cleanup( void )
  {
  //closegraph();
  }


extern void mainLoop()
{

  Init();

  Supervisor();

  Cleanup();
}

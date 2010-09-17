#include "astroids_code.h"

  
// Initialization code.

void Init(  )
  {
  //int GraphicsDriver = VGA;     // assume VGA graphics card
  //int GraphicsMode = VGAHI;     // use VGA 640x480 16 color mode

  //initgraph( &GraphicsDriver, &GraphicsMode, NULL );
  //setwritemode( XOR_PUT );

  g.Ship.Shape.NumPoints = 3;

  g.Ship.Shape.Point[ 0 ].x =   0;
  g.Ship.Shape.Point[ 0 ].y = -16;
  g.Ship.Shape.Point[ 1 ].x =  -8;
  g.Ship.Shape.Point[ 1 ].y =  +8;
  g.Ship.Shape.Point[ 2 ].x =  +8;
  g.Ship.Shape.Point[ 2 ].y =  +8;

  g.Ship.ViewAngle = 0;

  g.Ship.Loc.x = 320;
  g.Ship.Loc.y = 240;

  g.Ship.Direction.x = 0;
  g.Ship.Direction.y = 0;
  }
  
  
void translateAstroidShip() {
  TranslateObject( &g.Ship );
}

void newTranslatePoint(float *Dest, float *Src, int Angle) {
  double Radians;
  Radians = Object.Angle * 0.01745;
  
  Dest->x = Src->x * cos( Radians ) - Src->y * sin( Radians);
  Dest->y = Src->x * sin( Radians ) + Src->y * cos( Radians );
}
/*
void TranslatePoint( POINT *Dest, POINT *Src, int Angle )
  {
  double Radians;

  Radians = Angle * 0.01745;

  Dest->x = Src->x * cos( Radians ) - Src->y * sin( Radians );
  Dest->y = Src->x * sin( Radians ) + Src->y * cos( Radians );
  }
  */
  // Translates an object's relative coordinates to actual
// screen coordinates.

void TranslateObject( OBJECT *Object )
  {
  int i;

  for( i = 0; i < Object->Shape.NumPoints; i++ )
    {
    // First, account for rotation
    TranslatePoint(&Object->Screen.Point[ i ], &Object->Shape.Point[ i ], Object->ViewAngle );

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
  int x, y, x1, y1;
  for( i = 1; i < Object->Shape.NumPoints; i++ )
    {
          x = Object->Screen.Point[ i -1].x;
          y = Object->Screen.Point[i - 1].y;
          x1 = Object->Screen.Point[i].x;
          y1 = Object->Screen.Point[i].y;
          glcd.drawline( x,y, x1 , y1, BLACK );
          
//    lcd_engine::drawline( Object->Screen.Point[ i - 1 ].x, Object->Screen.Point[ i - 1 ].y,
//          Object->Screen.Point[ i     ].x, Object->Screen.Point[ i     ].y, BLACK );


    }

  glcd.drawline( Object->Screen.Point[ i - 1 ].x, Object->Screen.Point[ i - 1 ].y,
        Object->Screen.Point[ 0     ].x, Object->Screen.Point[ 0     ].y , BLACK);
  }


// Moves an object along its direction.

void MoveObject( OBJECT *Object )
  {
  Object->Loc.x += Object->Direction.x;
  Object->Loc.y += Object->Direction.y;

  // Handle screen wrap-around

  if( Object->Loc.x < 0 )    Object->Loc.x = Object->Loc.x + 640;
  if( Object->Loc.x > 639 )  Object->Loc.x = Object->Loc.x - 640;
  if( Object->Loc.y < 0 )    Object->Loc.y = Object->Loc.y + 480;
  if( Object->Loc.y > 479 )  Object->Loc.y = Object->Loc.y - 480;
  }


  
void moveAstroidShip() {
    MoveObject( &g.Ship );

    // Simulate friction.

    g.Ship.Direction.x *= FRICTION;
    g.Ship.Direction.y *= FRICTION;
}

void drawAstroidShip() {
  DrawObject( &g.Ship );   // Draw the ship
}

void updateAstroidShip() {
  //This code was taken from the c astroids file
      if( joyLeftState )    // left shift, rotate left
      {
      g.Ship.ViewAngle -= ROTATE_STEP;
      if( g.Ship.ViewAngle < 0 )  g.Ship.ViewAngle = 360 - ROTATE_STEP;
      }

    if( joyRightState )    // right shift, rotate right
      {
      g.Ship.ViewAngle += ROTATE_STEP;
      if( g.Ship.ViewAngle > 359 )  g.Ship.ViewAngle = 0 + ROTATE_STEP;
      }

    if( joyButtonState )    // shift-lock, fire
      {
      // Not supported yet.
      }

    if( joyUpState )    // alt, thrust
      {
      double Radians;

      Radians = g.Ship.ViewAngle * 0.01745;

      g.Ship.Direction.x += sin( Radians ) * SPEED;
      g.Ship.Direction.y -= cos( Radians ) * SPEED;
      }

}


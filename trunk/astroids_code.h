// Astroid vars
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
  
  #define ROTATE_STEP  3       // Number of degrees to rotate
#define SPEED        0.12    // Speed control
#define FRICTION     0.995   // Speed reduction per frame

//void TranslateObject( OBJECT *object );
//void TranslatePoint(float Dest, float Src, int Angle );
void MoveObject( OBJECT *Object );

/*
 *  Common.h
 *  BlockBlaster
 *
 *  Created by Robert Backman on 19/04/2009.
 *  Copyright 2009 Robert Backman. All rights reserved.
 *
 */

#import <OpenGLES/ES1/gl.h>
#import <math.h>
#pragma mark -
#pragma mark Debug

#define TILT_CONTROL NO
#define START_LEVEL 1
#define PLAYER_START_LIVES 5
#define BOSS_ACTIVE NO
#define START_COINS 300
#define START_SHOP NO
#define LEVEL_DURATION 180
#define PLAYER_MAX_VELOCITY 20
#define AUTOPAUSE YES
#define LANDSCAPE_MODE YES
#define MAX_TOP_LEVEL 0
#define MAX_BOT_LEVEL 0
#define SHOW_BOUNDS NO
#define SHOW_CURVES NO
#define DEBUG_COLLISION NO
#define CHECK_COLLISIONS YES
#define MAKE_BLOCKS YES
#define MAKE_BADGUYS YES
#define AUTO_OPEN_INVENTORY YES

#define SEARCH_ACTIVE 0
#define SEARCH_DEBUG 0
#define SEARCH_LINES 0

#define BONUS_COUNT_MAX 10
#define DEBUG NO
#define FRAME_PER_SEC 28.0f
#define CYCLE_TIME 1.0f/FRAME_PER_SEC

#define INVENTORY_MAX_HEIGHT 96
#define INVENTORY_MIN_HEIGHT 37
#define INVENTORY_TAB_HEIGHT 39
#define INVENTORY_WEAPBAR_OFFSET_X 280
#define SLIDER_MIN_SCALE 2
#define WEAP_BAR_BUTTON_SIZE 50

#define FORWARD YES
#define BACKWARDS NO

enum game_scene_tutorial_states
{
	GAME_SCENE_TUTORIAL_START,
	GAME_SCENE_TUTORIAL_TAP_MISSLE,
	GAME_SCENE_TUTORIAL_TAP_LASER,
	GAME_SCENE_TUTORIAL_BUY_AMMO,
	GAME_SCENE_TUTORIAL_LOAD_MISSLE,
	GAME_SCENE_TUTORIAL_LOAD_LASER,
	GAME_SCENE_TUTORIAL_CLOSE_INVENTORY,
	GAME_SCENE_TUTORIAL_START_MOVING,
	GAME_SCENE_TUTORIAL_START_SHOOTING,
	GAME_SCENE_HINT_TARGET_BADGUYS,
	GAME_SCENE_HINT_TILT_CONTROL,
	GAME_SCENE_HINT_NEW_INVENTORY,
	GAME_SCENE_STOP_TUTORIAL

};
enum weapon_shop_tutorial_states
{
	WEAPON_SHOP_TUTORIAL_START,
	WEAPON_SHOP_TUTORIAL_SELECT_LASER,
	WEAPON_SHOP_TUTORIAL_PRESS_BUY_1,
	WEAPON_SHOP_TUTORIAL_PRESS_BUY_2,
	WEAPON_SHOP_TUTORIAL_SELECT_MISSLE,
	WEAPON_SHOP_TUTORIAL_PRESS_BUY_3,
	WEAPON_SHOP_TUTORIAL_PRESS_RESUME,
	WEAPON_SHOP_TUTORIAL_TIP_1
};

enum ribbon_types
{
	BLUE_RIB,
	GREEN_RIB,
	YELLOW_RIB,
	RED_RIB,
	WHITE_RIBBON
	
};

enum entity_types
{
	PLAYER,
	SAUCER,
	BADGUY,
	MISSLE,
	BLOCK,
	LASER,
	BADGUYLASER,
	TURRET,
	BACKGROUND,
	SEARCH_NODE,
	GUARDIAN,
	COIN,
	BOSS,
	BOSS_GUN,
	BOSS_TENTICLE,
	SHIELD,
	FRAGMENT,
	BONUS
};

int MAXH;
int MINH;
int MAXW;


#pragma mark -
#pragma mark Macros

// Macro which returns a random value between -1 and 1
#define RANDOM_MINUS_1_TO_1() ((random() / (GLfloat)0x3fffffff )-1.0f)

// MAcro which returns a random number between 0 and 1
#define RANDOM_0_TO_1() ((random() / (GLfloat)0x7fffffff ))

// Macro which converts degrees into radians
#define DEGREES_TO_RADIANS(__ANGLE__) ((__ANGLE__) / 180.0 * M_PI)
#define RADIANS_TO_DEGREES(__ANGLE__) ((__ANGLE__) * 180.0 / M_PI)


#pragma mark -
#pragma mark Enumerations




#pragma mark -
#pragma mark Types



typedef struct _TileVert {
	GLfloat v[2];
	GLfloat uv[2];
} TileVert;

typedef struct _Color4f {
	GLfloat red;
	GLfloat green;
	GLfloat blue;
	GLfloat alpha;
} Color4f;

typedef struct _Vector2f {
	GLfloat x;
	GLfloat y;
} Vector2f;

typedef struct _Bounds {
	Vector2f min;
	Vector2f max;
} Bounds;

typedef struct _Dimension {
	GLfloat width;
	GLfloat height;
} Dimension;

typedef struct _Quad2f {
	GLfloat bl_x, bl_y;
	GLfloat br_x, br_y;
	GLfloat tl_x, tl_y;
	GLfloat tr_x, tr_y;
} Quad2f;

typedef struct _Particle {
	Vector2f position;
	Vector2f direction;
	Color4f color;
	Color4f deltaColor;
	GLfloat particleSize;
	GLfloat timeToLive;
} Particle;


typedef struct _PointSprite {
	GLfloat x;
	GLfloat y;
	GLfloat size;
} PointSprite;


typedef struct _Tri {
	Vector2f a;
	Vector2f b;
	Vector2f c;
}Tri;

typedef struct _Rec {
	Vector2f a;
	Vector2f b;
	Vector2f c;
	Vector2f d;
}Rec;

#pragma mark -
#pragma mark Inline Functions

#ifndef ABS 
#define ABS(X) ((X)>0 ? X:-(X) 
#endif



static void activatOpenGl()
{
/*	// Set client states so that the Texture Coordinate Array will be used during rendering
	glEnableClientState(GL_VERTEX_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	
	//	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
	//	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
	
	// Enable Texture_2D
	glEnable(GL_TEXTURE_2D);
	
	// Enable blending as we want the transparent parts of the image to be transparent
	glEnable(GL_BLEND);
	
	// Setup how the images are to be blended when rendered.  The setup below is the most common
	// config and handles transparency in images
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);*/
}
static void deactivateOpenGl()
{
	//glDisableClientState(GL_VERTEX_ARRAY);
	//glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	
}
static inline CGPoint touchToScene ( CGPoint p ) 
{
	CGPoint ret;
	if(LANDSCAPE_MODE)
	{
		ret = CGPointMake( p.y , p.x);
	}
	else{
		ret = CGPointMake(p.x, 480 - p.y);
	}
	return ret;
}

static inline float sBump ( float t ) // f([0,1])->[0,1]
{
	return 1.0f - pow ( 2.0f*t - 1, 4.0f ); //exponent has to be pair: 2 (low extremity speed), 4, 6, 8 (quicker), ...
}

static const Color4f Color4fInit = {1.0f, 1.0f, 1.0f, 1.0f};

static const Vector2f Vector2fZero = {0.0f, 0.0f};



static inline Vector2f Vector2fMake(GLfloat x, GLfloat y)
{
	return (Vector2f) {x, y};
}

static inline bool ptInBounds(Vector2f pt , Bounds b) 
{
	return( pt.x <= b.max.x && pt.x >= b.min.x && pt.y <=b.max.y && pt.y >= b.min.y)	;
}

static inline bool boundsOverlap(Bounds b1, Bounds b2)
{
	
    Vector2f sum_extents;
    sum_extents.x = (b1.max.x - b1.min.x) + (b2.max.x - b2.min.x);
    sum_extents.y = (b2.max.y - b2.min.y) + (b2.max.y - b2.min.y);
	
    Vector2f double_center_to_center;
    double_center_to_center.x = (b2.min.x + b2.max.x) - (b1.min.x + b1.max.x);
    double_center_to_center.y = (b2.min.y + b2.max.y) - (b1.min.y + b1.max.y);
	
    return fabsf(double_center_to_center.x) < sum_extents.x && fabsf(double_center_to_center.y) < sum_extents.y;     
}


static inline Bounds makeBounds(Vector2f p, Dimension sc)
{
	return (Bounds){Vector2fMake(p.x - sc.width/2, p.y-sc.height/2), Vector2fMake(p.x + sc.width/2, p.y + sc.height/2 )};
}

static inline Vector2f CGPointToVector2f(CGPoint p)
{
	return (Vector2f){p.x,p.y};
}
static inline	CGPoint Vector2fToCGPoint(Vector2f v)
{
	return (CGPoint){v.x, v.y};
}

static inline  float  Vector2fangle (Vector2f v) 
{
	
	float ang =atan2f(v.y,v.x);
	if ( ang<0 ) ang += 2.0f*3.14f;
	return ang;
}

static inline Vector2f Vector2fRotate(Vector2f v1,float deg)
{
	
	float ang = DEGREES_TO_RADIANS(deg);
	
	return (Vector2f) {v1.x*cos(ang) - v1.y*sin(ang) , v1.x*sin(ang) + v1.y*cos(ang) };
}

static inline Color4f Color4fMake(GLfloat red, GLfloat green, GLfloat blue, GLfloat alpha)
{
	return (Color4f) {red, green, blue, alpha};
}

static inline Vector2f Vector2fMultiply(Vector2f v, GLfloat s)
{
	return (Vector2f) {v.x * s, v.y * s};
}

static inline Rec makeRec(Vector2f p, int width, int height,int wo, int ho)
{
	return (Rec){
		Vector2fMake(p.x-width/2+wo, p.y + height/2+ho),
		Vector2fMake(p.x+width/2+wo, p.y + height/2+ho),
		Vector2fMake(p.x+width/2+wo, p.y - height/2+ho),
		Vector2fMake(p.x-width/2+wo, p.y - height/2+ho)
	};
}
static inline Vector2f Vector2fAdd(Vector2f v1, Vector2f v2)
{
	return (Vector2f) {v1.x + v2.x, v1.y + v2.y};
}

static inline Vector2f Vector2fSub(Vector2f v1, Vector2f v2)
{
	return (Vector2f) {v1.x - v2.x, v1.y - v2.y};
}

static inline GLfloat Vector2fDot(Vector2f v1, Vector2f v2)
{
	return (GLfloat) v1.x * v2.x + v1.y * v2.y;
}
static inline Vector2f Vector2fInterp(Vector2f v1, Vector2f v2, float t)
{
	return Vector2fMake( v1.x*(1-t) + v2.x*t, v1.y*(1-t) + v2.y*t);
}

static inline GLfloat Vector2fLength(Vector2f v)
{
	return (GLfloat) sqrtf(Vector2fDot(v, v));
}
static inline GLfloat Vector2fDistance(Vector2f v,Vector2f v2)
{
	Vector2f ds = Vector2fSub(v2,v);
	return (GLfloat) sqrtf(Vector2fDot(ds, ds));
}

static inline Vector2f Vector2fNormalize(Vector2f v)
{
	return Vector2fMultiply(v, 1.0f/Vector2fLength(v));
}
static inline bool ptInRec(Vector2f pt , Rec rc)
{
	return ((pt.x > rc.a.x) &&  (pt.x < rc.b.x) && (pt.y < rc.a.y) && (pt.y > rc.c.y));
}
static inline bool ptInCGRec(Vector2f pt , CGRect rc)
{
	return ((pt.x > rc.origin.x+rc.size.width/2.0) &&  (pt.x < rc.origin.x-rc.size.width/2.0) && (pt.y < rc.origin.y+rc.size.height/2.0) && (pt.y > rc.origin.y-rc.size.height/2.0));
}
static inline Vector2f Vector2fClosestPoint(Vector2f A, Vector2f B, Vector2f P, bool segmentClamp)
{
    Vector2f AP = Vector2fSub(P,A);
    Vector2f AB = Vector2fSub(B,A);
    float ab2 = AB.x*AB.x + AB.y*AB.y;
    float ap_ab = AP.x*AB.x + AP.y*AB.y;
    float t = ap_ab / ab2;
    if (segmentClamp)
    {
		if (t < 0.0f) t = 0.0f;
		else if (t > 1.0f) t = 1.0f;
    }
     return Vector2fAdd(A,Vector2fMultiply(AB,t));
}
static inline Vector2f Vector2fProjectY(Vector2f A, Vector2f B, Vector2f P)
{
	float dx = P.x-A.x;
	float slope = (B.y-A.y)/(B.x - A.x);
	float y = slope*dx+A.y;
	return Vector2fMake(P.x, y);
}

static inline bool triRectOverlap(Tri t1, Vector2f rectPos, Vector2f size)
{
	Vector2f tri[3]; Vector2f triLines[3];
	Vector2f rect[4]; Vector2f rectLines[2];
	float minRect, maxRect, minTri, maxTri;
	
	
	//Setup the triangles verticies in an array.
	tri[0] = t1.a;
	tri[1] = t1.b;
	tri[2] = t1.c;
	
	//Setup the rectangles verticies in an array.
	rect[0] = Vector2fMake(rectPos.x - size.x/2, rectPos.y - size.y/2); //Up Left
	rect[1] = Vector2fMake(rectPos.x - size.x/2, rectPos.y + size.y/2); //Down Left
	rect[2] = Vector2fMake(rectPos.x + size.x/2, rectPos.y - size.y/2); //Up Right
	rect[3] = Vector2fMake(rectPos.x + size.x/2, rectPos.y + size.y/2); //Down Right
	
	//Create the lines that make up the triangle.
	triLines[0] = Vector2fSub(t1.a,t1.b);
	triLines[1] = Vector2fSub(t1.b,t1.c);
	triLines[2] = Vector2fSub(t1.c,t1.a);
	
	//Get the normals of the lines.
	triLines[0] = Vector2fMake(-triLines[0].y, triLines[0].x);
	triLines[1] = Vector2fMake(-triLines[1].y, triLines[1].x);
	triLines[2] = Vector2fMake(-triLines[2].y, triLines[2].x);
	
	//Normalize the lines.
	triLines[0] = Vector2fNormalize(triLines[0]);
	triLines[1] = Vector2fNormalize(triLines[1]);
	triLines[2] = Vector2fNormalize(triLines[2]);
	
	//Since the rectangles are axis aligned the axis are simply the following.
	rectLines[0] = Vector2fMake(1, 0);
	rectLines[1] = Vector2fMake(0, 1);
	
	//Rectangle Check.
	for(int i = 0; i < 2; i ++)
	{
		Vector2f axis = rectLines[i];
		
		//Project the rectangle.
		float z = Vector2fDot(rect[0], axis);
		minRect = z; maxRect = z;
		for(int e=1; e<4; e++)
		{
			z = Vector2fDot(rect[e], axis);
			if(z < minRect)
				minRect = z;
			if(z > maxRect)
				maxRect = z;
		}
		
		//Project the triangle.
		z = Vector2fDot(tri[0], axis);
		minTri = z; maxTri = z;
		for(int e=1; e<3; e++)
		{
			float z = Vector2fDot(tri[e], axis);
			if(z < minTri)
				minTri = z;
			if(z > maxTri)
				maxTri = z;
		}
		
		//Check if they are not overlapping on the current axis.
		if(minTri > maxRect || maxTri < minRect)
			return false;
	}
	
	//Triangle Check.
	for (int i=0; i<3; i++)
	{
		Vector2f axis = triLines[i];
		
		//Project the rectangle.
		float z = Vector2fDot(rect[0], axis);
		minRect = z; maxRect = z;
		for(int e=1; e<4; e++)
		{
			z = Vector2fDot(rect[e], axis);
			if(z < minRect)
				minRect = z;
			if(z > maxRect)
				maxRect = z;
		}
		
		//Project the triangle.
		z = Vector2fDot(tri[0], axis);
		minTri = z; maxTri = z;
		for(int e=1; e<3; e++)
		{
			z = Vector2fDot(tri[e], axis);
			if(z < minTri)
				minTri = z;
			if(z > maxTri)
				maxTri = z;
		}
		
		//Check if they are not overlapping on the current axis.
		if(minTri > maxRect || maxTri < minRect)
			return false;
		
	}
	return true;
}






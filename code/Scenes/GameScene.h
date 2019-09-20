//
//  GameState.h
//  BlockBlaster
//
//  Created by Robert Backman on 31/05/2009.
//  Copyright 2009 Robert Backman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractScene.h"
#import "DrawingPrimitives.h"

@class AbstractScene;
@class BadGuy;
@class Player;
@class Missile;
@class AlienTailWagger;
@class AbstractEntity;
@class Block;
@class Laser;

@class Turret;
@class	Background;
@class BezierCurve;
@class Boss1;
@class SearchManager;

@class Guardian;
@class Coin;
@class Ribbon;
@class TokenControl;
@class InventoryBar;
@class GuardianToken;
@class Shield;

// This class is the core game scene.  It is responsible for game rendering, logic, user
// input etc.
//

#define TUTORIAL_GAME_LAST_STEP 7
enum sounds
{
REWARD_SOUND,
	EXPLODE1_SOUND,
	TRACKER_SOUND,
	LASER_SOUND,
	BADGUYLASER_SOUND,
	TURRET_FIRE,
	MISSLE_SOUND,
	CLICK_SOUND,
	SHIELD_DOWN_SOUND,
	SHIELD_ACTIVATE_SOUND,
	BONUS_START_SOUND,
	BONUS_END_SOUND
};


@interface GameScene : AbstractScene  <NSCoding> {

	/* Game specific items */
  @private    

	InventoryBar*  _inventory;



	MenuControl* menuBut;
	

	float lastClickTime;
	float lastBonusStartTime;
	float lastBonusEndTime;
	float lastMissileFireTime;
	float lastTurretFireTime;
	float lastRewardTime;
	float lastExplodeTime;
	float lastBadguyLaserTime;
	float lastLaserTime;
	float lastTrackerTime;
	
	bool firstAccel;
	float levelTime;
	bool scrolling;

	float restAccelAngle;
	//Buttons

	Vector2f joyPadPos;


	
	Rec _joyPadRec;
	// Joypad locations
	bool joyPadReset;
    uint _joyPadX, _joyPadY;




	UIAccelerationValue _accelerometer[3];
	
	// Player
    Player *_player;
	Vector2f playerPos;
	Image* targetImage;
	Vector2f Vel;
	
	//environment
	int block_counter;
	int wall_counter;
	int wallTopLevel;
	int topChangeCount;
	int botChangeCount;
	bool topUp,botUp;
	bool topChange,botChange;
	int wallBotLevel;

	bool scafold_running;
	int scafold_level;
	bool scafold_wait;
	bool paused;
	
	Image* _joyPad;
	Image *_joyPadBall;
	Image *gameOverLogo;
	
	
	Image *_pauseOverlay;
	Image * _titleBar;
	Image * _backgroundImage;
	
	//Groups
	NSMutableArray *_explosions;
	NSMutableArray *_tempExplosions;
	
	NSMutableArray *_background;
	NSMutableArray *_foreground;
    NSMutableArray *_spaceships;
	NSMutableArray *_fragments;
	
	NSMutableArray *_weapons;

	
	NSMutableArray *_badguys;
	NSMutableArray *_coins;
	NSMutableArray *_blocks;
	NSMutableArray *_walls;
	NSMutableArray *_badguyweapons;
	NSMutableArray *targets;
	NSMutableArray *_ribbons;
	NSMutableArray *_shields;
	
//instances of entities
	bool BossActive;
	int badGuyCounter;
	BezierCurve* badGuyCurve;
    Background* bg;
	AlienTailWagger *_tailwagger;
	Block *b;
	
	BadGuy *badguy;
	Boss1 *boss;
	Background* _stars;
	bool targetLock;
	float playerAngle;
	
	Vector2f tutPos;
	Image* tutBackdrop;
	Image* tutArrow;
	Vector2f tutPointTo;
	bool showArrow;
		int tutorialNextStep;
	bool soundsLoaded;
	int tutorialStep;

	NSString* line1;
	NSString* line2;
	NSString* line3;
	NSString* line4;
	
	MenuControl* nextBut;
	Image* tokenToSelectImage;
	TokenControl* tokenToSelect;
	bool showNext;
	bool useJoypad;
	
	Texture2D* ribTexture;
	Texture2D* explodeTexture;
	int numGuardians;
	NSMutableArray *guardians;
	int bonusCount;
	float bonusFade;
	int sceneIdleCount;
	float buttonFade;
	bool showButtons;
	int timeSinceStart;
	float backgroundSpeed;
	float spaceshipsSpeed;
	float foregroundSpeed;
	
}

// Provide readonly access to the tilemap which is being used
@property (nonatomic, readonly) NSMutableArray *guardians;
@property (nonatomic, readonly)float playerAngle;
@property (nonatomic,readonly) 	int tutorialStep;
@property (nonatomic,readonly) Player* _player;
@property (nonatomic, readonly) NSMutableArray *targets;
@property (nonatomic) bool paused;
@property (nonatomic, readonly) InventoryBar*  _inventory;
@property (nonatomic,readwrite)bool scrolling;
// Returns a boolean which identifies if the coordinates provided are on a blocked
// tile or not on the tilemap

-(void)addBackground:(AbstractEntity*)ent;
-(void)addForeground:(AbstractEntity*)ent;
-(void)addSpaceShip:(AbstractEntity*)ent;


-(void)addBonus:(Vector2f)pos;
-(void)renderGroup:(NSMutableArray*)grp;
-(void)updateGroup:(NSMutableArray*)grp delta:(float)theDelta;
-(void)addGuardian:(GuardianToken*)tok;
-(void)addExplosion:(int)type entity:(AbstractEntity*)ent;
-(void) addExplosion:(int)type entity:(AbstractEntity*)ent radius:(float)rad;
-(void)initValues;
-(void)initLevel;
-(void)levelUp;
-(void)newGame;
-(void)checkCollisions;
-(void)makeBlocks;
-(void)makeWall;
-(void)addBadGuys;
-(void)addCoin:(Vector2f)pos;
-(void)addRibbon:(AbstractEntity*)ent type:(int)tp;
-(void)addShield:(AbstractEntity*)shld;
-(void)addFragment:(AbstractEntity*)et;
-(void)addWithRibbon:(Ribbon*)rb entity:(AbstractEntity*)ent;
-(bool)isBlocked:(float)x y:(float)y;
-(void)moveJoystick:(CGPoint)_location;
-(void)resetJoystick;
-(void)playSound:(int)s pos:(Vector2f)pos;

-(void)tutProceed;

// Returns the current accelerometer value for the given axis.  The axis is the location
// within an array in which the value is stored.  0 = x, 1 = y, 2 = z
- (float)accelerometerValueForAxis:(uint)aAxis;

// Check to see if a touch was on one of the touchpad points
- (bool)checkJoyPadWithLocation:(CGPoint)aLocation;
-(void)addBadguyWeapon:(AbstractEntity*) et;
-(void)addWeapon:(AbstractEntity*) et;
-(void)reflectWeap:(Laser*)other;
-(void)playerDie;
-(void)clearBlocks:(Vector2f)p r:(float)rad maxEnergy:(int)max;

-(Vector2f)getPlayerPos;


-(void)findTargets:(Vector2f)pos rad:(float)r;


@end

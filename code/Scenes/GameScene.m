//
//  GameState.m
//  BlockBlaster
//
//  Created by Robert Backman on 31/05/2009.
//  Copyright 2009 Robert Backman. All rights reserved.
//

#import "GameScene.h"
#import "Missile.h"
#import "Player.h"

#import "Block.h"
#import "BadGuy.h"
#import "Laser.h"

#import "turret.h"
#import "background.h"
#import "BezierCurve.h"
#import "Boss1.h"
#if SEARCH_ACTIVE
#import "SearchManager.h"
#import "Tracker.h"
#endif
#import "Guardian.h"
#import "Coin.h"
#import "Ribbon.h"
#import "Tokens.h"
#import "TokenControl.h"
#import "InventoryBar.h"
#import "Explosion.h"
#import "Shield.h"
#import "HighScoreScene.h"

#pragma mark -
#pragma mark Private interface



#pragma mark -
#pragma mark Public implementation

@implementation GameScene



@synthesize paused;

@synthesize targets;
@synthesize _inventory;
@synthesize _player;
@synthesize playerAngle;
@synthesize guardians;
@synthesize scrolling;
@synthesize tutorialStep;

#pragma mark -
#pragma mark Initialization


-(void)initValues
{
	tutorialStep = 0;
	line1=nil;
	line2 =nil;
	line3 = nil;
	line4=nil;
	useJoypad = YES;
	firstAccel = YES;
	restAccelAngle = 60;
	paused = YES;

	
	targetLock = NO;
	scafold_level = 3;
	block_counter = 0;
	scafold_wait =true;
	badGuyCounter = 0;
	

	_sceneFadeSpeed = 3.0f;
	wall_counter = 0;
	wallBotLevel = 0;
	wallTopLevel=0;
	topChangeCount = 4;
	botChangeCount = 3;

	_joyPadX = 50;
	_joyPadY = 50;
	_joyPadRec = makeRec(Vector2fMake(_joyPadX, _joyPadY), 140, 140, 0, 0); 
	joyPadPos.x = _joyPadX;
	joyPadPos.y = _joyPadY;
	
	
	BossActive = BOSS_ACTIVE;
	scrolling = YES;
}
-(void)initLevel
{
	backgroundSpeed = 0.5f;
	spaceshipsSpeed = 0.1f;
	foregroundSpeed = 1.5f;
	
	gameOverLogo = nil;
	[_shields removeAllObjects];
	[guardians removeAllObjects];
	Background* wb;
	for(int i=0;i<MAXW+64;i+=64)
	{
		
		wb = [[Background alloc] initWithLocation:Vector2fMake(i, MAXH)  BGtype:WALL_BLOCK];
		[_walls addObject:wb];
		[wb release];
		wb = [[Background alloc] initWithLocation:Vector2fMake(i, MINH-32)  BGtype:WALL_BLOCK];
		[_walls addObject:wb];
		[wb release];
	}
	bg = [[Background alloc] initWithLocation:Vector2fMake(RANDOM_0_TO_1()*MAXW,  30 + 0.8*RANDOM_0_TO_1()*MAXH)  BGtype:SPACESHIP_BATTLECRUISER];
	[self addSpaceShip:bg];
	[bg release];
	
	bg = [[Background alloc] initWithLocation:Vector2fMake(RANDOM_0_TO_1()*MAXW,  30 + 0.8*RANDOM_0_TO_1()*MAXH)  BGtype:SPACESHIP_CARGO];
	[self addSpaceShip:bg];
	[bg release];
	
	bg = [[Background alloc] initWithLocation:Vector2fMake(RANDOM_0_TO_1()*MAXW,  30 + 0.8*RANDOM_0_TO_1()*MAXH)  BGtype:SPACE_STATION];
	[self addSpaceShip:bg];
	[bg release];
	
}


- (id)init {
	
	if(self == [super init]) {
		timeSinceStart = 0;
		// Grab an instance of our singleton classes
		_director = [Director sharedDirector];

	
		// Grab the bounds of the screen
		_screenBounds = [[UIScreen mainScreen] bounds];
		imagesLoaded = NO;
		if( LANDSCAPE_MODE)
		{
			MAXW = _screenBounds.size.height;
			MAXH =  _screenBounds.size.width;// - 20;
		}else{
			MAXW = _screenBounds.size.width;
			MAXH = _screenBounds.size.height;// - 20;
		}	
		MINH = 64;
		
		[self initValues];
		
		playerPos = Vector2fMake(MAXW/3, (MAXH-MINH)/2);
		
		_shields = [[NSMutableArray alloc] init];
		_ribbons = [[NSMutableArray alloc] init];
		_background = [[NSMutableArray alloc] init];
		_fragments = [[NSMutableArray alloc] init];
		_foreground = [[NSMutableArray alloc] init];
		_spaceships = [[NSMutableArray alloc] init];
		_walls	= [[NSMutableArray alloc] init];
		_weapons = [[NSMutableArray alloc] init];
		_badguys = [[NSMutableArray alloc] init];
		_coins = [[NSMutableArray alloc] init];
		_badguyweapons = [[NSMutableArray alloc] init];
		_blocks = [[NSMutableArray alloc] init];
		targets = [[NSMutableArray alloc] init];
		guardians = [[NSMutableArray alloc] init];
		_explosions = [[NSMutableArray alloc]init];
		_tempExplosions = [[NSMutableArray alloc] init];

		
    }
	
	return self;
}
-(void) addExplosion:(int)type entity:(AbstractEntity*)ent radius:(float)rad
{
	if([_stats graphicsLevel]>8)
	{
		//printf("add explosion");
		Explosion* exp;
		switch (type) {
			case PARTICLE_TRAIL:
			case PLAYER_TRAIL:
				exp = [[Explosion alloc] initWithParent:ent type:type];
				break;
			case MISSLE_EXPLOSIVE:
				exp = [[Explosion alloc] initWithLocation:[ent position] type:type];
				[exp setExplosion_radius:rad];
				break;
			case LASER_EXPLOSION:
				exp = [[Explosion alloc] initWithLocation:[ent position] type:type];
				[self playSound:CLICK_SOUND pos:[ent position]];
				break;
			default:
				exp = [[Explosion alloc] initWithLocation:[ent position] type:type];
				[self playSound:EXPLODE1_SOUND pos:[ent position]];
				break;
		}
		
		[_tempExplosions addObject:exp];
		[exp release];
	}
	
}
-(void)addExplosion:(int)type entity:(AbstractEntity*)ent
{
	[self addExplosion:type entity:ent radius:0];	
}

-(void)newGame {

	[self initValues];
	[_badguys removeAllObjects];
	[targets removeAllObjects];
	[_badguyweapons removeAllObjects];
	[_player setLives:PLAYER_START_LIVES];
	[_player setEnergy:100];
	[_player setPosition:Vector2fMake(50, MAXH/2.0)];
	[_player set_vel:Vector2fMake(0	, 0)];
	[self resetJoystick];
	paused = YES;
	[_walls removeAllObjects];
	[_weapons removeAllObjects];
	//[_inventory reset];
}

-(void)levelUp
{
	[_stars setDu:0];
	[_badguys removeAllObjects];
	[targets removeAllObjects];
	[_badguyweapons removeAllObjects];
		paused = false;
	[_weapons removeAllObjects];

	
}
#pragma mark -
#pragma mark add to scene
-(void)playSound:(int)s pos:(Vector2f)pos
{
	CGPoint p = CGPointZero; //Vector2fToCGPoint(pos);
	
	switch (s) {

			
		case 	BONUS_START_SOUND:
			if(ABS(levelTime-lastBonusStartTime)>0.1)
			{
				lastBonusStartTime = levelTime;
				[_soundManager playSoundWithKey:@"bonusStart" gain:1.0f pitch:1 location:p shouldLoop:NO sourceID:-1];
			}
		break;
		case BONUS_END_SOUND:
			if(ABS(levelTime-lastBonusEndTime)>0.1)
			{
				lastBonusEndTime = levelTime;
				[_soundManager playSoundWithKey:@"bonusEnd" gain:1.0f pitch:1 location:p shouldLoop:NO  sourceID:-1 ];
			}
		break;
		case 	SHIELD_DOWN_SOUND:
			[_soundManager playSoundWithKey:@"shieldDown" gain:0.5f pitch:1 location:p shouldLoop:NO sourceID:-1];
			break;
		case	SHIELD_ACTIVATE_SOUND :
			[_soundManager playSoundWithKey:@"shieldActivate" gain:0.6f pitch:1 location:p shouldLoop:NO sourceID:-1] ;
			break;
		case  CLICK_SOUND:
			if(ABS(levelTime-lastClickTime)>0.1)
			{
				lastClickTime = levelTime;
				[_soundManager playSoundWithKey:@"click" gain:0.3f pitch:1 location:p shouldLoop:NO sourceID:-1];
			}
			break;
		case REWARD_SOUND:
			if(ABS(levelTime-lastRewardTime)>0.1)
			{
				lastRewardTime = levelTime;
				[_soundManager playSoundWithKey:@"reward" gain:0.4f pitch:1.0f location:p shouldLoop:NO  sourceID:-1];
			}
			break;
		case EXPLODE1_SOUND:
			if(ABS(levelTime-lastExplodeTime)>0.3)
			{
				lastExplodeTime = levelTime;
				[_soundManager playSoundWithKey:@"explodeShort" gain:0.8f pitch:1.0f location:p shouldLoop:NO  sourceID:-1];
			}
			break;
		case TRACKER_SOUND:
			if(ABS(levelTime-lastTrackerTime)>0.1)
			{
				lastTrackerTime = levelTime;
				[_soundManager playSoundWithKey:@"missile" gain:0.2f pitch:1.0f location:p shouldLoop:NO  sourceID:-1];
			}
			break;
		case LASER_SOUND:
			if(ABS(levelTime-lastLaserTime)>0.1)
			{
				lastLaserTime = levelTime;
				[_soundManager playSoundWithKey:@"laser" gain:0.2f pitch:1.0f location:p shouldLoop:NO  sourceID:-1];
			}
			break;
		case BADGUYLASER_SOUND:
			if(ABS(levelTime-lastBadguyLaserTime)>0.1)
			{
				lastBadguyLaserTime = levelTime;
				[_soundManager playSoundWithKey:@"alienLaser" gain:0.3f pitch:1.0f location:p shouldLoop:NO  sourceID:-1];
			}
			break;
		case TURRET_FIRE:
			if(ABS(levelTime-lastTurretFireTime)>0.1)
			{
				lastTurretFireTime = levelTime;
				[_soundManager playSoundWithKey:@"turretLaser" gain:1.0f pitch:1.0f location:p shouldLoop:NO  sourceID:-1];
			}
			break;
		case MISSLE_SOUND:
			if(ABS(levelTime-lastMissileFireTime)>0.1)
			{
				lastMissileFireTime = levelTime;
				[_soundManager playSoundWithKey:@"missile" gain:0.5f pitch:1.0f location:p shouldLoop:NO sourceID:-1];
			}
			break;
			
		
			
			
	}
}
-(void)addBonus:(Vector2f)pos
{
	
	if(RANDOM_0_TO_1()<[_stats game_BonusProb])
		[_inventory addBonus:pos];
}

-(void)addGuardian:(GuardianToken*)tok
{
	if([tok update])
	{
				[_soundManager playSoundWithKey:@"launchGuardian" gain:0.4f pitch:1.0f location:CGPointZero shouldLoop:NO  sourceID:-1];
		
		Guardian* _guardian = [[Guardian alloc] initWithToken:tok parent:_player];   
		[guardians addObject:_guardian];
		[_guardian release];
		numGuardians = [guardians count];
		
		for(int i=0;i<numGuardians;i++)
		{
			[[guardians objectAtIndex:i] rotateOffset:i*360.0f/numGuardians];
		}
	}
}

-(void)addRibbon:(AbstractEntity*)ent type:(int)tp
{
	if([_stats graphicsLevel]>5)
	{
		
		Ribbon* rib;
		//float scale = 1;
		//if([_stats graphicsLevel])
			
		switch(tp)
		{
			case WHITE_RIBBON:
				rib = [[Ribbon alloc] initWithWidth:5 length:8 color:Color4fMake(255, 255, 255, 0) fade:0.4];

				break;
			case BLUE_RIB:		
					rib = [[Ribbon alloc] initWithWidth:16 length:5 color:Color4fMake(0, 255, 255, 0) fade:0.3];
			break;
			case YELLOW_RIB:		
				rib = [[Ribbon alloc] initWithWidth:6 length:4 color:Color4fMake(255, 255, 0, 0) fade:0.3];
			break;
			case GREEN_RIB:
				rib = [[Ribbon alloc] initWithWidth:10 length:5 color:Color4fMake(0, 255, 0, 0) fade:0.2];
				[rib setRibWidth:10];
				break;
				
		}
		[rib set_parent:ent];
		[_ribbons addObject:rib];
		[rib release];
	}
	
}
-(void)addWithRibbon:(Ribbon*)rb entity:(AbstractEntity*)ent
{
	[rb set_parent:ent];
	[_ribbons addObject:rb];
}
-(void)addBadGuys
{	
	
	[badGuyCurve release];
	float wd = MAXW/3.0;
	Vector2f a1 = Vector2fMake(MAXW+wd, MAXH/2);
		Vector2f a2 = Vector2fMake(MAXW-wd, MAXH/2);
	int ht = (int)(RANDOM_MINUS_1_TO_1()*MAXH/2.0f);
		Vector2f a3 = Vector2fMake(wd, MAXH/2-ht);
		Vector2f a4 = Vector2fMake(-wd, MAXH/2-ht);
	
	badGuyCurve = [[BezierCurve alloc]initCurveFrom:a1 controlPoint1:a2 controlPoint2:a3 endPoint:a4 segments:10];
	
	for(int i=0; i < [_stats game_BadGuysNum]; i++) 
	{
		badguy = [[BadGuy alloc] initWithLocation:a1 curve:badGuyCurve startT:i*10];
		//[[badguy image] setScale:0.5];
		[_badguys addObject:badguy];
		[badguy release];
	}
	
}
/*
-(void)runSearch
{
	if([_badguys count]>0)
	{
		[_searchManager reset];
		float d=500;
		AbstractEntity* target = nil;
		
		for(AbstractEntity* ent in _badguys)
		{
			if( [ent alive] && [ent active] && ([ent type] == TURRET) )
			{
				Vector2f ep = [ent position];
				Vector2f pp = [_player position];
				//if(ep.x>pp.x)
			//	{
					float d1 = Vector2fDistance(ep, pp);
					if(d1<d){d=d1;target = ent;}
			//	}
			}
		}
		
		if(d<500)
		{
			if([_searchManager findStartEnd:_player to:target])
			{
				   targetLock = YES;
				   [_searchManager runSearch];
			}
			else
			{
					targetLock = NO;
			}
		}
	}
	
}
*/

- (void) makeBlocks 
{
	int size = 18;
	if(LANDSCAPE_MODE)
	{
		for(int i= MINH + 12 ; i< MAXH - 40 ;i+=size)
		{
			if(RANDOM_0_TO_1() < [_stats game_BlockProb])
			{
				b = [[Block alloc] initWithLocation:Vector2fMake(MAXW+16, i) ];
			#if SEARCH_ACTIVE
				[_searchManager addBlockedNode:(int)(i/size) pos:Vector2fMake(MAXW+16, i) ent:b];
			#endif
				[_blocks addObject:b];
				[b release];
			}
			else
			{
				#if SEARCH_ACTIVE
				[_searchManager addNode:(int)(i/size) pos:Vector2fMake(MAXW+16, i)];
			#endif
			}
		}
		
		if(SEARCH_ACTIVE)
		{
	#if SEARCH_ACTIVE
			[_searchManager newCol];
			[_searchManager update];
	#endif
		}
	}
	else{
		for(int i= wallBotLevel*64+120; i< MAXH - wallTopLevel*64-32 ;i+=size)
		{
			if(RANDOM_0_TO_1() < [_stats game_BlockProb])
			{
				b = [[Block alloc] initWithLocation:Vector2fMake(MAXW+16, i) ];
				#if SEARCH_ACTIVE
				[_searchManager addBlockedNode:(int)(i/size) pos:Vector2fMake(MAXW+16, i) ent:b];
				#endif
				[_blocks addObject:b];
				[b release];
			}
			else
			{
				#if SEARCH_ACTIVE
				[_searchManager addNode:(int)(i/size) pos:Vector2fMake(MAXW+16, i)];
				#endif
			}
		}
		
	#if SEARCH_ACTIVE
			[_searchManager newCol];
			[_searchManager update];
	#endif
	}

	
}
int wallC = 0;

-(void)makeWall{
	
	/*int size = 64;
	topChange=false;
	botChange=false;
	int topBlock,botBlock;
	scafold_wait = false;*/

	Background* wb;
	wb = [[Background alloc] initWithLocation:Vector2fMake(MAXW+32, MAXH)  BGtype:WALL_BLOCK];
	[_walls addObject:wb];
	[wb release];
	
	wb = [[Background alloc] initWithLocation:Vector2fMake(MAXW+32, MINH-32)  BGtype:WALL_BLOCK];
	[_walls addObject:wb];
	[wb release];
	
	

	if(RANDOM_0_TO_1()<0.06f)
	{
		//start or stop scaffolding
		for(int i = 0;i< MAXH + 65;i+=64)
		{
			bg = [[Background alloc] initWithLocation:Vector2fMake(MAXW+64, i)  BGtype:SQUARE_64_SCAFOLD];
			[self addForeground:bg];
			[bg release];
		}
		
		scafold_running = !scafold_running;
		if(scafold_running) scafold_wait = true;
		scafold_level = (int)(RANDOM_0_TO_1()*6);
	}
	
	if(RANDOM_0_TO_1()<0.04f)
	{
		//start or stop scaffolding
		for(int i = 0;i< MAXH + 32;i+=32)
		{
			bg = [[Background alloc] initWithLocation:Vector2fMake(MAXW+64, i)  BGtype:SQUARE_32_SCAFOLD];
			[self addBackground:bg];
			[bg release];
		}
		
		scafold_running = !scafold_running;
		if(scafold_running) scafold_wait = true;
		scafold_level = (int)(RANDOM_0_TO_1()*6);
	}
	
	
	if(![_director tutorialMode])
	{
		if(RANDOM_0_TO_1()> 1.0f - [_stats game_TurretProb])
		{ 
			//create a turret
			Turret* t = [[Turret alloc] initWithLocation:Vector2fMake(MAXW+32,  MAXH -48) top:YES ];
			[_badguys addObject:t];
			[t release];
		}
		
		if(RANDOM_0_TO_1()>1.0f - [_stats game_TurretProb])
		{ 
			//create a turret
			Turret* t = [[Turret alloc] initWithLocation:Vector2fMake(MAXW+32, 75 ) top:NO ];
			[_badguys addObject:t];
			[t release];
		}
	}
	

}
-(Vector2f)getPlayerPos {
	return [_player position];	
}
-(void)addBadguyWeapon:(AbstractEntity*) et {
	[_badguyweapons addObject:et];	
}
-(void)addWeapon:(AbstractEntity*) et
{
	[_weapons addObject:et];
}
-(void)addFragment:(AbstractEntity*)et
{
	[_fragments addObject:et];
}
	-(void)addShield:(AbstractEntity*)shld
{
	[_shields addObject:shld];
}





-(void)clearBlocks:(Vector2f)p r:(float)rad maxEnergy:(int)max {
	float ds;
	if(rad>0)
	{
		for(AbstractEntity *blk in _blocks) 
		{
			ds = Vector2fDistance([blk position], p);
			
			if(ds < rad)  [ blk removeEnergy: max * (1 - ds/rad) ];
			
		}
		for(AbstractEntity *badg in _badguys) 
		{
			ds =  Vector2fDistance([badg position], p);
			if(ds < rad )  [ badg removeEnergy:max * (1 - ds/rad) ];
		}
	}
}
-(void)addCoin:(Vector2f)pos
{
	Coin* cn = [[Coin alloc] initWithLocation:pos ];
		[self addRibbon:cn type:GREEN_RIB];
		[_coins addObject:cn];
	[cn release];
	
}
-(void)reflectWeap:(Laser*)other 
{
	
	Vector2f position = [other refPos];

		Vector2f ds = Vector2fSub( [other position], position);
		if(ABS(Vector2fLength(ds))>=0.1f)
		{
			Vector2f nrm = Vector2fNormalize( ds);
			float vdot = 2 * Vector2fDot([other _vel],nrm );
			Vector2f dir = Vector2fSub( [other _vel] , Vector2fMultiply(nrm, vdot) );
			if([other position].x < position.x)
				[other setDir: Vector2fangle(dir) + 180]; 
			else
				[other setDir:Vector2fangle(dir)];  	//R = V - ( 2 * V [dot] N ) N 
		}
	

}
#pragma mark -
#pragma mark update scene


-(void)updateGroup:(NSMutableArray*)grp delta:(float)theDelta
{
	
	NSMutableArray *discarded = [NSMutableArray array];
	for(AbstractEntity *entity in grp) {
		if([entity alive]) 
			[entity update:theDelta];
		else 
			[discarded addObject:entity];
	}
	[grp removeObjectsInArray:discarded];
	
}
-(void)unloadImages
{
	imagesLoaded = NO;
	firstThrough = YES;
	[_background removeAllObjects];
	[_fragments removeAllObjects];
	[_spaceships removeAllObjects];
	[_foreground removeAllObjects];
	[_blocks removeAllObjects];
	[_walls removeAllObjects];
	[_ribbons removeAllObjects];
	[_coins removeAllObjects];
	[_explosions removeAllObjects];
	[_weapons removeAllObjects];
	[_badguyweapons removeAllObjects];
	[targets removeAllObjects];
	[_badguys removeAllObjects];
	[targetImage release];
	[ribTexture release];
	[explodeTexture release];
	[_titleBar release];
	[_pauseOverlay release];
	[_joyPad release];
	[_joyPadBall release];
	[_stars release];
	[_inventory release];
	[boss release];
	
}
-(void)loadImages
{
	imagesLoaded = YES;
	[_ResourceManager loadGameImages];

	_stats = [_director _statManager];
	targetImage = [[_ResourceManager _spriteSheet32] getSpriteAtX:1 y:1];
	[targetImage setAlpha:0.5];

	
	ribTexture = [[Texture2D alloc] initWithImage:[UIImage imageNamed:@"streak.png"] filter:GL_NEAREST];
	
	explodeTexture = [[Texture2D alloc] initWithImage:[UIImage imageNamed:@"texture.png"] filter:GL_NEAREST];
	_titleBar = [[_ResourceManager _gameTokenSheet] getSpriteAtXYWH:0 y:7 w:8 h:1];
	

	

	
	_pauseOverlay = [[_ResourceManager _spriteSheet32] getSpriteAtXYWH:3 y:6 w:5 h:1];
	
	_joyPad = [[_ResourceManager _spriteSheet64] getSpriteAtXYWH:6 y:6 w:2 h:2];
	_joyPadBall = [[_ResourceManager _spriteSheet64] getSpriteAtX:	4 y:6];
	[_joyPad setAlpha:0.5f];
	[_joyPadBall setAlpha:0.6];
	_player = [[Player alloc] initWithLocation:playerPos ];
	
	_stars = [[Background alloc] initWithLocation:Vector2fMake(MAXW-64,MAXH/2.0f+20)  BGtype:STARS];

	boss = [[Boss1 alloc]initWithLocation:Vector2fMake(MAXW-20, MAXH/2)  ];

	_inventory = [[InventoryBar alloc] initWithLocation:Vector2fMake(MAXW/2, MAXH/2) ];
	
	
	
	
	
	buttonFade = 0;
	showButtons = NO;
	

	
}


-(void)addBackground:(AbstractEntity*)ent
{
	if([_stats graphicsLevel]>3)
	[_background addObject:ent];	
	[_background sortUsingSelector:@selector(compareZdepth:)];

	}
-(void)addForeground:(AbstractEntity*)ent
{
	if([_stats graphicsLevel]>3)
		[_foreground addObject:ent];
}

-(void)addSpaceShip:(AbstractEntity*)ent
{
	if([_stats graphicsLevel]>2)
	[_spaceships addObject:ent];	
	[_spaceships sortUsingSelector:@selector(compareZdepth:)];

}

int shipC = 0;
- (void)updateWithDelta:(GLfloat)theDelta {
	
	timeSinceStart++;
	if(firstThrough && imagesLoaded)
	{

		if([_director tutorialMode]) 
		{
			tutorialStep = GAME_SCENE_TUTORIAL_START;
			showNext = YES;
			[self tutProceed];
		}
		[super updateWithDelta:theDelta];
		//[_ResourceManager _shopTokenSheet]
		menuBut = [[MenuControl alloc] initWithImage:[[_ResourceManager _spriteSheet64] getSpriteAtXYWH:0 y:4 w:2 h:1] location:Vector2fMake(MAXW-100, MAXH-42) centerOfImage:YES type:1];
		for(AbstractEntity* ent in _blocks)[ent update:theDelta];
	}
	switch (sceneState) {
		case kSceneState_Idle:
		{
						
			[self updateGroup:_explosions delta:theDelta];
			[self updateGroup:_ribbons delta:theDelta];
			[self updateGroup:_weapons delta:theDelta];
			[self updateGroup:_background delta:theDelta];
			[self updateGroup:_fragments delta:theDelta];
			
			[self updateGroup:_spaceships delta:theDelta];
			[self updateGroup:_foreground delta:theDelta];
			[self updateGroup:_walls delta:theDelta];
			[self updateGroup:_badguys delta:theDelta];
			[self updateGroup:_badguyweapons delta:theDelta];
			[self updateGroup:_blocks delta:theDelta];
			[self updateGroup:_coins delta:theDelta];
			[_stars update:theDelta];

			
			if(sceneIdleCount--<0)
			{
				[[_director _scoreScene] takeInput];
			sceneState = kSceneState_TransitionOut;
			nextSceneKey = @"HighScores";
			}
		}
			break;
		case kSceneState_Running:
		{
			
			
			if(!paused)
			{
				shipC++;

				if(shipC%890==0)
				{
					bg = [[Background alloc] initWithLocation:Vector2fMake(MAXW+128, 60 + 0.8*RANDOM_0_TO_1()*MAXH)  BGtype:SPACESHIP_CARGO];
					[self addSpaceShip:bg];
					[bg release];
					
					
				}
				if(shipC%1300==0)
				{
					
					bg = [[Background alloc] initWithLocation:Vector2fMake(MAXW+90,  30 + 0.8*RANDOM_0_TO_1()*MAXH)  BGtype:SPACESHIP_BATTLECRUISER];
					[self addSpaceShip:bg];
					[bg release];
				}
				if(shipC%2400==0)
				{
					shipC = 0;
					bg = [[Background alloc] initWithLocation:Vector2fMake(MAXW+64,  60 + 0.8*RANDOM_0_TO_1()*MAXH)  BGtype:SPACESHIP_FISH];
					[self addSpaceShip:bg];
					[bg release];
				}
			}
			
			[_stats update];

			if([_director tutorialMode])
			{
				[nextBut updateWithDelta:theDelta];	
			}
			
			[ _inventory update:theDelta];
			
			if(paused)
			{
			
				[menuBut updateWithDelta:theDelta];
				if( [menuBut selected] )
				{
					[menuBut deselect];
					sceneState = kSceneState_TransitionOut;
					nextSceneKey = @"menu";
				} 
			}
			else if(!scrolling)
			{
				
				
				NSMutableArray* disc = [NSMutableArray array];
				
				for(Explosion* exp in _explosions)
				{
					if([exp alive])
						[exp update:theDelta];
					else
					{
						[disc addObject:exp];
					}
				}
				
				[_explosions removeObjectsInArray:disc];
				
				
				if([_player exploding])
				{
					[_player update:theDelta];
				}else scrolling = YES;
			}
			else
			{
				if([_stats graphicsLevel]>2 && CHECK_COLLISIONS)
				{
					[self checkCollisions];
				}
				
				// Update the player
				[_player set_vel:Vel];
				[_player update:theDelta];

								
				if([_player lives]<=0)
				{
					gameOverLogo = [[_ResourceManager _spriteSheet32] getSpriteAtXYWH:0 y:4 w:8 h:1];
					sceneState = kSceneState_Idle;
					sceneIdleCount = 100;
					
		
				}
				[self updateGroup:_shields delta:theDelta];

			//update search manager
			#if SEARCH_ACTIVE
				[_searchManager updateNodes:theDelta];
			#endif
				
				//update the level
				levelTime+=theDelta;
				if(levelTime<0)levelTime=0;
				
				[_stats setGame_level_time:levelTime];
				
				if(levelTime>[_stats game_level_duration])
				{
					BossActive = YES;
					levelTime = 0;
				}
				if(BossActive)
				{
					
					if([boss alive])
						[boss update:theDelta];
					else if([_coins count]>0 || [_explosions count]>1 )
					{
						;//update until the boss explosion is gone
					}
					else
					{ 
						[_stats levelUp];
						[self levelUp];
						nextSceneKey = @"WeaponShop";
						paused = YES;
						sceneState = kSceneState_TransitionOut;
						BossActive = NO; 
						[boss reset];
					}
				}
				else
				{
					if(![_director tutorialMode])
					{
						
					if(MAKE_BADGUYS && badGuyCounter++>300){badGuyCounter=0; [self addBadGuys];}
					}
					if(MAKE_BLOCKS && (![_director tutorialMode] || tutorialStep >= GAME_SCENE_TUTORIAL_START_SHOOTING))
					{
					if(block_counter++>9) {block_counter = 0; [self makeBlocks];}
					}
				}
				
				if(wall_counter++>30){wall_counter=0; [self makeWall];}
	


				
				//check button activities


			
				

			
			/*//TODO:what does this do??
			if(SEARCH_ACTIVE)
			{
				for(AbstractEntity *entity in _badguys) 
				{
					if( [entity targeted] && ( ![entity active] || ![entity alive] ) ) 
					{ 
						targetLock = NO;
						[_searchManager reset];
					}
				}
			}*/
				
							
				//check if blocks are exploding
				//TODO: put this in blocks.m
							
				
				
				if([_badguyweapons count]>0)
				{
					NSMutableArray* reflectedLasers = [NSMutableArray array];
					for(AbstractEntity* ent in _badguyweapons)
					{
						if([ent type]==LASER)
						{
							Laser* las = (Laser*)ent;
							if([las reflectLaser])
							{
								[self reflectWeap:las];	
								[reflectedLasers addObject:ent];
							}
						}
					} 
					[_weapons addObjectsFromArray:reflectedLasers];
					[_badguyweapons removeObjectsInArray:reflectedLasers];
				}
				
				NSMutableArray* oldTargets = [NSMutableArray array];
				for(AbstractEntity* ent in targets)
				{
					if(![ent alive] || ![ent active] )[oldTargets addObject:ent];
				} 
				[targets removeObjectsInArray:oldTargets];
				
				NSMutableArray* discard = [NSMutableArray array];
				for(Guardian* g in guardians)
				{
					
					if([g alive])
					{
						[g update:theDelta];
						[g setTargetLock:NO];
						if([targets count]>0)
						{
							AbstractEntity* tg = [targets objectAtIndex:0];
							if([tg alive]) [g setTarget:tg];
						}
					}
					else [discard addObject:g];
					
				}
				[guardians removeObjectsInArray:discard];

				[self updateGroup:_background delta:theDelta];
				[self updateGroup:_spaceships delta:theDelta];
				[self updateGroup:_foreground delta:theDelta];
				[self updateGroup:_weapons delta:theDelta];
				[self updateGroup:_fragments delta:theDelta];
				[self updateGroup:_walls delta:theDelta];
				[self updateGroup:_badguys delta:theDelta];
				[self updateGroup:_badguyweapons delta:theDelta];
				[self updateGroup:_blocks delta:theDelta];
				[self updateGroup:_coins delta:theDelta];
				[_stars update:theDelta];
				[self updateGroup:_ribbons delta:theDelta];
				for(Ribbon* rib in _ribbons)
				{
					[ rib addPoint];	
				}
				
				NSMutableArray* disc = [NSMutableArray array];

				for(Explosion* exp in _explosions)
				{
					if([exp alive])
						[exp update:theDelta];
					else
					{
						[disc addObject:exp];
					}
				}

				[_explosions removeObjectsInArray:disc];
				
				if([_tempExplosions count]>0){
				[_explosions addObjectsFromArray:_tempExplosions];
				
				[_tempExplosions removeAllObjects];
				}
			}
		
			}
		break;
			
		case kSceneState_TransitionIn:
		{
			if(sceneAlpha==0)
			{
				if([_director tutorialMode])
					firstThrough = YES;
				
				[self loadImages];
				_stats = [_director _statManager];
				if([_stats resumed])
				{
					[self initLevel];
					[_inventory loadImages];
					[_inventory loadTokens];
					
					
		
				}
				else
				{
					[self newGame];	
					[self initLevel];
					
					if([_stats quickPlay])
					{
						
						[_inventory loadImages];
						[_inventory loadTokens];
						[_inventory autoLoad];
						[_stats setQuickPlay:NO];
					}
					
				}
				
				paused = YES;
			}
			sceneAlpha += _sceneFadeSpeed * theDelta;
			[_director setGlobalAlpha:sceneAlpha];
			if(sceneAlpha >= 1.0f) {
				sceneAlpha = 1.0f;
				sceneState = kSceneState_Running;	
			} 
		}
			break;
		case kSceneState_TransitionOut:
		{
			 sceneAlpha -= _sceneFadeSpeed * theDelta;
			 [_director setGlobalAlpha:sceneAlpha];
			 if(sceneAlpha < 0)
			 {
				 sceneAlpha = 0;
				 if(![_director setCurrentSceneToSceneWithKey:nextSceneKey])
				 {
					 sceneState = kSceneState_TransitionIn;
				 }
				 else
				 {
					 sceneState = kSceneState_TransitionIn;
					 [_stats clearBonusPoints];
					 [_stats setResumed:YES];
					 [_director saveGameState];
					 [_ResourceManager unloadGameImages];
					 [self unloadImages];
				 }
			 }
		}
			break;
			
		default:
			break;
	}
}

-(void)playerDie
{
	[guardians removeAllObjects];
	[_shields removeAllObjects];
	
}

- (bool)isBlocked:(float)x y:(float)y {
    //return _blocked[(int)x][(int)y];
	return false;
}
- (void)checkCollisions{
	
	if(BossActive)
	{
		for(AbstractEntity *weap in _weapons)
		{
			if([boss hits:weap] )
			{
				[weap blowUp];
			}
			
		}
		if([boss hits:_player])
		{
			[_player removeLife];
		}
	}
	
	for(AbstractEntity *badg in _badguys) 
	{
		if([badg active])
		{
			for(AbstractEntity *weap in _weapons)
			{
				
				if( [badg hits:weap] )
				{
					[badg removeEnergy:[weap energy] ];
					[weap blowUp];
					[ _stats addScore:10 ];
				}
				
			}
			
			if([_player hits:badg])
			{
				[_player removeEnergy:[badg energy] ];
				[badg removeEnergy:[_player energy]];
			}
			
		}
	}
	for(Block *blk in _blocks) 
	{
		/*for(AbstractEntity *trt in _badguys)
		{
			if([trt type] == TURRET)
			{
				if([trt hit:[blk position]])[blk removeEnergy:20];
			}
		}*/
		for(AbstractEntity *weap in _weapons)
		{
			
			if([blk hits:weap] )
			{
				
				
				[blk removeEnergy:[weap energy] ];
				
				if(![blk alive])
				{
					[ _stats addScore:5];
				}
				
				
				[weap blowUp];
				
			}
			
		}
		
		
		if([_player hits:blk])
		{
			if(![blk alive])
			{
				
			}
			if([blk blockType]==INDESTRUCTABLE_BLOCK)
			{
				[_player removeLife];
			}
			else 
			{
				[_player removeEnergy:20];
				[blk removeEnergy:10];
			}
		}
		
	}
	
	for(AbstractEntity *weap in _badguyweapons)
	{
		
		for(Guardian* gdg in guardians)
		{
			if([gdg hits:weap ])
			{
				[gdg removeEnergy:[weap	 energy]];
				[weap blowUp];
			}
		}
		
		
		if([_player hits:weap])
		{
			[_player removeEnergy:[weap energy]];
			[weap blowUp];
		}
		
		for(AbstractEntity *blk  in _blocks) 
		{
			if([blk hits:weap] )
			{
				[blk removeEnergy:[weap energy]];
				[weap blowUp];
			}
			
		}
	}
	

				for(AbstractEntity *weap in _badguyweapons)
				{
						if([weap position].y>MAXH-32 || [weap position].y < 32)
						{
							[weap blowUp];
						}
				}
				for(AbstractEntity *weap in _weapons)
				{
					if([weap position].y>MAXH-32 || [weap position].y < 32)
					{
						[weap blowUp];
					}
				}
				if([_player position].y>MAXH-32 || [_player position].y < 32)
				{
					[_player removeLife];
				}
			
	
	
}


#pragma mark -
#pragma mark UI events


-(void)resetJoystick
{
	[self moveJoystick:CGPointMake(_joyPadX,_joyPadY)];
	[_player set_vel:Vector2fMake(0, 0)];
	joyPadReset = true;
}

- (void)moveJoystick:(CGPoint)_location
{
	Vector2f ballDir = Vector2fMake(_location.x, _location.y);
	Vector2f Og = Vector2fMake(_joyPadX,_joyPadY);
	Vel  = Vector2fSub(ballDir,Og);
	
	GLfloat ln = Vector2fLength(Vel);
	if(ln>[_stats player_MaxVelocity])
	{
		Vector2f newD = Vector2fNormalize(Vel);
		newD = Vector2fMultiply(newD, [_stats player_MaxVelocity]);
		Vel = newD;
		//printf("balldir %g, %g\n",ballDir.x,ballDir.y);
		//Vel = Vector2fMultiply(Vel,ln/20.0f);
		
		joyPadPos.x = _joyPadX + newD.x;
		joyPadPos.y = _joyPadY + newD.y;
		
	}
	else
	{
		joyPadPos.x = _location.x;
		joyPadPos.y = _location.y;
	}
	
	Vel = Vector2fMultiply(Vel	, 0.25);
}


- (bool)checkJoyPadWithLocation:(CGPoint)aLocation  {
	return ptInRec(CGPointToVector2f(aLocation), _joyPadRec);
}

-(void)findTargets:(Vector2f)pos rad:(float)r
{
	float minD = r;
	AbstractEntity* tgt;
	bool foundTarget = NO;
	if(BossActive)
	{
			for(AbstractEntity* ent in [boss guns])
			{
				if(![ent beenTargeted])
				{
					float d = Vector2fDistance([ent position], pos);
					if(d<minD){
						foundTarget = YES;
						tgt=ent;
						minD = d;
					}
				}
			}
	}
	for(AbstractEntity* ent in _badguys)
	{
		if(![ent beenTargeted])
		{
			float d = Vector2fDistance([ent position], pos);
			if(d<minD){
				foundTarget = YES;
				tgt=ent;
				minD = d;
			}
		}
	}
	if(!foundTarget)
	{
		for(Block* ent in _blocks)
		{
			if([ent blockType] !=INDESTRUCTABLE_BLOCK)
			{
			if(![ent beenTargeted])
			{
				float d = Vector2fDistance([ent position], pos);
				if(d<minD){
					
					tgt=ent;
					minD = d;
				}
			}
			}
		}
	}
	if(minD<r)
	{
		[tgt setBeenTargeted:YES];
		[targets addObject:tgt];  
	}
}
- (void)updateWithTouchLocationBegan:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView {
	//	Read more: http://mcdevzone.com/2008/11/22/handling-multi-touch-in-an-iphone-application/#ixzz0U9oc5wK0

	

	UITouch *touch1; 
	UITouch *touch2;
	bool multi = NO;

	
	switch ([touches count]) {
        case 1:
        {
            // handle a single touch
            touch1 = [touches anyObject];
		            break;
        }
        default:
        {
		
            // handle multi touch
            touch1 = [[touches allObjects] objectAtIndex:0];
            touch2 = [[touches allObjects] objectAtIndex:1];
            multi = YES;
			//initialDistance = [self distanceBetweenTwoPoints:[touch1 locationInView:self]
              //                                       toPoint:[touch2 locationInView:self]];
            break;
        }
	}
	
			CGPoint _loc1,_loc2;
			_loc1 = touchToScene([touch1 locationInView:aView]);

			if(multi)
			{
				_loc2 = touchToScene([touch2 locationInView:aView]);
			}
			// Flip the y location ready to check it against OpenGL coordinates
		
		
			[_inventory hit:CGPointToVector2f(_loc1) press:BEGAN_PRESS];
		




		 
		 if([_inventory closed])
		 {
	
			if(useJoypad)
			{	
				if([self checkJoyPadWithLocation:_loc1])
				{ 
					paused = false; 
					if([_player exploding]) [_player setExplodeCount:0];
				}
				else 
				{
					 [self findTargets:CGPointToVector2f(_loc1) rad:30];
				}
			}	
				if(multi)
				{
					
						  if([self checkJoyPadWithLocation:_loc2])paused = false;
						  else  [self findTargets:CGPointToVector2f(_loc2) rad:30];

				}
		 }
			
			
	
	
}
- (void)updateWithTouchLocationMoved:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView {
	
		

	
	UITouch *touch1; 
	UITouch *touch2;
	bool multi = NO;
	//	[self updateButtons:touches view:aView ];
	switch ([touches count])
	{
        case 1:
        { 
            // handle a single touch
            touch1 = [touches anyObject];
            break;
        }
        default:
        {
	            // handle multi touch
            touch1 = [[touches allObjects] objectAtIndex:0];
            touch2 = [[touches allObjects] objectAtIndex:1];
            multi = YES;
			break;
        }
	}
	
	CGPoint _loc1,_loc2;
		_loc1 = touchToScene([touch1 locationInView:aView]);
		
		if(multi)
		{
			_loc2 = touchToScene([touch2 locationInView:aView]);
		}
		

		
			[ _inventory hit:CGPointToVector2f(_loc1) press:MOVE_PRESS];


    // Loop through the all the current touches.  If a touch    
		switch (sceneState) 
		{
			case kSceneState_Running:
			{
				if([ _inventory closed])
				{
					if(useJoypad)
					{	
						if([self checkJoyPadWithLocation:_loc1]) 
						{
							[self moveJoystick:_loc1];
							paused = FALSE;
						}
						else  [self findTargets:CGPointToVector2f(_loc1) rad:30];
					}
					
					if(multi)
					{

							if([self checkJoyPadWithLocation:_loc2])
								
							{
								paused = FALSE;
								[self moveJoystick:_loc2];	
							}
							else  [self findTargets:CGPointToVector2f(_loc2) rad:30];

					}										
				}

			}	

				break;
			default:
				break;
		}
	

}

-(void)tutProceed
{
	
	[line1 release];
	[line2 release];
	[line3 release];
	[line4 release];
	
	switch (tutorialStep) {
		case GAME_SCENE_TUTORIAL_START:
			showNext = NO;
			useJoypad = NO;
			tutPos = Vector2fMake(10, 270);
			tutBackdrop = [[_ResourceManager _spriteSheet32] getSpriteAtX:6 y:0];
			tutArrow = [[Image alloc] initWithImage:@"arrow.png"];
			[tutArrow setPivot:CGPointMake(0,32)];
			[tutArrow setAlpha:0.75];
			//[tutArrow setTextureOffsetY:0];
			tutPointTo = Vector2fMake(390,75);
			showArrow = YES;
			[tutBackdrop setScaleV:Vector2fMake(10, 4)];
			//[tutBackdrop setAlpha:0.75];
			nextBut = [[MenuControl alloc] initWithImage:[[_ResourceManager _spriteSheet32] getSpriteAtXYWH:4 y:3 w:4 h:1] location:Vector2fMake(tutPos.x + 220 , tutPos.y -80 ) centerOfImage:YES type:0];
			line1 = @"OK you are almost done";
			line2 = @"first thing we need to do is load";
			line3 = @"the weapons you just purchased.";
			line4 = @"Click on the yellow inventory tab.";
			tutorialNextStep = GAME_SCENE_TUTORIAL_LOAD_MISSLE;
		break;
		case GAME_SCENE_TUTORIAL_TAP_MISSLE:
			tutPointTo = Vector2fMake(129,96);
			line1 = @"when the inventory appears tap the missile ";
			line2 = @"icon once  ";
			line3 = @"  ";
			line4 = @"  ";
			tutorialNextStep = GAME_SCENE_TUTORIAL_BUY_AMMO;
			break;

		case GAME_SCENE_TUTORIAL_BUY_AMMO:
			tutPointTo = Vector2fMake(201,196);
			tutPos.y = 70;
			line1 = @"When an item is selected in the inventory ";
			line2 = @"its statistics are shown in the blue box";
			line3 = @"above. This also allows you to purchase more";
			line4 = @"Ammo. press BUY AMMO to continue";
			tutorialNextStep = GAME_SCENE_TUTORIAL_LOAD_LASER;
			break;
		case GAME_SCENE_TUTORIAL_LOAD_MISSLE:
			tutPos.y = 270;
			tutPointTo = Vector2fMake(246,31);
			line1 = @"Drag the missile icon from the inventory";
			line2 = @"to the weapon bar. ";
			line3 = @"This loads the weapon";
			line4 = @" ";
			tutorialNextStep =  GAME_SCENE_TUTORIAL_BUY_AMMO;
			break;
		case GAME_SCENE_TUTORIAL_LOAD_LASER:
			tutPos.y = 270;
			tutPointTo = Vector2fMake(198,94);
			line1 = @"next drag the laser";
			line2 = @" ";
			line3 = @" ";
			line4 = @" ";
			tutorialNextStep =  GAME_SCENE_TUTORIAL_CLOSE_INVENTORY;
			break;


		case GAME_SCENE_TUTORIAL_CLOSE_INVENTORY:
			tutPointTo = Vector2fMake(391,140);
			line1 = @"The ammo count shows up by the button.";
			line2 = @"The laser has no count since it is unlimited.";
			line3 = @"Close the inventory by pressing the";
			line4 = @"tab again.";
			tutorialNextStep =  GAME_SCENE_TUTORIAL_START_MOVING;
			break;
		case GAME_SCENE_TUTORIAL_START_MOVING:
			useJoypad = YES;
			showNext=YES;
			tutPointTo = Vector2fMake(47,54);
			[tutBackdrop setAlpha:0.5];
			line1 = @"To start moving press the joystick at the left.";
			line2 = @"During normal gameplay you always keep one finger";
			line3 = @"on the joystick. Whenever you let go it pauses";
			line4 = @"and you can reload your weapons or buy ammo";
			tutorialNextStep =  GAME_SCENE_TUTORIAL_START_SHOOTING ;
			break;
		case GAME_SCENE_TUTORIAL_START_SHOOTING:
			showNext = NO;
			showArrow = YES;
			tutPointTo = Vector2fMake(312,36);
			line1 = @"Alright now lets give you something to shoot at." ;
			line2 = @"Press laser that you loaded on the weapon bar." ;
			line3 = @" ";
			line4 = @" ";
			tutorialNextStep = GAME_SCENE_HINT_TARGET_BADGUYS ;
			break;
		case GAME_SCENE_HINT_TARGET_BADGUYS:	
			showNext = YES;
			showArrow = NO;
			line1 = @"When you blast a block it will release a green coin." ;
			line2 = @"Collect coins to buy upgrades and new weapons." ;
			line3 = @"Also try clicking on badguys to target them for ";
			line4 = @"certain weapons like guided missiles or guardians";
			tutorialNextStep = GAME_SCENE_STOP_TUTORIAL ;
			break;
		case GAME_SCENE_HINT_TILT_CONTROL:
			line1 = @"You can also change the angle of the ship by tilting.";
			line2 = @"The accelerometers are callibrated each time you";
			line3 = @"pause. But you can only get back to the weapon shop ";
			line4 = @"if you destroy the boss.  ";
			tutorialNextStep = GAME_SCENE_HINT_NEW_INVENTORY ;
			break;
		case GAME_SCENE_HINT_NEW_INVENTORY:
			line1 = @"Check the Inventory after you collect tokens.";
			line2 = @"You may find new weapons that are not available";
			line3 = @"in the weapon shop.";
			line4 = @"";
tutorialNextStep = GAME_SCENE_STOP_TUTORIAL  ;
			break;
		case GAME_SCENE_STOP_TUTORIAL:
			[_director setTutorialMode:NO];
			[tutArrow release];
			[nextBut release];
			[tutBackdrop release];
		break;
	}
	
}


- (void)updateWithTouchLocationEnded:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView
{
	UITouch *touch1; 
	UITouch *touch2;
	bool multi = NO;
	
	switch ([touches count])
	{
        case 1:
        { 
            // handle a single touch
            touch1 = [touches anyObject];
            break;
        }
        default:
        {
			// handle multi touch
            touch1 = [[touches allObjects] objectAtIndex:0];
            touch2 = [[touches allObjects] objectAtIndex:1];
            multi = YES;
			//initialDistance = [self distanceBetweenTwoPoints:[touch1 locationInView:self]
			//                                       toPoint:[touch2 locationInView:self]];
            break;
        }
	}
	
	CGPoint _loc1,_loc2;
	_loc1 = touchToScene([touch1 locationInView:aView]);
				
//	printf("click pos %g %g\n",_loc1.x,_loc1.y);
	
	if([_director tutorialMode])
	{
		Vector2f location = CGPointToVector2f(_loc1) ;
		
		if(showNext && tutorialStep != GAME_SCENE_TUTORIAL_START_MOVING)
		{
			if([nextBut updateWithLocation:location])
			{
				tutorialStep = tutorialNextStep;
				[self tutProceed];
			}
		}
		else
		{
		switch (tutorialStep)
		{
			case GAME_SCENE_TUTORIAL_START:
			case GAME_SCENE_TUTORIAL_BUY_AMMO:
			case GAME_SCENE_TUTORIAL_TAP_MISSLE:
			case GAME_SCENE_TUTORIAL_LOAD_MISSLE:
			case GAME_SCENE_TUTORIAL_LOAD_LASER:
			case GAME_SCENE_TUTORIAL_CLOSE_INVENTORY:
	
			{
				if([_inventory hit:location press:END_PRESS])
				{
					tutorialStep = tutorialNextStep;
					[self tutProceed];
				} //check if hit inventory tab
				
			}break;
			
			
			case GAME_SCENE_TUTORIAL_START_MOVING:
			{
				if([self checkJoyPadWithLocation:_loc1]) 
				{
					paused = TRUE;
					showNext = YES;
					showArrow=NO;
				}
				if([nextBut updateWithLocation:location])
				{
					tutorialStep = tutorialNextStep;
					[self tutProceed];
				}
				
			}break;
			
			case GAME_SCENE_TUTORIAL_START_SHOOTING:
			
				if([self checkJoyPadWithLocation:_loc1]) 
				{
					paused = TRUE;
					showNext = YES;
				}
				if([_inventory hit:location press:END_PRESS])
				{
					tutorialStep = tutorialNextStep;
					[self tutProceed];
				}
					
			break;
				
		}
		
		}
		
		
	}
	else
	{
		if(paused)
		{
			[menuBut setBounds:Vector2fMake(128, 64) offset:Vector2fZero ];
			[menuBut	updateWithLocation:CGPointToVector2f(_loc1)];
			
		}
	
		[_inventory hit:CGPointToVector2f(_loc1) press:END_PRESS];
		
		
		if(multi)
		{
			_loc2 = touchToScene([touch2 locationInView:aView]);
		}
		
		if([_inventory closed])
		{
			if([self checkJoyPadWithLocation:_loc1]) 
			{
				if(AUTOPAUSE)paused = TRUE;
			}
			
			if(multi)
			{
				if([self checkJoyPadWithLocation:_loc2]) 
				{
				if(AUTOPAUSE)paused = TRUE;
				}
			}
		
		}
	}
	
	
}
#pragma mark -
#pragma mark Accelerometer

- (void)updateWithAccelerometer:(UIAcceleration*)aAcceleration {
    // Populate the accelerometer array with the filtered accelerometer info
	_accelerometer[0] = aAcceleration.x * 0.1f + _accelerometer[0] * (1.0 - 0.1f);
	_accelerometer[1] = aAcceleration.y * 0.1f + _accelerometer[1] * (1.0 - 0.1f);
	_accelerometer[2] = aAcceleration.z * 0.1f + _accelerometer[2] * (1.0 - 0.1f);
	
	//printf("acc %g   %g\n",_accelerometer[0], _accelerometer[1]);
if(TILT_CONTROL)
{
	float angle = RADIANS_TO_DEGREES(Vector2fangle(Vector2fMake(_accelerometer[0], _accelerometer[1])) );
	
	if(firstAccel)
	{
		firstAccel=NO;
		restAccelAngle = angle;
	}
	if(paused )
		restAccelAngle = angle;
	else
	{
		playerAngle = angle - restAccelAngle;
		if(playerAngle>30) playerAngle=30;
		if(playerAngle<-30)playerAngle=-30;
		

		
		if(LANDSCAPE_MODE)
		{
			[_player set_angle:playerAngle];
		}
		else 
		{
			[_player set_angle:playerAngle ];
		}
	}
}
}

- (float)accelerometerValueForAxis:(uint)aAxis {
    return _accelerometer[aAxis];
}

#pragma mark -
#pragma mark Render scene
-(void)renderGroup:(NSMutableArray*)grp
{
	for(AbstractEntity *entity in grp) {
        [entity render];
    }
}
- (void)render {

	if(imagesLoaded)
	{
		
		
		activatOpenGl();
		
		//glClearColor(0,0,0,1);
	[_stars render];
	
	[self renderGroup:_spaceships];
		

		
		deactivateOpenGl();
		


		activatOpenGl();
		
		
		[self renderGroup:_fragments];
		[self renderGroup:_background];	
		if(BossActive)
		{
			[boss render];
			if(![boss active])
			{
				[[_ResourceManager _font32] setColourFilterRed:1 green:1 blue:1 alpha:1];
				[[_ResourceManager _font32] drawStringAt:CGPointMake(64,MAXH/2+80) text:[NSString stringWithFormat:@"LEVEL %D",[_stats game_level]]];
				[[_ResourceManager _font32] drawStringAt:CGPointMake(128,MAXH/2) text:@"COMPLETE"];
			}
		}
		
		[self renderGroup:_explosions];
		if([_ribbons count]>0)
		{
			
			glEnableClientState( GL_VERTEX_ARRAY);
			glEnableClientState( GL_TEXTURE_COORD_ARRAY );
			glEnableClientState(GL_COLOR_ARRAY);
			//	glTexEnvi( GL_POINT_SPRITE_OES, GL_COORD_REPLACE_OES, GL_TRUE );
			//glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
			glEnable( GL_TEXTURE_2D);
			glEnable(GL_BLEND);
			
			
			//	
			//	glBlendFunc(GL_SRC_ALPHA, GL_ONE);
			glBindTexture(GL_TEXTURE_2D, [ribTexture name]);
			
			[self renderGroup:_ribbons];
			
			
			
			glDisable(GL_BLEND);
			glDisable(GL_TEXTURE_2D);
			
			glDisableClientState(GL_VERTEX_ARRAY);
			glDisableClientState(GL_COLOR_ARRAY);
			glDisableClientState( GL_TEXTURE_COORD_ARRAY );
			
			
		}
		
		[self renderGroup:_weapons];
		[self renderGroup:_coins];
		[self renderGroup:_badguyweapons];
	
		[self renderGroup:_blocks];
		
		[self renderGroup:_walls];
		[self renderGroup:_badguys];



		deactivateOpenGl();
		
		activatOpenGl();
		
		if(gameOverLogo)
		{
			[gameOverLogo renderAtPoint:CGPointMake(MAXW/2, MAXH/2) centerOfImage:YES];	
		}
	
	
		for(AbstractEntity* e in targets)
		{
			[targetImage renderAtPoint:Vector2fToCGPoint([e position]) centerOfImage:YES];	
		}
		
		
			

	
	for(AbstractEntity* g in guardians) [g render];
	[_player render];
	[self renderGroup:_shields];
		
		deactivateOpenGl();
	

		
		/*
		if([_stats graphicsLevel]>8)
		{
			
			if([_explosions count]>0)
			{
				
				glEnableClientState(GL_POINT_SIZE_ARRAY_OES);
				glEnableClientState(GL_VERTEX_ARRAY);
				glEnableClientState(GL_COLOR_ARRAY);
			//	glTexEnvi( GL_POINT_SPRITE_OES, GL_COORD_REPLACE_OES, GL_TRUE );
				glEnable(GL_BLEND);
				glEnable(GL_TEXTURE_2D);
				glEnable(GL_POINT_SPRITE_OES);
				
				glBlendFunc(GL_SRC_ALPHA, GL_ONE);
				
				glBindTexture(GL_TEXTURE_2D, [explodeTexture name]);
				[self renderGroup:_explosions] ;
				
				
				glDisable(GL_POINT_SPRITE_OES);
				glDisable( GL_TEXTURE_2D);
				glDisable(GL_BLEND);
				glDisableClientState(GL_COLOR_ARRAY);
				glDisableClientState(GL_VERTEX_ARRAY);
				glDisableClientState(GL_POINT_SIZE_ARRAY_OES);
				glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
				
			}
			
			
			
			if([_ribbons count]>0)
			{
				
				glEnableClientState( GL_VERTEX_ARRAY);
				glEnableClientState( GL_TEXTURE_COORD_ARRAY );
				glEnableClientState(GL_COLOR_ARRAY);
				//	glTexEnvi( GL_POINT_SPRITE_OES, GL_COORD_REPLACE_OES, GL_TRUE );
				//glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
				glEnable( GL_TEXTURE_2D);
				glEnable(GL_BLEND);
				
				
				//	
				//	glBlendFunc(GL_SRC_ALPHA, GL_ONE);
				glBindTexture(GL_TEXTURE_2D, [ribTexture name]);
				
				[self renderGroup:_ribbons];
				
				
				
				glDisable(GL_BLEND);
				glDisable(GL_TEXTURE_2D);
				
				glDisableClientState(GL_VERTEX_ARRAY);
				glDisableClientState(GL_COLOR_ARRAY);
				glDisableClientState( GL_TEXTURE_COORD_ARRAY );
				
				
			}
			
			
			
			
			
			
		}*/

	//glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_REPLACE);
		
		activatOpenGl();
	[self renderGroup:_foreground];

	//RENDER UI ELEMENTS
	if(showButtons)
	{
		if(buttonFade<0.5f)
		{
			buttonFade+=0.1;
			[_joyPadBall setAlpha:buttonFade];
			[_joyPad setAlpha:buttonFade];
			
		}
		[_joyPadBall renderAtPoint:CGPointMake(joyPadPos.x,joyPadPos.y) centerOfImage:YES];
		[_joyPad renderAtPoint:CGPointMake(_joyPadX,_joyPadY) centerOfImage:YES];
	}
	else
	{

		if(buttonFade>0)
		{
		buttonFade-=0.1;
		[_joyPadBall setAlpha:buttonFade];
		[_joyPad setAlpha:buttonFade];
		[_joyPadBall renderAtPoint:CGPointMake(joyPadPos.x,joyPadPos.y) centerOfImage:YES];
		[_joyPad renderAtPoint:CGPointMake(_joyPadX,_joyPadY) centerOfImage:YES];
		}
	}
		
		if([_inventory closed] && timeSinceStart > 20)
		{
			showButtons = YES;	
		}
		else
		{
			showButtons = NO;	
		}
	
		[_inventory render];
		if(paused)
		{
			if( ![_director tutorialMode])
			{
				[_pauseOverlay renderAtPoint:CGPointMake(MAXW - 100,MAXH - 80) centerOfImage:YES];
			}
			[menuBut render];
		}

		[_titleBar renderAtPoint:CGPointMake(-9, MAXH-60) centerOfImage:NO];
		


		
	AngelCodeFont *font = [_ResourceManager _font16];
		if( [_stats bonusFade] > 0.01 && [_stats bonusPoints]> 10 ) 
		{ 
			[[_ResourceManager _font32] setColourFilterRed:1 green:1 blue:1 alpha:[_stats bonusFade] ];
			[[_ResourceManager _font32] drawStringAt:CGPointMake(60,MAXH-32) text:[NSString stringWithFormat:@"Bonus %d",[_stats bonusPoints] ]];
		}
				
	//[font drawStringAt:CGPointMake(10, MAXH-16) text:[ NSString stringWithFormat:@"FPS: %1.0f", [_director framesPerSecond] ] ];
	[font drawStringAt:CGPointMake(10, MAXH) text:[NSString stringWithFormat:@"Level: %d", [_stats game_level]]];
	[font drawStringAt:CGPointMake(244, MAXH) text:[NSString stringWithFormat:@"Lives: %d", [_player lives] ]];
	[font drawStringAt:CGPointMake(124, MAXH) text:[NSString stringWithFormat:@"Score: %d", [_stats player_Score]]];
	[font drawStringAt:CGPointMake(354, MAXH) text:[NSString stringWithFormat:@"$: %d", [_stats player_coins]]];
	
		//	[font drawStringAt:CGPointMake(140, MAXH) text:[NSString stringWithFormat:@"armour: %d", [_player energy]]];
	//	[font drawStringAt:CGPointMake(220, MAXH) text:[NSString stringWithFormat:@"Shields: %d", [_player shieldEnergy]]];
	
	
		

	
			
//	inventory_tokenImage 
//	inventory_shieldImage 
	


	
	//[shieldBar renderAtPoint:CGPointMake(105,90) centerOfImage:NO];
	//[armBar renderAtPoint:CGPointMake(105,15) centerOfImage:NO];
	//[missileBar renderAtPoint:CGPointMake(245,90) centerOfImage:NO];
	//[laserBar renderAtPoint:CGPointMake(205,90) centerOfImage:NO];


	
	if([_director tutorialMode])
	{
		//[font setColourFilterRed:0 green:0 blue:0 alpha:1];
		[tutBackdrop renderAtPoint:CGPointMake(tutPos.x-8, tutPos.y - 100)  centerOfImage:NO];
		[tutBackdrop setColourFilterRed:0.1 green:0.1 blue:0.1 alpha:1];
		
		if(line1)[font drawStringAt:CGPointMake(tutPos.x, tutPos.y) text:line1];
		if(line2)[font drawStringAt:CGPointMake(tutPos.x, tutPos.y-16) text:line2];
		if(line3)[font drawStringAt:CGPointMake(tutPos.x, tutPos.y-32) text:line3];
		if(line4)[font drawStringAt:CGPointMake(tutPos.x, tutPos.y-48) text:line4];
		if(showNext)
		{
			[nextBut setLocation:Vector2fMake(tutPos.x + 220 , tutPos.y -80 )];
			[nextBut render];
		}
		if(tutorialStep>=GAME_SCENE_TUTORIAL_START_MOVING)[_player render];
		
		if(showArrow)
		{
			Vector2f dir = Vector2fSub(Vector2fMake(MAXW/2, MAXH/2), tutPointTo	);
			float _tutangle = RADIANS_TO_DEGREES(Vector2fangle(dir));
			[tutArrow setRotation:-_tutangle];
			[tutArrow renderAtPoint:Vector2fToCGPoint(tutPointTo) centerOfImage:NO];
		}
		
	}

	}

	
	if(SHOW_BOUNDS)
	{
		drawRec(_joyPadRec);
	//	drawRec(makeRec(Vector2fMake(MAXW/2, MINH/2), MAXW/2, MINH	, 0, 0));
	}
	
deactivateOpenGl();
	

	
}






#pragma mark -
#pragma mark Initialize joypad



#pragma mark -
#pragma mark Initialize sound



- (id)initWithCoder:(NSCoder *)aDecoder {
	[self init];
	
	[_blocks release];
	_blocks = [[aDecoder decodeObjectForKey:@"blocks"] retain];

	playerPos.x = [aDecoder decodeIntForKey:@"playerX"];
	playerPos.y = [aDecoder decodeIntForKey:@"playerY"];
	
	
	/*NSMutableArray *_explosions;
	NSMutableArray *_tempExplosions;
	NSMutableArray *_background;
    NSMutableArray *_weapons;
	NSMutableArray *_badguys;
	NSMutableArray *_coins;
	NSMutableArray *_blocks;
	NSMutableArray *_walls;
	NSMutableArray *_badguyweapons;
	NSMutableArray *targets;
	NSMutableArray *_ribbons;
	NSMutableArray *_shields;
	
	bool BossActive;
	int badGuyCounter;

	NSMutableArray *guardians;
	
	int bonusCount;

	resumed = YES;
	tokenInventory = [[aDecoder decodeObjectForKey:@"inventory"] retain];
	
	buttonToken[0] = [aDecoder decodeIntForKey:@"token1"];
	buttonToken[1] = [aDecoder decodeIntForKey:@"token2"];
	buttonToken[2] = [aDecoder decodeIntForKey:@"token3"];
	buttonToken[3] = [aDecoder decodeIntForKey:@"token4"];
	
	game_level = [aDecoder decodeIntForKey:@"gameLevel"] ;
	player_Score = [aDecoder decodeInt64ForKey:@"score"];
	player_coins = [aDecoder decodeIntForKey:@"coins"] ;
	player_MaxVelocity = [aDecoder decodeFloatForKey:@"player_maxV"] ;
	fxVolume = [aDecoder decodeFloatForKey:@"fxVol"] ;
	musicVolume = [aDecoder decodeFloatForKey:@"musicVol"] ;
	graphicsLevel = [aDecoder decodeIntForKey:@"graphicsLevel"] ;
	*/
	return self;
}





- (void)encodeWithCoder:(NSCoder *)aCoder {
	
	[aCoder encodeObject:_blocks forKey:@"blocks"];
	if(_player)
	{
		[aCoder encodeInt:[_player position].x forKey:@"playerX"];
		[aCoder encodeInt:[_player position].y forKey:@"playerY"];
	}
	else
	{
		[aCoder encodeInt:playerPos.x forKey:@"playerX"];
		[aCoder encodeInt:playerPos.y forKey:@"playerY"];

	}
	
	/*[aCoder encodeInt:buttonToken[0] forKey:@"token1"];
	[aCoder encodeInt:buttonToken[1] forKey:@"token2"];
	[aCoder encodeInt:buttonToken[2] forKey:@"token3"];
	[aCoder encodeInt:buttonToken[3] forKey:@"token4"];
	[aCoder encodeInt:player_coins forKey:@"coins" ];
	[aCoder encodeInt:game_level forKey:@"gameLevel" ];
	[aCoder encodeInt64:player_Score forKey:@"score"];  
	[aCoder encodeFloat:player_MaxVelocity forKey:@"player_maxV"];
	[aCoder encodeInt:graphicsLevel forKey:@"graphicsLevel"];
	[aCoder encodeFloat:fxVolume forKey:@"fxVol"];
	[aCoder encodeFloat:musicVolume forKey:@"musicVol"];*/
	
}


@end


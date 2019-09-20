//
//  Player.m
//  Tutorial1
//
//  Created by Robert Backman on 14/06/2009.
//  Copyright 2009 Robert Backman. All rights reserved.
//

#import "Player.h"
#import "GameScene.h"

#import "Missile.h"
#import "Laser.h"
#import "Guardian.h"
#import "Tokens.h"
#import "Player.h"
#import "Shield.h"

@implementation Player


@synthesize lives;
@synthesize shieldsUp;
@synthesize shieldEnergy;
@synthesize shieldBrightness;
@synthesize exploding;


@synthesize laserEnergy;


- (void)dealloc {
	[image release];
//	[_jetEmitter release];
	//[shieldImage release];
	[shield removeEnergy:300];
	[shield release];
	[animation release];
	[armFullImage release];
	[armEmptyImage release];
	[shieldFullImage release];
	[shieldEmptyImage release];
    [super dealloc];
}

#pragma mark -
#pragma mark Init

- (id)initWithLocation:(Vector2f)aLocation  {
    self = [super init];
	if (self != nil) {
		shield = nil;
		collideBounds = YES;
			energy = 100;
		maxEnergy = energy;
		type = PLAYER;
		laserTop=YES;

		_size.width = 48;
		_size.height = 32;
		width_offset = 0;
		height_offset = 0;
	
		lives = PLAYER_START_LIVES;
		//entity properties
        position = aLocation;
		
		_vel.x=0;
		_vel.y=0;
		_speed = 0.04f;
	
		shieldsUp = NO;
		shieldradius = 40;
		image = [[_resourceManager _spriteSheet64] getSpriteAtX:1 y:0];	
		[image rotate:90];
	
		animation = [[Animation alloc] init];
		exploding=NO;
	
			tailPos = Vector2fMake(-20, 0);
		
		for(int i=0;i<8;i++)
			[animation addFrameWithImage:[[_resourceManager _spriteSheet64] getSpriteAtX:i y:5] delay:0.1f imageScale:0.8f];
		
		for(int i=0;i<3;i++)
			[animation addFrameWithImage:[[_resourceManager _spriteSheet64] getSpriteAtX:i y:6] delay:0.1f imageScale:0.8f];
		
		armFullImage = [[_resourceManager _spriteSheet8] getSpriteAtX:0 y:1];
		armEmptyImage = [[_resourceManager _spriteSheet8] getSpriteAtX:1 y:1];
		shieldFullImage = [[_resourceManager _spriteSheet8] getSpriteAtX:2 y:1];
		shieldEmptyImage = [[_resourceManager _spriteSheet8] getSpriteAtX:3 y:1];
		[armFullImage setPivot:CGPointMake(0,24)];  
		[armFullImage setColourFilterRed:1 green:1 blue:1 alpha:0.3f];
		[armEmptyImage setPivot:CGPointMake(0,24)];  		
		[shieldFullImage setPivot:CGPointMake(0,24)];
		[shieldFullImage setColourFilterRed:1 green:1 blue:1 alpha:0.3f];
		[shieldEmptyImage setPivot:CGPointMake(0,24)];  
		
	//	shieldImage = [[_resourceManager _spriteSheet64] getSpriteAtXYWH:1 y:3 w:2 h:1];
	//	[shieldImage setScaleV:Vector2fMake(0.5, 0.75)];
		
	//	shieldBrightness = 0.1f;
	//	[shieldImage setAlpha:shieldBrightness];

		if(LANDSCAPE_MODE)	_angle = 0;
				
    }
    return self;
}
-(void)removeLife
{
	if(!exploding)
	{
		invincipleCount = 60;
	    exploding = YES;
		[_stats clearBonusPoints];
		[_scene addExplosion:PLAYER_EXPLOSION entity:self];
		[_scene setScrolling:NO];
		[_scene playerDie];
		lives--;

		[shield blowUp];
		shield = nil;
		//[shield release];

	}
	
}
-(void)addEnergy:(int)eng { energy += eng;	if(energy>maxEnergy)energy = maxEnergy; }













-(bool)fireWeap:(Token*) tokn
{

	if(!exploding)
	{
		switch ([tokn token_type])
		{
			case MISSLE_TOKEN:
				[self fireMissile:(MissileToken*)tokn];
			break;
			case LASER_TOKEN:
			{
				[self fireLaser:(LaserToken*)tokn];
			}
			break;
			case GUARDIAN_TOKEN:
				[_scene addGuardian:(GuardianToken*)tokn];
			break;
				
			case SHIELDS_TOKEN:
				[self activateShield:(ShieldToken*)tokn];
			break;
			default:
				break;
		}	
	}
	return YES;
}
-(void)fireMissile:(MissileToken*)tokn
{

	
			

			
			
			

	if([tokn update])
	{
		AbstractEntity* targ = nil;
		
		switch ([tokn	sub_type]) 
		{
			case GUIDED_MISSLE:
			{
				bool stillLooking = YES;
				for(AbstractEntity* targt in [_scene targets])
				{
					if(stillLooking)
					{
						if(![targt beenFiredAt])
						{
							stillLooking = NO;
							targt.beenFiredAt =YES;
							targ =  targt;
						}
					}
				}
				if(targ==nil)
				{
					[tokn addAmo:1];
					return;
				}
			}
				break;
			default:
				break;
		}
		
			//
		[_scene playSound:MISSLE_SOUND pos:position];
			
			Missile* _missile;
			switch ([tokn sub_type]) {
					
				case CLUSTER_MISSLE:
				{
					for(int i=0;i<[tokn clusterNum];i++)
					{
						_missile = [[Missile alloc] initWithLocation:position target:targ  missileToken:tokn];
						[_scene addWeapon:_missile];
						[_missile release];	
					}
				}
					break;
				case STANDARD_MISSLE:
				default:
					_missile = [[Missile alloc] initWithLocation:position target:targ  missileToken:tokn];
					[_scene addWeapon:_missile];
					[_missile release];	
					break;
			}
			
			
		}
		
	}
	
-(void)activateShield:(ShieldToken*)tok
{

	if(!shield && _scene)
	{
		if([tok update])
		{
			[_scene playSound:SHIELD_ACTIVATE_SOUND pos:position];
		shield = [[Shield alloc] initWithParent:self type:PLAYER_SHIELD shieldToken:tok];
		[_scene addShield:shield];
		}
	}
	
}
-(void)fireLaser:(LaserToken*)tokn
  {	

		if([tokn update])
		{

			Vector2f offst;
			if([tokn  sub_type] ==DOUBLE_LASER)
			{
				laserTop = !laserTop;
				
				if(laserTop)
				{
					offst = Vector2fMake(-18	, 13);
				}
				else 
				{
					offst = Vector2fMake(-18, -12);
					//- (NSUInteger)playSoundWithKey:(NSString*)aSoundKey gain:(float)aGain pitch:(float)aPitch location:(CGPoint)aLocation shouldLoop:(BOOL)aLoop sourceID:(NSUInteger)aSourceID
					[_soundManager playSoundWithKey:@"laser" gain:0.2f pitch:1.0f location:CGPointZero shouldLoop:NO sourceID:-1];
				}
				
			}
			
			if([tokn sub_type] ==TRIPLE_LASER)
			{
				laserTop = !laserTop;
				laserCount++;
				switch (laserCount) {
					case 1:
						offst = Vector2fMake(-18	, 13);
						break;
					case 2:
						offst = Vector2fMake(12	, 0);
						[_soundManager playSoundWithKey:@"laser" gain:0.2f pitch:1.0f location:CGPointZero shouldLoop:NO sourceID:-1 ];
						break;
					case 3:
						offst = Vector2fMake(-18, -12);
						laserCount=0;
						break;
					default:
						break;
				}
				
			}
		
			else if([tokn sub_type] == STANDARD_LASER )
			{
				offst = Vector2fMake(12	, 0);
				[_soundManager playSoundWithKey:@"laser" gain:0.2f pitch:1.0f location:CGPointZero shouldLoop:NO sourceID:-1];
			}
			
			offst = Vector2fRotate(offst, _angle);
			Laser* _laser = [[Laser alloc] initWithLocation:Vector2fAdd(position, offst) color:BLUE_LASER token:tokn];
			[_laser setDir:_angle];
			[_scene addWeapon:_laser];
			[_laser release];
			
				//	- (NSUInteger)playSoundWithKey:(NSString*)aSoundKey gain:(ALfloat)aGain pitch:(ALfloat)aPitch location:(Vector2f)aLocation shouldLoop:(bool)aLoop sourceID:(NSUInteger)aSourceID {
			
		}
		
	}
#pragma mark -
#pragma mark Update

-(void)removeEnergy:(int)eng
{
	if(shield)
	{
		[shield removeEnergy:eng];	
	}
	else
	{
		[super removeEnergy:eng];	
	}
}

-(bool)hits:(AbstractEntity*)other
{
		if(invincipleCount > 0)  return NO;
	BOOL hit = NO;
	if(shield)
	{
		if([shield hits:other])
		{
			hit = YES;
		}
	}
	else
	{
		if( [super hits:other])
			hit = YES;
	}
	return hit;
}
-(int)getShieldEnergy
{
	int shieldEn = 0;
	if(shield)
	{
		shieldEn = [shield energy];	
	}
	return shieldEn;
}


- (void)update:(GLfloat)aDelta {
	

	
	if(firstThrough)
	{
		[super update:aDelta];
		_inventory = [_scene _inventory];
		[_scene	addExplosion:PLAYER_TRAIL entity:self];
	}
	if(shield)
	{
		if(![shield alive])
		{
			[shield release];
			shield = nil;
		}
	}
	if(exploding)
	{
	
		if(explodeCount--<=0)
		{
			[_scene resetJoystick];
			position.x=30;
			position.y=MAXH/2.0;
			exploding = NO;
			explodeCount = 60;
			energy = 100;
			
			
		}
	}
	else
	{
		[super update:aDelta];
		if(invincipleCount > 0)
		{
			invincipleCount--;
			if(invincipleCount<=0)invincipleCount=0;
		}
		
		/*if(shieldsUp)
		{
			[shieldImage setScaleV:Vector2fMake(0.5, 0.5 + ABS(_vel.y)/[_stats player_MaxVelocity] )];
		}*/
			
			
	/*	if(shieldBrightness>0.1f)
		{
			shieldBrightness-=0.05f;
			[shieldImage setAlpha:shieldBrightness];
		}*/
		
		if(energy<=0)
		{
			[self removeLife];
		}
		else 
		{
			if(age%5==0)
			{
				energy ++;
				if(energy > maxEnergy) 
					energy = maxEnergy;
			}
			
			position = Vector2fAdd(position, _vel); 

			if(position.x>MAXW) { _vel.x=0; position.x = MAXW; }
			if(position.x<32) { _vel.x=0; position.x=32; }
			if(position.y>MAXH-48) { _vel.y=0; position.y=MAXH-48; }
			if(position.y<MINH+16) { _vel.y = 0; position.y = MINH+16; }
		}
	}
}



#pragma mark -
#pragma mark Render

- (void)render {
	
	
	if(exploding)
	{
		;
	}
	else
	{

		for(int i=0;i<=	180*((float)energy /(float) maxEnergy) ;i+=10)
		{

				[armFullImage setRotation:90 - i];
				[armFullImage renderAtPoint:Vector2fToCGPoint(position) centerOfImage:YES];
			
		}
		
		if(shield)
		{
			for(int i=0;i<=180*((float)[shield energy]/(float)[shield maxEnergy]) ;i+=10)
			{
				[shieldFullImage setRotation:i-270];
				[shieldFullImage renderAtPoint:Vector2fToCGPoint(position) centerOfImage:YES];
			}
		}
		
	//[_jetEmitter renderParticles];

	//[image renderAtPoint:CGPointMake( (int)position.x, (int)position.y ) centerOfImage:TRUE];
	_size.height = 28+abs(_vel.y);
	int frme = 6 + _vel.y*0.5;
	if(frme>10)
		frme=10;
	if(frme<0)
		frme=0;
	[animation setCurrentFrame:frme];
	
	
	[animation renderAtPointAndAngle:CGPointMake( (int)position.x, (int)position.y ) Angle:-_angle imageScale:1.0f ];
	//drawCircle(Vector2fToCGPoint(position), shieldradius, 360, 12, false);
if(DEBUG_COLLISION)[super drawBounds];
	}
 }

@end

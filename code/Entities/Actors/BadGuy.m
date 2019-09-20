//
//  Monk.m
//  Tutorial1
//
//  Created by Robert Backman on 22/06/2009.
//  Copyright 2009 Robert Backman. All rights reserved.
//

#import "BadGuy.h"
#import "GameScene.h"
#import "Laser.h"
#import "BezierCurve.h"

@implementation BadGuy

- (void)dealloc {
       [image release];
	[turretImage release];
    [super dealloc];
}

- (id)initWithLocation:(Vector2f)aLocation  curve:(BezierCurve*)cv startT:(float)st;
{
[self initWithLocation:aLocation ];
	curve = cv;
	curveStartTime = st;
	followCurve=YES;
	_speed = 0.75;
	return self;
	
}
- (id)initWithLocation:(Vector2f)aLocation {
    self = [super init];
	if (self != nil) {

		explode = YES;
		type = BADGUY;
		_size.height = 32;
		_size.width = 32;
	
		energy = [_stats game_BadGuy_Energy];
		fireCount = RANDOM_0_TO_1()*5;
		

		width_offset = 0;
		height_offset = 0;
		fireCount = 0;
		drawTurret = YES;
	
		image = [[_resourceManager _spriteSheet64] getSpriteAtX:0 y:3];
		turretImage =  [[_resourceManager _spriteSheet64] getSpriteAtX:2 y:4];
   
		[image setScale:0.75];
		[turretImage setScale:0.5];
		
		// Set the actors location to the vector location which was passed in
        position.x = aLocation.x;
        position.y = aLocation.y;
        _angle = 0;
        _speed = 2;
		followCurve = NO;
    }
    return self;
}

//bool fire = YES;
-(void)removeEnergy:(int)eng
{
	energy-=eng;	
	if(energy<=0 && explode && active)
	{
		drawTurret = NO;
		//printf	("explde\n");
		[_scene addCoin:position];
		[_scene addExplosion:BADGUY_EXPLOSION entity:self];
		alive = NO;
		active = NO;
	}

}

- (void)update:(GLfloat)aDelta {
    
	if(followCurve)
	{
		if(curveStartTime--<=0)
		{
			position = [curve getPointAt:curveTime];
			
			if(curveTime<0.9)[self pointAt:[curve getPointAt:curveTime+0.1]];
			//	_angle = -RADIANS_TO_DEGREES(Vector2fangle(Vector2fSub(position, [curve getPointAt:t+0.1])));
		
			curveTime+=0.0075*_speed;
			if(curveTime>1) [super destroy];
		}
	}

	[super update:aDelta];

	turretAngle = RADIANS_TO_DEGREES(Vector2fangle(Vector2fSub([((GameScene*)_scene) getPlayerPos], position)));
	
	fireCount++;
	if(fireCount >= [_stats game_Alien_FireRate] && active){
		
		[_scene playSound:BADGUYLASER_SOUND pos:position];
		
		fireCount = 0;
		ls = [[Laser alloc]initWithLocation:position color:YELLOW_LASER ];
		
		[ls setDir:turretAngle ] ;
		[_scene addBadguyWeapon:ls];
		[ls release];
		
	}
	
  // Pick a new angle at
    
 
}

- (void)render {
	
	
	[image setRotation:-_angle];
	
	[image renderAtPoint:CGPointMake( (int)position.x, (int)position.y ) centerOfImage:TRUE];
	
	if(drawTurret)
	{
	[turretImage setRotation:-turretAngle];
	[turretImage renderAtPoint:Vector2fToCGPoint(position) centerOfImage:YES];
	}
if(DEBUG_COLLISION)[super drawBounds];
}
@end


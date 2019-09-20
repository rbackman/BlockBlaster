//
//  Monk.m
//  Tutorial1
//
//  Created by Robert Backman on 22/06/2009.
//  Copyright 2009 Robert Backman. All rights reserved.
//

#import "Guardian.h"
#import "GameScene.h"
#import "Laser.h"
#import "Tokens.h"

@implementation Guardian
@synthesize targetLock;

- (void)dealloc {
       [image release];
	
    [super dealloc];
}


- (id)initWithToken:(Token*)tokn parent:(AbstractEntity*)p
{
    self = [super init];
	if (self != nil) {
		token = tokn;
		_parent = p;
		position = [_parent position];
		type = GUARDIAN;
		_size.width = 16;
		_size.height = 16;		
		energy = [(GuardianToken*)tokn energy];
		orbitDistance = 32;
		parent_offset = Vector2fMake(0	, orbitDistance);
		firing = false;
		fireCount = 0;
		aware = false;
		_size.height = 16;
		_size.width = 16;
	
		image = [[_resourceManager _spriteSheet16] getSpriteAtX:0 y:0];
		_angle = 0;
        _speed = 1;
		_vel.x=-_speed;

		
		exploded = NO;
		explode = YES;
				

    }
    return self;
}
//bool fire = YES;
-(void)rotateTurret:(float)deg{
	

	
	barrelRotation = deg;	
}
-(void)setTarget:(AbstractEntity*)tgt
{
	target = tgt;
	targetLock=YES;
}
- (void)update:(GLfloat)aDelta {
    
	[super update:aDelta];

	targetLock=NO;
	if([[_scene targets] count]>0)
	{
		target = [[_scene targets] objectAtIndex:0];
		if([target active] && [target alive])
		{
			targetLock = YES;
		}
	}
	
	if(targetLock)
	{
		[self pointAt:[target position]];
		[image setRotation:-_angle];
		
		if(fireCount++>[token reloadRate])
		{
			[_scene playSound:LASER_SOUND pos:position];
			fireCount = 0;
			Laser* ls = [[Laser alloc] initWithLocation:position color:BLUE_LASER];
			[ls setDir:_angle];
			[_scene addWeapon:ls];
			[ls release];
		}
	}
	else
	{
		offsetAngle += 2.0f;
		[self rotateOffset:offsetAngle];
		[image setRotation:offsetAngle*3];
	}
	
	
	Vector2f goal = Vector2fAdd(parent_offset, [_parent position] );
	Vector2f dir = Vector2fSub(goal, position);
	_vel = Vector2fMultiply(dir, 0.2);
	
	position = Vector2fAdd(position	, _vel);
	
	//if(position.x<0)alive = NO;
	
	if(energy<=0)
	{
		alive = NO;
		[_scene addExplosion:GUARDIAN_EXPLOSION entity:self];
	}
	

	
    // Pick a new angle at
    
 
}
-(void)rotateOffset:(float)deg
{
	offsetAngle = deg;
	parent_offset = Vector2fMake(0, orbitDistance);
	parent_offset = Vector2fRotate(parent_offset, deg);	
}
- (void)render {
	[image renderAtPoint:Vector2fToCGPoint(position) centerOfImage:TRUE];
	if(DEBUG_COLLISION)[super drawBounds];
	
}
@end


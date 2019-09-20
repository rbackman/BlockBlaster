//
//  AbstractEntity.m
//  BlockBlaster
//
//  Created by Robert Backman on 04/03/2009.
//  Copyright 2009 Robert Backman. All rights reserved.
//

#import "AbstractEntity.h"
#import "ParticleEmitter.h"
#import "Director.h"
#import "DrawingPrimitives.h"
#if SEARCH_ACTIVE
#import "SearchNode.h"
#endif
@implementation AbstractEntity

@synthesize position;
@synthesize zDepth;
@synthesize _vel;
@synthesize image;
@synthesize alive;
@synthesize energy;
@synthesize type;
@synthesize radius;
@synthesize beenFiredAt;
@synthesize collideBounds;
@synthesize explode;
@synthesize active;
@synthesize _size;
@synthesize _angle;
@synthesize beenTargeted;
@synthesize _parent;
@synthesize parent_offset;
@synthesize explodeCount;

@synthesize token;
@synthesize diesOfOldAge;
- (id)init {
	self = [super init];
	if (self != nil) {
		token = nil;
		_parent = nil;

		_director = [Director sharedDirector];
		_soundManager = [SoundManager sharedSoundManager];
		_resourceManager = [ResourceManager sharedResourceManager];
		_stats = [_director _statManager];
		
		collideBounds = NO;
		energy = 5;
		beenTargeted=NO;
		beenFiredAt = NO;
		_size.height = 16;
		_size.width = 16;
		radius = 16;
		width_offset = 0;
		height_offset = 0;
		diesOfOldAge = NO;
		zDepth = 0;
		position = Vector2fMake(0, 0);
		_vel = Vector2fMake(0, 0);
		alive = YES;
		active = YES;
        firstThrough = YES;
		exploded = false;
		_dAngle = 1.0f;
		_angle = 0;
		tailPos = Vector2fMake(-5, 0);
	}
	return self;
}

- (NSComparisonResult)compareZdepth:(id)otherObject {
    return [self zDepth] > [otherObject zDepth] ;
}

-(float)globalAngle
{
	if(_parent!=nil)
	{
		return _angle + [_parent globalAngle];	
	}
	return _angle;
}
-(void)blowUp
{
	if(explode)
	{
		exploded = YES;	
		active = NO;
	}
	else 
	{
		alive = NO;
	}
}

-(Vector2f)getTailPos
{
	return Vector2fAdd(position,Vector2fRotate(tailPos, -_angle));	
}

-(Vector2f)globalPosition
{
	if(_parent!=nil)
	{
		return Vector2fAdd( [_parent globalPosition] , Vector2fRotate( parent_offset , [_parent globalAngle]) );	
	}
	return position;
}



-(void)removeEnergy:(int)eng
{
	energy-=eng;	
	if (energy<=0)
	{
		[self blowUp];
	}
}
- (void)update:(GLfloat)delta 
{
	_stats = [_director _statManager];
	_scene = [_director _gameScene];
	
	if(firstThrough)
	{
		

        firstThrough = NO;
    }
	age++;
	if(diesOfOldAge && age>death) alive = NO;
	
	
}

- (void)render {
	
}

-(void)pointAt:(Vector2f)pt
{
Vector2f dir = Vector2fSub(pt, position	);
_angle = RADIANS_TO_DEGREES(Vector2fangle(dir));
	
}

-(void)destroy
{
	
	alive = NO;	
}
-(void)set_speed:(float)sp
{
	_speed = sp;
	[self setDir:_angle];
}
-(void)setDir:(float)deg{
	_vel = Vector2fMultiply(Vector2fRotate(Vector2fMake(1, 0), deg),_speed);
}

-(void)setImage:(int)i
{
	if(i<[animation getAnimationFrameCount])
		[animation setCurrentFrame:i];
}
-(void)drawBounds
{
	_bounds = makeRec(position, _size.width, _size.height, width_offset, height_offset);
	drawRec(_bounds);
}
-(Bounds)getBounds
{
	return  makeBounds( position, _size );
}

-(bool)hits:(AbstractEntity*)other
{
	bool hit = NO;
	
	if(collideBounds && [other collideBounds] )
	{
		hit = boundsOverlap([self getBounds], [other getBounds]);
	}
	else if(collideBounds && ![other collideBounds])
	{
		hit = ptInBounds([other position], [self getBounds]);
	}
	else if(!collideBounds && [other collideBounds])
	{
		hit = ptInBounds(position, [other getBounds] );
	}
	else
	{
		hit = (Vector2fDistance(position, [other position]) < radius + [other radius]);
	}
	
	return hit;
}


- (id)initWithCoder:(NSCoder *)aDecoder {
	[self init];
	
	
	alive = [aDecoder decodeIntForKey:@"alive"];
	active = [aDecoder decodeBoolForKey:@"active"];
	beenTargeted = [aDecoder decodeBoolForKey:@"beenTargeted"];
	age = [aDecoder decodeIntForKey:@"age"];
	energy = [aDecoder decodeIntForKey:@"energy"];
	explodeCount = [aDecoder decodeIntForKey:@"explodeCount"];
	_angle = [aDecoder decodeFloatForKey:@"angle"];
	_speed = [aDecoder decodeFloatForKey:@"speed"];
	_vel.x = [aDecoder decodeFloatForKey:@"vel_x"];
	_vel.y = [aDecoder decodeFloatForKey:@"vel_y"];
	_accel.x = [aDecoder decodeFloatForKey:@"accel_x"];
	_accel.y = [aDecoder decodeFloatForKey:@"accel_y"];
	position.x = [aDecoder decodeFloatForKey:@"position_x"];
	position.y = [aDecoder decodeFloatForKey:@"position_y"];

	return self;
}





- (void)encodeWithCoder:(NSCoder *)aCoder 
{
	[aCoder encodeInt:alive forKey:@"alive"];
	[aCoder encodeBool:active  forKey:@"active"];
	[aCoder encodeBool:beenTargeted  forKey:@"beenTargeted"];
	[aCoder encodeInt:age  forKey:@"age"];
	[aCoder encodeInt:energy  forKey:@"energy"];
	[aCoder encodeInt:explodeCount  forKey:@"explodeCount"];
	[aCoder encodeFloat:_angle  forKey:@"angle"];
	[aCoder encodeFloat:_speed  forKey:@"speed"];
	[aCoder encodeFloat:_vel.x  forKey:@"vel_x"];
	[aCoder encodeFloat:_vel.y  forKey:@"vel_y"];
	[aCoder encodeFloat:_accel.x  forKey:@"accel_x"];
	[aCoder encodeFloat:_accel.y  forKey:@"accel_y"];

	[aCoder encodeFloat:position.x  forKey:@"position_x"];
	[aCoder encodeFloat:position.y  forKey:@"position_y"];
}


@end

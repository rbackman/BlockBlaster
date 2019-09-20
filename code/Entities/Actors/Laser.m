//
//  Laser.m
//  BlockBlaster
//
//  Created by Robert Backman on 10/15/09.
//  Copyright 2009 UC Merced. All rights reserved.
//

#import "Laser.h"
#import "BezierCurve.h"
#import "Tokens.h"

@implementation Laser

@synthesize reflectLaser;
@synthesize refPos;


- (void)dealloc {
	[image release];
    [super dealloc];
}

-(void)reflect:(Vector2f)pos
{
	reflectLaser = YES;
	refPos = pos;
}
- (id)initWithLocation:(Vector2f)aLocation   color:(int)col token:(LaserToken*)tok 
{
	[self initWithLocation:aLocation  color:col];
	energy = [tok energy];
	_speed = [tok speed];
	return self;
}
- (id)initWithLocation:(Vector2f)aLocation   color:(int)col{
    self = [super init];
	if (self != nil) {
		laserColor = col;
		type = LASER;
		energy =1;
		_size.width = 16;
		_size.height = 16;
		scaleX=0.8f;
		scaleY=0.5f;
		position.x = aLocation.x;
        position.y = aLocation.y;
		reflectLaser = NO;
        _angle = 0.0;
        _speed = 10.0f; 
		scaleEndX = 2.0f;
		scaleEndY = 0.5f;
		tailPos	= Vector2fZero;
		switch(laserColor)
		{
			case YELLOW_BALL: 
				image = [ [_resourceManager _spriteSheet16] getSpriteAtX:3 y:0]; 
				energy = 20; 
				scaleX = 1.0f; 
				scaleY = 1.0f; 		
				scaleEndX = 1.5f;
				scaleEndY = 1.0f;
				_speed = 9.0f; break;
			case RED_LASER: image = [[_resourceManager _spriteSheet16] getSpriteAtX:6 y:0]; energy = 5; break;
			case GREEN_LASER: image = [[_resourceManager _spriteSheet16] getSpriteAtX:7 y:0]; break;	
			case BLUE_LASER: image = [[_resourceManager _spriteSheet16] getSpriteAtX:9 y:0]; energy = 2; break;		
			case YELLOW_LASER: image = [[_resourceManager _spriteSheet16] getSpriteAtX:8 y:0]; energy = 10;  break;	
		}

		
		
        // Set the actors location to the vector location which was passed in

		
    }
    return self;
}
-(void)blowUp
{
[_scene addExplosion:LASER_EXPLOSION entity:self];
	alive = NO;
}
- (void)update:(GLfloat)aDelta {
    [super update:aDelta];
	

	if(scaleX<scaleEndX) scaleX+=0.05;
	if(scaleY<scaleEndY) scaleY+=0.05;
	[image setScaleV:Vector2fMake(scaleX, scaleY)];
   if(active)
   {
	   position = Vector2fAdd(position, _vel);
	    
   }
   else  
	{
		
		alive = NO	;
	}
	if(position.x>MAXW || position.x<-32||position.y<0||position.y>MAXH) alive=NO;

}

-(void)setDir:(float)deg{
	[super setDir:deg];
	[image setRotation:-deg];
}

- (void)render {

		[image renderAtPoint:CGPointMake((int)(position.x), (int)(position.y))  centerOfImage:YES];
	
}


@end

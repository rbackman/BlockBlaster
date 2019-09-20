//
//  Laser.m
//  BlockBlaster
//
//  Created by Robert Backman on 10/15/09.
//  Copyright 2009 UC Merced. All rights reserved.
//

#import "Shield.h"
#import "Tokens.h"
#import "Laser.h"

@implementation Shield
@synthesize shield_type;
@synthesize maxEnergy;

- (void)dealloc {
	[image release];
    [super dealloc];
}


- (id)initWithParent:(AbstractEntity*)prnt type:(int)tp shieldToken:(ShieldToken*)tok 
{
    self = [super init];
	if (self != nil) {
		shield_type = tp;
		token	=	tok;
		_parent = prnt;
		type = SHIELD;
		energy =[tok maxEnergy];
		maxEnergy = energy;
		_size.width = 128;
		_size.height = 64;
		shieldBrightness = 1.0f;
		image = [[_resourceManager _spriteSheet64] getSpriteAtXYWH:1 y:3 w:2 h:1];
		[image setAlpha:shieldBrightness];
		deployedScale = 0.01;
		position = [_parent position];  
		
    }
    return self;
}

- (void)update:(GLfloat)aDelta {
    
	[super update:aDelta];

	if(age%3==0)
	{
		energy--;	
		if(energy<0)
		{
			[self blowUp];
		}
	}
	position = [_parent position];  
	
	if(shieldBrightness>=0.2f)
	 {
		 shieldBrightness-=0.05f;
		[image setAlpha:shieldBrightness];
	 }
	if(deployedScale<0.8)
	{
		deployedScale+=0.08f;	
	}
	[image setScaleV:Vector2fMake(deployedScale, deployedScale + ABS([_parent _vel].y)/[_stats player_MaxVelocity] )];
	[image setRotation:-[_parent _angle]];
	
}
-(void)blowUp
{
	[_scene playSound:SHIELD_DOWN_SOUND pos:position];
	alive = NO;
}

-(bool)hits:(AbstractEntity*)other
{
	BOOL hit = NO;
	if( [super hits:other])
	{
		if(shield_type == PLAYER_SHIELD && [token sub_type] == REFLECTOR_SHIELD)
		{
			if([other type]==LASER)
			{
				[(Laser*)other reflect:position];
				[self removeEnergy:[other energy]];
				if(!alive)
				{
					[self blowUp];
				}
			}
		}
		else
		{
			[self removeEnergy:[other energy]];
			if(!alive)
			{
				[self blowUp];
			}
			hit = YES;
			shieldBrightness = 1.0f;	
		}
	}
	return	hit;
}

- (void)render
{

	[image renderAtPoint:CGPointMake(position.x, position.y) centerOfImage:TRUE];
	if(SHOW_BOUNDS) [super drawBounds];
}


@end

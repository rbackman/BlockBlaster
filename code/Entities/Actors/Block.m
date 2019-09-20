//
//  Monk.m
//  Tutorial1
//
//  Created by Robert Backman on 22/06/2009.
//  Copyright 2009 Robert Backman. All rights reserved.
//

#import "Block.h"
#import "GameScene.h"
#if SEARCH_ACTIVE
#import "SearchNode.h"
#endif
#import "Tokens.h"
#import "fragment.h"

@implementation Block

@synthesize blockType;


@synthesize searchNode;

- (void)dealloc {
    [animation release];
	[image release];

    [super dealloc];
}

- (id)initWithLocation:(Vector2f)aLocation
{
    self = [super init];
	if (self != nil) {
		searchNode = nil;

		type = BLOCK;
		alive = YES;
		_size.width = 28;
		_size.height = 28;
		energy = 1;
		collideBounds = YES;
		exploded = NO;
		width_offset = 0;
		height_offset = 0;
		rotating = NO;
		animated = NO;
		_angle = 0;
        animation = nil; 
		image = nil;
			
		if(RANDOM_0_TO_1()> 0.85)
			{
		
				blockType = EXPLOSIVE_BLOCK;
			}
			else if(RANDOM_0_TO_1()>0.9)
			{
				blockType = INDESTRUCTABLE_BLOCK;
			}
			else
			{
				blockType = COLOR_BLOCK;	
			}
		
				
	
	
        

        // Set the actors location to the vector location which was passed in
        position.x = aLocation.x;
        position.y = aLocation.y;
        _angle = 180;
        _speed = [[_director _statManager] game_scroll_speed];
    }
    return self;
}

- (void)update:(GLfloat)aDelta {
    
    // If we do not have access to the currentscene then grab it
	if(firstThrough)
	{
		[super update:aDelta];
		switch (blockType) {
			case EXPLOSIVE_BLOCK:
				animation = [[Animation alloc] init];
				for(int i=0;i<7;i++)
					[animation addFrameWithImage:[ [_resourceManager _spriteSheet16] getSpriteAtX:i y:5 ] delay:0.1f imageScale:1.5f];
				animated = YES;
				[animation setCurrentFrame:0];
				[animation setRunning:YES];
				[animation setPingPong:NO];
				[animation setRepeat:YES];
				explode = YES;
				break;
			case INDESTRUCTABLE_BLOCK:
				image = [[_resourceManager _spriteSheet16] getSpriteAtX:0 y:1];
				[image setScale:1.5f];
				
				rotating = NO;
				animated = NO;
				energy = 5000;
				break;
				
			case COLOR_BLOCK:
				blockType = COLOR_BLOCK;
				animation = [[Animation alloc] init];
				for(int i=3;i<=6;i++)[animation addFrameWithImage:[[_resourceManager _spriteSheet16] getSpriteAtX:i y:4.0 ] delay:0.5f imageScale:1.0f];
				energy = 3;
				animated = YES;
				[animation setCurrentFrame:0];
				[animation setRunning:NO];
				[animation setPingPong:YES];
				break;
			default:
				break;
		}
	}

		
		position.x -= _speed ; // * cos(DEGREES_TO_RADIANS(_angle));
		
	
    if(position.x<-10)[super destroy];
	
	if(rotating)
	{
		_angle+=_dAngle;
		[image setRotation:_angle];
	}
	
	if(animation) [animation update:aDelta];

//	if(!alive)
	

}



-(void)removeEnergy:(int)eng
{
	energy-=eng; 
	
	if(energy<=0 && explode)
	{
		alive = NO;
		if(!exploded)
		{
			[_scene addExplosion:BLOCK_EXPLOSION entity:self];
			[_scene addCoin:position];
			exploded = true;
		}
	}
	
	if(blockType==COLOR_BLOCK)
	{
	   [animation stepOneFrame];
		if(energy<=0)
		{
			alive = NO;
			
			
			[_scene addBonus:position];	
			[_scene addCoin:position];
			for(int i=0;i<2;i++)
			{
				Fragment *frag = [[Fragment alloc] initWithLocation:position fragPiece:i];
				[_scene addFragment:frag];
				[frag release];
			
			}
		}
			
	}else
	{
		if(energy<=0)
		{
			alive = NO;
		}	
	}
	
#if SEARCH_ACTIVE
	if(!alive || disentegrated || exploded)if(searchNode)[searchNode freeNode];
#endif
}



- (void)render {
	if(!exploded)
	{
		
		if(!animated)[image renderAtPoint:Vector2fToCGPoint(position) centerOfImage:YES];
		else [animation renderAtPoint:Vector2fToCGPoint(position)];
	}
if(DEBUG_COLLISION)[super drawBounds];
}



- (id)initWithCoder:(NSCoder *)aDecoder {
	
	[super initWithCoder:aDecoder];
	[self initWithLocation:position];
	blockType = [aDecoder decodeIntForKey:@"blockType"];
	return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder 
{
	[super encodeWithCoder:aCoder];
	[aCoder encodeInt:blockType forKey:@"blockType"];
}	
@end


//
//  Monk.m
//  Tutorial1
//
//  Created by Robert Backman on 22/06/2009.
//  Copyright 2009 Robert Backman. All rights reserved.
//

#import "wallBlock.h"
#import "GameScene.h"

@implementation wallBlock

@synthesize endBlock;

- (void)dealloc {
    [animation release];
    [super dealloc];
}


- (id)initWithLocation:(Vector2f)aLocation   type:(int)tp
{
    self = [super init];
	if (self != nil) {
		type = BLOCK;
		blockID = tp;
		alive = YES;
		_size.width = 64;
		_size.height = 64;
		energy = 40;
		endBlock = false;
		collideBounds = YES;
		
		if(blockID==FILL_BLOCK) {
			image = [[_resourceManager _spriteSheet64] getSpriteAtX:0 y:2];
		}
		else image = [[_resourceManager _spriteSheet64] getSpriteAtX:0 y:1];	
		switch(blockID)
		{
			case TOP_UP_BLOCK:
			{
				[image setRotation:180];
			}
				
				break;
			case TOP_DOWN_BLOCK:
			{
				[image setRotation:90];
			}
				break;
			case BOT_UP_BLOCK:
			{
			
				[image setRotation:-90];
				
			}
				break;
			case BOT_DOWN_BLOCK:
			{
				;
			}
				break;
			case FILL_BLOCK:
				;//	[image setRotation:((int)(RANDOM_0_TO_1()*4))*90];
				break;
		}
		
	
        

        // Set the actors location to the vector location which was passed in
        position.x = aLocation.x;
        position.y = aLocation.y;
        _angle = 180;
          _speed = [_stats game_scroll_speed];
    }
    return self;
}

- (void)update:(GLfloat)aDelta 
{
    
    // If we do not have access to the currentscene then grab it
	//[super update:aDelta];
	
    
    position.x -= _speed;
   
    if(position.x<-32)[super destroy];
	

	float size = _size.width;
	switch(blockID)
	{
		case TOP_UP_BLOCK:
		{
			
			_tri.a = Vector2fAdd(position, Vector2fMake(-size, size));
			_tri.b  = Vector2fAdd(position, Vector2fMake(size, size));
			_tri.c  = Vector2fAdd(position, Vector2fMake(size, -size));
		}
			
			break;
		case TOP_DOWN_BLOCK:
		{
			_tri.a = Vector2fAdd(position, Vector2fMake(-size, size));
			_tri.b  = Vector2fAdd(position, Vector2fMake(size, size));
			_tri.c  = Vector2fAdd(position, Vector2fMake(-size, -size));
			

		}
			break;
		case BOT_UP_BLOCK:
		{
			_tri.a = Vector2fAdd(position, Vector2fMake(size, size));
			_tri.b  = Vector2fAdd(position, Vector2fMake(size, -size));
			_tri.c  = Vector2fAdd(position, Vector2fMake(-size, -size));
	
			
		}
			break;
		case BOT_DOWN_BLOCK:
		{
			_tri.a = Vector2fAdd(position, Vector2fMake(-size, size));
			_tri.b  = Vector2fAdd(position, Vector2fMake(size, -size));
			_tri.c  = Vector2fAdd(position, Vector2fMake(-size, -size));
			
		}
			break;
		case FILL_BLOCK:
			{
				_rec.a = Vector2fAdd(position, Vector2fMake(-size, size));
				_rec.b  = Vector2fAdd(position, Vector2fMake(size, size));
				_rec.c  = Vector2fAdd(position, Vector2fMake(size, -size));
				_rec.d  = Vector2fAdd(position, Vector2fMake(-size, -size));
			}
			break;
	}
	
	
}
-(Vector2f)getSafePos:(Vector2f)loc
{
	float size = _size.width;
	switch(blockID)
	{
		case FILL_BLOCK:
			if(position.y>MAXH/2.0) {loc.y = position.y-size; if(!endBlock)loc.y-=5;}
			else {loc.y = position.y+size; if(!endBlock)loc.y+=5;}
			break;
		case TOP_UP_BLOCK:
			loc = Vector2fProjectY(_tri.a, _tri.c, loc ); //Vector2fClosestPoint(_tri.a,_tri.c,loc,true);
			break;
		case TOP_DOWN_BLOCK:
			loc = Vector2fProjectY(_tri.c, _tri.b, loc ); //_tri.c,_tri.b,loc,true);
			break;
		case BOT_UP_BLOCK:
			loc = Vector2fProjectY(_tri.c, _tri.a, loc ); //_tri.c,_tri.a,loc,true);
			break;
		case BOT_DOWN_BLOCK:
			loc = Vector2fProjectY(_tri.b, _tri.a, loc ); //_tri.b,_tri.a,loc,true);
		
			break;

	}
	return loc;
}

/*
-(bool)hits:(AbstractEntity*)pt 
{
	return [super hits:pt];
	
	Vector2f ps = position;
	
	if(blockID == FILL_BLOCK)
	{
		if( ptInRec([pt position] , _rec )) return true;
		else return false;
	}
	else
	{
		float dst = Vector2fDistance(ps,[pt position]);
		float size = _size.width;
		if(dst< size)
		{
			if(triRectOverlap(_tri, [pt position] , Vector2fMake(16, 16))) return true;
			else return false;
		}
		
	}
	return false;
		
}*/

- (void)render {
	
	[image renderAtPoint:CGPointMake((int)(position.x), (int)(position.y)) centerOfImage:TRUE];
	
	if(DEBUG_COLLISION)[super drawBounds];
	
}

@end


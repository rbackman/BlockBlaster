//
//  Laser.m
//  BlockBlaster
//
//  Created by Robert Backman on 10/15/09.
//  Copyright 2009 UC Merced. All rights reserved.
//

#import "Coin.h"


@implementation Coin


- (void) dealloc
{
	[image release];
	[_parent release];
	[super dealloc];
}



- (id)initWithLocation:(Vector2f)aLocation   {
    self = [super init];
	if (self != nil) {
	
		type = COIN;
		energy =1;
		_size.width = 16;
		_size.height = 16;
		diesOfOldAge = YES;
		death = 90;
		
		image = [[_resourceManager _spriteSheet16] getSpriteAtX:5 y:0];
	
        // Set the actors location to the vector location which was passed in
        position.x = aLocation.x;
        position.y = aLocation.y;
		_vel = Vector2fMake(RANDOM_MINUS_1_TO_1()*3, RANDOM_MINUS_1_TO_1()*3);
		_accel= Vector2fMake(0, 0);
        _angle = 0.0f;
        _speed = 0.0f; 
		tailPos = Vector2fZero;
    }
    return self;
}

- (void)update:(GLfloat)aDelta {
    
	[super update:aDelta];



	Vector2f dir = Vector2fSub( [_scene getPlayerPos] , position);
	if(Vector2fLength(dir)<32)
	{
		alive = NO;
		[_stats setPlayer_coins:[_stats player_coins]+1];
		[_scene playSound:REWARD_SOUND pos:position];
	}
	else
	{
		
		_angle+=aDelta*100;
		[image setRotation:_angle];
		float dis = Vector2fLength(dir);
		Vector2fNormalize(dir);

		_accel= Vector2fSub(Vector2fMultiply(dir, 0.005 + 1.0f/(dis*dis)), Vector2fMultiply(_vel, 0.05));
	   _vel = Vector2fAdd(_vel, _accel);
		//_vel =  Vector2fMultiply(dir, 0.1f);
	   position = Vector2fAdd(position, _vel);
		
	}
  

}


- (void)render {

		[image renderAtPoint:CGPointMake((int)(position.x), (int)(position.y))  centerOfImage:YES];
	
}


@end

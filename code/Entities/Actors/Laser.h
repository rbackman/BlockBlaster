//
//  Missile.h
//  BlockBlaster
//
//  Created by Robert Backman on 10/15/09.
//  Copyright 2009 UC Merced. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractEntity.h"
@class Laser;
@class LaserToken;

enum
{
	RED_LASER,
	BLUE_LASER,
	GREEN_LASER,
	YELLOW_LASER,
	YELLOW_BALL
};
@interface Laser : AbstractEntity {

	float startDelay;
	int laserColor;
	float scaleX,scaleY, scaleEndX,scaleEndY;
	bool reflectLaser;
	Vector2f refPos;
}
-(void)reflect:(Vector2f)pos;

- (id)initWithLocation:(Vector2f)aLocation   color:(int)col ;
- (id)initWithLocation:(Vector2f)aLocation   color:(int)col token:(LaserToken*)tok ;
@property(nonatomic,readonly)bool reflectLaser;
@property(nonatomic,readonly)Vector2f refPos;

@end

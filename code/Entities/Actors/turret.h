//
//  Monk.h
//  Tutorial1
//
//  Created by Robert Backman on 22/06/2009.
//  Copyright 2009 Robert Backman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractEntity.h"
#import "Laser.h"
@class GameScene;


@interface Turret : AbstractEntity {

	Image* baseImage;
	CFTimeInterval	lastLaserTime;
	float barrelRotation;
	float baseRotation;
	float maxAng,minAng;
	Vector2f gunOffset;
	bool firing;
	bool aware;
	int fireCount;
	int proximity;
	Laser *ls;
    int _tileWidth, _tileHeight;
	bool topTurret;
}

// Designated initializer which allows this actor to be placed on the tilemap using
// tilemap grid locations.
- (id)initWithLocation:(Vector2f)aLocation top:(bool)tp ;
-(void)rotateTurret:(float)deg;
@end

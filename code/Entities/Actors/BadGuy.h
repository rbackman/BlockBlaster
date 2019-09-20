//
//  Monk.h
//  Tutorial1
//
//  Created by Robert Backman on 22/06/2009.
//  Copyright 2009 Robert Backman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractEntity.h"

@class GameScene;
@class Laser;
@class BezierCurve;
@interface BadGuy : AbstractEntity {

	Image* turretImage;
	float turretAngle;
	bool drawTurret;
	BezierCurve* curve;
	float curveTime;
	float curveStartTime;
	bool followCurve;
	
	int fireCount;
	int maxDelay;
	
	int fireDelay;
	Laser *ls;
    int _tileWidth, _tileHeight;

}

// Designated initializer which allows this actor to be placed on the tilemap using
// tilemap grid locations.
- (id)initWithLocation:(Vector2f)aLocation  ;
- (id)initWithLocation:(Vector2f)aLocation   curve:(BezierCurve*)cv startT:(float)st;


@end

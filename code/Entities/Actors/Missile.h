//
//  Missile.h
//  BlockBlaster
//
//  Created by Robert Backman on 10/15/09.
//  Copyright 2009 UC Merced. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractEntity.h"

@class Ribbon;
@class MissileToken;

@interface Missile : AbstractEntity {

	Ribbon* rib;

	int explosionRadius;
	int startDelay;
	int trackDelay;
	AbstractEntity* target;
	Vector2f targetPos;
	bool targetLock;
	bool followCurve;
	BezierCurve* curvePath;
	float curveTime;
}
- (id)initWithLocation:(Vector2f)aLocation target:(AbstractEntity*)trg missileToken:(Token*)tok;

@end

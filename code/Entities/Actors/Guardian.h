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
@class Token;

@interface Guardian : AbstractEntity {
	
	float offsetAngle;
	float orbitDistance;
	float barrelRotation;
	
	int fireCount;
	bool firing;
	bool aware;
	bool targetLock;
	AbstractEntity* target;
}

// Designated initializer which allows this actor to be placed on the tilemap using
// tilemap grid locations.

- (id)initWithToken:(Token*)tokn parent:(AbstractEntity*)p;
-(void)rotateTurret:(float)deg;
-(void)setTarget:(AbstractEntity*)tgt;
-(void)rotateOffset:(float)deg;

@property bool targetLock;
@end

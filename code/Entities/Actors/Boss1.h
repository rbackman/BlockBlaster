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
@class Tenticle;

@class Laser;
@class BezierCurve;
@interface Boss1 : AbstractEntity {

	bool tenticlesDead;
	Image* ball;
	float dangle;
	float extension;
	float maxDAngle;
	float minDAngle;
	float delay;
	float maxDelay;
	bool opening;
	bool changing;
	float openP;
	


	NSMutableArray *tenticles;
	NSMutableArray *guns;
		int tenticlesPerCurve;
	Image* CoreImage;
	Image* tenticleImage;
	Image* gunImage;
	Vector2f eyeOffset;
	float eyeAngle;
	
	Image* eyeImage;
	Vector2f gunPos[4];
	
	bool seeking;
	float seekDelay;
}

// Designated initializer which allows this actor to be placed on the tilemap using
// tilemap grid locations.
@property (nonatomic,readonly) NSMutableArray *guns;
- (id)initWithLocation:(Vector2f)aLocation  ;

-(void)reset;
@end

@interface Tenticle  : AbstractEntity {
	
	Tenticle* child;
	bool endTent;
	int tentNum;
	bool gunAlive;
	
	Vector2f endPos;
	float restAngle;
	bool dir;
	Vector2f target;
	
	CFTimeInterval	lastLaserTime;
	int fireDelay;
	Laser *ls;
	
}
@property(nonatomic,assign)  Tenticle* child;
@property(nonatomic,readwrite) 	bool gunAlive;
@property(nonatomic,readwrite) 	bool endTent;
@property(nonatomic,readonly) 	Vector2f endPos;

// Designated initializer which allows this actor to be placed on the tilemap using
// tilemap grid locations.
- (id)initWithLocation:(Vector2f)ofst angle:(float)ang parent:(AbstractEntity*)p tenticleImage:(Image*)im num:(int)tn;
-(void)setArmAngle:(float)ang;
-(void)blowUp;
@end


@interface BossGun  : AbstractEntity {
	
	Tenticle* tent;
	bool target_Lock;
	float gunAngle;
	
	Vector2f target;
	
	CFTimeInterval	lastLaserTime;
	int fireDelay;
	Laser *ls;
	
}

-(void)setTarget:(Vector2f)tg;

// Designated initializer which allows this actor to be placed on the tilemap using
// tilemap grid locations.
- (id)initWithLocation:(Tenticle*)pt gunImage:(Image*)i;

@end
//
//  Player.h
//  Tutorial1
//
//  Created by Robert Backman on 14/06/2009.
//  Copyright 2009 Robert Backman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractEntity.h"

@class GameScene;
@class Token;
@class MissileToken;
@class LaserToken;
@class GuardianToken;
@class Shield;
@class ShieldToken;

@interface Player : AbstractEntity {

	

	InventoryBar *_inventory;
	int invincipleCount;
	
	int lives;
	int laserCount;

	int laserEnergy;
	int shieldradius;
	bool exploding;
	bool shieldsUp;
	int shieldEnergy;
	float shieldBrightness;

	Image* armFullImage;
	Image* armEmptyImage;
	Image* shieldFullImage;
	Image* shieldEmptyImage;
	
	int maxEnergy;
	
//	ParticleEmitter *_jetEmitter;

	bool laserTop;

	Shield* shield;
	
	
}



@property (nonatomic) int lives;
@property (nonatomic) bool shieldsUp;
@property (nonatomic) int shieldEnergy;

@property (nonatomic) float shieldBrightness;
@property (nonatomic,readonly) bool exploding;
@property (nonatomic) int laserEnergy;
- (id)initWithLocation:(Vector2f)aLocation  ;
-(void)removeLife;

-(bool)fireWeap:(Token*) weap;
-(void)fireMissile:(MissileToken*)tok;
-(void)fireLaser:(LaserToken*)tok;
-(void)activateShield:(ShieldToken*)tok;

-(int)getShieldEnergy;

-(void)addEnergy:(int)eng;

@end

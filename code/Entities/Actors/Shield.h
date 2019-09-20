//
//  Missile.h
//  BlockBlaster
//
//  Created by Robert Backman on 10/15/09.
//  Copyright 2009 UC Merced. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractEntity.h"

@class ShieldToken;

enum shield_types
{
	PLAYER_SHIELD,
	TURRET_SHIELD
};

@interface Shield : AbstractEntity 
{
	int shield_type;
	float shieldBrightness;
	int maxEnergy;
	float deployedScale;
}


- (id)initWithParent:(AbstractEntity*)prnt type:(int)tp shieldToken:(ShieldToken*)tok ;

@property (nonatomic,readonly) int shield_type;
@property (nonatomic,readonly) int maxEnergy;
@end

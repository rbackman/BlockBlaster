//
//  Monk.h
//  Tutorial1
//
//  Created by Robert Backman on 22/06/2009.
//  Copyright 2009 Robert Backman. All rights reserved.
//

#import <UIKit/UIKit.h>


@class GameScene;
@class ParticleEmitter;
@class AbstractEntity;
enum explosion_kinds{
	MISSLE_BASIC_EXPLOSION,
	MISSLE_EXPLOSIVE,
	BOSS_EXPLOSION,
	BLOCK_EXPLOSION,
	BADGUY_EXPLOSION,
	GUARDIAN_EXPLOSION,
	PARTICLE_TRAIL,
	PLAYER_TRAIL,
	PLAYER_EXPLOSION,
	LASER_EXPLOSION
};

@interface Explosion : NSObject
{
	bool alive;
	bool fading;
	float emission;
	int death;
	int age;
	int fadeCount;
	Vector2f position;
	int explosion_type;
	float explosion_radius;
	bool clearsBlocks;

	
	AbstractEntity* parent;
	Vector2f parent_offset;
    ParticleEmitter* emitter;	
}

// Designated initializer which allows this actor to be placed on the tilemap using
// tilemap grid locations.
-(id)initWithParent:(AbstractEntity*)ent type:(int)type;
- (id)initWithLocation:(Vector2f)aLocation type:(int)typ;
- (id)initWithLocation:(Vector2f)aLocation type:(int)typ parent:(AbstractEntity*)prnt offset:(Vector2f)ofst;
- (void)update:(GLfloat)aDelta;
- (void)render;
@property (nonatomic,readwrite)	float explosion_radius;
@property(nonatomic,readonly)bool alive;

@end

//
//  Monk.m
//  Tutorial1
//
//  Created by Robert Backman on 22/06/2009.
//  Copyright 2009 Robert Backman. All rights reserved.
//

#import "AbstractEntity.h"
#import "Explosion.h"
#import "ParticleEmitter.h"
#import "Player.h"
#import "Tokens.h"

@implementation Explosion;
@synthesize alive;
@synthesize explosion_radius;
- (void)dealloc {
	[emitter release];
    [super dealloc];
}
- (id)initWithLocation:(Vector2f)aLocation type:(int)typ
{
	[self initWithLocation:aLocation type:typ parent:nil offset:Vector2fZero];
	return self;
}
-(id)initWithParent:(AbstractEntity*)ent type:(int)type
{
	[self initWithLocation:[ent position] type:type parent:ent offset:[ent getTailPos]];
	return self;
}
- (id)initWithLocation:(Vector2f)aLocation type:(int)typ parent:(AbstractEntity*)prnt offset:(Vector2f)ofst;
{
    self = [super init];
	if (self != nil) 
	{
		parent = prnt;
		parent_offset = ofst;
		explosion_type = typ;
		position = aLocation;
		alive = YES;
		fading = NO;
		death = 10;
		age = 0;
		fadeCount = 5;
		emission = 1.0f;
		emitter = nil;
		explosion_radius = 0;
		clearsBlocks = NO;

		
		//TODO:CLear blocks float rad = ([(MissileToken*)token explosionRadius]*16/(explodeCount+1));
		//[_scene clearBlocks:position r:rad ];	
		
	switch (explosion_type) 
	{
		case PLAYER_TRAIL:
			death = -1;
			
			emitter = [[ParticleEmitter alloc] initParticleEmitterWithImageNamed:@"texture.png"
																		position:[parent position]
															  sourcePositionVariance:Vector2fMake(4, 0)
																			   speed:8.0f
																	   speedVariance:1.0f
																	particleLifeSpan:0.1f	
															particleLifespanVariance:0.1f
																			   angle:-180
																	   angleVariance:5
																			 gravity:Vector2fMake(0.0f, 0.0f)
																		  startColor:Color4fMake(0.0f, 0.0f, 1.0f, 1.0f)
																  startColorVariance:Color4fMake(0.0f, 0.0f, 0.0f, 0.5f)
																		 finishColor:Color4fMake(0.2f, 0.5f, 0.0f, 0.0f)  
																 finishColorVariance:Color4fMake(0.2f, 0.0f, 0.0f, 0.0f)
																		maxParticles:100
																		particleSize:16
																particleSizeVariance:8
																			duration:-1
																	   blendAdditive:YES];   
			break;
		case PARTICLE_TRAIL:
		{
			death = -1;
			fadeCount = -1;
			emitter = [[ParticleEmitter alloc] initParticleEmitterWithImageNamed:@"texture.png"
																	  position:position
														sourcePositionVariance:Vector2fMake(2,0)
																		 speed:0.0f
																 speedVariance:0.0f
															  particleLifeSpan:1.0f	
													  particleLifespanVariance:0.05f
																		 angle: 0.0f
																 angleVariance: 360.0f
																	   gravity:Vector2fMake(-0.05f, 0.0f)
																	startColor:Color4fMake(0.5f, 0.5f, 1.5f, 1.0f)
															startColorVariance:Color4fMake(0.0f, 0.0f, 0.2f, 0.5f)
																   finishColor:Color4fMake(0.0f, 0.0f, 0.0f, 0.0f)  
														   finishColorVariance:Color4fMake(0.0f, 0.0f, 0.0f, 0.0f)
																  maxParticles:30															
																  particleSize:16
														  particleSizeVariance:1
																	  duration:-1
																 blendAdditive:YES];
			[emitter setEmissionRate:3.0f];
		}
		break;
		case MISSLE_BASIC_EXPLOSION:
		{
			emitter = [[ParticleEmitter alloc] initParticleEmitterWithImageNamed:@"smoke.png"
																		  position:position
															sourcePositionVariance:Vector2fMake(0.5, 0.5)
																			 speed:3.0f
																	 speedVariance:1.0f
																  particleLifeSpan:0.8f	
														  particleLifespanVariance:0.03f
																			 angle: 0.0f
																	 angleVariance: 360.0f
																		   gravity:Vector2fMake(-0.05f, 0.0f)
																		startColor:Color4fMake(0.2f, 1.0f, 1.0f, 1.0f)
																startColorVariance:Color4fMake(0.1f, 0.0f, 0.0f, 0.0f)
																	   finishColor:Color4fMake(0.0f, 0.0f, 0.0f, 0.0f)  
															   finishColorVariance:Color4fMake(0.0f, 0.0f, 0.1f, 0.0f)
																	  maxParticles:10
																	  particleSize:40
															  particleSizeVariance:6
																		  duration:-1
																	 blendAdditive:YES];
			death = 16;
			fadeCount = 4;
		}
		break;
		case PLAYER_EXPLOSION:
		{
			emitter = [[ParticleEmitter alloc] initParticleEmitterWithImageNamed:@"smoke.png"
																		position:position
														  sourcePositionVariance:Vector2fMake(0.5, 0.5)
																		   speed:10.0f
																   speedVariance:4.0f
																particleLifeSpan:1.0f	
														particleLifespanVariance:0.03f
																		   angle: 0.0f
																   angleVariance: 360.0f
																		 gravity:Vector2fMake(-0.05f, 0.0f)
																	  startColor:Color4fMake(0.2f, 1.0f, 1.0f, 1.0f)
															  startColorVariance:Color4fMake(0.1f, 0.0f, 0.0f, 0.0f)
																	 finishColor:Color4fMake(0.0f, 0.0f, 0.0f, 0.0f)  
															 finishColorVariance:Color4fMake(0.0f, 0.0f, 0.1f, 0.0f)
																	maxParticles:120
																	particleSize:60
															particleSizeVariance:6
																		duration:-1
																   blendAdditive:YES];
			death = 20;
			fadeCount = 6;
		}
			break;
		case MISSLE_EXPLOSIVE:
		{
			explosion_radius = 10;

			clearsBlocks = YES;
			
		
			
			emitter = [[ParticleEmitter alloc] initParticleEmitterWithImageNamed:@"texture.png"
																		position:position
														  sourcePositionVariance:Vector2fMake(0, 0)
																		   speed:8.0f
																   speedVariance:0.0f
																particleLifeSpan:0.5f	
														particleLifespanVariance:0.03f
																		   angle: 0.0f
																   angleVariance: 360.0f
																		 gravity:Vector2fMake(-0.05f, 0.0f)
																	  startColor:Color4fMake(0.0f, 1.0f, 1.0f, 1.0f)
															  startColorVariance:Color4fMake(0.0f, 0.2f, 0.2f, 0.5f)
																	 finishColor:Color4fMake(0.0f, 0.0f, 1.0f, 0.0f)  
															 finishColorVariance:Color4fMake(0.0f, 0.0f, 1.0f, 0.0f)
																	maxParticles:40
																	particleSize:16
															particleSizeVariance:0
																		duration:-1
																   blendAdditive:YES];
			death = 8;
			fadeCount = 3;
		}
		break;
		case BOSS_EXPLOSION:
		{
			emitter = [[ParticleEmitter alloc] initParticleEmitterWithImageNamed:@"smoke.png"
																		position:position
														  sourcePositionVariance:Vector2fMake(0.5, 0.5)
																		   speed:10.0f
																   speedVariance:4.0f
																particleLifeSpan:1.0f	
														particleLifespanVariance:0.03f
																		   angle: 0.0f
																   angleVariance: 360.0f
																		 gravity:Vector2fMake(-0.05f, 0.0f)
																	  startColor:Color4fMake(1.0f, 0.5f, 0.5f, 1.0f)
															  startColorVariance:Color4fMake(0.1f, 0.0f, 0.0f, 0.0f)
																	 finishColor:Color4fMake(0.0f, 0.0f, 0.0f, 0.0f)  
															 finishColorVariance:Color4fMake(0.0f, 0.0f, 0.1f, 0.0f)
																	maxParticles:120
																	particleSize:60
															particleSizeVariance:6
																		duration:-1
																   blendAdditive:YES];
			death = 24;
			fadeCount = 6;
		}
		break;
		case BLOCK_EXPLOSION:
		{
			explosion_radius = 100;
			clearsBlocks = YES;
	
	
			
			emitter = [[ParticleEmitter alloc] initParticleEmitterWithImageNamed:@"texture.png"
																		  position:position
															sourcePositionVariance:Vector2fMake(0, 0)
																			 speed:8.0f
																	 speedVariance:0.0f
																  particleLifeSpan:0.5f	
														  particleLifespanVariance:0.03f
																			 angle: 0.0f
																	 angleVariance: 360.0f
																		   gravity:Vector2fMake(-0.05f, 0.0f)
																		startColor:Color4fMake(0.0f, 1.0f, 1.0f, 1.0f)
																startColorVariance:Color4fMake(0.0f, 0.2f, 0.2f, 0.5f)
																	   finishColor:Color4fMake(0.0f, 0.0f, 1.0f, 0.0f)  
															   finishColorVariance:Color4fMake(0.0f, 0.0f, 1.0f, 0.0f)
																	  maxParticles:40
																	  particleSize:16
															  particleSizeVariance:0
																		  duration:-1
																	 blendAdditive:YES];
			death = 8;
			fadeCount = 3;
			
		}
		break;
		case BADGUY_EXPLOSION:
		{
			emitter = [[ParticleEmitter alloc] initParticleEmitterWithImageNamed:@"texture.png"
																		  position:position
															sourcePositionVariance:Vector2fMake(0, 0)
																			 speed:8.0f
																	 speedVariance:0.0f
																  particleLifeSpan:0.5f	
														  particleLifespanVariance:0.03f
																			 angle: 0.0f
																	 angleVariance: 360.0f
																		   gravity:Vector2fMake(-0.05f, 0.0f)
																		startColor:Color4fMake(0.0f, 1.0f, 1.0f, 1.0f)
																startColorVariance:Color4fMake(0.0f, 0.2f, 0.2f, 0.5f)
																	   finishColor:Color4fMake(0.0f, 0.0f, 1.0f, 0.0f)  
															   finishColorVariance:Color4fMake(0.0f, 0.0f, 1.0f, 0.0f)
																	  maxParticles:40
																	  particleSize:16
															  particleSizeVariance:0
																		  duration:-1
																	 blendAdditive:YES];
			death = 8;
			fadeCount = 3;
			
		}
			break;
		case GUARDIAN_EXPLOSION:
		{
			death = 15;
			fadeCount = 5;
			emitter = [[ParticleEmitter alloc] initParticleEmitterWithImageNamed:@"texture.png"
																		  position:position
															sourcePositionVariance:Vector2fMake(1, 1)
																			 speed:1.5f
																	 speedVariance:1.0f
																  particleLifeSpan:0.8f	
														  particleLifespanVariance:0.03f
																			 angle: 0.0f
																	 angleVariance: 360.0f
																		   gravity:Vector2fMake(-0.05f, 0.0f)
																		startColor:Color4fMake(1.0f, 0.5f, 0.5f, 1.0f)
																startColorVariance:Color4fMake(0.0f, 0.2f, 0.2f, 0.5f)
																	   finishColor:Color4fMake(0.0f, 0.0f, 1.0f, 0.0f)  
															   finishColorVariance:Color4fMake(0.0f, 0.0f, 1.0f, 0.0f)
																	  maxParticles:30
																	  particleSize:32
															  particleSizeVariance:6
																		  duration:-1
																	 blendAdditive:YES];	
		}
			break;
		case LASER_EXPLOSION:
			death = 6;
			fadeCount = 0;
			emitter = [[ParticleEmitter alloc] initParticleEmitterWithImageNamed:@"texture.png"
																		position:position
														  sourcePositionVariance:Vector2fMake(1, 1)
																		   speed:5.0f
																   speedVariance:1.0f
																particleLifeSpan:0.4f	
														particleLifespanVariance:0.03f
																		   angle:0.0f
																   angleVariance:360.0f
																		 gravity:Vector2fMake(-0.05f, 0.0f)
																	  startColor:Color4fMake(0.0f, 0.0f, 1.0f, 1.0f)
															  startColorVariance:Color4fMake(0.0f, 0.0f, 0.2f, 0.5f)
																	 finishColor:Color4fMake(0.0f, 0.0f, 1.0f, 1.0f)  
															 finishColorVariance:Color4fMake(0.0f, 0.0f, 0.0f, 0.0f)
																	maxParticles:5
																	particleSize:8
															particleSizeVariance:2
																		duration:-1
																   blendAdditive:YES];	
			[emitter setEmissionRate:30];
			
			break;
		default:
			break;
	}	
	}
	return self;
	
}

- (void)update:(GLfloat)aDelta {
    
	
	if(alive)
	{
		if(clearsBlocks)
		{
			[ [[Director sharedDirector] _gameScene] clearBlocks:position r: explosion_radius maxEnergy:4 ];
		}
		
		
		if(parent)
		{
			if(![parent alive] && explosion_type != PLAYER_TRAIL)
			{
				parent = nil;	
				fading = YES;
			}
			else
			{
				[emitter setSourcePosition:[parent getTailPos] ];
			}
		}
		
		if(fading)
		{
			emission -= 1.0f/fadeCount;
			
			if(emission<=0)
			{
				alive = NO;
				emission = 0;
			}
			
			
		}
		
		if(death == -1)
		{
			; //do nothing
		}
		else if(age < death)
		{
			
			age++;
		}
		else 
		{
			[emitter setEmissionRate:0];
			fading = YES;
		}
		
		
		[emitter update:aDelta];
	}
}

- (void)render {
	if(explosion_type==PLAYER_TRAIL)
	{
		if(! [ (Player*)parent exploding ])	[emitter renderParticles];
	}
	else [emitter renderParticles];
		
	
}
@end


//
//  Monk.m
//  Tutorial1
//
//  Created by Robert Backman on 22/06/2009.
//  Copyright 2009 Robert Backman. All rights reserved.
//

#import "turret.h"
#import "GameScene.h"
#import "Laser.h"
#import "Ribbon.h"

@implementation Turret

- (void)dealloc {
       [image release];
	[baseImage release];
    [super dealloc];
}


- (id)initWithLocation:(Vector2f)aLocation top:(bool)tp{
    self = [super init];
	if (self != nil) {
		topTurret = tp;
		type = TURRET;
		_size.width = 64;
		_size.height = 64;
	
		energy = [_stats game_Turret_Energy];

		

		firing = false;
		aware = false;
		proximity = 350;
		_size.width = 32;
		_size.height = 32;
		fireCount = 0;
				_angle = 180;
		
		
		image = [[_resourceManager _spriteSheet64] getSpriteAtX:0 y:7];
		baseImage = [[_resourceManager _spriteSheet64] getSpriteAtX:1 y:7];
		
		        // Set the actors location to the vector location which was passed in

         _speed = [_stats game_scroll_speed];
		
		[image setScale:0.8];
		
        position.x = aLocation.x;
        position.y = aLocation.y;
		_vel.x=-_speed;
		exploded = NO;
		explode = YES;
		explodeCount = 20;
				
		if(topTurret)
		{
			minAng = 0;
			maxAng = 100;
			baseRotation = 180;
			gunOffset = Vector2fMake(0, 8);
			[image setPivot:CGPointMake(8, 32)];
		}
		else
		{
			minAng = -360;
			maxAng = 0;
			//baseRotation = 0;	
			gunOffset = Vector2fMake(0, 8);
			[image setPivot:CGPointMake(8, 8)];
			//[image flipVertically];
			[image setFlipHorizontally:YES];
			barrelRotation = 360;
		}
		[baseImage setRotation:baseRotation];

    }
    return self;
}
//bool fire = YES;
-(void)rotateTurret:(float)deg{
	
//	if(deg>maxAng) deg=maxAng;
//	if(deg<minAng) deg=minAng;
	
	barrelRotation = deg;	
}

- (void)update:(GLfloat)aDelta {
    
	[super update:aDelta];
	
	
	if(firing && !exploded)
	{
		fireCount++;
		if(fireCount>=[_stats game_Turret_FireRate])
		{
			
			[_scene playSound:TURRET_FIRE pos:position];
			fireCount = 0;
			Vector2f fp;
			if(topTurret) 
			{
				fp = Vector2fMake(40,3);
				fp = Vector2fRotate(fp, barrelRotation+baseRotation);
				fp = Vector2fAdd(fp, position);
			}
			else
			{
				fp = Vector2fMake(40, -8);
				fp = Vector2fRotate(fp, 180 + barrelRotation+baseRotation);
				fp = Vector2fAdd(fp, position);
			}
			ls = [[Laser alloc]initWithLocation:fp  color:YELLOW_BALL];
			[_scene addRibbon:ls type:YELLOW_RIB];
			
			if(topTurret)
				[ls setDir:( barrelRotation+baseRotation)];
			else
				[ls setDir: 180+( barrelRotation+baseRotation)];
			[ls setEnergy:50];
			[_scene addBadguyWeapon:ls];
			[ls release];
		}
	}
	Vector2f plyp = [_scene getPlayerPos];
	
//	printf("plyp %g %g\n",plyp.x,plyp.y);
	float dist =  Vector2fLength(Vector2fSub( position,plyp));
	if(dist<proximity)aware = true;
	
	if(aware)
	{
	
	
		if(topTurret)
		{
			float ang = RADIANS_TO_DEGREES(Vector2fangle( Vector2fSub( position,plyp) ))- barrelRotation;
			if(ang<20){firing=true;}
			else firing=false;	
			[self rotateTurret:(barrelRotation + ang/30.0f)];
		}
		else
		{
			float ang = RADIANS_TO_DEGREES(Vector2fangle( Vector2fSub( position,plyp) )) - barrelRotation;
			if(ang<20){firing=true;}
			else firing=false;
			
			[self rotateTurret:(barrelRotation + ang/30.0f)];
		}
	}
	
	position = Vector2fAdd(position	, _vel);
	
	if(position.x<-32)alive = NO;
	
	if(energy<=0)
	{
		alive = NO;
		[_scene addCoin:position];
		[_scene addExplosion:MISSLE_BASIC_EXPLOSION entity:self];
	}

}

- (void)render {
	
	if(topTurret)
		[image setRotation:-(barrelRotation+baseRotation)];
	else
	{
		[image setRotation: 180 -(barrelRotation+baseRotation)];
	}
	
	[image renderAtPoint:CGPointMake(position.x+gunOffset.x,position.y+gunOffset.y) centerOfImage:NO];
	[baseImage renderAtPoint:CGPointMake(position.x, position.y+4) centerOfImage:true ];
	
	
	/*glPushMatrix();

	glTranslatef(position.x, position.y, 0);
	glScalef(0.75, 0.75, 0.75);
	glRotatef(barrelRotation+baseRotation, 0, 0, 1);
	glTranslatef(20, 10, 0);

	if(!exploded)
	{
		[image renderAtPoint:CGPointMake( 0,0  ) centerOfImage:TRUE];
	
	}
	glPopMatrix();
	
	[baseImage renderAtPoint:CGPointMake(position.x, position.y+4) centerOfImage:true ];
		*/
	if(DEBUG_COLLISION)[super drawBounds];
	
}
@end


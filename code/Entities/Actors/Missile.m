//
//  Missile.m
//  BlockBlaster
//
//  Created by Robert Backman on 10/15/09.
//  Copyright 2009 UC Merced. All rights reserved.
//

#import "Missile.h"
#import "BezierCurve.h"

#import "Ribbon.h"
#import "Tokens.h"

@implementation Missile


- (void)dealloc {
	[animation release];
	[curvePath release];
	[image release];
	[target release];
    [super dealloc];

}
bool missile_side = 0;
#pragma mark -
#pragma mark INIT
- (id)initWithLocation:(Vector2f)aLocation target:(AbstractEntity*)trg  missileToken:(Token*)tokn
{
    self = [super init];
	if (self != nil) {
		token = tokn;
		type = MISSLE;
		explosionRadius = [(MissileToken*)token	explosionRadius];
		energy = [token energy];
		_size.width = 48;
		_size.height = 48;
		explodeCount = 0;
		explode = YES;
		diesOfOldAge = YES;
		death = 120;
		target = [trg retain];
		// Set the actors location to the vector location which was passed in
        position.x = aLocation.x;
        position.y = aLocation.y;
        _angle = 0.0;
        _speed = [(MissileToken*)token speed]; //(float)(RANDOM_0_TO_1() * 0.04f);
		//float offset = RANDOM_0_TO_1()*100.0f-50.0f;

		
		if(!target)
		{
			targetPos = Vector2fMake(MAXW+30, MAXH/2);
			targetLock = NO;
		}
		else
		{
			targetPos = [target position];
			targetLock = YES;
		}
		_scene = (GameScene*)[[Director	sharedDirector] currentScene];
		[_scene addRibbon:self type:WHITE_RIBBON];
		firstThrough = YES;
		followCurve = NO;
		//[_scene addExplosion:PARTICLE_TRAIL entity:self];
		trackDelay = 0;
		
		switch([token sub_type])
		{
			
			case EXPLOSIVE_MISSLE:
			{
				image = [[_resourceManager _spriteSheet16] getSpriteAtXYWH:2 y:12 w:2 h:1];
				_angle = [_scene playerAngle];
				_speed = [(MissileToken*)token speed];
				_vel = Vector2fRotate(Vector2fMake(_speed, 0), _angle);
			}
			break;
			case NARROW_RANGE_MISSLE:
			{
				Vector2f c1,c2,c3,c4;
				image = [[_resourceManager _spriteSheet16] getSpriteAtXYWH:0 y:12 w:2 h:1];
				followCurve = YES;
				if(missile_side)
				{
					c1= Vector2fAdd( aLocation,Vector2fMake(-5 , -5 ) );
					c2=Vector2fAdd( aLocation,Vector2fMake(10, -100  )) ;
				}
				else
				{
					c1= Vector2fAdd( aLocation,Vector2fMake(-5 , 5 )) ;
					c2=Vector2fAdd( aLocation,Vector2fMake(10 , 100  )) ;
				}
				missile_side=!missile_side;
				float tx = targetPos.x;
				float dx = abs(aLocation.x - targetPos.x);
				
				//c3= Vector2fAdd( aLocation,Vector2fMake(200, offset)) ;				
				//c4= Vector2fAdd( aLocation,Vector2fMake(300, offset));
				c3= Vector2fMake(tx - dx/3.0f, targetPos.y) ;	
				float ex = tx+dx/3.0f;
				if(ex<MAXW+10)ex=MAXW+10;
				c4= Vector2fMake(ex, targetPos.y);
				
				float dis = Vector2fDistance(targetPos	, aLocation);
				
				_speed = 200/dis;				
				curvePath = [[BezierCurve alloc] initCurveFrom:c1 controlPoint1:c2 controlPoint2:c3 endPoint:c4 segments:12 ];
			}
				break;
			case CLUSTER_MISSLE:
			{
				death = 60;
				trackDelay = 15;
				targetPos.y = targetPos.y + RANDOM_MINUS_1_TO_1()*[(MissileToken*)token trackingAccuracy];
				_accel = Vector2fMake(0,RANDOM_MINUS_1_TO_1()*0.3);
				image = [[_resourceManager _spriteSheet16] getSpriteAtXYWH:6 y:12 w:2 h:1];
				_angle = [_scene playerAngle];
				_speed = [(MissileToken*)token speed];
				_vel = Vector2fRotate(Vector2fMake(_speed, 0), _angle);
			}
				break; 
			case GUIDED_MISSLE:
			{
				image = [[_resourceManager _spriteSheet16] getSpriteAtXYWH:8 y:12 w:2 h:1];
				position = [_scene getPlayerPos];
				
				_angle = [_scene playerAngle];
				_speed = [(MissileToken*)token speed];
				_vel = Vector2fRotate(Vector2fMake(_speed, 0), _angle);
			}
			default:
			{
				image = [[_resourceManager _spriteSheet16] getSpriteAtXYWH:6 y:12 w:2 h:1];
				position = [_scene getPlayerPos];
				
				_angle = [_scene playerAngle];
				_speed = [(MissileToken*)token speed];
				_vel = Vector2fRotate(Vector2fMake(_speed, 0), _angle);
			}break;
		}
			
		[image setScale:0.75f];
		
		startDelay = 0.1f;
    }
    return self;
}
-(void)blowUp
{
	[super blowUp];
	if(target)	target.beenFiredAt = NO;
}
int i=0;
- (void)update:(GLfloat)aDelta {
	

	
    [super update:aDelta];

	if(position.x>MAXW || position.x<0||position.y<0||position.y>MAXH)
		alive=NO;
	
	if(targetLock)
	{
		if(![target active])
		{
			targetLock = NO;
			target = nil;
		}
	}
	
	if(exploded)
	{
		exploded = NO;
		alive = NO;
		if([token sub_type] == EXPLOSIVE_MISSLE) 
			[_scene addExplosion:MISSLE_EXPLOSIVE entity:self radius:explosionRadius];
			else
				[_scene addExplosion:MISSLE_BASIC_EXPLOSION entity:self];
	}
	
   if(active)
   {

	   switch ([token sub_type]) {
			case EXPLOSIVE_MISSLE:
			{
				
				position = Vector2fAdd(position, _vel);
			}	break;
			case NARROW_RANGE_MISSLE:
			{
				Vector2f lastP = position;
				
				curveTime += aDelta * _speed;
				if(curveTime > 1.0f)
				{
					alive = NO;
					return;
				}
				
				
				position = [curvePath getPointAt:curveTime];
				_vel = Vector2fSub(position	, lastP);
			}break;
			case CLUSTER_MISSLE:
			{
				if(trackDelay>=0)
				{
					trackDelay--;
					_vel = Vector2fAdd(_vel, _accel);
					position = Vector2fAdd(position, _vel);
				}
				else
				{

					_accel= Vector2fSub(targetPos, position);
					_accel= Vector2fMultiply(_accel, 0.25/Vector2fLength(_accel));
					_vel = Vector2fMultiply(Vector2fNormalize(Vector2fAdd(_vel, _accel)),_speed) ;
					position = Vector2fAdd(position, _vel);
				}
			}
				break;
			case GUIDED_MISSLE:
			{
				if(targetLock) targetPos = [target position];
				_accel= Vector2fSub(targetPos, position);
				_accel= Vector2fMultiply(_accel, 5/Vector2fLength(_accel));
				_vel = Vector2fMultiply(Vector2fNormalize(Vector2fAdd(_vel, _accel)),_speed) ;
				position = Vector2fAdd(position, _vel);
			}
				break;
			default:
				position = Vector2fAdd(position, _vel);
			break;
		}

	
	   _angle = -RADIANS_TO_DEGREES( Vector2fangle(_vel) );
	

    }
  }





- (void)render {

	if(active)
	{
			[image setRotation:_angle];
			[image renderAtPoint:CGPointMake((int)(position.x), (int)(position.y))  centerOfImage:YES];
	}
}


@end

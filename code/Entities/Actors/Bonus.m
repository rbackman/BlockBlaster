//
//  Monk.m
//  Tutorial1
//
//  Created by Robert Backman on 22/06/2009.
//  Copyright 2009 Robert Backman. All rights reserved.
//

#import "GameScene.h"

#import "Tokens.h"
#import "Bonus.h"
#import "BezierCurve.h"

@implementation Bonus

@synthesize _token;


- (void)dealloc {
    [animation release];
	[image release];
	[curve release];
    [super dealloc];
}

- (id)initWithLocation:(Vector2f)aLocation goal:(Vector2f)goal token:(Token*)tok
{
    self = [super init];
	if (self != nil) {
		scale = 0.1f;
        position.x = aLocation.x;
        position.y = aLocation.y;
        _angle = 180;
        _speed = [[_director _statManager] game_scroll_speed];
		buttonPos = goal;
		
		curve = nil;
		_token = tok;
		type = BONUS;
		alive = YES;
		collideBounds = NO;
		rotating = NO;
		_angle = 0;
		animation = nil;
		image = nil;
		amount = 5;
		animated = YES;
		tailPos = Vector2fZero;
		switch ([_token token_type]) {
			case MISSLE_TOKEN:
				animation = [[Animation alloc] init];
				for(int i = 0;i<11;i++)
					[animation addFrameWithImage:[[_resourceManager _spriteSheet16] getSpriteAtX:i y:9] delay:0.1f imageScale:1.5f];
				
				animated = YES;
				
				rotating = YES;
				_dAngle = 0.5f;
				
			
				break;
			case LASER_TOKEN:
				animation = [[Animation alloc] init];
				for(int i = 0;i<11;i++)
					[animation addFrameWithImage:[[_resourceManager _spriteSheet16] getSpriteAtX:i y:11] delay:0.1f imageScale:1.5f];
				
				animated = YES;
				
			break;
			case SHIELDS_TOKEN:
				
				amount = 2;
				animation = [[Animation alloc] init];
				for(int i = 0;i<11;i++)
					[animation addFrameWithImage:[[_resourceManager _spriteSheet16] getSpriteAtX:i y:10] delay:0.1f imageScale:1.5f];
				
				animated = YES;
				
				
				break;
			case GUARDIAN_TOKEN:
				
				animation = [[Animation alloc] init];
				for(int i = 0;i<11;i++)
					[animation addFrameWithImage:[[_resourceManager _spriteSheet16] getSpriteAtX:i y:8] delay:0.1f imageScale:1.5f];
				
				animated = YES;

				rotating = YES;
				_dAngle = 0.5f;
		
				amount = 3;
				break;
			case ENERGY_TOKEN:
				amount = 30;
				animation = [[Animation alloc] init];
				for(int i=0;i<5;i++)
					[animation addFrameWithImage:[[_resourceManager _spriteSheet16] getSpriteAtX:i y:6] delay:0.1f imageScale:1.5f];
				
				animated = YES;
				break;
			default:
				break;
		}
			
		[animation setScale:scale];
			
			if(animated)
			{
			[animation setCurrentFrame:0];
			[animation setRunning:YES];
			[animation setPingPong:NO];
			[animation setRepeat:YES];
			}


    }
    return self;
}

- (void)update:(GLfloat)aDelta {
    
    // If we do not have access to the currentscene then grab it
	[super update:aDelta];
	
	if(scale<1.0f)
	{
		scale+=0.08;
		[animation setScale:scale];
	}
	if(!homming)
	{
		if(Vector2fLength(Vector2fSub(position, [_scene getPlayerPos]))< 32)
		{
			[_scene playSound:BONUS_START_SOUND pos:position];
			homming = YES;
			[_scene addRibbon:self type:BLUE_RIB];
			Vector2f dis = Vector2fSub(position, buttonPos);
			length = Vector2fLength(dis);
			float dy = ABS(dis.y);
			float dx = ABS(dis.x);
			dy+=dx;
			Vector2f p1,p2;
			if(position.y < 140)
			{
				//NSLog(@"up\n");
				p1 = Vector2fMake(position.x, position.y+dy/2);
			}
			else
			{
			//	NSLog(@"down\n");
				p1 = Vector2fMake(position.x, position.y-dy/2);
			}
			
			p2 =  Vector2fMake(buttonPos.x, buttonPos.y+dy/2);
			
			curve = [[BezierCurve alloc] initCurveFrom:position controlPoint1:p1 controlPoint2:p2 endPoint:buttonPos segments:16];
			curveTime = 0;
		}
	}
		
	if(!homming)
	{
		position.x -= _speed ; // * cos(DEGREES_TO_RADIANS(_angle));
		//position.y += _speed * sin(DEGREES_TO_RADIANS(_angle));
	}
	else
	{
		curveTime+= 5.0f/length;
		if(curveTime>=1)
		{
			[_scene playSound:BONUS_END_SOUND pos:position];
			if([_token token_type]==MISSLE_TOKEN)
				if([_token sub_type]==CLUSTER_MISSLE)
					[_token addAmo:amount*[(MissileToken*)_token clusterNum]];
			
			[_token addAmo:amount];
			alive = NO;

		}
		else
			position = [curve getPointAt:curveTime];
		
			
			
	}
	
    if(position.x<0)[super destroy];
	
	if(rotating)
	{
		_angle+=_dAngle;
		[image setRotation:_angle];
	}
	
	if(animation) [animation update:aDelta];

}



- (void)render {

		if(!animated)[image renderAtPoint:Vector2fToCGPoint(position) centerOfImage:YES];
		else [animation renderAtPoint:Vector2fToCGPoint(position)];
	
	if(SHOW_CURVES)
	{
		if(curve)
		{
			[curve render];
		}
	}
}

@end


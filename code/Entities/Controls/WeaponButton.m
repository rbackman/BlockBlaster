//
//  MenuControl.m
//  BlockBlaster
//
//  Created by Robert Backman on 21/05/2009.
//  Copyright 2009 Robert Backman. All rights reserved.
//
#import <Foundation/Foundation.h>

#import "WeaponButton.h"
#import "Image.h"
#import "Tokens.h"
#import "GameScene.h"
#import "Player.h"

@implementation WeaponButton
@synthesize active;
@synthesize token;
- (id)initWithOffset:(Vector2f)theLocation
{
	[super init];
	toggleMode = NO;
	offset = theLocation;
	location = offset;
	buttonState = WEAPON_EMPTY;
	token = nil;
	controlBounds = makeRec(location , WEAP_BAR_BUTTON_SIZE, WEAP_BAR_BUTTON_SIZE , 0 ,0);
	return self;
}
-(void)move:(float)newX
{
	location.y = offset.y;
	location.x = offset.x + newX;
	controlBounds = makeRec(location , WEAP_BAR_BUTTON_SIZE, WEAP_BAR_BUTTON_SIZE , 0 ,0);
}
-(void)loadToken:(Token*)tk
{
	token = tk;	
	[token setLoaded:YES];
	//if([token token_type]==MISSLE_TOKEN) popBack = YES;
	[token	loadImage:NO];
	buttonState = WEAPON_DISARMED;
	
	toggleMode = YES;
	//if([token token_type]==LASER_TOKEN)
	//{
	//	toggleMode = YES;
	//}
}
-(void)unloadToken
{
	[token setLoaded:NO];
	token = nil;
}
- (bool)hit:(Vector2f)pos press:(int)pressState;
{

	if(ptInRec(pos, controlBounds) )
	{
		switch (pressState) 
		{
			case PRESS_INVENTORY_CLOSED:
				if(token)
				{
					if(![_scene paused]) [[_scene _player] fireWeap:token];
					
					if(toggleMode) 
					{
						if(buttonState == WEAPON_ARMED)buttonState = WEAPON_DISARMED;
						else if(buttonState == WEAPON_DISARMED) buttonState = WEAPON_ARMED;
					}
					else buttonState = WEAPON_ARMED;
				}
				else
				{
					buttonState = WEAPON_EMPTY;
				}
			break;
			case RELEASE_INVENTORY_CLOSED:
				if(token)
				{
					if(!toggleMode) buttonState = WEAPON_DISARMED;
				}
			default:
				break;
		}
		return YES;
	}
	return NO;
}

- (void)update:(float)theDelta 
{
	

	if(buttonState == WEAPON_ARMED && ![_scene paused] )
	{
		[[_scene _player] fireWeap:token];
		if([token empty] && ![token unlimited] ) buttonState == WEAPON_EMPTY;
	}

}

#import "DrawingPrimitives.h"
- (void)render 
{	
	if(firstThrough)
	{
		[super updateWithDelta:1];		
		emptyButton   = [[_ResourceManager _spriteSheet64] getSpriteAtX:3 y:0];
		armedButton    = [[_ResourceManager _spriteSheet64] getSpriteAtX:2 y:0]; 
		disarmedButton = [[_ResourceManager _spriteSheet64] getSpriteAtX:4 y:0]; 
		_scene = (GameScene*)[_director currentScene];
	}	
	
	switch (buttonState) {
		case WEAPON_ARMED:
			[armedButton renderAtPoint:Vector2fToCGPoint(location) centerOfImage:YES];
		break;
		case WEAPON_DISARMED:
			[disarmedButton renderAtPoint:Vector2fToCGPoint(location) centerOfImage:YES];
			break;
		case WEAPON_EMPTY:
			[emptyButton renderAtPoint:Vector2fToCGPoint(location) centerOfImage:YES];
		break;
		
	} 
	if(token)
	{
	[[token gameImage] renderAtPoint:Vector2fToCGPoint(location) centerOfImage:YES];
	

	if(![token unlimited])
		[[_ResourceManager _font16] drawStringAt:CGPointMake(location.x-15,location.y-8) text:[NSString stringWithFormat:@"x%d",[token num]]];
		
	}
	if(SHOW_BOUNDS)[super drawBounds];
}

@end

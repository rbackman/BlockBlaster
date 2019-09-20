//
//  MenuControl.m
//  BlockBlaster
//
//  Created by Robert Backman on 21/05/2009.
//  Copyright 2009 Robert Backman. All rights reserved.
//

#import "TokenControl.h"
#import "DrawingPrimitives.h"
#import "GameScene.h"

@interface TokenControl (Private)
- (void)scaleImage:(GLfloat)delta;
@end


@implementation TokenControl

@synthesize _token;
@synthesize gameImage;
@synthesize shopImage;

@synthesize tokenHit;
@synthesize alphaSpeed;
@synthesize scaleSpeed;
@synthesize  maxScale;
@synthesize hitTime;
@synthesize toggleActive;
@synthesize following;


- (void) dealloc
{
	[_token release];
	[Image release];
	[super dealloc];
}


-(void)set_token:(Token*)tk
{
	_token = tk;
	gameImage = [_token gameImage];
	shopImage = [_token shopImage];

}
- (id)initWithImage:(Image*)tokenImage offset:(Vector2f)ofst token:(Token*)tokn weapShop:(bool)shop
{
	self = [super init];
	if (self != nil) {
		
		weapShop = shop;
		following = NO;
		_token = [tokn retain];
		
		[tokn loadImage:shop];
		gameImage = nil;
		shopImage = nil;
		
		if(shop)shopImage = [_token shopImage];
		else gameImage = [_token gameImage];
//		gameImage = [_token gameImage];
//		shopImage = [_token shopImage];
		
		firstThrough = YES;
		image = tokenImage;
		offset = ofst;
		state = kControl_Idle;
		scale = 1.0f;
		alpha = 1.0f;
		 scaleSpeed = 2.0f;
		alphaSpeed = 1.0f;
		maxScale = 1.0f;
		minScale = 0.6f;
		scaleDown = YES;
		centered = YES;
		
		boundsSize = Vector2fMake(64,64);
		boundsOffset = Vector2fZero;
		controlBounds = makeRec(location ,boundsSize.x ,boundsSize.y ,boundsOffset.x,boundsOffset.y);
		
	}
	return self;
}
-(void)move:(int)newOffset
{
	location = Vector2fMake(offset.x, newOffset+offset.y);
}
-(bool)hit:(Vector2f)pos
{

	controlBounds = makeRec(location ,boundsSize.x ,boundsSize.y ,boundsOffset.x,boundsOffset.y);
	
return ptInRec(pos, controlBounds) ;

}
- (bool)updateWithLocation:(Vector2f)pos {

	if(hitTime<0.3)
	{
		if([self hit:pos])
		{
			if(weapShop)[_scene setActiveToken:_token];
			else; // [[_gamescene _inventory] setActiveToken: self ];
			
			state = kControl_Scaling;
			return YES;
		}
	}
	return NO;
}

- (void)updateWithDelta:(float)theDelta 
{
	if(firstThrough)
	{
		[super updateWithDelta:theDelta];
		
		if(weapShop)
		{
			_scene = [_director _shopScene];
			
		}
		else
		{
			_gamescene = [_director _gameScene];
		}
		
	}

	
	
	
	if(tokenHit)hitTime+=theDelta;
	
	if(weapShop)
	{
	   location = Vector2fMake([_scene tokenOrigin].x+offset.x, [_scene tokenOrigin].y-offset.y);
	}
	
	if(state == kControl_Scaling) 
	{		
		[self scaleImage:theDelta];
	}
	if(state == kControl_Idle) {
		scale = 1.0f;
		alpha = 1.0f;
	}


}


- (void)scaleImage:(GLfloat)delta 
{

	
	if(scaleDown)
	{
		scale -= delta*scaleSpeed;
		
		if(scale <= minScale) 
		{
			scaleDown = NO;
		}
	}
	else
	{
		scale += delta*scaleSpeed;
		
		if(scale >= maxScale) 
		{
			scale = maxScale;
			state = kControl_Selected;
			scaleDown = YES;
		}
	}
		
}


- (void)render:(bool)shop; {
	if(!firstThrough){
		

		[image setScale:scale];
		[image renderAtPoint:Vector2fToCGPoint(location) centerOfImage:centered];	
	
		if(shop && shopImage) 
		{	
			
			[shopImage setScale:scale];
			[shopImage renderAtPoint:Vector2fToCGPoint(location) centerOfImage:centered];	
		}	
		else if(!shop && gameImage)
		{
			[gameImage setScale:scale];
			[gameImage renderAtPoint:Vector2fToCGPoint(location) centerOfImage:centered];	
		}
		if(SHOW_BOUNDS)[super drawBounds];
		
	}
}

@end



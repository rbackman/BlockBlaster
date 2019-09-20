//
//  MenuControl.m
//  BlockBlaster
//
//  Created by Robert Backman on 21/05/2009.
//  Copyright 2009 Robert Backman. All rights reserved.
//
#import <Foundation/Foundation.h>

#import "MenuControl.h"


@interface MenuControl (Private)
- (void)scaleImage:(GLfloat)delta;
@end


@implementation MenuControl

@synthesize alphaSpeed;
@synthesize scaleSpeed;
@synthesize  maxScale;


-(id)initWithImage:(Image*)im location:(Vector2f)theLocation centerOfImage:(bool)theCenter type:(uint)theType
{
	self = [super init];
	if (self != nil) {
	
	image = im;
	location = theLocation;
	centered = theCenter;
	type = theType;
	state = kControl_Idle;
	scale = 1.0f;
	alpha = 1.0f;
	scaleSpeed = 2.0f;
	alphaSpeed = 1.0f;
	maxScale = 1.0f;
	minScale = 0.75;
	scaleDown = YES;
				boundsSize = Vector2fMake(([image imageWidth]*[image scale]), ([image imageHeight]*[image scale]));
	controlBounds = makeRec(location , boundsSize.x, boundsSize.y ,boundsOffset.x,boundsOffset.x);
	}
	return self;
}
- (id)initWithImageNamed:(NSString*)theImageName location:(Vector2f)theLocation centerOfImage:(bool)theCenter type:(uint)theType {
	self = [super init];
	if (self != nil) {
		
		image = [[Image alloc] initWithImage:[NSString stringWithFormat:@"%@",theImageName] filter:GL_LINEAR];
		location = theLocation;
		centered = theCenter;
		type = theType;
		state = kControl_Idle;
		scale = 1.0f;
		alpha = 1.0f;
		 scaleSpeed = 2.0f;
		alphaSpeed = 1.0f;
		maxScale = 1.0f;
		minScale = 0.75;
		scaleDown = YES;
		boundsSize = Vector2fMake(([image imageWidth]*[image scale]), ([image imageHeight]*[image scale]));
		boundsOffset = Vector2fZero;
		controlBounds = makeRec(location ,boundsSize.x ,boundsSize.y ,boundsOffset.x,boundsOffset.y);
		
	}
	return self;
}
-(id)initWithImageSpriteSheet:(uint)x y:(uint)y w:(uint)w h:(uint)h ss:(SpriteSheet*)ss location:(Vector2f)theLocation centerOfImage:(bool)theCenter type:(uint)theType
{
	self = [super init];
	if (self != nil) {
		_director = [Director sharedDirector];
		image = [ss getSpriteAtXYWH:x y:y w:w h:h];
		location = theLocation;
		centered = theCenter;
		type = theType;
		state = kControl_Idle;
		scale = 1.0f;
		alpha = 1.0f;
		scaleSpeed = 1.0f;
		alphaSpeed = 1.0f;
		maxScale = 3.0f;
		 boundsSize = Vector2fMake(([image imageWidth]*[image scale]), ([image imageHeight]*[image scale]));
		boundsOffset = Vector2fZero;
		controlBounds = makeRec(location , boundsSize.x ,boundsSize.y ,boundsOffset.x,boundsOffset.y);
		
			}
	return self;
}
-(void)setScale:(float)sc
{
	maxScale = sc;
	scale = sc;
	[image setScale:sc];
}

-(void)updateBounds
{
	controlBounds = makeRec(location , boundsSize.x ,boundsSize.y ,boundsOffset.x,boundsOffset.y);
}
- (bool)updateWithLocation:(Vector2f)touchPoint {

	if(ptInRec(touchPoint, controlBounds) )
	{
		state = kControl_Scaling;
		return YES;
	}
	return NO;
}

- (void)updateWithDelta:(float)theDelta 
{

	[super updateWithDelta:theDelta];
	[image setAlpha:alpha];
	[image setScale:scale];
	
	if(state == kControl_Scaling) {		
		[self scaleImage:theDelta];
	}
	if(state == kControl_Idle) {
		scale = 1.0f;
		alpha = 1.0f;
		
	}
}

-(bool)selected
{
	return (state == kControl_Selected);
}
-(void)deselect
{
	state = kControl_Idle;	
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

#import "DrawingPrimitives.h"
- (void)render {
	

	[image renderAtPoint:CGPointMake(location.x, location.y) centerOfImage:centered];	
	if(SHOW_BOUNDS)[super drawBounds];
}

@end

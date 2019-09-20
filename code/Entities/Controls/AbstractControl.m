//
//  AbstractControl.m
//  BlockBlaster
//
//  Created by Robert Backman on 29/05/2009.
//  Copyright 2009 Robert Backman. All rights reserved.
//

#import "AbstractControl.h"
#import "StatisticsManager.h"
#import "Director.h"
#import "SoundManager.h"
#import "ResourceManager.h"
#import "DrawingPrimitives.h"

@implementation AbstractControl

@synthesize image;
@synthesize location;
@synthesize centered;
@synthesize state;
@synthesize type;
@synthesize scale;
@synthesize alpha;
@synthesize boundsSize;
@synthesize boundsOffset;

-(id) init
{
	[super init];
	firstThrough = YES;
	_director = [Director sharedDirector];
	_soundManager = [SoundManager sharedSoundManager];
	_ResourceManager = [ResourceManager sharedResourceManager];
	return self;
}
- (bool)updateWithLocation:(Vector2f)theTouchLocation {
	return NO;
}

-(void)setBounds:(Vector2f)bnds offset:(Vector2f)ofst
{
	boundsSize = bnds;
	boundsOffset = ofst;
	controlBounds = makeRec(location , boundsSize.x ,boundsSize.y ,boundsOffset.x,boundsOffset.y);
}
-(void)drawBounds
{

	drawRec(controlBounds);
}
- (void)updateWithDelta:(float)theDelta {
	_stats = [_director _statManager];
	
	if(firstThrough)
	{
		
		
		firstThrough = NO;
	}
}


- (void)render {
	
}

@end

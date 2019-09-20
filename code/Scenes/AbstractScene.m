//
//  AbstractState.m
//  BlockBlaster
//
//  Created by Robert Backman on 01/06/2009.
//  Copyright 2009 Robert Backman. All rights reserved.
//

#import "AbstractScene.h"


@implementation AbstractScene

@synthesize sceneState;
@synthesize sceneAlpha;


-(id)init
{
	[super init];

	_director = [Director sharedDirector];
	_ResourceManager = [ResourceManager sharedResourceManager];
	_soundManager = [SoundManager sharedSoundManager];
	_stats = [_director _statManager];
	firstThrough = YES;
	return self;
}
- (void)updateWithDelta:(GLfloat)aDelta {
	
	if(firstThrough)
	{
				_stats = [_director _statManager];	
		firstThrough = NO;
	}
}


- (void)updateWithTouchLocationBegan:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView {
}

- (void)updateWithTouchLocationMoved:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView {
}

- (void)updateWithTouchLocationEnded:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView {
}

- (void)updateWithAccelerometer:(UIAcceleration*)aAcceleration {
}

- (void)transitionToSceneWithKey:(NSString*)aKey {
}

- (void)render {
}
-(void)loadImages{
	
}
-(void)unloadImages
{
	
}

@end
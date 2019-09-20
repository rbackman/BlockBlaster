//
//  SettingsScene.m
//  Tutorial1
//
//  Created by Robert Backman on 07/06/2009.
//  Copyright 2009 Robert Backman. All rights reserved.
//

#import "SettingsScene.h"
#import "SliderControl.h"
#import "MenuControl.h"

@implementation SettingsScene

- (id)init {
	
	if(self = [super init]) {

		
        _sceneFadeSpeed = 3.0f;
	
		firstThrough = YES;
        // Init anglecode font and message
		
	[graphicsLevel setIntMode:YES];
	}
	
	return self;
}

-(void)loadImages
{
	imagesLoaded = YES;
	_stats = [_director _statManager];
	if(fxVolume)[fxVolume release];	
		fxVolume = [[SliderControl alloc] initWithLocation:Vector2fMake(MAXW/2, MAXH-110) name:@"FX Vol" min:0 max:1 start:[_stats fxVolume]];
	if(musicVolume)[musicVolume release]; 
		musicVolume = [[SliderControl alloc] initWithLocation:Vector2fMake(MAXW/2, MAXH-200) name:@"MUSIC" min:0 max:1 start:[_stats musicVolume]];
	if(graphicsLevel)[graphicsLevel release]; 
		graphicsLevel = [[SliderControl alloc] initWithLocation:Vector2fMake(MAXW/2, MAXH-290) name:@"GRAPHICS" min:0 max:10 start:[_stats graphicsLevel]];
	
	[graphicsLevel setIntMode:YES];
	[musicVolume updateWithDelta:1];
	[fxVolume updateWithDelta:1];
	[graphicsLevel updateWithDelta:1];
	
	//_velSensitivity = [[SliderControl alloc] initWithLocation:<#(Vector2f)theLocation#> name:<#(NSString *)nm#> min:<#(float)min#> max:<#(float)max#>
	exitControl = [[MenuControl alloc] initWithImage:[[Image alloc] initWithImage:@"Exit.png"] location:Vector2fMake(MAXW-24, MAXH/2) centerOfImage:YES type:1];
	
}
-(void)unloadImages
{
	imagesLoaded = NO;
	[fxVolume release]; fxVolume = nil;
	[musicVolume release]; musicVolume = nil;
	[graphicsLevel release];graphicsLevel = nil;
	[exitControl release]; exitControl = nil;
}

- (void)updateWithDelta:(GLfloat)aDelta {
    switch (sceneState) {
		case kSceneState_Running:
		if(firstThrough)
		{
			[super updateWithDelta:aDelta];
			firstThrough = NO;
		}
			[exitControl updateWithDelta:aDelta];

			break;
			
		case kSceneState_TransitionOut:
			sceneAlpha-= _sceneFadeSpeed * aDelta;
            [_director setGlobalAlpha:sceneAlpha];
			if(sceneAlpha <= 0.0f){
				sceneAlpha = 0;
                // If the scene being transitioned to does not exist then transition
                // this scene back in
				if(![_director setCurrentSceneToSceneWithKey:nextSceneKey])
				{
                    sceneState = kSceneState_TransitionIn;
				}
				else{
					[_director saveGameState];
					[_ResourceManager unloadSettingsImages];
					[self unloadImages];
					sceneState = kSceneState_TransitionIn;
				}
			}
			break;
			
		case kSceneState_TransitionIn:
			if(sceneAlpha==0)
			{
				[_ResourceManager loadSettingsImages];
				[self loadImages];	
			}
			sceneAlpha += _sceneFadeSpeed * aDelta;
            [_director setGlobalAlpha:sceneAlpha];
			if(sceneAlpha >= 1.0f) {
				sceneState = kSceneState_Running;
			}
			break;
		default:
			break;
	}
    
}

- (void)updateWithTouchLocationMoved:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView {
    UITouch *touch = [[event touchesForView:aView] anyObject];
	Vector2f location;
	location = CGPointToVector2f(touchToScene([touch locationInView:aView]));
	
	
	if([fxVolume updateWithLocation:location press:MOVE_PRESS])
	{
	
		[_soundManager setFxVolume:[ fxVolume output ]];
		[_stats setFxVolume:[ fxVolume output ]];
	}
	
	if([musicVolume updateWithLocation:location press:MOVE_PRESS])
	{
		[_soundManager setMusicVolume:[musicVolume output]];
		[_stats setMusicVolume:[musicVolume output]];
	}
	
	
	if([graphicsLevel updateWithLocation:location press:MOVE_PRESS])
	{
		[_stats setGraphicsLevel:(int)[graphicsLevel output]];
	}
	
	

}

- (void)updateWithTouchLocationBegan:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView {
	
	UITouch *touch1; 
	UITouch *touch2;
	bool multi = NO;
		switch ([touches count]) {
        case 1:
        {
            // handle a single touch
            touch1 = [touches anyObject];
			break;
        }
        default:
        {
			
            // handle multi touch
            touch1 = [[touches allObjects] objectAtIndex:0];
            touch2 = [[touches allObjects] objectAtIndex:1];
            multi = YES;
			//initialDistance = [self distanceBetweenTwoPoints:[touch1 locationInView:self]
			//                                       toPoint:[touch2 locationInView:self]];
            break;
        }
	}
	
	Vector2f _loc1,_loc2;
	_loc1 = CGPointToVector2f(touchToScene([touch1 locationInView:aView]));
	
	if(multi)
	{
		_loc2 =  CGPointToVector2f(touchToScene([touch2 locationInView:aView]));
	}
	[exitControl setBounds:Vector2fMake(128, 128) offset:Vector2fZero];
	
	if([exitControl updateWithLocation:_loc1])
	{
			nextSceneKey = @"menu";
		    sceneState = kSceneState_TransitionOut;
	}
	if([fxVolume updateWithLocation:_loc1 press:BEGAN_PRESS])
	{
		[_soundManager setFxVolume:[ fxVolume output ]];
	}
	if([musicVolume updateWithLocation:_loc1 press:BEGAN_PRESS])
	{
		[_soundManager setMusicVolume:[musicVolume output]];
	}
	[graphicsLevel updateWithLocation:_loc1 press:BEGAN_PRESS];
	
}


- (void)render {
	if(imagesLoaded)
	{
		activatOpenGl();
		//[font setColourFilterRed:0 green:0 blue:1 alpha:1];
		//[font drawStringAt:CGPointMake(20, 450) text:@"Settings"];
		[fxVolume render];
		[musicVolume render];
		[graphicsLevel render];
		if(exitControl)[exitControl render];
		deactivateOpenGl();
	}
}

@end

//
//  SettingsScene.m
//  Tutorial1
//
//  Created by Robert Backman on 07/06/2009.
//  Copyright 2009 Robert Backman. All rights reserved.
//

#import "HighScoreScene.h"
#import "MenuControl.h"
#import "StatisticsManager.h"

@implementation HighScoreScene

- (id)init {
	
	if(self = [super init]) {

		imagesLoaded = NO;
        _sceneFadeSpeed = 3.0f;
		player_name = @"Player";
		firstThrough = YES;
		inputMode = NO;
		_textField = nil;
		NewHighScore = nil;
	}
	
	return self;
}

-(void)takeInput
{
	[super updateWithDelta:1];
//	if([_stats isHighScore])
//	{
	inputMode = YES;
	NewHighScore = @"New High Score";
	
	if(_textField)[_textField release];
	_textField = [[UITextField alloc] initWithFrame:CGRectMake(200, 200, 200, 48)];
	CGAffineTransform rotation = CGAffineTransformRotate(CGAffineTransformIdentity, 3.1415f/2.0f );
	CGAffineTransform translation = CGAffineTransformTranslate(rotation, 0, 130);
	
	_textField.transform = translation; //rotation; 
	[_textField setDelegate:self];
	[_textField setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:1.0]];
	[_textField setTextColor:[UIColor blackColor]];
	[_textField setFont:[UIFont fontWithName:kFontName size:46 ]];
	[_textField setPlaceholder:@"Tap to edit"];	
	[_textField setText:player_name ];
	[_textField setClearsOnBeginEditing:YES];
	[_director addTextField:_textField];
//	}
}
-(void)loadImages
{
	if(!imagesLoaded)
	{
	imagesLoaded = YES;



	
	//_velSensitivity = [[SliderControl alloc] initWithLocation:<#(Vector2f)theLocation#> name:<#(NSString *)nm#> min:<#(float)min#> max:<#(float)max#>
	exitControl = [[MenuControl alloc] initWithImage:[[_ResourceManager _menuSheet] getSpriteAtXYWH:6 y:0 w:2 h:4] location:Vector2fMake(MAXW-24, MAXH/2) centerOfImage:YES type:1];
	}
}
-(void)unloadImages
{
	imagesLoaded = NO;
	
	//Dismiss text field
	[exitControl release];
}

- (void)updateWithDelta:(GLfloat)aDelta {
	

	[super updateWithDelta:aDelta];
		
    switch (sceneState) {
		case kSceneState_Running:

	if(!inputMode)[exitControl updateWithDelta:aDelta];

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
					[_ResourceManager unloadHighScoreImages];
					[self unloadImages];
					sceneState = kSceneState_TransitionIn;
				}
			}
			break;
			
		case kSceneState_TransitionIn:
			if(sceneAlpha==0)
			{
				[_ResourceManager loadHighScoreImages];
				[_stats readHighScores];
				[self loadImages];	
				//[self takeInput];
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
	if(!inputMode)
	{	
		if(exitControl) 
		{
			[exitControl setBounds:Vector2fMake(128, 128) offset:Vector2fZero];
		
				if([exitControl updateWithLocation:_loc1])
				{
						nextSceneKey = @"menu";
						sceneState = kSceneState_TransitionOut;
				}
			
		}
	}
		
	
}

// Saves the user name and score after the user enters it in the provied text field. 
- (void)textFieldDidEndEditing:(UITextField*)textField {
	//Save name
	//[[NSUserDefaults standardUserDefaults] setObject:[textField text] forKey:kUserNameDefaultKey];
	[_stats newHighScore:player_name];
	[_stats saveHighScores];
	_stats.player_Score = 0;
	[_textField endEditing:YES];
	[_textField removeFromSuperview];
//	[_textField release];
	NewHighScore = nil;
	inputMode=NO;
	
	//Save the score
	
}

// Terminates the editing session
- (BOOL)textFieldShouldReturn:(UITextField*)textField {
	//Terminate editing
	player_name = [[textField text] retain];
	
		[textField resignFirstResponder];
	
	return YES;
}

- (void)render {
	if(imagesLoaded)
	{
		activatOpenGl();
		
		

		
		if(!inputMode)
		{
			[exitControl render];
				if(_stats)
				{
					if([_stats highScores])
					{
						int i = 8 - [[_stats highScores] count];
						
						for(HighScore* sc in [_stats highScores])
						{
							i++;
							[[_ResourceManager _font24] drawStringAt:CGPointMake(30, 20+i*28) text:[sc name]	];
							[[_ResourceManager _font24] drawStringAt:CGPointMake(250, 20+i*28) text:[NSString stringWithFormat:@"%d",[sc score]]];	
							//[[_ResourceManager _font32] drawStringAt:CGPointMake(100, 250-i*32) text:[[sc date] description]	];
						}
					}
				}
		}
		if(NewHighScore)[[_ResourceManager _font32] drawStringAt:CGPointMake(5, MAXH-32 )text:NewHighScore];
		
		deactivateOpenGl();
	}
}

@end

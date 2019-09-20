//
//  MenuState.m
//  BlockBlaster
//
//  Created by Robert Backman on 31/05/2009.
//  Copyright 2009 Robert Backman. All rights reserved.
//

#import "MenuScene.h"

@interface MenuScene (Private)
- (void)initMenuItems;
@end

@implementation MenuScene


- (id)init {
	
	if(self = [super init]) {
		imagesLoaded = NO;
		_director = [Director sharedDirector];
		_ResourceManager = [ResourceManager sharedResourceManager];
		_soundManager = [SoundManager sharedSoundManager];
        
        _sceneFadeSpeed = 3.0f;
        sceneAlpha = 0.0f;
        _origin = CGPointMake(0, 0);
        [_director setGlobalAlpha:sceneAlpha];
			
	
		//[menuBackground setRotation:90];
		[self setSceneState:kSceneState_TransitionIn];
		nextSceneKey = nil;
	

		
	}
	return self;
}

-(void)unloadImages
{
	imagesLoaded = NO;
	[menuBackground release];
	[menuEntities removeAllObjects];
	[menuEntities release];
	[_ResourceManager unloadMenuImages];
}
-(void)loadImages
{
	[_ResourceManager loadMenuImages];
	imagesLoaded = YES;
	[self initMenuItems];
	
	menuBackground = [[Image alloc] initWithImage:@"MenuBackground.png"];
	[menuBackground setRotation:-90];
	//[menuBackground setScaleV:Vector2fMake(1, 1.25)];
	
}
- (void)initMenuItems 
{
	menuEntities = [[NSMutableArray alloc] init];
	
	MenuControl *menuEntity;
	SpriteSheet* menuSheet = [_ResourceManager _menuSheet];
	
	Vector2f menuPos = Vector2fMake(MAXW-100, MAXH - 110);
	
	menuEntity = [[MenuControl alloc] initWithImage:[menuSheet getSpriteAtXYWH:0 y:0 w:6 h:2] location:menuPos centerOfImage:YES type:kControlType_NewGame];
	[menuEntity setBounds:Vector2fMake(3*64, 48) offset:Vector2fZero];
	[menuEntities addObject:menuEntity];
	[menuEntity release];
	
	
	menuPos.y = menuPos.y - 50;
	
	menuEntity = [[MenuControl alloc] initWithImage:[menuSheet getSpriteAtXYWH:0 y:2 w:6 h:2] location:menuPos centerOfImage:YES type:kControlType_Resume];
	[menuEntity setBounds:Vector2fMake(3*64, 48) offset:Vector2fZero];
	[menuEntities addObject:menuEntity];
	[menuEntity release];
	
	
	menuPos.y = menuPos.y - 40;
	
/*	menuEntity = [[MenuControl alloc] initWithImage:[menuSheet getSpriteAtXYWH:0 y:7 w:6 h:1] location:menuPos centerOfImage:YES type:kControlType_quickPlay];
	[menuEntities addObject:menuEntity];
	[menuEntity release];
	
	
	
	
	menuPos.y = menuPos.y - 36;*/
	
	menuEntity = [[MenuControl alloc] initWithImage:[menuSheet getSpriteAtXYWH:0 y:4 w:6 h:1] location:menuPos centerOfImage:YES type:kControlType_Tutorial];
	[menuEntities addObject:menuEntity];
	[menuEntity release];
	
	menuPos.y = menuPos.y - 36;
	menuEntity = [[MenuControl alloc] initWithImage:[menuSheet getSpriteAtXYWH:0 y:6 w:6 h:1] location:menuPos centerOfImage:YES type:kControlType_HighScores];
	[menuEntities addObject:menuEntity];
	[menuEntity release];
	
	menuPos.y = menuPos.y - 36;
	
	menuEntity = [[MenuControl alloc] initWithImage:[menuSheet getSpriteAtXYWH:0 y:5 w:6 h:1] location:menuPos centerOfImage:YES type:kControlType_Settings];
	[menuEntities addObject:menuEntity];
	[menuEntity release];
	
	

	
	

	
	/*for(MenuControl* m in menuEntities)
		{
			[m setBounds:Vector2fMake(180, 52) offset:Vector2fZero];
		}
	 */
}

- (void)updateWithDelta:(GLfloat)aDelta {

	[super updateWithDelta:aDelta];
	
	switch (sceneState) {
		case kSceneState_Running:
			{
				for(AbstractControl* c in menuEntities)
				{
					[c updateWithDelta:aDelta];	
				}
				
				for (MenuControl *control in menuEntities) 
				{
					if([control state] == kControl_Selected) 
					{
						[control setState:kControl_Idle];
						sceneState = kSceneState_TransitionOut;
						sceneAlpha = 1.0f;

						switch ([control type]) {
							case kControlType_Resume:
								[_director resumeGame];
								nextSceneKey = @"game";
								break;
							case kControlType_NewGame:
								/*[_director newGame];
								nextSceneKey = @"WeaponShop";*/
								[_director newGame];
							if(!START_SHOP)[_stats setQuickPlay:YES];
								nextSceneKey = @"WeaponShop";
								break;
							case kControlType_HighScores:
								[_stats readHighScores];
								nextSceneKey = @"HighScores";
								break;
							case kControlType_Tutorial:
								[_stats newGame];
								[_director newGame];
								[_director setTutorialMode:YES];
								nextSceneKey = @"WeaponShop";
								break;
							case kControlType_Settings:
								nextSceneKey = @"settings";
								break;
							case kControlType_quickPlay:
								[_director newGame];
								[_stats setQuickPlay:YES];
								nextSceneKey = @"WeaponShop";
							break;
							default:
								break;
							
						}
					}
				}
			}
			break;
			
		case kSceneState_TransitionOut:
		{
			sceneAlpha -= _sceneFadeSpeed * aDelta;
           
			if(sceneAlpha <= 0)
			{
				sceneAlpha =0;
                // If the scene being transitioned to does not exist then transition
                // this scene back in
				if(![_director setCurrentSceneToSceneWithKey:nextSceneKey])
				{
                    sceneState = kSceneState_TransitionIn;
				}
				else
				{
					sceneState = kSceneState_TransitionIn;
					[self unloadImages];
				}
			}
			 [_director setGlobalAlpha:sceneAlpha];
			
		}break;
			
		case kSceneState_TransitionIn:

			// I'm not using the delta value here as the large map being loaded causes
            // the first delta to be passed in to be very big which takes the alpha
            // to over 1.0 immediately, so I've got a fixed delta for the fade in.
			if(sceneAlpha==0)
			{
				
				[self loadImages];	
			}
            sceneAlpha += _sceneFadeSpeed * 0.02f;
          
			if(sceneAlpha >= 1.0f) {
				sceneAlpha = 1.0f;
				sceneState = kSceneState_Running;
			}
			  [_director setGlobalAlpha:sceneAlpha];
			break;
		default:
			break;
	}

}


- (void)setSceneState:(uint)theState {
	sceneState = theState;
	if(sceneState == kSceneState_TransitionOut)
		sceneAlpha = 1.0f;
	if(sceneState == kSceneState_TransitionIn)
		sceneAlpha = 0.0f;
}

- (void)updateWithTouchLocationBegan:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView {
    UITouch *touch = [[event touchesForView:aView] anyObject];
	CGPoint location;
	location = touchToScene([touch locationInView:aView]);
    
	for(AbstractControl* c in menuEntities)
	{
		[c updateWithLocation:CGPointToVector2f(location)];
	}
	
}


- (void)updateWithMovedLocation:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView {
    UITouch *touch = [[event touchesForView:aView] anyObject];
	Vector2f location;
		location = CGPointToVector2f(touchToScene([touch locationInView:aView]));
    
	for(AbstractControl* c in menuEntities)
	{
		[c updateWithLocation:location];
	}
}




- (void)render {
	
	if(imagesLoaded)
	{		glEnableClientState(GL_VERTEX_ARRAY);
		glEnableClientState(GL_TEXTURE_COORD_ARRAY);
		
		//	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
		//	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
		
		// Enable Texture_2D
		glEnable(GL_TEXTURE_2D);
		
		// Enable blending as we want the transparent parts of the image to be transparent
		glEnable(GL_BLEND);
		
		// Setup how the images are to be blended when rendered.  The setup below is the most common
		// config and handles transparency in images
		glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
		
		
		[menuBackground renderAtPoint:CGPointMake(MAXW, 0) centerOfImage:NO];
		[menuEntities makeObjectsPerformSelector:@selector(render)];
		
		glDisableClientState(GL_TEXTURE_COORD_ARRAY);
		glDisableClientState(GL_VERTEX_ARRAY);
	}
}


@end

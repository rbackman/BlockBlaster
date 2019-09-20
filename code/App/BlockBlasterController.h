//
//  BlockBlasterController.h
//  BlockBlaster
//
//  Created by Robert Backman on 08/05/2009.
//  Copyright 2009 Robert Backman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
//#import "AccelerometerSimulation.h"
#import "Director.h"
#if SEARCH_ACTIVE
#import "SearchManager.h"
#endif
#import "ResourceManager.h"
#import "SoundManager.h"
#import "Image.h"
#import "SpriteSheet.h"
#import "AbstractScene.h"
#import "MenuScene.h"
#import "GameScene.h"
#import "SettingsScene.h"

//#import "GameOverScene.h"
#import "WeaponShopScene.h"
#import "StatisticsManager.h"
#import "HighScoreScene.h"

@class EAGLView;

@interface BlockBlasterController : UIView <UIAccelerometerDelegate> {
	/* State to define if OGL has been initialised or not */
	bool glInitialised;
	
	// Grab the bounds of the screen
	CGRect screenBounds;
	
	// Accelerometer fata
	UIAccelerationValue _accelerometer[3];
	
	// Shared game state
	Director *_director;
	
	// Shared resource manager
	ResourceManager *_resourceManager;
	
	// Shared sound manager
	SoundManager *_soundManager;
	
	SearchManager *_searchManager;
	
	StatisticsManager* _statManager;
}

- (id)init;
- (void)initOpenGL;
- (void)renderScene;
- (void)updateScene:(GLfloat)aDelta;
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView;
- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView;
- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView;

@end

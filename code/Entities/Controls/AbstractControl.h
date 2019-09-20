//
//  AbstractControl.h
//  BlockBlaster
//
//  Created by Robert Backman on 29/05/2009.
//  Copyright 2009 Robert Backman. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Common.h"


@class StatisticsManager;
@class SoundManager;
@class Director;
@class Image;
@class ResourceManager;

enum press_state
{
	BEGAN_PRESS,
	END_PRESS,
	MOVE_PRESS
};

enum {
	kControlType_Tutorial,
	kControlType_Resume,
	kControlType_NewGame,
	kControlType_Settings,
	kControlType_HighScores,
	kControlType_quickPlay,
	kControlType_QuitGame,
	kControlType_PauseGame,
	kControl_Idle,
	kControl_Scaling,
	kControl_Selected,
	kGameState_Running,
	kGameState_Paused,
	kGameState_Loading,
	kSceneState_Idle,
	kSceneState_TransitionIn,
	kSceneState_TransitionOut,
	kSceneState_Running,
	kSceneState_Paused
};
@interface AbstractControl : NSObject 
{

	// Shared game state
	Director			*_director;
	SoundManager		*_soundManager;
	StatisticsManager	*_stats;
	ResourceManager *_ResourceManager;
	// Image for the control
	Image *image;
	// Location at which the control item should be rendered
	Vector2f location;
	// Should the image be rendered based on its center
	bool centered;
	// State of the control entity
	GLuint state;
	// Control Type
	uint type;
	// Control scale
	GLfloat scale;
	// Alpha
	GLfloat alpha;
	
	bool firstThrough;
	Rec controlBounds;
	Vector2f boundsSize;
	Vector2f boundsOffset;
}

@property(nonatomic, readonly) Vector2f boundsSize;
@property(nonatomic, readonly) Vector2f boundsOffset;
@property (nonatomic, retain) Image *image;
@property (nonatomic, assign) Vector2f location;
@property (nonatomic, assign) bool centered;
@property (nonatomic, assign) GLuint state;
@property (nonatomic, readonly) uint type;
@property (nonatomic, assign) GLfloat scale;
@property (nonatomic, assign) GLfloat alpha;

-(void)setBounds:(Vector2f)bnds offset:(Vector2f)ofst;
- (bool)updateWithLocation:(Vector2f)theTouchLocation;
- (void)updateWithDelta:(float)theDelta;
- (void)render;
-(void)drawBounds;
@end

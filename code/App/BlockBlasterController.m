//
//  BlockBlasterController.m
//  BlockBlaster
//
//  Created by Robert Backman on 08/05/2009.
//  Copyright 2009 Robert Backman. All rights reserved.
//

#import "BlockBlasterController.h"
#import "Common.h"
#import "EAGLView.h"

@interface BlockBlasterController (Private)

@end

@implementation BlockBlasterController

#pragma mark - 
#pragma mark Dealloc

- (void)dealloc {
	[_soundManager shutdownSoundManager];
	[_director dealloc];
	[_resourceManager dealloc];
    [super dealloc];
}

#pragma mark -
#pragma mark Initialize the game



- (id)init {
	
	if(self == [super init]) {	
		// Get the shared instance from the SingletonGameState class.  This will provide us with a static
		// class that can track game and OpenGL state
		_director = [Director sharedDirector];
		_resourceManager = [ResourceManager sharedResourceManager];
		_soundManager = [SoundManager sharedSoundManager];
		//_searchManager = [SearchManager sharedSearchManager];
		
		
		//[_searchManager init];
		
				// Initialize OpenGL
		[self initOpenGL];
		
		// Initialize the game states and add them to the Director class
		AbstractScene *scene = [[MenuScene alloc] init];
		[_director addSceneWithKey:@"menu" scene:scene];
        [scene release];
		
		scene = [[GameScene alloc] init];
		[_director addSceneWithKey:@"game" scene:scene];
		[scene release];
	

		
		
		
	 scene = [[SettingsScene alloc] init];
		[_director addSceneWithKey:@"settings" scene:scene];
		[scene release];
	/*
	 scene = [[ParticleScene alloc] init];
		[_director addSceneWithKey:@"particleFun" scene:scene];
		[scene release];
	 */
		/*
		scene = [[GameOverScene alloc] init];
		[_director addSceneWithKey:@"gameover" scene:scene];
		[scene release];*/
		
		scene = [[HighScoreScene alloc] init];
		[_director addSceneWithKey:@"HighScores" scene:scene];
		[scene release];
		
		// Make sure glInitialised is set to NO so that OpenGL gets initialised when the first scene is rendered
		glInitialised = NO;

		// Set the initial game state
		//[_director setCurrentSceneToSceneWithKey:@"HighScores"];
		//[[_director _scoreScene] takeInput];
		//[_director setCurrentSceneToSceneWithKey:@"WeaponShop"];
		[_director setCurrentSceneToSceneWithKey:@"menu"];
		//[_director setCurrentSceneToSceneWithKey:@"game"];

		[[_director currentScene] setSceneState:kSceneState_TransitionIn];
		
		
		
	
		
		
	}
	return self;
}




#pragma mark -
#pragma mark Initialize OpenGL settings

- (void)initOpenGL {
//	7072674296
	screenBounds = [[UIScreen mainScreen] bounds];
	
	// Switch to GL_PROJECTION matrix mode and reset the current matrix with the identity matrix
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
	
	// Rotate the entire view 90 degrees to the left to handle the phone being in landscape mode
if( LANDSCAPE_MODE	)
{
		glRotatef(-90.0f, 0, 0, 1);
	
		// Setup Ortho for the current matrix mode.  This describes a transformation that is applied to
		// the projection.  For our needs we are defining the fact that 1 pixel on the screen is equal to
		// one OGL unit by defining the horizontal and vertical clipping planes to be from 0 to the views
		// dimensions.  The far clipping plane is set to -1 and the near to 1.  The height and width have
		// been swapped to handle the phone being in landscape mode
		glOrthof(0, screenBounds.size.height, 0, screenBounds.size.width, -50, 50);
		//glTranslatef(0, -80, 0);
}else{
		glOrthof(0, screenBounds.size.width, 0, screenBounds.size.height, -50, 50);
}
	
	
	// Switch to GL_MODELVIEW so we can now draw our objects
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
	
	// Setup how textures should be rendered i.e. how a texture with alpha should be rendered ontop of
	// another texture.
	glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_BLEND_SRC);
	
	// We are not using the depth buffer in our 2D game so depth testing can be disabled.  If depth
	// testing was required then a depth buffer would need to be created as well as enabling the depth
	// test
	//glDisable(GL_DEPTH_TEST);
	
	// Set the colour to use when clearing the screen with glClear
	glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
	
	// Mark OGL as initialised
	glInitialised = YES;
}


#pragma mark -
#pragma mark Update the game scene logic

- (void)updateScene:(GLfloat)aDelta {
	
	// Update the games logic based for the current scene
	[[_director currentScene] updateWithDelta:aDelta];

}


#pragma mark -
#pragma mark Render the scene

- (void)renderScene {


	// Define the viewport.  Changing the settings for the viewport can allow you to scale the viewport
	// as well as the dimensions etc and so I'm setting it for each frame in case we want to change it
#ifdef LANDSCAPE_MODE
        glViewport(0, 0, screenBounds.size.width, screenBounds.size.height );
#else
        glViewport(0, 0, screenBounds.size.width , screenBounds.size.height);
#endif
	
	// Clear the screen
	glClear(GL_COLOR_BUFFER_BIT);
	
	[[_director currentScene] render];
}

#pragma mark -
#pragma mark Touches

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView {
	[[_director currentScene] updateWithTouchLocationBegan:touches withEvent:event view:aView];
}

- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView {
	[[_director currentScene] updateWithTouchLocationMoved:touches withEvent:event view:aView];

}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView {
	[[_director currentScene] updateWithTouchLocationEnded:touches withEvent:event view:aView];
}

#pragma mark -
#pragma mark Accelerometer

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)_accel {
    [[_director currentScene] updateWithAccelerometer:_accel];
}

@end

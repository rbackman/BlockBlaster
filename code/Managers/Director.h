//
//  Director.h
//  BlockBlaster
//
//  Created by Robert Backman on 03/05/2009.
//  Copyright 2009 Robert Backman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES1/gl.h>
#import "SynthesizeSingleton.h"
#import "Common.h"
#import "BlockBlasterAppDelegate.h"


@class AbstractScene;
@class SpriteSheet;
@class StatisticsManager;
@class GameScene;
@class WeaponShopScene;
@class HighScoreScene;

@interface Director : NSObject {
	
	// Currently bound texture name
	GLuint currentlyBoundTexture;
	// Current game state
	GLuint currentGameState;
	// Current scene
	AbstractScene *currentScene;
	// Dictionary of scenes
	NSMutableDictionary *_scenes;
	// Global alpha
	GLfloat globalAlpha;
    // Frames Per Second
    float framesPerSecond;

	bool tutorialMode;
	bool showBounds;
	
	StatisticsManager* _statManager;
	GameScene* _gameScene;
	WeaponShopScene* _shopScene;
	BlockBlasterAppDelegate* delegate;
	HighScoreScene* _scoreScene;

}

@property (nonatomic, readonly)	HighScoreScene* _scoreScene;
@property (nonatomic, readonly) GameScene* _gameScene;
@property (nonatomic, readonly)  WeaponShopScene* _shopScene;
@property (nonatomic, readonly) StatisticsManager* _statManager;
@property (nonatomic, readwrite)bool showBounds;
@property (nonatomic, readwrite)bool tutorialMode;
@property (nonatomic, assign) GLuint currentlyBoundTexture;
@property (nonatomic, assign) GLuint currentGameState;
@property (nonatomic, retain) AbstractScene *currentScene;
@property (nonatomic, assign) GLfloat globalAlpha;
@property (nonatomic, assign) float framesPerSecond;



+ (Director*)sharedDirector;

-(void)setDelegate:(BlockBlasterAppDelegate*)del;
-(void)addTextField:(UITextField*)textField;

-(void)newGame;
-(void)saveGameState;
-(void)resumeGame;

- (void)addSceneWithKey:(NSString*)aSceneKey scene:(AbstractScene*)aScene;
- (bool)setCurrentSceneToSceneWithKey:(NSString*)aSceneKey;
- (bool)transitionToSceneWithKey:(NSString*)aSceneKey;

@end

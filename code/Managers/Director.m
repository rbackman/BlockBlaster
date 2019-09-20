//
//  Director.m
//  BlockBlaster
//
//  Created by Robert Backman on 03/05/2009.
//  Copyright 2009 Robert Backman. All rights reserved.
//

#import "Director.h"
#import "AbstractScene.h"
#import "SpriteSheet.h"
#import "GameScene.h"
#import "WeaponShopScene.h"
#import "HighScoreScene.h"

@implementation Director
@synthesize showBounds;
@synthesize currentlyBoundTexture;
@synthesize currentGameState;
@synthesize currentScene;
@synthesize globalAlpha;
@synthesize framesPerSecond;
@synthesize _gameScene;
@synthesize _shopScene;
@synthesize _statManager;
@synthesize _scoreScene;

@synthesize tutorialMode;
// Make this class a singleton class
SYNTHESIZE_SINGLETON_FOR_CLASS(Director);


- (id)init {
	// Initialize the arrays to be used within the state manager
	_scenes = [[NSMutableDictionary alloc] init];
	currentScene = nil;
	globalAlpha = 1.0f;
	tutorialMode = NO;
	showBounds = SHOW_BOUNDS;
	_statManager= nil;
	_gameScene = nil;
	_shopScene = nil;
		_statManager  = [[StatisticsManager alloc] init];


	
	return self;
}
-(void)saveGameState
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *gameStatePath = [documentsDirectory stringByAppendingPathComponent:@"gameState.dat"];
	
	// Set up the encoder and storage for the game state data
	NSMutableData *gameData;
	NSKeyedArchiver *encoder;
	gameData = [NSMutableData data];
	encoder = [[NSKeyedArchiver alloc] initForWritingWithMutableData:gameData];
	
	// Archive our object
	[encoder encodeObject:_statManager forKey:@"statmanager"];
	[encoder encodeObject:_gameScene forKey:@"gameScene"];
	
	// Finish encoding and write to the gameState.dat file
	[encoder finishEncoding];
	[gameData writeToFile:gameStatePath atomically:YES];
	[encoder release];	
}
-(void)setDelegate:(BlockBlasterAppDelegate*)del
{
	delegate = del;	
}
-(void)addTextField:(UITextField*)textField
{
	[delegate addTextField:textField];	
}

-(void)newGame
{
	if(_gameScene)
	{
		[_scenes removeObjectForKey:@"game"];
		[_gameScene release];
	}
	
	if(_statManager)
		[_statManager release];
	
	if(!_shopScene)
	{
		_shopScene = [[WeaponShopScene alloc] init];
		[_scenes setObject:_shopScene forKey:@"WeaponShop"];
	}

	_statManager  = [[StatisticsManager alloc] init];
		
	_gameScene = [[GameScene alloc] init];
	[_scenes setObject:_gameScene forKey:@"game"];
	printf("new game\n");
	
	
}
-(void)resumeGame
{

		if(_statManager)
		{
			[_statManager release];
			_statManager = nil;
		}
		if(_gameScene)
		{
			[_scenes removeObjectForKey:@"game"];
			[_gameScene release];
			_gameScene = nil;
		}
	if(!_shopScene)
	{
		_shopScene = [[WeaponShopScene alloc] init];
		[_scenes setObject:_shopScene forKey:@"WeaponShop"];
	}
	
		// Check to see if there is a gameState.dat file.  If there is then load the contents
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		
		NSMutableData *gameData;
		NSKeyedUnarchiver *decoder;
		
		// Check to see if the ghosts.dat file exists and if so load the contents into the
		// entities array
		NSString *documentPath = [documentsDirectory stringByAppendingPathComponent:@"gameState.dat"];
		gameData = [NSData dataWithContentsOfFile:documentPath];
		
		if (gameData) 
		{
			decoder = [[NSKeyedUnarchiver alloc] initForReadingWithData:gameData];
			
			
			// Set the local instance of myObject to the object held in the gameState file with the key "myObject"
			
			_statManager = [[decoder decodeObjectForKey:@"statmanager"]retain]; 
			
			
			_gameScene = [[decoder decodeObjectForKey:@"gameScene"] retain];
			[_scenes removeObjectForKey:@"game"];
			[_scenes setObject:_gameScene forKey:@"game"];
			
						
			// We have finishd decoding the objects and retained them so we can now release the
			// decoder object
			[decoder release];
		}
		else 
		{
			[self newGame];
						
		}
		

}

- (void)addSceneWithKey:(NSString*)aSceneKey scene:(AbstractScene*)aScene
{
	if(aSceneKey==@"HighScores")
		_scoreScene = (HighScoreScene*)aScene;
	
	[_scenes setObject:aScene forKey:aSceneKey];
}


- (bool)setCurrentSceneToSceneWithKey:(NSString*)aSceneKey {
	if(![_scenes objectForKey:aSceneKey]) {
		if(DEBUG) NSLog(@"ERROR: Scene with key '%@' not found.", aSceneKey);
        return NO;
    }
	
    currentScene = [_scenes objectForKey:aSceneKey];
	[currentScene setSceneAlpha:0.0f];
	[currentScene setSceneState:kSceneState_TransitionIn];
    
    return YES;
}


- (bool)transitionToSceneWithKey:(NSString*)aSceneKey {

	// If the scene key exists then tell the current scene to transition to that
    // scene and return YES
    if([_scenes objectForKey:aSceneKey]) {
        [currentScene transitionToSceneWithKey:aSceneKey];
        return YES;
    }
    
    // If the scene does not exist then return NO;
    return NO;
}


- (void)dealloc {
	[_scenes release];
	[super dealloc];
}

@end

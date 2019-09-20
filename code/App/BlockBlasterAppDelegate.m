//
//  Tutorial1AppDelegate.m
//  Tutorial1
//
//  Created by Robert Backman on 28/02/2009.
//  Copyright Robert Backman 2009. All rights reserved.
//

#import "BlockBlasterAppDelegate.h"
#import "EAGLView.h"
#import "Director.h"

@implementation BlockBlasterAppDelegate


-(void)addTextField:(UITextField*)textField
{
	[window addSubview:textField];	
}


- (void)applicationDidFinishLaunching:(UIApplication *)application {
	
	director = [Director sharedDirector];
	[director setDelegate:self];
	// Not using any NIB files anymore, we are creating the window and the
    // EAGLView manually.
    window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	[window setUserInteractionEnabled:YES];
	[window setMultipleTouchEnabled:YES];
	
		
	glView = [[[EAGLView alloc] initWithFrame:[UIScreen mainScreen].bounds] retain];
	
    // Add the glView to the window which has been defined
	[window addSubview:glView];
	[window makeKeyAndVisible];
    
	// Since OS 3.0, just calling [glView mainGameLoop] did not work, you just got a black screen.
    // It appears that others have had the same problem and to fix it you need to use the 
    // performSelectorOnMainThread call below.
    [glView performSelectorOnMainThread:@selector(mainGameLoop) withObject:nil waitUntilDone:NO]; 

}


- (void)applicationWillTerminate:(UIApplication *)application {
	// Set up the game state path to the data file that the game state will be saved too. 
	[director saveGameState];
	
}

/*- (void)saveScore {

	NSString*			name = @"Rob";
	NSDate*				date = [NSDate date];
		
	//Dismiss text field
	[_textField endEditing:YES];
	[_textField removeFromSuperview];
	
	//Make sure a player name exists, if only the default
	if(![name length])
		name = @"Player";
	
	
	[scores addObject:[NSDictionary dictionaryWithObjectsAndKeys:name, @"name", [NSNumber numberWithUnsignedInt:_score], @"score", date, @"date", nil]];
	[scores sortUsingDescriptors:[NSArray arrayWithObject:[[[NSSortDescriptor alloc] initWithKey:@"score" ascending:NO] autorelease]]];
	[defaults setObject:scores forKey:kHighScoresDefaultKey];
	
	//Display high-scores in status texture
	string = [NSMutableString stringWithString:@"       HIGH-SCORES\n"];
	for(i = 0; i < MIN([scores count], 10); ++i) {
		dictionary = [scores objectAtIndex:i];
	}

	[_statusTexture release];
	_statusTexture = [[Texture2D alloc] initWithString:string dimensions:CGSizeMake(256, 256) alignment:UITextAlignmentLeft fontName:kFontName fontSize:kScoreFontSize];
	_state = kState_StandBy;
	
	//Render a frame
	[self renderScene];
}*/


- (void)applicationDidBecomeActive:(UIApplication *)application {

}


- (void)dealloc {
	[window release];
	[glView release];

	[super dealloc];
}

@end

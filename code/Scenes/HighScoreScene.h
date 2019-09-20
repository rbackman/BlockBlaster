//
//  SettingsScene.h
//  Tutorial1
//
//  Created by Robert Backman on 07/06/2009.
//  Copyright 2009 Robert Backman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractScene.h"

@class MenuControl;
#define kFontName					@"Arial"
#define kStatusFontSize				48

@interface HighScoreScene : AbstractScene<UITextFieldDelegate> {
	
	MenuControl* exitControl;
	UITextField*			_textField;
	NSString* player_name;
	NSString* NewHighScore;
	bool inputMode;
}

-(void)takeInput;

@end

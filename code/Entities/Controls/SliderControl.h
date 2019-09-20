//
//  MenuControl.h
//  BlockBlaster
//
//  Created by Robert Backman on 21/05/2009.
//  Copyright 2009 Robert Backman. All rights reserved.
//
// This class controls the appearance and state of menu options.  It takes an image
// which represents the menu option itself and is resposible for both the logic and
// rendering of the item

#import <Foundation/Foundation.h>
#import "AbstractControl.h"

#import "Common.h"

@class AngelCodeFont;

@interface SliderControl : AbstractControl {
	NSString* name;
	NSString* value;
	int maxValue;
	int minValue;
	float maxOutput;
	float minOutput;
	float output;
	bool intMode;
	float curValue;
	Image* slider;
	Rec bounds;
	bool activated;
}

-(id)initWithLocation:(Vector2f)theLocation name:(NSString*)nm min:(float)min max:(float)max start:(float)st;
- (bool)updateWithLocation:(Vector2f)touchPoint press:(int)prs ;
- (void)updateWithDelta:(float)theDelta;
- (void)render;

@property(nonatomic,readwrite) bool intMode;
@property(nonatomic,readonly) float output;



@end

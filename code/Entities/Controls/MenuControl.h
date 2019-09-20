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
#import "Image.h"
#import "Common.h"
#import "SpriteSheet.h"

@interface MenuControl : AbstractControl {
	float scaleSpeed;
	float alphaSpeed;
	float maxScale;
	bool scaleDown;
	float minScale;

}

- (id)initWithImageNamed:(NSString*)theImageName location:(Vector2f)theLocation centerOfImage:(bool)theCenter type:(uint)theType;
-(id)initWithImage:(Image*)im location:(Vector2f)theLocation centerOfImage:(bool)theCenter type:(uint)theType;
-(id)initWithImageSpriteSheet:(uint)x y:(uint)y w:(uint)w h:(uint)h ss:(SpriteSheet*)ss location:(Vector2f)theLocation centerOfImage:(bool)theCenter type:(uint)theType;
- (bool)updateWithLocation:(Vector2f)theTouchLocation;
- (void)updateWithDelta:(float)theDelta;
- (void)render;
-(bool)selected;
-(void)deselect;
-(void)updateBounds;
@property(nonatomic,assign) float scaleSpeed;
@property(nonatomic,assign) float alphaSpeed;
@property(nonatomic,assign) float maxScale;


@end

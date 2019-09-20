//
//  Animation.h
//  BlockBlaster
//
//  Created by Robert Backman on 06/03/2009.
//  Copyright 2009 Robert Backman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SpriteSheet.h"
#import "Frame.h"

enum {
	kDirection_Forward = 1,
	kDirection_Backwards = -1
};

@interface Animation : NSObject {
	
	// Frames to be used within this animation
	NSMutableArray *frames;
	// Accumulates the time while a frame is displayed
	float frameTimer;
	// Holds the animation running state
	bool running;
	// Repeat the animation
	bool repeat;
	// Should the animation ping pong backwards and forwards
	bool pingPong;
	// Direction in which the animation is running
	int direction;
	// The current frame of animation
	int currentFrame;
	//ceners animation at point
	bool centered;
	
	float scale;
}

@property(nonatomic)bool repeat;
@property(nonatomic)bool pingPong;
@property(nonatomic)bool running;
@property(nonatomic)int currentFrame;
@property(nonatomic)int direction;
@property(nonatomic)float scale;

-(void)stepOneFrame;
- (void)addFrameWithImage:(Image*)image delay:(float)delay imageScale:(float)sz;
- (void)update:(float)delta;
- (void)renderAtPoint:(CGPoint)point;
- (void)renderAtPointAndAngle:(CGPoint)point Angle:(float)ang imageScale:(int)sz;
- (Image*)getCurrentFrameImage;
- (GLuint)getAnimationFrameCount;
- (GLuint)getCurrentFrameNumber;
- (Frame*)getFrame:(GLuint)frameNumber;
- (void)flipAnimationVertically:(bool)flipVertically horizontally:(bool)flipHorizontally;

@end

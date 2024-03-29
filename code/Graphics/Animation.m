//
//  Animation.m
//  BlockBlaster
//
//  Created by Robert Backman on 06/03/2009.
//  Copyright 2009 Robert Backman. All rights reserved.
//

#import "Animation.h"


@implementation Animation

@synthesize running;
@synthesize currentFrame;
@synthesize direction;
@synthesize repeat;
@synthesize pingPong;
@synthesize scale;

- (id)init {
	self = [super init];
	if(self != nil) {
		// Initialize the array which will hold our frames
		frames = [[NSMutableArray alloc] init];
		
		// Set the default values for important properties
		currentFrame = 0;
		frameTimer = 0;
		running = NO;
		repeat = NO;
		pingPong = NO;
		direction = kDirection_Forward;
		centered = YES;
		scale = 1.0f;
	}
	return self;
}

-(void)stepOneFrame
{
	if(currentFrame<[frames count]-1)
	{
		currentFrame++;	
	}
}
- (void)addFrameWithImage:(Image*)image delay:(float)delay imageScale:(float)sz {
	
	scale = sz;
	// Create a new frame instance which will hold the frame image and delay for that image
	Frame *frame = [[Frame alloc] initWithImage:image delay:delay];
	
	// Add the frame to the array of frames in this animation
	[frames addObject:frame];
	
	// Release the frame instance created as having added it to the array will have put its
	// retain count up to 2 so the object we need will not be released until we are finished
	// with it
	[frame release];
	
}


- (void)update:(float)delta {
	// If the animation is not running then don't do anything
	if(!running) return;
	
	// Update the timer with the delta
	frameTimer += delta;

	// If the timer has exceed the delay for the current frame, move to the next frame.  If we are at
	// the end of the animation, check to see if we should repeat, pingpong or stop
	if(frameTimer > [[frames objectAtIndex:currentFrame] frameDelay]) {
		currentFrame += direction;
		frameTimer = 0;
		if(currentFrame > [frames count]-1 || currentFrame < 0) {
			
			// The following code was provided by akucsai (Antal) on the 71Squared blog
			if(!pingPong) {
				if(repeat)
					// If we should repeat without ping pong then just reset the current frame to 0 and carry on
					currentFrame = 0;
				else  {
					// If we are not repeating and no pingPing then set the current frame to 0 and stop the animation
					running = NO;
					currentFrame = 0;
				}
			} else {
				// If we are ping ponging then change the direction and move the current frame to the
				// next frame based on the direction
				direction = -direction;
				currentFrame += direction;
			}
		}
	}
}


- (Image*)getCurrentFrameImage {
	// Return the image which is being used for the current frame
	return [[frames objectAtIndex:currentFrame] frameImage];
}


- (GLuint)getAnimationFrameCount {
	// Return the total number of frames in this animation
	return [frames count];
}


- (GLuint)getCurrentFrameNumber {
	// Return the current frame within this animation
	return currentFrame;
}


- (Frame*)getFrame:(GLuint)frameNumber {
	
	// If a frame number is reuqested outside the range that exists, return nil
	// and log an error
	if(frameNumber > [frames count]) {
		if(DEBUG) NSLog(@"WARNING: Requested frame '%d' is out of bounds", frameNumber);
		return nil;
	}
	
	// Return the frame for the requested index
	return [frames objectAtIndex:frameNumber];
}


- (void)flipAnimationVertically:(bool)flipVertically horizontally:(bool)flipHorizontally {
	for(int index=0; index < [frames count]; index++) {
		[[[frames objectAtIndex:index] frameImage] setFlipVertically:flipVertically];
		[[[frames objectAtIndex:index] frameImage] setFlipHorizontally:flipHorizontally];
	}
}

- (void)renderAtPoint:(CGPoint)point {

	// Get the current frame for this animation
	Frame *frame = [frames objectAtIndex:currentFrame];
	
	[[frame frameImage] setScale:scale];
	
	// Take the image for this frame and render it at the point provided, but default
	// animations are rendered with their centre at the point provided
			
	[[frame frameImage] renderAtPoint:point centerOfImage:centered];
}
- (void)renderAtPointAndAngle:(CGPoint)point Angle:(float)ang imageScale:(int)sz
{
	
	// Get the current frame for this animation
	Frame *frame = [frames objectAtIndex:currentFrame];
	
	[[frame frameImage] setScale:scale];
	[[frame frameImage] setRotation:ang];
	// Take the image for this frame and render it at the point provided, but default
	// animations are rendered with their centre at the point provided
	
	[[frame frameImage] renderAtPoint:point centerOfImage:centered];
	
	
}

- (void)dealloc {
	
	[frames release];
	[super dealloc];
}
@end

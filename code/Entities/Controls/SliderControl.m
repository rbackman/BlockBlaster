//
//  MenuControl.m
//  BlockBlaster
//
//  Created by Robert Backman on 21/05/2009.
//  Copyright 2009 Robert Backman. All rights reserved.
//

#import "SliderControl.h"
#import "Image.h"
#import "SpriteSheet.h"
#import "DrawingPrimitives.h"
#import "AngelCodeFont.h"

@implementation SliderControl


@synthesize output;
@synthesize intMode;

- (void) dealloc
{
	[name release];
	[value release];
	[image release];
	[slider release];
	[super dealloc];
}

-(id)initWithLocation:(Vector2f)theLocation name:(NSString*)nm min:(float)min max:(float)max start:(float)st
{
	self = [super init];
	if (self != nil) 
	{
		maxValue = 380;
		minValue = 100;
		maxOutput = max;
		minOutput = min;
		
		curValue = minValue + ((st - minOutput)*(maxValue-minValue)/(maxOutput-minOutput));
		output = st;
		//curValue = (maxValue - minValue)/2;
		
	name = nm;
	image = [[Image alloc] initWithImage:@"slider.png"];
	[image setScaleV:Vector2fMake(10, 0.5)];
	slider = [[Image alloc] initWithImage:@"sliderBall.png"];
	location = theLocation;	


	bounds = makeRec(location , ([image imageWidth]*[image scale]),([image imageHeight]*[image scale]),0,0);
	}
	return self;
}


- (bool)updateWithLocation:(Vector2f)touchPoint press:(int)prs {
	bool ret = NO;
	switch (prs) {
		case BEGAN_PRESS:
			bounds = makeRec(Vector2fMake( curValue , location.y) , 64 , 64  ,0,0 );
			if(ptInRec(touchPoint, bounds) )
			{
				curValue = touchPoint.x;
				activated=YES;
				ret = YES;
			}
			else
			{
				ret = NO;
				activated = NO;
			}
			break;
		case MOVE_PRESS:
			{
				if(activated)	
				{
					curValue = touchPoint.x;
					ret = YES;
				}
			}break;
		case END_PRESS:
			bounds = makeRec(Vector2fMake( curValue , location.y) , 64 , 64  ,0,0 );
			if(ptInRec(touchPoint, bounds) )
			{
				curValue = touchPoint.x;
				activated=NO;
				ret = YES;
			}
			break;
		default:
			break;
	}
	
	if(curValue>maxValue)curValue = maxValue;
	if(curValue<minValue)curValue = minValue;
	
	output = minOutput +  (maxOutput-minOutput) * ((curValue - minValue)/(maxValue-minValue) ) ;
	if(intMode)output = (int)(0.5+output);
	else
	{
		output = ((float)((int)(output * 1000)))/1000;
	}
	
	return ret;
}

- (void)updateWithDelta:(float)theDelta 
{
	if(firstThrough)
	{
		[super updateWithDelta:theDelta];
	}
}






- (void)render {

	[[_ResourceManager _font32] drawStringAt:CGPointMake(location.x - 200 , location.y + 64) text:[NSString stringWithFormat:@"%@:%g",name,output]];
	
	[image renderAtPoint:CGPointMake(location.x, location.y) centerOfImage:YES];	
	[slider renderAtPoint:CGPointMake(curValue,location.y) centerOfImage:YES];

	if(SHOW_BOUNDS)[super drawBounds];
}

@end
